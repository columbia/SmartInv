1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/GSN/Context.sol
4 pragma solidity ^0.6.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
28 
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
110 
111 pragma solidity ^0.6.0;
112 
113 /**
114  * @dev Wrappers over Solidity's arithmetic operations with added overflow
115  * checks.
116  *
117  * Arithmetic operations in Solidity wrap on overflow. This can easily result
118  * in bugs, because programmers usually assume that an overflow raises an
119  * error, which is the standard behavior in high level programming languages.
120  * `SafeMath` restores this intuition by reverting the transaction when an
121  * operation overflows.
122  *
123  * Using this library instead of the unchecked operations eliminates an entire
124  * class of bugs, so it's recommended to use it always.
125  */
126 library SafeMath {
127     /**
128      * @dev Returns the addition of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `+` operator.
132      *
133      * Requirements:
134      *
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      *
152      * - Subtraction cannot overflow.
153      */
154     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155         return sub(a, b, "SafeMath: subtraction overflow");
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * Counterpart to Solidity's `-` operator.
163      *
164      * Requirements:
165      *
166      * - Subtraction cannot overflow.
167      */
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      *
183      * - Multiplication cannot overflow.
184      */
185     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
186         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
187         // benefit is lost if 'b' is also tested.
188         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
189         if (a == 0) {
190             return 0;
191         }
192 
193         uint256 c = a * b;
194         require(c / a == b, "SafeMath: multiplication overflow");
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the integer division of two unsigned integers. Reverts on
201      * division by zero. The result is rounded towards zero.
202      *
203      * Counterpart to Solidity's `/` operator. Note: this function uses a
204      * `revert` opcode (which leaves remaining gas untouched) while Solidity
205      * uses an invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function div(uint256 a, uint256 b) internal pure returns (uint256) {
212         return div(a, b, "SafeMath: division by zero");
213     }
214 
215     /**
216      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
217      * division by zero. The result is rounded towards zero.
218      *
219      * Counterpart to Solidity's `/` operator. Note: this function uses a
220      * `revert` opcode (which leaves remaining gas untouched) while Solidity
221      * uses an invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
248         return mod(a, b, "SafeMath: modulo by zero");
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * Reverts with custom message when dividing by zero.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 // File: @openzeppelin/contracts/utils/Address.sol
270 
271 
272 
273 pragma solidity ^0.6.2;
274 
275 /**
276  * @dev Collection of functions related to the address type
277  */
278 library Address {
279     /**
280      * @dev Returns true if `account` is a contract.
281      *
282      * [IMPORTANT]
283      * ====
284      * It is unsafe to assume that an address for which this function returns
285      * false is an externally-owned account (EOA) and not a contract.
286      *
287      * Among others, `isContract` will return false for the following
288      * types of addresses:
289      *
290      *  - an externally-owned account
291      *  - a contract in construction
292      *  - an address where a contract will be created
293      *  - an address where a contract lived, but was destroyed
294      * ====
295      */
296     function isContract(address account) internal view returns (bool) {
297         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
298         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
299         // for accounts without code, i.e. `keccak256('')`
300         bytes32 codehash;
301         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
302         // solhint-disable-next-line no-inline-assembly
303         assembly { codehash := extcodehash(account) }
304         return (codehash != accountHash && codehash != 0x0);
305     }
306 
307     /**
308      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
309      * `recipient`, forwarding all available gas and reverting on errors.
310      *
311      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
312      * of certain opcodes, possibly making contracts go over the 2300 gas limit
313      * imposed by `transfer`, making them unable to receive funds via
314      * `transfer`. {sendValue} removes this limitation.
315      *
316      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
317      *
318      * IMPORTANT: because control is transferred to `recipient`, care must be
319      * taken to not create reentrancy vulnerabilities. Consider using
320      * {ReentrancyGuard} or the
321      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
322      */
323     function sendValue(address payable recipient, uint256 amount) internal {
324         require(address(this).balance >= amount, "Address: insufficient balance");
325 
326         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
327         (bool success, ) = recipient.call{ value: amount }("");
328         require(success, "Address: unable to send value, recipient may have reverted");
329     }
330 
331     /**
332      * @dev Performs a Solidity function call using a low level `call`. A
333      * plain`call` is an unsafe replacement for a function call: use this
334      * function instead.
335      *
336      * If `target` reverts with a revert reason, it is bubbled up by this
337      * function (like regular Solidity function calls).
338      *
339      * Returns the raw returned data. To convert to the expected return value,
340      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
341      *
342      * Requirements:
343      *
344      * - `target` must be a contract.
345      * - calling `target` with `data` must not revert.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
350       return functionCall(target, data, "Address: low-level call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
355      * `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
360         return _functionCallWithValue(target, data, 0, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but also transferring `value` wei to `target`.
366      *
367      * Requirements:
368      *
369      * - the calling contract must have an ETH balance of at least `value`.
370      * - the called Solidity function must be `payable`.
371      *
372      * _Available since v3.1._
373      */
374     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
375         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
380      * with `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
385         require(address(this).balance >= value, "Address: insufficient balance for call");
386         return _functionCallWithValue(target, data, value, errorMessage);
387     }
388 
389     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
390         require(isContract(target), "Address: call to non-contract");
391 
392         // solhint-disable-next-line avoid-low-level-calls
393         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
394         if (success) {
395             return returndata;
396         } else {
397             // Look for revert reason and bubble it up if present
398             if (returndata.length > 0) {
399                 // The easiest way to bubble the revert reason is using memory via assembly
400 
401                 // solhint-disable-next-line no-inline-assembly
402                 assembly {
403                     let returndata_size := mload(returndata)
404                     revert(add(32, returndata), returndata_size)
405                 }
406             } else {
407                 revert(errorMessage);
408             }
409         }
410     }
411 }
412 
413 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
414 
415 
416 
417 pragma solidity ^0.6.0;
418 
419 
420 
421 
422 
423 /**
424  * @dev Implementation of the {IERC20} interface.
425  *
426  * This implementation is agnostic to the way tokens are created. This means
427  * that a supply mechanism has to be added in a derived contract using {_mint}.
428  * For a generic mechanism see {ERC20PresetMinterPauser}.
429  *
430  * TIP: For a detailed writeup see our guide
431  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
432  * to implement supply mechanisms].
433  *
434  * We have followed general OpenZeppelin guidelines: functions revert instead
435  * of returning `false` on failure. This behavior is nonetheless conventional
436  * and does not conflict with the expectations of ERC20 applications.
437  *
438  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
439  * This allows applications to reconstruct the allowance for all accounts just
440  * by listening to said events. Other implementations of the EIP may not emit
441  * these events, as it isn't required by the specification.
442  *
443  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
444  * functions have been added to mitigate the well-known issues around setting
445  * allowances. See {IERC20-approve}.
446  */
447 contract ERC20 is Context, IERC20 {
448     using SafeMath for uint256;
449     using Address for address;
450 
451     mapping (address => uint256) private _balances;
452 
453     mapping (address => mapping (address => uint256)) private _allowances;
454 
455     uint256 private _totalSupply;
456 
457     string private _name;
458     string private _symbol;
459     uint8 private _decimals;
460 
461     /**
462      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
463      * a default value of 18.
464      *
465      * To select a different value for {decimals}, use {_setupDecimals}.
466      *
467      * All three of these values are immutable: they can only be set once during
468      * construction.
469      */
470     constructor (string memory name, string memory symbol) public {
471         _name = name;
472         _symbol = symbol;
473         _decimals = 18;
474     }
475 
476     /**
477      * @dev Returns the name of the token.
478      */
479     function name() public view returns (string memory) {
480         return _name;
481     }
482 
483     /**
484      * @dev Returns the symbol of the token, usually a shorter version of the
485      * name.
486      */
487     function symbol() public view returns (string memory) {
488         return _symbol;
489     }
490 
491     /**
492      * @dev Returns the number of decimals used to get its user representation.
493      * For example, if `decimals` equals `2`, a balance of `505` tokens should
494      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
495      *
496      * Tokens usually opt for a value of 18, imitating the relationship between
497      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
498      * called.
499      *
500      * NOTE: This information is only used for _display_ purposes: it in
501      * no way affects any of the arithmetic of the contract, including
502      * {IERC20-balanceOf} and {IERC20-transfer}.
503      */
504     function decimals() public view returns (uint8) {
505         return _decimals;
506     }
507 
508     /**
509      * @dev See {IERC20-totalSupply}.
510      */
511     function totalSupply() public view override returns (uint256) {
512         return _totalSupply;
513     }
514 
515     /**
516      * @dev See {IERC20-balanceOf}.
517      */
518     function balanceOf(address account) public view override returns (uint256) {
519         return _balances[account];
520     }
521 
522     /**
523      * @dev See {IERC20-transfer}.
524      *
525      * Requirements:
526      *
527      * - `recipient` cannot be the zero address.
528      * - the caller must have a balance of at least `amount`.
529      */
530     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
531         _transfer(_msgSender(), recipient, amount);
532         return true;
533     }
534 
535     /**
536      * @dev See {IERC20-allowance}.
537      */
538     function allowance(address owner, address spender) public view virtual override returns (uint256) {
539         return _allowances[owner][spender];
540     }
541 
542     /**
543      * @dev See {IERC20-approve}.
544      *
545      * Requirements:
546      *
547      * - `spender` cannot be the zero address.
548      */
549     function approve(address spender, uint256 amount) public virtual override returns (bool) {
550         _approve(_msgSender(), spender, amount);
551         return true;
552     }
553 
554     /**
555      * @dev See {IERC20-transferFrom}.
556      *
557      * Emits an {Approval} event indicating the updated allowance. This is not
558      * required by the EIP. See the note at the beginning of {ERC20};
559      *
560      * Requirements:
561      * - `sender` and `recipient` cannot be the zero address.
562      * - `sender` must have a balance of at least `amount`.
563      * - the caller must have allowance for ``sender``'s tokens of at least
564      * `amount`.
565      */
566     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
567         _transfer(sender, recipient, amount);
568         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
569         return true;
570     }
571 
572     /**
573      * @dev Atomically increases the allowance granted to `spender` by the caller.
574      *
575      * This is an alternative to {approve} that can be used as a mitigation for
576      * problems described in {IERC20-approve}.
577      *
578      * Emits an {Approval} event indicating the updated allowance.
579      *
580      * Requirements:
581      *
582      * - `spender` cannot be the zero address.
583      */
584     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
585         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
586         return true;
587     }
588 
589     /**
590      * @dev Atomically decreases the allowance granted to `spender` by the caller.
591      *
592      * This is an alternative to {approve} that can be used as a mitigation for
593      * problems described in {IERC20-approve}.
594      *
595      * Emits an {Approval} event indicating the updated allowance.
596      *
597      * Requirements:
598      *
599      * - `spender` cannot be the zero address.
600      * - `spender` must have allowance for the caller of at least
601      * `subtractedValue`.
602      */
603     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
604         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
605         return true;
606     }
607 
608     /**
609      * @dev Moves tokens `amount` from `sender` to `recipient`.
610      *
611      * This is internal function is equivalent to {transfer}, and can be used to
612      * e.g. implement automatic token fees, slashing mechanisms, etc.
613      *
614      * Emits a {Transfer} event.
615      *
616      * Requirements:
617      *
618      * - `sender` cannot be the zero address.
619      * - `recipient` cannot be the zero address.
620      * - `sender` must have a balance of at least `amount`.
621      */
622     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
623         require(sender != address(0), "ERC20: transfer from the zero address");
624         require(recipient != address(0), "ERC20: transfer to the zero address");
625 
626         _beforeTokenTransfer(sender, recipient, amount);
627 
628         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
629         _balances[recipient] = _balances[recipient].add(amount);
630         emit Transfer(sender, recipient, amount);
631     }
632 
633     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
634      * the total supply.
635      *
636      * Emits a {Transfer} event with `from` set to the zero address.
637      *
638      * Requirements
639      *
640      * - `to` cannot be the zero address.
641      */
642     function _mint(address account, uint256 amount) internal virtual {
643         require(account != address(0), "ERC20: mint to the zero address");
644 
645         _beforeTokenTransfer(address(0), account, amount);
646 
647         _totalSupply = _totalSupply.add(amount);
648         _balances[account] = _balances[account].add(amount);
649         emit Transfer(address(0), account, amount);
650     }
651 
652     /**
653      * @dev Destroys `amount` tokens from `account`, reducing the
654      * total supply.
655      *
656      * Emits a {Transfer} event with `to` set to the zero address.
657      *
658      * Requirements
659      *
660      * - `account` cannot be the zero address.
661      * - `account` must have at least `amount` tokens.
662      */
663     function _burn(address account, uint256 amount) internal virtual {
664         require(account != address(0), "ERC20: burn from the zero address");
665 
666         _beforeTokenTransfer(account, address(0), amount);
667 
668         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
669         _totalSupply = _totalSupply.sub(amount);
670         emit Transfer(account, address(0), amount);
671     }
672 
673     /**
674      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
675      *
676      * This is internal function is equivalent to `approve`, and can be used to
677      * e.g. set automatic allowances for certain subsystems, etc.
678      *
679      * Emits an {Approval} event.
680      *
681      * Requirements:
682      *
683      * - `owner` cannot be the zero address.
684      * - `spender` cannot be the zero address.
685      */
686     function _approve(address owner, address spender, uint256 amount) internal virtual {
687         require(owner != address(0), "ERC20: approve from the zero address");
688         require(spender != address(0), "ERC20: approve to the zero address");
689 
690         _allowances[owner][spender] = amount;
691         emit Approval(owner, spender, amount);
692     }
693 
694     /**
695      * @dev Sets {decimals} to a value other than the default one of 18.
696      *
697      * WARNING: This function should only be called from the constructor. Most
698      * applications that interact with token contracts will not expect
699      * {decimals} to ever change, and may work incorrectly if it does.
700      */
701     function _setupDecimals(uint8 decimals_) internal {
702         _decimals = decimals_;
703     }
704 
705     /**
706      * @dev Hook that is called before any transfer of tokens. This includes
707      * minting and burning.
708      *
709      * Calling conditions:
710      *
711      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
712      * will be to transferred to `to`.
713      * - when `from` is zero, `amount` tokens will be minted for `to`.
714      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
715      * - `from` and `to` are never both zero.
716      *
717      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
718      */
719     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
720 }
721 
722 // File: @openzeppelin/contracts/access/Ownable.sol
723 
724 
725 
726 pragma solidity ^0.6.0;
727 
728 /**
729  * @dev Contract module which provides a basic access control mechanism, where
730  * there is an account (an owner) that can be granted exclusive access to
731  * specific functions.
732  *
733  * By default, the owner account will be the one that deploys the contract. This
734  * can later be changed with {transferOwnership}.
735  *
736  * This module is used through inheritance. It will make available the modifier
737  * `onlyOwner`, which can be applied to your functions to restrict their use to
738  * the owner.
739  */
740 contract Ownable is Context {
741     address private _owner;
742 
743     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
744 
745     /**
746      * @dev Initializes the contract setting the deployer as the initial owner.
747      */
748     constructor () internal {
749         address msgSender = _msgSender();
750         _owner = msgSender;
751         emit OwnershipTransferred(address(0), msgSender);
752     }
753 
754     /**
755      * @dev Returns the address of the current owner.
756      */
757     function owner() public view returns (address) {
758         return _owner;
759     }
760 
761     /**
762      * @dev Throws if called by any account other than the owner.
763      */
764     modifier onlyOwner() {
765         require(_owner == _msgSender(), "Ownable: caller is not the owner");
766         _;
767     }
768 
769     /**
770      * @dev Leaves the contract without owner. It will not be possible to call
771      * `onlyOwner` functions anymore. Can only be called by the current owner.
772      *
773      * NOTE: Renouncing ownership will leave the contract without an owner,
774      * thereby removing any functionality that is only available to the owner.
775      */
776     function renounceOwnership() public virtual onlyOwner {
777         emit OwnershipTransferred(_owner, address(0));
778         _owner = address(0);
779     }
780 
781     /**
782      * @dev Transfers ownership of the contract to a new account (`newOwner`).
783      * Can only be called by the current owner.
784      */
785     function transferOwnership(address newOwner) public virtual onlyOwner {
786         require(newOwner != address(0), "Ownable: new owner is the zero address");
787         emit OwnershipTransferred(_owner, newOwner);
788         _owner = newOwner;
789     }
790 }
791 
792 // File: contracts/HippoToken.sol
793 
794 pragma solidity 0.6.12;
795 
796 
797 
798 
799 // HippoToken with Governance.
800 contract HippoToken is ERC20("HippoFinance", "HIPPO"), Ownable {
801     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
802     function mint(address _to, uint256 _amount) public onlyOwner {
803         _mint(_to, _amount);
804         _moveDelegates(address(0), _delegates[_to], _amount);
805     }
806 
807     // Copied and modified from YAM code:
808     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
809     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
810     // Which is copied and modified from COMPOUND:
811     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
812 
813     /// @notice A record of each accounts delegate
814     mapping (address => address) internal _delegates;
815 
816     /// @notice A checkpoint for marking number of votes from a given block
817     struct Checkpoint {
818         uint32 fromBlock;
819         uint256 votes;
820     }
821 
822     /// @notice A record of votes checkpoints for each account, by index
823     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
824 
825     /// @notice The number of checkpoints for each account
826     mapping (address => uint32) public numCheckpoints;
827 
828     /// @notice The EIP-712 typehash for the contract's domain
829     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
830 
831     /// @notice The EIP-712 typehash for the delegation struct used by the contract
832     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
833 
834     /// @notice A record of states for signing / validating signatures
835     mapping (address => uint) public nonces;
836 
837       /// @notice An event thats emitted when an account changes its delegate
838     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
839 
840     /// @notice An event thats emitted when a delegate account's vote balance changes
841     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
842 
843     /**
844      * @notice Delegate votes from `msg.sender` to `delegatee`
845      * @param delegator The address to get delegatee for
846      */
847     function delegates(address delegator)
848         external
849         view
850         returns (address)
851     {
852         return _delegates[delegator];
853     }
854 
855    /**
856     * @notice Delegate votes from `msg.sender` to `delegatee`
857     * @param delegatee The address to delegate votes to
858     */
859     function delegate(address delegatee) external {
860         return _delegate(msg.sender, delegatee);
861     }
862 
863     /**
864      * @notice Delegates votes from signatory to `delegatee`
865      * @param delegatee The address to delegate votes to
866      * @param nonce The contract state required to match the signature
867      * @param expiry The time at which to expire the signature
868      * @param v The recovery byte of the signature
869      * @param r Half of the ECDSA signature pair
870      * @param s Half of the ECDSA signature pair
871      */
872     function delegateBySig(
873         address delegatee,
874         uint nonce,
875         uint expiry,
876         uint8 v,
877         bytes32 r,
878         bytes32 s
879     )
880         external
881     {
882         bytes32 domainSeparator = keccak256(
883             abi.encode(
884                 DOMAIN_TYPEHASH,
885                 keccak256(bytes(name())),
886                 getChainId(),
887                 address(this)
888             )
889         );
890 
891         bytes32 structHash = keccak256(
892             abi.encode(
893                 DELEGATION_TYPEHASH,
894                 delegatee,
895                 nonce,
896                 expiry
897             )
898         );
899 
900         bytes32 digest = keccak256(
901             abi.encodePacked(
902                 "\x19\x01",
903                 domainSeparator,
904                 structHash
905             )
906         );
907 
908         address signatory = ecrecover(digest, v, r, s);
909         require(signatory != address(0), "HIPPO::delegateBySig: invalid signature");
910         require(nonce == nonces[signatory]++, "HIPPO::delegateBySig: invalid nonce");
911         require(now <= expiry, "HIPPO::delegateBySig: signature expired");
912         return _delegate(signatory, delegatee);
913     }
914 
915     /**
916      * @notice Gets the current votes balance for `account`
917      * @param account The address to get votes balance
918      * @return The number of current votes for `account`
919      */
920     function getCurrentVotes(address account)
921         external
922         view
923         returns (uint256)
924     {
925         uint32 nCheckpoints = numCheckpoints[account];
926         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
927     }
928 
929     /**
930      * @notice Determine the prior number of votes for an account as of a block number
931      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
932      * @param account The address of the account to check
933      * @param blockNumber The block number to get the vote balance at
934      * @return The number of votes the account had as of the given block
935      */
936     function getPriorVotes(address account, uint blockNumber)
937         external
938         view
939         returns (uint256)
940     {
941         require(blockNumber < block.number, "HIPPO::getPriorVotes: not yet determined");
942 
943         uint32 nCheckpoints = numCheckpoints[account];
944         if (nCheckpoints == 0) {
945             return 0;
946         }
947 
948         // First check most recent balance
949         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
950             return checkpoints[account][nCheckpoints - 1].votes;
951         }
952 
953         // Next check implicit zero balance
954         if (checkpoints[account][0].fromBlock > blockNumber) {
955             return 0;
956         }
957 
958         uint32 lower = 0;
959         uint32 upper = nCheckpoints - 1;
960         while (upper > lower) {
961             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
962             Checkpoint memory cp = checkpoints[account][center];
963             if (cp.fromBlock == blockNumber) {
964                 return cp.votes;
965             } else if (cp.fromBlock < blockNumber) {
966                 lower = center;
967             } else {
968                 upper = center - 1;
969             }
970         }
971         return checkpoints[account][lower].votes;
972     }
973 
974     function _delegate(address delegator, address delegatee)
975         internal
976     {
977         address currentDelegate = _delegates[delegator];
978         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying HIPPOs (not scaled);
979         _delegates[delegator] = delegatee;
980 
981         emit DelegateChanged(delegator, currentDelegate, delegatee);
982 
983         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
984     }
985 
986     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
987         if (srcRep != dstRep && amount > 0) {
988             if (srcRep != address(0)) {
989                 // decrease old representative
990                 uint32 srcRepNum = numCheckpoints[srcRep];
991                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
992                 uint256 srcRepNew = srcRepOld.sub(amount);
993                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
994             }
995 
996             if (dstRep != address(0)) {
997                 // increase new representative
998                 uint32 dstRepNum = numCheckpoints[dstRep];
999                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1000                 uint256 dstRepNew = dstRepOld.add(amount);
1001                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1002             }
1003         }
1004     }
1005 
1006     function _writeCheckpoint(
1007         address delegatee,
1008         uint32 nCheckpoints,
1009         uint256 oldVotes,
1010         uint256 newVotes
1011     )
1012         internal
1013     {
1014         uint32 blockNumber = safe32(block.number, "HIPPO::_writeCheckpoint: block number exceeds 32 bits");
1015 
1016         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1017             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1018         } else {
1019             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1020             numCheckpoints[delegatee] = nCheckpoints + 1;
1021         }
1022 
1023         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1024     }
1025 
1026     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1027         require(n < 2**32, errorMessage);
1028         return uint32(n);
1029     }
1030 
1031     function getChainId() internal pure returns (uint) {
1032         uint256 chainId;
1033         assembly { chainId := chainid() }
1034         return chainId;
1035     }
1036 }