1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 
79 
80 /**
81  * @dev Interface for the optional metadata functions from the ERC20 standard.
82  *
83  * _Available since v4.1._
84  */
85 interface IERC20Metadata is IERC20 {
86     /**
87      * @dev Returns the name of the token.
88      */
89     function name() external view returns (string memory);
90 
91     /**
92      * @dev Returns the symbol of the token.
93      */
94     function symbol() external view returns (string memory);
95 
96     /**
97      * @dev Returns the decimals places of the token.
98      */
99     function decimals() external view returns (uint8);
100 }
101 
102 
103 
104 /*
105  * @dev Provides information about the current execution context, including the
106  * sender of the transaction and its data. While these are generally available
107  * via msg.sender and msg.data, they should not be accessed in such a direct
108  * manner, since when dealing with meta-transactions the account sending and
109  * paying for execution may not be the actual sender (as far as an application
110  * is concerned).
111  *
112  * This contract is only required for intermediate, library-like contracts.
113  */
114 abstract contract Context {
115     function _msgSender() internal view virtual returns (address) {
116         return msg.sender;
117     }
118 
119     function _msgData() internal view virtual returns (bytes calldata) {
120         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
121         return msg.data;
122     }
123 }
124 
125 /**
126  * @dev Wrappers over Solidity's arithmetic operations with added overflow
127  * checks.
128  *
129  * Arithmetic operations in Solidity wrap on overflow. This can easily result
130  * in bugs, because programmers usually assume that an overflow raises an
131  * error, which is the standard behavior in high level programming languages.
132  * `SafeMath` restores this intuition by reverting the transaction when an
133  * operation overflows.
134  *
135  * Using this library instead of the unchecked operations eliminates an entire
136  * class of bugs, so it's recommended to use it always.
137  */
138  
139 library SafeMath {
140     /**
141      * @dev Returns the addition of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `+` operator.
145      *
146      * Requirements:
147      *
148      * - Addition cannot overflow.
149      */
150     function add(uint256 a, uint256 b) internal pure returns (uint256) {
151         uint256 c = a + b;
152         require(c >= a, "SafeMath: addition overflow");
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      *
165      * - Subtraction cannot overflow.
166      */
167     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
168         return sub(a, b, "SafeMath: subtraction overflow");
169     }
170 
171     /**
172      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
173      * overflow (when the result is negative).
174      *
175      * Counterpart to Solidity's `-` operator.
176      *
177      * Requirements:
178      *
179      * - Subtraction cannot overflow.
180      */
181     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
182         require(b <= a, errorMessage);
183         uint256 c = a - b;
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the multiplication of two unsigned integers, reverting on
190      * overflow.
191      *
192      * Counterpart to Solidity's `*` operator.
193      *
194      * Requirements:
195      *
196      * - Multiplication cannot overflow.
197      */
198     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
199         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
200         // benefit is lost if 'b' is also tested.
201         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
202         if (a == 0) {
203             return 0;
204         }
205 
206         uint256 c = a * b;
207         require(c / a == b, "SafeMath: multiplication overflow");
208 
209         return c;
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers. Reverts on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function div(uint256 a, uint256 b) internal pure returns (uint256) {
225         return div(a, b, "SafeMath: division by zero");
226     }
227 
228     /**
229      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
230      * division by zero. The result is rounded towards zero.
231      *
232      * Counterpart to Solidity's `/` operator. Note: this function uses a
233      * `revert` opcode (which leaves remaining gas untouched) while Solidity
234      * uses an invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
241         require(b > 0, errorMessage);
242         uint256 c = a / b;
243         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
244 
245         return c;
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
261         return mod(a, b, "SafeMath: modulo by zero");
262     }
263 
264     /**
265      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
266      * Reverts with custom message when dividing by zero.
267      *
268      * Counterpart to Solidity's `%` operator. This function uses a `revert`
269      * opcode (which leaves remaining gas untouched) while Solidity uses an
270      * invalid opcode to revert (consuming all remaining gas).
271      *
272      * Requirements:
273      *
274      * - The divisor cannot be zero.
275      */
276     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
277         require(b != 0, errorMessage);
278         return a % b;
279     }
280 }
281 
282 
283 /**
284  * @dev Contract module which provides a basic access control mechanism, where
285  * there is an account (an owner) that can be granted exclusive access to
286  * specific functions.
287  *
288  * By default, the owner account will be the one that deploys the contract. This
289  * can later be changed with {transferOwnership}.
290  *
291  * This module is used through inheritance. It will make available the modifier
292  * `onlyOwner`, which can be applied to your functions to restrict their use to
293  * the owner.
294  */
295 contract Ownable is Context {
296     address private _owner;
297     address private _previousOwner;
298     uint256 private _lockTime;
299 
300     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
301 
302     /**
303      * @dev Initializes the contract setting the deployer as the initial owner.
304      */
305     constructor () {
306         address msgSender = _msgSender();
307         _owner = msgSender;
308         emit OwnershipTransferred(address(0), msgSender);
309     }
310 
311     /**
312      * @dev Returns the address of the current owner.
313      */
314     function owner() public view returns (address) {
315         return _owner;
316     }
317 
318     /**
319      * @dev Throws if called by any account other than the owner.
320      */
321     modifier onlyOwner() {
322         require(_owner == _msgSender(), "Ownable: caller is not the owner");
323         _;
324     }
325 
326      /**
327      * @dev Leaves the contract without owner. It will not be possible to call
328      * `onlyOwner` functions anymore. Can only be called by the current owner.
329      *
330      * NOTE: Renouncing ownership will leave the contract without an owner,
331      * thereby removing any functionality that is only available to the owner.
332      */
333     function renounceOwnership() public virtual onlyOwner {
334         emit OwnershipTransferred(_owner, address(0));
335         _owner = address(0);
336     }
337 
338     /**
339      * @dev Transfers ownership of the contract to a new account (`newOwner`).
340      * Can only be called by the current owner.
341      */
342     function transferOwnership(address newOwner) public virtual onlyOwner {
343         require(newOwner != address(0), "Ownable: new owner is the zero address");
344         emit OwnershipTransferred(_owner, newOwner);
345         _owner = newOwner;
346     }
347 
348     function geUnlockTime() public view returns (uint256) {
349         return _lockTime;
350     }
351 
352     //Locks the contract for owner for the amount of time provided
353     function lock(uint256 time) public virtual onlyOwner {
354         _previousOwner = _owner;
355         _owner = address(0);
356         _lockTime = block.timestamp + time;
357         emit OwnershipTransferred(_owner, address(0));
358     }
359     
360     //Unlocks the contract for owner when _lockTime is exceeds
361     function unlock() public virtual {
362         require(_previousOwner == msg.sender, "You don't have permission to unlock");
363         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
364         emit OwnershipTransferred(_owner, _previousOwner);
365         _owner = _previousOwner;
366     }
367 }
368 
369 
370 
371 
372 contract standardToken is Context, IERC20, IERC20Metadata,Ownable {
373     mapping (address => uint256) private _balances;
374 
375     mapping (address => mapping (address => uint256)) private _allowances;
376     bool public generatedUsingDxMint = true;
377     uint256 private _totalSupply;
378     bool public mintingFinishedPermanent = false;
379     string private _name;
380     string private _symbol;
381     uint8 private _decimals;
382     address public _creator;
383     /**
384      * @dev Sets the values for {name}, {symbol} and {decimals}.
385      *
386      *
387      * All two of these values are immutable: they can only be set once during
388      * construction.
389      */
390     constructor (address creator_,string memory name_, string memory symbol_,uint8 decimals_, uint256 tokenSupply_) {
391         _name = name_;
392         _symbol = symbol_;
393         _decimals = decimals_;
394         _creator = creator_;
395         
396         _mint(_creator,tokenSupply_);
397         mintingFinishedPermanent = true;
398     }
399 
400     /**
401      * @dev Returns the name of the token.
402      */
403     function name() public view virtual override returns (string memory) {
404         return _name;
405     }
406 
407     /**
408      * @dev Returns the symbol of the token, usually a shorter version of the
409      * name.
410      */
411     function symbol() public view virtual override returns (string memory) {
412         return _symbol;
413     }
414 
415     /**
416      * @dev Returns the number of decimals used to get its user representation.
417      * For example, if `decimals` equals `2`, a balance of `505` tokens should
418      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
419      *
420      * Tokens usually opt for a value of 18, imitating the relationship between
421      * Ether and Wei. This is the value {ERC20} uses, unless this function is
422      * overridden;
423      *
424      * NOTE: This information is only used for _display_ purposes: it in
425      * no way affects any of the arithmetic of the contract, including
426      * {IERC20-balanceOf} and {IERC20-transfer}.
427      */
428     function decimals() public view virtual override returns (uint8) {
429         return _decimals;
430     }
431 
432     /**
433      * @dev See {IERC20-totalSupply}.
434      */
435     function totalSupply() public view virtual override returns (uint256) {
436         return _totalSupply;
437     }
438 
439     /**
440      * @dev See {IERC20-balanceOf}.
441      */
442     function balanceOf(address account) public view virtual override returns (uint256) {
443         return _balances[account];
444     }
445 
446     /**
447      * @dev See {IERC20-transfer}.
448      *
449      * Requirements:
450      *
451      * - `recipient` cannot be the zero address.
452      * - the caller must have a balance of at least `amount`.
453      */
454     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
455         _transfer(_msgSender(), recipient, amount);
456         return true;
457     }
458 
459     /**
460      * @dev See {IERC20-allowance}.
461      */
462     function allowance(address owner, address spender) public view virtual override returns (uint256) {
463         return _allowances[owner][spender];
464     }
465 
466     /**
467      * @dev See {IERC20-approve}.
468      *
469      * Requirements:
470      *
471      * - `spender` cannot be the zero address.
472      */
473     function approve(address spender, uint256 amount) public virtual override returns (bool) {
474         _approve(_msgSender(), spender, amount);
475         return true;
476     }
477 
478     /**
479      * @dev See {IERC20-transferFrom}.
480      *
481      * Emits an {Approval} event indicating the updated allowance. This is not
482      * required by the EIP. See the note at the beginning of {ERC20}.
483      *
484      * Requirements:
485      *
486      * - `sender` and `recipient` cannot be the zero address.
487      * - `sender` must have a balance of at least `amount`.
488      * - the caller must have allowance for ``sender``'s tokens of at least
489      * `amount`.
490      */
491     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
492         _transfer(sender, recipient, amount);
493 
494         uint256 currentAllowance = _allowances[sender][_msgSender()];
495         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
496         _approve(sender, _msgSender(), currentAllowance - amount);
497 
498         return true;
499     }
500 
501     /**
502      * @dev Atomically increases the allowance granted to `spender` by the caller.
503      *
504      * This is an alternative to {approve} that can be used as a mitigation for
505      * problems described in {IERC20-approve}.
506      *
507      * Emits an {Approval} event indicating the updated allowance.
508      *
509      * Requirements:
510      *
511      * - `spender` cannot be the zero address.
512      */
513     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
514         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
515         return true;
516     }
517 
518     /**
519      * @dev Atomically decreases the allowance granted to `spender` by the caller.
520      *
521      * This is an alternative to {approve} that can be used as a mitigation for
522      * problems described in {IERC20-approve}.
523      *
524      * Emits an {Approval} event indicating the updated allowance.
525      *
526      * Requirements:
527      *
528      * - `spender` cannot be the zero address.
529      * - `spender` must have allowance for the caller of at least
530      * `subtractedValue`.
531      */
532     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
533         uint256 currentAllowance = _allowances[_msgSender()][spender];
534         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
535         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
536 
537         return true;
538     }
539 
540     /**
541      * @dev Moves tokens `amount` from `sender` to `recipient`.
542      *
543      * This is internal function is equivalent to {transfer}, and can be used to
544      * e.g. implement automatic token fees, slashing mechanisms, etc.
545      *
546      * Emits a {Transfer} event.
547      *
548      * Requirements:
549      *
550      * - `sender` cannot be the zero address.
551      * - `recipient` cannot be the zero address.
552      * - `sender` must have a balance of at least `amount`.
553      */
554     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
555         require(sender != address(0), "ERC20: transfer from the zero address");
556         require(recipient != address(0), "ERC20: transfer to the zero address");
557 
558         _beforeTokenTransfer(sender, recipient, amount);
559 
560         uint256 senderBalance = _balances[sender];
561         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
562         _balances[sender] = senderBalance - amount;
563         _balances[recipient] += amount;
564 
565         emit Transfer(sender, recipient, amount);
566     }
567 
568     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
569      * the total supply.
570      *
571      * Emits a {Transfer} event with `from` set to the zero address.
572      *
573      * Requirements:
574      *
575      * - `account` cannot be the zero address.
576      */
577     function _mint(address account, uint256 amount) internal virtual {
578         require(!mintingFinishedPermanent,"cant be minted anymore!");
579         require(account != address(0), "ERC20: mint to the zero address");
580 
581         _beforeTokenTransfer(address(0), account, amount);
582 
583         _totalSupply += amount;
584         _balances[account] += amount;
585         emit Transfer(address(0), account, amount);
586     } 
587 
588     /**
589      * @dev Destroys `amount` tokens from `account`, reducing the
590      * total supply.
591      *
592      * Emits a {Transfer} event with `to` set to the zero address.
593      *
594      * Requirements:
595      *
596      * - `account` cannot be the zero address.
597      * - `account` must have at least `amount` tokens.
598      */
599     function _burn(address account, uint256 amount) internal virtual {
600         require(account != address(0), "ERC20: burn from the zero address");
601 
602         _beforeTokenTransfer(account, address(0), amount);
603 
604         uint256 accountBalance = _balances[account];
605         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
606         _balances[account] = accountBalance - amount;
607         _totalSupply -= amount;
608 
609         emit Transfer(account, address(0), amount);
610     }
611 
612     /**
613      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
614      *
615      * This internal function is equivalent to `approve`, and can be used to
616      * e.g. set automatic allowances for certain subsystems, etc.
617      *
618      * Emits an {Approval} event.
619      *
620      * Requirements:
621      *
622      * - `owner` cannot be the zero address.
623      * - `spender` cannot be the zero address.
624      */
625     function _approve(address owner, address spender, uint256 amount) internal virtual {
626         require(owner != address(0), "ERC20: approve from the zero address");
627         require(spender != address(0), "ERC20: approve to the zero address");
628 
629         _allowances[owner][spender] = amount;
630         emit Approval(owner, spender, amount);
631     }
632 
633     /**
634      * @dev Hook that is called before any transfer of tokens. This includes
635      * minting and burning.
636      *
637      * Calling conditions:
638      *
639      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
640      * will be to transferred to `to`.
641      * - when `from` is zero, `amount` tokens will be minted for `to`.
642      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
643      * - `from` and `to` are never both zero.
644      *
645      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
646      */
647     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
648 }