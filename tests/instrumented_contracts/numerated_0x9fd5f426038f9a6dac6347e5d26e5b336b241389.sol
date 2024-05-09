1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-02
3 */
4 
5 // File: @openzeppelin/contracts/GSN/Context.sol
6 
7 pragma solidity ^0.6.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
31 
32 pragma solidity ^0.6.0;
33 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 // File: @openzeppelin/contracts/math/SafeMath.sol
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
294         // This method relies in extcodesize, which returns 0 for contracts in
295         // construction, since the code is only stored at the end of the
296         // constructor execution.
297 
298         uint256 size;
299         // solhint-disable-next-line no-inline-assembly
300         assembly { size := extcodesize(account) }
301         return size > 0;
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
717 // File: @openzeppelin/contracts/access/Ownable.sol
718 
719 pragma solidity ^0.6.0;
720 
721 /**
722  * @dev Contract module which provides a basic access control mechanism, where
723  * there is an account (an owner) that can be granted exclusive access to
724  * specific functions.
725  *
726  * By default, the owner account will be the one that deploys the contract. This
727  * can later be changed with {transferOwnership}.
728  *
729  * This module is used through inheritance. It will make available the modifier
730  * `onlyOwner`, which can be applied to your functions to restrict their use to
731  * the owner.
732  */
733 contract Ownable is Context {
734     address private _owner;
735 
736     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
737 
738     /**
739      * @dev Initializes the contract setting the deployer as the initial owner.
740      */
741     constructor () internal {
742         address msgSender = _msgSender();
743         _owner = msgSender;
744         emit OwnershipTransferred(address(0), msgSender);
745     }
746 
747     /**
748      * @dev Returns the address of the current owner.
749      */
750     function owner() public view returns (address) {
751         return _owner;
752     }
753 
754     /**
755      * @dev Throws if called by any account other than the owner.
756      */
757     modifier onlyOwner() {
758         require(_owner == _msgSender(), "Ownable: caller is not the owner");
759         _;
760     }
761 
762     /**
763      * @dev Leaves the contract without owner. It will not be possible to call
764      * `onlyOwner` functions anymore. Can only be called by the current owner.
765      *
766      * NOTE: Renouncing ownership will leave the contract without an owner,
767      * thereby removing any functionality that is only available to the owner.
768      */
769     function renounceOwnership() public virtual onlyOwner {
770         emit OwnershipTransferred(_owner, address(0));
771         _owner = address(0);
772     }
773 
774     /**
775      * @dev Transfers ownership of the contract to a new account (`newOwner`).
776      * Can only be called by the current owner.
777      */
778     function transferOwnership(address newOwner) public virtual onlyOwner {
779         require(newOwner != address(0), "Ownable: new owner is the zero address");
780         emit OwnershipTransferred(_owner, newOwner);
781         _owner = newOwner;
782     }
783 }
784 
785 // File: contracts/ethereum/TeleportAdmin.sol
786 
787 pragma solidity 0.6.12;
788 
789 
790 /**
791  * @dev Contract module which provides a basic access control mechanism, where
792  * there are multiple accounts (admins) that can be granted exclusive access to
793  * specific functions.
794  *
795  * This module is used through inheritance. It will make available the modifier
796  * `consumeAuthorization`, which can be applied to your functions to restrict
797  * their use to the admins.
798  */
799 contract TeleportAdmin is Ownable {
800   // Marks that the contract is frozen or unfrozen (safety kill-switch)
801   bool private _isFrozen;
802 
803   mapping(address => uint256) private _allowedAmount;
804 
805   event AdminUpdated(address indexed account, uint256 allowedAmount);
806 
807   // Modifiers
808 
809   /**
810     * @dev Throw if contract is currently frozen.
811     */
812   modifier notFrozen() {
813     require(
814       !_isFrozen,
815       "TeleportAdmin: contract is frozen by owner"
816     );
817 
818     _;
819   }
820 
821   /**
822     * @dev Throw if caller does not have sufficient authorized amount.
823     */
824   modifier consumeAuthorization(uint256 amount) {
825     address sender = _msgSender();
826     require(
827       allowedAmount(sender) >= amount,
828       "TeleportAdmin: caller does not have sufficient authorization"
829     );
830 
831     _;
832 
833     // reduce authorization amount. Underflow cannot occur because we have
834     // already checked that admin has sufficient allowed amount.
835     _allowedAmount[sender] -= amount;
836     emit AdminUpdated(sender, _allowedAmount[sender]);
837   }
838 
839   /**
840     * @dev Checks the authorized amount of an admin account.
841     */
842   function allowedAmount(address account)
843     public
844     view
845     returns (uint256)
846   {
847     return _allowedAmount[account];
848   }
849 
850   /**
851     * @dev Returns if the contract is currently frozen.
852     */
853   function isFrozen()
854     public
855     view
856     returns (bool)
857   {
858     return _isFrozen;
859   }
860 
861   /**
862     * @dev Owner freezes the contract.
863     */
864   function freeze()
865     public
866     onlyOwner
867   {
868     _isFrozen = true;
869   }
870 
871   /**
872     * @dev Owner unfreezes the contract.
873     */
874   function unfreeze()
875     public
876     onlyOwner
877   {
878     _isFrozen = false;
879   }
880 
881   /**
882     * @dev Updates the admin status of an account.
883     * Can only be called by the current owner.
884     */
885   function updateAdmin(address account, uint256 newAllowedAmount)
886     public
887     virtual
888     onlyOwner
889   {
890     emit AdminUpdated(account, newAllowedAmount);
891     _allowedAmount[account] = newAllowedAmount;
892   }
893 
894   /**
895     * @dev Overrides the inherited method from Ownable.
896     * Disable ownership resounce.
897     */
898   function renounceOwnership()
899     public
900     override
901     onlyOwner
902   {
903     revert("TeleportAdmin: ownership cannot be renounced");
904   }
905 }
906 
907 // File: contracts/ethereum/TeleportCustody.sol
908 
909 // SPDX-License-Identifier: MIT
910 
911 pragma solidity 0.6.12;
912 
913 
914 
915 /**
916  * @dev Implementation of the TeleportCustody contract.
917  *
918  * There are two priviledged roles for the contract: "owner" and "admin".
919  *
920  * Owner: Has the ultimate control of the contract and the funds stored inside the
921  *        contract. Including:
922  *     1) "freeze" and "unfreeze" the contract: when the TeleportCustody is frozen,
923  *        all deposits and withdrawals with the TeleportCustody is disabled. This 
924  *        should only happen when a major security risk is spotted or if admin access
925  *        is comprimised.
926  *     2) assign "admins": owner has the authority to grant "unlock" permission to
927  *        "admins" and set proper "unlock limit" for each "admin".
928  *
929  * Admin: Has the authority to "unlock" specific amount to tokens to receivers.
930  */
931 contract TeleportCustody is TeleportAdmin {
932   // REVV
933   ERC20 internal _tokenContract = ERC20(0x557B933a7C2c45672B610F8954A3deB39a51A8Ca);
934   
935   // Records that an unlock transaction has been executed
936   mapping(bytes32 => bool) internal _unlocked;
937   
938   // Emmitted when user locks token and initiates teleport
939   event Locked(uint256 amount, bytes8 indexed flowAddress, address indexed ethereumAddress);
940 
941   // Emmitted when teleport completes and token gets unlocked
942   event Unlocked(uint256 amount, address indexed ethereumAddress, bytes32 indexed flowHash);
943 
944   /**
945     * @dev User locks token and initiates teleport request.
946     */
947   function lock(uint256 amount, bytes8 flowAddress)
948     public
949     notFrozen
950   {
951     address sender = _msgSender();
952 
953     bool result = _tokenContract.transferFrom(sender, address(this), amount);
954     require(result, "TeleportCustody: transferFrom returns falsy value");
955 
956     emit Locked(amount, flowAddress, sender);
957   }
958 
959   // Admin methods
960 
961   /**
962     * @dev TeleportAdmin unlocks token upon receiving teleport request from Flow.
963     */
964   function unlock(uint256 amount, address ethereumAddress, bytes32 flowHash)
965     public
966     notFrozen
967     consumeAuthorization(amount)
968   {
969     _unlock(amount, ethereumAddress, flowHash);
970   }
971 
972   // Owner methods
973 
974   /**
975     * @dev Owner unlocks token upon receiving teleport request from Flow.
976     * There is no unlock limit for owner.
977     */
978   function unlockByOwner(uint256 amount, address ethereumAddress, bytes32 flowHash)
979     public
980     notFrozen
981     onlyOwner
982   {
983     _unlock(amount, ethereumAddress, flowHash);
984   }
985 
986   // Internal methods
987 
988   /**
989     * @dev Internal function for processing unlock requests.
990     * 
991     * There is no way TeleportCustody can check the validity of the target address
992     * beforehand so user and admin should always make sure the provided information
993     * is correct.
994     */
995   function _unlock(uint256 amount, address ethereumAddress, bytes32 flowHash)
996     internal
997   {
998     require(ethereumAddress != address(0), "TeleportCustody: ethereumAddress is the zero address");
999     require(!_unlocked[flowHash], "TeleportCustody: same unlock hash has been executed");
1000 
1001     _unlocked[flowHash] = true;
1002 
1003     bool result = _tokenContract.transfer(ethereumAddress, amount);
1004     require(result, "TeleportCustody: transfer returns falsy value");
1005 
1006     emit Unlocked(amount, ethereumAddress, flowHash);
1007   }
1008 }