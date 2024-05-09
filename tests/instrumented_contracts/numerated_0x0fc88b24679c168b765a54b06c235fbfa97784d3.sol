1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 pragma solidity ^0.6.2;
5 
6 /**
7  * @dev Collection of functions related to the address type
8  */
9 library Address {
10     /**
11      * @dev Returns true if `account` is a contract.
12      *
13      * [IMPORTANT]
14      * ====
15      * It is unsafe to assume that an address for which this function returns
16      * false is an externally-owned account (EOA) and not a contract.
17      *
18      * Among others, `isContract` will return false for the following
19      * types of addresses:
20      *
21      *  - an externally-owned account
22      *  - a contract in construction
23      *  - an address where a contract will be created
24      *  - an address where a contract lived, but was destroyed
25      * ====
26      */
27     function isContract(address account) internal view returns (bool) {
28         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
29         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
30         // for accounts without code, i.e. `keccak256('')`
31         bytes32 codehash;
32         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
33         // solhint-disable-next-line no-inline-assembly
34         assembly { codehash := extcodehash(account) }
35         return (codehash != accountHash && codehash != 0x0);
36     }
37 
38     /**
39      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
40      * `recipient`, forwarding all available gas and reverting on errors.
41      *
42      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
43      * of certain opcodes, possibly making contracts go over the 2300 gas limit
44      * imposed by `transfer`, making them unable to receive funds via
45      * `transfer`. {sendValue} removes this limitation.
46      *
47      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
48      *
49      * IMPORTANT: because control is transferred to `recipient`, care must be
50      * taken to not create reentrancy vulnerabilities. Consider using
51      * {ReentrancyGuard} or the
52      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
53      */
54     function sendValue(address payable recipient, uint256 amount) internal {
55         require(address(this).balance >= amount, "Address: insufficient balance");
56 
57         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
58         (bool success, ) = recipient.call{ value: amount }("");
59         require(success, "Address: unable to send value, recipient may have reverted");
60     }
61 
62     /**
63      * @dev Performs a Solidity function call using a low level `call`. A
64      * plain`call` is an unsafe replacement for a function call: use this
65      * function instead.
66      *
67      * If `target` reverts with a revert reason, it is bubbled up by this
68      * function (like regular Solidity function calls).
69      *
70      * Returns the raw returned data. To convert to the expected return value,
71      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
72      *
73      * Requirements:
74      *
75      * - `target` must be a contract.
76      * - calling `target` with `data` must not revert.
77      *
78      * _Available since v3.1._
79      */
80     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
81       return functionCall(target, data, "Address: low-level call failed");
82     }
83 
84     /**
85      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
86      * `errorMessage` as a fallback revert reason when `target` reverts.
87      *
88      * _Available since v3.1._
89      */
90     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
91         return _functionCallWithValue(target, data, 0, errorMessage);
92     }
93 
94     /**
95      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
96      * but also transferring `value` wei to `target`.
97      *
98      * Requirements:
99      *
100      * - the calling contract must have an ETH balance of at least `value`.
101      * - the called Solidity function must be `payable`.
102      *
103      * _Available since v3.1._
104      */
105     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
106         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
107     }
108 
109     /**
110      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
111      * with `errorMessage` as a fallback revert reason when `target` reverts.
112      *
113      * _Available since v3.1._
114      */
115     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
116         require(address(this).balance >= value, "Address: insufficient balance for call");
117         return _functionCallWithValue(target, data, value, errorMessage);
118     }
119 
120     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
121         require(isContract(target), "Address: call to non-contract");
122 
123         // solhint-disable-next-line avoid-low-level-calls
124         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
125         if (success) {
126             return returndata;
127         } else {
128             // Look for revert reason and bubble it up if present
129             if (returndata.length > 0) {
130                 // The easiest way to bubble the revert reason is using memory via assembly
131 
132                 // solhint-disable-next-line no-inline-assembly
133                 assembly {
134                     let returndata_size := mload(returndata)
135                     revert(add(32, returndata), returndata_size)
136                 }
137             } else {
138                 revert(errorMessage);
139             }
140         }
141     }
142 }
143 
144 // File: @openzeppelin/contracts/math/SafeMath.sol
145 
146 
147 pragma solidity ^0.6.0;
148 
149 /**
150  * @dev Wrappers over Solidity's arithmetic operations with added overflow
151  * checks.
152  *
153  * Arithmetic operations in Solidity wrap on overflow. This can easily result
154  * in bugs, because programmers usually assume that an overflow raises an
155  * error, which is the standard behavior in high level programming languages.
156  * `SafeMath` restores this intuition by reverting the transaction when an
157  * operation overflows.
158  *
159  * Using this library instead of the unchecked operations eliminates an entire
160  * class of bugs, so it's recommended to use it always.
161  */
162 library SafeMath {
163     /**
164      * @dev Returns the addition of two unsigned integers, reverting on
165      * overflow.
166      *
167      * Counterpart to Solidity's `+` operator.
168      *
169      * Requirements:
170      *
171      * - Addition cannot overflow.
172      */
173     function add(uint256 a, uint256 b) internal pure returns (uint256) {
174         uint256 c = a + b;
175         require(c >= a, "SafeMath: addition overflow");
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the subtraction of two unsigned integers, reverting on
182      * overflow (when the result is negative).
183      *
184      * Counterpart to Solidity's `-` operator.
185      *
186      * Requirements:
187      *
188      * - Subtraction cannot overflow.
189      */
190     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
191         return sub(a, b, "SafeMath: subtraction overflow");
192     }
193 
194     /**
195      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
196      * overflow (when the result is negative).
197      *
198      * Counterpart to Solidity's `-` operator.
199      *
200      * Requirements:
201      *
202      * - Subtraction cannot overflow.
203      */
204     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
205         require(b <= a, errorMessage);
206         uint256 c = a - b;
207 
208         return c;
209     }
210 
211     /**
212      * @dev Returns the multiplication of two unsigned integers, reverting on
213      * overflow.
214      *
215      * Counterpart to Solidity's `*` operator.
216      *
217      * Requirements:
218      *
219      * - Multiplication cannot overflow.
220      */
221     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
222         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
223         // benefit is lost if 'b' is also tested.
224         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
225         if (a == 0) {
226             return 0;
227         }
228 
229         uint256 c = a * b;
230         require(c / a == b, "SafeMath: multiplication overflow");
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the integer division of two unsigned integers. Reverts on
237      * division by zero. The result is rounded towards zero.
238      *
239      * Counterpart to Solidity's `/` operator. Note: this function uses a
240      * `revert` opcode (which leaves remaining gas untouched) while Solidity
241      * uses an invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function div(uint256 a, uint256 b) internal pure returns (uint256) {
248         return div(a, b, "SafeMath: division by zero");
249     }
250 
251     /**
252      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
253      * division by zero. The result is rounded towards zero.
254      *
255      * Counterpart to Solidity's `/` operator. Note: this function uses a
256      * `revert` opcode (which leaves remaining gas untouched) while Solidity
257      * uses an invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b > 0, errorMessage);
265         uint256 c = a / b;
266         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
267 
268         return c;
269     }
270 
271     /**
272      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
273      * Reverts when dividing by zero.
274      *
275      * Counterpart to Solidity's `%` operator. This function uses a `revert`
276      * opcode (which leaves remaining gas untouched) while Solidity uses an
277      * invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      *
281      * - The divisor cannot be zero.
282      */
283     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
284         return mod(a, b, "SafeMath: modulo by zero");
285     }
286 
287     /**
288      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
289      * Reverts with custom message when dividing by zero.
290      *
291      * Counterpart to Solidity's `%` operator. This function uses a `revert`
292      * opcode (which leaves remaining gas untouched) while Solidity uses an
293      * invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      *
297      * - The divisor cannot be zero.
298      */
299     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
300         require(b != 0, errorMessage);
301         return a % b;
302     }
303 }
304 
305 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
306 
307 
308 pragma solidity ^0.6.0;
309 
310 /**
311  * @dev Interface of the ERC20 standard as defined in the EIP.
312  */
313 interface IERC20 {
314     /**
315      * @dev Returns the amount of tokens in existence.
316      */
317     function totalSupply() external view returns (uint256);
318 
319     /**
320      * @dev Returns the amount of tokens owned by `account`.
321      */
322     function balanceOf(address account) external view returns (uint256);
323 
324     /**
325      * @dev Moves `amount` tokens from the caller's account to `recipient`.
326      *
327      * Returns a boolean value indicating whether the operation succeeded.
328      *
329      * Emits a {Transfer} event.
330      */
331     function transfer(address recipient, uint256 amount) external returns (bool);
332 
333     /**
334      * @dev Returns the remaining number of tokens that `spender` will be
335      * allowed to spend on behalf of `owner` through {transferFrom}. This is
336      * zero by default.
337      *
338      * This value changes when {approve} or {transferFrom} are called.
339      */
340     function allowance(address owner, address spender) external view returns (uint256);
341 
342     /**
343      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
344      *
345      * Returns a boolean value indicating whether the operation succeeded.
346      *
347      * IMPORTANT: Beware that changing an allowance with this method brings the risk
348      * that someone may use both the old and the new allowance by unfortunate
349      * transaction ordering. One possible solution to mitigate this race
350      * condition is to first reduce the spender's allowance to 0 and set the
351      * desired value afterwards:
352      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
353      *
354      * Emits an {Approval} event.
355      */
356     function approve(address spender, uint256 amount) external returns (bool);
357 
358     /**
359      * @dev Moves `amount` tokens from `sender` to `recipient` using the
360      * allowance mechanism. `amount` is then deducted from the caller's
361      * allowance.
362      *
363      * Returns a boolean value indicating whether the operation succeeded.
364      *
365      * Emits a {Transfer} event.
366      */
367     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
368 
369     /**
370      * @dev Emitted when `value` tokens are moved from one account (`from`) to
371      * another (`to`).
372      *
373      * Note that `value` may be zero.
374      */
375     event Transfer(address indexed from, address indexed to, uint256 value);
376 
377     /**
378      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
379      * a call to {approve}. `value` is the new allowance.
380      */
381     event Approval(address indexed owner, address indexed spender, uint256 value);
382 }
383 
384 // File: @openzeppelin/contracts/GSN/Context.sol
385 
386 
387 pragma solidity ^0.6.0;
388 
389 /*
390  * @dev Provides information about the current execution context, including the
391  * sender of the transaction and its data. While these are generally available
392  * via msg.sender and msg.data, they should not be accessed in such a direct
393  * manner, since when dealing with GSN meta-transactions the account sending and
394  * paying for execution may not be the actual sender (as far as an application
395  * is concerned).
396  *
397  * This contract is only required for intermediate, library-like contracts.
398  */
399 abstract contract Context {
400     function _msgSender() internal view virtual returns (address payable) {
401         return msg.sender;
402     }
403 
404     function _msgData() internal view virtual returns (bytes memory) {
405         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
406         return msg.data;
407     }
408 }
409 
410 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
411 
412 
413 pragma solidity ^0.6.0;
414 
415 
416 
417 
418 
419 /**
420  * @dev Implementation of the {IERC20} interface.
421  *
422  * This implementation is agnostic to the way tokens are created. This means
423  * that a supply mechanism has to be added in a derived contract using {_mint}.
424  * For a generic mechanism see {ERC20PresetMinterPauser}.
425  *
426  * TIP: For a detailed writeup see our guide
427  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
428  * to implement supply mechanisms].
429  *
430  * We have followed general OpenZeppelin guidelines: functions revert instead
431  * of returning `false` on failure. This behavior is nonetheless conventional
432  * and does not conflict with the expectations of ERC20 applications.
433  *
434  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
435  * This allows applications to reconstruct the allowance for all accounts just
436  * by listening to said events. Other implementations of the EIP may not emit
437  * these events, as it isn't required by the specification.
438  *
439  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
440  * functions have been added to mitigate the well-known issues around setting
441  * allowances. See {IERC20-approve}.
442  */
443 contract ERC20 is Context, IERC20 {
444     using SafeMath for uint256;
445     using Address for address;
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
466     constructor (string memory name, string memory symbol) public {
467         _name = name;
468         _symbol = symbol;
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
554      * required by the EIP. See the note at the beginning of {ERC20};
555      *
556      * Requirements:
557      * - `sender` and `recipient` cannot be the zero address.
558      * - `sender` must have a balance of at least `amount`.
559      * - the caller must have allowance for ``sender``'s tokens of at least
560      * `amount`.
561      */
562     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
563         _transfer(sender, recipient, amount);
564         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
565         return true;
566     }
567 
568     /**
569      * @dev Atomically increases the allowance granted to `spender` by the caller.
570      *
571      * This is an alternative to {approve} that can be used as a mitigation for
572      * problems described in {IERC20-approve}.
573      *
574      * Emits an {Approval} event indicating the updated allowance.
575      *
576      * Requirements:
577      *
578      * - `spender` cannot be the zero address.
579      */
580     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
581         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
582         return true;
583     }
584 
585     /**
586      * @dev Atomically decreases the allowance granted to `spender` by the caller.
587      *
588      * This is an alternative to {approve} that can be used as a mitigation for
589      * problems described in {IERC20-approve}.
590      *
591      * Emits an {Approval} event indicating the updated allowance.
592      *
593      * Requirements:
594      *
595      * - `spender` cannot be the zero address.
596      * - `spender` must have allowance for the caller of at least
597      * `subtractedValue`.
598      */
599     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
600         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
601         return true;
602     }
603 
604     /**
605      * @dev Moves tokens `amount` from `sender` to `recipient`.
606      *
607      * This is internal function is equivalent to {transfer}, and can be used to
608      * e.g. implement automatic token fees, slashing mechanisms, etc.
609      *
610      * Emits a {Transfer} event.
611      *
612      * Requirements:
613      *
614      * - `sender` cannot be the zero address.
615      * - `recipient` cannot be the zero address.
616      * - `sender` must have a balance of at least `amount`.
617      */
618     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
619         require(sender != address(0), "ERC20: transfer from the zero address");
620         require(recipient != address(0), "ERC20: transfer to the zero address");
621 
622         _beforeTokenTransfer(sender, recipient, amount);
623 
624         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
625         _balances[recipient] = _balances[recipient].add(amount);
626         emit Transfer(sender, recipient, amount);
627     }
628 
629     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
630      * the total supply.
631      *
632      * Emits a {Transfer} event with `from` set to the zero address.
633      *
634      * Requirements
635      *
636      * - `to` cannot be the zero address.
637      */
638     function _mint(address account, uint256 amount) internal virtual {
639         require(account != address(0), "ERC20: mint to the zero address");
640 
641         _beforeTokenTransfer(address(0), account, amount);
642 
643         _totalSupply = _totalSupply.add(amount);
644         _balances[account] = _balances[account].add(amount);
645         emit Transfer(address(0), account, amount);
646     }
647 
648     /**
649      * @dev Destroys `amount` tokens from `account`, reducing the
650      * total supply.
651      *
652      * Emits a {Transfer} event with `to` set to the zero address.
653      *
654      * Requirements
655      *
656      * - `account` cannot be the zero address.
657      * - `account` must have at least `amount` tokens.
658      */
659     function _burn(address account, uint256 amount) internal virtual {
660         require(account != address(0), "ERC20: burn from the zero address");
661 
662         _beforeTokenTransfer(account, address(0), amount);
663 
664         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
665         _totalSupply = _totalSupply.sub(amount);
666         emit Transfer(account, address(0), amount);
667     }
668 
669     /**
670      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
671      *
672      * This is internal function is equivalent to `approve`, and can be used to
673      * e.g. set automatic allowances for certain subsystems, etc.
674      *
675      * Emits an {Approval} event.
676      *
677      * Requirements:
678      *
679      * - `owner` cannot be the zero address.
680      * - `spender` cannot be the zero address.
681      */
682     function _approve(address owner, address spender, uint256 amount) internal virtual {
683         require(owner != address(0), "ERC20: approve from the zero address");
684         require(spender != address(0), "ERC20: approve to the zero address");
685 
686         _allowances[owner][spender] = amount;
687         emit Approval(owner, spender, amount);
688     }
689 
690     /**
691      * @dev Sets {decimals} to a value other than the default one of 18.
692      *
693      * WARNING: This function should only be called from the constructor. Most
694      * applications that interact with token contracts will not expect
695      * {decimals} to ever change, and may work incorrectly if it does.
696      */
697     function _setupDecimals(uint8 decimals_) internal {
698         _decimals = decimals_;
699     }
700 
701     /**
702      * @dev Hook that is called before any transfer of tokens. This includes
703      * minting and burning.
704      *
705      * Calling conditions:
706      *
707      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
708      * will be to transferred to `to`.
709      * - when `from` is zero, `amount` tokens will be minted for `to`.
710      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
711      * - `from` and `to` are never both zero.
712      *
713      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
714      */
715     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
716 }
717 
718 // File: localhost/contracts/AdmToken.sol
719 
720 
721 pragma solidity ^0.6.0;
722 
723 
724 contract AdmToken is ERC20 {
725     constructor(address initialOwner, uint256 initialSupply) public ERC20("Apex Digital Market", "ADM") {
726         _mint(initialOwner, initialSupply);
727     }
728 }