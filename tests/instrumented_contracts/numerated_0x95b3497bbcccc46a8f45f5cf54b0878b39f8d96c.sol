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
855 pragma solidity ^0.6.0;
856 
857 // imports
858 
859 
860 
861 
862 contract CMErc20Burn is ERC20Burnable,  CM {
863 
864     constructor(string memory name, string memory symbol, uint256 amount, uint8 decimals) ERC20(name, symbol) public payable {
865         _supportCM();
866         cmContractType = "CMErc20Burn";
867         _setupDecimals(decimals);
868         _mint(msg.sender, amount);
869         
870     }
871 
872     
873 
874 }