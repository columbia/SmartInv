1 // Verified using https://dapp.tools
2 // hevm: flattened sources of src/pickle-jar.sol
3 pragma solidity =0.6.7 >=0.4.23 >=0.6.0 <0.7.0 >=0.6.2 <0.7.0 >=0.6.7 <0.7.0;
4 
5 ////// src/interfaces/controller.sol
6 // SPDX-License-Identifier: MIT
7 
8 /* pragma solidity ^0.6.0; */
9 
10 interface IController {
11     function jars(address) external view returns (address);
12 
13     function rewards() external view returns (address);
14 
15     function devfund() external view returns (address);
16 
17     function treasury() external view returns (address);
18 
19     function balanceOf(address) external view returns (uint256);
20 
21     function withdraw(address, uint256) external;
22 
23     function earn(address, uint256) external;
24 }
25 
26 ////// src/lib/context.sol
27 // SPDX-License-Identifier: MIT
28 
29 /* pragma solidity ^0.6.0; */
30 
31 /*
32  * @dev Provides information about the current execution context, including the
33  * sender of the transaction and its data. While these are generally available
34  * via msg.sender and msg.data, they should not be accessed in such a direct
35  * manner, since when dealing with GSN meta-transactions the account sending and
36  * paying for execution may not be the actual sender (as far as an application
37  * is concerned).
38  *
39  * This contract is only required for intermediate, library-like contracts.
40  */
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address payable) {
43         return msg.sender;
44     }
45 
46     function _msgData() internal view virtual returns (bytes memory) {
47         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
48         return msg.data;
49     }
50 }
51 
52 ////// src/lib/safe-math.sol
53 // SPDX-License-Identifier: MIT
54 
55 /* pragma solidity ^0.6.0; */
56 
57 /**
58  * @dev Wrappers over Solidity's arithmetic operations with added overflow
59  * checks.
60  *
61  * Arithmetic operations in Solidity wrap on overflow. This can easily result
62  * in bugs, because programmers usually assume that an overflow raises an
63  * error, which is the standard behavior in high level programming languages.
64  * `SafeMath` restores this intuition by reverting the transaction when an
65  * operation overflows.
66  *
67  * Using this library instead of the unchecked operations eliminates an entire
68  * class of bugs, so it's recommended to use it always.
69  */
70 library SafeMath {
71     /**
72      * @dev Returns the addition of two unsigned integers, reverting on
73      * overflow.
74      *
75      * Counterpart to Solidity's `+` operator.
76      *
77      * Requirements:
78      *
79      * - Addition cannot overflow.
80      */
81     function add(uint256 a, uint256 b) internal pure returns (uint256) {
82         uint256 c = a + b;
83         require(c >= a, "SafeMath: addition overflow");
84 
85         return c;
86     }
87 
88     /**
89      * @dev Returns the subtraction of two unsigned integers, reverting on
90      * overflow (when the result is negative).
91      *
92      * Counterpart to Solidity's `-` operator.
93      *
94      * Requirements:
95      *
96      * - Subtraction cannot overflow.
97      */
98     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
99         return sub(a, b, "SafeMath: subtraction overflow");
100     }
101 
102     /**
103      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
104      * overflow (when the result is negative).
105      *
106      * Counterpart to Solidity's `-` operator.
107      *
108      * Requirements:
109      *
110      * - Subtraction cannot overflow.
111      */
112     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
113         require(b <= a, errorMessage);
114         uint256 c = a - b;
115 
116         return c;
117     }
118 
119     /**
120      * @dev Returns the multiplication of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `*` operator.
124      *
125      * Requirements:
126      *
127      * - Multiplication cannot overflow.
128      */
129     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
130         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
131         // benefit is lost if 'b' is also tested.
132         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
133         if (a == 0) {
134             return 0;
135         }
136 
137         uint256 c = a * b;
138         require(c / a == b, "SafeMath: multiplication overflow");
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the integer division of two unsigned integers. Reverts on
145      * division by zero. The result is rounded towards zero.
146      *
147      * Counterpart to Solidity's `/` operator. Note: this function uses a
148      * `revert` opcode (which leaves remaining gas untouched) while Solidity
149      * uses an invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function div(uint256 a, uint256 b) internal pure returns (uint256) {
156         return div(a, b, "SafeMath: division by zero");
157     }
158 
159     /**
160      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
161      * division by zero. The result is rounded towards zero.
162      *
163      * Counterpart to Solidity's `/` operator. Note: this function uses a
164      * `revert` opcode (which leaves remaining gas untouched) while Solidity
165      * uses an invalid opcode to revert (consuming all remaining gas).
166      *
167      * Requirements:
168      *
169      * - The divisor cannot be zero.
170      */
171     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172         require(b > 0, errorMessage);
173         uint256 c = a / b;
174         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
181      * Reverts when dividing by zero.
182      *
183      * Counterpart to Solidity's `%` operator. This function uses a `revert`
184      * opcode (which leaves remaining gas untouched) while Solidity uses an
185      * invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
192         return mod(a, b, "SafeMath: modulo by zero");
193     }
194 
195     /**
196      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
197      * Reverts with custom message when dividing by zero.
198      *
199      * Counterpart to Solidity's `%` operator. This function uses a `revert`
200      * opcode (which leaves remaining gas untouched) while Solidity uses an
201      * invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
208         require(b != 0, errorMessage);
209         return a % b;
210     }
211 }
212 ////// src/lib/erc20.sol
213 
214 // File: contracts/GSN/Context.sol
215 
216 // SPDX-License-Identifier: MIT
217 
218 /* pragma solidity ^0.6.0; */
219 
220 /* import "./safe-math.sol"; */
221 /* import "./context.sol"; */
222 
223 // File: contracts/token/ERC20/IERC20.sol
224 
225 
226 /**
227  * @dev Interface of the ERC20 standard as defined in the EIP.
228  */
229 interface IERC20 {
230     /**
231      * @dev Returns the amount of tokens in existence.
232      */
233     function totalSupply() external view returns (uint256);
234 
235     /**
236      * @dev Returns the amount of tokens owned by `account`.
237      */
238     function balanceOf(address account) external view returns (uint256);
239 
240     /**
241      * @dev Moves `amount` tokens from the caller's account to `recipient`.
242      *
243      * Returns a boolean value indicating whether the operation succeeded.
244      *
245      * Emits a {Transfer} event.
246      */
247     function transfer(address recipient, uint256 amount) external returns (bool);
248 
249     /**
250      * @dev Returns the remaining number of tokens that `spender` will be
251      * allowed to spend on behalf of `owner` through {transferFrom}. This is
252      * zero by default.
253      *
254      * This value changes when {approve} or {transferFrom} are called.
255      */
256     function allowance(address owner, address spender) external view returns (uint256);
257 
258     /**
259      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
260      *
261      * Returns a boolean value indicating whether the operation succeeded.
262      *
263      * IMPORTANT: Beware that changing an allowance with this method brings the risk
264      * that someone may use both the old and the new allowance by unfortunate
265      * transaction ordering. One possible solution to mitigate this race
266      * condition is to first reduce the spender's allowance to 0 and set the
267      * desired value afterwards:
268      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
269      *
270      * Emits an {Approval} event.
271      */
272     function approve(address spender, uint256 amount) external returns (bool);
273 
274     /**
275      * @dev Moves `amount` tokens from `sender` to `recipient` using the
276      * allowance mechanism. `amount` is then deducted from the caller's
277      * allowance.
278      *
279      * Returns a boolean value indicating whether the operation succeeded.
280      *
281      * Emits a {Transfer} event.
282      */
283     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
284 
285     /**
286      * @dev Emitted when `value` tokens are moved from one account (`from`) to
287      * another (`to`).
288      *
289      * Note that `value` may be zero.
290      */
291     event Transfer(address indexed from, address indexed to, uint256 value);
292 
293     /**
294      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
295      * a call to {approve}. `value` is the new allowance.
296      */
297     event Approval(address indexed owner, address indexed spender, uint256 value);
298 }
299 
300 // File: contracts/utils/Address.sol
301 
302 
303 /**
304  * @dev Collection of functions related to the address type
305  */
306 library Address {
307     /**
308      * @dev Returns true if `account` is a contract.
309      *
310      * [IMPORTANT]
311      * ====
312      * It is unsafe to assume that an address for which this function returns
313      * false is an externally-owned account (EOA) and not a contract.
314      *
315      * Among others, `isContract` will return false for the following
316      * types of addresses:
317      *
318      *  - an externally-owned account
319      *  - a contract in construction
320      *  - an address where a contract will be created
321      *  - an address where a contract lived, but was destroyed
322      * ====
323      */
324     function isContract(address account) internal view returns (bool) {
325         // This method relies on extcodesize, which returns 0 for contracts in
326         // construction, since the code is only stored at the end of the
327         // constructor execution.
328 
329         uint256 size;
330         // solhint-disable-next-line no-inline-assembly
331         assembly { size := extcodesize(account) }
332         return size > 0;
333     }
334 
335     /**
336      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
337      * `recipient`, forwarding all available gas and reverting on errors.
338      *
339      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
340      * of certain opcodes, possibly making contracts go over the 2300 gas limit
341      * imposed by `transfer`, making them unable to receive funds via
342      * `transfer`. {sendValue} removes this limitation.
343      *
344      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
345      *
346      * IMPORTANT: because control is transferred to `recipient`, care must be
347      * taken to not create reentrancy vulnerabilities. Consider using
348      * {ReentrancyGuard} or the
349      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
350      */
351     function sendValue(address payable recipient, uint256 amount) internal {
352         require(address(this).balance >= amount, "Address: insufficient balance");
353 
354         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
355         (bool success, ) = recipient.call{ value: amount }("");
356         require(success, "Address: unable to send value, recipient may have reverted");
357     }
358 
359     /**
360      * @dev Performs a Solidity function call using a low level `call`. A
361      * plain`call` is an unsafe replacement for a function call: use this
362      * function instead.
363      *
364      * If `target` reverts with a revert reason, it is bubbled up by this
365      * function (like regular Solidity function calls).
366      *
367      * Returns the raw returned data. To convert to the expected return value,
368      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
369      *
370      * Requirements:
371      *
372      * - `target` must be a contract.
373      * - calling `target` with `data` must not revert.
374      *
375      * _Available since v3.1._
376      */
377     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
378       return functionCall(target, data, "Address: low-level call failed");
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
383      * `errorMessage` as a fallback revert reason when `target` reverts.
384      *
385      * _Available since v3.1._
386      */
387     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
388         return _functionCallWithValue(target, data, 0, errorMessage);
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
393      * but also transferring `value` wei to `target`.
394      *
395      * Requirements:
396      *
397      * - the calling contract must have an ETH balance of at least `value`.
398      * - the called Solidity function must be `payable`.
399      *
400      * _Available since v3.1._
401      */
402     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
403         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
408      * with `errorMessage` as a fallback revert reason when `target` reverts.
409      *
410      * _Available since v3.1._
411      */
412     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
413         require(address(this).balance >= value, "Address: insufficient balance for call");
414         return _functionCallWithValue(target, data, value, errorMessage);
415     }
416 
417     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
418         require(isContract(target), "Address: call to non-contract");
419 
420         // solhint-disable-next-line avoid-low-level-calls
421         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
422         if (success) {
423             return returndata;
424         } else {
425             // Look for revert reason and bubble it up if present
426             if (returndata.length > 0) {
427                 // The easiest way to bubble the revert reason is using memory via assembly
428 
429                 // solhint-disable-next-line no-inline-assembly
430                 assembly {
431                     let returndata_size := mload(returndata)
432                     revert(add(32, returndata), returndata_size)
433                 }
434             } else {
435                 revert(errorMessage);
436             }
437         }
438     }
439 }
440 
441 // File: contracts/token/ERC20/ERC20.sol
442 
443 /**
444  * @dev Implementation of the {IERC20} interface.
445  *
446  * This implementation is agnostic to the way tokens are created. This means
447  * that a supply mechanism has to be added in a derived contract using {_mint}.
448  * For a generic mechanism see {ERC20PresetMinterPauser}.
449  *
450  * TIP: For a detailed writeup see our guide
451  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
452  * to implement supply mechanisms].
453  *
454  * We have followed general OpenZeppelin guidelines: functions revert instead
455  * of returning `false` on failure. This behavior is nonetheless conventional
456  * and does not conflict with the expectations of ERC20 applications.
457  *
458  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
459  * This allows applications to reconstruct the allowance for all accounts just
460  * by listening to said events. Other implementations of the EIP may not emit
461  * these events, as it isn't required by the specification.
462  *
463  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
464  * functions have been added to mitigate the well-known issues around setting
465  * allowances. See {IERC20-approve}.
466  */
467 contract ERC20 is Context, IERC20 {
468     using SafeMath for uint256;
469     using Address for address;
470 
471     mapping (address => uint256) private _balances;
472 
473     mapping (address => mapping (address => uint256)) private _allowances;
474 
475     uint256 private _totalSupply;
476 
477     string private _name;
478     string private _symbol;
479     uint8 private _decimals;
480 
481     /**
482      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
483      * a default value of 18.
484      *
485      * To select a different value for {decimals}, use {_setupDecimals}.
486      *
487      * All three of these values are immutable: they can only be set once during
488      * construction.
489      */
490     constructor (string memory name, string memory symbol) public {
491         _name = name;
492         _symbol = symbol;
493         _decimals = 18;
494     }
495 
496     /**
497      * @dev Returns the name of the token.
498      */
499     function name() public view returns (string memory) {
500         return _name;
501     }
502 
503     /**
504      * @dev Returns the symbol of the token, usually a shorter version of the
505      * name.
506      */
507     function symbol() public view returns (string memory) {
508         return _symbol;
509     }
510 
511     /**
512      * @dev Returns the number of decimals used to get its user representation.
513      * For example, if `decimals` equals `2`, a balance of `505` tokens should
514      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
515      *
516      * Tokens usually opt for a value of 18, imitating the relationship between
517      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
518      * called.
519      *
520      * NOTE: This information is only used for _display_ purposes: it in
521      * no way affects any of the arithmetic of the contract, including
522      * {IERC20-balanceOf} and {IERC20-transfer}.
523      */
524     function decimals() public view returns (uint8) {
525         return _decimals;
526     }
527 
528     /**
529      * @dev See {IERC20-totalSupply}.
530      */
531     function totalSupply() public view override returns (uint256) {
532         return _totalSupply;
533     }
534 
535     /**
536      * @dev See {IERC20-balanceOf}.
537      */
538     function balanceOf(address account) public view override returns (uint256) {
539         return _balances[account];
540     }
541 
542     /**
543      * @dev See {IERC20-transfer}.
544      *
545      * Requirements:
546      *
547      * - `recipient` cannot be the zero address.
548      * - the caller must have a balance of at least `amount`.
549      */
550     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
551         _transfer(_msgSender(), recipient, amount);
552         return true;
553     }
554 
555     /**
556      * @dev See {IERC20-allowance}.
557      */
558     function allowance(address owner, address spender) public view virtual override returns (uint256) {
559         return _allowances[owner][spender];
560     }
561 
562     /**
563      * @dev See {IERC20-approve}.
564      *
565      * Requirements:
566      *
567      * - `spender` cannot be the zero address.
568      */
569     function approve(address spender, uint256 amount) public virtual override returns (bool) {
570         _approve(_msgSender(), spender, amount);
571         return true;
572     }
573 
574     /**
575      * @dev See {IERC20-transferFrom}.
576      *
577      * Emits an {Approval} event indicating the updated allowance. This is not
578      * required by the EIP. See the note at the beginning of {ERC20};
579      *
580      * Requirements:
581      * - `sender` and `recipient` cannot be the zero address.
582      * - `sender` must have a balance of at least `amount`.
583      * - the caller must have allowance for ``sender``'s tokens of at least
584      * `amount`.
585      */
586     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
587         _transfer(sender, recipient, amount);
588         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
589         return true;
590     }
591 
592     /**
593      * @dev Atomically increases the allowance granted to `spender` by the caller.
594      *
595      * This is an alternative to {approve} that can be used as a mitigation for
596      * problems described in {IERC20-approve}.
597      *
598      * Emits an {Approval} event indicating the updated allowance.
599      *
600      * Requirements:
601      *
602      * - `spender` cannot be the zero address.
603      */
604     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
605         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
606         return true;
607     }
608 
609     /**
610      * @dev Atomically decreases the allowance granted to `spender` by the caller.
611      *
612      * This is an alternative to {approve} that can be used as a mitigation for
613      * problems described in {IERC20-approve}.
614      *
615      * Emits an {Approval} event indicating the updated allowance.
616      *
617      * Requirements:
618      *
619      * - `spender` cannot be the zero address.
620      * - `spender` must have allowance for the caller of at least
621      * `subtractedValue`.
622      */
623     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
624         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
625         return true;
626     }
627 
628     /**
629      * @dev Moves tokens `amount` from `sender` to `recipient`.
630      *
631      * This is internal function is equivalent to {transfer}, and can be used to
632      * e.g. implement automatic token fees, slashing mechanisms, etc.
633      *
634      * Emits a {Transfer} event.
635      *
636      * Requirements:
637      *
638      * - `sender` cannot be the zero address.
639      * - `recipient` cannot be the zero address.
640      * - `sender` must have a balance of at least `amount`.
641      */
642     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
643         require(sender != address(0), "ERC20: transfer from the zero address");
644         require(recipient != address(0), "ERC20: transfer to the zero address");
645 
646         _beforeTokenTransfer(sender, recipient, amount);
647 
648         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
649         _balances[recipient] = _balances[recipient].add(amount);
650         emit Transfer(sender, recipient, amount);
651     }
652 
653     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
654      * the total supply.
655      *
656      * Emits a {Transfer} event with `from` set to the zero address.
657      *
658      * Requirements
659      *
660      * - `to` cannot be the zero address.
661      */
662     function _mint(address account, uint256 amount) internal virtual {
663         require(account != address(0), "ERC20: mint to the zero address");
664 
665         _beforeTokenTransfer(address(0), account, amount);
666 
667         _totalSupply = _totalSupply.add(amount);
668         _balances[account] = _balances[account].add(amount);
669         emit Transfer(address(0), account, amount);
670     }
671 
672     /**
673      * @dev Destroys `amount` tokens from `account`, reducing the
674      * total supply.
675      *
676      * Emits a {Transfer} event with `to` set to the zero address.
677      *
678      * Requirements
679      *
680      * - `account` cannot be the zero address.
681      * - `account` must have at least `amount` tokens.
682      */
683     function _burn(address account, uint256 amount) internal virtual {
684         require(account != address(0), "ERC20: burn from the zero address");
685 
686         _beforeTokenTransfer(account, address(0), amount);
687 
688         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
689         _totalSupply = _totalSupply.sub(amount);
690         emit Transfer(account, address(0), amount);
691     }
692 
693     /**
694      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
695      *
696      * This internal function is equivalent to `approve`, and can be used to
697      * e.g. set automatic allowances for certain subsystems, etc.
698      *
699      * Emits an {Approval} event.
700      *
701      * Requirements:
702      *
703      * - `owner` cannot be the zero address.
704      * - `spender` cannot be the zero address.
705      */
706     function _approve(address owner, address spender, uint256 amount) internal virtual {
707         require(owner != address(0), "ERC20: approve from the zero address");
708         require(spender != address(0), "ERC20: approve to the zero address");
709 
710         _allowances[owner][spender] = amount;
711         emit Approval(owner, spender, amount);
712     }
713 
714     /**
715      * @dev Sets {decimals} to a value other than the default one of 18.
716      *
717      * WARNING: This function should only be called from the constructor. Most
718      * applications that interact with token contracts will not expect
719      * {decimals} to ever change, and may work incorrectly if it does.
720      */
721     function _setupDecimals(uint8 decimals_) internal {
722         _decimals = decimals_;
723     }
724 
725     /**
726      * @dev Hook that is called before any transfer of tokens. This includes
727      * minting and burning.
728      *
729      * Calling conditions:
730      *
731      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
732      * will be to transferred to `to`.
733      * - when `from` is zero, `amount` tokens will be minted for `to`.
734      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
735      * - `from` and `to` are never both zero.
736      *
737      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
738      */
739     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
740 }
741 
742 /**
743  * @title SafeERC20
744  * @dev Wrappers around ERC20 operations that throw on failure (when the token
745  * contract returns false). Tokens that return no value (and instead revert or
746  * throw on failure) are also supported, non-reverting calls are assumed to be
747  * successful.
748  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
749  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
750  */
751 library SafeERC20 {
752     using SafeMath for uint256;
753     using Address for address;
754 
755     function safeTransfer(IERC20 token, address to, uint256 value) internal {
756         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
757     }
758 
759     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
760         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
761     }
762 
763     /**
764      * @dev Deprecated. This function has issues similar to the ones found in
765      * {IERC20-approve}, and its usage is discouraged.
766      *
767      * Whenever possible, use {safeIncreaseAllowance} and
768      * {safeDecreaseAllowance} instead.
769      */
770     function safeApprove(IERC20 token, address spender, uint256 value) internal {
771         // safeApprove should only be called when setting an initial allowance,
772         // or when resetting it to zero. To increase and decrease it, use
773         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
774         // solhint-disable-next-line max-line-length
775         require((value == 0) || (token.allowance(address(this), spender) == 0),
776             "SafeERC20: approve from non-zero to non-zero allowance"
777         );
778         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
779     }
780 
781     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
782         uint256 newAllowance = token.allowance(address(this), spender).add(value);
783         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
784     }
785 
786     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
787         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
788         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
789     }
790 
791     /**
792      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
793      * on the return value: the return value is optional (but if data is returned, it must not be false).
794      * @param token The token targeted by the call.
795      * @param data The call data (encoded using abi.encode or one of its variants).
796      */
797     function _callOptionalReturn(IERC20 token, bytes memory data) private {
798         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
799         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
800         // the target address contains contract code and also asserts for success in the low-level call.
801 
802         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
803         if (returndata.length > 0) { // Return data is optional
804             // solhint-disable-next-line max-line-length
805             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
806         }
807     }
808 }
809 ////// src/pickle-jar.sol
810 // https://github.com/iearn-finance/vaults/blob/master/contracts/vaults/yVault.sol
811 
812 /* pragma solidity ^0.6.7; */
813 
814 /* import "./interfaces/controller.sol"; */
815 
816 /* import "./lib/erc20.sol"; */
817 /* import "./lib/safe-math.sol"; */
818 
819 contract PickleJar is ERC20 {
820     using SafeERC20 for IERC20;
821     using Address for address;
822     using SafeMath for uint256;
823 
824     IERC20 public token;
825 
826     uint256 public min = 9500;
827     uint256 public constant max = 10000;
828 
829     address public governance;
830     address public timelock;
831     address public controller;
832 
833     constructor(address _token, address _governance, address _timelock, address _controller)
834         public
835         ERC20(
836             string(abi.encodePacked("pickling ", ERC20(_token).name())),
837             string(abi.encodePacked("p", ERC20(_token).symbol()))
838         )
839     {
840         _setupDecimals(ERC20(_token).decimals());
841         token = IERC20(_token);
842         governance = _governance;
843         timelock = _timelock;
844         controller = _controller;
845     }
846 
847     function balance() public view returns (uint256) {
848         return
849             token.balanceOf(address(this)).add(
850                 IController(controller).balanceOf(address(token))
851             );
852     }
853 
854     function setMin(uint256 _min) external {
855         require(msg.sender == governance, "!governance");
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
913         IERC20(reserve).safeTransfer(controller, amount);
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
