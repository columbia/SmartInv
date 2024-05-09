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
24 
25 
26 /**
27  * @dev Wrappers over Solidity's arithmetic operations with added overflow
28  * checks.
29  *
30  * Arithmetic operations in Solidity wrap on overflow. This can easily result
31  * in bugs, because programmers usually assume that an overflow raises an
32  * error, which is the standard behavior in high level programming languages.
33  * `SafeMath` restores this intuition by reverting the transaction when an
34  * operation overflows.
35  *
36  * Using this library instead of the unchecked operations eliminates an entire
37  * class of bugs, so it's recommended to use it always.
38  */
39 library SafeMath {
40     /**
41      * @dev Returns the addition of two unsigned integers, reverting on
42      * overflow.
43      *
44      * Counterpart to Solidity's `+` operator.
45      *
46      * Requirements:
47      *
48      * - Addition cannot overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a, "SafeMath: addition overflow");
53 
54         return c;
55     }
56 
57     /**
58      * @dev Returns the subtraction of two unsigned integers, reverting on
59      * overflow (when the result is negative).
60      *
61      * Counterpart to Solidity's `-` operator.
62      *
63      * Requirements:
64      *
65      * - Subtraction cannot overflow.
66      */
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         return sub(a, b, "SafeMath: subtraction overflow");
69     }
70 
71     /**
72      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
73      * overflow (when the result is negative).
74      *
75      * Counterpart to Solidity's `-` operator.
76      *
77      * Requirements:
78      *
79      * - Subtraction cannot overflow.
80      */
81     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         require(b <= a, errorMessage);
83         uint256 c = a - b;
84 
85         return c;
86     }
87 
88     /**
89      * @dev Returns the multiplication of two unsigned integers, reverting on
90      * overflow.
91      *
92      * Counterpart to Solidity's `*` operator.
93      *
94      * Requirements:
95      *
96      * - Multiplication cannot overflow.
97      */
98     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
100         // benefit is lost if 'b' is also tested.
101         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
102         if (a == 0) {
103             return 0;
104         }
105 
106         uint256 c = a * b;
107         require(c / a == b, "SafeMath: multiplication overflow");
108 
109         return c;
110     }
111 
112     /**
113      * @dev Returns the integer division of two unsigned integers. Reverts on
114      * division by zero. The result is rounded towards zero.
115      *
116      * Counterpart to Solidity's `/` operator. Note: this function uses a
117      * `revert` opcode (which leaves remaining gas untouched) while Solidity
118      * uses an invalid opcode to revert (consuming all remaining gas).
119      *
120      * Requirements:
121      *
122      * - The divisor cannot be zero.
123      */
124     function div(uint256 a, uint256 b) internal pure returns (uint256) {
125         return div(a, b, "SafeMath: division by zero");
126     }
127 
128     /**
129      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
130      * division by zero. The result is rounded towards zero.
131      *
132      * Counterpart to Solidity's `/` operator. Note: this function uses a
133      * `revert` opcode (which leaves remaining gas untouched) while Solidity
134      * uses an invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b > 0, errorMessage);
142         uint256 c = a / b;
143         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
150      * Reverts when dividing by zero.
151      *
152      * Counterpart to Solidity's `%` operator. This function uses a `revert`
153      * opcode (which leaves remaining gas untouched) while Solidity uses an
154      * invalid opcode to revert (consuming all remaining gas).
155      *
156      * Requirements:
157      *
158      * - The divisor cannot be zero.
159      */
160     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
161         return mod(a, b, "SafeMath: modulo by zero");
162     }
163 
164     /**
165      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
166      * Reverts with custom message when dividing by zero.
167      *
168      * Counterpart to Solidity's `%` operator. This function uses a `revert`
169      * opcode (which leaves remaining gas untouched) while Solidity uses an
170      * invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      *
174      * - The divisor cannot be zero.
175      */
176     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
177         require(b != 0, errorMessage);
178         return a % b;
179     }
180 }
181 
182 
183 
184 /**
185  * @dev Collection of functions related to the address type
186  */
187 library Address {
188     /**
189      * @dev Returns true if `account` is a contract.
190      *
191      * [IMPORTANT]
192      * ====
193      * It is unsafe to assume that an address for which this function returns
194      * false is an externally-owned account (EOA) and not a contract.
195      *
196      * Among others, `isContract` will return false for the following
197      * types of addresses:
198      *
199      *  - an externally-owned account
200      *  - a contract in construction
201      *  - an address where a contract will be created
202      *  - an address where a contract lived, but was destroyed
203      * ====
204      */
205     function isContract(address account) internal view returns (bool) {
206         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
207         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
208         // for accounts without code, i.e. `keccak256('')`
209         bytes32 codehash;
210         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
211         // solhint-disable-next-line no-inline-assembly
212         assembly { codehash := extcodehash(account) }
213         return (codehash != accountHash && codehash != 0x0);
214     }
215 
216     /**
217      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
218      * `recipient`, forwarding all available gas and reverting on errors.
219      *
220      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
221      * of certain opcodes, possibly making contracts go over the 2300 gas limit
222      * imposed by `transfer`, making them unable to receive funds via
223      * `transfer`. {sendValue} removes this limitation.
224      *
225      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
226      *
227      * IMPORTANT: because control is transferred to `recipient`, care must be
228      * taken to not create reentrancy vulnerabilities. Consider using
229      * {ReentrancyGuard} or the
230      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
231      */
232     function sendValue(address payable recipient, uint256 amount) internal {
233         require(address(this).balance >= amount, "Address: insufficient balance");
234 
235         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
236         (bool success, ) = recipient.call{ value: amount }("");
237         require(success, "Address: unable to send value, recipient may have reverted");
238     }
239 
240     /**
241      * @dev Performs a Solidity function call using a low level `call`. A
242      * plain`call` is an unsafe replacement for a function call: use this
243      * function instead.
244      *
245      * If `target` reverts with a revert reason, it is bubbled up by this
246      * function (like regular Solidity function calls).
247      *
248      * Returns the raw returned data. To convert to the expected return value,
249      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
250      *
251      * Requirements:
252      *
253      * - `target` must be a contract.
254      * - calling `target` with `data` must not revert.
255      *
256      * _Available since v3.1._
257      */
258     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
259       return functionCall(target, data, "Address: low-level call failed");
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
264      * `errorMessage` as a fallback revert reason when `target` reverts.
265      *
266      * _Available since v3.1._
267      */
268     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
269         return _functionCallWithValue(target, data, 0, errorMessage);
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
274      * but also transferring `value` wei to `target`.
275      *
276      * Requirements:
277      *
278      * - the calling contract must have an ETH balance of at least `value`.
279      * - the called Solidity function must be `payable`.
280      *
281      * _Available since v3.1._
282      */
283     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
284         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
285     }
286 
287     /**
288      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
289      * with `errorMessage` as a fallback revert reason when `target` reverts.
290      *
291      * _Available since v3.1._
292      */
293     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
294         require(address(this).balance >= value, "Address: insufficient balance for call");
295         return _functionCallWithValue(target, data, value, errorMessage);
296     }
297 
298     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
299         require(isContract(target), "Address: call to non-contract");
300 
301         // solhint-disable-next-line avoid-low-level-calls
302         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
303         if (success) {
304             return returndata;
305         } else {
306             // Look for revert reason and bubble it up if present
307             if (returndata.length > 0) {
308                 // The easiest way to bubble the revert reason is using memory via assembly
309 
310                 // solhint-disable-next-line no-inline-assembly
311                 assembly {
312                     let returndata_size := mload(returndata)
313                     revert(add(32, returndata), returndata_size)
314                 }
315             } else {
316                 revert(errorMessage);
317             }
318         }
319     }
320 }
321 
322 
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
398 
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
447     constructor (string memory name, string memory symbol) public {
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
651      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
652      *
653      * This is internal function is equivalent to `approve`, and can be used to
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
700 
701 
702 // SPDX-License-Identifier: MIT
703 /*
704 * Code is proprietary property of Zin Finance and must not be copied or used elsewhere.
705 */
706 contract ZinFinance is ERC20 {
707     constructor () public ERC20("Zin Finance", "Zin") {
708         _mint(msg.sender, 1000000000 * (10 ** uint256(decimals())));
709     }
710 }