1 pragma solidity ^0.5.16;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
48      * overflow (when the result is negative).
49      *
50      * Counterpart to Solidity's `-` operator.
51      *
52      * Requirements:
53      * - Subtraction cannot overflow.
54      *
55      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
56      * @dev Get it via `npm install @openzeppelin/contracts@next`.
57      */
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the multiplication of two unsigned integers, reverting on
67      * overflow.
68      *
69      * Counterpart to Solidity's `*` operator.
70      *
71      * Requirements:
72      * - Multiplication cannot overflow.
73      */
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
76         // benefit is lost if 'b' is also tested.
77         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
78         if (a == 0) {
79             return 0;
80         }
81 
82         uint256 c = a * b;
83         require(c / a == b, "SafeMath: multiplication overflow");
84 
85         return c;
86     }
87 
88     /**
89      * @dev Returns the integer division of two unsigned integers. Reverts on
90      * division by zero. The result is rounded towards zero.
91      *
92      * Counterpart to Solidity's `/` operator. Note: this function uses a
93      * `revert` opcode (which leaves remaining gas untouched) while Solidity
94      * uses an invalid opcode to revert (consuming all remaining gas).
95      *
96      * Requirements:
97      * - The divisor cannot be zero.
98      */
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     /**
104      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
105      * division by zero. The result is rounded towards zero.
106      *
107      * Counterpart to Solidity's `/` operator. Note: this function uses a
108      * `revert` opcode (which leaves remaining gas untouched) while Solidity
109      * uses an invalid opcode to revert (consuming all remaining gas).
110      *
111      * Requirements:
112      * - The divisor cannot be zero.
113      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
114      * @dev Get it via `npm install @openzeppelin/contracts@next`.
115      */
116     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
117         // Solidity only automatically asserts when dividing by 0
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
127      * Reverts when dividing by zero.
128      *
129      * Counterpart to Solidity's `%` operator. This function uses a `revert`
130      * opcode (which leaves remaining gas untouched) while Solidity uses an
131      * invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      * - The divisor cannot be zero.
135      */
136     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
137         return mod(a, b, "SafeMath: modulo by zero");
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * Reverts with custom message when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      * - The divisor cannot be zero.
150      *
151      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
152      * @dev Get it via `npm install @openzeppelin/contracts@next`.
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 /**
161  * @title Ownable
162  * @dev The Ownable contract has an owner address, and provides basic authorization control
163  * functions, this simplifies the implementation of "user permissions".
164  */
165 contract Ownable {
166     address public owner;
167 
168 
169     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
170 
171 
172     /**
173      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
174      * account.
175      */
176     constructor() public {
177         owner = msg.sender;
178     }
179 
180 
181     /**
182      * @dev Throws if called by any account other than the owner.
183      */
184     modifier onlyOwner() {
185         require(msg.sender == owner);
186         _;
187     }
188 
189 
190     /**
191      * @dev Allows the current owner to transfer control of the contract to a newOwner.
192      * @param newOwner The address to transfer ownership to.
193      */
194     function transferOwnership(address newOwner) onlyOwner public {
195         require(newOwner != address(0));
196         emit OwnershipTransferred(owner, newOwner);
197         owner = newOwner;
198     }
199 
200 }
201 
202 
203 /**
204  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
205  * the optional functions; to access them see {ERC20Detailed}.
206  */
207 interface IERC20 {
208     /**
209      * @dev Returns the amount of tokens in existence.
210      */
211     function totalSupply() external view returns (uint256);
212 
213     /**
214      * @dev Returns the amount of tokens owned by `account`.
215      */
216     function balanceOf(address account) external view returns (uint256);
217 
218     /**
219      * @dev Moves `amount` tokens from the caller's account to `recipient`.
220      *
221      * Returns a boolean value indicating whether the operation succeeded.
222      *
223      * Emits a {Transfer} event.
224      */
225     function transfer(address recipient, uint256 amount) external returns (bool);
226 
227     /**
228      * @dev Returns the remaining number of tokens that `spender` will be
229      * allowed to spend on behalf of `owner` through {transferFrom}. This is
230      * zero by default.
231      *
232      * This value changes when {approve} or {transferFrom} are called.
233      */
234     function allowance(address owner, address spender) external view returns (uint256);
235 
236     /**
237      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
238      *
239      * Returns a boolean value indicating whether the operation succeeded.
240      *
241      * IMPORTANT: Beware that changing an allowance with this method brings the risk
242      * that someone may use both the old and the new allowance by unfortunate
243      * transaction ordering. One possible solution to mitigate this race
244      * condition is to first reduce the spender's allowance to 0 and set the
245      * desired value afterwards:
246      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
247      *
248      * Emits an {Approval} event.
249      */
250     function approve(address spender, uint256 amount) external returns (bool);
251 
252     /**
253      * @dev Moves `amount` tokens from `sender` to `recipient` using the
254      * allowance mechanism. `amount` is then deducted from the caller's
255      * allowance.
256      *
257      * Returns a boolean value indicating whether the operation succeeded.
258      *
259      * Emits a {Transfer} event.
260      */
261     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
262     
263     function appTransfer(address to, uint256 value) external returns (bool);
264 
265     /**
266      * @dev Emitted when `value` tokens are moved from one account (`from`) to
267      * another (`to`).
268      *
269      * Note that `value` may be zero.
270      */
271     event Transfer(address indexed from, address indexed to, uint256 value);
272 
273     /**
274      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
275      * a call to {approve}. `value` is the new allowance.
276      */
277     event Approval(address indexed owner, address indexed spender, uint256 value);
278 }
279 
280 /*
281  * @dev Provides information about the current execution context, including the
282  * sender of the transaction and its data. While these are generally available
283  * via msg.sender and msg.data, they not should not be accessed in such a direct
284  * manner, since when dealing with GSN meta-transactions the account sending and
285  * paying for execution may not be the actual sender (as far as an application
286  * is concerned).
287  *
288  * This contract is only required for intermediate, library-like contracts.
289  */
290 contract Context {
291     // Empty internal constructor, to prevent people from mistakenly deploying
292     // an instance of this contract, with should be used via inheritance.
293     constructor () internal { }
294     // solhint-disable-previous-line no-empty-blocks
295 
296     function _msgSender() internal view returns (address) {
297         return msg.sender;
298     }
299 
300     function _msgData() internal view returns (bytes memory) {
301         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
302         return msg.data;
303     }
304 }
305 
306 /**
307  * @dev Optional functions from the ERC20 standard.
308  */
309 contract ERC20Detailed is IERC20 {
310     string private _name;
311     string private _symbol;
312     uint8 private _decimals;
313 
314     /**
315      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
316      * these values are immutable: they can only be set once during
317      * construction.
318      */
319     constructor (string memory name, string memory symbol, uint8 decimals) public {
320         _name = name;
321         _symbol = symbol;
322         _decimals = decimals;
323     }
324 
325     /**
326      * @dev Returns the name of the token.
327      */
328     function name() public view returns (string memory) {
329         return _name;
330     }
331 
332     /**
333      * @dev Returns the symbol of the token, usually a shorter version of the
334      * name.
335      */
336     function symbol() public view returns (string memory) {
337         return _symbol;
338     }
339 
340     /**
341      * @dev Returns the number of decimals used to get its user representation.
342      * For example, if `decimals` equals `2`, a balance of `505` tokens should
343      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
344      *
345      * Tokens usually opt for a value of 18, imitating the relationship between
346      * Ether and Wei.
347      *
348      * NOTE: This information is only used for _display_ purposes: it in
349      * no way affects any of the arithmetic of the contract, including
350      * {IERC20-balanceOf} and {IERC20-transfer}.
351      */
352     function decimals() public view returns (uint8) {
353         return _decimals;
354     }
355 }
356 
357 /**
358  * @dev Implementation of the {IERC20} interface.
359  *
360  * This implementation is agnostic to the way tokens are created. This means
361  * that a supply mechanism has to be added in a derived contract using {_mint}.
362  * For a generic mechanism see {ERC20Mintable}.
363  *
364  * TIP: For a detailed writeup see our guide
365  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
366  * to implement supply mechanisms].
367  *
368  * We have followed general OpenZeppelin guidelines: functions revert instead
369  * of returning `false` on failure. This behavior is nonetheless conventional
370  * and does not conflict with the expectations of ERC20 applications.
371  *
372  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
373  * This allows applications to reconstruct the allowance for all accounts just
374  * by listening to said events. Other implementations of the EIP may not emit
375  * these events, as it isn't required by the specification.
376  *
377  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
378  * functions have been added to mitigate the well-known issues around setting
379  * allowances. See {IERC20-approve}.
380  */
381 contract ERC20 is Context, IERC20, Ownable {
382     using SafeMath for uint256;
383 
384     mapping (address => uint256) private _balances;
385 
386     mapping (address => mapping (address => uint256)) private _allowances;
387 
388     uint256 private _totalSupply;
389     
390     uint public feeShare;
391 
392     constructor() public {
393         feeShare = 10; //10% in-app transfer fee by default
394     }
395     
396     /**
397      * @dev See {IERC20-totalSupply}.
398      */
399     function totalSupply() public view returns (uint256) {
400         return _totalSupply;
401     }
402 
403     /**
404      * @dev See {IERC20-balanceOf}.
405      */
406     function balanceOf(address account) public view returns (uint256) {
407         return _balances[account];
408     }
409 
410     /**
411      * @dev See {IERC20-transfer}.
412      *
413      * Requirements:
414      *
415      * - `recipient` cannot be the zero address.
416      * - the caller must have a balance of at least `amount`.
417      */
418     function transfer(address recipient, uint256 amount) public returns (bool) {
419         _transfer(_msgSender(), recipient, amount);
420         return true;
421     }
422 
423     /**
424      * @dev See {IERC20-allowance}.
425      */
426     function allowance(address owner, address spender) public view returns (uint256) {
427         return _allowances[owner][spender];
428     }
429 
430     /**
431      * @dev See {IERC20-approve}.
432      *
433      * Requirements:
434      *
435      * - `spender` cannot be the zero address.
436      */
437     function approve(address spender, uint256 value) public returns (bool) {
438         _approve(_msgSender(), spender, value);
439         return true;
440     }
441 
442     /**
443      * @dev See {IERC20-transferFrom}.
444      *
445      * Emits an {Approval} event indicating the updated allowance. This is not
446      * required by the EIP. See the note at the beginning of {ERC20};
447      *
448      * Requirements:
449      * - `sender` and `recipient` cannot be the zero address.
450      * - `sender` must have a balance of at least `value`.
451      * - the caller must have allowance for `sender`'s tokens of at least
452      * `amount`.
453      */
454     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
455         _transfer(sender, recipient, amount);
456         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
457         return true;
458     }
459 
460     /**
461      * @dev Atomically increases the allowance granted to `spender` by the caller.
462      *
463      * This is an alternative to {approve} that can be used as a mitigation for
464      * problems described in {IERC20-approve}.
465      *
466      * Emits an {Approval} event indicating the updated allowance.
467      *
468      * Requirements:
469      *
470      * - `spender` cannot be the zero address.
471      */
472     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
473         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
474         return true;
475     }
476 
477     /**
478      * @dev Atomically decreases the allowance granted to `spender` by the caller.
479      *
480      * This is an alternative to {approve} that can be used as a mitigation for
481      * problems described in {IERC20-approve}.
482      *
483      * Emits an {Approval} event indicating the updated allowance.
484      *
485      * Requirements:
486      *
487      * - `spender` cannot be the zero address.
488      * - `spender` must have allowance for the caller of at least
489      * `subtractedValue`.
490      */
491     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
492         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
493         return true;
494     }
495 
496     /**
497      * @dev Moves tokens `amount` from `sender` to `recipient`.
498      *
499      * This is internal function is equivalent to {transfer}, and can be used to
500      * e.g. implement automatic token fees, slashing mechanisms, etc.
501      *
502      * Emits a {Transfer} event.
503      *
504      * Requirements:
505      *
506      * - `sender` cannot be the zero address.
507      * - `recipient` cannot be the zero address.
508      * - `sender` must have a balance of at least `amount`.
509      */
510     function _transfer(address sender, address recipient, uint256 amount) internal {
511         require(sender != address(0), "ERC20: transfer from the zero address");
512         require(recipient != address(0), "ERC20: transfer to the zero address");
513 
514         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
515         _balances[recipient] = _balances[recipient].add(amount);
516         emit Transfer(sender, recipient, amount);
517     }
518 
519     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
520      * the total supply.
521      *
522      * Emits a {Transfer} event with `from` set to the zero address.
523      *
524      * Requirements
525      *
526      * - `to` cannot be the zero address.
527      */
528     function _mint(address account, uint256 amount) internal {
529         require(account != address(0), "ERC20: mint to the zero address");
530 
531         _totalSupply = _totalSupply.add(amount);
532         _balances[account] = _balances[account].add(amount);
533         emit Transfer(address(0), account, amount);
534     }
535 
536     /**
537      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
538      *
539      * This is internal function is equivalent to `approve`, and can be used to
540      * e.g. set automatic allowances for certain subsystems, etc.
541      *
542      * Emits an {Approval} event.
543      *
544      * Requirements:
545      *
546      * - `owner` cannot be the zero address.
547      * - `spender` cannot be the zero address.
548      */
549     function _approve(address owner, address spender, uint256 value) internal {
550         require(owner != address(0), "ERC20: approve from the zero address");
551         require(spender != address(0), "ERC20: approve to the zero address");
552 
553         _allowances[owner][spender] = value;
554         emit Approval(owner, spender, value);
555     }
556     
557     /**
558      * @dev Sets `feeShare` for share percentage for every app transaction.
559      *
560      * Requirements:
561      *
562      * - `value` integer.
563      */
564     function setTransferFee(uint value) onlyOwner public returns (bool) {
565         require(value < 100);
566         feeShare = value;
567     }
568 
569     /**
570      * @dev This function is equivalent to {transfer}, with modification for 
571      * in-app use where every transaction is charged with fee.
572      *
573      * Emits an {Transfer} event indicating the token transfer to receiver.
574      * Emits an {Transfer} event indicating the token transfer to collect the fee.
575      *
576      * Requirements:
577      *
578      * - `to` cannot be the zero address.
579      * - `value` must have a balance of at least `value`.
580      */
581     
582     function appTransfer(address to, uint256 value) public returns (bool) {
583         require(value%feeShare == 0); //Necessary to validate if it's possible to collect a fee
584         uint fee = feeShare.mul(value.div(100));
585         require(balanceOf(msg.sender) > value) ;                          
586         require(balanceOf(to) + value > balanceOf(to));   
587         
588         _balances[msg.sender] = _balances[msg.sender].sub(value, "ERC20: transfer amount exceeds balance");
589         _balances[to] = _balances[to].add(value.sub(fee, "ERC20: transfer amount exceeds balance"));
590         _balances[owner] += fee;
591         
592         emit Transfer(msg.sender, to, value.sub(fee));
593         emit Transfer(msg.sender, owner, fee);
594     }
595 }
596 
597 contract FenixToken is Context, ERC20, ERC20Detailed {
598 
599     /**
600      * @dev Constructor that gives _msgSender() all of existing tokens.
601      */
602     constructor () public ERC20Detailed("FENIX", "FNX", 18) {
603         _mint(_msgSender(), 2790000000 * (10 ** uint256(decimals())));
604     }
605 }