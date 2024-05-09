1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
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
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19 
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 pragma solidity ^0.6.0;
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 pragma solidity ^0.6.0;
107 
108 /**
109  * @dev Wrappers over Solidity's arithmetic operations with added overflow
110  * checks.
111  *
112  * Arithmetic operations in Solidity wrap on overflow. This can easily result
113  * in bugs, because programmers usually assume that an overflow raises an
114  * error, which is the standard behavior in high level programming languages.
115  * `SafeMath` restores this intuition by reverting the transaction when an
116  * operation overflows.
117  *
118  * Using this library instead of the unchecked operations eliminates an entire
119  * class of bugs, so it's recommended to use it always.
120  */
121 library SafeMath {
122     /**
123      * @dev Returns the addition of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `+` operator.
127      *
128      * Requirements:
129      * - Addition cannot overflow.
130      */
131     function add(uint256 a, uint256 b) internal pure returns (uint256) {
132         uint256 c = a + b;
133         require(c >= a, "SafeMath: addition overflow");
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, reverting on
140      * overflow (when the result is negative).
141      *
142      * Counterpart to Solidity's `-` operator.
143      *
144      * Requirements:
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         return sub(a, b, "SafeMath: subtraction overflow");
149     }
150 
151     /**
152      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
153      * overflow (when the result is negative).
154      *
155      * Counterpart to Solidity's `-` operator.
156      *
157      * Requirements:
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b <= a, errorMessage);
162         uint256 c = a - b;
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `*` operator.
172      *
173      * Requirements:
174      * - Multiplication cannot overflow.
175      */
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178         // benefit is lost if 'b' is also tested.
179         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180         if (a == 0) {
181             return 0;
182         }
183 
184         uint256 c = a * b;
185         require(c / a == b, "SafeMath: multiplication overflow");
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b) internal pure returns (uint256) {
202         return div(a, b, "SafeMath: division by zero");
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
217         // Solidity only automatically asserts when dividing by 0
218         require(b > 0, errorMessage);
219         uint256 c = a / b;
220         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
237         return mod(a, b, "SafeMath: modulo by zero");
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts with custom message when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      * - The divisor cannot be zero.
250      */
251     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
252         require(b != 0, errorMessage);
253         return a % b;
254     }
255 }
256 
257 pragma solidity ^0.6.2;
258 
259 /**
260  * @dev Collection of functions related to the address type
261  */
262 library Address {
263     /**
264      * @dev Returns true if `account` is a contract.
265      *
266      * [IMPORTANT]
267      * ====
268      * It is unsafe to assume that an address for which this function returns
269      * false is an externally-owned account (EOA) and not a contract.
270      *
271      * Among others, `isContract` will return false for the following
272      * types of addresses:
273      *
274      *  - an externally-owned account
275      *  - a contract in construction
276      *  - an address where a contract will be created
277      *  - an address where a contract lived, but was destroyed
278      * ====
279      */
280     function isContract(address account) internal view returns (bool) {
281         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
282         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
283         // for accounts without code, i.e. `keccak256('')`
284         bytes32 codehash;
285         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
286         // solhint-disable-next-line no-inline-assembly
287         assembly { codehash := extcodehash(account) }
288         return (codehash != accountHash && codehash != 0x0);
289     }
290 
291     /**
292      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
293      * `recipient`, forwarding all available gas and reverting on errors.
294      *
295      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
296      * of certain opcodes, possibly making contracts go over the 2300 gas limit
297      * imposed by `transfer`, making them unable to receive funds via
298      * `transfer`. {sendValue} removes this limitation.
299      *
300      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
301      *
302      * IMPORTANT: because control is transferred to `recipient`, care must be
303      * taken to not create reentrancy vulnerabilities. Consider using
304      * {ReentrancyGuard} or the
305      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
306      */
307     function sendValue(address payable recipient, uint256 amount) internal {
308         require(address(this).balance >= amount, "Address: insufficient balance");
309 
310         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
311         (bool success, ) = recipient.call{ value: amount }("");
312         require(success, "Address: unable to send value, recipient may have reverted");
313     }
314 }
315 
316 pragma solidity ^0.6.0;
317 
318 /**
319  * @dev Implementation of the {IERC20} interface.
320  *
321  * This implementation is agnostic to the way tokens are created. This means
322  * that a supply mechanism has to be added in a derived contract using {_mint}.
323  * For a generic mechanism see {ERC20MinterPauser}.
324  *
325  * TIP: For a detailed writeup see our guide
326  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
327  * to implement supply mechanisms].
328  *
329  * We have followed general OpenZeppelin guidelines: functions revert instead
330  * of returning `false` on failure. This behavior is nonetheless conventional
331  * and does not conflict with the expectations of ERC20 applications.
332  *
333  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
334  * This allows applications to reconstruct the allowance for all accounts just
335  * by listening to said events. Other implementations of the EIP may not emit
336  * these events, as it isn't required by the specification.
337  *
338  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
339  * functions have been added to mitigate the well-known issues around setting
340  * allowances. See {IERC20-approve}.
341  */
342 contract ERC20 is Context, IERC20 {
343     using SafeMath for uint256;
344     using Address for address;
345 
346     mapping (address => uint256) internal _balances;
347 
348     mapping (address => mapping (address => uint256)) internal _allowances;
349 
350     uint256 internal _totalSupply;
351 
352     string private _name;
353     string private _symbol;
354     uint8 private _decimals;
355 
356     /**
357      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
358      * a default value of 18.
359      *
360      * To select a different value for {decimals}, use {_setupDecimals}.
361      *
362      * All three of these values are immutable: they can only be set once during
363      * construction.
364      */
365     constructor (string memory name, string memory symbol) public {
366         _name = name;
367         _symbol = symbol;
368         _decimals = 18;
369     }
370 
371     /**
372      * @dev Returns the name of the token.
373      */
374     function name() public view returns (string memory) {
375         return _name;
376     }
377 
378     /**
379      * @dev Returns the symbol of the token, usually a shorter version of the
380      * name.
381      */
382     function symbol() public view returns (string memory) {
383         return _symbol;
384     }
385 
386     /**
387      * @dev Returns the number of decimals used to get its user representation.
388      * For example, if `decimals` equals `2`, a balance of `505` tokens should
389      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
390      *
391      * Tokens usually opt for a value of 18, imitating the relationship between
392      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
393      * called.
394      *
395      * NOTE: This information is only used for _display_ purposes: it in
396      * no way affects any of the arithmetic of the contract, including
397      * {IERC20-balanceOf} and {IERC20-transfer}.
398      */
399     function decimals() public view returns (uint8) {
400         return _decimals;
401     }
402 
403     /**
404      * @dev See {IERC20-totalSupply}.
405      */
406     function totalSupply() public view override returns (uint256) {
407         return _totalSupply;
408     }
409 
410     /**
411      * @dev See {IERC20-balanceOf}.
412      */
413     function balanceOf(address account) public view override returns (uint256) {
414         return _balances[account];
415     }
416 
417     /**
418      * @dev See {IERC20-transfer}.
419      *
420      * Requirements:
421      *
422      * - `recipient` cannot be the zero address.
423      * - the caller must have a balance of at least `amount`.
424      */
425     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
426         _transfer(_msgSender(), recipient, amount);
427         return true;
428     }
429 
430     /**
431      * @dev See {IERC20-allowance}.
432      */
433     function allowance(address owner, address spender) public view virtual override returns (uint256) {
434         return _allowances[owner][spender];
435     }
436 
437     /**
438      * @dev See {IERC20-approve}.
439      *
440      * Requirements:
441      *
442      * - `spender` cannot be the zero address.
443      */
444     function approve(address spender, uint256 amount) public virtual override returns (bool) {
445         _approve(_msgSender(), spender, amount);
446         return true;
447     }
448 
449     /**
450      * @dev See {IERC20-transferFrom}.
451      *
452      * Emits an {Approval} event indicating the updated allowance. This is not
453      * required by the EIP. See the note at the beginning of {ERC20};
454      *
455      * Requirements:
456      * - `sender` and `recipient` cannot be the zero address.
457      * - `sender` must have a balance of at least `amount`.
458      * - the caller must have allowance for ``sender``'s tokens of at least
459      * `amount`.
460      */
461     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
462         _transfer(sender, recipient, amount);
463         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
464         return true;
465     }
466 
467     /**
468      * @dev Atomically increases the allowance granted to `spender` by the caller.
469      *
470      * This is an alternative to {approve} that can be used as a mitigation for
471      * problems described in {IERC20-approve}.
472      *
473      * Emits an {Approval} event indicating the updated allowance.
474      *
475      * Requirements:
476      *
477      * - `spender` cannot be the zero address.
478      */
479     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
480         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
481         return true;
482     }
483 
484     /**
485      * @dev Atomically decreases the allowance granted to `spender` by the caller.
486      *
487      * This is an alternative to {approve} that can be used as a mitigation for
488      * problems described in {IERC20-approve}.
489      *
490      * Emits an {Approval} event indicating the updated allowance.
491      *
492      * Requirements:
493      *
494      * - `spender` cannot be the zero address.
495      * - `spender` must have allowance for the caller of at least
496      * `subtractedValue`.
497      */
498     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
499         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
500         return true;
501     }
502 
503     /**
504      * @dev Moves tokens `amount` from `sender` to `recipient`.
505      *
506      * This is internal function is equivalent to {transfer}, and can be used to
507      * e.g. implement automatic token fees, slashing mechanisms, etc.
508      *
509      * Emits a {Transfer} event.
510      *
511      * Requirements:
512      *
513      * - `sender` cannot be the zero address.
514      * - `recipient` cannot be the zero address.
515      * - `sender` must have a balance of at least `amount`.
516      */
517     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
518         require(sender != address(0), "ERC20: transfer from the zero address");
519         require(recipient != address(0), "ERC20: transfer to the zero address");
520 
521         _beforeTokenTransfer(sender, recipient, amount);
522 
523         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
524         _balances[recipient] = _balances[recipient].add(amount);
525         emit Transfer(sender, recipient, amount);
526     }
527 
528     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
529      * the total supply.
530      *
531      * Emits a {Transfer} event with `from` set to the zero address.
532      *
533      * Requirements
534      *
535      * - `to` cannot be the zero address.
536      */
537     function _mint(address account, uint256 amount) internal virtual {
538         require(account != address(0), "ERC20: mint to the zero address");
539 
540         _beforeTokenTransfer(address(0), account, amount);
541 
542         _totalSupply = _totalSupply.add(amount);
543         _balances[account] = _balances[account].add(amount);
544         emit Transfer(address(0), account, amount);
545     }
546 
547     /**
548      * @dev Destroys `amount` tokens from `account`, reducing the
549      * total supply.
550      *
551      * Emits a {Transfer} event with `to` set to the zero address.
552      *
553      * Requirements
554      *
555      * - `account` cannot be the zero address.
556      * - `account` must have at least `amount` tokens.
557      */
558     function _burn(address account, uint256 amount) internal virtual {
559         require(account != address(0), "ERC20: burn from the zero address");
560 
561         _beforeTokenTransfer(account, address(0), amount);
562 
563         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
564         _totalSupply = _totalSupply.sub(amount);
565         emit Transfer(account, address(0), amount);
566     }
567 
568     /**
569      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
570      *
571      * This is internal function is equivalent to `approve`, and can be used to
572      * e.g. set automatic allowances for certain subsystems, etc.
573      *
574      * Emits an {Approval} event.
575      *
576      * Requirements:
577      *
578      * - `owner` cannot be the zero address.
579      * - `spender` cannot be the zero address.
580      */
581     function _approve(address owner, address spender, uint256 amount) internal virtual {
582         require(owner != address(0), "ERC20: approve from the zero address");
583         require(spender != address(0), "ERC20: approve to the zero address");
584 
585         _allowances[owner][spender] = amount;
586         emit Approval(owner, spender, amount);
587     }
588 
589     /**
590      * @dev Sets {decimals} to a value other than the default one of 18.
591      *
592      * WARNING: This function should only be called from the constructor. Most
593      * applications that interact with token contracts will not expect
594      * {decimals} to ever change, and may work incorrectly if it does.
595      */
596     function _setupDecimals(uint8 decimals_) internal {
597         _decimals = decimals_;
598     }
599 
600     /**
601      * @dev Hook that is called before any transfer of tokens. This includes
602      * minting and burning.
603      *
604      * Calling conditions:
605      *
606      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
607      * will be to transferred to `to`.
608      * - when `from` is zero, `amount` tokens will be minted for `to`.
609      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
610      * - `from` and `to` are never both zero.
611      *
612      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
613      */
614     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
615 }
616 
617 pragma solidity ^0.6.6;
618 
619 contract HE3 is ERC20 {
620     // Current supply
621     uint256 public _currentSupply;
622     // Manager
623     address public _owner;
624     // Burn address
625     address public _burnAddress;
626     // Fee address
627     address public _feeAddress;
628     // Initial Address
629     address public _initialAddress;
630     // Initial amount
631     uint256 public _initialToken;
632 
633     /**
634      * Constuctor func.
635      *
636      * Requirements:
637      *
638      * - `initialSupply`: total amount
639      * - `name`: token name
640      * - `symbol`: token symbol
641      */
642     constructor(
643         uint256 initialSupply, 
644         string memory name, 
645         string memory symbol, 
646         address initialAddress, 
647         uint256 initialToken, 
648         address feeAddress, 
649         address burnAddress
650     ) ERC20(name, symbol) public {
651         _owner = msg.sender;
652         _initialAddress = initialAddress;
653         _initialToken = initialToken;
654         _feeAddress = feeAddress;
655         _burnAddress = burnAddress;
656         _totalSupply = _totalSupply.add(initialSupply * 10 ** uint256(decimals()));
657         _balances[_initialAddress] = _balances[_initialAddress].add(_initialToken * 10 ** uint256(decimals()));
658         _currentSupply = _currentSupply.add(_initialToken * 10 ** uint256(decimals()));
659         emit Transfer(address(0), _initialAddress, _initialToken * 10 ** uint256(decimals()));
660     }
661 
662     modifier onlyOwner() {
663         require(msg.sender == _owner, "This function is restricted to the owner");
664         _;
665     }
666 
667     modifier notAddress0(address newAddress) {
668         require(newAddress != address(0), "Address should not be address(0)");
669         _;
670     }
671 
672 
673     // Update owner
674     function updateOwnerAddress(address newOwnerAddress) public onlyOwner notAddress0(newOwnerAddress) {
675         _owner = newOwnerAddress;
676     }
677 
678     // Update burn address
679     function updateBurnAddress(address newBurnAddress) public onlyOwner notAddress0(newBurnAddress) {
680         _burnAddress = newBurnAddress;
681     }
682 
683     // Update fee address
684     function updateFeeAddress(address newFeeAddress) public onlyOwner notAddress0(newFeeAddress) {
685         _feeAddress = newFeeAddress;
686     }
687 
688     /**
689      * Mint token, only owner have permission
690      *
691      * Requirements:
692      *
693      *  `userAddress`: to account address
694      * - `userToken`: reward amount
695      * - `feeToken`: fee amount
696      */
697     function mint(address userAddress, uint256 userToken, uint256 feeToken) public onlyOwner{
698         require(userAddress != address(0), "ERC20: mint to the zero address");
699         uint256 mintTotal = userToken.add(feeToken);
700         _currentSupply = _currentSupply.add(mintTotal);
701         require(_currentSupply <= _totalSupply, "TotalMintBalance should be less than or equal totalSupply");
702         _balances[_feeAddress] = _balances[_feeAddress].add(feeToken);
703         emit Transfer(address(0), _feeAddress, feeToken);
704         // mint to user
705         _balances[userAddress] = _balances[userAddress].add(userToken);
706         emit Transfer(address(0), userAddress, userToken);
707     }
708 
709     /**
710      * Only owner can burn token
711      *
712      * Requirements:
713      *
714      * - `_amount`: burn amount
715      */
716     function burnFromOwner(uint256 amount) public onlyOwner {
717         _totalSupply = _totalSupply.sub(amount);
718         _balances[_burnAddress] = _balances[_burnAddress].add(amount);
719         emit Transfer(address(0), _burnAddress, amount);
720     }
721 
722     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
723         if (recipient == _burnAddress) {
724             _totalSupply = _totalSupply.sub(amount);
725             _currentSupply = _currentSupply.sub(amount);
726         }
727 
728         _transfer(sender, recipient, amount);
729         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
730         return true;
731     }
732 }