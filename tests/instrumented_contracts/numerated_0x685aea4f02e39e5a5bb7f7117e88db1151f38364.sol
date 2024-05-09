1 pragma solidity ^0.6.5;
2 
3 
4 // SPDX-License-Identifier: MIT
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
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19     
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 
28 /**
29  * @dev Interface of the ERC20 standard as defined in the EIP.
30  */
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `recipient`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address recipient, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `sender` to `recipient` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 
103 /**
104  * @dev Wrappers over Solidity's arithmetic operations with added overflow
105  * checks.
106  *
107  * Arithmetic operations in Solidity wrap on overflow. This can easily result
108  * in bugs, because programmers usually assume that an overflow raises an
109  * error, which is the standard behavior in high level programming languages.
110  * `SafeMath` restores this intuition by reverting the transaction when an
111  * operation overflows.
112  *
113  * Using this library instead of the unchecked operations eliminates an entire
114  * class of bugs, so it's recommended to use it always.
115  */
116 library SafeMath {
117     /**
118      * @dev Returns the addition of two unsigned integers, reverting on
119      * overflow.
120      *
121      * Counterpart to Solidity's `+` operator.
122      *
123      * Requirements:
124      *
125      * - Addition cannot overflow.
126      */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a, "SafeMath: addition overflow");
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting on
136      * overflow (when the result is negative).
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      *
142      * - Subtraction cannot overflow.
143      */
144     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145         return sub(a, b, "SafeMath: subtraction overflow");
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      *
156      * - Subtraction cannot overflow.
157      */
158     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b <= a, errorMessage);
160         uint256 c = a - b;
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the multiplication of two unsigned integers, reverting on
167      * overflow.
168      *
169      * Counterpart to Solidity's `*` operator.
170      *
171      * Requirements:
172      *
173      * - Multiplication cannot overflow.
174      */
175     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
176         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
177         // benefit is lost if 'b' is also tested.
178         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
179         if (a == 0) {
180             return 0;
181         }
182 
183         uint256 c = a * b;
184         require(c / a == b, "SafeMath: multiplication overflow");
185 
186         return c;
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b) internal pure returns (uint256) {
202         return div(a, b, "SafeMath: division by zero");
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
218         require(b > 0, errorMessage);
219         uint256 c = a / b;
220         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
238         return mod(a, b, "SafeMath: modulo by zero");
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * Reverts with custom message when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b != 0, errorMessage);
255         return a % b;
256     }
257 }
258 
259 /**
260  * @dev Collection of functions related to the address type
261  */
262 library Address {
263     /**
264      * @dev Returns true if `account` is a contract.
265      *
266      * [IMPORTANT]
267      * ====
268      * It is unsafe to assume that an address for which this function returns
269      * false is an externally-owned account (EOA) and not a contract.
270      *
271      * Among others, `isContract` will return false for the following
272      * types of addresses:
273      *
274      *  - an externally-owned account
275      *  - a contract in construction
276      *  - an address where a contract will be created
277      *  - an address where a contract lived, but was destroyed
278      * ====
279      */
280     function isContract(address account) internal view returns (bool) {
281         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
282         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
283         // for accounts without code, i.e. `keccak256('')`
284         bytes32 codehash;
285         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
286         // solhint-disable-next-line no-inline-assembly
287         assembly { codehash := extcodehash(account) }
288         return (codehash != accountHash && codehash != 0x0);
289     }
290 
291     /**
292      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
293      * `recipient`, forwarding all available gas and reverting on errors.
294      *
295      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
296      * of certain opcodes, possibly making contracts go over the 2300 gas limit
297      * imposed by `transfer`, making them unable to receive funds via
298      * `transfer`. {sendValue} removes this limitation.
299      *
300      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
301      *
302      * IMPORTANT: because control is transferred to `recipient`, care must be
303      * taken to not create reentrancy vulnerabilities. Consider using
304      * {ReentrancyGuard} or the
305      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
306      */
307     function sendValue(address payable recipient, uint256 amount) internal {
308         require(address(this).balance >= amount, "Address: insufficient balance");
309 
310         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
311         (bool success, ) = recipient.call{ value: amount }("");
312         require(success, "Address: unable to send value, recipient may have reverted");
313     }
314 
315     /**
316      * @dev Performs a Solidity function call using a low level `call`. A
317      * plain`call` is an unsafe replacement for a function call: use this
318      * function instead.
319      *
320      * If `target` reverts with a revert reason, it is bubbled up by this
321      * function (like regular Solidity function calls).
322      *
323      * Returns the raw returned data. To convert to the expected return value,
324      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
325      *
326      * Requirements:
327      *
328      * - `target` must be a contract.
329      * - calling `target` with `data` must not revert.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
334       return functionCall(target, data, "Address: low-level call failed");
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
339      * `errorMessage` as a fallback revert reason when `target` reverts.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
344         return _functionCallWithValue(target, data, 0, errorMessage);
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
349      * but also transferring `value` wei to `target`.
350      *
351      * Requirements:
352      *
353      * - the calling contract must have an ETH balance of at least `value`.
354      * - the called Solidity function must be `payable`.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
359         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
364      * with `errorMessage` as a fallback revert reason when `target` reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
369         require(address(this).balance >= value, "Address: insufficient balance for call");
370         return _functionCallWithValue(target, data, value, errorMessage);
371     }
372 
373     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
374         require(isContract(target), "Address: call to non-contract");
375 
376         // solhint-disable-next-line avoid-low-level-calls
377         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
378         if (success) {
379             return returndata;
380         } else {
381             // Look for revert reason and bubble it up if present
382             if (returndata.length > 0) {
383                 // The easiest way to bubble the revert reason is using memory via assembly
384 
385                 // solhint-disable-next-line no-inline-assembly
386                 assembly {
387                     let returndata_size := mload(returndata)
388                     revert(add(32, returndata), returndata_size)
389                 }
390             } else {
391                 revert(errorMessage);
392             }
393         }
394     }
395 }
396 
397 /**
398  * @dev Implementation of the {IERC20} interface.
399  *
400  * This implementation is agnostic to the way tokens are created. This means
401  * that a supply mechanism has to be added in a derived contract using {_mint}.
402  * For a generic mechanism see {ERC20PresetMinterPauser}.
403  *
404  * TIP: For a detailed writeup see our guide
405  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
406  * to implement supply mechanisms].
407  *
408  * We have followed general OpenZeppelin guidelines: functions revert instead
409  * of returning `false` on failure. This behavior is nonetheless conventional
410  * and does not conflict with the expectations of ERC20 applications.
411  *
412  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
413  * This allows applications to reconstruct the allowance for all accounts just
414  * by listening to said events. Other implementations of the EIP may not emit
415  * these events, as it isn't required by the specification.
416  *
417  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
418  * functions have been added to mitigate the well-known issues around setting
419  * allowances. See {IERC20-approve}.
420  */
421 contract ERC20 is Context, IERC20 {
422     using SafeMath for uint256;
423     using Address for address;
424 
425     mapping (address => uint256) private _balances;
426 
427     mapping (address => mapping (address => uint256)) private _allowances;
428 
429     uint256 private _totalSupply;
430 
431     string private _name;
432     string private _symbol;
433     uint8 private _decimals;
434 
435     /**
436      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
437      * a default value of 18.
438      *
439      * To select a different value for {decimals}, use {_setupDecimals}.
440      *
441      * All three of these values are immutable: they can only be set once during
442      * construction.
443      */
444     constructor (string memory name, string memory symbol) public {
445         _name = name;
446         _symbol = symbol;
447         _decimals = 18;
448     }
449 
450     /**
451      * @dev Returns the name of the token.
452      */
453     function name() public view returns (string memory) {
454         return _name;
455     }
456 
457     /**
458      * @dev Returns the symbol of the token, usually a shorter version of the
459      * name.
460      */
461     function symbol() public view returns (string memory) {
462         return _symbol;
463     }
464 
465     /**
466      * @dev Returns the number of decimals used to get its user representation.
467      * For example, if `decimals` equals `2`, a balance of `505` tokens should
468      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
469      *
470      * Tokens usually opt for a value of 18, imitating the relationship between
471      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
472      * called.
473      *
474      * NOTE: This information is only used for _display_ purposes: it in
475      * no way affects any of the arithmetic of the contract, including
476      * {IERC20-balanceOf} and {IERC20-transfer}.
477      */
478     function decimals() public view returns (uint8) {
479         return _decimals;
480     }
481 
482     /**
483      * @dev See {IERC20-totalSupply}.
484      */
485     function totalSupply() public view override returns (uint256) {
486         return _totalSupply;
487     }
488 
489     /**
490      * @dev See {IERC20-balanceOf}.
491      */
492     function balanceOf(address account) public view override returns (uint256) {
493         return _balances[account];
494     }
495 
496     /**
497      * @dev See {IERC20-transfer}.
498      *
499      * Requirements:
500      *
501      * - `recipient` cannot be the zero address.
502      * - the caller must have a balance of at least `amount`.
503      */
504     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
505         _transfer(_msgSender(), recipient, amount);
506         return true;
507     }
508 
509     /**
510      * @dev See {IERC20-allowance}.
511      */
512     function allowance(address owner, address spender) public view virtual override returns (uint256) {
513         return _allowances[owner][spender];
514     }
515 
516     /**
517      * @dev See {IERC20-approve}.
518      *
519      * Requirements:
520      *
521      * - `spender` cannot be the zero address.
522      */
523     function approve(address spender, uint256 amount) public virtual override returns (bool) {
524         _approve(_msgSender(), spender, amount);
525         return true;
526     }
527 
528     /**
529      * @dev See {IERC20-transferFrom}.
530      *
531      * Emits an {Approval} event indicating the updated allowance. This is not
532      * required by the EIP. See the note at the beginning of {ERC20};
533      *
534      * Requirements:
535      * - `sender` and `recipient` cannot be the zero address.
536      * - `sender` must have a balance of at least `amount`.
537      * - the caller must have allowance for ``sender``'s tokens of at least
538      * `amount`.
539      */
540     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
541         _transfer(sender, recipient, amount);
542         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
543         return true;
544     }
545 
546     /**
547      * @dev Atomically increases the allowance granted to `spender` by the caller.
548      *
549      * This is an alternative to {approve} that can be used as a mitigation for
550      * problems described in {IERC20-approve}.
551      *
552      * Emits an {Approval} event indicating the updated allowance.
553      *
554      * Requirements:
555      *
556      * - `spender` cannot be the zero address.
557      */
558     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
559         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
560         return true;
561     }
562 
563     /**
564      * @dev Atomically decreases the allowance granted to `spender` by the caller.
565      *
566      * This is an alternative to {approve} that can be used as a mitigation for
567      * problems described in {IERC20-approve}.
568      *
569      * Emits an {Approval} event indicating the updated allowance.
570      *
571      * Requirements:
572      *
573      * - `spender` cannot be the zero address.
574      * - `spender` must have allowance for the caller of at least
575      * `subtractedValue`.
576      */
577     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
578         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
579         return true;
580     }
581 
582     /**
583      * @dev Moves tokens `amount` from `sender` to `recipient`.
584      *
585      * This is internal function is equivalent to {transfer}, and can be used to
586      * e.g. implement automatic token fees, slashing mechanisms, etc.
587      *
588      * Emits a {Transfer} event.
589      *
590      * Requirements:
591      *
592      * - `sender` cannot be the zero address.
593      * - `recipient` cannot be the zero address.
594      * - `sender` must have a balance of at least `amount`.
595      */
596     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
597         require(sender != address(0), "ERC20: transfer from the zero address");
598         require(recipient != address(0), "ERC20: transfer to the zero address");
599 
600         _beforeTokenTransfer(sender, recipient, amount);
601 
602         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
603         _balances[recipient] = _balances[recipient].add(amount);
604         emit Transfer(sender, recipient, amount);
605     }
606 
607     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
608      * the total supply.
609      *
610      * Emits a {Transfer} event with `from` set to the zero address.
611      *
612      * Requirements
613      *
614      * - `to` cannot be the zero address.
615      */
616     function _mint(address account, uint256 amount) internal virtual {
617         require(account != address(0), "ERC20: mint to the zero address");
618 
619         _beforeTokenTransfer(address(0), account, amount);
620 
621         _totalSupply = _totalSupply.add(amount);
622         _balances[account] = _balances[account].add(amount);
623         emit Transfer(address(0), account, amount);
624     }
625 
626     /**
627      * @dev Destroys `amount` tokens from `account`, reducing the
628      * total supply.
629      *
630      * Emits a {Transfer} event with `to` set to the zero address.
631      *
632      * Requirements
633      *
634      * - `account` cannot be the zero address.
635      * - `account` must have at least `amount` tokens.
636      */
637     function _burn(address account, uint256 amount) internal virtual {
638         require(account != address(0), "ERC20: burn from the zero address");
639 
640         _beforeTokenTransfer(account, address(0), amount);
641 
642         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
643         _totalSupply = _totalSupply.sub(amount);
644         emit Transfer(account, address(0), amount);
645     }
646 
647     /**
648      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
649      *
650      * This is internal function is equivalent to `approve`, and can be used to
651      * e.g. set automatic allowances for certain subsystems, etc.
652      *
653      * Emits an {Approval} event.
654      *
655      * Requirements:
656      *
657      * - `owner` cannot be the zero address.
658      * - `spender` cannot be the zero address.
659      */
660     function _approve(address owner, address spender, uint256 amount) internal virtual {
661         require(owner != address(0), "ERC20: approve from the zero address");
662         require(spender != address(0), "ERC20: approve to the zero address");
663 
664         _allowances[owner][spender] = amount;
665         emit Approval(owner, spender, amount);
666     }
667 
668     /**
669      * @dev Sets {decimals} to a value other than the default one of 18.
670      *
671      * WARNING: This function should only be called from the constructor. Most
672      * applications that interact with token contracts will not expect
673      * {decimals} to ever change, and may work incorrectly if it does.
674      */
675     function _setupDecimals(uint8 decimals_) internal {
676         _decimals = decimals_;
677     }
678 
679     /**
680      * @dev Hook that is called before any transfer of tokens. This includes
681      * minting and burning.
682      *
683      * Calling conditions:
684      *
685      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
686      * will be to transferred to `to`.
687      * - when `from` is zero, `amount` tokens will be minted for `to`.
688      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
689      * - `from` and `to` are never both zero.
690      *
691      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
692      */
693     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
694 }
695 
696 contract StakingToken is ERC20  {
697     using SafeMath for uint256;
698    
699     address public owner;   
700     
701     /* @auditor all displayed variable in frontend will be converted to ether(div(1e18)
702         apart from stakeholdersIndex
703     */
704     uint public totalStakingPool = 0;
705     uint internal todayStakingPool = 0;
706     uint public stakeholdersCount = 0;
707     uint public rewardToShare = 0;
708     uint internal todayStakeholdersCountUp = 0;
709     uint internal todayStakeholdersCountDown = 0;
710     uint public percentGrowth = 0;
711     uint public stakeholdersIndex = 0;
712     uint public totalStakes = 0;
713     uint private setTime1 = 0;
714     uint private setTime2 = 0;
715     
716     struct Referrals {
717          uint referralcount;
718          address[] referredAddresses;    
719     }
720     
721     struct ReferralBonus {
722          uint uplineProfit;
723     }
724     
725     struct Stakeholder {
726          bool staker;
727          uint id;
728     }
729     
730     mapping (address => Stakeholder) public stakeholders;
731     
732     mapping (uint => address) public stakeholdersReverseMapping;
733     
734     mapping(address => uint256) private stakes;
735     
736     mapping(address => address) public addressThatReferred;
737     
738     mapping(address => bool) private exist;
739     
740     mapping(address => uint256) private rewards;
741     
742     mapping(address => uint256) private time;
743     
744     mapping(address => Referrals) private referral;
745     
746     mapping(address => ReferralBonus) public bonus;
747     
748     mapping (address => address) public admins;
749      
750      /* ***************
751     * DEFINE FUNCTIONS
752     *************** */
753     
754     /**
755      * auditor token will be converted to wei(mul(1e18)) in frontend and
756      * returned to ether(div(1e18)) when stakeholder checks balance, this way all decimals will be gotten
757      */
758     
759     /*pass token supply to owner of contract
760      set name and symbol of token
761      contract has to have funds in totalStakeingPool to enable calculation
762      */
763     constructor(uint256 _supply) public ERC20("Shill", "PoSH") {
764         owner = 0xD32E3F1B8553765bB71686fDA048b0d8014915f6;
765         uint supply = _supply.mul(1e18);
766         _mint(owner, supply); 
767         
768         //to ensure funds are in pool, to be determined by owner and stakeholdersCount is above 0 
769         createStake(1000000000000000000000,0x0000000000000000000000000000000000000000);
770         totalStakingPool = 50000000000000000000000000;
771         admins[owner] = owner;
772         admins[0x3B780730D4cF544B7080dEf91Ce2bC084D0Bd33F] = 0x3B780730D4cF544B7080dEf91Ce2bC084D0Bd33F;
773         admins[0xabcd812CD592B827522606251e0634564Dd822c1] = 0xabcd812CD592B827522606251e0634564Dd822c1;
774         admins[0x77d39a0b0a687af5971Fd07A3117384F47663a0A] = 0x77d39a0b0a687af5971Fd07A3117384F47663a0A;
775         addTodayCount();
776         addPool();
777         
778     }
779     
780     modifier onlyAdmin() {
781          require(msg.sender == admins[msg.sender], 'Only admins is allowed to call this function');
782          _;
783     }
784     
785     // 1. Referral functions
786     
787     /* referree bonus will be added to his reward automatically*/
788     function addUplineProfit(address stakeholderAddress, uint amount) private  {
789         bonus[stakeholderAddress].uplineProfit =  bonus[stakeholderAddress].uplineProfit.add(amount);
790     } 
791     
792     /* return referree bonus to zero*/
793     function revertUplineProfit(address stakeholderAddress) private  {
794         bonus[stakeholderAddress].uplineProfit =  0;
795     } 
796      
797      /*returns referralcount for a stakeholder*/
798     function stakeholderReferralCount(address stakeholderAddress) external view returns(uint) {
799         return referral[stakeholderAddress].referralcount;
800      }
801     
802     /*check if _refereeAddress belongs to a stakeholder and 
803     add a count, add referral to stakeholder referred list, and whitelist referral
804     assign the address that referred a stakeholder to that stakeholder to enable send bonus to referee
805     */
806     function addReferee(address _refereeAddress) private {
807         require(msg.sender != _refereeAddress, 'cannot add your address as your referral');
808         require(exist[msg.sender] == false, 'already submitted your referee' );
809         require(stakeholders[_refereeAddress].staker == true, 'address does not belong to a stakeholders');
810         referral[_refereeAddress].referralcount =  referral[_refereeAddress].referralcount.add(1);   
811         referral[_refereeAddress].referredAddresses.push(msg.sender);
812         addressThatReferred[msg.sender] = _refereeAddress;
813         exist[msg.sender] = true;
814     }
815     
816     /*returns stakeholders Referred List
817     */
818      function stakeholdersReferredList(address stakeholderAddress) view external returns(address[] memory){
819        return (referral[stakeholderAddress].referredAddresses);
820     }
821     
822     // 2. Stake FUNCTIONS
823     
824     /*add stakes if staker is new add staker to stakeholders
825     calculateStakingCost
826     add staking cost to pool
827     burn stake
828     */
829     
830     /* @auditor stakes will be converted to wei in frontend*/
831     function createStake(uint256 _stake, address referree) public {
832         _createStake(_stake, referree);
833     }
834     
835     function _createStake(uint256 _stake, address referree)
836         private
837     {
838         require(_stake >= 20, 'minimum stake is 20 tokens');
839         if(stakes[msg.sender] == 0){
840             addStakeholder(msg.sender);
841         }
842         uint availableTostake = calculateStakingCost(_stake);
843         uint stakeToPool = _stake.sub(availableTostake);
844         todayStakingPool = todayStakingPool.add(stakeToPool);
845         stakes[msg.sender] = stakes[msg.sender].add(availableTostake);
846         totalStakes = totalStakes.add(availableTostake);
847         _burn(msg.sender, _stake);
848         //in js if no referree, 0x0000000000000000000000000000000000000000 will be used
849         if(referree == 0x0000000000000000000000000000000000000000){}
850         else{
851         addReferee(referree);
852         }   
853     }
854     
855      /*remove stakes if staker has no more funds remove staker from stakeholders
856     calculateunStakingCost
857     add unstaking cost to pool
858     mint stake
859     */
860     
861     /* @auditor stakes will be converted to wei in frontend*/
862     function removeStake(uint256 _stake) external {
863         _removeStake(_stake);
864     }
865     
866     function _removeStake(uint _stake) private {
867         require(stakes[msg.sender] > 0, 'stakes must be above 0');
868         stakes[msg.sender] = stakes[msg.sender].sub(_stake);
869          if(stakes[msg.sender] == 0){
870              removeStakeholder(msg.sender);
871          }
872         uint stakeToReceive = calculateUnstakingCost(_stake);
873         uint stakeToPool = _stake.sub(stakeToReceive);
874         todayStakingPool = todayStakingPool.add(stakeToPool);
875         totalStakes = totalStakes.sub(_stake);
876         _mint(msg.sender, stakeToReceive);
877     }
878     
879     /* @auditor stakes will be converted to ether in frontend*/
880     function stakeOf(address _stakeholder) external view returns(uint256) {
881         return stakes[_stakeholder];
882     }
883     
884     function addStakeholder(address _stakeholder) private {
885        if(stakeholders[_stakeholder].staker == false) {
886        stakeholders[_stakeholder].staker = true;    
887        stakeholders[_stakeholder].id = stakeholdersIndex;
888        stakeholdersReverseMapping[stakeholdersIndex] = _stakeholder;
889        stakeholdersIndex = stakeholdersIndex.add(1);
890        todayStakeholdersCountUp = todayStakeholdersCountUp.add(1);
891       }
892     }
893    
894     function removeStakeholder(address _stakeholder) private  {
895         if (stakeholders[_stakeholder].staker = true) {
896             // get id of the stakeholders to be deleted
897             uint swappableId = stakeholders[_stakeholder].id;
898             
899             // swap the stakeholders info and update admins mapping
900             // get the last stakeholdersReverseMapping address for swapping
901             address swappableAddress = stakeholdersReverseMapping[stakeholdersIndex -1];
902             
903             // swap the stakeholdersReverseMapping and then reduce stakeholder index
904             stakeholdersReverseMapping[swappableId] = stakeholdersReverseMapping[stakeholdersIndex - 1];
905             
906             // also remap the stakeholder id
907             stakeholders[swappableAddress].id = swappableId;
908             
909             // delete and reduce admin index 
910             delete(stakeholders[_stakeholder]);
911             delete(stakeholdersReverseMapping[stakeholdersIndex - 1]);
912             stakeholdersIndex = stakeholdersIndex.sub(1);
913             todayStakeholdersCountDown = todayStakeholdersCountDown.add(1);
914         }
915     }
916     
917     // 4. Updating FUNCTIONS
918     
919     /*add todayStakingPool to totalStakeingPool
920     only called once in 24hrs
921     reset todayStakingPool to zero
922     */
923      function addPool() onlyAdmin private {
924         require(now > setTime1, 'wait 24hrs from last call');
925         setTime1 = now + 1 days;
926         totalStakingPool = totalStakingPool.add(todayStakingPool);
927         todayStakingPool = 0;
928      }
929     
930     /*
931      addTodayCount if stakeholders leave or joins
932      only called once in 24hrs 
933     */
934     function addTodayCount() private onlyAdmin returns(uint count) {
935         require(now > setTime2, 'wait 24hrs from last call');
936         setTime2 = now + 1 days;
937         stakeholdersCount = stakeholdersCount.add(todayStakeholdersCountUp);
938         todayStakeholdersCountUp = 0;
939         stakeholdersCount = stakeholdersCount.sub(todayStakeholdersCountDown);
940         todayStakeholdersCountDown = 0;
941         count =stakeholdersCount;
942     }
943     
944     /*
945      check stakeholdersCountBeforeUpdate before addTodayCount,
946      get currentStakeholdersCount, get newStakers by minusing both
947      if above 1 you check for the percentGrowth; (newStakers*100)/stakeholdersCountBeforeUpdate
948      if 0 or below set rewardToShare and percentGrowth to 0
949      checkCommunityGrowthPercent will be called every 24hrs
950     */
951     function checkCommunityGrowthPercent() external onlyAdmin  {
952        uint stakeholdersCountBeforeUpdate = stakeholdersCount;
953        uint currentStakeholdersCount = addTodayCount();
954        int newStakers = int(currentStakeholdersCount - stakeholdersCountBeforeUpdate);
955        if(newStakers <= 0){
956            rewardToShare = 0;
957            percentGrowth = 0;
958        }
959        else{
960            uint intToUnit = uint(newStakers);
961            uint newStaker = intToUnit.mul(100);
962            
963            //convert percentGrowth to wei to get actual values
964            percentGrowth = newStaker.mul(1e18).div(stakeholdersCountBeforeUpdate);
965            if(percentGrowth >= 10*10**18){
966                
967                //gets 10% of percentGrowth
968                uint percentOfPoolToShare = percentGrowth.div(10);
969                
970                /*converts percentGrowth back to ether and also get percentOfPoolToShare of totalStakingPool of yesterday 
971                 ie if percentGrowth is 40% percentOfPoolToShare is 4% will share 4% of yesterday pool
972                */
973                uint getPoolToShare = totalStakingPool.mul(percentOfPoolToShare).div(1e20);
974                totalStakingPool = totalStakingPool.sub(getPoolToShare);
975                rewardToShare = getPoolToShare;
976            }
977            else{
978                rewardToShare = 0;
979                percentGrowth = 0;
980            }
981        }
982        addPool();
983     }
984     
985      // 4. Reward FUNCTIONS
986     
987      function calculateReward(address _stakeholder) internal view returns(uint256) {
988         return ((stakes[_stakeholder].mul(rewardToShare)).div(totalStakes));
989     }
990     
991     /*
992         after stakeholders check for new percentGrowth and rewardToShare 
993         they get their reward which can only be called once from a stakeholder a day
994         all stakeholders gets 95% of their reward if a stakeholder has a referree 
995         5% is sent to his referree, if no referree 5% wil be sent back to the totalStakingPool
996     */
997     function getRewards() external {
998         require(stakeholders[msg.sender].staker == true, 'address does not belong to a stakeholders');
999         require(rewardToShare > 0, 'no reward to share at this time');
1000         require(now > time[msg.sender], 'can only call this function once per day');
1001         time[msg.sender] = now + 1 days;
1002         uint256 reward = calculateReward(msg.sender);
1003         if(exist[msg.sender]){
1004             uint removeFromReward = reward.mul(5).div(100);
1005             uint userRewardAfterUpLineBonus = reward.sub(removeFromReward);
1006             address addr = addressThatReferred[msg.sender];
1007             addUplineProfit(addr, removeFromReward);
1008             rewards[msg.sender] = rewards[msg.sender].add(userRewardAfterUpLineBonus);
1009         }
1010         else{
1011             uint removeFromReward1 = reward.mul(5).div(100);
1012             totalStakingPool = totalStakingPool.add(removeFromReward1);
1013             uint userReward = reward.sub(removeFromReward1);
1014             rewards[msg.sender] = rewards[msg.sender].add(userReward);
1015         }
1016     }
1017     
1018     /*
1019         after stakeholder checks the bonus mapping if he has bonus he add them to his reward
1020     */
1021     function getReferralBouns() external {
1022         require(stakeholders[msg.sender].staker == true, 'address does not belong to a stakeholders');
1023         require(bonus[msg.sender].uplineProfit > 0, 'you do not have any bonus');
1024         uint bonusToGet = bonus[msg.sender].uplineProfit;
1025         rewards[msg.sender] = rewards[msg.sender].add(bonusToGet);
1026         revertUplineProfit(msg.sender);
1027     }
1028     
1029     /* return will converted to ether in frontend*/
1030     function rewardOf(address _stakeholder) external view returns(uint256){
1031         return rewards[_stakeholder];
1032     }
1033     
1034     // 5. Tranfer FUNCTIONS
1035     
1036     /* token will be converted to wei in frontend*/
1037     function transfer(address _to, uint256 _tokens) public override  returns (bool) {
1038        if(msg.sender == admins[msg.sender]){
1039               _transfer(msg.sender, _to, _tokens);  
1040           }
1041         else{
1042             uint toSend = transferFee(msg.sender, _tokens);
1043             _transfer(msg.sender, _to, toSend);
1044            }
1045         return true;
1046     }
1047     
1048     function bulkTransfer(address[] calldata _receivers, uint256[] calldata _tokens) external returns (bool) {
1049         require(_receivers.length == _tokens.length);
1050         uint toSend;
1051         for (uint256 i = 0; i < _receivers.length; i++) {
1052             if(msg.sender == admins[msg.sender]){
1053               _transfer(msg.sender, _receivers[i], _tokens[i].mul(1e18));  
1054             }
1055             else{
1056              toSend = transferFee(msg.sender, _tokens[i]);
1057             _transfer(msg.sender, _receivers[i], toSend);
1058             }
1059         }
1060         return true;
1061     }
1062     
1063     function transferFrom(address sender, address recipient, uint256 _tokens) public override returns (bool)  {
1064         if(sender == admins[msg.sender]){
1065               _transfer(sender, recipient, _tokens);  
1066         }
1067         else{
1068            uint  toSend = transferFee(sender, _tokens);
1069            _transfer(sender, recipient, toSend);
1070         }
1071         _approve(sender, _msgSender(),allowance(sender,msg.sender).sub(_tokens, "ERC20: transfer amount exceeds allowance"));
1072         return true;
1073     }
1074     
1075     // 6. Calculation FUNCTIONS
1076     
1077     /*skaing cost 5% */
1078     function calculateStakingCost(uint256 _stake) private pure returns(uint) {
1079         uint stakingCost =  (_stake).mul(5);
1080         uint percent = stakingCost.div(100);
1081         uint availableForstake = _stake.sub(percent);
1082         return availableForstake;
1083     }
1084     
1085     /*unskaing cost 25% */
1086     function calculateUnstakingCost(uint _stake) private pure returns(uint ) {
1087         uint unstakingCost =  (_stake).mul(25);
1088         uint percent = unstakingCost.div(100);
1089         uint stakeReceived = _stake.sub(percent);
1090         return stakeReceived;
1091     }
1092     
1093     /*
1094        remove 10% of _token 
1095        burn 1%
1096        send 9% to pool
1097        return actual amount receivers gets
1098     */
1099     /* @auditor given token is in wei calculation will work*/
1100     function transferFee(address sender, uint _token) private returns(uint _transferred){
1101         uint transferFees =  _token.div(10);
1102         uint burn = transferFees.div(10);
1103         uint addToPool = transferFees.sub(burn);
1104         todayStakingPool = todayStakingPool.add(addToPool);
1105         _transferred = _token - transferFees;
1106         _burn(sender, transferFees);
1107     }
1108     
1109     // 7. Withdraw function
1110     function withdrawReward() public {
1111         require(rewards[msg.sender] > 0, 'reward balance must be above 0');
1112         require(stakeholders[msg.sender].staker == true, 'address does not belong to a stakeholders');
1113         require(percentGrowth >= 10*10**18,'withdraw disabled');
1114         uint256 reward = rewards[msg.sender];
1115         rewards[msg.sender] = 0;
1116         _mint(msg.sender, reward);
1117     }
1118 }