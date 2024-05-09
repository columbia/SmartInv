1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-19
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.7.0;
8 
9 /** 
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
30 
31 /**
32  * @dev Interface of the ERC20 standard as defined in the EIP.
33  */
34 interface IERC20 {
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 /**
106  * @dev Wrappers over Solidity's arithmetic operations with added overflow
107  * checks.
108  *
109  * Arithmetic operations in Solidity wrap on overflow. This can easily result
110  * in bugs, because programmers usually assume that an overflow raises an
111  * error, which is the standard behavior in high level programming languages.
112  * `SafeMath` restores this intuition by reverting the transaction when an
113  * operation overflows.
114  *
115  * Using this library instead of the unchecked operations eliminates an entire
116  * class of bugs, so it's recommended to use it always.
117  */
118 library SafeMath {
119     /**
120      * @dev Returns the addition of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `+` operator.
124      *
125      * Requirements:
126      *
127      * - Addition cannot overflow.
128      */
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, "SafeMath: addition overflow");
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      *
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         return sub(a, b, "SafeMath: subtraction overflow");
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      *
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b <= a, errorMessage);
162         uint256 c = a - b;
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `*` operator.
172      *
173      * Requirements:
174      *
175      * - Multiplication cannot overflow.
176      */
177     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
179         // benefit is lost if 'b' is also tested.
180         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
181         if (a == 0) {
182             return 0;
183         }
184 
185         uint256 c = a * b;
186         require(c / a == b, "SafeMath: multiplication overflow");
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         return div(a, b, "SafeMath: division by zero");
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220         require(b > 0, errorMessage);
221         uint256 c = a / b;
222         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * Reverts when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
240         return mod(a, b, "SafeMath: modulo by zero");
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts with custom message when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256         require(b != 0, errorMessage);
257         return a % b;
258     }
259 }
260 
261 
262 /**
263  * @dev Collection of functions related to the address type
264  */
265 library Address {
266     /**
267      * @dev Returns true if `account` is a contract.
268      *
269      * [IMPORTANT]
270      * ====
271      * It is unsafe to assume that an address for which this function returns
272      * false is an externally-owned account (EOA) and not a contract.
273      *
274      * Among others, `isContract` will return false for the following
275      * types of addresses:
276      *
277      *  - an externally-owned account
278      *  - a contract in construction
279      *  - an address where a contract will be created
280      *  - an address where a contract lived, but was destroyed
281      * ====
282      */
283     function isContract(address account) internal view returns (bool) {
284         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
285         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
286         // for accounts without code, i.e. `keccak256('')`
287         bytes32 codehash;
288         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
289         // solhint-disable-next-line no-inline-assembly
290         assembly { codehash := extcodehash(account) }
291         return (codehash != accountHash && codehash != 0x0);
292     }
293 
294     /**
295      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
296      * `recipient`, forwarding all available gas and reverting on errors.
297      *
298      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
299      * of certain opcodes, possibly making contracts go over the 2300 gas limit
300      * imposed by `transfer`, making them unable to receive funds via
301      * `transfer`. {sendValue} removes this limitation.
302      *
303      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
304      *
305      * IMPORTANT: because control is transferred to `recipient`, care must be
306      * taken to not create reentrancy vulnerabilities. Consider using
307      * {ReentrancyGuard} or the
308      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
309      */
310     function sendValue(address payable recipient, uint256 amount) internal {
311         require(address(this).balance >= amount, "Address: insufficient balance");
312 
313         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
314         (bool success, ) = recipient.call{ value: amount }("");
315         require(success, "Address: unable to send value, recipient may have reverted");
316     }
317 
318     /**
319      * @dev Performs a Solidity function call using a low level `call`. A
320      * plain`call` is an unsafe replacement for a function call: use this
321      * function instead.
322      *
323      * If `target` reverts with a revert reason, it is bubbled up by this
324      * function (like regular Solidity function calls).
325      *
326      * Returns the raw returned data. To convert to the expected return value,
327      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
328      *
329      * Requirements:
330      *
331      * - `target` must be a contract.
332      * - calling `target` with `data` must not revert.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
337       return functionCall(target, data, "Address: low-level call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
342      * `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
347         return _functionCallWithValue(target, data, 0, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but also transferring `value` wei to `target`.
353      *
354      * Requirements:
355      *
356      * - the calling contract must have an ETH balance of at least `value`.
357      * - the called Solidity function must be `payable`.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
367      * with `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
372         require(address(this).balance >= value, "Address: insufficient balance for call");
373         return _functionCallWithValue(target, data, value, errorMessage);
374     }
375 
376     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
377         require(isContract(target), "Address: call to non-contract");
378 
379         // solhint-disable-next-line avoid-low-level-calls
380         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
381         if (success) {
382             return returndata;
383         } else {
384             // Look for revert reason and bubble it up if present
385             if (returndata.length > 0) {
386                 // The easiest way to bubble the revert reason is using memory via assembly
387 
388                 // solhint-disable-next-line no-inline-assembly
389                 assembly {
390                     let returndata_size := mload(returndata)
391                     revert(add(32, returndata), returndata_size)
392                 }
393             } else {
394                 revert(errorMessage);
395             }
396         }
397     }
398 }
399 
400 /**
401  * @dev Implementation of the {IERC20} interface.
402  *
403  * This implementation is agnostic to the way tokens are created. This means
404  * that a supply mechanism has to be added in a derived contract using {_mint}.
405  * For a generic mechanism see {ERC20PresetMinterPauser}.
406  *
407  * TIP: For a detailed writeup see our guide
408  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
409  * to implement supply mechanisms].
410  *
411  * We have followed general OpenZeppelin guidelines: functions revert instead
412  * of returning `false` on failure. This behavior is nonetheless conventional
413  * and does not conflict with the expectations of ERC20 applications.
414  *
415  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
416  * This allows applications to reconstruct the allowance for all accounts just
417  * by listening to said events. Other implementations of the EIP may not emit
418  * these events, as it isn't required by the specification.
419  *
420  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
421  * functions have been added to mitigate the well-known issues around setting
422  * allowances. See {IERC20-approve}.
423  */
424 contract ERC20 is Context, IERC20 {
425     using SafeMath for uint256;
426     using Address for address;
427 
428     mapping (address => uint256) private _balances;
429 
430     mapping (address => mapping (address => uint256)) private _allowances;
431 
432     uint256 private _totalSupply;
433 
434     string private _name;
435     string private _symbol;
436     uint8 private _decimals;
437 
438     /**
439      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
440      * a default value of 18.
441      *
442      * To select a different value for {decimals}, use {_setupDecimals}.
443      *
444      * All three of these values are immutable: they can only be set once during
445      * construction.
446      */
447     constructor (string memory name, string memory symbol) {
448         _name = name;
449         _symbol = symbol;
450         _decimals = 18;
451     }
452 
453     /**
454      * @dev Returns the name of the token.
455      */
456     function name() public view returns (string memory) {
457         return _name;
458     }
459 
460     /**
461      * @dev Returns the symbol of the token, usually a shorter version of the
462      * name.
463      */
464     function symbol() public view returns (string memory) {
465         return _symbol;
466     }
467 
468     /**
469      * @dev Returns the number of decimals used to get its user representation.
470      * For example, if `decimals` equals `2`, a balance of `505` tokens should
471      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
472      *
473      * Tokens usually opt for a value of 18, imitating the relationship between
474      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
475      * called.
476      *
477      * NOTE: This information is only used for _display_ purposes: it in
478      * no way affects any of the arithmetic of the contract, including
479      * {IERC20-balanceOf} and {IERC20-transfer}.
480      */
481     function decimals() public view returns (uint8) {
482         return _decimals;
483     }
484 
485     /**
486      * @dev See {IERC20-totalSupply}.
487      */
488     function totalSupply() public view override returns (uint256) {
489         return _totalSupply;
490     }
491 
492     /**
493      * @dev See {IERC20-balanceOf}.
494      */
495     function balanceOf(address account) public view override returns (uint256) {
496         return _balances[account];
497     }
498 
499     /**
500      * @dev See {IERC20-transfer}.
501      *
502      * Requirements:
503      *
504      * - `recipient` cannot be the zero address.
505      * - the caller must have a balance of at least `amount`.
506      */
507     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
508         _transfer(_msgSender(), recipient, amount);
509         return true;
510     }
511 
512     /**
513      * @dev See {IERC20-allowance}.
514      */
515     function allowance(address owner, address spender) public view virtual override returns (uint256) {
516         return _allowances[owner][spender];
517     }
518 
519     /**
520      * @dev See {IERC20-approve}.
521      *
522      * Requirements:
523      *
524      * - `spender` cannot be the zero address.
525      */
526     function approve(address spender, uint256 amount) public virtual override returns (bool) {
527         _approve(_msgSender(), spender, amount);
528         return true;
529     }
530 
531     /**
532      * @dev See {IERC20-transferFrom}.
533      *
534      * Emits an {Approval} event indicating the updated allowance. This is not
535      * required by the EIP. See the note at the beginning of {ERC20};
536      *
537      * Requirements:
538      * - `sender` and `recipient` cannot be the zero address.
539      * - `sender` must have a balance of at least `amount`.
540      * - the caller must have allowance for ``sender``'s tokens of at least
541      * `amount`.
542      */
543     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
544         _transfer(sender, recipient, amount);
545         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
546         return true;
547     }
548 
549     /**
550      * @dev Atomically increases the allowance granted to `spender` by the caller.
551      *
552      * This is an alternative to {approve} that can be used as a mitigation for
553      * problems described in {IERC20-approve}.
554      *
555      * Emits an {Approval} event indicating the updated allowance.
556      *
557      * Requirements:
558      *
559      * - `spender` cannot be the zero address.
560      */
561     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
562         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
563         return true;
564     }
565 
566     /**
567      * @dev Atomically decreases the allowance granted to `spender` by the caller.
568      *
569      * This is an alternative to {approve} that can be used as a mitigation for
570      * problems described in {IERC20-approve}.
571      *
572      * Emits an {Approval} event indicating the updated allowance.
573      *
574      * Requirements:
575      *
576      * - `spender` cannot be the zero address.
577      * - `spender` must have allowance for the caller of at least
578      * `subtractedValue`.
579      */
580     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
581         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
582         return true;
583     }
584 
585     /**
586      * @dev Moves tokens `amount` from `sender` to `recipient`.
587      *
588      * This is internal function is equivalent to {transfer}, and can be used to
589      * e.g. implement automatic token fees, slashing mechanisms, etc.
590      *
591      * Emits a {Transfer} event.
592      *
593      * Requirements:
594      *
595      * - `sender` cannot be the zero address.
596      * - `recipient` cannot be the zero address.
597      * - `sender` must have a balance of at least `amount`.
598      */
599     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
600         require(sender != address(0), "ERC20: transfer from the zero address");
601         require(recipient != address(0), "ERC20: transfer to the zero address");
602 
603         _beforeTokenTransfer(sender, recipient, amount);
604 
605         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
606         _balances[recipient] = _balances[recipient].add(amount);
607         emit Transfer(sender, recipient, amount);
608     }
609 
610     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
611      * the total supply.
612      *
613      * Emits a {Transfer} event with `from` set to the zero address.
614      *
615      * Requirements
616      *
617      * - `to` cannot be the zero address.
618      */
619     function _mint(address account, uint256 amount) internal virtual {
620         require(account != address(0), "ERC20: mint to the zero address");
621 
622         _beforeTokenTransfer(address(0), account, amount);
623 
624         _totalSupply = _totalSupply.add(amount);
625         _balances[account] = _balances[account].add(amount);
626         emit Transfer(address(0), account, amount);
627     }
628 
629     /**
630      * @dev Destroys `amount` tokens from `account`, reducing the
631      * total supply.
632      *
633      * Emits a {Transfer} event with `to` set to the zero address.
634      *
635      * Requirements
636      *
637      * - `account` cannot be the zero address.
638      * - `account` must have at least `amount` tokens.
639      */
640     function _burn(address account, uint256 amount) internal virtual {
641         require(account != address(0), "ERC20: burn from the zero address");
642 
643         _beforeTokenTransfer(account, address(0), amount);
644 
645         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
646         _totalSupply = _totalSupply.sub(amount);
647         emit Transfer(account, address(0), amount);
648     }
649 
650     /**
651      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
652      *
653      * This internal function is equivalent to `approve`, and can be used to
654      * e.g. set automatic allowances for certain subsystems, etc.
655      *
656      * Emits an {Approval} event.
657      *
658      * Requirements:
659      *
660      * - `owner` cannot be the zero address.
661      * - `spender` cannot be the zero address.
662      */
663     function _approve(address owner, address spender, uint256 amount) internal virtual {
664         require(owner != address(0), "ERC20: approve from the zero address");
665         require(spender != address(0), "ERC20: approve to the zero address");
666 
667         _allowances[owner][spender] = amount;
668         emit Approval(owner, spender, amount);
669     }
670 
671     /**
672      * @dev Sets {decimals} to a value other than the default one of 18.
673      *
674      * WARNING: This function should only be called from the constructor. Most
675      * applications that interact with token contracts will not expect
676      * {decimals} to ever change, and may work incorrectly if it does.
677      */
678     function _setupDecimals(uint8 decimals_) internal {
679         _decimals = decimals_;
680     }
681 
682     /**
683      * @dev Hook that is called before any transfer of tokens. This includes
684      * minting and burning.
685      *
686      * Calling conditions:
687      *
688      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
689      * will be to transferred to `to`.
690      * - when `from` is zero, `amount` tokens will be minted for `to`.
691      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
692      * - `from` and `to` are never both zero.
693      *
694      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
695      */
696     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
697 }
698 
699 
700 /**
701  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
702  */
703 abstract contract ERC20Capped is ERC20 {
704     using SafeMath for uint256;
705 
706     uint256 private _cap;
707 
708     /**
709      * @dev Sets the value of the `cap`. This value is immutable, it can only be
710      * set once during construction.
711      */
712     constructor (uint256 cap) {
713         require(cap > 0, "ERC20Capped: cap is 0");
714         _cap = cap;
715     }
716 
717     /**
718      * @dev Returns the cap on the token's total supply.
719      */
720     function cap() public view returns (uint256) {
721         return _cap;
722     }
723 
724     /**
725      * @dev See {ERC20-_beforeTokenTransfer}.
726      *
727      * Requirements:
728      *
729      * - minted tokens must not cause the total supply to go over the cap.
730      */
731     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
732         super._beforeTokenTransfer(from, to, amount);
733 
734         if (from == address(0)) { // When minting tokens
735             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
736         }
737     }
738 }
739 
740 
741 /**
742  * @dev Extension of {ERC20} that allows token holders to destroy both their own
743  * tokens and those that they have an allowance for, in a way that can be
744  * recognized off-chain (via event analysis).
745  */
746 abstract contract ERC20Burnable is Context, ERC20 {
747     using SafeMath for uint256;
748 
749     /**
750      * @dev Destroys `amount` tokens from the caller.
751      *
752      * See {ERC20-_burn}.
753      */
754     function burn(uint256 amount) public virtual{
755         _burn(_msgSender(), amount);
756     }
757 
758     /**
759      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
760      * allowance.
761      *
762      * See {ERC20-_burn} and {ERC20-allowance}.
763      *
764      * Requirements:
765      *
766      * - the caller must have allowance for ``accounts``'s tokens of at least
767      * `amount`.
768      */
769     function burnFrom(address account, uint256 amount) public virtual{
770         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
771 
772         _approve(account, _msgSender(), decreasedAllowance);
773         _burn(account, amount);
774     }
775 }
776 
777 
778 /**
779  * @dev Interface of the ERC165 standard, as defined in the
780  * https://eips.ethereum.org/EIPS/eip-165[EIP].
781  *
782  * Implementers can declare support of contract interfaces, which can then be
783  * queried by others ({ERC165Checker}).
784  *
785  * For an implementation, see {ERC165}.
786  */
787 interface IERC165 {
788     /**
789      * @dev Returns true if this contract implements the interface defined by
790      * `interfaceId`. See the corresponding
791      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
792      * to learn more about how these ids are created.
793      *
794      * This function call must use less than 30 000 gas.
795      */
796     function supportsInterface(bytes4 interfaceId) external view returns (bool);
797 }
798 
799 
800 pragma solidity ^0.7.0;
801 
802 /**
803  * @title IERC1363 Interface
804  * @author Vittorio Minacori (https://github.com/vittominacori)
805  * @dev Interface for a Payable Token contract as defined in
806  *  https://eips.ethereum.org/EIPS/eip-1363
807  */
808 interface IERC1363 is IERC20, IERC165 {
809     /*
810      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
811      * 0x4bbee2df ===
812      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
813      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
814      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
815      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
816      */
817 
818     /*
819      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
820      * 0xfb9ec8ce ===
821      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
822      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
823      */
824 
825     /**
826      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
827      * @param to address The address which you want to transfer to
828      * @param value uint256 The amount of tokens to be transferred
829      * @return true unless throwing
830      */
831     function transferAndCall(address to, uint256 value) external returns (bool);
832 
833     /**
834      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
835      * @param to address The address which you want to transfer to
836      * @param value uint256 The amount of tokens to be transferred
837      * @param data bytes Additional data with no specified format, sent in call to `to`
838      * @return true unless throwing
839      */
840     function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool);
841 
842     /**
843      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
844      * @param from address The address which you want to send tokens from
845      * @param to address The address which you want to transfer to
846      * @param value uint256 The amount of tokens to be transferred
847      * @return true unless throwing
848      */
849     function transferFromAndCall(address from, address to, uint256 value) external returns (bool);
850 
851     /**
852      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
853      * @param from address The address which you want to send tokens from
854      * @param to address The address which you want to transfer to
855      * @param value uint256 The amount of tokens to be transferred
856      * @param data bytes Additional data with no specified format, sent in call to `to`
857      * @return true unless throwing
858      */
859     function transferFromAndCall(address from, address to, uint256 value, bytes calldata data) external returns (bool);
860 
861     /**
862      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
863      * and then call `onApprovalReceived` on spender.
864      * Beware that changing an allowance with this method brings the risk that someone may use both the old
865      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
866      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
867      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
868      * @param spender address The address which will spend the funds
869      * @param value uint256 The amount of tokens to be spent
870      */
871     function approveAndCall(address spender, uint256 value) external returns (bool);
872 
873     /**
874      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
875      * and then call `onApprovalReceived` on spender.
876      * Beware that changing an allowance with this method brings the risk that someone may use both the old
877      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
878      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
879      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
880      * @param spender address The address which will spend the funds
881      * @param value uint256 The amount of tokens to be spent
882      * @param data bytes Additional data with no specified format, sent in call to `spender`
883      */
884     function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
885 }
886 
887 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
888 
889 pragma solidity ^0.7.0;
890 
891 /**
892  * @title IERC1363Receiver Interface
893  * @author Vittorio Minacori (https://github.com/vittominacori)
894  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
895  *  from ERC1363 token contracts as defined in
896  *  https://eips.ethereum.org/EIPS/eip-1363
897  */
898 interface IERC1363Receiver {
899     /*
900      * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
901      * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
902      */
903 
904     /**
905      * @notice Handle the receipt of ERC1363 tokens
906      * @dev Any ERC1363 smart contract calls this function on the recipient
907      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
908      * transfer. Return of other than the magic value MUST result in the
909      * transaction being reverted.
910      * Note: the token contract address is always the message sender.
911      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
912      * @param from address The address which are token transferred from
913      * @param value uint256 The amount of tokens transferred
914      * @param data bytes Additional data with no specified format
915      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
916      *  unless throwing
917      */
918     function onTransferReceived(address operator, address from, uint256 value, bytes calldata data) external returns (bytes4); // solhint-disable-line  max-line-length
919 }
920 
921 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
922 
923 pragma solidity ^0.7.0;
924 
925 /**
926  * @title IERC1363Spender Interface
927  * @author Vittorio Minacori (https://github.com/vittominacori)
928  * @dev Interface for any contract that wants to support approveAndCall
929  *  from ERC1363 token contracts as defined in
930  *  https://eips.ethereum.org/EIPS/eip-1363
931  */
932 interface IERC1363Spender {
933     /*
934      * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
935      * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
936      */
937 
938     /**
939      * @notice Handle the approval of ERC1363 tokens
940      * @dev Any ERC1363 smart contract calls this function on the recipient
941      * after an `approve`. This function MAY throw to revert and reject the
942      * approval. Return of other than the magic value MUST result in the
943      * transaction being reverted.
944      * Note: the token contract address is always the message sender.
945      * @param owner address The address which called `approveAndCall` function
946      * @param value uint256 The amount of tokens to be spent
947      * @param data bytes Additional data with no specified format
948      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
949      *  unless throwing
950      */
951     function onApprovalReceived(address owner, uint256 value, bytes calldata data) external returns (bytes4);
952 }
953 
954 // File: @openzeppelin/contracts/introspection/ERC165Checker.sol
955 
956 pragma solidity ^0.7.0;
957 
958 /**
959  * @dev Library used to query support of an interface declared via {IERC165}.
960  *
961  * Note that these functions return the actual result of the query: they do not
962  * `revert` if an interface is not supported. It is up to the caller to decide
963  * what to do in these cases.
964  */
965 library ERC165Checker {
966     // As per the EIP-165 spec, no interface should ever match 0xffffffff
967     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
968 
969     /*
970      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
971      */
972     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
973 
974     /**
975      * @dev Returns true if `account` supports the {IERC165} interface,
976      */
977     function supportsERC165(address account) internal view returns (bool) {
978         // Any contract that implements ERC165 must explicitly indicate support of
979         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
980         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
981             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
982     }
983 
984     /**
985      * @dev Returns true if `account` supports the interface defined by
986      * `interfaceId`. Support for {IERC165} itself is queried automatically.
987      *
988      * See {IERC165-supportsInterface}.
989      */
990     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
991         // query support of both ERC165 as per the spec and support of _interfaceId
992         return supportsERC165(account) &&
993             _supportsERC165Interface(account, interfaceId);
994     }
995 
996     /**
997      * @dev Returns true if `account` supports all the interfaces defined in
998      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
999      *
1000      * Batch-querying can lead to gas savings by skipping repeated checks for
1001      * {IERC165} support.
1002      *
1003      * See {IERC165-supportsInterface}.
1004      */
1005     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
1006         // query support of ERC165 itself
1007         if (!supportsERC165(account)) {
1008             return false;
1009         }
1010 
1011         // query support of each interface in _interfaceIds
1012         for (uint256 i = 0; i < interfaceIds.length; i++) {
1013             if (!_supportsERC165Interface(account, interfaceIds[i])) {
1014                 return false;
1015             }
1016         }
1017 
1018         // all interfaces supported
1019         return true;
1020     }
1021 
1022     /**
1023      * @notice Query if a contract implements an interface, does not check ERC165 support
1024      * @param account The address of the contract to query for support of an interface
1025      * @param interfaceId The interface identifier, as specified in ERC-165
1026      * @return true if the contract at account indicates support of the interface with
1027      * identifier interfaceId, false otherwise
1028      * @dev Assumes that account contains a contract that supports ERC165, otherwise
1029      * the behavior of this method is undefined. This precondition can be checked
1030      * with {supportsERC165}.
1031      * Interface identification is specified in ERC-165.
1032      */
1033     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
1034         // success determines whether the staticcall succeeded and result determines
1035         // whether the contract at account indicates support of _interfaceId
1036         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
1037 
1038         return (success && result);
1039     }
1040 
1041     /**
1042      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
1043      * @param account The address of the contract to query for support of an interface
1044      * @param interfaceId The interface identifier, as specified in ERC-165
1045      * @return success true if the STATICCALL succeeded, false otherwise
1046      * @return result true if the STATICCALL succeeded and the contract at account
1047      * indicates support of the interface with identifier interfaceId, false otherwise
1048      */
1049     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
1050         private
1051         view
1052         returns (bool, bool)
1053     {
1054         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
1055         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
1056         if (result.length < 32) return (false, false);
1057         return (success, abi.decode(result, (bool)));
1058     }
1059 }
1060 
1061 // File: @openzeppelin/contracts/introspection/ERC165.sol
1062 
1063 pragma solidity ^0.7.0;
1064 
1065 /**
1066  * @dev Implementation of the {IERC165} interface.
1067  *
1068  * Contracts may inherit from this and call {_registerInterface} to declare
1069  * their support of an interface.
1070  */
1071 contract ERC165 is IERC165 {
1072     /*
1073      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1074      */
1075     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1076 
1077     /**
1078      * @dev Mapping of interface ids to whether or not it's supported.
1079      */
1080     mapping(bytes4 => bool) private _supportedInterfaces;
1081 
1082     constructor () {
1083         // Derived contracts need only register support for their own interfaces,
1084         // we register support for ERC165 itself here
1085         _registerInterface(_INTERFACE_ID_ERC165);
1086     }
1087 
1088     /**
1089      * @dev See {IERC165-supportsInterface}.
1090      *
1091      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1092      */
1093     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1094         return _supportedInterfaces[interfaceId];
1095     }
1096 
1097     /**
1098      * @dev Registers the contract as an implementer of the interface defined by
1099      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1100      * registering its interface id is not required.
1101      *
1102      * See {IERC165-supportsInterface}.
1103      *
1104      * Requirements:
1105      *
1106      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1107      */
1108     function _registerInterface(bytes4 interfaceId) internal virtual {
1109         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1110         _supportedInterfaces[interfaceId] = true;
1111     }
1112 }
1113 
1114 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
1115 
1116 pragma solidity ^0.7.0;
1117 
1118 /**
1119  * @title ERC1363
1120  * @author Vittorio Minacori (https://github.com/vittominacori)
1121  * @dev Implementation of an ERC1363 interface
1122  */
1123 contract ERC1363 is ERC20, IERC1363, ERC165 {
1124     using Address for address;
1125 
1126     /*
1127      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
1128      * 0x4bbee2df ===
1129      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
1130      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
1131      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
1132      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
1133      */
1134     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
1135 
1136     /*
1137      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
1138      * 0xfb9ec8ce ===
1139      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
1140      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
1141      */
1142     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
1143 
1144     // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
1145     // which can be also obtained as `IERC1363Receiver(0).onTransferReceived.selector`
1146     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
1147 
1148     // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
1149     // which can be also obtained as `IERC1363Spender(0).onApprovalReceived.selector`
1150     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
1151 
1152     /**
1153      * @param name Name of the token
1154      * @param symbol A symbol to be used as ticker
1155      */
1156     constructor (string memory name, string memory symbol) ERC20(name, symbol) {
1157         // register the supported interfaces to conform to ERC1363 via ERC165
1158         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
1159         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
1160     }
1161 
1162     /**
1163      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1164      * @param to The address to transfer to.
1165      * @param value The amount to be transferred.
1166      * @return A boolean that indicates if the operation was successful.
1167      */
1168     function transferAndCall(address to, uint256 value) public override returns (bool) {
1169         return transferAndCall(to, value, "");
1170     }
1171 
1172     /**
1173      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1174      * @param to The address to transfer to
1175      * @param value The amount to be transferred
1176      * @param data Additional data with no specified format
1177      * @return A boolean that indicates if the operation was successful.
1178      */
1179     function transferAndCall(address to, uint256 value, bytes memory data) public override returns (bool) {
1180         transfer(to, value);
1181         require(_checkAndCallTransfer(_msgSender(), to, value, data), "ERC1363: _checkAndCallTransfer reverts");
1182         return true;
1183     }
1184 
1185     /**
1186      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1187      * @param from The address which you want to send tokens from
1188      * @param to The address which you want to transfer to
1189      * @param value The amount of tokens to be transferred
1190      * @return A boolean that indicates if the operation was successful.
1191      */
1192     function transferFromAndCall(address from, address to, uint256 value) public override returns (bool) {
1193         return transferFromAndCall(from, to, value, "");
1194     }
1195 
1196     /**
1197      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1198      * @param from The address which you want to send tokens from
1199      * @param to The address which you want to transfer to
1200      * @param value The amount of tokens to be transferred
1201      * @param data Additional data with no specified format
1202      * @return A boolean that indicates if the operation was successful.
1203      */
1204     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public override returns (bool) {
1205         transferFrom(from, to, value);
1206         require(_checkAndCallTransfer(from, to, value, data), "ERC1363: _checkAndCallTransfer reverts");
1207         return true;
1208     }
1209 
1210     /**
1211      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1212      * @param spender The address allowed to transfer to
1213      * @param value The amount allowed to be transferred
1214      * @return A boolean that indicates if the operation was successful.
1215      */
1216     function approveAndCall(address spender, uint256 value) public override returns (bool) {
1217         return approveAndCall(spender, value, "");
1218     }
1219 
1220     /**
1221      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1222      * @param spender The address allowed to transfer to.
1223      * @param value The amount allowed to be transferred.
1224      * @param data Additional data with no specified format.
1225      * @return A boolean that indicates if the operation was successful.
1226      */
1227     function approveAndCall(address spender, uint256 value, bytes memory data) public override returns (bool) {
1228         approve(spender, value);
1229         require(_checkAndCallApprove(spender, value, data), "ERC1363: _checkAndCallApprove reverts");
1230         return true;
1231     }
1232 
1233     /**
1234      * @dev Internal function to invoke `onTransferReceived` on a target address
1235      *  The call is not executed if the target address is not a contract
1236      * @param from address Representing the previous owner of the given token value
1237      * @param to address Target address that will receive the tokens
1238      * @param value uint256 The amount mount of tokens to be transferred
1239      * @param data bytes Optional data to send along with the call
1240      * @return whether the call correctly returned the expected magic value
1241      */
1242     function _checkAndCallTransfer(address from, address to, uint256 value, bytes memory data) internal returns (bool) {
1243         if (!to.isContract()) {
1244             return false;
1245         }
1246         bytes4 retval = IERC1363Receiver(to).onTransferReceived(
1247             _msgSender(), from, value, data
1248         );
1249         return (retval == _ERC1363_RECEIVED);
1250     }
1251 
1252     /**
1253      * @dev Internal function to invoke `onApprovalReceived` on a target address
1254      *  The call is not executed if the target address is not a contract
1255      * @param spender address The address which will spend the funds
1256      * @param value uint256 The amount of tokens to be spent
1257      * @param data bytes Optional data to send along with the call
1258      * @return whether the call correctly returned the expected magic value
1259      */
1260     function _checkAndCallApprove(address spender, uint256 value, bytes memory data) internal returns (bool) {
1261         if (!spender.isContract()) {
1262             return false;
1263         }
1264         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
1265             _msgSender(), value, data
1266         );
1267         return (retval == _ERC1363_APPROVED);
1268     }
1269 }
1270 
1271 // File: @openzeppelin/contracts/access/Ownable.sol
1272 
1273 pragma solidity ^0.7.0;
1274 
1275 /**
1276  * @dev Contract module which provides a basic access control mechanism, where
1277  * there is an account (an owner) that can be granted exclusive access to
1278  * specific functions.
1279  *
1280  * By default, the owner account will be the one that deploys the contract. This
1281  * can later be changed with {transferOwnership}.
1282  *
1283  * This module is used through inheritance. It will make available the modifier
1284  * `onlyOwner`, which can be applied to your functions to restrict their use to
1285  * the owner.
1286  */
1287 contract Ownable is Context {
1288     address private _owner;
1289 
1290     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1291 
1292     /**
1293      * @dev Initializes the contract setting the deployer as the initial owner.
1294      */
1295     constructor () {
1296         address msgSender = _msgSender();
1297         _owner = msgSender;
1298         emit OwnershipTransferred(address(0), msgSender);
1299     }
1300 
1301     /**
1302      * @dev Returns the address of the current owner.
1303      */
1304     function owner() public view returns (address) {
1305         return _owner;
1306     }
1307 
1308     /**
1309      * @dev Throws if called by any account other than the owner.
1310      */
1311     modifier onlyOwner() {
1312         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1313         _;
1314     }
1315 
1316     /**
1317      * @dev Leaves the contract without owner. It will not be possible to call
1318      * `onlyOwner` functions anymore. Can only be called by the current owner.
1319      *
1320      * NOTE: Renouncing ownership will leave the contract without an owner,
1321      * thereby removing any functionality that is only available to the owner.
1322      */
1323     function renounceOwnership() public virtual onlyOwner {
1324         emit OwnershipTransferred(_owner, address(0));
1325         _owner = address(0);
1326     }
1327 
1328     /**
1329      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1330      * Can only be called by the current owner.
1331      */
1332     function transferOwnership(address newOwner) public virtual onlyOwner {
1333         require(newOwner != address(0), "Ownable: new owner is the zero address");
1334         emit OwnershipTransferred(_owner, newOwner);
1335         _owner = newOwner;
1336     }
1337 }
1338 
1339 // File: eth-token-recover/contracts/TokenRecover.sol
1340 
1341 pragma solidity ^0.7.0;
1342 
1343 /**
1344  * @title TokenRecover
1345  * @author Vittorio Minacori (https://github.com/vittominacori)
1346  * @dev Allow to recover any ERC20 sent into the contract for error
1347  */
1348 contract TokenRecover is Ownable {
1349 
1350     /**
1351      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1352      * @param tokenAddress The token contract address
1353      * @param tokenAmount Number of tokens to be sent
1354      */
1355     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
1356         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1357     }
1358 }
1359 
1360 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
1361 
1362 pragma solidity ^0.7.0;
1363 
1364 /**
1365  * @dev Library for managing
1366  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1367  * types.
1368  *
1369  * Sets have the following properties:
1370  *
1371  * - Elements are added, removed, and checked for existence in constant time
1372  * (O(1)).
1373  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1374  *
1375  * ```
1376  * contract Example {
1377  *     // Add the library methods
1378  *     using EnumerableSet for EnumerableSet.AddressSet;
1379  *
1380  *     // Declare a set state variable
1381  *     EnumerableSet.AddressSet private mySet;
1382  * }
1383  * ```
1384  *
1385  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
1386  * (`UintSet`) are supported.
1387  */
1388 library EnumerableSet {
1389     // To implement this library for multiple types with as little code
1390     // repetition as possible, we write it in terms of a generic Set type with
1391     // bytes32 values.
1392     // The Set implementation uses private functions, and user-facing
1393     // implementations (such as AddressSet) are just wrappers around the
1394     // underlying Set.
1395     // This means that we can only create new EnumerableSets for types that fit
1396     // in bytes32.
1397 
1398     struct Set {
1399         // Storage of set values
1400         bytes32[] _values;
1401 
1402         // Position of the value in the `values` array, plus 1 because index 0
1403         // means a value is not in the set.
1404         mapping (bytes32 => uint256) _indexes;
1405     }
1406 
1407     /**
1408      * @dev Add a value to a set. O(1).
1409      *
1410      * Returns true if the value was added to the set, that is if it was not
1411      * already present.
1412      */
1413     function _add(Set storage set, bytes32 value) private returns (bool) {
1414         if (!_contains(set, value)) {
1415             set._values.push(value);
1416             // The value is stored at length-1, but we add 1 to all indexes
1417             // and use 0 as a sentinel value
1418             set._indexes[value] = set._values.length;
1419             return true;
1420         } else {
1421             return false;
1422         }
1423     }
1424 
1425     /**
1426      * @dev Removes a value from a set. O(1).
1427      *
1428      * Returns true if the value was removed from the set, that is if it was
1429      * present.
1430      */
1431     function _remove(Set storage set, bytes32 value) private returns (bool) {
1432         // We read and store the value's index to prevent multiple reads from the same storage slot
1433         uint256 valueIndex = set._indexes[value];
1434 
1435         if (valueIndex != 0) { // Equivalent to contains(set, value)
1436             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1437             // the array, and then remove the last element (sometimes called as 'swap and pop').
1438             // This modifies the order of the array, as noted in {at}.
1439 
1440             uint256 toDeleteIndex = valueIndex - 1;
1441             uint256 lastIndex = set._values.length - 1;
1442 
1443             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1444             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1445 
1446             bytes32 lastvalue = set._values[lastIndex];
1447 
1448             // Move the last value to the index where the value to delete is
1449             set._values[toDeleteIndex] = lastvalue;
1450             // Update the index for the moved value
1451             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1452 
1453             // Delete the slot where the moved value was stored
1454             set._values.pop();
1455 
1456             // Delete the index for the deleted slot
1457             delete set._indexes[value];
1458 
1459             return true;
1460         } else {
1461             return false;
1462         }
1463     }
1464 
1465     /**
1466      * @dev Returns true if the value is in the set. O(1).
1467      */
1468     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1469         return set._indexes[value] != 0;
1470     }
1471 
1472     /**
1473      * @dev Returns the number of values on the set. O(1).
1474      */
1475     function _length(Set storage set) private view returns (uint256) {
1476         return set._values.length;
1477     }
1478 
1479    /**
1480     * @dev Returns the value stored at position `index` in the set. O(1).
1481     *
1482     * Note that there are no guarantees on the ordering of values inside the
1483     * array, and it may change when more values are added or removed.
1484     *
1485     * Requirements:
1486     *
1487     * - `index` must be strictly less than {length}.
1488     */
1489     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1490         require(set._values.length > index, "EnumerableSet: index out of bounds");
1491         return set._values[index];
1492     }
1493 
1494     // AddressSet
1495 
1496     struct AddressSet {
1497         Set _inner;
1498     }
1499 
1500     /**
1501      * @dev Add a value to a set. O(1).
1502      *
1503      * Returns true if the value was added to the set, that is if it was not
1504      * already present.
1505      */
1506     function add(AddressSet storage set, address value) internal returns (bool) {
1507         return _add(set._inner, bytes32(uint256(value)));
1508     }
1509 
1510     /**
1511      * @dev Removes a value from a set. O(1).
1512      *
1513      * Returns true if the value was removed from the set, that is if it was
1514      * present.
1515      */
1516     function remove(AddressSet storage set, address value) internal returns (bool) {
1517         return _remove(set._inner, bytes32(uint256(value)));
1518     }
1519 
1520     /**
1521      * @dev Returns true if the value is in the set. O(1).
1522      */
1523     function contains(AddressSet storage set, address value) internal view returns (bool) {
1524         return _contains(set._inner, bytes32(uint256(value)));
1525     }
1526 
1527     /**
1528      * @dev Returns the number of values in the set. O(1).
1529      */
1530     function length(AddressSet storage set) internal view returns (uint256) {
1531         return _length(set._inner);
1532     }
1533 
1534    /**
1535     * @dev Returns the value stored at position `index` in the set. O(1).
1536     *
1537     * Note that there are no guarantees on the ordering of values inside the
1538     * array, and it may change when more values are added or removed.
1539     *
1540     * Requirements:
1541     *
1542     * - `index` must be strictly less than {length}.
1543     */
1544     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1545         return address(uint256(_at(set._inner, index)));
1546     }
1547 
1548 
1549     // UintSet
1550 
1551     struct UintSet {
1552         Set _inner;
1553     }
1554 
1555     /**
1556      * @dev Add a value to a set. O(1).
1557      *
1558      * Returns true if the value was added to the set, that is if it was not
1559      * already present.
1560      */
1561     function add(UintSet storage set, uint256 value) internal returns (bool) {
1562         return _add(set._inner, bytes32(value));
1563     }
1564 
1565     /**
1566      * @dev Removes a value from a set. O(1).
1567      *
1568      * Returns true if the value was removed from the set, that is if it was
1569      * present.
1570      */
1571     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1572         return _remove(set._inner, bytes32(value));
1573     }
1574 
1575     /**
1576      * @dev Returns true if the value is in the set. O(1).
1577      */
1578     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1579         return _contains(set._inner, bytes32(value));
1580     }
1581 
1582     /**
1583      * @dev Returns the number of values on the set. O(1).
1584      */
1585     function length(UintSet storage set) internal view returns (uint256) {
1586         return _length(set._inner);
1587     }
1588 
1589    /**
1590     * @dev Returns the value stored at position `index` in the set. O(1).
1591     *
1592     * Note that there are no guarantees on the ordering of values inside the
1593     * array, and it may change when more values are added or removed.
1594     *
1595     * Requirements:
1596     *
1597     * - `index` must be strictly less than {length}.
1598     */
1599     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1600         return uint256(_at(set._inner, index));
1601     }
1602 }
1603 
1604 // File: @openzeppelin/contracts/access/AccessControl.sol
1605 
1606 pragma solidity ^0.7.0;
1607 
1608 /**
1609  * @dev Contract module that allows children to implement role-based access
1610  * control mechanisms.
1611  *
1612  * Roles are referred to by their `bytes32` identifier. These should be exposed
1613  * in the external API and be unique. The best way to achieve this is by
1614  * using `public constant` hash digests:
1615  *
1616  * ```
1617  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1618  * ```
1619  *
1620  * Roles can be used to represent a set of permissions. To restrict access to a
1621  * function call, use {hasRole}:
1622  *
1623  * ```
1624  * function foo() public {
1625  *     require(hasRole(MY_ROLE, msg.sender));
1626  *     ...
1627  * }
1628  * ```
1629  *
1630  * Roles can be granted and revoked dynamically via the {grantRole} and
1631  * {revokeRole} functions. Each role has an associated admin role, and only
1632  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1633  *
1634  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1635  * that only accounts with this role will be able to grant or revoke other
1636  * roles. More complex role relationships can be created by using
1637  * {_setRoleAdmin}.
1638  *
1639  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1640  * grant and revoke this role. Extra precautions should be taken to secure
1641  * accounts that have been granted it.
1642  */
1643 abstract contract AccessControl is Context {
1644     using EnumerableSet for EnumerableSet.AddressSet;
1645     using Address for address;
1646 
1647     struct RoleData {
1648         EnumerableSet.AddressSet members;
1649         bytes32 adminRole;
1650     }
1651 
1652     mapping (bytes32 => RoleData) private _roles;
1653 
1654     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1655 
1656     /**
1657      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1658      *
1659      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1660      * {RoleAdminChanged} not being emitted signaling this.
1661      *
1662      * _Available since v3.1._
1663      */
1664     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1665 
1666     /**
1667      * @dev Emitted when `account` is granted `role`.
1668      *
1669      * `sender` is the account that originated the contract call, an admin role
1670      * bearer except when using {_setupRole}.
1671      */
1672     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1673 
1674     /**
1675      * @dev Emitted when `account` is revoked `role`.
1676      *
1677      * `sender` is the account that originated the contract call:
1678      *   - if using `revokeRole`, it is the admin role bearer
1679      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1680      */
1681     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1682 
1683     /**
1684      * @dev Returns `true` if `account` has been granted `role`.
1685      */
1686     function hasRole(bytes32 role, address account) public view returns (bool) {
1687         return _roles[role].members.contains(account);
1688     }
1689 
1690     /**
1691      * @dev Returns the number of accounts that have `role`. Can be used
1692      * together with {getRoleMember} to enumerate all bearers of a role.
1693      */
1694     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1695         return _roles[role].members.length();
1696     }
1697 
1698     /**
1699      * @dev Returns one of the accounts that have `role`. `index` must be a
1700      * value between 0 and {getRoleMemberCount}, non-inclusive.
1701      *
1702      * Role bearers are not sorted in any particular way, and their ordering may
1703      * change at any point.
1704      *
1705      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1706      * you perform all queries on the same block. See the following
1707      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1708      * for more information.
1709      */
1710     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1711         return _roles[role].members.at(index);
1712     }
1713 
1714     /**
1715      * @dev Returns the admin role that controls `role`. See {grantRole} and
1716      * {revokeRole}.
1717      *
1718      * To change a role's admin, use {_setRoleAdmin}.
1719      */
1720     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1721         return _roles[role].adminRole;
1722     }
1723 
1724     /**
1725      * @dev Grants `role` to `account`.
1726      *
1727      * If `account` had not been already granted `role`, emits a {RoleGranted}
1728      * event.
1729      *
1730      * Requirements:
1731      *
1732      * - the caller must have ``role``'s admin role.
1733      */
1734     function grantRole(bytes32 role, address account) public virtual {
1735         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1736 
1737         _grantRole(role, account);
1738     }
1739 
1740     /**
1741      * @dev Revokes `role` from `account`.
1742      *
1743      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1744      *
1745      * Requirements:
1746      *
1747      * - the caller must have ``role``'s admin role.
1748      */
1749     function revokeRole(bytes32 role, address account) public virtual {
1750         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1751 
1752         _revokeRole(role, account);
1753     }
1754 
1755     /**
1756      * @dev Revokes `role` from the calling account.
1757      *
1758      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1759      * purpose is to provide a mechanism for accounts to lose their privileges
1760      * if they are compromised (such as when a trusted device is misplaced).
1761      *
1762      * If the calling account had been granted `role`, emits a {RoleRevoked}
1763      * event.
1764      *
1765      * Requirements:
1766      *
1767      * - the caller must be `account`.
1768      */
1769     function renounceRole(bytes32 role, address account) public virtual {
1770         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1771 
1772         _revokeRole(role, account);
1773     }
1774 
1775     /**
1776      * @dev Grants `role` to `account`.
1777      *
1778      * If `account` had not been already granted `role`, emits a {RoleGranted}
1779      * event. Note that unlike {grantRole}, this function doesn't perform any
1780      * checks on the calling account.
1781      *
1782      * [WARNING]
1783      * ====
1784      * This function should only be called from the constructor when setting
1785      * up the initial roles for the system.
1786      *
1787      * Using this function in any other way is effectively circumventing the admin
1788      * system imposed by {AccessControl}.
1789      * ====
1790      */
1791     function _setupRole(bytes32 role, address account) internal virtual {
1792         _grantRole(role, account);
1793     }
1794 
1795     /**
1796      * @dev Sets `adminRole` as ``role``'s admin role.
1797      *
1798      * Emits a {RoleAdminChanged} event.
1799      */
1800     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1801         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1802         _roles[role].adminRole = adminRole;
1803     }
1804 
1805     function _grantRole(bytes32 role, address account) private {
1806         if (_roles[role].members.add(account)) {
1807             emit RoleGranted(role, account, _msgSender());
1808         }
1809     }
1810 
1811     function _revokeRole(bytes32 role, address account) private {
1812         if (_roles[role].members.remove(account)) {
1813             emit RoleRevoked(role, account, _msgSender());
1814         }
1815     }
1816 }
1817 
1818 // File: @vittominacori/erc20-token/contracts/access/Roles.sol
1819 
1820 pragma solidity ^0.7.0;
1821 
1822 contract Roles is AccessControl {
1823 
1824     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
1825     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR");
1826 
1827     constructor () {
1828         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1829         _setupRole(MINTER_ROLE, _msgSender());
1830         _setupRole(OPERATOR_ROLE, _msgSender());
1831     }
1832 
1833     modifier onlyMinter() {
1834         require(hasRole(MINTER_ROLE, _msgSender()), "Roles: caller does not have the MINTER role");
1835         _;
1836     }
1837 
1838     modifier onlyOperator() {
1839         require(hasRole(OPERATOR_ROLE, _msgSender()), "Roles: caller does not have the OPERATOR role");
1840         _;
1841     }
1842 }
1843 
1844 // File: @vittominacori/erc20-token/contracts/ERC20Base.sol
1845 
1846 pragma solidity ^0.7.0;
1847 
1848 /**
1849  * @title ERC20Base
1850  * @author Vittorio Minacori (https://github.com/vittominacori)
1851  * @dev Implementation of the ERC20Base
1852  */
1853 contract ERC20Base is ERC20Capped, ERC20Burnable, ERC1363, Roles, TokenRecover {
1854 
1855     // indicates if minting is finished
1856     bool private _mintingFinished = false;
1857 
1858     // indicates if transfer is enabled
1859     bool private _transferEnabled = false;
1860 
1861     /**
1862      * @dev Emitted during finish minting
1863      */
1864     event MintFinished();
1865 
1866     /**
1867      * @dev Emitted during transfer enabling
1868      */
1869     event TransferEnabled();
1870 
1871     /**
1872      * @dev Emitted during transfer disabling
1873      */
1874     event TransferDisabled();
1875 
1876     /**
1877      * @dev Tokens can be minted only before minting finished.
1878      */
1879     modifier canMint() {
1880         require(!_mintingFinished, "ERC20Base: minting is finished");
1881         _;
1882     }
1883 
1884     /**
1885      * @dev Tokens can be moved only after if transfer enabled or if you are an approved operator.
1886      */
1887     modifier canTransfer(address from) {
1888         require(
1889             _transferEnabled || hasRole(OPERATOR_ROLE, from),
1890             "ERC20Base: transfer is not enabled or from does not have the OPERATOR role"
1891         );
1892         _;
1893     }
1894 
1895     /**
1896      * @param name Name of the token
1897      * @param symbol A symbol to be used as ticker
1898      * @param decimals Number of decimals. All the operations are done using the smallest and indivisible token unit
1899      * @param cap Maximum number of tokens mintable
1900      * @param initialSupply Initial token supply
1901      * @param transferEnabled If transfer is enabled on token creation
1902      * @param mintingFinished If minting is finished after token creation
1903      */
1904     constructor(
1905         string memory name,
1906         string memory symbol,
1907         uint8 decimals,
1908         uint256 cap,
1909         uint256 initialSupply,
1910         bool transferEnabled,
1911         bool mintingFinished
1912     )
1913         ERC20Capped(cap)
1914         ERC1363(name, symbol)
1915     {
1916         require(
1917             mintingFinished == false || cap == initialSupply,
1918             "ERC20Base: if finish minting, cap must be equal to initialSupply"
1919         );
1920 
1921         _setupDecimals(decimals);
1922 
1923         if (initialSupply > 0) {
1924             _mint(owner(), initialSupply);
1925         }
1926 
1927         if (mintingFinished) {
1928             finishMinting();
1929         }
1930 
1931         if (transferEnabled) {
1932             enableTransfer();
1933         }
1934     }
1935 
1936     /**
1937      * @return if minting is finished or not.
1938      */
1939     function mintingFinished() public view returns (bool) {
1940         return _mintingFinished;
1941     }
1942 
1943     /**
1944      * @return if transfer is enabled or not.
1945      */
1946     function transferEnabled() public view returns (bool) {
1947         return _transferEnabled;
1948     }
1949 
1950     /**
1951      * @dev Function to mint tokens.
1952      * @param to The address that will receive the minted tokens
1953      * @param value The amount of tokens to mint
1954      */
1955     function mint(address to, uint256 value) public canMint onlyMinter {
1956         _mint(to, value);
1957     }
1958 
1959     /**
1960      * @dev Transfer tokens to a specified address.
1961      * @param to The address to transfer to
1962      * @param value The amount to be transferred
1963      * @return A boolean that indicates if the operation was successful.
1964      */
1965     function transfer(address to, uint256 value) public virtual override(ERC20) canTransfer(_msgSender()) returns (bool) {
1966         return super.transfer(to, value);
1967     }
1968 
1969     /**
1970      * @dev Transfer tokens from one address to another.
1971      * @param from The address which you want to send tokens from
1972      * @param to The address which you want to transfer to
1973      * @param value the amount of tokens to be transferred
1974      * @return A boolean that indicates if the operation was successful.
1975      */
1976     function transferFrom(address from, address to, uint256 value) public virtual override(ERC20) canTransfer(from) returns (bool) {
1977         return super.transferFrom(from, to, value);
1978     }
1979 
1980      /**
1981      * @dev Destroys `amount` tokens from the caller.
1982      *
1983      * See {ERC20-_burn}.
1984      */
1985     function burn(uint256 amount) public virtual override(ERC20Burnable) canTransfer(_msgSender()){
1986         super.burn(amount);
1987     }
1988 
1989     /**
1990      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1991      * allowance.
1992      *
1993      * See {ERC20-_burn} and {ERC20-allowance}.
1994      *
1995      * Requirements:
1996      *
1997      * - the caller must have allowance for ``accounts``'s tokens of at least
1998      * `amount`.
1999      */
2000     function burnFrom(address account, uint256 amount) public virtual override(ERC20Burnable) canTransfer(account){
2001         super.burnFrom(account, amount);
2002     }
2003 
2004      /**
2005      * @dev See {IERC20-approve}.
2006      *
2007      * Requirements:
2008      *
2009      * - `spender` cannot be the zero address.
2010      */
2011     function approve(address spender, uint256 amount) public virtual override canTransfer(spender) returns (bool) {
2012        return super.approve(spender, amount);
2013     }
2014 
2015     /**
2016      * @dev Function to stop minting new tokens.
2017      */
2018     function finishMinting() public canMint onlyOwner {
2019         _mintingFinished = true;
2020 
2021         emit MintFinished();
2022     }
2023 
2024     /**
2025      * @dev Function to enable transfers.
2026      */
2027     function enableTransfer() public onlyOwner {
2028         _transferEnabled = true;
2029 
2030         emit TransferEnabled();
2031     }
2032 
2033     /**
2034      * @dev Function to disable transfers.
2035      */
2036     function disableTransfer() public onlyOwner {
2037         _transferEnabled = false;
2038 
2039         emit TransferDisabled();
2040     }
2041 
2042     /**
2043      * @dev See {ERC20-_beforeTokenTransfer}.
2044      */
2045     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
2046         super._beforeTokenTransfer(from, to, amount);
2047     }
2048 }
2049 
2050 // File: contracts/BaseToken.sol
2051 
2052 pragma solidity ^0.7.1;
2053 
2054 /**
2055  * @title BaseToken
2056  * @author Vittorio Minacori (https://github.com/vittominacori)
2057  * @dev Implementation of the BaseToken
2058  */
2059 contract BaseToken is ERC20Base {
2060 
2061   string private constant _GENERATOR = "https://vittominacori.github.io/erc20-generator";
2062   string private constant _VERSION = "v3.2.0";
2063 
2064   constructor (
2065     string memory name,
2066     string memory symbol,
2067     uint8 decimals,
2068     uint256 cap,
2069     uint256 initialSupply,
2070     bool transferEnabled,
2071     bool mintingFinished
2072   ) ERC20Base(name, symbol, decimals, cap, initialSupply, transferEnabled, mintingFinished) {}
2073 
2074   /**
2075    * @dev Returns the token generator tool.
2076    */
2077   function generator() public pure returns (string memory) {
2078     return _GENERATOR;
2079   }
2080 
2081   /**
2082    * @dev Returns the token generator version.
2083    */
2084   function version() public pure returns (string memory) {
2085     return _VERSION;
2086   }
2087 }