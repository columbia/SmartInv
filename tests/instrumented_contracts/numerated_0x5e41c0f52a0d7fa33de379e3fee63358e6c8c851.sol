1 // Dependency file: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // pragma solidity ^0.6.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal virtual view returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal virtual view returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
29 
30 // pragma solidity ^0.6.0;
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * // importANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(
90         address sender,
91         address recipient,
92         uint256 amount
93     ) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 // Dependency file: @openzeppelin/contracts/math/SafeMath.sol
111 
112 // pragma solidity ^0.6.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      *
136      * - Addition cannot overflow.
137      */
138     function add(uint256 a, uint256 b) internal pure returns (uint256) {
139         uint256 c = a + b;
140         require(c >= a, "SafeMath: addition overflow");
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156         return sub(a, b, "SafeMath: subtraction overflow");
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(
170         uint256 a,
171         uint256 b,
172         string memory errorMessage
173     ) internal pure returns (uint256) {
174         require(b <= a, errorMessage);
175         uint256 c = a - b;
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the multiplication of two unsigned integers, reverting on
182      * overflow.
183      *
184      * Counterpart to Solidity's `*` operator.
185      *
186      * Requirements:
187      *
188      * - Multiplication cannot overflow.
189      */
190     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
192         // benefit is lost if 'b' is also tested.
193         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
194         if (a == 0) {
195             return 0;
196         }
197 
198         uint256 c = a * b;
199         require(c / a == b, "SafeMath: multiplication overflow");
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b) internal pure returns (uint256) {
217         return div(a, b, "SafeMath: division by zero");
218     }
219 
220     /**
221      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
222      * division by zero. The result is rounded towards zero.
223      *
224      * Counterpart to Solidity's `/` operator. Note: this function uses a
225      * `revert` opcode (which leaves remaining gas untouched) while Solidity
226      * uses an invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function div(
233         uint256 a,
234         uint256 b,
235         string memory errorMessage
236     ) internal pure returns (uint256) {
237         require(b > 0, errorMessage);
238         uint256 c = a / b;
239         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
240 
241         return c;
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
257         return mod(a, b, "SafeMath: modulo by zero");
258     }
259 
260     /**
261      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
262      * Reverts with custom message when dividing by zero.
263      *
264      * Counterpart to Solidity's `%` operator. This function uses a `revert`
265      * opcode (which leaves remaining gas untouched) while Solidity uses an
266      * invalid opcode to revert (consuming all remaining gas).
267      *
268      * Requirements:
269      *
270      * - The divisor cannot be zero.
271      */
272     function mod(
273         uint256 a,
274         uint256 b,
275         string memory errorMessage
276     ) internal pure returns (uint256) {
277         require(b != 0, errorMessage);
278         return a % b;
279     }
280 }
281 
282 // Dependency file: @openzeppelin/contracts/utils/Address.sol
283 
284 // pragma solidity ^0.6.2;
285 
286 /**
287  * @dev Collection of functions related to the address type
288  */
289 library Address {
290     /**
291      * @dev Returns true if `account` is a contract.
292      *
293      * [// importANT]
294      * ====
295      * It is unsafe to assume that an address for which this function returns
296      * false is an externally-owned account (EOA) and not a contract.
297      *
298      * Among others, `isContract` will return false for the following
299      * types of addresses:
300      *
301      *  - an externally-owned account
302      *  - a contract in construction
303      *  - an address where a contract will be created
304      *  - an address where a contract lived, but was destroyed
305      * ====
306      */
307     function isContract(address account) internal view returns (bool) {
308         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
309         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
310         // for accounts without code, i.e. `keccak256('')`
311         bytes32 codehash;
312         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
313         // solhint-disable-next-line no-inline-assembly
314         assembly {
315             codehash := extcodehash(account)
316         }
317         return (codehash != accountHash && codehash != 0x0);
318     }
319 
320     /**
321      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
322      * `recipient`, forwarding all available gas and reverting on errors.
323      *
324      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
325      * of certain opcodes, possibly making contracts go over the 2300 gas limit
326      * imposed by `transfer`, making them unable to receive funds via
327      * `transfer`. {sendValue} removes this limitation.
328      *
329      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
330      *
331      * // importANT: because control is transferred to `recipient`, care must be
332      * taken to not create reentrancy vulnerabilities. Consider using
333      * {ReentrancyGuard} or the
334      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
335      */
336     function sendValue(address payable recipient, uint256 amount) internal {
337         require(address(this).balance >= amount, "Address: insufficient balance");
338 
339         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
340         (bool success, ) = recipient.call{ value: amount }("");
341         require(success, "Address: unable to send value, recipient may have reverted");
342     }
343 
344     /**
345      * @dev Performs a Solidity function call using a low level `call`. A
346      * plain`call` is an unsafe replacement for a function call: use this
347      * function instead.
348      *
349      * If `target` reverts with a revert reason, it is bubbled up by this
350      * function (like regular Solidity function calls).
351      *
352      * Returns the raw returned data. To convert to the expected return value,
353      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
354      *
355      * Requirements:
356      *
357      * - `target` must be a contract.
358      * - calling `target` with `data` must not revert.
359      *
360      * _Available since v3.1._
361      */
362     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
363         return functionCall(target, data, "Address: low-level call failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
368      * `errorMessage` as a fallback revert reason when `target` reverts.
369      *
370      * _Available since v3.1._
371      */
372     function functionCall(
373         address target,
374         bytes memory data,
375         string memory errorMessage
376     ) internal returns (bytes memory) {
377         return _functionCallWithValue(target, data, 0, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but also transferring `value` wei to `target`.
383      *
384      * Requirements:
385      *
386      * - the calling contract must have an ETH balance of at least `value`.
387      * - the called Solidity function must be `payable`.
388      *
389      * _Available since v3.1._
390      */
391     function functionCallWithValue(
392         address target,
393         bytes memory data,
394         uint256 value
395     ) internal returns (bytes memory) {
396         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
401      * with `errorMessage` as a fallback revert reason when `target` reverts.
402      *
403      * _Available since v3.1._
404      */
405     function functionCallWithValue(
406         address target,
407         bytes memory data,
408         uint256 value,
409         string memory errorMessage
410     ) internal returns (bytes memory) {
411         require(address(this).balance >= value, "Address: insufficient balance for call");
412         return _functionCallWithValue(target, data, value, errorMessage);
413     }
414 
415     function _functionCallWithValue(
416         address target,
417         bytes memory data,
418         uint256 weiValue,
419         string memory errorMessage
420     ) private returns (bytes memory) {
421         require(isContract(target), "Address: call to non-contract");
422 
423         // solhint-disable-next-line avoid-low-level-calls
424         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
425         if (success) {
426             return returndata;
427         } else {
428             // Look for revert reason and bubble it up if present
429             if (returndata.length > 0) {
430                 // The easiest way to bubble the revert reason is using memory via assembly
431 
432                 // solhint-disable-next-line no-inline-assembly
433                 assembly {
434                     let returndata_size := mload(returndata)
435                     revert(add(32, returndata), returndata_size)
436                 }
437             } else {
438                 revert(errorMessage);
439             }
440         }
441     }
442 }
443 
444 // Dependency file: @openzeppelin/contracts/token/ERC20/ERC20.sol
445 
446 // pragma solidity ^0.6.0;
447 
448 // import "@openzeppelin/contracts/GSN/Context.sol";
449 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
450 // import "@openzeppelin/contracts/math/SafeMath.sol";
451 // import "@openzeppelin/contracts/utils/Address.sol";
452 
453 /**
454  * @dev Implementation of the {IERC20} interface.
455  *
456  * This implementation is agnostic to the way tokens are created. This means
457  * that a supply mechanism has to be added in a derived contract using {_mint}.
458  * For a generic mechanism see {ERC20PresetMinterPauser}.
459  *
460  * TIP: For a detailed writeup see our guide
461  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
462  * to implement supply mechanisms].
463  *
464  * We have followed general OpenZeppelin guidelines: functions revert instead
465  * of returning `false` on failure. This behavior is nonetheless conventional
466  * and does not conflict with the expectations of ERC20 applications.
467  *
468  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
469  * This allows applications to reconstruct the allowance for all accounts just
470  * by listening to said events. Other implementations of the EIP may not emit
471  * these events, as it isn't required by the specification.
472  *
473  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
474  * functions have been added to mitigate the well-known issues around setting
475  * allowances. See {IERC20-approve}.
476  */
477 contract ERC20 is Context, IERC20 {
478     using SafeMath for uint256;
479     using Address for address;
480 
481     mapping(address => uint256) private _balances;
482 
483     mapping(address => mapping(address => uint256)) private _allowances;
484 
485     uint256 private _totalSupply;
486 
487     string private _name;
488     string private _symbol;
489     uint8 private _decimals;
490 
491     /**
492      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
493      * a default value of 18.
494      *
495      * To select a different value for {decimals}, use {_setupDecimals}.
496      *
497      * All three of these values are immutable: they can only be set once during
498      * construction.
499      */
500     constructor(string memory name, string memory symbol) public {
501         _name = name;
502         _symbol = symbol;
503         _decimals = 18;
504     }
505 
506     /**
507      * @dev Returns the name of the token.
508      */
509     function name() public view returns (string memory) {
510         return _name;
511     }
512 
513     /**
514      * @dev Returns the symbol of the token, usually a shorter version of the
515      * name.
516      */
517     function symbol() public view returns (string memory) {
518         return _symbol;
519     }
520 
521     /**
522      * @dev Returns the number of decimals used to get its user representation.
523      * For example, if `decimals` equals `2`, a balance of `505` tokens should
524      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
525      *
526      * Tokens usually opt for a value of 18, imitating the relationship between
527      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
528      * called.
529      *
530      * NOTE: This information is only used for _display_ purposes: it in
531      * no way affects any of the arithmetic of the contract, including
532      * {IERC20-balanceOf} and {IERC20-transfer}.
533      */
534     function decimals() public view returns (uint8) {
535         return _decimals;
536     }
537 
538     /**
539      * @dev See {IERC20-totalSupply}.
540      */
541     function totalSupply() public override view returns (uint256) {
542         return _totalSupply;
543     }
544 
545     /**
546      * @dev See {IERC20-balanceOf}.
547      */
548     function balanceOf(address account) public override view returns (uint256) {
549         return _balances[account];
550     }
551 
552     /**
553      * @dev See {IERC20-transfer}.
554      *
555      * Requirements:
556      *
557      * - `recipient` cannot be the zero address.
558      * - the caller must have a balance of at least `amount`.
559      */
560     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
561         _transfer(_msgSender(), recipient, amount);
562         return true;
563     }
564 
565     /**
566      * @dev See {IERC20-allowance}.
567      */
568     function allowance(address owner, address spender) public virtual override view returns (uint256) {
569         return _allowances[owner][spender];
570     }
571 
572     /**
573      * @dev See {IERC20-approve}.
574      *
575      * Requirements:
576      *
577      * - `spender` cannot be the zero address.
578      */
579     function approve(address spender, uint256 amount) public virtual override returns (bool) {
580         _approve(_msgSender(), spender, amount);
581         return true;
582     }
583 
584     /**
585      * @dev See {IERC20-transferFrom}.
586      *
587      * Emits an {Approval} event indicating the updated allowance. This is not
588      * required by the EIP. See the note at the beginning of {ERC20};
589      *
590      * Requirements:
591      * - `sender` and `recipient` cannot be the zero address.
592      * - `sender` must have a balance of at least `amount`.
593      * - the caller must have allowance for ``sender``'s tokens of at least
594      * `amount`.
595      */
596     function transferFrom(
597         address sender,
598         address recipient,
599         uint256 amount
600     ) public virtual override returns (bool) {
601         _transfer(sender, recipient, amount);
602         _approve(
603             sender,
604             _msgSender(),
605             _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance")
606         );
607         return true;
608     }
609 
610     /**
611      * @dev Atomically increases the allowance granted to `spender` by the caller.
612      *
613      * This is an alternative to {approve} that can be used as a mitigation for
614      * problems described in {IERC20-approve}.
615      *
616      * Emits an {Approval} event indicating the updated allowance.
617      *
618      * Requirements:
619      *
620      * - `spender` cannot be the zero address.
621      */
622     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
623         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
624         return true;
625     }
626 
627     /**
628      * @dev Atomically decreases the allowance granted to `spender` by the caller.
629      *
630      * This is an alternative to {approve} that can be used as a mitigation for
631      * problems described in {IERC20-approve}.
632      *
633      * Emits an {Approval} event indicating the updated allowance.
634      *
635      * Requirements:
636      *
637      * - `spender` cannot be the zero address.
638      * - `spender` must have allowance for the caller of at least
639      * `subtractedValue`.
640      */
641     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
642         _approve(
643             _msgSender(),
644             spender,
645             _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero")
646         );
647         return true;
648     }
649 
650     /**
651      * @dev Moves tokens `amount` from `sender` to `recipient`.
652      *
653      * This is internal function is equivalent to {transfer}, and can be used to
654      * e.g. implement automatic token fees, slashing mechanisms, etc.
655      *
656      * Emits a {Transfer} event.
657      *
658      * Requirements:
659      *
660      * - `sender` cannot be the zero address.
661      * - `recipient` cannot be the zero address.
662      * - `sender` must have a balance of at least `amount`.
663      */
664     function _transfer(
665         address sender,
666         address recipient,
667         uint256 amount
668     ) internal virtual {
669         require(sender != address(0), "ERC20: transfer from the zero address");
670         require(recipient != address(0), "ERC20: transfer to the zero address");
671 
672         _beforeTokenTransfer(sender, recipient, amount);
673 
674         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
675         _balances[recipient] = _balances[recipient].add(amount);
676         emit Transfer(sender, recipient, amount);
677     }
678 
679     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
680      * the total supply.
681      *
682      * Emits a {Transfer} event with `from` set to the zero address.
683      *
684      * Requirements
685      *
686      * - `to` cannot be the zero address.
687      */
688     function _mint(address account, uint256 amount) internal virtual {
689         require(account != address(0), "ERC20: mint to the zero address");
690 
691         _beforeTokenTransfer(address(0), account, amount);
692 
693         _totalSupply = _totalSupply.add(amount);
694         _balances[account] = _balances[account].add(amount);
695         emit Transfer(address(0), account, amount);
696     }
697 
698     /**
699      * @dev Destroys `amount` tokens from `account`, reducing the
700      * total supply.
701      *
702      * Emits a {Transfer} event with `to` set to the zero address.
703      *
704      * Requirements
705      *
706      * - `account` cannot be the zero address.
707      * - `account` must have at least `amount` tokens.
708      */
709     function _burn(address account, uint256 amount) internal virtual {
710         require(account != address(0), "ERC20: burn from the zero address");
711 
712         _beforeTokenTransfer(account, address(0), amount);
713 
714         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
715         _totalSupply = _totalSupply.sub(amount);
716         emit Transfer(account, address(0), amount);
717     }
718 
719     /**
720      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
721      *
722      * This is internal function is equivalent to `approve`, and can be used to
723      * e.g. set automatic allowances for certain subsystems, etc.
724      *
725      * Emits an {Approval} event.
726      *
727      * Requirements:
728      *
729      * - `owner` cannot be the zero address.
730      * - `spender` cannot be the zero address.
731      */
732     function _approve(
733         address owner,
734         address spender,
735         uint256 amount
736     ) internal virtual {
737         require(owner != address(0), "ERC20: approve from the zero address");
738         require(spender != address(0), "ERC20: approve to the zero address");
739 
740         _allowances[owner][spender] = amount;
741         emit Approval(owner, spender, amount);
742     }
743 
744     /**
745      * @dev Sets {decimals} to a value other than the default one of 18.
746      *
747      * WARNING: This function should only be called from the constructor. Most
748      * applications that interact with token contracts will not expect
749      * {decimals} to ever change, and may work incorrectly if it does.
750      */
751     function _setupDecimals(uint8 decimals_) internal {
752         _decimals = decimals_;
753     }
754 
755     /**
756      * @dev Hook that is called before any transfer of tokens. This includes
757      * minting and burning.
758      *
759      * Calling conditions:
760      *
761      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
762      * will be to transferred to `to`.
763      * - when `from` is zero, `amount` tokens will be minted for `to`.
764      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
765      * - `from` and `to` are never both zero.
766      *
767      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
768      */
769     function _beforeTokenTransfer(
770         address from,
771         address to,
772         uint256 amount
773     ) internal virtual {}
774 }
775 
776 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
777 
778 // pragma solidity ^0.6.0;
779 
780 // import "@openzeppelin/contracts/GSN/Context.sol";
781 /**
782  * @dev Contract module which provides a basic access control mechanism, where
783  * there is an account (an owner) that can be granted exclusive access to
784  * specific functions.
785  *
786  * By default, the owner account will be the one that deploys the contract. This
787  * can later be changed with {transferOwnership}.
788  *
789  * This module is used through inheritance. It will make available the modifier
790  * `onlyOwner`, which can be applied to your functions to restrict their use to
791  * the owner.
792  */
793 contract Ownable is Context {
794     address private _owner;
795 
796     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
797 
798     /**
799      * @dev Initializes the contract setting the deployer as the initial owner.
800      */
801     constructor() internal {
802         address msgSender = _msgSender();
803         _owner = msgSender;
804         emit OwnershipTransferred(address(0), msgSender);
805     }
806 
807     /**
808      * @dev Returns the address of the current owner.
809      */
810     function owner() public view returns (address) {
811         return _owner;
812     }
813 
814     /**
815      * @dev Throws if called by any account other than the owner.
816      */
817     modifier onlyOwner() {
818         require(_owner == _msgSender(), "Ownable: caller is not the owner");
819         _;
820     }
821 
822     /**
823      * @dev Leaves the contract without owner. It will not be possible to call
824      * `onlyOwner` functions anymore. Can only be called by the current owner.
825      *
826      * NOTE: Renouncing ownership will leave the contract without an owner,
827      * thereby removing any functionality that is only available to the owner.
828      */
829     function renounceOwnership() public virtual onlyOwner {
830         emit OwnershipTransferred(_owner, address(0));
831         _owner = address(0);
832     }
833 
834     /**
835      * @dev Transfers ownership of the contract to a new account (`newOwner`).
836      * Can only be called by the current owner.
837      */
838     function transferOwnership(address newOwner) public virtual onlyOwner {
839         require(newOwner != address(0), "Ownable: new owner is the zero address");
840         emit OwnershipTransferred(_owner, newOwner);
841         _owner = newOwner;
842     }
843 }
844 
845 // Root file: contracts/TempusToken.sol
846 
847 pragma solidity ^0.6.10;
848 
849 // import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
850 // import "@openzeppelin/contracts/access/Ownable.sol";
851 
852 interface IUniswapV2Pair {
853     function sync() external;
854 }
855 
856 interface IUniswapV2Factory {
857     function createPair(address tokenA, address tokenB) external returns (address pair);
858 }
859 
860 contract TempusToken is ERC20, Ownable {
861     address public pauser;
862     bool public paused;
863     bool public taxEnabled;
864     address public stakingContract;
865     address public uniswapPool;
866 
867     ERC20 public WETH;
868     IUniswapV2Factory public uniswapFactory;
869 
870     modifier onlyPauser() {
871         require(pauser == _msgSender(), "TempusToken: caller is not the pauser.");
872         _;
873     }
874 
875     modifier onlyStakingContract() {
876         require(stakingContract == _msgSender(), "TempusToken: caller is not the staking contract.");
877         _;
878     }
879 
880     constructor(
881         uint256 initialSupply,
882         ERC20 _weth,
883         IUniswapV2Factory _uniswapFactory
884     ) public Ownable() ERC20("Tempus Token", "TEMP") {
885         _mint(msg.sender, initialSupply);
886         setPauser(msg.sender);
887         paused = true;
888         taxEnabled = false;
889         WETH = ERC20(_weth);
890         uniswapFactory = IUniswapV2Factory(_uniswapFactory);
891     }
892 
893     function setUniswapPool() external onlyOwner {
894         require(uniswapPool == address(0), "TempusToken: pool already created");
895         uniswapPool = uniswapFactory.createPair(address(WETH), address(this));
896     }
897 
898     function setPauser(address newPauser) public onlyOwner {
899         require(newPauser != address(0), "TempusToken: not zero address.");
900         pauser = newPauser;
901     }
902 
903     function setStakingContract(address value) external onlyOwner {
904         require(value != address(0), "TempusToken: not zero address.");
905         stakingContract = value;
906     }
907 
908     function unpause() external onlyPauser {
909         paused = false;
910     }
911 
912     function setTaxEnabled(bool value) external onlyOwner {
913         taxEnabled = value;
914     }
915 
916     function _beforeTokenTransfer(
917         address from,
918         address to,
919         uint256 amount
920     ) internal virtual override {
921         super._beforeTokenTransfer(from, to, amount);
922         require(!paused || msg.sender == pauser, "TempusToken: token transfer while paused and not pauser role.");
923     }
924 
925     function transfer(address recipient, uint256 amount) public override returns (bool) {
926         amount = addTax(_msgSender(), recipient, amount);
927         return super.transfer(recipient, amount);
928     }
929 
930     function transferFrom(
931         address sender,
932         address recipient,
933         uint256 amount
934     ) public override returns (bool) {
935         amount = addTax(sender, recipient, amount);
936         return super.transferFrom(sender, recipient, amount);
937     }
938 
939     function addTax(
940         address from,
941         address to,
942         uint256 amount
943     ) internal returns (uint256) {
944         if (from != stakingContract && to != stakingContract && to != address(0)) {
945             if (taxEnabled) {
946                 uint256 burnAmount = amount.div(100);
947                 _burn(msg.sender, burnAmount);
948                 return amount.sub(burnAmount);
949             }
950         }
951         return amount;
952     }
953 
954     function burn(uint256 amount) external {
955         _internalBurn(amount);
956     }
957 
958     function _internalBurn(uint256 amount) internal onlyStakingContract {
959         _burn(uniswapPool, amount);
960     }
961 
962     function transferReward(address to, uint256 amount) external {
963         _transferReward(to, amount);
964     }
965 
966     function _transferReward(address to, uint256 amount) internal onlyStakingContract {
967         _transfer(uniswapPool, to, amount);
968     }
969 }