1 // SPDX-License-Identifier: MIT
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
164 /**
165  * @dev Collection of functions related to the address type
166  */
167 library Address {
168     /**
169      * @dev Returns true if `account` is a contract.
170      *
171      * [IMPORTANT]
172      * ====
173      * It is unsafe to assume that an address for which this function returns
174      * false is an externally-owned account (EOA) and not a contract.
175      *
176      * Among others, `isContract` will return false for the following
177      * types of addresses:
178      *
179      *  - an externally-owned account
180      *  - a contract in construction
181      *  - an address where a contract will be created
182      *  - an address where a contract lived, but was destroyed
183      * ====
184      */
185     function isContract(address account) internal view returns (bool) {
186         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
187         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
188         // for accounts without code, i.e. `keccak256('')`
189         bytes32 codehash;
190         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
191         // solhint-disable-next-line no-inline-assembly
192         assembly { codehash := extcodehash(account) }
193         return (codehash != accountHash && codehash != 0x0);
194     }
195 
196     /**
197      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
198      * `recipient`, forwarding all available gas and reverting on errors.
199      *
200      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
201      * of certain opcodes, possibly making contracts go over the 2300 gas limit
202      * imposed by `transfer`, making them unable to receive funds via
203      * `transfer`. {sendValue} removes this limitation.
204      *
205      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
206      *
207      * IMPORTANT: because control is transferred to `recipient`, care must be
208      * taken to not create reentrancy vulnerabilities. Consider using
209      * {ReentrancyGuard} or the
210      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
211      */
212     function sendValue(address payable recipient, uint256 amount) internal {
213         require(address(this).balance >= amount, "Address: insufficient balance");
214 
215         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
216         (bool success, ) = recipient.call{ value: amount }("");
217         require(success, "Address: unable to send value, recipient may have reverted");
218     }
219 
220     /**
221      * @dev Performs a Solidity function call using a low level `call`. A
222      * plain`call` is an unsafe replacement for a function call: use this
223      * function instead.
224      *
225      * If `target` reverts with a revert reason, it is bubbled up by this
226      * function (like regular Solidity function calls).
227      *
228      * Returns the raw returned data. To convert to the expected return value,
229      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
230      *
231      * Requirements:
232      *
233      * - `target` must be a contract.
234      * - calling `target` with `data` must not revert.
235      *
236      * _Available since v3.1._
237      */
238     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
239       return functionCall(target, data, "Address: low-level call failed");
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
244      * `errorMessage` as a fallback revert reason when `target` reverts.
245      *
246      * _Available since v3.1._
247      */
248     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
249         return _functionCallWithValue(target, data, 0, errorMessage);
250     }
251 
252     /**
253      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
254      * but also transferring `value` wei to `target`.
255      *
256      * Requirements:
257      *
258      * - the calling contract must have an ETH balance of at least `value`.
259      * - the called Solidity function must be `payable`.
260      *
261      * _Available since v3.1._
262      */
263     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
264         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
269      * with `errorMessage` as a fallback revert reason when `target` reverts.
270      *
271      * _Available since v3.1._
272      */
273     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
274         require(address(this).balance >= value, "Address: insufficient balance for call");
275         return _functionCallWithValue(target, data, value, errorMessage);
276     }
277 
278     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
279         require(isContract(target), "Address: call to non-contract");
280 
281         // solhint-disable-next-line avoid-low-level-calls
282         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
283         if (success) {
284             return returndata;
285         } else {
286             // Look for revert reason and bubble it up if present
287             if (returndata.length > 0) {
288                 // The easiest way to bubble the revert reason is using memory via assembly
289 
290                 // solhint-disable-next-line no-inline-assembly
291                 assembly {
292                     let returndata_size := mload(returndata)
293                     revert(add(32, returndata), returndata_size)
294                 }
295             } else {
296                 revert(errorMessage);
297             }
298         }
299     }
300 }
301 
302 // 
303 /*
304  * @dev Provides information about the current execution context, including the
305  * sender of the transaction and its data. While these are generally available
306  * via msg.sender and msg.data, they should not be accessed in such a direct
307  * manner, since when dealing with GSN meta-transactions the account sending and
308  * paying for execution may not be the actual sender (as far as an application
309  * is concerned).
310  *
311  * This contract is only required for intermediate, library-like contracts.
312  */
313 abstract contract Context {
314     function _msgSender() internal view virtual returns (address payable) {
315         return msg.sender;
316     }
317 
318     function _msgData() internal view virtual returns (bytes memory) {
319         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
320         return msg.data;
321     }
322 }
323 
324 // 
325 /**
326  * @dev Interface of the ERC20 standard as defined in the EIP.
327  */
328 interface IERC20 {
329     /**
330      * @dev Returns the amount of tokens in existence.
331      */
332     function totalSupply() external view returns (uint256);
333 
334     /**
335      * @dev Returns the amount of tokens owned by `account`.
336      */
337     function balanceOf(address account) external view returns (uint256);
338 
339     /**
340      * @dev Moves `amount` tokens from the caller's account to `recipient`.
341      *
342      * Returns a boolean value indicating whether the operation succeeded.
343      *
344      * Emits a {Transfer} event.
345      */
346     function transfer(address recipient, uint256 amount) external returns (bool);
347 
348     /**
349      * @dev Returns the remaining number of tokens that `spender` will be
350      * allowed to spend on behalf of `owner` through {transferFrom}. This is
351      * zero by default.
352      *
353      * This value changes when {approve} or {transferFrom} are called.
354      */
355     function allowance(address owner, address spender) external view returns (uint256);
356 
357     /**
358      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
359      *
360      * Returns a boolean value indicating whether the operation succeeded.
361      *
362      * IMPORTANT: Beware that changing an allowance with this method brings the risk
363      * that someone may use both the old and the new allowance by unfortunate
364      * transaction ordering. One possible solution to mitigate this race
365      * condition is to first reduce the spender's allowance to 0 and set the
366      * desired value afterwards:
367      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
368      *
369      * Emits an {Approval} event.
370      */
371     function approve(address spender, uint256 amount) external returns (bool);
372 
373     /**
374      * @dev Moves `amount` tokens from `sender` to `recipient` using the
375      * allowance mechanism. `amount` is then deducted from the caller's
376      * allowance.
377      *
378      * Returns a boolean value indicating whether the operation succeeded.
379      *
380      * Emits a {Transfer} event.
381      */
382     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
383 
384     /**
385      * @dev Emitted when `value` tokens are moved from one account (`from`) to
386      * another (`to`).
387      *
388      * Note that `value` may be zero.
389      */
390     event Transfer(address indexed from, address indexed to, uint256 value);
391 
392     /**
393      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
394      * a call to {approve}. `value` is the new allowance.
395      */
396     event Approval(address indexed owner, address indexed spender, uint256 value);
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
701  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
702  */
703 abstract contract ERC20Capped is ERC20 {
704     uint256 private _cap;
705 
706     /**
707      * @dev Sets the value of the `cap`. This value is immutable, it can only be
708      * set once during construction.
709      */
710     constructor (uint256 cap) public {
711         require(cap > 0, "ERC20Capped: cap is 0");
712         _cap = cap;
713     }
714 
715     /**
716      * @dev Returns the cap on the token's total supply.
717      */
718     function cap() public view returns (uint256) {
719         return _cap;
720     }
721 
722     /**
723      * @dev See {ERC20-_beforeTokenTransfer}.
724      *
725      * Requirements:
726      *
727      * - minted tokens must not cause the total supply to go over the cap.
728      */
729     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
730         super._beforeTokenTransfer(from, to, amount);
731 
732         if (from == address(0)) { // When minting tokens
733             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
734         }
735     }
736 }
737 
738 // 
739 contract Honey is ERC20Capped {
740     using Address for address;
741     using SafeMath for uint;
742 
743     address public governance;
744 
745     constructor (uint256 cap) public
746     ERC20("Honey Finance", "HONEY")
747     ERC20Capped(cap)
748     {
749         governance = msg.sender;
750     }
751 
752     function mint(address account, uint amount) public {
753         require(msg.sender == governance, "!governance");
754         _mint(account, amount);
755     }
756 
757     function setGovernance(address _governance) public {
758         require(msg.sender == governance, "!governance");
759         governance = _governance;
760     }
761 }