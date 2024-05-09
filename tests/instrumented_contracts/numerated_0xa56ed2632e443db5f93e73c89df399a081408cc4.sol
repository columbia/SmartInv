1 /*
2  *
3  ██████╗  ██████╗ ██╗     ██████╗     ██╗  ██╗ ██████╗ ███████╗     ██████╗ ███╗   ██╗███████╗
4 ██╔════╝ ██╔═══██╗██║     ██╔══██╗    ██║  ██║██╔═══██╗██╔════╝    ██╔═══██╗████╗  ██║██╔════╝
5 ██║  ███╗██║   ██║██║     ██║  ██║    ███████║██║   ██║█████╗      ██║   ██║██╔██╗ ██║█████╗  
6 ██║   ██║██║   ██║██║     ██║  ██║    ██╔══██║██║   ██║██╔══╝      ██║   ██║██║╚██╗██║██╔══╝  
7 ╚██████╔╝╚██████╔╝███████╗██████╔╝    ██║  ██║╚██████╔╝███████╗    ╚██████╔╝██║ ╚████║███████╗
8  ╚═════╝  ╚═════╝ ╚══════╝╚═════╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝     ╚═════╝ ╚═╝  ╚═══╝╚══════╝                                                                                              
9 
10                Tribute to Satoshi Nakamoto in 2008 and Vitalik Buterin in 2011.
11                                 - Decentralized believer, PROX.
12  *
13  */
14 
15 pragma solidity ^0.6.0;
16 
17 // SPDX-License-Identifier: MIT
18 
19 /*
20  * @dev Provides information about the current execution context, including the
21  * sender of the transaction and its data. While these are generally available
22  * via msg.sender and msg.data, they should not be accessed in such a direct
23  * manner, since when dealing with GSN meta-transactions the account sending and
24  * paying for execution may not be the actual sender (as far as an application
25  * is concerned).
26  *
27  * This contract is only required for intermediate, library-like contracts.
28  */
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address payable) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes memory) {
35         this;
36         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
37         return msg.data;
38     }
39 }
40 
41 /**
42  * @dev Interface of the ERC20 standard as defined in the EIP.
43  */
44 interface IERC20 {
45     /**
46      * @dev Returns the amount of tokens in existence.
47      */
48     function totalSupply() external view returns (uint256);
49 
50     /**
51      * @dev Returns the amount of tokens owned by `account`.
52      */
53     function balanceOf(address account) external view returns (uint256);
54 
55     /**
56      * @dev Moves `amount` tokens from the caller's account to `recipient`.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transfer(address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Returns the remaining number of tokens that `spender` will be
66      * allowed to spend on behalf of `owner` through {transferFrom}. This is
67      * zero by default.
68      *
69      * This value changes when {approve} or {transferFrom} are called.
70      */
71     function allowance(address owner, address spender) external view returns (uint256);
72 
73     /**
74      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * IMPORTANT: Beware that changing an allowance with this method brings the risk
79      * that someone may use both the old and the new allowance by unfortunate
80      * transaction ordering. One possible solution to mitigate this race
81      * condition is to first reduce the spender's allowance to 0 and set the
82      * desired value afterwards:
83      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
84      *
85      * Emits an {Approval} event.
86      */
87     function approve(address spender, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Moves `amount` tokens from `sender` to `recipient` using the
91      * allowance mechanism. `amount` is then deducted from the caller's
92      * allowance.
93      *
94      * Returns a boolean value indicating whether the operation succeeded.
95      *
96      * Emits a {Transfer} event.
97      */
98     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
99 
100     /**
101      * @dev Emitted when `value` tokens are moved from one account (`from`) to
102      * another (`to`).
103      *
104      * Note that `value` may be zero.
105      */
106     event Transfer(address indexed from, address indexed to, uint256 value);
107 
108     /**
109      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
110      * a call to {approve}. `value` is the new allowance.
111      */
112     event Approval(address indexed owner, address indexed spender, uint256 value);
113 }
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
129     /**
130      * @dev Returns the addition of two unsigned integers, reverting on
131      * overflow.
132      *
133      * Counterpart to Solidity's `+` operator.
134      *
135      * Requirements:
136      *
137      * - Addition cannot overflow.
138      */
139     function add(uint256 a, uint256 b) internal pure returns (uint256) {
140         uint256 c = a + b;
141         require(c >= a, "SafeMath: addition overflow");
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
157         return sub(a, b, "SafeMath: subtraction overflow");
158     }
159 
160     /**
161      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
162      * overflow (when the result is negative).
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b <= a, errorMessage);
172         uint256 c = a - b;
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the multiplication of two unsigned integers, reverting on
179      * overflow.
180      *
181      * Counterpart to Solidity's `*` operator.
182      *
183      * Requirements:
184      *
185      * - Multiplication cannot overflow.
186      */
187     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
188         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
189         // benefit is lost if 'b' is also tested.
190         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
191         if (a == 0) {
192             return 0;
193         }
194 
195         uint256 c = a * b;
196         require(c / a == b, "SafeMath: multiplication overflow");
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers. Reverts on
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
213     function div(uint256 a, uint256 b) internal pure returns (uint256) {
214         return div(a, b, "SafeMath: division by zero");
215     }
216 
217     /**
218      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
219      * division by zero. The result is rounded towards zero.
220      *
221      * Counterpart to Solidity's `/` operator. Note: this function uses a
222      * `revert` opcode (which leaves remaining gas untouched) while Solidity
223      * uses an invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b > 0, errorMessage);
231         uint256 c = a / b;
232         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
250         return mod(a, b, "SafeMath: modulo by zero");
251     }
252 
253     /**
254      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
255      * Reverts with custom message when dividing by zero.
256      *
257      * Counterpart to Solidity's `%` operator. This function uses a `revert`
258      * opcode (which leaves remaining gas untouched) while Solidity uses an
259      * invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b != 0, errorMessage);
267         return a % b;
268     }
269 }
270 
271 /**
272  * @dev Collection of functions related to the address type
273  */
274 library Address {
275     /**
276      * @dev Returns true if `account` is a contract.
277      *
278      * [IMPORTANT]
279      * ====
280      * It is unsafe to assume that an address for which this function returns
281      * false is an externally-owned account (EOA) and not a contract.
282      *
283      * Among others, `isContract` will return false for the following
284      * types of addresses:
285      *
286      *  - an externally-owned account
287      *  - a contract in construction
288      *  - an address where a contract will be created
289      *  - an address where a contract lived, but was destroyed
290      * ====
291      */
292     function isContract(address account) internal view returns (bool) {
293         // This method relies in extcodesize, which returns 0 for contracts in
294         // construction, since the code is only stored at the end of the
295         // constructor execution.
296 
297         uint256 size;
298         // solhint-disable-next-line no-inline-assembly
299         assembly {size := extcodesize(account)}
300         return size > 0;
301     }
302 
303     /**
304      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
305      * `recipient`, forwarding all available gas and reverting on errors.
306      *
307      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
308      * of certain opcodes, possibly making contracts go over the 2300 gas limit
309      * imposed by `transfer`, making them unable to receive funds via
310      * `transfer`. {sendValue} removes this limitation.
311      *
312      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
313      *
314      * IMPORTANT: because control is transferred to `recipient`, care must be
315      * taken to not create reentrancy vulnerabilities. Consider using
316      * {ReentrancyGuard} or the
317      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
318      */
319     function sendValue(address payable recipient, uint256 amount) internal {
320         require(address(this).balance >= amount, "Address: insufficient balance");
321 
322         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
323         (bool success,) = recipient.call{value : amount}("");
324         require(success, "Address: unable to send value, recipient may have reverted");
325     }
326 
327     /**
328      * @dev Performs a Solidity function call using a low level `call`. A
329      * plain`call` is an unsafe replacement for a function call: use this
330      * function instead.
331      *
332      * If `target` reverts with a revert reason, it is bubbled up by this
333      * function (like regular Solidity function calls).
334      *
335      * Returns the raw returned data. To convert to the expected return value,
336      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
337      *
338      * Requirements:
339      *
340      * - `target` must be a contract.
341      * - calling `target` with `data` must not revert.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
346         return functionCall(target, data, "Address: low-level call failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
351      * `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
356         return _functionCallWithValue(target, data, 0, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but also transferring `value` wei to `target`.
362      *
363      * Requirements:
364      *
365      * - the calling contract must have an ETH balance of at least `value`.
366      * - the called Solidity function must be `payable`.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
371         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
376      * with `errorMessage` as a fallback revert reason when `target` reverts.
377      *
378      * _Available since v3.1._
379      */
380     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
381         require(address(this).balance >= value, "Address: insufficient balance for call");
382         return _functionCallWithValue(target, data, value, errorMessage);
383     }
384 
385     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
386         require(isContract(target), "Address: call to non-contract");
387 
388         // solhint-disable-next-line avoid-low-level-calls
389         (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
390         if (success) {
391             return returndata;
392         } else {
393             // Look for revert reason and bubble it up if present
394             if (returndata.length > 0) {
395                 // The easiest way to bubble the revert reason is using memory via assembly
396 
397                 // solhint-disable-next-line no-inline-assembly
398                 assembly {
399                     let returndata_size := mload(returndata)
400                     revert(add(32, returndata), returndata_size)
401                 }
402             } else {
403                 revert(errorMessage);
404             }
405         }
406     }
407 }
408 
409 /**
410  * @dev Implementation of the {IERC20} interface.
411  *
412  * This implementation is agnostic to the way tokens are created. This means
413  * that a supply mechanism has to be added in a derived contract using {_mint}.
414  * For a generic mechanism see {ERC20PresetMinterPauser}.
415  *
416  * TIP: For a detailed writeup see our guide
417  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
418  * to implement supply mechanisms].
419  *
420  * We have followed general OpenZeppelin guidelines: functions revert instead
421  * of returning `false` on failure. This behavior is nonetheless conventional
422  * and does not conflict with the expectations of ERC20 applications.
423  *
424  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
425  * This allows applications to reconstruct the allowance for all accounts just
426  * by listening to said events. Other implementations of the EIP may not emit
427  * these events, as it isn't required by the specification.
428  *
429  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
430  * functions have been added to mitigate the well-known issues around setting
431  * allowances. See {IERC20-approve}.
432  */
433 contract ERC20 is Context, IERC20 {
434     using SafeMath for uint256;
435     using Address for address;
436 
437     mapping(address => uint256) private _balances;
438 
439     mapping(address => mapping(address => uint256)) private _allowances;
440 
441     uint256 private _totalSupply;
442 
443     string private _name;
444     string private _symbol;
445     uint8 private _decimals;
446 
447     /**
448      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
449      * a default value of 18.
450      *
451      * To select a different value for {decimals}, use {_setupDecimals}.
452      *
453      * All three of these values are immutable: they can only be set once during
454      * construction.
455      */
456     constructor (string memory name, string memory symbol) public {
457         _name = name;
458         _symbol = symbol;
459         _decimals = 18;
460     }
461 
462     /**
463      * @dev Returns the name of the token.
464      */
465     function name() public view returns (string memory) {
466         return _name;
467     }
468 
469     /**
470      * @dev Returns the symbol of the token, usually a shorter version of the
471      * name.
472      */
473     function symbol() public view returns (string memory) {
474         return _symbol;
475     }
476 
477     /**
478      * @dev Returns the number of decimals used to get its user representation.
479      * For example, if `decimals` equals `2`, a balance of `505` tokens should
480      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
481      *
482      * Tokens usually opt for a value of 18, imitating the relationship between
483      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
484      * called.
485      *
486      * NOTE: This information is only used for _display_ purposes: it in
487      * no way affects any of the arithmetic of the contract, including
488      * {IERC20-balanceOf} and {IERC20-transfer}.
489      */
490     function decimals() public view returns (uint8) {
491         return _decimals;
492     }
493 
494     /**
495      * @dev See {IERC20-totalSupply}.
496      */
497     function totalSupply() public view override returns (uint256) {
498         return _totalSupply;
499     }
500 
501     /**
502      * @dev See {IERC20-balanceOf}.
503      */
504     function balanceOf(address account) public view override returns (uint256) {
505         return _balances[account];
506     }
507 
508     /**
509      * @dev See {IERC20-transfer}.
510      *
511      * Requirements:
512      *
513      * - `recipient` cannot be the zero address.
514      * - the caller must have a balance of at least `amount`.
515      */
516     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
517         _transfer(_msgSender(), recipient, amount);
518         return true;
519     }
520 
521     /**
522      * @dev See {IERC20-allowance}.
523      */
524     function allowance(address owner, address spender) public view virtual override returns (uint256) {
525         return _allowances[owner][spender];
526     }
527 
528     /**
529      * @dev See {IERC20-approve}.
530      *
531      * Requirements:
532      *
533      * - `spender` cannot be the zero address.
534      */
535     function approve(address spender, uint256 amount) public virtual override returns (bool) {
536         _approve(_msgSender(), spender, amount);
537         return true;
538     }
539 
540     /**
541      * @dev See {IERC20-transferFrom}.
542      *
543      * Emits an {Approval} event indicating the updated allowance. This is not
544      * required by the EIP. See the note at the beginning of {ERC20};
545      *
546      * Requirements:
547      * - `sender` and `recipient` cannot be the zero address.
548      * - `sender` must have a balance of at least `amount`.
549      * - the caller must have allowance for ``sender``'s tokens of at least
550      * `amount`.
551      */
552     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
553         _transfer(sender, recipient, amount);
554         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
555         return true;
556     }
557 
558     /**
559      * @dev Atomically increases the allowance granted to `spender` by the caller.
560      *
561      * This is an alternative to {approve} that can be used as a mitigation for
562      * problems described in {IERC20-approve}.
563      *
564      * Emits an {Approval} event indicating the updated allowance.
565      *
566      * Requirements:
567      *
568      * - `spender` cannot be the zero address.
569      */
570     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
571         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
572         return true;
573     }
574 
575     /**
576      * @dev Atomically decreases the allowance granted to `spender` by the caller.
577      *
578      * This is an alternative to {approve} that can be used as a mitigation for
579      * problems described in {IERC20-approve}.
580      *
581      * Emits an {Approval} event indicating the updated allowance.
582      *
583      * Requirements:
584      *
585      * - `spender` cannot be the zero address.
586      * - `spender` must have allowance for the caller of at least
587      * `subtractedValue`.
588      */
589     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
590         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
591         return true;
592     }
593 
594     /**
595      * @dev Moves tokens `amount` from `sender` to `recipient`.
596      *
597      * This is internal function is equivalent to {transfer}, and can be used to
598      * e.g. implement automatic token fees, slashing mechanisms, etc.
599      *
600      * Emits a {Transfer} event.
601      *
602      * Requirements:
603      *
604      * - `sender` cannot be the zero address.
605      * - `recipient` cannot be the zero address.
606      * - `sender` must have a balance of at least `amount`.
607      */
608     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
609         require(sender != address(0), "ERC20: transfer from the zero address");
610         require(recipient != address(0), "ERC20: transfer to the zero address");
611 
612         _beforeTokenTransfer(sender, recipient, amount);
613 
614         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
615         _balances[recipient] = _balances[recipient].add(amount);
616         emit Transfer(sender, recipient, amount);
617     }
618 
619     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
620      * the total supply.
621      *
622      * Emits a {Transfer} event with `from` set to the zero address.
623      *
624      * Requirements
625      *
626      * - `to` cannot be the zero address.
627      */
628     function _mint(address account, uint256 amount) internal virtual {
629         require(account != address(0), "ERC20: mint to the zero address");
630 
631         _beforeTokenTransfer(address(0), account, amount);
632 
633         _totalSupply = _totalSupply.add(amount);
634         _balances[account] = _balances[account].add(amount);
635         emit Transfer(address(0), account, amount);
636     }
637 
638     /**
639      * @dev Destroys `amount` tokens from `account`, reducing the
640      * total supply.
641      *
642      * Emits a {Transfer} event with `to` set to the zero address.
643      *
644      * Requirements
645      *
646      * - `account` cannot be the zero address.
647      * - `account` must have at least `amount` tokens.
648      */
649     function _burn(address account, uint256 amount) internal virtual {
650         require(account != address(0), "ERC20: burn from the zero address");
651 
652         _beforeTokenTransfer(account, address(0), amount);
653 
654         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
655         _totalSupply = _totalSupply.sub(amount);
656         emit Transfer(account, address(0), amount);
657     }
658 
659     /**
660      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
661      *
662      * This internal function is equivalent to `approve`, and can be used to
663      * e.g. set automatic allowances for certain subsystems, etc.
664      *
665      * Emits an {Approval} event.
666      *
667      * Requirements:
668      *
669      * - `owner` cannot be the zero address.
670      * - `spender` cannot be the zero address.
671      */
672     function _approve(address owner, address spender, uint256 amount) internal virtual {
673         require(owner != address(0), "ERC20: approve from the zero address");
674         require(spender != address(0), "ERC20: approve to the zero address");
675 
676         _allowances[owner][spender] = amount;
677         emit Approval(owner, spender, amount);
678     }
679 
680     /**
681      * @dev Sets {decimals} to a value other than the default one of 18.
682      *
683      * WARNING: This function should only be called from the constructor. Most
684      * applications that interact with token contracts will not expect
685      * {decimals} to ever change, and may work incorrectly if it does.
686      */
687     function _setupDecimals(uint8 decimals_) internal {
688         _decimals = decimals_;
689     }
690 
691     /**
692      * @dev Hook that is called before any transfer of tokens. This includes
693      * minting and burning.
694      *
695      * Calling conditions:
696      *
697      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
698      * will be to transferred to `to`.
699      * - when `from` is zero, `amount` tokens will be minted for `to`.
700      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
701      * - `from` and `to` are never both zero.
702      *
703      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
704      */
705     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
706 }
707 
708 contract GoldHoeOne is ERC20 {
709     string public constant TOKEN_NAME = "Gold Hoe One";
710     string public constant TOKEN_SYMBOL = "HOE";
711     uint256 public constant TOKEN_SUPPLY = 80000;
712 
713     constructor() ERC20(TOKEN_NAME, TOKEN_SYMBOL) public {
714         _mint(msg.sender, TOKEN_SUPPLY * 10 ** uint256(decimals()));
715     }
716 }