1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-28
3 */
4 
5 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
6 
7 
8 
9 pragma solidity ^0.6.0;
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations with added overflow
13  * checks.
14  *
15  * Arithmetic operations in Solidity wrap on overflow. This can easily result
16  * in bugs, because programmers usually assume that an overflow raises an
17  * error, which is the standard behavior in high level programming languages.
18  * `SafeMath` restores this intuition by reverting the transaction when an
19  * operation overflows.
20  *
21  * Using this library instead of the unchecked operations eliminates an entire
22  * class of bugs, so it's recommended to use it always.
23  */
24 library SafeMath {
25     /**
26      * @dev Returns the addition of two unsigned integers, reverting on
27      * overflow.
28      *
29      * Counterpart to Solidity's `+` operator.
30      *
31      * Requirements:
32      *
33      * - Addition cannot overflow.
34      */
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         require(c >= a, "SafeMath: addition overflow");
38 
39         return c;
40     }
41 
42     /**
43      * @dev Returns the subtraction of two unsigned integers, reverting on
44      * overflow (when the result is negative).
45      *
46      * Counterpart to Solidity's `-` operator.
47      *
48      * Requirements:
49      *
50      * - Subtraction cannot overflow.
51      */
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         return sub(a, b, "SafeMath: subtraction overflow");
54     }
55 
56     /**
57      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
58      * overflow (when the result is negative).
59      *
60      * Counterpart to Solidity's `-` operator.
61      *
62      * Requirements:
63      *
64      * - Subtraction cannot overflow.
65      */
66     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b <= a, errorMessage);
68         uint256 c = a - b;
69 
70         return c;
71     }
72 
73     /**
74      * @dev Returns the multiplication of two unsigned integers, reverting on
75      * overflow.
76      *
77      * Counterpart to Solidity's `*` operator.
78      *
79      * Requirements:
80      *
81      * - Multiplication cannot overflow.
82      */
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
85         // benefit is lost if 'b' is also tested.
86         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
87         if (a == 0) {
88             return 0;
89         }
90 
91         uint256 c = a * b;
92         require(c / a == b, "SafeMath: multiplication overflow");
93 
94         return c;
95     }
96 
97     /**
98      * @dev Returns the integer division of two unsigned integers. Reverts on
99      * division by zero. The result is rounded towards zero.
100      *
101      * Counterpart to Solidity's `/` operator. Note: this function uses a
102      * `revert` opcode (which leaves remaining gas untouched) while Solidity
103      * uses an invalid opcode to revert (consuming all remaining gas).
104      *
105      * Requirements:
106      *
107      * - The divisor cannot be zero.
108      */
109     function div(uint256 a, uint256 b) internal pure returns (uint256) {
110         return div(a, b, "SafeMath: division by zero");
111     }
112 
113     /**
114      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
115      * division by zero. The result is rounded towards zero.
116      *
117      * Counterpart to Solidity's `/` operator. Note: this function uses a
118      * `revert` opcode (which leaves remaining gas untouched) while Solidity
119      * uses an invalid opcode to revert (consuming all remaining gas).
120      *
121      * Requirements:
122      *
123      * - The divisor cannot be zero.
124      */
125     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
126         require(b > 0, errorMessage);
127         uint256 c = a / b;
128         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
129 
130         return c;
131     }
132 
133     /**
134      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
135      * Reverts when dividing by zero.
136      *
137      * Counterpart to Solidity's `%` operator. This function uses a `revert`
138      * opcode (which leaves remaining gas untouched) while Solidity uses an
139      * invalid opcode to revert (consuming all remaining gas).
140      *
141      * Requirements:
142      *
143      * - The divisor cannot be zero.
144      */
145     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
146         return mod(a, b, "SafeMath: modulo by zero");
147     }
148 
149     /**
150      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
151      * Reverts with custom message when dividing by zero.
152      *
153      * Counterpart to Solidity's `%` operator. This function uses a `revert`
154      * opcode (which leaves remaining gas untouched) while Solidity uses an
155      * invalid opcode to revert (consuming all remaining gas).
156      *
157      * Requirements:
158      *
159      * - The divisor cannot be zero.
160      */
161     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
162         require(b != 0, errorMessage);
163         return a % b;
164     }
165 }
166 
167 // File: openzeppelin-solidity/contracts/GSN/Context.sol
168 
169 
170 
171 pragma solidity ^0.6.0;
172 
173 /*
174  * @dev Provides information about the current execution context, including the
175  * sender of the transaction and its data. While these are generally available
176  * via msg.sender and msg.data, they should not be accessed in such a direct
177  * manner, since when dealing with GSN meta-transactions the account sending and
178  * paying for execution may not be the actual sender (as far as an application
179  * is concerned).
180  *
181  * This contract is only required for intermediate, library-like contracts.
182  */
183 abstract contract Context {
184     function _msgSender() internal view virtual returns (address payable) {
185         return msg.sender;
186     }
187 
188     function _msgData() internal view virtual returns (bytes memory) {
189         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
190         return msg.data;
191     }
192 }
193 
194 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
195 
196 
197 
198 pragma solidity ^0.6.0;
199 
200 /**
201  * @dev Interface of the ERC20 standard as defined in the EIP.
202  */
203 interface IERC20 {
204     /**
205      * @dev Returns the amount of tokens in existence.
206      */
207     function totalSupply() external view returns (uint256);
208 
209     /**
210      * @dev Returns the amount of tokens owned by `account`.
211      */
212     function balanceOf(address account) external view returns (uint256);
213 
214     /**
215      * @dev Moves `amount` tokens from the caller's account to `recipient`.
216      *
217      * Returns a boolean value indicating whether the operation succeeded.
218      *
219      * Emits a {Transfer} event.
220      */
221     function transfer(address recipient, uint256 amount) external returns (bool);
222 
223     /**
224      * @dev Returns the remaining number of tokens that `spender` will be
225      * allowed to spend on behalf of `owner` through {transferFrom}. This is
226      * zero by default.
227      *
228      * This value changes when {approve} or {transferFrom} are called.
229      */
230     function allowance(address owner, address spender) external view returns (uint256);
231 
232     /**
233      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
234      *
235      * Returns a boolean value indicating whether the operation succeeded.
236      *
237      * IMPORTANT: Beware that changing an allowance with this method brings the risk
238      * that someone may use both the old and the new allowance by unfortunate
239      * transaction ordering. One possible solution to mitigate this race
240      * condition is to first reduce the spender's allowance to 0 and set the
241      * desired value afterwards:
242      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
243      *
244      * Emits an {Approval} event.
245      */
246     function approve(address spender, uint256 amount) external returns (bool);
247 
248     /**
249      * @dev Moves `amount` tokens from `sender` to `recipient` using the
250      * allowance mechanism. `amount` is then deducted from the caller's
251      * allowance.
252      *
253      * Returns a boolean value indicating whether the operation succeeded.
254      *
255      * Emits a {Transfer} event.
256      */
257     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
258 
259     /**
260      * @dev Emitted when `value` tokens are moved from one account (`from`) to
261      * another (`to`).
262      *
263      * Note that `value` may be zero.
264      */
265     event Transfer(address indexed from, address indexed to, uint256 value);
266 
267     /**
268      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
269      * a call to {approve}. `value` is the new allowance.
270      */
271     event Approval(address indexed owner, address indexed spender, uint256 value);
272 }
273 
274 // File: openzeppelin-solidity/contracts/utils/Address.sol
275 
276 
277 
278 pragma solidity ^0.6.2;
279 
280 /**
281  * @dev Collection of functions related to the address type
282  */
283 library Address {
284     /**
285      * @dev Returns true if `account` is a contract.
286      *
287      * [IMPORTANT]
288      * ====
289      * It is unsafe to assume that an address for which this function returns
290      * false is an externally-owned account (EOA) and not a contract.
291      *
292      * Among others, `isContract` will return false for the following
293      * types of addresses:
294      *
295      *  - an externally-owned account
296      *  - a contract in construction
297      *  - an address where a contract will be created
298      *  - an address where a contract lived, but was destroyed
299      * ====
300      */
301     function isContract(address account) internal view returns (bool) {
302         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
303         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
304         // for accounts without code, i.e. `keccak256('')`
305         bytes32 codehash;
306         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
307         // solhint-disable-next-line no-inline-assembly
308         assembly { codehash := extcodehash(account) }
309         return (codehash != accountHash && codehash != 0x0);
310     }
311 
312     /**
313      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
314      * `recipient`, forwarding all available gas and reverting on errors.
315      *
316      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
317      * of certain opcodes, possibly making contracts go over the 2300 gas limit
318      * imposed by `transfer`, making them unable to receive funds via
319      * `transfer`. {sendValue} removes this limitation.
320      *
321      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
322      *
323      * IMPORTANT: because control is transferred to `recipient`, care must be
324      * taken to not create reentrancy vulnerabilities. Consider using
325      * {ReentrancyGuard} or the
326      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
327      */
328     function sendValue(address payable recipient, uint256 amount) internal {
329         require(address(this).balance >= amount, "Address: insufficient balance");
330 
331         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
332         (bool success, ) = recipient.call{ value: amount }("");
333         require(success, "Address: unable to send value, recipient may have reverted");
334     }
335 
336     /**
337      * @dev Performs a Solidity function call using a low level `call`. A
338      * plain`call` is an unsafe replacement for a function call: use this
339      * function instead.
340      *
341      * If `target` reverts with a revert reason, it is bubbled up by this
342      * function (like regular Solidity function calls).
343      *
344      * Returns the raw returned data. To convert to the expected return value,
345      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
346      *
347      * Requirements:
348      *
349      * - `target` must be a contract.
350      * - calling `target` with `data` must not revert.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
355       return functionCall(target, data, "Address: low-level call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
360      * `errorMessage` as a fallback revert reason when `target` reverts.
361      *
362      * _Available since v3.1._
363      */
364     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
365         return _functionCallWithValue(target, data, 0, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but also transferring `value` wei to `target`.
371      *
372      * Requirements:
373      *
374      * - the calling contract must have an ETH balance of at least `value`.
375      * - the called Solidity function must be `payable`.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
380         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
385      * with `errorMessage` as a fallback revert reason when `target` reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
390         require(address(this).balance >= value, "Address: insufficient balance for call");
391         return _functionCallWithValue(target, data, value, errorMessage);
392     }
393 
394     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
395         require(isContract(target), "Address: call to non-contract");
396 
397         // solhint-disable-next-line avoid-low-level-calls
398         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
399         if (success) {
400             return returndata;
401         } else {
402             // Look for revert reason and bubble it up if present
403             if (returndata.length > 0) {
404                 // The easiest way to bubble the revert reason is using memory via assembly
405 
406                 // solhint-disable-next-line no-inline-assembly
407                 assembly {
408                     let returndata_size := mload(returndata)
409                     revert(add(32, returndata), returndata_size)
410                 }
411             } else {
412                 revert(errorMessage);
413             }
414         }
415     }
416 }
417 
418 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
419 
420 
421 
422 pragma solidity ^0.6.0;
423 
424 
425 
426 
427 
428 /**
429  * @dev Implementation of the {IERC20} interface.
430  *
431  * This implementation is agnostic to the way tokens are created. This means
432  * that a supply mechanism has to be added in a derived contract using {_mint}.
433  * For a generic mechanism see {ERC20PresetMinterPauser}.
434  *
435  * TIP: For a detailed writeup see our guide
436  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
437  * to implement supply mechanisms].
438  *
439  * We have followed general OpenZeppelin guidelines: functions revert instead
440  * of returning `false` on failure. This behavior is nonetheless conventional
441  * and does not conflict with the expectations of ERC20 applications.
442  *
443  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
444  * This allows applications to reconstruct the allowance for all accounts just
445  * by listening to said events. Other implementations of the EIP may not emit
446  * these events, as it isn't required by the specification.
447  *
448  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
449  * functions have been added to mitigate the well-known issues around setting
450  * allowances. See {IERC20-approve}.
451  */
452 contract ERC20 is Context, IERC20 {
453     using SafeMath for uint256;
454     using Address for address;
455 
456     mapping (address => uint256) private _balances;
457 
458     mapping (address => mapping (address => uint256)) private _allowances;
459 
460     uint256 private _totalSupply;
461 
462     string private _name;
463     string private _symbol;
464     uint8 private _decimals;
465 
466     /**
467      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
468      * a default value of 18.
469      *
470      * To select a different value for {decimals}, use {_setupDecimals}.
471      *
472      * All three of these values are immutable: they can only be set once during
473      * construction.
474      */
475     constructor (string memory name, string memory symbol) public {
476         _name = name;
477         _symbol = symbol;
478         _decimals = 18;
479     }
480 
481     /**
482      * @dev Returns the name of the token.
483      */
484     function name() public view returns (string memory) {
485         return _name;
486     }
487 
488     /**
489      * @dev Returns the symbol of the token, usually a shorter version of the
490      * name.
491      */
492     function symbol() public view returns (string memory) {
493         return _symbol;
494     }
495 
496     /**
497      * @dev Returns the number of decimals used to get its user representation.
498      * For example, if `decimals` equals `2`, a balance of `505` tokens should
499      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
500      *
501      * Tokens usually opt for a value of 18, imitating the relationship between
502      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
503      * called.
504      *
505      * NOTE: This information is only used for _display_ purposes: it in
506      * no way affects any of the arithmetic of the contract, including
507      * {IERC20-balanceOf} and {IERC20-transfer}.
508      */
509     function decimals() public view returns (uint8) {
510         return _decimals;
511     }
512 
513     /**
514      * @dev See {IERC20-totalSupply}.
515      */
516     function totalSupply() public view override returns (uint256) {
517         return _totalSupply;
518     }
519 
520     /**
521      * @dev See {IERC20-balanceOf}.
522      */
523     function balanceOf(address account) public view override returns (uint256) {
524         return _balances[account];
525     }
526 
527     /**
528      * @dev See {IERC20-transfer}.
529      *
530      * Requirements:
531      *
532      * - `recipient` cannot be the zero address.
533      * - the caller must have a balance of at least `amount`.
534      */
535     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
536         _transfer(_msgSender(), recipient, amount);
537         return true;
538     }
539 
540     /**
541      * @dev See {IERC20-allowance}.
542      */
543     function allowance(address owner, address spender) public view virtual override returns (uint256) {
544         return _allowances[owner][spender];
545     }
546 
547     /**
548      * @dev See {IERC20-approve}.
549      *
550      * Requirements:
551      *
552      * - `spender` cannot be the zero address.
553      */
554     function approve(address spender, uint256 amount) public virtual override returns (bool) {
555         _approve(_msgSender(), spender, amount);
556         return true;
557     }
558 
559     /**
560      * @dev See {IERC20-transferFrom}.
561      *
562      * Emits an {Approval} event indicating the updated allowance. This is not
563      * required by the EIP. See the note at the beginning of {ERC20};
564      *
565      * Requirements:
566      * - `sender` and `recipient` cannot be the zero address.
567      * - `sender` must have a balance of at least `amount`.
568      * - the caller must have allowance for ``sender``'s tokens of at least
569      * `amount`.
570      */
571     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
572         _transfer(sender, recipient, amount);
573         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
574         return true;
575     }
576 
577     /**
578      * @dev Atomically increases the allowance granted to `spender` by the caller.
579      *
580      * This is an alternative to {approve} that can be used as a mitigation for
581      * problems described in {IERC20-approve}.
582      *
583      * Emits an {Approval} event indicating the updated allowance.
584      *
585      * Requirements:
586      *
587      * - `spender` cannot be the zero address.
588      */
589     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
590         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
591         return true;
592     }
593 
594     /**
595      * @dev Atomically decreases the allowance granted to `spender` by the caller.
596      *
597      * This is an alternative to {approve} that can be used as a mitigation for
598      * problems described in {IERC20-approve}.
599      *
600      * Emits an {Approval} event indicating the updated allowance.
601      *
602      * Requirements:
603      *
604      * - `spender` cannot be the zero address.
605      * - `spender` must have allowance for the caller of at least
606      * `subtractedValue`.
607      */
608     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
609         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
610         return true;
611     }
612 
613     /**
614      * @dev Moves tokens `amount` from `sender` to `recipient`.
615      *
616      * This is internal function is equivalent to {transfer}, and can be used to
617      * e.g. implement automatic token fees, slashing mechanisms, etc.
618      *
619      * Emits a {Transfer} event.
620      *
621      * Requirements:
622      *
623      * - `sender` cannot be the zero address.
624      * - `recipient` cannot be the zero address.
625      * - `sender` must have a balance of at least `amount`.
626      */
627     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
628         require(sender != address(0), "ERC20: transfer from the zero address");
629         require(recipient != address(0), "ERC20: transfer to the zero address");
630 
631         _beforeTokenTransfer(sender, recipient, amount);
632 
633         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
634         _balances[recipient] = _balances[recipient].add(amount);
635         emit Transfer(sender, recipient, amount);
636     }
637 
638     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
639      * the total supply.
640      *
641      * Emits a {Transfer} event with `from` set to the zero address.
642      *
643      * Requirements
644      *
645      * - `to` cannot be the zero address.
646      */
647     function _mint(address account, uint256 amount) internal virtual {
648         require(account != address(0), "ERC20: mint to the zero address");
649 
650         _beforeTokenTransfer(address(0), account, amount);
651 
652         _totalSupply = _totalSupply.add(amount);
653         _balances[account] = _balances[account].add(amount);
654         emit Transfer(address(0), account, amount);
655     }
656 
657     /**
658      * @dev Destroys `amount` tokens from `account`, reducing the
659      * total supply.
660      *
661      * Emits a {Transfer} event with `to` set to the zero address.
662      *
663      * Requirements
664      *
665      * - `account` cannot be the zero address.
666      * - `account` must have at least `amount` tokens.
667      */
668     function _burn(address account, uint256 amount) internal virtual {
669         require(account != address(0), "ERC20: burn from the zero address");
670 
671         _beforeTokenTransfer(account, address(0), amount);
672 
673         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
674         _totalSupply = _totalSupply.sub(amount);
675         emit Transfer(account, address(0), amount);
676     }
677 
678     /**
679      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
680      *
681      * This is internal function is equivalent to `approve`, and can be used to
682      * e.g. set automatic allowances for certain subsystems, etc.
683      *
684      * Emits an {Approval} event.
685      *
686      * Requirements:
687      *
688      * - `owner` cannot be the zero address.
689      * - `spender` cannot be the zero address.
690      */
691     function _approve(address owner, address spender, uint256 amount) internal virtual {
692         require(owner != address(0), "ERC20: approve from the zero address");
693         require(spender != address(0), "ERC20: approve to the zero address");
694 
695         _allowances[owner][spender] = amount;
696         emit Approval(owner, spender, amount);
697     }
698 
699     /**
700      * @dev Sets {decimals} to a value other than the default one of 18.
701      *
702      * WARNING: This function should only be called from the constructor. Most
703      * applications that interact with token contracts will not expect
704      * {decimals} to ever change, and may work incorrectly if it does.
705      */
706     function _setupDecimals(uint8 decimals_) internal {
707         _decimals = decimals_;
708     }
709 
710     /**
711      * @dev Hook that is called before any transfer of tokens. This includes
712      * minting and burning.
713      *
714      * Calling conditions:
715      *
716      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
717      * will be to transferred to `to`.
718      * - when `from` is zero, `amount` tokens will be minted for `to`.
719      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
720      * - `from` and `to` are never both zero.
721      *
722      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
723      */
724     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
725 }
726 
727 // File: openzeppelin-solidity/contracts/access/Ownable.sol
728 
729 
730 
731 pragma solidity ^0.6.0;
732 
733 /**
734  * @dev Contract module which provides a basic access control mechanism, where
735  * there is an account (an owner) that can be granted exclusive access to
736  * specific functions.
737  *
738  * By default, the owner account will be the one that deploys the contract. This
739  * can later be changed with {transferOwnership}.
740  *
741  * This module is used through inheritance. It will make available the modifier
742  * `onlyOwner`, which can be applied to your functions to restrict their use to
743  * the owner.
744  */
745 contract Ownable is Context {
746     address private _owner;
747 
748     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
749 
750     /**
751      * @dev Initializes the contract setting the deployer as the initial owner.
752      */
753     constructor () internal {
754         address msgSender = _msgSender();
755         _owner = msgSender;
756         emit OwnershipTransferred(address(0), msgSender);
757     }
758 
759     /**
760      * @dev Returns the address of the current owner.
761      */
762     function owner() public view returns (address) {
763         return _owner;
764     }
765 
766     /**
767      * @dev Throws if called by any account other than the owner.
768      */
769     modifier onlyOwner() {
770         require(_owner == _msgSender(), "Ownable: caller is not the owner");
771         _;
772     }
773 
774     /**
775      * @dev Leaves the contract without owner. It will not be possible to call
776      * `onlyOwner` functions anymore. Can only be called by the current owner.
777      *
778      * NOTE: Renouncing ownership will leave the contract without an owner,
779      * thereby removing any functionality that is only available to the owner.
780      */
781     function renounceOwnership() public virtual onlyOwner {
782         emit OwnershipTransferred(_owner, address(0));
783         _owner = address(0);
784     }
785 
786     /**
787      * @dev Transfers ownership of the contract to a new account (`newOwner`).
788      * Can only be called by the current owner.
789      */
790     function transferOwnership(address newOwner) public virtual onlyOwner {
791         require(newOwner != address(0), "Ownable: new owner is the zero address");
792         emit OwnershipTransferred(_owner, newOwner);
793         _owner = newOwner;
794     }
795 }
796 
797 // File: original_contracts/IWhitelisted.sol
798 
799 pragma solidity 0.6.12;
800 
801 
802 interface IWhitelisted {
803 
804     function hasRole(
805         bytes32 role,
806         address account
807     )
808         external
809         view
810         returns (bool);
811 
812     function WHITELISTED_ROLE() external view returns(bytes32);
813 }
814 
815 // File: original_contracts/lib/IExchange.sol
816 
817 pragma solidity 0.6.12;
818 
819 
820 
821 /**
822 * @dev This interface should be implemented by all exchanges which needs to integrate with the paraswap protocol
823 */
824 interface IExchange {
825 
826     /**
827    * @dev The function which performs the swap on an exchange.
828    * Exchange needs to implement this method in order to support swapping of tokens through it
829    * @param fromToken Address of the source token
830    * @param toToken Address of the destination token
831    * @param fromAmount Amount of source tokens to be swapped
832    * @param toAmount Minimum destination token amount expected out of this swap
833    * @param exchange Internal exchange or factory contract address for the exchange. For example Registry address for the Uniswap
834    * @param payload Any exchange specific data which is required can be passed in this argument in encoded format which
835    * will be decoded by the exchange. Each exchange will publish it's own decoding/encoding mechanism
836    */
837     function swap(
838         IERC20 fromToken,
839         IERC20 toToken,
840         uint256 fromAmount,
841         uint256 toAmount,
842         address exchange,
843         bytes calldata payload) external payable returns (uint256);
844 
845 /**
846    * @dev The function which performs the swap on an exchange.
847    * Exchange needs to implement this method in order to support swapping of tokens through it
848    * @param fromToken Address of the source token
849    * @param toToken Address of the destination token
850    * @param fromAmount Max Amount of source tokens to be swapped
851    * @param toAmount Destination token amount expected out of this swap
852    * @param exchange Internal exchange or factory contract address for the exchange. For example Registry address for the Uniswap
853    * @param payload Any exchange specific data which is required can be passed in this argument in encoded format which
854    * will be decoded by the exchange. Each exchange will publish it's own decoding/encoding mechanism
855    */
856     function buy(
857         IERC20 fromToken,
858         IERC20 toToken,
859         uint256 fromAmount,
860         uint256 toAmount,
861         address exchange,
862         bytes calldata payload) external payable returns (uint256);
863 }
864 
865 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
866 
867 
868 
869 pragma solidity ^0.6.0;
870 
871 
872 
873 
874 /**
875  * @title SafeERC20
876  * @dev Wrappers around ERC20 operations that throw on failure (when the token
877  * contract returns false). Tokens that return no value (and instead revert or
878  * throw on failure) are also supported, non-reverting calls are assumed to be
879  * successful.
880  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
881  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
882  */
883 library SafeERC20 {
884     using SafeMath for uint256;
885     using Address for address;
886 
887     function safeTransfer(IERC20 token, address to, uint256 value) internal {
888         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
889     }
890 
891     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
892         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
893     }
894 
895     /**
896      * @dev Deprecated. This function has issues similar to the ones found in
897      * {IERC20-approve}, and its usage is discouraged.
898      *
899      * Whenever possible, use {safeIncreaseAllowance} and
900      * {safeDecreaseAllowance} instead.
901      */
902     function safeApprove(IERC20 token, address spender, uint256 value) internal {
903         // safeApprove should only be called when setting an initial allowance,
904         // or when resetting it to zero. To increase and decrease it, use
905         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
906         // solhint-disable-next-line max-line-length
907         require((value == 0) || (token.allowance(address(this), spender) == 0),
908             "SafeERC20: approve from non-zero to non-zero allowance"
909         );
910         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
911     }
912 
913     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
914         uint256 newAllowance = token.allowance(address(this), spender).add(value);
915         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
916     }
917 
918     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
919         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
920         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
921     }
922 
923     /**
924      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
925      * on the return value: the return value is optional (but if data is returned, it must not be false).
926      * @param token The token targeted by the call.
927      * @param data The call data (encoded using abi.encode or one of its variants).
928      */
929     function _callOptionalReturn(IERC20 token, bytes memory data) private {
930         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
931         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
932         // the target address contains contract code and also asserts for success in the low-level call.
933 
934         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
935         if (returndata.length > 0) { // Return data is optional
936             // solhint-disable-next-line max-line-length
937             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
938         }
939     }
940 }
941 
942 // File: original_contracts/ITokenTransferProxy.sol
943 
944 pragma solidity 0.6.12;
945 
946 
947 interface ITokenTransferProxy {
948 
949     function transferFrom(
950         address token,
951         address from,
952         address to,
953         uint256 amount
954     )
955         external;
956 
957     function freeGSTTokens(uint256 tokensToFree) external;
958 }
959 
960 // File: original_contracts/lib/Utils.sol
961 
962 pragma solidity 0.6.12;
963 
964 
965 
966 
967 
968 
969 
970 library Utils {
971     using SafeMath for uint256;
972     using SafeERC20 for IERC20;
973 
974     address constant ETH_ADDRESS = address(
975         0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
976     );
977 
978     uint256 constant MAX_UINT = 2 ** 256 - 1;
979 
980     struct Route {
981         address payable exchange;
982         address targetExchange;
983         uint percent;
984         bytes payload;
985         uint256 networkFee;//Network fee is associated with 0xv3 trades
986     }
987 
988     struct Path {
989         address to;
990         uint256 totalNetworkFee;//Network fee is associated with 0xv3 trades
991         Route[] routes;
992     }
993 
994     struct BuyRoute {
995         address payable exchange;
996         address targetExchange;
997         uint256 fromAmount;
998         uint256 toAmount;
999         bytes payload;
1000         uint256 networkFee;//Network fee is associated with 0xv3 trades
1001     }
1002 
1003     function ethAddress() internal pure returns (address) {return ETH_ADDRESS;}
1004 
1005     function maxUint() internal pure returns (uint256) {return MAX_UINT;}
1006 
1007     function approve(
1008         address addressToApprove,
1009         address token,
1010         uint256 amount
1011     ) internal {
1012         if (token != ETH_ADDRESS) {
1013             IERC20 _token = IERC20(token);
1014 
1015             uint allowance = _token.allowance(address(this), addressToApprove);
1016 
1017             if (allowance < amount) {
1018                 _token.safeApprove(addressToApprove, 0);
1019                 _token.safeIncreaseAllowance(addressToApprove, MAX_UINT);
1020             }
1021         }
1022     }
1023 
1024     function transferTokens(
1025         address token,
1026         address payable destination,
1027         uint256 amount
1028     )
1029     internal
1030     {
1031         if (amount > 0) {
1032             if (token == ETH_ADDRESS) {
1033                 destination.transfer(amount);
1034             }
1035             else {
1036                 IERC20(token).safeTransfer(destination, amount);
1037             }
1038         }
1039 
1040     }
1041 
1042     function tokenBalance(
1043         address token,
1044         address account
1045     )
1046     internal
1047     view
1048     returns (uint256)
1049     {
1050         if (token == ETH_ADDRESS) {
1051             return account.balance;
1052         } else {
1053             return IERC20(token).balanceOf(account);
1054         }
1055     }
1056 
1057     /**
1058     * @dev Helper method to refund gas using gas tokens
1059     */
1060     function refundGas(
1061         address tokenProxy,
1062         uint256 initialGas,
1063         uint256 mintPrice
1064     )
1065         internal
1066     {
1067 
1068         uint256 mintBase = 32254;
1069         uint256 mintToken = 36543;
1070         uint256 freeBase = 14154;
1071         uint256 freeToken = 6870;
1072         uint256 reimburse = 24000;
1073 
1074         uint256 tokens = initialGas.sub(
1075             gasleft()).add(freeBase).div(reimburse.mul(2).sub(freeToken)
1076         );
1077 
1078         uint256 mintCost = mintBase.add(tokens.mul(mintToken));
1079         uint256 freeCost = freeBase.add(tokens.mul(freeToken));
1080         uint256 maxreimburse = tokens.mul(reimburse);
1081 
1082         uint256 efficiency = maxreimburse.mul(tx.gasprice).mul(100).div(
1083             mintCost.mul(mintPrice).add(freeCost.mul(tx.gasprice))
1084         );
1085 
1086         if (efficiency > 100) {
1087             freeGasTokens(tokenProxy, tokens);
1088         }
1089     }
1090 
1091     /**
1092     * @dev Helper method to free gas tokens
1093     */
1094     function freeGasTokens(address tokenProxy, uint256 tokens) internal {
1095 
1096         uint256 tokensToFree = tokens;
1097         uint256 safeNumTokens = 0;
1098         uint256 gas = gasleft();
1099 
1100         if (gas >= 27710) {
1101             safeNumTokens = gas.sub(27710).div(1148 + 5722 + 150);
1102         }
1103 
1104         if (tokensToFree > safeNumTokens) {
1105             tokensToFree = safeNumTokens;
1106         }
1107 
1108         ITokenTransferProxy(tokenProxy).freeGSTTokens(tokensToFree);
1109 
1110     }
1111 }
1112 
1113 // File: original_contracts/IGST2.sol
1114 
1115 pragma solidity 0.6.12;
1116 
1117 interface IGST2 {
1118 
1119     function freeUpTo(uint256 value) external returns (uint256 freed);
1120 
1121     function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
1122 
1123     function balanceOf(address who) external view returns (uint256);
1124 
1125     function mint(uint256 value) external;
1126 }
1127 
1128 // File: original_contracts/TokenTransferProxy.sol
1129 
1130 pragma solidity 0.6.12;
1131 
1132 
1133 
1134 
1135 
1136 
1137 /**
1138 * @dev Allows owner of the contract to transfer tokens on behalf of user.
1139 * User will need to approve this contract to spend tokens on his/her behalf
1140 * on Paraswap platform
1141 */
1142 contract TokenTransferProxy is Ownable {
1143     using SafeERC20 for IERC20;
1144 
1145     IGST2 private _gst2;
1146 
1147     address private _gstHolder;
1148 
1149     constructor(address gst2, address gstHolder) public {
1150         _gst2 = IGST2(gst2);
1151         _gstHolder = gstHolder;
1152     }
1153 
1154     function getGSTHolder() external view returns(address) {
1155         return _gstHolder;
1156     }
1157 
1158     function getGST() external view returns(address) {
1159         return address(_gst2);
1160     }
1161 
1162     function changeGSTTokenHolder(address gstHolder) external onlyOwner {
1163         _gstHolder = gstHolder;
1164 
1165     }
1166 
1167     /**
1168     * @dev Allows owner of the contract to transfer tokens on user's behalf
1169     * @dev Swapper contract will be the owner of this contract
1170     * @param token Address of the token
1171     * @param from Address from which tokens will be transferred
1172     * @param to Receipent address of the tokens
1173     * @param amount Amount of tokens to transfer
1174     */
1175     function transferFrom(
1176         address token,
1177         address from,
1178         address to,
1179         uint256 amount
1180     )
1181         external
1182         onlyOwner
1183     {
1184         IERC20(token).safeTransferFrom(from, to, amount);
1185     }
1186 
1187     function freeGSTTokens(uint256 tokensToFree) external onlyOwner {
1188         _gst2.freeFromUpTo(_gstHolder, tokensToFree);
1189     }
1190 
1191 }
1192 
1193 // File: original_contracts/IPartnerRegistry.sol
1194 
1195 pragma solidity 0.6.12;
1196 
1197 
1198 interface IPartnerRegistry {
1199 
1200     function getPartnerContract(string calldata referralId) external view returns(address);
1201 
1202     function addPartner(
1203         string calldata referralId,
1204         address payable feeWallet,
1205         uint256 fee,
1206         uint256 paraswapShare,
1207         uint256 partnerShare,
1208         address owner,
1209         uint256 timelock,
1210         uint256 maxFee
1211     )
1212         external;
1213 
1214     function removePartner(string calldata referralId) external;
1215 }
1216 
1217 // File: original_contracts/IPartner.sol
1218 
1219 pragma solidity 0.6.12;
1220 
1221 
1222 interface IPartner {
1223 
1224     function getReferralId() external view returns(string memory);
1225 
1226     function getFeeWallet() external view returns(address payable);
1227 
1228     function getFee() external view returns(uint256);
1229 
1230     function getPartnerShare() external returns(uint256);
1231 
1232     function getParaswapShare() external returns(uint256);
1233 
1234     function changeFeeWallet(address payable feeWallet) external;
1235 
1236     function changeFee(uint256 newFee) external;
1237 }
1238 
1239 // File: original_contracts/AugustusSwapper.sol
1240 
1241 pragma solidity 0.6.12;
1242 pragma experimental ABIEncoderV2;
1243 
1244 
1245 
1246 
1247 
1248 
1249 
1250 
1251 
1252 
1253 
1254 
1255 contract AugustusSwapper is Ownable {
1256     using SafeMath for uint256;
1257     using SafeERC20 for IERC20;
1258     using Address for address;
1259 
1260     TokenTransferProxy private _tokenTransferProxy;
1261 
1262     bool private _paused;
1263 
1264     IWhitelisted private _whitelisted;
1265 
1266     IPartnerRegistry private _partnerRegistry;
1267     address payable private _feeWallet;
1268 
1269     string private _version = "2.0.0";
1270 
1271     event Paused();
1272     event Unpaused();
1273 
1274     event Swapped(
1275         address initiator,
1276         address indexed beneficiary,
1277         address indexed srcToken,
1278         address indexed destToken,
1279         uint256 srcAmount,
1280         uint256 receivedAmount,
1281         uint256 expectedAmount,
1282         string referrer
1283     );
1284 
1285     event Bought(
1286         address initiator,
1287         address indexed beneficiary,
1288         address indexed srcToken,
1289         address indexed destToken,
1290         uint256 srcAmount,
1291         uint256 receivedAmount,
1292         uint256 expectedAmount,
1293         string referrer
1294     );
1295 
1296     event Donation(address indexed receiver, uint256 donationBasisPoints);
1297 
1298     event FeeTaken(
1299         uint256 fee,
1300         uint256 partnerShare,
1301         uint256 paraswapShare
1302     );
1303 
1304     /**
1305      * @dev Modifier to make a function callable only when the contract is not paused.
1306      */
1307     modifier whenNotPaused() {
1308         require(!_paused, "Pausable: paused");
1309         _;
1310     }
1311 
1312     /**
1313      * @dev Modifier to make a function callable only when the contract is paused.
1314      */
1315     modifier whenPaused() {
1316         require(_paused, "Pausable: not paused");
1317         _;
1318     }
1319 
1320     constructor(
1321         address whitelist,
1322         address gasToken,
1323         address partnerRegistry,
1324         address payable feeWallet,
1325         address gstHolder
1326     )
1327         public
1328     {
1329 
1330         _partnerRegistry = IPartnerRegistry(partnerRegistry);
1331         _tokenTransferProxy = new TokenTransferProxy(gasToken, gstHolder);
1332         _whitelisted = IWhitelisted(whitelist);
1333         _feeWallet = feeWallet;
1334     }
1335 
1336     /**
1337     * @dev Fallback method to allow exchanges to transfer back ethers for a particular swap
1338     */
1339     receive() external payable {
1340     }
1341 
1342     function getVersion() external view returns(string memory) {
1343         return _version;
1344     }
1345 
1346     function getPartnerRegistry() external view returns(address) {
1347         return address(_partnerRegistry);
1348     }
1349 
1350     function getWhitelistAddress() external view returns(address) {
1351         return address(_whitelisted);
1352     }
1353 
1354     function getFeeWallet() external view returns(address) {
1355         return _feeWallet;
1356     }
1357 
1358     function setFeeWallet(address payable feeWallet) external onlyOwner {
1359         require(feeWallet != address(0), "Invalid address");
1360         _feeWallet = feeWallet;
1361     }
1362 
1363     function setPartnerRegistry(address partnerRegistry) external onlyOwner {
1364         require(partnerRegistry != address(0), "Invalid address");
1365         _partnerRegistry = IPartnerRegistry(partnerRegistry);
1366     }
1367 
1368     function setWhitelistAddress(address whitelisted) external onlyOwner {
1369         require(whitelisted != address(0), "Invalid whitelist address");
1370         _whitelisted = IWhitelisted(whitelisted);
1371     }
1372 
1373     function getTokenTransferProxy() external view returns (address) {
1374         return address(_tokenTransferProxy);
1375     }
1376 
1377     function changeGSTHolder(address gstHolder) external onlyOwner {
1378         require(gstHolder != address(0), "Invalid address");
1379         _tokenTransferProxy.changeGSTTokenHolder(gstHolder);
1380     }
1381 
1382     /**
1383      * @dev Returns true if the contract is paused, and false otherwise.
1384      */
1385     function paused() external view returns (bool) {
1386         return _paused;
1387     }
1388 
1389     /**
1390      * @dev Called by a pauser to pause, triggers stopped state.
1391      */
1392     function pause() external onlyOwner whenNotPaused {
1393         _paused = true;
1394         emit Paused();
1395     }
1396 
1397     /**
1398      * @dev Called by a pauser to unpause, returns to normal state.
1399      */
1400     function unpause() external onlyOwner whenPaused {
1401         _paused = false;
1402         emit Unpaused();
1403     }
1404 
1405     /**
1406     * @dev Allows owner of the contract to transfer tokens any tokens which are assigned to the contract
1407     * This method is for saftey if by any chance tokens or ETHs are assigned to the contract by mistake
1408     * @dev token Address of the token to be transferred
1409     * @dev destination Recepient of the token
1410     * @dev amount Amount of tokens to be transferred
1411     */
1412     function ownerTransferTokens(
1413         address token,
1414         address payable destination,
1415         uint256 amount
1416     )
1417     external
1418     onlyOwner
1419     {
1420         Utils.transferTokens(token, destination, amount);
1421     }
1422 
1423     /**
1424    * @dev The function which performs the multi path swap.
1425    * @param fromToken Address of the source token
1426    * @param toToken Address of the destination token
1427    * @param fromAmount Amount of source tokens to be swapped
1428    * @param toAmount Minimum destination token amount expected out of this swap
1429    * @param expectedAmount Expected amount of destination tokens without slippage
1430    * @param path Route to be taken for this swap to take place
1431    * @param mintPrice Price of gas at the time of minting of gas tokens, if any. In wei. 0 means gas token will not be used
1432    * @param beneficiary Beneficiary address
1433    * @param donationBasisPoints Basis points of returned amount to be transferred to beneficiary, if beneficiary is available. If this is passed as
1434    * 0 then 100% will be transferred to beneficiary. Pass 10000 for 100%
1435    * @param referrer referral id
1436    */
1437     function multiSwap(
1438         IERC20 fromToken,
1439         IERC20 toToken,
1440         uint256 fromAmount,
1441         uint256 toAmount,
1442         uint256 expectedAmount,
1443         Utils.Path[] memory path,
1444         uint256 mintPrice,
1445         address payable beneficiary,
1446         uint256 donationBasisPoints,
1447         string memory referrer
1448     )
1449         public
1450         payable
1451         whenNotPaused
1452         returns (uint256)
1453     {
1454         //Referral id can never be empty
1455         require(bytes(referrer).length > 0, "Invalid referrer");
1456 
1457         require(donationBasisPoints <= 10000, "Invalid value");
1458 
1459         require(toAmount > 0, "To amount can not be 0");
1460 
1461         uint256 receivedAmount = performSwap(
1462             fromToken,
1463             toToken,
1464             fromAmount,
1465             toAmount,
1466             path,
1467             mintPrice
1468         );
1469 
1470         takeFeeAndTransferTokens(
1471             toToken,
1472             toAmount,
1473             receivedAmount,
1474             beneficiary,
1475             donationBasisPoints,
1476             referrer
1477         );
1478 
1479         //If any ether is left at this point then we transfer it back to the user
1480         uint256 remEthBalance = Utils.tokenBalance(
1481             Utils.ethAddress(),
1482             address(this)
1483         );
1484         if ( remEthBalance > 0) {
1485             msg.sender.transfer(remEthBalance);
1486         }
1487 
1488         //Contract should not have any remaining balance after entire execution
1489         require(
1490             Utils.tokenBalance(address(toToken), address(this)) == 0,
1491             "Destination tokens are stuck"
1492         );
1493 
1494         emit Swapped(
1495             msg.sender,
1496             beneficiary == address(0)?msg.sender:beneficiary,
1497             address(fromToken),
1498             address(toToken),
1499             fromAmount,
1500             receivedAmount,
1501             expectedAmount,
1502             referrer
1503         );
1504 
1505         return receivedAmount;
1506     }
1507 
1508     /**
1509    * @dev The function which performs the single path buy.
1510    * @param fromToken Address of the source token
1511    * @param toToken Address of the destination token
1512    * @param fromAmount Max amount of source tokens to be swapped
1513    * @param toAmount Destination token amount expected out of this swap
1514    * @param expectedAmount Expected amount of source tokens to be used without slippage
1515    * @param route Route to be taken for this swap to take place
1516    * @param mintPrice Price of gas at the time of minting of gas tokens, if any. In wei. 0 means gas token will not be used
1517    * @param beneficiary Beneficiary address
1518    * @param donationBasisPoints Basis points of returned amount to be transferred to beneficiary, if beneficiary is available. If this is passed as
1519    * 0 then 100% will be transferred to beneficiary. Pass 10000 for 100%
1520    * @param referrer referral id
1521    */
1522     function buy(
1523         IERC20 fromToken,
1524         IERC20 toToken,
1525         uint256 fromAmount,
1526         uint256 toAmount,
1527         uint256 expectedAmount,
1528         Utils.BuyRoute[] memory route,
1529         uint256 mintPrice,
1530         address payable beneficiary,
1531         uint256 donationBasisPoints,
1532         string memory referrer
1533     )
1534         public
1535         payable
1536         whenNotPaused
1537         returns (uint256)
1538     {
1539         //Referral id can never be empty
1540         require(bytes(referrer).length > 0, "Invalid referrer");
1541 
1542         require(donationBasisPoints <= 10000, "Invalid value");
1543 
1544         require(toAmount > 0, "To amount can not be 0");
1545 
1546         uint256 receivedAmount = performBuy(
1547             fromToken,
1548             toToken,
1549             fromAmount,
1550             toAmount,
1551             route,
1552             mintPrice
1553         );
1554 
1555         takeFeeAndTransferTokens(
1556             toToken,
1557             toAmount,
1558             receivedAmount,
1559             beneficiary,
1560             donationBasisPoints,
1561             referrer
1562         );
1563 
1564         uint256 remainingAmount = Utils.tokenBalance(
1565             address(fromToken),
1566             address(this)
1567         );
1568         Utils.transferTokens(address(fromToken), msg.sender, remainingAmount);
1569 
1570         //If any ether is left at this point then we transfer it back to the user
1571         remainingAmount = Utils.tokenBalance(
1572             Utils.ethAddress(),
1573             address(this)
1574         );
1575         if ( remainingAmount > 0) {
1576             Utils.transferTokens(Utils.ethAddress(), msg.sender, remainingAmount);
1577         }
1578 
1579         //Contract should not have any remaining balance after entire execution
1580         require(
1581             Utils.tokenBalance(address(toToken), address(this)) == 0,
1582             "Destination tokens are stuck"
1583         );
1584 
1585         emit Bought(
1586             msg.sender,
1587             beneficiary == address(0)?msg.sender:beneficiary,
1588             address(fromToken),
1589             address(toToken),
1590             fromAmount,
1591             receivedAmount,
1592             expectedAmount,
1593             referrer
1594         );
1595 
1596         return receivedAmount;
1597     }
1598 
1599 
1600 
1601     //Helper function to transfer final amount to the beneficiaries
1602     function takeFeeAndTransferTokens(
1603         IERC20 toToken,
1604         uint256 toAmount,
1605         uint256 receivedAmount,
1606         address payable beneficiary,
1607         uint256 donationBasisPoints,
1608         string memory referrer
1609 
1610     )
1611         private
1612     {
1613         uint256 remainingAmount = receivedAmount;
1614 
1615         //Take partner fee
1616         uint256 fee = _takeFee(
1617             toToken,
1618             receivedAmount,
1619             referrer
1620         );
1621         remainingAmount = receivedAmount.sub(fee);
1622 
1623         //If beneficiary is not a 0 address then it means it is a transfer transaction
1624         if (beneficiary == address(0)){
1625             Utils.transferTokens(address(toToken), msg.sender, remainingAmount);
1626         }
1627         else {
1628             //Extra check of < 100 is made to ensure that in case of 100% we do not send
1629             //un-necessary transfer call to the msg.sender. This will save some gas
1630             if (donationBasisPoints > 0 && donationBasisPoints < 10000){
1631 
1632                 //Keep donation amount with the contract and send rest to the msg.sender
1633                 uint256 donationAmount = remainingAmount.mul(donationBasisPoints).div(10000);
1634 
1635                 Utils.transferTokens(
1636                     address(toToken),
1637                     msg.sender,
1638                     remainingAmount.sub(donationAmount)
1639                 );
1640 
1641                 remainingAmount = donationAmount;
1642             }
1643 
1644             //we will fire donation event if donationBasisPoints is > 0 even if it is 100%
1645             if (donationBasisPoints > 0) {
1646                 emit Donation(beneficiary, donationBasisPoints);
1647             }
1648 
1649             Utils.transferTokens(address(toToken), beneficiary, remainingAmount);
1650         }
1651 
1652     }
1653 
1654     //Helper function to perform swap
1655     function performSwap(
1656         IERC20 fromToken,
1657         IERC20 toToken,
1658         uint256 fromAmount,
1659         uint256 toAmount,
1660         Utils.Path[] memory path,
1661         uint256 mintPrice
1662     )
1663         private
1664         returns(uint256)
1665     {
1666         uint initialGas = gasleft();
1667 
1668         uint _fromAmount = fromAmount;
1669 
1670         require(path.length > 0, "Path not provided for swap");
1671         require(
1672             path[path.length - 1].to == address(toToken),
1673             "Last to token does not match toToken"
1674         );
1675 
1676         //if fromToken is not ETH then transfer tokens from user to this contract
1677         if (address(fromToken) != Utils.ethAddress()) {
1678             _tokenTransferProxy.transferFrom(
1679                 address(fromToken),
1680                 msg.sender,
1681                 address(this),
1682                 fromAmount
1683             );
1684         }
1685 
1686         //Assuming path will not be too long to reach out of gas exception
1687         for (uint i = 0; i < path.length; i++) {
1688             //_fromToken will be either fromToken of toToken of the previous path
1689             IERC20 _fromToken = i > 0 ? IERC20(path[i - 1].to) : IERC20(fromToken);
1690             IERC20 _toToken = IERC20(path[i].to);
1691 
1692             if (i > 0 && address(_fromToken) == Utils.ethAddress()) {
1693                 _fromAmount = _fromAmount.sub(path[i].totalNetworkFee);
1694             }
1695 
1696             uint256 initialFromBalance = Utils.tokenBalance(
1697                 address(_fromToken),
1698                 address(this)
1699             ).sub(_fromAmount);
1700 
1701             for (uint j = 0; j < path[i].routes.length; j++) {
1702                 Utils.Route memory route = path[i].routes[j];
1703 
1704                 //Calculating tokens to be passed to the relevant exchange
1705                 //percentage should be 200 for 2%
1706                 uint fromAmountSlice = _fromAmount.mul(route.percent).div(10000);
1707                 uint256 value = route.networkFee;
1708 
1709                 if (j == path[i].routes.length.sub(1)) {
1710                     uint256 remBal = Utils.tokenBalance(address(_fromToken), address(this));
1711 
1712                     fromAmountSlice = remBal;
1713 
1714                     if (address(_fromToken) == Utils.ethAddress()) {
1715                         //subtract network fee
1716                         fromAmountSlice = fromAmountSlice.sub(value);
1717                     }
1718                 }
1719 
1720                 //Check if exchange is supported
1721                 require(
1722                     _whitelisted.hasRole(_whitelisted.WHITELISTED_ROLE(), route.exchange),
1723                     "Exchange not whitelisted"
1724                 );
1725 
1726                 IExchange dex = IExchange(route.exchange);
1727 
1728                 Utils.approve(
1729                   route.exchange,
1730                   address(_fromToken),
1731                   fromAmountSlice
1732                 );
1733 
1734                 uint256 initialExchangeFromBalance = Utils.tokenBalance(
1735                     address(_fromToken),
1736                     route.exchange
1737                 );
1738                 uint256 initialExchangeToBalance = Utils.tokenBalance(
1739                     address(_toToken),
1740                     route.exchange
1741                 );
1742 
1743                 //Call to the exchange
1744                 if (address(_fromToken) == Utils.ethAddress()) {
1745                     value = value.add(fromAmountSlice);
1746 
1747                     dex.swap{value: value}(_fromToken, _toToken, fromAmountSlice, 1, route.targetExchange, route.payload);
1748                 }
1749                 else {
1750                     _fromToken.safeTransfer(route.exchange, fromAmountSlice);
1751 
1752                     dex.swap{value: value}(_fromToken, _toToken, fromAmountSlice, 1, route.targetExchange, route.payload);
1753                 }
1754 
1755                 require(
1756                     Utils.tokenBalance(address(_toToken), route.exchange) <= initialExchangeToBalance,
1757                     "Destination tokens are stuck in exchange"
1758                 );
1759                 require(
1760                     Utils.tokenBalance(address(_fromToken), route.exchange) <= initialExchangeFromBalance,
1761                     "Source tokens are stuck in exchange"
1762                 );
1763             }
1764 
1765             _fromAmount = Utils.tokenBalance(address(_toToken), address(this));
1766 
1767             //Contract should not have any remaining balance after execution
1768             require(
1769                 Utils.tokenBalance(address(_fromToken), address(this)) <= initialFromBalance,
1770                 "From tokens are stuck"
1771             );
1772         }
1773 
1774         uint256 receivedAmount = Utils.tokenBalance(
1775             address(toToken),
1776             address(this)
1777         );
1778         require(
1779             receivedAmount >= toAmount,
1780             "Received amount of tokens are less then expected"
1781         );
1782 
1783         if (mintPrice > 0) {
1784             Utils.refundGas(address(_tokenTransferProxy), initialGas, mintPrice);
1785         }
1786         return receivedAmount;
1787     }
1788 
1789     //Helper function to perform swap
1790     function performBuy(
1791         IERC20 fromToken,
1792         IERC20 toToken,
1793         uint256 fromAmount,
1794         uint256 toAmount,
1795         Utils.BuyRoute[] memory routes,
1796         uint256 mintPrice
1797     )
1798         private
1799         returns(uint256)
1800     {
1801         uint initialGas = gasleft();
1802         IERC20 _fromToken = fromToken;
1803         IERC20 _toToken = toToken;
1804 
1805         //if fromToken is not ETH then transfer tokens from user to this contract
1806         if (address(_fromToken) != Utils.ethAddress()) {
1807             _tokenTransferProxy.transferFrom(
1808                 address(_fromToken),
1809                 msg.sender,
1810                 address(this),
1811                 fromAmount
1812             );
1813         }
1814 
1815         for (uint j = 0; j < routes.length; j++) {
1816             Utils.BuyRoute memory route = routes[j];
1817 
1818             //Check if exchange is supported
1819             require(
1820                 _whitelisted.hasRole(_whitelisted.WHITELISTED_ROLE(), route.exchange),
1821                 "Exchange not whitelisted"
1822             );
1823             IExchange dex = IExchange(route.exchange);
1824             Utils.approve(
1825               route.exchange,
1826               address(_fromToken),
1827               route.fromAmount
1828             );
1829 
1830             uint256 initialExchangeFromBalance = Utils.tokenBalance(
1831                 address(_fromToken),
1832                 route.exchange
1833             );
1834             uint256 initialExchangeToBalance = Utils.tokenBalance(
1835                 address(_toToken),
1836                 route.exchange
1837             );
1838             //Call to the exchange
1839             if (address(_fromToken) == Utils.ethAddress()) {
1840                 uint256 value = route.networkFee.add(route.fromAmount);
1841                 dex.buy{value: value}(
1842                     _fromToken,
1843                     _toToken,
1844                     route.fromAmount,
1845                     route.toAmount,
1846                     route.targetExchange,
1847                     route.payload
1848                 );
1849             }
1850             else {
1851                 _fromToken.safeTransfer(route.exchange, route.fromAmount);
1852                 dex.buy{value: route.networkFee}(
1853                     _fromToken,
1854                     _toToken,
1855                     route.fromAmount,
1856                     route.toAmount,
1857                     route.targetExchange,
1858                     route.payload
1859                 );
1860             }
1861             require(
1862                 Utils.tokenBalance(address(_toToken), route.exchange) <= initialExchangeToBalance,
1863                 "Destination tokens are stuck in exchange"
1864             );
1865             require(
1866                 Utils.tokenBalance(address(_fromToken), route.exchange) <= initialExchangeFromBalance,
1867                 "Source tokens are stuck in exchange"
1868             );
1869         }
1870 
1871         uint256 receivedAmount = Utils.tokenBalance(
1872             address(_toToken),
1873             address(this)
1874         );
1875         require(
1876             receivedAmount >= toAmount,
1877             "Received amount of tokens are less then expected tokens"
1878         );
1879 
1880         if (mintPrice > 0) {
1881             Utils.refundGas(address(_tokenTransferProxy), initialGas, mintPrice);
1882         }
1883         return receivedAmount;
1884     }
1885 
1886     function _takeFee(
1887         IERC20 toToken,
1888         uint256 receivedAmount,
1889         string memory referrer
1890     )
1891         private
1892         returns(uint256)
1893     {
1894         address partnerContract = _partnerRegistry.getPartnerContract(referrer);
1895 
1896         //If there is no partner associated with the referral id then no fee will be taken
1897         if (partnerContract == address(0)) {
1898             return 0;
1899         }
1900 
1901         uint256 feePercent = IPartner(partnerContract).getFee();
1902         uint256 partnerSharePercent = IPartner(partnerContract).getPartnerShare();
1903         address payable partnerFeeWallet = IPartner(partnerContract).getFeeWallet();
1904 
1905         //Calculate total fee to be taken
1906         uint256 fee = receivedAmount.mul(feePercent).div(10000);
1907         //Calculate partner's share
1908         uint256 partnerShare = fee.mul(partnerSharePercent).div(10000);
1909         //All remaining fee is paraswap's share
1910         uint256 paraswapShare = fee.sub(partnerShare);
1911 
1912         Utils.transferTokens(address(toToken), partnerFeeWallet, partnerShare);
1913         Utils.transferTokens(address(toToken), _feeWallet, paraswapShare);
1914 
1915         emit FeeTaken(fee, partnerShare, paraswapShare);
1916         return fee;
1917     }
1918 }