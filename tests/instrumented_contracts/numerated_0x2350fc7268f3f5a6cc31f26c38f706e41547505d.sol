1 pragma solidity >=0.6.0 <0.7.0 >=0.6.7 <0.7.0;
2 
3 ////// src/interfaces/controller.sol
4 // SPDX-License-Identifier: MIT
5 
6 /* pragma solidity ^0.6.0; */
7 
8 interface IController {
9     function jars(address) external view returns (address);
10 
11     function rewards() external view returns (address);
12 
13     function devfund() external view returns (address);
14 
15     function treasury() external view returns (address);
16 
17     function balanceOf(address) external view returns (uint256);
18 
19     function withdraw(address, uint256) external;
20 
21     function earn(address, uint256) external;
22 }
23 
24 ////// src/lib/context.sol
25 // SPDX-License-Identifier: MIT
26 
27 /* pragma solidity ^0.6.0; */
28 
29 /*
30  * @dev Provides information about the current execution context, including the
31  * sender of the transaction and its data. While these are generally available
32  * via msg.sender and msg.data, they should not be accessed in such a direct
33  * manner, since when dealing with GSN meta-transactions the account sending and
34  * paying for execution may not be the actual sender (as far as an application
35  * is concerned).
36  *
37  * This contract is only required for intermediate, library-like contracts.
38  */
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address payable) {
41         return msg.sender;
42     }
43 
44     function _msgData() internal view virtual returns (bytes memory) {
45         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
46         return msg.data;
47     }
48 }
49 
50 ////// src/lib/safe-math.sol
51 // SPDX-License-Identifier: MIT
52 
53 /* pragma solidity ^0.6.0; */
54 
55 /**
56  * @dev Wrappers over Solidity's arithmetic operations with added overflow
57  * checks.
58  *
59  * Arithmetic operations in Solidity wrap on overflow. This can easily result
60  * in bugs, because programmers usually assume that an overflow raises an
61  * error, which is the standard behavior in high level programming languages.
62  * `SafeMath` restores this intuition by reverting the transaction when an
63  * operation overflows.
64  *
65  * Using this library instead of the unchecked operations eliminates an entire
66  * class of bugs, so it's recommended to use it always.
67  */
68 library SafeMath {
69     /**
70      * @dev Returns the addition of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `+` operator.
74      *
75      * Requirements:
76      *
77      * - Addition cannot overflow.
78      */
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         require(c >= a, "SafeMath: addition overflow");
82 
83         return c;
84     }
85 
86     /**
87      * @dev Returns the subtraction of two unsigned integers, reverting on
88      * overflow (when the result is negative).
89      *
90      * Counterpart to Solidity's `-` operator.
91      *
92      * Requirements:
93      *
94      * - Subtraction cannot overflow.
95      */
96     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97         return sub(a, b, "SafeMath: subtraction overflow");
98     }
99 
100     /**
101      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
102      * overflow (when the result is negative).
103      *
104      * Counterpart to Solidity's `-` operator.
105      *
106      * Requirements:
107      *
108      * - Subtraction cannot overflow.
109      */
110     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
111         require(b <= a, errorMessage);
112         uint256 c = a - b;
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the multiplication of two unsigned integers, reverting on
119      * overflow.
120      *
121      * Counterpart to Solidity's `*` operator.
122      *
123      * Requirements:
124      *
125      * - Multiplication cannot overflow.
126      */
127     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
128         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
129         // benefit is lost if 'b' is also tested.
130         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
131         if (a == 0) {
132             return 0;
133         }
134 
135         uint256 c = a * b;
136         require(c / a == b, "SafeMath: multiplication overflow");
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the integer division of two unsigned integers. Reverts on
143      * division by zero. The result is rounded towards zero.
144      *
145      * Counterpart to Solidity's `/` operator. Note: this function uses a
146      * `revert` opcode (which leaves remaining gas untouched) while Solidity
147      * uses an invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function div(uint256 a, uint256 b) internal pure returns (uint256) {
154         return div(a, b, "SafeMath: division by zero");
155     }
156 
157     /**
158      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
159      * division by zero. The result is rounded towards zero.
160      *
161      * Counterpart to Solidity's `/` operator. Note: this function uses a
162      * `revert` opcode (which leaves remaining gas untouched) while Solidity
163      * uses an invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      *
167      * - The divisor cannot be zero.
168      */
169     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b > 0, errorMessage);
171         uint256 c = a / b;
172         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
179      * Reverts when dividing by zero.
180      *
181      * Counterpart to Solidity's `%` operator. This function uses a `revert`
182      * opcode (which leaves remaining gas untouched) while Solidity uses an
183      * invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
190         return mod(a, b, "SafeMath: modulo by zero");
191     }
192 
193     /**
194      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
195      * Reverts with custom message when dividing by zero.
196      *
197      * Counterpart to Solidity's `%` operator. This function uses a `revert`
198      * opcode (which leaves remaining gas untouched) while Solidity uses an
199      * invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
206         require(b != 0, errorMessage);
207         return a % b;
208     }
209 }
210 ////// src/lib/erc20.sol
211 
212 // File: contracts/GSN/Context.sol
213 
214 // SPDX-License-Identifier: MIT
215 
216 /* pragma solidity ^0.6.0; */
217 
218 /* import "./safe-math.sol"; */
219 /* import "./context.sol"; */
220 
221 // File: contracts/token/ERC20/IERC20.sol
222 
223 
224 /**
225  * @dev Interface of the ERC20 standard as defined in the EIP.
226  */
227 interface IERC20_1 {
228     /**
229      * @dev Returns the amount of tokens in existence.
230      */
231     function totalSupply() external view returns (uint256);
232 
233     /**
234      * @dev Returns the amount of tokens owned by `account`.
235      */
236     function balanceOf(address account) external view returns (uint256);
237 
238     /**
239      * @dev Moves `amount` tokens from the caller's account to `recipient`.
240      *
241      * Returns a boolean value indicating whether the operation succeeded.
242      *
243      * Emits a {Transfer} event.
244      */
245     function transfer(address recipient, uint256 amount) external returns (bool);
246 
247     /**
248      * @dev Returns the remaining number of tokens that `spender` will be
249      * allowed to spend on behalf of `owner` through {transferFrom}. This is
250      * zero by default.
251      *
252      * This value changes when {approve} or {transferFrom} are called.
253      */
254     function allowance(address owner, address spender) external view returns (uint256);
255 
256     /**
257      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
258      *
259      * Returns a boolean value indicating whether the operation succeeded.
260      *
261      * IMPORTANT: Beware that changing an allowance with this method brings the risk
262      * that someone may use both the old and the new allowance by unfortunate
263      * transaction ordering. One possible solution to mitigate this race
264      * condition is to first reduce the spender's allowance to 0 and set the
265      * desired value afterwards:
266      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267      *
268      * Emits an {Approval} event.
269      */
270     function approve(address spender, uint256 amount) external returns (bool);
271 
272     /**
273      * @dev Moves `amount` tokens from `sender` to `recipient` using the
274      * allowance mechanism. `amount` is then deducted from the caller's
275      * allowance.
276      *
277      * Returns a boolean value indicating whether the operation succeeded.
278      *
279      * Emits a {Transfer} event.
280      */
281     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
282 
283     /**
284      * @dev Emitted when `value` tokens are moved from one account (`from`) to
285      * another (`to`).
286      *
287      * Note that `value` may be zero.
288      */
289     event Transfer(address indexed from, address indexed to, uint256 value);
290 
291     /**
292      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
293      * a call to {approve}. `value` is the new allowance.
294      */
295     event Approval(address indexed owner, address indexed spender, uint256 value);
296 }
297 
298 // File: contracts/utils/Address.sol
299 
300 
301 /**
302  * @dev Collection of functions related to the address type
303  */
304 library Address {
305     /**
306      * @dev Returns true if `account` is a contract.
307      *
308      * [IMPORTANT]
309      * ====
310      * It is unsafe to assume that an address for which this function returns
311      * false is an externally-owned account (EOA) and not a contract.
312      *
313      * Among others, `isContract` will return false for the following
314      * types of addresses:
315      *
316      *  - an externally-owned account
317      *  - a contract in construction
318      *  - an address where a contract will be created
319      *  - an address where a contract lived, but was destroyed
320      * ====
321      */
322     function isContract(address account) internal view returns (bool) {
323         // This method relies on extcodesize, which returns 0 for contracts in
324         // construction, since the code is only stored at the end of the
325         // constructor execution.
326 
327         uint256 size;
328         // solhint-disable-next-line no-inline-assembly
329         assembly { size := extcodesize(account) }
330         return size > 0;
331     }
332 
333     /**
334      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
335      * `recipient`, forwarding all available gas and reverting on errors.
336      *
337      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
338      * of certain opcodes, possibly making contracts go over the 2300 gas limit
339      * imposed by `transfer`, making them unable to receive funds via
340      * `transfer`. {sendValue} removes this limitation.
341      *
342      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
343      *
344      * IMPORTANT: because control is transferred to `recipient`, care must be
345      * taken to not create reentrancy vulnerabilities. Consider using
346      * {ReentrancyGuard} or the
347      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
348      */
349     function sendValue(address payable recipient, uint256 amount) internal {
350         require(address(this).balance >= amount, "Address: insufficient balance");
351 
352         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
353         (bool success, ) = recipient.call{ value: amount }("");
354         require(success, "Address: unable to send value, recipient may have reverted");
355     }
356 
357     /**
358      * @dev Performs a Solidity function call using a low level `call`. A
359      * plain`call` is an unsafe replacement for a function call: use this
360      * function instead.
361      *
362      * If `target` reverts with a revert reason, it is bubbled up by this
363      * function (like regular Solidity function calls).
364      *
365      * Returns the raw returned data. To convert to the expected return value,
366      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
367      *
368      * Requirements:
369      *
370      * - `target` must be a contract.
371      * - calling `target` with `data` must not revert.
372      *
373      * _Available since v3.1._
374      */
375     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
376       return functionCall(target, data, "Address: low-level call failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
381      * `errorMessage` as a fallback revert reason when `target` reverts.
382      *
383      * _Available since v3.1._
384      */
385     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
386         return _functionCallWithValue(target, data, 0, errorMessage);
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
391      * but also transferring `value` wei to `target`.
392      *
393      * Requirements:
394      *
395      * - the calling contract must have an ETH balance of at least `value`.
396      * - the called Solidity function must be `payable`.
397      *
398      * _Available since v3.1._
399      */
400     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
401         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
406      * with `errorMessage` as a fallback revert reason when `target` reverts.
407      *
408      * _Available since v3.1._
409      */
410     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
411         require(address(this).balance >= value, "Address: insufficient balance for call");
412         return _functionCallWithValue(target, data, value, errorMessage);
413     }
414 
415     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
416         require(isContract(target), "Address: call to non-contract");
417 
418         // solhint-disable-next-line avoid-low-level-calls
419         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
420         if (success) {
421             return returndata;
422         } else {
423             // Look for revert reason and bubble it up if present
424             if (returndata.length > 0) {
425                 // The easiest way to bubble the revert reason is using memory via assembly
426 
427                 // solhint-disable-next-line no-inline-assembly
428                 assembly {
429                     let returndata_size := mload(returndata)
430                     revert(add(32, returndata), returndata_size)
431                 }
432             } else {
433                 revert(errorMessage);
434             }
435         }
436     }
437 }
438 
439 // File: contracts/token/ERC20/ERC20.sol
440 
441 /**
442  * @dev Implementation of the {IERC20} interface.
443  *
444  * This implementation is agnostic to the way tokens are created. This means
445  * that a supply mechanism has to be added in a derived contract using {_mint}.
446  * For a generic mechanism see {ERC20PresetMinterPauser}.
447  *
448  * TIP: For a detailed writeup see our guide
449  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
450  * to implement supply mechanisms].
451  *
452  * We have followed general OpenZeppelin guidelines: functions revert instead
453  * of returning `false` on failure. This behavior is nonetheless conventional
454  * and does not conflict with the expectations of ERC20 applications.
455  *
456  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
457  * This allows applications to reconstruct the allowance for all accounts just
458  * by listening to said events. Other implementations of the EIP may not emit
459  * these events, as it isn't required by the specification.
460  *
461  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
462  * functions have been added to mitigate the well-known issues around setting
463  * allowances. See {IERC20-approve}.
464  */
465 contract ERC20 is Context, IERC20_1 {
466     using SafeMath for uint256;
467     using Address for address;
468 
469     mapping (address => uint256) private _balances;
470 
471     mapping (address => mapping (address => uint256)) private _allowances;
472 
473     uint256 private _totalSupply;
474 
475     string private _name;
476     string private _symbol;
477     uint8 private _decimals;
478 
479     /**
480      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
481      * a default value of 18.
482      *
483      * To select a different value for {decimals}, use {_setupDecimals}.
484      *
485      * All three of these values are immutable: they can only be set once during
486      * construction.
487      */
488     constructor (string memory name, string memory symbol) public {
489         _name = name;
490         _symbol = symbol;
491         _decimals = 18;
492     }
493 
494     /**
495      * @dev Returns the name of the token.
496      */
497     function name() public view returns (string memory) {
498         return _name;
499     }
500 
501     /**
502      * @dev Returns the symbol of the token, usually a shorter version of the
503      * name.
504      */
505     function symbol() public view returns (string memory) {
506         return _symbol;
507     }
508 
509     /**
510      * @dev Returns the number of decimals used to get its user representation.
511      * For example, if `decimals` equals `2`, a balance of `505` tokens should
512      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
513      *
514      * Tokens usually opt for a value of 18, imitating the relationship between
515      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
516      * called.
517      *
518      * NOTE: This information is only used for _display_ purposes: it in
519      * no way affects any of the arithmetic of the contract, including
520      * {IERC20-balanceOf} and {IERC20-transfer}.
521      */
522     function decimals() public view returns (uint8) {
523         return _decimals;
524     }
525 
526     /**
527      * @dev See {IERC20-totalSupply}.
528      */
529     function totalSupply() public view override returns (uint256) {
530         return _totalSupply;
531     }
532 
533     /**
534      * @dev See {IERC20-balanceOf}.
535      */
536     function balanceOf(address account) public view override returns (uint256) {
537         return _balances[account];
538     }
539 
540     /**
541      * @dev See {IERC20-transfer}.
542      *
543      * Requirements:
544      *
545      * - `recipient` cannot be the zero address.
546      * - the caller must have a balance of at least `amount`.
547      */
548     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
549         _transfer(_msgSender(), recipient, amount);
550         return true;
551     }
552 
553     /**
554      * @dev See {IERC20-allowance}.
555      */
556     function allowance(address owner, address spender) public view virtual override returns (uint256) {
557         return _allowances[owner][spender];
558     }
559 
560     /**
561      * @dev See {IERC20-approve}.
562      *
563      * Requirements:
564      *
565      * - `spender` cannot be the zero address.
566      */
567     function approve(address spender, uint256 amount) public virtual override returns (bool) {
568         _approve(_msgSender(), spender, amount);
569         return true;
570     }
571 
572     /**
573      * @dev See {IERC20-transferFrom}.
574      *
575      * Emits an {Approval} event indicating the updated allowance. This is not
576      * required by the EIP. See the note at the beginning of {ERC20};
577      *
578      * Requirements:
579      * - `sender` and `recipient` cannot be the zero address.
580      * - `sender` must have a balance of at least `amount`.
581      * - the caller must have allowance for ``sender``'s tokens of at least
582      * `amount`.
583      */
584     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
585         _transfer(sender, recipient, amount);
586         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
587         return true;
588     }
589 
590     /**
591      * @dev Atomically increases the allowance granted to `spender` by the caller.
592      *
593      * This is an alternative to {approve} that can be used as a mitigation for
594      * problems described in {IERC20-approve}.
595      *
596      * Emits an {Approval} event indicating the updated allowance.
597      *
598      * Requirements:
599      *
600      * - `spender` cannot be the zero address.
601      */
602     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
603         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
604         return true;
605     }
606 
607     /**
608      * @dev Atomically decreases the allowance granted to `spender` by the caller.
609      *
610      * This is an alternative to {approve} that can be used as a mitigation for
611      * problems described in {IERC20-approve}.
612      *
613      * Emits an {Approval} event indicating the updated allowance.
614      *
615      * Requirements:
616      *
617      * - `spender` cannot be the zero address.
618      * - `spender` must have allowance for the caller of at least
619      * `subtractedValue`.
620      */
621     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
622         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
623         return true;
624     }
625 
626     /**
627      * @dev Moves tokens `amount` from `sender` to `recipient`.
628      *
629      * This is internal function is equivalent to {transfer}, and can be used to
630      * e.g. implement automatic token fees, slashing mechanisms, etc.
631      *
632      * Emits a {Transfer} event.
633      *
634      * Requirements:
635      *
636      * - `sender` cannot be the zero address.
637      * - `recipient` cannot be the zero address.
638      * - `sender` must have a balance of at least `amount`.
639      */
640     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
641         require(sender != address(0), "ERC20: transfer from the zero address");
642         require(recipient != address(0), "ERC20: transfer to the zero address");
643 
644         _beforeTokenTransfer(sender, recipient, amount);
645 
646         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
647         _balances[recipient] = _balances[recipient].add(amount);
648         emit Transfer(sender, recipient, amount);
649     }
650 
651     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
652      * the total supply.
653      *
654      * Emits a {Transfer} event with `from` set to the zero address.
655      *
656      * Requirements
657      *
658      * - `to` cannot be the zero address.
659      */
660     function _mint(address account, uint256 amount) internal virtual {
661         require(account != address(0), "ERC20: mint to the zero address");
662 
663         _beforeTokenTransfer(address(0), account, amount);
664 
665         _totalSupply = _totalSupply.add(amount);
666         _balances[account] = _balances[account].add(amount);
667         emit Transfer(address(0), account, amount);
668     }
669 
670     /**
671      * @dev Destroys `amount` tokens from `account`, reducing the
672      * total supply.
673      *
674      * Emits a {Transfer} event with `to` set to the zero address.
675      *
676      * Requirements
677      *
678      * - `account` cannot be the zero address.
679      * - `account` must have at least `amount` tokens.
680      */
681     function _burn(address account, uint256 amount) internal virtual {
682         require(account != address(0), "ERC20: burn from the zero address");
683 
684         _beforeTokenTransfer(account, address(0), amount);
685 
686         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
687         _totalSupply = _totalSupply.sub(amount);
688         emit Transfer(account, address(0), amount);
689     }
690 
691     /**
692      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
693      *
694      * This internal function is equivalent to `approve`, and can be used to
695      * e.g. set automatic allowances for certain subsystems, etc.
696      *
697      * Emits an {Approval} event.
698      *
699      * Requirements:
700      *
701      * - `owner` cannot be the zero address.
702      * - `spender` cannot be the zero address.
703      */
704     function _approve(address owner, address spender, uint256 amount) internal virtual {
705         require(owner != address(0), "ERC20: approve from the zero address");
706         require(spender != address(0), "ERC20: approve to the zero address");
707 
708         _allowances[owner][spender] = amount;
709         emit Approval(owner, spender, amount);
710     }
711 
712     /**
713      * @dev Sets {decimals} to a value other than the default one of 18.
714      *
715      * WARNING: This function should only be called from the constructor. Most
716      * applications that interact with token contracts will not expect
717      * {decimals} to ever change, and may work incorrectly if it does.
718      */
719     function _setupDecimals(uint8 decimals_) internal {
720         _decimals = decimals_;
721     }
722 
723     /**
724      * @dev Hook that is called before any transfer of tokens. This includes
725      * minting and burning.
726      *
727      * Calling conditions:
728      *
729      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
730      * will be to transferred to `to`.
731      * - when `from` is zero, `amount` tokens will be minted for `to`.
732      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
733      * - `from` and `to` are never both zero.
734      *
735      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
736      */
737     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
738 }
739 
740 /**
741  * @title SafeERC20
742  * @dev Wrappers around ERC20 operations that throw on failure (when the token
743  * contract returns false). Tokens that return no value (and instead revert or
744  * throw on failure) are also supported, non-reverting calls are assumed to be
745  * successful.
746  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
747  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
748  */
749 library SafeERC20 {
750     using SafeMath for uint256;
751     using Address for address;
752 
753     function safeTransfer(IERC20_1 token, address to, uint256 value) internal {
754         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
755     }
756 
757     function safeTransferFrom(IERC20_1 token, address from, address to, uint256 value) internal {
758         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
759     }
760 
761     /**
762      * @dev Deprecated. This function has issues similar to the ones found in
763      * {IERC20-approve}, and its usage is discouraged.
764      *
765      * Whenever possible, use {safeIncreaseAllowance} and
766      * {safeDecreaseAllowance} instead.
767      */
768     function safeApprove(IERC20_1 token, address spender, uint256 value) internal {
769         // safeApprove should only be called when setting an initial allowance,
770         // or when resetting it to zero. To increase and decrease it, use
771         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
772         // solhint-disable-next-line max-line-length
773         require((value == 0) || (token.allowance(address(this), spender) == 0),
774             "SafeERC20: approve from non-zero to non-zero allowance"
775         );
776         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
777     }
778 
779     function safeIncreaseAllowance(IERC20_1 token, address spender, uint256 value) internal {
780         uint256 newAllowance = token.allowance(address(this), spender).add(value);
781         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
782     }
783 
784     function safeDecreaseAllowance(IERC20_1 token, address spender, uint256 value) internal {
785         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
786         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
787     }
788 
789     /**
790      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
791      * on the return value: the return value is optional (but if data is returned, it must not be false).
792      * @param token The token targeted by the call.
793      * @param data The call data (encoded using abi.encode or one of its variants).
794      */
795     function _callOptionalReturn(IERC20_1 token, bytes memory data) private {
796         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
797         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
798         // the target address contains contract code and also asserts for success in the low-level call.
799 
800         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
801         if (returndata.length > 0) { // Return data is optional
802             // solhint-disable-next-line max-line-length
803             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
804         }
805     }
806 }
807 ////// src/pickle-jar.sol
808 // https://github.com/iearn-finance/vaults/blob/master/contracts/vaults/yVault.sol
809 
810 /* pragma solidity ^0.6.7; */
811 
812 /* import "./interfaces/controller.sol"; */
813 
814 /* import "./lib/erc20.sol"; */
815 /* import "./lib/safe-math.sol"; */
816 
817 contract PickleJar is ERC20 {
818     using SafeERC20 for IERC20_1;
819     using Address for address;
820     using SafeMath for uint256;
821 
822     IERC20_1 public token;
823 
824     uint256 public min = 9500;
825     uint256 public constant max = 10000;
826 
827     address public governance;
828     address public timelock;
829     address public controller;
830 
831     constructor(address _token, address _governance, address _timelock, address _controller)
832         public
833         ERC20(
834             string(abi.encodePacked("pickling ", ERC20(_token).name())),
835             string(abi.encodePacked("p", ERC20(_token).symbol()))
836         )
837     {
838         _setupDecimals(ERC20(_token).decimals());
839         token = IERC20_1(_token);
840         governance = _governance;
841         timelock = _timelock;
842         controller = _controller;
843     }
844 
845     function balance() public view returns (uint256) {
846         return
847             token.balanceOf(address(this)).add(
848                 IController(controller).balanceOf(address(token))
849             );
850     }
851 
852     function setMin(uint256 _min) external {
853         require(msg.sender == governance, "!governance");
854         require(_min <= max, "numerator cannot be greater than denominator");
855         min = _min;
856     }
857 
858     function setGovernance(address _governance) public {
859         require(msg.sender == governance, "!governance");
860         governance = _governance;
861     }
862 
863     function setTimelock(address _timelock) public {
864         require(msg.sender == timelock, "!timelock");
865         timelock = _timelock;
866     }
867 
868     function setController(address _controller) public {
869         require(msg.sender == timelock, "!timelock");
870         controller = _controller;
871     }
872 
873     // Custom logic in here for how much the jars allows to be borrowed
874     // Sets minimum required on-hand to keep small withdrawals cheap
875     function available() public view returns (uint256) {
876         return token.balanceOf(address(this)).mul(min).div(max);
877     }
878 
879     function earn() public {
880         uint256 _bal = available();
881         token.safeTransfer(controller, _bal);
882         IController(controller).earn(address(token), _bal);
883     }
884 
885     function depositAll() external {
886         deposit(token.balanceOf(msg.sender));
887     }
888 
889     function deposit(uint256 _amount) public {
890         uint256 _pool = balance();
891         uint256 _before = token.balanceOf(address(this));
892         token.safeTransferFrom(msg.sender, address(this), _amount);
893         uint256 _after = token.balanceOf(address(this));
894         _amount = _after.sub(_before); // Additional check for deflationary tokens
895         uint256 shares = 0;
896         if (totalSupply() == 0) {
897             shares = _amount;
898         } else {
899             shares = (_amount.mul(totalSupply())).div(_pool);
900         }
901         _mint(msg.sender, shares);
902     }
903 
904     function withdrawAll() external {
905         withdraw(balanceOf(msg.sender));
906     }
907 
908     // Used to swap any borrowed reserve over the debt limit to liquidate to 'token'
909     function harvest(address reserve, uint256 amount) external {
910         require(msg.sender == controller, "!controller");
911         require(reserve != address(token), "token");
912         IERC20_1(reserve).safeTransfer(controller, amount);
913     }
914 
915     // No rebalance implementation for lower fees and faster swaps
916     function withdraw(uint256 _shares) public {
917         uint256 r = (balance().mul(_shares)).div(totalSupply());
918         _burn(msg.sender, _shares);
919 
920         // Check balance
921         uint256 b = token.balanceOf(address(this));
922         if (b < r) {
923             uint256 _withdraw = r.sub(b);
924             IController(controller).withdraw(address(token), _withdraw);
925             uint256 _after = token.balanceOf(address(this));
926             uint256 _diff = _after.sub(b);
927             if (_diff < _withdraw) {
928                 r = b.add(_diff);
929             }
930         }
931 
932         token.safeTransfer(msg.sender, r);
933     }
934 
935     function getRatio() public view returns (uint256) {
936         return balance().mul(1e18).div(totalSupply());
937     }
938 }