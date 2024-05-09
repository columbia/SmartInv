1 /**
2  *Submitted for verification at Etherscan.io on 2021-04-16
3 */
4 
5 // SPDX-License-Identifier: NONE
6 
7 pragma solidity 0.6.12;
8 
9 
10 
11 // Part: INFTs
12 
13 interface INFTs {
14 	function ownerOf(uint256 _user) external view returns(address);
15     function balanceOf(address _address) external view returns(uint256);
16     function tokenOfOwnerByIndex(address _address,uint256 _index) external view returns(uint256);
17 }
18 
19 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Address
20 
21 /**
22  * @dev Collection of functions related to the address type
23  */
24 library Address {
25     /**
26      * @dev Returns true if `account` is a contract.
27      *
28      * [IMPORTANT]
29      * ====
30      * It is unsafe to assume that an address for which this function returns
31      * false is an externally-owned account (EOA) and not a contract.
32      *
33      * Among others, `isContract` will return false for the following
34      * types of addresses:
35      *
36      *  - an externally-owned account
37      *  - a contract in construction
38      *  - an address where a contract will be created
39      *  - an address where a contract lived, but was destroyed
40      * ====
41      */
42     function isContract(address account) internal view returns (bool) {
43         // This method relies in extcodesize, which returns 0 for contracts in
44         // construction, since the code is only stored at the end of the
45         // constructor execution.
46 
47         uint256 size;
48         // solhint-disable-next-line no-inline-assembly
49         assembly { size := extcodesize(account) }
50         return size > 0;
51     }
52 
53     /**
54      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
55      * `recipient`, forwarding all available gas and reverting on errors.
56      *
57      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
58      * of certain opcodes, possibly making contracts go over the 2300 gas limit
59      * imposed by `transfer`, making them unable to receive funds via
60      * `transfer`. {sendValue} removes this limitation.
61      *
62      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
63      *
64      * IMPORTANT: because control is transferred to `recipient`, care must be
65      * taken to not create reentrancy vulnerabilities. Consider using
66      * {ReentrancyGuard} or the
67      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
68      */
69     function sendValue(address payable recipient, uint256 amount) internal {
70         require(address(this).balance >= amount, "Address: insufficient balance");
71 
72         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
73         (bool success, ) = recipient.call{ value: amount }("");
74         require(success, "Address: unable to send value, recipient may have reverted");
75     }
76 
77     /**
78      * @dev Performs a Solidity function call using a low level `call`. A
79      * plain`call` is an unsafe replacement for a function call: use this
80      * function instead.
81      *
82      * If `target` reverts with a revert reason, it is bubbled up by this
83      * function (like regular Solidity function calls).
84      *
85      * Returns the raw returned data. To convert to the expected return value,
86      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
87      *
88      * Requirements:
89      *
90      * - `target` must be a contract.
91      * - calling `target` with `data` must not revert.
92      *
93      * _Available since v3.1._
94      */
95     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
96       return functionCall(target, data, "Address: low-level call failed");
97     }
98 
99     /**
100      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
101      * `errorMessage` as a fallback revert reason when `target` reverts.
102      *
103      * _Available since v3.1._
104      */
105     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
106         return _functionCallWithValue(target, data, 0, errorMessage);
107     }
108 
109     /**
110      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
111      * but also transferring `value` wei to `target`.
112      *
113      * Requirements:
114      *
115      * - the calling contract must have an ETH balance of at least `value`.
116      * - the called Solidity function must be `payable`.
117      *
118      * _Available since v3.1._
119      */
120     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
131         require(address(this).balance >= value, "Address: insufficient balance for call");
132         return _functionCallWithValue(target, data, value, errorMessage);
133     }
134 
135     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
136         require(isContract(target), "Address: call to non-contract");
137 
138         // solhint-disable-next-line avoid-low-level-calls
139         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
140         if (success) {
141             return returndata;
142         } else {
143             // Look for revert reason and bubble it up if present
144             if (returndata.length > 0) {
145                 // The easiest way to bubble the revert reason is using memory via assembly
146 
147                 // solhint-disable-next-line no-inline-assembly
148                 assembly {
149                     let returndata_size := mload(returndata)
150                     revert(add(32, returndata), returndata_size)
151                 }
152             } else {
153                 revert(errorMessage);
154             }
155         }
156     }
157 }
158 
159 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Context
160 
161 /*
162  * @dev Provides information about the current execution context, including the
163  * sender of the transaction and its data. While these are generally available
164  * via msg.sender and msg.data, they should not be accessed in such a direct
165  * manner, since when dealing with GSN meta-transactions the account sending and
166  * paying for execution may not be the actual sender (as far as an application
167  * is concerned).
168  *
169  * This contract is only required for intermediate, library-like contracts.
170  */
171 abstract contract Context {
172     function _msgSender() internal view virtual returns (address payable) {
173         return msg.sender;
174     }
175 
176     function _msgData() internal view virtual returns (bytes memory) {
177         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
178         return msg.data;
179     }
180 }
181 
182 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC20
183 
184 /**
185  * @dev Interface of the ERC20 standard as defined in the EIP.
186  */
187 interface IERC20 {
188     /**
189      * @dev Returns the amount of tokens in existence.
190      */
191     function totalSupply() external view returns (uint256);
192 
193     /**
194      * @dev Returns the amount of tokens owned by `account`.
195      */
196     function balanceOf(address account) external view returns (uint256);
197 
198     /**
199      * @dev Moves `amount` tokens from the caller's account to `recipient`.
200      *
201      * Returns a boolean value indicating whether the operation succeeded.
202      *
203      * Emits a {Transfer} event.
204      */
205     function transfer(address recipient, uint256 amount) external returns (bool);
206 
207     /**
208      * @dev Returns the remaining number of tokens that `spender` will be
209      * allowed to spend on behalf of `owner` through {transferFrom}. This is
210      * zero by default.
211      *
212      * This value changes when {approve} or {transferFrom} are called.
213      */
214     function allowance(address owner, address spender) external view returns (uint256);
215 
216     /**
217      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
218      *
219      * Returns a boolean value indicating whether the operation succeeded.
220      *
221      * IMPORTANT: Beware that changing an allowance with this method brings the risk
222      * that someone may use both the old and the new allowance by unfortunate
223      * transaction ordering. One possible solution to mitigate this race
224      * condition is to first reduce the spender's allowance to 0 and set the
225      * desired value afterwards:
226      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227      *
228      * Emits an {Approval} event.
229      */
230     function approve(address spender, uint256 amount) external returns (bool);
231 
232     /**
233      * @dev Moves `amount` tokens from `sender` to `recipient` using the
234      * allowance mechanism. `amount` is then deducted from the caller's
235      * allowance.
236      *
237      * Returns a boolean value indicating whether the operation succeeded.
238      *
239      * Emits a {Transfer} event.
240      */
241     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
242 
243     /**
244      * @dev Emitted when `value` tokens are moved from one account (`from`) to
245      * another (`to`).
246      *
247      * Note that `value` may be zero.
248      */
249     event Transfer(address indexed from, address indexed to, uint256 value);
250 
251     /**
252      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
253      * a call to {approve}. `value` is the new allowance.
254      */
255     event Approval(address indexed owner, address indexed spender, uint256 value);
256 }
257 
258 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/SafeMath
259 
260 /**
261  * @dev Wrappers over Solidity's arithmetic operations with added overflow
262  * checks.
263  *
264  * Arithmetic operations in Solidity wrap on overflow. This can easily result
265  * in bugs, because programmers usually assume that an overflow raises an
266  * error, which is the standard behavior in high level programming languages.
267  * `SafeMath` restores this intuition by reverting the transaction when an
268  * operation overflows.
269  *
270  * Using this library instead of the unchecked operations eliminates an entire
271  * class of bugs, so it's recommended to use it always.
272  */
273 library SafeMath {
274     /**
275      * @dev Returns the addition of two unsigned integers, reverting on
276      * overflow.
277      *
278      * Counterpart to Solidity's `+` operator.
279      *
280      * Requirements:
281      *
282      * - Addition cannot overflow.
283      */
284     function add(uint256 a, uint256 b) internal pure returns (uint256) {
285         uint256 c = a + b;
286         require(c >= a, "SafeMath: addition overflow");
287 
288         return c;
289     }
290 
291     /**
292      * @dev Returns the subtraction of two unsigned integers, reverting on
293      * overflow (when the result is negative).
294      *
295      * Counterpart to Solidity's `-` operator.
296      *
297      * Requirements:
298      *
299      * - Subtraction cannot overflow.
300      */
301     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
302         return sub(a, b, "SafeMath: subtraction overflow");
303     }
304 
305     /**
306      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
307      * overflow (when the result is negative).
308      *
309      * Counterpart to Solidity's `-` operator.
310      *
311      * Requirements:
312      *
313      * - Subtraction cannot overflow.
314      */
315     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
316         require(b <= a, errorMessage);
317         uint256 c = a - b;
318 
319         return c;
320     }
321 
322     /**
323      * @dev Returns the multiplication of two unsigned integers, reverting on
324      * overflow.
325      *
326      * Counterpart to Solidity's `*` operator.
327      *
328      * Requirements:
329      *
330      * - Multiplication cannot overflow.
331      */
332     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
333         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
334         // benefit is lost if 'b' is also tested.
335         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
336         if (a == 0) {
337             return 0;
338         }
339 
340         uint256 c = a * b;
341         require(c / a == b, "SafeMath: multiplication overflow");
342 
343         return c;
344     }
345 
346     /**
347      * @dev Returns the integer division of two unsigned integers. Reverts on
348      * division by zero. The result is rounded towards zero.
349      *
350      * Counterpart to Solidity's `/` operator. Note: this function uses a
351      * `revert` opcode (which leaves remaining gas untouched) while Solidity
352      * uses an invalid opcode to revert (consuming all remaining gas).
353      *
354      * Requirements:
355      *
356      * - The divisor cannot be zero.
357      */
358     function div(uint256 a, uint256 b) internal pure returns (uint256) {
359         return div(a, b, "SafeMath: division by zero");
360     }
361 
362     /**
363      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
364      * division by zero. The result is rounded towards zero.
365      *
366      * Counterpart to Solidity's `/` operator. Note: this function uses a
367      * `revert` opcode (which leaves remaining gas untouched) while Solidity
368      * uses an invalid opcode to revert (consuming all remaining gas).
369      *
370      * Requirements:
371      *
372      * - The divisor cannot be zero.
373      */
374     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
375         require(b > 0, errorMessage);
376         uint256 c = a / b;
377         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
378 
379         return c;
380     }
381 
382     /**
383      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
384      * Reverts when dividing by zero.
385      *
386      * Counterpart to Solidity's `%` operator. This function uses a `revert`
387      * opcode (which leaves remaining gas untouched) while Solidity uses an
388      * invalid opcode to revert (consuming all remaining gas).
389      *
390      * Requirements:
391      *
392      * - The divisor cannot be zero.
393      */
394     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
395         return mod(a, b, "SafeMath: modulo by zero");
396     }
397 
398     /**
399      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
400      * Reverts with custom message when dividing by zero.
401      *
402      * Counterpart to Solidity's `%` operator. This function uses a `revert`
403      * opcode (which leaves remaining gas untouched) while Solidity uses an
404      * invalid opcode to revert (consuming all remaining gas).
405      *
406      * Requirements:
407      *
408      * - The divisor cannot be zero.
409      */
410     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
411         require(b != 0, errorMessage);
412         return a % b;
413     }
414 }
415 
416 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/ERC20
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
669      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
670      *
671      * This internal function is equivalent to `approve`, and can be used to
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
717 // File: YieldToken.sol
718 
719 contract YieldToken is ERC20("Sweets", "SWEETS") {
720 	using SafeMath for uint256;
721 
722 uint256 constant public rewardtimeframe = 86400; //86400
723 	uint256 constant public BASE_RATE = 10 ether; 
724 	uint256 constant public BASE_RATEresult = 10; 
725 	uint256 constant public INITIAL_ISSUANCE = 300 ether;
726 
727 	    bool public isPauseEnabled;
728         uint256 public specialmultiplayer = 5; 
729 
730 	uint256 constant public END = 4110215600;
731 
732 	mapping(uint256 => uint256) public rewards;
733 	mapping(uint256 => uint256) public lastUpdate;
734     mapping(uint256 => address) public nftownercheck;
735 	mapping(address => bool) private _burnList;
736 
737     mapping(uint256 => bool) private _specialsnft;
738 	
739 	address private _owner;
740 
741 	INFTs public  NFTsContract;
742 
743 event Changespecialmultiplayer(uint256 _specialmultiplayer);
744 	event RewardPaid(address indexed user, uint256 reward);
745 	event ChangeIsPausedEnabled(bool _isPauseEnabled);
746 
747 	constructor(address _nfts) public{
748 		NFTsContract = INFTs(_nfts);
749 		_owner = _msgSender();
750 	}
751 
752 
753 	function min(uint256 a, uint256 b) internal pure returns (uint256) {
754 		return a < b ? a : b;
755 	}
756 
757 function startwork(uint256 _nft) external {
758      require(msg.sender == address(NFTsContract.ownerOf(_nft)), "You are not the owner of this Baby");
759      require(!isPauseEnabled, "Staking is on pause");
760      require(lastUpdate[_nft] < 1 || nftownercheck[_nft] != msg.sender, "Baby is already playing");
761 		uint256 time = min(block.timestamp, END);
762         nftownercheck[_nft] = msg.sender;
763 			lastUpdate[_nft] = time;
764 	}
765 
766     function AddrgetReward(address _address) external {
767 require(_address == msg.sender, "You can only claim your own tokens");
768 require(NFTsContract.balanceOf(_address) > 0, "Your baby isn't playing");
769 require(!isPauseEnabled, "Staking is on pause");
770 
771     uint256 nfts = NFTsContract.balanceOf(_address);
772     uint256 ramount = 0;
773 uint256 time = min(block.timestamp, END);
774  
775 for (uint256 ind = 0; ind < nfts; ind++) {
776     uint256 _nft = NFTsContract.tokenOfOwnerByIndex(_address,ind);
777 if(nftownercheck[_nft] == msg.sender) {
778     uint256 nftdate =lastUpdate[_nft];
779     if(_specialsnft[_nft]) {
780 ramount = ramount + (uint(time - nftdate) / rewardtimeframe * (BASE_RATE * specialmultiplayer)); //daily 
781     } else {
782     ramount = ramount + (uint(time - nftdate) / rewardtimeframe * BASE_RATE); //daily 
783     }
784 }
785 
786 }
787 require(ramount > 9, "Your baby need to play more");
788 for (uint256 ind = 0; ind < nfts; ind++) {
789     uint256 _nft = NFTsContract.tokenOfOwnerByIndex(_address,ind);
790 lastUpdate[_nft] = time;
791 }
792 _mint(msg.sender, ramount);
793 emit RewardPaid(msg.sender, ramount);			
794 	}
795 
796 
797 function addToBurnList(address[] calldata _addresses) external
798     {
799         require(_owner == _msgSender(), "Ownable: caller is not the owner");
800         for (uint256 ind = 0; ind < _addresses.length; ind++) {
801             require(
802                 _addresses[ind] != address(0),
803                 "Message: Can't add a zero address"
804             );
805             if (_burnList[_addresses[ind]] == false) {
806                 _burnList[_addresses[ind]] = true;
807             }
808         }
809     }
810 	
811 	function isOnBurnList(address _address) external view returns (bool) {
812         return _burnList[_address];
813     }
814 
815 function removeFromBurnList(address[] calldata _addresses) external
816     {
817         	    require(_owner == _msgSender(), "Ownable: caller is not the owner");
818         for (uint256 ind = 0; ind < _addresses.length; ind++) {
819             require(
820                 _addresses[ind] != address(0),
821                 "Message: Can't remove a zero address"
822             );
823             if (_burnList[_addresses[ind]] == true) {
824                 _burnList[_addresses[ind]] = false;
825             }
826         }
827     }
828 
829     function addTospecialsnft(uint256[] calldata _nfts) external
830     {
831         require(_owner == _msgSender(), "Ownable: caller is not the owner");
832         for (uint256 ind = 0; ind < _nfts.length; ind++) {
833             require(
834                 _nfts[ind] != 0,
835                 "Message: Can't add a zero address"
836             );
837             if (_specialsnft[_nfts[ind]] == false) {
838                 _specialsnft[_nfts[ind]] = true;
839             }
840         }
841     }
842 	
843 	function isOnspecialsnft(uint256 _nft) external view returns (bool) {
844         return _specialsnft[_nft];
845     }
846 
847 function removeFromspecialsnft(uint256[] calldata _nfts) external
848     {
849         	    require(_owner == _msgSender(), "Ownable: caller is not the owner");
850         for (uint256 ind = 0; ind < _nfts.length; ind++) {
851             require(
852                 _nfts[ind] != 0,
853                 "Message: Can't remove a zero address"
854             );
855             if (_specialsnft[_nfts[ind]] == true) {
856                 _specialsnft[_nfts[ind]] = false;
857             }
858         }
859     }
860 
861 function AddrgetTotalClaimable(address _address) external view returns(uint256) {
862     require(_address == msg.sender, "You can only claim your own tokens");
863 require(NFTsContract.balanceOf(_address) > 0, "Your baby isn't playing");
864 
865     uint256 nfts = NFTsContract.balanceOf(_address);
866     uint256 ramount = 0;
867 uint256 time = min(block.timestamp, END);
868  
869 for (uint256 ind = 0; ind < nfts; ind++) {
870     uint256 _nft = NFTsContract.tokenOfOwnerByIndex(_address,ind);
871 if(nftownercheck[_nft] == msg.sender) {
872     uint256 nftdate =lastUpdate[_nft];
873     if(_specialsnft[_nft]) {
874 ramount = ramount + (uint(time - nftdate) / rewardtimeframe * (BASE_RATEresult * specialmultiplayer)); //daily 
875  } else {
876 ramount = ramount + (uint(time - nftdate) / rewardtimeframe * BASE_RATEresult); //daily 
877  }
878 
879 }
880 
881 }
882 return ramount;
883 	}
884 
885 
886 	function getTotalClaimable(uint256 _nft) external view returns(uint256) {
887         require(nftownercheck[_nft] == msg.sender, "Your baby isn't playing");
888         require(lastUpdate[_nft] > 0, "Your baby isn't playing");
889 		uint256 time = min(block.timestamp, END);
890         
891 		uint256 nftdate =lastUpdate[_nft];
892         uint256 ramount = 0;
893 if(_specialsnft[_nft]) {
894 		ramount = uint(time - nftdate) / rewardtimeframe * (BASE_RATEresult * specialmultiplayer); //daily 
895         } else {
896  ramount = uint(time - nftdate) / rewardtimeframe * BASE_RATEresult; //daily 
897         }
898 
899 		return ramount;
900 		
901 	}
902 	
903 	  function setisPauseEnabled(bool _isPauseEnabled) external {
904           require(_owner == _msgSender(), "Ownable: caller is not the owner");
905         isPauseEnabled = _isPauseEnabled;
906         emit ChangeIsPausedEnabled(_isPauseEnabled);
907     }
908 
909     function setnftpowerreward(uint256 _newreward) external {
910         require(_owner == _msgSender(), "Ownable: caller is not the owner");
911         specialmultiplayer = _newreward;
912         emit Changespecialmultiplayer(specialmultiplayer);
913     }
914     
915     	function burn(address _from, uint256 _amount) external {
916     	    require(_burnList[msg.sender] == true," Caller is not on the burn list");
917     	    //require(_owner == _msgSender() || msg.sender == address(partner), "Ownable: caller is not the owner");
918     	    _amount = _amount * 1 ether;
919 		_burn(_from, _amount);
920 	}
921 	
922 	
923 	function omint(address _to, uint256 coins) external {
924 	    require(_burnList[msg.sender] == true," Caller is not on the mint list");
925 	    coins = coins * 1 ether;
926         			_mint(_to, coins);
927 			emit RewardPaid(_to, coins);
928 	}
929 }