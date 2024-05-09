1 pragma solidity 0.5.16;
2 
3 /**
4  * Compiled Feb 2020 from OpenZeppelin github open-source code contracts:
5  * "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/ownership/Ownable.sol";
6  * "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
7  * "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/ERC20Burnable.sol";
8  */
9 
10 /*
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with GSN meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20  
21 contract Context {
22     // Empty internal constructor, to prevent people from mistakenly deploying
23     // an instance of this contract, which should be used via inheritance.
24     constructor () internal { }
25     // solhint-disable-previous-line no-empty-blocks
26 
27     function _msgSender() internal view returns (address payable) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view returns (bytes memory) {
32         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
33         return msg.data;
34     }
35 }
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () internal {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(isOwner(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Returns true if the caller is the current owner.
77      */
78     function isOwner() public view returns (bool) {
79         return _msgSender() == _owner;
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public onlyOwner {
90         emit OwnershipTransferred(_owner, address(0));
91         _owner = address(0);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public onlyOwner {
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      */
105     function _transferOwnership(address newOwner) internal {
106         require(newOwner != address(0), "Ownable: new owner is the zero address");
107         emit OwnershipTransferred(_owner, newOwner);
108         _owner = newOwner;
109     }
110 }
111 
112 /**
113  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
114  * the optional functions; to access them see {ERC20Detailed}.
115  */
116 interface IERC20 {
117     /**
118      * @dev Returns the amount of tokens in existence.
119      */
120     function totalSupply() external view returns (uint256);
121 
122     /**
123      * @dev Returns the amount of tokens owned by `account`.
124      */
125     function balanceOf(address account) external view returns (uint256);
126 
127     /**
128      * @dev Moves `amount` tokens from the caller's account to `recipient`.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transfer(address recipient, uint256 amount) external returns (bool);
135 
136     /**
137      * @dev Returns the remaining number of tokens that `spender` will be
138      * allowed to spend on behalf of `owner` through {transferFrom}. This is
139      * zero by default.
140      *
141      * This value changes when {approve} or {transferFrom} are called.
142      */
143     function allowance(address owner, address spender) external view returns (uint256);
144 
145     /**
146      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
147      *
148      * Returns a boolean value indicating whether the operation succeeded.
149      *
150      * IMPORTANT: Beware that changing an allowance with this method brings the risk
151      * that someone may use both the old and the new allowance by unfortunate
152      * transaction ordering. One possible solution to mitigate this race
153      * condition is to first reduce the spender's allowance to 0 and set the
154      * desired value afterwards:
155      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156      *
157      * Emits an {Approval} event.
158      */
159     function approve(address spender, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Moves `amount` tokens from `sender` to `recipient` using the
163      * allowance mechanism. `amount` is then deducted from the caller's
164      * allowance.
165      *
166      * Returns a boolean value indicating whether the operation succeeded.
167      *
168      * Emits a {Transfer} event.
169      */
170     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
171 
172     /**
173      * @dev Emitted when `value` tokens are moved from one account (`from`) to
174      * another (`to`).
175      *
176      * Note that `value` may be zero.
177      */
178     event Transfer(address indexed from, address indexed to, uint256 value);
179 
180     /**
181      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
182      * a call to {approve}. `value` is the new allowance.
183      */
184     event Approval(address indexed owner, address indexed spender, uint256 value);
185 }
186 /**
187  * @dev Wrappers over Solidity's arithmetic operations with added overflow
188  * checks.
189  *
190  * Arithmetic operations in Solidity wrap on overflow. This can easily result
191  * in bugs, because programmers usually assume that an overflow raises an
192  * error, which is the standard behavior in high level programming languages.
193  * `SafeMath` restores this intuition by reverting the transaction when an
194  * operation overflows.
195  *
196  * Using this library instead of the unchecked operations eliminates an entire
197  * class of bugs, so it's recommended to use it always.
198  */
199 library SafeMath {
200     /**
201      * @dev Returns the addition of two unsigned integers, reverting on
202      * overflow.
203      *
204      * Counterpart to Solidity's `+` operator.
205      *
206      * Requirements:
207      * - Addition cannot overflow.
208      */
209     function add(uint256 a, uint256 b) internal pure returns (uint256) {
210         uint256 c = a + b;
211         require(c >= a, "SafeMath: addition overflow");
212 
213         return c;
214     }
215 
216     /**
217      * @dev Returns the subtraction of two unsigned integers, reverting on
218      * overflow (when the result is negative).
219      *
220      * Counterpart to Solidity's `-` operator.
221      *
222      * Requirements:
223      * - Subtraction cannot overflow.
224      */
225     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
226         return sub(a, b, "SafeMath: subtraction overflow");
227     }
228 
229     /**
230      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
231      * overflow (when the result is negative).
232      *
233      * Counterpart to Solidity's `-` operator.
234      *
235      * Requirements:
236      * - Subtraction cannot overflow.
237      *
238      * _Available since v2.4.0._
239      */
240     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
241         require(b <= a, errorMessage);
242         uint256 c = a - b;
243 
244         return c;
245     }
246 
247     /**
248      * @dev Returns the multiplication of two unsigned integers, reverting on
249      * overflow.
250      *
251      * Counterpart to Solidity's `*` operator.
252      *
253      * Requirements:
254      * - Multiplication cannot overflow.
255      */
256     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
257         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
258         // benefit is lost if 'b' is also tested.
259         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
260         if (a == 0) {
261             return 0;
262         }
263 
264         uint256 c = a * b;
265         require(c / a == b, "SafeMath: multiplication overflow");
266 
267         return c;
268     }
269 
270     /**
271      * @dev Returns the integer division of two unsigned integers. Reverts on
272      * division by zero. The result is rounded towards zero.
273      *
274      * Counterpart to Solidity's `/` operator. Note: this function uses a
275      * `revert` opcode (which leaves remaining gas untouched) while Solidity
276      * uses an invalid opcode to revert (consuming all remaining gas).
277      *
278      * Requirements:
279      * - The divisor cannot be zero.
280      */
281     function div(uint256 a, uint256 b) internal pure returns (uint256) {
282         return div(a, b, "SafeMath: division by zero");
283     }
284 
285     /**
286      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
287      * division by zero. The result is rounded towards zero.
288      *
289      * Counterpart to Solidity's `/` operator. Note: this function uses a
290      * `revert` opcode (which leaves remaining gas untouched) while Solidity
291      * uses an invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      * - The divisor cannot be zero.
295      *
296      * _Available since v2.4.0._
297      */
298     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
299         // Solidity only automatically asserts when dividing by 0
300         require(b > 0, errorMessage);
301         uint256 c = a / b;
302         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
303 
304         return c;
305     }
306 
307     /**
308      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
309      * Reverts when dividing by zero.
310      *
311      * Counterpart to Solidity's `%` operator. This function uses a `revert`
312      * opcode (which leaves remaining gas untouched) while Solidity uses an
313      * invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      * - The divisor cannot be zero.
317      */
318     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
319         return mod(a, b, "SafeMath: modulo by zero");
320     }
321 
322     /**
323      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
324      * Reverts with custom message when dividing by zero.
325      *
326      * Counterpart to Solidity's `%` operator. This function uses a `revert`
327      * opcode (which leaves remaining gas untouched) while Solidity uses an
328      * invalid opcode to revert (consuming all remaining gas).
329      *
330      * Requirements:
331      * - The divisor cannot be zero.
332      *
333      * _Available since v2.4.0._
334      */
335     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
336         require(b != 0, errorMessage);
337         return a % b;
338     }
339 }
340 /**
341  * @dev Implementation of the {IERC20} interface.
342  *
343  * This implementation is agnostic to the way tokens are created. This means
344  * that a supply mechanism has to be added in a derived contract using {_mint}.
345  * For a generic mechanism see {ERC20Mintable}.
346  *
347  * TIP: For a detailed writeup see our guide
348  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
349  * to implement supply mechanisms].
350  *
351  * We have followed general OpenZeppelin guidelines: functions revert instead
352  * of returning `false` on failure. This behavior is nonetheless conventional
353  * and does not conflict with the expectations of ERC20 applications.
354  *
355  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
356  * This allows applications to reconstruct the allowance for all accounts just
357  * by listening to said events. Other implementations of the EIP may not emit
358  * these events, as it isn't required by the specification.
359  *
360  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
361  * functions have been added to mitigate the well-known issues around setting
362  * allowances. See {IERC20-approve}.
363  */
364  
365 contract ERC20 is Context, IERC20 {
366     using SafeMath for uint256;
367 
368     mapping (address => uint256) private _balances;
369 
370     mapping (address => mapping (address => uint256)) private _allowances;
371 
372     uint256 private _totalSupply;
373 
374     /**
375      * @dev See {IERC20-totalSupply}.
376      */
377     function totalSupply() public view returns (uint256) {
378         return _totalSupply;
379     }
380 
381     /**
382      * @dev See {IERC20-balanceOf}.
383      */
384     function balanceOf(address account) public view returns (uint256) {
385         return _balances[account];
386     }
387 
388     /**
389      * @dev See {IERC20-transfer}.
390      *
391      * Requirements:
392      *
393      * - `recipient` cannot be the zero address.
394      * - the caller must have a balance of at least `amount`.
395      */
396      
397     function transfer(address recipient, uint256 amount) public returns (bool) {
398         _transfer(_msgSender(), recipient, amount);
399         return true;
400     }
401 
402     /**
403      * @dev See {IERC20-allowance}.
404      */
405     function allowance(address owner, address spender) public view returns (uint256) {
406         return _allowances[owner][spender];
407     }
408 
409     /**
410      * @dev See {IERC20-approve}.
411      *
412      * Requirements:
413      *
414      * - `spender` cannot be the zero address.
415      */
416     function approve(address spender, uint256 amount) public returns (bool) {
417         _approve(_msgSender(), spender, amount);
418         return true;
419     }
420 
421     /**
422      * @dev See {IERC20-transferFrom}.
423      *
424      * Emits an {Approval} event indicating the updated allowance. This is not
425      * required by the EIP. See the note at the beginning of {ERC20};
426      *
427      * Requirements:
428      * - `sender` and `recipient` cannot be the zero address.
429      * - `sender` must have a balance of at least `amount`.
430      * - the caller must have allowance for `sender`'s tokens of at least
431      * `amount`.
432      */
433     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
434         _transfer(sender, recipient, amount);
435         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
436         return true;
437     }
438 
439     /**
440      * @dev Atomically increases the allowance granted to `spender` by the caller.
441      *
442      * This is an alternative to {approve} that can be used as a mitigation for
443      * problems described in {IERC20-approve}.
444      *
445      * Emits an {Approval} event indicating the updated allowance.
446      *
447      * Requirements:
448      *
449      * - `spender` cannot be the zero address.
450      */
451     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
452         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
453         return true;
454     }
455 
456     /**
457      * @dev Atomically decreases the allowance granted to `spender` by the caller.
458      *
459      * This is an alternative to {approve} that can be used as a mitigation for
460      * problems described in {IERC20-approve}.
461      *
462      * Emits an {Approval} event indicating the updated allowance.
463      *
464      * Requirements:
465      *
466      * - `spender` cannot be the zero address.
467      * - `spender` must have allowance for the caller of at least
468      * `subtractedValue`.
469      */
470     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
471         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
472         return true;
473     }
474 
475     /**
476      * @dev Moves tokens `amount` from `sender` to `recipient`.
477      *
478      * This is internal function is equivalent to {transfer}, and can be used to
479      * e.g. implement automatic token fees, slashing mechanisms, etc.
480      *
481      * Emits a {Transfer} event.
482      *
483      * Requirements:
484      *
485      * - `sender` cannot be the zero address.
486      * - `recipient` cannot be the zero address.
487      * - `sender` must have a balance of at least `amount`.
488      */
489     function _transfer(address sender, address recipient, uint256 amount) internal {
490         require(sender != address(0), "ERC20: transfer from the zero address");
491         require(recipient != address(0), "ERC20: transfer to the zero address");
492 
493         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
494         _balances[recipient] = _balances[recipient].add(amount);
495         emit Transfer(sender, recipient, amount);
496     }
497 
498     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
499      * the total supply.
500      *
501      * Emits a {Transfer} event with `from` set to the zero address.
502      *
503      * Requirements
504      *
505      * - `to` cannot be the zero address.
506      */
507     function _mint(address account, uint256 amount) internal {
508         require(account != address(0), "ERC20: mint to the zero address");
509 
510         _totalSupply = _totalSupply.add(amount);
511         _balances[account] = _balances[account].add(amount);
512         emit Transfer(address(0), account, amount);
513     }
514 
515     /**
516      * @dev Destroys `amount` tokens from `account`, reducing the
517      * total supply.
518      *
519      * Emits a {Transfer} event with `to` set to the zero address.
520      *
521      * Requirements
522      *
523      * - `account` cannot be the zero address.
524      * - `account` must have at least `amount` tokens.
525      */
526     function _burn(address account, uint256 amount) internal {
527         require(account != address(0), "ERC20: burn from the zero address");
528 
529         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
530         _totalSupply = _totalSupply.sub(amount);
531         emit Transfer(account, address(0), amount);
532     }
533 
534     /**
535      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
536      *
537      * This is internal function is equivalent to `approve`, and can be used to
538      * e.g. set automatic allowances for certain subsystems, etc.
539      *
540      * Emits an {Approval} event.
541      *
542      * Requirements:
543      *
544      * - `owner` cannot be the zero address.
545      * - `spender` cannot be the zero address.
546      */
547     function _approve(address owner, address spender, uint256 amount) internal {
548         require(owner != address(0), "ERC20: approve from the zero address");
549         require(spender != address(0), "ERC20: approve to the zero address");
550 
551         _allowances[owner][spender] = amount;
552         emit Approval(owner, spender, amount);
553     }
554 
555     /**
556      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
557      * from the caller's allowance.
558      *
559      * See {_burn} and {_approve}.
560      */
561     function _burnFrom(address account, uint256 amount) internal {
562         _burn(account, amount);
563         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
564     }
565 }
566 /**
567  * @dev Extension of {ERC20} that allows token holders to destroy both their own
568  * tokens and those that they have an allowance for, in a way that can be
569  * recognized off-chain (via event analysis).
570  */
571 contract ERC20Burnable is Context, ERC20 {
572     /**
573      * @dev Destroys `amount` tokens from the caller.
574      *
575      * See {ERC20-_burn}.
576      */
577     function burn(uint256 amount) public {
578         _burn(_msgSender(), amount);
579     }
580 
581     /**
582      * @dev See {ERC20-_burnFrom}.
583      */
584     function burnFrom(address account, uint256 amount) public {
585         _burnFrom(account, amount);
586     }
587 }
588 
589 contract MASQ is ERC20Burnable, Ownable {
590     string public constant name = "MASQ";
591     string public constant symbol = "MASQ";
592     uint8 public constant decimals = 18;
593 
594     // 472 million tokens * decimal places (10^18)
595     uint256 public constant INITIAL_SUPPLY = 472000000000000000000000000;
596 
597     constructor() public {
598         ERC20._mint(msg.sender, INITIAL_SUPPLY);
599     }
600 
601     function approve(address _spender, uint256 _value) public returns (bool) {
602         require(_value == 0 || allowance(msg.sender, _spender) == 0, "Use increaseApproval or decreaseApproval to prevent double-spend.");
603 
604         return ERC20.approve(_spender, _value);
605     }
606 }