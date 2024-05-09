1 pragma solidity 0.6.12;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address payable) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 /**
25  * @dev Interface of the ERC20 standard as defined in the EIP.
26  */
27 interface IERC20 {
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `recipient`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address recipient, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `sender` to `recipient` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Emitted when `value` tokens are moved from one account (`from`) to
85      * another (`to`).
86      *
87      * Note that `value` may be zero.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     /**
92      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
93      * a call to {approve}. `value` is the new allowance.
94      */
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 /**
99  * @dev Wrappers over Solidity's arithmetic operations with added overflow
100  * checks.
101  *
102  * Arithmetic operations in Solidity wrap on overflow. This can easily result
103  * in bugs, because programmers usually assume that an overflow raises an
104  * error, which is the standard behavior in high level programming languages.
105  * `SafeMath` restores this intuition by reverting the transaction when an
106  * operation overflows.
107  *
108  * Using this library instead of the unchecked operations eliminates an entire
109  * class of bugs, so it's recommended to use it always.
110  */
111 library SafeMath {
112     /**
113      * @dev Returns the addition of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `+` operator.
117      *
118      * Requirements:
119      *
120      * - Addition cannot overflow.
121      */
122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
123         uint256 c = a + b;
124         require(c >= a, "SafeMath: addition overflow");
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the subtraction of two unsigned integers, reverting on
131      * overflow (when the result is negative).
132      *
133      * Counterpart to Solidity's `-` operator.
134      *
135      * Requirements:
136      *
137      * - Subtraction cannot overflow.
138      */
139     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
140         return sub(a, b, "SafeMath: subtraction overflow");
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      *
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b <= a, errorMessage);
155         uint256 c = a - b;
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the multiplication of two unsigned integers, reverting on
162      * overflow.
163      *
164      * Counterpart to Solidity's `*` operator.
165      *
166      * Requirements:
167      *
168      * - Multiplication cannot overflow.
169      */
170     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
171         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
172         // benefit is lost if 'b' is also tested.
173         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
174         if (a == 0) {
175             return 0;
176         }
177 
178         uint256 c = a * b;
179         require(c / a == b, "SafeMath: multiplication overflow");
180 
181         return c;
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers. Reverts on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(uint256 a, uint256 b) internal pure returns (uint256) {
197         return div(a, b, "SafeMath: division by zero");
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         require(b > 0, errorMessage);
214         uint256 c = a / b;
215         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
216 
217         return c;
218     }
219 
220     /**
221      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
222      * Reverts when dividing by zero.
223      *
224      * Counterpart to Solidity's `%` operator. This function uses a `revert`
225      * opcode (which leaves remaining gas untouched) while Solidity uses an
226      * invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
233         return mod(a, b, "SafeMath: modulo by zero");
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts with custom message when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
249         require(b != 0, errorMessage);
250         return a % b;
251     }
252 }
253 
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
330         return functionCall(target, data, "Address: low-level call failed");
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
692 /**
693  * @dev Contract module which provides a basic access control mechanism, where
694  * there is an account (an owner) that can be granted exclusive access to
695  * specific functions.
696  *
697  * By default, the owner account will be the one that deploys the contract. This
698  * can later be changed with {transferOwnership}.
699  *
700  * This module is used through inheritance. It will make available the modifier
701  * `onlyOwner`, which can be applied to your functions to restrict their use to
702  * the owner.
703  */
704 contract Ownable is Context {
705     address private _owner;
706 
707     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
708 
709     /**
710      * @dev Initializes the contract setting the deployer as the initial owner.
711      */
712     constructor () internal {
713         address msgSender = _msgSender();
714         _owner = msgSender;
715         emit OwnershipTransferred(address(0), msgSender);
716     }
717 
718     /**
719      * @dev Returns the address of the current owner.
720      */
721     function owner() public view returns (address) {
722         return _owner;
723     }
724 
725     /**
726      * @dev Throws if called by any account other than the owner.
727      */
728     modifier onlyOwner() {
729         require(_owner == _msgSender(), "Ownable: caller is not the owner");
730         _;
731     }
732 
733     /**
734      * @dev Leaves the contract without owner. It will not be possible to call
735      * `onlyOwner` functions anymore. Can only be called by the current owner.
736      *
737      * NOTE: Renouncing ownership will leave the contract without an owner,
738      * thereby removing any functionality that is only available to the owner.
739      */
740     function renounceOwnership() public virtual onlyOwner {
741         emit OwnershipTransferred(_owner, address(0));
742         _owner = address(0);
743     }
744 
745     /**
746      * @dev Transfers ownership of the contract to a new account (`newOwner`).
747      * Can only be called by the current owner.
748      */
749     function transferOwnership(address newOwner) public virtual onlyOwner {
750         require(newOwner != address(0), "Ownable: new owner is the zero address");
751         emit OwnershipTransferred(_owner, newOwner);
752         _owner = newOwner;
753     }
754 }
755 
756 // EqualToken with Governance.
757 contract EqualToken is ERC20("Equalizer", "EQL"), Ownable {
758     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
759     function mint(address _to, uint256 _amount) public onlyOwner {
760         _mint(_to, _amount);
761         _moveDelegates(address(0), _delegates[_to], _amount);
762     }
763 
764     function burn(uint256 _amount) public {
765         _burn(msg.sender, _amount);
766         _moveDelegates(_delegates[msg.sender], address(0), _amount);
767     }
768 
769     // Copied and modified from YAM code:
770     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
771     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
772     // Which is copied and modified from COMPOUND:
773     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
774 
775     /// @notice A record of each accounts delegate
776     mapping (address => address) internal _delegates;
777 
778     /// @notice A checkpoint for marking number of votes from a given block
779     struct Checkpoint {
780         uint32 fromBlock;
781         uint256 votes;
782     }
783 
784     /// @notice A record of votes checkpoints for each account, by index
785     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
786 
787     /// @notice The number of checkpoints for each account
788     mapping (address => uint32) public numCheckpoints;
789 
790     /// @notice The EIP-712 typehash for the contract's domain
791     /* solium-disable-next-line  */
792     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
793 
794     /// @notice The EIP-712 typehash for the delegation struct used by the contract
795     /* solium-disable-next-line  */
796     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
797 
798     /// @notice A record of states for signing / validating signatures
799     mapping (address => uint) public nonces;
800 
801     /// @notice An event thats emitted when an account changes its delegate
802     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
803 
804     /// @notice An event thats emitted when a delegate account's vote balance changes
805     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
806 
807     /**
808      * @notice Transfer `amount` tokens from `msg.sender` to `dst`
809      * @param dst The address of the destination account
810      * @param amount The number of tokens to transfer
811      * @return Whether or not the transfer succeeded
812      */
813     function transfer(address dst, uint256 amount) public override returns (bool) {
814         bool success = super.transfer(dst, amount);
815         if (success) {
816             _moveDelegates(_delegates[msg.sender], _delegates[dst], amount);
817         }
818         return success;
819     }
820 
821     /**
822      * @notice Transfer `amount` tokens from `src` to `dst`
823      * @param src The address of the source account
824      * @param dst The address of the destination account
825      * @param amount The number of tokens to transfer
826      * @return Whether or not the transfer succeeded
827      */
828     function transferFrom(address src, address dst, uint256 amount) public override returns (bool) {
829         bool success = super.transferFrom(src, dst, amount);
830         if (success) {
831             _moveDelegates(_delegates[src], _delegates[dst], amount);
832         }
833         return success;
834     }
835 
836     /**
837      * @notice Delegate votes from `msg.sender` to `delegatee`
838      * @param delegator The address to get delegatee for
839      */
840     function delegates(address delegator)
841     external
842     view
843     returns (address)
844     {
845         return _delegates[delegator];
846     }
847 
848     /**
849      * @notice Delegate votes from `msg.sender` to `delegatee`
850      * @param delegatee The address to delegate votes to
851      */
852     function delegate(address delegatee) external {
853         return _delegate(msg.sender, delegatee);
854     }
855 
856     /**
857      * @notice Delegates votes from signatory to `delegatee`
858      * @param delegatee The address to delegate votes to
859      * @param nonce The contract state required to match the signature
860      * @param expiry The time at which to expire the signature
861      * @param v The recovery byte of the signature
862      * @param r Half of the ECDSA signature pair
863      * @param s Half of the ECDSA signature pair
864      */
865     function delegateBySig(
866         address delegatee,
867         uint nonce,
868         uint expiry,
869         uint8 v,
870         bytes32 r,
871         bytes32 s
872     )
873     external
874     {
875         bytes32 domainSeparator = keccak256(
876             abi.encode(
877                 DOMAIN_TYPEHASH,
878                 keccak256(bytes(name())),
879                 getChainId(),
880                 address(this)
881             )
882         );
883 
884         bytes32 structHash = keccak256(
885             abi.encode(
886                 DELEGATION_TYPEHASH,
887                 delegatee,
888                 nonce,
889                 expiry
890             )
891         );
892 
893         bytes32 digest = keccak256(
894             abi.encodePacked(
895                 "\x19\x01",
896                 domainSeparator,
897                 structHash
898             )
899         );
900 
901         address signatory = ecrecover(digest, v, r, s);
902         require(signatory != address(0), "Equal::delegateBySig: invalid signature");
903         require(nonce == nonces[signatory]++, "Equal::delegateBySig: invalid nonce");
904         require(now <= expiry, "Equal::delegateBySig: signature expired");
905         return _delegate(signatory, delegatee);
906     }
907 
908     /**
909      * @notice Gets the current votes balance for `account`
910      * @param account The address to get votes balance
911      * @return The number of current votes for `account`
912      */
913     function getCurrentVotes(address account)
914     external
915     view
916     returns (uint256)
917     {
918         uint32 nCheckpoints = numCheckpoints[account];
919         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
920     }
921 
922     /**
923      * @notice Determine the prior number of votes for an account as of a block number
924      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
925      * @param account The address of the account to check
926      * @param blockNumber The block number to get the vote balance at
927      * @return The number of votes the account had as of the given block
928      */
929     function getPriorVotes(address account, uint blockNumber)
930     external
931     view
932     returns (uint256)
933     {
934         require(blockNumber < block.number, "Equal::getPriorVotes: not yet determined");
935 
936         uint32 nCheckpoints = numCheckpoints[account];
937         if (nCheckpoints == 0) {
938             return 0;
939         }
940 
941         // First check most recent balance
942         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
943             return checkpoints[account][nCheckpoints - 1].votes;
944         }
945 
946         // Next check implicit zero balance
947         if (checkpoints[account][0].fromBlock > blockNumber) {
948             return 0;
949         }
950 
951         uint32 lower = 0;
952         uint32 upper = nCheckpoints - 1;
953         while (upper > lower) {
954             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
955             Checkpoint memory cp = checkpoints[account][center];
956             if (cp.fromBlock == blockNumber) {
957                 return cp.votes;
958             } else if (cp.fromBlock < blockNumber) {
959                 lower = center;
960             } else {
961                 upper = center - 1;
962             }
963         }
964         return checkpoints[account][lower].votes;
965     }
966 
967     function _delegate(address delegator, address delegatee)
968     internal
969     {
970         address currentDelegate = _delegates[delegator];
971         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying Equal (not scaled);
972         _delegates[delegator] = delegatee;
973 
974         emit DelegateChanged(delegator, currentDelegate, delegatee);
975 
976         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
977     }
978 
979     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
980         if (srcRep != dstRep && amount > 0) {
981             if (srcRep != address(0)) {
982                 // decrease old representative
983                 uint32 srcRepNum = numCheckpoints[srcRep];
984                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
985                 uint256 srcRepNew = srcRepOld.sub(amount);
986                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
987             }
988 
989             if (dstRep != address(0)) {
990                 // increase new representative
991                 uint32 dstRepNum = numCheckpoints[dstRep];
992                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
993                 uint256 dstRepNew = dstRepOld.add(amount);
994                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
995             }
996         }
997     }
998 
999     function _writeCheckpoint(
1000         address delegatee,
1001         uint32 nCheckpoints,
1002         uint256 oldVotes,
1003         uint256 newVotes
1004     )
1005     internal
1006     {
1007         uint32 blockNumber = safe32(block.number, "Equal::_writeCheckpoint: block number exceeds 32 bits");
1008 
1009         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1010             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1011         } else {
1012             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1013             numCheckpoints[delegatee] = nCheckpoints + 1;
1014         }
1015 
1016         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1017     }
1018 
1019     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1020         require(n < 2**32, errorMessage);
1021         return uint32(n);
1022     }
1023 
1024     function getChainId() internal pure returns (uint) {
1025         uint256 chainId;
1026         /* solium-disable-next-line  */
1027         assembly { chainId := chainid() }
1028         return chainId;
1029     }
1030 }