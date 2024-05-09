1 // Partial License: MIT
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
26 
27 // Partial License: MIT
28 
29 pragma solidity ^0.6.0;
30 
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(_owner == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 
96 
97 pragma solidity ^0.6.0;
98 
99 
100 
101 contract CM is Ownable {
102     string public cmContractType = "erc20";
103     string public cmImage   = "";
104     string public cmURL     = "";
105 
106     function _setCMImage(string memory image) public onlyOwner {
107         cmImage = image;
108     }
109 
110     function _setCMURL(string memory url) public onlyOwner {
111         cmURL = url;
112     }
113 
114     function _supportCM() internal {
115         require(msg.value > 45000000000000000 wei);
116         payable(0x98035297b70Cc88fbC064340Fa52344308eC8910).transfer(45000000000000000 wei);
117         // Thanks for supporting coinmechanics development!
118     }
119 }
120 
121 // Partial License: MIT
122 
123 pragma solidity ^0.6.0;
124 
125 /**
126  * @dev Interface of the ERC20 standard as defined in the EIP.
127  */
128 interface IERC20 {
129     /**
130      * @dev Returns the amount of tokens in existence.
131      */
132     function totalSupply() external view returns (uint256);
133 
134     /**
135      * @dev Returns the amount of tokens owned by `account`.
136      */
137     function balanceOf(address account) external view returns (uint256);
138 
139     /**
140      * @dev Moves `amount` tokens from the caller's account to `recipient`.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * Emits a {Transfer} event.
145      */
146     function transfer(address recipient, uint256 amount) external returns (bool);
147 
148     /**
149      * @dev Returns the remaining number of tokens that `spender` will be
150      * allowed to spend on behalf of `owner` through {transferFrom}. This is
151      * zero by default.
152      *
153      * This value changes when {approve} or {transferFrom} are called.
154      */
155     function allowance(address owner, address spender) external view returns (uint256);
156 
157     /**
158      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * IMPORTANT: Beware that changing an allowance with this method brings the risk
163      * that someone may use both the old and the new allowance by unfortunate
164      * transaction ordering. One possible solution to mitigate this race
165      * condition is to first reduce the spender's allowance to 0 and set the
166      * desired value afterwards:
167      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168      *
169      * Emits an {Approval} event.
170      */
171     function approve(address spender, uint256 amount) external returns (bool);
172 
173     /**
174      * @dev Moves `amount` tokens from `sender` to `recipient` using the
175      * allowance mechanism. `amount` is then deducted from the caller's
176      * allowance.
177      *
178      * Returns a boolean value indicating whether the operation succeeded.
179      *
180      * Emits a {Transfer} event.
181      */
182     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
183 
184     /**
185      * @dev Emitted when `value` tokens are moved from one account (`from`) to
186      * another (`to`).
187      *
188      * Note that `value` may be zero.
189      */
190     event Transfer(address indexed from, address indexed to, uint256 value);
191 
192     /**
193      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
194      * a call to {approve}. `value` is the new allowance.
195      */
196     event Approval(address indexed owner, address indexed spender, uint256 value);
197 }
198 
199 
200 // Partial License: MIT
201 
202 pragma solidity ^0.6.0;
203 
204 /**
205  * @dev Wrappers over Solidity's arithmetic operations with added overflow
206  * checks.
207  *
208  * Arithmetic operations in Solidity wrap on overflow. This can easily result
209  * in bugs, because programmers usually assume that an overflow raises an
210  * error, which is the standard behavior in high level programming languages.
211  * `SafeMath` restores this intuition by reverting the transaction when an
212  * operation overflows.
213  *
214  * Using this library instead of the unchecked operations eliminates an entire
215  * class of bugs, so it's recommended to use it always.
216  */
217 library SafeMath {
218     /**
219      * @dev Returns the addition of two unsigned integers, reverting on
220      * overflow.
221      *
222      * Counterpart to Solidity's `+` operator.
223      *
224      * Requirements:
225      *
226      * - Addition cannot overflow.
227      */
228     function add(uint256 a, uint256 b) internal pure returns (uint256) {
229         uint256 c = a + b;
230         require(c >= a, "SafeMath: addition overflow");
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the subtraction of two unsigned integers, reverting on
237      * overflow (when the result is negative).
238      *
239      * Counterpart to Solidity's `-` operator.
240      *
241      * Requirements:
242      *
243      * - Subtraction cannot overflow.
244      */
245     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
246         return sub(a, b, "SafeMath: subtraction overflow");
247     }
248 
249     /**
250      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
251      * overflow (when the result is negative).
252      *
253      * Counterpart to Solidity's `-` operator.
254      *
255      * Requirements:
256      *
257      * - Subtraction cannot overflow.
258      */
259     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
260         require(b <= a, errorMessage);
261         uint256 c = a - b;
262 
263         return c;
264     }
265 
266     /**
267      * @dev Returns the multiplication of two unsigned integers, reverting on
268      * overflow.
269      *
270      * Counterpart to Solidity's `*` operator.
271      *
272      * Requirements:
273      *
274      * - Multiplication cannot overflow.
275      */
276     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
277         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
278         // benefit is lost if 'b' is also tested.
279         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
280         if (a == 0) {
281             return 0;
282         }
283 
284         uint256 c = a * b;
285         require(c / a == b, "SafeMath: multiplication overflow");
286 
287         return c;
288     }
289 
290     /**
291      * @dev Returns the integer division of two unsigned integers. Reverts on
292      * division by zero. The result is rounded towards zero.
293      *
294      * Counterpart to Solidity's `/` operator. Note: this function uses a
295      * `revert` opcode (which leaves remaining gas untouched) while Solidity
296      * uses an invalid opcode to revert (consuming all remaining gas).
297      *
298      * Requirements:
299      *
300      * - The divisor cannot be zero.
301      */
302     function div(uint256 a, uint256 b) internal pure returns (uint256) {
303         return div(a, b, "SafeMath: division by zero");
304     }
305 
306     /**
307      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
308      * division by zero. The result is rounded towards zero.
309      *
310      * Counterpart to Solidity's `/` operator. Note: this function uses a
311      * `revert` opcode (which leaves remaining gas untouched) while Solidity
312      * uses an invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      *
316      * - The divisor cannot be zero.
317      */
318     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
319         require(b > 0, errorMessage);
320         uint256 c = a / b;
321         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
322 
323         return c;
324     }
325 
326     /**
327      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
328      * Reverts when dividing by zero.
329      *
330      * Counterpart to Solidity's `%` operator. This function uses a `revert`
331      * opcode (which leaves remaining gas untouched) while Solidity uses an
332      * invalid opcode to revert (consuming all remaining gas).
333      *
334      * Requirements:
335      *
336      * - The divisor cannot be zero.
337      */
338     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
339         return mod(a, b, "SafeMath: modulo by zero");
340     }
341 
342     /**
343      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
344      * Reverts with custom message when dividing by zero.
345      *
346      * Counterpart to Solidity's `%` operator. This function uses a `revert`
347      * opcode (which leaves remaining gas untouched) while Solidity uses an
348      * invalid opcode to revert (consuming all remaining gas).
349      *
350      * Requirements:
351      *
352      * - The divisor cannot be zero.
353      */
354     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
355         require(b != 0, errorMessage);
356         return a % b;
357     }
358 }
359 
360 
361 // Partial License: MIT
362 
363 pragma solidity ^0.6.2;
364 
365 /**
366  * @dev Collection of functions related to the address type
367  */
368 library Address {
369     /**
370      * @dev Returns true if `account` is a contract.
371      *
372      * [IMPORTANT]
373      * ====
374      * It is unsafe to assume that an address for which this function returns
375      * false is an externally-owned account (EOA) and not a contract.
376      *
377      * Among others, `isContract` will return false for the following
378      * types of addresses:
379      *
380      *  - an externally-owned account
381      *  - a contract in construction
382      *  - an address where a contract will be created
383      *  - an address where a contract lived, but was destroyed
384      * ====
385      */
386     function isContract(address account) internal view returns (bool) {
387         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
388         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
389         // for accounts without code, i.e. `keccak256('')`
390         bytes32 codehash;
391         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
392         // solhint-disable-next-line no-inline-assembly
393         assembly { codehash := extcodehash(account) }
394         return (codehash != accountHash && codehash != 0x0);
395     }
396 
397     /**
398      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
399      * `recipient`, forwarding all available gas and reverting on errors.
400      *
401      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
402      * of certain opcodes, possibly making contracts go over the 2300 gas limit
403      * imposed by `transfer`, making them unable to receive funds via
404      * `transfer`. {sendValue} removes this limitation.
405      *
406      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
407      *
408      * IMPORTANT: because control is transferred to `recipient`, care must be
409      * taken to not create reentrancy vulnerabilities. Consider using
410      * {ReentrancyGuard} or the
411      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
412      */
413     function sendValue(address payable recipient, uint256 amount) internal {
414         require(address(this).balance >= amount, "Address: insufficient balance");
415 
416         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
417         (bool success, ) = recipient.call{ value: amount }("");
418         require(success, "Address: unable to send value, recipient may have reverted");
419     }
420 
421     /**
422      * @dev Performs a Solidity function call using a low level `call`. A
423      * plain`call` is an unsafe replacement for a function call: use this
424      * function instead.
425      *
426      * If `target` reverts with a revert reason, it is bubbled up by this
427      * function (like regular Solidity function calls).
428      *
429      * Returns the raw returned data. To convert to the expected return value,
430      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
431      *
432      * Requirements:
433      *
434      * - `target` must be a contract.
435      * - calling `target` with `data` must not revert.
436      *
437      * _Available since v3.1._
438      */
439     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
440       return functionCall(target, data, "Address: low-level call failed");
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
445      * `errorMessage` as a fallback revert reason when `target` reverts.
446      *
447      * _Available since v3.1._
448      */
449     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
450         return _functionCallWithValue(target, data, 0, errorMessage);
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
455      * but also transferring `value` wei to `target`.
456      *
457      * Requirements:
458      *
459      * - the calling contract must have an ETH balance of at least `value`.
460      * - the called Solidity function must be `payable`.
461      *
462      * _Available since v3.1._
463      */
464     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
465         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
470      * with `errorMessage` as a fallback revert reason when `target` reverts.
471      *
472      * _Available since v3.1._
473      */
474     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
475         require(address(this).balance >= value, "Address: insufficient balance for call");
476         return _functionCallWithValue(target, data, value, errorMessage);
477     }
478 
479     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
480         require(isContract(target), "Address: call to non-contract");
481 
482         // solhint-disable-next-line avoid-low-level-calls
483         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
484         if (success) {
485             return returndata;
486         } else {
487             // Look for revert reason and bubble it up if present
488             if (returndata.length > 0) {
489                 // The easiest way to bubble the revert reason is using memory via assembly
490 
491                 // solhint-disable-next-line no-inline-assembly
492                 assembly {
493                     let returndata_size := mload(returndata)
494                     revert(add(32, returndata), returndata_size)
495                 }
496             } else {
497                 revert(errorMessage);
498             }
499         }
500     }
501 }
502 
503 
504 // Partial License: MIT
505 
506 pragma solidity ^0.6.0;
507 
508 
509 
510 
511 
512 
513 /**
514  * @dev Implementation of the {IERC20} interface.
515  *
516  * This implementation is agnostic to the way tokens are created. This means
517  * that a supply mechanism has to be added in a derived contract using {_mint}.
518  * For a generic mechanism see {ERC20PresetMinterPauser}.
519  *
520  * TIP: For a detailed writeup see our guide
521  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
522  * to implement supply mechanisms].
523  *
524  * We have followed general OpenZeppelin guidelines: functions revert instead
525  * of returning `false` on failure. This behavior is nonetheless conventional
526  * and does not conflict with the expectations of ERC20 applications.
527  *
528  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
529  * This allows applications to reconstruct the allowance for all accounts just
530  * by listening to said events. Other implementations of the EIP may not emit
531  * these events, as it isn't required by the specification.
532  *
533  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
534  * functions have been added to mitigate the well-known issues around setting
535  * allowances. See {IERC20-approve}.
536  */
537 contract ERC20 is Context, IERC20 {
538     using SafeMath for uint256;
539     using Address for address;
540 
541     mapping (address => uint256) private _balances;
542 
543     mapping (address => mapping (address => uint256)) private _allowances;
544 
545     uint256 private _totalSupply;
546 
547     string private _name;
548     string private _symbol;
549     uint8 private _decimals;
550 
551     /**
552      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
553      * a default value of 18.
554      *
555      * To select a different value for {decimals}, use {_setupDecimals}.
556      *
557      * All three of these values are immutable: they can only be set once during
558      * construction.
559      */
560     constructor (string memory name, string memory symbol) public {
561         _name = name;
562         _symbol = symbol;
563         _decimals = 18;
564     }
565 
566     /**
567      * @dev Returns the name of the token.
568      */
569     function name() public view returns (string memory) {
570         return _name;
571     }
572 
573     /**
574      * @dev Returns the symbol of the token, usually a shorter version of the
575      * name.
576      */
577     function symbol() public view returns (string memory) {
578         return _symbol;
579     }
580 
581     /**
582      * @dev Returns the number of decimals used to get its user representation.
583      * For example, if `decimals` equals `2`, a balance of `505` tokens should
584      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
585      *
586      * Tokens usually opt for a value of 18, imitating the relationship between
587      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
588      * called.
589      *
590      * NOTE: This information is only used for _display_ purposes: it in
591      * no way affects any of the arithmetic of the contract, including
592      * {IERC20-balanceOf} and {IERC20-transfer}.
593      */
594     function decimals() public view returns (uint8) {
595         return _decimals;
596     }
597 
598     /**
599      * @dev See {IERC20-totalSupply}.
600      */
601     function totalSupply() public view override returns (uint256) {
602         return _totalSupply;
603     }
604 
605     /**
606      * @dev See {IERC20-balanceOf}.
607      */
608     function balanceOf(address account) public view override returns (uint256) {
609         return _balances[account];
610     }
611 
612     /**
613      * @dev See {IERC20-transfer}.
614      *
615      * Requirements:
616      *
617      * - `recipient` cannot be the zero address.
618      * - the caller must have a balance of at least `amount`.
619      */
620     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
621         _transfer(_msgSender(), recipient, amount);
622         return true;
623     }
624 
625     /**
626      * @dev See {IERC20-allowance}.
627      */
628     function allowance(address owner, address spender) public view virtual override returns (uint256) {
629         return _allowances[owner][spender];
630     }
631 
632     /**
633      * @dev See {IERC20-approve}.
634      *
635      * Requirements:
636      *
637      * - `spender` cannot be the zero address.
638      */
639     function approve(address spender, uint256 amount) public virtual override returns (bool) {
640         _approve(_msgSender(), spender, amount);
641         return true;
642     }
643 
644     /**
645      * @dev See {IERC20-transferFrom}.
646      *
647      * Emits an {Approval} event indicating the updated allowance. This is not
648      * required by the EIP. See the note at the beginning of {ERC20};
649      *
650      * Requirements:
651      * - `sender` and `recipient` cannot be the zero address.
652      * - `sender` must have a balance of at least `amount`.
653      * - the caller must have allowance for ``sender``'s tokens of at least
654      * `amount`.
655      */
656     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
657         _transfer(sender, recipient, amount);
658         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
659         return true;
660     }
661 
662     /**
663      * @dev Atomically increases the allowance granted to `spender` by the caller.
664      *
665      * This is an alternative to {approve} that can be used as a mitigation for
666      * problems described in {IERC20-approve}.
667      *
668      * Emits an {Approval} event indicating the updated allowance.
669      *
670      * Requirements:
671      *
672      * - `spender` cannot be the zero address.
673      */
674     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
675         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
676         return true;
677     }
678 
679     /**
680      * @dev Atomically decreases the allowance granted to `spender` by the caller.
681      *
682      * This is an alternative to {approve} that can be used as a mitigation for
683      * problems described in {IERC20-approve}.
684      *
685      * Emits an {Approval} event indicating the updated allowance.
686      *
687      * Requirements:
688      *
689      * - `spender` cannot be the zero address.
690      * - `spender` must have allowance for the caller of at least
691      * `subtractedValue`.
692      */
693     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
694         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
695         return true;
696     }
697 
698     /**
699      * @dev Moves tokens `amount` from `sender` to `recipient`.
700      *
701      * This is internal function is equivalent to {transfer}, and can be used to
702      * e.g. implement automatic token fees, slashing mechanisms, etc.
703      *
704      * Emits a {Transfer} event.
705      *
706      * Requirements:
707      *
708      * - `sender` cannot be the zero address.
709      * - `recipient` cannot be the zero address.
710      * - `sender` must have a balance of at least `amount`.
711      */
712     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
713         require(sender != address(0), "ERC20: transfer from the zero address");
714         require(recipient != address(0), "ERC20: transfer to the zero address");
715 
716         _beforeTokenTransfer(sender, recipient, amount);
717 
718         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
719         _balances[recipient] = _balances[recipient].add(amount);
720         emit Transfer(sender, recipient, amount);
721     }
722 
723     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
724      * the total supply.
725      *
726      * Emits a {Transfer} event with `from` set to the zero address.
727      *
728      * Requirements
729      *
730      * - `to` cannot be the zero address.
731      */
732     function _mint(address account, uint256 amount) internal virtual {
733         require(account != address(0), "ERC20: mint to the zero address");
734 
735         _beforeTokenTransfer(address(0), account, amount);
736 
737         _totalSupply = _totalSupply.add(amount);
738         _balances[account] = _balances[account].add(amount);
739         emit Transfer(address(0), account, amount);
740     }
741 
742     /**
743      * @dev Destroys `amount` tokens from `account`, reducing the
744      * total supply.
745      *
746      * Emits a {Transfer} event with `to` set to the zero address.
747      *
748      * Requirements
749      *
750      * - `account` cannot be the zero address.
751      * - `account` must have at least `amount` tokens.
752      */
753     function _burn(address account, uint256 amount) internal virtual {
754         require(account != address(0), "ERC20: burn from the zero address");
755 
756         _beforeTokenTransfer(account, address(0), amount);
757 
758         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
759         _totalSupply = _totalSupply.sub(amount);
760         emit Transfer(account, address(0), amount);
761     }
762 
763     /**
764      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
765      *
766      * This is internal function is equivalent to `approve`, and can be used to
767      * e.g. set automatic allowances for certain subsystems, etc.
768      *
769      * Emits an {Approval} event.
770      *
771      * Requirements:
772      *
773      * - `owner` cannot be the zero address.
774      * - `spender` cannot be the zero address.
775      */
776     function _approve(address owner, address spender, uint256 amount) internal virtual {
777         require(owner != address(0), "ERC20: approve from the zero address");
778         require(spender != address(0), "ERC20: approve to the zero address");
779 
780         _allowances[owner][spender] = amount;
781         emit Approval(owner, spender, amount);
782     }
783 
784     /**
785      * @dev Sets {decimals} to a value other than the default one of 18.
786      *
787      * WARNING: This function should only be called from the constructor. Most
788      * applications that interact with token contracts will not expect
789      * {decimals} to ever change, and may work incorrectly if it does.
790      */
791     function _setupDecimals(uint8 decimals_) internal {
792         _decimals = decimals_;
793     }
794 
795     /**
796      * @dev Hook that is called before any transfer of tokens. This includes
797      * minting and burning.
798      *
799      * Calling conditions:
800      *
801      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
802      * will be to transferred to `to`.
803      * - when `from` is zero, `amount` tokens will be minted for `to`.
804      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
805      * - `from` and `to` are never both zero.
806      *
807      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
808      */
809     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
810 }
811 
812 
813 // Partial License: MIT
814 
815 pragma solidity ^0.6.0;
816 
817 
818 
819 
820 /**
821  * @dev Extension of {ERC20} that allows token holders to destroy both their own
822  * tokens and those that they have an allowance for, in a way that can be
823  * recognized off-chain (via event analysis).
824  */
825 abstract contract ERC20Burnable is Context, ERC20 {
826     /**
827      * @dev Destroys `amount` tokens from the caller.
828      *
829      * See {ERC20-_burn}.
830      */
831     function burn(uint256 amount) public virtual {
832         _burn(_msgSender(), amount);
833     }
834 
835     /**
836      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
837      * allowance.
838      *
839      * See {ERC20-_burn} and {ERC20-allowance}.
840      *
841      * Requirements:
842      *
843      * - the caller must have allowance for ``accounts``'s tokens of at least
844      * `amount`.
845      */
846     function burnFrom(address account, uint256 amount) public virtual {
847         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
848 
849         _approve(account, _msgSender(), decreasedAllowance);
850         _burn(account, amount);
851     }
852 }
853 
854 
855 // Partial License: MIT
856 
857 pragma solidity ^0.6.0;
858 
859 /**
860  * @dev Library for managing
861  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
862  * types.
863  *
864  * Sets have the following properties:
865  *
866  * - Elements are added, removed, and checked for existence in constant time
867  * (O(1)).
868  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
869  *
870  * ```
871  * contract Example {
872  *     // Add the library methods
873  *     using EnumerableSet for EnumerableSet.AddressSet;
874  *
875  *     // Declare a set state variable
876  *     EnumerableSet.AddressSet private mySet;
877  * }
878  * ```
879  *
880  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
881  * (`UintSet`) are supported.
882  */
883 library EnumerableSet {
884     // To implement this library for multiple types with as little code
885     // repetition as possible, we write it in terms of a generic Set type with
886     // bytes32 values.
887     // The Set implementation uses private functions, and user-facing
888     // implementations (such as AddressSet) are just wrappers around the
889     // underlying Set.
890     // This means that we can only create new EnumerableSets for types that fit
891     // in bytes32.
892 
893     struct Set {
894         // Storage of set values
895         bytes32[] _values;
896 
897         // Position of the value in the `values` array, plus 1 because index 0
898         // means a value is not in the set.
899         mapping (bytes32 => uint256) _indexes;
900     }
901 
902     /**
903      * @dev Add a value to a set. O(1).
904      *
905      * Returns true if the value was added to the set, that is if it was not
906      * already present.
907      */
908     function _add(Set storage set, bytes32 value) private returns (bool) {
909         if (!_contains(set, value)) {
910             set._values.push(value);
911             // The value is stored at length-1, but we add 1 to all indexes
912             // and use 0 as a sentinel value
913             set._indexes[value] = set._values.length;
914             return true;
915         } else {
916             return false;
917         }
918     }
919 
920     /**
921      * @dev Removes a value from a set. O(1).
922      *
923      * Returns true if the value was removed from the set, that is if it was
924      * present.
925      */
926     function _remove(Set storage set, bytes32 value) private returns (bool) {
927         // We read and store the value's index to prevent multiple reads from the same storage slot
928         uint256 valueIndex = set._indexes[value];
929 
930         if (valueIndex != 0) { // Equivalent to contains(set, value)
931             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
932             // the array, and then remove the last element (sometimes called as 'swap and pop').
933             // This modifies the order of the array, as noted in {at}.
934 
935             uint256 toDeleteIndex = valueIndex - 1;
936             uint256 lastIndex = set._values.length - 1;
937 
938             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
939             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
940 
941             bytes32 lastvalue = set._values[lastIndex];
942 
943             // Move the last value to the index where the value to delete is
944             set._values[toDeleteIndex] = lastvalue;
945             // Update the index for the moved value
946             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
947 
948             // Delete the slot where the moved value was stored
949             set._values.pop();
950 
951             // Delete the index for the deleted slot
952             delete set._indexes[value];
953 
954             return true;
955         } else {
956             return false;
957         }
958     }
959 
960     /**
961      * @dev Returns true if the value is in the set. O(1).
962      */
963     function _contains(Set storage set, bytes32 value) private view returns (bool) {
964         return set._indexes[value] != 0;
965     }
966 
967     /**
968      * @dev Returns the number of values on the set. O(1).
969      */
970     function _length(Set storage set) private view returns (uint256) {
971         return set._values.length;
972     }
973 
974    /**
975     * @dev Returns the value stored at position `index` in the set. O(1).
976     *
977     * Note that there are no guarantees on the ordering of values inside the
978     * array, and it may change when more values are added or removed.
979     *
980     * Requirements:
981     *
982     * - `index` must be strictly less than {length}.
983     */
984     function _at(Set storage set, uint256 index) private view returns (bytes32) {
985         require(set._values.length > index, "EnumerableSet: index out of bounds");
986         return set._values[index];
987     }
988 
989     // AddressSet
990 
991     struct AddressSet {
992         Set _inner;
993     }
994 
995     /**
996      * @dev Add a value to a set. O(1).
997      *
998      * Returns true if the value was added to the set, that is if it was not
999      * already present.
1000      */
1001     function add(AddressSet storage set, address value) internal returns (bool) {
1002         return _add(set._inner, bytes32(uint256(value)));
1003     }
1004 
1005     /**
1006      * @dev Removes a value from a set. O(1).
1007      *
1008      * Returns true if the value was removed from the set, that is if it was
1009      * present.
1010      */
1011     function remove(AddressSet storage set, address value) internal returns (bool) {
1012         return _remove(set._inner, bytes32(uint256(value)));
1013     }
1014 
1015     /**
1016      * @dev Returns true if the value is in the set. O(1).
1017      */
1018     function contains(AddressSet storage set, address value) internal view returns (bool) {
1019         return _contains(set._inner, bytes32(uint256(value)));
1020     }
1021 
1022     /**
1023      * @dev Returns the number of values in the set. O(1).
1024      */
1025     function length(AddressSet storage set) internal view returns (uint256) {
1026         return _length(set._inner);
1027     }
1028 
1029    /**
1030     * @dev Returns the value stored at position `index` in the set. O(1).
1031     *
1032     * Note that there are no guarantees on the ordering of values inside the
1033     * array, and it may change when more values are added or removed.
1034     *
1035     * Requirements:
1036     *
1037     * - `index` must be strictly less than {length}.
1038     */
1039     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1040         return address(uint256(_at(set._inner, index)));
1041     }
1042 
1043 
1044     // UintSet
1045 
1046     struct UintSet {
1047         Set _inner;
1048     }
1049 
1050     /**
1051      * @dev Add a value to a set. O(1).
1052      *
1053      * Returns true if the value was added to the set, that is if it was not
1054      * already present.
1055      */
1056     function add(UintSet storage set, uint256 value) internal returns (bool) {
1057         return _add(set._inner, bytes32(value));
1058     }
1059 
1060     /**
1061      * @dev Removes a value from a set. O(1).
1062      *
1063      * Returns true if the value was removed from the set, that is if it was
1064      * present.
1065      */
1066     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1067         return _remove(set._inner, bytes32(value));
1068     }
1069 
1070     /**
1071      * @dev Returns true if the value is in the set. O(1).
1072      */
1073     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1074         return _contains(set._inner, bytes32(value));
1075     }
1076 
1077     /**
1078      * @dev Returns the number of values on the set. O(1).
1079      */
1080     function length(UintSet storage set) internal view returns (uint256) {
1081         return _length(set._inner);
1082     }
1083 
1084    /**
1085     * @dev Returns the value stored at position `index` in the set. O(1).
1086     *
1087     * Note that there are no guarantees on the ordering of values inside the
1088     * array, and it may change when more values are added or removed.
1089     *
1090     * Requirements:
1091     *
1092     * - `index` must be strictly less than {length}.
1093     */
1094     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1095         return uint256(_at(set._inner, index));
1096     }
1097 }
1098 
1099 
1100 // Partial License: MIT
1101 
1102 pragma solidity ^0.6.0;
1103 
1104 
1105 
1106 
1107 
1108 /**
1109  * @dev Contract module that allows children to implement role-based access
1110  * control mechanisms.
1111  *
1112  * Roles are referred to by their `bytes32` identifier. These should be exposed
1113  * in the external API and be unique. The best way to achieve this is by
1114  * using `public constant` hash digests:
1115  *
1116  * ```
1117  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1118  * ```
1119  *
1120  * Roles can be used to represent a set of permissions. To restrict access to a
1121  * function call, use {hasRole}:
1122  *
1123  * ```
1124  * function foo() public {
1125  *     require(hasRole(MY_ROLE, msg.sender));
1126  *     ...
1127  * }
1128  * ```
1129  *
1130  * Roles can be granted and revoked dynamically via the {grantRole} and
1131  * {revokeRole} functions. Each role has an associated admin role, and only
1132  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1133  *
1134  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1135  * that only accounts with this role will be able to grant or revoke other
1136  * roles. More complex role relationships can be created by using
1137  * {_setRoleAdmin}.
1138  *
1139  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1140  * grant and revoke this role. Extra precautions should be taken to secure
1141  * accounts that have been granted it.
1142  */
1143 abstract contract AccessControl is Context {
1144     using EnumerableSet for EnumerableSet.AddressSet;
1145     using Address for address;
1146 
1147     struct RoleData {
1148         EnumerableSet.AddressSet members;
1149         bytes32 adminRole;
1150     }
1151 
1152     mapping (bytes32 => RoleData) private _roles;
1153 
1154     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1155 
1156     /**
1157      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1158      *
1159      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1160      * {RoleAdminChanged} not being emitted signaling this.
1161      *
1162      * _Available since v3.1._
1163      */
1164     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1165 
1166     /**
1167      * @dev Emitted when `account` is granted `role`.
1168      *
1169      * `sender` is the account that originated the contract call, an admin role
1170      * bearer except when using {_setupRole}.
1171      */
1172     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1173 
1174     /**
1175      * @dev Emitted when `account` is revoked `role`.
1176      *
1177      * `sender` is the account that originated the contract call:
1178      *   - if using `revokeRole`, it is the admin role bearer
1179      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1180      */
1181     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1182 
1183     /**
1184      * @dev Returns `true` if `account` has been granted `role`.
1185      */
1186     function hasRole(bytes32 role, address account) public view returns (bool) {
1187         return _roles[role].members.contains(account);
1188     }
1189 
1190     /**
1191      * @dev Returns the number of accounts that have `role`. Can be used
1192      * together with {getRoleMember} to enumerate all bearers of a role.
1193      */
1194     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1195         return _roles[role].members.length();
1196     }
1197 
1198     /**
1199      * @dev Returns one of the accounts that have `role`. `index` must be a
1200      * value between 0 and {getRoleMemberCount}, non-inclusive.
1201      *
1202      * Role bearers are not sorted in any particular way, and their ordering may
1203      * change at any point.
1204      *
1205      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1206      * you perform all queries on the same block. See the following
1207      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1208      * for more information.
1209      */
1210     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1211         return _roles[role].members.at(index);
1212     }
1213 
1214     /**
1215      * @dev Returns the admin role that controls `role`. See {grantRole} and
1216      * {revokeRole}.
1217      *
1218      * To change a role's admin, use {_setRoleAdmin}.
1219      */
1220     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1221         return _roles[role].adminRole;
1222     }
1223 
1224     /**
1225      * @dev Grants `role` to `account`.
1226      *
1227      * If `account` had not been already granted `role`, emits a {RoleGranted}
1228      * event.
1229      *
1230      * Requirements:
1231      *
1232      * - the caller must have ``role``'s admin role.
1233      */
1234     function grantRole(bytes32 role, address account) public virtual {
1235         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1236 
1237         _grantRole(role, account);
1238     }
1239 
1240     /**
1241      * @dev Revokes `role` from `account`.
1242      *
1243      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1244      *
1245      * Requirements:
1246      *
1247      * - the caller must have ``role``'s admin role.
1248      */
1249     function revokeRole(bytes32 role, address account) public virtual {
1250         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1251 
1252         _revokeRole(role, account);
1253     }
1254 
1255     /**
1256      * @dev Revokes `role` from the calling account.
1257      *
1258      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1259      * purpose is to provide a mechanism for accounts to lose their privileges
1260      * if they are compromised (such as when a trusted device is misplaced).
1261      *
1262      * If the calling account had been granted `role`, emits a {RoleRevoked}
1263      * event.
1264      *
1265      * Requirements:
1266      *
1267      * - the caller must be `account`.
1268      */
1269     function renounceRole(bytes32 role, address account) public virtual {
1270         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1271 
1272         _revokeRole(role, account);
1273     }
1274 
1275     /**
1276      * @dev Grants `role` to `account`.
1277      *
1278      * If `account` had not been already granted `role`, emits a {RoleGranted}
1279      * event. Note that unlike {grantRole}, this function doesn't perform any
1280      * checks on the calling account.
1281      *
1282      * [WARNING]
1283      * ====
1284      * This function should only be called from the constructor when setting
1285      * up the initial roles for the system.
1286      *
1287      * Using this function in any other way is effectively circumventing the admin
1288      * system imposed by {AccessControl}.
1289      * ====
1290      */
1291     function _setupRole(bytes32 role, address account) internal virtual {
1292         _grantRole(role, account);
1293     }
1294 
1295     /**
1296      * @dev Sets `adminRole` as ``role``'s admin role.
1297      *
1298      * Emits a {RoleAdminChanged} event.
1299      */
1300     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1301         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1302         _roles[role].adminRole = adminRole;
1303     }
1304 
1305     function _grantRole(bytes32 role, address account) private {
1306         if (_roles[role].members.add(account)) {
1307             emit RoleGranted(role, account, _msgSender());
1308         }
1309     }
1310 
1311     function _revokeRole(bytes32 role, address account) private {
1312         if (_roles[role].members.remove(account)) {
1313             emit RoleRevoked(role, account, _msgSender());
1314         }
1315     }
1316 }
1317 
1318 
1319 // Partial License: MIT
1320 
1321 pragma solidity ^0.6.0;
1322 
1323 /**
1324  * @dev Standard math utilities missing in the Solidity language.
1325  */
1326 library Math {
1327     /**
1328      * @dev Returns the largest of two numbers.
1329      */
1330     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1331         return a >= b ? a : b;
1332     }
1333 
1334     /**
1335      * @dev Returns the smallest of two numbers.
1336      */
1337     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1338         return a < b ? a : b;
1339     }
1340 
1341     /**
1342      * @dev Returns the average of two numbers. The result is rounded towards
1343      * zero.
1344      */
1345     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1346         // (a + b) / 2 can overflow, so we distribute
1347         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
1348     }
1349 }
1350 
1351 
1352 // Partial License: MIT
1353 
1354 pragma solidity ^0.6.0;
1355 
1356 
1357 
1358 /**
1359  * @dev Collection of functions related to array types.
1360  */
1361 library Arrays {
1362    /**
1363      * @dev Searches a sorted `array` and returns the first index that contains
1364      * a value greater or equal to `element`. If no such index exists (i.e. all
1365      * values in the array are strictly less than `element`), the array length is
1366      * returned. Time complexity O(log n).
1367      *
1368      * `array` is expected to be sorted in ascending order, and to contain no
1369      * repeated elements.
1370      */
1371     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
1372         if (array.length == 0) {
1373             return 0;
1374         }
1375 
1376         uint256 low = 0;
1377         uint256 high = array.length;
1378 
1379         while (low < high) {
1380             uint256 mid = Math.average(low, high);
1381 
1382             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
1383             // because Math.average rounds down (it does integer division with truncation).
1384             if (array[mid] > element) {
1385                 high = mid;
1386             } else {
1387                 low = mid + 1;
1388             }
1389         }
1390 
1391         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
1392         if (low > 0 && array[low - 1] == element) {
1393             return low - 1;
1394         } else {
1395             return low;
1396         }
1397     }
1398 }
1399 
1400 
1401 // Partial License: MIT
1402 
1403 pragma solidity ^0.6.0;
1404 
1405 
1406 
1407 /**
1408  * @title Counters
1409  * @author Matt Condon (@shrugs)
1410  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1411  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1412  *
1413  * Include with `using Counters for Counters.Counter;`
1414  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1415  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1416  * directly accessed.
1417  */
1418 library Counters {
1419     using SafeMath for uint256;
1420 
1421     struct Counter {
1422         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1423         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1424         // this feature: see https://github.com/ethereum/solidity/issues/4637
1425         uint256 _value; // default: 0
1426     }
1427 
1428     function current(Counter storage counter) internal view returns (uint256) {
1429         return counter._value;
1430     }
1431 
1432     function increment(Counter storage counter) internal {
1433         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1434         counter._value += 1;
1435     }
1436 
1437     function decrement(Counter storage counter) internal {
1438         counter._value = counter._value.sub(1);
1439     }
1440 }
1441 
1442 
1443 // Partial License: MIT
1444 
1445 pragma solidity ^0.6.0;
1446 
1447 
1448 
1449 
1450 
1451 
1452 /**
1453  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
1454  * total supply at the time are recorded for later access.
1455  *
1456  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
1457  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
1458  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
1459  * used to create an efficient ERC20 forking mechanism.
1460  *
1461  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
1462  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
1463  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
1464  * and the account address.
1465  *
1466  * ==== Gas Costs
1467  *
1468  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
1469  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
1470  * smaller since identical balances in subsequent snapshots are stored as a single entry.
1471  *
1472  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
1473  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
1474  * transfers will have normal cost until the next snapshot, and so on.
1475  */
1476 abstract contract ERC20Snapshot is ERC20 {
1477     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
1478     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
1479 
1480     using SafeMath for uint256;
1481     using Arrays for uint256[];
1482     using Counters for Counters.Counter;
1483 
1484     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
1485     // Snapshot struct, but that would impede usage of functions that work on an array.
1486     struct Snapshots {
1487         uint256[] ids;
1488         uint256[] values;
1489     }
1490 
1491     mapping (address => Snapshots) private _accountBalanceSnapshots;
1492     Snapshots private _totalSupplySnapshots;
1493 
1494     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
1495     Counters.Counter private _currentSnapshotId;
1496 
1497     /**
1498      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
1499      */
1500     event Snapshot(uint256 id);
1501 
1502     /**
1503      * @dev Creates a new snapshot and returns its snapshot id.
1504      *
1505      * Emits a {Snapshot} event that contains the same id.
1506      *
1507      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
1508      * set of accounts, for example using {AccessControl}, or it may be open to the public.
1509      *
1510      * [WARNING]
1511      * ====
1512      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
1513      * you must consider that it can potentially be used by attackers in two ways.
1514      *
1515      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
1516      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
1517      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
1518      * section above.
1519      *
1520      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
1521      * ====
1522      */
1523     function _snapshot() internal virtual returns (uint256) {
1524         _currentSnapshotId.increment();
1525 
1526         uint256 currentId = _currentSnapshotId.current();
1527         emit Snapshot(currentId);
1528         return currentId;
1529     }
1530 
1531     /**
1532      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
1533      */
1534     function balanceOfAt(address account, uint256 snapshotId) public view returns (uint256) {
1535         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
1536 
1537         return snapshotted ? value : balanceOf(account);
1538     }
1539 
1540     /**
1541      * @dev Retrieves the total supply at the time `snapshotId` was created.
1542      */
1543     function totalSupplyAt(uint256 snapshotId) public view returns(uint256) {
1544         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
1545 
1546         return snapshotted ? value : totalSupply();
1547     }
1548 
1549     // _transfer, _mint and _burn are the only functions where the balances are modified, so it is there that the
1550     // snapshots are updated. Note that the update happens _before_ the balance change, with the pre-modified value.
1551     // The same is true for the total supply and _mint and _burn.
1552     function _transfer(address from, address to, uint256 value) internal virtual override {
1553         _updateAccountSnapshot(from);
1554         _updateAccountSnapshot(to);
1555 
1556         super._transfer(from, to, value);
1557     }
1558 
1559     function _mint(address account, uint256 value) internal virtual override {
1560         _updateAccountSnapshot(account);
1561         _updateTotalSupplySnapshot();
1562 
1563         super._mint(account, value);
1564     }
1565 
1566     function _burn(address account, uint256 value) internal virtual override {
1567         _updateAccountSnapshot(account);
1568         _updateTotalSupplySnapshot();
1569 
1570         super._burn(account, value);
1571     }
1572 
1573     function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
1574         private view returns (bool, uint256)
1575     {
1576         require(snapshotId > 0, "ERC20Snapshot: id is 0");
1577         // solhint-disable-next-line max-line-length
1578         require(snapshotId <= _currentSnapshotId.current(), "ERC20Snapshot: nonexistent id");
1579 
1580         // When a valid snapshot is queried, there are three possibilities:
1581         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
1582         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
1583         //  to this id is the current one.
1584         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
1585         //  requested id, and its value is the one to return.
1586         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
1587         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
1588         //  larger than the requested one.
1589         //
1590         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
1591         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
1592         // exactly this.
1593 
1594         uint256 index = snapshots.ids.findUpperBound(snapshotId);
1595 
1596         if (index == snapshots.ids.length) {
1597             return (false, 0);
1598         } else {
1599             return (true, snapshots.values[index]);
1600         }
1601     }
1602 
1603     function _updateAccountSnapshot(address account) private {
1604         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
1605     }
1606 
1607     function _updateTotalSupplySnapshot() private {
1608         _updateSnapshot(_totalSupplySnapshots, totalSupply());
1609     }
1610 
1611     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
1612         uint256 currentId = _currentSnapshotId.current();
1613         if (_lastSnapshotId(snapshots.ids) < currentId) {
1614             snapshots.ids.push(currentId);
1615             snapshots.values.push(currentValue);
1616         }
1617     }
1618 
1619     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
1620         if (ids.length == 0) {
1621             return 0;
1622         } else {
1623             return ids[ids.length - 1];
1624         }
1625     }
1626 }
1627 
1628 
1629 pragma solidity ^0.6.0;
1630 
1631 
1632 
1633 
1634 
1635 
1636 
1637 abstract contract CMERC20Snapshot is Context, AccessControl, ERC20Snapshot {
1638 
1639     bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");
1640     
1641     function snapshot() public {
1642         require(hasRole(SNAPSHOT_ROLE, _msgSender()), "ERC20Snapshot: must have snapshotter role to snapshot");
1643         _snapshot();
1644     }
1645 
1646 }
1647 
1648 
1649 pragma solidity ^0.6.0;
1650 
1651 // imports
1652 
1653 
1654 
1655 
1656 
1657 contract CMErc20BurnSnap is ERC20Burnable, CMERC20Snapshot,  CM {
1658 
1659     constructor(string memory name, string memory symbol, uint256 amount, uint8 decimals) ERC20(name, symbol) public payable {
1660         _supportCM();
1661         cmContractType = "CMErc20BurnSnap";
1662         _setupDecimals(decimals);
1663         _mint(msg.sender, amount);
1664         
1665         // set up required roles
1666         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1667         _setupRole(SNAPSHOT_ROLE, _msgSender());
1668         
1669         
1670     }
1671 
1672     
1673     // overrides
1674     function _burn(address account, uint256 value) internal override(ERC20, ERC20Snapshot) {
1675         super._burn(account, value);
1676     }
1677 
1678     function _mint(address account, uint256 value) internal override(ERC20, ERC20Snapshot) {
1679         super._mint(account, value);
1680     }
1681 
1682     function _transfer(address from, address to, uint256 value)internal override(ERC20, ERC20Snapshot) {
1683         super._transfer(from, to, value);
1684     }
1685     
1686 
1687 }