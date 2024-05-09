1 /*
2       $$$$$$$\  $$\                 $$\     $$\      $$\                                         
3       $$  __$$\ \__|                $$ |    $$$\    $$$ |                                        
4       $$ |  $$ |$$\  $$$$$$\   $$$$$$$ |    $$$$\  $$$$ | $$$$$$\  $$$$$$$\   $$$$$$\  $$\   $$\ 
5       $$$$$$$\ |$$ |$$  __$$\ $$  __$$ |    $$\$$\$$ $$ |$$  __$$\ $$  __$$\ $$  __$$\ $$ |  $$ |
6       $$  __$$\ $$ |$$ |  \__|$$ /  $$ |    $$ \$$$  $$ |$$ /  $$ |$$ |  $$ |$$$$$$$$ |$$ |  $$ |
7       $$ |  $$ |$$ |$$ |      $$ |  $$ |    $$ |\$  /$$ |$$ |  $$ |$$ |  $$ |$$   ____|$$ |  $$ |
8       $$$$$$$  |$$ |$$ |      \$$$$$$$ |$$\ $$ | \_/ $$ |\$$$$$$  |$$ |  $$ |\$$$$$$$\ \$$$$$$$ |
9       \_______/ \__|\__|       \_______|\__|\__|     \__| \______/ \__|  \__| \_______| \____$$ |
10                                                                                        $$\   $$ |
11                                                                                        \$$$$$$  |
12                                                                                         \______/ 
13 */
14  
15  
16 // Bird.Money Token $BIRD
17 // © 2020 Bird Money
18 // SPDX-License-Identifier: MIT
19 
20 pragma solidity 0.6.12;
21 
22 /*
23  * @dev Provides information about the current execution context, including the
24  * sender of the transaction and its data. While these are generally available
25  * via msg.sender and msg.data, they should not be accessed in such a direct
26  * manner, since when dealing with GSN meta-transactions the account sending and
27  * paying for execution may not be the actual sender (as far as an application
28  * is concerned).
29  *
30  * This contract is only required for intermediate, library-like contracts.
31  */
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address payable) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes memory) {
38         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
39         return msg.data;
40     }
41 }
42 
43 
44 
45 /**
46  * @dev Interface of the ERC20 standard as defined in the EIP.
47  */
48 interface IERC20 {
49     /**
50      * @dev Returns the amount of tokens in existence.
51      */
52     function totalSupply() external view returns (uint256);
53 
54     /**
55      * @dev Returns the amount of tokens owned by `account`.
56      */
57     function balanceOf(address account) external view returns (uint256);
58 
59     /**
60      * @dev Moves `amount` tokens from the caller's account to `recipient`.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transfer(address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Returns the remaining number of tokens that `spender` will be
70      * allowed to spend on behalf of `owner` through {transferFrom}. This is
71      * zero by default.
72      *
73      * This value changes when {approve} or {transferFrom} are called.
74      */
75     function allowance(address owner, address spender) external view returns (uint256);
76 
77     /**
78      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * IMPORTANT: Beware that changing an allowance with this method brings the risk
83      * that someone may use both the old and the new allowance by unfortunate
84      * transaction ordering. One possible solution to mitigate this race
85      * condition is to first reduce the spender's allowance to 0 and set the
86      * desired value afterwards:
87      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
88      *
89      * Emits an {Approval} event.
90      */
91     function approve(address spender, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Moves `amount` tokens from `sender` to `recipient` using the
95      * allowance mechanism. `amount` is then deducted from the caller's
96      * allowance.
97      *
98      * Returns a boolean value indicating whether the operation succeeded.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
103 
104     /**
105      * @dev Emitted when `value` tokens are moved from one account (`from`) to
106      * another (`to`).
107      *
108      * Note that `value` may be zero.
109      */
110     event Transfer(address indexed from, address indexed to, uint256 value);
111 
112     /**
113      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
114      * a call to {approve}. `value` is the new allowance.
115      */
116     event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 /**
120  * @dev Wrappers over Solidity's arithmetic operations with added overflow
121  * checks.
122  *
123  * Arithmetic operations in Solidity wrap on overflow. This can easily result
124  * in bugs, because programmers usually assume that an overflow raises an
125  * error, which is the standard behavior in high level programming languages.
126  * `SafeMath` restores this intuition by reverting the transaction when an
127  * operation overflows.
128  *
129  * Using this library instead of the unchecked operations eliminates an entire
130  * class of bugs, so it's recommended to use it always.
131  */
132 library SafeMath {
133     /**
134      * @dev Returns the addition of two unsigned integers, reverting on
135      * overflow.
136      *
137      * Counterpart to Solidity's `+` operator.
138      *
139      * Requirements:
140      *
141      * - Addition cannot overflow.
142      */
143     function add(uint256 a, uint256 b) internal pure returns (uint256) {
144         uint256 c = a + b;
145         require(c >= a, "SafeMath: addition overflow");
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      *
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
161         return sub(a, b, "SafeMath: subtraction overflow");
162     }
163 
164     /**
165      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
166      * overflow (when the result is negative).
167      *
168      * Counterpart to Solidity's `-` operator.
169      *
170      * Requirements:
171      *
172      * - Subtraction cannot overflow.
173      */
174     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
175         require(b <= a, errorMessage);
176         uint256 c = a - b;
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the multiplication of two unsigned integers, reverting on
183      * overflow.
184      *
185      * Counterpart to Solidity's `*` operator.
186      *
187      * Requirements:
188      *
189      * - Multiplication cannot overflow.
190      */
191     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
192         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
193         // benefit is lost if 'b' is also tested.
194         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
195         if (a == 0) {
196             return 0;
197         }
198 
199         uint256 c = a * b;
200         require(c / a == b, "SafeMath: multiplication overflow");
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers. Reverts on
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
217     function div(uint256 a, uint256 b) internal pure returns (uint256) {
218         return div(a, b, "SafeMath: division by zero");
219     }
220 
221     /**
222      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
223      * division by zero. The result is rounded towards zero.
224      *
225      * Counterpart to Solidity's `/` operator. Note: this function uses a
226      * `revert` opcode (which leaves remaining gas untouched) while Solidity
227      * uses an invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b > 0, errorMessage);
235         uint256 c = a / b;
236         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
237 
238         return c;
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * Reverts when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
254         return mod(a, b, "SafeMath: modulo by zero");
255     }
256 
257     /**
258      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
259      * Reverts with custom message when dividing by zero.
260      *
261      * Counterpart to Solidity's `%` operator. This function uses a `revert`
262      * opcode (which leaves remaining gas untouched) while Solidity uses an
263      * invalid opcode to revert (consuming all remaining gas).
264      *
265      * Requirements:
266      *
267      * - The divisor cannot be zero.
268      */
269     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
270         require(b != 0, errorMessage);
271         return a % b;
272     }
273 }
274 
275 /**
276  * @dev Collection of functions related to the address type
277  */
278 library Address {
279     /**
280      * @dev Returns true if `account` is a contract.
281      *
282      * [IMPORTANT]
283      * ====
284      * It is unsafe to assume that an address for which this function returns
285      * false is an externally-owned account (EOA) and not a contract.
286      *
287      * Among others, `isContract` will return false for the following
288      * types of addresses:
289      *
290      *  - an externally-owned account
291      *  - a contract in construction
292      *  - an address where a contract will be created
293      *  - an address where a contract lived, but was destroyed
294      * ====
295      */
296     function isContract(address account) internal view returns (bool) {
297         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
298         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
299         // for accounts without code, i.e. `keccak256('')`
300         bytes32 codehash;
301         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
302         // solhint-disable-next-line no-inline-assembly
303         assembly { codehash := extcodehash(account) }
304         return (codehash != accountHash && codehash != 0x0);
305     }
306 
307     /**
308      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
309      * `recipient`, forwarding all available gas and reverting on errors.
310      *
311      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
312      * of certain opcodes, possibly making contracts go over the 2300 gas limit
313      * imposed by `transfer`, making them unable to receive funds via
314      * `transfer`. {sendValue} removes this limitation.
315      *
316      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
317      *
318      * IMPORTANT: because control is transferred to `recipient`, care must be
319      * taken to not create reentrancy vulnerabilities. Consider using
320      * {ReentrancyGuard} or the
321      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
322      */
323     function sendValue(address payable recipient, uint256 amount) internal {
324         require(address(this).balance >= amount, "Address: insufficient balance");
325 
326         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
327         (bool success, ) = recipient.call{ value: amount }("");
328         require(success, "Address: unable to send value, recipient may have reverted");
329     }
330 
331     /**
332      * @dev Performs a Solidity function call using a low level `call`. A
333      * plain`call` is an unsafe replacement for a function call: use this
334      * function instead.
335      *
336      * If `target` reverts with a revert reason, it is bubbled up by this
337      * function (like regular Solidity function calls).
338      *
339      * Returns the raw returned data. To convert to the expected return value,
340      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
341      *
342      * Requirements:
343      *
344      * - `target` must be a contract.
345      * - calling `target` with `data` must not revert.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
350       return functionCall(target, data, "Address: low-level call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
355      * `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
360         return _functionCallWithValue(target, data, 0, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but also transferring `value` wei to `target`.
366      *
367      * Requirements:
368      *
369      * - the calling contract must have an ETH balance of at least `value`.
370      * - the called Solidity function must be `payable`.
371      *
372      * _Available since v3.1._
373      */
374     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
375         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
380      * with `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
385         require(address(this).balance >= value, "Address: insufficient balance for call");
386         return _functionCallWithValue(target, data, value, errorMessage);
387     }
388 
389     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
390         require(isContract(target), "Address: call to non-contract");
391 
392         // solhint-disable-next-line avoid-low-level-calls
393         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
394         if (success) {
395             return returndata;
396         } else {
397             // Look for revert reason and bubble it up if present
398             if (returndata.length > 0) {
399                 // The easiest way to bubble the revert reason is using memory via assembly
400 
401                 // solhint-disable-next-line no-inline-assembly
402                 assembly {
403                     let returndata_size := mload(returndata)
404                     revert(add(32, returndata), returndata_size)
405                 }
406             } else {
407                 revert(errorMessage);
408             }
409         }
410     }
411 }
412 
413 /**
414  * @dev Implementation of the {IERC20} interface.
415  *
416  * This implementation is agnostic to the way tokens are created. This means
417  * that a supply mechanism has to be added in a derived contract using {_mint}.
418  * For a generic mechanism see {ERC20PresetMinterPauser}.
419  *
420  * TIP: For a detailed writeup see our guide
421  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
422  * to implement supply mechanisms].
423  *
424  * We have followed general OpenZeppelin guidelines: functions revert instead
425  * of returning `false` on failure. This behavior is nonetheless conventional
426  * and does not conflict with the expectations of ERC20 applications.
427  *
428  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
429  * This allows applications to reconstruct the allowance for all accounts just
430  * by listening to said events. Other implementations of the EIP may not emit
431  * these events, as it isn't required by the specification.
432  *
433  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
434  * functions have been added to mitigate the well-known issues around setting
435  * allowances. See {IERC20-approve}.
436  */
437 
438 contract ERC20 is Context, IERC20 {
439     using SafeMath for uint256;
440     using Address for address;
441 
442     mapping (address => uint256) private _balances;
443 
444     mapping (address => mapping (address => uint256)) private _allowances;
445 
446     uint256 private _totalSupply;
447 
448     string private _name;
449     string private _symbol;
450     uint8 private _decimals;
451 
452     /**
453      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
454      * a default value of 18.
455      *
456      * To select a different value for {decimals}, use {_setupDecimals}.
457      *
458      * All three of these values are immutable: they can only be set once during
459      * construction.
460      */
461     constructor (string memory name, string memory symbol) public {
462         _name = name;
463         _symbol = symbol;
464         _decimals = 18;
465     }
466 
467     /**
468      * @dev Returns the name of the token.
469      */
470     function name() public view returns (string memory) {
471         return _name;
472     }
473 
474     /**
475      * @dev Returns the symbol of the token, usually a shorter version of the
476      * name.
477      */
478     function symbol() public view returns (string memory) {
479         return _symbol;
480     }
481 
482     /**
483      * @dev Returns the number of decimals used to get its user representation.
484      * For example, if `decimals` equals `2`, a balance of `505` tokens should
485      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
486      *
487      * Tokens usually opt for a value of 18, imitating the relationship between
488      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
489      * called.
490      *
491      * NOTE: This information is only used for _display_ purposes: it in
492      * no way affects any of the arithmetic of the contract, including
493      * {IERC20-balanceOf} and {IERC20-transfer}.
494      */
495     function decimals() public view returns (uint8) {
496         return _decimals;
497     }
498 
499     /**
500      * @dev See {IERC20-totalSupply}.
501      */
502     function totalSupply() public view override returns (uint256) {
503         return _totalSupply;
504     }
505 
506     /**
507      * @dev See {IERC20-balanceOf}.
508      */
509     function balanceOf(address account) public view override returns (uint256) {
510         return _balances[account];
511     }
512 
513     /**
514      * @dev See {IERC20-transfer}.
515      *
516      * Requirements:
517      *
518      * - `recipient` cannot be the zero address.
519      * - the caller must have a balance of at least `amount`.
520      */
521     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
522         _transfer(_msgSender(), recipient, amount);
523         return true;
524     }
525 
526     /**
527      * @dev See {IERC20-allowance}.
528      */
529     function allowance(address owner, address spender) public view virtual override returns (uint256) {
530         return _allowances[owner][spender];
531     }
532 
533     /**
534      * @dev See {IERC20-approve}.
535      *
536      * Requirements:
537      *
538      * - `spender` cannot be the zero address.
539      */
540     function approve(address spender, uint256 amount) public virtual override returns (bool) {
541         _approve(_msgSender(), spender, amount);
542         return true;
543     }
544 
545     /**
546      * @dev See {IERC20-transferFrom}.
547      *
548      * Emits an {Approval} event indicating the updated allowance. This is not
549      * required by the EIP. See the note at the beginning of {ERC20};
550      *
551      * Requirements:
552      * - `sender` and `recipient` cannot be the zero address.
553      * - `sender` must have a balance of at least `amount`.
554      * - the caller must have allowance for ``sender``'s tokens of at least
555      * `amount`.
556      */
557     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
558         _transfer(sender, recipient, amount);
559         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
560         return true;
561     }
562 
563     /**
564      * @dev Atomically increases the allowance granted to `spender` by the caller.
565      *
566      * This is an alternative to {approve} that can be used as a mitigation for
567      * problems described in {IERC20-approve}.
568      *
569      * Emits an {Approval} event indicating the updated allowance.
570      *
571      * Requirements:
572      *
573      * - `spender` cannot be the zero address.
574      */
575     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
576         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
577         return true;
578     }
579 
580     /**
581      * @dev Atomically decreases the allowance granted to `spender` by the caller.
582      *
583      * This is an alternative to {approve} that can be used as a mitigation for
584      * problems described in {IERC20-approve}.
585      *
586      * Emits an {Approval} event indicating the updated allowance.
587      *
588      * Requirements:
589      *
590      * - `spender` cannot be the zero address.
591      * - `spender` must have allowance for the caller of at least
592      * `subtractedValue`.
593      */
594     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
595         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
596         return true;
597     }
598 
599     /**
600      * @dev Moves tokens `amount` from `sender` to `recipient`.
601      *
602      * This is internal function is equivalent to {transfer}, and can be used to
603      * e.g. implement automatic token fees, slashing mechanisms, etc.
604      *
605      * Emits a {Transfer} event.
606      *
607      * Requirements:
608      *
609      * - `sender` cannot be the zero address.
610      * - `recipient` cannot be the zero address.
611      * - `sender` must have a balance of at least `amount`.
612      */
613     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
614         require(sender != address(0), "ERC20: transfer from the zero address");
615         require(recipient != address(0), "ERC20: transfer to the zero address");
616 
617         _beforeTokenTransfer(sender, recipient, amount);
618 
619         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
620         _balances[recipient] = _balances[recipient].add(amount);
621         emit Transfer(sender, recipient, amount);
622     }
623 
624     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
625      * the total supply.
626      *
627      * Emits a {Transfer} event with `from` set to the zero address.
628      *
629      * Requirements
630      *
631      * - `to` cannot be the zero address.
632      */
633     function _mint(address account, uint256 amount) internal virtual {
634         require(account != address(0), "ERC20: mint to the zero address");
635 
636         _beforeTokenTransfer(address(0), account, amount);
637 
638         _totalSupply = _totalSupply.add(amount);
639         _balances[account] = _balances[account].add(amount);
640         emit Transfer(address(0), account, amount);
641     }
642 
643     /**
644      * @dev Destroys `amount` tokens from `account`, reducing the
645      * total supply.
646      *
647      * Emits a {Transfer} event with `to` set to the zero address.
648      *
649      * Requirements
650      *
651      * - `account` cannot be the zero address.
652      * - `account` must have at least `amount` tokens.
653      */
654     function _burn(address account, uint256 amount) internal virtual {
655         require(account != address(0), "ERC20: burn from the zero address");
656 
657         _beforeTokenTransfer(account, address(0), amount);
658 
659         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
660         _totalSupply = _totalSupply.sub(amount);
661         emit Transfer(account, address(0), amount);
662     }
663 
664     /**
665      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
666      *
667      * This is internal function is equivalent to `approve`, and can be used to
668      * e.g. set automatic allowances for certain subsystems, etc.
669      *
670      * Emits an {Approval} event.
671      *
672      * Requirements:
673      *
674      * - `owner` cannot be the zero address.
675      * - `spender` cannot be the zero address.
676      */
677     function _approve(address owner, address spender, uint256 amount) internal virtual {
678         require(owner != address(0), "ERC20: approve from the zero address");
679         require(spender != address(0), "ERC20: approve to the zero address");
680 
681         _allowances[owner][spender] = amount;
682         emit Approval(owner, spender, amount);
683     }
684 
685     /**
686      * @dev Sets {decimals} to a value other than the default one of 18.
687      *
688      * WARNING: This function should only be called from the constructor. Most
689      * applications that interact with token contracts will not expect
690      * {decimals} to ever change, and may work incorrectly if it does.
691      */
692     function _setupDecimals(uint8 decimals_) internal {
693         _decimals = decimals_;
694     }
695 
696     /**
697      * @dev Hook that is called before any transfer of tokens. This includes
698      * minting and burning.
699      *
700      * Calling conditions:
701      *
702      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
703      * will be to transferred to `to`.
704      * - when `from` is zero, `amount` tokens will be minted for `to`.
705      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
706      * - `from` and `to` are never both zero.
707      *
708      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
709      */
710     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
711 }
712 
713 /**
714  * @dev Extension of {ERC20} that allows token holders to destroy both their own
715  * tokens and those that they have an allowance for, in a way that can be
716  * recognized off-chain (via event analysis).
717  */
718 abstract contract ERC20Burnable is Context, ERC20 {
719     /**
720      * @dev Destroys `amount` tokens from the caller.
721      *
722      * See {ERC20-_burn}.
723      */
724     function burn(uint256 amount) public virtual {
725         _burn(_msgSender(), amount);
726     }
727 
728     /**
729      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
730      * allowance.
731      *
732      * See {ERC20-_burn} and {ERC20-allowance}.
733      *
734      * Requirements:
735      *
736      * - the caller must have allowance for ``accounts``'s tokens of at least
737      * `amount`.
738      */
739     function burnFrom(address account, uint256 amount) public virtual {
740         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
741 
742         _approve(account, _msgSender(), decreasedAllowance);
743         _burn(account, amount);
744     }
745 }
746 
747 
748 contract BirdToken is ERC20, ERC20Burnable {
749     string constant NAME    = 'Bird.Money';
750     string constant SYMBOL  = 'BIRD';
751     uint8 constant DECIMALS  = 18;
752     uint256 constant TOTAL_SUPPLY = 900_000 * 10**uint256(DECIMALS);
753 
754     constructor() ERC20(NAME, SYMBOL) public {
755         _mint(msg.sender, TOTAL_SUPPLY);
756     }
757 }