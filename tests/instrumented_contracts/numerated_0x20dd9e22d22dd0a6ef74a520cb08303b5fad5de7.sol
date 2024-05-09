1 // SPDX-License-Identifier: GPL-3.0-or-later
2 // File: @openzeppelin/contracts/GSN/Context.sol
3 
4 
5 pragma solidity ^0.6.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
29 
30 
31 pragma solidity ^0.6.0;
32 
33 /**
34  * @dev Interface of the ERC20 standard as defined in the EIP.
35  */
36 interface IERC20 {
37     /**
38      * @dev Returns the amount of tokens in existence.
39      */
40     function totalSupply() external view returns (uint256);
41 
42     /**
43      * @dev Returns the amount of tokens owned by `account`.
44      */
45     function balanceOf(address account) external view returns (uint256);
46 
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address recipient, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Returns the remaining number of tokens that `spender` will be
58      * allowed to spend on behalf of `owner` through {transferFrom}. This is
59      * zero by default.
60      *
61      * This value changes when {approve} or {transferFrom} are called.
62      */
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Emitted when `value` tokens are moved from one account (`from`) to
94      * another (`to`).
95      *
96      * Note that `value` may be zero.
97      */
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     /**
101      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
102      * a call to {approve}. `value` is the new allowance.
103      */
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 // File: @openzeppelin/contracts/math/SafeMath.sol
108 
109 
110 pragma solidity ^0.6.0;
111 
112 /**
113  * @dev Wrappers over Solidity's arithmetic operations with added overflow
114  * checks.
115  *
116  * Arithmetic operations in Solidity wrap on overflow. This can easily result
117  * in bugs, because programmers usually assume that an overflow raises an
118  * error, which is the standard behavior in high level programming languages.
119  * `SafeMath` restores this intuition by reverting the transaction when an
120  * operation overflows.
121  *
122  * Using this library instead of the unchecked operations eliminates an entire
123  * class of bugs, so it's recommended to use it always.
124  */
125 library SafeMath {
126     /**
127      * @dev Returns the addition of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `+` operator.
131      *
132      * Requirements:
133      *
134      * - Addition cannot overflow.
135      */
136     function add(uint256 a, uint256 b) internal pure returns (uint256) {
137         uint256 c = a + b;
138         require(c >= a, "SafeMath: addition overflow");
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      *
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      *
165      * - Subtraction cannot overflow.
166      */
167     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
168         require(b <= a, errorMessage);
169         uint256 c = a - b;
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the multiplication of two unsigned integers, reverting on
176      * overflow.
177      *
178      * Counterpart to Solidity's `*` operator.
179      *
180      * Requirements:
181      *
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function div(uint256 a, uint256 b) internal pure returns (uint256) {
211         return div(a, b, "SafeMath: division by zero");
212     }
213 
214     /**
215      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
216      * division by zero. The result is rounded towards zero.
217      *
218      * Counterpart to Solidity's `/` operator. Note: this function uses a
219      * `revert` opcode (which leaves remaining gas untouched) while Solidity
220      * uses an invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         require(b > 0, errorMessage);
228         uint256 c = a / b;
229         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
230 
231         return c;
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * Reverts when dividing by zero.
237      *
238      * Counterpart to Solidity's `%` operator. This function uses a `revert`
239      * opcode (which leaves remaining gas untouched) while Solidity uses an
240      * invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
263         require(b != 0, errorMessage);
264         return a % b;
265     }
266 }
267 
268 // File: @openzeppelin/contracts/utils/Address.sol
269 
270 
271 pragma solidity ^0.6.2;
272 
273 /**
274  * @dev Collection of functions related to the address type
275  */
276 library Address {
277     /**
278      * @dev Returns true if `account` is a contract.
279      *
280      * [IMPORTANT]
281      * ====
282      * It is unsafe to assume that an address for which this function returns
283      * false is an externally-owned account (EOA) and not a contract.
284      *
285      * Among others, `isContract` will return false for the following
286      * types of addresses:
287      *
288      *  - an externally-owned account
289      *  - a contract in construction
290      *  - an address where a contract will be created
291      *  - an address where a contract lived, but was destroyed
292      * ====
293      */
294     function isContract(address account) internal view returns (bool) {
295         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
296         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
297         // for accounts without code, i.e. `keccak256('')`
298         bytes32 codehash;
299         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
300         // solhint-disable-next-line no-inline-assembly
301         assembly { codehash := extcodehash(account) }
302         return (codehash != accountHash && codehash != 0x0);
303     }
304 
305     /**
306      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
307      * `recipient`, forwarding all available gas and reverting on errors.
308      *
309      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
310      * of certain opcodes, possibly making contracts go over the 2300 gas limit
311      * imposed by `transfer`, making them unable to receive funds via
312      * `transfer`. {sendValue} removes this limitation.
313      *
314      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
315      *
316      * IMPORTANT: because control is transferred to `recipient`, care must be
317      * taken to not create reentrancy vulnerabilities. Consider using
318      * {ReentrancyGuard} or the
319      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
320      */
321     function sendValue(address payable recipient, uint256 amount) internal {
322         require(address(this).balance >= amount, "Address: insufficient balance");
323 
324         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
325         (bool success, ) = recipient.call{ value: amount }("");
326         require(success, "Address: unable to send value, recipient may have reverted");
327     }
328 
329     /**
330      * @dev Performs a Solidity function call using a low level `call`. A
331      * plain`call` is an unsafe replacement for a function call: use this
332      * function instead.
333      *
334      * If `target` reverts with a revert reason, it is bubbled up by this
335      * function (like regular Solidity function calls).
336      *
337      * Returns the raw returned data. To convert to the expected return value,
338      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
339      *
340      * Requirements:
341      *
342      * - `target` must be a contract.
343      * - calling `target` with `data` must not revert.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
348       return functionCall(target, data, "Address: low-level call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
353      * `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
358         return _functionCallWithValue(target, data, 0, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but also transferring `value` wei to `target`.
364      *
365      * Requirements:
366      *
367      * - the calling contract must have an ETH balance of at least `value`.
368      * - the called Solidity function must be `payable`.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
373         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
378      * with `errorMessage` as a fallback revert reason when `target` reverts.
379      *
380      * _Available since v3.1._
381      */
382     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
383         require(address(this).balance >= value, "Address: insufficient balance for call");
384         return _functionCallWithValue(target, data, value, errorMessage);
385     }
386 
387     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
388         require(isContract(target), "Address: call to non-contract");
389 
390         // solhint-disable-next-line avoid-low-level-calls
391         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
392         if (success) {
393             return returndata;
394         } else {
395             // Look for revert reason and bubble it up if present
396             if (returndata.length > 0) {
397                 // The easiest way to bubble the revert reason is using memory via assembly
398 
399                 // solhint-disable-next-line no-inline-assembly
400                 assembly {
401                     let returndata_size := mload(returndata)
402                     revert(add(32, returndata), returndata_size)
403                 }
404             } else {
405                 revert(errorMessage);
406             }
407         }
408     }
409 }
410 
411 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
412 
413 
414 pragma solidity ^0.6.0;
415 
416 
417 
418 
419 
420 /**
421  * @dev Implementation of the {IERC20} interface.
422  *
423  * This implementation is agnostic to the way tokens are created. This means
424  * that a supply mechanism has to be added in a derived contract using {_mint}.
425  * For a generic mechanism see {ERC20PresetMinterPauser}.
426  *
427  * TIP: For a detailed writeup see our guide
428  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
429  * to implement supply mechanisms].
430  *
431  * We have followed general OpenZeppelin guidelines: functions revert instead
432  * of returning `false` on failure. This behavior is nonetheless conventional
433  * and does not conflict with the expectations of ERC20 applications.
434  *
435  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
436  * This allows applications to reconstruct the allowance for all accounts just
437  * by listening to said events. Other implementations of the EIP may not emit
438  * these events, as it isn't required by the specification.
439  *
440  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
441  * functions have been added to mitigate the well-known issues around setting
442  * allowances. See {IERC20-approve}.
443  */
444 contract ERC20 is Context, IERC20 {
445     using SafeMath for uint256;
446     using Address for address;
447 
448     mapping (address => uint256) private _balances;
449 
450     mapping (address => mapping (address => uint256)) private _allowances;
451 
452     uint256 private _totalSupply;
453 
454     string private _name;
455     string private _symbol;
456     uint8 private _decimals;
457 
458     /**
459      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
460      * a default value of 18.
461      *
462      * To select a different value for {decimals}, use {_setupDecimals}.
463      *
464      * All three of these values are immutable: they can only be set once during
465      * construction.
466      */
467     constructor (string memory name, string memory symbol) public {
468         _name = name;
469         _symbol = symbol;
470         _decimals = 18;
471     }
472 
473     /**
474      * @dev Returns the name of the token.
475      */
476     function name() public view returns (string memory) {
477         return _name;
478     }
479 
480     /**
481      * @dev Returns the symbol of the token, usually a shorter version of the
482      * name.
483      */
484     function symbol() public view returns (string memory) {
485         return _symbol;
486     }
487 
488     /**
489      * @dev Returns the number of decimals used to get its user representation.
490      * For example, if `decimals` equals `2`, a balance of `505` tokens should
491      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
492      *
493      * Tokens usually opt for a value of 18, imitating the relationship between
494      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
495      * called.
496      *
497      * NOTE: This information is only used for _display_ purposes: it in
498      * no way affects any of the arithmetic of the contract, including
499      * {IERC20-balanceOf} and {IERC20-transfer}.
500      */
501     function decimals() public view returns (uint8) {
502         return _decimals;
503     }
504 
505     /**
506      * @dev See {IERC20-totalSupply}.
507      */
508     function totalSupply() public view override returns (uint256) {
509         return _totalSupply;
510     }
511 
512     /**
513      * @dev See {IERC20-balanceOf}.
514      */
515     function balanceOf(address account) public view override returns (uint256) {
516         return _balances[account];
517     }
518 
519     /**
520      * @dev See {IERC20-transfer}.
521      *
522      * Requirements:
523      *
524      * - `recipient` cannot be the zero address.
525      * - the caller must have a balance of at least `amount`.
526      */
527     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
528         _transfer(_msgSender(), recipient, amount);
529         return true;
530     }
531 
532     /**
533      * @dev See {IERC20-allowance}.
534      */
535     function allowance(address owner, address spender) public view virtual override returns (uint256) {
536         return _allowances[owner][spender];
537     }
538 
539     /**
540      * @dev See {IERC20-approve}.
541      *
542      * Requirements:
543      *
544      * - `spender` cannot be the zero address.
545      */
546     function approve(address spender, uint256 amount) public virtual override returns (bool) {
547         _approve(_msgSender(), spender, amount);
548         return true;
549     }
550 
551     /**
552      * @dev See {IERC20-transferFrom}.
553      *
554      * Emits an {Approval} event indicating the updated allowance. This is not
555      * required by the EIP. See the note at the beginning of {ERC20};
556      *
557      * Requirements:
558      * - `sender` and `recipient` cannot be the zero address.
559      * - `sender` must have a balance of at least `amount`.
560      * - the caller must have allowance for ``sender``'s tokens of at least
561      * `amount`.
562      */
563     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
564         _transfer(sender, recipient, amount);
565         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
566         return true;
567     }
568 
569     /**
570      * @dev Atomically increases the allowance granted to `spender` by the caller.
571      *
572      * This is an alternative to {approve} that can be used as a mitigation for
573      * problems described in {IERC20-approve}.
574      *
575      * Emits an {Approval} event indicating the updated allowance.
576      *
577      * Requirements:
578      *
579      * - `spender` cannot be the zero address.
580      */
581     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
582         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
583         return true;
584     }
585 
586     /**
587      * @dev Atomically decreases the allowance granted to `spender` by the caller.
588      *
589      * This is an alternative to {approve} that can be used as a mitigation for
590      * problems described in {IERC20-approve}.
591      *
592      * Emits an {Approval} event indicating the updated allowance.
593      *
594      * Requirements:
595      *
596      * - `spender` cannot be the zero address.
597      * - `spender` must have allowance for the caller of at least
598      * `subtractedValue`.
599      */
600     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
601         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
602         return true;
603     }
604 
605     /**
606      * @dev Moves tokens `amount` from `sender` to `recipient`.
607      *
608      * This is internal function is equivalent to {transfer}, and can be used to
609      * e.g. implement automatic token fees, slashing mechanisms, etc.
610      *
611      * Emits a {Transfer} event.
612      *
613      * Requirements:
614      *
615      * - `sender` cannot be the zero address.
616      * - `recipient` cannot be the zero address.
617      * - `sender` must have a balance of at least `amount`.
618      */
619     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
620         require(sender != address(0), "ERC20: transfer from the zero address");
621         require(recipient != address(0), "ERC20: transfer to the zero address");
622 
623         _beforeTokenTransfer(sender, recipient, amount);
624 
625         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
626         _balances[recipient] = _balances[recipient].add(amount);
627         emit Transfer(sender, recipient, amount);
628     }
629 
630     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
631      * the total supply.
632      *
633      * Emits a {Transfer} event with `from` set to the zero address.
634      *
635      * Requirements
636      *
637      * - `to` cannot be the zero address.
638      */
639     function _mint(address account, uint256 amount) internal virtual {
640         require(account != address(0), "ERC20: mint to the zero address");
641 
642         _beforeTokenTransfer(address(0), account, amount);
643 
644         _totalSupply = _totalSupply.add(amount);
645         _balances[account] = _balances[account].add(amount);
646         emit Transfer(address(0), account, amount);
647     }
648 
649     /**
650      * @dev Destroys `amount` tokens from `account`, reducing the
651      * total supply.
652      *
653      * Emits a {Transfer} event with `to` set to the zero address.
654      *
655      * Requirements
656      *
657      * - `account` cannot be the zero address.
658      * - `account` must have at least `amount` tokens.
659      */
660     function _burn(address account, uint256 amount) internal virtual {
661         require(account != address(0), "ERC20: burn from the zero address");
662 
663         _beforeTokenTransfer(account, address(0), amount);
664 
665         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
666         _totalSupply = _totalSupply.sub(amount);
667         emit Transfer(account, address(0), amount);
668     }
669 
670     /**
671      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
672      *
673      * This is internal function is equivalent to `approve`, and can be used to
674      * e.g. set automatic allowances for certain subsystems, etc.
675      *
676      * Emits an {Approval} event.
677      *
678      * Requirements:
679      *
680      * - `owner` cannot be the zero address.
681      * - `spender` cannot be the zero address.
682      */
683     function _approve(address owner, address spender, uint256 amount) internal virtual {
684         require(owner != address(0), "ERC20: approve from the zero address");
685         require(spender != address(0), "ERC20: approve to the zero address");
686 
687         _allowances[owner][spender] = amount;
688         emit Approval(owner, spender, amount);
689     }
690 
691     /**
692      * @dev Sets {decimals} to a value other than the default one of 18.
693      *
694      * WARNING: This function should only be called from the constructor. Most
695      * applications that interact with token contracts will not expect
696      * {decimals} to ever change, and may work incorrectly if it does.
697      */
698     function _setupDecimals(uint8 decimals_) internal {
699         _decimals = decimals_;
700     }
701 
702     /**
703      * @dev Hook that is called before any transfer of tokens. This includes
704      * minting and burning.
705      *
706      * Calling conditions:
707      *
708      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
709      * will be to transferred to `to`.
710      * - when `from` is zero, `amount` tokens will be minted for `to`.
711      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
712      * - `from` and `to` are never both zero.
713      *
714      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
715      */
716     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
717 }
718 
719 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
720 
721 
722 pragma solidity ^0.6.0;
723 
724 
725 
726 
727 /**
728  * @title SafeERC20
729  * @dev Wrappers around ERC20 operations that throw on failure (when the token
730  * contract returns false). Tokens that return no value (and instead revert or
731  * throw on failure) are also supported, non-reverting calls are assumed to be
732  * successful.
733  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
734  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
735  */
736 library SafeERC20 {
737     using SafeMath for uint256;
738     using Address for address;
739 
740     function safeTransfer(IERC20 token, address to, uint256 value) internal {
741         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
742     }
743 
744     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
745         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
746     }
747 
748     /**
749      * @dev Deprecated. This function has issues similar to the ones found in
750      * {IERC20-approve}, and its usage is discouraged.
751      *
752      * Whenever possible, use {safeIncreaseAllowance} and
753      * {safeDecreaseAllowance} instead.
754      */
755     function safeApprove(IERC20 token, address spender, uint256 value) internal {
756         // safeApprove should only be called when setting an initial allowance,
757         // or when resetting it to zero. To increase and decrease it, use
758         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
759         // solhint-disable-next-line max-line-length
760         require((value == 0) || (token.allowance(address(this), spender) == 0),
761             "SafeERC20: approve from non-zero to non-zero allowance"
762         );
763         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
764     }
765 
766     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
767         uint256 newAllowance = token.allowance(address(this), spender).add(value);
768         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
769     }
770 
771     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
772         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
773         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
774     }
775 
776     /**
777      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
778      * on the return value: the return value is optional (but if data is returned, it must not be false).
779      * @param token The token targeted by the call.
780      * @param data The call data (encoded using abi.encode or one of its variants).
781      */
782     function _callOptionalReturn(IERC20 token, bytes memory data) private {
783         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
784         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
785         // the target address contains contract code and also asserts for success in the low-level call.
786 
787         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
788         if (returndata.length > 0) { // Return data is optional
789             // solhint-disable-next-line max-line-length
790             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
791         }
792     }
793 }
794 
795 // File: @openzeppelin/contracts/access/Ownable.sol
796 
797 
798 pragma solidity ^0.6.0;
799 
800 /**
801  * @dev Contract module which provides a basic access control mechanism, where
802  * there is an account (an owner) that can be granted exclusive access to
803  * specific functions.
804  *
805  * By default, the owner account will be the one that deploys the contract. This
806  * can later be changed with {transferOwnership}.
807  *
808  * This module is used through inheritance. It will make available the modifier
809  * `onlyOwner`, which can be applied to your functions to restrict their use to
810  * the owner.
811  */
812 contract Ownable is Context {
813     address private _owner;
814 
815     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
816 
817     /**
818      * @dev Initializes the contract setting the deployer as the initial owner.
819      */
820     constructor () internal {
821         address msgSender = _msgSender();
822         _owner = msgSender;
823         emit OwnershipTransferred(address(0), msgSender);
824     }
825 
826     /**
827      * @dev Returns the address of the current owner.
828      */
829     function owner() public view returns (address) {
830         return _owner;
831     }
832 
833     /**
834      * @dev Throws if called by any account other than the owner.
835      */
836     modifier onlyOwner() {
837         require(_owner == _msgSender(), "Ownable: caller is not the owner");
838         _;
839     }
840 
841     /**
842      * @dev Leaves the contract without owner. It will not be possible to call
843      * `onlyOwner` functions anymore. Can only be called by the current owner.
844      *
845      * NOTE: Renouncing ownership will leave the contract without an owner,
846      * thereby removing any functionality that is only available to the owner.
847      */
848     function renounceOwnership() public virtual onlyOwner {
849         emit OwnershipTransferred(_owner, address(0));
850         _owner = address(0);
851     }
852 
853     /**
854      * @dev Transfers ownership of the contract to a new account (`newOwner`).
855      * Can only be called by the current owner.
856      */
857     function transferOwnership(address newOwner) public virtual onlyOwner {
858         require(newOwner != address(0), "Ownable: new owner is the zero address");
859         emit OwnershipTransferred(_owner, newOwner);
860         _owner = newOwner;
861     }
862 }
863 
864 // File: @chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol
865 
866 pragma solidity >=0.6.0;
867 
868 interface AggregatorV3Interface {
869   function decimals() external view returns (uint8);
870   function description() external view returns (string memory);
871   function version() external view returns (uint256);
872 
873   // getRoundData and latestRoundData should both raise "No data present"
874   // if they do not have data to report, instead of returning unset values
875   // which could be misinterpreted as actual reported values.
876   function getRoundData(uint80 _roundId)
877     external
878     view
879     returns (
880       uint80 roundId,
881       int256 answer,
882       uint256 startedAt,
883       uint256 updatedAt,
884       uint80 answeredInRound
885     );
886   function latestRoundData()
887     external
888     view
889     returns (
890       uint80 roundId,
891       int256 answer,
892       uint256 startedAt,
893       uint256 updatedAt,
894       uint80 answeredInRound
895     );
896 }
897 
898 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
899 
900 pragma solidity >=0.6.2;
901 
902 interface IUniswapV2Router01 {
903     function factory() external pure returns (address);
904     function WETH() external pure returns (address);
905 
906     function addLiquidity(
907         address tokenA,
908         address tokenB,
909         uint amountADesired,
910         uint amountBDesired,
911         uint amountAMin,
912         uint amountBMin,
913         address to,
914         uint deadline
915     ) external returns (uint amountA, uint amountB, uint liquidity);
916     function addLiquidityETH(
917         address token,
918         uint amountTokenDesired,
919         uint amountTokenMin,
920         uint amountETHMin,
921         address to,
922         uint deadline
923     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
924     function removeLiquidity(
925         address tokenA,
926         address tokenB,
927         uint liquidity,
928         uint amountAMin,
929         uint amountBMin,
930         address to,
931         uint deadline
932     ) external returns (uint amountA, uint amountB);
933     function removeLiquidityETH(
934         address token,
935         uint liquidity,
936         uint amountTokenMin,
937         uint amountETHMin,
938         address to,
939         uint deadline
940     ) external returns (uint amountToken, uint amountETH);
941     function removeLiquidityWithPermit(
942         address tokenA,
943         address tokenB,
944         uint liquidity,
945         uint amountAMin,
946         uint amountBMin,
947         address to,
948         uint deadline,
949         bool approveMax, uint8 v, bytes32 r, bytes32 s
950     ) external returns (uint amountA, uint amountB);
951     function removeLiquidityETHWithPermit(
952         address token,
953         uint liquidity,
954         uint amountTokenMin,
955         uint amountETHMin,
956         address to,
957         uint deadline,
958         bool approveMax, uint8 v, bytes32 r, bytes32 s
959     ) external returns (uint amountToken, uint amountETH);
960     function swapExactTokensForTokens(
961         uint amountIn,
962         uint amountOutMin,
963         address[] calldata path,
964         address to,
965         uint deadline
966     ) external returns (uint[] memory amounts);
967     function swapTokensForExactTokens(
968         uint amountOut,
969         uint amountInMax,
970         address[] calldata path,
971         address to,
972         uint deadline
973     ) external returns (uint[] memory amounts);
974     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
975         external
976         payable
977         returns (uint[] memory amounts);
978     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
979         external
980         returns (uint[] memory amounts);
981     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
982         external
983         returns (uint[] memory amounts);
984     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
985         external
986         payable
987         returns (uint[] memory amounts);
988 
989     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
990     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
991     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
992     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
993     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
994 }
995 
996 // File: contracts/Interfaces/Interfaces.sol
997 
998 pragma solidity 0.6.12;
999 
1000 /**
1001  * Hegic
1002  * Copyright (C) 2020 Hegic Protocol
1003  *
1004  * This program is free software: you can redistribute it and/or modify
1005  * it under the terms of the GNU General Public License as published by
1006  * the Free Software Foundation, either version 3 of the License, or
1007  * (at your option) any later version.
1008  *
1009  * This program is distributed in the hope that it will be useful,
1010  * but WITHOUT ANY WARRANTY; without even the implied warranty of
1011  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1012  * GNU General Public License for more details.
1013  *
1014  * You should have received a copy of the GNU General Public License
1015  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
1016  */
1017 
1018 
1019 
1020 
1021 
1022 
1023 
1024 interface ILiquidityPool {
1025     struct LockedLiquidity { uint amount; uint premium; bool locked; }
1026 
1027     event Profit(uint indexed id, uint amount);
1028     event Loss(uint indexed id, uint amount);
1029     event Provide(address indexed account, uint256 amount, uint256 writeAmount);
1030     event Withdraw(address indexed account, uint256 amount, uint256 writeAmount);
1031 
1032     function unlock(uint256 id) external;
1033     function send(uint256 id, address payable account, uint256 amount) external;
1034     function setLockupPeriod(uint value) external;
1035     function totalBalance() external view returns (uint256 amount);
1036     // function unlockPremium(uint256 amount) external;
1037 }
1038 
1039 
1040 interface IERCLiquidityPool is ILiquidityPool {
1041     function lock(uint id, uint256 amount, uint premium) external;
1042     function token() external view returns (IERC20);
1043 }
1044 
1045 
1046 interface IETHLiquidityPool is ILiquidityPool {
1047     function lock(uint id, uint256 amount) external payable;
1048 }
1049 
1050 
1051 interface IHegicStaking {    
1052     event Claim(address indexed acount, uint amount);
1053     event Profit(uint amount);
1054 
1055 
1056     function claimProfit() external returns (uint profit);
1057     function buy(uint amount) external;
1058     function sell(uint amount) external;
1059     function profitOf(address account) external view returns (uint);
1060 }
1061 
1062 
1063 interface IHegicStakingETH is IHegicStaking {
1064     function sendProfit() external payable;
1065 }
1066 
1067 
1068 interface IHegicStakingERC20 is IHegicStaking {
1069     function sendProfit(uint amount) external;
1070 }
1071 
1072 
1073 interface IHegicOptions {
1074     event Create(
1075         uint256 indexed id,
1076         address indexed account,
1077         uint256 settlementFee,
1078         uint256 totalFee
1079     );
1080 
1081     event Exercise(uint256 indexed id, uint256 profit);
1082     event Expire(uint256 indexed id, uint256 premium);
1083     enum State {Inactive, Active, Exercised, Expired}
1084     enum OptionType {Invalid, Put, Call}
1085 
1086     struct Option {
1087         State state;
1088         address payable holder;
1089         uint256 strike;
1090         uint256 amount;
1091         uint256 lockedAmount;
1092         uint256 premium;
1093         uint256 expiration;
1094         OptionType optionType;
1095     }
1096 
1097     function options(uint) external view returns (
1098         State state,
1099         address payable holder,
1100         uint256 strike,
1101         uint256 amount,
1102         uint256 lockedAmount,
1103         uint256 premium,
1104         uint256 expiration,
1105         OptionType optionType
1106     );
1107 }
1108 
1109 // For the future integrations of non-standard ERC20 tokens such as USDT and others
1110 // interface ERC20Incorrect {
1111 //     event Transfer(address indexed from, address indexed to, uint256 value);
1112 //
1113 //     event Approval(address indexed owner, address indexed spender, uint256 value);
1114 //
1115 //     function transfer(address to, uint256 value) external;
1116 //
1117 //     function transferFrom(
1118 //         address from,
1119 //         address to,
1120 //         uint256 value
1121 //     ) external;
1122 //
1123 //     function approve(address spender, uint256 value) external;
1124 //     function balanceOf(address who) external view returns (uint256);
1125 //     function allowance(address owner, address spender) external view returns (uint256);
1126 //
1127 // }
1128 
1129 // File: contracts/Pool/HegicWBTCPool.sol
1130 
1131 pragma solidity 0.6.12;
1132 
1133 /**
1134  * Hegic
1135  * Copyright (C) 2020 Hegic Protocol
1136  *
1137  * This program is free software: you can redistribute it and/or modify
1138  * it under the terms of the GNU General Public License as published by
1139  * the Free Software Foundation, either version 3 of the License, or
1140  * (at your option) any later version.
1141  *
1142  * This program is distributed in the hope that it will be useful,
1143  * but WITHOUT ANY WARRANTY; without even the implied warranty of
1144  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1145  * GNU General Public License for more details.
1146  *
1147  * You should have received a copy of the GNU General Public License
1148  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
1149  */
1150 
1151 
1152 
1153 /**
1154  * @author 0mllwntrmt3
1155  * @title Hegic WBTC Liquidity Pool
1156  * @notice Accumulates liquidity in WBTC from LPs and distributes P&L in WBTC
1157  */
1158 contract HegicERCPool is
1159     IERCLiquidityPool,
1160     Ownable,
1161     ERC20("Hegic WBTC LP Token", "writeWBTC")
1162 {
1163     using SafeMath for uint256;
1164     using SafeERC20 for IERC20;
1165     uint256 public constant INITIAL_RATE = 1e13;
1166     uint256 public lockupPeriod = 2 weeks;
1167     uint256 public lockedAmount;
1168     uint256 public lockedPremium;
1169     mapping(address => uint256) public lastProvideTimestamp;
1170     mapping(address => bool) public _revertTransfersInLockUpPeriod;
1171     LockedLiquidity[] public lockedLiquidity;
1172     IERC20 public override token;
1173 
1174     /*
1175      * @return _token WBTC Address
1176      */
1177     constructor(IERC20 _token) public {
1178         token = _token;
1179     }
1180 
1181     /**
1182      * @notice Used for changing the lockup period
1183      * @param value New period value
1184      */
1185     function setLockupPeriod(uint256 value) external override onlyOwner {
1186         require(value <= 60 days, "Lockup period is too large");
1187         lockupPeriod = value;
1188     }
1189 
1190     /*
1191      * @nonce calls by HegicPutOptions to lock funds
1192      * @param amount Amount of funds that should be locked in an option
1193      */
1194     function lock(uint id, uint256 amount, uint256 premium) external override onlyOwner {
1195         require(id == lockedLiquidity.length, "Wrong id");
1196 
1197         require(
1198             lockedAmount.add(amount).mul(10) <= totalBalance().mul(8),
1199             "Pool Error: Amount is too large."
1200         );
1201 
1202         lockedLiquidity.push(LockedLiquidity(amount, premium, true));
1203         lockedPremium = lockedPremium.add(premium);
1204         lockedAmount = lockedAmount.add(amount);
1205         token.safeTransferFrom(msg.sender, address(this), premium);
1206     }
1207 
1208     /*
1209      * @nonce Calls by HegicPutOptions to unlock funds
1210      * @param amount Amount of funds that should be unlocked in an expired option
1211      */
1212     function unlock(uint256 id) external override onlyOwner {
1213         LockedLiquidity storage ll = lockedLiquidity[id];
1214         require(ll.locked, "LockedLiquidity with such id has already unlocked");
1215         ll.locked = false;
1216 
1217         lockedPremium = lockedPremium.sub(ll.premium);
1218         lockedAmount = lockedAmount.sub(ll.amount);
1219 
1220         emit Profit(id, ll.premium);
1221     }
1222 
1223     /*
1224      * @nonce calls by HegicPutOptions to unlock the premiums after an option's expiraton
1225      * @param to Provider
1226      * @param amount Amount of premiums that should be unlocked
1227      */
1228     /*
1229      * @nonce calls by HegicCallOptions to send funds to liquidity providers after an option's expiration
1230      * @param to Provider
1231      * @param amount Funds that should be sent
1232      */
1233     function send(uint id, address payable to, uint256 amount)
1234         external
1235         override
1236         onlyOwner
1237     {
1238         LockedLiquidity storage ll = lockedLiquidity[id];
1239         require(ll.locked, "LockedLiquidity with such id has already unlocked");
1240         require(to != address(0));
1241 
1242         ll.locked = false;
1243         lockedPremium = lockedPremium.sub(ll.premium);
1244         lockedAmount = lockedAmount.sub(ll.amount);
1245 
1246         uint transferAmount = amount > ll.amount ? ll.amount : amount;
1247         token.safeTransfer(to, transferAmount);
1248 
1249         if (transferAmount <= ll.premium)
1250             emit Profit(id, ll.premium - transferAmount);
1251         else
1252             emit Loss(id, transferAmount - ll.premium);
1253     }
1254 
1255     /*
1256      * @nonce A provider supplies WBTC to the pool and receives writeWBTC tokens
1257      * @param amount Provided tokens
1258      * @param minMint Minimum amount of tokens that should be received by a provider.
1259                       Calling the provide function will require the minimum amount of tokens to be minted.
1260                       The actual amount that will be minted could vary but can only be higher (not lower) than the minimum value.
1261      * @return mint Amount of tokens to be received
1262      */
1263     function provide(uint256 amount, uint256 minMint) external returns (uint256 mint) {
1264         lastProvideTimestamp[msg.sender] = block.timestamp;
1265         uint supply = totalSupply();
1266         uint balance = totalBalance();
1267         if (supply > 0 && balance > 0)
1268             mint = amount.mul(supply).div(balance);
1269         else
1270             mint = amount.mul(INITIAL_RATE);
1271 
1272         require(mint >= minMint, "Pool: Mint limit is too large");
1273         require(mint > 0, "Pool: Amount is too small");
1274         _mint(msg.sender, mint);
1275         emit Provide(msg.sender, amount, mint);
1276 
1277         require(
1278             token.transferFrom(msg.sender, address(this), amount),
1279             "Token transfer error: Please lower the amount of premiums that you want to send."
1280         );
1281     }
1282 
1283     /*
1284      * @nonce Provider burns writeWBTC and receives WBTC from the pool
1285      * @param amount Amount of WBTC to receive
1286      * @param maxBurn Maximum amount of tokens that can be burned
1287      * @return mint Amount of tokens to be burnt
1288      */
1289     function withdraw(uint256 amount, uint256 maxBurn) external returns (uint256 burn) {
1290         require(
1291             lastProvideTimestamp[msg.sender].add(lockupPeriod) <= block.timestamp,
1292             "Pool: Withdrawal is locked up"
1293         );
1294         require(
1295             amount <= availableBalance(),
1296             "Pool Error: You are trying to unlock more funds than have been locked for your contract. Please lower the amount."
1297         );
1298 
1299         burn = divCeil(amount.mul(totalSupply()), totalBalance());
1300 
1301         require(burn <= maxBurn, "Pool: Burn limit is too small");
1302         require(burn <= balanceOf(msg.sender), "Pool: Amount is too large");
1303         require(burn > 0, "Pool: Amount is too small");
1304 
1305         _burn(msg.sender, burn);
1306         emit Withdraw(msg.sender, amount, burn);
1307         require(token.transfer(msg.sender, amount), "Insufficient funds");
1308     }
1309 
1310     /*
1311      * @nonce Returns provider's share in WBTC
1312      * @param account Provider's address
1313      * @return Provider's share in WBTC
1314      */
1315     function shareOf(address user) external view returns (uint256 share) {
1316         uint supply = totalSupply();
1317         if (supply > 0)
1318             share = totalBalance().mul(balanceOf(user)).div(supply);
1319         else
1320             share = 0;
1321     }
1322 
1323     /*
1324      * @nonce Returns the amount of WBTC available for withdrawals
1325      * @return balance Unlocked amount
1326      */
1327     function availableBalance() public view returns (uint256 balance) {
1328         return totalBalance().sub(lockedAmount);
1329     }
1330 
1331     /*
1332      * @nonce Returns the WBTC total balance provided to the pool
1333      * @return balance Pool balance
1334      */
1335     function totalBalance() public override view returns (uint256 balance) {
1336         return token.balanceOf(address(this)).sub(lockedPremium);
1337     }
1338 
1339     function _beforeTokenTransfer(address from, address to, uint256) internal override {
1340         if (
1341             lastProvideTimestamp[from].add(lockupPeriod) > block.timestamp &&
1342             lastProvideTimestamp[from] > lastProvideTimestamp[to]
1343         ) {
1344             require(
1345                 !_revertTransfersInLockUpPeriod[to],
1346                 "the recipient does not accept blocked funds"
1347             );
1348             lastProvideTimestamp[to] = lastProvideTimestamp[from];
1349         }
1350     }
1351 
1352     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
1353         require(b > 0);
1354         uint256 c = a / b;
1355         if (a % b != 0)
1356             c = c + 1;
1357         return c;
1358     }
1359 }
1360 
1361 // File: contracts/Options/HegicWBTCOptions.sol
1362 
1363 pragma solidity 0.6.12;
1364 
1365 /**
1366  * Hegic
1367  * Copyright (C) 2020 Hegic Protocol
1368  *
1369  * This program is free software: you can redistribute it and/or modify
1370  * it under the terms of the GNU General Public License as published by
1371  * the Free Software Foundation, either version 3 of the License, or
1372  * (at your option) any later version.
1373  *
1374  * This program is distributed in the hope that it will be useful,
1375  * but WITHOUT ANY WARRANTY; without even the implied warranty of
1376  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1377  * GNU General Public License for more details.
1378  *
1379  * You should have received a copy of the GNU General Public License
1380  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
1381  */
1382 
1383 
1384 
1385 /**
1386  * @author 0mllwntrmt3
1387  * @title Hegic WBTC (Wrapped Bitcoin) Bidirectional (Call and Put) Options
1388  * @notice Hegic Protocol Options Contract
1389  */
1390 contract HegicWBTCOptions is Ownable, IHegicOptions {
1391     using SafeMath for uint256;
1392     using SafeERC20 for IERC20;
1393 
1394     IHegicStakingERC20 public settlementFeeRecipient;
1395     Option[] public override options;
1396     uint256 public impliedVolRate;
1397     uint256 public optionCollateralizationRatio = 100;
1398     uint256 internal constant PRICE_DECIMALS = 1e8;
1399     uint256 internal contractCreationTimestamp;
1400     AggregatorV3Interface public priceProvider;
1401     HegicERCPool public pool;
1402     IUniswapV2Router01 public uniswapRouter;
1403     address[] public ethToWbtcSwapPath;
1404     IERC20 public wbtc;
1405 
1406     /**
1407      * @param _priceProvider The address of ChainLink BTC/USD price feed contract
1408      * @param _uniswap The address of Uniswap router contract
1409      * @param token The address of WBTC ERC20 token contract
1410      */
1411     constructor(
1412         AggregatorV3Interface _priceProvider,
1413         IUniswapV2Router01 _uniswap,
1414         ERC20 token,
1415         IHegicStakingERC20 _settlementFeeRecipient
1416     ) public {
1417         pool = new HegicERCPool(token);
1418         wbtc = token;
1419         priceProvider = _priceProvider;
1420         settlementFeeRecipient = _settlementFeeRecipient;
1421         impliedVolRate = 4500;
1422         uniswapRouter = _uniswap;
1423         contractCreationTimestamp = block.timestamp;
1424         approve();
1425 
1426         ethToWbtcSwapPath = new address[](2);
1427         ethToWbtcSwapPath[0] = uniswapRouter.WETH();
1428         ethToWbtcSwapPath[1] = address(wbtc);
1429 
1430     }
1431 
1432     /**
1433      * @notice Can be used to update the contract in critical situations
1434      *         in the first 14 days after deployment
1435      */
1436     function transferPoolOwnership() external onlyOwner {
1437         require(block.timestamp < contractCreationTimestamp + 14 days);
1438         pool.transferOwnership(owner());
1439     }
1440 
1441     /**
1442      * @notice Used for adjusting the options prices while balancing asset's implied volatility rate
1443      * @param value New IVRate value
1444      */
1445     function setImpliedVolRate(uint256 value) external onlyOwner {
1446         require(value >= 1000, "ImpliedVolRate limit is too small");
1447         impliedVolRate = value;
1448     }
1449 
1450     /**
1451      * @notice Used for changing settlementFeeRecipient
1452      * @param recipient New settlementFee recipient address
1453      */
1454     function setSettlementFeeRecipient(IHegicStakingERC20 recipient) external onlyOwner {
1455         require(block.timestamp < contractCreationTimestamp + 14 days);
1456         require(address(recipient) != address(0));
1457         settlementFeeRecipient = recipient;
1458     }
1459 
1460     /**
1461      * @notice Used for changing option collateralization ratio
1462      * @param value New optionCollateralizationRatio value
1463      */
1464     function setOptionCollaterizationRatio(uint value) external onlyOwner {
1465         require(50 <= value && value <= 100, "wrong value");
1466         optionCollateralizationRatio = value;
1467     }
1468 
1469     /**
1470      * @notice Creates a new option
1471      * @param period Option period in seconds (1 days <= period <= 4 weeks)
1472      * @param amount Option amount
1473      * @param strike Strike price of the option
1474      * @param optionType Call or Put option type
1475      * @return optionID Created option's ID
1476      */
1477     function create(
1478         uint256 period,
1479         uint256 amount,
1480         uint256 strike,
1481         OptionType optionType
1482     )
1483         external
1484         payable
1485         returns (uint256 optionID)
1486     {
1487         (uint256 total, uint256 totalETH, uint256 settlementFee, uint256 strikeFee, ) =
1488             fees(period, amount, strike, optionType);
1489         require(
1490             optionType == OptionType.Call || optionType == OptionType.Put,
1491             "Wrong option type"
1492         );
1493         require(period >= 1 days, "Period is too short");
1494         require(period <= 4 weeks, "Period is too long");
1495         require(amount > strikeFee, "price difference is too large");
1496 
1497         uint256 strikeAmount = amount.sub(strikeFee);
1498         uint premium = total.sub(settlementFee);
1499         optionID = options.length;
1500 
1501         Option memory option = Option(
1502             State.Active,
1503             msg.sender,
1504             strike,
1505             amount,
1506             strikeAmount.mul(optionCollateralizationRatio).div(100).add(strikeFee),
1507             premium,
1508             block.timestamp + period,
1509             optionType
1510         );
1511 
1512         uint amountIn = swapToWBTC(totalETH, total);
1513         if (amountIn < msg.value) {
1514             msg.sender.transfer(msg.value.sub(amountIn));
1515         }
1516 
1517         options.push(option);
1518         settlementFeeRecipient.sendProfit(settlementFee);
1519         pool.lock(optionID, option.lockedAmount, option.premium);
1520 
1521         emit Create(optionID, msg.sender, settlementFee, total);
1522     }
1523 
1524     /**
1525      * @notice Transfers an active option
1526      * @param optionID ID of your option
1527      * @param newHolder Address of new option holder
1528      */
1529     function transfer(uint256 optionID, address payable newHolder) external {
1530         Option storage option = options[optionID];
1531 
1532         require(newHolder != address(0), "new holder address is zero");
1533         require(option.expiration >= block.timestamp, "Option has expired");
1534         require(option.holder == msg.sender, "Wrong msg.sender");
1535         require(option.state == State.Active, "Only active option could be transferred");
1536 
1537         option.holder = newHolder;
1538     }
1539 
1540     /**
1541      * @notice Exercises an active option
1542      * @param optionID ID of your option
1543      */
1544     function exercise(uint256 optionID) external {
1545         Option storage option = options[optionID];
1546 
1547         require(option.expiration >= block.timestamp, "Option has expired");
1548         require(option.holder == msg.sender, "Wrong msg.sender");
1549         require(option.state == State.Active, "Wrong state");
1550 
1551         option.state = State.Exercised;
1552         uint256 profit = payProfit(optionID);
1553 
1554         emit Exercise(optionID, profit);
1555     }
1556 
1557     /**
1558      * @notice Unlocks an array of options
1559      * @param optionIDs array of options
1560      */
1561     function unlockAll(uint256[] calldata optionIDs) external {
1562         uint arrayLength = optionIDs.length;
1563         for (uint256 i = 0; i < arrayLength; i++) {
1564             unlock(optionIDs[i]);
1565         }
1566     }
1567 
1568     /**
1569      * @notice Allows the ERC pool contract to receive and send tokens
1570      */
1571     function approve() public {
1572         wbtc.safeApprove(address(pool), uint(-1));
1573         wbtc.safeApprove(address(settlementFeeRecipient), uint(-1));
1574     }
1575 
1576     /**
1577      * @notice Used for getting the actual options prices
1578      * @param period Option period in seconds (1 days <= period <= 4 weeks)
1579      * @param amount Option amount
1580      * @param strike Strike price of the option
1581      * @return total Total price to be paid
1582      * @return totalETH Total price in ETH to be paid
1583      * @return settlementFee Amount to be distributed to the HEGIC token holders
1584      * @return strikeFee Amount that covers the price difference in the ITM options
1585      * @return periodFee Option period fee amount
1586      */
1587     function fees(
1588         uint256 period,
1589         uint256 amount,
1590         uint256 strike,
1591         OptionType optionType
1592     )
1593         public
1594         view
1595         returns (
1596             uint256 total,
1597             uint256 totalETH,
1598             uint256 settlementFee,
1599             uint256 strikeFee,
1600             uint256 periodFee
1601         )
1602     {
1603         (, int latestPrice, , , ) = priceProvider.latestRoundData();
1604         uint256 currentPrice = uint256(latestPrice);
1605         settlementFee = getSettlementFee(amount);
1606         periodFee = getPeriodFee(amount, period, strike, currentPrice, optionType);
1607         strikeFee = getStrikeFee(amount, strike, currentPrice, optionType);
1608         total = periodFee.add(strikeFee).add(settlementFee);
1609         totalETH = uniswapRouter.getAmountsIn(total, ethToWbtcSwapPath)[0];
1610     }
1611 
1612     /**
1613      * @notice Unlock funds locked in the expired options
1614      * @param optionID ID of the option
1615      */
1616     function unlock(uint256 optionID) public {
1617         Option storage option = options[optionID];
1618         require(option.expiration < block.timestamp, "Option has not expired yet");
1619         require(option.state == State.Active, "Option is not active");
1620         option.state = State.Expired;
1621         pool.unlock(optionID);
1622         emit Expire(optionID, option.premium);
1623     }
1624 
1625     /**
1626      * @notice Calculates settlementFee
1627      * @param amount Option amount
1628      * @return fee Settlement fee amount
1629      */
1630     function getSettlementFee(uint256 amount)
1631         internal
1632         pure
1633         returns (uint256 fee)
1634     {
1635         return amount / 100;
1636     }
1637 
1638     /**
1639      * @notice Calculates periodFee
1640      * @param amount Option amount
1641      * @param period Option period in seconds (1 days <= period <= 4 weeks)
1642      * @param strike Strike price of the option
1643      * @param currentPrice Current price of BTC
1644      * @return fee Period fee amount
1645      *
1646      * amount < 1e30        |
1647      * impliedVolRate < 1e10| => amount * impliedVolRate * strike < 1e60 < 2^uint256
1648      * strike < 1e20 ($1T)  |
1649      *
1650      * in case amount * impliedVolRate * strike >= 2^256
1651      * transaction will be reverted by the SafeMath
1652      */
1653     function getPeriodFee(
1654         uint256 amount,
1655         uint256 period,
1656         uint256 strike,
1657         uint256 currentPrice,
1658         OptionType optionType
1659     ) internal view returns (uint256 fee) {
1660         if (optionType == OptionType.Put)
1661             return amount
1662                 .mul(sqrt(period))
1663                 .mul(impliedVolRate)
1664                 .mul(strike)
1665                 .div(currentPrice)
1666                 .div(PRICE_DECIMALS);
1667         else
1668             return amount
1669                 .mul(sqrt(period))
1670                 .mul(impliedVolRate)
1671                 .mul(currentPrice)
1672                 .div(strike)
1673                 .div(PRICE_DECIMALS);
1674     }
1675 
1676     /**
1677      * @notice Calculates strikeFee
1678      * @param amount Option amount
1679      * @param strike Strike price of the option
1680      * @param currentPrice Current price of BTC
1681      * @return fee Strike fee amount
1682      */
1683     function getStrikeFee(
1684         uint256 amount,
1685         uint256 strike,
1686         uint256 currentPrice,
1687         OptionType optionType
1688     ) internal pure returns (uint256 fee) {
1689         if (strike > currentPrice && optionType == OptionType.Put)
1690             return strike.sub(currentPrice).mul(amount).div(currentPrice);
1691         if (strike < currentPrice && optionType == OptionType.Call)
1692             return currentPrice.sub(strike).mul(amount).div(currentPrice);
1693         return 0;
1694     }
1695 
1696     /**
1697      * @notice Sends profits in WBTC from the WBTC pool to an option holder's address
1698      * @param optionID A specific option contract id
1699      */
1700     function payProfit(uint optionID)
1701         internal
1702         returns (uint profit)
1703     {
1704         Option memory option = options[optionID];
1705         (, int latestPrice, , , ) = priceProvider.latestRoundData();
1706         uint256 currentPrice = uint256(latestPrice);
1707         if (option.optionType == OptionType.Call) {
1708             require(option.strike <= currentPrice, "Current price is too low");
1709             profit = currentPrice.sub(option.strike).mul(option.amount).div(currentPrice);
1710         } else {
1711             require(option.strike >= currentPrice, "Current price is too high");
1712             profit = option.strike.sub(currentPrice).mul(option.amount).div(currentPrice);
1713         }
1714         if (profit > option.lockedAmount)
1715             profit = option.lockedAmount;
1716         pool.send(optionID, option.holder, profit);
1717     }
1718 
1719     /**
1720      * @notice Swap ETH to WBTC via Uniswap router
1721      * @param maxAmountIn The maximum amount of ETH that can be required before the transaction reverts.
1722      * @param amountOut The amount of WBTC tokens to receive.
1723      */
1724     function swapToWBTC(
1725         uint maxAmountIn,
1726         uint amountOut
1727     )
1728         internal
1729         returns (uint)
1730     {
1731             uint[] memory amounts = uniswapRouter.swapETHForExactTokens {
1732                 value: maxAmountIn
1733             }(
1734                 amountOut,
1735                 ethToWbtcSwapPath,
1736                 address(this),
1737                 block.timestamp
1738             );
1739             return amounts[0];
1740     }
1741 
1742     /**
1743      * @return result Square root of the number
1744      */
1745     function sqrt(uint256 x) private pure returns (uint256 result) {
1746         result = x;
1747         uint256 k = x.div(2).add(1);
1748         while (k < result) (result, k) = (k, x.div(k).add(k).div(2));
1749     }
1750 }