1 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
2 
3 // SPDX-License-Identifier: MIT
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
28 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
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
107 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
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
268 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
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
411 // File: node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol
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
719 // File: node_modules\@openzeppelin\contracts\utils\Pausable.sol
720 
721 
722 pragma solidity ^0.6.0;
723 
724 
725 /**
726  * @dev Contract module which allows children to implement an emergency stop
727  * mechanism that can be triggered by an authorized account.
728  *
729  * This module is used through inheritance. It will make available the
730  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
731  * the functions of your contract. Note that they will not be pausable by
732  * simply including this module, only once the modifiers are put in place.
733  */
734 contract Pausable is Context {
735     /**
736      * @dev Emitted when the pause is triggered by `account`.
737      */
738     event Paused(address account);
739 
740     /**
741      * @dev Emitted when the pause is lifted by `account`.
742      */
743     event Unpaused(address account);
744 
745     bool private _paused;
746 
747     /**
748      * @dev Initializes the contract in unpaused state.
749      */
750     constructor () internal {
751         _paused = false;
752     }
753 
754     /**
755      * @dev Returns true if the contract is paused, and false otherwise.
756      */
757     function paused() public view returns (bool) {
758         return _paused;
759     }
760 
761     /**
762      * @dev Modifier to make a function callable only when the contract is not paused.
763      *
764      * Requirements:
765      *
766      * - The contract must not be paused.
767      */
768     modifier whenNotPaused() {
769         require(!_paused, "Pausable: paused");
770         _;
771     }
772 
773     /**
774      * @dev Modifier to make a function callable only when the contract is paused.
775      *
776      * Requirements:
777      *
778      * - The contract must be paused.
779      */
780     modifier whenPaused() {
781         require(_paused, "Pausable: not paused");
782         _;
783     }
784 
785     /**
786      * @dev Triggers stopped state.
787      *
788      * Requirements:
789      *
790      * - The contract must not be paused.
791      */
792     function _pause() internal virtual whenNotPaused {
793         _paused = true;
794         emit Paused(_msgSender());
795     }
796 
797     /**
798      * @dev Returns to normal state.
799      *
800      * Requirements:
801      *
802      * - The contract must be paused.
803      */
804     function _unpause() internal virtual whenPaused {
805         _paused = false;
806         emit Unpaused(_msgSender());
807     }
808 }
809 
810 // File: @openzeppelin\contracts\token\ERC20\ERC20Pausable.sol
811 
812 
813 pragma solidity ^0.6.0;
814 
815 
816 
817 /**
818  * @dev ERC20 token with pausable token transfers, minting and burning.
819  *
820  * Useful for scenarios such as preventing trades until the end of an evaluation
821  * period, or having an emergency switch for freezing all token transfers in the
822  * event of a large bug.
823  */
824 abstract contract ERC20Pausable is ERC20, Pausable {
825     /**
826      * @dev See {ERC20-_beforeTokenTransfer}.
827      *
828      * Requirements:
829      *
830      * - the contract must not be paused.
831      */
832     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
833         super._beforeTokenTransfer(from, to, amount);
834 
835         require(!paused(), "ERC20Pausable: token transfer while paused");
836     }
837 }
838 
839 
840 // File: node_modules\@openzeppelin\contracts\utils\EnumerableSet.sol
841 
842 
843 pragma solidity ^0.6.0;
844 
845 /**
846  * @dev Library for managing
847  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
848  * types.
849  *
850  * Sets have the following properties:
851  *
852  * - Elements are added, removed, and checked for existence in constant time
853  * (O(1)).
854  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
855  *
856  * ```
857  * contract Example {
858  *     // Add the library methods
859  *     using EnumerableSet for EnumerableSet.AddressSet;
860  *
861  *     // Declare a set state variable
862  *     EnumerableSet.AddressSet private mySet;
863  * }
864  * ```
865  *
866  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
867  * (`UintSet`) are supported.
868  */
869 library EnumerableSet {
870     // To implement this library for multiple types with as little code
871     // repetition as possible, we write it in terms of a generic Set type with
872     // bytes32 values.
873     // The Set implementation uses private functions, and user-facing
874     // implementations (such as AddressSet) are just wrappers around the
875     // underlying Set.
876     // This means that we can only create new EnumerableSets for types that fit
877     // in bytes32.
878 
879     struct Set {
880         // Storage of set values
881         bytes32[] _values;
882 
883         // Position of the value in the `values` array, plus 1 because index 0
884         // means a value is not in the set.
885         mapping (bytes32 => uint256) _indexes;
886     }
887 
888     /**
889      * @dev Add a value to a set. O(1).
890      *
891      * Returns true if the value was added to the set, that is if it was not
892      * already present.
893      */
894     function _add(Set storage set, bytes32 value) private returns (bool) {
895         if (!_contains(set, value)) {
896             set._values.push(value);
897             // The value is stored at length-1, but we add 1 to all indexes
898             // and use 0 as a sentinel value
899             set._indexes[value] = set._values.length;
900             return true;
901         } else {
902             return false;
903         }
904     }
905 
906     /**
907      * @dev Removes a value from a set. O(1).
908      *
909      * Returns true if the value was removed from the set, that is if it was
910      * present.
911      */
912     function _remove(Set storage set, bytes32 value) private returns (bool) {
913         // We read and store the value's index to prevent multiple reads from the same storage slot
914         uint256 valueIndex = set._indexes[value];
915 
916         if (valueIndex != 0) { // Equivalent to contains(set, value)
917             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
918             // the array, and then remove the last element (sometimes called as 'swap and pop').
919             // This modifies the order of the array, as noted in {at}.
920 
921             uint256 toDeleteIndex = valueIndex - 1;
922             uint256 lastIndex = set._values.length - 1;
923 
924             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
925             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
926 
927             bytes32 lastvalue = set._values[lastIndex];
928 
929             // Move the last value to the index where the value to delete is
930             set._values[toDeleteIndex] = lastvalue;
931             // Update the index for the moved value
932             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
933 
934             // Delete the slot where the moved value was stored
935             set._values.pop();
936 
937             // Delete the index for the deleted slot
938             delete set._indexes[value];
939 
940             return true;
941         } else {
942             return false;
943         }
944     }
945 
946     /**
947      * @dev Returns true if the value is in the set. O(1).
948      */
949     function _contains(Set storage set, bytes32 value) private view returns (bool) {
950         return set._indexes[value] != 0;
951     }
952 
953     /**
954      * @dev Returns the number of values on the set. O(1).
955      */
956     function _length(Set storage set) private view returns (uint256) {
957         return set._values.length;
958     }
959 
960    /**
961     * @dev Returns the value stored at position `index` in the set. O(1).
962     *
963     * Note that there are no guarantees on the ordering of values inside the
964     * array, and it may change when more values are added or removed.
965     *
966     * Requirements:
967     *
968     * - `index` must be strictly less than {length}.
969     */
970     function _at(Set storage set, uint256 index) private view returns (bytes32) {
971         require(set._values.length > index, "EnumerableSet: index out of bounds");
972         return set._values[index];
973     }
974 
975     // AddressSet
976 
977     struct AddressSet {
978         Set _inner;
979     }
980 
981     /**
982      * @dev Add a value to a set. O(1).
983      *
984      * Returns true if the value was added to the set, that is if it was not
985      * already present.
986      */
987     function add(AddressSet storage set, address value) internal returns (bool) {
988         return _add(set._inner, bytes32(uint256(value)));
989     }
990 
991     /**
992      * @dev Removes a value from a set. O(1).
993      *
994      * Returns true if the value was removed from the set, that is if it was
995      * present.
996      */
997     function remove(AddressSet storage set, address value) internal returns (bool) {
998         return _remove(set._inner, bytes32(uint256(value)));
999     }
1000 
1001     /**
1002      * @dev Returns true if the value is in the set. O(1).
1003      */
1004     function contains(AddressSet storage set, address value) internal view returns (bool) {
1005         return _contains(set._inner, bytes32(uint256(value)));
1006     }
1007 
1008     /**
1009      * @dev Returns the number of values in the set. O(1).
1010      */
1011     function length(AddressSet storage set) internal view returns (uint256) {
1012         return _length(set._inner);
1013     }
1014 
1015    /**
1016     * @dev Returns the value stored at position `index` in the set. O(1).
1017     *
1018     * Note that there are no guarantees on the ordering of values inside the
1019     * array, and it may change when more values are added or removed.
1020     *
1021     * Requirements:
1022     *
1023     * - `index` must be strictly less than {length}.
1024     */
1025     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1026         return address(uint256(_at(set._inner, index)));
1027     }
1028 
1029 
1030     // UintSet
1031 
1032     struct UintSet {
1033         Set _inner;
1034     }
1035 
1036     /**
1037      * @dev Add a value to a set. O(1).
1038      *
1039      * Returns true if the value was added to the set, that is if it was not
1040      * already present.
1041      */
1042     function add(UintSet storage set, uint256 value) internal returns (bool) {
1043         return _add(set._inner, bytes32(value));
1044     }
1045 
1046     /**
1047      * @dev Removes a value from a set. O(1).
1048      *
1049      * Returns true if the value was removed from the set, that is if it was
1050      * present.
1051      */
1052     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1053         return _remove(set._inner, bytes32(value));
1054     }
1055 
1056     /**
1057      * @dev Returns true if the value is in the set. O(1).
1058      */
1059     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1060         return _contains(set._inner, bytes32(value));
1061     }
1062 
1063     /**
1064      * @dev Returns the number of values on the set. O(1).
1065      */
1066     function length(UintSet storage set) internal view returns (uint256) {
1067         return _length(set._inner);
1068     }
1069 
1070    /**
1071     * @dev Returns the value stored at position `index` in the set. O(1).
1072     *
1073     * Note that there are no guarantees on the ordering of values inside the
1074     * array, and it may change when more values are added or removed.
1075     *
1076     * Requirements:
1077     *
1078     * - `index` must be strictly less than {length}.
1079     */
1080     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1081         return uint256(_at(set._inner, index));
1082     }
1083 }
1084 
1085 // File: @openzeppelin\contracts\access\AccessControl.sol
1086 
1087 
1088 pragma solidity ^0.6.0;
1089 
1090 
1091 
1092 
1093 /**
1094  * @dev Contract module that allows children to implement role-based access
1095  * control mechanisms.
1096  *
1097  * Roles are referred to by their `bytes32` identifier. These should be exposed
1098  * in the external API and be unique. The best way to achieve this is by
1099  * using `public constant` hash digests:
1100  *
1101  * ```
1102  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1103  * ```
1104  *
1105  * Roles can be used to represent a set of permissions. To restrict access to a
1106  * function call, use {hasRole}:
1107  *
1108  * ```
1109  * function foo() public {
1110  *     require(hasRole(MY_ROLE, msg.sender));
1111  *     ...
1112  * }
1113  * ```
1114  *
1115  * Roles can be granted and revoked dynamically via the {grantRole} and
1116  * {revokeRole} functions. Each role has an associated admin role, and only
1117  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1118  *
1119  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1120  * that only accounts with this role will be able to grant or revoke other
1121  * roles. More complex role relationships can be created by using
1122  * {_setRoleAdmin}.
1123  *
1124  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1125  * grant and revoke this role. Extra precautions should be taken to secure
1126  * accounts that have been granted it.
1127  */
1128 abstract contract AccessControl is Context {
1129     using EnumerableSet for EnumerableSet.AddressSet;
1130     using Address for address;
1131 
1132     struct RoleData {
1133         EnumerableSet.AddressSet members;
1134         bytes32 adminRole;
1135     }
1136 
1137     mapping (bytes32 => RoleData) private _roles;
1138 
1139     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1140 
1141     /**
1142      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1143      *
1144      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1145      * {RoleAdminChanged} not being emitted signaling this.
1146      *
1147      * _Available since v3.1._
1148      */
1149     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1150 
1151     /**
1152      * @dev Emitted when `account` is granted `role`.
1153      *
1154      * `sender` is the account that originated the contract call, an admin role
1155      * bearer except when using {_setupRole}.
1156      */
1157     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1158 
1159     /**
1160      * @dev Emitted when `account` is revoked `role`.
1161      *
1162      * `sender` is the account that originated the contract call:
1163      *   - if using `revokeRole`, it is the admin role bearer
1164      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1165      */
1166     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1167 
1168     /**
1169      * @dev Returns `true` if `account` has been granted `role`.
1170      */
1171     function hasRole(bytes32 role, address account) public view returns (bool) {
1172         return _roles[role].members.contains(account);
1173     }
1174 
1175     /**
1176      * @dev Returns the number of accounts that have `role`. Can be used
1177      * together with {getRoleMember} to enumerate all bearers of a role.
1178      */
1179     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1180         return _roles[role].members.length();
1181     }
1182 
1183     /**
1184      * @dev Returns one of the accounts that have `role`. `index` must be a
1185      * value between 0 and {getRoleMemberCount}, non-inclusive.
1186      *
1187      * Role bearers are not sorted in any particular way, and their ordering may
1188      * change at any point.
1189      *
1190      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1191      * you perform all queries on the same block. See the following
1192      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1193      * for more information.
1194      */
1195     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1196         return _roles[role].members.at(index);
1197     }
1198 
1199     /**
1200      * @dev Returns the admin role that controls `role`. See {grantRole} and
1201      * {revokeRole}.
1202      *
1203      * To change a role's admin, use {_setRoleAdmin}.
1204      */
1205     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1206         return _roles[role].adminRole;
1207     }
1208 
1209     /**
1210      * @dev Grants `role` to `account`.
1211      *
1212      * If `account` had not been already granted `role`, emits a {RoleGranted}
1213      * event.
1214      *
1215      * Requirements:
1216      *
1217      * - the caller must have ``role``'s admin role.
1218      */
1219     function grantRole(bytes32 role, address account) public virtual {
1220         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1221 
1222         _grantRole(role, account);
1223     }
1224 
1225     /**
1226      * @dev Revokes `role` from `account`.
1227      *
1228      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1229      *
1230      * Requirements:
1231      *
1232      * - the caller must have ``role``'s admin role.
1233      */
1234     function revokeRole(bytes32 role, address account) public virtual {
1235         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1236 
1237         _revokeRole(role, account);
1238     }
1239 
1240     /**
1241      * @dev Revokes `role` from the calling account.
1242      *
1243      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1244      * purpose is to provide a mechanism for accounts to lose their privileges
1245      * if they are compromised (such as when a trusted device is misplaced).
1246      *
1247      * If the calling account had been granted `role`, emits a {RoleRevoked}
1248      * event.
1249      *
1250      * Requirements:
1251      *
1252      * - the caller must be `account`.
1253      */
1254     function renounceRole(bytes32 role, address account) public virtual {
1255         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1256 
1257         _revokeRole(role, account);
1258     }
1259 
1260     /**
1261      * @dev Grants `role` to `account`.
1262      *
1263      * If `account` had not been already granted `role`, emits a {RoleGranted}
1264      * event. Note that unlike {grantRole}, this function doesn't perform any
1265      * checks on the calling account.
1266      *
1267      * [WARNING]
1268      * ====
1269      * This function should only be called from the constructor when setting
1270      * up the initial roles for the system.
1271      *
1272      * Using this function in any other way is effectively circumventing the admin
1273      * system imposed by {AccessControl}.
1274      * ====
1275      */
1276     function _setupRole(bytes32 role, address account) internal virtual {
1277         _grantRole(role, account);
1278     }
1279 
1280     /**
1281      * @dev Sets `adminRole` as ``role``'s admin role.
1282      *
1283      * Emits a {RoleAdminChanged} event.
1284      */
1285     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1286         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1287         _roles[role].adminRole = adminRole;
1288     }
1289 
1290     function _grantRole(bytes32 role, address account) private {
1291         if (_roles[role].members.add(account)) {
1292             emit RoleGranted(role, account, _msgSender());
1293         }
1294     }
1295 
1296     function _revokeRole(bytes32 role, address account) private {
1297         if (_roles[role].members.remove(account)) {
1298             emit RoleRevoked(role, account, _msgSender());
1299         }
1300     }
1301 }
1302 
1303 // File: contracts\interface\IMintBurn.sol
1304 
1305 
1306 pragma solidity ^0.6.12;
1307 
1308 interface IMintBurn {
1309 
1310     function burn(address account, uint amount) external;
1311     function mint(address account, uint amount) external;
1312 }
1313 
1314 // File: contracts\interface\IPause.sol
1315 
1316 
1317 pragma solidity ^0.6.12;
1318 
1319 interface IPause {
1320     function pause() external;
1321     function unpause() external;
1322 }
1323 
1324 // File: contracts\token\BaseToken.sol
1325 
1326 
1327 pragma solidity ^0.6.12;
1328 
1329 
1330 
1331 
1332 
1333 
1334 contract BaseToken is ERC20Pausable, AccessControl, IMintBurn, IPause{
1335     bytes32 public constant MINTER_ROLE ="MINTER_ROLE";
1336     bytes32 public constant BURNER_ROLE ="BURNER_ROLE";
1337     bytes32 public constant LIQUIDATION = "LIQUIDATION";
1338     constructor(
1339         string memory _name,
1340         string memory _symbol,
1341         uint8 decimal_,
1342         address admin
1343     ) public ERC20(_name, _symbol) {
1344         _setupRole(DEFAULT_ADMIN_ROLE, admin);
1345         _setupDecimals(decimal_);
1346     }
1347 
1348     function mint(address account, uint amount) public override onlyMinter{
1349         _mint(account, amount);
1350     }
1351 
1352     function burn(address account, uint amount) public override onlyBurner{
1353         _burn(account, amount);
1354     }
1355 
1356     function pause() public override onlyLiquidation {
1357         _pause();
1358     }
1359 
1360     function unpause() public override onlyLiquidation {
1361         _unpause();
1362     }
1363 
1364     // minter will only be tunnel
1365     modifier onlyMinter {
1366         require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
1367         _;
1368     }
1369 
1370     modifier onlyBurner {
1371         require(hasRole(BURNER_ROLE, msg.sender), "Caller is not a burner");
1372         _;
1373     }
1374 
1375     modifier onlyLiquidation {
1376         require(hasRole(LIQUIDATION, msg.sender), "Caller is not liquidation contract");
1377         _;
1378     }
1379 }
1380 
1381 // File: contracts\token\OToken.sol
1382 
1383 
1384 pragma solidity ^0.6.12;
1385 
1386 
1387 contract OToken is BaseToken {
1388 
1389     constructor(
1390         string memory name_,
1391         string memory symbol_,
1392         uint8 decimal_,
1393         address admin
1394     ) public BaseToken(name_, symbol_, decimal_, admin) {}
1395 
1396 }