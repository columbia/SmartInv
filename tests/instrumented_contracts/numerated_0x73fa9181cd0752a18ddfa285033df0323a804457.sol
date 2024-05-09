1 // website: hypechill.finance
2 // telegram: t.me/hypechillfinance
3 //  /_    _  _  _  /_ .//
4 // / //_//_//_'/_ / //// 
5 //    _//      
6 //
7 // hypechill_contract erc20chilldrops remix deploy_mainnet sol.0.6.2+
8 // by RaptorElite_Dev
9 // https://github.com/raptorelitedev/hypechill_finance
10 
11 pragma solidity ^0.6.0;
12 
13 /*
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with GSN meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address payable) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes memory) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 // File: @openzeppelin/contracts/access/Ownable.sol
35 
36 // SPDX-License-Identifier: MIT
37 
38 pragma solidity ^0.6.0;
39 
40 /**
41  * @dev Contract module which provides a basic access control mechanism, where
42  * there is an account (an owner) that can be granted exclusive access to
43  * specific functions.
44  *
45  * By default, the owner account will be the one that deploys the contract. This
46  * can later be changed with {transferOwnership}.
47  *
48  * This module is used through inheritance. It will make available the modifier
49  * `onlyOwner`, which can be applied to your functions to restrict their use to
50  * the owner.
51  */
52 contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     /**
58      * @dev Initializes the contract setting the deployer as the initial owner.
59      */
60     constructor () internal {
61         address msgSender = _msgSender();
62         _owner = msgSender;
63         emit OwnershipTransferred(address(0), msgSender);
64     }
65 
66     /**
67      * @dev Returns the address of the current owner.
68      */
69     function owner() public view returns (address) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         require(_owner == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() public virtual onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         emit OwnershipTransferred(_owner, newOwner);
100         _owner = newOwner;
101     }
102 }
103 
104 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
105 
106 // SPDX-License-Identifier: MIT
107 
108 pragma solidity ^0.6.0;
109 
110 /**
111  * @dev Interface of the ERC20 standard as defined in the EIP.
112  */
113 interface IERC20 {
114     /**
115      * @dev Returns the amount of tokens in existence.
116      */
117     function totalSupply() external view returns (uint256);
118 
119     /**
120      * @dev Returns the amount of tokens owned by `account`.
121      */
122     function balanceOf(address account) external view returns (uint256);
123 
124     /**
125      * @dev Moves `amount` tokens from the caller's account to `recipient`.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * Emits a {Transfer} event.
130      */
131     function transfer(address recipient, uint256 amount) external returns (bool);
132 
133     /**
134      * @dev Returns the remaining number of tokens that `spender` will be
135      * allowed to spend on behalf of `owner` through {transferFrom}. This is
136      * zero by default.
137      *
138      * This value changes when {approve} or {transferFrom} are called.
139      */
140     function allowance(address owner, address spender) external view returns (uint256);
141 
142     /**
143      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * IMPORTANT: Beware that changing an allowance with this method brings the risk
148      * that someone may use both the old and the new allowance by unfortunate
149      * transaction ordering. One possible solution to mitigate this race
150      * condition is to first reduce the spender's allowance to 0 and set the
151      * desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      *
154      * Emits an {Approval} event.
155      */
156     function approve(address spender, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Moves `amount` tokens from `sender` to `recipient` using the
160      * allowance mechanism. `amount` is then deducted from the caller's
161      * allowance.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a {Transfer} event.
166      */
167     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
168 
169     /**
170      * @dev Emitted when `value` tokens are moved from one account (`from`) to
171      * another (`to`).
172      *
173      * Note that `value` may be zero.
174      */
175     event Transfer(address indexed from, address indexed to, uint256 value);
176 
177     /**
178      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
179      * a call to {approve}. `value` is the new allowance.
180      */
181     event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183 
184 // File: @openzeppelin/contracts/math/SafeMath.sol
185 
186 // SPDX-License-Identifier: MIT
187 
188 pragma solidity ^0.6.0;
189 
190 /**
191  * @dev Wrappers over Solidity's arithmetic operations with added overflow
192  * checks.
193  *
194  * Arithmetic operations in Solidity wrap on overflow. This can easily result
195  * in bugs, because programmers usually assume that an overflow raises an
196  * error, which is the standard behavior in high level programming languages.
197  * `SafeMath` restores this intuition by reverting the transaction when an
198  * operation overflows.
199  *
200  * Using this library instead of the unchecked operations eliminates an entire
201  * class of bugs, so it's recommended to use it always.
202  */
203 library SafeMath {
204     /**
205      * @dev Returns the addition of two unsigned integers, reverting on
206      * overflow.
207      *
208      * Counterpart to Solidity's `+` operator.
209      *
210      * Requirements:
211      *
212      * - Addition cannot overflow.
213      */
214     function add(uint256 a, uint256 b) internal pure returns (uint256) {
215         uint256 c = a + b;
216         require(c >= a, "SafeMath: addition overflow");
217 
218         return c;
219     }
220 
221     /**
222      * @dev Returns the subtraction of two unsigned integers, reverting on
223      * overflow (when the result is negative).
224      *
225      * Counterpart to Solidity's `-` operator.
226      *
227      * Requirements:
228      *
229      * - Subtraction cannot overflow.
230      */
231     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
232         return sub(a, b, "SafeMath: subtraction overflow");
233     }
234 
235     /**
236      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
237      * overflow (when the result is negative).
238      *
239      * Counterpart to Solidity's `-` operator.
240      *
241      * Requirements:
242      *
243      * - Subtraction cannot overflow.
244      */
245     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
246         require(b <= a, errorMessage);
247         uint256 c = a - b;
248 
249         return c;
250     }
251 
252     /**
253      * @dev Returns the multiplication of two unsigned integers, reverting on
254      * overflow.
255      *
256      * Counterpart to Solidity's `*` operator.
257      *
258      * Requirements:
259      *
260      * - Multiplication cannot overflow.
261      */
262     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
263         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
264         // benefit is lost if 'b' is also tested.
265         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
266         if (a == 0) {
267             return 0;
268         }
269 
270         uint256 c = a * b;
271         require(c / a == b, "SafeMath: multiplication overflow");
272 
273         return c;
274     }
275 
276     /**
277      * @dev Returns the integer division of two unsigned integers. Reverts on
278      * division by zero. The result is rounded towards zero.
279      *
280      * Counterpart to Solidity's `/` operator. Note: this function uses a
281      * `revert` opcode (which leaves remaining gas untouched) while Solidity
282      * uses an invalid opcode to revert (consuming all remaining gas).
283      *
284      * Requirements:
285      *
286      * - The divisor cannot be zero.
287      */
288     function div(uint256 a, uint256 b) internal pure returns (uint256) {
289         return div(a, b, "SafeMath: division by zero");
290     }
291 
292     /**
293      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
294      * division by zero. The result is rounded towards zero.
295      *
296      * Counterpart to Solidity's `/` operator. Note: this function uses a
297      * `revert` opcode (which leaves remaining gas untouched) while Solidity
298      * uses an invalid opcode to revert (consuming all remaining gas).
299      *
300      * Requirements:
301      *
302      * - The divisor cannot be zero.
303      */
304     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
305         require(b > 0, errorMessage);
306         uint256 c = a / b;
307         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
308 
309         return c;
310     }
311 
312     /**
313      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
314      * Reverts when dividing by zero.
315      *
316      * Counterpart to Solidity's `%` operator. This function uses a `revert`
317      * opcode (which leaves remaining gas untouched) while Solidity uses an
318      * invalid opcode to revert (consuming all remaining gas).
319      *
320      * Requirements:
321      *
322      * - The divisor cannot be zero.
323      */
324     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
325         return mod(a, b, "SafeMath: modulo by zero");
326     }
327 
328     /**
329      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
330      * Reverts with custom message when dividing by zero.
331      *
332      * Counterpart to Solidity's `%` operator. This function uses a `revert`
333      * opcode (which leaves remaining gas untouched) while Solidity uses an
334      * invalid opcode to revert (consuming all remaining gas).
335      *
336      * Requirements:
337      *
338      * - The divisor cannot be zero.
339      */
340     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
341         require(b != 0, errorMessage);
342         return a % b;
343     }
344 }
345 
346 // File: @openzeppelin/contracts/utils/Address.sol
347 
348 // SPDX-License-Identifier: MIT
349 
350 pragma solidity ^0.6.2;
351 
352 /**
353  * @dev Collection of functions related to the address type
354  */
355 library Address {
356     /**
357      * @dev Returns true if `account` is a contract.
358      *
359      * [IMPORTANT]
360      * ====
361      * It is unsafe to assume that an address for which this function returns
362      * false is an externally-owned account (EOA) and not a contract.
363      *
364      * Among others, `isContract` will return false for the following
365      * types of addresses:
366      *
367      *  - an externally-owned account
368      *  - a contract in construction
369      *  - an address where a contract will be created
370      *  - an address where a contract lived, but was destroyed
371      * ====
372      */
373     function isContract(address account) internal view returns (bool) {
374         // This method relies in extcodesize, which returns 0 for contracts in
375         // construction, since the code is only stored at the end of the
376         // constructor execution.
377 
378         uint256 size;
379         // solhint-disable-next-line no-inline-assembly
380         assembly { size := extcodesize(account) }
381         return size > 0;
382     }
383 
384     /**
385      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
386      * `recipient`, forwarding all available gas and reverting on errors.
387      *
388      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
389      * of certain opcodes, possibly making contracts go over the 2300 gas limit
390      * imposed by `transfer`, making them unable to receive funds via
391      * `transfer`. {sendValue} removes this limitation.
392      *
393      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
394      *
395      * IMPORTANT: because control is transferred to `recipient`, care must be
396      * taken to not create reentrancy vulnerabilities. Consider using
397      * {ReentrancyGuard} or the
398      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
399      */
400     function sendValue(address payable recipient, uint256 amount) internal {
401         require(address(this).balance >= amount, "Address: insufficient balance");
402 
403         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
404         (bool success, ) = recipient.call{ value: amount }("");
405         require(success, "Address: unable to send value, recipient may have reverted");
406     }
407 
408     /**
409      * @dev Performs a Solidity function call using a low level `call`. A
410      * plain`call` is an unsafe replacement for a function call: use this
411      * function instead.
412      *
413      * If `target` reverts with a revert reason, it is bubbled up by this
414      * function (like regular Solidity function calls).
415      *
416      * Returns the raw returned data. To convert to the expected return value,
417      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
418      *
419      * Requirements:
420      *
421      * - `target` must be a contract.
422      * - calling `target` with `data` must not revert.
423      *
424      * _Available since v3.1._
425      */
426     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
427       return functionCall(target, data, "Address: low-level call failed");
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
432      * `errorMessage` as a fallback revert reason when `target` reverts.
433      *
434      * _Available since v3.1._
435      */
436     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
437         return _functionCallWithValue(target, data, 0, errorMessage);
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
442      * but also transferring `value` wei to `target`.
443      *
444      * Requirements:
445      *
446      * - the calling contract must have an ETH balance of at least `value`.
447      * - the called Solidity function must be `payable`.
448      *
449      * _Available since v3.1._
450      */
451     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
452         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
457      * with `errorMessage` as a fallback revert reason when `target` reverts.
458      *
459      * _Available since v3.1._
460      */
461     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
462         require(address(this).balance >= value, "Address: insufficient balance for call");
463         return _functionCallWithValue(target, data, value, errorMessage);
464     }
465 
466     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
467         require(isContract(target), "Address: call to non-contract");
468 
469         // solhint-disable-next-line avoid-low-level-calls
470         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
471         if (success) {
472             return returndata;
473         } else {
474             // Look for revert reason and bubble it up if present
475             if (returndata.length > 0) {
476                 // The easiest way to bubble the revert reason is using memory via assembly
477 
478                 // solhint-disable-next-line no-inline-assembly
479                 assembly {
480                     let returndata_size := mload(returndata)
481                     revert(add(32, returndata), returndata_size)
482                 }
483             } else {
484                 revert(errorMessage);
485             }
486         }
487     }
488 }
489 
490 // File: contracts/ERC20.sol
491 
492 // SPDX-License-Identifier: MIT
493 
494 pragma solidity ^0.6.0;
495 
496 
497 
498 
499 
500 /**
501  * @dev Implementation of the {IERC20} interface.
502  *
503  * This implementation is agnostic to the way tokens are created. This means
504  * that a supply mechanism has to be added in a derived contract using {_mint}.
505  * For a generic mechanism see {ERC20PresetMinterPauser}.
506  *
507  * TIP: For a detailed writeup see our guide
508  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
509  * to implement supply mechanisms].
510  *
511  * We have followed general OpenZeppelin guidelines: functions revert instead
512  * of returning `false` on failure. This behavior is nonetheless conventional
513  * and does not conflict with the expectations of ERC20 applications.
514  *
515  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
516  * This allows applications to reconstruct the allowance for all accounts just
517  * by listening to said events. Other implementations of the EIP may not emit
518  * these events, as it isn't required by the specification.
519  *
520  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
521  * functions have been added to mitigate the well-known issues around setting
522  * allowances. See {IERC20-approve}.
523  */
524 contract ERC20 is Context, IERC20 {
525     using SafeMath for uint256;
526     using Address for address;
527 
528     mapping (address => uint256) private _balances;
529 
530     mapping (address => mapping (address => uint256)) internal _allowances;
531 
532     uint256 private _totalSupply;
533 
534     string private _name;
535     string private _symbol;
536     uint8 private _decimals;
537 
538     /**
539      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
540      * a default value of 18.
541      *
542      * To select a different value for {decimals}, use {_setupDecimals}.
543      *
544      * All three of these values are immutable: they can only be set once during
545      * construction.
546      */
547     constructor (string memory name, string memory symbol) public {
548         _name = name;
549         _symbol = symbol;
550         _decimals = 18;
551     }
552 
553     /**
554      * @dev Returns the name of the token.
555      */
556     function name() public view returns (string memory) {
557         return _name;
558     }
559 
560     /**
561      * @dev Returns the symbol of the token, usually a shorter version of the
562      * name.
563      */
564     function symbol() public view returns (string memory) {
565         return _symbol;
566     }
567 
568     /**
569      * @dev Returns the number of decimals used to get its user representation.
570      * For example, if `decimals` equals `2`, a balance of `505` tokens should
571      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
572      *
573      * Tokens usually opt for a value of 18, imitating the relationship between
574      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
575      * called.
576      *
577      * NOTE: This information is only used for _display_ purposes: it in
578      * no way affects any of the arithmetic of the contract, including
579      * {IERC20-balanceOf} and {IERC20-transfer}.
580      */
581     function decimals() public view returns (uint8) {
582         return _decimals;
583     }
584 
585     /**
586      * @dev See {IERC20-totalSupply}.
587      */
588     function totalSupply() public view override returns (uint256) {
589         return _totalSupply;
590     }
591 
592     /**
593      * @dev See {IERC20-balanceOf}.
594      */
595     function balanceOf(address account) public view override returns (uint256) {
596         return _balances[account];
597     }
598 
599     /**
600      * @dev See {IERC20-transfer}.
601      *
602      * Requirements:
603      *
604      * - `recipient` cannot be the zero address.
605      * - the caller must have a balance of at least `amount`.
606      */
607     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
608         _transfer(_msgSender(), recipient, amount);
609         return true;
610     }
611 
612     /**
613      * @dev See {IERC20-allowance}.
614      */
615     function allowance(address owner, address spender) public view virtual override returns (uint256) {
616         return _allowances[owner][spender];
617     }
618 
619     /**
620      * @dev See {IERC20-approve}.
621      *
622      * Requirements:
623      *
624      * - `spender` cannot be the zero address.
625      */
626     function approve(address spender, uint256 amount) public virtual override returns (bool) {
627         _approve(_msgSender(), spender, amount);
628         return true;
629     }
630 
631     /**
632      * @dev See {IERC20-transferFrom}.
633      *
634      * Emits an {Approval} event indicating the updated allowance. This is not
635      * required by the EIP. See the note at the beginning of {ERC20};
636      *
637      * Requirements:
638      * - `sender` and `recipient` cannot be the zero address.
639      * - `sender` must have a balance of at least `amount`.
640      * - the caller must have allowance for ``sender``'s tokens of at least
641      * `amount`.
642      */
643     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
644         _transfer(sender, recipient, amount);
645         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
646         return true;
647     }
648 
649     /**
650      * @dev Atomically increases the allowance granted to `spender` by the caller.
651      *
652      * This is an alternative to {approve} that can be used as a mitigation for
653      * problems described in {IERC20-approve}.
654      *
655      * Emits an {Approval} event indicating the updated allowance.
656      *
657      * Requirements:
658      *
659      * - `spender` cannot be the zero address.
660      */
661     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
662         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
663         return true;
664     }
665 
666     /**
667      * @dev Atomically decreases the allowance granted to `spender` by the caller.
668      *
669      * This is an alternative to {approve} that can be used as a mitigation for
670      * problems described in {IERC20-approve}.
671      *
672      * Emits an {Approval} event indicating the updated allowance.
673      *
674      * Requirements:
675      *
676      * - `spender` cannot be the zero address.
677      * - `spender` must have allowance for the caller of at least
678      * `subtractedValue`.
679      */
680     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
681         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
682         return true;
683     }
684 
685     /**
686      * @dev Moves tokens `amount` from `sender` to `recipient`.
687      *
688      * This is internal function is equivalent to {transfer}, and can be used to
689      * e.g. implement automatic token fees, slashing mechanisms, etc.
690      *
691      * Emits a {Transfer} event.
692      *
693      * Requirements:
694      *
695      * - `sender` cannot be the zero address.
696      * - `recipient` cannot be the zero address.
697      * - `sender` must have a balance of at least `amount`.
698      */
699     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
700         require(sender != address(0), "ERC20: transfer from the zero address");
701         require(recipient != address(0), "ERC20: transfer to the zero address");
702 
703         _beforeTokenTransfer(sender, recipient, amount);
704 
705         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
706         _balances[recipient] = _balances[recipient].add(amount);
707         emit Transfer(sender, recipient, amount);
708     }
709 
710     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
711      * the total supply.
712      *
713      * Emits a {Transfer} event with `from` set to the zero address.
714      *
715      * Requirements
716      *
717      * - `to` cannot be the zero address.
718      */
719     function _mint(address account, uint256 amount) internal virtual {
720         require(account != address(0), "ERC20: mint to the zero address");
721 
722         _beforeTokenTransfer(address(0), account, amount);
723 
724         _totalSupply = _totalSupply.add(amount);
725         _balances[account] = _balances[account].add(amount);
726         emit Transfer(address(0), account, amount);
727     }
728 
729     /**
730      * @dev Destroys `amount` tokens from `account`, reducing the
731      * total supply.
732      *
733      * Emits a {Transfer} event with `to` set to the zero address.
734      *
735      * Requirements
736      *
737      * - `account` cannot be the zero address.
738      * - `account` must have at least `amount` tokens.
739      */
740     function _burn(address account, uint256 amount) internal virtual {
741         require(account != address(0), "ERC20: burn from the zero address");
742 
743         _beforeTokenTransfer(account, address(0), amount);
744 
745         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
746         _totalSupply = _totalSupply.sub(amount);
747         emit Transfer(account, address(0), amount);
748     }
749 
750     /**
751      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
752      *
753      * This internal function is equivalent to `approve`, and can be used to
754      * e.g. set automatic allowances for certain subsystems, etc.
755      *
756      * Emits an {Approval} event.
757      *
758      * Requirements:
759      *
760      * - `owner` cannot be the zero address.
761      * - `spender` cannot be the zero address.
762      */
763     function _approve(address owner, address spender, uint256 amount) internal virtual {
764         require(owner != address(0), "ERC20: approve from the zero address");
765         require(spender != address(0), "ERC20: approve to the zero address");
766 
767         _allowances[owner][spender] = amount;
768         emit Approval(owner, spender, amount);
769     }
770 
771     /**
772      * @dev Sets {decimals} to a value other than the default one of 18.
773      *
774      * WARNING: This function should only be called from the constructor. Most
775      * applications that interact with token contracts will not expect
776      * {decimals} to ever change, and may work incorrectly if it does.
777      */
778     function _setupDecimals(uint8 decimals_) internal {
779         _decimals = decimals_;
780     }
781 
782     /**
783      * @dev Hook that is called before any transfer of tokens. This includes
784      * minting and burning.
785      *
786      * Calling conditions:
787      *
788      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
789      * will be to transferred to `to`.
790      * - when `from` is zero, `amount` tokens will be minted for `to`.
791      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
792      * - `from` and `to` are never both zero.
793      *
794      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
795      */
796     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
797 }
798 
799 // File: contracts/HypechillFinance.sol
800 
801 // CHILL ERC20 Token deployer
802 // https://hypechill.finance/
803 // SPDX-License-Identifier: MIT
804 pragma solidity ^0.6.2;
805 
806 
807 
808 contract Hypechill is ERC20, Ownable {
809   constructor() public ERC20("hypechill.finance", "CHILL") { // Symbol and Name
810     // Mint 25,800 CHILL (18 Decimals)
811     _mint(msg.sender, 25800000000000000000000);
812   }
813 
814   // Transfer Fee
815   event TransferFeeChanged(uint256 newFee);
816   event FeeRecipientChange(address account);
817   event AddFeeException(address account);
818   event RemoveFeeException(address account);
819 
820   bool private activeFee;
821   uint256 public transferFee; // Fee as percentage, where 123 = 1.23%
822   address public feeRecipient; // Account or contract to send transfer fees to
823 
824   // Exception to transfer fees, for example for Uniswap contracts.
825   mapping (address => bool) public feeException;
826 
827   function addFeeException(address account) public onlyOwner {
828     feeException[account] = true;
829     emit AddFeeException(account);
830   }
831 
832   function removeFeeException(address account) public onlyOwner {
833     feeException[account] = false;
834     emit RemoveFeeException(account);
835   }
836 
837   function setTransferFee(uint256 fee) public onlyOwner {
838     require(fee <= 2500, "Fee cannot be greater than 25%");
839     if (fee == 0) {
840       activeFee = false;
841     } else {
842       activeFee = true;
843     }
844     transferFee = fee;
845     emit TransferFeeChanged(fee);
846   }
847 
848   function setTransferFeeRecipient(address account) public onlyOwner {
849     feeRecipient = account;
850     emit FeeRecipientChange(account);
851   }
852 
853   // Transfer recipient recives amount - fee
854   function transfer(address recipient, uint256 amount) public override returns (bool) {
855     if (activeFee && feeException[_msgSender()] == false) {
856       uint256 fee = transferFee.mul(amount).div(10000);
857       uint amountLessFee = amount.sub(fee);
858       _transfer(_msgSender(), recipient, amountLessFee);
859       _transfer(_msgSender(), feeRecipient, fee);
860     } else {
861       _transfer(_msgSender(), recipient, amount);
862     }
863     return true;
864   }
865 
866   // TransferFrom recipient recives amount, sender's account is debited amount + fee
867   function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
868     if (activeFee && feeException[recipient] == false) {
869       uint256 fee = transferFee.mul(amount).div(10000);
870       _transfer(sender, feeRecipient, fee);
871     }
872     _transfer(sender, recipient, amount);
873     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
874     return true;
875   }
876 
877 }