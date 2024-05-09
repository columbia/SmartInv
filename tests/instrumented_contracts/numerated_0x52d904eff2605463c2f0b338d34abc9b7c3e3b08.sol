1 // File: @openzeppelin\upgrades\contracts\Initializable.sol
2 
3 pragma solidity >=0.4.24 <0.7.0;
4 
5 
6 /**
7  * @title Initializable
8  *
9  * @dev Helper contract to support initializer functions. To use it, replace
10  * the constructor with a function that has the `initializer` modifier.
11  * WARNING: Unlike constructors, initializer functions must be manually
12  * invoked. This applies both to deploying an Initializable contract, as well
13  * as extending an Initializable contract via inheritance.
14  * WARNING: When used with inheritance, manual care must be taken to not invoke
15  * a parent initializer twice, or ensure that all initializers are idempotent,
16  * because this is not dealt with automatically as with constructors.
17  */
18 contract Initializable {
19 
20   /**
21    * @dev Indicates that the contract has been initialized.
22    */
23   bool private initialized;
24 
25   /**
26    * @dev Indicates that the contract is in the process of being initialized.
27    */
28   bool private initializing;
29 
30   /**
31    * @dev Modifier to use in the initializer function of a contract.
32    */
33   modifier initializer() {
34     require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
35 
36     bool isTopLevelCall = !initializing;
37     if (isTopLevelCall) {
38       initializing = true;
39       initialized = true;
40     }
41 
42     _;
43 
44     if (isTopLevelCall) {
45       initializing = false;
46     }
47   }
48 
49   /// @dev Returns true if and only if the function is running in the constructor
50   function isConstructor() private view returns (bool) {
51     // extcodesize checks the size of the code stored in an address, and
52     // address returns the current address. Since the code is still not
53     // deployed when running a constructor, any checks on its code size will
54     // yield zero, making it an effective way to detect if a contract is
55     // under construction or not.
56     address self = address(this);
57     uint256 cs;
58     assembly { cs := extcodesize(self) }
59     return cs == 0;
60   }
61 
62   // Reserved storage space to allow for layout changes in the future.
63   uint256[50] private ______gap;
64 }
65 
66 // File: node_modules\@openzeppelin\contracts-ethereum-package\contracts\GSN\Context.sol
67 
68 pragma solidity ^0.5.0;
69 
70 
71 /*
72  * @dev Provides information about the current execution context, including the
73  * sender of the transaction and its data. While these are generally available
74  * via msg.sender and msg.data, they should not be accessed in such a direct
75  * manner, since when dealing with GSN meta-transactions the account sending and
76  * paying for execution may not be the actual sender (as far as an application
77  * is concerned).
78  *
79  * This contract is only required for intermediate, library-like contracts.
80  */
81 contract Context is Initializable {
82     // Empty internal constructor, to prevent people from mistakenly deploying
83     // an instance of this contract, which should be used via inheritance.
84     constructor () internal { }
85     // solhint-disable-previous-line no-empty-blocks
86 
87     function _msgSender() internal view returns (address payable) {
88         return msg.sender;
89     }
90 
91     function _msgData() internal view returns (bytes memory) {
92         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
93         return msg.data;
94     }
95 }
96 
97 // File: node_modules\@openzeppelin\contracts-ethereum-package\contracts\token\ERC20\IERC20.sol
98 
99 pragma solidity ^0.5.0;
100 
101 /**
102  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
103  * the optional functions; to access them see {ERC20Detailed}.
104  */
105 interface IERC20 {
106     /**
107      * @dev Returns the amount of tokens in existence.
108      */
109     function totalSupply() external view returns (uint256);
110 
111     /**
112      * @dev Returns the amount of tokens owned by `account`.
113      */
114     function balanceOf(address account) external view returns (uint256);
115 
116     /**
117      * @dev Moves `amount` tokens from the caller's account to `recipient`.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * Emits a {Transfer} event.
122      */
123     function transfer(address recipient, uint256 amount) external returns (bool);
124 
125     /**
126      * @dev Returns the remaining number of tokens that `spender` will be
127      * allowed to spend on behalf of `owner` through {transferFrom}. This is
128      * zero by default.
129      *
130      * This value changes when {approve} or {transferFrom} are called.
131      */
132     function allowance(address owner, address spender) external view returns (uint256);
133 
134     /**
135      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * IMPORTANT: Beware that changing an allowance with this method brings the risk
140      * that someone may use both the old and the new allowance by unfortunate
141      * transaction ordering. One possible solution to mitigate this race
142      * condition is to first reduce the spender's allowance to 0 and set the
143      * desired value afterwards:
144      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145      *
146      * Emits an {Approval} event.
147      */
148     function approve(address spender, uint256 amount) external returns (bool);
149 
150     /**
151      * @dev Moves `amount` tokens from `sender` to `recipient` using the
152      * allowance mechanism. `amount` is then deducted from the caller's
153      * allowance.
154      *
155      * Returns a boolean value indicating whether the operation succeeded.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Emitted when `value` tokens are moved from one account (`from`) to
163      * another (`to`).
164      *
165      * Note that `value` may be zero.
166      */
167     event Transfer(address indexed from, address indexed to, uint256 value);
168 
169     /**
170      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
171      * a call to {approve}. `value` is the new allowance.
172      */
173     event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175 
176 // File: node_modules\@openzeppelin\contracts-ethereum-package\contracts\math\SafeMath.sol
177 
178 pragma solidity ^0.5.0;
179 
180 /**
181  * @dev Wrappers over Solidity's arithmetic operations with added overflow
182  * checks.
183  *
184  * Arithmetic operations in Solidity wrap on overflow. This can easily result
185  * in bugs, because programmers usually assume that an overflow raises an
186  * error, which is the standard behavior in high level programming languages.
187  * `SafeMath` restores this intuition by reverting the transaction when an
188  * operation overflows.
189  *
190  * Using this library instead of the unchecked operations eliminates an entire
191  * class of bugs, so it's recommended to use it always.
192  */
193 library SafeMath {
194     /**
195      * @dev Returns the addition of two unsigned integers, reverting on
196      * overflow.
197      *
198      * Counterpart to Solidity's `+` operator.
199      *
200      * Requirements:
201      * - Addition cannot overflow.
202      */
203     function add(uint256 a, uint256 b) internal pure returns (uint256) {
204         uint256 c = a + b;
205         require(c >= a, "SafeMath: addition overflow");
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the subtraction of two unsigned integers, reverting on
212      * overflow (when the result is negative).
213      *
214      * Counterpart to Solidity's `-` operator.
215      *
216      * Requirements:
217      * - Subtraction cannot overflow.
218      */
219     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
220         return sub(a, b, "SafeMath: subtraction overflow");
221     }
222 
223     /**
224      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
225      * overflow (when the result is negative).
226      *
227      * Counterpart to Solidity's `-` operator.
228      *
229      * Requirements:
230      * - Subtraction cannot overflow.
231      *
232      * _Available since v2.4.0._
233      */
234     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
235         require(b <= a, errorMessage);
236         uint256 c = a - b;
237 
238         return c;
239     }
240 
241     /**
242      * @dev Returns the multiplication of two unsigned integers, reverting on
243      * overflow.
244      *
245      * Counterpart to Solidity's `*` operator.
246      *
247      * Requirements:
248      * - Multiplication cannot overflow.
249      */
250     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
251         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
252         // benefit is lost if 'b' is also tested.
253         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
254         if (a == 0) {
255             return 0;
256         }
257 
258         uint256 c = a * b;
259         require(c / a == b, "SafeMath: multiplication overflow");
260 
261         return c;
262     }
263 
264     /**
265      * @dev Returns the integer division of two unsigned integers. Reverts on
266      * division by zero. The result is rounded towards zero.
267      *
268      * Counterpart to Solidity's `/` operator. Note: this function uses a
269      * `revert` opcode (which leaves remaining gas untouched) while Solidity
270      * uses an invalid opcode to revert (consuming all remaining gas).
271      *
272      * Requirements:
273      * - The divisor cannot be zero.
274      */
275     function div(uint256 a, uint256 b) internal pure returns (uint256) {
276         return div(a, b, "SafeMath: division by zero");
277     }
278 
279     /**
280      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
281      * division by zero. The result is rounded towards zero.
282      *
283      * Counterpart to Solidity's `/` operator. Note: this function uses a
284      * `revert` opcode (which leaves remaining gas untouched) while Solidity
285      * uses an invalid opcode to revert (consuming all remaining gas).
286      *
287      * Requirements:
288      * - The divisor cannot be zero.
289      *
290      * _Available since v2.4.0._
291      */
292     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
293         // Solidity only automatically asserts when dividing by 0
294         require(b > 0, errorMessage);
295         uint256 c = a / b;
296         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
297 
298         return c;
299     }
300 
301     /**
302      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
303      * Reverts when dividing by zero.
304      *
305      * Counterpart to Solidity's `%` operator. This function uses a `revert`
306      * opcode (which leaves remaining gas untouched) while Solidity uses an
307      * invalid opcode to revert (consuming all remaining gas).
308      *
309      * Requirements:
310      * - The divisor cannot be zero.
311      */
312     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
313         return mod(a, b, "SafeMath: modulo by zero");
314     }
315 
316     /**
317      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
318      * Reverts with custom message when dividing by zero.
319      *
320      * Counterpart to Solidity's `%` operator. This function uses a `revert`
321      * opcode (which leaves remaining gas untouched) while Solidity uses an
322      * invalid opcode to revert (consuming all remaining gas).
323      *
324      * Requirements:
325      * - The divisor cannot be zero.
326      *
327      * _Available since v2.4.0._
328      */
329     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
330         require(b != 0, errorMessage);
331         return a % b;
332     }
333 }
334 
335 // File: @openzeppelin\contracts-ethereum-package\contracts\token\ERC20\ERC20.sol
336 
337 pragma solidity ^0.5.0;
338 
339 
340 
341 
342 
343 /**
344  * @dev Implementation of the {IERC20} interface.
345  *
346  * This implementation is agnostic to the way tokens are created. This means
347  * that a supply mechanism has to be added in a derived contract using {_mint}.
348  * For a generic mechanism see {ERC20Mintable}.
349  *
350  * TIP: For a detailed writeup see our guide
351  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
352  * to implement supply mechanisms].
353  *
354  * We have followed general OpenZeppelin guidelines: functions revert instead
355  * of returning `false` on failure. This behavior is nonetheless conventional
356  * and does not conflict with the expectations of ERC20 applications.
357  *
358  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
359  * This allows applications to reconstruct the allowance for all accounts just
360  * by listening to said events. Other implementations of the EIP may not emit
361  * these events, as it isn't required by the specification.
362  *
363  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
364  * functions have been added to mitigate the well-known issues around setting
365  * allowances. See {IERC20-approve}.
366  */
367 contract ERC20 is Initializable, Context, IERC20 {
368     using SafeMath for uint256;
369 
370     mapping (address => uint256) private _balances;
371 
372     mapping (address => mapping (address => uint256)) private _allowances;
373 
374     uint256 private _totalSupply;
375 
376     /**
377      * @dev See {IERC20-totalSupply}.
378      */
379     function totalSupply() public view returns (uint256) {
380         return _totalSupply;
381     }
382 
383     /**
384      * @dev See {IERC20-balanceOf}.
385      */
386     function balanceOf(address account) public view returns (uint256) {
387         return _balances[account];
388     }
389 
390     /**
391      * @dev See {IERC20-transfer}.
392      *
393      * Requirements:
394      *
395      * - `recipient` cannot be the zero address.
396      * - the caller must have a balance of at least `amount`.
397      */
398     function transfer(address recipient, uint256 amount) public returns (bool) {
399         _transfer(_msgSender(), recipient, amount);
400         return true;
401     }
402 
403     /**
404      * @dev See {IERC20-allowance}.
405      */
406     function allowance(address owner, address spender) public view returns (uint256) {
407         return _allowances[owner][spender];
408     }
409 
410     /**
411      * @dev See {IERC20-approve}.
412      *
413      * Requirements:
414      *
415      * - `spender` cannot be the zero address.
416      */
417     function approve(address spender, uint256 amount) public returns (bool) {
418         _approve(_msgSender(), spender, amount);
419         return true;
420     }
421 
422     /**
423      * @dev See {IERC20-transferFrom}.
424      *
425      * Emits an {Approval} event indicating the updated allowance. This is not
426      * required by the EIP. See the note at the beginning of {ERC20};
427      *
428      * Requirements:
429      * - `sender` and `recipient` cannot be the zero address.
430      * - `sender` must have a balance of at least `amount`.
431      * - the caller must have allowance for `sender`'s tokens of at least
432      * `amount`.
433      */
434     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
435         _transfer(sender, recipient, amount);
436         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
437         return true;
438     }
439 
440     /**
441      * @dev Atomically increases the allowance granted to `spender` by the caller.
442      *
443      * This is an alternative to {approve} that can be used as a mitigation for
444      * problems described in {IERC20-approve}.
445      *
446      * Emits an {Approval} event indicating the updated allowance.
447      *
448      * Requirements:
449      *
450      * - `spender` cannot be the zero address.
451      */
452     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
453         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
454         return true;
455     }
456 
457     /**
458      * @dev Atomically decreases the allowance granted to `spender` by the caller.
459      *
460      * This is an alternative to {approve} that can be used as a mitigation for
461      * problems described in {IERC20-approve}.
462      *
463      * Emits an {Approval} event indicating the updated allowance.
464      *
465      * Requirements:
466      *
467      * - `spender` cannot be the zero address.
468      * - `spender` must have allowance for the caller of at least
469      * `subtractedValue`.
470      */
471     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
472         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
473         return true;
474     }
475 
476     /**
477      * @dev Moves tokens `amount` from `sender` to `recipient`.
478      *
479      * This is internal function is equivalent to {transfer}, and can be used to
480      * e.g. implement automatic token fees, slashing mechanisms, etc.
481      *
482      * Emits a {Transfer} event.
483      *
484      * Requirements:
485      *
486      * - `sender` cannot be the zero address.
487      * - `recipient` cannot be the zero address.
488      * - `sender` must have a balance of at least `amount`.
489      */
490     function _transfer(address sender, address recipient, uint256 amount) internal {
491         require(sender != address(0), "ERC20: transfer from the zero address");
492         require(recipient != address(0), "ERC20: transfer to the zero address");
493 
494         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
495         _balances[recipient] = _balances[recipient].add(amount);
496         emit Transfer(sender, recipient, amount);
497     }
498 
499     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
500      * the total supply.
501      *
502      * Emits a {Transfer} event with `from` set to the zero address.
503      *
504      * Requirements
505      *
506      * - `to` cannot be the zero address.
507      */
508     function _mint(address account, uint256 amount) internal {
509         require(account != address(0), "ERC20: mint to the zero address");
510 
511         _totalSupply = _totalSupply.add(amount);
512         _balances[account] = _balances[account].add(amount);
513         emit Transfer(address(0), account, amount);
514     }
515 
516     /**
517      * @dev Destroys `amount` tokens from `account`, reducing the
518      * total supply.
519      *
520      * Emits a {Transfer} event with `to` set to the zero address.
521      *
522      * Requirements
523      *
524      * - `account` cannot be the zero address.
525      * - `account` must have at least `amount` tokens.
526      */
527     function _burn(address account, uint256 amount) internal {
528         require(account != address(0), "ERC20: burn from the zero address");
529 
530         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
531         _totalSupply = _totalSupply.sub(amount);
532         emit Transfer(account, address(0), amount);
533     }
534 
535     /**
536      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
537      *
538      * This is internal function is equivalent to `approve`, and can be used to
539      * e.g. set automatic allowances for certain subsystems, etc.
540      *
541      * Emits an {Approval} event.
542      *
543      * Requirements:
544      *
545      * - `owner` cannot be the zero address.
546      * - `spender` cannot be the zero address.
547      */
548     function _approve(address owner, address spender, uint256 amount) internal {
549         require(owner != address(0), "ERC20: approve from the zero address");
550         require(spender != address(0), "ERC20: approve to the zero address");
551 
552         _allowances[owner][spender] = amount;
553         emit Approval(owner, spender, amount);
554     }
555 
556     /**
557      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
558      * from the caller's allowance.
559      *
560      * See {_burn} and {_approve}.
561      */
562     function _burnFrom(address account, uint256 amount) internal {
563         _burn(account, amount);
564         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
565     }
566 
567     uint256[50] private ______gap;
568 }
569 
570 // File: @openzeppelin\contracts-ethereum-package\contracts\token\ERC20\ERC20Detailed.sol
571 
572 pragma solidity ^0.5.0;
573 
574 
575 
576 /**
577  * @dev Optional functions from the ERC20 standard.
578  */
579 contract ERC20Detailed is Initializable, IERC20 {
580     string private _name;
581     string private _symbol;
582     uint8 private _decimals;
583 
584     /**
585      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
586      * these values are immutable: they can only be set once during
587      * construction.
588      */
589     function initialize(string memory name, string memory symbol, uint8 decimals) public initializer {
590         _name = name;
591         _symbol = symbol;
592         _decimals = decimals;
593     }
594 
595     /**
596      * @dev Returns the name of the token.
597      */
598     function name() public view returns (string memory) {
599         return _name;
600     }
601 
602     /**
603      * @dev Returns the symbol of the token, usually a shorter version of the
604      * name.
605      */
606     function symbol() public view returns (string memory) {
607         return _symbol;
608     }
609 
610     /**
611      * @dev Returns the number of decimals used to get its user representation.
612      * For example, if `decimals` equals `2`, a balance of `505` tokens should
613      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
614      *
615      * Tokens usually opt for a value of 18, imitating the relationship between
616      * Ether and Wei.
617      *
618      * NOTE: This information is only used for _display_ purposes: it in
619      * no way affects any of the arithmetic of the contract, including
620      * {IERC20-balanceOf} and {IERC20-transfer}.
621      */
622     function decimals() public view returns (uint8) {
623         return _decimals;
624     }
625 
626     uint256[50] private ______gap;
627 }
628 
629 // File: contracts\SimpleToken.sol
630 
631 pragma solidity 0.5.16;
632 
633 
634 
635 contract SimpleToken is ERC20Detailed, ERC20 {
636   constructor(
637     string memory _name,
638     string memory _symbol,
639     uint8 _decimals,
640     uint256 _amount
641   ) public {
642     require(_amount > 0, "amount has to be greater than 0");
643     ERC20Detailed.initialize(_name, _symbol, _decimals);
644     _mint(msg.sender, _amount * (10 ** uint256(decimals())));
645   }
646 }