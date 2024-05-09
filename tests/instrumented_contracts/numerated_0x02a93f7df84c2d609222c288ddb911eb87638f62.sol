1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.0;
3 
4 /**
5  * @dev Collection of functions related to the address type
6  */
7 library Address {
8     /**
9      * @dev Returns true if `account` is a contract.
10      *
11      * [IMPORTANT]
12      * ====
13      * It is unsafe to assume that an address for which this function returns
14      * false is an externally-owned account (EOA) and not a contract.
15      *
16      * Among others, `isContract` will return false for the following
17      * types of addresses:
18      *
19      *  - an externally-owned account
20      *  - a contract in construction
21      *  - an address where a contract will be created
22      *  - an address where a contract lived, but was destroyed
23      * ====
24      */
25     function isContract(address account) internal view returns (bool) {
26         // This method relies on extcodesize, which returns 0 for contracts in
27         // construction, since the code is only stored at the end of the
28         // constructor execution.
29 
30         uint256 size;
31         // solhint-disable-next-line no-inline-assembly
32         assembly { size := extcodesize(account) }
33         return size > 0;
34     }
35 
36     /**
37      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
38      * `recipient`, forwarding all available gas and reverting on errors.
39      *
40      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
41      * of certain opcodes, possibly making contracts go over the 2300 gas limit
42      * imposed by `transfer`, making them unable to receive funds via
43      * `transfer`. {sendValue} removes this limitation.
44      *
45      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
46      *
47      * IMPORTANT: because control is transferred to `recipient`, care must be
48      * taken to not create reentrancy vulnerabilities. Consider using
49      * {ReentrancyGuard} or the
50      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
51      */
52     function sendValue(address payable recipient, uint256 amount) internal {
53         require(address(this).balance >= amount, "Address: insufficient balance");
54 
55         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
56         (bool success, ) = recipient.call{ value: amount }("");
57         require(success, "Address: unable to send value, recipient may have reverted");
58     }
59 
60     /**
61      * @dev Performs a Solidity function call using a low level `call`. A
62      * plain`call` is an unsafe replacement for a function call: use this
63      * function instead.
64      *
65      * If `target` reverts with a revert reason, it is bubbled up by this
66      * function (like regular Solidity function calls).
67      *
68      * Returns the raw returned data. To convert to the expected return value,
69      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
70      *
71      * Requirements:
72      *
73      * - `target` must be a contract.
74      * - calling `target` with `data` must not revert.
75      *
76      * _Available since v3.1._
77      */
78     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
79       return functionCall(target, data, "Address: low-level call failed");
80     }
81 
82     /**
83      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
84      * `errorMessage` as a fallback revert reason when `target` reverts.
85      *
86      * _Available since v3.1._
87      */
88     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
89         return functionCallWithValue(target, data, 0, errorMessage);
90     }
91 
92     /**
93      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
94      * but also transferring `value` wei to `target`.
95      *
96      * Requirements:
97      *
98      * - the calling contract must have an ETH balance of at least `value`.
99      * - the called Solidity function must be `payable`.
100      *
101      * _Available since v3.1._
102      */
103     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
109      * with `errorMessage` as a fallback revert reason when `target` reverts.
110      *
111      * _Available since v3.1._
112      */
113     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
114         require(address(this).balance >= value, "Address: insufficient balance for call");
115         require(isContract(target), "Address: call to non-contract");
116 
117         // solhint-disable-next-line avoid-low-level-calls
118         (bool success, bytes memory returndata) = target.call{ value: value }(data);
119         return _verifyCallResult(success, returndata, errorMessage);
120     }
121 
122     /**
123      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
124      * but performing a static call.
125      *
126      * _Available since v3.3._
127      */
128     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
129         return functionStaticCall(target, data, "Address: low-level static call failed");
130     }
131 
132     /**
133      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
134      * but performing a static call.
135      *
136      * _Available since v3.3._
137      */
138     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
139         require(isContract(target), "Address: static call to non-contract");
140 
141         // solhint-disable-next-line avoid-low-level-calls
142         (bool success, bytes memory returndata) = target.staticcall(data);
143         return _verifyCallResult(success, returndata, errorMessage);
144     }
145 
146     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
147         if (success) {
148             return returndata;
149         } else {
150             // Look for revert reason and bubble it up if present
151             if (returndata.length > 0) {
152                 // The easiest way to bubble the revert reason is using memory via assembly
153 
154                 // solhint-disable-next-line no-inline-assembly
155                 assembly {
156                     let returndata_size := mload(returndata)
157                     revert(add(32, returndata), returndata_size)
158                 }
159             } else {
160                 revert(errorMessage);
161             }
162         }
163     }
164 }
165 
166 
167 /**
168  * @dev Wrappers over Solidity's arithmetic operations with added overflow
169  * checks.
170  *
171  * Arithmetic operations in Solidity wrap on overflow. This can easily result
172  * in bugs, because programmers usually assume that an overflow raises an
173  * error, which is the standard behavior in high level programming languages.
174  * `SafeMath` restores this intuition by reverting the transaction when an
175  * operation overflows.
176  *
177  * Using this library instead of the unchecked operations eliminates an entire
178  * class of bugs, so it's recommended to use it always.
179  */
180 library SafeMath {
181     /**
182      * @dev Returns the addition of two unsigned integers, reverting on
183      * overflow.
184      *
185      * Counterpart to Solidity's `+` operator.
186      *
187      * Requirements:
188      *
189      * - Addition cannot overflow.
190      */
191     function add(uint256 a, uint256 b) internal pure returns (uint256) {
192         uint256 c = a + b;
193         require(c >= a, "SafeMath: addition overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the subtraction of two unsigned integers, reverting on
200      * overflow (when the result is negative).
201      *
202      * Counterpart to Solidity's `-` operator.
203      *
204      * Requirements:
205      *
206      * - Subtraction cannot overflow.
207      */
208     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
209         return sub(a, b, "SafeMath: subtraction overflow");
210     }
211 
212     /**
213      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
214      * overflow (when the result is negative).
215      *
216      * Counterpart to Solidity's `-` operator.
217      *
218      * Requirements:
219      *
220      * - Subtraction cannot overflow.
221      */
222     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         require(b <= a, errorMessage);
224         uint256 c = a - b;
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the multiplication of two unsigned integers, reverting on
231      * overflow.
232      *
233      * Counterpart to Solidity's `*` operator.
234      *
235      * Requirements:
236      *
237      * - Multiplication cannot overflow.
238      */
239     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
240         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
241         // benefit is lost if 'b' is also tested.
242         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
243         if (a == 0) {
244             return 0;
245         }
246 
247         uint256 c = a * b;
248         require(c / a == b, "SafeMath: multiplication overflow");
249 
250         return c;
251     }
252 
253     /**
254      * @dev Returns the integer division of two unsigned integers. Reverts on
255      * division by zero. The result is rounded towards zero.
256      *
257      * Counterpart to Solidity's `/` operator. Note: this function uses a
258      * `revert` opcode (which leaves remaining gas untouched) while Solidity
259      * uses an invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function div(uint256 a, uint256 b) internal pure returns (uint256) {
266         return div(a, b, "SafeMath: division by zero");
267     }
268 
269     /**
270      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
271      * division by zero. The result is rounded towards zero.
272      *
273      * Counterpart to Solidity's `/` operator. Note: this function uses a
274      * `revert` opcode (which leaves remaining gas untouched) while Solidity
275      * uses an invalid opcode to revert (consuming all remaining gas).
276      *
277      * Requirements:
278      *
279      * - The divisor cannot be zero.
280      */
281     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
282         require(b > 0, errorMessage);
283         uint256 c = a / b;
284         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
285 
286         return c;
287     }
288 
289     /**
290      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
291      * Reverts when dividing by zero.
292      *
293      * Counterpart to Solidity's `%` operator. This function uses a `revert`
294      * opcode (which leaves remaining gas untouched) while Solidity uses an
295      * invalid opcode to revert (consuming all remaining gas).
296      *
297      * Requirements:
298      *
299      * - The divisor cannot be zero.
300      */
301     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
302         return mod(a, b, "SafeMath: modulo by zero");
303     }
304 
305     /**
306      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
307      * Reverts with custom message when dividing by zero.
308      *
309      * Counterpart to Solidity's `%` operator. This function uses a `revert`
310      * opcode (which leaves remaining gas untouched) while Solidity uses an
311      * invalid opcode to revert (consuming all remaining gas).
312      *
313      * Requirements:
314      *
315      * - The divisor cannot be zero.
316      */
317     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
318         require(b != 0, errorMessage);
319         return a % b;
320     }
321 }
322 
323 
324 /*
325  * @dev Provides information about the current execution context, including the
326  * sender of the transaction and its data. While these are generally available
327  * via msg.sender and msg.data, they should not be accessed in such a direct
328  * manner, since when dealing with GSN meta-transactions the account sending and
329  * paying for execution may not be the actual sender (as far as an application
330  * is concerned).
331  *
332  * This contract is only required for intermediate, library-like contracts.
333  */
334 abstract contract Context {
335     function _msgSender() internal view virtual returns (address payable) {
336         return msg.sender;
337     }
338 
339     function _msgData() internal view virtual returns (bytes memory) {
340         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
341         return msg.data;
342     }
343 }
344 
345 
346 /**
347  * @dev Interface of the ERC20 standard as defined in the EIP.
348  */
349 interface IERC20 {
350     /**
351      * @dev Returns the amount of tokens in existence.
352      */
353     function totalSupply() external view returns (uint256);
354 
355     /**
356      * @dev Returns the amount of tokens owned by `account`.
357      */
358     function balanceOf(address account) external view returns (uint256);
359 
360     /**
361      * @dev Moves `amount` tokens from the caller's account to `recipient`.
362      *
363      * Returns a boolean value indicating whether the operation succeeded.
364      *
365      * Emits a {Transfer} event.
366      */
367     function transfer(address recipient, uint256 amount) external returns (bool);
368 
369     /**
370      * @dev Returns the remaining number of tokens that `spender` will be
371      * allowed to spend on behalf of `owner` through {transferFrom}. This is
372      * zero by default.
373      *
374      * This value changes when {approve} or {transferFrom} are called.
375      */
376     function allowance(address owner, address spender) external view returns (uint256);
377 
378     /**
379      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
380      *
381      * Returns a boolean value indicating whether the operation succeeded.
382      *
383      * IMPORTANT: Beware that changing an allowance with this method brings the risk
384      * that someone may use both the old and the new allowance by unfortunate
385      * transaction ordering. One possible solution to mitigate this race
386      * condition is to first reduce the spender's allowance to 0 and set the
387      * desired value afterwards:
388      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
389      *
390      * Emits an {Approval} event.
391      */
392     function approve(address spender, uint256 amount) external returns (bool);
393 
394     /**
395      * @dev Moves `amount` tokens from `sender` to `recipient` using the
396      * allowance mechanism. `amount` is then deducted from the caller's
397      * allowance.
398      *
399      * Returns a boolean value indicating whether the operation succeeded.
400      *
401      * Emits a {Transfer} event.
402      */
403     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
404 
405     /**
406      * @dev Emitted when `value` tokens are moved from one account (`from`) to
407      * another (`to`).
408      *
409      * Note that `value` may be zero.
410      */
411     event Transfer(address indexed from, address indexed to, uint256 value);
412 
413     /**
414      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
415      * a call to {approve}. `value` is the new allowance.
416      */
417     event Approval(address indexed owner, address indexed spender, uint256 value);
418 }
419 
420 /**
421  * @dev Implementation of the {IERC20} interface.
422  *
423  * This implementation is agnostic to the way tokens are created. This means
424  * that a supply mechanism has to be added in a derived contract using {_mint}.
425  * For a generic mechanism see {ERC20PresetMinterPauser}.
426  *
427  * TIP: For a detailed writeup see our guide
428  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
429  * to implement supply mechanisms].
430  *
431  * We have followed general OpenZeppelin guidelines: functions revert instead
432  * of returning `false` on failure. This behavior is nonetheless conventional
433  * and does not conflict with the expectations of ERC20 applications.
434  *
435  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
436  * This allows applications to reconstruct the allowance for all accounts just
437  * by listening to said events. Other implementations of the EIP may not emit
438  * these events, as it isn't required by the specification.
439  *
440  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
441  * functions have been added to mitigate the well-known issues around setting
442  * allowances. See {IERC20-approve}.
443  */
444 contract ERC20 is Context, IERC20 {
445     using SafeMath for uint256;
446 
447     mapping (address => uint256) private _balances;
448 
449     mapping (address => mapping (address => uint256)) private _allowances;
450 
451     uint256 private _totalSupply;
452 
453     string private _name;
454     string private _symbol;
455     uint8 private _decimals;
456 
457     /**
458      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
459      * a default value of 18.
460      *
461      * To select a different value for {decimals}, use {_setupDecimals}.
462      *
463      * All three of these values are immutable: they can only be set once during
464      * construction.
465      */
466     constructor (string memory name_, string memory symbol_) public {
467         _name = name_;
468         _symbol = symbol_;
469         _decimals = 18;
470     }
471 
472     /**
473      * @dev Returns the name of the token.
474      */
475     function name() public view returns (string memory) {
476         return _name;
477     }
478 
479     /**
480      * @dev Returns the symbol of the token, usually a shorter version of the
481      * name.
482      */
483     function symbol() public view returns (string memory) {
484         return _symbol;
485     }
486 
487     /**
488      * @dev Returns the number of decimals used to get its user representation.
489      * For example, if `decimals` equals `2`, a balance of `505` tokens should
490      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
491      *
492      * Tokens usually opt for a value of 18, imitating the relationship between
493      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
494      * called.
495      *
496      * NOTE: This information is only used for _display_ purposes: it in
497      * no way affects any of the arithmetic of the contract, including
498      * {IERC20-balanceOf} and {IERC20-transfer}.
499      */
500     function decimals() public view returns (uint8) {
501         return _decimals;
502     }
503 
504     /**
505      * @dev See {IERC20-totalSupply}.
506      */
507     function totalSupply() public view override returns (uint256) {
508         return _totalSupply;
509     }
510 
511     /**
512      * @dev See {IERC20-balanceOf}.
513      */
514     function balanceOf(address account) public view override returns (uint256) {
515         return _balances[account];
516     }
517 
518     /**
519      * @dev See {IERC20-transfer}.
520      *
521      * Requirements:
522      *
523      * - `recipient` cannot be the zero address.
524      * - the caller must have a balance of at least `amount`.
525      */
526     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
527         _transfer(_msgSender(), recipient, amount);
528         return true;
529     }
530 
531     /**
532      * @dev See {IERC20-allowance}.
533      */
534     function allowance(address owner, address spender) public view virtual override returns (uint256) {
535         return _allowances[owner][spender];
536     }
537 
538     /**
539      * @dev See {IERC20-approve}.
540      *
541      * Requirements:
542      *
543      * - `spender` cannot be the zero address.
544      */
545     function approve(address spender, uint256 amount) public virtual override returns (bool) {
546         _approve(_msgSender(), spender, amount);
547         return true;
548     }
549 
550     /**
551      * @dev See {IERC20-transferFrom}.
552      *
553      * Emits an {Approval} event indicating the updated allowance. This is not
554      * required by the EIP. See the note at the beginning of {ERC20}.
555      *
556      * Requirements:
557      *
558      * - `sender` and `recipient` cannot be the zero address.
559      * - `sender` must have a balance of at least `amount`.
560      * - the caller must have allowance for ``sender``'s tokens of at least
561      * `amount`.
562      */
563     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
564         _transfer(sender, recipient, amount);
565         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
566         return true;
567     }
568 
569     /**
570      * @dev Atomically increases the allowance granted to `spender` by the caller.
571      *
572      * This is an alternative to {approve} that can be used as a mitigation for
573      * problems described in {IERC20-approve}.
574      *
575      * Emits an {Approval} event indicating the updated allowance.
576      *
577      * Requirements:
578      *
579      * - `spender` cannot be the zero address.
580      */
581     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
582         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
583         return true;
584     }
585 
586     /**
587      * @dev Atomically decreases the allowance granted to `spender` by the caller.
588      *
589      * This is an alternative to {approve} that can be used as a mitigation for
590      * problems described in {IERC20-approve}.
591      *
592      * Emits an {Approval} event indicating the updated allowance.
593      *
594      * Requirements:
595      *
596      * - `spender` cannot be the zero address.
597      * - `spender` must have allowance for the caller of at least
598      * `subtractedValue`.
599      */
600     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
601         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
602         return true;
603     }
604 
605     /**
606      * @dev Moves tokens `amount` from `sender` to `recipient`.
607      *
608      * This is internal function is equivalent to {transfer}, and can be used to
609      * e.g. implement automatic token fees, slashing mechanisms, etc.
610      *
611      * Emits a {Transfer} event.
612      *
613      * Requirements:
614      *
615      * - `sender` cannot be the zero address.
616      * - `recipient` cannot be the zero address.
617      * - `sender` must have a balance of at least `amount`.
618      */
619     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
620         require(sender != address(0), "ERC20: transfer from the zero address");
621         require(recipient != address(0), "ERC20: transfer to the zero address");
622 
623         _beforeTokenTransfer(sender, recipient, amount);
624 
625         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
626         _balances[recipient] = _balances[recipient].add(amount);
627         emit Transfer(sender, recipient, amount);
628     }
629 
630     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
631      * the total supply.
632      *
633      * Emits a {Transfer} event with `from` set to the zero address.
634      *
635      * Requirements:
636      *
637      * - `to` cannot be the zero address.
638      */
639     function _mint(address account, uint256 amount) internal virtual {
640         require(account != address(0), "ERC20: mint to the zero address");
641 
642         _beforeTokenTransfer(address(0), account, amount);
643 
644         _totalSupply = _totalSupply.add(amount);
645         _balances[account] = _balances[account].add(amount);
646         emit Transfer(address(0), account, amount);
647     }
648 
649     /**
650      * @dev Destroys `amount` tokens from `account`, reducing the
651      * total supply.
652      *
653      * Emits a {Transfer} event with `to` set to the zero address.
654      *
655      * Requirements:
656      *
657      * - `account` cannot be the zero address.
658      * - `account` must have at least `amount` tokens.
659      */
660     function _burn(address account, uint256 amount) internal virtual {
661         require(account != address(0), "ERC20: burn from the zero address");
662 
663         _beforeTokenTransfer(account, address(0), amount);
664 
665         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
666         _totalSupply = _totalSupply.sub(amount);
667         emit Transfer(account, address(0), amount);
668     }
669 
670     /**
671      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
672      *
673      * This internal function is equivalent to `approve`, and can be used to
674      * e.g. set automatic allowances for certain subsystems, etc.
675      *
676      * Emits an {Approval} event.
677      *
678      * Requirements:
679      *
680      * - `owner` cannot be the zero address.
681      * - `spender` cannot be the zero address.
682      */
683     function _approve(address owner, address spender, uint256 amount) internal virtual {
684         require(owner != address(0), "ERC20: approve from the zero address");
685         require(spender != address(0), "ERC20: approve to the zero address");
686 
687         _allowances[owner][spender] = amount;
688         emit Approval(owner, spender, amount);
689     }
690 
691     /**
692      * @dev Sets {decimals} to a value other than the default one of 18.
693      *
694      * WARNING: This function should only be called from the constructor. Most
695      * applications that interact with token contracts will not expect
696      * {decimals} to ever change, and may work incorrectly if it does.
697      */
698     function _setupDecimals(uint8 decimals_) internal {
699         _decimals = decimals_;
700     }
701 
702     /**
703      * @dev Hook that is called before any transfer of tokens. This includes
704      * minting and burning.
705      *
706      * Calling conditions:
707      *
708      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
709      * will be to transferred to `to`.
710      * - when `from` is zero, `amount` tokens will be minted for `to`.
711      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
712      * - `from` and `to` are never both zero.
713      *
714      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
715      */
716     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
717 }
718 
719 /**
720  * @dev Extension of {ERC20} that allows token holders to destroy both their own
721  * tokens and those that they have an allowance for, in a way that can be
722  * recognized off-chain (via event analysis).
723  */
724 abstract contract ERC20Burnable is Context, ERC20 {
725     using SafeMath for uint256;
726 
727     /**
728      * @dev Destroys `amount` tokens from the caller.
729      *
730      * See {ERC20-_burn}.
731      */
732     function burn(uint256 amount) public virtual {
733         _burn(_msgSender(), amount);
734     }
735 
736     /**
737      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
738      * allowance.
739      *
740      * See {ERC20-_burn} and {ERC20-allowance}.
741      *
742      * Requirements:
743      *
744      * - the caller must have allowance for ``accounts``'s tokens of at least
745      * `amount`.
746      */
747     function burnFrom(address account, uint256 amount) public virtual {
748         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
749 
750         _approve(account, _msgSender(), decreasedAllowance);
751         _burn(account, amount);
752     }
753 }
754 
755 /**
756  * @title SafeERC20
757  * @dev Wrappers around ERC20 operations that throw on failure (when the token
758  * contract returns false). Tokens that return no value (and instead revert or
759  * throw on failure) are also supported, non-reverting calls are assumed to be
760  * successful.
761  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
762  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
763  */
764 library SafeERC20 {
765     using SafeMath for uint256;
766     using Address for address;
767 
768     function safeTransfer(IERC20 token, address to, uint256 value) internal {
769         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
770     }
771 
772     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
773         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
774     }
775 
776     /**
777      * @dev Deprecated. This function has issues similar to the ones found in
778      * {IERC20-approve}, and its usage is discouraged.
779      *
780      * Whenever possible, use {safeIncreaseAllowance} and
781      * {safeDecreaseAllowance} instead.
782      */
783     function safeApprove(IERC20 token, address spender, uint256 value) internal {
784         // safeApprove should only be called when setting an initial allowance,
785         // or when resetting it to zero. To increase and decrease it, use
786         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
787         // solhint-disable-next-line max-line-length
788         require((value == 0) || (token.allowance(address(this), spender) == 0),
789             "SafeERC20: approve from non-zero to non-zero allowance"
790         );
791         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
792     }
793 
794     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
795         uint256 newAllowance = token.allowance(address(this), spender).add(value);
796         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
797     }
798 
799     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
800         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
801         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
802     }
803 
804     /**
805      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
806      * on the return value: the return value is optional (but if data is returned, it must not be false).
807      * @param token The token targeted by the call.
808      * @param data The call data (encoded using abi.encode or one of its variants).
809      */
810     function _callOptionalReturn(IERC20 token, bytes memory data) private {
811         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
812         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
813         // the target address contains contract code and also asserts for success in the low-level call.
814 
815         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
816         if (returndata.length > 0) { // Return data is optional
817             // solhint-disable-next-line max-line-length
818             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
819         }
820     }
821 }
822 
823 /**
824  * @dev Contract module which provides a basic access control mechanism, where
825  * there is an account (an owner) that can be granted exclusive access to
826  * specific functions.
827  *
828  * By default, the owner account will be the one that deploys the contract. This
829  * can later be changed with {transferOwnership}.
830  *
831  * This module is used through inheritance. It will make available the modifier
832  * `onlyOwner`, which can be applied to your functions to restrict their use to
833  * the owner.
834  */
835 abstract contract Ownable is Context {
836     address private _owner;
837 
838     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
839 
840     /**
841      * @dev Initializes the contract setting the deployer as the initial owner.
842      */
843     constructor () internal {
844         address msgSender = _msgSender();
845         _owner = msgSender;
846         emit OwnershipTransferred(address(0), msgSender);
847     }
848 
849     /**
850      * @dev Returns the address of the current owner.
851      */
852     function owner() public view returns (address) {
853         return _owner;
854     }
855 
856     /**
857      * @dev Throws if called by any account other than the owner.
858      */
859     modifier onlyOwner() {
860         require(_owner == _msgSender(), "Ownable: caller is not the owner");
861         _;
862     }
863 
864     /**
865      * @dev Leaves the contract without owner. It will not be possible to call
866      * `onlyOwner` functions anymore. Can only be called by the current owner.
867      *
868      * NOTE: Renouncing ownership will leave the contract without an owner,
869      * thereby removing any functionality that is only available to the owner.
870      */
871     function renounceOwnership() public virtual onlyOwner {
872         emit OwnershipTransferred(_owner, address(0));
873         _owner = address(0);
874     }
875 
876     /**
877      * @dev Transfers ownership of the contract to a new account (`newOwner`).
878      * Can only be called by the current owner.
879      */
880     function transferOwnership(address newOwner) public virtual onlyOwner {
881         require(newOwner != address(0), "Ownable: new owner is the zero address");
882         emit OwnershipTransferred(_owner, newOwner);
883         _owner = newOwner;
884     }
885 }
886 
887 /**
888  * @dev Contract module that helps prevent reentrant calls to a function.
889  *
890  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
891  * available, which can be applied to functions to make sure there are no nested
892  * (reentrant) calls to them.
893  *
894  * Note that because there is a single `nonReentrant` guard, functions marked as
895  * `nonReentrant` may not call one another. This can be worked around by making
896  * those functions `private`, and then adding `external` `nonReentrant` entry
897  * points to them.
898  *
899  * TIP: If you would like to learn more about reentrancy and alternative ways
900  * to protect against it, check out our blog post
901  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
902  */
903 abstract contract ReentrancyGuard {
904     // Booleans are more expensive than uint256 or any type that takes up a full
905     // word because each write operation emits an extra SLOAD to first read the
906     // slot's contents, replace the bits taken up by the boolean, and then write
907     // back. This is the compiler's defense against contract upgrades and
908     // pointer aliasing, and it cannot be disabled.
909 
910     // The values being non-zero value makes deployment a bit more expensive,
911     // but in exchange the refund on every call to nonReentrant will be lower in
912     // amount. Since refunds are capped to a percentage of the total
913     // transaction's gas, it is best to keep them low in cases like this one, to
914     // increase the likelihood of the full refund coming into effect.
915     uint256 private constant _NOT_ENTERED = 1;
916     uint256 private constant _ENTERED = 2;
917 
918     uint256 private _status;
919 
920     constructor () internal {
921         _status = _NOT_ENTERED;
922     }
923 
924     /**
925      * @dev Prevents a contract from calling itself, directly or indirectly.
926      * Calling a `nonReentrant` function from another `nonReentrant`
927      * function is not supported. It is possible to prevent this from happening
928      * by making the `nonReentrant` function external, and make it call a
929      * `private` function that does the actual work.
930      */
931     modifier nonReentrant() {
932         // On the first call to nonReentrant, _notEntered will be true
933         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
934 
935         // Any calls to nonReentrant after this point will fail
936         _status = _ENTERED;
937 
938         _;
939 
940         // By storing the original value once again, a refund is triggered (see
941         // https://eips.ethereum.org/EIPS/eip-2200)
942         _status = _NOT_ENTERED;
943     }
944 }
945 
946 contract Staking is Ownable, ReentrancyGuard {
947     
948     using SafeMath for uint;
949     using SafeERC20 for IERC20;
950     using SafeERC20 for ERC20Burnable;
951 
952 	ERC20Burnable public duckToken;
953 
954 	uint public stakingStartTime;
955 	uint public stakingFinishTime;
956 
957 	uint public harvestStartTime;
958 
959 	address public rewardAddress;
960 	uint public rewardAmount;
961 
962 	address public duckReceiverAddress;
963 	uint public burnThreshold;
964 
965 	mapping(address => uint) public balances;
966 	uint public totalStaked;
967 	
968 	uint public stakingLimit;
969 	uint public userStakingLimit;
970 	bool public canWithdraw;
971 
972 	bool finished;
973 
974 	struct Reward {
975 		address addr;
976 		uint amount;
977 	}
978 
979 	Reward[] public rewards;
980 	mapping(address => uint) public userLastUnclaimedReward;
981 
982 	event NewReward(address indexed tokenAddress, uint amount);
983 
984 	constructor(address _duckAddress, address _duckReceiverAddress) public Ownable() {
985 		duckToken = ERC20Burnable(_duckAddress);
986 		duckReceiverAddress = _duckReceiverAddress;
987 	}
988 
989 	function initialSetup(uint _stakingStartTime, uint _stakingFinishTime, uint _stakingLimit) external onlyOwner {
990 		require(stakingStartTime == 0, "already set");
991         
992 		stakingStartTime = _stakingStartTime;
993 		stakingFinishTime = _stakingFinishTime;
994 		
995 		stakingLimit = _stakingLimit;
996 	}
997 
998 	function secondarySetup(uint _burnThreshold, uint _harvestStartTime, uint _userStakingLimit) external onlyOwner {
999         require(_harvestStartTime >= stakingFinishTime, "harvestStartTime < stakingFinishTime");
1000 		burnThreshold = _burnThreshold;
1001 		harvestStartTime = _harvestStartTime;
1002 		userStakingLimit = _userStakingLimit;
1003 	}
1004 
1005 	function addReward(address _rewardAddress, uint _rewardAmount) external onlyOwner {
1006 		rewards.push(Reward({addr: _rewardAddress, amount: _rewardAmount}));
1007 		emit NewReward(_rewardAddress, _rewardAmount);
1008 	}
1009 	
1010 	function stake(uint amount) external nonReentrant() {
1011 		require(block.timestamp > stakingStartTime && block.timestamp < stakingFinishTime, "not a staking time");
1012 
1013         if(totalStaked.add(amount) > stakingLimit) {
1014             amount = stakingLimit.sub(totalStaked);
1015         }
1016         
1017         if(balances[msg.sender].add(amount) > userStakingLimit) {
1018             amount = userStakingLimit.sub(balances[msg.sender]);
1019         }
1020         
1021         require(amount > 0, "nothing to stake");
1022 		require(duckToken.transferFrom(msg.sender, address(this), amount));
1023 	    
1024 		balances[msg.sender] = balances[msg.sender].add(amount);
1025 		totalStaked = totalStaked.add(amount);
1026 	}
1027 
1028 	function claimReward() external nonReentrant() {
1029 		require(block.timestamp >= harvestStartTime, "not a harvest time");
1030 		require(balances[msg.sender] > 0, "nothing to claim");
1031 
1032 		uint buf = userLastUnclaimedReward[msg.sender];
1033 		userLastUnclaimedReward[msg.sender] = rewards.length;
1034 
1035 		for(uint i = buf; i < rewards.length; i++) {
1036 			uint reward = rewards[i].amount.mul(balances[msg.sender]).div(totalStaked);
1037 			IERC20(rewards[i].addr).safeTransfer(msg.sender, reward);
1038 		}
1039 	}
1040 
1041 	function finish() external {
1042 		require(!finished, "already finished");
1043 		require(block.timestamp > stakingFinishTime, "not a finish time");
1044 
1045 		finished = true;
1046 
1047 		if(totalStaked <= burnThreshold) {
1048 			duckToken.safeTransfer(duckReceiverAddress, totalStaked);
1049 			return;
1050 		}
1051 
1052 		duckToken.safeTransfer(duckReceiverAddress, burnThreshold);
1053 		duckToken.burn(totalStaked.sub(burnThreshold));
1054 	}
1055 
1056 	function withdrawLostTokens(address tokenAddress) external onlyOwner {
1057 		require(finished, "call finish first");
1058 		
1059 		require(tokenAddress != rewardAddress, "can't withdraw reward tokens");
1060 		IERC20(tokenAddress).safeTransfer(owner(), IERC20(tokenAddress).balanceOf(address(this)));
1061 	}
1062 	
1063 	function setWithdrawPermission(bool perm) external onlyOwner {
1064 	    canWithdraw = perm;
1065 	}
1066     
1067     function withdraw() public {
1068         require(canWithdraw, "withdraw disabled");
1069         require(balances[msg.sender] > 0, "nothing to claim");
1070         
1071         uint toSend = balances[msg.sender];
1072         balances[msg.sender] = 0;
1073         
1074         duckToken.safeTransfer(msg.sender, toSend);
1075     }
1076     
1077     //frontend
1078 	function calculateReward(address user) public view returns(uint) {
1079 		uint res;
1080 	    for(uint i = userLastUnclaimedReward[user]; i < rewards.length; i++) {
1081 			uint reward = rewards[i].amount.mul(balances[user]).div(totalStaked);
1082 			res += reward;
1083 		}
1084 
1085 		return res;
1086 	}
1087 }