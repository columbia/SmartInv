1 pragma solidity ^0.8.0;
2 
3 // Part: ICitizen - Needed to interface with the final citizen contract
4 
5 interface ICitizen {
6 	function getRewardRate(address _user) external view returns(uint256);
7 
8     function getRewardsRateForTokenId(uint256) external view returns(uint256);
9 
10     function getCurrentOrFinalTime() external view returns(uint256);
11 
12     function reduceRewards(uint256, address) external;
13 
14     function increaseRewards(uint256, address) external;
15 
16     function getEnd() external returns(uint256);
17 }
18 
19 interface IIdentity {
20     function ownerOf(uint256 tokenId) external view returns (address owner);
21 }
22 
23 interface IVaultBox {
24 	function getCredits(uint256 tokenId) external view returns (string memory);
25     function ownerOf(uint256 tokenId) external view returns (address owner);
26 }
27 
28 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Address
29 
30 /**
31  * @dev Collection of functions related to the address type
32  */
33 library Address {
34     /**
35      * @dev Returns true if `account` is a contract.
36      *
37      * [IMPORTANT]
38      * ====
39      * It is unsafe to assume that an address for which this function returns
40      * false is an externally-owned account (EOA) and not a contract.
41      *
42      * Among others, `isContract` will return false for the following
43      * types of addresses:
44      *
45      *  - an externally-owned account
46      *  - a contract in construction
47      *  - an address where a contract will be created
48      *  - an address where a contract lived, but was destroyed
49      * ====
50      */
51     function isContract(address account) internal view returns (bool) {
52         // This method relies in extcodesize, which returns 0 for contracts in
53         // construction, since the code is only stored at the end of the
54         // constructor execution.
55 
56         uint256 size;
57         // solhint-disable-next-line no-inline-assembly
58         assembly { size := extcodesize(account) }
59         return size > 0;
60     }
61 
62     /**
63      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
64      * `recipient`, forwarding all available gas and reverting on errors.
65      *
66      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
67      * of certain opcodes, possibly making contracts go over the 2300 gas limit
68      * imposed by `transfer`, making them unable to receive funds via
69      * `transfer`. {sendValue} removes this limitation.
70      *
71      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
72      *
73      * IMPORTANT: because control is transferred to `recipient`, care must be
74      * taken to not create reentrancy vulnerabilities. Consider using
75      * {ReentrancyGuard} or the
76      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
77      */
78     function sendValue(address payable recipient, uint256 amount) internal {
79         require(address(this).balance >= amount, "Address: insufficient balance");
80 
81         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
82         (bool success, ) = recipient.call{ value: amount }("");
83         require(success, "Address: unable to send value, recipient may have reverted");
84     }
85 
86     /**
87      * @dev Performs a Solidity function call using a low level `call`. A
88      * plain`call` is an unsafe replacement for a function call: use this
89      * function instead.
90      *
91      * If `target` reverts with a revert reason, it is bubbled up by this
92      * function (like regular Solidity function calls).
93      *
94      * Returns the raw returned data. To convert to the expected return value,
95      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
96      *
97      * Requirements:
98      *
99      * - `target` must be a contract.
100      * - calling `target` with `data` must not revert.
101      *
102      * _Available since v3.1._
103      */
104     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
105       return functionCall(target, data, "Address: low-level call failed");
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
110      * `errorMessage` as a fallback revert reason when `target` reverts.
111      *
112      * _Available since v3.1._
113      */
114     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
115         return _functionCallWithValue(target, data, 0, errorMessage);
116     }
117 
118     /**
119      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
120      * but also transferring `value` wei to `target`.
121      *
122      * Requirements:
123      *
124      * - the calling contract must have an ETH balance of at least `value`.
125      * - the called Solidity function must be `payable`.
126      *
127      * _Available since v3.1._
128      */
129     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
130         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
131     }
132 
133     /**
134      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
135      * with `errorMessage` as a fallback revert reason when `target` reverts.
136      *
137      * _Available since v3.1._
138      */
139     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
140         require(address(this).balance >= value, "Address: insufficient balance for call");
141         return _functionCallWithValue(target, data, value, errorMessage);
142     }
143 
144     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
145         require(isContract(target), "Address: call to non-contract");
146 
147         // solhint-disable-next-line avoid-low-level-calls
148         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
149         if (success) {
150             return returndata;
151         } else {
152             // Look for revert reason and bubble it up if present
153             if (returndata.length > 0) {
154                 // The easiest way to bubble the revert reason is using memory via assembly
155 
156                 // solhint-disable-next-line no-inline-assembly
157                 assembly {
158                     let returndata_size := mload(returndata)
159                     revert(add(32, returndata), returndata_size)
160                 }
161             } else {
162                 revert(errorMessage);
163             }
164         }
165     }
166 }
167 
168 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Context
169 
170 /*
171  * @dev Provides information about the current execution context, including the
172  * sender of the transaction and its data. While these are generally available
173  * via msg.sender and msg.data, they should not be accessed in such a direct
174  * manner, since when dealing with GSN meta-transactions the account sending and
175  * paying for execution may not be the actual sender (as far as an application
176  * is concerned).
177  *
178  * This contract is only required for intermediate, library-like contracts.
179  */
180 abstract contract Context {
181     function _msgSender() internal view virtual returns (address payable) {
182         return payable(msg.sender);
183     }
184 
185     function _msgData() internal view virtual returns (bytes memory) {
186         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
187         return msg.data;
188     }
189 }
190 
191 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC20
192 
193 /**
194  * @dev Interface of the ERC20 standard as defined in the EIP.
195  */
196 interface IERC20 {
197     /**
198      * @dev Returns the amount of tokens in existence.
199      */
200     function totalSupply() external view returns (uint256);
201 
202     /**
203      * @dev Returns the amount of tokens owned by `account`.
204      */
205     function balanceOf(address account) external view returns (uint256);
206 
207     /**
208      * @dev Moves `amount` tokens from the caller's account to `recipient`.
209      *
210      * Returns a boolean value indicating whether the operation succeeded.
211      *
212      * Emits a {Transfer} event.
213      */
214     function transfer(address recipient, uint256 amount) external returns (bool);
215 
216     /**
217      * @dev Returns the remaining number of tokens that `spender` will be
218      * allowed to spend on behalf of `owner` through {transferFrom}. This is
219      * zero by default.
220      *
221      * This value changes when {approve} or {transferFrom} are called.
222      */
223     function allowance(address owner, address spender) external view returns (uint256);
224 
225     /**
226      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
227      *
228      * Returns a boolean value indicating whether the operation succeeded.
229      *
230      * IMPORTANT: Beware that changing an allowance with this method brings the risk
231      * that someone may use both the old and the new allowance by unfortunate
232      * transaction ordering. One possible solution to mitigate this race
233      * condition is to first reduce the spender's allowance to 0 and set the
234      * desired value afterwards:
235      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
236      *
237      * Emits an {Approval} event.
238      */
239     function approve(address spender, uint256 amount) external returns (bool);
240 
241     /**
242      * @dev Moves `amount` tokens from `sender` to `recipient` using the
243      * allowance mechanism. `amount` is then deducted from the caller's
244      * allowance.
245      *
246      * Returns a boolean value indicating whether the operation succeeded.
247      *
248      * Emits a {Transfer} event.
249      */
250     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
251 
252     /**
253      * @dev Emitted when `value` tokens are moved from one account (`from`) to
254      * another (`to`).
255      *
256      * Note that `value` may be zero.
257      */
258     event Transfer(address indexed from, address indexed to, uint256 value);
259 
260     /**
261      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
262      * a call to {approve}. `value` is the new allowance.
263      */
264     event Approval(address indexed owner, address indexed spender, uint256 value);
265 }
266 
267 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/SafeMath
268 
269 /**
270  * @dev Wrappers over Solidity's arithmetic operations with added overflow
271  * checks.
272  *
273  * Arithmetic operations in Solidity wrap on overflow. This can easily result
274  * in bugs, because programmers usually assume that an overflow raises an
275  * error, which is the standard behavior in high level programming languages.
276  * `SafeMath` restores this intuition by reverting the transaction when an
277  * operation overflows.
278  *
279  * Using this library instead of the unchecked operations eliminates an entire
280  * class of bugs, so it's recommended to use it always.
281  */
282 library SafeMath {
283     /**
284      * @dev Returns the addition of two unsigned integers, reverting on
285      * overflow.
286      *
287      * Counterpart to Solidity's `+` operator.
288      *
289      * Requirements:
290      *
291      * - Addition cannot overflow.
292      */
293     function add(uint256 a, uint256 b) internal pure returns (uint256) {
294         uint256 c = a + b;
295         require(c >= a, "SafeMath: addition overflow");
296 
297         return c;
298     }
299 
300     /**
301      * @dev Returns the subtraction of two unsigned integers, reverting on
302      * overflow (when the result is negative).
303      *
304      * Counterpart to Solidity's `-` operator.
305      *
306      * Requirements:
307      *
308      * - Subtraction cannot overflow.
309      */
310     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
311         return sub(a, b, "SafeMath: subtraction overflow");
312     }
313 
314     /**
315      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
316      * overflow (when the result is negative).
317      *
318      * Counterpart to Solidity's `-` operator.
319      *
320      * Requirements:
321      *
322      * - Subtraction cannot overflow.
323      */
324     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
325         require(b <= a, errorMessage);
326         uint256 c = a - b;
327 
328         return c;
329     }
330 
331     /**
332      * @dev Returns the multiplication of two unsigned integers, reverting on
333      * overflow.
334      *
335      * Counterpart to Solidity's `*` operator.
336      *
337      * Requirements:
338      *
339      * - Multiplication cannot overflow.
340      */
341     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
342         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
343         // benefit is lost if 'b' is also tested.
344         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
345         if (a == 0) {
346             return 0;
347         }
348 
349         uint256 c = a * b;
350         require(c / a == b, "SafeMath: multiplication overflow");
351 
352         return c;
353     }
354 
355     /**
356      * @dev Returns the integer division of two unsigned integers. Reverts on
357      * division by zero. The result is rounded towards zero.
358      *
359      * Counterpart to Solidity's `/` operator. Note: this function uses a
360      * `revert` opcode (which leaves remaining gas untouched) while Solidity
361      * uses an invalid opcode to revert (consuming all remaining gas).
362      *
363      * Requirements:
364      *
365      * - The divisor cannot be zero.
366      */
367     function div(uint256 a, uint256 b) internal pure returns (uint256) {
368         return div(a, b, "SafeMath: division by zero");
369     }
370 
371     /**
372      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
373      * division by zero. The result is rounded towards zero.
374      *
375      * Counterpart to Solidity's `/` operator. Note: this function uses a
376      * `revert` opcode (which leaves remaining gas untouched) while Solidity
377      * uses an invalid opcode to revert (consuming all remaining gas).
378      *
379      * Requirements:
380      *
381      * - The divisor cannot be zero.
382      */
383     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
384         require(b > 0, errorMessage);
385         uint256 c = a / b;
386         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
387 
388         return c;
389     }
390 
391     /**
392      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
393      * Reverts when dividing by zero.
394      *
395      * Counterpart to Solidity's `%` operator. This function uses a `revert`
396      * opcode (which leaves remaining gas untouched) while Solidity uses an
397      * invalid opcode to revert (consuming all remaining gas).
398      *
399      * Requirements:
400      *
401      * - The divisor cannot be zero.
402      */
403     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
404         return mod(a, b, "SafeMath: modulo by zero");
405     }
406 
407     /**
408      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
409      * Reverts with custom message when dividing by zero.
410      *
411      * Counterpart to Solidity's `%` operator. This function uses a `revert`
412      * opcode (which leaves remaining gas untouched) while Solidity uses an
413      * invalid opcode to revert (consuming all remaining gas).
414      *
415      * Requirements:
416      *
417      * - The divisor cannot be zero.
418      */
419     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
420         require(b != 0, errorMessage);
421         return a % b;
422     }
423 }
424 
425 /**
426  * @dev Contract module which provides a basic access control mechanism, where
427  * there is an account (an owner) that can be granted exclusive access to
428  * specific functions.
429  *
430  * By default, the owner account will be the one that deploys the contract. This
431  * can later be changed with {transferOwnership}.
432  *
433  * This module is used through inheritance. It will make available the modifier
434  * `onlyOwner`, which can be applied to your functions to restrict their use to
435  * the owner.
436  */
437 abstract contract Ownable is Context {
438     address private _owner;
439 
440     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
441 
442     /**
443      * @dev Initializes the contract setting the deployer as the initial owner.
444      */
445     constructor() {
446         _setOwner(_msgSender());
447     }
448 
449     /**
450      * @dev Returns the address of the current owner.
451      */
452     function owner() public view virtual returns (address) {
453         return _owner;
454     }
455 
456     /**
457      * @dev Throws if called by any account other than the owner.
458      */
459     modifier onlyOwner() {
460         require(owner() == _msgSender(), "Ownable: caller is not the owner");
461         _;
462     }
463 
464     /**
465      * @dev Leaves the contract without owner. It will not be possible to call
466      * `onlyOwner` functions anymore. Can only be called by the current owner.
467      *
468      * NOTE: Renouncing ownership will leave the contract without an owner,
469      * thereby removing any functionality that is only available to the owner.
470      */
471     function renounceOwnership() public virtual onlyOwner {
472         _setOwner(address(0));
473     }
474 
475     /**
476      * @dev Transfers ownership of the contract to a new account (`newOwner`).
477      * Can only be called by the current owner.
478      */
479     function transferOwnership(address newOwner) public virtual onlyOwner {
480         require(newOwner != address(0), "Ownable: new owner is the zero address");
481         _setOwner(newOwner);
482     }
483 
484     function _setOwner(address newOwner) private {
485         address oldOwner = _owner;
486         _owner = newOwner;
487         emit OwnershipTransferred(oldOwner, newOwner);
488     }
489 }
490 
491 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/ERC20
492 
493 /**
494  * @dev Implementation of the {IERC20} interface.
495  *
496  * This implementation is agnostic to the way tokens are created. This means
497  * that a supply mechanism has to be added in a derived contract using {_mint}.
498  * For a generic mechanism see {ERC20PresetMinterPauser}.
499  *
500  * TIP: For a detailed writeup see our guide
501  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
502  * to implement supply mechanisms].
503  *
504  * We have followed general OpenZeppelin guidelines: functions revert instead
505  * of returning `false` on failure. This behavior is nonetheless conventional
506  * and does not conflict with the expectations of ERC20 applications.
507  *
508  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
509  * This allows applications to reconstruct the allowance for all accounts just
510  * by listening to said events. Other implementations of the EIP may not emit
511  * these events, as it isn't required by the specification.
512  *
513  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
514  * functions have been added to mitigate the well-known issues around setting
515  * allowances. See {IERC20-approve}.
516  */
517 contract ERC20 is Context, IERC20 {
518     using SafeMath for uint256;
519     using Address for address;
520 
521     mapping (address => uint256) private _balances;
522 
523     mapping (address => mapping (address => uint256)) private _allowances;
524 
525     uint256 private _totalSupply;
526 
527     string private _name;
528     string private _symbol;
529     uint8 private _decimals;
530 
531     /**
532      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
533      * a default value of 18.
534      *
535      * To select a different value for {decimals}, use {_setupDecimals}.
536      *
537      * All three of these values are immutable: they can only be set once during
538      * construction.
539      */
540     constructor (string memory name, string memory symbol) public {
541         _name = name;
542         _symbol = symbol;
543         _decimals = 18;
544     }
545 
546     /**
547      * @dev Returns the name of the token.
548      */
549     function name() public view returns (string memory) {
550         return _name;
551     }
552 
553     /**
554      * @dev Returns the symbol of the token, usually a shorter version of the
555      * name.
556      */
557     function symbol() public view returns (string memory) {
558         return _symbol;
559     }
560 
561     /**
562      * @dev Returns the number of decimals used to get its user representation.
563      * For example, if `decimals` equals `2`, a balance of `505` tokens should
564      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
565      *
566      * Tokens usually opt for a value of 18, imitating the relationship between
567      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
568      * called.
569      *
570      * NOTE: This information is only used for _display_ purposes: it in
571      * no way affects any of the arithmetic of the contract, including
572      * {IERC20-balanceOf} and {IERC20-transfer}.
573      */
574     function decimals() public view returns (uint8) {
575         return _decimals;
576     }
577 
578     /**
579      * @dev See {IERC20-totalSupply}.
580      */
581     function totalSupply() public view override returns (uint256) {
582         return _totalSupply;
583     }
584 
585     /**
586      * @dev See {IERC20-balanceOf}.
587      */
588     function balanceOf(address account) public view override returns (uint256) {
589         return _balances[account];
590     }
591 
592     /**
593      * @dev See {IERC20-transfer}.
594      *
595      * Requirements:
596      *
597      * - `recipient` cannot be the zero address.
598      * - the caller must have a balance of at least `amount`.
599      */
600     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
601         _transfer(_msgSender(), recipient, amount);
602         return true;
603     }
604 
605     /**
606      * @dev See {IERC20-allowance}.
607      */
608     function allowance(address owner, address spender) public view virtual override returns (uint256) {
609         return _allowances[owner][spender];
610     }
611 
612     /**
613      * @dev See {IERC20-approve}.
614      *
615      * Requirements:
616      *
617      * - `spender` cannot be the zero address.
618      */
619     function approve(address spender, uint256 amount) public virtual override returns (bool) {
620         _approve(_msgSender(), spender, amount);
621         return true;
622     }
623 
624     /**
625      * @dev See {IERC20-transferFrom}.
626      *
627      * Emits an {Approval} event indicating the updated allowance. This is not
628      * required by the EIP. See the note at the beginning of {ERC20};
629      *
630      * Requirements:
631      * - `sender` and `recipient` cannot be the zero address.
632      * - `sender` must have a balance of at least `amount`.
633      * - the caller must have allowance for ``sender``'s tokens of at least
634      * `amount`.
635      */
636     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
637         _transfer(sender, recipient, amount);
638         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
639         return true;
640     }
641 
642     /**
643      * @dev Atomically increases the allowance granted to `spender` by the caller.
644      *
645      * This is an alternative to {approve} that can be used as a mitigation for
646      * problems described in {IERC20-approve}.
647      *
648      * Emits an {Approval} event indicating the updated allowance.
649      *
650      * Requirements:
651      *
652      * - `spender` cannot be the zero address.
653      */
654     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
655         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
656         return true;
657     }
658 
659     /**
660      * @dev Atomically decreases the allowance granted to `spender` by the caller.
661      *
662      * This is an alternative to {approve} that can be used as a mitigation for
663      * problems described in {IERC20-approve}.
664      *
665      * Emits an {Approval} event indicating the updated allowance.
666      *
667      * Requirements:
668      *
669      * - `spender` cannot be the zero address.
670      * - `spender` must have allowance for the caller of at least
671      * `subtractedValue`.
672      */
673     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
674         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
675         return true;
676     }
677 
678     /**
679      * @dev Moves tokens `amount` from `sender` to `recipient`.
680      *
681      * This is internal function is equivalent to {transfer}, and can be used to
682      * e.g. implement automatic token fees, slashing mechanisms, etc.
683      *
684      * Emits a {Transfer} event.
685      *
686      * Requirements:
687      *
688      * - `sender` cannot be the zero address.
689      * - `recipient` cannot be the zero address.
690      * - `sender` must have a balance of at least `amount`.
691      */
692     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
693         require(sender != address(0), "ERC20: transfer from the zero address");
694         require(recipient != address(0), "ERC20: transfer to the zero address");
695 
696         _beforeTokenTransfer(sender, recipient, amount);
697 
698         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
699         _balances[recipient] = _balances[recipient].add(amount);
700         emit Transfer(sender, recipient, amount);
701     }
702 
703     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
704      * the total supply.
705      *
706      * Emits a {Transfer} event with `from` set to the zero address.
707      *
708      * Requirements
709      *
710      * - `to` cannot be the zero address.
711      */
712     function _mint(address account, uint256 amount) internal virtual {
713         require(account != address(0), "ERC20: mint to the zero address");
714 
715         _beforeTokenTransfer(address(0), account, amount);
716 
717         _totalSupply = _totalSupply.add(amount);
718         _balances[account] = _balances[account].add(amount);
719         emit Transfer(address(0), account, amount);
720     }
721 
722     /**
723      * @dev Destroys `amount` tokens from `account`, reducing the
724      * total supply.
725      *
726      * Emits a {Transfer} event with `to` set to the zero address.
727      *
728      * Requirements
729      *
730      * - `account` cannot be the zero address.
731      * - `account` must have at least `amount` tokens.
732      */
733     function _burn(address account, uint256 amount) internal virtual {
734         require(account != address(0), "ERC20: burn from the zero address");
735 
736         _beforeTokenTransfer(account, address(0), amount);
737 
738         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
739         _totalSupply = _totalSupply.sub(amount);
740         emit Transfer(account, address(0), amount);
741     }
742 
743     /**
744      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
745      *
746      * This internal function is equivalent to `approve`, and can be used to
747      * e.g. set automatic allowances for certain subsystems, etc.
748      *
749      * Emits an {Approval} event.
750      *
751      * Requirements:
752      *
753      * - `owner` cannot be the zero address.
754      * - `spender` cannot be the zero address.
755      */
756     function _approve(address owner, address spender, uint256 amount) internal virtual {
757         require(owner != address(0), "ERC20: approve from the zero address");
758         require(spender != address(0), "ERC20: approve to the zero address");
759 
760         _allowances[owner][spender] = amount;
761         emit Approval(owner, spender, amount);
762     }
763 
764     /**
765      * @dev Sets {decimals} to a value other than the default one of 18.
766      *
767      * WARNING: This function should only be called from the constructor. Most
768      * applications that interact with token contracts will not expect
769      * {decimals} to ever change, and may work incorrectly if it does.
770      */
771     function _setupDecimals(uint8 decimals_) internal {
772         _decimals = decimals_;
773     }
774 
775     /**
776      * @dev Hook that is called before any transfer of tokens. This includes
777      * minting and burning.
778      *
779      * Calling conditions:
780      *
781      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
782      * will be to transferred to `to`.
783      * - when `from` is zero, `amount` tokens will be minted for `to`.
784      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
785      * - `from` and `to` are never both zero.
786      *
787      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
788      */
789     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
790 }
791 
792 // File: BYTESContract.sol
793 
794 contract BYTESContract is Ownable, ERC20("BYTES", "BYTES") {
795 	using SafeMath for uint256;
796 
797     uint256 maxRewardableCitizens;
798 
799 	mapping(address => uint256) public rewards;
800 	mapping(address => uint256) public lastUpdate;
801     mapping(address => bool) public adminContracts;
802 
803     mapping(uint256 => uint256) public identityBoxOpened;
804     mapping(uint256 => uint256) public vaultBoxOpenedByIdentity;
805 
806 	ICitizen public citizenContract;
807     IIdentity public identityContract;
808     IIdentity public boughtIdentityContract;
809     IVaultBox public vaultBoxContract;
810 
811 	event RewardPaid(address indexed user, uint256 reward);
812 
813 	constructor() {
814         identityContract = IIdentity(0x86357A19E5537A8Fba9A004E555713BC943a66C0);
815         vaultBoxContract = IVaultBox(0xab0b0dD7e4EaB0F9e31a539074a03f1C1Be80879);
816         maxRewardableCitizens = 2501;
817 	}
818 
819     function openVaultBox(uint256 identityTokenId, uint256 vaultBoxTokenId) public 
820     {
821         require(identityBoxOpened[identityTokenId] == 0, "That identity has already opened a box");
822         require(vaultBoxOpenedByIdentity[vaultBoxTokenId] == 0, "That box has already been opened");
823         require(validateIdentity(identityTokenId), "You don't own that identity");
824         require(vaultBoxContract.ownerOf(vaultBoxTokenId) == msg.sender, "You don't own that vault box");
825 
826         uint credits;
827         bool valueReturned; 
828         (credits, valueReturned) = strToUint(vaultBoxContract.getCredits(vaultBoxTokenId));
829 
830         uint payout = credits * 10 ** 18;
831 
832         if(valueReturned)
833         {
834             _mint(msg.sender, payout);
835             identityBoxOpened[identityTokenId] = vaultBoxTokenId;
836             vaultBoxOpenedByIdentity[vaultBoxTokenId] = identityTokenId;
837         }
838     }
839 
840     function hasVaultBoxBeenOpened(uint256 tokenId) public view returns(bool)
841     {
842         if(vaultBoxOpenedByIdentity[tokenId] == 0)
843         {
844             return false;
845         }
846 
847         return true;
848     }
849 
850     function hasIdentityOpenedABox(uint256 tokenId) public view returns(bool)
851     {
852         if(identityBoxOpened[tokenId] == 0)
853         {
854             return false;
855         }
856 
857         return true;
858     }
859 
860     function updateMaxRewardableTokens(uint256 _amount) public onlyOwner
861     {
862         maxRewardableCitizens = _amount;
863     }
864 
865     function addAdminContractAddress(address _address) public onlyOwner
866     {
867         adminContracts[_address] = true;
868     }
869 
870     function removeAdminContactAddress(address _address) public onlyOwner
871     {
872         adminContracts[_address] = false;
873     }
874 
875     function validateIdentity(uint256 tokenId) internal view returns(bool)
876     {
877         if(tokenId < 2300)
878         {
879             if(identityContract.ownerOf(tokenId) == msg.sender)
880             {
881                 return true;
882             }
883         }
884         else
885         {
886             if(boughtIdentityContract.ownerOf(tokenId) == msg.sender)
887             {
888                 return true;
889             }
890         }
891 
892         return false;
893 
894     }
895 
896     function setIdentityContract(address _address) public onlyOwner {
897         identityContract = IIdentity(_address);
898     }
899 
900     function setBoughtIdentityContract(address _address) public onlyOwner {
901         boughtIdentityContract = IIdentity(_address);
902     }
903 
904     function setVaultBoxContract(address _address) public onlyOwner {
905         vaultBoxContract = IVaultBox(_address);
906     }
907 
908     function setCitizenContract(address _address) public onlyOwner {
909         adminContracts[_address] = true;
910         citizenContract = ICitizen(_address);
911     }
912 
913 	// called when a new citizen is minted
914 	function updateRewardOnMint(address _user, uint256 tokenId) external {
915 		require(msg.sender == address(citizenContract), "Can't call this");
916 		uint256 time;
917 		uint256 timerUser = lastUpdate[_user];
918 
919         time = citizenContract.getCurrentOrFinalTime();
920 
921 
922 		if (timerUser > 0)
923         {
924             rewards[_user] = rewards[_user].add(citizenContract.getRewardRate(_user).mul((time.sub(timerUser))).div(86400));
925         }
926 
927         uint256 rateDelta = citizenContract.getRewardsRateForTokenId(tokenId);
928 
929         citizenContract.increaseRewards(rateDelta, _user);
930 
931 		lastUpdate[_user] = time;
932 	}
933 
934 	// called on transfers or right before a getReward to properly update rewards
935 	function updateReward(address _from, address _to, uint256 _tokenId) external {
936 		require(msg.sender == address(citizenContract));
937 		if (_tokenId < maxRewardableCitizens) {
938 			uint256 time;
939 			uint256 timerFrom = lastUpdate[_from];
940 
941             uint256 END = citizenContract.getEnd();
942 
943             time = citizenContract.getCurrentOrFinalTime();
944 
945             uint256 rateDelta = citizenContract.getRewardsRateForTokenId(_tokenId);
946 
947 			if (timerFrom > 0)
948             {
949                 rewards[_from] += citizenContract.getRewardRate(_from).mul((time.sub(timerFrom))).div(86400);
950             }
951 			if (timerFrom != END)
952             {
953 				lastUpdate[_from] = time;
954             }
955 			if (_to != address(0)) {
956 				uint256 timerTo = lastUpdate[_to];
957 				if (timerTo > 0)
958                 {
959                     rewards[_to] += citizenContract.getRewardRate(_to).mul((time.sub(timerTo))).div(86400);
960                 }
961 				if (timerTo != END)
962                 {
963 					lastUpdate[_to] = time;
964                 }
965 			}
966 
967             citizenContract.reduceRewards(rateDelta, _from);
968             citizenContract.increaseRewards(rateDelta, _to);
969 		}
970 	}
971 
972 	function getReward(address _to) external {
973 		require(msg.sender == address(citizenContract));
974 		uint256 reward = rewards[_to];
975 		if (reward > 0) {
976 			rewards[_to] = 0;
977 			_mint(_to, reward * 10 ** 18);
978 			emit RewardPaid(_to, reward);
979 		}
980 	}
981 
982 	function burn(address _from, uint256 _amount) external {
983 		require(adminContracts[msg.sender], "You are not approved to burn tokens");
984 		_burn(_from, _amount);
985 	}
986 
987 	function getTotalClaimable(address _user) external view returns(uint256) {
988 		
989         uint256 time = citizenContract.getCurrentOrFinalTime();
990 
991         uint256 pending = citizenContract.getRewardRate(_user).mul((time.sub(lastUpdate[_user]))).div(86400);
992 		return rewards[_user] + pending;
993 	}
994 
995     function strToUint(string memory _str) public pure returns(uint256 res, bool err) {
996     for (uint256 i = 0; i < bytes(_str).length; i++) {
997         if ((uint8(bytes(_str)[i]) - 48) < 0 || (uint8(bytes(_str)[i]) - 48) > 9) {
998             return (0, false);
999         }
1000         res += (uint8(bytes(_str)[i]) - 48) * 10**(bytes(_str).length - i - 1);
1001     }
1002     
1003     return (res, true);
1004 }
1005 }