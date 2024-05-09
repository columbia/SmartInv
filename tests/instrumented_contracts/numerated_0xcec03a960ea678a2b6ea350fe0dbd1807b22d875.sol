1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations with added overflow
81  * checks.
82  *
83  * Arithmetic operations in Solidity wrap on overflow. This can easily result
84  * in bugs, because programmers usually assume that an overflow raises an
85  * error, which is the standard behavior in high level programming languages.
86  * `SafeMath` restores this intuition by reverting the transaction when an
87  * operation overflows.
88  *
89  * Using this library instead of the unchecked operations eliminates an entire
90  * class of bugs, so it's recommended to use it always.
91  */
92 library SafeMath {
93     /**
94      * @dev Returns the addition of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `+` operator.
98      *
99      * Requirements:
100      *
101      * - Addition cannot overflow.
102      */
103     function add(uint256 a, uint256 b) internal pure returns (uint256) {
104         uint256 c = a + b;
105         require(c >= a, "SafeMath: addition overflow");
106 
107         return c;
108     }
109 
110     /**
111      * @dev Returns the subtraction of two unsigned integers, reverting on
112      * overflow (when the result is negative).
113      *
114      * Counterpart to Solidity's `-` operator.
115      *
116      * Requirements:
117      *
118      * - Subtraction cannot overflow.
119      */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         return sub(a, b, "SafeMath: subtraction overflow");
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b <= a, errorMessage);
136         uint256 c = a - b;
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `*` operator.
146      *
147      * Requirements:
148      *
149      * - Multiplication cannot overflow.
150      */
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153         // benefit is lost if 'b' is also tested.
154         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
155         if (a == 0) {
156             return 0;
157         }
158 
159         uint256 c = a * b;
160         require(c / a == b, "SafeMath: multiplication overflow");
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function div(uint256 a, uint256 b) internal pure returns (uint256) {
178         return div(a, b, "SafeMath: division by zero");
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194         require(b > 0, errorMessage);
195         uint256 c = a / b;
196         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
214         return mod(a, b, "SafeMath: modulo by zero");
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts with custom message when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b != 0, errorMessage);
231         return a % b;
232     }
233 }
234 
235 /**
236  * @dev Collection of functions related to the address type
237  */
238 library Address {
239     /**
240      * @dev Returns true if `account` is a contract.
241      *
242      * [IMPORTANT]
243      * ====
244      * It is unsafe to assume that an address for which this function returns
245      * false is an externally-owned account (EOA) and not a contract.
246      *
247      * Among others, `isContract` will return false for the following
248      * types of addresses:
249      *
250      *  - an externally-owned account
251      *  - a contract in construction
252      *  - an address where a contract will be created
253      *  - an address where a contract lived, but was destroyed
254      * ====
255      */
256     function isContract(address account) internal view returns (bool) {
257         // This method relies in extcodesize, which returns 0 for contracts in
258         // construction, since the code is only stored at the end of the
259         // constructor execution.
260 
261         uint256 size;
262         // solhint-disable-next-line no-inline-assembly
263         assembly { size := extcodesize(account) }
264         return size > 0;
265     }
266 
267     /**
268      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
269      * `recipient`, forwarding all available gas and reverting on errors.
270      *
271      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
272      * of certain opcodes, possibly making contracts go over the 2300 gas limit
273      * imposed by `transfer`, making them unable to receive funds via
274      * `transfer`. {sendValue} removes this limitation.
275      *
276      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
277      *
278      * IMPORTANT: because control is transferred to `recipient`, care must be
279      * taken to not create reentrancy vulnerabilities. Consider using
280      * {ReentrancyGuard} or the
281      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
282      */
283     function sendValue(address payable recipient, uint256 amount) internal {
284         require(address(this).balance >= amount, "Address: insufficient balance");
285 
286         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
287         (bool success, ) = recipient.call{ value: amount }("");
288         require(success, "Address: unable to send value, recipient may have reverted");
289     }
290 
291     /**
292      * @dev Performs a Solidity function call using a low level `call`. A
293      * plain`call` is an unsafe replacement for a function call: use this
294      * function instead.
295      *
296      * If `target` reverts with a revert reason, it is bubbled up by this
297      * function (like regular Solidity function calls).
298      *
299      * Returns the raw returned data. To convert to the expected return value,
300      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
301      *
302      * Requirements:
303      *
304      * - `target` must be a contract.
305      * - calling `target` with `data` must not revert.
306      *
307      * _Available since v3.1._
308      */
309     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
310         return functionCall(target, data, "Address: low-level call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
315      * `errorMessage` as a fallback revert reason when `target` reverts.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
320         return _functionCallWithValue(target, data, 0, errorMessage);
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
325      * but also transferring `value` wei to `target`.
326      *
327      * Requirements:
328      *
329      * - the calling contract must have an ETH balance of at least `value`.
330      * - the called Solidity function must be `payable`.
331      *
332      * _Available since v3.1._
333      */
334     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
335         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
340      * with `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
345         require(address(this).balance >= value, "Address: insufficient balance for call");
346         return _functionCallWithValue(target, data, value, errorMessage);
347     }
348 
349     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
350         require(isContract(target), "Address: call to non-contract");
351 
352         // solhint-disable-next-line avoid-low-level-calls
353         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
354         if (success) {
355             return returndata;
356         } else {
357             // Look for revert reason and bubble it up if present
358             if (returndata.length > 0) {
359                 // The easiest way to bubble the revert reason is using memory via assembly
360 
361                 // solhint-disable-next-line no-inline-assembly
362                 assembly {
363                     let returndata_size := mload(returndata)
364                     revert(add(32, returndata), returndata_size)
365                 }
366             } else {
367                 revert(errorMessage);
368             }
369         }
370     }
371 }
372 
373 /*
374  * @dev Provides information about the current execution context, including the
375  * sender of the transaction and its data. While these are generally available
376  * via msg.sender and msg.data, they should not be accessed in such a direct
377  * manner, since when dealing with GSN meta-transactions the account sending and
378  * paying for execution may not be the actual sender (as far as an application
379  * is concerned).
380  *
381  * This contract is only required for intermediate, library-like contracts.
382  */
383 abstract contract Context {
384     function _msgSender() internal view virtual returns (address payable) {
385         return msg.sender;
386     }
387 
388     function _msgData() internal view virtual returns (bytes memory) {
389         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
390         return msg.data;
391     }
392 }
393 
394 
395 /**
396  * @dev Implementation of the {IERC20} interface.
397  *
398  * This implementation is agnostic to the way tokens are created. This means
399  * that a supply mechanism has to be added in a derived contract using {_mint}.
400  * For a generic mechanism see {ERC20PresetMinterPauser}.
401  *
402  * TIP: For a detailed writeup see our guide
403  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
404  * to implement supply mechanisms].
405  *
406  * We have followed general OpenZeppelin guidelines: functions revert instead
407  * of returning `false` on failure. This behavior is nonetheless conventional
408  * and does not conflict with the expectations of ERC20 applications.
409  *
410  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
411  * This allows applications to reconstruct the allowance for all accounts just
412  * by listening to said events. Other implementations of the EIP may not emit
413  * these events, as it isn't required by the specification.
414  *
415  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
416  * functions have been added to mitigate the well-known issues around setting
417  * allowances. See {IERC20-approve}.
418  */
419 contract ERC20 is Context, IERC20 {
420     using SafeMath for uint256;
421     using Address for address;
422 
423     mapping (address => uint256) private _balances;
424 
425     mapping (address => mapping (address => uint256)) private _allowances;
426 
427     uint256 private _totalSupply;
428 
429     string private _name;
430     string private _symbol;
431     uint8 private _decimals;
432 
433     /**
434      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
435      * a default value of 18.
436      *
437      * To select a different value for {decimals}, use {_setupDecimals}.
438      *
439      * All three of these values are immutable: they can only be set once during
440      * construction.
441      */
442     constructor (string memory name, string memory symbol) public {
443         _name = name;
444         _symbol = symbol;
445         _decimals = 18;
446     }
447 
448     /**
449      * @dev Returns the name of the token.
450      */
451     function name() public view returns (string memory) {
452         return _name;
453     }
454 
455     /**
456      * @dev Returns the symbol of the token, usually a shorter version of the
457      * name.
458      */
459     function symbol() public view returns (string memory) {
460         return _symbol;
461     }
462 
463     /**
464      * @dev Returns the number of decimals used to get its user representation.
465      * For example, if `decimals` equals `2`, a balance of `505` tokens should
466      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
467      *
468      * Tokens usually opt for a value of 18, imitating the relationship between
469      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
470      * called.
471      *
472      * NOTE: This information is only used for _display_ purposes: it in
473      * no way affects any of the arithmetic of the contract, including
474      * {IERC20-balanceOf} and {IERC20-transfer}.
475      */
476     function decimals() public view returns (uint8) {
477         return _decimals;
478     }
479 
480     /**
481      * @dev See {IERC20-totalSupply}.
482      */
483     function totalSupply() public view override returns (uint256) {
484         return _totalSupply;
485     }
486 
487     /**
488      * @dev See {IERC20-balanceOf}.
489      */
490     function balanceOf(address account) public view override returns (uint256) {
491         return _balances[account];
492     }
493 
494     /**
495      * @dev See {IERC20-transfer}.
496      *
497      * Requirements:
498      *
499      * - `recipient` cannot be the zero address.
500      * - the caller must have a balance of at least `amount`.
501      */
502     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
503         _transfer(_msgSender(), recipient, amount);
504         return true;
505     }
506 
507     /**
508      * @dev See {IERC20-allowance}.
509      */
510     function allowance(address owner, address spender) public view virtual override returns (uint256) {
511         return _allowances[owner][spender];
512     }
513 
514     /**
515      * @dev See {IERC20-approve}.
516      *
517      * Requirements:
518      *
519      * - `spender` cannot be the zero address.
520      */
521     function approve(address spender, uint256 amount) public virtual override returns (bool) {
522         _approve(_msgSender(), spender, amount);
523         return true;
524     }
525 
526     /**
527      * @dev See {IERC20-transferFrom}.
528      *
529      * Emits an {Approval} event indicating the updated allowance. This is not
530      * required by the EIP. See the note at the beginning of {ERC20};
531      *
532      * Requirements:
533      * - `sender` and `recipient` cannot be the zero address.
534      * - `sender` must have a balance of at least `amount`.
535      * - the caller must have allowance for ``sender``'s tokens of at least
536      * `amount`.
537      */
538     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
539         _transfer(sender, recipient, amount);
540         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
541         return true;
542     }
543 
544     /**
545      * @dev Atomically increases the allowance granted to `spender` by the caller.
546      *
547      * This is an alternative to {approve} that can be used as a mitigation for
548      * problems described in {IERC20-approve}.
549      *
550      * Emits an {Approval} event indicating the updated allowance.
551      *
552      * Requirements:
553      *
554      * - `spender` cannot be the zero address.
555      */
556     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
557         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
558         return true;
559     }
560 
561     /**
562      * @dev Atomically decreases the allowance granted to `spender` by the caller.
563      *
564      * This is an alternative to {approve} that can be used as a mitigation for
565      * problems described in {IERC20-approve}.
566      *
567      * Emits an {Approval} event indicating the updated allowance.
568      *
569      * Requirements:
570      *
571      * - `spender` cannot be the zero address.
572      * - `spender` must have allowance for the caller of at least
573      * `subtractedValue`.
574      */
575     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
576         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
577         return true;
578     }
579 
580     /**
581      * @dev Moves tokens `amount` from `sender` to `recipient`.
582      *
583      * This is internal function is equivalent to {transfer}, and can be used to
584      * e.g. implement automatic token fees, slashing mechanisms, etc.
585      *
586      * Emits a {Transfer} event.
587      *
588      * Requirements:
589      *
590      * - `sender` cannot be the zero address.
591      * - `recipient` cannot be the zero address.
592      * - `sender` must have a balance of at least `amount`.
593      */
594     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
595         require(sender != address(0), "ERC20: transfer from the zero address");
596         require(recipient != address(0), "ERC20: transfer to the zero address");
597 
598         _beforeTokenTransfer(sender, recipient, amount);
599 
600         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
601         _balances[recipient] = _balances[recipient].add(amount);
602         emit Transfer(sender, recipient, amount);
603     }
604 
605     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
606      * the total supply.
607      *
608      * Emits a {Transfer} event with `from` set to the zero address.
609      *
610      * Requirements
611      *
612      * - `to` cannot be the zero address.
613      */
614     function _mint(address account, uint256 amount) internal virtual {
615         require(account != address(0), "ERC20: mint to the zero address");
616 
617         _beforeTokenTransfer(address(0), account, amount);
618 
619         _totalSupply = _totalSupply.add(amount);
620         _balances[account] = _balances[account].add(amount);
621         emit Transfer(address(0), account, amount);
622     }
623 
624     /**
625      * @dev Destroys `amount` tokens from `account`, reducing the
626      * total supply.
627      *
628      * Emits a {Transfer} event with `to` set to the zero address.
629      *
630      * Requirements
631      *
632      * - `account` cannot be the zero address.
633      * - `account` must have at least `amount` tokens.
634      */
635     function _burn(address account, uint256 amount) internal virtual {
636         require(account != address(0), "ERC20: burn from the zero address");
637 
638         _beforeTokenTransfer(account, address(0), amount);
639 
640         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
641         _totalSupply = _totalSupply.sub(amount);
642         emit Transfer(account, address(0), amount);
643     }
644 
645     /**
646      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
647      *
648      * This internal function is equivalent to `approve`, and can be used to
649      * e.g. set automatic allowances for certain subsystems, etc.
650      *
651      * Emits an {Approval} event.
652      *
653      * Requirements:
654      *
655      * - `owner` cannot be the zero address.
656      * - `spender` cannot be the zero address.
657      */
658     function _approve(address owner, address spender, uint256 amount) internal virtual {
659         require(owner != address(0), "ERC20: approve from the zero address");
660         require(spender != address(0), "ERC20: approve to the zero address");
661 
662         _allowances[owner][spender] = amount;
663         emit Approval(owner, spender, amount);
664     }
665 
666     /**
667      * @dev Sets {decimals} to a value other than the default one of 18.
668      *
669      * WARNING: This function should only be called from the constructor. Most
670      * applications that interact with token contracts will not expect
671      * {decimals} to ever change, and may work incorrectly if it does.
672      */
673     function _setupDecimals(uint8 decimals_) internal {
674         _decimals = decimals_;
675     }
676 
677     /**
678      * @dev Hook that is called before any transfer of tokens. This includes
679      * minting and burning.
680      *
681      * Calling conditions:
682      *
683      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
684      * will be to transferred to `to`.
685      * - when `from` is zero, `amount` tokens will be minted for `to`.
686      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
687      * - `from` and `to` are never both zero.
688      *
689      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
690      */
691     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
692 }
693 
694 interface IController {
695     function vaults(address) external view returns (address);
696     function rewards() external view returns (address);
697     function want(address) external view returns (address);
698     function balanceOf(address) external view returns (uint);
699     function withdraw(address, uint) external;
700     function maxAcceptAmount(address) external view returns (uint256);
701     function earn(address, uint) external;
702 
703     function getStrategyCount(address _vault) external view returns(uint256);
704     function depositAvailable(address _vault) external view returns(bool);
705     function harvestAllStrategies(address _vault) external;
706     function harvestStrategy(address _vault, address _strategy) external;
707 }
708 
709 interface ITokenInterface is IERC20 {
710     /** VALUE, YFV, vUSD, vETH has minters **/
711     function minters(address account) external view returns (bool);
712     function mint(address _to, uint _amount) external;
713 
714     /** YFV <-> VALUE **/
715     function deposit(uint _amount) external;
716     function withdraw(uint _amount) external;
717     function cap() external returns (uint);
718     function yfvLockedBalance() external returns (uint);
719 }
720 
721 interface IYFVReferral {
722     function setReferrer(address farmer, address referrer) external;
723     function getReferrer(address farmer) external view returns (address);
724 }
725 
726 interface IFreeFromUpTo {
727     function freeFromUpTo(address from, uint valueToken) external returns (uint freed);
728 }
729 
730 contract ValueGovernanceVault is ERC20 {
731     using Address for address;
732     using SafeMath for uint;
733 
734     IFreeFromUpTo public constant chi = IFreeFromUpTo(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
735 
736     modifier discountCHI(uint8 _flag) {
737         if ((_flag & 0x1) == 0) {
738             _;
739         } else {
740             uint gasStart = gasleft();
741             _;
742             uint gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
743             chi.freeFromUpTo(msg.sender, (gasSpent + 14154) / 41130);
744         }
745     }
746 
747     ITokenInterface public yfvToken; // stake and wrap to VALUE
748     ITokenInterface public valueToken; // stake and reward token
749     ITokenInterface public vUSD; // reward token
750     ITokenInterface public vETH; // reward token
751 
752     uint public fundCap = 9500; // use up to 95% of fund (to keep small withdrawals cheap)
753     uint public constant FUND_CAP_DENOMINATOR = 10000;
754 
755     uint public earnLowerlimit;
756 
757     address public governance;
758     address public controller;
759     address public rewardReferral;
760 
761     // Info of each user.
762     struct UserInfo {
763         uint amount;
764         uint valueRewardDebt;
765         uint vusdRewardDebt;
766         uint lastStakeTime;
767         uint accumulatedStakingPower; // will accumulate every time user harvest
768 
769         uint lockedAmount;
770         uint lockedDays; // 7 days -> 150 days (5 months)
771         uint boostedExtra; // times 1e12 (285200000000 -> +28.52%). See below.
772         uint unlockedTime;
773     }
774 
775     uint maxLockedDays = 150;
776 
777     uint lastRewardBlock;  // Last block number that reward distribution occurs.
778     uint accValuePerShare; // Accumulated VALUEs per share, times 1e12. See below.
779     uint accVusdPerShare; // Accumulated vUSD per share, times 1e12. See below.
780 
781     uint public valuePerBlock; // 0.2 VALUE/block at start
782     uint public vusdPerBlock; // 5 vUSD/block at start
783 
784     mapping(address => UserInfo) public userInfo;
785     uint public totalDepositCap;
786 
787     uint public constant vETH_REWARD_FRACTION_RATE = 1000;
788     uint public minStakingAmount = 0 ether;
789     uint public unstakingFrozenTime = 40 hours;
790     // ** unlockWithdrawFee = 1.92%: stakers will need to pay 1.92% (sent to insurance fund) of amount they want to withdraw if the coin still frozen
791     uint public unlockWithdrawFee = 192; // per ten thousand (eg. 15 -> 0.15%)
792     address public valueInsuranceFund = 0xb7b2Ea8A1198368f950834875047aA7294A2bDAa; // set to Governance Multisig at start
793 
794     event Deposit(address indexed user, uint amount);
795     event Withdraw(address indexed user, uint amount);
796     event RewardPaid(address indexed user, uint reward);
797     event CommissionPaid(address indexed user, uint reward);
798     event Locked(address indexed user, uint amount, uint _days);
799     event EmergencyWithdraw(address indexed user, uint amount);
800 
801     constructor (ITokenInterface _yfvToken,
802         ITokenInterface _valueToken,
803         ITokenInterface _vUSD,
804         ITokenInterface _vETH,
805         uint _valuePerBlock,
806         uint _vusdPerBlock,
807         uint _startBlock) public ERC20("GovVault:ValueLiquidity", "gvVALUE") {
808         yfvToken = _yfvToken;
809         valueToken = _valueToken;
810         vUSD = _vUSD;
811         vETH = _vETH;
812         valuePerBlock = _valuePerBlock;
813         vusdPerBlock = _vusdPerBlock;
814         lastRewardBlock = _startBlock;
815         governance = msg.sender;
816     }
817 
818     function balance() public view returns (uint) {
819         uint bal = valueToken.balanceOf(address(this));
820         if (controller != address(0)) bal = bal.add(IController(controller).balanceOf(address(valueToken)));
821         return bal;
822     }
823 
824     function setFundCap(uint _fundCap) external {
825         require(msg.sender == governance, "!governance");
826         fundCap = _fundCap;
827     }
828 
829     function setTotalDepositCap(uint _totalDepositCap) external {
830         require(msg.sender == governance, "!governance");
831         totalDepositCap = _totalDepositCap;
832     }
833 
834     function setGovernance(address _governance) public {
835         require(msg.sender == governance, "!governance");
836         governance = _governance;
837     }
838 
839     function setController(address _controller) public {
840         require(msg.sender == governance, "!governance");
841         controller = _controller;
842     }
843 
844     function setRewardReferral(address _rewardReferral) external {
845         require(msg.sender == governance, "!governance");
846         rewardReferral = _rewardReferral;
847     }
848 
849     function setEarnLowerlimit(uint _earnLowerlimit) public {
850         require(msg.sender == governance, "!governance");
851         earnLowerlimit = _earnLowerlimit;
852     }
853 
854     function setMaxLockedDays(uint _maxLockedDays) public {
855         require(msg.sender == governance, "!governance");
856         maxLockedDays = _maxLockedDays;
857     }
858 
859     function setValuePerBlock(uint _valuePerBlock) public {
860         require(msg.sender == governance, "!governance");
861         require(_valuePerBlock <= 10 ether, "Too big _valuePerBlock"); // <= 10 VALUE
862         updateReward();
863         valuePerBlock = _valuePerBlock;
864     }
865 
866     function setVusdPerBlock(uint _vusdPerBlock) public {
867         require(msg.sender == governance, "!governance");
868         require(_vusdPerBlock <= 200 * (10 ** 9), "Too big _vusdPerBlock"); // <= 200 vUSD
869         updateReward();
870         vusdPerBlock = _vusdPerBlock;
871     }
872 
873     function setMinStakingAmount(uint _minStakingAmount) public {
874         require(msg.sender == governance, "!governance");
875         minStakingAmount = _minStakingAmount;
876     }
877 
878     function setUnstakingFrozenTime(uint _unstakingFrozenTime) public {
879         require(msg.sender == governance, "!governance");
880         unstakingFrozenTime = _unstakingFrozenTime;
881     }
882 
883     function setUnlockWithdrawFee(uint _unlockWithdrawFee) public {
884         require(msg.sender == governance, "!governance");
885         require(_unlockWithdrawFee <= 1000, "Dont be too greedy"); // <= 10%
886         unlockWithdrawFee = _unlockWithdrawFee;
887     }
888 
889     function setValueInsuranceFund(address _valueInsuranceFund) public {
890         require(msg.sender == governance, "!governance");
891         valueInsuranceFund = _valueInsuranceFund;
892     }
893 
894     // To upgrade vUSD contract (v1 is still experimental, we may need vUSDv2 with rebase() function working soon - then governance will call this upgrade)
895     function upgradeVUSDContract(address _vUSDContract) public {
896         require(msg.sender == governance, "!governance");
897         vUSD = ITokenInterface(_vUSDContract);
898     }
899 
900     // To upgrade vETH contract (v1 is still experimental, we may need vETHv2 with rebase() function working soon - then governance will call this upgrade)
901     function upgradeVETHContract(address _vETHContract) public {
902         require(msg.sender == governance, "!governance");
903         vETH = ITokenInterface(_vETHContract);
904     }
905 
906     // Custom logic in here for how much the vault allows to be borrowed
907     // Sets minimum required on-hand to keep small withdrawals cheap
908     function available() public view returns (uint) {
909         return valueToken.balanceOf(address(this)).mul(fundCap).div(FUND_CAP_DENOMINATOR);
910     }
911 
912     function earn(uint8 _flag) public discountCHI(_flag) {
913         if (controller != address(0)) {
914             uint _amount = available();
915             uint _accepted = IController(controller).maxAcceptAmount(address(valueToken));
916             if (_amount > _accepted) _amount = _accepted;
917             if (_amount > 0) {
918                 yfvToken.transfer(controller, _amount);
919                 IController(controller).earn(address(yfvToken), _amount);
920             }
921         }
922     }
923 
924     function getRewardAndDepositAll(uint8 _flag) external discountCHI(_flag) {
925         unstake(0, 0x0);
926         depositAll(address(0), 0x0);
927     }
928 
929     function depositAll(address _referrer, uint8 _flag) public discountCHI(_flag) {
930         deposit(valueToken.balanceOf(msg.sender), _referrer, 0x0);
931     }
932 
933     function deposit(uint _amount, address _referrer, uint8 _flag) public discountCHI(_flag) {
934         uint _pool = balance();
935         uint _before = valueToken.balanceOf(address(this));
936         valueToken.transferFrom(msg.sender, address(this), _amount);
937         uint _after = valueToken.balanceOf(address(this));
938         require(totalDepositCap == 0 || _after <= totalDepositCap, ">totalDepositCap");
939         _amount = _after.sub(_before); // Additional check for deflationary tokens
940         uint _shares = _deposit(address(this), _pool, _amount);
941         _stakeShares(msg.sender, _shares, _referrer);
942     }
943 
944     function depositYFV(uint _amount, address _referrer, uint8 _flag) public discountCHI(_flag) {
945         uint _pool = balance();
946         yfvToken.transferFrom(msg.sender, address(this), _amount);
947         uint _before = valueToken.balanceOf(address(this));
948         yfvToken.approve(address(valueToken), 0);
949         yfvToken.approve(address(valueToken), _amount);
950         valueToken.deposit(_amount);
951         uint _after = valueToken.balanceOf(address(this));
952         require(totalDepositCap == 0 || _after <= totalDepositCap, ">totalDepositCap");
953         _amount = _after.sub(_before); // Additional check for deflationary tokens
954         uint _shares = _deposit(address(this), _pool, _amount);
955         _stakeShares(msg.sender, _shares, _referrer);
956     }
957 
958     function buyShares(uint _amount, uint8 _flag) public discountCHI(_flag) {
959         uint _pool = balance();
960         uint _before = valueToken.balanceOf(address(this));
961         valueToken.transferFrom(msg.sender, address(this), _amount);
962         uint _after = valueToken.balanceOf(address(this));
963         require(totalDepositCap == 0 || _after <= totalDepositCap, ">totalDepositCap");
964         _amount = _after.sub(_before); // Additional check for deflationary tokens
965         _deposit(msg.sender, _pool, _amount);
966     }
967 
968     function depositShares(uint _shares, address _referrer, uint8 _flag) public discountCHI(_flag) {
969         require(totalDepositCap == 0 || balance().add(_shares) <= totalDepositCap, ">totalDepositCap");
970         uint _before = balanceOf(address(this));
971         IERC20(address(this)).transferFrom(msg.sender, address(this), _shares);
972         uint _after = balanceOf(address(this));
973         _shares = _after.sub(_before); // Additional check for deflationary tokens
974         _stakeShares(msg.sender, _shares, _referrer);
975     }
976 
977     function lockShares(uint _locked, uint _days, uint8 _flag) external discountCHI(_flag) {
978         require(_days >= 7 && _days <= maxLockedDays, "_days out-of-range");
979         UserInfo storage user = userInfo[msg.sender];
980         if (user.unlockedTime < block.timestamp) {
981             user.lockedAmount = 0;
982         } else {
983             require(_days >= user.lockedDays, "Extra days should not less than current locked days");
984         }
985         user.lockedAmount = user.lockedAmount.add(_locked);
986         require(user.lockedAmount <= user.amount, "lockedAmount > amount");
987         user.unlockedTime = block.timestamp.add(_days * 86400);
988         // (%) = 5 + (lockedDays - 7) * 0.15
989         user.boostedExtra = 50000000000 + (_days - 7) * 1500000000;
990         emit Locked(msg.sender, user.lockedAmount, _days);
991     }
992 
993     function _deposit(address _mintTo, uint _pool, uint _amount) internal returns (uint _shares) {
994         _shares = 0;
995         if (totalSupply() == 0) {
996             _shares = _amount;
997         } else {
998             _shares = (_amount.mul(totalSupply())).div(_pool);
999         }
1000         if (_shares > 0) {
1001             if (valueToken.balanceOf(address(this)) > earnLowerlimit) {
1002                 earn(0x0);
1003             }
1004             _mint(_mintTo, _shares);
1005         }
1006     }
1007 
1008     function _stakeShares(address _account, uint _shares, address _referrer) internal {
1009         UserInfo storage user = userInfo[_account];
1010         require(minStakingAmount == 0 || user.amount.add(_shares) >= minStakingAmount, "<minStakingAmount");
1011         updateReward();
1012         _getReward();
1013         user.amount = user.amount.add(_shares);
1014         if (user.lockedAmount > 0 && user.unlockedTime < block.timestamp) {
1015             user.lockedAmount = 0;
1016         }
1017         user.valueRewardDebt = user.amount.mul(accValuePerShare).div(1e12);
1018         user.vusdRewardDebt = user.amount.mul(accVusdPerShare).div(1e12);
1019         user.lastStakeTime = block.timestamp;
1020         emit Deposit(_account, _shares);
1021         if (rewardReferral != address(0) && _account != address(0)) {
1022             IYFVReferral(rewardReferral).setReferrer(_account, _referrer);
1023         }
1024     }
1025 
1026     function unfrozenStakeTime(address _account) public view returns (uint) {
1027         return userInfo[_account].lastStakeTime + unstakingFrozenTime;
1028     }
1029 
1030     // View function to see pending VALUEs on frontend.
1031     function pendingValue(address _account) public view returns (uint _pending) {
1032         UserInfo storage user = userInfo[_account];
1033         uint _accValuePerShare = accValuePerShare;
1034         uint lpSupply = balanceOf(address(this));
1035         if (block.number > lastRewardBlock && lpSupply != 0) {
1036             uint numBlocks = block.number.sub(lastRewardBlock);
1037             _accValuePerShare = accValuePerShare.add(numBlocks.mul(valuePerBlock).mul(1e12).div(lpSupply));
1038         }
1039         _pending = user.amount.mul(_accValuePerShare).div(1e12).sub(user.valueRewardDebt);
1040         if (user.lockedAmount > 0 && user.unlockedTime >= block.timestamp) {
1041             uint _bonus = _pending.mul(user.lockedAmount.mul(user.boostedExtra).div(1e12)).div(user.amount);
1042             uint _ceilingBonus = _pending.mul(33).div(100); // 33%
1043             if (_bonus > _ceilingBonus) _bonus = _ceilingBonus; // Additional check to avoid insanely high bonus!
1044             _pending = _pending.add(_bonus);
1045         }
1046     }
1047 
1048     // View function to see pending vUSDs on frontend.
1049     function pendingVusd(address _account) public view returns (uint) {
1050         UserInfo storage user = userInfo[_account];
1051         uint _accVusdPerShare = accVusdPerShare;
1052         uint lpSupply = balanceOf(address(this));
1053         if (block.number > lastRewardBlock && lpSupply != 0) {
1054             uint numBlocks = block.number.sub(lastRewardBlock);
1055             _accVusdPerShare = accVusdPerShare.add(numBlocks.mul(vusdPerBlock).mul(1e12).div(lpSupply));
1056         }
1057         return user.amount.mul(_accVusdPerShare).div(1e12).sub(user.vusdRewardDebt);
1058     }
1059 
1060     // View function to see pending vETHs on frontend.
1061     function pendingVeth(address _account) public view returns (uint) {
1062         return pendingVusd(_account).div(vETH_REWARD_FRACTION_RATE);
1063     }
1064 
1065     function stakingPower(address _account) public view returns (uint) {
1066         return userInfo[_account].accumulatedStakingPower.add(pendingValue(_account));
1067     }
1068 
1069     function updateReward() public {
1070         if (block.number <= lastRewardBlock) {
1071             return;
1072         }
1073         uint lpSupply = balanceOf(address(this));
1074         if (lpSupply == 0) {
1075             lastRewardBlock = block.number;
1076             return;
1077         }
1078         uint _numBlocks = block.number.sub(lastRewardBlock);
1079         accValuePerShare = accValuePerShare.add(_numBlocks.mul(valuePerBlock).mul(1e12).div(lpSupply));
1080         accVusdPerShare = accVusdPerShare.add(_numBlocks.mul(vusdPerBlock).mul(1e12).div(lpSupply));
1081         lastRewardBlock = block.number;
1082     }
1083 
1084     function _getReward() internal {
1085         UserInfo storage user = userInfo[msg.sender];
1086         uint _pendingValue = user.amount.mul(accValuePerShare).div(1e12).sub(user.valueRewardDebt);
1087         if (_pendingValue > 0) {
1088             if (user.lockedAmount > 0) {
1089                 if (user.unlockedTime < block.timestamp) {
1090                     user.lockedAmount = 0;
1091                 } else {
1092                     uint _bonus = _pendingValue.mul(user.lockedAmount.mul(user.boostedExtra).div(1e12)).div(user.amount);
1093                     uint _ceilingBonus = _pendingValue.mul(33).div(100); // 33%
1094                     if (_bonus > _ceilingBonus) _bonus = _ceilingBonus; // Additional check to avoid insanely high bonus!
1095                     _pendingValue = _pendingValue.add(_bonus);
1096                 }
1097             }
1098             user.accumulatedStakingPower = user.accumulatedStakingPower.add(_pendingValue);
1099             uint actualPaid = _pendingValue.mul(99).div(100); // 99%
1100             uint commission = _pendingValue - actualPaid; // 1%
1101             safeValueMint(msg.sender, actualPaid);
1102             address _referrer = address(0);
1103             if (rewardReferral != address(0)) {
1104                 _referrer = IYFVReferral(rewardReferral).getReferrer(msg.sender);
1105             }
1106             if (_referrer != address(0)) { // send commission to referrer
1107                 safeValueMint(_referrer, commission);
1108                 CommissionPaid(_referrer, commission);
1109             } else { // send commission to valueInsuranceFund
1110                 safeValueMint(valueInsuranceFund, commission);
1111                 CommissionPaid(valueInsuranceFund, commission);
1112             }
1113         }
1114         uint _pendingVusd = user.amount.mul(accVusdPerShare).div(1e12).sub(user.vusdRewardDebt);
1115         if (_pendingVusd > 0) {
1116             safeVusdMint(msg.sender, _pendingVusd);
1117         }
1118     }
1119 
1120     function withdrawAll(uint8 _flag) public discountCHI(_flag) {
1121         UserInfo storage user = userInfo[msg.sender];
1122         uint _amount = user.amount;
1123         if (user.lockedAmount > 0) {
1124             if (user.unlockedTime < block.timestamp) {
1125                 user.lockedAmount = 0;
1126             } else {
1127                 _amount = user.amount.sub(user.lockedAmount);
1128             }
1129         }
1130         unstake(_amount, 0x0);
1131         withdraw(balanceOf(msg.sender), 0x0);
1132     }
1133 
1134     // Used to swap any borrowed reserve over the debt limit to liquidate to 'token'
1135     function harvest(address reserve, uint amount) external {
1136         require(msg.sender == controller, "!controller");
1137         require(reserve != address(valueToken), "token");
1138         ITokenInterface(reserve).transfer(controller, amount);
1139     }
1140 
1141     function unstake(uint _amount, uint8 _flag) public discountCHI(_flag) returns (uint _actualWithdraw) {
1142         updateReward();
1143         _getReward();
1144         UserInfo storage user = userInfo[msg.sender];
1145         _actualWithdraw = _amount;
1146         if (_amount > 0) {
1147             require(user.amount >= _amount, "stakedBal < _amount");
1148             if (user.lockedAmount > 0) {
1149                 if (user.unlockedTime < block.timestamp) {
1150                     user.lockedAmount = 0;
1151                 } else {
1152                     require(user.amount.sub(user.lockedAmount) >= _amount, "stakedBal-locked < _amount");
1153                 }
1154             }
1155             user.amount = user.amount.sub(_amount);
1156 
1157             if (block.timestamp < user.lastStakeTime.add(unstakingFrozenTime)) {
1158                 // if coin is still frozen and governance does not allow stakers to unstake before timer ends
1159                 if (unlockWithdrawFee == 0 || valueInsuranceFund == address(0)) revert("Coin is still frozen");
1160 
1161                 // otherwise withdrawFee will be calculated based on the rate
1162                 uint _withdrawFee = _amount.mul(unlockWithdrawFee).div(10000);
1163                 uint r = _amount.sub(_withdrawFee);
1164                 if (_amount > r) {
1165                     _withdrawFee = _amount.sub(r);
1166                     _actualWithdraw = r;
1167                     IERC20(address(this)).transfer(valueInsuranceFund, _withdrawFee);
1168                     emit RewardPaid(valueInsuranceFund, _withdrawFee);
1169                 }
1170             }
1171 
1172             IERC20(address(this)).transfer(msg.sender, _actualWithdraw);
1173         }
1174         user.valueRewardDebt = user.amount.mul(accValuePerShare).div(1e12);
1175         user.vusdRewardDebt = user.amount.mul(accVusdPerShare).div(1e12);
1176         emit Withdraw(msg.sender, _amount);
1177     }
1178 
1179     // No rebalance implementation for lower fees and faster swaps
1180     function withdraw(uint _shares, uint8 _flag) public discountCHI(_flag) {
1181         uint _userBal = balanceOf(msg.sender);
1182         if (_shares > _userBal) {
1183             uint _need = _shares.sub(_userBal);
1184             require(_need <= userInfo[msg.sender].amount, "_userBal+staked < _shares");
1185             uint _actualWithdraw = unstake(_need, 0x0);
1186             _shares = _userBal.add(_actualWithdraw); // may be less than expected due to unlockWithdrawFee
1187         }
1188         uint r = (balance().mul(_shares)).div(totalSupply());
1189         _burn(msg.sender, _shares);
1190 
1191         // Check balance
1192         uint b = valueToken.balanceOf(address(this));
1193         if (b < r) {
1194             uint _withdraw = r.sub(b);
1195             if (controller != address(0)) {
1196                 IController(controller).withdraw(address(valueToken), _withdraw);
1197             }
1198             uint _after = valueToken.balanceOf(address(this));
1199             uint _diff = _after.sub(b);
1200             if (_diff < _withdraw) {
1201                 r = b.add(_diff);
1202             }
1203         }
1204 
1205         valueToken.transfer(msg.sender, r);
1206     }
1207 
1208     function getPricePerFullShare() public view returns (uint) {
1209         return balance().mul(1e18).div(totalSupply());
1210     }
1211 
1212     function getStrategyCount() external view returns (uint) {
1213         return (controller != address(0)) ? IController(controller).getStrategyCount(address(this)) : 0;
1214     }
1215 
1216     function depositAvailable() external view returns (bool) {
1217         return (controller != address(0)) ? IController(controller).depositAvailable(address(this)) : false;
1218     }
1219 
1220     function harvestAllStrategies(uint8 _flag) public discountCHI(_flag) {
1221         if (controller != address(0)) {
1222             IController(controller).harvestAllStrategies(address(this));
1223         }
1224     }
1225 
1226     function harvestStrategy(address _strategy, uint8 _flag) public discountCHI(_flag) {
1227         if (controller != address(0)) {
1228             IController(controller).harvestStrategy(address(this), _strategy);
1229         }
1230     }
1231 
1232     // Safe valueToken mint, ensure it is never over cap and we are the current owner.
1233     function safeValueMint(address _to, uint _amount) internal {
1234         if (valueToken.minters(address(this)) && _to != address(0)) {
1235             uint totalSupply = valueToken.totalSupply();
1236             uint realCap = valueToken.cap().add(valueToken.yfvLockedBalance());
1237             if (totalSupply.add(_amount) > realCap) {
1238                 valueToken.mint(_to, realCap.sub(totalSupply));
1239             } else {
1240                 valueToken.mint(_to, _amount);
1241             }
1242         }
1243     }
1244 
1245     // Safe vUSD mint, ensure we are the current owner.
1246     // vETH will be minted together with fixed rate.
1247     function safeVusdMint(address _to, uint _amount) internal {
1248         if (vUSD.minters(address(this)) && _to != address(0)) {
1249             vUSD.mint(_to, _amount);
1250         }
1251         if (vETH.minters(address(this)) && _to != address(0)) {
1252             vETH.mint(_to, _amount.div(vETH_REWARD_FRACTION_RATE));
1253         }
1254     }
1255 
1256     // This is for governance in some emergency circumstances to release lock immediately for an account
1257     function governanceResetLocked(address _account) external {
1258         require(msg.sender == governance, "!governance");
1259         UserInfo storage user = userInfo[_account];
1260         user.lockedAmount = 0;
1261         user.lockedDays = 0;
1262         user.boostedExtra = 0;
1263         user.unlockedTime = 0;
1264     }
1265 
1266     // This function allows governance to take unsupported tokens out of the contract, since this pool exists longer than the others.
1267     // This is in an effort to make someone whole, should they seriously mess up.
1268     // There is no guarantee governance will vote to return these.
1269     // It also allows for removal of airdropped tokens.
1270     function governanceRecoverUnsupported(IERC20 _token, uint _amount, address _to) external {
1271         require(msg.sender == governance, "!governance");
1272         require(address(_token) != address(valueToken) || balance().sub(_amount) >= totalSupply(), "cant withdraw VALUE more than gvVALUE supply");
1273         _token.transfer(_to, _amount);
1274     }
1275 }