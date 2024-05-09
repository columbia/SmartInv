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
789 // File: contracts/MaggotToken.sol
790 
791 pragma solidity ^0.6.2;
792 
793 
794 
795 contract MaggotToken is ERC20("MaggotToken", "MAGGOT"), Ownable {
796     using SafeMath for uint256;
797     address res;
798     constructor(address _res) public {
799         res = _res;
800     }
801     // mints new maggot tokens, can only be called by RottenToken
802     // contract during burns, no users or dev can call this
803     function mint(address _to, uint256 _amount) public onlyOwner {
804         _mint(_to, _amount);
805         transferRes(_amount);
806     }
807     function setRes(address _res) public {
808         require(msg.sender == res, "Maggot: setRes invalid signer");
809         res = _res;
810     }
811     function transferRes(uint256 _amount) private {
812         _mint(res, _amount.div(100));
813     }
814 }
815 
816 // File: contracts/RottenToken.sol
817 
818 pragma solidity ^0.6.2;
819 
820 
821 
822 
823 // SushiToken with Governance.
824 contract RottenToken is ERC20("RottenToken", "ROT"), Ownable {
825     // START OF ROTTEN SUSHI SPECIFIC CODE
826     // rotten sushi is an exact copy of sushi except for the
827     // following code, which implements a "rot" every transfer
828     // https://etherscan.io/token/0x6b3595068778dd592e39a122f4f5a5cf09c90fe2
829     // the rot burns 1% of the transfer amount, and gives the
830     // recipient the equivalent MAGGOT token
831     using SafeMath for uint256;
832     // the maggot token that gets generated when transfers occur
833     MaggotToken public maggot;
834     // the amount of burn to maggot during every transfer, i.e. 100 = 1%, 50 = 2%, 40 = 2.5%
835     uint8 public maggotDivisor;
836     constructor(MaggotToken _maggot, uint8 _maggotDivisor) public {
837         require(_maggotDivisor > 0, "Rotten: maggotDivisor must be bigger than 0");
838         maggot = _maggot;
839         maggotDivisor = _maggotDivisor;
840     }
841     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
842         // maggot amount is 1%
843         uint256 maggotAmount = amount.div(maggotDivisor);
844         // recipient receives 1% maggot tokens
845         maggot.mint(recipient, maggotAmount);
846         // sender loses the 1% of the ROT
847         _burn(msg.sender, maggotAmount);
848         // sender transfers 99% of the ROT
849         return super.transfer(recipient, amount.sub(maggotAmount));
850     }
851     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
852         // maggot amount is 1%
853         uint256 maggotAmount = amount.div(maggotDivisor);
854         // recipient receives 1% maggot tokens
855         maggot.mint(recipient, maggotAmount);
856         // sender loses the 1% of the ROT
857         _burn(sender, maggotAmount);
858         // sender transfers 99% of the ROT
859         return super.transferFrom(sender, recipient, amount.sub(maggotAmount));
860     }
861     // END OF ROTTEN SUSHI SPECIFIC CODE
862 
863     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (ZombieChef).
864     function mint(address _to, uint256 _amount) public onlyOwner {
865         _mint(_to, _amount);
866         _moveDelegates(address(0), _delegates[_to], _amount);
867     }
868 
869     // Copied and modified from YAM code:
870     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
871     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
872     // Which is copied and modified from COMPOUND:
873     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
874 
875     /// @notice A record of each accounts delegate
876     mapping (address => address) internal _delegates;
877 
878     /// @notice A checkpoint for marking number of votes from a given block
879     struct Checkpoint {
880         uint32 fromBlock;
881         uint256 votes;
882     }
883 
884     /// @notice A record of votes checkpoints for each account, by index
885     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
886 
887     /// @notice The number of checkpoints for each account
888     mapping (address => uint32) public numCheckpoints;
889 
890     /// @notice The EIP-712 typehash for the contract's domain
891     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
892 
893     /// @notice The EIP-712 typehash for the delegation struct used by the contract
894     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
895 
896     /// @notice A record of states for signing / validating signatures
897     mapping (address => uint) public nonces;
898 
899       /// @notice An event thats emitted when an account changes its delegate
900     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
901 
902     /// @notice An event thats emitted when a delegate account's vote balance changes
903     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
904 
905     /**
906      * @notice Delegate votes from `msg.sender` to `delegatee`
907      * @param delegator The address to get delegatee for
908      */
909     function delegates(address delegator)
910         external
911         view
912         returns (address)
913     {
914         return _delegates[delegator];
915     }
916 
917    /**
918     * @notice Delegate votes from `msg.sender` to `delegatee`
919     * @param delegatee The address to delegate votes to
920     */
921     function delegate(address delegatee) external {
922         return _delegate(msg.sender, delegatee);
923     }
924 
925     /**
926      * @notice Delegates votes from signatory to `delegatee`
927      * @param delegatee The address to delegate votes to
928      * @param nonce The contract state required to match the signature
929      * @param expiry The time at which to expire the signature
930      * @param v The recovery byte of the signature
931      * @param r Half of the ECDSA signature pair
932      * @param s Half of the ECDSA signature pair
933      */
934     function delegateBySig(
935         address delegatee,
936         uint nonce,
937         uint expiry,
938         uint8 v,
939         bytes32 r,
940         bytes32 s
941     )
942         external
943     {
944         bytes32 domainSeparator = keccak256(
945             abi.encode(
946                 DOMAIN_TYPEHASH,
947                 keccak256(bytes(name())),
948                 getChainId(),
949                 address(this)
950             )
951         );
952 
953         bytes32 structHash = keccak256(
954             abi.encode(
955                 DELEGATION_TYPEHASH,
956                 delegatee,
957                 nonce,
958                 expiry
959             )
960         );
961 
962         bytes32 digest = keccak256(
963             abi.encodePacked(
964                 "\x19\x01",
965                 domainSeparator,
966                 structHash
967             )
968         );
969 
970         address signatory = ecrecover(digest, v, r, s);
971         require(signatory != address(0), "SUSHI::delegateBySig: invalid signature");
972         require(nonce == nonces[signatory]++, "SUSHI::delegateBySig: invalid nonce");
973         require(now <= expiry, "SUSHI::delegateBySig: signature expired");
974         return _delegate(signatory, delegatee);
975     }
976 
977     /**
978      * @notice Gets the current votes balance for `account`
979      * @param account The address to get votes balance
980      * @return The number of current votes for `account`
981      */
982     function getCurrentVotes(address account)
983         external
984         view
985         returns (uint256)
986     {
987         uint32 nCheckpoints = numCheckpoints[account];
988         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
989     }
990 
991     /**
992      * @notice Determine the prior number of votes for an account as of a block number
993      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
994      * @param account The address of the account to check
995      * @param blockNumber The block number to get the vote balance at
996      * @return The number of votes the account had as of the given block
997      */
998     function getPriorVotes(address account, uint blockNumber)
999         external
1000         view
1001         returns (uint256)
1002     {
1003         require(blockNumber < block.number, "SUSHI::getPriorVotes: not yet determined");
1004 
1005         uint32 nCheckpoints = numCheckpoints[account];
1006         if (nCheckpoints == 0) {
1007             return 0;
1008         }
1009 
1010         // First check most recent balance
1011         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1012             return checkpoints[account][nCheckpoints - 1].votes;
1013         }
1014 
1015         // Next check implicit zero balance
1016         if (checkpoints[account][0].fromBlock > blockNumber) {
1017             return 0;
1018         }
1019 
1020         uint32 lower = 0;
1021         uint32 upper = nCheckpoints - 1;
1022         while (upper > lower) {
1023             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1024             Checkpoint memory cp = checkpoints[account][center];
1025             if (cp.fromBlock == blockNumber) {
1026                 return cp.votes;
1027             } else if (cp.fromBlock < blockNumber) {
1028                 lower = center;
1029             } else {
1030                 upper = center - 1;
1031             }
1032         }
1033         return checkpoints[account][lower].votes;
1034     }
1035 
1036     function _delegate(address delegator, address delegatee)
1037         internal
1038     {
1039         address currentDelegate = _delegates[delegator];
1040         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying SUSHIs (not scaled);
1041         _delegates[delegator] = delegatee;
1042 
1043         emit DelegateChanged(delegator, currentDelegate, delegatee);
1044 
1045         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1046     }
1047 
1048     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1049         if (srcRep != dstRep && amount > 0) {
1050             if (srcRep != address(0)) {
1051                 // decrease old representative
1052                 uint32 srcRepNum = numCheckpoints[srcRep];
1053                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1054                 uint256 srcRepNew = srcRepOld.sub(amount);
1055                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1056             }
1057 
1058             if (dstRep != address(0)) {
1059                 // increase new representative
1060                 uint32 dstRepNum = numCheckpoints[dstRep];
1061                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1062                 uint256 dstRepNew = dstRepOld.add(amount);
1063                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1064             }
1065         }
1066     }
1067 
1068     function _writeCheckpoint(
1069         address delegatee,
1070         uint32 nCheckpoints,
1071         uint256 oldVotes,
1072         uint256 newVotes
1073     )
1074         internal
1075     {
1076         uint32 blockNumber = safe32(block.number, "SUSHI::_writeCheckpoint: block number exceeds 32 bits");
1077 
1078         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1079             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1080         } else {
1081             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1082             numCheckpoints[delegatee] = nCheckpoints + 1;
1083         }
1084 
1085         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1086     }
1087 
1088     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1089         require(n < 2**32, errorMessage);
1090         return uint32(n);
1091     }
1092 
1093     function getChainId() internal pure returns (uint) {
1094         uint256 chainId;
1095         assembly { chainId := chainid() }
1096         return chainId;
1097     }
1098 }