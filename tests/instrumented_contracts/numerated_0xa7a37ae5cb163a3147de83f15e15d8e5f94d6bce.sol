1 // hevm: flattened sources of src/pickle-jar.sol
2 pragma solidity >=0.6.0 <0.7.0 >=0.6.7 <0.7.0;
3 
4 ////// src/interfaces/controller.sol
5 // SPDX-License-Identifier: MIT
6 
7 /* pragma solidity ^0.6.0; */
8 
9 interface IController {
10     function jars(address) external view returns (address);
11 
12     function rewards() external view returns (address);
13 
14     function devfund() external view returns (address);
15 
16     function treasury() external view returns (address);
17 
18     function balanceOf(address) external view returns (uint256);
19 
20     function withdraw(address, uint256) external;
21 
22     function earn(address, uint256) external;
23 }
24 
25 ////// src/lib/context.sol
26 // SPDX-License-Identifier: MIT
27 
28 /* pragma solidity ^0.6.0; */
29 
30 /*
31  * @dev Provides information about the current execution context, including the
32  * sender of the transaction and its data. While these are generally available
33  * via msg.sender and msg.data, they should not be accessed in such a direct
34  * manner, since when dealing with GSN meta-transactions the account sending and
35  * paying for execution may not be the actual sender (as far as an application
36  * is concerned).
37  *
38  * This contract is only required for intermediate, library-like contracts.
39  */
40 abstract contract Context {
41     function _msgSender() internal view virtual returns (address payable) {
42         return msg.sender;
43     }
44 
45     function _msgData() internal view virtual returns (bytes memory) {
46         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
47         return msg.data;
48     }
49 }
50 
51 ////// src/lib/safe-math.sol
52 // SPDX-License-Identifier: MIT
53 
54 /* pragma solidity ^0.6.0; */
55 
56 /**
57  * @dev Wrappers over Solidity's arithmetic operations with added overflow
58  * checks.
59  *
60  * Arithmetic operations in Solidity wrap on overflow. This can easily result
61  * in bugs, because programmers usually assume that an overflow raises an
62  * error, which is the standard behavior in high level programming languages.
63  * `SafeMath` restores this intuition by reverting the transaction when an
64  * operation overflows.
65  *
66  * Using this library instead of the unchecked operations eliminates an entire
67  * class of bugs, so it's recommended to use it always.
68  */
69 library SafeMath {
70     /**
71      * @dev Returns the addition of two unsigned integers, reverting on
72      * overflow.
73      *
74      * Counterpart to Solidity's `+` operator.
75      *
76      * Requirements:
77      *
78      * - Addition cannot overflow.
79      */
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         require(c >= a, "SafeMath: addition overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the subtraction of two unsigned integers, reverting on
89      * overflow (when the result is negative).
90      *
91      * Counterpart to Solidity's `-` operator.
92      *
93      * Requirements:
94      *
95      * - Subtraction cannot overflow.
96      */
97     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98         return sub(a, b, "SafeMath: subtraction overflow");
99     }
100 
101     /**
102      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
103      * overflow (when the result is negative).
104      *
105      * Counterpart to Solidity's `-` operator.
106      *
107      * Requirements:
108      *
109      * - Subtraction cannot overflow.
110      */
111     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
112         require(b <= a, errorMessage);
113         uint256 c = a - b;
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the multiplication of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `*` operator.
123      *
124      * Requirements:
125      *
126      * - Multiplication cannot overflow.
127      */
128     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
129         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
130         // benefit is lost if 'b' is also tested.
131         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
132         if (a == 0) {
133             return 0;
134         }
135 
136         uint256 c = a * b;
137         require(c / a == b, "SafeMath: multiplication overflow");
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the integer division of two unsigned integers. Reverts on
144      * division by zero. The result is rounded towards zero.
145      *
146      * Counterpart to Solidity's `/` operator. Note: this function uses a
147      * `revert` opcode (which leaves remaining gas untouched) while Solidity
148      * uses an invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function div(uint256 a, uint256 b) internal pure returns (uint256) {
155         return div(a, b, "SafeMath: division by zero");
156     }
157 
158     /**
159      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
160      * division by zero. The result is rounded towards zero.
161      *
162      * Counterpart to Solidity's `/` operator. Note: this function uses a
163      * `revert` opcode (which leaves remaining gas untouched) while Solidity
164      * uses an invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      *
168      * - The divisor cannot be zero.
169      */
170     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b > 0, errorMessage);
172         uint256 c = a / b;
173         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
180      * Reverts when dividing by zero.
181      *
182      * Counterpart to Solidity's `%` operator. This function uses a `revert`
183      * opcode (which leaves remaining gas untouched) while Solidity uses an
184      * invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
191         return mod(a, b, "SafeMath: modulo by zero");
192     }
193 
194     /**
195      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
196      * Reverts with custom message when dividing by zero.
197      *
198      * Counterpart to Solidity's `%` operator. This function uses a `revert`
199      * opcode (which leaves remaining gas untouched) while Solidity uses an
200      * invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207         require(b != 0, errorMessage);
208         return a % b;
209     }
210 }
211 ////// src/lib/erc20.sol
212 
213 // File: contracts/GSN/Context.sol
214 
215 // SPDX-License-Identifier: MIT
216 
217 /* pragma solidity ^0.6.0; */
218 
219 /* import "./safe-math.sol"; */
220 /* import "./context.sol"; */
221 
222 // File: contracts/token/ERC20/IERC20.sol
223 
224 
225 /**
226  * @dev Interface of the ERC20 standard as defined in the EIP.
227  */
228 interface IERC20_1 {
229     /**
230      * @dev Returns the amount of tokens in existence.
231      */
232     function totalSupply() external view returns (uint256);
233 
234     /**
235      * @dev Returns the amount of tokens owned by `account`.
236      */
237     function balanceOf(address account) external view returns (uint256);
238 
239     /**
240      * @dev Moves `amount` tokens from the caller's account to `recipient`.
241      *
242      * Returns a boolean value indicating whether the operation succeeded.
243      *
244      * Emits a {Transfer} event.
245      */
246     function transfer(address recipient, uint256 amount) external returns (bool);
247 
248     /**
249      * @dev Returns the remaining number of tokens that `spender` will be
250      * allowed to spend on behalf of `owner` through {transferFrom}. This is
251      * zero by default.
252      *
253      * This value changes when {approve} or {transferFrom} are called.
254      */
255     function allowance(address owner, address spender) external view returns (uint256);
256 
257     /**
258      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
259      *
260      * Returns a boolean value indicating whether the operation succeeded.
261      *
262      * IMPORTANT: Beware that changing an allowance with this method brings the risk
263      * that someone may use both the old and the new allowance by unfortunate
264      * transaction ordering. One possible solution to mitigate this race
265      * condition is to first reduce the spender's allowance to 0 and set the
266      * desired value afterwards:
267      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
268      *
269      * Emits an {Approval} event.
270      */
271     function approve(address spender, uint256 amount) external returns (bool);
272 
273     /**
274      * @dev Moves `amount` tokens from `sender` to `recipient` using the
275      * allowance mechanism. `amount` is then deducted from the caller's
276      * allowance.
277      *
278      * Returns a boolean value indicating whether the operation succeeded.
279      *
280      * Emits a {Transfer} event.
281      */
282     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
283 
284     /**
285      * @dev Emitted when `value` tokens are moved from one account (`from`) to
286      * another (`to`).
287      *
288      * Note that `value` may be zero.
289      */
290     event Transfer(address indexed from, address indexed to, uint256 value);
291 
292     /**
293      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
294      * a call to {approve}. `value` is the new allowance.
295      */
296     event Approval(address indexed owner, address indexed spender, uint256 value);
297 }
298 
299 // File: contracts/utils/Address.sol
300 
301 
302 /**
303  * @dev Collection of functions related to the address type
304  */
305 library Address {
306     /**
307      * @dev Returns true if `account` is a contract.
308      *
309      * [IMPORTANT]
310      * ====
311      * It is unsafe to assume that an address for which this function returns
312      * false is an externally-owned account (EOA) and not a contract.
313      *
314      * Among others, `isContract` will return false for the following
315      * types of addresses:
316      *
317      *  - an externally-owned account
318      *  - a contract in construction
319      *  - an address where a contract will be created
320      *  - an address where a contract lived, but was destroyed
321      * ====
322      */
323     function isContract(address account) internal view returns (bool) {
324         // This method relies on extcodesize, which returns 0 for contracts in
325         // construction, since the code is only stored at the end of the
326         // constructor execution.
327 
328         uint256 size;
329         // solhint-disable-next-line no-inline-assembly
330         assembly { size := extcodesize(account) }
331         return size > 0;
332     }
333 
334     /**
335      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
336      * `recipient`, forwarding all available gas and reverting on errors.
337      *
338      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
339      * of certain opcodes, possibly making contracts go over the 2300 gas limit
340      * imposed by `transfer`, making them unable to receive funds via
341      * `transfer`. {sendValue} removes this limitation.
342      *
343      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
344      *
345      * IMPORTANT: because control is transferred to `recipient`, care must be
346      * taken to not create reentrancy vulnerabilities. Consider using
347      * {ReentrancyGuard} or the
348      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
349      */
350     function sendValue(address payable recipient, uint256 amount) internal {
351         require(address(this).balance >= amount, "Address: insufficient balance");
352 
353         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
354         (bool success, ) = recipient.call{ value: amount }("");
355         require(success, "Address: unable to send value, recipient may have reverted");
356     }
357 
358     /**
359      * @dev Performs a Solidity function call using a low level `call`. A
360      * plain`call` is an unsafe replacement for a function call: use this
361      * function instead.
362      *
363      * If `target` reverts with a revert reason, it is bubbled up by this
364      * function (like regular Solidity function calls).
365      *
366      * Returns the raw returned data. To convert to the expected return value,
367      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
368      *
369      * Requirements:
370      *
371      * - `target` must be a contract.
372      * - calling `target` with `data` must not revert.
373      *
374      * _Available since v3.1._
375      */
376     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
377       return functionCall(target, data, "Address: low-level call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
382      * `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
387         return _functionCallWithValue(target, data, 0, errorMessage);
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
392      * but also transferring `value` wei to `target`.
393      *
394      * Requirements:
395      *
396      * - the calling contract must have an ETH balance of at least `value`.
397      * - the called Solidity function must be `payable`.
398      *
399      * _Available since v3.1._
400      */
401     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
402         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
407      * with `errorMessage` as a fallback revert reason when `target` reverts.
408      *
409      * _Available since v3.1._
410      */
411     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
412         require(address(this).balance >= value, "Address: insufficient balance for call");
413         return _functionCallWithValue(target, data, value, errorMessage);
414     }
415 
416     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
417         require(isContract(target), "Address: call to non-contract");
418 
419         // solhint-disable-next-line avoid-low-level-calls
420         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
421         if (success) {
422             return returndata;
423         } else {
424             // Look for revert reason and bubble it up if present
425             if (returndata.length > 0) {
426                 // The easiest way to bubble the revert reason is using memory via assembly
427 
428                 // solhint-disable-next-line no-inline-assembly
429                 assembly {
430                     let returndata_size := mload(returndata)
431                     revert(add(32, returndata), returndata_size)
432                 }
433             } else {
434                 revert(errorMessage);
435             }
436         }
437     }
438 }
439 
440 // File: contracts/token/ERC20/ERC20.sol
441 
442 /**
443  * @dev Implementation of the {IERC20} interface.
444  *
445  * This implementation is agnostic to the way tokens are created. This means
446  * that a supply mechanism has to be added in a derived contract using {_mint}.
447  * For a generic mechanism see {ERC20PresetMinterPauser}.
448  *
449  * TIP: For a detailed writeup see our guide
450  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
451  * to implement supply mechanisms].
452  *
453  * We have followed general OpenZeppelin guidelines: functions revert instead
454  * of returning `false` on failure. This behavior is nonetheless conventional
455  * and does not conflict with the expectations of ERC20 applications.
456  *
457  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
458  * This allows applications to reconstruct the allowance for all accounts just
459  * by listening to said events. Other implementations of the EIP may not emit
460  * these events, as it isn't required by the specification.
461  *
462  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
463  * functions have been added to mitigate the well-known issues around setting
464  * allowances. See {IERC20-approve}.
465  */
466 contract ERC20 is Context, IERC20_1 {
467     using SafeMath for uint256;
468     using Address for address;
469 
470     mapping (address => uint256) private _balances;
471 
472     mapping (address => mapping (address => uint256)) private _allowances;
473 
474     uint256 private _totalSupply;
475 
476     string private _name;
477     string private _symbol;
478     uint8 private _decimals;
479 
480     /**
481      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
482      * a default value of 18.
483      *
484      * To select a different value for {decimals}, use {_setupDecimals}.
485      *
486      * All three of these values are immutable: they can only be set once during
487      * construction.
488      */
489     constructor (string memory name, string memory symbol) public {
490         _name = name;
491         _symbol = symbol;
492         _decimals = 18;
493     }
494 
495     /**
496      * @dev Returns the name of the token.
497      */
498     function name() public view returns (string memory) {
499         return _name;
500     }
501 
502     /**
503      * @dev Returns the symbol of the token, usually a shorter version of the
504      * name.
505      */
506     function symbol() public view returns (string memory) {
507         return _symbol;
508     }
509 
510     /**
511      * @dev Returns the number of decimals used to get its user representation.
512      * For example, if `decimals` equals `2`, a balance of `505` tokens should
513      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
514      *
515      * Tokens usually opt for a value of 18, imitating the relationship between
516      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
517      * called.
518      *
519      * NOTE: This information is only used for _display_ purposes: it in
520      * no way affects any of the arithmetic of the contract, including
521      * {IERC20-balanceOf} and {IERC20-transfer}.
522      */
523     function decimals() public view returns (uint8) {
524         return _decimals;
525     }
526 
527     /**
528      * @dev See {IERC20-totalSupply}.
529      */
530     function totalSupply() public view override returns (uint256) {
531         return _totalSupply;
532     }
533 
534     /**
535      * @dev See {IERC20-balanceOf}.
536      */
537     function balanceOf(address account) public view override returns (uint256) {
538         return _balances[account];
539     }
540 
541     /**
542      * @dev See {IERC20-transfer}.
543      *
544      * Requirements:
545      *
546      * - `recipient` cannot be the zero address.
547      * - the caller must have a balance of at least `amount`.
548      */
549     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
550         _transfer(_msgSender(), recipient, amount);
551         return true;
552     }
553 
554     /**
555      * @dev See {IERC20-allowance}.
556      */
557     function allowance(address owner, address spender) public view virtual override returns (uint256) {
558         return _allowances[owner][spender];
559     }
560 
561     /**
562      * @dev See {IERC20-approve}.
563      *
564      * Requirements:
565      *
566      * - `spender` cannot be the zero address.
567      */
568     function approve(address spender, uint256 amount) public virtual override returns (bool) {
569         _approve(_msgSender(), spender, amount);
570         return true;
571     }
572 
573     /**
574      * @dev See {IERC20-transferFrom}.
575      *
576      * Emits an {Approval} event indicating the updated allowance. This is not
577      * required by the EIP. See the note at the beginning of {ERC20};
578      *
579      * Requirements:
580      * - `sender` and `recipient` cannot be the zero address.
581      * - `sender` must have a balance of at least `amount`.
582      * - the caller must have allowance for ``sender``'s tokens of at least
583      * `amount`.
584      */
585     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
586         _transfer(sender, recipient, amount);
587         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
588         return true;
589     }
590 
591     /**
592      * @dev Atomically increases the allowance granted to `spender` by the caller.
593      *
594      * This is an alternative to {approve} that can be used as a mitigation for
595      * problems described in {IERC20-approve}.
596      *
597      * Emits an {Approval} event indicating the updated allowance.
598      *
599      * Requirements:
600      *
601      * - `spender` cannot be the zero address.
602      */
603     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
604         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
605         return true;
606     }
607 
608     /**
609      * @dev Atomically decreases the allowance granted to `spender` by the caller.
610      *
611      * This is an alternative to {approve} that can be used as a mitigation for
612      * problems described in {IERC20-approve}.
613      *
614      * Emits an {Approval} event indicating the updated allowance.
615      *
616      * Requirements:
617      *
618      * - `spender` cannot be the zero address.
619      * - `spender` must have allowance for the caller of at least
620      * `subtractedValue`.
621      */
622     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
623         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
624         return true;
625     }
626 
627     /**
628      * @dev Moves tokens `amount` from `sender` to `recipient`.
629      *
630      * This is internal function is equivalent to {transfer}, and can be used to
631      * e.g. implement automatic token fees, slashing mechanisms, etc.
632      *
633      * Emits a {Transfer} event.
634      *
635      * Requirements:
636      *
637      * - `sender` cannot be the zero address.
638      * - `recipient` cannot be the zero address.
639      * - `sender` must have a balance of at least `amount`.
640      */
641     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
642         require(sender != address(0), "ERC20: transfer from the zero address");
643         require(recipient != address(0), "ERC20: transfer to the zero address");
644 
645         _beforeTokenTransfer(sender, recipient, amount);
646 
647         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
648         _balances[recipient] = _balances[recipient].add(amount);
649         emit Transfer(sender, recipient, amount);
650     }
651 
652     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
653      * the total supply.
654      *
655      * Emits a {Transfer} event with `from` set to the zero address.
656      *
657      * Requirements
658      *
659      * - `to` cannot be the zero address.
660      */
661     function _mint(address account, uint256 amount) internal virtual {
662         require(account != address(0), "ERC20: mint to the zero address");
663 
664         _beforeTokenTransfer(address(0), account, amount);
665 
666         _totalSupply = _totalSupply.add(amount);
667         _balances[account] = _balances[account].add(amount);
668         emit Transfer(address(0), account, amount);
669     }
670 
671     /**
672      * @dev Destroys `amount` tokens from `account`, reducing the
673      * total supply.
674      *
675      * Emits a {Transfer} event with `to` set to the zero address.
676      *
677      * Requirements
678      *
679      * - `account` cannot be the zero address.
680      * - `account` must have at least `amount` tokens.
681      */
682     function _burn(address account, uint256 amount) internal virtual {
683         require(account != address(0), "ERC20: burn from the zero address");
684 
685         _beforeTokenTransfer(account, address(0), amount);
686 
687         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
688         _totalSupply = _totalSupply.sub(amount);
689         emit Transfer(account, address(0), amount);
690     }
691 
692     /**
693      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
694      *
695      * This internal function is equivalent to `approve`, and can be used to
696      * e.g. set automatic allowances for certain subsystems, etc.
697      *
698      * Emits an {Approval} event.
699      *
700      * Requirements:
701      *
702      * - `owner` cannot be the zero address.
703      * - `spender` cannot be the zero address.
704      */
705     function _approve(address owner, address spender, uint256 amount) internal virtual {
706         require(owner != address(0), "ERC20: approve from the zero address");
707         require(spender != address(0), "ERC20: approve to the zero address");
708 
709         _allowances[owner][spender] = amount;
710         emit Approval(owner, spender, amount);
711     }
712 
713     /**
714      * @dev Sets {decimals} to a value other than the default one of 18.
715      *
716      * WARNING: This function should only be called from the constructor. Most
717      * applications that interact with token contracts will not expect
718      * {decimals} to ever change, and may work incorrectly if it does.
719      */
720     function _setupDecimals(uint8 decimals_) internal {
721         _decimals = decimals_;
722     }
723 
724     /**
725      * @dev Hook that is called before any transfer of tokens. This includes
726      * minting and burning.
727      *
728      * Calling conditions:
729      *
730      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
731      * will be to transferred to `to`.
732      * - when `from` is zero, `amount` tokens will be minted for `to`.
733      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
734      * - `from` and `to` are never both zero.
735      *
736      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
737      */
738     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
739 }
740 
741 /**
742  * @title SafeERC20
743  * @dev Wrappers around ERC20 operations that throw on failure (when the token
744  * contract returns false). Tokens that return no value (and instead revert or
745  * throw on failure) are also supported, non-reverting calls are assumed to be
746  * successful.
747  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
748  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
749  */
750 library SafeERC20 {
751     using SafeMath for uint256;
752     using Address for address;
753 
754     function safeTransfer(IERC20_1 token, address to, uint256 value) internal {
755         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
756     }
757 
758     function safeTransferFrom(IERC20_1 token, address from, address to, uint256 value) internal {
759         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
760     }
761 
762     /**
763      * @dev Deprecated. This function has issues similar to the ones found in
764      * {IERC20-approve}, and its usage is discouraged.
765      *
766      * Whenever possible, use {safeIncreaseAllowance} and
767      * {safeDecreaseAllowance} instead.
768      */
769     function safeApprove(IERC20_1 token, address spender, uint256 value) internal {
770         // safeApprove should only be called when setting an initial allowance,
771         // or when resetting it to zero. To increase and decrease it, use
772         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
773         // solhint-disable-next-line max-line-length
774         require((value == 0) || (token.allowance(address(this), spender) == 0),
775             "SafeERC20: approve from non-zero to non-zero allowance"
776         );
777         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
778     }
779 
780     function safeIncreaseAllowance(IERC20_1 token, address spender, uint256 value) internal {
781         uint256 newAllowance = token.allowance(address(this), spender).add(value);
782         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
783     }
784 
785     function safeDecreaseAllowance(IERC20_1 token, address spender, uint256 value) internal {
786         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
787         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
788     }
789 
790     /**
791      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
792      * on the return value: the return value is optional (but if data is returned, it must not be false).
793      * @param token The token targeted by the call.
794      * @param data The call data (encoded using abi.encode or one of its variants).
795      */
796     function _callOptionalReturn(IERC20_1 token, bytes memory data) private {
797         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
798         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
799         // the target address contains contract code and also asserts for success in the low-level call.
800 
801         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
802         if (returndata.length > 0) { // Return data is optional
803             // solhint-disable-next-line max-line-length
804             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
805         }
806     }
807 }
808 ////// src/pickle-jar.sol
809 // https://github.com/iearn-finance/vaults/blob/master/contracts/vaults/yVault.sol
810 
811 /* pragma solidity ^0.6.7; */
812 
813 /* import "./interfaces/controller.sol"; */
814 
815 /* import "./lib/erc20.sol"; */
816 /* import "./lib/safe-math.sol"; */
817 
818 contract PickleJar is ERC20 {
819     using SafeERC20 for IERC20_1;
820     using Address for address;
821     using SafeMath for uint256;
822 
823     IERC20_1 public token;
824 
825     uint256 public min = 9500;
826     uint256 public constant max = 10000;
827 
828     address public governance;
829     address public timelock;
830     address public controller;
831 
832     constructor(address _token, address _governance, address _timelock, address _controller)
833         public
834         ERC20(
835             string(abi.encodePacked("pickling ", ERC20(_token).name())),
836             string(abi.encodePacked("p", ERC20(_token).symbol()))
837         )
838     {
839         _setupDecimals(ERC20(_token).decimals());
840         token = IERC20_1(_token);
841         governance = _governance;
842         timelock = _timelock;
843         controller = _controller;
844     }
845 
846     function balance() public view returns (uint256) {
847         return
848             token.balanceOf(address(this)).add(
849                 IController(controller).balanceOf(address(token))
850             );
851     }
852 
853     function setMin(uint256 _min) external {
854         require(msg.sender == governance, "!governance");
855         require(_min <= max, "numerator cannot be greater than denominator");
856         min = _min;
857     }
858 
859     function setGovernance(address _governance) public {
860         require(msg.sender == governance, "!governance");
861         governance = _governance;
862     }
863 
864     function setTimelock(address _timelock) public {
865         require(msg.sender == timelock, "!timelock");
866         timelock = _timelock;
867     }
868 
869     function setController(address _controller) public {
870         require(msg.sender == timelock, "!timelock");
871         controller = _controller;
872     }
873 
874     // Custom logic in here for how much the jars allows to be borrowed
875     // Sets minimum required on-hand to keep small withdrawals cheap
876     function available() public view returns (uint256) {
877         return token.balanceOf(address(this)).mul(min).div(max);
878     }
879 
880     function earn() public {
881         uint256 _bal = available();
882         token.safeTransfer(controller, _bal);
883         IController(controller).earn(address(token), _bal);
884     }
885 
886     function depositAll() external {
887         deposit(token.balanceOf(msg.sender));
888     }
889 
890     function deposit(uint256 _amount) public {
891         uint256 _pool = balance();
892         uint256 _before = token.balanceOf(address(this));
893         token.safeTransferFrom(msg.sender, address(this), _amount);
894         uint256 _after = token.balanceOf(address(this));
895         _amount = _after.sub(_before); // Additional check for deflationary tokens
896         uint256 shares = 0;
897         if (totalSupply() == 0) {
898             shares = _amount;
899         } else {
900             shares = (_amount.mul(totalSupply())).div(_pool);
901         }
902         _mint(msg.sender, shares);
903     }
904 
905     function withdrawAll() external {
906         withdraw(balanceOf(msg.sender));
907     }
908 
909     // Used to swap any borrowed reserve over the debt limit to liquidate to 'token'
910     function harvest(address reserve, uint256 amount) external {
911         require(msg.sender == controller, "!controller");
912         require(reserve != address(token), "token");
913         IERC20_1(reserve).safeTransfer(controller, amount);
914     }
915 
916     // No rebalance implementation for lower fees and faster swaps
917     function withdraw(uint256 _shares) public {
918         uint256 r = (balance().mul(_shares)).div(totalSupply());
919         _burn(msg.sender, _shares);
920 
921         // Check balance
922         uint256 b = token.balanceOf(address(this));
923         if (b < r) {
924             uint256 _withdraw = r.sub(b);
925             IController(controller).withdraw(address(token), _withdraw);
926             uint256 _after = token.balanceOf(address(this));
927             uint256 _diff = _after.sub(b);
928             if (_diff < _withdraw) {
929                 r = b.add(_diff);
930             }
931         }
932 
933         token.safeTransfer(msg.sender, r);
934     }
935 
936     function getRatio() public view returns (uint256) {
937         return balance().mul(1e18).div(totalSupply());
938     }
939 }