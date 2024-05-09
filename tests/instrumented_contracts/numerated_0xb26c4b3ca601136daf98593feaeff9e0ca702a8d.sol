1 pragma solidity 0.6.12;
2 
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address payable) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes memory) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Interface of the ERC20 standard as defined in the EIP.
27  */
28 interface IERC20 {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `sender` to `recipient` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 /**
100  * @dev Wrappers over Solidity's arithmetic operations with added overflow
101  * checks.
102  *
103  * Arithmetic operations in Solidity wrap on overflow. This can easily result
104  * in bugs, because programmers usually assume that an overflow raises an
105  * error, which is the standard behavior in high level programming languages.
106  * `SafeMath` restores this intuition by reverting the transaction when an
107  * operation overflows.
108  *
109  * Using this library instead of the unchecked operations eliminates an entire
110  * class of bugs, so it's recommended to use it always.
111  */
112 library SafeMath {
113     /**
114      * @dev Returns the addition of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `+` operator.
118      *
119      * Requirements:
120      *
121      * - Addition cannot overflow.
122      */
123     function add(uint256 a, uint256 b) internal pure returns (uint256) {
124         uint256 c = a + b;
125         require(c >= a, "SafeMath: addition overflow");
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting on
132      * overflow (when the result is negative).
133      *
134      * Counterpart to Solidity's `-` operator.
135      *
136      * Requirements:
137      *
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141         return sub(a, b, "SafeMath: subtraction overflow");
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      *
152      * - Subtraction cannot overflow.
153      */
154     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b <= a, errorMessage);
156         uint256 c = a - b;
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the multiplication of two unsigned integers, reverting on
163      * overflow.
164      *
165      * Counterpart to Solidity's `*` operator.
166      *
167      * Requirements:
168      *
169      * - Multiplication cannot overflow.
170      */
171     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
172         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
173         // benefit is lost if 'b' is also tested.
174         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
175         if (a == 0) {
176             return 0;
177         }
178 
179         uint256 c = a * b;
180         require(c / a == b, "SafeMath: multiplication overflow");
181 
182         return c;
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers. Reverts on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `/` operator. Note: this function uses a
190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
191      * uses an invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function div(uint256 a, uint256 b) internal pure returns (uint256) {
198         return div(a, b, "SafeMath: division by zero");
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
203      * division by zero. The result is rounded towards zero.
204      *
205      * Counterpart to Solidity's `/` operator. Note: this function uses a
206      * `revert` opcode (which leaves remaining gas untouched) while Solidity
207      * uses an invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
214         require(b > 0, errorMessage);
215         uint256 c = a / b;
216         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
217 
218         return c;
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
234         return mod(a, b, "SafeMath: modulo by zero");
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts with custom message when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
250         require(b != 0, errorMessage);
251         return a % b;
252     }
253 }
254 
255 /**
256  * @dev Collection of functions related to the address type
257  */
258 library Address {
259     /**
260      * @dev Returns true if `account` is a contract.
261      *
262      * [IMPORTANT]
263      * ====
264      * It is unsafe to assume that an address for which this function returns
265      * false is an externally-owned account (EOA) and not a contract.
266      *
267      * Among others, `isContract` will return false for the following
268      * types of addresses:
269      *
270      *  - an externally-owned account
271      *  - a contract in construction
272      *  - an address where a contract will be created
273      *  - an address where a contract lived, but was destroyed
274      * ====
275      */
276     function isContract(address account) internal view returns (bool) {
277         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
278         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
279         // for accounts without code, i.e. `keccak256('')`
280         bytes32 codehash;
281         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
282         // solhint-disable-next-line no-inline-assembly
283         assembly { codehash := extcodehash(account) }
284         return (codehash != accountHash && codehash != 0x0);
285     }
286 
287     /**
288      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
289      * `recipient`, forwarding all available gas and reverting on errors.
290      *
291      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
292      * of certain opcodes, possibly making contracts go over the 2300 gas limit
293      * imposed by `transfer`, making them unable to receive funds via
294      * `transfer`. {sendValue} removes this limitation.
295      *
296      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
297      *
298      * IMPORTANT: because control is transferred to `recipient`, care must be
299      * taken to not create reentrancy vulnerabilities. Consider using
300      * {ReentrancyGuard} or the
301      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
302      */
303     function sendValue(address payable recipient, uint256 amount) internal {
304         require(address(this).balance >= amount, "Address: insufficient balance");
305 
306         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
307         (bool success, ) = recipient.call{ value: amount }("");
308         require(success, "Address: unable to send value, recipient may have reverted");
309     }
310 
311     /**
312      * @dev Performs a Solidity function call using a low level `call`. A
313      * plain`call` is an unsafe replacement for a function call: use this
314      * function instead.
315      *
316      * If `target` reverts with a revert reason, it is bubbled up by this
317      * function (like regular Solidity function calls).
318      *
319      * Returns the raw returned data. To convert to the expected return value,
320      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
321      *
322      * Requirements:
323      *
324      * - `target` must be a contract.
325      * - calling `target` with `data` must not revert.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
330       return functionCall(target, data, "Address: low-level call failed");
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
335      * `errorMessage` as a fallback revert reason when `target` reverts.
336      *
337      * _Available since v3.1._
338      */
339     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
340         return _functionCallWithValue(target, data, 0, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but also transferring `value` wei to `target`.
346      *
347      * Requirements:
348      *
349      * - the calling contract must have an ETH balance of at least `value`.
350      * - the called Solidity function must be `payable`.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
355         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
360      * with `errorMessage` as a fallback revert reason when `target` reverts.
361      *
362      * _Available since v3.1._
363      */
364     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
365         require(address(this).balance >= value, "Address: insufficient balance for call");
366         return _functionCallWithValue(target, data, value, errorMessage);
367     }
368 
369     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
370         require(isContract(target), "Address: call to non-contract");
371 
372         // solhint-disable-next-line avoid-low-level-calls
373         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
374         if (success) {
375             return returndata;
376         } else {
377             // Look for revert reason and bubble it up if present
378             if (returndata.length > 0) {
379                 // The easiest way to bubble the revert reason is using memory via assembly
380 
381                 // solhint-disable-next-line no-inline-assembly
382                 assembly {
383                     let returndata_size := mload(returndata)
384                     revert(add(32, returndata), returndata_size)
385                 }
386             } else {
387                 revert(errorMessage);
388             }
389         }
390     }
391 }
392 
393 /**
394  * @dev Implementation of the {IERC20} interface.
395  *
396  * This implementation is agnostic to the way tokens are created. This means
397  * that a supply mechanism has to be added in a derived contract using {_mint}.
398  * For a generic mechanism see {ERC20PresetMinterPauser}.
399  *
400  * TIP: For a detailed writeup see our guide
401  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
402  * to implement supply mechanisms].
403  *
404  * We have followed general OpenZeppelin guidelines: functions revert instead
405  * of returning `false` on failure. This behavior is nonetheless conventional
406  * and does not conflict with the expectations of ERC20 applications.
407  *
408  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
409  * This allows applications to reconstruct the allowance for all accounts just
410  * by listening to said events. Other implementations of the EIP may not emit
411  * these events, as it isn't required by the specification.
412  *
413  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
414  * functions have been added to mitigate the well-known issues around setting
415  * allowances. See {IERC20-approve}.
416  */
417 contract ERC20 is Context, IERC20 {
418     using SafeMath for uint256;
419     using Address for address;
420 
421     mapping (address => uint256) private _balances;
422 
423     mapping (address => mapping (address => uint256)) private _allowances;
424 
425     uint256 private _totalSupply;
426 
427     string private _name;
428     string private _symbol;
429     uint8 private _decimals;
430 
431     /**
432      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
433      * a default value of 18.
434      *
435      * To select a different value for {decimals}, use {_setupDecimals}.
436      *
437      * All three of these values are immutable: they can only be set once during
438      * construction.
439      */
440     constructor (string memory name, string memory symbol) public {
441         _name = name;
442         _symbol = symbol;
443         _decimals = 18;
444     }
445 
446     /**
447      * @dev Returns the name of the token.
448      */
449     function name() public view returns (string memory) {
450         return _name;
451     }
452 
453     /**
454      * @dev Returns the symbol of the token, usually a shorter version of the
455      * name.
456      */
457     function symbol() public view returns (string memory) {
458         return _symbol;
459     }
460 
461     /**
462      * @dev Returns the number of decimals used to get its user representation.
463      * For example, if `decimals` equals `2`, a balance of `505` tokens should
464      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
465      *
466      * Tokens usually opt for a value of 18, imitating the relationship between
467      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
468      * called.
469      *
470      * NOTE: This information is only used for _display_ purposes: it in
471      * no way affects any of the arithmetic of the contract, including
472      * {IERC20-balanceOf} and {IERC20-transfer}.
473      */
474     function decimals() public view returns (uint8) {
475         return _decimals;
476     }
477 
478     /**
479      * @dev See {IERC20-totalSupply}.
480      */
481     function totalSupply() public view override returns (uint256) {
482         return _totalSupply;
483     }
484 
485     /**
486      * @dev See {IERC20-balanceOf}.
487      */
488     function balanceOf(address account) public view override returns (uint256) {
489         return _balances[account];
490     }
491 
492     /**
493      * @dev See {IERC20-transfer}.
494      *
495      * Requirements:
496      *
497      * - `recipient` cannot be the zero address.
498      * - the caller must have a balance of at least `amount`.
499      */
500     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
501         _transfer(_msgSender(), recipient, amount);
502         return true;
503     }
504 
505     /**
506      * @dev See {IERC20-allowance}.
507      */
508     function allowance(address owner, address spender) public view virtual override returns (uint256) {
509         return _allowances[owner][spender];
510     }
511 
512     /**
513      * @dev See {IERC20-approve}.
514      *
515      * Requirements:
516      *
517      * - `spender` cannot be the zero address.
518      */
519     function approve(address spender, uint256 amount) public virtual override returns (bool) {
520         _approve(_msgSender(), spender, amount);
521         return true;
522     }
523 
524     /**
525      * @dev See {IERC20-transferFrom}.
526      *
527      * Emits an {Approval} event indicating the updated allowance. This is not
528      * required by the EIP. See the note at the beginning of {ERC20};
529      *
530      * Requirements:
531      * - `sender` and `recipient` cannot be the zero address.
532      * - `sender` must have a balance of at least `amount`.
533      * - the caller must have allowance for ``sender``'s tokens of at least
534      * `amount`.
535      */
536     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
537         _transfer(sender, recipient, amount);
538         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
539         return true;
540     }
541 
542     /**
543      * @dev Atomically increases the allowance granted to `spender` by the caller.
544      *
545      * This is an alternative to {approve} that can be used as a mitigation for
546      * problems described in {IERC20-approve}.
547      *
548      * Emits an {Approval} event indicating the updated allowance.
549      *
550      * Requirements:
551      *
552      * - `spender` cannot be the zero address.
553      */
554     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
555         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
556         return true;
557     }
558 
559     /**
560      * @dev Atomically decreases the allowance granted to `spender` by the caller.
561      *
562      * This is an alternative to {approve} that can be used as a mitigation for
563      * problems described in {IERC20-approve}.
564      *
565      * Emits an {Approval} event indicating the updated allowance.
566      *
567      * Requirements:
568      *
569      * - `spender` cannot be the zero address.
570      * - `spender` must have allowance for the caller of at least
571      * `subtractedValue`.
572      */
573     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
574         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
575         return true;
576     }
577 
578     /**
579      * @dev Moves tokens `amount` from `sender` to `recipient`.
580      *
581      * This is internal function is equivalent to {transfer}, and can be used to
582      * e.g. implement automatic token fees, slashing mechanisms, etc.
583      *
584      * Emits a {Transfer} event.
585      *
586      * Requirements:
587      *
588      * - `sender` cannot be the zero address.
589      * - `recipient` cannot be the zero address.
590      * - `sender` must have a balance of at least `amount`.
591      */
592     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
593         require(sender != address(0), "ERC20: transfer from the zero address");
594         require(recipient != address(0), "ERC20: transfer to the zero address");
595 
596         _beforeTokenTransfer(sender, recipient, amount);
597 
598         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
599         _balances[recipient] = _balances[recipient].add(amount);
600         emit Transfer(sender, recipient, amount);
601     }
602 
603     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
604      * the total supply.
605      *
606      * Emits a {Transfer} event with `from` set to the zero address.
607      *
608      * Requirements
609      *
610      * - `to` cannot be the zero address.
611      */
612     function _mint(address account, uint256 amount) internal virtual {
613         require(account != address(0), "ERC20: mint to the zero address");
614 
615         _beforeTokenTransfer(address(0), account, amount);
616 
617         _totalSupply = _totalSupply.add(amount);
618         _balances[account] = _balances[account].add(amount);
619         emit Transfer(address(0), account, amount);
620     }
621 
622     /**
623      * @dev Destroys `amount` tokens from `account`, reducing the
624      * total supply.
625      *
626      * Emits a {Transfer} event with `to` set to the zero address.
627      *
628      * Requirements
629      *
630      * - `account` cannot be the zero address.
631      * - `account` must have at least `amount` tokens.
632      */
633     function _burn(address account, uint256 amount) internal virtual {
634         require(account != address(0), "ERC20: burn from the zero address");
635 
636         _beforeTokenTransfer(account, address(0), amount);
637 
638         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
639         _totalSupply = _totalSupply.sub(amount);
640         emit Transfer(account, address(0), amount);
641     }
642 
643     /**
644      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
645      *
646      * This is internal function is equivalent to `approve`, and can be used to
647      * e.g. set automatic allowances for certain subsystems, etc.
648      *
649      * Emits an {Approval} event.
650      *
651      * Requirements:
652      *
653      * - `owner` cannot be the zero address.
654      * - `spender` cannot be the zero address.
655      */
656     function _approve(address owner, address spender, uint256 amount) internal virtual {
657         require(owner != address(0), "ERC20: approve from the zero address");
658         require(spender != address(0), "ERC20: approve to the zero address");
659 
660         _allowances[owner][spender] = amount;
661         emit Approval(owner, spender, amount);
662     }
663 
664     /**
665      * @dev Sets {decimals} to a value other than the default one of 18.
666      *
667      * WARNING: This function should only be called from the constructor. Most
668      * applications that interact with token contracts will not expect
669      * {decimals} to ever change, and may work incorrectly if it does.
670      */
671     function _setupDecimals(uint8 decimals_) internal {
672         _decimals = decimals_;
673     }
674 
675     /**
676      * @dev Hook that is called before any transfer of tokens. This includes
677      * minting and burning.
678      *
679      * Calling conditions:
680      *
681      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
682      * will be to transferred to `to`.
683      * - when `from` is zero, `amount` tokens will be minted for `to`.
684      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
685      * - `from` and `to` are never both zero.
686      *
687      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
688      */
689     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
690 }
691 
692 // Standard ERC20 token with mint and burn
693 contract ALDToken is ERC20("Aladdin Token", "ALD") {
694     address public governance;
695     mapping (address => bool) public isMinter;
696 
697     constructor () public {
698         governance = msg.sender;
699     }
700 
701     function setGovernance(address _governance) external {
702         require(msg.sender == governance, "!governance");
703         governance = _governance;
704     }
705 
706     function setMinter(address _minter, bool _status) external {
707         require(msg.sender == governance, "!governance");
708         isMinter[_minter] = _status;
709     }
710 
711     /// @notice Creates `_amount` token to `_to`. Must only be called by minter
712     function mint(address _to, uint256 _amount) external {
713         require(isMinter[msg.sender] == true, "!minter");
714         _mint(_to, _amount);
715     }
716 
717     /// @notice Burn `_amount` token from `_from`. Must only be called by governance
718     function burn(address _from, uint256 _amount) external {
719         require(msg.sender == governance, "!governance");
720         _burn(_from, _amount);
721     }
722 }