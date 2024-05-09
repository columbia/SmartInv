1 // SPDX-License-Identifier: GPL-3.0-or-later
2 
3 /**
4 
5 Author: CoFiX Core, https://cofix.io
6 Commit hash: v0.9.5-1-g7141c43
7 Repository: https://github.com/Computable-Finance/CoFiX
8 Issues: https://github.com/Computable-Finance/CoFiX/issues
9 
10 */
11 
12 pragma solidity 0.6.12;
13 
14 
15 // 
16 /*
17  * @dev Provides information about the current execution context, including the
18  * sender of the transaction and its data. While these are generally available
19  * via msg.sender and msg.data, they should not be accessed in such a direct
20  * manner, since when dealing with GSN meta-transactions the account sending and
21  * paying for execution may not be the actual sender (as far as an application
22  * is concerned).
23  *
24  * This contract is only required for intermediate, library-like contracts.
25  */
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address payable) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes memory) {
32         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
33         return msg.data;
34     }
35 }
36 
37 // 
38 /**
39  * @dev Interface of the ERC20 standard as defined in the EIP.
40  */
41 interface IERC20 {
42     /**
43      * @dev Returns the amount of tokens in existence.
44      */
45     function totalSupply() external view returns (uint256);
46 
47     /**
48      * @dev Returns the amount of tokens owned by `account`.
49      */
50     function balanceOf(address account) external view returns (uint256);
51 
52     /**
53      * @dev Moves `amount` tokens from the caller's account to `recipient`.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transfer(address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Returns the remaining number of tokens that `spender` will be
63      * allowed to spend on behalf of `owner` through {transferFrom}. This is
64      * zero by default.
65      *
66      * This value changes when {approve} or {transferFrom} are called.
67      */
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     /**
71      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * IMPORTANT: Beware that changing an allowance with this method brings the risk
76      * that someone may use both the old and the new allowance by unfortunate
77      * transaction ordering. One possible solution to mitigate this race
78      * condition is to first reduce the spender's allowance to 0 and set the
79      * desired value afterwards:
80      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
81      *
82      * Emits an {Approval} event.
83      */
84     function approve(address spender, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Moves `amount` tokens from `sender` to `recipient` using the
88      * allowance mechanism. `amount` is then deducted from the caller's
89      * allowance.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Emitted when `value` tokens are moved from one account (`from`) to
99      * another (`to`).
100      *
101      * Note that `value` may be zero.
102      */
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     /**
106      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
107      * a call to {approve}. `value` is the new allowance.
108      */
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 // 
113 /**
114  * @dev Wrappers over Solidity's arithmetic operations with added overflow
115  * checks.
116  *
117  * Arithmetic operations in Solidity wrap on overflow. This can easily result
118  * in bugs, because programmers usually assume that an overflow raises an
119  * error, which is the standard behavior in high level programming languages.
120  * `SafeMath` restores this intuition by reverting the transaction when an
121  * operation overflows.
122  *
123  * Using this library instead of the unchecked operations eliminates an entire
124  * class of bugs, so it's recommended to use it always.
125  */
126 library SafeMath {
127     /**
128      * @dev Returns the addition of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `+` operator.
132      *
133      * Requirements:
134      *
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      *
152      * - Subtraction cannot overflow.
153      */
154     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155         return sub(a, b, "SafeMath: subtraction overflow");
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * Counterpart to Solidity's `-` operator.
163      *
164      * Requirements:
165      *
166      * - Subtraction cannot overflow.
167      */
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      *
183      * - Multiplication cannot overflow.
184      */
185     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
186         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
187         // benefit is lost if 'b' is also tested.
188         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
189         if (a == 0) {
190             return 0;
191         }
192 
193         uint256 c = a * b;
194         require(c / a == b, "SafeMath: multiplication overflow");
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the integer division of two unsigned integers. Reverts on
201      * division by zero. The result is rounded towards zero.
202      *
203      * Counterpart to Solidity's `/` operator. Note: this function uses a
204      * `revert` opcode (which leaves remaining gas untouched) while Solidity
205      * uses an invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function div(uint256 a, uint256 b) internal pure returns (uint256) {
212         return div(a, b, "SafeMath: division by zero");
213     }
214 
215     /**
216      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
217      * division by zero. The result is rounded towards zero.
218      *
219      * Counterpart to Solidity's `/` operator. Note: this function uses a
220      * `revert` opcode (which leaves remaining gas untouched) while Solidity
221      * uses an invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
248         return mod(a, b, "SafeMath: modulo by zero");
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * Reverts with custom message when dividing by zero.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 // 
270 /**
271  * @dev Collection of functions related to the address type
272  */
273 library Address {
274     /**
275      * @dev Returns true if `account` is a contract.
276      *
277      * [IMPORTANT]
278      * ====
279      * It is unsafe to assume that an address for which this function returns
280      * false is an externally-owned account (EOA) and not a contract.
281      *
282      * Among others, `isContract` will return false for the following
283      * types of addresses:
284      *
285      *  - an externally-owned account
286      *  - a contract in construction
287      *  - an address where a contract will be created
288      *  - an address where a contract lived, but was destroyed
289      * ====
290      */
291     function isContract(address account) internal view returns (bool) {
292         // This method relies in extcodesize, which returns 0 for contracts in
293         // construction, since the code is only stored at the end of the
294         // constructor execution.
295 
296         uint256 size;
297         // solhint-disable-next-line no-inline-assembly
298         assembly { size := extcodesize(account) }
299         return size > 0;
300     }
301 
302     /**
303      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
304      * `recipient`, forwarding all available gas and reverting on errors.
305      *
306      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
307      * of certain opcodes, possibly making contracts go over the 2300 gas limit
308      * imposed by `transfer`, making them unable to receive funds via
309      * `transfer`. {sendValue} removes this limitation.
310      *
311      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
312      *
313      * IMPORTANT: because control is transferred to `recipient`, care must be
314      * taken to not create reentrancy vulnerabilities. Consider using
315      * {ReentrancyGuard} or the
316      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
317      */
318     function sendValue(address payable recipient, uint256 amount) internal {
319         require(address(this).balance >= amount, "Address: insufficient balance");
320 
321         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
322         (bool success, ) = recipient.call{ value: amount }("");
323         require(success, "Address: unable to send value, recipient may have reverted");
324     }
325 
326     /**
327      * @dev Performs a Solidity function call using a low level `call`. A
328      * plain`call` is an unsafe replacement for a function call: use this
329      * function instead.
330      *
331      * If `target` reverts with a revert reason, it is bubbled up by this
332      * function (like regular Solidity function calls).
333      *
334      * Returns the raw returned data. To convert to the expected return value,
335      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
336      *
337      * Requirements:
338      *
339      * - `target` must be a contract.
340      * - calling `target` with `data` must not revert.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
345       return functionCall(target, data, "Address: low-level call failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
350      * `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
355         return _functionCallWithValue(target, data, 0, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but also transferring `value` wei to `target`.
361      *
362      * Requirements:
363      *
364      * - the calling contract must have an ETH balance of at least `value`.
365      * - the called Solidity function must be `payable`.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
370         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
375      * with `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
380         require(address(this).balance >= value, "Address: insufficient balance for call");
381         return _functionCallWithValue(target, data, value, errorMessage);
382     }
383 
384     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
385         require(isContract(target), "Address: call to non-contract");
386 
387         // solhint-disable-next-line avoid-low-level-calls
388         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
389         if (success) {
390             return returndata;
391         } else {
392             // Look for revert reason and bubble it up if present
393             if (returndata.length > 0) {
394                 // The easiest way to bubble the revert reason is using memory via assembly
395 
396                 // solhint-disable-next-line no-inline-assembly
397                 assembly {
398                     let returndata_size := mload(returndata)
399                     revert(add(32, returndata), returndata_size)
400                 }
401             } else {
402                 revert(errorMessage);
403             }
404         }
405     }
406 }
407 
408 // 
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
437     mapping (address => uint256) private _balances;
438 
439     mapping (address => mapping (address => uint256)) private _allowances;
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
705     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
706 }
707 
708 // 
709 // CoFiToken with Governance. It offers possibilities to adopt off-chain gasless governance infra.
710 contract CoFiToken is ERC20("CoFi Token", "CoFi") {
711 
712     address public governance;
713     mapping (address => bool) public minters;
714 
715     // Copied and modified from SUSHI code:
716     // https://github.com/sushiswap/sushiswap/blob/master/contracts/SushiToken.sol
717     // Which is copied and modified from YAM code and COMPOUND:
718     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
719     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
720     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
721 
722     /// @dev A record of each accounts delegate
723     mapping (address => address) internal _delegates;
724 
725     /// @notice A checkpoint for marking number of votes from a given block
726     struct Checkpoint {
727         uint32 fromBlock;
728         uint256 votes;
729     }
730 
731     /// @notice A record of votes checkpoints for each account, by index
732     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
733 
734     /// @notice The number of checkpoints for each account
735     mapping (address => uint32) public numCheckpoints;
736 
737     /// @notice The EIP-712 typehash for the contract's domain
738     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
739 
740     /// @notice The EIP-712 typehash for the delegation struct used by the contract
741     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
742 
743     /// @notice A record of states for signing / validating signatures
744     mapping (address => uint) public nonces;
745 
746       /// @notice An event thats emitted when an account changes its delegate
747     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
748 
749     /// @notice An event thats emitted when a delegate account's vote balance changes
750     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
751 
752     /// @dev An event thats emitted when a new governance account is set
753     /// @param  _new The new governance address
754     event NewGovernance(address _new);
755 
756     /// @dev An event thats emitted when a new minter account is added
757     /// @param  _minter The new minter address added
758     event MinterAdded(address _minter);
759 
760     /// @dev An event thats emitted when a minter account is removed
761     /// @param  _minter The minter address removed
762     event MinterRemoved(address _minter);
763 
764     modifier onlyGovernance() {
765         require(msg.sender == governance, "CoFi: !governance");
766         _;
767     }
768 
769     constructor() public {
770         governance = msg.sender;
771     }
772 
773     function setGovernance(address _new) external onlyGovernance {
774         require(_new != address(0), "CoFi: zero addr");
775         require(_new != governance, "CoFi: same addr");
776         governance = _new;
777         emit NewGovernance(_new);
778     }
779 
780     function addMinter(address _minter) external onlyGovernance {
781         minters[_minter] = true;
782         emit MinterAdded(_minter);
783     }
784 
785     function removeMinter(address _minter) external onlyGovernance {
786         minters[_minter] = false;
787         emit MinterRemoved(_minter);
788     }
789 
790     /// @notice mint is used to distribute CoFi token to users, minters are CoFi mining pools
791     function mint(address _to, uint256 _amount) external {
792         require(minters[msg.sender], "CoFi: !minter");
793         _mint(_to, _amount);
794         _moveDelegates(address(0), _delegates[_to], _amount);
795     }
796 
797     /// @notice override original transfer to fix SUSHI's vote issue
798     /// check https://blog.peckshield.com/2020/09/08/sushi/
799     function transfer(address _recipient, uint256 _amount) public override returns (bool) {
800         super.transfer(_recipient, _amount);
801         _moveDelegates(_delegates[msg.sender], _delegates[_recipient], _amount);
802         return true;
803     }
804 
805     /// @notice override original transferFrom to fix SUSHI's vote issue
806     function transferFrom(address _sender, address _recipient, uint256 _amount) public override returns (bool) {
807         super.transferFrom(_sender, _recipient, _amount);
808         _moveDelegates(_delegates[_sender], _delegates[_recipient], _amount);
809         return true;
810     }
811 
812     /**
813      * @notice Delegate votes from `msg.sender` to `delegatee`
814      * @param delegator The address to get delegatee for
815      */
816     function delegates(address delegator)
817         external
818         view
819         returns (address)
820     {
821         return _delegates[delegator];
822     }
823 
824    /**
825     * @notice Delegate votes from `msg.sender` to `delegatee`
826     * @param delegatee The address to delegate votes to
827     */
828     function delegate(address delegatee) external {
829         return _delegate(msg.sender, delegatee);
830     }
831 
832     /**
833      * @notice Delegates votes from signatory to `delegatee`
834      * @param delegatee The address to delegate votes to
835      * @param nonce The contract state required to match the signature
836      * @param expiry The time at which to expire the signature
837      * @param v The recovery byte of the signature
838      * @param r Half of the ECDSA signature pair
839      * @param s Half of the ECDSA signature pair
840      */
841     function delegateBySig(
842         address delegatee,
843         uint nonce,
844         uint expiry,
845         uint8 v,
846         bytes32 r,
847         bytes32 s
848     )
849         external
850     {
851         bytes32 domainSeparator = keccak256(
852             abi.encode(
853                 DOMAIN_TYPEHASH,
854                 keccak256(bytes(name())),
855                 getChainId(),
856                 address(this)
857             )
858         );
859 
860         bytes32 structHash = keccak256(
861             abi.encode(
862                 DELEGATION_TYPEHASH,
863                 delegatee,
864                 nonce,
865                 expiry
866             )
867         );
868 
869         bytes32 digest = keccak256(
870             abi.encodePacked(
871                 "\x19\x01",
872                 domainSeparator,
873                 structHash
874             )
875         );
876 
877         address signatory = ecrecover(digest, v, r, s);
878         require(signatory != address(0), "CoFi::delegateBySig: invalid signature");
879         require(nonce == nonces[signatory]++, "CoFi::delegateBySig: invalid nonce");
880         require(now <= expiry, "CoFi::delegateBySig: signature expired");
881         return _delegate(signatory, delegatee);
882     }
883 
884     /**
885      * @notice Gets the current votes balance for `account`
886      * @param account The address to get votes balance
887      * @return The number of current votes for `account`
888      */
889     function getCurrentVotes(address account)
890         external
891         view
892         returns (uint256)
893     {
894         uint32 nCheckpoints = numCheckpoints[account];
895         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
896     }
897 
898     /**
899      * @notice Determine the prior number of votes for an account as of a block number
900      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
901      * @param account The address of the account to check
902      * @param blockNumber The block number to get the vote balance at
903      * @return The number of votes the account had as of the given block
904      */
905     function getPriorVotes(address account, uint blockNumber)
906         external
907         view
908         returns (uint256)
909     {
910         require(blockNumber < block.number, "CoFi::getPriorVotes: not yet determined");
911 
912         uint32 nCheckpoints = numCheckpoints[account];
913         if (nCheckpoints == 0) {
914             return 0;
915         }
916 
917         // First check most recent balance
918         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
919             return checkpoints[account][nCheckpoints - 1].votes;
920         }
921 
922         // Next check implicit zero balance
923         if (checkpoints[account][0].fromBlock > blockNumber) {
924             return 0;
925         }
926 
927         uint32 lower = 0;
928         uint32 upper = nCheckpoints - 1;
929         while (upper > lower) {
930             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
931             Checkpoint memory cp = checkpoints[account][center];
932             if (cp.fromBlock == blockNumber) {
933                 return cp.votes;
934             } else if (cp.fromBlock < blockNumber) {
935                 lower = center;
936             } else {
937                 upper = center - 1;
938             }
939         }
940         return checkpoints[account][lower].votes;
941     }
942 
943     function _delegate(address delegator, address delegatee)
944         internal
945     {
946         address currentDelegate = _delegates[delegator];
947         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying SUSHIs (not scaled);
948         _delegates[delegator] = delegatee;
949 
950         emit DelegateChanged(delegator, currentDelegate, delegatee);
951 
952         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
953     }
954 
955     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
956         if (srcRep != dstRep && amount > 0) {
957             if (srcRep != address(0)) {
958                 // decrease old representative
959                 uint32 srcRepNum = numCheckpoints[srcRep];
960                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
961                 uint256 srcRepNew = srcRepOld.sub(amount);
962                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
963             }
964 
965             if (dstRep != address(0)) {
966                 // increase new representative
967                 uint32 dstRepNum = numCheckpoints[dstRep];
968                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
969                 uint256 dstRepNew = dstRepOld.add(amount);
970                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
971             }
972         }
973     }
974 
975     function _writeCheckpoint(
976         address delegatee,
977         uint32 nCheckpoints,
978         uint256 oldVotes,
979         uint256 newVotes
980     )
981         internal
982     {
983         uint32 blockNumber = safe32(block.number, "CoFi::_writeCheckpoint: block number exceeds 32 bits");
984 
985         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
986             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
987         } else {
988             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
989             numCheckpoints[delegatee] = nCheckpoints + 1;
990         }
991 
992         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
993     }
994 
995     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
996         require(n < 2**32, errorMessage);
997         return uint32(n);
998     }
999 
1000     function getChainId() internal pure returns (uint) {
1001         uint256 chainId;
1002         assembly { chainId := chainid() }
1003         return chainId;
1004     }
1005 }