1 // SPDX-License-Identifier: Apache-2.0
2 
3 pragma solidity ^0.6.12;
4 
5 
6 // 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // 
164 /*
165  * @dev Provides information about the current execution context, including the
166  * sender of the transaction and its data. While these are generally available
167  * via msg.sender and msg.data, they should not be accessed in such a direct
168  * manner, since when dealing with GSN meta-transactions the account sending and
169  * paying for execution may not be the actual sender (as far as an application
170  * is concerned).
171  *
172  * This contract is only required for intermediate, library-like contracts.
173  */
174 abstract contract Context {
175     function _msgSender() internal view virtual returns (address payable) {
176         return msg.sender;
177     }
178 
179     function _msgData() internal view virtual returns (bytes memory) {
180         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
181         return msg.data;
182     }
183 }
184 
185 // 
186 /**
187  * @dev Interface of the ERC20 standard as defined in the EIP.
188  */
189 interface IERC20 {
190     /**
191      * @dev Returns the amount of tokens in existence.
192      */
193     function totalSupply() external view returns (uint256);
194 
195     /**
196      * @dev Returns the amount of tokens owned by `account`.
197      */
198     function balanceOf(address account) external view returns (uint256);
199 
200     /**
201      * @dev Moves `amount` tokens from the caller's account to `recipient`.
202      *
203      * Returns a boolean value indicating whether the operation succeeded.
204      *
205      * Emits a {Transfer} event.
206      */
207     function transfer(address recipient, uint256 amount) external returns (bool);
208 
209     /**
210      * @dev Returns the remaining number of tokens that `spender` will be
211      * allowed to spend on behalf of `owner` through {transferFrom}. This is
212      * zero by default.
213      *
214      * This value changes when {approve} or {transferFrom} are called.
215      */
216     function allowance(address owner, address spender) external view returns (uint256);
217 
218     /**
219      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
220      *
221      * Returns a boolean value indicating whether the operation succeeded.
222      *
223      * IMPORTANT: Beware that changing an allowance with this method brings the risk
224      * that someone may use both the old and the new allowance by unfortunate
225      * transaction ordering. One possible solution to mitigate this race
226      * condition is to first reduce the spender's allowance to 0 and set the
227      * desired value afterwards:
228      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
229      *
230      * Emits an {Approval} event.
231      */
232     function approve(address spender, uint256 amount) external returns (bool);
233 
234     /**
235      * @dev Moves `amount` tokens from `sender` to `recipient` using the
236      * allowance mechanism. `amount` is then deducted from the caller's
237      * allowance.
238      *
239      * Returns a boolean value indicating whether the operation succeeded.
240      *
241      * Emits a {Transfer} event.
242      */
243     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
244 
245     /**
246      * @dev Emitted when `value` tokens are moved from one account (`from`) to
247      * another (`to`).
248      *
249      * Note that `value` may be zero.
250      */
251     event Transfer(address indexed from, address indexed to, uint256 value);
252 
253     /**
254      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
255      * a call to {approve}. `value` is the new allowance.
256      */
257     event Approval(address indexed owner, address indexed spender, uint256 value);
258 }
259 
260 // 
261 /**
262  * @dev Collection of functions related to the address type
263  */
264 library Address {
265     /**
266      * @dev Returns true if `account` is a contract.
267      *
268      * [IMPORTANT]
269      * ====
270      * It is unsafe to assume that an address for which this function returns
271      * false is an externally-owned account (EOA) and not a contract.
272      *
273      * Among others, `isContract` will return false for the following
274      * types of addresses:
275      *
276      *  - an externally-owned account
277      *  - a contract in construction
278      *  - an address where a contract will be created
279      *  - an address where a contract lived, but was destroyed
280      * ====
281      */
282     function isContract(address account) internal view returns (bool) {
283         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
284         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
285         // for accounts without code, i.e. `keccak256('')`
286         bytes32 codehash;
287         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
288         // solhint-disable-next-line no-inline-assembly
289         assembly { codehash := extcodehash(account) }
290         return (codehash != accountHash && codehash != 0x0);
291     }
292 
293     /**
294      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
295      * `recipient`, forwarding all available gas and reverting on errors.
296      *
297      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
298      * of certain opcodes, possibly making contracts go over the 2300 gas limit
299      * imposed by `transfer`, making them unable to receive funds via
300      * `transfer`. {sendValue} removes this limitation.
301      *
302      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
303      *
304      * IMPORTANT: because control is transferred to `recipient`, care must be
305      * taken to not create reentrancy vulnerabilities. Consider using
306      * {ReentrancyGuard} or the
307      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
308      */
309     function sendValue(address payable recipient, uint256 amount) internal {
310         require(address(this).balance >= amount, "Address: insufficient balance");
311 
312         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
313         (bool success, ) = recipient.call{ value: amount }("");
314         require(success, "Address: unable to send value, recipient may have reverted");
315     }
316 
317     /**
318      * @dev Performs a Solidity function call using a low level `call`. A
319      * plain`call` is an unsafe replacement for a function call: use this
320      * function instead.
321      *
322      * If `target` reverts with a revert reason, it is bubbled up by this
323      * function (like regular Solidity function calls).
324      *
325      * Returns the raw returned data. To convert to the expected return value,
326      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
327      *
328      * Requirements:
329      *
330      * - `target` must be a contract.
331      * - calling `target` with `data` must not revert.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
336       return functionCall(target, data, "Address: low-level call failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
341      * `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
346         return _functionCallWithValue(target, data, 0, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but also transferring `value` wei to `target`.
352      *
353      * Requirements:
354      *
355      * - the calling contract must have an ETH balance of at least `value`.
356      * - the called Solidity function must be `payable`.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
366      * with `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
371         require(address(this).balance >= value, "Address: insufficient balance for call");
372         return _functionCallWithValue(target, data, value, errorMessage);
373     }
374 
375     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
376         require(isContract(target), "Address: call to non-contract");
377 
378         // solhint-disable-next-line avoid-low-level-calls
379         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
380         if (success) {
381             return returndata;
382         } else {
383             // Look for revert reason and bubble it up if present
384             if (returndata.length > 0) {
385                 // The easiest way to bubble the revert reason is using memory via assembly
386 
387                 // solhint-disable-next-line no-inline-assembly
388                 assembly {
389                     let returndata_size := mload(returndata)
390                     revert(add(32, returndata), returndata_size)
391                 }
392             } else {
393                 revert(errorMessage);
394             }
395         }
396     }
397 }
398 
399 // 
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
699 // 
700 /**
701  * @title SafeERC20
702  * @dev Wrappers around ERC20 operations that throw on failure (when the token
703  * contract returns false). Tokens that return no value (and instead revert or
704  * throw on failure) are also supported, non-reverting calls are assumed to be
705  * successful.
706  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
707  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
708  */
709 library SafeERC20 {
710     using SafeMath for uint256;
711     using Address for address;
712 
713     function safeTransfer(IERC20 token, address to, uint256 value) internal {
714         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
715     }
716 
717     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
718         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
719     }
720 
721     /**
722      * @dev Deprecated. This function has issues similar to the ones found in
723      * {IERC20-approve}, and its usage is discouraged.
724      *
725      * Whenever possible, use {safeIncreaseAllowance} and
726      * {safeDecreaseAllowance} instead.
727      */
728     function safeApprove(IERC20 token, address spender, uint256 value) internal {
729         // safeApprove should only be called when setting an initial allowance,
730         // or when resetting it to zero. To increase and decrease it, use
731         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
732         // solhint-disable-next-line max-line-length
733         require((value == 0) || (token.allowance(address(this), spender) == 0),
734             "SafeERC20: approve from non-zero to non-zero allowance"
735         );
736         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
737     }
738 
739     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
740         uint256 newAllowance = token.allowance(address(this), spender).add(value);
741         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
742     }
743 
744     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
745         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
746         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
747     }
748 
749     /**
750      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
751      * on the return value: the return value is optional (but if data is returned, it must not be false).
752      * @param token The token targeted by the call.
753      * @param data The call data (encoded using abi.encode or one of its variants).
754      */
755     function _callOptionalReturn(IERC20 token, bytes memory data) private {
756         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
757         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
758         // the target address contains contract code and also asserts for success in the low-level call.
759 
760         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
761         if (returndata.length > 0) { // Return data is optional
762             // solhint-disable-next-line max-line-length
763             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
764         }
765     }
766 }
767 
768 // 
769 interface ICToken {
770     /// @notice Contract which oversees inter-cToken operations
771     function comptroller() external view returns (IComptroller);
772 
773     /**
774      * @notice Sender supplies assets into the market and receives cTokens in exchange
775      * @dev Accrues interest whether or not the operation succeeds, unless reverted
776      * @param mintAmount The amount of the underlying asset to supply
777      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
778      */
779     function mint(uint mintAmount) external returns (uint);
780 
781     /**
782      * @notice Sender redeems cTokens in exchange for a specified amount of underlying asset
783      * @dev Accrues interest whether or not the operation succeeds, unless reverted
784      * @param redeemAmount The amount of underlying to redeem
785      * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
786      */
787     function redeemUnderlying(uint redeemAmount) external returns (uint);
788 
789     /**
790      * @notice Get the underlying balance of the `owner`
791      * @dev This also accrues interest in a transaction
792      * @param owner The address of the account to query
793      * @return The amount of underlying owned by `owner`
794      */
795     function balanceOfUnderlying(address owner) external returns (uint);
796 
797     /**
798      * @notice Get the token balance of the `owner`
799      * @param owner The address of the account to query
800      * @return The number of tokens owned by `owner`
801      */
802     function balanceOf(address owner) external view returns (uint);
803 
804     /**
805      * @notice Returns the current per-block borrow interest rate for this cToken
806      * @return The borrow interest rate per block, scaled by 1e18
807      */
808     function borrowRatePerBlock() external view returns (uint);
809 
810     /**
811      * @notice Returns the current per-block supply interest rate for this cToken
812      * @return The supply interest rate per block, scaled by 1e18
813      */
814     function supplyRatePerBlock() external view returns (uint);
815 
816     /**
817      * @notice Calculates the exchange rate from the underlying to the CToken
818      * @dev This function does not accrue interest before calculating the exchange rate
819      * @return Calculated exchange rate scaled by 1e18
820      */
821     function exchangeRateStored() external view returns (uint256);
822 
823     /**
824      * @notice Get the total number of tokens in circulation
825      * @return The supply of tokens
826      */
827     function totalSupply() external view returns (uint256);
828 
829     /// @notice Underlying asset for this CToken
830     function underlying() external view returns (address);
831 }
832 
833 interface IComptroller {
834     /// @notice The COMP accrued but not yet transferred to each user
835     function compAccrued(address holder) external view returns (uint256);
836 
837     /**
838      * @notice Claim all the comp accrued by holder in all markets
839      * @param holder The address to claim COMP for
840      */
841     function claimComp(address holder) external;
842 
843     /**
844      * @notice Claim all the comp accrued by holder in the specified markets
845      * @param holder The address to claim COMP for
846      * @param cTokens The list of markets to claim COMP in
847      */
848     function claimComp(address holder, ICToken[] memory cTokens) external;
849 
850     /**
851      * @notice Claim all comp accrued by the holders
852      * @param holders The addresses to claim COMP for
853      * @param cTokens The list of markets to claim COMP in
854      * @param borrowers Whether or not to claim COMP earned by borrowing
855      * @param suppliers Whether or not to claim COMP earned by supplying
856      */
857     function claimComp(address[] memory holders, ICToken[] memory cTokens, bool borrowers, bool suppliers) external;
858 
859     /// @notice The portion of compRate that each market currently receives
860     function compSpeeds(address cToken) external view returns (uint256);
861 
862     /**
863      * @notice Return the address of the COMP token
864      * @return The address of COMP
865      */
866     function getCompAddress() external view returns (address);
867 }
868 
869 // 
870 interface IContinuousRewardToken {
871   /// @notice Emitted when a user supplies underlying token
872   event Supply(address indexed sender, address indexed receiver, uint256 amount);
873   /// @notice Emitted when a CRT token holder redeems balance
874   event Redeem(address indexed sender, address indexed receiver, uint256 amount);
875   /// @notice Emitted when current or previous reward owners claim their rewards
876   event Claim(address indexed sender, address indexed receiver, address indexed rewardToken, uint256 amount);
877   /// @notice Emitted when an admin changes current reward owner
878   event DelegateUpdated(address indexed oldDelegate, address indexed newDelegate);
879   /// @notice Emitted when an admin role is transferred by current admin
880   event AdminTransferred(address indexed oldAdmin, address indexed newAdmin);
881 
882   /**
883    * @notice The address of underlying token
884    * @return underlying token
885    */
886   function underlying() external view returns (address);
887 
888   /**
889    * @notice Reward tokens that may be accrued as rewards
890    * @return Exhaustive list of all reward token addresses
891    */
892   function rewardTokens() external view returns (address[] memory);
893 
894   /**
895    * @notice Balance of accrued reward token for account
896    * @param rewardToken Reward token address
897    * @return Balance of accrued reward token for account
898    */
899   function balanceOfReward(address rewardToken, address account) external view returns (uint256);
900 
901   /**
902    * @notice Annual Percentage Reward for the specific reward token. Measured in relation to the base units of the underlying asset vs base units of the accrued reward token.
903    * @param rewardToken Reward token address
904    * @return APY times 10^18
905    */
906   function rate(address rewardToken) external view returns (uint256);
907 
908   /**
909    * @notice Supply a specified amount of underlying tokens and receive back an equivalent quantity of CB-CR-XX-XX tokens
910    * @param receiver Account to credit CB-CR-XX-XX tokens to
911    * @param amount Amount of underlying token to supply
912    */
913   function supply(
914     address receiver,
915     uint256 amount
916   ) external;
917 
918   /**
919    * @notice Redeem a specified amount of underlying tokens by burning an equivalent quantity of CB-CR-XX-XX tokens. Does not redeem reward tokens
920    * @param receiver Account to credit underlying tokens to
921    * @param amount Amount of underlying token to redeem
922    */
923   function redeem(
924     address receiver,
925     uint256 amount
926   ) external;
927 
928   /**
929    * @notice Claim accrued reward in one or reward tokens
930    * @dev All params must have the same array length
931    * @param receivers List of accounts to credit claimed tokens to
932    * @param tokens Reward token addresses
933    * @param amounts Amounts of each reward token to claim
934    */
935   function claim(
936     address[] memory receivers,
937     address[] memory tokens,
938     uint256[] memory amounts
939   ) external;
940 
941   /**
942    * @notice Atomic redeem and claim in a single transaction
943    * @dev receivers.length[0] corresponds to the address that the underlying token is redeemed to. receivers.length[1:n-1] hold the to addresses for the reward tokens respectively.
944    * @param receivers       List of accounts to credit tokens to
945    * @param amounts         List of amounts to credit
946    * @param claimTokens     Reward token addresses
947    */
948   function redeemAndClaim(
949     address[] calldata receivers,
950     uint256[] calldata amounts,
951     address[] calldata claimTokens
952   ) external;
953 
954   /**
955    * @notice Snapshots reward owner balance and update reward owner address
956    * @dev Only callable by admin
957    * @param newDelegate New reward owner address
958    */
959   function updateDelegate(address newDelegate) external;
960 
961   /**
962    * @notice Get the current delegate (receiver of rewards)
963    * @return the address of the current delegate
964    */
965   function delegate() external view returns (address);
966 
967   /**
968    * @notice Get the current admin
969    * @return the address of the current admin
970    */
971   function admin() external view returns (address);
972 
973   /**
974    * @notice Updates the admin address
975    * @dev Only callable by admin
976    * @param newAdmin New admin address
977    */
978   function transferAdmin(address newAdmin) external;
979 }
980 
981 // 
982 /**
983  * @title ContinuousRewardToken contract
984  * @notice ERC20 token which wraps underlying protocol rewards
985  * @author
986  */
987 abstract contract ContinuousRewardToken is ERC20, IContinuousRewardToken {
988   using SafeMath for uint256;
989   using SafeERC20 for IERC20;
990 
991   /// @notice The address of underlying token
992   address public override underlying;
993   /// @notice The admin of reward token
994   address public override admin;
995   /// @notice The current owner of all rewards
996   address public override delegate;
997   /// @notice Unclaimed rewards of all previous owners: reward token => (owner => amount)
998   mapping(address => mapping(address => uint256)) public unclaimedRewards;
999   /// @notice Total amount of unclaimed rewards: (reward token => amount)
1000   mapping(address => uint256) public totalUnclaimedRewards;
1001 
1002   /**
1003    * @notice Construct a new Continuous reward token
1004    * @param _underlying The address of underlying token
1005    * @param _delegate The address of reward owner
1006    */
1007   constructor(address _underlying, address _delegate) public {
1008     admin = msg.sender;
1009     require(_underlying != address(0), "ContinuousRewardToken: invalid underlying address");
1010     require(_delegate != address(0), "ContinuousRewardToken: invalid delegate address");
1011 
1012     delegate = _delegate;
1013     underlying = _underlying;
1014   }
1015 
1016   /**
1017    * @notice Supply a specified amount of underlying tokens and receive back an equivalent quantity of CB-CR-XX-XX tokens
1018    * @param receiver Account to credit CB-CR-XX-XX tokens to
1019    * @param amount Amount of underlying token to supply
1020    */
1021   function supply(address receiver, uint256 amount) override external {
1022     IERC20(underlying).safeTransferFrom(msg.sender, address(this), amount);
1023 
1024     _mint(receiver, amount);
1025     _supply(amount);
1026 
1027     emit Supply(msg.sender, receiver, amount);
1028   }
1029 
1030   function _supply(uint256 amount) virtual internal;
1031 
1032   /**
1033    * @notice Reward tokens that may be accrued as rewards
1034    * @return Exhaustive list of all reward token addresses
1035    */
1036   function rewardTokens() override external view returns (address[] memory) {
1037     return _rewardTokens();
1038   }
1039 
1040   function _rewardTokens() virtual internal view returns (address[] memory);
1041 
1042   /**
1043    * @notice Amount of reward for the given reward token
1044    * @param rewardToken The address of reward token
1045    * @param account The account for which reward balance is checked
1046    * @return reward balance of token the specified account has
1047    */
1048   function balanceOfReward(address rewardToken, address account) override public view returns (uint256) {
1049     if (account == delegate) {
1050       return _balanceOfReward(rewardToken).sub(totalUnclaimedRewards[rewardToken]);
1051     }
1052     return unclaimedRewards[rewardToken][account];
1053   }
1054 
1055   function _balanceOfReward(address rewardToken) virtual internal view returns (uint256);
1056 
1057   /**
1058    * @notice Redeem a specified amount of underlying tokens by burning an equivalent quantity of CB-CR-XX-XX tokens. Does not redeem reward tokens
1059    * @param receiver Account to credit underlying tokens to
1060    * @param amount Amount of underlying token to redeem
1061    */
1062   function redeem(
1063     address receiver,
1064     uint256 amount
1065   ) override public {
1066     _burn(msg.sender, amount);
1067     _redeem(amount);
1068 
1069     IERC20(underlying).safeTransfer(receiver, amount);
1070 
1071     emit Redeem(msg.sender, receiver, amount);
1072   }
1073 
1074   function _redeem(uint256 amount) virtual internal;
1075 
1076   /**
1077    * @notice Claim accrued reward in one or more reward tokens
1078    * @dev All params must have the same array length
1079    * @param receivers List of accounts to credit claimed tokens to
1080    * @param tokens Reward token addresses
1081    * @param amounts Amounts of each reward token to claim
1082    */
1083   function claim(
1084     address[] calldata receivers,
1085     address[] calldata tokens,
1086     uint256[] calldata amounts
1087   ) override public {
1088     require(receivers.length == tokens.length && receivers.length == amounts.length, "ContinuousRewardToken: lengths dont match");
1089 
1090     for (uint256 i = 0; i < receivers.length; i++) {
1091       address receiver = receivers[i];
1092       address claimToken = tokens[i];
1093       uint256 amount = amounts[i];
1094       uint256 rewardBalance = balanceOfReward(claimToken, msg.sender);
1095 
1096       uint256 claimAmount = amount == uint256(-1) ? rewardBalance : amount;
1097       require(rewardBalance >= claimAmount, "ContinuousRewardToken: insufficient claimable");
1098 
1099       // If caller is one of previous owners, update unclaimed rewards data
1100       if (msg.sender != delegate) {
1101         unclaimedRewards[claimToken][msg.sender] = rewardBalance.sub(claimAmount);
1102         totalUnclaimedRewards[claimToken] = totalUnclaimedRewards[claimToken].sub(claimAmount);
1103       }
1104 
1105       _claim(claimToken, claimAmount);
1106 
1107       IERC20(claimToken).safeTransfer(receiver, claimAmount);
1108 
1109       emit Claim(msg.sender, receiver, claimToken, claimAmount);
1110     }
1111   }
1112 
1113   function _claim(address claimToken, uint256 amount) virtual internal;
1114 
1115   /**
1116    * @notice Atomic redeem and claim in a single transaction
1117    * @dev receivers[0] corresponds to the address that the underlying token is redeemed to. receivers[1:n-1] hold the to addresses for the reward tokens respectively.
1118    * @param receivers       List of accounts to credit tokens to
1119    * @param amounts         List of amounts to credit
1120    * @param claimTokens     Reward token addresses
1121    */
1122   function redeemAndClaim(
1123     address[] calldata receivers,
1124     uint256[] calldata amounts,
1125     address[] calldata claimTokens
1126   ) override external {
1127     redeem(receivers[0], amounts[0]);
1128     claim(receivers[1:], claimTokens, amounts[1:]);
1129   }
1130 
1131   /**
1132    * @notice Updates reward owner address
1133    * @dev Only callable by admin
1134    * @param newDelegate New reward owner address
1135    */
1136   function updateDelegate(address newDelegate) override external onlyAdmin {
1137     require(newDelegate != delegate, "ContinuousRewardToken: new reward owner is the same as old one");
1138     require(newDelegate != address(0), "ContinuousRewardToken: invalid new delegate address");
1139 
1140     address oldDelegate = delegate;
1141 
1142     address[] memory allRewardTokens = _rewardTokens();
1143     for (uint256 i = 0; i < allRewardTokens.length; i++) {
1144       address rewardToken = allRewardTokens[i];
1145 
1146       uint256 rewardBalance = balanceOfReward(rewardToken, oldDelegate);
1147       unclaimedRewards[rewardToken][oldDelegate] = rewardBalance;
1148       totalUnclaimedRewards[rewardToken] = totalUnclaimedRewards[rewardToken].add(rewardBalance);
1149 
1150       // If new owner used to be reward owner in the past, transfer back his unclaimed rewards to himself
1151       uint256 prevBalance = unclaimedRewards[rewardToken][newDelegate];
1152       if (prevBalance > 0) {
1153         unclaimedRewards[rewardToken][newDelegate] = 0;
1154         totalUnclaimedRewards[rewardToken] = totalUnclaimedRewards[rewardToken].sub(prevBalance);
1155       }
1156     }
1157 
1158     delegate = newDelegate;
1159 
1160     emit DelegateUpdated(oldDelegate, newDelegate);
1161   }
1162 
1163   /**
1164    * @notice Updates the admin address
1165    * @dev Only callable by admin
1166    * @param newAdmin New admin address
1167    */
1168   function transferAdmin(address newAdmin) override external onlyAdmin {
1169     require(newAdmin != admin, "ContinuousRewardToken: new admin is the same as old one");
1170     address previousAdmin = admin;
1171 
1172     admin = newAdmin;
1173 
1174     emit AdminTransferred(previousAdmin, newAdmin);
1175   }
1176 
1177   modifier onlyAdmin {
1178     require(msg.sender == admin, "ContinuousRewardToken: not an admin");
1179     _;
1180   }
1181 }
1182 
1183 // 
1184 /**
1185  * @title CompoundRewardToken contract
1186  * @notice ERC20 token which wraps Compound underlying and COMP rewards
1187  * @author
1188  */
1189 contract CompoundRewardToken is ContinuousRewardToken {
1190   using SafeMath for uint256;
1191   using SafeERC20 for IERC20;
1192 
1193   uint256 constant private BASE = 1e18;
1194   uint256 constant private DAYS_PER_YEAR = 365;
1195   uint256 constant private BLOCKS_PER_DAY = 5760;// at a rate of 15 seconds per block, https://github.com/compound-finance/compound-protocol/blob/23eac9425accafb82551777c93896ee7678a85a3/contracts/JumpRateModel.sol#L18
1196   uint256 constant private BLOCKS_PER_YEAR = BLOCKS_PER_DAY * DAYS_PER_YEAR;
1197 
1198   /// @notice The address of cToken contract
1199   ICToken public cToken;
1200   /// @notice The address of COMP token
1201   address public comp;
1202 
1203   /**
1204    * @notice Construct a new Compound reward token
1205    * @param name ERC-20 name of this token
1206    * @param symbol ERC-20 symbol of this token
1207    * @param _cToken The address of cToken contract
1208    * @param delegate The address of reward owner
1209    */
1210   constructor(
1211     string memory name,
1212     string memory symbol,
1213     ICToken _cToken,
1214     address delegate
1215   ) ERC20(name, symbol) ContinuousRewardToken(_cToken.underlying(), delegate) public {
1216     cToken = _cToken;
1217     comp = cToken.comptroller().getCompAddress();
1218 
1219     // This contract doesn't support cComp or cEther, use special case contract for them
1220     require(underlying != comp, "CompoundRewardToken: does not support cComp usecase");
1221 
1222     IERC20(underlying).safeApprove(address(cToken), uint256(-1));
1223   }
1224 
1225   function _rewardTokens() override internal view returns (address[] memory) {
1226     address[] memory tokens = new address[](2);
1227     (tokens[0], tokens[1]) = (underlying, comp);
1228     return tokens;
1229   }
1230 
1231   function _balanceOfReward(address rewardToken) override internal view returns (uint256) {
1232     require(rewardToken == underlying || rewardToken == comp, "CompoundRewardToken: not reward token");
1233     if (rewardToken == underlying) {
1234       // get the value of this contract's cTokens in the underlying, and subtract total CRT mint amount to get interest
1235       uint256 underlyingBalance = balanceOfCTokenUnderlying(address(this));
1236       uint256 totalSupply = totalSupply();
1237       // Due to rounding errors, it is possible the total supply is greater than the underlying balance by 1 wei, return 0 in this case
1238       // This is a transient case which will resolve itself once rewards are earned
1239       return totalSupply > underlyingBalance ? 0 : underlyingBalance.sub(totalSupply);
1240     } else {
1241       return getCompRewards();
1242     }
1243   }
1244 
1245   /**
1246    * @notice Annual Percentage Reward for the specific reward token. Measured in relation to the base units of the underlying asset vs base units of the accrued reward token.
1247    * @param rewardToken Reward token address
1248    * @dev Underlying asset rate is an APY, Comp rate is an APR
1249    * @return APY times 10^18
1250    */
1251   function rate(address rewardToken) override external view returns (uint256) {
1252     require(rewardToken == underlying || rewardToken == comp, "CompoundRewardToken: not reward token");
1253     if (rewardToken == underlying) {
1254       return getUnderlyingRate();
1255     } else {
1256       return getCompRate();
1257     }
1258   }
1259 
1260   function _supply(uint256 amount) override internal {
1261     require(cToken.mint(amount) == 0, "CompoundRewardToken: minting cToken failed");
1262   }
1263 
1264   function _redeem(uint256 amount) override internal {
1265     require(cToken.redeemUnderlying(amount) == 0, "CompoundRewardToken: redeeming cToken failed");
1266   }
1267 
1268   function _claim(address claimToken, uint256 amount) override internal {
1269     require(claimToken == underlying || claimToken == comp, "CompoundRewardToken: not reward token");
1270     if (claimToken == underlying) {
1271       require(cToken.redeemUnderlying(amount) == 0, "CompoundRewardToken: redeemUnderlying failed");
1272     } else {
1273       claimComp();
1274     }
1275   }
1276 
1277   /*** Compound Interface ***/
1278 
1279   //@dev Only shows the COMP accrued up until the last interaction with the cToken.
1280   function getCompRewards() internal view returns (uint256) {
1281     uint256 compAccrued = cToken.comptroller().compAccrued(address(this));
1282     return IERC20(comp).balanceOf(address(this)).add(compAccrued);
1283   }
1284 
1285   function claimComp() internal {
1286     ICToken[] memory cTokens = new ICToken[](1);
1287     cTokens[0] = cToken;
1288     cToken.comptroller().claimComp(address(this), cTokens);
1289   }
1290 
1291   function getUnderlyingRate() internal view returns (uint256) {
1292     uint256 supplyRatePerBlock = cToken.supplyRatePerBlock();
1293     return rateToAPY(supplyRatePerBlock);
1294   }
1295 
1296   // @dev APY = (1 + rate) ^ 365 - 1
1297   function rateToAPY(uint apr) internal pure returns (uint256) {
1298     uint256 ratePerDay = apr.mul(BLOCKS_PER_DAY).add(BASE);
1299     uint256 acc = ratePerDay;
1300     for (uint256 i = 1; i < DAYS_PER_YEAR; i++) {
1301       acc = acc.mul(ratePerDay).div(BASE);
1302     }
1303     return acc.sub(BASE);
1304   }
1305 
1306   function getCompRate() internal view returns (uint256) {
1307     IComptroller comptroller = cToken.comptroller();
1308     uint256 compForMarketPerYear = comptroller.compSpeeds(address(cToken)).mul(BLOCKS_PER_YEAR);
1309     uint256 exchangeRate = cToken.exchangeRateStored();
1310     uint256 totalSupply = cToken.totalSupply();
1311     uint256 totalUnderlying = totalSupply.mul(exchangeRate).div(BASE);
1312     return compForMarketPerYear.mul(BASE).div(totalUnderlying);
1313   }
1314 
1315   // @dev returns the amount of underlying that this contract's cTokens can be redeemed for
1316   function balanceOfCTokenUnderlying(address owner) internal view returns (uint256) {
1317     uint256 exchangeRate = cToken.exchangeRateStored();
1318     uint256 scaledMantissa = exchangeRate.mul(cToken.balanceOf(owner));
1319     // Note: We are not using careful math here as we're performing a division that cannot fail
1320     return scaledMantissa /  BASE;
1321   }
1322 }