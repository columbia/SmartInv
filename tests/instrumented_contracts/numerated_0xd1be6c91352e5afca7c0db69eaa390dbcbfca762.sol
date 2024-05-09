1 /**
2 
3 /*
4 
5 /// ██╗  ░█████╗░███╗░░░███╗  ███████╗██████╗░░█████╗░░██████╗░░░░ ///
6 /// ██║  ██╔══██╗████╗░████║  ██╔════╝██╔══██╗██╔══██╗██╔════╝░░░░ ///
7 /// ██║  ███████║██╔████╔██║  █████╗░░██████╔╝██║░░██║██║░░██╗░░░░ ///
8 /// ██║  ██╔══██║██║╚██╔╝██║  ██╔══╝░░██╔══██╗██║░░██║██║░░╚██╗░░░ ///
9 /// ██║  ██║░░██║██║░╚═╝░██║  ██║░░░░░██║░░██║╚█████╔╝╚██████╔╝██╗ ///
10 /// ╚═╝  ╚═╝░░╚═╝╚═╝░░░░░╚═╝  ╚═╝░░░░░╚═╝░░╚═╝░╚════╝░░╚═════╝░╚═╝ ///
11 
12 /// LQNTY's Liquidity is Perma-Locked in this contract
13 /// Liquinity's Auto-Burn LP Token prohibits a malicious actor from removing LP
14 /// even if the malicious actor is me
15 
16 /// The only LP that will be burned is Liquidity bought by the contract
17 /// How much liquidity is locked and burned is proportional to LQNTY's market cap
18 /// Even you can add your own liquidity, because liquidity
19 /// enables free markets to be free
20 /// Liquinity is a free market
21 
22 /// Trust in defi has been abused
23 /// LQNTY is a shield
24 
25 /// Total Supply: 100,000,000,000.00 (100B) $LQNTY 
26 /// Taxes: 7/7%, all of which the Contract allocates to LP
27 
28 /// 50% Tax for the first 60 seconds as Anti-Bot as Contract has no _deadBlock 
29 
30 /// Taxes will decrease to:
31 
32 /// 6/6% @ $5,000,000 Market Cap
33 /// 5/5% @ $10,000,000 Market Cap
34 /// 4/4% @ $15,000,000 Market Cap
35 /// 3/3% @ $25,000,000 Market Cap
36 /// 2/2% @ $35,000,000 Market Cap
37 /// 1/1% @ $45,000,000 Market Cap
38 /// 0%/1% @ $50,000,000 Market Cap
39 /// 0%/0% @ $100,000,000 Market Cap + 
40 
41 /// 100% of taxes collected are added to the contract 
42 /// and introduced into the LQNTY Liquidity Pool 
43 
44 /// https://t.me/LQNTY_portal
45 /// Community Admins will be assigned.
46 /// https://liquinity.io/ 
47 /// https://twitter.com/lqnty_token
48 
49 /// DApp soon...
50 
51 /// I am Frog.
52 
53 pragma solidity ^0.6.0;
54 
55 // Dependency file: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/Context.sol
56 
57 // SPDX-License-Identifier: MIT
58 
59 // pragma solidity ^0.6.0;
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
82 // Dependency file: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
83 
84 // pragma solidity ^0.6.0;
85 
86 // import "@openzeppelin/contracts/GSN/Context.sol";
87 /**
88  * @dev Contract module which provides a basic access control mechanism, where
89  * there is an account (an owner) that can be granted exclusive access to
90  * specific functions.
91  *
92  * By default, the owner account will be the one that deploys the contract. This
93  * can later be changed with {transferOwnership}.
94  *
95  * This module is used through inheritance. It will make available the modifier
96  * `onlyOwner`, which can be applied to your functions to restrict their use to
97  * the owner.
98  */
99 contract Ownable is Context {
100     address private _owner;
101 
102     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
103 
104     /**
105      * @dev Initializes the contract setting the deployer as the initial owner.
106      */
107     constructor () internal {
108         address msgSender = _msgSender();
109         _owner = msgSender;
110         emit OwnershipTransferred(address(0), msgSender);
111     }
112 
113     /**
114      * @dev Returns the address of the current owner.
115      */
116     function owner() public view returns (address) {
117         return _owner;
118     }
119 
120     /**
121      * @dev Throws if called by any account other than the owner.
122      */
123     modifier onlyOwner() {
124         require(_owner == _msgSender(), "Ownable: caller is not the owner");
125         _;
126     }
127 
128     /**
129      * @dev Leaves the contract without owner. It will not be possible to call
130      * `onlyOwner` functions anymore. Can only be called by the current owner.
131      *
132      * NOTE: Renouncing ownership will leave the contract without an owner,
133      * thereby removing any functionality that is only available to the owner.
134      */
135     function renounceOwnership() public virtual onlyOwner {
136         emit OwnershipTransferred(_owner, address(0));
137         _owner = address(0);
138     }
139 
140     /**
141      * @dev Transfers ownership of the contract to a new account (`newOwner`).
142      * Can only be called by the current owner.
143      */
144     function transferOwnership(address newOwner) public virtual onlyOwner {
145         require(newOwner != address(0), "Ownable: new owner is the zero address");
146         emit OwnershipTransferred(_owner, newOwner);
147         _owner = newOwner;
148     }
149 }
150 
151 // pragma solidity ^0.6.0;
152 
153 /**
154  * @dev Wrappers over Solidity's arithmetic operations with added overflow
155  * checks.
156  *
157  * Arithmetic operations in Solidity wrap on overflow. This can easily result
158  * in bugs, because programmers usually assume that an overflow raises an
159  * error, which is the standard behavior in high level programming languages.
160  * `SafeMath` restores this intuition by reverting the transaction when an
161  * operation overflows.
162  *
163  * Using this library instead of the unchecked operations eliminates an entire
164  * class of bugs, so it's recommended to use it always.
165  */
166 library SafeMath {
167     /**
168      * @dev Returns the addition of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `+` operator.
172      *
173      * Requirements:
174      *
175      * - Addition cannot overflow.
176      */
177     function add(uint256 a, uint256 b) internal pure returns (uint256) {
178         uint256 c = a + b;
179         require(c >= a, "SafeMath: addition overflow");
180 
181         return c;
182     }
183 
184     /**
185      * @dev Returns the subtraction of two unsigned integers, reverting on
186      * overflow (when the result is negative).
187      *
188      * Counterpart to Solidity's `-` operator.
189      *
190      * Requirements:
191      *
192      * - Subtraction cannot overflow.
193      */
194     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
195         return sub(a, b, "SafeMath: subtraction overflow");
196     }
197 
198     /**
199      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
200      * overflow (when the result is negative).
201      *
202      * Counterpart to Solidity's `-` operator.
203      *
204      * Requirements:
205      *
206      * - Subtraction cannot overflow.
207      */
208     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
209         require(b <= a, errorMessage);
210         uint256 c = a - b;
211 
212         return c;
213     }
214 
215     /**
216      * @dev Returns the multiplication of two unsigned integers, reverting on
217      * overflow.
218      *
219      * Counterpart to Solidity's `*` operator.
220      *
221      * Requirements:
222      *
223      * - Multiplication cannot overflow.
224      */
225     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
226         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
227         // benefit is lost if 'b' is also tested.
228         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
229         if (a == 0) {
230             return 0;
231         }
232 
233         uint256 c = a * b;
234         require(c / a == b, "SafeMath: multiplication overflow");
235 
236         return c;
237     }
238 
239     /**
240      * @dev Returns the integer division of two unsigned integers. Reverts on
241      * division by zero. The result is rounded towards zero.
242      *
243      * Counterpart to Solidity's `/` operator. Note: this function uses a
244      * `revert` opcode (which leaves remaining gas untouched) while Solidity
245      * uses an invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function div(uint256 a, uint256 b) internal pure returns (uint256) {
252         return div(a, b, "SafeMath: division by zero");
253     }
254 
255     /**
256      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
257      * division by zero. The result is rounded towards zero.
258      *
259      * Counterpart to Solidity's `/` operator. Note: this function uses a
260      * `revert` opcode (which leaves remaining gas untouched) while Solidity
261      * uses an invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      *
265      * - The divisor cannot be zero.
266      */
267     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
268         require(b > 0, errorMessage);
269         uint256 c = a / b;
270         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
271 
272         return c;
273     }
274 
275     /**
276      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
277      * Reverts when dividing by zero.
278      *
279      * Counterpart to Solidity's `%` operator. This function uses a `revert`
280      * opcode (which leaves remaining gas untouched) while Solidity uses an
281      * invalid opcode to revert (consuming all remaining gas).
282      *
283      * Requirements:
284      *
285      * - The divisor cannot be zero.
286      */
287     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
288         return mod(a, b, "SafeMath: modulo by zero");
289     }
290 
291     /**
292      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
293      * Reverts with custom message when dividing by zero.
294      *
295      * Counterpart to Solidity's `%` operator. This function uses a `revert`
296      * opcode (which leaves remaining gas untouched) while Solidity uses an
297      * invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      *
301      * - The divisor cannot be zero.
302      */
303     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
304         require(b != 0, errorMessage);
305         return a % b;
306     }
307 }
308 
309 
310 // Dependency file: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
311 
312 
313 // pragma solidity ^0.6.0;
314 
315 /**
316  * @dev Interface of the ERC20 standard as defined in the EIP.
317  */
318 interface IERC20 {
319     /**
320      * @dev Returns the amount of tokens in existence.
321      */
322     function totalSupply() external view returns (uint256);
323 
324     /**
325      * @dev Returns the amount of tokens owned by `account`.
326      */
327     function balanceOf(address account) external view returns (uint256);
328 
329     /**
330      * @dev Moves `amount` tokens from the caller's account to `recipient`.
331      *
332      * Returns a boolean value indicating whether the operation succeeded.
333      *
334      * Emits a {Transfer} event.
335      */
336     function transfer(address recipient, uint256 amount) external returns (bool);
337 
338     /**
339      * @dev Returns the remaining number of tokens that `spender` will be
340      * allowed to spend on behalf of `owner` through {transferFrom}. This is
341      * zero by default.
342      *
343      * This value changes when {approve} or {transferFrom} are called.
344      */
345     function allowance(address owner, address spender) external view returns (uint256);
346 
347     /**
348      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
349      *
350      * Returns a boolean value indicating whether the operation succeeded.
351      *
352      * // importANT: Beware that changing an allowance with this method brings the risk
353      * that someone may use both the old and the new allowance by unfortunate
354      * transaction ordering. One possible solution to mitigate this race
355      * condition is to first reduce the spender's allowance to 0 and set the
356      * desired value afterwards:
357      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
358      *
359      * Emits an {Approval} event.
360      */
361     function approve(address spender, uint256 amount) external returns (bool);
362 
363     /**
364      * @dev Moves `amount` tokens from `sender` to `recipient` using the
365      * allowance mechanism. `amount` is then deducted from the caller's
366      * allowance.
367      *
368      * Returns a boolean value indicating whether the operation succeeded.
369      *
370      * Emits a {Transfer} event.
371      */
372     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
373 
374     /**
375      * @dev Emitted when `value` tokens are moved from one account (`from`) to
376      * another (`to`).
377      *
378      * Note that `value` may be zero.
379      */
380     event Transfer(address indexed from, address indexed to, uint256 value);
381 
382     /**
383      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
384      * a call to {approve}. `value` is the new allowance.
385      */
386     event Approval(address indexed owner, address indexed spender, uint256 value);
387 }
388 
389 
390 // Dependency file: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.soll
391 
392 
393 
394 // pragma solidity ^0.6.2;
395 
396 /**
397  * @dev Collection of functions related to the address type
398  */
399 library Address {
400     /**
401      * @dev Returns true if `account` is a contract.
402      *
403      * [// importANT]
404      * ====
405      * It is unsafe to assume that an address for which this function returns
406      * false is an externally-owned account (EOA) and not a contract.
407      *
408      * Among others, `isContract` will return false for the following
409      * types of addresses:
410      *
411      *  - an externally-owned account
412      *  - a contract in construction
413      *  - an address where a contract will be created
414      *  - an address where a contract lived, but was destroyed
415      * ====
416      */
417     function isContract(address account) internal view returns (bool) {
418         // This method relies in extcodesize, which returns 0 for contracts in
419         // construction, since the code is only stored at the end of the
420         // constructor execution.
421 
422         uint256 size;
423         // solhint-disable-next-line no-inline-assembly
424         assembly { size := extcodesize(account) }
425         return size > 0;
426     }
427 
428     /**
429      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
430      * `recipient`, forwarding all available gas and reverting on errors.
431      *
432      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
433      * of certain opcodes, possibly making contracts go over the 2300 gas limit
434      * imposed by `transfer`, making them unable to receive funds via
435      * `transfer`. {sendValue} removes this limitation.
436      *
437      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
438      *
439      * // importANT: because control is transferred to `recipient`, care must be
440      * taken to not create reentrancy vulnerabilities. Consider using
441      * {ReentrancyGuard} or the
442      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
443      */
444     function sendValue(address payable recipient, uint256 amount) internal {
445         require(address(this).balance >= amount, "Address: insufficient balance");
446 
447         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
448         (bool success, ) = recipient.call{ value: amount }("");
449         require(success, "Address: unable to send value, recipient may have reverted");
450     }
451 
452     /**
453      * @dev Performs a Solidity function call using a low level `call`. A
454      * plain`call` is an unsafe replacement for a function call: use this
455      * function instead.
456      *
457      * If `target` reverts with a revert reason, it is bubbled up by this
458      * function (like regular Solidity function calls).
459      *
460      * Returns the raw returned data. To convert to the expected return value,
461      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
462      *
463      * Requirements:
464      *
465      * - `target` must be a contract.
466      * - calling `target` with `data` must not revert.
467      *
468      * _Available since v3.1._
469      */
470     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
471       return functionCall(target, data, "Address: low-level call failed");
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
476      * `errorMessage` as a fallback revert reason when `target` reverts.
477      *
478      * _Available since v3.1._
479      */
480     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
481         return _functionCallWithValue(target, data, 0, errorMessage);
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
486      * but also transferring `value` wei to `target`.
487      *
488      * Requirements:
489      *
490      * - the calling contract must have an ETH balance of at least `value`.
491      * - the called Solidity function must be `payable`.
492      *
493      * _Available since v3.1._
494      */
495     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
496         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
501      * with `errorMessage` as a fallback revert reason when `target` reverts.
502      *
503      * _Available since v3.1._
504      */
505     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
506         require(address(this).balance >= value, "Address: insufficient balance for call");
507         return _functionCallWithValue(target, data, value, errorMessage);
508     }
509 
510     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
511         require(isContract(target), "Address: call to non-contract");
512 
513         // solhint-disable-next-line avoid-low-level-calls
514         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
515         if (success) {
516             return returndata;
517         } else {
518             // Look for revert reason and bubble it up if present
519             if (returndata.length > 0) {
520                 // The easiest way to bubble the revert reason is using memory via assembly
521 
522                 // solhint-disable-next-line no-inline-assembly
523                 assembly {
524                     let returndata_size := mload(returndata)
525                     revert(add(32, returndata), returndata_size)
526                 }
527             } else {
528                 revert(errorMessage);
529             }
530         }
531     }
532 }
533 
534 
535 // Dependency file: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
536 
537 
538 
539 // pragma solidity ^0.6.0;
540 
541 // import "@openzeppelin/contracts/GSN/Context.sol";
542 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
543 // import "@openzeppelin/contracts/math/SafeMath.sol";
544 // import "@openzeppelin/contracts/utils/Address.sol";
545 
546 /**
547  * @dev Implementation of the {IERC20} interface.
548  *
549  * This implementation is agnostic to the way tokens are created. This means
550  * that a supply mechanism has to be added in a derived contract using {_mint}.
551  * For a generic mechanism see {ERC20PresetMinterPauser}.
552  *
553  * TIP: For a detailed writeup see our guide
554  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
555  * to implement supply mechanisms].
556  *
557  * We have followed general OpenZeppelin guidelines: functions revert instead
558  * of returning `false` on failure. This behavior is nonetheless conventional
559  * and does not conflict with the expectations of ERC20 applications.
560  *
561  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
562  * This allows applications to reconstruct the allowance for all accounts just
563  * by listening to said events. Other implementations of the EIP may not emit
564  * these events, as it isn't required by the specification.
565  *
566  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
567  * functions have been added to mitigate the well-known issues around setting
568  * allowances. See {IERC20-approve}.
569  */
570 contract ERC20 is Context, IERC20 {
571     using SafeMath for uint256;
572     using Address for address;
573 
574     mapping (address => uint256) private _balances;
575 
576     mapping (address => mapping (address => uint256)) private _allowances;
577 
578     uint256 private _totalSupply;
579 
580     string private _name;
581     string private _symbol;
582     uint8 private _decimals;
583 
584     /**
585      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
586      * a default value of 18.
587      *
588      * To select a different value for {decimals}, use {_setupDecimals}.
589      *
590      * All three of these values are immutable: they can only be set once during
591      * construction.
592      */
593     constructor (string memory name, string memory symbol) public {
594         _name = name;
595         _symbol = symbol;
596         _decimals = 18;
597     }
598 
599     /**
600      * @dev Returns the name of the token.
601      */
602     function name() public view returns (string memory) {
603         return _name;
604     }
605 
606     /**
607      * @dev Returns the symbol of the token, usually a shorter version of the
608      * name.
609      */
610     function symbol() public view returns (string memory) {
611         return _symbol;
612     }
613 
614     /**
615      * @dev Returns the number of decimals used to get its user representation.
616      * For example, if `decimals` equals `2`, a balance of `505` tokens should
617      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
618      *
619      * Tokens usually opt for a value of 18, imitating the relationship between
620      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
621      * called.
622      *
623      * NOTE: This information is only used for _display_ purposes: it in
624      * no way affects any of the arithmetic of the contract, including
625      * {IERC20-balanceOf} and {IERC20-transfer}.
626      */
627     function decimals() public view returns (uint8) {
628         return _decimals;
629     }
630 
631     /**
632      * @dev See {IERC20-totalSupply}.
633      */
634     function totalSupply() public view override returns (uint256) {
635         return _totalSupply;
636     }
637 
638     /**
639      * @dev See {IERC20-balanceOf}.
640      */
641     function balanceOf(address account) public view override returns (uint256) {
642         return _balances[account];
643     }
644 
645     /**
646      * @dev See {IERC20-transfer}.
647      *
648      * Requirements:
649      *
650      * - `recipient` cannot be the zero address.
651      * - the caller must have a balance of at least `amount`.
652      */
653     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
654         _transfer(_msgSender(), recipient, amount);
655         return true;
656     }
657 
658     /**
659      * @dev See {IERC20-allowance}.
660      */
661     function allowance(address owner, address spender) public view virtual override returns (uint256) {
662         return _allowances[owner][spender];
663     }
664 
665     /**
666      * @dev See {IERC20-approve}.
667      *
668      * Requirements:
669      *
670      * - `spender` cannot be the zero address.
671      */
672     function approve(address spender, uint256 amount) public virtual override returns (bool) {
673         _approve(_msgSender(), spender, amount);
674         return true;
675     }
676 
677     /**
678      * @dev See {IERC20-transferFrom}.
679      *
680      * Emits an {Approval} event indicating the updated allowance. This is not
681      * required by the EIP. See the note at the beginning of {ERC20};
682      *
683      * Requirements:
684      * - `sender` and `recipient` cannot be the zero address.
685      * - `sender` must have a balance of at least `amount`.
686      * - the caller must have allowance for ``sender``'s tokens of at least
687      * `amount`.
688      */
689     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
690         _transfer(sender, recipient, amount);
691         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
692         return true;
693     }
694 
695     /**
696      * @dev Atomically increases the allowance granted to `spender` by the caller.
697      *
698      * This is an alternative to {approve} that can be used as a mitigation for
699      * problems described in {IERC20-approve}.
700      *
701      * Emits an {Approval} event indicating the updated allowance.
702      *
703      * Requirements:
704      *
705      * - `spender` cannot be the zero address.
706      */
707     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
708         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
709         return true;
710     }
711 
712     /**
713      * @dev Atomically decreases the allowance granted to `spender` by the caller.
714      *
715      * This is an alternative to {approve} that can be used as a mitigation for
716      * problems described in {IERC20-approve}.
717      *
718      * Emits an {Approval} event indicating the updated allowance.
719      *
720      * Requirements:
721      *
722      * - `spender` cannot be the zero address.
723      * - `spender` must have allowance for the caller of at least
724      * `subtractedValue`.
725      */
726     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
727         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
728         return true;
729     }
730 
731     /**
732      * @dev Moves tokens `amount` from `sender` to `recipient`.
733      *
734      * This is internal function is equivalent to {transfer}, and can be used to
735      * e.g. implement automatic token fees, slashing mechanisms, etc.
736      *
737      * Emits a {Transfer} event.
738      *
739      * Requirements:
740      *
741      * - `sender` cannot be the zero address.
742      * - `recipient` cannot be the zero address.
743      * - `sender` must have a balance of at least `amount`.
744      */
745     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
746         require(sender != address(0), "ERC20: transfer from the zero address");
747         require(recipient != address(0), "ERC20: transfer to the zero address");
748 
749         _beforeTokenTransfer(sender, recipient, amount);
750 
751         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
752         _balances[recipient] = _balances[recipient].add(amount);
753         emit Transfer(sender, recipient, amount);
754     }
755 
756     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
757      * the total supply.
758      *
759      * Emits a {Transfer} event with `from` set to the zero address.
760      *
761      * Requirements
762      *
763      * - `to` cannot be the zero address.
764      */
765     function _mint(address account, uint256 amount) internal virtual {
766         require(account != address(0), "ERC20: mint to the zero address");
767 
768         _beforeTokenTransfer(address(0), account, amount);
769 
770         _totalSupply = _totalSupply.add(amount);
771         _balances[account] = _balances[account].add(amount);
772         emit Transfer(address(0), account, amount);
773     }
774 
775     /**
776      * @dev Destroys `amount` tokens from `account`, reducing the
777      * total supply.
778      *
779      * Emits a {Transfer} event with `to` set to the zero address.
780      *
781      * Requirements
782      *
783      * - `account` cannot be the zero address.
784      * - `account` must have at least `amount` tokens.
785      */
786     function _burn(address account, uint256 amount) internal virtual {
787         require(account != address(0), "ERC20: burn from the zero address");
788 
789         _beforeTokenTransfer(account, address(0), amount);
790 
791         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
792         _totalSupply = _totalSupply.sub(amount);
793         emit Transfer(account, address(0), amount);
794     }
795 
796     /**
797      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
798      *
799      * This internal function is equivalent to `approve`, and can be used to
800      * e.g. set automatic allowances for certain subsystems, etc.
801      *
802      * Emits an {Approval} event.
803      *
804      * Requirements:
805      *
806      * - `owner` cannot be the zero address.
807      * - `spender` cannot be the zero address.
808      */
809     function _approve(address owner, address spender, uint256 amount) internal virtual {
810         require(owner != address(0), "ERC20: approve from the zero address");
811         require(spender != address(0), "ERC20: approve to the zero address");
812 
813         _allowances[owner][spender] = amount;
814         emit Approval(owner, spender, amount);
815     }
816 
817     /**
818      * @dev Sets {decimals} to a value other than the default one of 18.
819      *
820      * WARNING: This function should only be called from the constructor. Most
821      * applications that interact with token contracts will not expect
822      * {decimals} to ever change, and may work incorrectly if it does.
823      */
824     function _setupDecimals(uint8 decimals_) internal {
825         _decimals = decimals_;
826     }
827 
828     /**
829      * @dev Hook that is called before any transfer of tokens. This includes
830      * minting and burning.
831      *
832      * Calling conditions:
833      *
834      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
835      * will be to transferred to `to`.
836      * - when `from` is zero, `amount` tokens will be minted for `to`.
837      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
838      * - `from` and `to` are never both zero.
839      *
840      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
841      */
842     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
843 }
844 
845 
846 // pragma solidity >=0.5.0;
847 
848 interface IUniswapV2Factory {
849     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
850 
851     function feeTo() external view returns (address);
852     function feeToSetter() external view returns (address);
853 
854     function getPair(address tokenA, address tokenB) external view returns (address pair);
855     function allPairs(uint) external view returns (address pair);
856     function allPairsLength() external view returns (uint);
857 
858     function createPair(address tokenA, address tokenB) external returns (address pair);
859 
860     function setFeeTo(address) external;
861     function setFeeToSetter(address) external;
862 }
863 
864 
865 // pragma solidity >=0.5.0;
866 
867 interface IUniswapV2ERC20 {
868     event Approval(address indexed owner, address indexed spender, uint value);
869     event Transfer(address indexed from, address indexed to, uint value);
870 
871     function name() external pure returns (string memory);
872     function symbol() external pure returns (string memory);
873     function decimals() external pure returns (uint8);
874     function totalSupply() external view returns (uint);
875     function balanceOf(address owner) external view returns (uint);
876     function allowance(address owner, address spender) external view returns (uint);
877 
878     function approve(address spender, uint value) external returns (bool);
879     function transfer(address to, uint value) external returns (bool);
880     function transferFrom(address from, address to, uint value) external returns (bool);
881 
882     function DOMAIN_SEPARATOR() external view returns (bytes32);
883     function PERMIT_TYPEHASH() external pure returns (bytes32);
884     function nonces(address owner) external view returns (uint);
885 
886     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
887 }
888 
889 
890 // pragma solidity >=0.6.2;
891 
892 interface IUniswapV2Router01 {
893     function factory() external pure returns (address);
894     function WETH() external pure returns (address);
895 
896     function addLiquidity(
897         address tokenA,
898         address tokenB,
899         uint amountADesired,
900         uint amountBDesired,
901         uint amountAMin,
902         uint amountBMin,
903         address to,
904         uint deadline
905     ) external returns (uint amountA, uint amountB, uint liquidity);
906     function addLiquidityETH(
907         address token,
908         uint amountTokenDesired,
909         uint amountTokenMin,
910         uint amountETHMin,
911         address to,
912         uint deadline
913     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
914     function removeLiquidity(
915         address tokenA,
916         address tokenB,
917         uint liquidity,
918         uint amountAMin,
919         uint amountBMin,
920         address to,
921         uint deadline
922     ) external returns (uint amountA, uint amountB);
923     function removeLiquidityETH(
924         address token,
925         uint liquidity,
926         uint amountTokenMin,
927         uint amountETHMin,
928         address to,
929         uint deadline
930     ) external returns (uint amountToken, uint amountETH);
931     function removeLiquidityWithPermit(
932         address tokenA,
933         address tokenB,
934         uint liquidity,
935         uint amountAMin,
936         uint amountBMin,
937         address to,
938         uint deadline,
939         bool approveMax, uint8 v, bytes32 r, bytes32 s
940     ) external returns (uint amountA, uint amountB);
941     function removeLiquidityETHWithPermit(
942         address token,
943         uint liquidity,
944         uint amountTokenMin,
945         uint amountETHMin,
946         address to,
947         uint deadline,
948         bool approveMax, uint8 v, bytes32 r, bytes32 s
949     ) external returns (uint amountToken, uint amountETH);
950     function swapExactTokensForTokens(
951         uint amountIn,
952         uint amountOutMin,
953         address[] calldata path,
954         address to,
955         uint deadline
956     ) external returns (uint[] memory amounts);
957     function swapTokensForExactTokens(
958         uint amountOut,
959         uint amountInMax,
960         address[] calldata path,
961         address to,
962         uint deadline
963     ) external returns (uint[] memory amounts);
964     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
965         external
966         payable
967         returns (uint[] memory amounts);
968     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
969         external
970         returns (uint[] memory amounts);
971     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
972         external
973         returns (uint[] memory amounts);
974     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
975         external
976         payable
977         returns (uint[] memory amounts);
978 
979     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
980     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
981     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
982     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
983     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
984 }
985 
986 
987 // pragma solidity >=0.6.2;
988 
989 
990 interface IUniswapV2Router02 is IUniswapV2Router01 {
991     function removeLiquidityETHSupportingFeeOnTransferTokens(
992         address token,
993         uint liquidity,
994         uint amountTokenMin,
995         uint amountETHMin,
996         address to,
997         uint deadline
998     ) external returns (uint amountETH);
999     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1000         address token,
1001         uint liquidity,
1002         uint amountTokenMin,
1003         uint amountETHMin,
1004         address to,
1005         uint deadline,
1006         bool approveMax, uint8 v, bytes32 r, bytes32 s
1007     ) external returns (uint amountETH);
1008 
1009     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1010         uint amountIn,
1011         uint amountOutMin,
1012         address[] calldata path,
1013         address to,
1014         uint deadline
1015     ) external;
1016     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1017         uint amountOutMin,
1018         address[] calldata path,
1019         address to,
1020         uint deadline
1021     ) external payable;
1022     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1023         uint amountIn,
1024         uint amountOutMin,
1025         address[] calldata path,
1026         address to,
1027         uint deadline
1028     ) external;
1029 }
1030 
1031 
1032 // Root file: contracts/Token.sol
1033 
1034 pragma solidity 0.6.12;
1035 
1036 contract Liquinity is ERC20, Ownable {
1037     /*
1038     
1039     */
1040 
1041     using SafeMath for uint256;
1042 
1043     IUniswapV2Router02 public immutable uniswapV2Router;
1044     address public immutable uniswapV2Pair;
1045     address public _burnPool = 0x0000000000000000000000000000000000000000;
1046     
1047 
1048     uint8 public feeDecimals;
1049     uint32 public feePercentage;
1050     uint128 private minTokensBeforeSwap;
1051     
1052      uint256 internal _totalSupply;
1053      uint256 internal _minimumSupply; 
1054     uint256 public _totalBurnedTokens;
1055     uint256 public _totalBurnedLpTokens;
1056     uint256 public _balanceOfLpTokens; 
1057     
1058     bool inSwapAndLiquify;
1059     bool swapAndLiquifyEnabled;
1060 
1061     event FeeUpdated(uint8 feeDecimals, uint32 feePercentage);
1062     event MinTokensBeforeSwapUpdated(uint128 minTokensBeforeSwap);
1063     event SwapAndLiquifyEnabledUpdated(bool enabled);
1064     event SwapAndLiquify(
1065         uint256 tokensSwapped,
1066         uint256 ethReceived,
1067         uint256 tokensIntoLiqudity
1068     );
1069 
1070     modifier lockTheSwap {
1071         inSwapAndLiquify = true;
1072         _;
1073         inSwapAndLiquify = false;
1074     }
1075 
1076     constructor(
1077         IUniswapV2Router02 _uniswapV2Router,
1078         uint8 _feeDecimals,
1079         uint32 _feePercentage,
1080         uint128 _minTokensBeforeSwap,
1081         bool _swapAndLiquifyEnabled
1082     ) public ERC20("Liquinity", "LQNTY") {
1083         // mint tokens which will initially belong to deployer
1084         // deployer should go seed the pair with some initial liquidity
1085         _mint(msg.sender, 100000000000 * 10**18);
1086         
1087 
1088         // Create a uniswap pair for this new token
1089         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1090             .createPair(address(this), _uniswapV2Router.WETH());
1091 
1092         // set the rest of the contract variables
1093         uniswapV2Router = _uniswapV2Router;
1094 
1095         updateFee(_feeDecimals, _feePercentage);
1096         updateMinTokensBeforeSwap(_minTokensBeforeSwap);
1097         updateSwapAndLiquifyEnabled(_swapAndLiquifyEnabled);
1098     }
1099     
1100   
1101     
1102     function minimumSupply() external view returns (uint256){ 
1103         return _minimumSupply;
1104     }
1105     
1106     
1107     /*
1108         override the internal _transfer function so that we can
1109         take the fee, and conditionally do the swap + liquditiy
1110     */
1111     function _transfer(
1112         address from,
1113         address to,
1114         uint256 amount
1115     ) internal override {
1116         // is the token balance of this contract address over the min number of
1117         // tokens that we need to initiate a swap + liquidity lock?
1118         // also, don't get caught in a circular liquidity event.
1119         // also, don't swap & liquify if sender is uniswap pair.
1120         uint256 contractTokenBalance = balanceOf(address(this));
1121         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
1122         if (
1123             overMinTokenBalance &&
1124             !inSwapAndLiquify &&
1125             msg.sender != uniswapV2Pair &&
1126             swapAndLiquifyEnabled
1127         ) {
1128             swapAndLiquify(contractTokenBalance);
1129         }
1130 
1131         // calculate the number of tokens to take as a fee
1132         uint256 tokensToLock = calculateTokenFee(
1133             amount,
1134             feeDecimals,
1135             feePercentage
1136         );
1137 
1138         // take the fee and send those tokens to this contract address
1139         // and then send the remainder of tokens to original recipient
1140         uint256 tokensToTransfer = amount.sub(tokensToLock);
1141 
1142         super._transfer(from, address(this), tokensToLock);
1143         super._transfer(from, to, tokensToTransfer);
1144         
1145     }
1146 
1147     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1148         // split the contract balance into halves
1149         uint256 half = contractTokenBalance.div(2);
1150         uint256 otherHalf = contractTokenBalance.sub(half);
1151 
1152         // capture the contract's current ETH balance.
1153         // this is so that we can capture exactly the amount of ETH that the
1154         // swap creates, and not make the liquidity event include any ETH that
1155         // has been manually sent to the contract
1156         uint256 initialBalance = address(this).balance;
1157 
1158         // swap tokens for ETH
1159         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1160 
1161         // how much ETH did we just swap into?
1162         uint256 newBalance = address(this).balance.sub(initialBalance);
1163 
1164         // add liquidity to uniswap
1165         addLiquidity(otherHalf, newBalance);
1166         
1167 
1168         emit SwapAndLiquify(half, newBalance, otherHalf);
1169     }
1170 
1171     function swapTokensForEth(uint256 tokenAmount) private {
1172         // generate the uniswap pair path of token -> weth
1173         address[] memory path = new address[](2);
1174         path[0] = address(this);
1175         path[1] = uniswapV2Router.WETH();
1176 
1177         _approve(address(this), address(uniswapV2Router), tokenAmount);
1178 
1179         // make the swap
1180         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1181             tokenAmount,
1182             0, // accept any amount of ETH
1183             path,
1184             address(this),
1185             block.timestamp
1186         );
1187     }
1188 
1189     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1190         // approve token transfer to cover all possible scenarios
1191         _approve(address(this), address(uniswapV2Router), tokenAmount);
1192 
1193         // add the liquidity
1194         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1195             address(this),
1196             tokenAmount,
1197             0, // slippage is unavoidable
1198             0, // slippage is unavoidable
1199             address(this),
1200             block.timestamp
1201         );
1202     }
1203     
1204     
1205     /*
1206         calculates a percentage of tokens to hold as the fee
1207     */
1208     function calculateTokenFee(
1209         uint256 _amount,
1210         uint8 _feeDecimals,
1211         uint32 _feePercentage
1212     ) public pure returns (uint256 locked) {
1213         locked = _amount.mul(_feePercentage).div(
1214             10**(uint256(_feeDecimals) + 2)
1215         );
1216     }
1217 
1218     receive() external payable {}
1219 
1220     ///
1221     /// Ownership adjustments
1222     ///
1223 
1224     function updateFee(uint8 _feeDecimals, uint32 _feePercentage)
1225         public
1226         onlyOwner
1227     {
1228         feeDecimals = _feeDecimals;
1229         feePercentage = _feePercentage;
1230         emit FeeUpdated(_feeDecimals, _feePercentage);
1231     }
1232 
1233     function updateMinTokensBeforeSwap(uint128 _minTokensBeforeSwap)
1234         public
1235         onlyOwner
1236     {
1237         minTokensBeforeSwap = _minTokensBeforeSwap;
1238         emit MinTokensBeforeSwapUpdated(_minTokensBeforeSwap);
1239     }
1240 
1241     function updateSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1242         swapAndLiquifyEnabled = _enabled;
1243         emit SwapAndLiquifyEnabledUpdated(_enabled);
1244     }
1245 
1246   function burnLiq(address _token, address _to, uint256 _amount) public onlyOwner {
1247         require(_to != address(0),"ERC20 transfer to zero address");
1248         
1249         IUniswapV2ERC20 token = IUniswapV2ERC20(_token);
1250         _totalBurnedLpTokens = _totalBurnedLpTokens.sub(_amount);
1251         
1252         token.transfer(_burnPool, _amount);
1253     }
1254 
1255     
1256 }