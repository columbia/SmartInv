1 // SPDX-License-Identifier: NONE
2 
3 pragma solidity 0.6.12;
4 
5 
6 
7 // Part: IKongz
8 
9 interface IKongz {
10 	function balanceOG(address _user) external view returns(uint256);
11 }
12 
13 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Address
14 
15 /**
16  * @dev Collection of functions related to the address type
17  */
18 library Address {
19     /**
20      * @dev Returns true if `account` is a contract.
21      *
22      * [IMPORTANT]
23      * ====
24      * It is unsafe to assume that an address for which this function returns
25      * false is an externally-owned account (EOA) and not a contract.
26      *
27      * Among others, `isContract` will return false for the following
28      * types of addresses:
29      *
30      *  - an externally-owned account
31      *  - a contract in construction
32      *  - an address where a contract will be created
33      *  - an address where a contract lived, but was destroyed
34      * ====
35      */
36     function isContract(address account) internal view returns (bool) {
37         // This method relies in extcodesize, which returns 0 for contracts in
38         // construction, since the code is only stored at the end of the
39         // constructor execution.
40 
41         uint256 size;
42         // solhint-disable-next-line no-inline-assembly
43         assembly { size := extcodesize(account) }
44         return size > 0;
45     }
46 
47     /**
48      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
49      * `recipient`, forwarding all available gas and reverting on errors.
50      *
51      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
52      * of certain opcodes, possibly making contracts go over the 2300 gas limit
53      * imposed by `transfer`, making them unable to receive funds via
54      * `transfer`. {sendValue} removes this limitation.
55      *
56      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
57      *
58      * IMPORTANT: because control is transferred to `recipient`, care must be
59      * taken to not create reentrancy vulnerabilities. Consider using
60      * {ReentrancyGuard} or the
61      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
62      */
63     function sendValue(address payable recipient, uint256 amount) internal {
64         require(address(this).balance >= amount, "Address: insufficient balance");
65 
66         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
67         (bool success, ) = recipient.call{ value: amount }("");
68         require(success, "Address: unable to send value, recipient may have reverted");
69     }
70 
71     /**
72      * @dev Performs a Solidity function call using a low level `call`. A
73      * plain`call` is an unsafe replacement for a function call: use this
74      * function instead.
75      *
76      * If `target` reverts with a revert reason, it is bubbled up by this
77      * function (like regular Solidity function calls).
78      *
79      * Returns the raw returned data. To convert to the expected return value,
80      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
81      *
82      * Requirements:
83      *
84      * - `target` must be a contract.
85      * - calling `target` with `data` must not revert.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
90       return functionCall(target, data, "Address: low-level call failed");
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
95      * `errorMessage` as a fallback revert reason when `target` reverts.
96      *
97      * _Available since v3.1._
98      */
99     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
100         return _functionCallWithValue(target, data, 0, errorMessage);
101     }
102 
103     /**
104      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
105      * but also transferring `value` wei to `target`.
106      *
107      * Requirements:
108      *
109      * - the calling contract must have an ETH balance of at least `value`.
110      * - the called Solidity function must be `payable`.
111      *
112      * _Available since v3.1._
113      */
114     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
115         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
116     }
117 
118     /**
119      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
120      * with `errorMessage` as a fallback revert reason when `target` reverts.
121      *
122      * _Available since v3.1._
123      */
124     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
125         require(address(this).balance >= value, "Address: insufficient balance for call");
126         return _functionCallWithValue(target, data, value, errorMessage);
127     }
128 
129     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
130         require(isContract(target), "Address: call to non-contract");
131 
132         // solhint-disable-next-line avoid-low-level-calls
133         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
134         if (success) {
135             return returndata;
136         } else {
137             // Look for revert reason and bubble it up if present
138             if (returndata.length > 0) {
139                 // The easiest way to bubble the revert reason is using memory via assembly
140 
141                 // solhint-disable-next-line no-inline-assembly
142                 assembly {
143                     let returndata_size := mload(returndata)
144                     revert(add(32, returndata), returndata_size)
145                 }
146             } else {
147                 revert(errorMessage);
148             }
149         }
150     }
151 }
152 
153 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Context
154 
155 /*
156  * @dev Provides information about the current execution context, including the
157  * sender of the transaction and its data. While these are generally available
158  * via msg.sender and msg.data, they should not be accessed in such a direct
159  * manner, since when dealing with GSN meta-transactions the account sending and
160  * paying for execution may not be the actual sender (as far as an application
161  * is concerned).
162  *
163  * This contract is only required for intermediate, library-like contracts.
164  */
165 abstract contract Context {
166     function _msgSender() internal view virtual returns (address payable) {
167         return msg.sender;
168     }
169 
170     function _msgData() internal view virtual returns (bytes memory) {
171         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
172         return msg.data;
173     }
174 }
175 
176 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC20
177 
178 /**
179  * @dev Interface of the ERC20 standard as defined in the EIP.
180  */
181 interface IERC20 {
182     /**
183      * @dev Returns the amount of tokens in existence.
184      */
185     function totalSupply() external view returns (uint256);
186 
187     /**
188      * @dev Returns the amount of tokens owned by `account`.
189      */
190     function balanceOf(address account) external view returns (uint256);
191 
192     /**
193      * @dev Moves `amount` tokens from the caller's account to `recipient`.
194      *
195      * Returns a boolean value indicating whether the operation succeeded.
196      *
197      * Emits a {Transfer} event.
198      */
199     function transfer(address recipient, uint256 amount) external returns (bool);
200 
201     /**
202      * @dev Returns the remaining number of tokens that `spender` will be
203      * allowed to spend on behalf of `owner` through {transferFrom}. This is
204      * zero by default.
205      *
206      * This value changes when {approve} or {transferFrom} are called.
207      */
208     function allowance(address owner, address spender) external view returns (uint256);
209 
210     /**
211      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
212      *
213      * Returns a boolean value indicating whether the operation succeeded.
214      *
215      * IMPORTANT: Beware that changing an allowance with this method brings the risk
216      * that someone may use both the old and the new allowance by unfortunate
217      * transaction ordering. One possible solution to mitigate this race
218      * condition is to first reduce the spender's allowance to 0 and set the
219      * desired value afterwards:
220      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221      *
222      * Emits an {Approval} event.
223      */
224     function approve(address spender, uint256 amount) external returns (bool);
225 
226     /**
227      * @dev Moves `amount` tokens from `sender` to `recipient` using the
228      * allowance mechanism. `amount` is then deducted from the caller's
229      * allowance.
230      *
231      * Returns a boolean value indicating whether the operation succeeded.
232      *
233      * Emits a {Transfer} event.
234      */
235     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
236 
237     /**
238      * @dev Emitted when `value` tokens are moved from one account (`from`) to
239      * another (`to`).
240      *
241      * Note that `value` may be zero.
242      */
243     event Transfer(address indexed from, address indexed to, uint256 value);
244 
245     /**
246      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
247      * a call to {approve}. `value` is the new allowance.
248      */
249     event Approval(address indexed owner, address indexed spender, uint256 value);
250 }
251 
252 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/SafeMath
253 
254 /**
255  * @dev Wrappers over Solidity's arithmetic operations with added overflow
256  * checks.
257  *
258  * Arithmetic operations in Solidity wrap on overflow. This can easily result
259  * in bugs, because programmers usually assume that an overflow raises an
260  * error, which is the standard behavior in high level programming languages.
261  * `SafeMath` restores this intuition by reverting the transaction when an
262  * operation overflows.
263  *
264  * Using this library instead of the unchecked operations eliminates an entire
265  * class of bugs, so it's recommended to use it always.
266  */
267 library SafeMath {
268     /**
269      * @dev Returns the addition of two unsigned integers, reverting on
270      * overflow.
271      *
272      * Counterpart to Solidity's `+` operator.
273      *
274      * Requirements:
275      *
276      * - Addition cannot overflow.
277      */
278     function add(uint256 a, uint256 b) internal pure returns (uint256) {
279         uint256 c = a + b;
280         require(c >= a, "SafeMath: addition overflow");
281 
282         return c;
283     }
284 
285     /**
286      * @dev Returns the subtraction of two unsigned integers, reverting on
287      * overflow (when the result is negative).
288      *
289      * Counterpart to Solidity's `-` operator.
290      *
291      * Requirements:
292      *
293      * - Subtraction cannot overflow.
294      */
295     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
296         return sub(a, b, "SafeMath: subtraction overflow");
297     }
298 
299     /**
300      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
301      * overflow (when the result is negative).
302      *
303      * Counterpart to Solidity's `-` operator.
304      *
305      * Requirements:
306      *
307      * - Subtraction cannot overflow.
308      */
309     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
310         require(b <= a, errorMessage);
311         uint256 c = a - b;
312 
313         return c;
314     }
315 
316     /**
317      * @dev Returns the multiplication of two unsigned integers, reverting on
318      * overflow.
319      *
320      * Counterpart to Solidity's `*` operator.
321      *
322      * Requirements:
323      *
324      * - Multiplication cannot overflow.
325      */
326     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
327         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
328         // benefit is lost if 'b' is also tested.
329         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
330         if (a == 0) {
331             return 0;
332         }
333 
334         uint256 c = a * b;
335         require(c / a == b, "SafeMath: multiplication overflow");
336 
337         return c;
338     }
339 
340     /**
341      * @dev Returns the integer division of two unsigned integers. Reverts on
342      * division by zero. The result is rounded towards zero.
343      *
344      * Counterpart to Solidity's `/` operator. Note: this function uses a
345      * `revert` opcode (which leaves remaining gas untouched) while Solidity
346      * uses an invalid opcode to revert (consuming all remaining gas).
347      *
348      * Requirements:
349      *
350      * - The divisor cannot be zero.
351      */
352     function div(uint256 a, uint256 b) internal pure returns (uint256) {
353         return div(a, b, "SafeMath: division by zero");
354     }
355 
356     /**
357      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
358      * division by zero. The result is rounded towards zero.
359      *
360      * Counterpart to Solidity's `/` operator. Note: this function uses a
361      * `revert` opcode (which leaves remaining gas untouched) while Solidity
362      * uses an invalid opcode to revert (consuming all remaining gas).
363      *
364      * Requirements:
365      *
366      * - The divisor cannot be zero.
367      */
368     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
369         require(b > 0, errorMessage);
370         uint256 c = a / b;
371         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
372 
373         return c;
374     }
375 
376     /**
377      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
378      * Reverts when dividing by zero.
379      *
380      * Counterpart to Solidity's `%` operator. This function uses a `revert`
381      * opcode (which leaves remaining gas untouched) while Solidity uses an
382      * invalid opcode to revert (consuming all remaining gas).
383      *
384      * Requirements:
385      *
386      * - The divisor cannot be zero.
387      */
388     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
389         return mod(a, b, "SafeMath: modulo by zero");
390     }
391 
392     /**
393      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
394      * Reverts with custom message when dividing by zero.
395      *
396      * Counterpart to Solidity's `%` operator. This function uses a `revert`
397      * opcode (which leaves remaining gas untouched) while Solidity uses an
398      * invalid opcode to revert (consuming all remaining gas).
399      *
400      * Requirements:
401      *
402      * - The divisor cannot be zero.
403      */
404     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
405         require(b != 0, errorMessage);
406         return a % b;
407     }
408 }
409 
410 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/ERC20
411 
412 /**
413  * @dev Implementation of the {IERC20} interface.
414  *
415  * This implementation is agnostic to the way tokens are created. This means
416  * that a supply mechanism has to be added in a derived contract using {_mint}.
417  * For a generic mechanism see {ERC20PresetMinterPauser}.
418  *
419  * TIP: For a detailed writeup see our guide
420  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
421  * to implement supply mechanisms].
422  *
423  * We have followed general OpenZeppelin guidelines: functions revert instead
424  * of returning `false` on failure. This behavior is nonetheless conventional
425  * and does not conflict with the expectations of ERC20 applications.
426  *
427  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
428  * This allows applications to reconstruct the allowance for all accounts just
429  * by listening to said events. Other implementations of the EIP may not emit
430  * these events, as it isn't required by the specification.
431  *
432  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
433  * functions have been added to mitigate the well-known issues around setting
434  * allowances. See {IERC20-approve}.
435  */
436 contract ERC20 is Context, IERC20 {
437     using SafeMath for uint256;
438     using Address for address;
439 
440     mapping (address => uint256) private _balances;
441 
442     mapping (address => mapping (address => uint256)) private _allowances;
443 
444     uint256 private _totalSupply;
445 
446     string private _name;
447     string private _symbol;
448     uint8 private _decimals;
449 
450     /**
451      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
452      * a default value of 18.
453      *
454      * To select a different value for {decimals}, use {_setupDecimals}.
455      *
456      * All three of these values are immutable: they can only be set once during
457      * construction.
458      */
459     constructor (string memory name, string memory symbol) public {
460         _name = name;
461         _symbol = symbol;
462         _decimals = 18;
463     }
464 
465     /**
466      * @dev Returns the name of the token.
467      */
468     function name() public view returns (string memory) {
469         return _name;
470     }
471 
472     /**
473      * @dev Returns the symbol of the token, usually a shorter version of the
474      * name.
475      */
476     function symbol() public view returns (string memory) {
477         return _symbol;
478     }
479 
480     /**
481      * @dev Returns the number of decimals used to get its user representation.
482      * For example, if `decimals` equals `2`, a balance of `505` tokens should
483      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
484      *
485      * Tokens usually opt for a value of 18, imitating the relationship between
486      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
487      * called.
488      *
489      * NOTE: This information is only used for _display_ purposes: it in
490      * no way affects any of the arithmetic of the contract, including
491      * {IERC20-balanceOf} and {IERC20-transfer}.
492      */
493     function decimals() public view returns (uint8) {
494         return _decimals;
495     }
496 
497     /**
498      * @dev See {IERC20-totalSupply}.
499      */
500     function totalSupply() public view override returns (uint256) {
501         return _totalSupply;
502     }
503 
504     /**
505      * @dev See {IERC20-balanceOf}.
506      */
507     function balanceOf(address account) public view override returns (uint256) {
508         return _balances[account];
509     }
510 
511     /**
512      * @dev See {IERC20-transfer}.
513      *
514      * Requirements:
515      *
516      * - `recipient` cannot be the zero address.
517      * - the caller must have a balance of at least `amount`.
518      */
519     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
520         _transfer(_msgSender(), recipient, amount);
521         return true;
522     }
523 
524     /**
525      * @dev See {IERC20-allowance}.
526      */
527     function allowance(address owner, address spender) public view virtual override returns (uint256) {
528         return _allowances[owner][spender];
529     }
530 
531     /**
532      * @dev See {IERC20-approve}.
533      *
534      * Requirements:
535      *
536      * - `spender` cannot be the zero address.
537      */
538     function approve(address spender, uint256 amount) public virtual override returns (bool) {
539         _approve(_msgSender(), spender, amount);
540         return true;
541     }
542 
543     /**
544      * @dev See {IERC20-transferFrom}.
545      *
546      * Emits an {Approval} event indicating the updated allowance. This is not
547      * required by the EIP. See the note at the beginning of {ERC20};
548      *
549      * Requirements:
550      * - `sender` and `recipient` cannot be the zero address.
551      * - `sender` must have a balance of at least `amount`.
552      * - the caller must have allowance for ``sender``'s tokens of at least
553      * `amount`.
554      */
555     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
556         _transfer(sender, recipient, amount);
557         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
558         return true;
559     }
560 
561     /**
562      * @dev Atomically increases the allowance granted to `spender` by the caller.
563      *
564      * This is an alternative to {approve} that can be used as a mitigation for
565      * problems described in {IERC20-approve}.
566      *
567      * Emits an {Approval} event indicating the updated allowance.
568      *
569      * Requirements:
570      *
571      * - `spender` cannot be the zero address.
572      */
573     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
574         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
575         return true;
576     }
577 
578     /**
579      * @dev Atomically decreases the allowance granted to `spender` by the caller.
580      *
581      * This is an alternative to {approve} that can be used as a mitigation for
582      * problems described in {IERC20-approve}.
583      *
584      * Emits an {Approval} event indicating the updated allowance.
585      *
586      * Requirements:
587      *
588      * - `spender` cannot be the zero address.
589      * - `spender` must have allowance for the caller of at least
590      * `subtractedValue`.
591      */
592     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
593         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
594         return true;
595     }
596 
597     /**
598      * @dev Moves tokens `amount` from `sender` to `recipient`.
599      *
600      * This is internal function is equivalent to {transfer}, and can be used to
601      * e.g. implement automatic token fees, slashing mechanisms, etc.
602      *
603      * Emits a {Transfer} event.
604      *
605      * Requirements:
606      *
607      * - `sender` cannot be the zero address.
608      * - `recipient` cannot be the zero address.
609      * - `sender` must have a balance of at least `amount`.
610      */
611     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
612         require(sender != address(0), "ERC20: transfer from the zero address");
613         require(recipient != address(0), "ERC20: transfer to the zero address");
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
663      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
664      *
665      * This internal function is equivalent to `approve`, and can be used to
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
711 // File: YieldToken.sol
712 
713 contract YieldToken is ERC20("Banana", "BANANA") {
714 	using SafeMath for uint256;
715 
716 	uint256 constant public BASE_RATE = 10 ether; 
717 	uint256 constant public INITIAL_ISSUANCE = 300 ether;
718 	// Tue Mar 18 2031 17:46:47 GMT+0000
719 	uint256 constant public END = 1931622407;
720 
721 	mapping(address => uint256) public rewards;
722 	mapping(address => uint256) public lastUpdate;
723 
724 	IKongz public  kongzContract;
725 
726 	event RewardPaid(address indexed user, uint256 reward);
727 
728 	constructor(address _kongz) public{
729 		kongzContract = IKongz(_kongz);
730 	}
731 
732 
733 	function min(uint256 a, uint256 b) internal pure returns (uint256) {
734 		return a < b ? a : b;
735 	}
736 
737 	// called when minting many NFTs
738 	// updated_amount = (balanceOG(user) * base_rate * delta / 86400) + amount * initial rate
739 	function updateRewardOnMint(address _user, uint256 _amount) external {
740 		require(msg.sender == address(kongzContract), "Can't call this");
741 		uint256 time = min(block.timestamp, END);
742 		uint256 timerUser = lastUpdate[_user];
743 		if (timerUser > 0)
744 			rewards[_user] = rewards[_user].add(kongzContract.balanceOG(_user).mul(BASE_RATE.mul((time.sub(timerUser)))).div(86400)
745 				.add(_amount.mul(INITIAL_ISSUANCE)));
746 		else 
747 			rewards[_user] = rewards[_user].add(_amount.mul(INITIAL_ISSUANCE));
748 		lastUpdate[_user] = time;
749 	}
750 
751 	// called on transfers
752 	function updateReward(address _from, address _to, uint256 _tokenId) external {
753 		require(msg.sender == address(kongzContract));
754 		if (_tokenId < 1001) {
755 			uint256 time = min(block.timestamp, END);
756 			uint256 timerFrom = lastUpdate[_from];
757 			if (timerFrom > 0)
758 				rewards[_from] += kongzContract.balanceOG(_from).mul(BASE_RATE.mul((time.sub(timerFrom)))).div(86400);
759 			if (timerFrom != END)
760 				lastUpdate[_from] = time;
761 			if (_to != address(0)) {
762 				uint256 timerTo = lastUpdate[_to];
763 				if (timerTo > 0)
764 					rewards[_to] += kongzContract.balanceOG(_to).mul(BASE_RATE.mul((time.sub(timerTo)))).div(86400);
765 				if (timerTo != END)
766 					lastUpdate[_to] = time;
767 			}
768 		}
769 	}
770 
771 	function getReward(address _to) external {
772 		require(msg.sender == address(kongzContract));
773 		uint256 reward = rewards[_to];
774 		if (reward > 0) {
775 			rewards[_to] = 0;
776 			_mint(_to, reward);
777 			emit RewardPaid(_to, reward);
778 		}
779 	}
780 
781 	function burn(address _from, uint256 _amount) external {
782 		require(msg.sender == address(kongzContract));
783 		_burn(_from, _amount);
784 	}
785 
786 	function getTotalClaimable(address _user) external view returns(uint256) {
787 		uint256 time = min(block.timestamp, END);
788 		uint256 pending = kongzContract.balanceOG(_user).mul(BASE_RATE.mul((time.sub(lastUpdate[_user])))).div(86400);
789 		return rewards[_user] + pending;
790 	}
791 }
