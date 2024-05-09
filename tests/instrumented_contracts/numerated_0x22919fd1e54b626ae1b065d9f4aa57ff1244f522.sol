1 // hevm: flattened sources of src/mith-jar.sol
2 pragma solidity >=0.6.0 <0.7.0 >=0.6.2 <0.7.0 >=0.6.7 <0.7.0;
3 
4 ////// src/interfaces/strategy.sol
5 // SPDX-License-Identifier: MIT
6 /* pragma solidity ^0.6.2; */
7 
8 interface IStrategy {
9     function rewards() external view returns (address);
10 
11     function gauge() external view returns (address);
12 
13     function want() external view returns (address);
14 
15     function initiator() external view returns (address);
16 
17     function stakingContract() external view returns (address);
18 
19     function treasury() external view returns (address);
20 
21     function deposit() external;
22 
23     function withdrawForSwap(uint256) external returns (uint256);
24 
25     function withdraw(address) external;
26 
27     function withdraw(uint256) external;
28 
29     function skim() external;
30 
31     function withdrawAll() external returns (uint256);
32 
33     function balanceOf() external view returns (uint256);
34 
35     function getHarvestable() external view returns (uint256);
36 
37     function harvest() external;
38 
39     function setJar(address _jar) external;
40     
41     function setInitiator(address _initiator) external;
42 
43     function setStakingContract(address _stakingContract) external;
44 
45     function execute(address _target, bytes calldata _data)
46         external
47         payable
48         returns (bytes memory response);
49 
50     function execute(bytes calldata _data)
51         external
52         payable
53         returns (bytes memory response);
54 }
55 
56 ////// src/lib/context.sol
57 // SPDX-License-Identifier: MIT
58 
59 /* pragma solidity ^0.6.0; */
60 
61 /*
62  * @dev Provides information about the current execution context, including the
63  * sender of the transaction and its data. While these are generally available
64  * via msg.sender and msg.data, they should not be accessed in such a direct
65  * manner, since when dealing with GSN meta-transactions the account sending and
66  * paying for execution may not be the actual sender (as far as an application
67  * is concerned).
68  *
69  * This contract is only required for intermediate, library-like contracts.
70  */
71 abstract contract Context {
72     function _msgSender() internal view virtual returns (address payable) {
73         return msg.sender;
74     }
75 
76     function _msgData() internal view virtual returns (bytes memory) {
77         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
78         return msg.data;
79     }
80 }
81 
82 ////// src/lib/safe-math.sol
83 // SPDX-License-Identifier: MIT
84 
85 /* pragma solidity ^0.6.0; */
86 
87 /**
88  * @dev Wrappers over Solidity's arithmetic operations with added overflow
89  * checks.
90  *
91  * Arithmetic operations in Solidity wrap on overflow. This can easily result
92  * in bugs, because programmers usually assume that an overflow raises an
93  * error, which is the standard behavior in high level programming languages.
94  * `SafeMath` restores this intuition by reverting the transaction when an
95  * operation overflows.
96  *
97  * Using this library instead of the unchecked operations eliminates an entire
98  * class of bugs, so it's recommended to use it always.
99  */
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b <= a, errorMessage);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `*` operator.
154      *
155      * Requirements:
156      *
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers. Reverts on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function div(uint256 a, uint256 b) internal pure returns (uint256) {
186         return div(a, b, "SafeMath: division by zero");
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         require(b > 0, errorMessage);
203         uint256 c = a / b;
204         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * Reverts when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         return mod(a, b, "SafeMath: modulo by zero");
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts with custom message when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b != 0, errorMessage);
239         return a % b;
240     }
241 }
242 ////// src/lib/erc20.sol
243 
244 // File: contracts/GSN/Context.sol
245 
246 // SPDX-License-Identifier: MIT
247 
248 /* pragma solidity ^0.6.0; */
249 
250 /* import "./safe-math.sol"; */
251 /* import "./context.sol"; */
252 
253 // File: contracts/token/ERC20/IERC20.sol
254 
255 
256 /**
257  * @dev Interface of the ERC20 standard as defined in the EIP.
258  */
259 interface IERC20 {
260     /**
261      * @dev Returns the amount of tokens in existence.
262      */
263     function totalSupply() external view returns (uint256);
264 
265     /**
266      * @dev Returns the amount of tokens owned by `account`.
267      */
268     function balanceOf(address account) external view returns (uint256);
269 
270     /**
271      * @dev Moves `amount` tokens from the caller's account to `recipient`.
272      *
273      * Returns a boolean value indicating whether the operation succeeded.
274      *
275      * Emits a {Transfer} event.
276      */
277     function transfer(address recipient, uint256 amount) external returns (bool);
278 
279     /**
280      * @dev Returns the remaining number of tokens that `spender` will be
281      * allowed to spend on behalf of `owner` through {transferFrom}. This is
282      * zero by default.
283      *
284      * This value changes when {approve} or {transferFrom} are called.
285      */
286     function allowance(address owner, address spender) external view returns (uint256);
287 
288     /**
289      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
290      *
291      * Returns a boolean value indicating whether the operation succeeded.
292      *
293      * IMPORTANT: Beware that changing an allowance with this method brings the risk
294      * that someone may use both the old and the new allowance by unfortunate
295      * transaction ordering. One possible solution to mitigate this race
296      * condition is to first reduce the spender's allowance to 0 and set the
297      * desired value afterwards:
298      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
299      *
300      * Emits an {Approval} event.
301      */
302     function approve(address spender, uint256 amount) external returns (bool);
303 
304     /**
305      * @dev Moves `amount` tokens from `sender` to `recipient` using the
306      * allowance mechanism. `amount` is then deducted from the caller's
307      * allowance.
308      *
309      * Returns a boolean value indicating whether the operation succeeded.
310      *
311      * Emits a {Transfer} event.
312      */
313     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
314 
315     /**
316      * @dev Emitted when `value` tokens are moved from one account (`from`) to
317      * another (`to`).
318      *
319      * Note that `value` may be zero.
320      */
321     event Transfer(address indexed from, address indexed to, uint256 value);
322 
323     /**
324      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
325      * a call to {approve}. `value` is the new allowance.
326      */
327     event Approval(address indexed owner, address indexed spender, uint256 value);
328 }
329 
330 // File: contracts/utils/Address.sol
331 
332 
333 /**
334  * @dev Collection of functions related to the address type
335  */
336 library Address {
337     /**
338      * @dev Returns true if `account` is a contract.
339      *
340      * [IMPORTANT]
341      * ====
342      * It is unsafe to assume that an address for which this function returns
343      * false is an externally-owned account (EOA) and not a contract.
344      *
345      * Among others, `isContract` will return false for the following
346      * types of addresses:
347      *
348      *  - an externally-owned account
349      *  - a contract in construction
350      *  - an address where a contract will be created
351      *  - an address where a contract lived, but was destroyed
352      * ====
353      */
354     function isContract(address account) internal view returns (bool) {
355         // This method relies on extcodesize, which returns 0 for contracts in
356         // construction, since the code is only stored at the end of the
357         // constructor execution.
358 
359         uint256 size;
360         // solhint-disable-next-line no-inline-assembly
361         assembly { size := extcodesize(account) }
362         return size > 0;
363     }
364 
365     /**
366      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
367      * `recipient`, forwarding all available gas and reverting on errors.
368      *
369      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
370      * of certain opcodes, possibly making contracts go over the 2300 gas limit
371      * imposed by `transfer`, making them unable to receive funds via
372      * `transfer`. {sendValue} removes this limitation.
373      *
374      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
375      *
376      * IMPORTANT: because control is transferred to `recipient`, care must be
377      * taken to not create reentrancy vulnerabilities. Consider using
378      * {ReentrancyGuard} or the
379      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
380      */
381     function sendValue(address payable recipient, uint256 amount) internal {
382         require(address(this).balance >= amount, "Address: insufficient balance");
383 
384         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
385         (bool success, ) = recipient.call{ value: amount }("");
386         require(success, "Address: unable to send value, recipient may have reverted");
387     }
388 
389     /**
390      * @dev Performs a Solidity function call using a low level `call`. A
391      * plain`call` is an unsafe replacement for a function call: use this
392      * function instead.
393      *
394      * If `target` reverts with a revert reason, it is bubbled up by this
395      * function (like regular Solidity function calls).
396      *
397      * Returns the raw returned data. To convert to the expected return value,
398      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
399      *
400      * Requirements:
401      *
402      * - `target` must be a contract.
403      * - calling `target` with `data` must not revert.
404      *
405      * _Available since v3.1._
406      */
407     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
408       return functionCall(target, data, "Address: low-level call failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
413      * `errorMessage` as a fallback revert reason when `target` reverts.
414      *
415      * _Available since v3.1._
416      */
417     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
418         return _functionCallWithValue(target, data, 0, errorMessage);
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
423      * but also transferring `value` wei to `target`.
424      *
425      * Requirements:
426      *
427      * - the calling contract must have an ETH balance of at least `value`.
428      * - the called Solidity function must be `payable`.
429      *
430      * _Available since v3.1._
431      */
432     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
433         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
438      * with `errorMessage` as a fallback revert reason when `target` reverts.
439      *
440      * _Available since v3.1._
441      */
442     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
443         require(address(this).balance >= value, "Address: insufficient balance for call");
444         return _functionCallWithValue(target, data, value, errorMessage);
445     }
446 
447     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
448         require(isContract(target), "Address: call to non-contract");
449 
450         // solhint-disable-next-line avoid-low-level-calls
451         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
452         if (success) {
453             return returndata;
454         } else {
455             // Look for revert reason and bubble it up if present
456             if (returndata.length > 0) {
457                 // The easiest way to bubble the revert reason is using memory via assembly
458 
459                 // solhint-disable-next-line no-inline-assembly
460                 assembly {
461                     let returndata_size := mload(returndata)
462                     revert(add(32, returndata), returndata_size)
463                 }
464             } else {
465                 revert(errorMessage);
466             }
467         }
468     }
469 }
470 
471 // File: contracts/token/ERC20/ERC20.sol
472 
473 /**
474  * @dev Implementation of the {IERC20} interface.
475  *
476  * This implementation is agnostic to the way tokens are created. This means
477  * that a supply mechanism has to be added in a derived contract using {_mint}.
478  * For a generic mechanism see {ERC20PresetMinterPauser}.
479  *
480  * TIP: For a detailed writeup see our guide
481  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
482  * to implement supply mechanisms].
483  *
484  * We have followed general OpenZeppelin guidelines: functions revert instead
485  * of returning `false` on failure. This behavior is nonetheless conventional
486  * and does not conflict with the expectations of ERC20 applications.
487  *
488  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
489  * This allows applications to reconstruct the allowance for all accounts just
490  * by listening to said events. Other implementations of the EIP may not emit
491  * these events, as it isn't required by the specification.
492  *
493  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
494  * functions have been added to mitigate the well-known issues around setting
495  * allowances. See {IERC20-approve}.
496  */
497 contract ERC20 is Context, IERC20 {
498     using SafeMath for uint256;
499     using Address for address;
500 
501     mapping (address => uint256) private _balances;
502 
503     mapping (address => mapping (address => uint256)) private _allowances;
504 
505     uint256 private _totalSupply;
506 
507     string private _name;
508     string private _symbol;
509     uint8 private _decimals;
510 
511     /**
512      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
513      * a default value of 18.
514      *
515      * To select a different value for {decimals}, use {_setupDecimals}.
516      *
517      * All three of these values are immutable: they can only be set once during
518      * construction.
519      */
520     constructor (string memory name, string memory symbol) public {
521         _name = name;
522         _symbol = symbol;
523         _decimals = 18;
524     }
525 
526     /**
527      * @dev Returns the name of the token.
528      */
529     function name() public view returns (string memory) {
530         return _name;
531     }
532 
533     /**
534      * @dev Returns the symbol of the token, usually a shorter version of the
535      * name.
536      */
537     function symbol() public view returns (string memory) {
538         return _symbol;
539     }
540 
541     /**
542      * @dev Returns the number of decimals used to get its user representation.
543      * For example, if `decimals` equals `2`, a balance of `505` tokens should
544      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
545      *
546      * Tokens usually opt for a value of 18, imitating the relationship between
547      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
548      * called.
549      *
550      * NOTE: This information is only used for _display_ purposes: it in
551      * no way affects any of the arithmetic of the contract, including
552      * {IERC20-balanceOf} and {IERC20-transfer}.
553      */
554     function decimals() public view returns (uint8) {
555         return _decimals;
556     }
557 
558     /**
559      * @dev See {IERC20-totalSupply}.
560      */
561     function totalSupply() public view override returns (uint256) {
562         return _totalSupply;
563     }
564 
565     /**
566      * @dev See {IERC20-balanceOf}.
567      */
568     function balanceOf(address account) public view override returns (uint256) {
569         return _balances[account];
570     }
571 
572     /**
573      * @dev See {IERC20-transfer}.
574      *
575      * Requirements:
576      *
577      * - `recipient` cannot be the zero address.
578      * - the caller must have a balance of at least `amount`.
579      */
580     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
581         _transfer(_msgSender(), recipient, amount);
582         return true;
583     }
584 
585     /**
586      * @dev See {IERC20-allowance}.
587      */
588     function allowance(address owner, address spender) public view virtual override returns (uint256) {
589         return _allowances[owner][spender];
590     }
591 
592     /**
593      * @dev See {IERC20-approve}.
594      *
595      * Requirements:
596      *
597      * - `spender` cannot be the zero address.
598      */
599     function approve(address spender, uint256 amount) public virtual override returns (bool) {
600         _approve(_msgSender(), spender, amount);
601         return true;
602     }
603 
604     /**
605      * @dev See {IERC20-transferFrom}.
606      *
607      * Emits an {Approval} event indicating the updated allowance. This is not
608      * required by the EIP. See the note at the beginning of {ERC20};
609      *
610      * Requirements:
611      * - `sender` and `recipient` cannot be the zero address.
612      * - `sender` must have a balance of at least `amount`.
613      * - the caller must have allowance for ``sender``'s tokens of at least
614      * `amount`.
615      */
616     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
617         _transfer(sender, recipient, amount);
618         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
619         return true;
620     }
621 
622     /**
623      * @dev Atomically increases the allowance granted to `spender` by the caller.
624      *
625      * This is an alternative to {approve} that can be used as a mitigation for
626      * problems described in {IERC20-approve}.
627      *
628      * Emits an {Approval} event indicating the updated allowance.
629      *
630      * Requirements:
631      *
632      * - `spender` cannot be the zero address.
633      */
634     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
635         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
636         return true;
637     }
638 
639     /**
640      * @dev Atomically decreases the allowance granted to `spender` by the caller.
641      *
642      * This is an alternative to {approve} that can be used as a mitigation for
643      * problems described in {IERC20-approve}.
644      *
645      * Emits an {Approval} event indicating the updated allowance.
646      *
647      * Requirements:
648      *
649      * - `spender` cannot be the zero address.
650      * - `spender` must have allowance for the caller of at least
651      * `subtractedValue`.
652      */
653     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
654         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
655         return true;
656     }
657 
658     /**
659      * @dev Moves tokens `amount` from `sender` to `recipient`.
660      *
661      * This is internal function is equivalent to {transfer}, and can be used to
662      * e.g. implement automatic token fees, slashing mechanisms, etc.
663      *
664      * Emits a {Transfer} event.
665      *
666      * Requirements:
667      *
668      * - `sender` cannot be the zero address.
669      * - `recipient` cannot be the zero address.
670      * - `sender` must have a balance of at least `amount`.
671      */
672     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
673         require(sender != address(0), "ERC20: transfer from the zero address");
674         require(recipient != address(0), "ERC20: transfer to the zero address");
675 
676         _beforeTokenTransfer(sender, recipient, amount);
677 
678         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
679         _balances[recipient] = _balances[recipient].add(amount);
680         emit Transfer(sender, recipient, amount);
681     }
682 
683     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
684      * the total supply.
685      *
686      * Emits a {Transfer} event with `from` set to the zero address.
687      *
688      * Requirements
689      *
690      * - `to` cannot be the zero address.
691      */
692     function _mint(address account, uint256 amount) internal virtual {
693         require(account != address(0), "ERC20: mint to the zero address");
694 
695         _beforeTokenTransfer(address(0), account, amount);
696 
697         _totalSupply = _totalSupply.add(amount);
698         _balances[account] = _balances[account].add(amount);
699         emit Transfer(address(0), account, amount);
700     }
701 
702     /**
703      * @dev Destroys `amount` tokens from `account`, reducing the
704      * total supply.
705      *
706      * Emits a {Transfer} event with `to` set to the zero address.
707      *
708      * Requirements
709      *
710      * - `account` cannot be the zero address.
711      * - `account` must have at least `amount` tokens.
712      */
713     function _burn(address account, uint256 amount) internal virtual {
714         require(account != address(0), "ERC20: burn from the zero address");
715 
716         _beforeTokenTransfer(account, address(0), amount);
717 
718         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
719         _totalSupply = _totalSupply.sub(amount);
720         emit Transfer(account, address(0), amount);
721     }
722 
723     /**
724      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
725      *
726      * This internal function is equivalent to `approve`, and can be used to
727      * e.g. set automatic allowances for certain subsystems, etc.
728      *
729      * Emits an {Approval} event.
730      *
731      * Requirements:
732      *
733      * - `owner` cannot be the zero address.
734      * - `spender` cannot be the zero address.
735      */
736     function _approve(address owner, address spender, uint256 amount) internal virtual {
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
769     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
770 }
771 
772 /**
773  * @title SafeERC20
774  * @dev Wrappers around ERC20 operations that throw on failure (when the token
775  * contract returns false). Tokens that return no value (and instead revert or
776  * throw on failure) are also supported, non-reverting calls are assumed to be
777  * successful.
778  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
779  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
780  */
781 library SafeERC20 {
782     using SafeMath for uint256;
783     using Address for address;
784 
785     function safeTransfer(IERC20 token, address to, uint256 value) internal {
786         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
787     }
788 
789     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
790         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
791     }
792 
793     /**
794      * @dev Deprecated. This function has issues similar to the ones found in
795      * {IERC20-approve}, and its usage is discouraged.
796      *
797      * Whenever possible, use {safeIncreaseAllowance} and
798      * {safeDecreaseAllowance} instead.
799      */
800     function safeApprove(IERC20 token, address spender, uint256 value) internal {
801         // safeApprove should only be called when setting an initial allowance,
802         // or when resetting it to zero. To increase and decrease it, use
803         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
804         // solhint-disable-next-line max-line-length
805         require((value == 0) || (token.allowance(address(this), spender) == 0),
806             "SafeERC20: approve from non-zero to non-zero allowance"
807         );
808         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
809     }
810 
811     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
812         uint256 newAllowance = token.allowance(address(this), spender).add(value);
813         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
814     }
815 
816     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
817         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
818         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
819     }
820 
821     /**
822      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
823      * on the return value: the return value is optional (but if data is returned, it must not be false).
824      * @param token The token targeted by the call.
825      * @param data The call data (encoded using abi.encode or one of its variants).
826      */
827     function _callOptionalReturn(IERC20 token, bytes memory data) private {
828         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
829         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
830         // the target address contains contract code and also asserts for success in the low-level call.
831 
832         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
833         if (returndata.length > 0) { // Return data is optional
834             // solhint-disable-next-line max-line-length
835             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
836         }
837     }
838 }
839 ////// src/mith-jar.sol
840 // https://github.com/iearn-finance/vaults/blob/master/contracts/vaults/yVault.sol
841 
842 /* pragma solidity ^0.6.7; */
843 
844 /* import "./interfaces/strategy.sol"; */
845 
846 /* import "./lib/erc20.sol"; */
847 /* import "./lib/safe-math.sol"; */
848 
849 contract MithJar is ERC20 {
850     using SafeERC20 for IERC20;
851     using Address for address;
852     using SafeMath for uint256;
853 
854     IERC20 public token;
855 
856     uint256 public min = 9500;
857     uint256 public constant max = 10000;
858 
859     address public strategy;
860 
861     constructor(IStrategy _strategy)
862         public
863         ERC20(
864             string(abi.encodePacked(ERC20(_strategy.want()).name(), "vault")),
865             string(abi.encodePacked("v", ERC20(_strategy.want()).symbol()))
866         )
867     {
868         _setupDecimals(ERC20(_strategy.want()).decimals());
869         token = IERC20(_strategy.want());
870         strategy = address(_strategy);
871     }
872 
873     function balance() public view returns (uint256) {
874         return
875             token.balanceOf(address(this)).add(
876                 IStrategy(strategy).balanceOf()
877             );
878     }
879 
880     // Custom logic in here for how much the jars allows to be borrowed
881     // Sets minimum required on-hand to keep small withdrawals cheap
882     function available() public view returns (uint256) {
883         return token.balanceOf(address(this)).mul(min).div(max);
884     }
885 
886     function earn() public {
887         uint256 _bal = available();
888         token.safeTransfer(strategy, _bal);
889         IStrategy(strategy).deposit();
890     }
891 
892     function depositAll() external {
893         deposit(token.balanceOf(msg.sender));
894     }
895 
896     function deposit(uint256 _amount) public {
897         uint256 _pool = balance();
898         uint256 _before = token.balanceOf(address(this));
899         token.safeTransferFrom(msg.sender, address(this), _amount);
900         uint256 _after = token.balanceOf(address(this));
901         _amount = _after.sub(_before); // Additional check for deflationary tokens
902         uint256 shares = 0;
903         if (totalSupply() == 0) {
904             shares = _amount;
905         } else {
906             shares = (_amount.mul(totalSupply())).div(_pool);
907         }
908         _mint(msg.sender, shares);
909     }
910 
911     function withdrawAll() external {
912         withdraw(balanceOf(msg.sender));
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
924             IStrategy(strategy).withdraw(_withdraw);
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