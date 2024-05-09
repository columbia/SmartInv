1 // SPDX-License-Identifier: Unlicense
2 
3 pragma solidity 0.6.12;
4 
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 /**
28  * @dev Contract module which provides a basic access control mechanism, where
29  * there is an account (an owner) that can be granted exclusive access to
30  * specific functions.
31  *
32  * By default, the owner account will be the one that deploys the contract. This
33  * can later be changed with {transferOwnership}.
34  *
35  * This module is used through inheritance. It will make available the modifier
36  * `onlyOwner`, which can be applied to your functions to restrict their use to
37  * the owner.
38  */
39 abstract contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44     /**
45      * @dev Initializes the contract setting the deployer as the initial owner.
46      */
47     constructor () internal {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52 
53     /**
54      * @dev Returns the address of the current owner.
55      */
56     function owner() public view returns (address) {
57         return _owner;
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         require(_owner == _msgSender(), "Ownable: caller is not the owner");
65         _;
66     }
67 
68     /**
69      * @dev Leaves the contract without owner. It will not be possible to call
70      * `onlyOwner` functions anymore. Can only be called by the current owner.
71      *
72      * NOTE: Renouncing ownership will leave the contract without an owner,
73      * thereby removing any functionality that is only available to the owner.
74      */
75     function renounceOwnership() public virtual onlyOwner {
76         emit OwnershipTransferred(_owner, address(0));
77         _owner = address(0);
78     }
79 
80     /**
81      * @dev Transfers ownership of the contract to a new account (`newOwner`).
82      * Can only be called by the current owner.
83      */
84     function transferOwnership(address newOwner) public virtual onlyOwner {
85         require(newOwner != address(0), "Ownable: new owner is the zero address");
86         emit OwnershipTransferred(_owner, newOwner);
87         _owner = newOwner;
88     }
89 }
90 
91 /**
92  * @dev Interface of the ERC20 standard as defined in the EIP.
93  */
94 interface IERC20 {
95     /**
96      * @dev Returns the amount of tokens in existence.
97      */
98     function totalSupply() external view returns (uint256);
99 
100     /**
101      * @dev Returns the amount of tokens owned by `account`.
102      */
103     function balanceOf(address account) external view returns (uint256);
104 
105     /**
106      * @dev Moves `amount` tokens from the caller's account to `recipient`.
107      *
108      * Returns a boolean value indicating whether the operation succeeded.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transfer(address recipient, uint256 amount) external returns (bool);
113 
114     /**
115      * @dev Returns the remaining number of tokens that `spender` will be
116      * allowed to spend on behalf of `owner` through {transferFrom}. This is
117      * zero by default.
118      *
119      * This value changes when {approve} or {transferFrom} are called.
120      */
121     function allowance(address owner, address spender) external view returns (uint256);
122 
123     /**
124      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
125      *
126      * Returns a boolean value indicating whether the operation succeeded.
127      *
128      * IMPORTANT: Beware that changing an allowance with this method brings the risk
129      * that someone may use both the old and the new allowance by unfortunate
130      * transaction ordering. One possible solution to mitigate this race
131      * condition is to first reduce the spender's allowance to 0 and set the
132      * desired value afterwards:
133      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134      *
135      * Emits an {Approval} event.
136      */
137     function approve(address spender, uint256 amount) external returns (bool);
138 
139     /**
140      * @dev Moves `amount` tokens from `sender` to `recipient` using the
141      * allowance mechanism. `amount` is then deducted from the caller's
142      * allowance.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * Emits a {Transfer} event.
147      */
148     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
149 
150     /**
151      * @dev Emitted when `value` tokens are moved from one account (`from`) to
152      * another (`to`).
153      *
154      * Note that `value` may be zero.
155      */
156     event Transfer(address indexed from, address indexed to, uint256 value);
157 
158     /**
159      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
160      * a call to {approve}. `value` is the new allowance.
161      */
162     event Approval(address indexed owner, address indexed spender, uint256 value);
163 }
164 
165 /**
166  * @dev Wrappers over Solidity's arithmetic operations with added overflow
167  * checks.
168  *
169  * Arithmetic operations in Solidity wrap on overflow. This can easily result
170  * in bugs, because programmers usually assume that an overflow raises an
171  * error, which is the standard behavior in high level programming languages.
172  * `SafeMath` restores this intuition by reverting the transaction when an
173  * operation overflows.
174  *
175  * Using this library instead of the unchecked operations eliminates an entire
176  * class of bugs, so it's recommended to use it always.
177  */
178 library SafeMath {
179     /**
180      * @dev Returns the addition of two unsigned integers, reverting on
181      * overflow.
182      *
183      * Counterpart to Solidity's `+` operator.
184      *
185      * Requirements:
186      *
187      * - Addition cannot overflow.
188      */
189     function add(uint256 a, uint256 b) internal pure returns (uint256) {
190         uint256 c = a + b;
191         require(c >= a, "SafeMath: addition overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the subtraction of two unsigned integers, reverting on
198      * overflow (when the result is negative).
199      *
200      * Counterpart to Solidity's `-` operator.
201      *
202      * Requirements:
203      *
204      * - Subtraction cannot overflow.
205      */
206     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
207         return sub(a, b, "SafeMath: subtraction overflow");
208     }
209 
210     /**
211      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
212      * overflow (when the result is negative).
213      *
214      * Counterpart to Solidity's `-` operator.
215      *
216      * Requirements:
217      *
218      * - Subtraction cannot overflow.
219      */
220     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         require(b <= a, errorMessage);
222         uint256 c = a - b;
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the multiplication of two unsigned integers, reverting on
229      * overflow.
230      *
231      * Counterpart to Solidity's `*` operator.
232      *
233      * Requirements:
234      *
235      * - Multiplication cannot overflow.
236      */
237     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
238         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
239         // benefit is lost if 'b' is also tested.
240         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
241         if (a == 0) {
242             return 0;
243         }
244 
245         uint256 c = a * b;
246         require(c / a == b, "SafeMath: multiplication overflow");
247 
248         return c;
249     }
250 
251     /**
252      * @dev Returns the integer division of two unsigned integers. Reverts on
253      * division by zero. The result is rounded towards zero.
254      *
255      * Counterpart to Solidity's `/` operator. Note: this function uses a
256      * `revert` opcode (which leaves remaining gas untouched) while Solidity
257      * uses an invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function div(uint256 a, uint256 b) internal pure returns (uint256) {
264         return div(a, b, "SafeMath: division by zero");
265     }
266 
267     /**
268      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
269      * division by zero. The result is rounded towards zero.
270      *
271      * Counterpart to Solidity's `/` operator. Note: this function uses a
272      * `revert` opcode (which leaves remaining gas untouched) while Solidity
273      * uses an invalid opcode to revert (consuming all remaining gas).
274      *
275      * Requirements:
276      *
277      * - The divisor cannot be zero.
278      */
279     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
280         require(b > 0, errorMessage);
281         uint256 c = a / b;
282         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
283 
284         return c;
285     }
286 
287     /**
288      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
289      * Reverts when dividing by zero.
290      *
291      * Counterpart to Solidity's `%` operator. This function uses a `revert`
292      * opcode (which leaves remaining gas untouched) while Solidity uses an
293      * invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      *
297      * - The divisor cannot be zero.
298      */
299     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
300         return mod(a, b, "SafeMath: modulo by zero");
301     }
302 
303     /**
304      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
305      * Reverts with custom message when dividing by zero.
306      *
307      * Counterpart to Solidity's `%` operator. This function uses a `revert`
308      * opcode (which leaves remaining gas untouched) while Solidity uses an
309      * invalid opcode to revert (consuming all remaining gas).
310      *
311      * Requirements:
312      *
313      * - The divisor cannot be zero.
314      */
315     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
316         require(b != 0, errorMessage);
317         return a % b;
318     }
319 }
320 
321 /**
322  * @dev Implementation of the {IERC20} interface.
323  *
324  * This implementation is agnostic to the way tokens are created. This means
325  * that a supply mechanism has to be added in a derived contract using {_mint}.
326  * For a generic mechanism see {ERC20PresetMinterPauser}.
327  *
328  * TIP: For a detailed writeup see our guide
329  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
330  * to implement supply mechanisms].
331  *
332  * We have followed general OpenZeppelin guidelines: functions revert instead
333  * of returning `false` on failure. This behavior is nonetheless conventional
334  * and does not conflict with the expectations of ERC20 applications.
335  *
336  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
337  * This allows applications to reconstruct the allowance for all accounts just
338  * by listening to said events. Other implementations of the EIP may not emit
339  * these events, as it isn't required by the specification.
340  *
341  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
342  * functions have been added to mitigate the well-known issues around setting
343  * allowances. See {IERC20-approve}.
344  */
345 contract ERC20 is Context, IERC20 {
346     using SafeMath for uint256;
347 
348     mapping (address => uint256) private _balances;
349 
350     mapping (address => mapping (address => uint256)) private _allowances;
351 
352     uint256 private _totalSupply;
353 
354     string private _name;
355     string private _symbol;
356     uint8 private _decimals;
357 
358     /**
359      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
360      * a default value of 18.
361      *
362      * To select a different value for {decimals}, use {_setupDecimals}.
363      *
364      * All three of these values are immutable: they can only be set once during
365      * construction.
366      */
367     constructor (string memory name_, string memory symbol_) public {
368         _name = name_;
369         _symbol = symbol_;
370         _decimals = 18;
371     }
372 
373     /**
374      * @dev Returns the name of the token.
375      */
376     function name() public view returns (string memory) {
377         return _name;
378     }
379 
380     /**
381      * @dev Returns the symbol of the token, usually a shorter version of the
382      * name.
383      */
384     function symbol() public view returns (string memory) {
385         return _symbol;
386     }
387 
388     /**
389      * @dev Returns the number of decimals used to get its user representation.
390      * For example, if `decimals` equals `2`, a balance of `505` tokens should
391      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
392      *
393      * Tokens usually opt for a value of 18, imitating the relationship between
394      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
395      * called.
396      *
397      * NOTE: This information is only used for _display_ purposes: it in
398      * no way affects any of the arithmetic of the contract, including
399      * {IERC20-balanceOf} and {IERC20-transfer}.
400      */
401     function decimals() public view returns (uint8) {
402         return _decimals;
403     }
404 
405     /**
406      * @dev See {IERC20-totalSupply}.
407      */
408     function totalSupply() public view override returns (uint256) {
409         return _totalSupply;
410     }
411 
412     /**
413      * @dev See {IERC20-balanceOf}.
414      */
415     function balanceOf(address account) public view override returns (uint256) {
416         return _balances[account];
417     }
418 
419     /**
420      * @dev See {IERC20-transfer}.
421      *
422      * Requirements:
423      *
424      * - `recipient` cannot be the zero address.
425      * - the caller must have a balance of at least `amount`.
426      */
427     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
428         _transfer(_msgSender(), recipient, amount);
429         return true;
430     }
431 
432     /**
433      * @dev See {IERC20-allowance}.
434      */
435     function allowance(address owner, address spender) public view virtual override returns (uint256) {
436         return _allowances[owner][spender];
437     }
438 
439     /**
440      * @dev See {IERC20-approve}.
441      *
442      * Requirements:
443      *
444      * - `spender` cannot be the zero address.
445      */
446     function approve(address spender, uint256 amount) public virtual override returns (bool) {
447         _approve(_msgSender(), spender, amount);
448         return true;
449     }
450 
451     /**
452      * @dev See {IERC20-transferFrom}.
453      *
454      * Emits an {Approval} event indicating the updated allowance. This is not
455      * required by the EIP. See the note at the beginning of {ERC20}.
456      *
457      * Requirements:
458      *
459      * - `sender` and `recipient` cannot be the zero address.
460      * - `sender` must have a balance of at least `amount`.
461      * - the caller must have allowance for ``sender``'s tokens of at least
462      * `amount`.
463      */
464     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
465         _transfer(sender, recipient, amount);
466         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
467         return true;
468     }
469 
470     /**
471      * @dev Atomically increases the allowance granted to `spender` by the caller.
472      *
473      * This is an alternative to {approve} that can be used as a mitigation for
474      * problems described in {IERC20-approve}.
475      *
476      * Emits an {Approval} event indicating the updated allowance.
477      *
478      * Requirements:
479      *
480      * - `spender` cannot be the zero address.
481      */
482     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
483         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
484         return true;
485     }
486 
487     /**
488      * @dev Atomically decreases the allowance granted to `spender` by the caller.
489      *
490      * This is an alternative to {approve} that can be used as a mitigation for
491      * problems described in {IERC20-approve}.
492      *
493      * Emits an {Approval} event indicating the updated allowance.
494      *
495      * Requirements:
496      *
497      * - `spender` cannot be the zero address.
498      * - `spender` must have allowance for the caller of at least
499      * `subtractedValue`.
500      */
501     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
502         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
503         return true;
504     }
505 
506     /**
507      * @dev Moves tokens `amount` from `sender` to `recipient`.
508      *
509      * This is internal function is equivalent to {transfer}, and can be used to
510      * e.g. implement automatic token fees, slashing mechanisms, etc.
511      *
512      * Emits a {Transfer} event.
513      *
514      * Requirements:
515      *
516      * - `sender` cannot be the zero address.
517      * - `recipient` cannot be the zero address.
518      * - `sender` must have a balance of at least `amount`.
519      */
520     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
521         require(sender != address(0), "ERC20: transfer from the zero address");
522         require(recipient != address(0), "ERC20: transfer to the zero address");
523 
524         _beforeTokenTransfer(sender, recipient, amount);
525 
526         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
527         _balances[recipient] = _balances[recipient].add(amount);
528         emit Transfer(sender, recipient, amount);
529     }
530 
531     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
532      * the total supply.
533      *
534      * Emits a {Transfer} event with `from` set to the zero address.
535      *
536      * Requirements:
537      *
538      * - `to` cannot be the zero address.
539      */
540     function _mint(address account, uint256 amount) internal virtual {
541         require(account != address(0), "ERC20: mint to the zero address");
542 
543         _beforeTokenTransfer(address(0), account, amount);
544 
545         _totalSupply = _totalSupply.add(amount);
546         _balances[account] = _balances[account].add(amount);
547         emit Transfer(address(0), account, amount);
548     }
549 
550     /**
551      * @dev Destroys `amount` tokens from `account`, reducing the
552      * total supply.
553      *
554      * Emits a {Transfer} event with `to` set to the zero address.
555      *
556      * Requirements:
557      *
558      * - `account` cannot be the zero address.
559      * - `account` must have at least `amount` tokens.
560      */
561     function _burn(address account, uint256 amount) internal virtual {
562         require(account != address(0), "ERC20: burn from the zero address");
563 
564         _beforeTokenTransfer(account, address(0), amount);
565 
566         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
567         _totalSupply = _totalSupply.sub(amount);
568         emit Transfer(account, address(0), amount);
569     }
570 
571     /**
572      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
573      *
574      * This internal function is equivalent to `approve`, and can be used to
575      * e.g. set automatic allowances for certain subsystems, etc.
576      *
577      * Emits an {Approval} event.
578      *
579      * Requirements:
580      *
581      * - `owner` cannot be the zero address.
582      * - `spender` cannot be the zero address.
583      */
584     function _approve(address owner, address spender, uint256 amount) internal virtual {
585         require(owner != address(0), "ERC20: approve from the zero address");
586         require(spender != address(0), "ERC20: approve to the zero address");
587 
588         _allowances[owner][spender] = amount;
589         emit Approval(owner, spender, amount);
590     }
591 
592     /**
593      * @dev Sets {decimals} to a value other than the default one of 18.
594      *
595      * WARNING: This function should only be called from the constructor. Most
596      * applications that interact with token contracts will not expect
597      * {decimals} to ever change, and may work incorrectly if it does.
598      */
599     function _setupDecimals(uint8 decimals_) internal {
600         _decimals = decimals_;
601     }
602 
603     /**
604      * @dev Hook that is called before any transfer of tokens. This includes
605      * minting and burning.
606      *
607      * Calling conditions:
608      *
609      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
610      * will be to transferred to `to`.
611      * - when `from` is zero, `amount` tokens will be minted for `to`.
612      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
613      * - `from` and `to` are never both zero.
614      *
615      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
616      */
617     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
618 }
619 
620 /**
621  * @dev Collection of functions related to the address type
622  */
623 library Address {
624     /**
625      * @dev Returns true if `account` is a contract.
626      *
627      * [IMPORTANT]
628      * ====
629      * It is unsafe to assume that an address for which this function returns
630      * false is an externally-owned account (EOA) and not a contract.
631      *
632      * Among others, `isContract` will return false for the following
633      * types of addresses:
634      *
635      *  - an externally-owned account
636      *  - a contract in construction
637      *  - an address where a contract will be created
638      *  - an address where a contract lived, but was destroyed
639      * ====
640      */
641     function isContract(address account) internal view returns (bool) {
642         // This method relies on extcodesize, which returns 0 for contracts in
643         // construction, since the code is only stored at the end of the
644         // constructor execution.
645 
646         uint256 size;
647         // solhint-disable-next-line no-inline-assembly
648         assembly { size := extcodesize(account) }
649         return size > 0;
650     }
651 
652     /**
653      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
654      * `recipient`, forwarding all available gas and reverting on errors.
655      *
656      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
657      * of certain opcodes, possibly making contracts go over the 2300 gas limit
658      * imposed by `transfer`, making them unable to receive funds via
659      * `transfer`. {sendValue} removes this limitation.
660      *
661      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
662      *
663      * IMPORTANT: because control is transferred to `recipient`, care must be
664      * taken to not create reentrancy vulnerabilities. Consider using
665      * {ReentrancyGuard} or the
666      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
667      */
668     function sendValue(address payable recipient, uint256 amount) internal {
669         require(address(this).balance >= amount, "Address: insufficient balance");
670 
671         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
672         (bool success, ) = recipient.call{ value: amount }("");
673         require(success, "Address: unable to send value, recipient may have reverted");
674     }
675 
676     /**
677      * @dev Performs a Solidity function call using a low level `call`. A
678      * plain`call` is an unsafe replacement for a function call: use this
679      * function instead.
680      *
681      * If `target` reverts with a revert reason, it is bubbled up by this
682      * function (like regular Solidity function calls).
683      *
684      * Returns the raw returned data. To convert to the expected return value,
685      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
686      *
687      * Requirements:
688      *
689      * - `target` must be a contract.
690      * - calling `target` with `data` must not revert.
691      *
692      * _Available since v3.1._
693      */
694     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
695       return functionCall(target, data, "Address: low-level call failed");
696     }
697 
698     /**
699      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
700      * `errorMessage` as a fallback revert reason when `target` reverts.
701      *
702      * _Available since v3.1._
703      */
704     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
705         return functionCallWithValue(target, data, 0, errorMessage);
706     }
707 
708     /**
709      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
710      * but also transferring `value` wei to `target`.
711      *
712      * Requirements:
713      *
714      * - the calling contract must have an ETH balance of at least `value`.
715      * - the called Solidity function must be `payable`.
716      *
717      * _Available since v3.1._
718      */
719     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
720         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
721     }
722 
723     /**
724      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
725      * with `errorMessage` as a fallback revert reason when `target` reverts.
726      *
727      * _Available since v3.1._
728      */
729     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
730         require(address(this).balance >= value, "Address: insufficient balance for call");
731         require(isContract(target), "Address: call to non-contract");
732 
733         // solhint-disable-next-line avoid-low-level-calls
734         (bool success, bytes memory returndata) = target.call{ value: value }(data);
735         return _verifyCallResult(success, returndata, errorMessage);
736     }
737 
738     /**
739      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
740      * but performing a static call.
741      *
742      * _Available since v3.3._
743      */
744     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
745         return functionStaticCall(target, data, "Address: low-level static call failed");
746     }
747 
748     /**
749      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
750      * but performing a static call.
751      *
752      * _Available since v3.3._
753      */
754     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
755         require(isContract(target), "Address: static call to non-contract");
756 
757         // solhint-disable-next-line avoid-low-level-calls
758         (bool success, bytes memory returndata) = target.staticcall(data);
759         return _verifyCallResult(success, returndata, errorMessage);
760     }
761 
762     /**
763      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
764      * but performing a delegate call.
765      *
766      * _Available since v3.3._
767      */
768     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
769         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
770     }
771 
772     /**
773      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
774      * but performing a delegate call.
775      *
776      * _Available since v3.3._
777      */
778     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
779         require(isContract(target), "Address: delegate call to non-contract");
780 
781         // solhint-disable-next-line avoid-low-level-calls
782         (bool success, bytes memory returndata) = target.delegatecall(data);
783         return _verifyCallResult(success, returndata, errorMessage);
784     }
785 
786     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
787         if (success) {
788             return returndata;
789         } else {
790             // Look for revert reason and bubble it up if present
791             if (returndata.length > 0) {
792                 // The easiest way to bubble the revert reason is using memory via assembly
793 
794                 // solhint-disable-next-line no-inline-assembly
795                 assembly {
796                     let returndata_size := mload(returndata)
797                     revert(add(32, returndata), returndata_size)
798                 }
799             } else {
800                 revert(errorMessage);
801             }
802         }
803     }
804 }
805 
806 /**
807  * @title SafeERC20
808  * @dev Wrappers around ERC20 operations that throw on failure (when the token
809  * contract returns false). Tokens that return no value (and instead revert or
810  * throw on failure) are also supported, non-reverting calls are assumed to be
811  * successful.
812  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
813  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
814  */
815 library SafeERC20 {
816     using SafeMath for uint256;
817     using Address for address;
818 
819     function safeTransfer(IERC20 token, address to, uint256 value) internal {
820         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
821     }
822 
823     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
824         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
825     }
826 
827     /**
828      * @dev Deprecated. This function has issues similar to the ones found in
829      * {IERC20-approve}, and its usage is discouraged.
830      *
831      * Whenever possible, use {safeIncreaseAllowance} and
832      * {safeDecreaseAllowance} instead.
833      */
834     function safeApprove(IERC20 token, address spender, uint256 value) internal {
835         // safeApprove should only be called when setting an initial allowance,
836         // or when resetting it to zero. To increase and decrease it, use
837         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
838         // solhint-disable-next-line max-line-length
839         require((value == 0) || (token.allowance(address(this), spender) == 0),
840             "SafeERC20: approve from non-zero to non-zero allowance"
841         );
842         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
843     }
844 
845     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
846         uint256 newAllowance = token.allowance(address(this), spender).add(value);
847         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
848     }
849 
850     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
851         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
852         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
853     }
854 
855     /**
856      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
857      * on the return value: the return value is optional (but if data is returned, it must not be false).
858      * @param token The token targeted by the call.
859      * @param data The call data (encoded using abi.encode or one of its variants).
860      */
861     function _callOptionalReturn(IERC20 token, bytes memory data) private {
862         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
863         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
864         // the target address contains contract code and also asserts for success in the low-level call.
865 
866         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
867         if (returndata.length > 0) { // Return data is optional
868             // solhint-disable-next-line max-line-length
869             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
870         }
871     }
872 }
873 
874 // RigelToken with Governance.
875 contract RigelToken is ERC20("Rigel Finance", "RIGEL"), Ownable {
876     using SafeERC20 for IERC20;
877     
878     uint256 public maxRigel = 30000; 
879     uint256 public maxSupply = maxRigel.mul(1e18); //30,000 RIGEL TOKEN
880     address private _recoveryOwner;
881     
882     constructor (address _dev) public {
883         uint256 crowdsaleSupply = 4000;  
884         uint256 premintSupply = 1800;  
885     	uint256 crowdsaleAllocation = crowdsaleSupply.mul(1e18); //4,000 RIGEL TOKEN Crowdsale Supply
886     	uint256 liquidityAllocation = premintSupply.mul(1e18);  //1,800 RIGEL TOKEN Premint Supply
887         _mint(msg.sender, crowdsaleAllocation); //mint crowdsaleSupply to Crowdsale Contract
888         _mint(_dev, liquidityAllocation); //premintSupply will be used for Providing Liquidity on Exchanges
889         _recoveryOwner = _dev;
890     }
891     
892     /**
893      * @dev Returns the address of the current Recovery owner.
894      */
895     function recoveryOwner() public view returns (address) {
896         return _recoveryOwner;
897     }
898     
899     modifier onlyRecoveryOwner() {
900         require (msg.sender == _recoveryOwner);
901         _;
902     }
903 
904     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (BigBang).
905     function mint(address _to, uint256 _amount) public onlyOwner {
906         require(totalSupply().add(_amount)<=maxSupply,"Exceeding Max Supply");
907         _mint(_to, _amount);
908         _moveDelegates(address(0), _delegates[_to], _amount);
909     }
910 
911     /**
912      * @dev Destroys `_amount` tokens from `msg.sender`, reducing the
913      * total supply.
914      */
915     function burn(uint256 _amount) public {
916         _burn(msg.sender,_amount);
917         _moveDelegates(_delegates[msg.sender],address(0), _amount);
918     }
919 
920     // Copied and modified from YAM code:
921     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
922     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
923     // Which is copied and modified from COMPOUND:
924     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
925 
926     /// @dev A record of each accounts delegate
927     mapping (address => address) internal _delegates;
928 
929     /// @notice A checkpoint for marking number of votes from a given block
930     struct Checkpoint {
931         uint32 fromBlock;
932         uint256 votes;
933     }
934 
935     /// @notice A record of votes checkpoints for each account, by index
936     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
937 
938     /// @notice The number of checkpoints for each account
939     mapping (address => uint32) public numCheckpoints;
940 
941     /// @notice The EIP-712 typehash for the contract's domain
942     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
943 
944     /// @notice The EIP-712 typehash for the delegation struct used by the contract
945     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
946 
947     /// @notice A record of states for signing / validating signatures
948     mapping (address => uint) public nonces;
949 
950       /// @notice An event thats emitted when an account changes its delegate
951     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
952 
953     /// @notice An event thats emitted when a delegate account's vote balance changes
954     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
955 
956     /**
957      * @notice Delegate votes from `msg.sender` to `delegatee`
958      * @param delegator The address to get delegatee for
959      */
960     function delegates(address delegator)
961         external
962         view
963         returns (address)
964     {
965         return _delegates[delegator];
966     }
967 
968    /**
969     * @notice Delegate votes from `msg.sender` to `delegatee`
970     * @param delegatee The address to delegate votes to
971     */
972     function delegate(address delegatee) external {
973         return _delegate(msg.sender, delegatee);
974     }
975 
976     /**
977      * @notice Delegates votes from signatory to `delegatee`
978      * @param delegatee The address to delegate votes to
979      * @param nonce The contract state required to match the signature
980      * @param expiry The time at which to expire the signature
981      * @param v The recovery byte of the signature
982      * @param r Half of the ECDSA signature pair
983      * @param s Half of the ECDSA signature pair
984      */
985     function delegateBySig(
986         address delegatee,
987         uint nonce,
988         uint expiry,
989         uint8 v,
990         bytes32 r,
991         bytes32 s
992     )
993         external
994     {
995         bytes32 domainSeparator = keccak256(
996             abi.encode(
997                 DOMAIN_TYPEHASH,
998                 keccak256(bytes(name())),
999                 getChainId(),
1000                 address(this)
1001             )
1002         );
1003 
1004         bytes32 structHash = keccak256(
1005             abi.encode(
1006                 DELEGATION_TYPEHASH,
1007                 delegatee,
1008                 nonce,
1009                 expiry
1010             )
1011         );
1012 
1013         bytes32 digest = keccak256(
1014             abi.encodePacked(
1015                 "\x19\x01",
1016                 domainSeparator,
1017                 structHash
1018             )
1019         );
1020 
1021         address signatory = ecrecover(digest, v, r, s);
1022         require(signatory != address(0), "RIGEL::delegateBySig: invalid signature");
1023         require(nonce == nonces[signatory]++, "RIGEL::delegateBySig: invalid nonce");
1024         require(now <= expiry, "RIGEL::delegateBySig: signature expired");
1025         return _delegate(signatory, delegatee);
1026     }
1027 
1028     /**
1029      * @notice Gets the current votes balance for `account`
1030      * @param account The address to get votes balance
1031      * @return The number of current votes for `account`
1032      */
1033     function getCurrentVotes(address account)
1034         external
1035         view
1036         returns (uint256)
1037     {
1038         uint32 nCheckpoints = numCheckpoints[account];
1039         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1040     }
1041 
1042     /**
1043      * @notice Determine the prior number of votes for an account as of a block number
1044      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1045      * @param account The address of the account to check
1046      * @param blockNumber The block number to get the vote balance at
1047      * @return The number of votes the account had as of the given block
1048      */
1049     function getPriorVotes(address account, uint blockNumber)
1050         external
1051         view
1052         returns (uint256)
1053     {
1054         require(blockNumber < block.number, "RIGEL::getPriorVotes: not yet determined");
1055 
1056         uint32 nCheckpoints = numCheckpoints[account];
1057         if (nCheckpoints == 0) {
1058             return 0;
1059         }
1060 
1061         // First check most recent balance
1062         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1063             return checkpoints[account][nCheckpoints - 1].votes;
1064         }
1065 
1066         // Next check implicit zero balance
1067         if (checkpoints[account][0].fromBlock > blockNumber) {
1068             return 0;
1069         }
1070 
1071         uint32 lower = 0;
1072         uint32 upper = nCheckpoints - 1;
1073         while (upper > lower) {
1074             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1075             Checkpoint memory cp = checkpoints[account][center];
1076             if (cp.fromBlock == blockNumber) {
1077                 return cp.votes;
1078             } else if (cp.fromBlock < blockNumber) {
1079                 lower = center;
1080             } else {
1081                 upper = center - 1;
1082             }
1083         }
1084         return checkpoints[account][lower].votes;
1085     }
1086 
1087     function _delegate(address delegator, address delegatee)
1088         internal
1089     {
1090         address currentDelegate = _delegates[delegator];
1091         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying RIGELs (not scaled);
1092         _delegates[delegator] = delegatee;
1093 
1094         emit DelegateChanged(delegator, currentDelegate, delegatee);
1095 
1096         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1097     }
1098 
1099     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1100         if (srcRep != dstRep && amount > 0) {
1101             if (srcRep != address(0)) {
1102                 // decrease old representative
1103                 uint32 srcRepNum = numCheckpoints[srcRep];
1104                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1105                 uint256 srcRepNew = srcRepOld.sub(amount);
1106                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1107             }
1108 
1109             if (dstRep != address(0)) {
1110                 // increase new representative
1111                 uint32 dstRepNum = numCheckpoints[dstRep];
1112                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1113                 uint256 dstRepNew = dstRepOld.add(amount);
1114                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1115             }
1116         }
1117     }
1118 
1119     function _writeCheckpoint(
1120         address delegatee,
1121         uint32 nCheckpoints,
1122         uint256 oldVotes,
1123         uint256 newVotes
1124     )
1125         internal
1126     {
1127         uint32 blockNumber = safe32(block.number, "RIGEL::_writeCheckpoint: block number exceeds 32 bits");
1128 
1129         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1130             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1131         } else {
1132             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1133             numCheckpoints[delegatee] = nCheckpoints + 1;
1134         }
1135 
1136         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1137     }
1138 
1139     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1140         require(n < 2**32, errorMessage);
1141         return uint32(n);
1142     }
1143 
1144     function getChainId() internal pure returns (uint) {
1145         uint256 chainId;
1146         assembly { chainId := chainid() }
1147         return chainId;
1148     }
1149 
1150     /// @dev Recover ERC20 tokens that were accidentally sent to this smart contract.
1151     /// @param token The token contract. Can be anything. This contract should not hold ERC20 tokens.
1152     /// @param to The address to send the tokens to.
1153     /// @param value The number of tokens to transfer to `to`.
1154     function recover(IERC20 token, address to, uint256 value) external onlyRecoveryOwner {
1155         token.safeTransfer(to, value);
1156     }
1157 }