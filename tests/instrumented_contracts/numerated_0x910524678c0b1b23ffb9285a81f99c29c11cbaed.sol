1 pragma solidity ^0.7.0;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address payable) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes memory) {
9         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
10         return msg.data;
11     }
12 }
13 
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 
86 library SafeMath {
87     /**
88      * @dev Returns the addition of two unsigned integers, reverting on
89      * overflow.
90      *
91      * Counterpart to Solidity's `+` operator.
92      *
93      * Requirements:
94      *
95      * - Addition cannot overflow.
96      */
97     function add(uint256 a, uint256 b) internal pure returns (uint256) {
98         uint256 c = a + b;
99         require(c >= a, "SafeMath: addition overflow");
100 
101         return c;
102     }
103 
104     /**
105      * @dev Returns the subtraction of two unsigned integers, reverting on
106      * overflow (when the result is negative).
107      *
108      * Counterpart to Solidity's `-` operator.
109      *
110      * Requirements:
111      *
112      * - Subtraction cannot overflow.
113      */
114     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115         return sub(a, b, "SafeMath: subtraction overflow");
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
129         require(b <= a, errorMessage);
130         uint256 c = a - b;
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the multiplication of two unsigned integers, reverting on
137      * overflow.
138      *
139      * Counterpart to Solidity's `*` operator.
140      *
141      * Requirements:
142      *
143      * - Multiplication cannot overflow.
144      */
145     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
147         // benefit is lost if 'b' is also tested.
148         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
149         if (a == 0) {
150             return 0;
151         }
152 
153         uint256 c = a * b;
154         require(c / a == b, "SafeMath: multiplication overflow");
155 
156         return c;
157     }
158 
159     /**
160      * @dev Returns the integer division of two unsigned integers. Reverts on
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
171     function div(uint256 a, uint256 b) internal pure returns (uint256) {
172         return div(a, b, "SafeMath: division by zero");
173     }
174 
175     /**
176      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
177      * division by zero. The result is rounded towards zero.
178      *
179      * Counterpart to Solidity's `/` operator. Note: this function uses a
180      * `revert` opcode (which leaves remaining gas untouched) while Solidity
181      * uses an invalid opcode to revert (consuming all remaining gas).
182      *
183      * Requirements:
184      *
185      * - The divisor cannot be zero.
186      */
187     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
188         require(b > 0, errorMessage);
189         uint256 c = a / b;
190         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
191 
192         return c;
193     }
194 
195     /**
196      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
197      * Reverts when dividing by zero.
198      *
199      * Counterpart to Solidity's `%` operator. This function uses a `revert`
200      * opcode (which leaves remaining gas untouched) while Solidity uses an
201      * invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
208         return mod(a, b, "SafeMath: modulo by zero");
209     }
210 
211     /**
212      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
213      * Reverts with custom message when dividing by zero.
214      *
215      * Counterpart to Solidity's `%` operator. This function uses a `revert`
216      * opcode (which leaves remaining gas untouched) while Solidity uses an
217      * invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
224         require(b != 0, errorMessage);
225         return a % b;
226     }
227 }
228 
229 library Address {
230     /**
231      * @dev Returns true if `account` is a contract.
232      *
233      * [IMPORTANT]
234      * ====
235      * It is unsafe to assume that an address for which this function returns
236      * false is an externally-owned account (EOA) and not a contract.
237      *
238      * Among others, `isContract` will return false for the following
239      * types of addresses:
240      *
241      *  - an externally-owned account
242      *  - a contract in construction
243      *  - an address where a contract will be created
244      *  - an address where a contract lived, but was destroyed
245      * ====
246      */
247     function isContract(address account) internal view returns (bool) {
248         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
249         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
250         // for accounts without code, i.e. `keccak256('')`
251         bytes32 codehash;
252         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
253         // solhint-disable-next-line no-inline-assembly
254         assembly { codehash := extcodehash(account) }
255         return (codehash != accountHash && codehash != 0x0);
256     }
257 
258     /**
259      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
260      * `recipient`, forwarding all available gas and reverting on errors.
261      *
262      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
263      * of certain opcodes, possibly making contracts go over the 2300 gas limit
264      * imposed by `transfer`, making them unable to receive funds via
265      * `transfer`. {sendValue} removes this limitation.
266      *
267      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
268      *
269      * IMPORTANT: because control is transferred to `recipient`, care must be
270      * taken to not create reentrancy vulnerabilities. Consider using
271      * {ReentrancyGuard} or the
272      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
273      */
274     function sendValue(address payable recipient, uint256 amount) internal {
275         require(address(this).balance >= amount, "Address: insufficient balance");
276 
277         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
278         (bool success, ) = recipient.call{ value: amount }("");
279         require(success, "Address: unable to send value, recipient may have reverted");
280     }
281 
282     /**
283      * @dev Performs a Solidity function call using a low level `call`. A
284      * plain`call` is an unsafe replacement for a function call: use this
285      * function instead.
286      *
287      * If `target` reverts with a revert reason, it is bubbled up by this
288      * function (like regular Solidity function calls).
289      *
290      * Returns the raw returned data. To convert to the expected return value,
291      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
292      *
293      * Requirements:
294      *
295      * - `target` must be a contract.
296      * - calling `target` with `data` must not revert.
297      *
298      * _Available since v3.1._
299      */
300     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
301         return functionCall(target, data, "Address: low-level call failed");
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
306      * `errorMessage` as a fallback revert reason when `target` reverts.
307      *
308      * _Available since v3.1._
309      */
310     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
311         return _functionCallWithValue(target, data, 0, errorMessage);
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316      * but also transferring `value` wei to `target`.
317      *
318      * Requirements:
319      *
320      * - the calling contract must have an ETH balance of at least `value`.
321      * - the called Solidity function must be `payable`.
322      *
323      * _Available since v3.1._
324      */
325     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
326         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
331      * with `errorMessage` as a fallback revert reason when `target` reverts.
332      *
333      * _Available since v3.1._
334      */
335     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
336         require(address(this).balance >= value, "Address: insufficient balance for call");
337         return _functionCallWithValue(target, data, value, errorMessage);
338     }
339 
340     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
341         require(isContract(target), "Address: call to non-contract");
342 
343         // solhint-disable-next-line avoid-low-level-calls
344         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
345         if (success) {
346             return returndata;
347         } else {
348             // Look for revert reason and bubble it up if present
349             if (returndata.length > 0) {
350                 // The easiest way to bubble the revert reason is using memory via assembly
351 
352                 // solhint-disable-next-line no-inline-assembly
353                 assembly {
354                     let returndata_size := mload(returndata)
355                     revert(add(32, returndata), returndata_size)
356                 }
357             } else {
358                 revert(errorMessage);
359             }
360         }
361     }
362 }
363 
364 contract ERC20 is Context, IERC20 {
365     using SafeMath for uint256;
366     using Address for address;
367 
368     mapping (address => uint256) private _balances;
369 
370     mapping (address => mapping (address => uint256)) private _allowances;
371 
372     uint256 private _totalSupply;
373 
374     string private _name;
375     string private _symbol;
376     uint8 private _decimals;
377 
378     /**
379      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
380      * a default value of 18.
381      *
382      * To select a different value for {decimals}, use {_setupDecimals}.
383      *
384      * All three of these values are immutable: they can only be set once during
385      * construction.
386      */
387     constructor (string memory name, string memory symbol) {
388         _name = name;
389         _symbol = symbol;
390         _decimals = 18;
391     }
392 
393     /**
394      * @dev Returns the name of the token.
395      */
396     function name() public view returns (string memory) {
397         return _name;
398     }
399 
400     /**
401      * @dev Returns the symbol of the token, usually a shorter version of the
402      * name.
403      */
404     function symbol() public view returns (string memory) {
405         return _symbol;
406     }
407 
408     /**
409      * @dev Returns the number of decimals used to get its user representation.
410      * For example, if `decimals` equals `2`, a balance of `505` tokens should
411      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
412      *
413      * Tokens usually opt for a value of 18, imitating the relationship between
414      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
415      * called.
416      *
417      * NOTE: This information is only used for _display_ purposes: it in
418      * no way affects any of the arithmetic of the contract, including
419      * {IERC20-balanceOf} and {IERC20-transfer}.
420      */
421     function decimals() public view returns (uint8) {
422         return _decimals;
423     }
424 
425     /**
426      * @dev See {IERC20-totalSupply}.
427      */
428     function totalSupply() public view override returns (uint256) {
429         return _totalSupply;
430     }
431 
432     /**
433      * @dev See {IERC20-balanceOf}.
434      */
435     function balanceOf(address account) public view override returns (uint256) {
436         return _balances[account];
437     }
438 
439     /**
440      * @dev See {IERC20-transfer}.
441      *
442      * Requirements:
443      *
444      * - `recipient` cannot be the zero address.
445      * - the caller must have a balance of at least `amount`.
446      */
447     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
448         _transfer(_msgSender(), recipient, amount);
449         return true;
450     }
451 
452     /**
453      * @dev See {IERC20-allowance}.
454      */
455     function allowance(address owner, address spender) public view virtual override returns (uint256) {
456         return _allowances[owner][spender];
457     }
458 
459     /**
460      * @dev See {IERC20-approve}.
461      *
462      * Requirements:
463      *
464      * - `spender` cannot be the zero address.
465      */
466     function approve(address spender, uint256 amount) public virtual override returns (bool) {
467         _approve(_msgSender(), spender, amount);
468         return true;
469     }
470 
471     /**
472      * @dev See {IERC20-transferFrom}.
473      *
474      * Emits an {Approval} event indicating the updated allowance. This is not
475      * required by the EIP. See the note at the beginning of {ERC20};
476      *
477      * Requirements:
478      * - `sender` and `recipient` cannot be the zero address.
479      * - `sender` must have a balance of at least `amount`.
480      * - the caller must have allowance for ``sender``'s tokens of at least
481      * `amount`.
482      */
483     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
484         _transfer(sender, recipient, amount);
485         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
486         return true;
487     }
488 
489     /**
490      * @dev Atomically increases the allowance granted to `spender` by the caller.
491      *
492      * This is an alternative to {approve} that can be used as a mitigation for
493      * problems described in {IERC20-approve}.
494      *
495      * Emits an {Approval} event indicating the updated allowance.
496      *
497      * Requirements:
498      *
499      * - `spender` cannot be the zero address.
500      */
501     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
502         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
503         return true;
504     }
505 
506     /**
507      * @dev Atomically decreases the allowance granted to `spender` by the caller.
508      *
509      * This is an alternative to {approve} that can be used as a mitigation for
510      * problems described in {IERC20-approve}.
511      *
512      * Emits an {Approval} event indicating the updated allowance.
513      *
514      * Requirements:
515      *
516      * - `spender` cannot be the zero address.
517      * - `spender` must have allowance for the caller of at least
518      * `subtractedValue`.
519      */
520     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
521         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
522         return true;
523     }
524 
525     /**
526      * @dev Moves tokens `amount` from `sender` to `recipient`.
527      *
528      * This is internal function is equivalent to {transfer}, and can be used to
529      * e.g. implement automatic token fees, slashing mechanisms, etc.
530      *
531      * Emits a {Transfer} event.
532      *
533      * Requirements:
534      *
535      * - `sender` cannot be the zero address.
536      * - `recipient` cannot be the zero address.
537      * - `sender` must have a balance of at least `amount`.
538      */
539     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
540         require(sender != address(0), "ERC20: transfer from the zero address");
541         require(recipient != address(0), "ERC20: transfer to the zero address");
542 
543         _beforeTokenTransfer(sender, recipient, amount);
544 
545         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
546         _balances[recipient] = _balances[recipient].add(amount);
547         emit Transfer(sender, recipient, amount);
548     }
549 
550     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
551      * the total supply.
552      *
553      * Emits a {Transfer} event with `from` set to the zero address.
554      *
555      * Requirements
556      *
557      * - `to` cannot be the zero address.
558      */
559     function _mint(address account, uint256 amount) internal virtual {
560         require(account != address(0), "ERC20: mint to the zero address");
561 
562         _beforeTokenTransfer(address(0), account, amount);
563 
564         _totalSupply = _totalSupply.add(amount);
565         _balances[account] = _balances[account].add(amount);
566         emit Transfer(address(0), account, amount);
567     }
568 
569     /**
570      * @dev Destroys `amount` tokens from `account`, reducing the
571      * total supply.
572      *
573      * Emits a {Transfer} event with `to` set to the zero address.
574      *
575      * Requirements
576      *
577      * - `account` cannot be the zero address.
578      * - `account` must have at least `amount` tokens.
579      */
580     function _burn(address account, uint256 amount) internal virtual {
581         require(account != address(0), "ERC20: burn from the zero address");
582 
583         _beforeTokenTransfer(account, address(0), amount);
584 
585         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
586         _totalSupply = _totalSupply.sub(amount);
587         emit Transfer(account, address(0), amount);
588     }
589 
590     /**
591      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
592      *
593      * This is internal function is equivalent to `approve`, and can be used to
594      * e.g. set automatic allowances for certain subsystems, etc.
595      *
596      * Emits an {Approval} event.
597      *
598      * Requirements:
599      *
600      * - `owner` cannot be the zero address.
601      * - `spender` cannot be the zero address.
602      */
603     function _approve(address owner, address spender, uint256 amount) internal virtual {
604         require(owner != address(0), "ERC20: approve from the zero address");
605         require(spender != address(0), "ERC20: approve to the zero address");
606 
607         _allowances[owner][spender] = amount;
608         emit Approval(owner, spender, amount);
609     }
610 
611     /**
612      * @dev Sets {decimals} to a value other than the default one of 18.
613      *
614      * WARNING: This function should only be called from the constructor. Most
615      * applications that interact with token contracts will not expect
616      * {decimals} to ever change, and may work incorrectly if it does.
617      */
618     function _setupDecimals(uint8 decimals_) internal {
619         _decimals = decimals_;
620     }
621 
622     /**
623      * @dev Hook that is called before any transfer of tokens. This includes
624      * minting and burning.
625      *
626      * Calling conditions:
627      *
628      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
629      * will be to transferred to `to`.
630      * - when `from` is zero, `amount` tokens will be minted for `to`.
631      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
632      * - `from` and `to` are never both zero.
633      *
634      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
635      */
636     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
637 }
638 
639 
640 contract Ownable is Context {
641     address private _owner;
642 
643     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
644 
645     /**
646      * @dev Initializes the contract setting the deployer as the initial owner.
647      */
648     constructor () {
649         address msgSender = _msgSender();
650         _owner = msgSender;
651         emit OwnershipTransferred(address(0), msgSender);
652     }
653 
654     /**
655      * @dev Returns the address of the current owner.
656      */
657     function owner() public view returns (address) {
658         return _owner;
659     }
660 
661     /**
662      * @dev Throws if called by any account other than the owner.
663      */
664     modifier onlyOwner() {
665         require(_owner == _msgSender(), "Ownable: caller is not the owner");
666         _;
667     }
668 
669     /**
670      * @dev Leaves the contract without owner. It will not be possible to call
671      * `onlyOwner` functions anymore. Can only be called by the current owner.
672      *
673      * NOTE: Renouncing ownership will leave the contract without an owner,
674      * thereby removing any functionality that is only available to the owner.
675      */
676     function renounceOwnership() public virtual onlyOwner {
677         emit OwnershipTransferred(_owner, address(0));
678         _owner = address(0);
679     }
680 
681     /**
682      * @dev Transfers ownership of the contract to a new account (`newOwner`).
683      * Can only be called by the current owner.
684      */
685     function transferOwnership(address newOwner) public virtual onlyOwner {
686         require(newOwner != address(0), "Ownable: new owner is the zero address");
687         emit OwnershipTransferred(_owner, newOwner);
688         _owner = newOwner;
689     }
690 }
691 
692 contract AzukiToken is ERC20("DokiDokiAzuki", "AZUKI"), Ownable {
693     using SafeMath for uint256;
694     using Address for address;
695 
696     mapping(string => uint) public operationLockTime;
697     mapping(string => bool) public operationTimelockEnabled;
698     string private MINT = "mint";
699     string private TRANSFER = "transfer";
700     string private ADDMINTER = "add_minter";
701     string private BURNRATE = "burn_rate";
702     uint public unlockDuration = 2 days;
703 
704     // mint for Owner
705     address public mintTo = address(0);
706     uint public mintAmount = 0;
707     // add mint for Owner
708     address public newMinter = address(0);
709     uint public newBurnRate = 0;
710 
711     mapping(address => bool) public minters;
712 
713     // transfer burn
714     uint public burnRate = 5;
715     mapping(address => bool) public transferBlacklist;
716     mapping(address => bool) public transferFromBlacklist;
717 
718     event GonnaMint(address to, uint amount, uint releaseTime);
719     event GonnaAddMinter(address newMinter, uint releaseTime);
720     event GonnaLockTransfer(uint releaseTime);
721     event GonnaChangeBurnRate(uint burnRate);
722 
723     modifier onlyMinter() {
724         require(minters[msg.sender], "Restricted to minters.");
725         _;
726     }
727 
728     function mint(address to, uint amount) public onlyMinter {
729         if (operationTimelockEnabled[MINT]) {
730             require(msg.sender != owner(), "Sorry, this function has been locked for Owner.");
731         }
732         _mint(to, amount);
733     }
734 
735     function burn(uint amount) public {
736         require(amount > 0);
737         require(balanceOf(msg.sender) >= amount);
738         _burn(msg.sender, amount);
739     }
740 
741     function addMinter(address account) public onlyOwner {
742         require(!operationTimelockEnabled[ADDMINTER], "Sorry, this function has been locked for Owner.");
743         minters[account] = true;
744     }
745 
746     function removeMinter(address account) public onlyOwner {
747         minters[account] = false;
748     }
749 
750     function gonnaMint(address to, uint amount) public onlyOwner {
751         mintTo = to;
752         mintAmount = amount;
753         operationLockTime[MINT] = block.timestamp + unlockDuration;
754 
755         emit GonnaMint(to, amount, operationLockTime[MINT]);
756     }
757 
758     function releaseMint() public onlyOwner {
759         require(mintAmount != 0, "mint amount can not be 0.");
760         require(block.timestamp >= operationLockTime[MINT], "Mint operation is pending.");
761         _mint(mintTo, mintAmount);
762         mintTo = address(0);
763         mintAmount = 0;
764     }
765 
766     function gonnaAddMinter(address account) public onlyOwner {
767         newMinter = account;
768         operationLockTime[ADDMINTER] = block.timestamp + unlockDuration;
769 
770         emit GonnaAddMinter(account, operationLockTime[ADDMINTER]);
771     }
772 
773     function releaseNewMinter() public onlyOwner {
774         require(newMinter != address(0), "New minter can not be 0x000.");
775         require(block.timestamp >= operationLockTime[ADDMINTER], "Add minter operation is pending.");
776         minters[newMinter] = true;
777         newMinter = address(0);
778     }
779 
780     function gonnaLockTransfer() public onlyOwner {
781         operationLockTime[TRANSFER] = block.timestamp + unlockDuration;
782 
783         emit GonnaLockTransfer(operationLockTime[TRANSFER]);
784     }
785 
786     function releaseTransferLock() public onlyOwner {
787         require(!operationTimelockEnabled[TRANSFER], "Transfer is being locked.");
788         require(block.timestamp >= operationLockTime[TRANSFER], "Transfer lock operation is pending.");
789         operationTimelockEnabled[TRANSFER] = true;
790     }
791 
792     function unlockTransfer() public onlyOwner {
793         operationTimelockEnabled[TRANSFER] = false;
794     }
795 
796     function gonnaChangeBurnRate(uint newRate) public onlyOwner {
797         newBurnRate = newRate;
798         operationLockTime[BURNRATE] = block.timestamp + unlockDuration;
799         emit GonnaChangeBurnRate(newRate);
800     }
801 
802     function releaseNewBurnRate() public onlyOwner {
803         require(block.timestamp >= operationLockTime[BURNRATE], "Changing to new burning rate is pending.");
804         burnRate = newBurnRate;
805     }
806 
807     function changeTimelockDuration(uint duration) public onlyOwner {
808         require(duration >= 1 days, "Duration must be greater than 1 day.");
809         unlockDuration = duration;
810     }
811 
812     function lockMint() public onlyOwner {
813         operationTimelockEnabled[MINT] = true;
814     }
815 
816     function lockAddMinter() public onlyOwner {
817         operationTimelockEnabled[ADDMINTER] = true;
818     }
819 
820     function addToTransferBlacklist(address account) public onlyOwner {
821         transferBlacklist[account] = true;
822     }
823 
824     function removeFromTransferBlacklist(address account) public onlyOwner {
825         transferBlacklist[account] = false;
826     }
827 
828     function addToTransferFromBlacklist(address account) public onlyOwner {
829         transferFromBlacklist[account] = true;
830     }
831 
832     function removeFromTransferFromBlacklist(address account) public onlyOwner {
833         transferFromBlacklist[account] = false;
834     }
835 
836     function transfer(address recipient, uint256 amount) public override returns (bool) {
837         require(msg.sender == owner() || !operationTimelockEnabled[TRANSFER], "Transfer is being locked.");
838         uint256 burnAmount = 0;
839         if (transferBlacklist[msg.sender]) {
840             burnAmount = amount.mul(burnRate).div(100);
841         }
842         uint256 transferAmount = amount.sub(burnAmount);
843         require(balanceOf(msg.sender) >= amount, "insufficient balance.");
844         super.transfer(recipient, transferAmount);
845         if (burnAmount != 0) {
846             _burn(msg.sender, burnAmount);
847         }
848         return true;
849     }
850 
851     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
852         require(sender == owner() || !operationTimelockEnabled[TRANSFER], "TransferFrom is being locked.");
853         uint256 burnAmount = 0;
854         if (transferFromBlacklist[recipient]) {
855             burnAmount = amount.mul(burnRate).div(100);
856         }
857         uint256 transferAmount = amount.sub(burnAmount);
858         require(balanceOf(sender) >= amount, "insufficient balance.");
859         super.transferFrom(sender, recipient, transferAmount);
860         if (burnAmount != 0) {
861             _burn(sender, burnAmount);
862         }
863         return true;
864     }
865 }