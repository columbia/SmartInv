1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 
4 pragma solidity ^0.6.0;
5 
6 /**
7  * @dev Wrappers over Solidity's arithmetic operations with added overflow
8  * checks.
9  *
10  * Arithmetic operations in Solidity wrap on overflow. This can easily result
11  * in bugs, because programmers usually assume that an overflow raises an
12  * error, which is the standard behavior in high level programming languages.
13  * `SafeMath` restores this intuition by reverting the transaction when an
14  * operation overflows.
15  *
16  * Using this library instead of the unchecked operations eliminates an entire
17  * class of bugs, so it's recommended to use it always.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, reverting on
22      * overflow.
23      *
24      * Counterpart to Solidity's `+` operator.
25      *
26      * Requirements:
27      *
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      *
45      * - Subtraction cannot overflow.
46      */
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     /**
52      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
53      * overflow (when the result is negative).
54      *
55      * Counterpart to Solidity's `-` operator.
56      *
57      * Requirements:
58      *
59      * - Subtraction cannot overflow.
60      */
61     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b <= a, errorMessage);
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     /**
69      * @dev Returns the multiplication of two unsigned integers, reverting on
70      * overflow.
71      *
72      * Counterpart to Solidity's `*` operator.
73      *
74      * Requirements:
75      *
76      * - Multiplication cannot overflow.
77      */
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80         // benefit is lost if 'b' is also tested.
81         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b, "SafeMath: multiplication overflow");
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the integer division of two unsigned integers. Reverts on
94      * division by zero. The result is rounded towards zero.
95      *
96      * Counterpart to Solidity's `/` operator. Note: this function uses a
97      * `revert` opcode (which leaves remaining gas untouched) while Solidity
98      * uses an invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      *
102      * - The divisor cannot be zero.
103      */
104     function div(uint256 a, uint256 b) internal pure returns (uint256) {
105         return div(a, b, "SafeMath: division by zero");
106     }
107 
108     /**
109      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
110      * division by zero. The result is rounded towards zero.
111      *
112      * Counterpart to Solidity's `/` operator. Note: this function uses a
113      * `revert` opcode (which leaves remaining gas untouched) while Solidity
114      * uses an invalid opcode to revert (consuming all remaining gas).
115      *
116      * Requirements:
117      *
118      * - The divisor cannot be zero.
119      */
120     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
121         require(b > 0, errorMessage);
122         uint256 c = a / b;
123         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
130      * Reverts when dividing by zero.
131      *
132      * Counterpart to Solidity's `%` operator. This function uses a `revert`
133      * opcode (which leaves remaining gas untouched) while Solidity uses an
134      * invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141         return mod(a, b, "SafeMath: modulo by zero");
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * Reverts with custom message when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b != 0, errorMessage);
158         return a % b;
159     }
160 }
161 
162 // File: @openzeppelin/contracts/GSN/Context.sol
163 
164 
165 pragma solidity ^0.6.0;
166 
167 /*
168  * @dev Provides information about the current execution context, including the
169  * sender of the transaction and its data. While these are generally available
170  * via msg.sender and msg.data, they should not be accessed in such a direct
171  * manner, since when dealing with GSN meta-transactions the account sending and
172  * paying for execution may not be the actual sender (as far as an application
173  * is concerned).
174  *
175  * This contract is only required for intermediate, library-like contracts.
176  */
177 abstract contract Context {
178     function _msgSender() internal view virtual returns (address payable) {
179         return msg.sender;
180     }
181 
182     function _msgData() internal view virtual returns (bytes memory) {
183         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
184         return msg.data;
185     }
186 }
187 
188 // File: @openzeppelin/contracts/access/Ownable.sol
189 
190 
191 pragma solidity ^0.6.0;
192 
193 /**
194  * @dev Contract module which provides a basic access control mechanism, where
195  * there is an account (an owner) that can be granted exclusive access to
196  * specific functions.
197  *
198  * By default, the owner account will be the one that deploys the contract. This
199  * can later be changed with {transferOwnership}.
200  *
201  * This module is used through inheritance. It will make available the modifier
202  * `onlyOwner`, which can be applied to your functions to restrict their use to
203  * the owner.
204  */
205 contract Ownable is Context {
206     address private _owner;
207 
208     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
209 
210     /**
211      * @dev Initializes the contract setting the deployer as the initial owner.
212      */
213     constructor () internal {
214         address msgSender = _msgSender();
215         _owner = msgSender;
216         emit OwnershipTransferred(address(0), msgSender);
217     }
218 
219     /**
220      * @dev Returns the address of the current owner.
221      */
222     function owner() public view returns (address) {
223         return _owner;
224     }
225 
226     /**
227      * @dev Throws if called by any account other than the owner.
228      */
229     modifier onlyOwner() {
230         require(_owner == _msgSender(), "Ownable: caller is not the owner");
231         _;
232     }
233 
234     /**
235      * @dev Leaves the contract without owner. It will not be possible to call
236      * `onlyOwner` functions anymore. Can only be called by the current owner.
237      *
238      * NOTE: Renouncing ownership will leave the contract without an owner,
239      * thereby removing any functionality that is only available to the owner.
240      */
241     function renounceOwnership() public virtual onlyOwner {
242         emit OwnershipTransferred(_owner, address(0));
243         _owner = address(0);
244     }
245 
246     /**
247      * @dev Transfers ownership of the contract to a new account (`newOwner`).
248      * Can only be called by the current owner.
249      */
250     function transferOwnership(address newOwner) public virtual onlyOwner {
251         require(newOwner != address(0), "Ownable: new owner is the zero address");
252         emit OwnershipTransferred(_owner, newOwner);
253         _owner = newOwner;
254     }
255 }
256 
257 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
258 
259 
260 pragma solidity ^0.6.0;
261 
262 /**
263  * @dev Interface of the ERC20 standard as defined in the EIP.
264  */
265 interface IERC20 {
266     /**
267      * @dev Returns the amount of tokens in existence.
268      */
269     function totalSupply() external view returns (uint256);
270 
271     /**
272      * @dev Returns the amount of tokens owned by `account`.
273      */
274     function balanceOf(address account) external view returns (uint256);
275 
276     /**
277      * @dev Moves `amount` tokens from the caller's account to `recipient`.
278      *
279      * Returns a boolean value indicating whether the operation succeeded.
280      *
281      * Emits a {Transfer} event.
282      */
283     function transfer(address recipient, uint256 amount) external returns (bool);
284 
285     /**
286      * @dev Returns the remaining number of tokens that `spender` will be
287      * allowed to spend on behalf of `owner` through {transferFrom}. This is
288      * zero by default.
289      *
290      * This value changes when {approve} or {transferFrom} are called.
291      */
292     function allowance(address owner, address spender) external view returns (uint256);
293 
294     /**
295      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
296      *
297      * Returns a boolean value indicating whether the operation succeeded.
298      *
299      * IMPORTANT: Beware that changing an allowance with this method brings the risk
300      * that someone may use both the old and the new allowance by unfortunate
301      * transaction ordering. One possible solution to mitigate this race
302      * condition is to first reduce the spender's allowance to 0 and set the
303      * desired value afterwards:
304      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
305      *
306      * Emits an {Approval} event.
307      */
308     function approve(address spender, uint256 amount) external returns (bool);
309 
310     /**
311      * @dev Moves `amount` tokens from `sender` to `recipient` using the
312      * allowance mechanism. `amount` is then deducted from the caller's
313      * allowance.
314      *
315      * Returns a boolean value indicating whether the operation succeeded.
316      *
317      * Emits a {Transfer} event.
318      */
319     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
320 
321     /**
322      * @dev Emitted when `value` tokens are moved from one account (`from`) to
323      * another (`to`).
324      *
325      * Note that `value` may be zero.
326      */
327     event Transfer(address indexed from, address indexed to, uint256 value);
328 
329     /**
330      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
331      * a call to {approve}. `value` is the new allowance.
332      */
333     event Approval(address indexed owner, address indexed spender, uint256 value);
334 }
335 
336 // File: @openzeppelin/contracts/utils/Address.sol
337 
338 
339 pragma solidity ^0.6.2;
340 
341 /**
342  * @dev Collection of functions related to the address type
343  */
344 library Address {
345     /**
346      * @dev Returns true if `account` is a contract.
347      *
348      * [IMPORTANT]
349      * ====
350      * It is unsafe to assume that an address for which this function returns
351      * false is an externally-owned account (EOA) and not a contract.
352      *
353      * Among others, `isContract` will return false for the following
354      * types of addresses:
355      *
356      *  - an externally-owned account
357      *  - a contract in construction
358      *  - an address where a contract will be created
359      *  - an address where a contract lived, but was destroyed
360      * ====
361      */
362     function isContract(address account) internal view returns (bool) {
363         // This method relies in extcodesize, which returns 0 for contracts in
364         // construction, since the code is only stored at the end of the
365         // constructor execution.
366 
367         uint256 size;
368         // solhint-disable-next-line no-inline-assembly
369         assembly { size := extcodesize(account) }
370         return size > 0;
371     }
372 
373     /**
374      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
375      * `recipient`, forwarding all available gas and reverting on errors.
376      *
377      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
378      * of certain opcodes, possibly making contracts go over the 2300 gas limit
379      * imposed by `transfer`, making them unable to receive funds via
380      * `transfer`. {sendValue} removes this limitation.
381      *
382      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
383      *
384      * IMPORTANT: because control is transferred to `recipient`, care must be
385      * taken to not create reentrancy vulnerabilities. Consider using
386      * {ReentrancyGuard} or the
387      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
388      */
389     function sendValue(address payable recipient, uint256 amount) internal {
390         require(address(this).balance >= amount, "Address: insufficient balance");
391 
392         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
393         (bool success, ) = recipient.call{ value: amount }("");
394         require(success, "Address: unable to send value, recipient may have reverted");
395     }
396 
397     /**
398      * @dev Performs a Solidity function call using a low level `call`. A
399      * plain`call` is an unsafe replacement for a function call: use this
400      * function instead.
401      *
402      * If `target` reverts with a revert reason, it is bubbled up by this
403      * function (like regular Solidity function calls).
404      *
405      * Returns the raw returned data. To convert to the expected return value,
406      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
407      *
408      * Requirements:
409      *
410      * - `target` must be a contract.
411      * - calling `target` with `data` must not revert.
412      *
413      * _Available since v3.1._
414      */
415     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
416       return functionCall(target, data, "Address: low-level call failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
421      * `errorMessage` as a fallback revert reason when `target` reverts.
422      *
423      * _Available since v3.1._
424      */
425     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
426         return _functionCallWithValue(target, data, 0, errorMessage);
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
431      * but also transferring `value` wei to `target`.
432      *
433      * Requirements:
434      *
435      * - the calling contract must have an ETH balance of at least `value`.
436      * - the called Solidity function must be `payable`.
437      *
438      * _Available since v3.1._
439      */
440     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
441         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
446      * with `errorMessage` as a fallback revert reason when `target` reverts.
447      *
448      * _Available since v3.1._
449      */
450     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
451         require(address(this).balance >= value, "Address: insufficient balance for call");
452         return _functionCallWithValue(target, data, value, errorMessage);
453     }
454 
455     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
456         require(isContract(target), "Address: call to non-contract");
457 
458         // solhint-disable-next-line avoid-low-level-calls
459         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
460         if (success) {
461             return returndata;
462         } else {
463             // Look for revert reason and bubble it up if present
464             if (returndata.length > 0) {
465                 // The easiest way to bubble the revert reason is using memory via assembly
466 
467                 // solhint-disable-next-line no-inline-assembly
468                 assembly {
469                     let returndata_size := mload(returndata)
470                     revert(add(32, returndata), returndata_size)
471                 }
472             } else {
473                 revert(errorMessage);
474             }
475         }
476     }
477 }
478 
479 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
480 
481 
482 pragma solidity ^0.6.0;
483 
484 
485 
486 
487 
488 /**
489  * @dev Implementation of the {IERC20} interface.
490  *
491  * This implementation is agnostic to the way tokens are created. This means
492  * that a supply mechanism has to be added in a derived contract using {_mint}.
493  * For a generic mechanism see {ERC20PresetMinterPauser}.
494  *
495  * TIP: For a detailed writeup see our guide
496  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
497  * to implement supply mechanisms].
498  *
499  * We have followed general OpenZeppelin guidelines: functions revert instead
500  * of returning `false` on failure. This behavior is nonetheless conventional
501  * and does not conflict with the expectations of ERC20 applications.
502  *
503  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
504  * This allows applications to reconstruct the allowance for all accounts just
505  * by listening to said events. Other implementations of the EIP may not emit
506  * these events, as it isn't required by the specification.
507  *
508  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
509  * functions have been added to mitigate the well-known issues around setting
510  * allowances. See {IERC20-approve}.
511  */
512 contract ERC20 is Context, IERC20 {
513     using SafeMath for uint256;
514     using Address for address;
515 
516     mapping (address => uint256) private _balances;
517 
518     mapping (address => mapping (address => uint256)) private _allowances;
519 
520     uint256 private _totalSupply;
521 
522     string private _name;
523     string private _symbol;
524     uint8 private _decimals;
525 
526     /**
527      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
528      * a default value of 18.
529      *
530      * To select a different value for {decimals}, use {_setupDecimals}.
531      *
532      * All three of these values are immutable: they can only be set once during
533      * construction.
534      */
535     constructor (string memory name, string memory symbol) public {
536         _name = name;
537         _symbol = symbol;
538         _decimals = 18;
539     }
540 
541     /**
542      * @dev Returns the name of the token.
543      */
544     function name() public view returns (string memory) {
545         return _name;
546     }
547 
548     /**
549      * @dev Returns the symbol of the token, usually a shorter version of the
550      * name.
551      */
552     function symbol() public view returns (string memory) {
553         return _symbol;
554     }
555 
556     /**
557      * @dev Returns the number of decimals used to get its user representation.
558      * For example, if `decimals` equals `2`, a balance of `505` tokens should
559      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
560      *
561      * Tokens usually opt for a value of 18, imitating the relationship between
562      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
563      * called.
564      *
565      * NOTE: This information is only used for _display_ purposes: it in
566      * no way affects any of the arithmetic of the contract, including
567      * {IERC20-balanceOf} and {IERC20-transfer}.
568      */
569     function decimals() public view returns (uint8) {
570         return _decimals;
571     }
572 
573     /**
574      * @dev See {IERC20-totalSupply}.
575      */
576     function totalSupply() public view override returns (uint256) {
577         return _totalSupply;
578     }
579 
580     /**
581      * @dev See {IERC20-balanceOf}.
582      */
583     function balanceOf(address account) public view override returns (uint256) {
584         return _balances[account];
585     }
586 
587     /**
588      * @dev See {IERC20-transfer}.
589      *
590      * Requirements:
591      *
592      * - `recipient` cannot be the zero address.
593      * - the caller must have a balance of at least `amount`.
594      */
595     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
596         _transfer(_msgSender(), recipient, amount);
597         return true;
598     }
599 
600     /**
601      * @dev See {IERC20-allowance}.
602      */
603     function allowance(address owner, address spender) public view virtual override returns (uint256) {
604         return _allowances[owner][spender];
605     }
606 
607     /**
608      * @dev See {IERC20-approve}.
609      *
610      * Requirements:
611      *
612      * - `spender` cannot be the zero address.
613      */
614     function approve(address spender, uint256 amount) public virtual override returns (bool) {
615         _approve(_msgSender(), spender, amount);
616         return true;
617     }
618 
619     /**
620      * @dev See {IERC20-transferFrom}.
621      *
622      * Emits an {Approval} event indicating the updated allowance. This is not
623      * required by the EIP. See the note at the beginning of {ERC20};
624      *
625      * Requirements:
626      * - `sender` and `recipient` cannot be the zero address.
627      * - `sender` must have a balance of at least `amount`.
628      * - the caller must have allowance for ``sender``'s tokens of at least
629      * `amount`.
630      */
631     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
632         _transfer(sender, recipient, amount);
633         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
634         return true;
635     }
636 
637     /**
638      * @dev Atomically increases the allowance granted to `spender` by the caller.
639      *
640      * This is an alternative to {approve} that can be used as a mitigation for
641      * problems described in {IERC20-approve}.
642      *
643      * Emits an {Approval} event indicating the updated allowance.
644      *
645      * Requirements:
646      *
647      * - `spender` cannot be the zero address.
648      */
649     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
650         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
651         return true;
652     }
653 
654     /**
655      * @dev Atomically decreases the allowance granted to `spender` by the caller.
656      *
657      * This is an alternative to {approve} that can be used as a mitigation for
658      * problems described in {IERC20-approve}.
659      *
660      * Emits an {Approval} event indicating the updated allowance.
661      *
662      * Requirements:
663      *
664      * - `spender` cannot be the zero address.
665      * - `spender` must have allowance for the caller of at least
666      * `subtractedValue`.
667      */
668     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
669         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
670         return true;
671     }
672 
673     /**
674      * @dev Moves tokens `amount` from `sender` to `recipient`.
675      *
676      * This is internal function is equivalent to {transfer}, and can be used to
677      * e.g. implement automatic token fees, slashing mechanisms, etc.
678      *
679      * Emits a {Transfer} event.
680      *
681      * Requirements:
682      *
683      * - `sender` cannot be the zero address.
684      * - `recipient` cannot be the zero address.
685      * - `sender` must have a balance of at least `amount`.
686      */
687     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
688         require(sender != address(0), "ERC20: transfer from the zero address");
689         require(recipient != address(0), "ERC20: transfer to the zero address");
690 
691         _beforeTokenTransfer(sender, recipient, amount);
692 
693         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
694         _balances[recipient] = _balances[recipient].add(amount);
695         emit Transfer(sender, recipient, amount);
696     }
697 
698     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
699      * the total supply.
700      *
701      * Emits a {Transfer} event with `from` set to the zero address.
702      *
703      * Requirements
704      *
705      * - `to` cannot be the zero address.
706      */
707     function _mint(address account, uint256 amount) internal virtual {
708         require(account != address(0), "ERC20: mint to the zero address");
709 
710         _beforeTokenTransfer(address(0), account, amount);
711 
712         _totalSupply = _totalSupply.add(amount);
713         _balances[account] = _balances[account].add(amount);
714         emit Transfer(address(0), account, amount);
715     }
716 
717     /**
718      * @dev Destroys `amount` tokens from `account`, reducing the
719      * total supply.
720      *
721      * Emits a {Transfer} event with `to` set to the zero address.
722      *
723      * Requirements
724      *
725      * - `account` cannot be the zero address.
726      * - `account` must have at least `amount` tokens.
727      */
728     function _burn(address account, uint256 amount) internal virtual {
729         require(account != address(0), "ERC20: burn from the zero address");
730 
731         _beforeTokenTransfer(account, address(0), amount);
732 
733         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
734         _totalSupply = _totalSupply.sub(amount);
735         emit Transfer(account, address(0), amount);
736     }
737 
738     /**
739      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
740      *
741      * This internal function is equivalent to `approve`, and can be used to
742      * e.g. set automatic allowances for certain subsystems, etc.
743      *
744      * Emits an {Approval} event.
745      *
746      * Requirements:
747      *
748      * - `owner` cannot be the zero address.
749      * - `spender` cannot be the zero address.
750      */
751     function _approve(address owner, address spender, uint256 amount) internal virtual {
752         require(owner != address(0), "ERC20: approve from the zero address");
753         require(spender != address(0), "ERC20: approve to the zero address");
754 
755         _allowances[owner][spender] = amount;
756         emit Approval(owner, spender, amount);
757     }
758 
759     /**
760      * @dev Sets {decimals} to a value other than the default one of 18.
761      *
762      * WARNING: This function should only be called from the constructor. Most
763      * applications that interact with token contracts will not expect
764      * {decimals} to ever change, and may work incorrectly if it does.
765      */
766     function _setupDecimals(uint8 decimals_) internal {
767         _decimals = decimals_;
768     }
769 
770     /**
771      * @dev Hook that is called before any transfer of tokens. This includes
772      * minting and burning.
773      *
774      * Calling conditions:
775      *
776      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
777      * will be to transferred to `to`.
778      * - when `from` is zero, `amount` tokens will be minted for `to`.
779      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
780      * - `from` and `to` are never both zero.
781      *
782      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
783      */
784     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
785 }
786 
787 // File: contracts/DipperCoin.sol
788 
789 pragma solidity ^0.6.2;
790 
791 
792 
793 
794 contract Dipper is ERC20, Ownable {
795     using SafeMath for uint256;
796 
797     constructor() ERC20("Dipper", "DIPP") public {
798         _mint(0x7335e64591fA8EEC7BDE44CA72F47063D0d854F6, 10000000e18);
799     }
800 
801     function increaseOwnerAllowance(uint256 amount) public onlyOwner {
802         _mint(owner(), amount);
803     }
804 
805     function decreaseOwnerAllowance(uint256 amount) public onlyOwner {
806         _burn(owner(), amount);
807     }
808 }