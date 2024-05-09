1 // SPDX-License-Identifier: MIT
2 
3 // import "../../utils/Address.sol";
4 
5 
6 pragma solidity ^0.7.0;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      */
29     function isContract(address account) internal view returns (bool) {
30         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
31         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
32         // for accounts without code, i.e. `keccak256('')`
33         bytes32 codehash;
34         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
35         // solhint-disable-next-line no-inline-assembly
36         assembly { codehash := extcodehash(account) }
37         return (codehash != accountHash && codehash != 0x0);
38     }
39 
40     /**
41      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
42      * `recipient`, forwarding all available gas and reverting on errors.
43      *
44      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
45      * of certain opcodes, possibly making contracts go over the 2300 gas limit
46      * imposed by `transfer`, making them unable to receive funds via
47      * `transfer`. {sendValue} removes this limitation.
48      *
49      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
50      *
51      * IMPORTANT: because control is transferred to `recipient`, care must be
52      * taken to not create reentrancy vulnerabilities. Consider using
53      * {ReentrancyGuard} or the
54      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
55      */
56     function sendValue(address payable recipient, uint256 amount) internal {
57         require(address(this).balance >= amount, "Address: insufficient balance");
58 
59         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
60         (bool success, ) = recipient.call{ value: amount }("");
61         require(success, "Address: unable to send value, recipient may have reverted");
62     }
63 
64     /**
65      * @dev Performs a Solidity function call using a low level `call`. A
66      * plain`call` is an unsafe replacement for a function call: use this
67      * function instead.
68      *
69      * If `target` reverts with a revert reason, it is bubbled up by this
70      * function (like regular Solidity function calls).
71      *
72      * Returns the raw returned data. To convert to the expected return value,
73      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
74      *
75      * Requirements:
76      *
77      * - `target` must be a contract.
78      * - calling `target` with `data` must not revert.
79      *
80      * _Available since v3.1._
81      */
82     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
83       return functionCall(target, data, "Address: low-level call failed");
84     }
85 
86     /**
87      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
88      * `errorMessage` as a fallback revert reason when `target` reverts.
89      *
90      * _Available since v3.1._
91      */
92     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
93         return _functionCallWithValue(target, data, 0, errorMessage);
94     }
95 
96     /**
97      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
98      * but also transferring `value` wei to `target`.
99      *
100      * Requirements:
101      *
102      * - the calling contract must have an ETH balance of at least `value`.
103      * - the called Solidity function must be `payable`.
104      *
105      * _Available since v3.1._
106      */
107     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
108         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
109     }
110 
111     /**
112      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
113      * with `errorMessage` as a fallback revert reason when `target` reverts.
114      *
115      * _Available since v3.1._
116      */
117     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
118         require(address(this).balance >= value, "Address: insufficient balance for call");
119         return _functionCallWithValue(target, data, value, errorMessage);
120     }
121 
122     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
123         require(isContract(target), "Address: call to non-contract");
124 
125         // solhint-disable-next-line avoid-low-level-calls
126         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
127         if (success) {
128             return returndata;
129         } else {
130             // Look for revert reason and bubble it up if present
131             if (returndata.length > 0) {
132                 // The easiest way to bubble the revert reason is using memory via assembly
133 
134                 // solhint-disable-next-line no-inline-assembly
135                 assembly {
136                     let returndata_size := mload(returndata)
137                     revert(add(32, returndata), returndata_size)
138                 }
139             } else {
140                 revert(errorMessage);
141             }
142         }
143     }
144 }
145 
146 // import "../../math/SafeMath.sol";
147 
148 pragma solidity ^0.7.0;
149 
150 /**
151  * @dev Wrappers over Solidity's arithmetic operations with added overflow
152  * checks.
153  *
154  * Arithmetic operations in Solidity wrap on overflow. This can easily result
155  * in bugs, because programmers usually assume that an overflow raises an
156  * error, which is the standard behavior in high level programming languages.
157  * `SafeMath` restores this intuition by reverting the transaction when an
158  * operation overflows.
159  *
160  * Using this library instead of the unchecked operations eliminates an entire
161  * class of bugs, so it's recommended to use it always.
162  */
163 library SafeMath {
164     /**
165      * @dev Returns the addition of two unsigned integers, reverting on
166      * overflow.
167      *
168      * Counterpart to Solidity's `+` operator.
169      *
170      * Requirements:
171      *
172      * - Addition cannot overflow.
173      */
174     function add(uint256 a, uint256 b) internal pure returns (uint256) {
175         uint256 c = a + b;
176         require(c >= a, "SafeMath: addition overflow");
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the subtraction of two unsigned integers, reverting on
183      * overflow (when the result is negative).
184      *
185      * Counterpart to Solidity's `-` operator.
186      *
187      * Requirements:
188      *
189      * - Subtraction cannot overflow.
190      */
191     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
192         return sub(a, b, "SafeMath: subtraction overflow");
193     }
194 
195     /**
196      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
197      * overflow (when the result is negative).
198      *
199      * Counterpart to Solidity's `-` operator.
200      *
201      * Requirements:
202      *
203      * - Subtraction cannot overflow.
204      */
205     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
206         require(b <= a, errorMessage);
207         uint256 c = a - b;
208 
209         return c;
210     }
211 
212     /**
213      * @dev Returns the multiplication of two unsigned integers, reverting on
214      * overflow.
215      *
216      * Counterpart to Solidity's `*` operator.
217      *
218      * Requirements:
219      *
220      * - Multiplication cannot overflow.
221      */
222     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
223         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
224         // benefit is lost if 'b' is also tested.
225         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
226         if (a == 0) {
227             return 0;
228         }
229 
230         uint256 c = a * b;
231         require(c / a == b, "SafeMath: multiplication overflow");
232 
233         return c;
234     }
235 
236     /**
237      * @dev Returns the integer division of two unsigned integers. Reverts on
238      * division by zero. The result is rounded towards zero.
239      *
240      * Counterpart to Solidity's `/` operator. Note: this function uses a
241      * `revert` opcode (which leaves remaining gas untouched) while Solidity
242      * uses an invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function div(uint256 a, uint256 b) internal pure returns (uint256) {
249         return div(a, b, "SafeMath: division by zero");
250     }
251 
252     /**
253      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
254      * division by zero. The result is rounded towards zero.
255      *
256      * Counterpart to Solidity's `/` operator. Note: this function uses a
257      * `revert` opcode (which leaves remaining gas untouched) while Solidity
258      * uses an invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265         require(b > 0, errorMessage);
266         uint256 c = a / b;
267         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
268 
269         return c;
270     }
271 
272     /**
273      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
274      * Reverts when dividing by zero.
275      *
276      * Counterpart to Solidity's `%` operator. This function uses a `revert`
277      * opcode (which leaves remaining gas untouched) while Solidity uses an
278      * invalid opcode to revert (consuming all remaining gas).
279      *
280      * Requirements:
281      *
282      * - The divisor cannot be zero.
283      */
284     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
285         return mod(a, b, "SafeMath: modulo by zero");
286     }
287 
288     /**
289      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
290      * Reverts with custom message when dividing by zero.
291      *
292      * Counterpart to Solidity's `%` operator. This function uses a `revert`
293      * opcode (which leaves remaining gas untouched) while Solidity uses an
294      * invalid opcode to revert (consuming all remaining gas).
295      *
296      * Requirements:
297      *
298      * - The divisor cannot be zero.
299      */
300     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
301         require(b != 0, errorMessage);
302         return a % b;
303     }
304 }
305 
306 // import "../../GSN/Context.sol";
307 
308 pragma solidity ^0.7.0;
309 
310 /*
311  * @dev Provides information about the current execution context, including the
312  * sender of the transaction and its data. While these are generally available
313  * via msg.sender and msg.data, they should not be accessed in such a direct
314  * manner, since when dealing with GSN meta-transactions the account sending and
315  * paying for execution may not be the actual sender (as far as an application
316  * is concerned).
317  *
318  * This contract is only required for intermediate, library-like contracts.
319  */
320 abstract contract Context {
321     function _msgSender() internal view virtual returns (address payable) {
322         return msg.sender;
323     }
324 
325     function _msgData() internal view virtual returns (bytes memory) {
326         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
327         return msg.data;
328     }
329 }
330 
331 
332 
333 // import "./IERC20.sol";
334 pragma solidity ^0.7.0;
335 
336 /**
337  * @dev Interface of the ERC20 standard as defined in the EIP.
338  */
339 interface IERC20 {
340     /**
341      * @dev Returns the amount of tokens in existence.
342      */
343     function totalSupply() external view returns (uint256);
344 
345     /**
346      * @dev Returns the amount of tokens owned by `account`.
347      */
348     function balanceOf(address account) external view returns (uint256);
349 
350     /**
351      * @dev Moves `amount` tokens from the caller's account to `recipient`.
352      *
353      * Returns a boolean value indicating whether the operation succeeded.
354      *
355      * Emits a {Transfer} event.
356      */
357     function transfer(address recipient, uint256 amount) external returns (bool);
358 
359     /**
360      * @dev Returns the remaining number of tokens that `spender` will be
361      * allowed to spend on behalf of `owner` through {transferFrom}. This is
362      * zero by default.
363      *
364      * This value changes when {approve} or {transferFrom} are called.
365      */
366     function allowance(address owner, address spender) external view returns (uint256);
367 
368     /**
369      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
370      *
371      * Returns a boolean value indicating whether the operation succeeded.
372      *
373      * IMPORTANT: Beware that changing an allowance with this method brings the risk
374      * that someone may use both the old and the new allowance by unfortunate
375      * transaction ordering. One possible solution to mitigate this race
376      * condition is to first reduce the spender's allowance to 0 and set the
377      * desired value afterwards:
378      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
379      *
380      * Emits an {Approval} event.
381      */
382     function approve(address spender, uint256 amount) external returns (bool);
383 
384     /**
385      * @dev Moves `amount` tokens from `sender` to `recipient` using the
386      * allowance mechanism. `amount` is then deducted from the caller's
387      * allowance.
388      *
389      * Returns a boolean value indicating whether the operation succeeded.
390      *
391      * Emits a {Transfer} event.
392      */
393     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
394 
395     /**
396      * @dev Emitted when `value` tokens are moved from one account (`from`) to
397      * another (`to`).
398      *
399      * Note that `value` may be zero.
400      */
401     event Transfer(address indexed from, address indexed to, uint256 value);
402 
403     /**
404      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
405      * a call to {approve}. `value` is the new allowance.
406      */
407     event Approval(address indexed owner, address indexed spender, uint256 value);
408 }
409 
410 // import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.2.1-solc-0.7/contracts/token/ERC20/ERC20.sol";
411 pragma solidity ^0.7.0;
412 
413 
414 
415 /**
416  * @dev Implementation of the {IERC20} interface.
417  *
418  * This implementation is agnostic to the way tokens are created. This means
419  * that a supply mechanism has to be added in a derived contract using {_mint}.
420  * For a generic mechanism see {ERC20PresetMinterPauser}.
421  *
422  * TIP: For a detailed writeup see our guide
423  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
424  * to implement supply mechanisms].
425  *
426  * We have followed general OpenZeppelin guidelines: functions revert instead
427  * of returning `false` on failure. This behavior is nonetheless conventional
428  * and does not conflict with the expectations of ERC20 applications.
429  *
430  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
431  * This allows applications to reconstruct the allowance for all accounts just
432  * by listening to said events. Other implementations of the EIP may not emit
433  * these events, as it isn't required by the specification.
434  *
435  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
436  * functions have been added to mitigate the well-known issues around setting
437  * allowances. See {IERC20-approve}.
438  */
439 contract ERC20 is Context, IERC20 {
440     using SafeMath for uint256;
441     using Address for address;
442 
443     mapping (address => uint256) private _balances;
444 
445     mapping (address => mapping (address => uint256)) private _allowances;
446 
447     uint256 private _totalSupply;
448 
449     string private _name;
450     string private _symbol;
451     uint8 private _decimals;
452 
453     /**
454      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
455      * a default value of 18.
456      *
457      * To select a different value for {decimals}, use {_setupDecimals}.
458      *
459      * All three of these values are immutable: they can only be set once during
460      * construction.
461      */
462     constructor (string memory name, string memory symbol) {
463         _name = name;
464         _symbol = symbol;
465         _decimals = 18;
466     }
467 
468     /**
469      * @dev Returns the name of the token.
470      */
471     function name() public view returns (string memory) {
472         return _name;
473     }
474 
475     /**
476      * @dev Returns the symbol of the token, usually a shorter version of the
477      * name.
478      */
479     function symbol() public view returns (string memory) {
480         return _symbol;
481     }
482 
483     /**
484      * @dev Returns the number of decimals used to get its user representation.
485      * For example, if `decimals` equals `2`, a balance of `505` tokens should
486      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
487      *
488      * Tokens usually opt for a value of 18, imitating the relationship between
489      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
490      * called.
491      *
492      * NOTE: This information is only used for _display_ purposes: it in
493      * no way affects any of the arithmetic of the contract, including
494      * {IERC20-balanceOf} and {IERC20-transfer}.
495      */
496     function decimals() public view returns (uint8) {
497         return _decimals;
498     }
499 
500     /**
501      * @dev See {IERC20-totalSupply}.
502      */
503     function totalSupply() public view override returns (uint256) {
504         return _totalSupply;
505     }
506 
507     /**
508      * @dev See {IERC20-balanceOf}.
509      */
510     function balanceOf(address account) public view override returns (uint256) {
511         return _balances[account];
512     }
513 
514     /**
515      * @dev See {IERC20-transfer}.
516      *
517      * Requirements:
518      *
519      * - `recipient` cannot be the zero address.
520      * - the caller must have a balance of at least `amount`.
521      */
522     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
523         _transfer(_msgSender(), recipient, amount);
524         return true;
525     }
526 
527     /**
528      * @dev See {IERC20-allowance}.
529      */
530     function allowance(address owner, address spender) public view virtual override returns (uint256) {
531         return _allowances[owner][spender];
532     }
533 
534     /**
535      * @dev See {IERC20-approve}.
536      *
537      * Requirements:
538      *
539      * - `spender` cannot be the zero address.
540      */
541     function approve(address spender, uint256 amount) public virtual override returns (bool) {
542         _approve(_msgSender(), spender, amount);
543         return true;
544     }
545 
546     /**
547      * @dev See {IERC20-transferFrom}.
548      *
549      * Emits an {Approval} event indicating the updated allowance. This is not
550      * required by the EIP. See the note at the beginning of {ERC20};
551      *
552      * Requirements:
553      * - `sender` and `recipient` cannot be the zero address.
554      * - `sender` must have a balance of at least `amount`.
555      * - the caller must have allowance for ``sender``'s tokens of at least
556      * `amount`.
557      */
558     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
559         _transfer(sender, recipient, amount);
560         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
561         return true;
562     }
563 
564     /**
565      * @dev Atomically increases the allowance granted to `spender` by the caller.
566      *
567      * This is an alternative to {approve} that can be used as a mitigation for
568      * problems described in {IERC20-approve}.
569      *
570      * Emits an {Approval} event indicating the updated allowance.
571      *
572      * Requirements:
573      *
574      * - `spender` cannot be the zero address.
575      */
576     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
577         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
578         return true;
579     }
580 
581     /**
582      * @dev Atomically decreases the allowance granted to `spender` by the caller.
583      *
584      * This is an alternative to {approve} that can be used as a mitigation for
585      * problems described in {IERC20-approve}.
586      *
587      * Emits an {Approval} event indicating the updated allowance.
588      *
589      * Requirements:
590      *
591      * - `spender` cannot be the zero address.
592      * - `spender` must have allowance for the caller of at least
593      * `subtractedValue`.
594      */
595     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
596         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
597         return true;
598     }
599 
600     /**
601      * @dev Moves tokens `amount` from `sender` to `recipient`.
602      *
603      * This is internal function is equivalent to {transfer}, and can be used to
604      * e.g. implement automatic token fees, slashing mechanisms, etc.
605      *
606      * Emits a {Transfer} event.
607      *
608      * Requirements:
609      *
610      * - `sender` cannot be the zero address.
611      * - `recipient` cannot be the zero address.
612      * - `sender` must have a balance of at least `amount`.
613      */
614     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
615         require(sender != address(0), "ERC20: transfer from the zero address");
616         require(recipient != address(0), "ERC20: transfer to the zero address");
617 
618         _beforeTokenTransfer(sender, recipient, amount);
619 
620         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
621         _balances[recipient] = _balances[recipient].add(amount);
622         emit Transfer(sender, recipient, amount);
623     }
624 
625     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
626      * the total supply.
627      *
628      * Emits a {Transfer} event with `from` set to the zero address.
629      *
630      * Requirements
631      *
632      * - `to` cannot be the zero address.
633      */
634     function _mint(address account, uint256 amount) internal virtual {
635         require(account != address(0), "ERC20: mint to the zero address");
636 
637         _beforeTokenTransfer(address(0), account, amount);
638 
639         _totalSupply = _totalSupply.add(amount);
640         _balances[account] = _balances[account].add(amount);
641         emit Transfer(address(0), account, amount);
642     }
643 
644     /**
645      * @dev Destroys `amount` tokens from `account`, reducing the
646      * total supply.
647      *
648      * Emits a {Transfer} event with `to` set to the zero address.
649      *
650      * Requirements
651      *
652      * - `account` cannot be the zero address.
653      * - `account` must have at least `amount` tokens.
654      */
655     function _burn(address account, uint256 amount) internal virtual {
656         require(account != address(0), "ERC20: burn from the zero address");
657 
658         _beforeTokenTransfer(account, address(0), amount);
659 
660         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
661         _totalSupply = _totalSupply.sub(amount);
662         emit Transfer(account, address(0), amount);
663     }
664 
665     /**
666      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
667      *
668      * This internal function is equivalent to `approve`, and can be used to
669      * e.g. set automatic allowances for certain subsystems, etc.
670      *
671      * Emits an {Approval} event.
672      *
673      * Requirements:
674      *
675      * - `owner` cannot be the zero address.
676      * - `spender` cannot be the zero address.
677      */
678     function _approve(address owner, address spender, uint256 amount) internal virtual {
679         require(owner != address(0), "ERC20: approve from the zero address");
680         require(spender != address(0), "ERC20: approve to the zero address");
681 
682         _allowances[owner][spender] = amount;
683         emit Approval(owner, spender, amount);
684     }
685 
686     /**
687      * @dev Sets {decimals} to a value other than the default one of 18.
688      *
689      * WARNING: This function should only be called from the constructor. Most
690      * applications that interact with token contracts will not expect
691      * {decimals} to ever change, and may work incorrectly if it does.
692      */
693     function _setupDecimals(uint8 decimals_) internal {
694         _decimals = decimals_;
695     }
696 
697     /**
698      * @dev Hook that is called before any transfer of tokens. This includes
699      * minting and burning.
700      *
701      * Calling conditions:
702      *
703      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
704      * will be to transferred to `to`.
705      * - when `from` is zero, `amount` tokens will be minted for `to`.
706      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
707      * - `from` and `to` are never both zero.
708      *
709      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
710      */
711     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
712 }
713 
714 
715 
716 pragma solidity ^0.7.4;
717 
718 contract HEGICTokenIOU is ERC20("HEGICTokenIOU","rHEGIC") {
719     constructor(){
720         _mint(msg.sender, 3_012_009_888e18);
721     }
722 }