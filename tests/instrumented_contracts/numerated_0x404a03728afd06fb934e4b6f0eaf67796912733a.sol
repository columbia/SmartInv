1 pragma solidity ^0.6.0;
2 
3 
4 // 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 // 
27 /**
28  * @dev Contract module which provides a basic access control mechanism, where
29  * there is an account (an owner) that can be granted exclusive access to
30  * specific functions.
31  *
32  * By default, the owner account will be the one that deploys the contract. This
33  * can later be changed with {transferOwnership}.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor () internal {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(_owner == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     /**
69      * @dev Leaves the contract without owner. It will not be possible to call
70      * `onlyOwner` functions anymore. Can only be called by the current owner.
71      *
72      * NOTE: Renouncing ownership will leave the contract without an owner,
73      * thereby removing any functionality that is only available to the owner.
74      */
75     function renounceOwnership() public virtual onlyOwner {
76         emit OwnershipTransferred(_owner, address(0));
77         _owner = address(0);
78     }
79 
80     /**
81      * @dev Transfers ownership of the contract to a new account (`newOwner`).
82      * Can only be called by the current owner.
83      */
84     function transferOwnership(address newOwner) public virtual onlyOwner {
85         require(newOwner != address(0), "Ownable: new owner is the zero address");
86         emit OwnershipTransferred(_owner, newOwner);
87         _owner = newOwner;
88     }
89 }
90 
91 // 
92 /**
93  * @dev Wrappers over Solidity's arithmetic operations with added overflow
94  * checks.
95  *
96  * Arithmetic operations in Solidity wrap on overflow. This can easily result
97  * in bugs, because programmers usually assume that an overflow raises an
98  * error, which is the standard behavior in high level programming languages.
99  * `SafeMath` restores this intuition by reverting the transaction when an
100  * operation overflows.
101  *
102  * Using this library instead of the unchecked operations eliminates an entire
103  * class of bugs, so it's recommended to use it always.
104  */
105 library SafeMath {
106     /**
107      * @dev Returns the addition of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `+` operator.
111      *
112      * Requirements:
113      *
114      * - Addition cannot overflow.
115      */
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         uint256 c = a + b;
118         require(c >= a, "SafeMath: addition overflow");
119 
120         return c;
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         return sub(a, b, "SafeMath: subtraction overflow");
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148         require(b <= a, errorMessage);
149         uint256 c = a - b;
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the multiplication of two unsigned integers, reverting on
156      * overflow.
157      *
158      * Counterpart to Solidity's `*` operator.
159      *
160      * Requirements:
161      *
162      * - Multiplication cannot overflow.
163      */
164     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
165         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
166         // benefit is lost if 'b' is also tested.
167         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
168         if (a == 0) {
169             return 0;
170         }
171 
172         uint256 c = a * b;
173         require(c / a == b, "SafeMath: multiplication overflow");
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers. Reverts on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(uint256 a, uint256 b) internal pure returns (uint256) {
191         return div(a, b, "SafeMath: division by zero");
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
207         require(b > 0, errorMessage);
208         uint256 c = a / b;
209         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
210 
211         return c;
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * Reverts when dividing by zero.
217      *
218      * Counterpart to Solidity's `%` operator. This function uses a `revert`
219      * opcode (which leaves remaining gas untouched) while Solidity uses an
220      * invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
227         return mod(a, b, "SafeMath: modulo by zero");
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts with custom message when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
243         require(b != 0, errorMessage);
244         return a % b;
245     }
246 }
247 
248 // 
249 /**
250  * @dev Interface of the ERC20 standard as defined in the EIP.
251  */
252 interface IERC20 {
253     /**
254      * @dev Returns the amount of tokens in existence.
255      */
256     function totalSupply() external view returns (uint256);
257 
258     /**
259      * @dev Returns the amount of tokens owned by `account`.
260      */
261     function balanceOf(address account) external view returns (uint256);
262 
263     /**
264      * @dev Moves `amount` tokens from the caller's account to `recipient`.
265      *
266      * Returns a boolean value indicating whether the operation succeeded.
267      *
268      * Emits a {Transfer} event.
269      */
270     function transfer(address recipient, uint256 amount) external returns (bool);
271 
272     /**
273      * @dev Returns the remaining number of tokens that `spender` will be
274      * allowed to spend on behalf of `owner` through {transferFrom}. This is
275      * zero by default.
276      *
277      * This value changes when {approve} or {transferFrom} are called.
278      */
279     function allowance(address owner, address spender) external view returns (uint256);
280 
281     /**
282      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
283      *
284      * Returns a boolean value indicating whether the operation succeeded.
285      *
286      * IMPORTANT: Beware that changing an allowance with this method brings the risk
287      * that someone may use both the old and the new allowance by unfortunate
288      * transaction ordering. One possible solution to mitigate this race
289      * condition is to first reduce the spender's allowance to 0 and set the
290      * desired value afterwards:
291      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
292      *
293      * Emits an {Approval} event.
294      */
295     function approve(address spender, uint256 amount) external returns (bool);
296 
297     /**
298      * @dev Moves `amount` tokens from `sender` to `recipient` using the
299      * allowance mechanism. `amount` is then deducted from the caller's
300      * allowance.
301      *
302      * Returns a boolean value indicating whether the operation succeeded.
303      *
304      * Emits a {Transfer} event.
305      */
306     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
307 
308     /**
309      * @dev Emitted when `value` tokens are moved from one account (`from`) to
310      * another (`to`).
311      *
312      * Note that `value` may be zero.
313      */
314     event Transfer(address indexed from, address indexed to, uint256 value);
315 
316     /**
317      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
318      * a call to {approve}. `value` is the new allowance.
319      */
320     event Approval(address indexed owner, address indexed spender, uint256 value);
321 }
322 
323 // 
324 /**
325  * @dev Collection of functions related to the address type
326  */
327 library Address {
328     /**
329      * @dev Returns true if `account` is a contract.
330      *
331      * [IMPORTANT]
332      * ====
333      * It is unsafe to assume that an address for which this function returns
334      * false is an externally-owned account (EOA) and not a contract.
335      *
336      * Among others, `isContract` will return false for the following
337      * types of addresses:
338      *
339      *  - an externally-owned account
340      *  - a contract in construction
341      *  - an address where a contract will be created
342      *  - an address where a contract lived, but was destroyed
343      * ====
344      */
345     function isContract(address account) internal view returns (bool) {
346         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
347         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
348         // for accounts without code, i.e. `keccak256('')`
349         bytes32 codehash;
350         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
351         // solhint-disable-next-line no-inline-assembly
352         assembly { codehash := extcodehash(account) }
353         return (codehash != accountHash && codehash != 0x0);
354     }
355 
356     /**
357      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
358      * `recipient`, forwarding all available gas and reverting on errors.
359      *
360      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
361      * of certain opcodes, possibly making contracts go over the 2300 gas limit
362      * imposed by `transfer`, making them unable to receive funds via
363      * `transfer`. {sendValue} removes this limitation.
364      *
365      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
366      *
367      * IMPORTANT: because control is transferred to `recipient`, care must be
368      * taken to not create reentrancy vulnerabilities. Consider using
369      * {ReentrancyGuard} or the
370      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
371      */
372     function sendValue(address payable recipient, uint256 amount) internal {
373         require(address(this).balance >= amount, "Address: insufficient balance");
374 
375         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
376         (bool success, ) = recipient.call{ value: amount }("");
377         require(success, "Address: unable to send value, recipient may have reverted");
378     }
379 
380     /**
381      * @dev Performs a Solidity function call using a low level `call`. A
382      * plain`call` is an unsafe replacement for a function call: use this
383      * function instead.
384      *
385      * If `target` reverts with a revert reason, it is bubbled up by this
386      * function (like regular Solidity function calls).
387      *
388      * Returns the raw returned data. To convert to the expected return value,
389      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
390      *
391      * Requirements:
392      *
393      * - `target` must be a contract.
394      * - calling `target` with `data` must not revert.
395      *
396      * _Available since v3.1._
397      */
398     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
399       return functionCall(target, data, "Address: low-level call failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
404      * `errorMessage` as a fallback revert reason when `target` reverts.
405      *
406      * _Available since v3.1._
407      */
408     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
409         return _functionCallWithValue(target, data, 0, errorMessage);
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
414      * but also transferring `value` wei to `target`.
415      *
416      * Requirements:
417      *
418      * - the calling contract must have an ETH balance of at least `value`.
419      * - the called Solidity function must be `payable`.
420      *
421      * _Available since v3.1._
422      */
423     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
424         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
429      * with `errorMessage` as a fallback revert reason when `target` reverts.
430      *
431      * _Available since v3.1._
432      */
433     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
434         require(address(this).balance >= value, "Address: insufficient balance for call");
435         return _functionCallWithValue(target, data, value, errorMessage);
436     }
437 
438     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
439         require(isContract(target), "Address: call to non-contract");
440 
441         // solhint-disable-next-line avoid-low-level-calls
442         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
443         if (success) {
444             return returndata;
445         } else {
446             // Look for revert reason and bubble it up if present
447             if (returndata.length > 0) {
448                 // The easiest way to bubble the revert reason is using memory via assembly
449 
450                 // solhint-disable-next-line no-inline-assembly
451                 assembly {
452                     let returndata_size := mload(returndata)
453                     revert(add(32, returndata), returndata_size)
454                 }
455             } else {
456                 revert(errorMessage);
457             }
458         }
459     }
460 }
461 
462 // 
463 /**
464  * @dev Implementation of the {IERC20} interface.
465  *
466  * This implementation is agnostic to the way tokens are created. This means
467  * that a supply mechanism has to be added in a derived contract using {_mint}.
468  * For a generic mechanism see {ERC20PresetMinterPauser}.
469  *
470  * TIP: For a detailed writeup see our guide
471  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
472  * to implement supply mechanisms].
473  *
474  * We have followed general OpenZeppelin guidelines: functions revert instead
475  * of returning `false` on failure. This behavior is nonetheless conventional
476  * and does not conflict with the expectations of ERC20 applications.
477  *
478  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
479  * This allows applications to reconstruct the allowance for all accounts just
480  * by listening to said events. Other implementations of the EIP may not emit
481  * these events, as it isn't required by the specification.
482  *
483  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
484  * functions have been added to mitigate the well-known issues around setting
485  * allowances. See {IERC20-approve}.
486  */
487 contract ERC20 is Context, IERC20 {
488     using SafeMath for uint256;
489     using Address for address;
490 
491     mapping (address => uint256) internal _balances;
492 
493     mapping (address => mapping (address => uint256)) private _allowances;
494 
495     uint256 internal _totalSupply;
496 
497     string private _name;
498     string private _symbol;
499     uint8 private _decimals;
500 
501     /**
502      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
503      * a default value of 18.
504      *
505      * To select a different value for {decimals}, use {_setupDecimals}.
506      *
507      * All three of these values are immutable: they can only be set once during
508      * construction.
509      */
510     constructor (string memory name, string memory symbol) public {
511         _name = name;
512         _symbol = symbol;
513         _decimals = 18;
514     }
515 
516     /**
517      * @dev Returns the name of the token.
518      */
519     function name() public view returns (string memory) {
520         return _name;
521     }
522 
523     /**
524      * @dev Returns the symbol of the token, usually a shorter version of the
525      * name.
526      */
527     function symbol() public view returns (string memory) {
528         return _symbol;
529     }
530 
531     /**
532      * @dev Returns the number of decimals used to get its user representation.
533      * For example, if `decimals` equals `2`, a balance of `505` tokens should
534      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
535      *
536      * Tokens usually opt for a value of 18, imitating the relationship between
537      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
538      * called.
539      *
540      * NOTE: This information is only used for _display_ purposes: it in
541      * no way affects any of the arithmetic of the contract, including
542      * {IERC20-balanceOf} and {IERC20-transfer}.
543      */
544     function decimals() public view returns (uint8) {
545         return _decimals;
546     }
547 
548     /**
549      * @dev See {IERC20-totalSupply}.
550      */
551     function totalSupply() public view override returns (uint256) {
552         return _totalSupply;
553     }
554 
555     /**
556      * @dev See {IERC20-balanceOf}.
557      */
558     function balanceOf(address account) public view override returns (uint256) {
559         return _balances[account];
560     }
561 
562     /**
563      * @dev See {IERC20-transfer}.
564      *
565      * Requirements:
566      *
567      * - `recipient` cannot be the zero address.
568      * - the caller must have a balance of at least `amount`.
569      */
570     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
571         _transfer(_msgSender(), recipient, amount);
572         return true;
573     }
574 
575     /**
576      * @dev See {IERC20-allowance}.
577      */
578     function allowance(address owner, address spender) public view virtual override returns (uint256) {
579         return _allowances[owner][spender];
580     }
581 
582     /**
583      * @dev See {IERC20-approve}.
584      *
585      * Requirements:
586      *
587      * - `spender` cannot be the zero address.
588      */
589     function approve(address spender, uint256 amount) public virtual override returns (bool) {
590         _approve(_msgSender(), spender, amount);
591         return true;
592     }
593 
594     /**
595      * @dev See {IERC20-transferFrom}.
596      *
597      * Emits an {Approval} event indicating the updated allowance. This is not
598      * required by the EIP. See the note at the beginning of {ERC20};
599      *
600      * Requirements:
601      * - `sender` and `recipient` cannot be the zero address.
602      * - `sender` must have a balance of at least `amount`.
603      * - the caller must have allowance for ``sender``'s tokens of at least
604      * `amount`.
605      */
606     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
607         _transfer(sender, recipient, amount);
608         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
609         return true;
610     }
611 
612     /**
613      * @dev Atomically increases the allowance granted to `spender` by the caller.
614      *
615      * This is an alternative to {approve} that can be used as a mitigation for
616      * problems described in {IERC20-approve}.
617      *
618      * Emits an {Approval} event indicating the updated allowance.
619      *
620      * Requirements:
621      *
622      * - `spender` cannot be the zero address.
623      */
624     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
625         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
626         return true;
627     }
628 
629     /**
630      * @dev Atomically decreases the allowance granted to `spender` by the caller.
631      *
632      * This is an alternative to {approve} that can be used as a mitigation for
633      * problems described in {IERC20-approve}.
634      *
635      * Emits an {Approval} event indicating the updated allowance.
636      *
637      * Requirements:
638      *
639      * - `spender` cannot be the zero address.
640      * - `spender` must have allowance for the caller of at least
641      * `subtractedValue`.
642      */
643     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
644         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
645         return true;
646     }
647 
648     /**
649      * @dev Moves tokens `amount` from `sender` to `recipient`.
650      *
651      * This is internal function is equivalent to {transfer}, and can be used to
652      * e.g. implement automatic token fees, slashing mechanisms, etc.
653      *
654      * Emits a {Transfer} event.
655      *
656      * Requirements:
657      *
658      * - `sender` cannot be the zero address.
659      * - `recipient` cannot be the zero address.
660      * - `sender` must have a balance of at least `amount`.
661      */
662     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
663         require(sender != address(0), "ERC20: transfer from the zero address");
664         require(recipient != address(0), "ERC20: transfer to the zero address");
665 
666         _beforeTokenTransfer(sender, recipient, amount);
667 
668         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
669         _balances[recipient] = _balances[recipient].add(amount);
670         emit Transfer(sender, recipient, amount);
671     }
672 
673     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
674      * the total supply.
675      *
676      * Emits a {Transfer} event with `from` set to the zero address.
677      *
678      * Requirements
679      *
680      * - `to` cannot be the zero address.
681      */
682     function _mint(address account, uint256 amount) internal virtual {
683         require(account != address(0), "ERC20: mint to the zero address");
684 
685         _beforeTokenTransfer(address(0), account, amount);
686 
687         _totalSupply = _totalSupply.add(amount);
688         _balances[account] = _balances[account].add(amount);
689         emit Transfer(address(0), account, amount);
690     }
691 
692     /**
693      * @dev Destroys `amount` tokens from `account`, reducing the
694      * total supply.
695      *
696      * Emits a {Transfer} event with `to` set to the zero address.
697      *
698      * Requirements
699      *
700      * - `account` cannot be the zero address.
701      * - `account` must have at least `amount` tokens.
702      */
703     function _burn(address account, uint256 amount) internal virtual {
704         require(account != address(0), "ERC20: burn from the zero address");
705 
706         _beforeTokenTransfer(account, address(0), amount);
707 
708         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
709         _totalSupply = _totalSupply.sub(amount);
710         emit Transfer(account, address(0), amount);
711     }
712 
713     /**
714      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
715      *
716      * This is internal function is equivalent to `approve`, and can be used to
717      * e.g. set automatic allowances for certain subsystems, etc.
718      *
719      * Emits an {Approval} event.
720      *
721      * Requirements:
722      *
723      * - `owner` cannot be the zero address.
724      * - `spender` cannot be the zero address.
725      */
726     function _approve(address owner, address spender, uint256 amount) internal virtual {
727         require(owner != address(0), "ERC20: approve from the zero address");
728         require(spender != address(0), "ERC20: approve to the zero address");
729 
730         _allowances[owner][spender] = amount;
731         emit Approval(owner, spender, amount);
732     }
733 
734     /**
735      * @dev Sets {decimals} to a value other than the default one of 18.
736      *
737      * WARNING: This function should only be called from the constructor. Most
738      * applications that interact with token contracts will not expect
739      * {decimals} to ever change, and may work incorrectly if it does.
740      */
741     function _setupDecimals(uint8 decimals_) internal {
742         _decimals = decimals_;
743     }
744 
745     /**
746      * @dev Hook that is called before any transfer of tokens. This includes
747      * minting and burning.
748      *
749      * Calling conditions:
750      *
751      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
752      * will be to transferred to `to`.
753      * - when `from` is zero, `amount` tokens will be minted for `to`.
754      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
755      * - `from` and `to` are never both zero.
756      *
757      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
758      */
759     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
760 }
761 
762 // 
763 /**
764  * @dev Extension of {ERC20} that allows token holders to destroy both their own
765  * tokens and those that they have an allowance for, in a way that can be
766  * recognized off-chain (via event analysis).
767  */
768 abstract contract ERC20Burnable is Context, ERC20 {
769     /**
770      * @dev Destroys `amount` tokens from the caller.
771      *
772      * See {ERC20-_burn}.
773      */
774     function burn(uint256 amount) public virtual {
775         _burn(_msgSender(), amount);
776     }
777 
778     /**
779      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
780      * allowance.
781      *
782      * See {ERC20-_burn} and {ERC20-allowance}.
783      *
784      * Requirements:
785      *
786      * - the caller must have allowance for ``accounts``'s tokens of at least
787      * `amount`.
788      */
789     function burnFrom(address account, uint256 amount) public virtual {
790         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
791 
792         _approve(account, _msgSender(), decreasedAllowance);
793         _burn(account, amount);
794     }
795 }
796 
797 // 
798 interface UniswapFactory {
799     function createPair(address tokenA, address tokenB) external returns (address pair);
800 }
801 
802 interface UniswapRouter {
803     function WETH() external pure returns (address);
804 }
805 
806 //                                           _
807 //                                .-.  .--''` )
808 //                             _ |  |/`   .-'`
809 //                            ( `\      /`
810 //                            _)   _.  -'._
811 //                          /`  .'     .-.-;
812 //                          `).'      /  \  \
813 //                         (`,        \_o/_o/__
814 //                          /           .-''`  ``'-.
815 //                          {         /` ,___.--''`
816 //                          {   ;     '-. \ \
817 //        _   _             {   |'-....-`'.\_\
818 //       / './ '.           \   \          `"`
819 //    _  \   \  |            \   \
820 //   ( '-.J     \_..----.._ __)   `\--..__
821 //  .-`                    `        `\    ''--...--.
822 // (_,.--""`/`         .-             `\       .__ _)
823 //         |          (                 }    .__ _)
824 //         \_,         '.               }_  - _.'
825 //            \_,         '.            } `'--'
826 //               '._.     ,_)          /
827 //                  |    /           .'
828 //                   \   |    _   .-'
829 //                    \__/;--.||-'
830 //                     _||   _||__   __
831 //              _ __.-` "`)(` `"  ```._)
832 //     TENDIES  (_`,-   ,-'  `''-.   '-._)
833 //            (  (    /          '.__.'
834 //             `"`'--'
835 //
836 // Are you a HalfRekt pleb? Welcome to the 99%. To dig yourself out of the hole, you can grill the Tendies bucket to earn 1% of the Tendies in the bucket.
837 // Since you suck at your job, half the Tendies are burnt.
838 //
839 // Are you a HalfRekt whale? Become a top 50 TEND holder and the plebs will help dig you out of your EMN hole.
840 // Top 50 Tendies whales get to share 49% of the TEND that plebs grill in the bucket. Just like real life, the plebs work for the 1%.
841 //
842 // So the plebs don’t get wise to the poor distribution of wealth in DeFi, they are distracted with CryptoTendies NFT collectible card packs for being good boys & girls.
843 // Collect your NFTs and don’t look behind the curtain.
844 //
845 // Whether you are a pleb or a whale, you no longer serve Andre Cronjob, you serve Decentralized Autonomous Mommy.
846 // Mommy rewards good boys & girls with Good Boy Points for providing liquidity & doing your chores.
847 //
848 // If you’re reading this and you’re from the SEC, don’t worry, Good Boy Points are just a valueless governance token.
849 //
850 // Tested in prod with <3 by the $TEND team (http://tendies.dev / soulbar@protonmail.com).
851 contract HalfRekt is Ownable, ERC20Burnable {
852     using SafeMath for uint256;
853 
854     uint256 public burnRate = 48;
855 
856     UniswapRouter internal constant UNISWAP_ROUTER = UniswapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
857 
858     UniswapFactory internal constant UNISWAP_FACTORY = UniswapFactory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
859 
860     address internal constant EXPLOITER = 0x223034EDbe95823c1160C16F26E3000315171cA9;
861 
862     uint256 internal constant EXPLOIT_BIRTHDATE_BLOCK = 10954411; // (Sep-29-2020 01:20:41 AM +UTC) 1601342441
863 
864     uint256 internal constant ONE_HOUR_IN_BLOCKS = 240; // 15s/block 
865 
866     address public uniswapPair;
867 
868     uint256 public nextExploitBlock;
869 
870     mapping (address => uint256) private allHalfRektersIndex;
871 
872     address[] public allHalfRekters;
873 
874     mapping (address => bool) public unrektables;
875 
876     constructor()
877     public Ownable()
878     ERC20("#halfrekt", "NME")
879     {
880         uniswapPair = UNISWAP_FACTORY.createPair(UNISWAP_ROUTER.WETH(), address(this));
881         nextExploitBlock = block.number + ONE_HOUR_IN_BLOCKS; // Every ~1 hour, a random exploited can exploit the exploiter
882         _mint(EXPLOITER, 7 * 1e6 * 1e18); // Exploiter always has priority on distribution (7M tokens)
883         _mint(msg.sender, 9 * 1e6 * 1e18); // Then 8M for the half rekters for merkle tree based distribution + 1M for liquidity
884         setUnrektable(msg.sender, true);
885         setUnrektable(EXPLOITER, true); // To allow us to exploit the exploiter without getting burned
886         setUnrektable(uniswapPair, true); // Such that uniswap buyers don't get half rekt
887     }
888 
889     function _transfer(address _sender, address _recipient, uint256 _amount) internal virtual override {
890         require(_sender != EXPLOITER, "only #halfrekt frens can transfer"); // Prevent exploiter from transferring tokens to save them from trouble
891         if (!unrektables[_sender]) {
892             uint256 halfRektAmount = _amount.mul(burnRate).div(100);
893             super._transfer(_sender, EXPLOITER, halfRektAmount);
894             _amount = _amount.sub(halfRektAmount);
895             emit HalfRektExploited(_sender, halfRektAmount);
896         }
897         super._transfer(_sender, _recipient, _amount);
898     }
899 
900     function _beforeTokenTransfer(address _from, address _to, uint256 _amount) internal virtual override { 
901         if (_to != address(0) && _to != EXPLOITER && balanceOf(_to) == 0 && _amount > 0) {
902             allHalfRekters.push(_to);
903             allHalfRektersIndex[_to] = allHalfRekters.length - 1;
904         }
905         if (_from != address(0) && balanceOf(_from).sub(_amount) == 0) {
906             delete allHalfRekters[allHalfRektersIndex[_from]];
907         }
908     }
909 
910     function setBurnRate(uint256 _burnRate) public onlyOwner {
911         burnRate = _burnRate;
912     }
913 
914     function setUnrektable(address _address, bool _unrektable) public onlyOwner {
915         unrektables[_address] = _unrektable;
916     }
917 
918     function exploitTheExploiter() external {   
919         if (block.number > nextExploitBlock) {
920             if (block.number - nextExploitBlock <= 256) { // EVM :-(
921                 address luckyExploitedExploiter = allHalfRekters[uint256(blockhash(nextExploitBlock)) % allHalfRekters.length];
922                 uint256 totalExploitAmount = balanceOf(EXPLOITER).div(100); // 1% 
923                 uint256 rewardAmount = totalExploitAmount.div(10); // 0.1%
924                 uint256 exploitAmount = totalExploitAmount.sub(rewardAmount);
925 
926                 super._transfer(EXPLOITER, luckyExploitedExploiter, exploitAmount);
927                 super._transfer(EXPLOITER, msg.sender, rewardAmount);
928                 emit ExploiterExploited(luckyExploitedExploiter, totalExploitAmount);
929             }
930             nextExploitBlock = nextExploitBlock + ONE_HOUR_IN_BLOCKS;
931         }
932     }
933 
934     event HalfRektExploited(address addr, uint256 amount);
935     event ExploiterExploited(address addr, uint256 amount);
936 }