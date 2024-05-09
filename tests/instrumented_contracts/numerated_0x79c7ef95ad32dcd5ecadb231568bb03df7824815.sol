1 /**
2  *Submitted for verification at BscScan.com on 2020-11-10
3 */
4 
5 // SPDX-License-Identifier: MIT
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
30 /**
31  * @dev Collection of functions related to the address type
32  */
33 library Address {
34     /**
35      * @dev Returns true if `account` is a contract.
36      *
37      * [IMPORTANT]
38      * ====
39      * It is unsafe to assume that an address for which this function returns
40      * false is an externally-owned account (EOA) and not a contract.
41      *
42      * Among others, `isContract` will return false for the following
43      * types of addresses:
44      *
45      *  - an externally-owned account
46      *  - a contract in construction
47      *  - an address where a contract will be created
48      *  - an address where a contract lived, but was destroyed
49      * ====
50      */
51     function isContract(address account) internal view returns (bool) {
52         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
53         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
54         // for accounts without code, i.e. `keccak256('')`
55         bytes32 codehash;
56         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
57         // solhint-disable-next-line no-inline-assembly
58         assembly { codehash := extcodehash(account) }
59         return (codehash != accountHash && codehash != 0x0);
60     }
61 
62     /**
63      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
64      * `recipient`, forwarding all available gas and reverting on errors.
65      *
66      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
67      * of certain opcodes, possibly making contracts go over the 2300 gas limit
68      * imposed by `transfer`, making them unable to receive funds via
69      * `transfer`. {sendValue} removes this limitation.
70      *
71      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
72      *
73      * IMPORTANT: because control is transferred to `recipient`, care must be
74      * taken to not create reentrancy vulnerabilities. Consider using
75      * {ReentrancyGuard} or the
76      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
77      */
78     function sendValue(address payable recipient, uint256 amount) internal {
79         require(address(this).balance >= amount, "Address: insufficient balance");
80 
81         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
82         (bool success, ) = recipient.call{ value: amount }("");
83         require(success, "Address: unable to send value, recipient may have reverted");
84     }
85 
86     /**
87      * @dev Performs a Solidity function call using a low level `call`. A
88      * plain`call` is an unsafe replacement for a function call: use this
89      * function instead.
90      *
91      * If `target` reverts with a revert reason, it is bubbled up by this
92      * function (like regular Solidity function calls).
93      *
94      * Returns the raw returned data. To convert to the expected return value,
95      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
96      *
97      * Requirements:
98      *
99      * - `target` must be a contract.
100      * - calling `target` with `data` must not revert.
101      *
102      * _Available since v3.1._
103      */
104     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
105         return functionCall(target, data, "Address: low-level call failed");
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
110      * `errorMessage` as a fallback revert reason when `target` reverts.
111      *
112      * _Available since v3.1._
113      */
114     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
115         return _functionCallWithValue(target, data, 0, errorMessage);
116     }
117 
118     /**
119      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
120      * but also transferring `value` wei to `target`.
121      *
122      * Requirements:
123      *
124      * - the calling contract must have an ETH balance of at least `value`.
125      * - the called Solidity function must be `payable`.
126      *
127      * _Available since v3.1._
128      */
129     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
130         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
131     }
132 
133     /**
134      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
135      * with `errorMessage` as a fallback revert reason when `target` reverts.
136      *
137      * _Available since v3.1._
138      */
139     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
140         require(address(this).balance >= value, "Address: insufficient balance for call");
141         return _functionCallWithValue(target, data, value, errorMessage);
142     }
143 
144     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
145         require(isContract(target), "Address: call to non-contract");
146 
147         // solhint-disable-next-line avoid-low-level-calls
148         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
149         if (success) {
150             return returndata;
151         } else {
152             // Look for revert reason and bubble it up if present
153             if (returndata.length > 0) {
154                 // The easiest way to bubble the revert reason is using memory via assembly
155 
156                 // solhint-disable-next-line no-inline-assembly
157                 assembly {
158                     let returndata_size := mload(returndata)
159                     revert(add(32, returndata), returndata_size)
160                 }
161             } else {
162                 revert(errorMessage);
163             }
164         }
165     }
166 }
167 
168 /**
169  * @dev Wrappers over Solidity's arithmetic operations with added overflow
170  * checks.
171  *
172  * Arithmetic operations in Solidity wrap on overflow. This can easily result
173  * in bugs, because programmers usually assume that an overflow raises an
174  * error, which is the standard behavior in high level programming languages.
175  * `SafeMath` restores this intuition by reverting the transaction when an
176  * operation overflows.
177  *
178  * Using this library instead of the unchecked operations eliminates an entire
179  * class of bugs, so it's recommended to use it always.
180  */
181 library SafeMath {
182     /**
183      * @dev Returns the addition of two unsigned integers, reverting on
184      * overflow.
185      *
186      * Counterpart to Solidity's `+` operator.
187      *
188      * Requirements:
189      *
190      * - Addition cannot overflow.
191      */
192     function add(uint256 a, uint256 b) internal pure returns (uint256) {
193         uint256 c = a + b;
194         require(c >= a, "SafeMath: addition overflow");
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the subtraction of two unsigned integers, reverting on
201      * overflow (when the result is negative).
202      *
203      * Counterpart to Solidity's `-` operator.
204      *
205      * Requirements:
206      *
207      * - Subtraction cannot overflow.
208      */
209     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
210         return sub(a, b, "SafeMath: subtraction overflow");
211     }
212 
213     /**
214      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
215      * overflow (when the result is negative).
216      *
217      * Counterpart to Solidity's `-` operator.
218      *
219      * Requirements:
220      *
221      * - Subtraction cannot overflow.
222      */
223     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
224         require(b <= a, errorMessage);
225         uint256 c = a - b;
226 
227         return c;
228     }
229 
230     /**
231      * @dev Returns the multiplication of two unsigned integers, reverting on
232      * overflow.
233      *
234      * Counterpart to Solidity's `*` operator.
235      *
236      * Requirements:
237      *
238      * - Multiplication cannot overflow.
239      */
240     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
241         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
242         // benefit is lost if 'b' is also tested.
243         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
244         if (a == 0) {
245             return 0;
246         }
247 
248         uint256 c = a * b;
249         require(c / a == b, "SafeMath: multiplication overflow");
250 
251         return c;
252     }
253 
254     /**
255      * @dev Returns the integer division of two unsigned integers. Reverts on
256      * division by zero. The result is rounded towards zero.
257      *
258      * Counterpart to Solidity's `/` operator. Note: this function uses a
259      * `revert` opcode (which leaves remaining gas untouched) while Solidity
260      * uses an invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      *
264      * - The divisor cannot be zero.
265      */
266     function div(uint256 a, uint256 b) internal pure returns (uint256) {
267         return div(a, b, "SafeMath: division by zero");
268     }
269 
270     /**
271      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
272      * division by zero. The result is rounded towards zero.
273      *
274      * Counterpart to Solidity's `/` operator. Note: this function uses a
275      * `revert` opcode (which leaves remaining gas untouched) while Solidity
276      * uses an invalid opcode to revert (consuming all remaining gas).
277      *
278      * Requirements:
279      *
280      * - The divisor cannot be zero.
281      */
282     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
283         require(b > 0, errorMessage);
284         uint256 c = a / b;
285         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
286 
287         return c;
288     }
289 
290     /**
291      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
292      * Reverts when dividing by zero.
293      *
294      * Counterpart to Solidity's `%` operator. This function uses a `revert`
295      * opcode (which leaves remaining gas untouched) while Solidity uses an
296      * invalid opcode to revert (consuming all remaining gas).
297      *
298      * Requirements:
299      *
300      * - The divisor cannot be zero.
301      */
302     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
303         return mod(a, b, "SafeMath: modulo by zero");
304     }
305 
306     /**
307      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
308      * Reverts with custom message when dividing by zero.
309      *
310      * Counterpart to Solidity's `%` operator. This function uses a `revert`
311      * opcode (which leaves remaining gas untouched) while Solidity uses an
312      * invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      *
316      * - The divisor cannot be zero.
317      */
318     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
319         require(b != 0, errorMessage);
320         return a % b;
321     }
322 }
323 
324 /**
325  * @dev Interface of the ERC20 standard as defined in the EIP.
326  */
327 interface IERC20 {
328     /**
329      * @dev Returns the amount of tokens in existence.
330      */
331     function totalSupply() external view returns (uint256);
332 
333     /**
334      * @dev Returns the amount of tokens owned by `account`.
335      */
336     function balanceOf(address account) external view returns (uint256);
337 
338     /**
339      * @dev Moves `amount` tokens from the caller's account to `recipient`.
340      *
341      * Returns a boolean value indicating whether the operation succeeded.
342      *
343      * Emits a {Transfer} event.
344      */
345     function transfer(address recipient, uint256 amount) external returns (bool);
346 
347     /**
348      * @dev Returns the remaining number of tokens that `spender` will be
349      * allowed to spend on behalf of `owner` through {transferFrom}. This is
350      * zero by default.
351      *
352      * This value changes when {approve} or {transferFrom} are called.
353      */
354     function allowance(address owner, address spender) external view returns (uint256);
355 
356     /**
357      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
358      *
359      * Returns a boolean value indicating whether the operation succeeded.
360      *
361      * IMPORTANT: Beware that changing an allowance with this method brings the risk
362      * that someone may use both the old and the new allowance by unfortunate
363      * transaction ordering. One possible solution to mitigate this race
364      * condition is to first reduce the spender's allowance to 0 and set the
365      * desired value afterwards:
366      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
367      *
368      * Emits an {Approval} event.
369      */
370     function approve(address spender, uint256 amount) external returns (bool);
371 
372     /**
373      * @dev Moves `amount` tokens from `sender` to `recipient` using the
374      * allowance mechanism. `amount` is then deducted from the caller's
375      * allowance.
376      *
377      * Returns a boolean value indicating whether the operation succeeded.
378      *
379      * Emits a {Transfer} event.
380      */
381     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
382 
383     /**
384      * @dev Emitted when `value` tokens are moved from one account (`from`) to
385      * another (`to`).
386      *
387      * Note that `value` may be zero.
388      */
389     event Transfer(address indexed from, address indexed to, uint256 value);
390 
391     /**
392      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
393      * a call to {approve}. `value` is the new allowance.
394      */
395     event Approval(address indexed owner, address indexed spender, uint256 value);
396 }
397 
398 /**
399  * @dev Implementation of the {IERC20} interface.
400  *
401  * This implementation is agnostic to the way tokens are created. This means
402  * that a supply mechanism has to be added in a derived contract using {_mint}.
403  * For a generic mechanism see {ERC20PresetMinterPauser}.
404  *
405  * TIP: For a detailed writeup see our guide
406  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
407  * to implement supply mechanisms].
408  *
409  * We have followed general OpenZeppelin guidelines: functions revert instead
410  * of returning `false` on failure. This behavior is nonetheless conventional
411  * and does not conflict with the expectations of ERC20 applications.
412  *
413  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
414  * This allows applications to reconstruct the allowance for all accounts just
415  * by listening to said events. Other implementations of the EIP may not emit
416  * these events, as it isn't required by the specification.
417  *
418  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
419  * functions have been added to mitigate the well-known issues around setting
420  * allowances. See {IERC20-approve}.
421  */
422 contract ERC20 is Context, IERC20 {
423     using SafeMath for uint256;
424     using Address for address;
425 
426     mapping (address => uint256) private _balances;
427 
428     mapping (address => mapping (address => uint256)) private _allowances;
429 
430     uint256 private _totalSupply;
431 
432     string private _name;
433     string private _symbol;
434     uint8 private _decimals;
435 
436     /**
437      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
438      * a default value of 18.
439      *
440      * To select a different value for {decimals}, use {_setupDecimals}.
441      *
442      * All three of these values are immutable: they can only be set once during
443      * construction.
444      */
445     constructor (string memory name, string memory symbol) public {
446         _name = name;
447         _symbol = symbol;
448         _decimals = 18;
449     }
450 
451     /**
452      * @dev Returns the name of the token.
453      */
454     function name() public view returns (string memory) {
455         return _name;
456     }
457 
458     /**
459      * @dev Returns the symbol of the token, usually a shorter version of the
460      * name.
461      */
462     function symbol() public view returns (string memory) {
463         return _symbol;
464     }
465 
466     /**
467      * @dev Returns the number of decimals used to get its user representation.
468      * For example, if `decimals` equals `2`, a balance of `505` tokens should
469      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
470      *
471      * Tokens usually opt for a value of 18, imitating the relationship between
472      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
473      * called.
474      *
475      * NOTE: This information is only used for _display_ purposes: it in
476      * no way affects any of the arithmetic of the contract, including
477      * {IERC20-balanceOf} and {IERC20-transfer}.
478      */
479     function decimals() public view returns (uint8) {
480         return _decimals;
481     }
482 
483     /**
484      * @dev See {IERC20-totalSupply}.
485      */
486     function totalSupply() public view override returns (uint256) {
487         return _totalSupply;
488     }
489 
490     /**
491      * @dev See {IERC20-balanceOf}.
492      */
493     function balanceOf(address account) public view override returns (uint256) {
494         return _balances[account];
495     }
496 
497     /**
498      * @dev See {IERC20-transfer}.
499      *
500      * Requirements:
501      *
502      * - `recipient` cannot be the zero address.
503      * - the caller must have a balance of at least `amount`.
504      */
505     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
506         _transfer(_msgSender(), recipient, amount);
507         return true;
508     }
509 
510     /**
511      * @dev See {IERC20-allowance}.
512      */
513     function allowance(address owner, address spender) public view virtual override returns (uint256) {
514         return _allowances[owner][spender];
515     }
516 
517     /**
518      * @dev See {IERC20-approve}.
519      *
520      * Requirements:
521      *
522      * - `spender` cannot be the zero address.
523      */
524     function approve(address spender, uint256 amount) public virtual override returns (bool) {
525         _approve(_msgSender(), spender, amount);
526         return true;
527     }
528 
529     /**
530      * @dev See {IERC20-transferFrom}.
531      *
532      * Emits an {Approval} event indicating the updated allowance. This is not
533      * required by the EIP. See the note at the beginning of {ERC20};
534      *
535      * Requirements:
536      * - `sender` and `recipient` cannot be the zero address.
537      * - `sender` must have a balance of at least `amount`.
538      * - the caller must have allowance for ``sender``'s tokens of at least
539      * `amount`.
540      */
541     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
542         _transfer(sender, recipient, amount);
543         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
544         return true;
545     }
546 
547     /**
548      * @dev Atomically increases the allowance granted to `spender` by the caller.
549      *
550      * This is an alternative to {approve} that can be used as a mitigation for
551      * problems described in {IERC20-approve}.
552      *
553      * Emits an {Approval} event indicating the updated allowance.
554      *
555      * Requirements:
556      *
557      * - `spender` cannot be the zero address.
558      */
559     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
560         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
561         return true;
562     }
563 
564     /**
565      * @dev Atomically decreases the allowance granted to `spender` by the caller.
566      *
567      * This is an alternative to {approve} that can be used as a mitigation for
568      * problems described in {IERC20-approve}.
569      *
570      * Emits an {Approval} event indicating the updated allowance.
571      *
572      * Requirements:
573      *
574      * - `spender` cannot be the zero address.
575      * - `spender` must have allowance for the caller of at least
576      * `subtractedValue`.
577      */
578     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
579         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
580         return true;
581     }
582 
583     /**
584      * @dev Moves tokens `amount` from `sender` to `recipient`.
585      *
586      * This is internal function is equivalent to {transfer}, and can be used to
587      * e.g. implement automatic token fees, slashing mechanisms, etc.
588      *
589      * Emits a {Transfer} event.
590      *
591      * Requirements:
592      *
593      * - `sender` cannot be the zero address.
594      * - `recipient` cannot be the zero address.
595      * - `sender` must have a balance of at least `amount`.
596      */
597     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
598         require(sender != address(0), "ERC20: transfer from the zero address");
599         require(recipient != address(0), "ERC20: transfer to the zero address");
600 
601         _beforeTokenTransfer(sender, recipient, amount);
602 
603         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
604         _balances[recipient] = _balances[recipient].add(amount);
605         emit Transfer(sender, recipient, amount);
606     }
607 
608     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
609      * the total supply.
610      *
611      * Emits a {Transfer} event with `from` set to the zero address.
612      *
613      * Requirements
614      *
615      * - `to` cannot be the zero address.
616      */
617     function _mint(address account, uint256 amount) internal virtual {
618         require(account != address(0), "ERC20: mint to the zero address");
619 
620         _beforeTokenTransfer(address(0), account, amount);
621 
622         _totalSupply = _totalSupply.add(amount);
623         _balances[account] = _balances[account].add(amount);
624         emit Transfer(address(0), account, amount);
625     }
626 
627     /**
628      * @dev Destroys `amount` tokens from `account`, reducing the
629      * total supply.
630      *
631      * Emits a {Transfer} event with `to` set to the zero address.
632      *
633      * Requirements
634      *
635      * - `account` cannot be the zero address.
636      * - `account` must have at least `amount` tokens.
637      */
638     function _burn(address account, uint256 amount) internal virtual {
639         require(account != address(0), "ERC20: burn from the zero address");
640 
641         _beforeTokenTransfer(account, address(0), amount);
642 
643         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
644         _totalSupply = _totalSupply.sub(amount);
645         emit Transfer(account, address(0), amount);
646     }
647 
648     /**
649      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
650      *
651      * This is internal function is equivalent to `approve`, and can be used to
652      * e.g. set automatic allowances for certain subsystems, etc.
653      *
654      * Emits an {Approval} event.
655      *
656      * Requirements:
657      *
658      * - `owner` cannot be the zero address.
659      * - `spender` cannot be the zero address.
660      */
661     function _approve(address owner, address spender, uint256 amount) internal virtual {
662         require(owner != address(0), "ERC20: approve from the zero address");
663         require(spender != address(0), "ERC20: approve to the zero address");
664 
665         _allowances[owner][spender] = amount;
666         emit Approval(owner, spender, amount);
667     }
668 
669     /**
670      * @dev Sets {decimals} to a value other than the default one of 18.
671      *
672      * WARNING: This function should only be called from the constructor. Most
673      * applications that interact with token contracts will not expect
674      * {decimals} to ever change, and may work incorrectly if it does.
675      */
676     function _setupDecimals(uint8 decimals_) internal {
677         _decimals = decimals_;
678     }
679 
680     /**
681      * @dev Hook that is called before any transfer of tokens. This includes
682      * minting and burning.
683      *
684      * Calling conditions:
685      *
686      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
687      * will be to transferred to `to`.
688      * - when `from` is zero, `amount` tokens will be minted for `to`.
689      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
690      * - `from` and `to` are never both zero.
691      *
692      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
693      */
694     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
695 }
696 
697 contract ERC20Minter is Context, ERC20 {
698     address public current_minter = address(0);
699 
700     modifier onlyMinter() {
701         require(current_minter == _msgSender(), "onlyMinter: caller is not the minter");
702         _;
703     }
704 
705     constructor(string memory name, string memory symbol, uint8 decimals, address minter) public ERC20(name, symbol) {
706         require(minter != address(0), "ERROR: Zero address");
707         _setupDecimals(decimals);
708         current_minter = minter;
709     }
710 
711     function mint(address to, uint256 amount) external onlyMinter {
712         _mint(to, amount);
713     }
714 
715     function burn(uint256 amount) external onlyMinter {
716         _burn(_msgSender(), amount);
717     }
718 
719     function replaceMinter(address newMinter) external onlyMinter {
720         current_minter = newMinter;
721     }
722 
723     function _transfer(address sender, address recipient, uint256 amount) internal virtual override(ERC20) {
724         super._transfer(sender, recipient, amount);
725         if (_msgSender() != current_minter && recipient == current_minter) {
726             _burn(recipient, amount);
727         }
728     }
729 
730     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20) {
731         super._beforeTokenTransfer(from, to, amount);
732     }
733 }