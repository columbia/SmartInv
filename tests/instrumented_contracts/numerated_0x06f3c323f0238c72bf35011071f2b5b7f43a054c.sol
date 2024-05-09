1 pragma solidity 0.5.16;
2 
3 /**
4  * MASQ v2 token contract for use by the MASQ Network and their community - for MASQNode
5  * decentralized mesh network sfotware solution - internet freedom!
6  * 
7  * Compiled Feb 2020 from OpenZeppelin github open-source code contracts:
8  * "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/ownership/Ownable.sol";
9  * "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
10  * "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol";
11  */
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
23  
24 contract Context {
25     // Empty internal constructor, to prevent people from mistakenly deploying
26     // an instance of this contract, which should be used via inheritance.
27     constructor () internal { }
28     // solhint-disable-previous-line no-empty-blocks
29 
30     function _msgSender() internal view returns (address payable) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view returns (bytes memory) {
35         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
36         return msg.data;
37     }
38 }
39 
40 /**
41  * @dev Contract module which provides a basic access control mechanism, where
42  * there is an account (an owner) that can be granted exclusive access to
43  * specific functions.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor () internal {
58         address msgSender = _msgSender();
59         _owner = msgSender;
60         emit OwnershipTransferred(address(0), msgSender);
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(isOwner(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     /**
79      * @dev Returns true if the caller is the current owner.
80      */
81     function isOwner() public view returns (bool) {
82         return _msgSender() == _owner;
83     }
84 
85     /**
86      * @dev Leaves the contract without owner. It will not be possible to call
87      * `onlyOwner` functions anymore. Can only be called by the current owner.
88      *
89      * NOTE: Renouncing ownership will leave the contract without an owner,
90      * thereby removing any functionality that is only available to the owner.
91      */
92     function renounceOwnership() public onlyOwner {
93         emit OwnershipTransferred(_owner, address(0));
94         _owner = address(0);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Can only be called by the current owner.
100      */
101     function transferOwnership(address newOwner) public onlyOwner {
102         _transferOwnership(newOwner);
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      */
108     function _transferOwnership(address newOwner) internal {
109         require(newOwner != address(0), "Ownable: new owner is the zero address");
110         emit OwnershipTransferred(_owner, newOwner);
111         _owner = newOwner;
112     }
113 }
114 
115 /**
116  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
117  * the optional functions; to access them see {ERC20Detailed}.
118  */
119 interface IERC20 {
120     /**
121      * @dev Returns the amount of tokens in existence.
122      */
123     function totalSupply() external view returns (uint256);
124 
125     /**
126      * @dev Returns the amount of tokens owned by `account`.
127      */
128     function balanceOf(address account) external view returns (uint256);
129 
130     /**
131      * @dev Moves `amount` tokens from the caller's account to `recipient`.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * Emits a {Transfer} event.
136      */
137     function transfer(address recipient, uint256 amount) external returns (bool);
138 
139     /**
140      * @dev Returns the remaining number of tokens that `spender` will be
141      * allowed to spend on behalf of `owner` through {transferFrom}. This is
142      * zero by default.
143      *
144      * This value changes when {approve} or {transferFrom} are called.
145      */
146     function allowance(address owner, address spender) external view returns (uint256);
147 
148     /**
149      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * IMPORTANT: Beware that changing an allowance with this method brings the risk
154      * that someone may use both the old and the new allowance by unfortunate
155      * transaction ordering. One possible solution to mitigate this race
156      * condition is to first reduce the spender's allowance to 0 and set the
157      * desired value afterwards:
158      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159      *
160      * Emits an {Approval} event.
161      */
162     function approve(address spender, uint256 amount) external returns (bool);
163 
164     /**
165      * @dev Moves `amount` tokens from `sender` to `recipient` using the
166      * allowance mechanism. `amount` is then deducted from the caller's
167      * allowance.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * Emits a {Transfer} event.
172      */
173     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
174 
175     /**
176      * @dev Emitted when `value` tokens are moved from one account (`from`) to
177      * another (`to`).
178      *
179      * Note that `value` may be zero.
180      */
181     event Transfer(address indexed from, address indexed to, uint256 value);
182 
183     /**
184      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
185      * a call to {approve}. `value` is the new allowance.
186      */
187     event Approval(address indexed owner, address indexed spender, uint256 value);
188 }
189 /**
190  * @dev Wrappers over Solidity's arithmetic operations with added overflow
191  * checks.
192  *
193  * Arithmetic operations in Solidity wrap on overflow. This can easily result
194  * in bugs, because programmers usually assume that an overflow raises an
195  * error, which is the standard behavior in high level programming languages.
196  * `SafeMath` restores this intuition by reverting the transaction when an
197  * operation overflows.
198  *
199  * Using this library instead of the unchecked operations eliminates an entire
200  * class of bugs, so it's recommended to use it always.
201  */
202 library SafeMath {
203     /**
204      * @dev Returns the addition of two unsigned integers, reverting on
205      * overflow.
206      *
207      * Counterpart to Solidity's `+` operator.
208      *
209      * Requirements:
210      * - Addition cannot overflow.
211      */
212     function add(uint256 a, uint256 b) internal pure returns (uint256) {
213         uint256 c = a + b;
214         require(c >= a, "SafeMath: addition overflow");
215 
216         return c;
217     }
218 
219     /**
220      * @dev Returns the subtraction of two unsigned integers, reverting on
221      * overflow (when the result is negative).
222      *
223      * Counterpart to Solidity's `-` operator.
224      *
225      * Requirements:
226      * - Subtraction cannot overflow.
227      */
228     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
229         return sub(a, b, "SafeMath: subtraction overflow");
230     }
231 
232     /**
233      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
234      * overflow (when the result is negative).
235      *
236      * Counterpart to Solidity's `-` operator.
237      *
238      * Requirements:
239      * - Subtraction cannot overflow.
240      *
241      * _Available since v2.4.0._
242      */
243     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
244         require(b <= a, errorMessage);
245         uint256 c = a - b;
246 
247         return c;
248     }
249 
250     /**
251      * @dev Returns the multiplication of two unsigned integers, reverting on
252      * overflow.
253      *
254      * Counterpart to Solidity's `*` operator.
255      *
256      * Requirements:
257      * - Multiplication cannot overflow.
258      */
259     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
260         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
261         // benefit is lost if 'b' is also tested.
262         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
263         if (a == 0) {
264             return 0;
265         }
266 
267         uint256 c = a * b;
268         require(c / a == b, "SafeMath: multiplication overflow");
269 
270         return c;
271     }
272 
273     /**
274      * @dev Returns the integer division of two unsigned integers. Reverts on
275      * division by zero. The result is rounded towards zero.
276      *
277      * Counterpart to Solidity's `/` operator. Note: this function uses a
278      * `revert` opcode (which leaves remaining gas untouched) while Solidity
279      * uses an invalid opcode to revert (consuming all remaining gas).
280      *
281      * Requirements:
282      * - The divisor cannot be zero.
283      */
284     function div(uint256 a, uint256 b) internal pure returns (uint256) {
285         return div(a, b, "SafeMath: division by zero");
286     }
287 
288     /**
289      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
290      * division by zero. The result is rounded towards zero.
291      *
292      * Counterpart to Solidity's `/` operator. Note: this function uses a
293      * `revert` opcode (which leaves remaining gas untouched) while Solidity
294      * uses an invalid opcode to revert (consuming all remaining gas).
295      *
296      * Requirements:
297      * - The divisor cannot be zero.
298      *
299      * _Available since v2.4.0._
300      */
301     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
302         // Solidity only automatically asserts when dividing by 0
303         require(b > 0, errorMessage);
304         uint256 c = a / b;
305         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
306 
307         return c;
308     }
309 
310     /**
311      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
312      * Reverts when dividing by zero.
313      *
314      * Counterpart to Solidity's `%` operator. This function uses a `revert`
315      * opcode (which leaves remaining gas untouched) while Solidity uses an
316      * invalid opcode to revert (consuming all remaining gas).
317      *
318      * Requirements:
319      * - The divisor cannot be zero.
320      */
321     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
322         return mod(a, b, "SafeMath: modulo by zero");
323     }
324 
325     /**
326      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
327      * Reverts with custom message when dividing by zero.
328      *
329      * Counterpart to Solidity's `%` operator. This function uses a `revert`
330      * opcode (which leaves remaining gas untouched) while Solidity uses an
331      * invalid opcode to revert (consuming all remaining gas).
332      *
333      * Requirements:
334      * - The divisor cannot be zero.
335      *
336      * _Available since v2.4.0._
337      */
338     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
339         require(b != 0, errorMessage);
340         return a % b;
341     }
342 }
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
367  
368 contract ERC20 is Context, IERC20 {
369     using SafeMath for uint256;
370 
371     mapping (address => uint256) private _balances;
372 
373     mapping (address => mapping (address => uint256)) private _allowances;
374 
375     uint256 private _totalSupply;
376 
377     /**
378      * @dev See {IERC20-totalSupply}.
379      */
380     function totalSupply() public view returns (uint256) {
381         return _totalSupply;
382     }
383 
384     /**
385      * @dev See {IERC20-balanceOf}.
386      */
387     function balanceOf(address account) public view returns (uint256) {
388         return _balances[account];
389     }
390 
391     /**
392      * @dev See {IERC20-transfer}.
393      *
394      * Requirements:
395      *
396      * - `recipient` cannot be the zero address.
397      * - the caller must have a balance of at least `amount`.
398      */
399      
400     function transfer(address recipient, uint256 amount) public returns (bool) {
401         _transfer(_msgSender(), recipient, amount);
402         return true;
403     }
404 
405     /**
406      * @dev See {IERC20-allowance}.
407      */
408     function allowance(address owner, address spender) public view returns (uint256) {
409         return _allowances[owner][spender];
410     }
411 
412     /**
413      * @dev See {IERC20-approve}.
414      *
415      * Requirements:
416      *
417      * - `spender` cannot be the zero address.
418      */
419     function approve(address spender, uint256 amount) public returns (bool) {
420         _approve(_msgSender(), spender, amount);
421         return true;
422     }
423 
424     /**
425      * @dev See {IERC20-transferFrom}.
426      *
427      * Emits an {Approval} event indicating the updated allowance. This is not
428      * required by the EIP. See the note at the beginning of {ERC20};
429      *
430      * Requirements:
431      * - `sender` and `recipient` cannot be the zero address.
432      * - `sender` must have a balance of at least `amount`.
433      * - the caller must have allowance for `sender`'s tokens of at least
434      * `amount`.
435      */
436     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
437         _transfer(sender, recipient, amount);
438         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
439         return true;
440     }
441 
442     /**
443      * @dev Atomically increases the allowance granted to `spender` by the caller.
444      *
445      * This is an alternative to {approve} that can be used as a mitigation for
446      * problems described in {IERC20-approve}.
447      *
448      * Emits an {Approval} event indicating the updated allowance.
449      *
450      * Requirements:
451      *
452      * - `spender` cannot be the zero address.
453      */
454     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
455         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
456         return true;
457     }
458 
459     /**
460      * @dev Atomically decreases the allowance granted to `spender` by the caller.
461      *
462      * This is an alternative to {approve} that can be used as a mitigation for
463      * problems described in {IERC20-approve}.
464      *
465      * Emits an {Approval} event indicating the updated allowance.
466      *
467      * Requirements:
468      *
469      * - `spender` cannot be the zero address.
470      * - `spender` must have allowance for the caller of at least
471      * `subtractedValue`.
472      */
473     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
474         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
475         return true;
476     }
477 
478     /**
479      * @dev Moves tokens `amount` from `sender` to `recipient`.
480      *
481      * This is internal function is equivalent to {transfer}, and can be used to
482      * e.g. implement automatic token fees, slashing mechanisms, etc.
483      *
484      * Emits a {Transfer} event.
485      *
486      * Requirements:
487      *
488      * - `sender` cannot be the zero address.
489      * - `recipient` cannot be the zero address.
490      * - `sender` must have a balance of at least `amount`.
491      */
492     function _transfer(address sender, address recipient, uint256 amount) internal {
493         require(sender != address(0), "ERC20: transfer from the zero address");
494         require(recipient != address(0), "ERC20: transfer to the zero address");
495 
496         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
497         _balances[recipient] = _balances[recipient].add(amount);
498         emit Transfer(sender, recipient, amount);
499     }
500 
501     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
502      * the total supply.
503      *
504      * Emits a {Transfer} event with `from` set to the zero address.
505      *
506      * Requirements
507      *
508      * - `to` cannot be the zero address.
509      */
510     function _mint(address account, uint256 amount) internal {
511         require(account != address(0), "ERC20: mint to the zero address");
512 
513         _totalSupply = _totalSupply.add(amount);
514         _balances[account] = _balances[account].add(amount);
515         emit Transfer(address(0), account, amount);
516     }
517 
518     /**
519      * @dev Destroys `amount` tokens from `account`, reducing the
520      * total supply.
521      *
522      * Emits a {Transfer} event with `to` set to the zero address.
523      *
524      * Requirements
525      *
526      * - `account` cannot be the zero address.
527      * - `account` must have at least `amount` tokens.
528      */
529     function _burn(address account, uint256 amount) internal {
530         require(account != address(0), "ERC20: burn from the zero address");
531 
532         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
533         _totalSupply = _totalSupply.sub(amount);
534         emit Transfer(account, address(0), amount);
535     }
536 
537     /**
538      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
539      *
540      * This is internal function is equivalent to `approve`, and can be used to
541      * e.g. set automatic allowances for certain subsystems, etc.
542      *
543      * Emits an {Approval} event.
544      *
545      * Requirements:
546      *
547      * - `owner` cannot be the zero address.
548      * - `spender` cannot be the zero address.
549      */
550     function _approve(address owner, address spender, uint256 amount) internal {
551         require(owner != address(0), "ERC20: approve from the zero address");
552         require(spender != address(0), "ERC20: approve to the zero address");
553 
554         _allowances[owner][spender] = amount;
555         emit Approval(owner, spender, amount);
556     }
557 
558     /**
559      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
560      * from the caller's allowance.
561      *
562      * See {_burn} and {_approve}.
563      */
564     function _burnFrom(address account, uint256 amount) internal {
565         _burn(account, amount);
566         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
567     }
568 }
569 /**
570  * @dev Extension of {ERC20} that allows token holders to destroy both their own
571  * tokens and those that they have an allowance for, in a way that can be
572  * recognized off-chain (via event analysis).
573  */
574 contract ERC20Burnable is Context, ERC20 {
575     /**
576      * @dev Destroys `amount` tokens from the caller.
577      *
578      * See {ERC20-_burn}.
579      */
580     function burn(uint256 amount) public {
581         _burn(_msgSender(), amount);
582     }
583 
584     /**
585      * @dev See {ERC20-_burnFrom}.
586      */
587     function burnFrom(address account, uint256 amount) public {
588         _burnFrom(account, amount);
589     }
590 }
591 
592 contract MASQv2 is ERC20Burnable, Ownable {
593     string public constant name = "MASQ";
594     string public constant symbol = "MASQ";
595     uint8 public constant decimals = 18;
596 
597     // 472 million tokens * decimal places (10^18)
598     uint256 public constant INITIAL_SUPPLY = 39947981000000000000000000;
599 
600     constructor() public {
601         ERC20._mint(msg.sender, INITIAL_SUPPLY);
602     }
603 
604     function approve(address _spender, uint256 _value) public returns (bool) {
605         require(_value == 0 || allowance(msg.sender, _spender) == 0, "Use increaseApproval or decreaseApproval to prevent double-spend.");
606 
607         return ERC20.approve(_spender, _value);
608     }
609 }