1 /*! bloomzed.sol | (c) 2020 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | SPDX-License-Identifier: MIT License */
2 
3 pragma solidity 0.6.11;
4 
5 
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
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor () internal {
49         address msgSender = _msgSender();
50         _owner = msgSender;
51         emit OwnershipTransferred(address(0), msgSender);
52     }
53 
54     /**
55      * @dev Returns the address of the current owner.
56      */
57     function owner() public view returns (address) {
58         return _owner;
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(_owner == _msgSender(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     /**
70      * @dev Leaves the contract without owner. It will not be possible to call
71      * `onlyOwner` functions anymore. Can only be called by the current owner.
72      *
73      * NOTE: Renouncing ownership will leave the contract without an owner,
74      * thereby removing any functionality that is only available to the owner.
75      */
76     function renounceOwnership() public virtual onlyOwner {
77         emit OwnershipTransferred(_owner, address(0));
78         _owner = address(0);
79     }
80 
81     /**
82      * @dev Transfers ownership of the contract to a new account (`newOwner`).
83      * Can only be called by the current owner.
84      */
85     function transferOwnership(address newOwner) public virtual onlyOwner {
86         require(newOwner != address(0), "Ownable: new owner is the zero address");
87         emit OwnershipTransferred(_owner, newOwner);
88         _owner = newOwner;
89     }
90 }
91 
92 
93 /**
94  * @dev Interface of the ERC20 standard as defined in the EIP.
95  */
96 interface IERC20 {
97     /**
98      * @dev Returns the amount of tokens in existence.
99      */
100     function totalSupply() external view returns (uint256);
101 
102     /**
103      * @dev Returns the amount of tokens owned by `account`.
104      */
105     function balanceOf(address account) external view returns (uint256);
106 
107     /**
108      * @dev Moves `amount` tokens from the caller's account to `recipient`.
109      *
110      * Returns a boolean value indicating whether the operation succeeded.
111      *
112      * Emits a {Transfer} event.
113      */
114     function transfer(address recipient, uint256 amount) external returns (bool);
115 
116     /**
117      * @dev Returns the remaining number of tokens that `spender` will be
118      * allowed to spend on behalf of `owner` through {transferFrom}. This is
119      * zero by default.
120      *
121      * This value changes when {approve} or {transferFrom} are called.
122      */
123     function allowance(address owner, address spender) external view returns (uint256);
124 
125     /**
126      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
127      *
128      * Returns a boolean value indicating whether the operation succeeded.
129      *
130      * IMPORTANT: Beware that changing an allowance with this method brings the risk
131      * that someone may use both the old and the new allowance by unfortunate
132      * transaction ordering. One possible solution to mitigate this race
133      * condition is to first reduce the spender's allowance to 0 and set the
134      * desired value afterwards:
135      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
136      *
137      * Emits an {Approval} event.
138      */
139     function approve(address spender, uint256 amount) external returns (bool);
140 
141     /**
142      * @dev Moves `amount` tokens from `sender` to `recipient` using the
143      * allowance mechanism. `amount` is then deducted from the caller's
144      * allowance.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * Emits a {Transfer} event.
149      */
150     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
151 
152     /**
153      * @dev Emitted when `value` tokens are moved from one account (`from`) to
154      * another (`to`).
155      *
156      * Note that `value` may be zero.
157      */
158     event Transfer(address indexed from, address indexed to, uint256 value);
159 
160     /**
161      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
162      * a call to {approve}. `value` is the new allowance.
163      */
164     event Approval(address indexed owner, address indexed spender, uint256 value);
165 }
166 
167 
168 
169 
170 
171 
172 /**
173  * @dev Wrappers over Solidity's arithmetic operations with added overflow
174  * checks.
175  *
176  * Arithmetic operations in Solidity wrap on overflow. This can easily result
177  * in bugs, because programmers usually assume that an overflow raises an
178  * error, which is the standard behavior in high level programming languages.
179  * `SafeMath` restores this intuition by reverting the transaction when an
180  * operation overflows.
181  *
182  * Using this library instead of the unchecked operations eliminates an entire
183  * class of bugs, so it's recommended to use it always.
184  */
185 library SafeMath {
186     /**
187      * @dev Returns the addition of two unsigned integers, reverting on
188      * overflow.
189      *
190      * Counterpart to Solidity's `+` operator.
191      *
192      * Requirements:
193      *
194      * - Addition cannot overflow.
195      */
196     function add(uint256 a, uint256 b) internal pure returns (uint256) {
197         uint256 c = a + b;
198         require(c >= a, "SafeMath: addition overflow");
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the subtraction of two unsigned integers, reverting on
205      * overflow (when the result is negative).
206      *
207      * Counterpart to Solidity's `-` operator.
208      *
209      * Requirements:
210      *
211      * - Subtraction cannot overflow.
212      */
213     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
214         return sub(a, b, "SafeMath: subtraction overflow");
215     }
216 
217     /**
218      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
219      * overflow (when the result is negative).
220      *
221      * Counterpart to Solidity's `-` operator.
222      *
223      * Requirements:
224      *
225      * - Subtraction cannot overflow.
226      */
227     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b <= a, errorMessage);
229         uint256 c = a - b;
230 
231         return c;
232     }
233 
234     /**
235      * @dev Returns the multiplication of two unsigned integers, reverting on
236      * overflow.
237      *
238      * Counterpart to Solidity's `*` operator.
239      *
240      * Requirements:
241      *
242      * - Multiplication cannot overflow.
243      */
244     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
245         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
246         // benefit is lost if 'b' is also tested.
247         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
248         if (a == 0) {
249             return 0;
250         }
251 
252         uint256 c = a * b;
253         require(c / a == b, "SafeMath: multiplication overflow");
254 
255         return c;
256     }
257 
258     /**
259      * @dev Returns the integer division of two unsigned integers. Reverts on
260      * division by zero. The result is rounded towards zero.
261      *
262      * Counterpart to Solidity's `/` operator. Note: this function uses a
263      * `revert` opcode (which leaves remaining gas untouched) while Solidity
264      * uses an invalid opcode to revert (consuming all remaining gas).
265      *
266      * Requirements:
267      *
268      * - The divisor cannot be zero.
269      */
270     function div(uint256 a, uint256 b) internal pure returns (uint256) {
271         return div(a, b, "SafeMath: division by zero");
272     }
273 
274     /**
275      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
276      * division by zero. The result is rounded towards zero.
277      *
278      * Counterpart to Solidity's `/` operator. Note: this function uses a
279      * `revert` opcode (which leaves remaining gas untouched) while Solidity
280      * uses an invalid opcode to revert (consuming all remaining gas).
281      *
282      * Requirements:
283      *
284      * - The divisor cannot be zero.
285      */
286     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
287         require(b > 0, errorMessage);
288         uint256 c = a / b;
289         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
290 
291         return c;
292     }
293 
294     /**
295      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
296      * Reverts when dividing by zero.
297      *
298      * Counterpart to Solidity's `%` operator. This function uses a `revert`
299      * opcode (which leaves remaining gas untouched) while Solidity uses an
300      * invalid opcode to revert (consuming all remaining gas).
301      *
302      * Requirements:
303      *
304      * - The divisor cannot be zero.
305      */
306     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
307         return mod(a, b, "SafeMath: modulo by zero");
308     }
309 
310     /**
311      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
312      * Reverts with custom message when dividing by zero.
313      *
314      * Counterpart to Solidity's `%` operator. This function uses a `revert`
315      * opcode (which leaves remaining gas untouched) while Solidity uses an
316      * invalid opcode to revert (consuming all remaining gas).
317      *
318      * Requirements:
319      *
320      * - The divisor cannot be zero.
321      */
322     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
323         require(b != 0, errorMessage);
324         return a % b;
325     }
326 }
327 
328 
329 /**
330  * @dev Collection of functions related to the address type
331  */
332 library Address {
333     /**
334      * @dev Returns true if `account` is a contract.
335      *
336      * [IMPORTANT]
337      * ====
338      * It is unsafe to assume that an address for which this function returns
339      * false is an externally-owned account (EOA) and not a contract.
340      *
341      * Among others, `isContract` will return false for the following
342      * types of addresses:
343      *
344      *  - an externally-owned account
345      *  - a contract in construction
346      *  - an address where a contract will be created
347      *  - an address where a contract lived, but was destroyed
348      * ====
349      */
350     function isContract(address account) internal view returns (bool) {
351         // This method relies in extcodesize, which returns 0 for contracts in
352         // construction, since the code is only stored at the end of the
353         // constructor execution.
354 
355         uint256 size;
356         // solhint-disable-next-line no-inline-assembly
357         assembly { size := extcodesize(account) }
358         return size > 0;
359     }
360 
361     /**
362      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
363      * `recipient`, forwarding all available gas and reverting on errors.
364      *
365      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
366      * of certain opcodes, possibly making contracts go over the 2300 gas limit
367      * imposed by `transfer`, making them unable to receive funds via
368      * `transfer`. {sendValue} removes this limitation.
369      *
370      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
371      *
372      * IMPORTANT: because control is transferred to `recipient`, care must be
373      * taken to not create reentrancy vulnerabilities. Consider using
374      * {ReentrancyGuard} or the
375      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
376      */
377     function sendValue(address payable recipient, uint256 amount) internal {
378         require(address(this).balance >= amount, "Address: insufficient balance");
379 
380         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
381         (bool success, ) = recipient.call{ value: amount }("");
382         require(success, "Address: unable to send value, recipient may have reverted");
383     }
384 
385     /**
386      * @dev Performs a Solidity function call using a low level `call`. A
387      * plain`call` is an unsafe replacement for a function call: use this
388      * function instead.
389      *
390      * If `target` reverts with a revert reason, it is bubbled up by this
391      * function (like regular Solidity function calls).
392      *
393      * Returns the raw returned data. To convert to the expected return value,
394      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
395      *
396      * Requirements:
397      *
398      * - `target` must be a contract.
399      * - calling `target` with `data` must not revert.
400      *
401      * _Available since v3.1._
402      */
403     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
404       return functionCall(target, data, "Address: low-level call failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
409      * `errorMessage` as a fallback revert reason when `target` reverts.
410      *
411      * _Available since v3.1._
412      */
413     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
414         return _functionCallWithValue(target, data, 0, errorMessage);
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
419      * but also transferring `value` wei to `target`.
420      *
421      * Requirements:
422      *
423      * - the calling contract must have an ETH balance of at least `value`.
424      * - the called Solidity function must be `payable`.
425      *
426      * _Available since v3.1._
427      */
428     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
429         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
434      * with `errorMessage` as a fallback revert reason when `target` reverts.
435      *
436      * _Available since v3.1._
437      */
438     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
439         require(address(this).balance >= value, "Address: insufficient balance for call");
440         return _functionCallWithValue(target, data, value, errorMessage);
441     }
442 
443     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
444         require(isContract(target), "Address: call to non-contract");
445 
446         // solhint-disable-next-line avoid-low-level-calls
447         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
448         if (success) {
449             return returndata;
450         } else {
451             // Look for revert reason and bubble it up if present
452             if (returndata.length > 0) {
453                 // The easiest way to bubble the revert reason is using memory via assembly
454 
455                 // solhint-disable-next-line no-inline-assembly
456                 assembly {
457                     let returndata_size := mload(returndata)
458                     revert(add(32, returndata), returndata_size)
459                 }
460             } else {
461                 revert(errorMessage);
462             }
463         }
464     }
465 }
466 
467 
468 /**
469  * @dev Implementation of the {IERC20} interface.
470  *
471  * This implementation is agnostic to the way tokens are created. This means
472  * that a supply mechanism has to be added in a derived contract using {_mint}.
473  * For a generic mechanism see {ERC20PresetMinterPauser}.
474  *
475  * TIP: For a detailed writeup see our guide
476  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
477  * to implement supply mechanisms].
478  *
479  * We have followed general OpenZeppelin guidelines: functions revert instead
480  * of returning `false` on failure. This behavior is nonetheless conventional
481  * and does not conflict with the expectations of ERC20 applications.
482  *
483  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
484  * This allows applications to reconstruct the allowance for all accounts just
485  * by listening to said events. Other implementations of the EIP may not emit
486  * these events, as it isn't required by the specification.
487  *
488  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
489  * functions have been added to mitigate the well-known issues around setting
490  * allowances. See {IERC20-approve}.
491  */
492 contract ERC20 is Context, IERC20 {
493     using SafeMath for uint256;
494     using Address for address;
495 
496     mapping (address => uint256) private _balances;
497 
498     mapping (address => mapping (address => uint256)) private _allowances;
499 
500     uint256 private _totalSupply;
501 
502     string private _name;
503     string private _symbol;
504     uint8 private _decimals;
505 
506     /**
507      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
508      * a default value of 18.
509      *
510      * To select a different value for {decimals}, use {_setupDecimals}.
511      *
512      * All three of these values are immutable: they can only be set once during
513      * construction.
514      */
515     constructor (string memory name, string memory symbol) public {
516         _name = name;
517         _symbol = symbol;
518         _decimals = 18;
519     }
520 
521     /**
522      * @dev Returns the name of the token.
523      */
524     function name() public view returns (string memory) {
525         return _name;
526     }
527 
528     /**
529      * @dev Returns the symbol of the token, usually a shorter version of the
530      * name.
531      */
532     function symbol() public view returns (string memory) {
533         return _symbol;
534     }
535 
536     /**
537      * @dev Returns the number of decimals used to get its user representation.
538      * For example, if `decimals` equals `2`, a balance of `505` tokens should
539      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
540      *
541      * Tokens usually opt for a value of 18, imitating the relationship between
542      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
543      * called.
544      *
545      * NOTE: This information is only used for _display_ purposes: it in
546      * no way affects any of the arithmetic of the contract, including
547      * {IERC20-balanceOf} and {IERC20-transfer}.
548      */
549     function decimals() public view returns (uint8) {
550         return _decimals;
551     }
552 
553     /**
554      * @dev See {IERC20-totalSupply}.
555      */
556     function totalSupply() public view override returns (uint256) {
557         return _totalSupply;
558     }
559 
560     /**
561      * @dev See {IERC20-balanceOf}.
562      */
563     function balanceOf(address account) public view override returns (uint256) {
564         return _balances[account];
565     }
566 
567     /**
568      * @dev See {IERC20-transfer}.
569      *
570      * Requirements:
571      *
572      * - `recipient` cannot be the zero address.
573      * - the caller must have a balance of at least `amount`.
574      */
575     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
576         _transfer(_msgSender(), recipient, amount);
577         return true;
578     }
579 
580     /**
581      * @dev See {IERC20-allowance}.
582      */
583     function allowance(address owner, address spender) public view virtual override returns (uint256) {
584         return _allowances[owner][spender];
585     }
586 
587     /**
588      * @dev See {IERC20-approve}.
589      *
590      * Requirements:
591      *
592      * - `spender` cannot be the zero address.
593      */
594     function approve(address spender, uint256 amount) public virtual override returns (bool) {
595         _approve(_msgSender(), spender, amount);
596         return true;
597     }
598 
599     /**
600      * @dev See {IERC20-transferFrom}.
601      *
602      * Emits an {Approval} event indicating the updated allowance. This is not
603      * required by the EIP. See the note at the beginning of {ERC20};
604      *
605      * Requirements:
606      * - `sender` and `recipient` cannot be the zero address.
607      * - `sender` must have a balance of at least `amount`.
608      * - the caller must have allowance for ``sender``'s tokens of at least
609      * `amount`.
610      */
611     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
612         _transfer(sender, recipient, amount);
613         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
614         return true;
615     }
616 
617     /**
618      * @dev Atomically increases the allowance granted to `spender` by the caller.
619      *
620      * This is an alternative to {approve} that can be used as a mitigation for
621      * problems described in {IERC20-approve}.
622      *
623      * Emits an {Approval} event indicating the updated allowance.
624      *
625      * Requirements:
626      *
627      * - `spender` cannot be the zero address.
628      */
629     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
630         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
631         return true;
632     }
633 
634     /**
635      * @dev Atomically decreases the allowance granted to `spender` by the caller.
636      *
637      * This is an alternative to {approve} that can be used as a mitigation for
638      * problems described in {IERC20-approve}.
639      *
640      * Emits an {Approval} event indicating the updated allowance.
641      *
642      * Requirements:
643      *
644      * - `spender` cannot be the zero address.
645      * - `spender` must have allowance for the caller of at least
646      * `subtractedValue`.
647      */
648     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
649         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
650         return true;
651     }
652 
653     /**
654      * @dev Moves tokens `amount` from `sender` to `recipient`.
655      *
656      * This is internal function is equivalent to {transfer}, and can be used to
657      * e.g. implement automatic token fees, slashing mechanisms, etc.
658      *
659      * Emits a {Transfer} event.
660      *
661      * Requirements:
662      *
663      * - `sender` cannot be the zero address.
664      * - `recipient` cannot be the zero address.
665      * - `sender` must have a balance of at least `amount`.
666      */
667     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
668         require(sender != address(0), "ERC20: transfer from the zero address");
669         require(recipient != address(0), "ERC20: transfer to the zero address");
670 
671         _beforeTokenTransfer(sender, recipient, amount);
672 
673         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
674         _balances[recipient] = _balances[recipient].add(amount);
675         emit Transfer(sender, recipient, amount);
676     }
677 
678     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
679      * the total supply.
680      *
681      * Emits a {Transfer} event with `from` set to the zero address.
682      *
683      * Requirements
684      *
685      * - `to` cannot be the zero address.
686      */
687     function _mint(address account, uint256 amount) internal virtual {
688         require(account != address(0), "ERC20: mint to the zero address");
689 
690         _beforeTokenTransfer(address(0), account, amount);
691 
692         _totalSupply = _totalSupply.add(amount);
693         _balances[account] = _balances[account].add(amount);
694         emit Transfer(address(0), account, amount);
695     }
696 
697     /**
698      * @dev Destroys `amount` tokens from `account`, reducing the
699      * total supply.
700      *
701      * Emits a {Transfer} event with `to` set to the zero address.
702      *
703      * Requirements
704      *
705      * - `account` cannot be the zero address.
706      * - `account` must have at least `amount` tokens.
707      */
708     function _burn(address account, uint256 amount) internal virtual {
709         require(account != address(0), "ERC20: burn from the zero address");
710 
711         _beforeTokenTransfer(account, address(0), amount);
712 
713         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
714         _totalSupply = _totalSupply.sub(amount);
715         emit Transfer(account, address(0), amount);
716     }
717 
718     /**
719      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
720      *
721      * This is internal function is equivalent to `approve`, and can be used to
722      * e.g. set automatic allowances for certain subsystems, etc.
723      *
724      * Emits an {Approval} event.
725      *
726      * Requirements:
727      *
728      * - `owner` cannot be the zero address.
729      * - `spender` cannot be the zero address.
730      */
731     function _approve(address owner, address spender, uint256 amount) internal virtual {
732         require(owner != address(0), "ERC20: approve from the zero address");
733         require(spender != address(0), "ERC20: approve to the zero address");
734 
735         _allowances[owner][spender] = amount;
736         emit Approval(owner, spender, amount);
737     }
738 
739     /**
740      * @dev Sets {decimals} to a value other than the default one of 18.
741      *
742      * WARNING: This function should only be called from the constructor. Most
743      * applications that interact with token contracts will not expect
744      * {decimals} to ever change, and may work incorrectly if it does.
745      */
746     function _setupDecimals(uint8 decimals_) internal {
747         _decimals = decimals_;
748     }
749 
750     /**
751      * @dev Hook that is called before any transfer of tokens. This includes
752      * minting and burning.
753      *
754      * Calling conditions:
755      *
756      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
757      * will be to transferred to `to`.
758      * - when `from` is zero, `amount` tokens will be minted for `to`.
759      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
760      * - `from` and `to` are never both zero.
761      *
762      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
763      */
764     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
765 }
766 
767 
768 contract ERC20DecimalsMock is ERC20 {
769     constructor (string memory name, string memory symbol, uint8 decimals) public ERC20(name, symbol) {
770         _setupDecimals(decimals);
771     }
772 }
773 
774 
775 
776 
777 /**
778  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
779  */
780 abstract contract ERC20Capped is ERC20 {
781     uint256 private _cap;
782 
783     /**
784      * @dev Sets the value of the `cap`. This value is immutable, it can only be
785      * set once during construction.
786      */
787     constructor (uint256 cap) public {
788         require(cap > 0, "ERC20Capped: cap is 0");
789         _cap = cap;
790     }
791 
792     /**
793      * @dev Returns the cap on the token's total supply.
794      */
795     function cap() public view returns (uint256) {
796         return _cap;
797     }
798 
799     /**
800      * @dev See {ERC20-_beforeTokenTransfer}.
801      *
802      * Requirements:
803      *
804      * - minted tokens must not cause the total supply to go over the cap.
805      */
806     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
807         super._beforeTokenTransfer(from, to, amount);
808 
809         if (from == address(0)) { // When minting tokens
810             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
811         }
812     }
813 }
814 
815 
816 contract Token is ERC20Capped(1e26), ERC20DecimalsMock("Bloomzed Loyalty Club Ticket", "BLCT", 18), Ownable {
817     IERC20 public bzt_token = IERC20(0x0D5516103752b3954D95621f470A8261151Da2e4);
818 
819     mapping(address => bool) public whitelist;
820     mapping(address => uint256) public users_exchanges;
821     mapping(address => uint256) public users_limits;
822 
823     function _beforeTokenTransfer(address _from, address _to, uint256 _amount) internal override(ERC20Capped, ERC20) {
824         ERC20Capped._beforeTokenTransfer(_from, _to, _amount);
825     }
826 
827     function exchange(uint256 _amount) external {
828         require(whitelist[msg.sender], "Your address is blocked");
829         require(users_exchanges[msg.sender] + _amount <= users_limits[msg.sender], "Limit exchange");
830         require(bzt_token.transferFrom(msg.sender, owner(), _amount), "Trasfer not available");
831         
832         users_exchanges[msg.sender] += _amount;
833         
834         _mint(msg.sender, _amount);
835     }
836 
837     function mint(address _to, uint256 _amount) external onlyOwner {
838         _mint(_to, _amount);
839     }
840 
841     function addToWhiteList(address _to) external onlyOwner {
842         require(!whitelist[_to], "Address already in whitelist");
843 
844         whitelist[_to] = true;
845     }
846 
847     function addToWhiteList(address[] calldata _to, uint256[] calldata _limits) external onlyOwner {
848         for(uint256 i = 0; i < _to.length; i++) {
849             whitelist[_to[i]] = true;
850             users_limits[_to[i]] = _limits[i];
851         }
852     }
853 
854     function removeFromWhiteList(address _to) external onlyOwner {
855         require(whitelist[_to], "Address not in whitelist");
856 
857         whitelist[_to] = false;
858     }
859 
860     function viewLimits(address user) public view returns (uint256) {
861         return users_limits[user];
862     }
863    
864     
865 }