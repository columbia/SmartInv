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
817 /**
818  * @dev Library for managing
819  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
820  * types.
821  *
822  * Sets have the following properties:
823  *
824  * - Elements are added, removed, and checked for existence in constant time
825  * (O(1)).
826  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
827  *
828  * ```
829  * contract Example {
830  *     // Add the library methods
831  *     using EnumerableSet for EnumerableSet.AddressSet;
832  *
833  *     // Declare a set state variable
834  *     EnumerableSet.AddressSet private mySet;
835  * }
836  * ```
837  *
838  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
839  * (`UintSet`) are supported.
840  */
841 library EnumerableSet {
842     // To implement this library for multiple types with as little code
843     // repetition as possible, we write it in terms of a generic Set type with
844     // bytes32 values.
845     // The Set implementation uses private functions, and user-facing
846     // implementations (such as AddressSet) are just wrappers around the
847     // underlying Set.
848     // This means that we can only create new EnumerableSets for types that fit
849     // in bytes32.
850 
851     struct Set {
852         // Storage of set values
853         bytes32[] _values;
854 
855         // Position of the value in the `values` array, plus 1 because index 0
856         // means a value is not in the set.
857         mapping (bytes32 => uint256) _indexes;
858     }
859 
860     /**
861      * @dev Add a value to a set. O(1).
862      *
863      * Returns true if the value was added to the set, that is if it was not
864      * already present.
865      */
866     function _add(Set storage set, bytes32 value) private returns (bool) {
867         if (!_contains(set, value)) {
868             set._values.push(value);
869             // The value is stored at length-1, but we add 1 to all indexes
870             // and use 0 as a sentinel value
871             set._indexes[value] = set._values.length;
872             return true;
873         } else {
874             return false;
875         }
876     }
877 
878     /**
879      * @dev Removes a value from a set. O(1).
880      *
881      * Returns true if the value was removed from the set, that is if it was
882      * present.
883      */
884     function _remove(Set storage set, bytes32 value) private returns (bool) {
885         // We read and store the value's index to prevent multiple reads from the same storage slot
886         uint256 valueIndex = set._indexes[value];
887 
888         if (valueIndex != 0) { // Equivalent to contains(set, value)
889             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
890             // the array, and then remove the last element (sometimes called as 'swap and pop').
891             // This modifies the order of the array, as noted in {at}.
892 
893             uint256 toDeleteIndex = valueIndex - 1;
894             uint256 lastIndex = set._values.length - 1;
895 
896             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
897             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
898 
899             bytes32 lastvalue = set._values[lastIndex];
900 
901             // Move the last value to the index where the value to delete is
902             set._values[toDeleteIndex] = lastvalue;
903             // Update the index for the moved value
904             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
905 
906             // Delete the slot where the moved value was stored
907             set._values.pop();
908 
909             // Delete the index for the deleted slot
910             delete set._indexes[value];
911 
912             return true;
913         } else {
914             return false;
915         }
916     }
917 
918     /**
919      * @dev Returns true if the value is in the set. O(1).
920      */
921     function _contains(Set storage set, bytes32 value) private view returns (bool) {
922         return set._indexes[value] != 0;
923     }
924 
925     /**
926      * @dev Returns the number of values on the set. O(1).
927      */
928     function _length(Set storage set) private view returns (uint256) {
929         return set._values.length;
930     }
931 
932    /**
933     * @dev Returns the value stored at position `index` in the set. O(1).
934     *
935     * Note that there are no guarantees on the ordering of values inside the
936     * array, and it may change when more values are added or removed.
937     *
938     * Requirements:
939     *
940     * - `index` must be strictly less than {length}.
941     */
942     function _at(Set storage set, uint256 index) private view returns (bytes32) {
943         require(set._values.length > index, "EnumerableSet: index out of bounds");
944         return set._values[index];
945     }
946 
947     // AddressSet
948 
949     struct AddressSet {
950         Set _inner;
951     }
952 
953     /**
954      * @dev Add a value to a set. O(1).
955      *
956      * Returns true if the value was added to the set, that is if it was not
957      * already present.
958      */
959     function add(AddressSet storage set, address value) internal returns (bool) {
960         return _add(set._inner, bytes32(uint256(value)));
961     }
962 
963     /**
964      * @dev Removes a value from a set. O(1).
965      *
966      * Returns true if the value was removed from the set, that is if it was
967      * present.
968      */
969     function remove(AddressSet storage set, address value) internal returns (bool) {
970         return _remove(set._inner, bytes32(uint256(value)));
971     }
972 
973     /**
974      * @dev Returns true if the value is in the set. O(1).
975      */
976     function contains(AddressSet storage set, address value) internal view returns (bool) {
977         return _contains(set._inner, bytes32(uint256(value)));
978     }
979 
980     /**
981      * @dev Returns the number of values in the set. O(1).
982      */
983     function length(AddressSet storage set) internal view returns (uint256) {
984         return _length(set._inner);
985     }
986 
987    /**
988     * @dev Returns the value stored at position `index` in the set. O(1).
989     *
990     * Note that there are no guarantees on the ordering of values inside the
991     * array, and it may change when more values are added or removed.
992     *
993     * Requirements:
994     *
995     * - `index` must be strictly less than {length}.
996     */
997     function at(AddressSet storage set, uint256 index) internal view returns (address) {
998         return address(uint256(_at(set._inner, index)));
999     }
1000 
1001 
1002     // UintSet
1003 
1004     struct UintSet {
1005         Set _inner;
1006     }
1007 
1008     /**
1009      * @dev Add a value to a set. O(1).
1010      *
1011      * Returns true if the value was added to the set, that is if it was not
1012      * already present.
1013      */
1014     function add(UintSet storage set, uint256 value) internal returns (bool) {
1015         return _add(set._inner, bytes32(value));
1016     }
1017 
1018     /**
1019      * @dev Removes a value from a set. O(1).
1020      *
1021      * Returns true if the value was removed from the set, that is if it was
1022      * present.
1023      */
1024     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1025         return _remove(set._inner, bytes32(value));
1026     }
1027 
1028     /**
1029      * @dev Returns true if the value is in the set. O(1).
1030      */
1031     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1032         return _contains(set._inner, bytes32(value));
1033     }
1034 
1035     /**
1036      * @dev Returns the number of values on the set. O(1).
1037      */
1038     function length(UintSet storage set) internal view returns (uint256) {
1039         return _length(set._inner);
1040     }
1041 
1042    /**
1043     * @dev Returns the value stored at position `index` in the set. O(1).
1044     *
1045     * Note that there are no guarantees on the ordering of values inside the
1046     * array, and it may change when more values are added or removed.
1047     *
1048     * Requirements:
1049     *
1050     * - `index` must be strictly less than {length}.
1051     */
1052     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1053         return uint256(_at(set._inner, index));
1054     }
1055 }
1056 
1057 
1058 // Partial License: MIT
1059 
1060 pragma solidity ^0.6.0;
1061 
1062 
1063 
1064 
1065 
1066 /**
1067  * @dev Contract module that allows children to implement role-based access
1068  * control mechanisms.
1069  *
1070  * Roles are referred to by their `bytes32` identifier. These should be exposed
1071  * in the external API and be unique. The best way to achieve this is by
1072  * using `public constant` hash digests:
1073  *
1074  * ```
1075  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1076  * ```
1077  *
1078  * Roles can be used to represent a set of permissions. To restrict access to a
1079  * function call, use {hasRole}:
1080  *
1081  * ```
1082  * function foo() public {
1083  *     require(hasRole(MY_ROLE, msg.sender));
1084  *     ...
1085  * }
1086  * ```
1087  *
1088  * Roles can be granted and revoked dynamically via the {grantRole} and
1089  * {revokeRole} functions. Each role has an associated admin role, and only
1090  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1091  *
1092  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1093  * that only accounts with this role will be able to grant or revoke other
1094  * roles. More complex role relationships can be created by using
1095  * {_setRoleAdmin}.
1096  *
1097  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1098  * grant and revoke this role. Extra precautions should be taken to secure
1099  * accounts that have been granted it.
1100  */
1101 abstract contract AccessControl is Context {
1102     using EnumerableSet for EnumerableSet.AddressSet;
1103     using Address for address;
1104 
1105     struct RoleData {
1106         EnumerableSet.AddressSet members;
1107         bytes32 adminRole;
1108     }
1109 
1110     mapping (bytes32 => RoleData) private _roles;
1111 
1112     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1113 
1114     /**
1115      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1116      *
1117      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1118      * {RoleAdminChanged} not being emitted signaling this.
1119      *
1120      * _Available since v3.1._
1121      */
1122     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1123 
1124     /**
1125      * @dev Emitted when `account` is granted `role`.
1126      *
1127      * `sender` is the account that originated the contract call, an admin role
1128      * bearer except when using {_setupRole}.
1129      */
1130     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1131 
1132     /**
1133      * @dev Emitted when `account` is revoked `role`.
1134      *
1135      * `sender` is the account that originated the contract call:
1136      *   - if using `revokeRole`, it is the admin role bearer
1137      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1138      */
1139     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1140 
1141     /**
1142      * @dev Returns `true` if `account` has been granted `role`.
1143      */
1144     function hasRole(bytes32 role, address account) public view returns (bool) {
1145         return _roles[role].members.contains(account);
1146     }
1147 
1148     /**
1149      * @dev Returns the number of accounts that have `role`. Can be used
1150      * together with {getRoleMember} to enumerate all bearers of a role.
1151      */
1152     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1153         return _roles[role].members.length();
1154     }
1155 
1156     /**
1157      * @dev Returns one of the accounts that have `role`. `index` must be a
1158      * value between 0 and {getRoleMemberCount}, non-inclusive.
1159      *
1160      * Role bearers are not sorted in any particular way, and their ordering may
1161      * change at any point.
1162      *
1163      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1164      * you perform all queries on the same block. See the following
1165      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1166      * for more information.
1167      */
1168     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1169         return _roles[role].members.at(index);
1170     }
1171 
1172     /**
1173      * @dev Returns the admin role that controls `role`. See {grantRole} and
1174      * {revokeRole}.
1175      *
1176      * To change a role's admin, use {_setRoleAdmin}.
1177      */
1178     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1179         return _roles[role].adminRole;
1180     }
1181 
1182     /**
1183      * @dev Grants `role` to `account`.
1184      *
1185      * If `account` had not been already granted `role`, emits a {RoleGranted}
1186      * event.
1187      *
1188      * Requirements:
1189      *
1190      * - the caller must have ``role``'s admin role.
1191      */
1192     function grantRole(bytes32 role, address account) public virtual {
1193         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1194 
1195         _grantRole(role, account);
1196     }
1197 
1198     /**
1199      * @dev Revokes `role` from `account`.
1200      *
1201      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1202      *
1203      * Requirements:
1204      *
1205      * - the caller must have ``role``'s admin role.
1206      */
1207     function revokeRole(bytes32 role, address account) public virtual {
1208         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1209 
1210         _revokeRole(role, account);
1211     }
1212 
1213     /**
1214      * @dev Revokes `role` from the calling account.
1215      *
1216      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1217      * purpose is to provide a mechanism for accounts to lose their privileges
1218      * if they are compromised (such as when a trusted device is misplaced).
1219      *
1220      * If the calling account had been granted `role`, emits a {RoleRevoked}
1221      * event.
1222      *
1223      * Requirements:
1224      *
1225      * - the caller must be `account`.
1226      */
1227     function renounceRole(bytes32 role, address account) public virtual {
1228         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1229 
1230         _revokeRole(role, account);
1231     }
1232 
1233     /**
1234      * @dev Grants `role` to `account`.
1235      *
1236      * If `account` had not been already granted `role`, emits a {RoleGranted}
1237      * event. Note that unlike {grantRole}, this function doesn't perform any
1238      * checks on the calling account.
1239      *
1240      * [WARNING]
1241      * ====
1242      * This function should only be called from the constructor when setting
1243      * up the initial roles for the system.
1244      *
1245      * Using this function in any other way is effectively circumventing the admin
1246      * system imposed by {AccessControl}.
1247      * ====
1248      */
1249     function _setupRole(bytes32 role, address account) internal virtual {
1250         _grantRole(role, account);
1251     }
1252 
1253     /**
1254      * @dev Sets `adminRole` as ``role``'s admin role.
1255      *
1256      * Emits a {RoleAdminChanged} event.
1257      */
1258     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1259         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1260         _roles[role].adminRole = adminRole;
1261     }
1262 
1263     function _grantRole(bytes32 role, address account) private {
1264         if (_roles[role].members.add(account)) {
1265             emit RoleGranted(role, account, _msgSender());
1266         }
1267     }
1268 
1269     function _revokeRole(bytes32 role, address account) private {
1270         if (_roles[role].members.remove(account)) {
1271             emit RoleRevoked(role, account, _msgSender());
1272         }
1273     }
1274 }
1275 
1276 
1277 // Partial License: MIT
1278 
1279 pragma solidity ^0.6.0;
1280 
1281 
1282 
1283 
1284 /**
1285  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1286  * tokens and those that they have an allowance for, in a way that can be
1287  * recognized off-chain (via event analysis).
1288  */
1289 abstract contract ERC20Burnable is Context, ERC20 {
1290     /**
1291      * @dev Destroys `amount` tokens from the caller.
1292      *
1293      * See {ERC20-_burn}.
1294      */
1295     function burn(uint256 amount) public virtual {
1296         _burn(_msgSender(), amount);
1297     }
1298 
1299     /**
1300      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1301      * allowance.
1302      *
1303      * See {ERC20-_burn} and {ERC20-allowance}.
1304      *
1305      * Requirements:
1306      *
1307      * - the caller must have allowance for ``accounts``'s tokens of at least
1308      * `amount`.
1309      */
1310     function burnFrom(address account, uint256 amount) public virtual {
1311         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1312 
1313         _approve(account, _msgSender(), decreasedAllowance);
1314         _burn(account, amount);
1315     }
1316 }
1317 
1318 
1319 // Partial License: MIT
1320 
1321 pragma solidity ^0.6.0;
1322 
1323 
1324 
1325 /**
1326  * @dev Contract module which allows children to implement an emergency stop
1327  * mechanism that can be triggered by an authorized account.
1328  *
1329  * This module is used through inheritance. It will make available the
1330  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1331  * the functions of your contract. Note that they will not be pausable by
1332  * simply including this module, only once the modifiers are put in place.
1333  */
1334 contract Pausable is Context {
1335     /**
1336      * @dev Emitted when the pause is triggered by `account`.
1337      */
1338     event Paused(address account);
1339 
1340     /**
1341      * @dev Emitted when the pause is lifted by `account`.
1342      */
1343     event Unpaused(address account);
1344 
1345     bool private _paused;
1346 
1347     /**
1348      * @dev Initializes the contract in unpaused state.
1349      */
1350     constructor () internal {
1351         _paused = false;
1352     }
1353 
1354     /**
1355      * @dev Returns true if the contract is paused, and false otherwise.
1356      */
1357     function paused() public view returns (bool) {
1358         return _paused;
1359     }
1360 
1361     /**
1362      * @dev Modifier to make a function callable only when the contract is not paused.
1363      *
1364      * Requirements:
1365      *
1366      * - The contract must not be paused.
1367      */
1368     modifier whenNotPaused() {
1369         require(!_paused, "Pausable: paused");
1370         _;
1371     }
1372 
1373     /**
1374      * @dev Modifier to make a function callable only when the contract is paused.
1375      *
1376      * Requirements:
1377      *
1378      * - The contract must be paused.
1379      */
1380     modifier whenPaused() {
1381         require(_paused, "Pausable: not paused");
1382         _;
1383     }
1384 
1385     /**
1386      * @dev Triggers stopped state.
1387      *
1388      * Requirements:
1389      *
1390      * - The contract must not be paused.
1391      */
1392     function _pause() internal virtual whenNotPaused {
1393         _paused = true;
1394         emit Paused(_msgSender());
1395     }
1396 
1397     /**
1398      * @dev Returns to normal state.
1399      *
1400      * Requirements:
1401      *
1402      * - The contract must be paused.
1403      */
1404     function _unpause() internal virtual whenPaused {
1405         _paused = false;
1406         emit Unpaused(_msgSender());
1407     }
1408 }
1409 
1410 
1411 // Partial License: MIT
1412 
1413 pragma solidity ^0.6.0;
1414 
1415 
1416 
1417 
1418 /**
1419  * @dev ERC20 token with pausable token transfers, minting and burning.
1420  *
1421  * Useful for scenarios such as preventing trades until the end of an evaluation
1422  * period, or having an emergency switch for freezing all token transfers in the
1423  * event of a large bug.
1424  */
1425 abstract contract ERC20Pausable is ERC20, Pausable {
1426     /**
1427      * @dev See {ERC20-_beforeTokenTransfer}.
1428      *
1429      * Requirements:
1430      *
1431      * - the contract must not be paused.
1432      */
1433     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
1434         super._beforeTokenTransfer(from, to, amount);
1435 
1436         require(!paused(), "ERC20Pausable: token transfer while paused");
1437     }
1438 }
1439 
1440 
1441 pragma solidity ^0.6.0;
1442 
1443 
1444 
1445 
1446 
1447 
1448 
1449 
1450 
1451 abstract contract CMERC20Mintable is Context, AccessControl, ERC20 {
1452 
1453     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1454     
1455     function mint(address to, uint256 amount) public {
1456         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20Minter: must have minter role to mint");
1457         _mint(to, amount);
1458     }
1459 }
1460 
1461 
1462 pragma solidity ^0.6.0;
1463 
1464 
1465 
1466 
1467 
1468 
1469 
1470 abstract contract CMERC20Pausable is Context, AccessControl, ERC20Pausable {
1471 
1472     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1473     
1474     function pause() public {
1475         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20Pauser: must have pauser role to pause");
1476         _pause();
1477     }
1478 
1479     function unpause() public {
1480         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20Pauser: must have pauser role to unpause");
1481         _unpause();
1482     }
1483 }
1484 
1485 
1486 // Partial License: MIT
1487 
1488 pragma solidity ^0.6.0;
1489 
1490 /**
1491  * @dev Standard math utilities missing in the Solidity language.
1492  */
1493 library Math {
1494     /**
1495      * @dev Returns the largest of two numbers.
1496      */
1497     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1498         return a >= b ? a : b;
1499     }
1500 
1501     /**
1502      * @dev Returns the smallest of two numbers.
1503      */
1504     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1505         return a < b ? a : b;
1506     }
1507 
1508     /**
1509      * @dev Returns the average of two numbers. The result is rounded towards
1510      * zero.
1511      */
1512     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1513         // (a + b) / 2 can overflow, so we distribute
1514         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
1515     }
1516 }
1517 
1518 
1519 // Partial License: MIT
1520 
1521 pragma solidity ^0.6.0;
1522 
1523 
1524 
1525 /**
1526  * @dev Collection of functions related to array types.
1527  */
1528 library Arrays {
1529    /**
1530      * @dev Searches a sorted `array` and returns the first index that contains
1531      * a value greater or equal to `element`. If no such index exists (i.e. all
1532      * values in the array are strictly less than `element`), the array length is
1533      * returned. Time complexity O(log n).
1534      *
1535      * `array` is expected to be sorted in ascending order, and to contain no
1536      * repeated elements.
1537      */
1538     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
1539         if (array.length == 0) {
1540             return 0;
1541         }
1542 
1543         uint256 low = 0;
1544         uint256 high = array.length;
1545 
1546         while (low < high) {
1547             uint256 mid = Math.average(low, high);
1548 
1549             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
1550             // because Math.average rounds down (it does integer division with truncation).
1551             if (array[mid] > element) {
1552                 high = mid;
1553             } else {
1554                 low = mid + 1;
1555             }
1556         }
1557 
1558         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
1559         if (low > 0 && array[low - 1] == element) {
1560             return low - 1;
1561         } else {
1562             return low;
1563         }
1564     }
1565 }
1566 
1567 
1568 // Partial License: MIT
1569 
1570 pragma solidity ^0.6.0;
1571 
1572 
1573 
1574 /**
1575  * @title Counters
1576  * @author Matt Condon (@shrugs)
1577  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1578  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1579  *
1580  * Include with `using Counters for Counters.Counter;`
1581  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1582  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1583  * directly accessed.
1584  */
1585 library Counters {
1586     using SafeMath for uint256;
1587 
1588     struct Counter {
1589         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1590         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1591         // this feature: see https://github.com/ethereum/solidity/issues/4637
1592         uint256 _value; // default: 0
1593     }
1594 
1595     function current(Counter storage counter) internal view returns (uint256) {
1596         return counter._value;
1597     }
1598 
1599     function increment(Counter storage counter) internal {
1600         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1601         counter._value += 1;
1602     }
1603 
1604     function decrement(Counter storage counter) internal {
1605         counter._value = counter._value.sub(1);
1606     }
1607 }
1608 
1609 
1610 // Partial License: MIT
1611 
1612 pragma solidity ^0.6.0;
1613 
1614 
1615 
1616 
1617 
1618 
1619 /**
1620  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
1621  * total supply at the time are recorded for later access.
1622  *
1623  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
1624  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
1625  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
1626  * used to create an efficient ERC20 forking mechanism.
1627  *
1628  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
1629  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
1630  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
1631  * and the account address.
1632  *
1633  * ==== Gas Costs
1634  *
1635  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
1636  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
1637  * smaller since identical balances in subsequent snapshots are stored as a single entry.
1638  *
1639  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
1640  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
1641  * transfers will have normal cost until the next snapshot, and so on.
1642  */
1643 abstract contract ERC20Snapshot is ERC20 {
1644     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
1645     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
1646 
1647     using SafeMath for uint256;
1648     using Arrays for uint256[];
1649     using Counters for Counters.Counter;
1650 
1651     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
1652     // Snapshot struct, but that would impede usage of functions that work on an array.
1653     struct Snapshots {
1654         uint256[] ids;
1655         uint256[] values;
1656     }
1657 
1658     mapping (address => Snapshots) private _accountBalanceSnapshots;
1659     Snapshots private _totalSupplySnapshots;
1660 
1661     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
1662     Counters.Counter private _currentSnapshotId;
1663 
1664     /**
1665      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
1666      */
1667     event Snapshot(uint256 id);
1668 
1669     /**
1670      * @dev Creates a new snapshot and returns its snapshot id.
1671      *
1672      * Emits a {Snapshot} event that contains the same id.
1673      *
1674      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
1675      * set of accounts, for example using {AccessControl}, or it may be open to the public.
1676      *
1677      * [WARNING]
1678      * ====
1679      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
1680      * you must consider that it can potentially be used by attackers in two ways.
1681      *
1682      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
1683      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
1684      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
1685      * section above.
1686      *
1687      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
1688      * ====
1689      */
1690     function _snapshot() internal virtual returns (uint256) {
1691         _currentSnapshotId.increment();
1692 
1693         uint256 currentId = _currentSnapshotId.current();
1694         emit Snapshot(currentId);
1695         return currentId;
1696     }
1697 
1698     /**
1699      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
1700      */
1701     function balanceOfAt(address account, uint256 snapshotId) public view returns (uint256) {
1702         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
1703 
1704         return snapshotted ? value : balanceOf(account);
1705     }
1706 
1707     /**
1708      * @dev Retrieves the total supply at the time `snapshotId` was created.
1709      */
1710     function totalSupplyAt(uint256 snapshotId) public view returns(uint256) {
1711         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
1712 
1713         return snapshotted ? value : totalSupply();
1714     }
1715 
1716     // _transfer, _mint and _burn are the only functions where the balances are modified, so it is there that the
1717     // snapshots are updated. Note that the update happens _before_ the balance change, with the pre-modified value.
1718     // The same is true for the total supply and _mint and _burn.
1719     function _transfer(address from, address to, uint256 value) internal virtual override {
1720         _updateAccountSnapshot(from);
1721         _updateAccountSnapshot(to);
1722 
1723         super._transfer(from, to, value);
1724     }
1725 
1726     function _mint(address account, uint256 value) internal virtual override {
1727         _updateAccountSnapshot(account);
1728         _updateTotalSupplySnapshot();
1729 
1730         super._mint(account, value);
1731     }
1732 
1733     function _burn(address account, uint256 value) internal virtual override {
1734         _updateAccountSnapshot(account);
1735         _updateTotalSupplySnapshot();
1736 
1737         super._burn(account, value);
1738     }
1739 
1740     function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
1741         private view returns (bool, uint256)
1742     {
1743         require(snapshotId > 0, "ERC20Snapshot: id is 0");
1744         // solhint-disable-next-line max-line-length
1745         require(snapshotId <= _currentSnapshotId.current(), "ERC20Snapshot: nonexistent id");
1746 
1747         // When a valid snapshot is queried, there are three possibilities:
1748         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
1749         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
1750         //  to this id is the current one.
1751         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
1752         //  requested id, and its value is the one to return.
1753         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
1754         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
1755         //  larger than the requested one.
1756         //
1757         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
1758         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
1759         // exactly this.
1760 
1761         uint256 index = snapshots.ids.findUpperBound(snapshotId);
1762 
1763         if (index == snapshots.ids.length) {
1764             return (false, 0);
1765         } else {
1766             return (true, snapshots.values[index]);
1767         }
1768     }
1769 
1770     function _updateAccountSnapshot(address account) private {
1771         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
1772     }
1773 
1774     function _updateTotalSupplySnapshot() private {
1775         _updateSnapshot(_totalSupplySnapshots, totalSupply());
1776     }
1777 
1778     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
1779         uint256 currentId = _currentSnapshotId.current();
1780         if (_lastSnapshotId(snapshots.ids) < currentId) {
1781             snapshots.ids.push(currentId);
1782             snapshots.values.push(currentValue);
1783         }
1784     }
1785 
1786     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
1787         if (ids.length == 0) {
1788             return 0;
1789         } else {
1790             return ids[ids.length - 1];
1791         }
1792     }
1793 }
1794 
1795 
1796 pragma solidity ^0.6.0;
1797 
1798 
1799 
1800 
1801 
1802 
1803 
1804 abstract contract CMERC20Snapshot is Context, AccessControl, ERC20Snapshot {
1805 
1806     bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");
1807     
1808     function snapshot() public {
1809         require(hasRole(SNAPSHOT_ROLE, _msgSender()), "ERC20Snapshot: must have snapshotter role to snapshot");
1810         _snapshot();
1811     }
1812 
1813 }
1814 
1815 
1816 pragma solidity ^0.6.0;
1817 
1818 // imports
1819 
1820 
1821 
1822 
1823 
1824 
1825 
1826 contract CMErc20MintBurnPauseSnap is CMERC20Mintable, ERC20Burnable, CMERC20Pausable, CMERC20Snapshot,  CM {
1827 
1828     constructor(string memory name, string memory symbol, uint256 amount, uint8 decimals) ERC20(name, symbol) public payable {
1829         _supportCM();
1830         cmContractType = "CMErc20MintBurnPauseSnap";
1831         _setupDecimals(decimals);
1832         _mint(msg.sender, amount);
1833         
1834         // set up required roles
1835         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1836         _setupRole(MINTER_ROLE, _msgSender());
1837         _setupRole(PAUSER_ROLE, _msgSender());
1838         _setupRole(SNAPSHOT_ROLE, _msgSender());
1839         
1840         
1841     }
1842 
1843     
1844     // overrides
1845     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Pausable) {
1846         super._beforeTokenTransfer(from, to, amount);
1847 	}function _burn(address account, uint256 value) internal override(ERC20, ERC20Snapshot) {
1848         super._burn(account, value);
1849     }
1850 
1851     function _mint(address account, uint256 value) internal override(ERC20, ERC20Snapshot) {
1852         super._mint(account, value);
1853     }
1854 
1855     function _transfer(address from, address to, uint256 value)internal override(ERC20, ERC20Snapshot) {
1856         super._transfer(from, to, value);
1857     }
1858     
1859 
1860 }