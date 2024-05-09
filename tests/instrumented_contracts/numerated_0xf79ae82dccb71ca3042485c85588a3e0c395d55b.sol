1 // hevm: flattened sources of src/pickle-jar.sol
2 pragma solidity >=0.4.23 >=0.6.0 <0.7.0 >=0.6.2 <0.7.0 >=0.6.7 <0.7.0;
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
14     function want(address) external view returns (address); // NOTE: Only StrategyControllerV2 implements this
15 
16     function balanceOf(address) external view returns (uint256);
17 
18     function withdraw(address, uint256) external;
19 
20     function earn(address, uint256) external;
21 }
22 
23 ////// src/lib/safe-math.sol
24 
25 
26 /* pragma solidity ^0.6.0; */
27 
28 /**
29  * @dev Wrappers over Solidity's arithmetic operations with added overflow
30  * checks.
31  *
32  * Arithmetic operations in Solidity wrap on overflow. This can easily result
33  * in bugs, because programmers usually assume that an overflow raises an
34  * error, which is the standard behavior in high level programming languages.
35  * `SafeMath` restores this intuition by reverting the transaction when an
36  * operation overflows.
37  *
38  * Using this library instead of the unchecked operations eliminates an entire
39  * class of bugs, so it's recommended to use it always.
40  */
41 library SafeMath {
42     /**
43      * @dev Returns the addition of two unsigned integers, reverting on
44      * overflow.
45      *
46      * Counterpart to Solidity's `+` operator.
47      *
48      * Requirements:
49      *
50      * - Addition cannot overflow.
51      */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a, "SafeMath: addition overflow");
55 
56         return c;
57     }
58 
59     /**
60      * @dev Returns the subtraction of two unsigned integers, reverting on
61      * overflow (when the result is negative).
62      *
63      * Counterpart to Solidity's `-` operator.
64      *
65      * Requirements:
66      *
67      * - Subtraction cannot overflow.
68      */
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         return sub(a, b, "SafeMath: subtraction overflow");
71     }
72 
73     /**
74      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
75      * overflow (when the result is negative).
76      *
77      * Counterpart to Solidity's `-` operator.
78      *
79      * Requirements:
80      *
81      * - Subtraction cannot overflow.
82      */
83     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
84         require(b <= a, errorMessage);
85         uint256 c = a - b;
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the multiplication of two unsigned integers, reverting on
92      * overflow.
93      *
94      * Counterpart to Solidity's `*` operator.
95      *
96      * Requirements:
97      *
98      * - Multiplication cannot overflow.
99      */
100     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
102         // benefit is lost if 'b' is also tested.
103         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
104         if (a == 0) {
105             return 0;
106         }
107 
108         uint256 c = a * b;
109         require(c / a == b, "SafeMath: multiplication overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the integer division of two unsigned integers. Reverts on
116      * division by zero. The result is rounded towards zero.
117      *
118      * Counterpart to Solidity's `/` operator. Note: this function uses a
119      * `revert` opcode (which leaves remaining gas untouched) while Solidity
120      * uses an invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      *
124      * - The divisor cannot be zero.
125      */
126     function div(uint256 a, uint256 b) internal pure returns (uint256) {
127         return div(a, b, "SafeMath: division by zero");
128     }
129 
130     /**
131      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
132      * division by zero. The result is rounded towards zero.
133      *
134      * Counterpart to Solidity's `/` operator. Note: this function uses a
135      * `revert` opcode (which leaves remaining gas untouched) while Solidity
136      * uses an invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b > 0, errorMessage);
144         uint256 c = a / b;
145         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
152      * Reverts when dividing by zero.
153      *
154      * Counterpart to Solidity's `%` operator. This function uses a `revert`
155      * opcode (which leaves remaining gas untouched) while Solidity uses an
156      * invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      *
160      * - The divisor cannot be zero.
161      */
162     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
163         return mod(a, b, "SafeMath: modulo by zero");
164     }
165 
166     /**
167      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
168      * Reverts with custom message when dividing by zero.
169      *
170      * Counterpart to Solidity's `%` operator. This function uses a `revert`
171      * opcode (which leaves remaining gas untouched) while Solidity uses an
172      * invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
179         require(b != 0, errorMessage);
180         return a % b;
181     }
182 }
183 ////// src/lib/erc20.sol
184 
185 // File: contracts/GSN/Context.sol
186 
187 
188 
189 /* pragma solidity ^0.6.0; */
190 
191 /* import "./safe-math.sol"; */
192 
193 /*
194  * @dev Provides information about the current execution context, including the
195  * sender of the transaction and its data. While these are generally available
196  * via msg.sender and msg.data, they should not be accessed in such a direct
197  * manner, since when dealing with GSN meta-transactions the account sending and
198  * paying for execution may not be the actual sender (as far as an application
199  * is concerned).
200  *
201  * This contract is only required for intermediate, library-like contracts.
202  */
203 abstract contract Context {
204     function _msgSender() internal view virtual returns (address payable) {
205         return msg.sender;
206     }
207 
208     function _msgData() internal view virtual returns (bytes memory) {
209         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
210         return msg.data;
211     }
212 }
213 
214 // File: contracts/token/ERC20/IERC20.sol
215 
216 
217 /**
218  * @dev Interface of the ERC20 standard as defined in the EIP.
219  */
220 interface IERC20 {
221     /**
222      * @dev Returns the amount of tokens in existence.
223      */
224     function totalSupply() external view returns (uint256);
225 
226     /**
227      * @dev Returns the amount of tokens owned by `account`.
228      */
229     function balanceOf(address account) external view returns (uint256);
230 
231     /**
232      * @dev Moves `amount` tokens from the caller's account to `recipient`.
233      *
234      * Returns a boolean value indicating whether the operation succeeded.
235      *
236      * Emits a {Transfer} event.
237      */
238     function transfer(address recipient, uint256 amount) external returns (bool);
239 
240     /**
241      * @dev Returns the remaining number of tokens that `spender` will be
242      * allowed to spend on behalf of `owner` through {transferFrom}. This is
243      * zero by default.
244      *
245      * This value changes when {approve} or {transferFrom} are called.
246      */
247     function allowance(address owner, address spender) external view returns (uint256);
248 
249     /**
250      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
251      *
252      * Returns a boolean value indicating whether the operation succeeded.
253      *
254      * IMPORTANT: Beware that changing an allowance with this method brings the risk
255      * that someone may use both the old and the new allowance by unfortunate
256      * transaction ordering. One possible solution to mitigate this race
257      * condition is to first reduce the spender's allowance to 0 and set the
258      * desired value afterwards:
259      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
260      *
261      * Emits an {Approval} event.
262      */
263     function approve(address spender, uint256 amount) external returns (bool);
264 
265     /**
266      * @dev Moves `amount` tokens from `sender` to `recipient` using the
267      * allowance mechanism. `amount` is then deducted from the caller's
268      * allowance.
269      *
270      * Returns a boolean value indicating whether the operation succeeded.
271      *
272      * Emits a {Transfer} event.
273      */
274     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
275 
276     /**
277      * @dev Emitted when `value` tokens are moved from one account (`from`) to
278      * another (`to`).
279      *
280      * Note that `value` may be zero.
281      */
282     event Transfer(address indexed from, address indexed to, uint256 value);
283 
284     /**
285      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
286      * a call to {approve}. `value` is the new allowance.
287      */
288     event Approval(address indexed owner, address indexed spender, uint256 value);
289 }
290 
291 // File: contracts/utils/Address.sol
292 
293 
294 /**
295  * @dev Collection of functions related to the address type
296  */
297 library Address {
298     /**
299      * @dev Returns true if `account` is a contract.
300      *
301      * [IMPORTANT]
302      * ====
303      * It is unsafe to assume that an address for which this function returns
304      * false is an externally-owned account (EOA) and not a contract.
305      *
306      * Among others, `isContract` will return false for the following
307      * types of addresses:
308      *
309      *  - an externally-owned account
310      *  - a contract in construction
311      *  - an address where a contract will be created
312      *  - an address where a contract lived, but was destroyed
313      * ====
314      */
315     function isContract(address account) internal view returns (bool) {
316         // This method relies on extcodesize, which returns 0 for contracts in
317         // construction, since the code is only stored at the end of the
318         // constructor execution.
319 
320         uint256 size;
321         // solhint-disable-next-line no-inline-assembly
322         assembly { size := extcodesize(account) }
323         return size > 0;
324     }
325 
326     /**
327      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
328      * `recipient`, forwarding all available gas and reverting on errors.
329      *
330      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
331      * of certain opcodes, possibly making contracts go over the 2300 gas limit
332      * imposed by `transfer`, making them unable to receive funds via
333      * `transfer`. {sendValue} removes this limitation.
334      *
335      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
336      *
337      * IMPORTANT: because control is transferred to `recipient`, care must be
338      * taken to not create reentrancy vulnerabilities. Consider using
339      * {ReentrancyGuard} or the
340      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
341      */
342     function sendValue(address payable recipient, uint256 amount) internal {
343         require(address(this).balance >= amount, "Address: insufficient balance");
344 
345         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
346         (bool success, ) = recipient.call{ value: amount }("");
347         require(success, "Address: unable to send value, recipient may have reverted");
348     }
349 
350     /**
351      * @dev Performs a Solidity function call using a low level `call`. A
352      * plain`call` is an unsafe replacement for a function call: use this
353      * function instead.
354      *
355      * If `target` reverts with a revert reason, it is bubbled up by this
356      * function (like regular Solidity function calls).
357      *
358      * Returns the raw returned data. To convert to the expected return value,
359      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
360      *
361      * Requirements:
362      *
363      * - `target` must be a contract.
364      * - calling `target` with `data` must not revert.
365      *
366      * _Available since v3.1._
367      */
368     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
369       return functionCall(target, data, "Address: low-level call failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
374      * `errorMessage` as a fallback revert reason when `target` reverts.
375      *
376      * _Available since v3.1._
377      */
378     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
379         return _functionCallWithValue(target, data, 0, errorMessage);
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
384      * but also transferring `value` wei to `target`.
385      *
386      * Requirements:
387      *
388      * - the calling contract must have an ETH balance of at least `value`.
389      * - the called Solidity function must be `payable`.
390      *
391      * _Available since v3.1._
392      */
393     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
394         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
399      * with `errorMessage` as a fallback revert reason when `target` reverts.
400      *
401      * _Available since v3.1._
402      */
403     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
404         require(address(this).balance >= value, "Address: insufficient balance for call");
405         return _functionCallWithValue(target, data, value, errorMessage);
406     }
407 
408     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
409         require(isContract(target), "Address: call to non-contract");
410 
411         // solhint-disable-next-line avoid-low-level-calls
412         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
413         if (success) {
414             return returndata;
415         } else {
416             // Look for revert reason and bubble it up if present
417             if (returndata.length > 0) {
418                 // The easiest way to bubble the revert reason is using memory via assembly
419 
420                 // solhint-disable-next-line no-inline-assembly
421                 assembly {
422                     let returndata_size := mload(returndata)
423                     revert(add(32, returndata), returndata_size)
424                 }
425             } else {
426                 revert(errorMessage);
427             }
428         }
429     }
430 }
431 
432 // File: contracts/token/ERC20/ERC20.sol
433 
434 /**
435  * @dev Implementation of the {IERC20} interface.
436  *
437  * This implementation is agnostic to the way tokens are created. This means
438  * that a supply mechanism has to be added in a derived contract using {_mint}.
439  * For a generic mechanism see {ERC20PresetMinterPauser}.
440  *
441  * TIP: For a detailed writeup see our guide
442  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
443  * to implement supply mechanisms].
444  *
445  * We have followed general OpenZeppelin guidelines: functions revert instead
446  * of returning `false` on failure. This behavior is nonetheless conventional
447  * and does not conflict with the expectations of ERC20 applications.
448  *
449  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
450  * This allows applications to reconstruct the allowance for all accounts just
451  * by listening to said events. Other implementations of the EIP may not emit
452  * these events, as it isn't required by the specification.
453  *
454  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
455  * functions have been added to mitigate the well-known issues around setting
456  * allowances. See {IERC20-approve}.
457  */
458 contract ERC20 is Context, IERC20 {
459     using SafeMath for uint256;
460     using Address for address;
461 
462     mapping (address => uint256) private _balances;
463 
464     mapping (address => mapping (address => uint256)) private _allowances;
465 
466     uint256 private _totalSupply;
467 
468     string private _name;
469     string private _symbol;
470     uint8 private _decimals;
471 
472     /**
473      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
474      * a default value of 18.
475      *
476      * To select a different value for {decimals}, use {_setupDecimals}.
477      *
478      * All three of these values are immutable: they can only be set once during
479      * construction.
480      */
481     constructor (string memory name, string memory symbol) public {
482         _name = name;
483         _symbol = symbol;
484         _decimals = 18;
485     }
486 
487     /**
488      * @dev Returns the name of the token.
489      */
490     function name() public view returns (string memory) {
491         return _name;
492     }
493 
494     /**
495      * @dev Returns the symbol of the token, usually a shorter version of the
496      * name.
497      */
498     function symbol() public view returns (string memory) {
499         return _symbol;
500     }
501 
502     /**
503      * @dev Returns the number of decimals used to get its user representation.
504      * For example, if `decimals` equals `2`, a balance of `505` tokens should
505      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
506      *
507      * Tokens usually opt for a value of 18, imitating the relationship between
508      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
509      * called.
510      *
511      * NOTE: This information is only used for _display_ purposes: it in
512      * no way affects any of the arithmetic of the contract, including
513      * {IERC20-balanceOf} and {IERC20-transfer}.
514      */
515     function decimals() public view returns (uint8) {
516         return _decimals;
517     }
518 
519     /**
520      * @dev See {IERC20-totalSupply}.
521      */
522     function totalSupply() public view override returns (uint256) {
523         return _totalSupply;
524     }
525 
526     /**
527      * @dev See {IERC20-balanceOf}.
528      */
529     function balanceOf(address account) public view override returns (uint256) {
530         return _balances[account];
531     }
532 
533     /**
534      * @dev See {IERC20-transfer}.
535      *
536      * Requirements:
537      *
538      * - `recipient` cannot be the zero address.
539      * - the caller must have a balance of at least `amount`.
540      */
541     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
542         _transfer(_msgSender(), recipient, amount);
543         return true;
544     }
545 
546     /**
547      * @dev See {IERC20-allowance}.
548      */
549     function allowance(address owner, address spender) public view virtual override returns (uint256) {
550         return _allowances[owner][spender];
551     }
552 
553     /**
554      * @dev See {IERC20-approve}.
555      *
556      * Requirements:
557      *
558      * - `spender` cannot be the zero address.
559      */
560     function approve(address spender, uint256 amount) public virtual override returns (bool) {
561         _approve(_msgSender(), spender, amount);
562         return true;
563     }
564 
565     /**
566      * @dev See {IERC20-transferFrom}.
567      *
568      * Emits an {Approval} event indicating the updated allowance. This is not
569      * required by the EIP. See the note at the beginning of {ERC20};
570      *
571      * Requirements:
572      * - `sender` and `recipient` cannot be the zero address.
573      * - `sender` must have a balance of at least `amount`.
574      * - the caller must have allowance for ``sender``'s tokens of at least
575      * `amount`.
576      */
577     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
578         _transfer(sender, recipient, amount);
579         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
580         return true;
581     }
582 
583     /**
584      * @dev Atomically increases the allowance granted to `spender` by the caller.
585      *
586      * This is an alternative to {approve} that can be used as a mitigation for
587      * problems described in {IERC20-approve}.
588      *
589      * Emits an {Approval} event indicating the updated allowance.
590      *
591      * Requirements:
592      *
593      * - `spender` cannot be the zero address.
594      */
595     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
596         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
597         return true;
598     }
599 
600     /**
601      * @dev Atomically decreases the allowance granted to `spender` by the caller.
602      *
603      * This is an alternative to {approve} that can be used as a mitigation for
604      * problems described in {IERC20-approve}.
605      *
606      * Emits an {Approval} event indicating the updated allowance.
607      *
608      * Requirements:
609      *
610      * - `spender` cannot be the zero address.
611      * - `spender` must have allowance for the caller of at least
612      * `subtractedValue`.
613      */
614     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
615         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
616         return true;
617     }
618 
619     /**
620      * @dev Moves tokens `amount` from `sender` to `recipient`.
621      *
622      * This is internal function is equivalent to {transfer}, and can be used to
623      * e.g. implement automatic token fees, slashing mechanisms, etc.
624      *
625      * Emits a {Transfer} event.
626      *
627      * Requirements:
628      *
629      * - `sender` cannot be the zero address.
630      * - `recipient` cannot be the zero address.
631      * - `sender` must have a balance of at least `amount`.
632      */
633     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
634         require(sender != address(0), "ERC20: transfer from the zero address");
635         require(recipient != address(0), "ERC20: transfer to the zero address");
636 
637         _beforeTokenTransfer(sender, recipient, amount);
638 
639         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
640         _balances[recipient] = _balances[recipient].add(amount);
641         emit Transfer(sender, recipient, amount);
642     }
643 
644     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
645      * the total supply.
646      *
647      * Emits a {Transfer} event with `from` set to the zero address.
648      *
649      * Requirements
650      *
651      * - `to` cannot be the zero address.
652      */
653     function _mint(address account, uint256 amount) internal virtual {
654         require(account != address(0), "ERC20: mint to the zero address");
655 
656         _beforeTokenTransfer(address(0), account, amount);
657 
658         _totalSupply = _totalSupply.add(amount);
659         _balances[account] = _balances[account].add(amount);
660         emit Transfer(address(0), account, amount);
661     }
662 
663     /**
664      * @dev Destroys `amount` tokens from `account`, reducing the
665      * total supply.
666      *
667      * Emits a {Transfer} event with `to` set to the zero address.
668      *
669      * Requirements
670      *
671      * - `account` cannot be the zero address.
672      * - `account` must have at least `amount` tokens.
673      */
674     function _burn(address account, uint256 amount) internal virtual {
675         require(account != address(0), "ERC20: burn from the zero address");
676 
677         _beforeTokenTransfer(account, address(0), amount);
678 
679         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
680         _totalSupply = _totalSupply.sub(amount);
681         emit Transfer(account, address(0), amount);
682     }
683 
684     /**
685      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
686      *
687      * This internal function is equivalent to `approve`, and can be used to
688      * e.g. set automatic allowances for certain subsystems, etc.
689      *
690      * Emits an {Approval} event.
691      *
692      * Requirements:
693      *
694      * - `owner` cannot be the zero address.
695      * - `spender` cannot be the zero address.
696      */
697     function _approve(address owner, address spender, uint256 amount) internal virtual {
698         require(owner != address(0), "ERC20: approve from the zero address");
699         require(spender != address(0), "ERC20: approve to the zero address");
700 
701         _allowances[owner][spender] = amount;
702         emit Approval(owner, spender, amount);
703     }
704 
705     /**
706      * @dev Sets {decimals} to a value other than the default one of 18.
707      *
708      * WARNING: This function should only be called from the constructor. Most
709      * applications that interact with token contracts will not expect
710      * {decimals} to ever change, and may work incorrectly if it does.
711      */
712     function _setupDecimals(uint8 decimals_) internal {
713         _decimals = decimals_;
714     }
715 
716     /**
717      * @dev Hook that is called before any transfer of tokens. This includes
718      * minting and burning.
719      *
720      * Calling conditions:
721      *
722      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
723      * will be to transferred to `to`.
724      * - when `from` is zero, `amount` tokens will be minted for `to`.
725      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
726      * - `from` and `to` are never both zero.
727      *
728      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
729      */
730     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
731 }
732 
733 /**
734  * @title SafeERC20
735  * @dev Wrappers around ERC20 operations that throw on failure (when the token
736  * contract returns false). Tokens that return no value (and instead revert or
737  * throw on failure) are also supported, non-reverting calls are assumed to be
738  * successful.
739  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
740  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
741  */
742 library SafeERC20 {
743     using SafeMath for uint256;
744     using Address for address;
745 
746     function safeTransfer(IERC20 token, address to, uint256 value) internal {
747         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
748     }
749 
750     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
751         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
752     }
753 
754     /**
755      * @dev Deprecated. This function has issues similar to the ones found in
756      * {IERC20-approve}, and its usage is discouraged.
757      *
758      * Whenever possible, use {safeIncreaseAllowance} and
759      * {safeDecreaseAllowance} instead.
760      */
761     function safeApprove(IERC20 token, address spender, uint256 value) internal {
762         // safeApprove should only be called when setting an initial allowance,
763         // or when resetting it to zero. To increase and decrease it, use
764         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
765         // solhint-disable-next-line max-line-length
766         require((value == 0) || (token.allowance(address(this), spender) == 0),
767             "SafeERC20: approve from non-zero to non-zero allowance"
768         );
769         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
770     }
771 
772     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
773         uint256 newAllowance = token.allowance(address(this), spender).add(value);
774         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
775     }
776 
777     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
778         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
779         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
780     }
781 
782     /**
783      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
784      * on the return value: the return value is optional (but if data is returned, it must not be false).
785      * @param token The token targeted by the call.
786      * @param data The call data (encoded using abi.encode or one of its variants).
787      */
788     function _callOptionalReturn(IERC20 token, bytes memory data) private {
789         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
790         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
791         // the target address contains contract code and also asserts for success in the low-level call.
792 
793         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
794         if (returndata.length > 0) { // Return data is optional
795             // solhint-disable-next-line max-line-length
796             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
797         }
798     }
799 }
800 ////// src/pickle-jar.sol
801 // https://github.com/iearn-finance/vaults/blob/master/contracts/vaults/yVault.sol
802 
803 /* pragma solidity ^0.6.7; */
804 
805 /* import "./interfaces/controller.sol"; */
806 
807 /* import "./lib/erc20.sol"; */
808 /* import "./lib/safe-math.sol"; */
809 
810 contract PickleJar is ERC20 {
811     using SafeERC20 for IERC20;
812     using Address for address;
813     using SafeMath for uint256;
814 
815     IERC20 public token;
816 
817     uint256 public min = 9500;
818     uint256 public constant max = 10000;
819 
820     address public governance;
821     address public controller;
822 
823     constructor(address _token, address _governance, address _controller)
824         public
825         ERC20(
826             string(abi.encodePacked("pickling ", ERC20(_token).name())),
827             string(abi.encodePacked("p", ERC20(_token).symbol()))
828         )
829     {
830         _setupDecimals(ERC20(_token).decimals());
831         token = IERC20(_token);
832         governance = _governance;
833         controller = _controller;
834     }
835 
836     function balance() public view returns (uint256) {
837         return
838             token.balanceOf(address(this)).add(
839                 IController(controller).balanceOf(address(token))
840             );
841     }
842 
843     function setMin(uint256 _min) external {
844         require(msg.sender == governance, "!governance");
845         min = _min;
846     }
847 
848     function setGovernance(address _governance) public {
849         require(msg.sender == governance, "!governance");
850         governance = _governance;
851     }
852 
853     function setController(address _controller) public {
854         require(msg.sender == governance, "!governance");
855         controller = _controller;
856     }
857 
858     // Custom logic in here for how much the jars allows to be borrowed
859     // Sets minimum required on-hand to keep small withdrawals cheap
860     function available() public view returns (uint256) {
861         return token.balanceOf(address(this)).mul(min).div(max);
862     }
863 
864     function earn() public {
865         uint256 _bal = available();
866         token.safeTransfer(controller, _bal);
867         IController(controller).earn(address(token), _bal);
868     }
869 
870     function depositAll() external {
871         deposit(token.balanceOf(msg.sender));
872     }
873 
874     function deposit(uint256 _amount) public {
875         uint256 _pool = balance();
876         uint256 _before = token.balanceOf(address(this));
877         token.safeTransferFrom(msg.sender, address(this), _amount);
878         uint256 _after = token.balanceOf(address(this));
879         _amount = _after.sub(_before); // Additional check for deflationary tokens
880         uint256 shares = 0;
881         if (totalSupply() == 0) {
882             shares = _amount;
883         } else {
884             shares = (_amount.mul(totalSupply())).div(_pool);
885         }
886         _mint(msg.sender, shares);
887     }
888 
889     function withdrawAll() external {
890         withdraw(balanceOf(msg.sender));
891     }
892 
893     // Used to swap any borrowed reserve over the debt limit to liquidate to 'token'
894     function harvest(address reserve, uint256 amount) external {
895         require(msg.sender == controller, "!controller");
896         require(reserve != address(token), "token");
897         IERC20(reserve).safeTransfer(controller, amount);
898     }
899 
900     // No rebalance implementation for lower fees and faster swaps
901     function withdraw(uint256 _shares) public {
902         uint256 r = (balance().mul(_shares)).div(totalSupply());
903         _burn(msg.sender, _shares);
904 
905         // Check balance
906         uint256 b = token.balanceOf(address(this));
907         if (b < r) {
908             uint256 _withdraw = r.sub(b);
909             IController(controller).withdraw(address(token), _withdraw);
910             uint256 _after = token.balanceOf(address(this));
911             uint256 _diff = _after.sub(b);
912             if (_diff < _withdraw) {
913                 r = b.add(_diff);
914             }
915         }
916 
917         token.safeTransfer(msg.sender, r);
918     }
919 
920     function getRatio() public view returns (uint256) {
921         return balance().mul(1e18).div(totalSupply());
922     }
923 }