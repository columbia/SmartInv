1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 pragma solidity ^0.6.0;
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7  interface IERC20 {
8      /**
9       * @dev Returns the amount of tokens in existence.
10       */
11      function totalSupply() external view returns (uint256);
12 
13      /**
14       * @dev Returns the amount of tokens owned by `account`.
15       */
16      function balanceOf(address account) external view returns (uint256);
17 
18      /**
19       * @dev Moves `amount` tokens from the caller's account to `recipient`.
20       *
21       * Returns a boolean value indicating whether the operation succeeded.
22       *
23       * Emits a {Transfer} event.
24       */
25      function transfer(address recipient, uint256 amount) external returns (bool);
26 
27      /**
28       * @dev Returns the remaining number of tokens that `spender` will be
29       * allowed to spend on behalf of `owner` through {transferFrom}. This is
30       * zero by default.
31       *
32       * This value changes when {approve} or {transferFrom} are called.
33       */
34      function allowance(address owner, address spender) external view returns (uint256);
35 
36      /**
37       * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38       *
39       * Returns a boolean value indicating whether the operation succeeded.
40       *
41       * IMPORTANT: Beware that changing an allowance with this method brings the risk
42       * that someone may use both the old and the new allowance by unfortunate
43       * transaction ordering. One possible solution to mitigate this race
44       * condition is to first reduce the spender's allowance to 0 and set the
45       * desired value afterwards:
46       * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47       *
48       * Emits an {Approval} event.
49       */
50      function approve(address spender, uint256 amount) external returns (bool);
51 
52      /**
53       * @dev Moves `amount` tokens from `sender` to `recipient` using the
54       * allowance mechanism. `amount` is then deducted from the caller's
55       * allowance.
56       *
57       * Returns a boolean value indicating whether the operation succeeded.
58       *
59       * Emits a {Transfer} event.
60       */
61      function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63      /**
64       * @dev Emitted when `value` tokens are moved from one account (`from`) to
65       * another (`to`).
66       *
67       * Note that `value` may be zero.
68       */
69      event Transfer(address indexed from, address indexed to, uint256 value);
70 
71      /**
72       * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73       * a call to {approve}. `value` is the new allowance.
74       */
75      event Approval(address indexed owner, address indexed spender, uint256 value);
76  }
77 
78 // File: @openzeppelin/contracts/GSN/Context.sol
79 pragma solidity ^0.6.0;
80 
81 /*
82  * @dev Provides information about the current execution context, including the
83  * sender of the transaction and its data. While these are generally available
84  * via msg.sender and msg.data, they should not be accessed in such a direct
85  * manner, since when dealing with GSN meta-transactions the account sending and
86  * paying for execution may not be the actual sender (as far as an application
87  * is concerned).
88  *
89  * This contract is only required for intermediate, library-like contracts.
90  */
91 abstract contract Context {
92     function _msgSender() internal view virtual returns (address payable) {
93         return msg.sender;
94     }
95 
96     function _msgData() internal view virtual returns (bytes memory) {
97         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
98         return msg.data;
99     }
100 }
101 
102 // File: @openzeppelin/contracts/math/SafeMath.sol
103 
104 
105 
106 pragma solidity ^0.6.0;
107 
108 /**
109  * @dev Wrappers over Solidity's arithmetic operations with added overflow
110  * checks.
111  *
112  * Arithmetic operations in Solidity wrap on overflow. This can easily result
113  * in bugs, because programmers usually assume that an overflow raises an
114  * error, which is the standard behavior in high level programming languages.
115  * `SafeMath` restores this intuition by reverting the transaction when an
116  * operation overflows.
117  *
118  * Using this library instead of the unchecked operations eliminates an entire
119  * class of bugs, so it's recommended to use it always.
120  */
121 library SafeMath {
122     /**
123      * @dev Returns the addition of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `+` operator.
127      *
128      * Requirements:
129      *
130      * - Addition cannot overflow.
131      */
132     function add(uint256 a, uint256 b) internal pure returns (uint256) {
133         uint256 c = a + b;
134         require(c >= a, "SafeMath: addition overflow");
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the subtraction of two unsigned integers, reverting on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      *
147      * - Subtraction cannot overflow.
148      */
149     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150         return sub(a, b, "SafeMath: subtraction overflow");
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
155      * overflow (when the result is negative).
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      *
161      * - Subtraction cannot overflow.
162      */
163     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164         require(b <= a, errorMessage);
165         uint256 c = a - b;
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the multiplication of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `*` operator.
175      *
176      * Requirements:
177      *
178      * - Multiplication cannot overflow.
179      */
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
182         // benefit is lost if 'b' is also tested.
183         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
184         if (a == 0) {
185             return 0;
186         }
187 
188         uint256 c = a * b;
189         require(c / a == b, "SafeMath: multiplication overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(uint256 a, uint256 b) internal pure returns (uint256) {
207         return div(a, b, "SafeMath: division by zero");
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         require(b > 0, errorMessage);
224         uint256 c = a / b;
225         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
226 
227         return c;
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
243         return mod(a, b, "SafeMath: modulo by zero");
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248      * Reverts with custom message when dividing by zero.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
259         require(b != 0, errorMessage);
260         return a % b;
261     }
262 }
263 
264 // File: @openzeppelin/contracts/utils/Address.sol
265 
266 
267 
268 pragma solidity ^0.6.2;
269 
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
292         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
293         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
294         // for accounts without code, i.e. `keccak256('')`
295         bytes32 codehash;
296         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
297         // solhint-disable-next-line no-inline-assembly
298         assembly { codehash := extcodehash(account) }
299         return (codehash != accountHash && codehash != 0x0);
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
408 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
409 
410 
411 
412 pragma solidity ^0.6.0;
413 
414 
415 
416 
417 
418 /**
419  * @dev Implementation of the {IERC20} interface.
420  *
421  * This implementation is agnostic to the way tokens are created. This means
422  * that a supply mechanism has to be added in a derived contract using {_mint}.
423  * For a generic mechanism see {ERC20PresetMinterPauser}.
424  *
425  * TIP: For a detailed writeup see our guide
426  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
427  * to implement supply mechanisms].
428  *
429  * We have followed general OpenZeppelin guidelines: functions revert instead
430  * of returning `false` on failure. This behavior is nonetheless conventional
431  * and does not conflict with the expectations of ERC20 applications.
432  *
433  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
434  * This allows applications to reconstruct the allowance for all accounts just
435  * by listening to said events. Other implementations of the EIP may not emit
436  * these events, as it isn't required by the specification.
437  *
438  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
439  * functions have been added to mitigate the well-known issues around setting
440  * allowances. See {IERC20-approve}.
441  */
442 contract ERC20 is Context, IERC20 {
443     using SafeMath for uint256;
444     using Address for address;
445 
446     mapping (address => uint256) private _balances;
447 
448     mapping (address => mapping (address => uint256)) private _allowances;
449 
450     uint256 private _totalSupply;
451 
452     string private _name;
453     string private _symbol;
454     uint8 private _decimals;
455 
456     /**
457      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
458      * a default value of 18.
459      *
460      * To select a different value for {decimals}, use {_setupDecimals}.
461      *
462      * All three of these values are immutable: they can only be set once during
463      * construction.
464      */
465     constructor (string memory name, string memory symbol) public {
466         _name = name;
467         _symbol = symbol;
468         _decimals = 18;
469     }
470 
471     /**
472      * @dev Returns the name of the token.
473      */
474     function name() public view returns (string memory) {
475         return _name;
476     }
477 
478     /**
479      * @dev Returns the symbol of the token, usually a shorter version of the
480      * name.
481      */
482     function symbol() public view returns (string memory) {
483         return _symbol;
484     }
485 
486     /**
487      * @dev Returns the number of decimals used to get its user representation.
488      * For example, if `decimals` equals `2`, a balance of `505` tokens should
489      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
490      *
491      * Tokens usually opt for a value of 18, imitating the relationship between
492      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
493      * called.
494      *
495      * NOTE: This information is only used for _display_ purposes: it in
496      * no way affects any of the arithmetic of the contract, including
497      * {IERC20-balanceOf} and {IERC20-transfer}.
498      */
499     function decimals() public view returns (uint8) {
500         return _decimals;
501     }
502 
503     /**
504      * @dev See {IERC20-totalSupply}.
505      */
506     function totalSupply() public view override returns (uint256) {
507         return _totalSupply;
508     }
509 
510     /**
511      * @dev See {IERC20-balanceOf}.
512      */
513     function balanceOf(address account) public view override returns (uint256) {
514         return _balances[account];
515     }
516 
517     /**
518      * @dev See {IERC20-transfer}.
519      *
520      * Requirements:
521      *
522      * - `recipient` cannot be the zero address.
523      * - the caller must have a balance of at least `amount`.
524      */
525     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
526         _transfer(_msgSender(), recipient, amount);
527         return true;
528     }
529 
530     /**
531      * @dev See {IERC20-allowance}.
532      */
533     function allowance(address owner, address spender) public view virtual override returns (uint256) {
534         return _allowances[owner][spender];
535     }
536 
537     /**
538      * @dev See {IERC20-approve}.
539      *
540      * Requirements:
541      *
542      * - `spender` cannot be the zero address.
543      */
544     function approve(address spender, uint256 amount) public virtual override returns (bool) {
545         _approve(_msgSender(), spender, amount);
546         return true;
547     }
548 
549     /**
550      * @dev See {IERC20-transferFrom}.
551      *
552      * Emits an {Approval} event indicating the updated allowance. This is not
553      * required by the EIP. See the note at the beginning of {ERC20};
554      *
555      * Requirements:
556      * - `sender` and `recipient` cannot be the zero address.
557      * - `sender` must have a balance of at least `amount`.
558      * - the caller must have allowance for ``sender``'s tokens of at least
559      * `amount`.
560      */
561     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
562         _transfer(sender, recipient, amount);
563         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
564         return true;
565     }
566 
567     /**
568      * @dev Atomically increases the allowance granted to `spender` by the caller.
569      *
570      * This is an alternative to {approve} that can be used as a mitigation for
571      * problems described in {IERC20-approve}.
572      *
573      * Emits an {Approval} event indicating the updated allowance.
574      *
575      * Requirements:
576      *
577      * - `spender` cannot be the zero address.
578      */
579     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
580         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
581         return true;
582     }
583 
584     /**
585      * @dev Atomically decreases the allowance granted to `spender` by the caller.
586      *
587      * This is an alternative to {approve} that can be used as a mitigation for
588      * problems described in {IERC20-approve}.
589      *
590      * Emits an {Approval} event indicating the updated allowance.
591      *
592      * Requirements:
593      *
594      * - `spender` cannot be the zero address.
595      * - `spender` must have allowance for the caller of at least
596      * `subtractedValue`.
597      */
598     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
599         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
600         return true;
601     }
602 
603     /**
604      * @dev Moves tokens `amount` from `sender` to `recipient`.
605      *
606      * This is internal function is equivalent to {transfer}, and can be used to
607      * e.g. implement automatic token fees, slashing mechanisms, etc.
608      *
609      * Emits a {Transfer} event.
610      *
611      * Requirements:
612      *
613      * - `sender` cannot be the zero address.
614      * - `recipient` cannot be the zero address.
615      * - `sender` must have a balance of at least `amount`.
616      */
617     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
618         require(sender != address(0), "ERC20: transfer from the zero address");
619         require(recipient != address(0), "ERC20: transfer to the zero address");
620 
621         _beforeTokenTransfer(sender, recipient, amount);
622 
623         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
624         _balances[recipient] = _balances[recipient].add(amount);
625         emit Transfer(sender, recipient, amount);
626     }
627 
628     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
629      * the total supply.
630      *
631      * Emits a {Transfer} event with `from` set to the zero address.
632      *
633      * Requirements
634      *
635      * - `to` cannot be the zero address.
636      */
637     function _mint(address account, uint256 amount) internal virtual {
638         require(account != address(0), "ERC20: mint to the zero address");
639 
640         _beforeTokenTransfer(address(0), account, amount);
641 
642         _totalSupply = _totalSupply.add(amount);
643         _balances[account] = _balances[account].add(amount);
644         emit Transfer(address(0), account, amount);
645     }
646 
647     /**
648      * @dev Destroys `amount` tokens from `account`, reducing the
649      * total supply.
650      *
651      * Emits a {Transfer} event with `to` set to the zero address.
652      *
653      * Requirements
654      *
655      * - `account` cannot be the zero address.
656      * - `account` must have at least `amount` tokens.
657      */
658     function _burn(address account, uint256 amount) internal virtual {
659         require(account != address(0), "ERC20: burn from the zero address");
660 
661         _beforeTokenTransfer(account, address(0), amount);
662 
663         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
664         _totalSupply = _totalSupply.sub(amount);
665         emit Transfer(account, address(0), amount);
666     }
667 
668     /**
669      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
670      *
671      * This is internal function is equivalent to `approve`, and can be used to
672      * e.g. set automatic allowances for certain subsystems, etc.
673      *
674      * Emits an {Approval} event.
675      *
676      * Requirements:
677      *
678      * - `owner` cannot be the zero address.
679      * - `spender` cannot be the zero address.
680      */
681     function _approve(address owner, address spender, uint256 amount) internal virtual {
682         require(owner != address(0), "ERC20: approve from the zero address");
683         require(spender != address(0), "ERC20: approve to the zero address");
684 
685         _allowances[owner][spender] = amount;
686         emit Approval(owner, spender, amount);
687     }
688 
689     /**
690      * @dev Sets {decimals} to a value other than the default one of 18.
691      *
692      * WARNING: This function should only be called from the constructor. Most
693      * applications that interact with token contracts will not expect
694      * {decimals} to ever change, and may work incorrectly if it does.
695      */
696     function _setupDecimals(uint8 decimals_) internal {
697         _decimals = decimals_;
698     }
699 
700     /**
701      * @dev Hook that is called before any transfer of tokens. This includes
702      * minting and burning.
703      *
704      * Calling conditions:
705      *
706      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
707      * will be to transferred to `to`.
708      * - when `from` is zero, `amount` tokens will be minted for `to`.
709      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
710      * - `from` and `to` are never both zero.
711      *
712      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
713      */
714     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
715 }
716 
717 pragma solidity 0.6.12;
718 
719 contract StakedONX is ERC20("StakedONX", "sONX"){
720 
721     using SafeMath for uint256;
722     IERC20 public onx;
723 
724     constructor(IERC20 _onx) public {
725         onx = _onx;
726     }
727 
728     // Enter to stake ONX. Pay some ONX. Earn some StakedONX
729     function enter(uint256 _amount) public {
730         uint256 totalONX = onx.balanceOf(address(this));
731         uint256 totalShares = totalSupply();
732         if (totalShares == 0 || totalONX == 0) {
733             _mint(msg.sender, _amount);
734         } else {
735             uint256 what = _amount.mul(totalShares).div(totalONX);
736             _mint(msg.sender, what);
737         }
738         onx.transferFrom(msg.sender, address(this), _amount);
739     }
740 
741     // Leave and Claim back your ONX with rewards
742     function leave(uint256 _share) public {
743         uint256 totalShares = totalSupply();
744         uint256 what = _share.mul(onx.balanceOf(address(this))).div(totalShares);
745         _burn(msg.sender, _share);
746         onx.transfer(msg.sender, what);
747     }
748 }