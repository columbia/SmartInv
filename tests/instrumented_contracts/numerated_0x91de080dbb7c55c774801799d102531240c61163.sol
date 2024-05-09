1 // File: contracts/ChiGasSaver.sol
2 
3 pragma solidity >=0.4.22 <0.8.0;
4 
5 interface IFreeFromUpTo {
6    function freeFromUpTo(address from, uint256 value) external returns(uint256 freed);
7 }
8 
9 contract ChiGasSaver {
10 
11    modifier saveGas(address payable sponsor, address chiToken) {
12        uint256 gasStart = gasleft();
13        _;
14        uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
15 
16        IFreeFromUpTo chi = IFreeFromUpTo(chiToken);
17        chi.freeFromUpTo(sponsor, (gasSpent + 14154) / 41947);
18    }
19 }
20 
21 // File: @openzeppelin/contracts/GSN/Context.sol
22 
23 
24 
25 
26 
27 /*
28  * @dev Provides information about the current execution context, including the
29  * sender of the transaction and its data. While these are generally available
30  * via msg.sender and msg.data, they should not be accessed in such a direct
31  * manner, since when dealing with GSN meta-transactions the account sending and
32  * paying for execution may not be the actual sender (as far as an application
33  * is concerned).
34  *
35  * This contract is only required for intermediate, library-like contracts.
36  */
37 abstract contract Context {
38     function _msgSender() internal view virtual returns (address payable) {
39         return msg.sender;
40     }
41 
42     function _msgData() internal view virtual returns (bytes memory) {
43         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
44         return msg.data;
45     }
46 }
47 
48 // File: @openzeppelin/contracts/access/Ownable.sol
49 
50 
51 
52 
53 /**
54  * @dev Contract module which provides a basic access control mechanism, where
55  * there is an account (an owner) that can be granted exclusive access to
56  * specific functions.
57  *
58  * By default, the owner account will be the one that deploys the contract. This
59  * can later be changed with {transferOwnership}.
60  *
61  * This module is used through inheritance. It will make available the modifier
62  * `onlyOwner`, which can be applied to your functions to restrict their use to
63  * the owner.
64  */
65 contract Ownable is Context {
66     address private _owner;
67 
68     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70     /**
71      * @dev Initializes the contract setting the deployer as the initial owner.
72      */
73     constructor () internal {
74         address msgSender = _msgSender();
75         _owner = msgSender;
76         emit OwnershipTransferred(address(0), msgSender);
77     }
78 
79     /**
80      * @dev Returns the address of the current owner.
81      */
82     function owner() public view returns (address) {
83         return _owner;
84     }
85 
86     /**
87      * @dev Throws if called by any account other than the owner.
88      */
89     modifier onlyOwner() {
90         require(_owner == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     /**
95      * @dev Leaves the contract without owner. It will not be possible to call
96      * `onlyOwner` functions anymore. Can only be called by the current owner.
97      *
98      * NOTE: Renouncing ownership will leave the contract without an owner,
99      * thereby removing any functionality that is only available to the owner.
100      */
101     function renounceOwnership() public virtual onlyOwner {
102         emit OwnershipTransferred(_owner, address(0));
103         _owner = address(0);
104     }
105 
106     /**
107      * @dev Transfers ownership of the contract to a new account (`newOwner`).
108      * Can only be called by the current owner.
109      */
110     function transferOwnership(address newOwner) public virtual onlyOwner {
111         require(newOwner != address(0), "Ownable: new owner is the zero address");
112         emit OwnershipTransferred(_owner, newOwner);
113         _owner = newOwner;
114     }
115 }
116 
117 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
118 
119 
120 
121 
122 /**
123  * @dev Interface of the ERC20 standard as defined in the EIP.
124  */
125 interface IERC20 {
126     /**
127      * @dev Returns the amount of tokens in existence.
128      */
129     function totalSupply() external view returns (uint256);
130 
131     /**
132      * @dev Returns the amount of tokens owned by `account`.
133      */
134     function balanceOf(address account) external view returns (uint256);
135 
136     /**
137      * @dev Moves `amount` tokens from the caller's account to `recipient`.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * Emits a {Transfer} event.
142      */
143     function transfer(address recipient, uint256 amount) external returns (bool);
144 
145     /**
146      * @dev Returns the remaining number of tokens that `spender` will be
147      * allowed to spend on behalf of `owner` through {transferFrom}. This is
148      * zero by default.
149      *
150      * This value changes when {approve} or {transferFrom} are called.
151      */
152     function allowance(address owner, address spender) external view returns (uint256);
153 
154     /**
155      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * IMPORTANT: Beware that changing an allowance with this method brings the risk
160      * that someone may use both the old and the new allowance by unfortunate
161      * transaction ordering. One possible solution to mitigate this race
162      * condition is to first reduce the spender's allowance to 0 and set the
163      * desired value afterwards:
164      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165      *
166      * Emits an {Approval} event.
167      */
168     function approve(address spender, uint256 amount) external returns (bool);
169 
170     /**
171      * @dev Moves `amount` tokens from `sender` to `recipient` using the
172      * allowance mechanism. `amount` is then deducted from the caller's
173      * allowance.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * Emits a {Transfer} event.
178      */
179     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
180 
181     /**
182      * @dev Emitted when `value` tokens are moved from one account (`from`) to
183      * another (`to`).
184      *
185      * Note that `value` may be zero.
186      */
187     event Transfer(address indexed from, address indexed to, uint256 value);
188 
189     /**
190      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
191      * a call to {approve}. `value` is the new allowance.
192      */
193     event Approval(address indexed owner, address indexed spender, uint256 value);
194 }
195 
196 // File: @openzeppelin/contracts/math/SafeMath.sol
197 
198 
199 
200 
201 /**
202  * @dev Wrappers over Solidity's arithmetic operations with added overflow
203  * checks.
204  *
205  * Arithmetic operations in Solidity wrap on overflow. This can easily result
206  * in bugs, because programmers usually assume that an overflow raises an
207  * error, which is the standard behavior in high level programming languages.
208  * `SafeMath` restores this intuition by reverting the transaction when an
209  * operation overflows.
210  *
211  * Using this library instead of the unchecked operations eliminates an entire
212  * class of bugs, so it's recommended to use it always.
213  */
214 library SafeMath {
215     /**
216      * @dev Returns the addition of two unsigned integers, reverting on
217      * overflow.
218      *
219      * Counterpart to Solidity's `+` operator.
220      *
221      * Requirements:
222      *
223      * - Addition cannot overflow.
224      */
225     function add(uint256 a, uint256 b) internal pure returns (uint256) {
226         uint256 c = a + b;
227         require(c >= a, "SafeMath: addition overflow");
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the subtraction of two unsigned integers, reverting on
234      * overflow (when the result is negative).
235      *
236      * Counterpart to Solidity's `-` operator.
237      *
238      * Requirements:
239      *
240      * - Subtraction cannot overflow.
241      */
242     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
243         return sub(a, b, "SafeMath: subtraction overflow");
244     }
245 
246     /**
247      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
248      * overflow (when the result is negative).
249      *
250      * Counterpart to Solidity's `-` operator.
251      *
252      * Requirements:
253      *
254      * - Subtraction cannot overflow.
255      */
256     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b <= a, errorMessage);
258         uint256 c = a - b;
259 
260         return c;
261     }
262 
263     /**
264      * @dev Returns the multiplication of two unsigned integers, reverting on
265      * overflow.
266      *
267      * Counterpart to Solidity's `*` operator.
268      *
269      * Requirements:
270      *
271      * - Multiplication cannot overflow.
272      */
273     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
274         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
275         // benefit is lost if 'b' is also tested.
276         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
277         if (a == 0) {
278             return 0;
279         }
280 
281         uint256 c = a * b;
282         require(c / a == b, "SafeMath: multiplication overflow");
283 
284         return c;
285     }
286 
287     /**
288      * @dev Returns the integer division of two unsigned integers. Reverts on
289      * division by zero. The result is rounded towards zero.
290      *
291      * Counterpart to Solidity's `/` operator. Note: this function uses a
292      * `revert` opcode (which leaves remaining gas untouched) while Solidity
293      * uses an invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      *
297      * - The divisor cannot be zero.
298      */
299     function div(uint256 a, uint256 b) internal pure returns (uint256) {
300         return div(a, b, "SafeMath: division by zero");
301     }
302 
303     /**
304      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
305      * division by zero. The result is rounded towards zero.
306      *
307      * Counterpart to Solidity's `/` operator. Note: this function uses a
308      * `revert` opcode (which leaves remaining gas untouched) while Solidity
309      * uses an invalid opcode to revert (consuming all remaining gas).
310      *
311      * Requirements:
312      *
313      * - The divisor cannot be zero.
314      */
315     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
316         require(b > 0, errorMessage);
317         uint256 c = a / b;
318         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
319 
320         return c;
321     }
322 
323     /**
324      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
325      * Reverts when dividing by zero.
326      *
327      * Counterpart to Solidity's `%` operator. This function uses a `revert`
328      * opcode (which leaves remaining gas untouched) while Solidity uses an
329      * invalid opcode to revert (consuming all remaining gas).
330      *
331      * Requirements:
332      *
333      * - The divisor cannot be zero.
334      */
335     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
336         return mod(a, b, "SafeMath: modulo by zero");
337     }
338 
339     /**
340      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
341      * Reverts with custom message when dividing by zero.
342      *
343      * Counterpart to Solidity's `%` operator. This function uses a `revert`
344      * opcode (which leaves remaining gas untouched) while Solidity uses an
345      * invalid opcode to revert (consuming all remaining gas).
346      *
347      * Requirements:
348      *
349      * - The divisor cannot be zero.
350      */
351     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
352         require(b != 0, errorMessage);
353         return a % b;
354     }
355 }
356 
357 // File: @openzeppelin/contracts/utils/Address.sol
358 
359 
360 
361 /**
362  * @dev Collection of functions related to the address type
363  */
364 library Address {
365     /**
366      * @dev Returns true if `account` is a contract.
367      *
368      * [IMPORTANT]
369      * ====
370      * It is unsafe to assume that an address for which this function returns
371      * false is an externally-owned account (EOA) and not a contract.
372      *
373      * Among others, `isContract` will return false for the following
374      * types of addresses:
375      *
376      *  - an externally-owned account
377      *  - a contract in construction
378      *  - an address where a contract will be created
379      *  - an address where a contract lived, but was destroyed
380      * ====
381      */
382     function isContract(address account) internal view returns (bool) {
383         // This method relies in extcodesize, which returns 0 for contracts in
384         // construction, since the code is only stored at the end of the
385         // constructor execution.
386 
387         uint256 size;
388         // solhint-disable-next-line no-inline-assembly
389         assembly { size := extcodesize(account) }
390         return size > 0;
391     }
392 
393     /**
394      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
395      * `recipient`, forwarding all available gas and reverting on errors.
396      *
397      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
398      * of certain opcodes, possibly making contracts go over the 2300 gas limit
399      * imposed by `transfer`, making them unable to receive funds via
400      * `transfer`. {sendValue} removes this limitation.
401      *
402      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
403      *
404      * IMPORTANT: because control is transferred to `recipient`, care must be
405      * taken to not create reentrancy vulnerabilities. Consider using
406      * {ReentrancyGuard} or the
407      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
408      */
409     function sendValue(address payable recipient, uint256 amount) internal {
410         require(address(this).balance >= amount, "Address: insufficient balance");
411 
412         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
413         (bool success, ) = recipient.call{ value: amount }("");
414         require(success, "Address: unable to send value, recipient may have reverted");
415     }
416 
417     /**
418      * @dev Performs a Solidity function call using a low level `call`. A
419      * plain`call` is an unsafe replacement for a function call: use this
420      * function instead.
421      *
422      * If `target` reverts with a revert reason, it is bubbled up by this
423      * function (like regular Solidity function calls).
424      *
425      * Returns the raw returned data. To convert to the expected return value,
426      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
427      *
428      * Requirements:
429      *
430      * - `target` must be a contract.
431      * - calling `target` with `data` must not revert.
432      *
433      * _Available since v3.1._
434      */
435     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
436       return functionCall(target, data, "Address: low-level call failed");
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
441      * `errorMessage` as a fallback revert reason when `target` reverts.
442      *
443      * _Available since v3.1._
444      */
445     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
446         return _functionCallWithValue(target, data, 0, errorMessage);
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
451      * but also transferring `value` wei to `target`.
452      *
453      * Requirements:
454      *
455      * - the calling contract must have an ETH balance of at least `value`.
456      * - the called Solidity function must be `payable`.
457      *
458      * _Available since v3.1._
459      */
460     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
461         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
466      * with `errorMessage` as a fallback revert reason when `target` reverts.
467      *
468      * _Available since v3.1._
469      */
470     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
471         require(address(this).balance >= value, "Address: insufficient balance for call");
472         return _functionCallWithValue(target, data, value, errorMessage);
473     }
474 
475     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
476         require(isContract(target), "Address: call to non-contract");
477 
478         // solhint-disable-next-line avoid-low-level-calls
479         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
480         if (success) {
481             return returndata;
482         } else {
483             // Look for revert reason and bubble it up if present
484             if (returndata.length > 0) {
485                 // The easiest way to bubble the revert reason is using memory via assembly
486 
487                 // solhint-disable-next-line no-inline-assembly
488                 assembly {
489                     let returndata_size := mload(returndata)
490                     revert(add(32, returndata), returndata_size)
491                 }
492             } else {
493                 revert(errorMessage);
494             }
495         }
496     }
497 }
498 
499 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
500 
501 // SPDX-License-Identifier: MIT
502 
503 
504 
505 
506 
507 
508 
509 /**
510  * @dev Implementation of the {IERC20} interface.
511  *
512  * This implementation is agnostic to the way tokens are created. This means
513  * that a supply mechanism has to be added in a derived contract using {_mint}.
514  * For a generic mechanism see {ERC20PresetMinterPauser}.
515  *
516  * TIP: For a detailed writeup see our guide
517  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
518  * to implement supply mechanisms].
519  *
520  * We have followed general OpenZeppelin guidelines: functions revert instead
521  * of returning `false` on failure. This behavior is nonetheless conventional
522  * and does not conflict with the expectations of ERC20 applications.
523  *
524  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
525  * This allows applications to reconstruct the allowance for all accounts just
526  * by listening to said events. Other implementations of the EIP may not emit
527  * these events, as it isn't required by the specification.
528  *
529  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
530  * functions have been added to mitigate the well-known issues around setting
531  * allowances. See {IERC20-approve}.
532  */
533 contract ERC20 is Context, IERC20 {
534     using SafeMath for uint256;
535     using Address for address;
536 
537     mapping (address => uint256) private _balances;
538 
539     mapping (address => mapping (address => uint256)) private _allowances;
540 
541     uint256 private _totalSupply;
542 
543     string private _name;
544     string private _symbol;
545     uint8 private _decimals;
546 
547     /**
548      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
549      * a default value of 18.
550      *
551      * To select a different value for {decimals}, use {_setupDecimals}.
552      *
553      * All three of these values are immutable: they can only be set once during
554      * construction.
555      */
556     constructor (string memory name, string memory symbol) public {
557         _name = name;
558         _symbol = symbol;
559         _decimals = 18;
560     }
561 
562     /**
563      * @dev Returns the name of the token.
564      */
565     function name() public view returns (string memory) {
566         return _name;
567     }
568 
569     /**
570      * @dev Returns the symbol of the token, usually a shorter version of the
571      * name.
572      */
573     function symbol() public view returns (string memory) {
574         return _symbol;
575     }
576 
577     /**
578      * @dev Returns the number of decimals used to get its user representation.
579      * For example, if `decimals` equals `2`, a balance of `505` tokens should
580      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
581      *
582      * Tokens usually opt for a value of 18, imitating the relationship between
583      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
584      * called.
585      *
586      * NOTE: This information is only used for _display_ purposes: it in
587      * no way affects any of the arithmetic of the contract, including
588      * {IERC20-balanceOf} and {IERC20-transfer}.
589      */
590     function decimals() public view returns (uint8) {
591         return _decimals;
592     }
593 
594     /**
595      * @dev See {IERC20-totalSupply}.
596      */
597     function totalSupply() public view override returns (uint256) {
598         return _totalSupply;
599     }
600 
601     /**
602      * @dev See {IERC20-balanceOf}.
603      */
604     function balanceOf(address account) public view override returns (uint256) {
605         return _balances[account];
606     }
607 
608     /**
609      * @dev See {IERC20-transfer}.
610      *
611      * Requirements:
612      *
613      * - `recipient` cannot be the zero address.
614      * - the caller must have a balance of at least `amount`.
615      */
616     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
617         _transfer(_msgSender(), recipient, amount);
618         return true;
619     }
620 
621     /**
622      * @dev See {IERC20-allowance}.
623      */
624     function allowance(address owner, address spender) public view virtual override returns (uint256) {
625         return _allowances[owner][spender];
626     }
627 
628     /**
629      * @dev See {IERC20-approve}.
630      *
631      * Requirements:
632      *
633      * - `spender` cannot be the zero address.
634      */
635     function approve(address spender, uint256 amount) public virtual override returns (bool) {
636         _approve(_msgSender(), spender, amount);
637         return true;
638     }
639 
640     /**
641      * @dev See {IERC20-transferFrom}.
642      *
643      * Emits an {Approval} event indicating the updated allowance. This is not
644      * required by the EIP. See the note at the beginning of {ERC20};
645      *
646      * Requirements:
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
724      * Requirements
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
744      * Requirements
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
808 // File: contracts/TellorProxy.sol
809 
810 
811 
812 
813 
814 
815 
816 interface ITellor {
817   function addTip(uint256 _requestId, uint256 _tip) external;
818   function submitMiningSolution(string calldata _nonce, uint256 _requestId, uint256 _value) external;
819   function submitMiningSolution(string calldata _nonce,uint256[5] calldata _requestId, uint256[5] calldata _value) external;
820   function depositStake() external;
821   function requestStakingWithdraw() external;
822   function withdrawStake() external;
823   function vote(uint256 _disputeId, bool _supportsDispute) external;
824 }
825 
826 
827 contract TellorProxy is ChiGasSaver, Ownable, ERC20 {
828 
829   address tellorAddress;   // Address of Tellor Oracle
830   address gasToken;        // Gas token address to use for gas saver
831   uint256 stakedAt;        // Timestamp when the stake was deposited
832   uint256 unstakedAt;      // Timestamp when the stake was withdrawn
833   uint256 fee;             // Fee that stakers collect, where 100 is 1%
834   uint256 stakeAmount;     // The Tellor token staking amount
835   uint256 feesCollected;   // The fees collected for the stakers
836 
837   constructor(address _tellorAddress,
838     address _gasToken,
839     uint256 _fee,
840     uint256 _stakeAmount)
841     public
842     // NOTE: Change the token name and symbol for each staked miner
843     // Use the form: TPS-YYYYMMDD
844     // Where YYYY == year, MM == month, and DD = day the token is redeamable
845     ERC20("Tellorpool Token (2020-11-22)", "TPS-20201122")
846   {
847     tellorAddress = _tellorAddress;
848     gasToken = _gasToken;
849     fee = _fee;
850     stakeAmount = _stakeAmount * 1e18;
851     feesCollected = 0;
852   }
853 
854   // Enter the contract, get TPS for your TRB
855   function enter(uint256 _amount) public {
856     require(IERC20(tellorAddress).transferFrom(msg.sender, address(this), _amount));
857     _mint(msg.sender, _amount);
858     require(totalSupply() <= stakeAmount, "CAN NOT ACCEPT MORE THAN STAKE AMOUNT");
859   }
860 
861   // Leave the contract, get TRB for your TPS
862   function leave() public {
863     // Can only leave after the contract has been unstaked or before staking
864     require(unstakedAt != 0 || stakedAt == 0, "NOT UNSTAKED YET");
865     uint256 totalTRB = IERC20(tellorAddress).balanceOf(address(this));
866     uint256 totalShares = totalSupply();
867     uint256 theirShares = balanceOf(msg.sender);
868     uint256 theirTRB = totalTRB.mul(theirShares).div(totalShares);
869     _burn(msg.sender, theirShares);
870     require(IERC20(tellorAddress).transfer(msg.sender, theirTRB));
871   }
872 
873   // Close the contract, send remaining balance to owner
874   function close() external onlyOwner {
875     // Can only close after being unstaked for 90 days
876     // or after 365 days from staking (in case of dispute)
877     require((unstakedAt < now - 90 days && unstakedAt != 0) || (stakedAt < now - 365 days && stakedAt != 0), "CAN NOT CLOSE YET");
878     uint256 leftovers = IERC20(tellorAddress).balanceOf(address(this));
879     require(IERC20(tellorAddress).transfer(owner(), leftovers));
880   }
881 
882   // Withdraw rewards less fees
883   function withdrawRewards() external onlyOwner {
884     require(unstakedAt == 0, "NO WITHDRAWS AFTER UNSTAKING");
885     require(stakedAt != 0, "NO WITHDRAWS BEFORE STAKING");
886     uint256 surplus = IERC20(tellorAddress).balanceOf(address(this)) - stakeAmount - feesCollected;
887     uint256 available = surplus.mul(10000 - fee).div(10000);
888     feesCollected += surplus - available;
889     require(IERC20(tellorAddress).transfer(owner(), available));
890   }
891 
892   // Returns the TRB value of the token with 5 decimals of percision
893   function getTokenValue() external view returns (uint256) {
894     if (stakedAt != 0) {
895       return (stakeAmount + feesCollected).mul(100000).div(totalSupply());
896     } else {
897       return 100000;
898     }
899   }
900 
901   // Returns the fee as a percentage with 2 decimals of percision
902   function getFee() external view returns (uint256) {
903     return fee;
904   }
905 
906   // Withdraw for other tokens if not Tellor
907   function tokenWithdraw(address _tokenAddress, uint256 _amount)
908     external
909     onlyOwner
910   {
911     require(_tokenAddress != tellorAddress, "CAN NOT WITHDRAW TRB");
912     require(IERC20(_tokenAddress).transfer(owner(), _amount));
913   }
914 
915   function addTip(uint256 _requestId, uint256 _tip)
916     external
917     onlyOwner
918     saveGas(msg.sender, gasToken)
919   {
920     ITellor(tellorAddress).addTip(_requestId, _tip);
921   }
922 
923   function submitMiningSolutionSaveGas(string calldata _nonce, uint256 _requestId, uint256 _value)
924     external
925     onlyOwner
926     saveGas(msg.sender, gasToken)
927   {
928     ITellor(tellorAddress).submitMiningSolution(_nonce, _requestId, _value);
929   }
930 
931   function submitMiningSolutionSaveGas(string calldata _nonce, uint256[5] calldata _requestId, uint256[5] calldata _value)
932     external
933     onlyOwner
934     saveGas(msg.sender, gasToken)
935   {
936     ITellor(tellorAddress).submitMiningSolution(_nonce, _requestId, _value);
937   }
938 
939   function submitMiningSolution(string calldata _nonce, uint256 _requestId, uint256 _value)
940     external
941     onlyOwner
942   {
943     ITellor(tellorAddress).submitMiningSolution(_nonce, _requestId, _value);
944   }
945 
946   function submitMiningSolution(string calldata _nonce, uint256[5] calldata _requestId, uint256[5] calldata _value)
947     external
948     onlyOwner
949   {
950     ITellor(tellorAddress).submitMiningSolution(_nonce, _requestId, _value);
951   }
952 
953   function depositStake()
954     external
955     onlyOwner
956   {
957     stakedAt = now;
958     ITellor(tellorAddress).depositStake();
959   }
960 
961   function requestStakingWithdraw()
962     external
963     onlyOwner
964   {
965     ITellor(tellorAddress).requestStakingWithdraw();
966   }
967 
968   function withdrawStake()
969     external
970     onlyOwner
971   {
972     unstakedAt = now;
973     ITellor(tellorAddress).withdrawStake();
974   }
975 
976   function vote(uint256 _disputeId, bool _supportsDispute)
977     external
978     onlyOwner
979   {
980     ITellor(tellorAddress).vote(_disputeId, _supportsDispute);
981   }
982 
983 }