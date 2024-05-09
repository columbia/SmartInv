1 //
2 // "Here's to the crazy ones..." the degens, the chads, the farmers.
3 //
4 // Welcome to SwapShip RTC. You know this game.
5 //
6 // Stake your Uniswap UNI-V2 LP tokens OR SushiSwap SLP tokens!! Farm SWSH.
7 // And go on a mission! PS. LIQLO stakers are rewarded 10x!
8 //
9 // Captain Cook will tell you more:
10 // https://etherscan.io/address/0xf8bfd0cf1c6f948339d5bd78444bebd78e43ae26
11 //
12 // Good luck!
13 //
14 // Veronika
15 //
16 
17 // //////////////////////////////////////////////////////////////////////////////// //
18 //                                                                                  //
19 //                               ////   //////   /////                              //
20 //                              //        //     //                                 //
21 //                              //        //     /////                              //
22 //                                                                                  //
23 //                              Never break the chain.                              //
24 //                                                                                  //
25 // //////////////////////////////////////////////////////////////////////////////// //
26 
27 
28 // File: @openzeppelin/contracts/GSN/Context.sol
29 
30 
31 
32 pragma solidity ^0.6.0;
33 
34 /*
35  * @dev Provides information about the current execution context, including the
36  * sender of the transaction and its data. While these are generally available
37  * via msg.sender and msg.data, they should not be accessed in such a direct
38  * manner, since when dealing with GSN meta-transactions the account sending and
39  * paying for execution may not be the actual sender (as far as an application
40  * is concerned).
41  *
42  * This contract is only required for intermediate, library-like contracts.
43  */
44 abstract contract Context {
45     function _msgSender() internal view virtual returns (address payable) {
46         return msg.sender;
47     }
48 
49     function _msgData() internal view virtual returns (bytes memory) {
50         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
51         return msg.data;
52     }
53 }
54 
55 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
56 
57 
58 
59 pragma solidity ^0.6.0;
60 
61 /**
62  * @dev Interface of the ERC20 standard as defined in the EIP.
63  */
64 interface IERC20 {
65     /**
66      * @dev Returns the amount of tokens in existence.
67      */
68     function totalSupply() external view returns (uint256);
69 
70     /**
71      * @dev Returns the amount of tokens owned by `account`.
72      */
73     function balanceOf(address account) external view returns (uint256);
74 
75     /**
76      * @dev Moves `amount` tokens from the caller's account to `recipient`.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transfer(address recipient, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Returns the remaining number of tokens that `spender` will be
86      * allowed to spend on behalf of `owner` through {transferFrom}. This is
87      * zero by default.
88      *
89      * This value changes when {approve} or {transferFrom} are called.
90      */
91     function allowance(address owner, address spender) external view returns (uint256);
92 
93     /**
94      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
95      *
96      * Returns a boolean value indicating whether the operation succeeded.
97      *
98      * IMPORTANT: Beware that changing an allowance with this method brings the risk
99      * that someone may use both the old and the new allowance by unfortunate
100      * transaction ordering. One possible solution to mitigate this race
101      * condition is to first reduce the spender's allowance to 0 and set the
102      * desired value afterwards:
103      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
104      *
105      * Emits an {Approval} event.
106      */
107     function approve(address spender, uint256 amount) external returns (bool);
108 
109     /**
110      * @dev Moves `amount` tokens from `sender` to `recipient` using the
111      * allowance mechanism. `amount` is then deducted from the caller's
112      * allowance.
113      *
114      * Returns a boolean value indicating whether the operation succeeded.
115      *
116      * Emits a {Transfer} event.
117      */
118     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
119 
120     /**
121      * @dev Emitted when `value` tokens are moved from one account (`from`) to
122      * another (`to`).
123      *
124      * Note that `value` may be zero.
125      */
126     event Transfer(address indexed from, address indexed to, uint256 value);
127 
128     /**
129      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
130      * a call to {approve}. `value` is the new allowance.
131      */
132     event Approval(address indexed owner, address indexed spender, uint256 value);
133 }
134 
135 // File: @openzeppelin/contracts/math/SafeMath.sol
136 
137 
138 
139 pragma solidity ^0.6.0;
140 
141 /**
142  * @dev Wrappers over Solidity's arithmetic operations with added overflow
143  * checks.
144  *
145  * Arithmetic operations in Solidity wrap on overflow. This can easily result
146  * in bugs, because programmers usually assume that an overflow raises an
147  * error, which is the standard behavior in high level programming languages.
148  * `SafeMath` restores this intuition by reverting the transaction when an
149  * operation overflows.
150  *
151  * Using this library instead of the unchecked operations eliminates an entire
152  * class of bugs, so it's recommended to use it always.
153  */
154 library SafeMath {
155     /**
156      * @dev Returns the addition of two unsigned integers, reverting on
157      * overflow.
158      *
159      * Counterpart to Solidity's `+` operator.
160      *
161      * Requirements:
162      *
163      * - Addition cannot overflow.
164      */
165     function add(uint256 a, uint256 b) internal pure returns (uint256) {
166         uint256 c = a + b;
167         require(c >= a, "SafeMath: addition overflow");
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the subtraction of two unsigned integers, reverting on
174      * overflow (when the result is negative).
175      *
176      * Counterpart to Solidity's `-` operator.
177      *
178      * Requirements:
179      *
180      * - Subtraction cannot overflow.
181      */
182     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
183         return sub(a, b, "SafeMath: subtraction overflow");
184     }
185 
186     /**
187      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
188      * overflow (when the result is negative).
189      *
190      * Counterpart to Solidity's `-` operator.
191      *
192      * Requirements:
193      *
194      * - Subtraction cannot overflow.
195      */
196     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
197         require(b <= a, errorMessage);
198         uint256 c = a - b;
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the multiplication of two unsigned integers, reverting on
205      * overflow.
206      *
207      * Counterpart to Solidity's `*` operator.
208      *
209      * Requirements:
210      *
211      * - Multiplication cannot overflow.
212      */
213     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
214         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
215         // benefit is lost if 'b' is also tested.
216         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
217         if (a == 0) {
218             return 0;
219         }
220 
221         uint256 c = a * b;
222         require(c / a == b, "SafeMath: multiplication overflow");
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the integer division of two unsigned integers. Reverts on
229      * division by zero. The result is rounded towards zero.
230      *
231      * Counterpart to Solidity's `/` operator. Note: this function uses a
232      * `revert` opcode (which leaves remaining gas untouched) while Solidity
233      * uses an invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function div(uint256 a, uint256 b) internal pure returns (uint256) {
240         return div(a, b, "SafeMath: division by zero");
241     }
242 
243     /**
244      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
245      * division by zero. The result is rounded towards zero.
246      *
247      * Counterpart to Solidity's `/` operator. Note: this function uses a
248      * `revert` opcode (which leaves remaining gas untouched) while Solidity
249      * uses an invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256         require(b > 0, errorMessage);
257         uint256 c = a / b;
258         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
259 
260         return c;
261     }
262 
263     /**
264      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
265      * Reverts when dividing by zero.
266      *
267      * Counterpart to Solidity's `%` operator. This function uses a `revert`
268      * opcode (which leaves remaining gas untouched) while Solidity uses an
269      * invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      *
273      * - The divisor cannot be zero.
274      */
275     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
276         return mod(a, b, "SafeMath: modulo by zero");
277     }
278 
279     /**
280      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
281      * Reverts with custom message when dividing by zero.
282      *
283      * Counterpart to Solidity's `%` operator. This function uses a `revert`
284      * opcode (which leaves remaining gas untouched) while Solidity uses an
285      * invalid opcode to revert (consuming all remaining gas).
286      *
287      * Requirements:
288      *
289      * - The divisor cannot be zero.
290      */
291     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
292         require(b != 0, errorMessage);
293         return a % b;
294     }
295 }
296 
297 // File: @openzeppelin/contracts/utils/Address.sol
298 
299 
300 
301 pragma solidity ^0.6.0;
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
325         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
326         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
327         // for accounts without code, i.e. `keccak256('')`
328         bytes32 codehash;
329         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
330         // solhint-disable-next-line no-inline-assembly
331         assembly { codehash := extcodehash(account) }
332         return (codehash != accountHash && codehash != 0x0);
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
441 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
442 
443 
444 
445 pragma solidity ^0.6.0;
446 
447 
448 
449 
450 
451 /**
452  * @dev Implementation of the {IERC20} interface.
453  *
454  * This implementation is agnostic to the way tokens are created. This means
455  * that a supply mechanism has to be added in a derived contract using {_mint}.
456  * For a generic mechanism see {ERC20PresetMinterPauser}.
457  *
458  * TIP: For a detailed writeup see our guide
459  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
460  * to implement supply mechanisms].
461  *
462  * We have followed general OpenZeppelin guidelines: functions revert instead
463  * of returning `false` on failure. This behavior is nonetheless conventional
464  * and does not conflict with the expectations of ERC20 applications.
465  *
466  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
467  * This allows applications to reconstruct the allowance for all accounts just
468  * by listening to said events. Other implementations of the EIP may not emit
469  * these events, as it isn't required by the specification.
470  *
471  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
472  * functions have been added to mitigate the well-known issues around setting
473  * allowances. See {IERC20-approve}.
474  */
475 contract ERC20 is Context, IERC20 {
476     using SafeMath for uint256;
477     using Address for address;
478 
479     mapping (address => uint256) private _balances;
480 
481     mapping (address => mapping (address => uint256)) private _allowances;
482 
483     uint256 private _totalSupply;
484 
485     string private _name;
486     string private _symbol;
487     uint8 private _decimals;
488 
489     /**
490      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
491      * a default value of 18.
492      *
493      * To select a different value for {decimals}, use {_setupDecimals}.
494      *
495      * All three of these values are immutable: they can only be set once during
496      * construction.
497      */
498     constructor (string memory name, string memory symbol) public {
499         _name = name;
500         _symbol = symbol;
501         _decimals = 18;
502     }
503 
504     /**
505      * @dev Returns the name of the token.
506      */
507     function name() public view returns (string memory) {
508         return _name;
509     }
510 
511     /**
512      * @dev Returns the symbol of the token, usually a shorter version of the
513      * name.
514      */
515     function symbol() public view returns (string memory) {
516         return _symbol;
517     }
518 
519     /**
520      * @dev Returns the number of decimals used to get its user representation.
521      * For example, if `decimals` equals `2`, a balance of `505` tokens should
522      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
523      *
524      * Tokens usually opt for a value of 18, imitating the relationship between
525      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
526      * called.
527      *
528      * NOTE: This information is only used for _display_ purposes: it in
529      * no way affects any of the arithmetic of the contract, including
530      * {IERC20-balanceOf} and {IERC20-transfer}.
531      */
532     function decimals() public view returns (uint8) {
533         return _decimals;
534     }
535 
536     /**
537      * @dev See {IERC20-totalSupply}.
538      */
539     function totalSupply() public view override returns (uint256) {
540         return _totalSupply;
541     }
542 
543     /**
544      * @dev See {IERC20-balanceOf}.
545      */
546     function balanceOf(address account) public view override returns (uint256) {
547         return _balances[account];
548     }
549 
550     /**
551      * @dev See {IERC20-transfer}.
552      *
553      * Requirements:
554      *
555      * - `recipient` cannot be the zero address.
556      * - the caller must have a balance of at least `amount`.
557      */
558     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
559         _transfer(_msgSender(), recipient, amount);
560         return true;
561     }
562 
563     /**
564      * @dev See {IERC20-allowance}.
565      */
566     function allowance(address owner, address spender) public view virtual override returns (uint256) {
567         return _allowances[owner][spender];
568     }
569 
570     /**
571      * @dev See {IERC20-approve}.
572      *
573      * Requirements:
574      *
575      * - `spender` cannot be the zero address.
576      */
577     function approve(address spender, uint256 amount) public virtual override returns (bool) {
578         _approve(_msgSender(), spender, amount);
579         return true;
580     }
581 
582     /**
583      * @dev See {IERC20-transferFrom}.
584      *
585      * Emits an {Approval} event indicating the updated allowance. This is not
586      * required by the EIP. See the note at the beginning of {ERC20};
587      *
588      * Requirements:
589      * - `sender` and `recipient` cannot be the zero address.
590      * - `sender` must have a balance of at least `amount`.
591      * - the caller must have allowance for ``sender``'s tokens of at least
592      * `amount`.
593      */
594     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
595         _transfer(sender, recipient, amount);
596         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
597         return true;
598     }
599 
600     /**
601      * @dev Atomically increases the allowance granted to `spender` by the caller.
602      *
603      * This is an alternative to {approve} that can be used as a mitigation for
604      * problems described in {IERC20-approve}.
605      *
606      * Emits an {Approval} event indicating the updated allowance.
607      *
608      * Requirements:
609      *
610      * - `spender` cannot be the zero address.
611      */
612     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
613         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
614         return true;
615     }
616 
617     /**
618      * @dev Atomically decreases the allowance granted to `spender` by the caller.
619      *
620      * This is an alternative to {approve} that can be used as a mitigation for
621      * problems described in {IERC20-approve}.
622      *
623      * Emits an {Approval} event indicating the updated allowance.
624      *
625      * Requirements:
626      *
627      * - `spender` cannot be the zero address.
628      * - `spender` must have allowance for the caller of at least
629      * `subtractedValue`.
630      */
631     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
632         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
633         return true;
634     }
635 
636     /**
637      * @dev Moves tokens `amount` from `sender` to `recipient`.
638      *
639      * This is internal function is equivalent to {transfer}, and can be used to
640      * e.g. implement automatic token fees, slashing mechanisms, etc.
641      *
642      * Emits a {Transfer} event.
643      *
644      * Requirements:
645      *
646      * - `sender` cannot be the zero address.
647      * - `recipient` cannot be the zero address.
648      * - `sender` must have a balance of at least `amount`.
649      */
650     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
651         require(sender != address(0), "ERC20: transfer from the zero address");
652         require(recipient != address(0), "ERC20: transfer to the zero address");
653 
654         _beforeTokenTransfer(sender, recipient, amount);
655 
656         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
657         _balances[recipient] = _balances[recipient].add(amount);
658         emit Transfer(sender, recipient, amount);
659     }
660 
661     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
662      * the total supply.
663      *
664      * Emits a {Transfer} event with `from` set to the zero address.
665      *
666      * Requirements
667      *
668      * - `to` cannot be the zero address.
669      */
670     function _mint(address account, uint256 amount) internal virtual {
671         require(account != address(0), "ERC20: mint to the zero address");
672 
673         _beforeTokenTransfer(address(0), account, amount);
674 
675         _totalSupply = _totalSupply.add(amount);
676         _balances[account] = _balances[account].add(amount);
677         emit Transfer(address(0), account, amount);
678     }
679 
680     /**
681      * @dev Destroys `amount` tokens from `account`, reducing the
682      * total supply.
683      *
684      * Emits a {Transfer} event with `to` set to the zero address.
685      *
686      * Requirements
687      *
688      * - `account` cannot be the zero address.
689      * - `account` must have at least `amount` tokens.
690      */
691     function _burn(address account, uint256 amount) internal virtual {
692         require(account != address(0), "ERC20: burn from the zero address");
693 
694         _beforeTokenTransfer(account, address(0), amount);
695 
696         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
697         _totalSupply = _totalSupply.sub(amount);
698         emit Transfer(account, address(0), amount);
699     }
700 
701     /**
702      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
703      *
704      * This is internal function is equivalent to `approve`, and can be used to
705      * e.g. set automatic allowances for certain subsystems, etc.
706      *
707      * Emits an {Approval} event.
708      *
709      * Requirements:
710      *
711      * - `owner` cannot be the zero address.
712      * - `spender` cannot be the zero address.
713      */
714     function _approve(address owner, address spender, uint256 amount) internal virtual {
715         require(owner != address(0), "ERC20: approve from the zero address");
716         require(spender != address(0), "ERC20: approve to the zero address");
717 
718         _allowances[owner][spender] = amount;
719         emit Approval(owner, spender, amount);
720     }
721 
722     /**
723      * @dev Sets {decimals} to a value other than the default one of 18.
724      *
725      * WARNING: This function should only be called from the constructor. Most
726      * applications that interact with token contracts will not expect
727      * {decimals} to ever change, and may work incorrectly if it does.
728      */
729     function _setupDecimals(uint8 decimals_) internal {
730         _decimals = decimals_;
731     }
732 
733     /**
734      * @dev Hook that is called before any transfer of tokens. This includes
735      * minting and burning.
736      *
737      * Calling conditions:
738      *
739      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
740      * will be to transferred to `to`.
741      * - when `from` is zero, `amount` tokens will be minted for `to`.
742      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
743      * - `from` and `to` are never both zero.
744      *
745      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
746      */
747     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
748 }
749 
750 // File: @openzeppelin/contracts/access/Ownable.sol
751 
752 
753 
754 pragma solidity ^0.6.0;
755 
756 /**
757  * @dev Contract module which provides a basic access control mechanism, where
758  * there is an account (an owner) that can be granted exclusive access to
759  * specific functions.
760  *
761  * By default, the owner account will be the one that deploys the contract. This
762  * can later be changed with {transferOwnership}.
763  *
764  * This module is used through inheritance. It will make available the modifier
765  * `onlyOwner`, which can be applied to your functions to restrict their use to
766  * the owner.
767  */
768 contract Ownable is Context {
769     address private _owner;
770 
771     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
772 
773     /**
774      * @dev Initializes the contract setting the deployer as the initial owner.
775      */
776     constructor () internal {
777         address msgSender = _msgSender();
778         _owner = msgSender;
779         emit OwnershipTransferred(address(0), msgSender);
780     }
781 
782     /**
783      * @dev Returns the address of the current owner.
784      */
785     function owner() public view returns (address) {
786         return _owner;
787     }
788 
789     /**
790      * @dev Throws if called by any account other than the owner.
791      */
792     modifier onlyOwner() {
793         require(_owner == _msgSender(), "Ownable: caller is not the owner");
794         _;
795     }
796 
797     /**
798      * @dev Leaves the contract without owner. It will not be possible to call
799      * `onlyOwner` functions anymore. Can only be called by the current owner.
800      *
801      * NOTE: Renouncing ownership will leave the contract without an owner,
802      * thereby removing any functionality that is only available to the owner.
803      */
804     function renounceOwnership() public virtual onlyOwner {
805         emit OwnershipTransferred(_owner, address(0));
806         _owner = address(0);
807     }
808 
809     /**
810      * @dev Transfers ownership of the contract to a new account (`newOwner`).
811      * Can only be called by the current owner.
812      */
813     function transferOwnership(address newOwner) public virtual onlyOwner {
814         require(newOwner != address(0), "Ownable: new owner is the zero address");
815         emit OwnershipTransferred(_owner, newOwner);
816         _owner = newOwner;
817     }
818 }
819 
820 pragma solidity ^0.6.0;
821 
822 contract TokenRecover is Ownable {
823 
824 
825     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
826         IERC20(tokenAddress).transfer(owner(), tokenAmount);
827     }
828 }
829 
830 // File: contracts/SwapShipToken.sol
831 
832 pragma solidity ^0.6.0;
833 
834 
835 
836 
837 // SwapShipToken.
838 contract SwapShipToken is ERC20("SwapShip RTC", "SWSH"), Ownable {
839     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (CaptainCook).
840     function mint(address _to, uint256 _amount) public onlyOwner {
841         _mint(_to, _amount);
842     }
843 }