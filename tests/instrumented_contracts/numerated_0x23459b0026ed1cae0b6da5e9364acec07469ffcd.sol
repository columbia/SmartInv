1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.3/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.3/contracts/GSN/Context.sol
6 
7 
8 
9 pragma solidity >=0.6.0 <0.8.0;
10 
11 /*
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with GSN meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 
33 pragma solidity >=0.6.0 <0.8.0;
34 
35 /**
36  * @dev Wrappers over Solidity's arithmetic operations with added overflow
37  * checks.
38  *
39  * Arithmetic operations in Solidity wrap on overflow. This can easily result
40  * in bugs, because programmers usually assume that an overflow raises an
41  * error, which is the standard behavior in high level programming languages.
42  * `SafeMath` restores this intuition by reverting the transaction when an
43  * operation overflows.
44  *
45  * Using this library instead of the unchecked operations eliminates an entire
46  * class of bugs, so it's recommended to use it always.
47  */
48 library SafeMath {
49     /**
50      * @dev Returns the addition of two unsigned integers, reverting on
51      * overflow.
52      *
53      * Counterpart to Solidity's `+` operator.
54      *
55      * Requirements:
56      *
57      * - Addition cannot overflow.
58      */
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a + b;
61         require(c >= a, "SafeMath: addition overflow");
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the subtraction of two unsigned integers, reverting on
68      * overflow (when the result is negative).
69      *
70      * Counterpart to Solidity's `-` operator.
71      *
72      * Requirements:
73      *
74      * - Subtraction cannot overflow.
75      */
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         return sub(a, b, "SafeMath: subtraction overflow");
78     }
79 
80     /**
81      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
82      * overflow (when the result is negative).
83      *
84      * Counterpart to Solidity's `-` operator.
85      *
86      * Requirements:
87      *
88      * - Subtraction cannot overflow.
89      */
90     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
91         require(b <= a, errorMessage);
92         uint256 c = a - b;
93 
94         return c;
95     }
96 
97     /**
98      * @dev Returns the multiplication of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `*` operator.
102      *
103      * Requirements:
104      *
105      * - Multiplication cannot overflow.
106      */
107     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
109         // benefit is lost if 'b' is also tested.
110         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
111         if (a == 0) {
112             return 0;
113         }
114 
115         uint256 c = a * b;
116         require(c / a == b, "SafeMath: multiplication overflow");
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the integer division of two unsigned integers. Reverts on
123      * division by zero. The result is rounded towards zero.
124      *
125      * Counterpart to Solidity's `/` operator. Note: this function uses a
126      * `revert` opcode (which leaves remaining gas untouched) while Solidity
127      * uses an invalid opcode to revert (consuming all remaining gas).
128      *
129      * Requirements:
130      *
131      * - The divisor cannot be zero.
132      */
133     function div(uint256 a, uint256 b) internal pure returns (uint256) {
134         return div(a, b, "SafeMath: division by zero");
135     }
136 
137     /**
138      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
139      * division by zero. The result is rounded towards zero.
140      *
141      * Counterpart to Solidity's `/` operator. Note: this function uses a
142      * `revert` opcode (which leaves remaining gas untouched) while Solidity
143      * uses an invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      *
147      * - The divisor cannot be zero.
148      */
149     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         require(b > 0, errorMessage);
151         uint256 c = a / b;
152         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
159      * Reverts when dividing by zero.
160      *
161      * Counterpart to Solidity's `%` operator. This function uses a `revert`
162      * opcode (which leaves remaining gas untouched) while Solidity uses an
163      * invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      *
167      * - The divisor cannot be zero.
168      */
169     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
170         return mod(a, b, "SafeMath: modulo by zero");
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts with custom message when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
186         require(b != 0, errorMessage);
187         return a % b;
188     }
189 }
190 
191 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.3/contracts/token/ERC20/IERC20.sol
192 
193 
194 
195 pragma solidity >=0.6.0 <0.8.0;
196 
197 /**
198  * @dev Interface of the ERC20 standard as defined in the EIP.
199  */
200 interface IERC20 {
201     /**
202      * @dev Returns the amount of tokens in existence.
203      */
204     function totalSupply() external view returns (uint256);
205 
206     /**
207      * @dev Returns the amount of tokens owned by `account`.
208      */
209     function balanceOf(address account) external view returns (uint256);
210 
211     /**
212      * @dev Moves `amount` tokens from the caller's account to `recipient`.
213      *
214      * Returns a boolean value indicating whether the operation succeeded.
215      *
216      * Emits a {Transfer} event.
217      */
218     function transfer(address recipient, uint256 amount) external returns (bool);
219 
220     /**
221      * @dev Returns the remaining number of tokens that `spender` will be
222      * allowed to spend on behalf of `owner` through {transferFrom}. This is
223      * zero by default.
224      *
225      * This value changes when {approve} or {transferFrom} are called.
226      */
227     function allowance(address owner, address spender) external view returns (uint256);
228 
229     /**
230      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
231      *
232      * Returns a boolean value indicating whether the operation succeeded.
233      *
234      * IMPORTANT: Beware that changing an allowance with this method brings the risk
235      * that someone may use both the old and the new allowance by unfortunate
236      * transaction ordering. One possible solution to mitigate this race
237      * condition is to first reduce the spender's allowance to 0 and set the
238      * desired value afterwards:
239      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
240      *
241      * Emits an {Approval} event.
242      */
243     function approve(address spender, uint256 amount) external returns (bool);
244 
245     /**
246      * @dev Moves `amount` tokens from `sender` to `recipient` using the
247      * allowance mechanism. `amount` is then deducted from the caller's
248      * allowance.
249      *
250      * Returns a boolean value indicating whether the operation succeeded.
251      *
252      * Emits a {Transfer} event.
253      */
254     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
255 
256     /**
257      * @dev Emitted when `value` tokens are moved from one account (`from`) to
258      * another (`to`).
259      *
260      * Note that `value` may be zero.
261      */
262     event Transfer(address indexed from, address indexed to, uint256 value);
263 
264     /**
265      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
266      * a call to {approve}. `value` is the new allowance.
267      */
268     event Approval(address indexed owner, address indexed spender, uint256 value);
269 }
270 
271 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.3/contracts/token/ERC20/ERC20.sol
272 
273 
274 
275 pragma solidity >=0.6.0 <0.8.0;
276 
277 
278 
279 
280 /**
281  * @dev Implementation of the {IERC20} interface.
282  *
283  * This implementation is agnostic to the way tokens are created. This means
284  * that a supply mechanism has to be added in a derived contract using {_mint}.
285  * For a generic mechanism see {ERC20PresetMinterPauser}.
286  *
287  * TIP: For a detailed writeup see our guide
288  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
289  * to implement supply mechanisms].
290  *
291  * We have followed general OpenZeppelin guidelines: functions revert instead
292  * of returning `false` on failure. This behavior is nonetheless conventional
293  * and does not conflict with the expectations of ERC20 applications.
294  *
295  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
296  * This allows applications to reconstruct the allowance for all accounts just
297  * by listening to said events. Other implementations of the EIP may not emit
298  * these events, as it isn't required by the specification.
299  *
300  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
301  * functions have been added to mitigate the well-known issues around setting
302  * allowances. See {IERC20-approve}.
303  */
304 contract ERC20 is Context, IERC20 {
305     using SafeMath for uint256;
306 
307     mapping (address => uint256) private _balances;
308 
309     mapping (address => mapping (address => uint256)) private _allowances;
310 
311     uint256 private _totalSupply;
312 
313     string private _name;
314     string private _symbol;
315     uint8 private _decimals;
316 
317     /**
318      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
319      * a default value of 18.
320      *
321      * To select a different value for {decimals}, use {_setupDecimals}.
322      *
323      * All three of these values are immutable: they can only be set once during
324      * construction.
325      */
326     constructor (string memory name_, string memory symbol_) public {
327         _name = name_;
328         _symbol = symbol_;
329         _decimals = 18;
330     }
331 
332     /**
333      * @dev Returns the name of the token.
334      */
335     function name() public view returns (string memory) {
336         return _name;
337     }
338 
339     /**
340      * @dev Returns the symbol of the token, usually a shorter version of the
341      * name.
342      */
343     function symbol() public view returns (string memory) {
344         return _symbol;
345     }
346 
347     /**
348      * @dev Returns the number of decimals used to get its user representation.
349      * For example, if `decimals` equals `2`, a balance of `505` tokens should
350      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
351      *
352      * Tokens usually opt for a value of 18, imitating the relationship between
353      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
354      * called.
355      *
356      * NOTE: This information is only used for _display_ purposes: it in
357      * no way affects any of the arithmetic of the contract, including
358      * {IERC20-balanceOf} and {IERC20-transfer}.
359      */
360     function decimals() public view returns (uint8) {
361         return _decimals;
362     }
363 
364     /**
365      * @dev See {IERC20-totalSupply}.
366      */
367     function totalSupply() public view override returns (uint256) {
368         return _totalSupply;
369     }
370 
371     /**
372      * @dev See {IERC20-balanceOf}.
373      */
374     function balanceOf(address account) public view override returns (uint256) {
375         return _balances[account];
376     }
377 
378     /**
379      * @dev See {IERC20-transfer}.
380      *
381      * Requirements:
382      *
383      * - `recipient` cannot be the zero address.
384      * - the caller must have a balance of at least `amount`.
385      */
386     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
387         _transfer(_msgSender(), recipient, amount);
388         return true;
389     }
390 
391     /**
392      * @dev See {IERC20-allowance}.
393      */
394     function allowance(address owner, address spender) public view virtual override returns (uint256) {
395         return _allowances[owner][spender];
396     }
397 
398     /**
399      * @dev See {IERC20-approve}.
400      *
401      * Requirements:
402      *
403      * - `spender` cannot be the zero address.
404      */
405     function approve(address spender, uint256 amount) public virtual override returns (bool) {
406         _approve(_msgSender(), spender, amount);
407         return true;
408     }
409 
410     /**
411      * @dev See {IERC20-transferFrom}.
412      *
413      * Emits an {Approval} event indicating the updated allowance. This is not
414      * required by the EIP. See the note at the beginning of {ERC20}.
415      *
416      * Requirements:
417      *
418      * - `sender` and `recipient` cannot be the zero address.
419      * - `sender` must have a balance of at least `amount`.
420      * - the caller must have allowance for ``sender``'s tokens of at least
421      * `amount`.
422      */
423     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
424         _transfer(sender, recipient, amount);
425         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
426         return true;
427     }
428 
429     /**
430      * @dev Atomically increases the allowance granted to `spender` by the caller.
431      *
432      * This is an alternative to {approve} that can be used as a mitigation for
433      * problems described in {IERC20-approve}.
434      *
435      * Emits an {Approval} event indicating the updated allowance.
436      *
437      * Requirements:
438      *
439      * - `spender` cannot be the zero address.
440      */
441     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
442         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
443         return true;
444     }
445 
446     /**
447      * @dev Atomically decreases the allowance granted to `spender` by the caller.
448      *
449      * This is an alternative to {approve} that can be used as a mitigation for
450      * problems described in {IERC20-approve}.
451      *
452      * Emits an {Approval} event indicating the updated allowance.
453      *
454      * Requirements:
455      *
456      * - `spender` cannot be the zero address.
457      * - `spender` must have allowance for the caller of at least
458      * `subtractedValue`.
459      */
460     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
461         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
462         return true;
463     }
464 
465     /**
466      * @dev Moves tokens `amount` from `sender` to `recipient`.
467      *
468      * This is internal function is equivalent to {transfer}, and can be used to
469      * e.g. implement automatic token fees, slashing mechanisms, etc.
470      *
471      * Emits a {Transfer} event.
472      *
473      * Requirements:
474      *
475      * - `sender` cannot be the zero address.
476      * - `recipient` cannot be the zero address.
477      * - `sender` must have a balance of at least `amount`.
478      */
479     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
480         require(sender != address(0), "ERC20: transfer from the zero address");
481         require(recipient != address(0), "ERC20: transfer to the zero address");
482 
483         _beforeTokenTransfer(sender, recipient, amount);
484 
485         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
486         _balances[recipient] = _balances[recipient].add(amount);
487         emit Transfer(sender, recipient, amount);
488     }
489 
490     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
491      * the total supply.
492      *
493      * Emits a {Transfer} event with `from` set to the zero address.
494      *
495      * Requirements:
496      *
497      * - `to` cannot be the zero address.
498      */
499     function _mint(address account, uint256 amount) internal virtual {
500         require(account != address(0), "ERC20: mint to the zero address");
501 
502         _beforeTokenTransfer(address(0), account, amount);
503 
504         _totalSupply = _totalSupply.add(amount);
505         _balances[account] = _balances[account].add(amount);
506         emit Transfer(address(0), account, amount);
507     }
508 
509     /**
510      * @dev Destroys `amount` tokens from `account`, reducing the
511      * total supply.
512      *
513      * Emits a {Transfer} event with `to` set to the zero address.
514      *
515      * Requirements:
516      *
517      * - `account` cannot be the zero address.
518      * - `account` must have at least `amount` tokens.
519      */
520     function _burn(address account, uint256 amount) internal virtual {
521         require(account != address(0), "ERC20: burn from the zero address");
522 
523         _beforeTokenTransfer(account, address(0), amount);
524 
525         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
526         _totalSupply = _totalSupply.sub(amount);
527         emit Transfer(account, address(0), amount);
528     }
529 
530     /**
531      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
532      *
533      * This internal function is equivalent to `approve`, and can be used to
534      * e.g. set automatic allowances for certain subsystems, etc.
535      *
536      * Emits an {Approval} event.
537      *
538      * Requirements:
539      *
540      * - `owner` cannot be the zero address.
541      * - `spender` cannot be the zero address.
542      */
543     function _approve(address owner, address spender, uint256 amount) internal virtual {
544         require(owner != address(0), "ERC20: approve from the zero address");
545         require(spender != address(0), "ERC20: approve to the zero address");
546 
547         _allowances[owner][spender] = amount;
548         emit Approval(owner, spender, amount);
549     }
550 
551     /**
552      * @dev Sets {decimals} to a value other than the default one of 18.
553      *
554      * WARNING: This function should only be called from the constructor. Most
555      * applications that interact with token contracts will not expect
556      * {decimals} to ever change, and may work incorrectly if it does.
557      */
558     function _setupDecimals(uint8 decimals_) internal {
559         _decimals = decimals_;
560     }
561 
562     /**
563      * @dev Hook that is called before any transfer of tokens. This includes
564      * minting and burning.
565      *
566      * Calling conditions:
567      *
568      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
569      * will be to transferred to `to`.
570      * - when `from` is zero, `amount` tokens will be minted for `to`.
571      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
572      * - `from` and `to` are never both zero.
573      *
574      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
575      */
576     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
577 }
578 
579 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.3/contracts/utils/Address.sol
580 
581 
582 
583 pragma solidity >=0.6.2 <0.8.0;
584 
585 /**
586  * @dev Collection of functions related to the address type
587  */
588 library Address {
589     /**
590      * @dev Returns true if `account` is a contract.
591      *
592      * [IMPORTANT]
593      * ====
594      * It is unsafe to assume that an address for which this function returns
595      * false is an externally-owned account (EOA) and not a contract.
596      *
597      * Among others, `isContract` will return false for the following
598      * types of addresses:
599      *
600      *  - an externally-owned account
601      *  - a contract in construction
602      *  - an address where a contract will be created
603      *  - an address where a contract lived, but was destroyed
604      * ====
605      */
606     function isContract(address account) internal view returns (bool) {
607         // This method relies on extcodesize, which returns 0 for contracts in
608         // construction, since the code is only stored at the end of the
609         // constructor execution.
610 
611         uint256 size;
612         // solhint-disable-next-line no-inline-assembly
613         assembly { size := extcodesize(account) }
614         return size > 0;
615     }
616 
617     /**
618      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
619      * `recipient`, forwarding all available gas and reverting on errors.
620      *
621      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
622      * of certain opcodes, possibly making contracts go over the 2300 gas limit
623      * imposed by `transfer`, making them unable to receive funds via
624      * `transfer`. {sendValue} removes this limitation.
625      *
626      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
627      *
628      * IMPORTANT: because control is transferred to `recipient`, care must be
629      * taken to not create reentrancy vulnerabilities. Consider using
630      * {ReentrancyGuard} or the
631      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
632      */
633     function sendValue(address payable recipient, uint256 amount) internal {
634         require(address(this).balance >= amount, "Address: insufficient balance");
635 
636         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
637         (bool success, ) = recipient.call{ value: amount }("");
638         require(success, "Address: unable to send value, recipient may have reverted");
639     }
640 
641     /**
642      * @dev Performs a Solidity function call using a low level `call`. A
643      * plain`call` is an unsafe replacement for a function call: use this
644      * function instead.
645      *
646      * If `target` reverts with a revert reason, it is bubbled up by this
647      * function (like regular Solidity function calls).
648      *
649      * Returns the raw returned data. To convert to the expected return value,
650      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
651      *
652      * Requirements:
653      *
654      * - `target` must be a contract.
655      * - calling `target` with `data` must not revert.
656      *
657      * _Available since v3.1._
658      */
659     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
660       return functionCall(target, data, "Address: low-level call failed");
661     }
662 
663     /**
664      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
665      * `errorMessage` as a fallback revert reason when `target` reverts.
666      *
667      * _Available since v3.1._
668      */
669     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
670         return functionCallWithValue(target, data, 0, errorMessage);
671     }
672 
673     /**
674      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
675      * but also transferring `value` wei to `target`.
676      *
677      * Requirements:
678      *
679      * - the calling contract must have an ETH balance of at least `value`.
680      * - the called Solidity function must be `payable`.
681      *
682      * _Available since v3.1._
683      */
684     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
685         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
686     }
687 
688     /**
689      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
690      * with `errorMessage` as a fallback revert reason when `target` reverts.
691      *
692      * _Available since v3.1._
693      */
694     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
695         require(address(this).balance >= value, "Address: insufficient balance for call");
696         require(isContract(target), "Address: call to non-contract");
697 
698         // solhint-disable-next-line avoid-low-level-calls
699         (bool success, bytes memory returndata) = target.call{ value: value }(data);
700         return _verifyCallResult(success, returndata, errorMessage);
701     }
702 
703     /**
704      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
705      * but performing a static call.
706      *
707      * _Available since v3.3._
708      */
709     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
710         return functionStaticCall(target, data, "Address: low-level static call failed");
711     }
712 
713     /**
714      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
715      * but performing a static call.
716      *
717      * _Available since v3.3._
718      */
719     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
720         require(isContract(target), "Address: static call to non-contract");
721 
722         // solhint-disable-next-line avoid-low-level-calls
723         (bool success, bytes memory returndata) = target.staticcall(data);
724         return _verifyCallResult(success, returndata, errorMessage);
725     }
726 
727     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
728         if (success) {
729             return returndata;
730         } else {
731             // Look for revert reason and bubble it up if present
732             if (returndata.length > 0) {
733                 // The easiest way to bubble the revert reason is using memory via assembly
734 
735                 // solhint-disable-next-line no-inline-assembly
736                 assembly {
737                     let returndata_size := mload(returndata)
738                     revert(add(32, returndata), returndata_size)
739                 }
740             } else {
741                 revert(errorMessage);
742             }
743         }
744     }
745 }
746 
747 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.3/contracts/utils/EnumerableSet.sol
748 
749 
750 
751 pragma solidity >=0.6.0 <0.8.0;
752 
753 /**
754  * @dev Library for managing
755  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
756  * types.
757  *
758  * Sets have the following properties:
759  *
760  * - Elements are added, removed, and checked for existence in constant time
761  * (O(1)).
762  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
763  *
764  * ```
765  * contract Example {
766  *     // Add the library methods
767  *     using EnumerableSet for EnumerableSet.AddressSet;
768  *
769  *     // Declare a set state variable
770  *     EnumerableSet.AddressSet private mySet;
771  * }
772  * ```
773  *
774  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
775  * and `uint256` (`UintSet`) are supported.
776  */
777 library EnumerableSet {
778     // To implement this library for multiple types with as little code
779     // repetition as possible, we write it in terms of a generic Set type with
780     // bytes32 values.
781     // The Set implementation uses private functions, and user-facing
782     // implementations (such as AddressSet) are just wrappers around the
783     // underlying Set.
784     // This means that we can only create new EnumerableSets for types that fit
785     // in bytes32.
786 
787     struct Set {
788         // Storage of set values
789         bytes32[] _values;
790 
791         // Position of the value in the `values` array, plus 1 because index 0
792         // means a value is not in the set.
793         mapping (bytes32 => uint256) _indexes;
794     }
795 
796     /**
797      * @dev Add a value to a set. O(1).
798      *
799      * Returns true if the value was added to the set, that is if it was not
800      * already present.
801      */
802     function _add(Set storage set, bytes32 value) private returns (bool) {
803         if (!_contains(set, value)) {
804             set._values.push(value);
805             // The value is stored at length-1, but we add 1 to all indexes
806             // and use 0 as a sentinel value
807             set._indexes[value] = set._values.length;
808             return true;
809         } else {
810             return false;
811         }
812     }
813 
814     /**
815      * @dev Removes a value from a set. O(1).
816      *
817      * Returns true if the value was removed from the set, that is if it was
818      * present.
819      */
820     function _remove(Set storage set, bytes32 value) private returns (bool) {
821         // We read and store the value's index to prevent multiple reads from the same storage slot
822         uint256 valueIndex = set._indexes[value];
823 
824         if (valueIndex != 0) { // Equivalent to contains(set, value)
825             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
826             // the array, and then remove the last element (sometimes called as 'swap and pop').
827             // This modifies the order of the array, as noted in {at}.
828 
829             uint256 toDeleteIndex = valueIndex - 1;
830             uint256 lastIndex = set._values.length - 1;
831 
832             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
833             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
834 
835             bytes32 lastvalue = set._values[lastIndex];
836 
837             // Move the last value to the index where the value to delete is
838             set._values[toDeleteIndex] = lastvalue;
839             // Update the index for the moved value
840             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
841 
842             // Delete the slot where the moved value was stored
843             set._values.pop();
844 
845             // Delete the index for the deleted slot
846             delete set._indexes[value];
847 
848             return true;
849         } else {
850             return false;
851         }
852     }
853 
854     /**
855      * @dev Returns true if the value is in the set. O(1).
856      */
857     function _contains(Set storage set, bytes32 value) private view returns (bool) {
858         return set._indexes[value] != 0;
859     }
860 
861     /**
862      * @dev Returns the number of values on the set. O(1).
863      */
864     function _length(Set storage set) private view returns (uint256) {
865         return set._values.length;
866     }
867 
868    /**
869     * @dev Returns the value stored at position `index` in the set. O(1).
870     *
871     * Note that there are no guarantees on the ordering of values inside the
872     * array, and it may change when more values are added or removed.
873     *
874     * Requirements:
875     *
876     * - `index` must be strictly less than {length}.
877     */
878     function _at(Set storage set, uint256 index) private view returns (bytes32) {
879         require(set._values.length > index, "EnumerableSet: index out of bounds");
880         return set._values[index];
881     }
882 
883     // Bytes32Set
884 
885     struct Bytes32Set {
886         Set _inner;
887     }
888 
889     /**
890      * @dev Add a value to a set. O(1).
891      *
892      * Returns true if the value was added to the set, that is if it was not
893      * already present.
894      */
895     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
896         return _add(set._inner, value);
897     }
898 
899     /**
900      * @dev Removes a value from a set. O(1).
901      *
902      * Returns true if the value was removed from the set, that is if it was
903      * present.
904      */
905     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
906         return _remove(set._inner, value);
907     }
908 
909     /**
910      * @dev Returns true if the value is in the set. O(1).
911      */
912     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
913         return _contains(set._inner, value);
914     }
915 
916     /**
917      * @dev Returns the number of values in the set. O(1).
918      */
919     function length(Bytes32Set storage set) internal view returns (uint256) {
920         return _length(set._inner);
921     }
922 
923    /**
924     * @dev Returns the value stored at position `index` in the set. O(1).
925     *
926     * Note that there are no guarantees on the ordering of values inside the
927     * array, and it may change when more values are added or removed.
928     *
929     * Requirements:
930     *
931     * - `index` must be strictly less than {length}.
932     */
933     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
934         return _at(set._inner, index);
935     }
936 
937     // AddressSet
938 
939     struct AddressSet {
940         Set _inner;
941     }
942 
943     /**
944      * @dev Add a value to a set. O(1).
945      *
946      * Returns true if the value was added to the set, that is if it was not
947      * already present.
948      */
949     function add(AddressSet storage set, address value) internal returns (bool) {
950         return _add(set._inner, bytes32(uint256(value)));
951     }
952 
953     /**
954      * @dev Removes a value from a set. O(1).
955      *
956      * Returns true if the value was removed from the set, that is if it was
957      * present.
958      */
959     function remove(AddressSet storage set, address value) internal returns (bool) {
960         return _remove(set._inner, bytes32(uint256(value)));
961     }
962 
963     /**
964      * @dev Returns true if the value is in the set. O(1).
965      */
966     function contains(AddressSet storage set, address value) internal view returns (bool) {
967         return _contains(set._inner, bytes32(uint256(value)));
968     }
969 
970     /**
971      * @dev Returns the number of values in the set. O(1).
972      */
973     function length(AddressSet storage set) internal view returns (uint256) {
974         return _length(set._inner);
975     }
976 
977    /**
978     * @dev Returns the value stored at position `index` in the set. O(1).
979     *
980     * Note that there are no guarantees on the ordering of values inside the
981     * array, and it may change when more values are added or removed.
982     *
983     * Requirements:
984     *
985     * - `index` must be strictly less than {length}.
986     */
987     function at(AddressSet storage set, uint256 index) internal view returns (address) {
988         return address(uint256(_at(set._inner, index)));
989     }
990 
991 
992     // UintSet
993 
994     struct UintSet {
995         Set _inner;
996     }
997 
998     /**
999      * @dev Add a value to a set. O(1).
1000      *
1001      * Returns true if the value was added to the set, that is if it was not
1002      * already present.
1003      */
1004     function add(UintSet storage set, uint256 value) internal returns (bool) {
1005         return _add(set._inner, bytes32(value));
1006     }
1007 
1008     /**
1009      * @dev Removes a value from a set. O(1).
1010      *
1011      * Returns true if the value was removed from the set, that is if it was
1012      * present.
1013      */
1014     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1015         return _remove(set._inner, bytes32(value));
1016     }
1017 
1018     /**
1019      * @dev Returns true if the value is in the set. O(1).
1020      */
1021     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1022         return _contains(set._inner, bytes32(value));
1023     }
1024 
1025     /**
1026      * @dev Returns the number of values on the set. O(1).
1027      */
1028     function length(UintSet storage set) internal view returns (uint256) {
1029         return _length(set._inner);
1030     }
1031 
1032    /**
1033     * @dev Returns the value stored at position `index` in the set. O(1).
1034     *
1035     * Note that there are no guarantees on the ordering of values inside the
1036     * array, and it may change when more values are added or removed.
1037     *
1038     * Requirements:
1039     *
1040     * - `index` must be strictly less than {length}.
1041     */
1042     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1043         return uint256(_at(set._inner, index));
1044     }
1045 }
1046 
1047 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.3/contracts/access/AccessControl.sol
1048 
1049 
1050 
1051 pragma solidity >=0.6.0 <0.8.0;
1052 
1053 
1054 
1055 
1056 /**
1057  * @dev Contract module that allows children to implement role-based access
1058  * control mechanisms.
1059  *
1060  * Roles are referred to by their `bytes32` identifier. These should be exposed
1061  * in the external API and be unique. The best way to achieve this is by
1062  * using `public constant` hash digests:
1063  *
1064  * ```
1065  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1066  * ```
1067  *
1068  * Roles can be used to represent a set of permissions. To restrict access to a
1069  * function call, use {hasRole}:
1070  *
1071  * ```
1072  * function foo() public {
1073  *     require(hasRole(MY_ROLE, msg.sender));
1074  *     ...
1075  * }
1076  * ```
1077  *
1078  * Roles can be granted and revoked dynamically via the {grantRole} and
1079  * {revokeRole} functions. Each role has an associated admin role, and only
1080  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1081  *
1082  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1083  * that only accounts with this role will be able to grant or revoke other
1084  * roles. More complex role relationships can be created by using
1085  * {_setRoleAdmin}.
1086  *
1087  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1088  * grant and revoke this role. Extra precautions should be taken to secure
1089  * accounts that have been granted it.
1090  */
1091 abstract contract AccessControl is Context {
1092     using EnumerableSet for EnumerableSet.AddressSet;
1093     using Address for address;
1094 
1095     struct RoleData {
1096         EnumerableSet.AddressSet members;
1097         bytes32 adminRole;
1098     }
1099 
1100     mapping (bytes32 => RoleData) private _roles;
1101 
1102     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1103 
1104     /**
1105      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1106      *
1107      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1108      * {RoleAdminChanged} not being emitted signaling this.
1109      *
1110      * _Available since v3.1._
1111      */
1112     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1113 
1114     /**
1115      * @dev Emitted when `account` is granted `role`.
1116      *
1117      * `sender` is the account that originated the contract call, an admin role
1118      * bearer except when using {_setupRole}.
1119      */
1120     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1121 
1122     /**
1123      * @dev Emitted when `account` is revoked `role`.
1124      *
1125      * `sender` is the account that originated the contract call:
1126      *   - if using `revokeRole`, it is the admin role bearer
1127      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1128      */
1129     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1130 
1131     /**
1132      * @dev Returns `true` if `account` has been granted `role`.
1133      */
1134     function hasRole(bytes32 role, address account) public view returns (bool) {
1135         return _roles[role].members.contains(account);
1136     }
1137 
1138     /**
1139      * @dev Returns the number of accounts that have `role`. Can be used
1140      * together with {getRoleMember} to enumerate all bearers of a role.
1141      */
1142     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1143         return _roles[role].members.length();
1144     }
1145 
1146     /**
1147      * @dev Returns one of the accounts that have `role`. `index` must be a
1148      * value between 0 and {getRoleMemberCount}, non-inclusive.
1149      *
1150      * Role bearers are not sorted in any particular way, and their ordering may
1151      * change at any point.
1152      *
1153      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1154      * you perform all queries on the same block. See the following
1155      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1156      * for more information.
1157      */
1158     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1159         return _roles[role].members.at(index);
1160     }
1161 
1162     /**
1163      * @dev Returns the admin role that controls `role`. See {grantRole} and
1164      * {revokeRole}.
1165      *
1166      * To change a role's admin, use {_setRoleAdmin}.
1167      */
1168     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1169         return _roles[role].adminRole;
1170     }
1171 
1172     /**
1173      * @dev Grants `role` to `account`.
1174      *
1175      * If `account` had not been already granted `role`, emits a {RoleGranted}
1176      * event.
1177      *
1178      * Requirements:
1179      *
1180      * - the caller must have ``role``'s admin role.
1181      */
1182     function grantRole(bytes32 role, address account) public virtual {
1183         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1184 
1185         _grantRole(role, account);
1186     }
1187 
1188     /**
1189      * @dev Revokes `role` from `account`.
1190      *
1191      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1192      *
1193      * Requirements:
1194      *
1195      * - the caller must have ``role``'s admin role.
1196      */
1197     function revokeRole(bytes32 role, address account) public virtual {
1198         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1199 
1200         _revokeRole(role, account);
1201     }
1202 
1203     /**
1204      * @dev Revokes `role` from the calling account.
1205      *
1206      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1207      * purpose is to provide a mechanism for accounts to lose their privileges
1208      * if they are compromised (such as when a trusted device is misplaced).
1209      *
1210      * If the calling account had been granted `role`, emits a {RoleRevoked}
1211      * event.
1212      *
1213      * Requirements:
1214      *
1215      * - the caller must be `account`.
1216      */
1217     function renounceRole(bytes32 role, address account) public virtual {
1218         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1219 
1220         _revokeRole(role, account);
1221     }
1222 
1223     /**
1224      * @dev Grants `role` to `account`.
1225      *
1226      * If `account` had not been already granted `role`, emits a {RoleGranted}
1227      * event. Note that unlike {grantRole}, this function doesn't perform any
1228      * checks on the calling account.
1229      *
1230      * [WARNING]
1231      * ====
1232      * This function should only be called from the constructor when setting
1233      * up the initial roles for the system.
1234      *
1235      * Using this function in any other way is effectively circumventing the admin
1236      * system imposed by {AccessControl}.
1237      * ====
1238      */
1239     function _setupRole(bytes32 role, address account) internal virtual {
1240         _grantRole(role, account);
1241     }
1242 
1243     /**
1244      * @dev Sets `adminRole` as ``role``'s admin role.
1245      *
1246      * Emits a {RoleAdminChanged} event.
1247      */
1248     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1249         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1250         _roles[role].adminRole = adminRole;
1251     }
1252 
1253     function _grantRole(bytes32 role, address account) private {
1254         if (_roles[role].members.add(account)) {
1255             emit RoleGranted(role, account, _msgSender());
1256         }
1257     }
1258 
1259     function _revokeRole(bytes32 role, address account) private {
1260         if (_roles[role].members.remove(account)) {
1261             emit RoleRevoked(role, account, _msgSender());
1262         }
1263     }
1264 }
1265 
1266 
1267 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.3/contracts/access/Ownable.sol
1268 
1269 
1270 
1271 pragma solidity >=0.6.0 <0.8.0;
1272 
1273 /**
1274  * @dev Contract module which provides a basic access control mechanism, where
1275  * there is an account (an owner) that can be granted exclusive access to
1276  * specific functions.
1277  *
1278  * By default, the owner account will be the one that deploys the contract. This
1279  * can later be changed with {transferOwnership}.
1280  *
1281  * This module is used through inheritance. It will make available the modifier
1282  * `onlyOwner`, which can be applied to your functions to restrict their use to
1283  * the owner.
1284  */
1285 abstract contract Ownable is Context {
1286     address private _owner;
1287 
1288     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1289 
1290     /**
1291      * @dev Initializes the contract setting the deployer as the initial owner.
1292      */
1293     constructor () internal {
1294         address msgSender = _msgSender();
1295         _owner = msgSender;
1296         emit OwnershipTransferred(address(0), msgSender);
1297     }
1298 
1299     /**
1300      * @dev Returns the address of the current owner.
1301      */
1302     function owner() public view returns (address) {
1303         return _owner;
1304     }
1305 
1306     /**
1307      * @dev Throws if called by any account other than the owner.
1308      */
1309     modifier onlyOwner() {
1310         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1311         _;
1312     }
1313 
1314     /**
1315      * @dev Leaves the contract without owner. It will not be possible to call
1316      * `onlyOwner` functions anymore. Can only be called by the current owner.
1317      *
1318      * NOTE: Renouncing ownership will leave the contract without an owner,
1319      * thereby removing any functionality that is only available to the owner.
1320      */
1321     function renounceOwnership() public virtual onlyOwner {
1322         emit OwnershipTransferred(_owner, address(0));
1323         _owner = address(0);
1324     }
1325 
1326     /**
1327      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1328      * Can only be called by the current owner.
1329      */
1330     function transferOwnership(address newOwner) public virtual onlyOwner {
1331         require(newOwner != address(0), "Ownable: new owner is the zero address");
1332         emit OwnershipTransferred(_owner, newOwner);
1333         _owner = newOwner;
1334     }
1335 }
1336 
1337 // File: TimeToken.sol
1338 
1339 //Be name khoda
1340 
1341 
1342 
1343 pragma solidity >=0.6.0 <0.8.0;
1344 
1345 
1346 
1347 
1348 
1349 contract TransferController is Ownable{
1350 
1351 	mapping (address => bool) public transferableAddresses;
1352 
1353 	function setAddressTransferState(address _address, bool state) public onlyOwner{
1354 		transferableAddresses[_address] = state;
1355 	}
1356 
1357 	constructor() public{
1358 		transferableAddresses[address(0)] = true;
1359 	}
1360 	
1361 	function beforeTokenTransfer(address from, address to, uint256 value) public{
1362 		require(transferableAddresses[from] || transferableAddresses[to] , 'TimeToken is not transferable');
1363 	}
1364 }
1365 
1366 contract TimeToken is ERC20, AccessControl{
1367 
1368     using SafeMath for uint256;
1369 
1370     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1371     bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
1372 	bytes32 public constant CONFIG_ROLE = keccak256("CONFIG_ROLE");
1373 
1374 	TransferController public transferController;
1375 
1376     constructor() public ERC20('DEUS Time Token', 'TIME') {
1377 		_setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1378 		_setupRole(CONFIG_ROLE, msg.sender);
1379 
1380 		transferController = new TransferController();
1381 		transferController.transferOwnership(msg.sender);
1382     }
1383 
1384 	function setTransferController(address _transferController) public{
1385 		require(hasRole(CONFIG_ROLE, msg.sender), "Caller is not a configer");
1386 		transferController = TransferController(_transferController);
1387 	}
1388 
1389     function mint(address to, uint256 amount) public {
1390         require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
1391         _mint(to, amount);
1392     }
1393 
1394     function burn(address from, uint256 amount) public {
1395         require(hasRole(BURNER_ROLE, msg.sender), "Caller is not a burner");
1396         _burn(from, amount);
1397     }
1398 
1399 	function _beforeTokenTransfer(address from, address to, uint256 value) internal virtual override {
1400         transferController.beforeTokenTransfer(from, to, value);
1401         super._beforeTokenTransfer(from, to, value);
1402     }
1403 
1404 }
1405 
1406 //Dar panah khoda