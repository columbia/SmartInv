1 pragma solidity ^0.6.0;
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
24 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
25 
26 // SPDX-License-Identifier: MIT
27 
28 pragma solidity ^0.6.0;
29 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 // File: @openzeppelin/contracts/math/SafeMath.sol
105 
106 // SPDX-License-Identifier: MIT
107 
108 pragma solidity ^0.6.0;
109 
110 /**
111  * @dev Wrappers over Solidity's arithmetic operations with added overflow
112  * checks.
113  *
114  * Arithmetic operations in Solidity wrap on overflow. This can easily result
115  * in bugs, because programmers usually assume that an overflow raises an
116  * error, which is the standard behavior in high level programming languages.
117  * `SafeMath` restores this intuition by reverting the transaction when an
118  * operation overflows.
119  *
120  * Using this library instead of the unchecked operations eliminates an entire
121  * class of bugs, so it's recommended to use it always.
122  */
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `+` operator.
129      *
130      * Requirements:
131      *
132      * - Addition cannot overflow.
133      */
134     function add(uint256 a, uint256 b) internal pure returns (uint256) {
135         uint256 c = a + b;
136         require(c >= a, "SafeMath: addition overflow");
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the subtraction of two unsigned integers, reverting on
143      * overflow (when the result is negative).
144      *
145      * Counterpart to Solidity's `-` operator.
146      *
147      * Requirements:
148      *
149      * - Subtraction cannot overflow.
150      */
151     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152         return sub(a, b, "SafeMath: subtraction overflow");
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      *
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
166         require(b <= a, errorMessage);
167         uint256 c = a - b;
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the multiplication of two unsigned integers, reverting on
174      * overflow.
175      *
176      * Counterpart to Solidity's `*` operator.
177      *
178      * Requirements:
179      *
180      * - Multiplication cannot overflow.
181      */
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184         // benefit is lost if 'b' is also tested.
185         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186         if (a == 0) {
187             return 0;
188         }
189 
190         uint256 c = a * b;
191         require(c / a == b, "SafeMath: multiplication overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b) internal pure returns (uint256) {
209         return div(a, b, "SafeMath: division by zero");
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b > 0, errorMessage);
226         uint256 c = a / b;
227         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
245         return mod(a, b, "SafeMath: modulo by zero");
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts with custom message when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         require(b != 0, errorMessage);
262         return a % b;
263     }
264 }
265 
266 // File: @openzeppelin/contracts/utils/Address.sol
267 
268 // SPDX-License-Identifier: MIT
269 
270 pragma solidity ^0.6.2;
271 
272 /**
273  * @dev Collection of functions related to the address type
274  */
275 library Address {
276     /**
277      * @dev Returns true if `account` is a contract.
278      *
279      * [IMPORTANT]
280      * ====
281      * It is unsafe to assume that an address for which this function returns
282      * false is an externally-owned account (EOA) and not a contract.
283      *
284      * Among others, `isContract` will return false for the following
285      * types of addresses:
286      *
287      *  - an externally-owned account
288      *  - a contract in construction
289      *  - an address where a contract will be created
290      *  - an address where a contract lived, but was destroyed
291      * ====
292      */
293     function isContract(address account) internal view returns (bool) {
294         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
295         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
296         // for accounts without code, i.e. `keccak256('')`
297         bytes32 codehash;
298         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
299         // solhint-disable-next-line no-inline-assembly
300         assembly { codehash := extcodehash(account) }
301         return (codehash != accountHash && codehash != 0x0);
302     }
303 
304     /**
305      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
306      * `recipient`, forwarding all available gas and reverting on errors.
307      *
308      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
309      * of certain opcodes, possibly making contracts go over the 2300 gas limit
310      * imposed by `transfer`, making them unable to receive funds via
311      * `transfer`. {sendValue} removes this limitation.
312      *
313      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
314      *
315      * IMPORTANT: because control is transferred to `recipient`, care must be
316      * taken to not create reentrancy vulnerabilities. Consider using
317      * {ReentrancyGuard} or the
318      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
319      */
320     function sendValue(address payable recipient, uint256 amount) internal {
321         require(address(this).balance >= amount, "Address: insufficient balance");
322 
323         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
324         (bool success, ) = recipient.call{ value: amount }("");
325         require(success, "Address: unable to send value, recipient may have reverted");
326     }
327 
328     /**
329      * @dev Performs a Solidity function call using a low level `call`. A
330      * plain`call` is an unsafe replacement for a function call: use this
331      * function instead.
332      *
333      * If `target` reverts with a revert reason, it is bubbled up by this
334      * function (like regular Solidity function calls).
335      *
336      * Returns the raw returned data. To convert to the expected return value,
337      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
338      *
339      * Requirements:
340      *
341      * - `target` must be a contract.
342      * - calling `target` with `data` must not revert.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
347       return functionCall(target, data, "Address: low-level call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
352      * `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
357         return _functionCallWithValue(target, data, 0, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but also transferring `value` wei to `target`.
363      *
364      * Requirements:
365      *
366      * - the calling contract must have an ETH balance of at least `value`.
367      * - the called Solidity function must be `payable`.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
372         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
377      * with `errorMessage` as a fallback revert reason when `target` reverts.
378      *
379      * _Available since v3.1._
380      */
381     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
382         require(address(this).balance >= value, "Address: insufficient balance for call");
383         return _functionCallWithValue(target, data, value, errorMessage);
384     }
385 
386     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
387         require(isContract(target), "Address: call to non-contract");
388 
389         // solhint-disable-next-line avoid-low-level-calls
390         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
391         if (success) {
392             return returndata;
393         } else {
394             // Look for revert reason and bubble it up if present
395             if (returndata.length > 0) {
396                 // The easiest way to bubble the revert reason is using memory via assembly
397 
398                 // solhint-disable-next-line no-inline-assembly
399                 assembly {
400                     let returndata_size := mload(returndata)
401                     revert(add(32, returndata), returndata_size)
402                 }
403             } else {
404                 revert(errorMessage);
405             }
406         }
407     }
408 }
409 
410 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
411 
412 // SPDX-License-Identifier: MIT
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
719 // File: @openzeppelin/contracts/access/Ownable.sol
720 
721 // SPDX-License-Identifier: MIT
722 
723 pragma solidity ^0.6.0;
724 
725 /**
726  * @dev Contract module which provides a basic access control mechanism, where
727  * there is an account (an owner) that can be granted exclusive access to
728  * specific functions.
729  *
730  * By default, the owner account will be the one that deploys the contract. This
731  * can later be changed with {transferOwnership}.
732  *
733  * This module is used through inheritance. It will make available the modifier
734  * `onlyOwner`, which can be applied to your functions to restrict their use to
735  * the owner.
736  */
737 contract Ownable is Context {
738     address private _owner;
739 
740     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
741 
742     /**
743      * @dev Initializes the contract setting the deployer as the initial owner.
744      */
745     constructor () internal {
746         address msgSender = _msgSender();
747         _owner = msgSender;
748         emit OwnershipTransferred(address(0), msgSender);
749     }
750 
751     /**
752      * @dev Returns the address of the current owner.
753      */
754     function owner() public view returns (address) {
755         return _owner;
756     }
757 
758     /**
759      * @dev Throws if called by any account other than the owner.
760      */
761     modifier onlyOwner() {
762         require(_owner == _msgSender(), "Ownable: caller is not the owner");
763         _;
764     }
765 
766     /**
767      * @dev Leaves the contract without owner. It will not be possible to call
768      * `onlyOwner` functions anymore. Can only be called by the current owner.
769      *
770      * NOTE: Renouncing ownership will leave the contract without an owner,
771      * thereby removing any functionality that is only available to the owner.
772      */
773     function renounceOwnership() public virtual onlyOwner {
774         emit OwnershipTransferred(_owner, address(0));
775         _owner = address(0);
776     }
777 
778     /**
779      * @dev Transfers ownership of the contract to a new account (`newOwner`).
780      * Can only be called by the current owner.
781      */
782     function transferOwnership(address newOwner) public virtual onlyOwner {
783         require(newOwner != address(0), "Ownable: new owner is the zero address");
784         emit OwnershipTransferred(_owner, newOwner);
785         _owner = newOwner;
786     }
787 }
788 
789 // File: contracts/NiceToken.sol
790 
791 pragma solidity ^0.6.2;
792 
793 
794 
795 // SushiToken with Governance.
796 contract NiceToken is ERC20("NiceToken", "NICE"), Ownable {
797     // START OF NICE SPECIFIC CODE
798 
799     // NICE is a copy of SUSHI https://etherscan.io/token/0x6b3595068778dd592e39a122f4f5a5cf09c90fe2
800     // except for the following code, which implements 
801     // a burn percent on each transfer. The burn percent (burnDivisor) 
802     // is set periodically and automatically by the 
803     // contract owner (PoliceChief contract) to make sure
804     // NICE total supply remains pegged between 69 and 420
805 
806     // It also fixes the governance move delegate bug
807     // https://medium.com/bulldax-finance/sushiswap-delegation-double-spending-bug-5adcc7b3830f
808 
809     using SafeMath for uint256;
810 
811     // the amount of burn during every transfer, i.e. 100 = 1%, 50 = 2%, 40 = 2.5%
812     uint256 public burnDivisor = 100;
813     // keep track of total supply burned (for fun only, serves no purpose)
814     uint256 public totalSupplyBurned;
815 
816     function setBurnDivisor(uint256 _burnDivisor) public onlyOwner {
817         require(_burnDivisor > 3, "NICE::setBurnDivisor: burnDivisor must be bigger than 3"); // 100 / 4 == 25% max burn
818         burnDivisor = _burnDivisor;
819     }
820 
821     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
822         // calculate burn amount
823         uint256 burnAmount = amount.div(burnDivisor);
824         // burn burn amount
825         burn(msg.sender, burnAmount);
826         // fix governance delegate bug
827         _moveDelegates(_delegates[msg.sender], _delegates[recipient], amount.sub(burnAmount));
828         // transfer amount minus burn amount
829         return super.transfer(recipient, amount.sub(burnAmount));
830     }
831 
832     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
833         // calculate burn amount
834         uint256 burnAmount = amount.div(burnDivisor);
835         // burn burn amount
836         burn(sender, burnAmount);
837         // fix governance delegate bug
838         _moveDelegates(_delegates[sender], _delegates[recipient], amount.sub(burnAmount));
839         // transfer amount minus burn amount
840         return super.transferFrom(sender, recipient, amount.sub(burnAmount));
841     }
842 
843     // we need to implement our own burn function similar to 
844     // sushi's mint function in order to call _moveDelegates
845     // and to keep track of totalSupplyBurned
846     function burn(address account, uint256 amount) private {
847         _burn(account, amount);
848         // keep track of total supply burned
849         totalSupplyBurned = totalSupplyBurned.add(amount);
850         // fix governance delegate bug
851         _moveDelegates(_delegates[account], address(0), amount);
852     }
853 
854     // END OF NICE SPECIFIC CODE
855 
856     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (PoliceChef).
857     function mint(address _to, uint256 _amount) public onlyOwner {
858         _mint(_to, _amount);
859         _moveDelegates(address(0), _delegates[_to], _amount);
860     }
861 
862     // Copied and modified from YAM code:
863     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
864     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
865     // Which is copied and modified from COMPOUND:
866     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
867 
868     /// @notice A record of each accounts delegate
869     mapping (address => address) internal _delegates;
870 
871     /// @notice A checkpoint for marking number of votes from a given block
872     struct Checkpoint {
873         uint32 fromBlock;
874         uint256 votes;
875     }
876 
877     /// @notice A record of votes checkpoints for each account, by index
878     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
879 
880     /// @notice The number of checkpoints for each account
881     mapping (address => uint32) public numCheckpoints;
882 
883     /// @notice The EIP-712 typehash for the contract's domain
884     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
885 
886     /// @notice The EIP-712 typehash for the delegation struct used by the contract
887     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
888 
889     /// @notice A record of states for signing / validating signatures
890     mapping (address => uint) public nonces;
891 
892       /// @notice An event thats emitted when an account changes its delegate
893     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
894 
895     /// @notice An event thats emitted when a delegate account's vote balance changes
896     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
897 
898     /**
899      * @notice Delegate votes from `msg.sender` to `delegatee`
900      * @param delegator The address to get delegatee for
901      */
902     function delegates(address delegator)
903         external
904         view
905         returns (address)
906     {
907         return _delegates[delegator];
908     }
909 
910    /**
911     * @notice Delegate votes from `msg.sender` to `delegatee`
912     * @param delegatee The address to delegate votes to
913     */
914     function delegate(address delegatee) external {
915         return _delegate(msg.sender, delegatee);
916     }
917 
918     /**
919      * @notice Delegates votes from signatory to `delegatee`
920      * @param delegatee The address to delegate votes to
921      * @param nonce The contract state required to match the signature
922      * @param expiry The time at which to expire the signature
923      * @param v The recovery byte of the signature
924      * @param r Half of the ECDSA signature pair
925      * @param s Half of the ECDSA signature pair
926      */
927     function delegateBySig(
928         address delegatee,
929         uint nonce,
930         uint expiry,
931         uint8 v,
932         bytes32 r,
933         bytes32 s
934     )
935         external
936     {
937         bytes32 domainSeparator = keccak256(
938             abi.encode(
939                 DOMAIN_TYPEHASH,
940                 keccak256(bytes(name())),
941                 getChainId(),
942                 address(this)
943             )
944         );
945 
946         bytes32 structHash = keccak256(
947             abi.encode(
948                 DELEGATION_TYPEHASH,
949                 delegatee,
950                 nonce,
951                 expiry
952             )
953         );
954 
955         bytes32 digest = keccak256(
956             abi.encodePacked(
957                 "\x19\x01",
958                 domainSeparator,
959                 structHash
960             )
961         );
962 
963         address signatory = ecrecover(digest, v, r, s);
964         require(signatory != address(0), "SUSHI::delegateBySig: invalid signature");
965         require(nonce == nonces[signatory]++, "SUSHI::delegateBySig: invalid nonce");
966         require(now <= expiry, "SUSHI::delegateBySig: signature expired");
967         return _delegate(signatory, delegatee);
968     }
969 
970     /**
971      * @notice Gets the current votes balance for `account`
972      * @param account The address to get votes balance
973      * @return The number of current votes for `account`
974      */
975     function getCurrentVotes(address account)
976         external
977         view
978         returns (uint256)
979     {
980         uint32 nCheckpoints = numCheckpoints[account];
981         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
982     }
983 
984     /**
985      * @notice Determine the prior number of votes for an account as of a block number
986      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
987      * @param account The address of the account to check
988      * @param blockNumber The block number to get the vote balance at
989      * @return The number of votes the account had as of the given block
990      */
991     function getPriorVotes(address account, uint blockNumber)
992         external
993         view
994         returns (uint256)
995     {
996         require(blockNumber < block.number, "SUSHI::getPriorVotes: not yet determined");
997 
998         uint32 nCheckpoints = numCheckpoints[account];
999         if (nCheckpoints == 0) {
1000             return 0;
1001         }
1002 
1003         // First check most recent balance
1004         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1005             return checkpoints[account][nCheckpoints - 1].votes;
1006         }
1007 
1008         // Next check implicit zero balance
1009         if (checkpoints[account][0].fromBlock > blockNumber) {
1010             return 0;
1011         }
1012 
1013         uint32 lower = 0;
1014         uint32 upper = nCheckpoints - 1;
1015         while (upper > lower) {
1016             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1017             Checkpoint memory cp = checkpoints[account][center];
1018             if (cp.fromBlock == blockNumber) {
1019                 return cp.votes;
1020             } else if (cp.fromBlock < blockNumber) {
1021                 lower = center;
1022             } else {
1023                 upper = center - 1;
1024             }
1025         }
1026         return checkpoints[account][lower].votes;
1027     }
1028 
1029     function _delegate(address delegator, address delegatee)
1030         internal
1031     {
1032         address currentDelegate = _delegates[delegator];
1033         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying SUSHIs (not scaled);
1034         _delegates[delegator] = delegatee;
1035 
1036         emit DelegateChanged(delegator, currentDelegate, delegatee);
1037 
1038         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1039     }
1040 
1041     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1042         if (srcRep != dstRep && amount > 0) {
1043             if (srcRep != address(0)) {
1044                 // decrease old representative
1045                 uint32 srcRepNum = numCheckpoints[srcRep];
1046                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1047                 uint256 srcRepNew = srcRepOld.sub(amount);
1048                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1049             }
1050 
1051             if (dstRep != address(0)) {
1052                 // increase new representative
1053                 uint32 dstRepNum = numCheckpoints[dstRep];
1054                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1055                 uint256 dstRepNew = dstRepOld.add(amount);
1056                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1057             }
1058         }
1059     }
1060 
1061     function _writeCheckpoint(
1062         address delegatee,
1063         uint32 nCheckpoints,
1064         uint256 oldVotes,
1065         uint256 newVotes
1066     )
1067         internal
1068     {
1069         uint32 blockNumber = safe32(block.number, "SUSHI::_writeCheckpoint: block number exceeds 32 bits");
1070 
1071         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1072             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1073         } else {
1074             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1075             numCheckpoints[delegatee] = nCheckpoints + 1;
1076         }
1077 
1078         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1079     }
1080 
1081     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1082         require(n < 2**32, errorMessage);
1083         return uint32(n);
1084     }
1085 
1086     function getChainId() internal pure returns (uint) {
1087         uint256 chainId;
1088         assembly { chainId := chainid() }
1089         return chainId;
1090     }
1091 }