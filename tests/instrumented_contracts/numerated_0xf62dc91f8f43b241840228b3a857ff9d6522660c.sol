1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-11
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-11-10
7 */
8 
9 /**
10  *Submitted for verification at Etherscan.io on 2020-11-09
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2020-11-09
15 */
16 
17 /**
18  *Submitted for verification at Etherscan.io on 2020-11-08
19 */
20 
21 /**
22  *Submitted for verification at Etherscan.io on 2020-11-08
23 */
24 
25 // SPDX-License-Identifier: MIT
26 
27 // File: @openzeppelin/contracts/math/Math.sol
28 
29 pragma solidity ^0.6.0;
30 
31 /**
32  * @dev Standard math utilities missing in the Solidity language.
33  */
34 library Math {
35     /**
36      * @dev Returns the largest of two numbers.
37      */
38     function max(uint256 a, uint256 b) internal pure returns (uint256) {
39         return a >= b ? a : b;
40     }
41 
42     /**
43      * @dev Returns the smallest of two numbers.
44      */
45     function min(uint256 a, uint256 b) internal pure returns (uint256) {
46         return a < b ? a : b;
47     }
48 
49     /**
50      * @dev Returns the average of two numbers. The result is rounded towards
51      * zero.
52      */
53     function average(uint256 a, uint256 b) internal pure returns (uint256) {
54         // (a + b) / 2 can overflow, so we distribute
55         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
56     }
57 }
58 
59 pragma solidity ^0.6.2;
60 
61 /**
62  * @dev Collection of functions related to the address type
63  */
64 library Address {
65     /**
66      * @dev Returns true if `account` is a contract.
67      *
68      * [IMPORTANT]
69      * ====
70      * It is unsafe to assume that an address for which this function returns
71      * false is an externally-owned account (EOA) and not a contract.
72      *
73      * Among others, `isContract` will return false for the following
74      * types of addresses:
75      *
76      *  - an externally-owned account
77      *  - a contract in construction
78      *  - an address where a contract will be created
79      *  - an address where a contract lived, but was destroyed
80      * ====
81      */
82     function isContract(address account) internal view returns (bool) {
83         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
84         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
85         // for accounts without code, i.e. `keccak256('')`
86         bytes32 codehash;
87         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
88         // solhint-disable-next-line no-inline-assembly
89         assembly { codehash := extcodehash(account) }
90         return (codehash != accountHash && codehash != 0x0);
91     }
92 
93     /**
94      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
95      * `recipient`, forwarding all available gas and reverting on errors.
96      *
97      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
98      * of certain opcodes, possibly making contracts go over the 2300 gas limit
99      * imposed by `transfer`, making them unable to receive funds via
100      * `transfer`. {sendValue} removes this limitation.
101      *
102      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
103      *
104      * IMPORTANT: because control is transferred to `recipient`, care must be
105      * taken to not create reentrancy vulnerabilities. Consider using
106      * {ReentrancyGuard} or the
107      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
108      */
109     function sendValue(address payable recipient, uint256 amount) internal {
110         require(address(this).balance >= amount, "Address: insufficient balance");
111 
112         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
113         (bool success, ) = recipient.call{ value: amount }("");
114         require(success, "Address: unable to send value, recipient may have reverted");
115     }
116 
117     /**
118      * @dev Performs a Solidity function call using a low level `call`. A
119      * plain`call` is an unsafe replacement for a function call: use this
120      * function instead.
121      *
122      * If `target` reverts with a revert reason, it is bubbled up by this
123      * function (like regular Solidity function calls).
124      *
125      * Returns the raw returned data. To convert to the expected return value,
126      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
127      *
128      * Requirements:
129      *
130      * - `target` must be a contract.
131      * - calling `target` with `data` must not revert.
132      *
133      * _Available since v3.1._
134      */
135     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
136       return functionCall(target, data, "Address: low-level call failed");
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
141      * `errorMessage` as a fallback revert reason when `target` reverts.
142      *
143      * _Available since v3.1._
144      */
145     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
146         return _functionCallWithValue(target, data, 0, errorMessage);
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
151      * but also transferring `value` wei to `target`.
152      *
153      * Requirements:
154      *
155      * - the calling contract must have an ETH balance of at least `value`.
156      * - the called Solidity function must be `payable`.
157      *
158      * _Available since v3.1._
159      */
160     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
161         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
162     }
163 
164     /**
165      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
166      * with `errorMessage` as a fallback revert reason when `target` reverts.
167      *
168      * _Available since v3.1._
169      */
170     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
171         require(address(this).balance >= value, "Address: insufficient balance for call");
172         return _functionCallWithValue(target, data, value, errorMessage);
173     }
174 
175     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
176         require(isContract(target), "Address: call to non-contract");
177 
178         // solhint-disable-next-line avoid-low-level-calls
179         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
180         if (success) {
181             return returndata;
182         } else {
183             // Look for revert reason and bubble it up if present
184             if (returndata.length > 0) {
185                 // The easiest way to bubble the revert reason is using memory via assembly
186 
187                 // solhint-disable-next-line no-inline-assembly
188                 assembly {
189                     let returndata_size := mload(returndata)
190                     revert(add(32, returndata), returndata_size)
191                 }
192             } else {
193                 revert(errorMessage);
194             }
195         }
196     }
197 }
198 
199 // File: @openzeppelin/contracts/math/SafeMath.sol
200 
201 pragma solidity ^0.6.0;
202 
203 /**
204  * @dev Wrappers over Solidity's arithmetic operations with added overflow
205  * checks.
206  *
207  * Arithmetic operations in Solidity wrap on overflow. This can easily result
208  * in bugs, because programmers usually assume that an overflow raises an
209  * error, which is the standard behavior in high level programming languages.
210  * `SafeMath` restores this intuition by reverting the transaction when an
211  * operation overflows.
212  *
213  * Using this library instead of the unchecked operations eliminates an entire
214  * class of bugs, so it's recommended to use it always.
215  */
216 library SafeMath {
217     /**
218      * @dev Returns the addition of two unsigned integers, reverting on
219      * overflow.
220      *
221      * Counterpart to Solidity's `+` operator.
222      *
223      * Requirements:
224      *
225      * - Addition cannot overflow.
226      */
227     function add(uint256 a, uint256 b) internal pure returns (uint256) {
228         uint256 c = a + b;
229         require(c >= a, "SafeMath: addition overflow");
230 
231         return c;
232     }
233 
234     /**
235      * @dev Returns the subtraction of two unsigned integers, reverting on
236      * overflow (when the result is negative).
237      *
238      * Counterpart to Solidity's `-` operator.
239      *
240      * Requirements:
241      *
242      * - Subtraction cannot overflow.
243      */
244     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
245         return sub(a, b, "SafeMath: subtraction overflow");
246     }
247 
248     /**
249      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
250      * overflow (when the result is negative).
251      *
252      * Counterpart to Solidity's `-` operator.
253      *
254      * Requirements:
255      *
256      * - Subtraction cannot overflow.
257      */
258     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
259         require(b <= a, errorMessage);
260         uint256 c = a - b;
261 
262         return c;
263     }
264 
265     /**
266      * @dev Returns the multiplication of two unsigned integers, reverting on
267      * overflow.
268      *
269      * Counterpart to Solidity's `*` operator.
270      *
271      * Requirements:
272      *
273      * - Multiplication cannot overflow.
274      */
275     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
276         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
277         // benefit is lost if 'b' is also tested.
278         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
279         if (a == 0) {
280             return 0;
281         }
282 
283         uint256 c = a * b;
284         require(c / a == b, "SafeMath: multiplication overflow");
285 
286         return c;
287     }
288 
289     /**
290      * @dev Returns the integer division of two unsigned integers. Reverts on
291      * division by zero. The result is rounded towards zero.
292      *
293      * Counterpart to Solidity's `/` operator. Note: this function uses a
294      * `revert` opcode (which leaves remaining gas untouched) while Solidity
295      * uses an invalid opcode to revert (consuming all remaining gas).
296      *
297      * Requirements:
298      *
299      * - The divisor cannot be zero.
300      */
301     function div(uint256 a, uint256 b) internal pure returns (uint256) {
302         return div(a, b, "SafeMath: division by zero");
303     }
304 
305     /**
306      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
307      * division by zero. The result is rounded towards zero.
308      *
309      * Counterpart to Solidity's `/` operator. Note: this function uses a
310      * `revert` opcode (which leaves remaining gas untouched) while Solidity
311      * uses an invalid opcode to revert (consuming all remaining gas).
312      *
313      * Requirements:
314      *
315      * - The divisor cannot be zero.
316      */
317     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
318         require(b > 0, errorMessage);
319         uint256 c = a / b;
320         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
321 
322         return c;
323     }
324 
325     /**
326      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
327      * Reverts when dividing by zero.
328      *
329      * Counterpart to Solidity's `%` operator. This function uses a `revert`
330      * opcode (which leaves remaining gas untouched) while Solidity uses an
331      * invalid opcode to revert (consuming all remaining gas).
332      *
333      * Requirements:
334      *
335      * - The divisor cannot be zero.
336      */
337     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
338         return mod(a, b, "SafeMath: modulo by zero");
339     }
340 
341     /**
342      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
343      * Reverts with custom message when dividing by zero.
344      *
345      * Counterpart to Solidity's `%` operator. This function uses a `revert`
346      * opcode (which leaves remaining gas untouched) while Solidity uses an
347      * invalid opcode to revert (consuming all remaining gas).
348      *
349      * Requirements:
350      *
351      * - The divisor cannot be zero.
352      */
353     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
354         require(b != 0, errorMessage);
355         return a % b;
356     }
357 }
358 
359 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
360 
361 pragma solidity ^0.6.0;
362 
363 /*
364  * @dev Provides information about the current execution context, including the
365  * sender of the transaction and its data. While these are generally available
366  * via msg.sender and msg.data, they should not be accessed in such a direct
367  * manner, since when dealing with GSN meta-transactions the account sending and
368  * paying for execution may not be the actual sender (as far as an application
369  * is concerned).
370  *
371  * This contract is only required for intermediate, library-like contracts.
372  */
373 abstract contract Context {
374     function _msgSender() internal view virtual returns (address payable) {
375         return msg.sender;
376     }
377 
378     function _msgData() internal view virtual returns (bytes memory) {
379         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
380         return msg.data;
381     }
382 }
383 
384 // File: @openzeppelin/contracts/ownership/Ownable.sol
385 
386 pragma solidity ^0.6.0;
387 
388 /**
389  * @dev Contract module which provides a basic access control mechanism, where
390  * there is an account (an owner) that can be granted exclusive access to
391  * specific functions.
392  *
393  * By default, the owner account will be the one that deploys the contract. This
394  * can later be changed with {transferOwnership}.
395  *
396  * This module is used through inheritance. It will make available the modifier
397  * `onlyOwner`, which can be applied to your functions to restrict their use to
398  * the owner.
399  */
400 contract Ownable is Context {
401     address private _owner;
402 
403     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
404 
405     /**
406      * @dev Initializes the contract setting the deployer as the initial owner.
407      */
408     constructor () internal {
409         address msgSender = _msgSender();
410         _owner = msgSender;
411         emit OwnershipTransferred(address(0), msgSender);
412     }
413 
414     /**
415      * @dev Returns the address of the current owner.
416      */
417     function owner() public view returns (address) {
418         return _owner;
419     }
420 
421     /**
422      * @dev Throws if called by any account other than the owner.
423      */
424     modifier onlyOwner() {
425         require(_owner == _msgSender(), "Ownable: caller is not the owner");
426         _;
427     }
428 
429     /**
430      * @dev Leaves the contract without owner. It will not be possible to call
431      * `onlyOwner` functions anymore. Can only be called by the current owner.
432      *
433      * NOTE: Renouncing ownership will leave the contract without an owner,
434      * thereby removing any functionality that is only available to the owner.
435      */
436     function renounceOwnership() public virtual onlyOwner {
437         emit OwnershipTransferred(_owner, address(0));
438         _owner = address(0);
439     }
440 
441     /**
442      * @dev Transfers ownership of the contract to a new account (`newOwner`).
443      * Can only be called by the current owner.
444      */
445     function transferOwnership(address newOwner) public virtual onlyOwner {
446         require(newOwner != address(0), "Ownable: new owner is the zero address");
447         emit OwnershipTransferred(_owner, newOwner);
448         _owner = newOwner;
449     }
450 }
451 
452 
453 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
454 
455 pragma solidity ^0.6.0;
456 
457 /**
458  * @dev Interface of the ERC20 standard as defined in the EIP.
459  */
460 interface IERC20 {
461     /**
462      * @dev Returns the amount of tokens in existence.
463      */
464     function totalSupply() external view returns (uint256);
465 
466     /**
467      * @dev Returns the amount of tokens owned by `account`.
468      */
469     function balanceOf(address account) external view returns (uint256);
470 
471     /**
472      * @dev Moves `amount` tokens from the caller's account to `recipient`.
473      *
474      * Returns a boolean value indicating whether the operation succeeded.
475      *
476      * Emits a {Transfer} event.
477      */
478     function transfer(address recipient, uint256 amount) external returns (bool);
479 
480     /**
481      * @dev Returns the remaining number of tokens that `spender` will be
482      * allowed to spend on behalf of `owner` through {transferFrom}. This is
483      * zero by default.
484      *
485      * This value changes when {approve} or {transferFrom} are called.
486      */
487     function allowance(address owner, address spender) external view returns (uint256);
488 
489     /**
490      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
491      *
492      * Returns a boolean value indicating whether the operation succeeded.
493      *
494      * IMPORTANT: Beware that changing an allowance with this method brings the risk
495      * that someone may use both the old and the new allowance by unfortunate
496      * transaction ordering. One possible solution to mitigate this race
497      * condition is to first reduce the spender's allowance to 0 and set the
498      * desired value afterwards:
499      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
500      *
501      * Emits an {Approval} event.
502      */
503     function approve(address spender, uint256 amount) external returns (bool);
504 
505     /**
506      * @dev Moves `amount` tokens from `sender` to `recipient` using the
507      * allowance mechanism. `amount` is then deducted from the caller's
508      * allowance.
509      *
510      * Returns a boolean value indicating whether the operation succeeded.
511      *
512      * Emits a {Transfer} event.
513      */
514     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
515 
516     /**
517      * @dev Emitted when `value` tokens are moved from one account (`from`) to
518      * another (`to`).
519      *
520      * Note that `value` may be zero.
521      */
522     event Transfer(address indexed from, address indexed to, uint256 value);
523 
524     /**
525      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
526      * a call to {approve}. `value` is the new allowance.
527      */
528     event Approval(address indexed owner, address indexed spender, uint256 value);
529 }
530 
531 pragma solidity ^0.6.0;
532 
533 contract ERC20 is Context, IERC20 {
534     using SafeMath for uint256;
535 
536     mapping (address => uint256) private _balances;
537 
538     mapping (address => mapping (address => uint256)) private _allowances;
539 
540     uint256 private _totalSupply;
541 
542     string private _name;
543     string private _symbol;
544     uint8 private _decimals;
545 
546     /**
547      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
548      * a default value of 18.
549      *
550      * To select a different value for {decimals}, use {_setupDecimals}.
551      *
552      * All three of these values are immutable: they can only be set once during
553      * construction.
554      */
555     constructor (string memory name, string memory symbol) public {
556         _name = name;
557         _symbol = symbol;
558         _decimals = 18;
559     }
560 
561     /**
562      * @dev Returns the name of the token.
563      */
564     function name() public view returns (string memory) {
565         return _name;
566     }
567 
568     /**
569      * @dev Returns the symbol of the token, usually a shorter version of the
570      * name.
571      */
572     function symbol() public view returns (string memory) {
573         return _symbol;
574     }
575 
576     /**
577      * @dev Returns the number of decimals used to get its user representation.
578      * For example, if `decimals` equals `2`, a balance of `505` tokens should
579      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
580      *
581      * Tokens usually opt for a value of 18, imitating the relationship between
582      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
583      * called.
584      *
585      * NOTE: This information is only used for _display_ purposes: it in
586      * no way affects any of the arithmetic of the contract, including
587      * {IERC20-balanceOf} and {IERC20-transfer}.
588      */
589     function decimals() public view returns (uint8) {
590         return _decimals;
591     }
592 
593     /**
594      * @dev See {IERC20-totalSupply}.
595      */
596     function totalSupply() public view override returns (uint256) {
597         return _totalSupply;
598     }
599 
600     /**
601      * @dev See {IERC20-balanceOf}.
602      */
603     function balanceOf(address account) public view override returns (uint256) {
604         return _balances[account];
605     }
606 
607     /**
608      * @dev See {IERC20-transfer}.
609      *
610      * Requirements:
611      *
612      * - `recipient` cannot be the zero address.
613      * - the caller must have a balance of at least `amount`.
614      */
615     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
616         _transfer(_msgSender(), recipient, amount);
617         return true;
618     }
619 
620     /**
621      * @dev See {IERC20-allowance}.
622      */
623     function allowance(address owner, address spender) public view virtual override returns (uint256) {
624         return _allowances[owner][spender];
625     }
626 
627     /**
628      * @dev See {IERC20-approve}.
629      *
630      * Requirements:
631      *
632      * - `spender` cannot be the zero address.
633      */
634     function approve(address spender, uint256 amount) public virtual override returns (bool) {
635         _approve(_msgSender(), spender, amount);
636         return true;
637     }
638 
639     /**
640      * @dev See {IERC20-transferFrom}.
641      *
642      * Emits an {Approval} event indicating the updated allowance. This is not
643      * required by the EIP. See the note at the beginning of {ERC20}.
644      *
645      * Requirements:
646      *
647      * - `sender` and `recipient` cannot be the zero address.
648      * - `sender` must have a balance of at least `amount`.
649      * - the caller must have allowance for ``sender``'s tokens of at least
650      * `amount`.
651      */
652     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
653         _transfer(sender, recipient, amount);
654         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
655         return true;
656     }
657 
658     /**
659      * @dev Atomically increases the allowance granted to `spender` by the caller.
660      *
661      * This is an alternative to {approve} that can be used as a mitigation for
662      * problems described in {IERC20-approve}.
663      *
664      * Emits an {Approval} event indicating the updated allowance.
665      *
666      * Requirements:
667      *
668      * - `spender` cannot be the zero address.
669      */
670     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
671         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
672         return true;
673     }
674 
675     /**
676      * @dev Atomically decreases the allowance granted to `spender` by the caller.
677      *
678      * This is an alternative to {approve} that can be used as a mitigation for
679      * problems described in {IERC20-approve}.
680      *
681      * Emits an {Approval} event indicating the updated allowance.
682      *
683      * Requirements:
684      *
685      * - `spender` cannot be the zero address.
686      * - `spender` must have allowance for the caller of at least
687      * `subtractedValue`.
688      */
689     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
690         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
691         return true;
692     }
693 
694     /**
695      * @dev Moves tokens `amount` from `sender` to `recipient`.
696      *
697      * This is internal function is equivalent to {transfer}, and can be used to
698      * e.g. implement automatic token fees, slashing mechanisms, etc.
699      *
700      * Emits a {Transfer} event.
701      *
702      * Requirements:
703      *
704      * - `sender` cannot be the zero address.
705      * - `recipient` cannot be the zero address.
706      * - `sender` must have a balance of at least `amount`.
707      */
708     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
709         require(sender != address(0), "ERC20: transfer from the zero address");
710         require(recipient != address(0), "ERC20: transfer to the zero address");
711 
712         _beforeTokenTransfer(sender, recipient, amount);
713 
714         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
715         _balances[recipient] = _balances[recipient].add(amount);
716         emit Transfer(sender, recipient, amount);
717     }
718 
719     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
720      * the total supply.
721      *
722      * Emits a {Transfer} event with `from` set to the zero address.
723      *
724      * Requirements:
725      *
726      * - `to` cannot be the zero address.
727      */
728     function _mint(address account, uint256 amount) internal virtual {
729         require(account != address(0), "ERC20: mint to the zero address");
730 
731         _beforeTokenTransfer(address(0), account, amount);
732 
733         _totalSupply = _totalSupply.add(amount);
734         _balances[account] = _balances[account].add(amount);
735         emit Transfer(address(0), account, amount);
736     }
737 
738     /**
739      * @dev Destroys `amount` tokens from `account`, reducing the
740      * total supply.
741      *
742      * Emits a {Transfer} event with `to` set to the zero address.
743      *
744      * Requirements:
745      *
746      * - `account` cannot be the zero address.
747      * - `account` must have at least `amount` tokens.
748      */
749     function _burn(address account, uint256 amount) internal virtual {
750         require(account != address(0), "ERC20: burn from the zero address");
751 
752         _beforeTokenTransfer(account, address(0), amount);
753 
754         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
755         _totalSupply = _totalSupply.sub(amount);
756         emit Transfer(account, address(0), amount);
757     }
758 
759     /**
760      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
761      *
762      * This internal function is equivalent to `approve`, and can be used to
763      * e.g. set automatic allowances for certain subsystems, etc.
764      *
765      * Emits an {Approval} event.
766      *
767      * Requirements:
768      *
769      * - `owner` cannot be the zero address.
770      * - `spender` cannot be the zero address.
771      */
772     function _approve(address owner, address spender, uint256 amount) internal virtual {
773         require(owner != address(0), "ERC20: approve from the zero address");
774         require(spender != address(0), "ERC20: approve to the zero address");
775 
776         _allowances[owner][spender] = amount;
777         emit Approval(owner, spender, amount);
778     }
779 
780     /**
781      * @dev Sets {decimals} to a value other than the default one of 18.
782      *
783      * WARNING: This function should only be called from the constructor. Most
784      * applications that interact with token contracts will not expect
785      * {decimals} to ever change, and may work incorrectly if it does.
786      */
787     function _setupDecimals(uint8 decimals_) internal {
788         _decimals = decimals_;
789     }
790 
791     /**
792      * @dev Hook that is called before any transfer of tokens. This includes
793      * minting and burning.
794      *
795      * Calling conditions:
796      *
797      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
798      * will be to transferred to `to`.
799      * - when `from` is zero, `amount` tokens will be minted for `to`.
800      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
801      * - `from` and `to` are never both zero.
802      *
803      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
804      */
805     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
806 }
807 
808 pragma solidity ^0.6.0;
809 
810 library SafeERC20 {
811     using SafeMath for uint256;
812     using Address for address;
813 
814     function safeTransfer(IERC20 token, address to, uint256 value) internal {
815         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
816     }
817 
818     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
819         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
820     }
821 
822     /**
823      * @dev Deprecated. This function has issues similar to the ones found in
824      * {IERC20-approve}, and its usage is discouraged.
825      *
826      * Whenever possible, use {safeIncreaseAllowance} and
827      * {safeDecreaseAllowance} instead.
828      */
829     function safeApprove(IERC20 token, address spender, uint256 value) internal {
830         // safeApprove should only be called when setting an initial allowance,
831         // or when resetting it to zero. To increase and decrease it, use
832         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
833         // solhint-disable-next-line max-line-length
834         require((value == 0) || (token.allowance(address(this), spender) == 0),
835             "SafeERC20: approve from non-zero to non-zero allowance"
836         );
837         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
838     }
839 
840     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
841         uint256 newAllowance = token.allowance(address(this), spender).add(value);
842         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
843     }
844 
845     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
846         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
847         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
848     }
849 
850     /**
851      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
852      * on the return value: the return value is optional (but if data is returned, it must not be false).
853      * @param token The token targeted by the call.
854      * @param data The call data (encoded using abi.encode or one of its variants).
855      */
856     function _callOptionalReturn(IERC20 token, bytes memory data) private {
857         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
858         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
859         // the target address contains contract code and also asserts for success in the low-level call.
860 
861         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
862         if (returndata.length > 0) { // Return data is optional
863             // solhint-disable-next-line max-line-length
864             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
865         }
866     }
867 }
868 
869 // File: staking-audit.sol
870 
871 pragma solidity ^0.6.12;
872 pragma experimental ABIEncoderV2;
873 
874 contract DarkPool is ERC20("DarkPool", "pDARK"), Ownable {
875     using SafeMath for uint256;
876     using SafeERC20 for IERC20;
877 
878 // ------------ Multi darklisted_ Tokens rewarding ---------------------------------------
879 
880     IERC20 public DARK = IERC20(0x3108ccFd96816F9E663baA0E8c5951D229E8C6da);
881 
882     uint256 public darklisted_duration = 50 days;
883     uint256 public darklisted_period_finish = 0;
884     uint256 public darklisted_last_update_time;
885     uint256 public darklisted_newreward;
886     uint256 public darklisted_reward_handout;
887 
888     address[] public darklisted_token;
889     address[] public darklisted_reward_account_list;
890     
891     mapping(address => bool) public darklisted_staker_accepted;
892 
893     mapping(address => uint256) public darklisted_reward_per_token_stored;
894     mapping(address => uint256) public darklisted_reward_rate;
895 
896     mapping(address => mapping (address => uint)) public darklisted_each_account_rewards;
897     mapping(address => mapping (address => uint)) public darklisted_user_reward_per_token_paid;
898 
899     event RewardAdded(uint256 darklisted_newreward);
900     event Staked(address indexed user, uint256 amount);
901     event Withdrawn(address indexed user, uint256 amount);
902     event RewardPaid(address indexed user, uint256 reward);
903 
904 // ------------ Listing Tokens ---------------------------------------
905 
906     address public DARK_listed = 0x3108ccFd96816F9E663baA0E8c5951D229E8C6da;
907     address public sDARK_listed = 0x26c7D50B9f372e1FA9cA078CC054298f36D68B17;
908     address public darkDAI_listed = 0x8a10eEf5A822879D5682A71F52bC8969eEE8D77a;
909     address public MATIC_listed = 0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0;
910     address public Storj_listed = 0xB64ef51C888972c908CFacf59B47C1AfBC0Ab8aC;
911     address public ENJ_listed = 0xF629cBd94d3791C9250152BD8dfBDF380E2a3B9c;
912 
913 
914     constructor() public {
915         darklisted_token.push(0x3108ccFd96816F9E663baA0E8c5951D229E8C6da);
916         darklisted_token.push(0x26c7D50B9f372e1FA9cA078CC054298f36D68B17);
917         darklisted_token.push(0x8a10eEf5A822879D5682A71F52bC8969eEE8D77a);
918         darklisted_token.push(0x7D1AfA7B718fb893dB30A3aBc0Cfc608AaCfeBB0);
919         darklisted_token.push(0xB64ef51C888972c908CFacf59B47C1AfBC0Ab8aC);
920         darklisted_token.push(0xF629cBd94d3791C9250152BD8dfBDF380E2a3B9c);
921     }
922 
923     function approve_darkListing(address _darklisted_token) public onlyOwner {
924         require(_darklisted_token != address(0), "Cannot be adddress(0)");
925 
926         darklisted_token.push(_darklisted_token);
927     }
928 
929     function revoke_darkListing() public onlyOwner {
930 
931         darklisted_token.pop();
932     }
933 
934 // ------------ Pool Duration ---------------------------------------
935 
936     function set_duration(uint256 _darklisted_duration) external onlyOwner {
937         require(_darklisted_duration != 0, "Cannot be 0 days");
938 
939         darklisted_duration = _darklisted_duration;
940     }
941 
942     function set_period_finish() external onlyOwner {
943 
944         darklisted_period_finish = block.timestamp.add(darklisted_duration);
945     }
946 
947 // ------------ Modifier and Modifier Function ---------------------------------------
948 
949     modifier darklisted_updateReward(address account, address token) {
950         darklisted_reward_per_token_stored[token] = darklisted_rewardPerToken(token);
951         darklisted_last_update_time = darklisted_lastTimeRewardApplicable();
952         if (account != address(0)) {
953             darklisted_each_account_rewards[account][token] = darklisted_earned(account, token);
954             darklisted_user_reward_per_token_paid[account][token] = darklisted_reward_per_token_stored[token];
955         }
956         _;
957     }
958 
959     function darklisted_updateReward_function(address account, address token) internal {
960         darklisted_reward_per_token_stored[token] = darklisted_rewardPerToken(token);
961         darklisted_last_update_time = darklisted_lastTimeRewardApplicable();
962         if (account != address(0)) {
963             darklisted_each_account_rewards[account][token] = darklisted_earned(account, token);
964             darklisted_user_reward_per_token_paid[account][token] = darklisted_reward_per_token_stored[token];
965         }
966     }
967 
968 // ------------ darklisted_ Rewards Logics--------------------------------
969 
970     function darklisted_lastTimeRewardApplicable() public view returns(uint256) {
971         return Math.min(block.timestamp, darklisted_period_finish);
972     }
973 
974     function darklisted_rewardPerToken(address token) public view returns(uint256) {
975 
976         if (totalSupply() == 0) {
977             return darklisted_reward_per_token_stored[token];
978         }
979 
980         return darklisted_reward_per_token_stored[token].add(
981         darklisted_lastTimeRewardApplicable().sub(darklisted_last_update_time).mul(darklisted_reward_rate[token]).mul(1e18).div(totalSupply())
982         );
983             
984     }
985     
986 
987     function darklisted_earned(address account, address token) public view returns(uint256) {
988         return balanceOf(account).mul(
989         darklisted_rewardPerToken(token).sub(darklisted_user_reward_per_token_paid[account][token])
990         ).div(1e18).add(darklisted_each_account_rewards[account][token]);
991     }
992 
993     function stake(uint256 amount) public darklisted_updateReward(msg.sender, 0x3108ccFd96816F9E663baA0E8c5951D229E8C6da) {
994         require(amount > 1e18, "At least 1 DARK");
995 
996         if (balanceOf(msg.sender) == 0 && !darklisted_staker_accepted[msg.sender]) {
997             darklisted_staker_accepted[msg.sender] = true;
998             darklisted_reward_account_list.push(msg.sender);
999         }
1000 
1001         _mint(msg.sender, amount);
1002         DARK.safeTransferFrom(msg.sender, address(this), amount);
1003         emit Staked(msg.sender, amount);
1004     }
1005 
1006     function withdraw(uint256 _share) public darklisted_updateReward(msg.sender, 0x3108ccFd96816F9E663baA0E8c5951D229E8C6da) {
1007         require(_share > 0, "Cannot withdraw 0");
1008         uint amount_ = balanceOf(msg.sender).sub(_share);
1009         if (amount_ == 0) {
1010             darklisted_staker_accepted[msg.sender] = false;
1011             uint256 index = 0;
1012             while (darklisted_reward_account_list[index] != msg.sender) {
1013                 index++;
1014             }
1015             darklisted_reward_account_list[index] = darklisted_reward_account_list[darklisted_reward_account_list.length.sub(1)];
1016             darklisted_reward_account_list.pop();
1017         }
1018 
1019         _burn(msg.sender, _share);
1020         DARK.safeTransfer(msg.sender, _share);
1021         emit Withdrawn(msg.sender, _share);
1022     }
1023 
1024     function exit() public {
1025         withdraw(balanceOf(msg.sender));
1026         getReward();
1027     }
1028 
1029     function getReward() public {
1030         getReward_For_All(msg.sender, DARK_listed);
1031     }
1032 
1033     function darklisted_notifyRewardAmount() external {
1034 
1035         for(uint d = 0; d< darklisted_token.length; d++){
1036             darklisted_updateReward_function(address(0), darklisted_token[d]);
1037             if (darklisted_token[d] == 0x3108ccFd96816F9E663baA0E8c5951D229E8C6da) {
1038                 darklisted_newreward = DARK.balanceOf(address(this)).sub(totalSupply());
1039             } else {
1040                 darklisted_newreward = IERC20(darklisted_token[d]).balanceOf(address(this));
1041             }
1042             if (block.timestamp >= darklisted_period_finish) {
1043                 darklisted_reward_rate[darklisted_token[d]] = darklisted_newreward.div(darklisted_duration);
1044             } else {
1045                 uint256 remaining = darklisted_period_finish.sub(block.timestamp);
1046                 uint256 leftover = remaining.mul(darklisted_reward_rate[darklisted_token[d]]);
1047                 darklisted_reward_rate[darklisted_token[d]] = darklisted_newreward.add(leftover).div(darklisted_duration);
1048             }
1049             darklisted_last_update_time = block.timestamp;
1050             emit RewardAdded(darklisted_newreward);
1051         }
1052     }
1053     
1054     function getReward_For_All(address account, address token) public darklisted_updateReward(account, token) {
1055 
1056         darklisted_reward_handout = darklisted_earned(account, token);
1057         if (darklisted_reward_handout > 0) {
1058             darklisted_each_account_rewards[account][token] = 0;
1059             IERC20(token).safeTransfer(account, darklisted_reward_handout);
1060             emit RewardPaid(account, darklisted_reward_handout);
1061         }
1062     }
1063 
1064     function darklisted_getReward_For_DARK() public {
1065         for(uint i = 0; i< darklisted_reward_account_list.length; i++){
1066             getReward_For_All(darklisted_reward_account_list[i], darklisted_token[0]);
1067         }
1068     }
1069 
1070     function darklisted_getReward_For_sDARK() public {
1071         for(uint i = 0; i< darklisted_reward_account_list.length; i++){
1072             getReward_For_All(darklisted_reward_account_list[i], darklisted_token[1]);
1073         }
1074     }
1075 
1076     function darklisted_getReward_For_darkDAI() public {
1077         for(uint i = 0; i< darklisted_reward_account_list.length; i++){
1078             getReward_For_All(darklisted_reward_account_list[i], darklisted_token[2]);
1079         }
1080     }
1081 
1082     function darklisted_getReward_For_darkMATIC() public {
1083         for(uint i = 0; i< darklisted_reward_account_list.length; i++){
1084             getReward_For_All(darklisted_reward_account_list[i], darklisted_token[3]);
1085         }
1086     }
1087 
1088     function darklisted_getReward_For_darkStorj() public {
1089         for(uint i = 0; i< darklisted_reward_account_list.length; i++){
1090             getReward_For_All(darklisted_reward_account_list[i], darklisted_token[4]);
1091         }
1092     }
1093 
1094     function darklisted_getReward_For_darkEnj() public {
1095         for(uint i = 0; i< darklisted_reward_account_list.length; i++){
1096             getReward_For_All(darklisted_reward_account_list[i], darklisted_token[5]);
1097         }
1098     }
1099 
1100     function darklisted_getReward_For_darkfuturefuturetoken(uint index) public {
1101         for(uint i = 0; i< darklisted_reward_account_list.length; i++){
1102             getReward_For_All(darklisted_reward_account_list[i], darklisted_token[index]);
1103         }
1104     }
1105 
1106 //--------------- 100 Addresses a list -----------------
1107 
1108     mapping(uint => address[]) public darklisted_reward_account_list_indexed;
1109 
1110     function sort_lists() public onlyOwner {
1111  
1112         if (darklisted_reward_account_list.length >= 100) {
1113             
1114              for(uint i = 0; i< darklisted_reward_account_list.length.div(100).add(1); i++) {
1115 
1116                  if (i == darklisted_reward_account_list.length.div(100)) {
1117                      
1118                      for(uint j = 0; j< darklisted_reward_account_list.length.sub(i.mul(100)); j++){
1119                          
1120                          darklisted_reward_account_list_indexed[i].push(darklisted_reward_account_list[i.mul(100).add(j)]);
1121                      }
1122                  } else {
1123                      
1124                      for(uint j = 0; j< 100; j++){
1125                          
1126                          darklisted_reward_account_list_indexed[i].push(darklisted_reward_account_list[i.mul(100).add(j)]);
1127                      }
1128                     
1129                  }
1130              }
1131         } else {
1132             darklisted_reward_account_list_indexed[0] = darklisted_reward_account_list;
1133         }
1134     }
1135 
1136     function darklisted_getReward_For_DARK_list(uint index) public {
1137         for(uint i = 0; i< darklisted_reward_account_list_indexed[index].length; i++){
1138             getReward_For_All(darklisted_reward_account_list_indexed[index][i], darklisted_token[0]);
1139         }
1140     }
1141 
1142     function darklisted_getReward_For_sDARK_list(uint index) public {
1143         for(uint i = 0; i< darklisted_reward_account_list_indexed[index].length; i++){
1144             getReward_For_All(darklisted_reward_account_list_indexed[index][i], darklisted_token[1]);
1145         }
1146     }
1147 
1148     function darklisted_getReward_For_darkDAI_list(uint index) public {
1149         for(uint i = 0; i< darklisted_reward_account_list_indexed[index].length; i++){
1150             getReward_For_All(darklisted_reward_account_list_indexed[index][i], darklisted_token[2]);
1151         }
1152     }
1153 
1154     function darklisted_getReward_For_darkMATIC_list(uint index) public {
1155         for(uint i = 0; i< darklisted_reward_account_list_indexed[index].length; i++){
1156             getReward_For_All(darklisted_reward_account_list_indexed[index][i], darklisted_token[3]);
1157         }
1158     }
1159 
1160     function darklisted_getReward_For_darkStorj_list(uint index) public {
1161         for(uint i = 0; i< darklisted_reward_account_list_indexed[index].length; i++){
1162             getReward_For_All(darklisted_reward_account_list_indexed[index][i], darklisted_token[4]);
1163         }
1164     }
1165 
1166     function darklisted_getReward_For_darkEnj_list(uint index) public {
1167         for(uint i = 0; i< darklisted_reward_account_list_indexed[index].length; i++){
1168             getReward_For_All(darklisted_reward_account_list_indexed[index][i], darklisted_token[5]);
1169         }
1170     }
1171 
1172     function darklisted_getReward_For_darkfuturetoken_list(uint index, uint indexx) public {
1173         for(uint i = 0; i< darklisted_reward_account_list_indexed[index].length; i++){
1174             getReward_For_All(darklisted_reward_account_list_indexed[index][i], darklisted_token[indexx]);
1175         }
1176     }
1177 
1178     function reward_account_list_length() public view returns (uint) {
1179         return (darklisted_reward_account_list.length);
1180     }
1181 
1182     function reward_account_list_data() public view returns (address[] memory) {
1183         return (darklisted_reward_account_list);
1184     }
1185 
1186     function reward_account_list_indexed_data(uint index) public view returns (address[] memory) {
1187         return (darklisted_reward_account_list_indexed[index]);
1188     }
1189 }