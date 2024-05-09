1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.7.6;
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      *
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      *
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      *
57      * - Subtraction cannot overflow.
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      *
74      * - Multiplication cannot overflow.
75      */
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
78         // benefit is lost if 'b' is also tested.
79         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
80         if (a == 0) {
81             return 0;
82         }
83 
84         uint256 c = a * b;
85         require(c / a == b, "SafeMath: multiplication overflow");
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the integer division of two unsigned integers. Reverts on
92      * division by zero. The result is rounded towards zero.
93      *
94      * Counterpart to Solidity's `/` operator. Note: this function uses a
95      * `revert` opcode (which leaves remaining gas untouched) while Solidity
96      * uses an invalid opcode to revert (consuming all remaining gas).
97      *
98      * Requirements:
99      *
100      * - The divisor cannot be zero.
101      */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105 
106     /**
107      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
108      * division by zero. The result is rounded towards zero.
109      *
110      * Counterpart to Solidity's `/` operator. Note: this function uses a
111      * `revert` opcode (which leaves remaining gas untouched) while Solidity
112      * uses an invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      *
116      * - The divisor cannot be zero.
117      */
118     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         return mod(a, b, "SafeMath: modulo by zero");
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts with custom message when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 /*
161  * @dev Provides information about the current execution context, including the
162  * sender of the transaction and its data. While these are generally available
163  * via msg.sender and msg.data, they should not be accessed in such a direct
164  * manner, since when dealing with GSN meta-transactions the account sending and
165  * paying for execution may not be the actual sender (as far as an application
166  * is concerned).
167  *
168  * This contract is only required for intermediate, library-like contracts.
169  */
170 abstract contract Context {
171     function _msgSender() internal view virtual returns (address payable) {
172         return msg.sender;
173     }
174 
175     function _msgData() internal view virtual returns (bytes memory) {
176         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
177         return msg.data;
178     }
179 }
180 
181 /**
182  * @dev Contract module which provides a basic access control mechanism, where
183  * there is an account (an owner) that can be granted exclusive access to
184  * specific functions.
185  *
186  * By default, the owner account will be the one that deploys the contract. This
187  * can later be changed with {transferOwnership}.
188  *
189  * This module is used through inheritance. It will make available the modifier
190  * `onlyOwner`, which can be applied to your functions to restrict their use to
191  * the owner.
192  */
193 abstract contract Ownable is Context {
194     address private _owner;
195     address private _potentialOwner;
196 
197     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
198     event OwnerNominated(address potentialOwner);
199 
200     /**
201      * @dev Initializes the contract setting the deployer as the initial owner.
202      */
203     constructor () internal {
204         address msgSender = _msgSender();
205         _owner = msgSender;
206         emit OwnershipTransferred(address(0), msgSender);
207     }
208 
209     /**
210      * @dev Returns the address of the current owner.
211      */
212     function owner() public view returns (address) {
213         return _owner;
214     }
215 
216     /**
217      * @dev Returns the address of the current potentialOwner.
218      */
219     function potentialOwner() public view returns (address) {
220         return _potentialOwner;
221     }
222 
223     /**
224      * @dev Throws if called by any account other than the owner.
225      */
226     modifier onlyOwner() {
227         require(_owner == _msgSender(), "Ownable: caller is not the owner");
228         _;
229     }
230 
231     /**
232      * @dev Leaves the contract without owner. It will not be possible to call
233      * `onlyOwner` functions anymore. Can only be called by the current owner.
234      *
235      * NOTE: Renouncing ownership will leave the contract without an owner,
236      * thereby removing any functionality that is only available to the owner.
237      */
238     function renounceOwnership() public virtual onlyOwner {
239         emit OwnershipTransferred(_owner, address(0));
240         _owner = address(0);
241     }
242 
243     /**
244      * @dev Transfers ownership of the contract to a new account (`newOwner`).
245      * Can only be called by the current owner.
246      */
247     function transferOwnership(address newOwner) public virtual onlyOwner {
248         require(newOwner != address(0), "Ownable: new owner is the zero address");
249         emit OwnershipTransferred(_owner, newOwner);
250         _owner = newOwner;
251     }
252 
253     function nominatePotentialOwner(address newOwner) public virtual onlyOwner {
254         _potentialOwner = newOwner;
255         emit OwnerNominated(newOwner);
256     }
257 
258     function acceptOwnership () public virtual {
259         require(msg.sender == _potentialOwner, 'You must be nominated as potential owner before you can accept ownership');
260         emit OwnershipTransferred(_owner, _potentialOwner);
261         _owner = _potentialOwner;
262         _potentialOwner = address(0);
263     }
264 }
265 
266 /**
267  * @dev Collection of functions related to the address type
268  */
269 library Address {
270     /**
271      * @dev Returns true if `account` is a contract.
272      *
273      * [IMPORTANT]
274      * ====
275      * It is unsafe to assume that an address for which this function returns
276      * false is an externally-owned account (EOA) and not a contract.
277      *
278      * Among others, `isContract` will return false for the following
279      * types of addresses:
280      *
281      *  - an externally-owned account
282      *  - a contract in construction
283      *  - an address where a contract will be created
284      *  - an address where a contract lived, but was destroyed
285      * ====
286      */
287     function isContract(address account) internal view returns (bool) {
288         // This method relies on extcodesize, which returns 0 for contracts in
289         // construction, since the code is only stored at the end of the
290         // constructor execution.
291 
292         uint256 size;
293         // solhint-disable-next-line no-inline-assembly
294         assembly { size := extcodesize(account) }
295         return size > 0;
296     }
297 
298     /**
299      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
300      * `recipient`, forwarding all available gas and reverting on errors.
301      *
302      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
303      * of certain opcodes, possibly making contracts go over the 2300 gas limit
304      * imposed by `transfer`, making them unable to receive funds via
305      * `transfer`. {sendValue} removes this limitation.
306      *
307      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
308      *
309      * IMPORTANT: because control is transferred to `recipient`, care must be
310      * taken to not create reentrancy vulnerabilities. Consider using
311      * {ReentrancyGuard} or the
312      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
313      */
314     function sendValue(address payable recipient, uint256 amount) internal {
315         require(address(this).balance >= amount, "Address: insufficient balance");
316 
317         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
318         (bool success, ) = recipient.call{ value: amount }("");
319         require(success, "Address: unable to send value, recipient may have reverted");
320     }
321 
322     /**
323      * @dev Performs a Solidity function call using a low level `call`. A
324      * plain`call` is an unsafe replacement for a function call: use this
325      * function instead.
326      *
327      * If `target` reverts with a revert reason, it is bubbled up by this
328      * function (like regular Solidity function calls).
329      *
330      * Returns the raw returned data. To convert to the expected return value,
331      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
332      *
333      * Requirements:
334      *
335      * - `target` must be a contract.
336      * - calling `target` with `data` must not revert.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
341         return functionCall(target, data, "Address: low-level call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
346      * `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
351         return functionCallWithValue(target, data, 0, errorMessage);
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
356      * but also transferring `value` wei to `target`.
357      *
358      * Requirements:
359      *
360      * - the calling contract must have an ETH balance of at least `value`.
361      * - the called Solidity function must be `payable`.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
366         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
371      * with `errorMessage` as a fallback revert reason when `target` reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
376         require(address(this).balance >= value, "Address: insufficient balance for call");
377         require(isContract(target), "Address: call to non-contract");
378 
379         // solhint-disable-next-line avoid-low-level-calls
380         (bool success, bytes memory returndata) = target.call{ value: value }(data);
381         return _verifyCallResult(success, returndata, errorMessage);
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
386      * but performing a static call.
387      *
388      * _Available since v3.3._
389      */
390     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
391         return functionStaticCall(target, data, "Address: low-level static call failed");
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
396      * but performing a static call.
397      *
398      * _Available since v3.3._
399      */
400     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
401         require(isContract(target), "Address: static call to non-contract");
402 
403         // solhint-disable-next-line avoid-low-level-calls
404         (bool success, bytes memory returndata) = target.staticcall(data);
405         return _verifyCallResult(success, returndata, errorMessage);
406     }
407 
408     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
409         if (success) {
410             return returndata;
411         } else {
412             // Look for revert reason and bubble it up if present
413             if (returndata.length > 0) {
414                 // The easiest way to bubble the revert reason is using memory via assembly
415 
416                 // solhint-disable-next-line no-inline-assembly
417                 assembly {
418                     let returndata_size := mload(returndata)
419                     revert(add(32, returndata), returndata_size)
420                 }
421             } else {
422                 revert(errorMessage);
423             }
424         }
425     }
426 }
427 
428 /**
429  * @dev Interface of the ERC20 standard as defined in the EIP.
430  */
431 interface IERC20 {
432     /**
433      * @dev Returns the amount of tokens in existence.
434      */
435     function totalSupply() external view returns (uint256);
436 
437     /**
438      * @dev Returns the amount of tokens owned by `account`.
439      */
440     function balanceOf(address account) external view returns (uint256);
441 
442     /**
443      * @dev Moves `amount` tokens from the caller's account to `recipient`.
444      *
445      * Returns a boolean value indicating whether the operation succeeded.
446      *
447      * Emits a {Transfer} event.
448      */
449     function transfer(address recipient, uint256 amount) external returns (bool);
450 
451     /**
452      * @dev Returns the remaining number of tokens that `spender` will be
453      * allowed to spend on behalf of `owner` through {transferFrom}. This is
454      * zero by default.
455      *
456      * This value changes when {approve} or {transferFrom} are called.
457      */
458     function allowance(address owner, address spender) external view returns (uint256);
459 
460     /**
461      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
462      *
463      * Returns a boolean value indicating whether the operation succeeded.
464      *
465      * IMPORTANT: Beware that changing an allowance with this method brings the risk
466      * that someone may use both the old and the new allowance by unfortunate
467      * transaction ordering. One possible solution to mitigate this race
468      * condition is to first reduce the spender's allowance to 0 and set the
469      * desired value afterwards:
470      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
471      *
472      * Emits an {Approval} event.
473      */
474     function approve(address spender, uint256 amount) external returns (bool);
475 
476     /**
477      * @dev Moves `amount` tokens from `sender` to `recipient` using the
478      * allowance mechanism. `amount` is then deducted from the caller's
479      * allowance.
480      *
481      * Returns a boolean value indicating whether the operation succeeded.
482      *
483      * Emits a {Transfer} event.
484      */
485     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
486 
487     /**
488      * @dev Emitted when `value` tokens are moved from one account (`from`) to
489      * another (`to`).
490      *
491      * Note that `value` may be zero.
492      */
493     event Transfer(address indexed from, address indexed to, uint256 value);
494 
495     /**
496      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
497      * a call to {approve}. `value` is the new allowance.
498      */
499     event Approval(address indexed owner, address indexed spender, uint256 value);
500 }
501 
502 /**
503  * @dev Implementation of the {IERC20} interface.
504  *
505  * This implementation is agnostic to the way tokens are created. This means
506  * that a supply mechanism has to be added in a derived contract using {_mint}.
507  * For a generic mechanism see {ERC20PresetMinterPauser}.
508  *
509  * TIP: For a detailed writeup see our guide
510  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
511  * to implement supply mechanisms].
512  *
513  * We have followed general OpenZeppelin guidelines: functions revert instead
514  * of returning `false` on failure. This behavior is nonetheless conventional
515  * and does not conflict with the expectations of ERC20 applications.
516  *
517  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
518  * This allows applications to reconstruct the allowance for all accounts just
519  * by listening to said events. Other implementations of the EIP may not emit
520  * these events, as it isn't required by the specification.
521  *
522  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
523  * functions have been added to mitigate the well-known issues around setting
524  * allowances. See {IERC20-approve}.
525  */
526 contract ERC20 is Context, IERC20 {
527     using SafeMath for uint256;
528 
529     mapping (address => uint256) private _balances;
530 
531     mapping (address => mapping (address => uint256)) private _allowances;
532 
533     uint256 private _totalSupply;
534 
535     string private _name;
536     string private _symbol;
537     uint8 private _decimals;
538 
539     /**
540      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
541      * a default value of 18.
542      *
543      * To select a different value for {decimals}, use {_setupDecimals}.
544      *
545      * All three of these values are immutable: they can only be set once during
546      * construction.
547      */
548     constructor (string memory name_, string memory symbol_) public {
549         _name = name_;
550         _symbol = symbol_;
551         _decimals = 18;
552     }
553 
554     /**
555      * @dev Returns the name of the token.
556      */
557     function name() public view returns (string memory) {
558         return _name;
559     }
560 
561     /**
562      * @dev Returns the symbol of the token, usually a shorter version of the
563      * name.
564      */
565     function symbol() public view returns (string memory) {
566         return _symbol;
567     }
568 
569     /**
570      * @dev Returns the number of decimals used to get its user representation.
571      * For example, if `decimals` equals `2`, a balance of `505` tokens should
572      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
573      *
574      * Tokens usually opt for a value of 18, imitating the relationship between
575      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
576      * called.
577      *
578      * NOTE: This information is only used for _display_ purposes: it in
579      * no way affects any of the arithmetic of the contract, including
580      * {IERC20-balanceOf} and {IERC20-transfer}.
581      */
582     function decimals() public view returns (uint8) {
583         return _decimals;
584     }
585 
586     /**
587      * @dev See {IERC20-totalSupply}.
588      */
589     function totalSupply() public view override returns (uint256) {
590         return _totalSupply;
591     }
592 
593     /**
594      * @dev See {IERC20-balanceOf}.
595      */
596     function balanceOf(address account) public view override returns (uint256) {
597         return _balances[account];
598     }
599 
600     /**
601      * @dev See {IERC20-transfer}.
602      *
603      * Requirements:
604      *
605      * - `recipient` cannot be the zero address.
606      * - the caller must have a balance of at least `amount`.
607      */
608     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
609         _transfer(_msgSender(), recipient, amount);
610         return true;
611     }
612 
613     /**
614      * @dev See {IERC20-allowance}.
615      */
616     function allowance(address owner, address spender) public view virtual override returns (uint256) {
617         return _allowances[owner][spender];
618     }
619 
620     /**
621      * @dev See {IERC20-approve}.
622      *
623      * Requirements:
624      *
625      * - `spender` cannot be the zero address.
626      */
627     function approve(address spender, uint256 amount) public virtual override returns (bool) {
628         _approve(_msgSender(), spender, amount);
629         return true;
630     }
631 
632     /**
633      * @dev See {IERC20-transferFrom}.
634      *
635      * Emits an {Approval} event indicating the updated allowance. This is not
636      * required by the EIP. See the note at the beginning of {ERC20}.
637      *
638      * Requirements:
639      *
640      * - `sender` and `recipient` cannot be the zero address.
641      * - `sender` must have a balance of at least `amount`.
642      * - the caller must have allowance for ``sender``'s tokens of at least
643      * `amount`.
644      */
645     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
646         _transfer(sender, recipient, amount);
647         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
648         return true;
649     }
650 
651     /**
652      * @dev Atomically increases the allowance granted to `spender` by the caller.
653      *
654      * This is an alternative to {approve} that can be used as a mitigation for
655      * problems described in {IERC20-approve}.
656      *
657      * Emits an {Approval} event indicating the updated allowance.
658      *
659      * Requirements:
660      *
661      * - `spender` cannot be the zero address.
662      */
663     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
664         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
665         return true;
666     }
667 
668     /**
669      * @dev Atomically decreases the allowance granted to `spender` by the caller.
670      *
671      * This is an alternative to {approve} that can be used as a mitigation for
672      * problems described in {IERC20-approve}.
673      *
674      * Emits an {Approval} event indicating the updated allowance.
675      *
676      * Requirements:
677      *
678      * - `spender` cannot be the zero address.
679      * - `spender` must have allowance for the caller of at least
680      * `subtractedValue`.
681      */
682     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
683         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
684         return true;
685     }
686 
687     /**
688      * @dev Moves tokens `amount` from `sender` to `recipient`.
689      *
690      * This is internal function is equivalent to {transfer}, and can be used to
691      * e.g. implement automatic token fees, slashing mechanisms, etc.
692      *
693      * Emits a {Transfer} event.
694      *
695      * Requirements:
696      *
697      * - `sender` cannot be the zero address.
698      * - `recipient` cannot be the zero address.
699      * - `sender` must have a balance of at least `amount`.
700      */
701     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
702         require(sender != address(0), "ERC20: transfer from the zero address");
703         require(recipient != address(0), "ERC20: transfer to the zero address");
704 
705         _beforeTokenTransfer(sender, recipient, amount);
706 
707         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
708         _balances[recipient] = _balances[recipient].add(amount);
709         emit Transfer(sender, recipient, amount);
710     }
711 
712     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
713      * the total supply.
714      *
715      * Emits a {Transfer} event with `from` set to the zero address.
716      *
717      * Requirements:
718      *
719      * - `to` cannot be the zero address.
720      */
721     function _mint(address account, uint256 amount) internal virtual {
722         require(account != address(0), "ERC20: mint to the zero address");
723 
724         _beforeTokenTransfer(address(0), account, amount);
725 
726         _totalSupply = _totalSupply.add(amount);
727         _balances[account] = _balances[account].add(amount);
728         emit Transfer(address(0), account, amount);
729     }
730 
731     /**
732      * @dev Destroys `amount` tokens from `account`, reducing the
733      * total supply.
734      *
735      * Emits a {Transfer} event with `to` set to the zero address.
736      *
737      * Requirements:
738      *
739      * - `account` cannot be the zero address.
740      * - `account` must have at least `amount` tokens.
741      */
742     function _burn(address account, uint256 amount) internal virtual {
743         require(account != address(0), "ERC20: burn from the zero address");
744 
745         _beforeTokenTransfer(account, address(0), amount);
746 
747         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
748         _totalSupply = _totalSupply.sub(amount);
749         emit Transfer(account, address(0), amount);
750     }
751 
752     /**
753      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
754      *
755      * This internal function is equivalent to `approve`, and can be used to
756      * e.g. set automatic allowances for certain subsystems, etc.
757      *
758      * Emits an {Approval} event.
759      *
760      * Requirements:
761      *
762      * - `owner` cannot be the zero address.
763      * - `spender` cannot be the zero address.
764      */
765     function _approve(address owner, address spender, uint256 amount) internal virtual {
766         require(owner != address(0), "ERC20: approve from the zero address");
767         require(spender != address(0), "ERC20: approve to the zero address");
768 
769         _allowances[owner][spender] = amount;
770         emit Approval(owner, spender, amount);
771     }
772 
773     /**
774      * @dev Sets {decimals} to a value other than the default one of 18.
775      *
776      * WARNING: This function should only be called from the constructor. Most
777      * applications that interact with token contracts will not expect
778      * {decimals} to ever change, and may work incorrectly if it does.
779      */
780     function _setupDecimals(uint8 decimals_) internal {
781         _decimals = decimals_;
782     }
783 
784     /**
785      * @dev Hook that is called before any transfer of tokens. This includes
786      * minting and burning.
787      *
788      * Calling conditions:
789      *
790      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
791      * will be to transferred to `to`.
792      * - when `from` is zero, `amount` tokens will be minted for `to`.
793      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
794      * - `from` and `to` are never both zero.
795      *
796      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
797      */
798     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
799 }
800 
801 /// RACA V2 token
802 contract RACAV2Token is ERC20("Radio Caca V2", "RACA"), Ownable {
803     using Address for address;
804     using SafeMath for uint256;
805 
806     /// A checkpoint for marking number of votes from a given block
807     struct Checkpoint {
808         uint32 fromBlock;
809         uint256 votes;
810     }
811 
812     /// We need mint some RACA in advance
813     uint256 public racaInAdvance;
814 
815     /// The address of Treasury wallet
816     address public treasuryWalletAddr;
817 
818     /// The EIP-712 typehash for the contract's domain
819     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
820 
821     /// The EIP-712 typehash for the delegation struct used by the contract
822     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
823 
824     // A record of each accounts delegate
825     mapping (address => address) internal _delegates;
826 
827     /// A record of votes checkpoints for each account, by index
828     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
829 
830     /// The number of checkpoints for each account
831     mapping (address => uint32) public numCheckpoints;
832 
833     /// A record of states for signing / validating signatures
834     mapping (address => uint) public nonces;
835 
836     /// An event thats emitted when an account changes its delegate
837     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
838 
839     /// An event thats emitted when a delegate account's vote balance changes
840     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
841 
842     /// @notice We need mint some RACAs in advance
843     constructor() public {
844         treasuryWalletAddr = _msgSender();
845         racaInAdvance = 500000 * 10**6 * 10**18;
846 
847         mint(treasuryWalletAddr, racaInAdvance);
848     }
849 
850     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner
851     function mint(address _to, uint256 _amount) public onlyOwner {
852         _mint(_to, _amount);
853         _moveDelegates(address(0), _delegates[_to], _amount);
854     }
855 
856     /// @notice Burn `_amount` token from `_from`. Must only be called by the owner
857     function burn(address _from, uint256 _amount) public onlyOwner {
858         _burn(_from, _amount);
859         _moveDelegates(_delegates[_from], address(0), _amount);
860     }
861 
862     /// @notice Override ERC20.transfer
863     function transfer(address recipient, uint256 amount) public override returns (bool) {
864         super.transfer(recipient, amount);
865         _moveDelegates(_delegates[msg.sender], _delegates[recipient], amount);
866         return true;
867     }
868 
869     /// @notice Override ERC20.transferFrom
870     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
871         super.transferFrom(sender, recipient, amount);
872         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
873         return true;
874     }
875 
876     /**
877      * @notice Delegate votes from `msg.sender` to `delegatee`
878      * @param delegator The address to get delegatee for
879      */
880     function delegates(address delegator)
881     external
882     view
883     returns (address)
884     {
885         return _delegates[delegator];
886     }
887 
888     /**
889      * @notice Delegate votes from `msg.sender` to `delegatee`
890      * @param delegatee The address to delegate votes to
891      */
892     function delegate(address delegatee) external {
893         return _delegate(msg.sender, delegatee);
894     }
895 
896     /**
897      * @notice Delegates votes from signatory to `delegatee`
898      * @param delegatee The address to delegate votes to
899      * @param nonce The contract state required to match the signature
900      * @param expiry The time at which to expire the signature
901      * @param v The recovery byte of the signature
902      * @param r Half of the ECDSA signature pair
903      * @param s Half of the ECDSA signature pair
904      */
905     function delegateBySig(
906         address delegatee,
907         uint nonce,
908         uint expiry,
909         uint8 v,
910         bytes32 r,
911         bytes32 s
912     )
913     external
914     {
915         bytes32 domainSeparator = keccak256(
916             abi.encode(
917                 DOMAIN_TYPEHASH,
918                 keccak256(bytes(name())),
919                 getChainId(),
920                 address(this)
921             )
922         );
923 
924         bytes32 structHash = keccak256(
925             abi.encode(
926                 DELEGATION_TYPEHASH,
927                 delegatee,
928                 nonce,
929                 expiry
930             )
931         );
932 
933         bytes32 digest = keccak256(
934             abi.encodePacked(
935                 "\x19\x01",
936                 domainSeparator,
937                 structHash
938             )
939         );
940 
941         address signatory = ecrecover(digest, v, r, s);
942         require(signatory != address(0), "delegateBySig: invalid signature");
943         require(nonce == nonces[signatory]++, "delegateBySig: invalid nonce");
944         require(block.timestamp <= expiry, "delegateBySig: signature expired");
945         return _delegate(signatory, delegatee);
946     }
947 
948     /**
949      * @notice Gets the current votes balance for `account`
950      * @param account The address to get votes balance
951      * @return The number of current votes for `account`
952      */
953     function getCurrentVotes(address account)
954     external
955     view
956     returns (uint256)
957     {
958         uint32 nCheckpoints = numCheckpoints[account];
959         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
960     }
961 
962     /**
963      * @notice Determine the prior number of votes for an account as of a block number
964      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
965      * @param account The address of the account to check
966      * @param blockNumber The block number to get the vote balance at
967      * @return The number of votes the account had as of the given block
968      */
969     function getPriorVotes(address account, uint blockNumber)
970     external
971     view
972     returns (uint256)
973     {
974         require(blockNumber < block.number, "getPriorVotes: not yet determined");
975 
976         uint32 nCheckpoints = numCheckpoints[account];
977         if (nCheckpoints == 0) {
978             return 0;
979         }
980 
981         // First check most recent balance
982         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
983             return checkpoints[account][nCheckpoints - 1].votes;
984         }
985 
986         // Next check implicit zero balance
987         if (checkpoints[account][0].fromBlock > blockNumber) {
988             return 0;
989         }
990 
991         uint32 lower = 0;
992         uint32 upper = nCheckpoints - 1;
993         while (upper > lower) {
994             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
995             Checkpoint memory cp = checkpoints[account][center];
996             if (cp.fromBlock == blockNumber) {
997                 return cp.votes;
998             } else if (cp.fromBlock < blockNumber) {
999                 lower = center;
1000             } else {
1001                 upper = center - 1;
1002             }
1003         }
1004         return checkpoints[account][lower].votes;
1005     }
1006 
1007     function transferRACAByOwner(address _to, uint256 _amount) external onlyOwner {
1008         require(balanceOf(address(this)) >= _amount, "out of balance");
1009         this.transfer(_to, _amount);
1010     }
1011 
1012     function _delegate(address delegator, address delegatee)
1013     internal
1014     {
1015         address currentDelegate = _delegates[delegator];
1016         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying DVGs (not scaled);
1017         _delegates[delegator] = delegatee;
1018 
1019         emit DelegateChanged(delegator, currentDelegate, delegatee);
1020 
1021         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1022     }
1023 
1024     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1025         if (srcRep != dstRep && amount > 0) {
1026             if (srcRep != address(0)) {
1027                 // decrease old representative
1028                 uint32 srcRepNum = numCheckpoints[srcRep];
1029                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1030                 uint256 srcRepNew = srcRepOld.sub(amount);
1031                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1032             }
1033 
1034             if (dstRep != address(0)) {
1035                 // increase new representative
1036                 uint32 dstRepNum = numCheckpoints[dstRep];
1037                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1038                 uint256 dstRepNew = dstRepOld.add(amount);
1039                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1040             }
1041         }
1042     }
1043 
1044     function _writeCheckpoint(
1045         address delegatee,
1046         uint32 nCheckpoints,
1047         uint256 oldVotes,
1048         uint256 newVotes
1049     )
1050     internal
1051     {
1052         uint32 blockNumber = safe32(block.number, "_writeCheckpoint: block number exceeds 32 bits");
1053 
1054         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1055             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1056         } else {
1057             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1058             numCheckpoints[delegatee] = nCheckpoints + 1;
1059         }
1060 
1061         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1062     }
1063 
1064     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1065         require(n < 2**32, errorMessage);
1066         return uint32(n);
1067     }
1068 
1069     function getChainId() internal pure returns (uint) {
1070         uint256 chainId;
1071         assembly { chainId := chainid() }
1072         return chainId;
1073     }
1074 }