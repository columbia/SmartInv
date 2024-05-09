1 pragma solidity ^0.4.24;
2 
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 contract Context {
15     // Empty internal constructor, to prevent people from mistakenly deploying
16     // an instance of this contract, which should be used via inheritance.
17     constructor () internal { }
18     // solhint-disable-previous-line no-empty-blocks
19 
20     function _msgSender() internal view returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 
32 /**
33  * @dev Wrappers over Solidity's arithmetic operations with added overflow
34  * checks.
35  *
36  * Arithmetic operations in Solidity wrap on overflow. This can easily result
37  * in bugs, because programmers usually assume that an overflow raises an
38  * error, which is the standard behavior in high level programming languages.
39  * `SafeMath` restores this intuition by reverting the transaction when an
40  * operation overflows.
41  *
42  * Using this library instead of the unchecked operations eliminates an entire
43  * class of bugs, so it's recommended to use it always.
44  */
45 library SafeMath {
46     /**
47      * @dev Returns the addition of two unsigned integers, reverting on
48      * overflow.
49      *
50      * Counterpart to Solidity's `+` operator.
51      *
52      * Requirements:
53      * - Addition cannot overflow.
54      */
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a, "SafeMath: addition overflow");
58 
59         return c;
60     }
61 
62     /**
63      * @dev Returns the subtraction of two unsigned integers, reverting on
64      * overflow (when the result is negative).
65      *
66      * Counterpart to Solidity's `-` operator.
67      *
68      * Requirements:
69      * - Subtraction cannot overflow.
70      */
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         return sub(a, b, "SafeMath: subtraction overflow");
73     }
74 
75     /**
76      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
77      * overflow (when the result is negative).
78      *
79      * Counterpart to Solidity's `-` operator.
80      *
81      * Requirements:
82      * - Subtraction cannot overflow.
83      *
84      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
85      * @dev Get it via `npm install @openzeppelin/contracts@next`.
86      */
87     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
88         require(b <= a, errorMessage);
89         uint256 c = a - b;
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the multiplication of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `*` operator.
99      *
100      * Requirements:
101      * - Multiplication cannot overflow.
102      */
103     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
105         // benefit is lost if 'b' is also tested.
106         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
107         if (a == 0) {
108             return 0;
109         }
110 
111         uint256 c = a * b;
112         require(c / a == b, "SafeMath: multiplication overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the integer division of two unsigned integers. Reverts on
119      * division by zero. The result is rounded towards zero.
120      *
121      * Counterpart to Solidity's `/` operator. Note: this function uses a
122      * `revert` opcode (which leaves remaining gas untouched) while Solidity
123      * uses an invalid opcode to revert (consuming all remaining gas).
124      *
125      * Requirements:
126      * - The divisor cannot be zero.
127      */
128     function div(uint256 a, uint256 b) internal pure returns (uint256) {
129         return div(a, b, "SafeMath: division by zero");
130     }
131 
132     /**
133      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
134      * division by zero. The result is rounded towards zero.
135      *
136      * Counterpart to Solidity's `/` operator. Note: this function uses a
137      * `revert` opcode (which leaves remaining gas untouched) while Solidity
138      * uses an invalid opcode to revert (consuming all remaining gas).
139      *
140      * Requirements:
141      * - The divisor cannot be zero.
142 
143      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
144      * @dev Get it via `npm install @openzeppelin/contracts@next`.
145      */
146     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
147         // Solidity only automatically asserts when dividing by 0
148         require(b > 0, errorMessage);
149         uint256 c = a / b;
150         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
157      * Reverts when dividing by zero.
158      *
159      * Counterpart to Solidity's `%` operator. This function uses a `revert`
160      * opcode (which leaves remaining gas untouched) while Solidity uses an
161      * invalid opcode to revert (consuming all remaining gas).
162      *
163      * Requirements:
164      * - The divisor cannot be zero.
165      */
166     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
167         return mod(a, b, "SafeMath: modulo by zero");
168     }
169 
170     /**
171      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
172      * Reverts with custom message when dividing by zero.
173      *
174      * Counterpart to Solidity's `%` operator. This function uses a `revert`
175      * opcode (which leaves remaining gas untouched) while Solidity uses an
176      * invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      * - The divisor cannot be zero.
180      *
181      * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
182      * @dev Get it via `npm install @openzeppelin/contracts@next`.
183      */
184     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
185         require(b != 0, errorMessage);
186         return a % b;
187     }
188 }
189 
190 
191 
192 /**
193  * @title Ownable
194  * @dev The Ownable contract has an owner address, and provides basic authorization control
195  * functions, this simplifies the implementation of "user permissions".
196  */
197 contract Ownable {
198   address public owner;
199 
200 
201   /**
202    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
203    * account.
204    */
205   constructor() public {
206     owner = msg.sender;
207   }
208 
209 
210   /**
211    * @dev Throws if called by any account other than the owner.
212    */
213   modifier onlyOwner() {
214     require(msg.sender == owner);
215     _;
216   }
217 
218 
219   /**
220    * @dev Allows the current owner to transfer control of the contract to a newOwner.
221    * @param newOwner The address to transfer ownership to.
222    */
223   function transferOwnership(address newOwner) public onlyOwner {
224     if (newOwner != address(0)) {
225       owner = newOwner;
226     }
227   }
228 
229 }
230 
231 
232 
233 /**
234  * @title Pausable
235  * @dev Base contract which allows children to implement an emergency stop mechanism.
236  */
237 contract Pausable is Ownable {
238   event Pause();
239   event Unpause();
240 
241   bool public paused = false;
242 
243 
244   /**
245    * @dev modifier to allow actions only when the contract IS paused
246    */
247   modifier whenNotPaused() {
248     require(!paused);
249     _;
250   }
251 
252   /**
253    * @dev modifier to allow actions only when the contract IS NOT paused
254    */
255   modifier whenPaused {
256     require(paused);
257     _;
258   }
259 
260   /**
261    * @dev called by the owner to pause, triggers stopped state
262    */
263   function pause() public onlyOwner whenNotPaused returns (bool) {
264     paused = true;
265     emit Pause();
266     return true;
267   }
268 
269   /**
270    * @dev called by the owner to unpause, returns to normal state
271    */
272   function unpause() public onlyOwner whenPaused returns (bool) {
273     paused = false;
274     emit Unpause();
275     return true;
276   }
277 }
278 
279 
280 
281 contract ERC20 is Context, Ownable, Pausable {
282     using SafeMath for uint256;
283     
284     string private _name;
285     string private _symbol;
286     uint8 private _decimals;
287     uint256 private _totalSupply;
288     
289     uint256 private ONE_TOKEN;
290 
291     mapping (address => uint256) private _balances;
292     
293     mapping (address => mapping (address => uint256)) private _allowances;
294 
295     /**
296      * @dev Emitted when `value` tokens are moved from one account (`from`) to
297      * another (`to`).
298      *
299      * Note that `value` may be zero.
300      */
301     event Transfer(address indexed from, address indexed to, uint256 value);
302 
303     /**
304      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
305      * a call to {approve}. `value` is the new allowance.
306      */
307     event Approval(address indexed owner, address indexed spender, uint256 value);
308 
309     /**
310      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
311      * these values are immutable: they can only be set once during
312      * construction.
313      */
314     // constructor (string name, string symbol, uint256 totalSupply, uint8 decimals) public {
315     //     _name = name;
316     //     _symbol = symbol;
317     //     _decimals = decimals;
318     //     ONE_TOKEN = (10 ** uint256(decimals)); 
319     //     _totalSupply = totalSupply * ONE_TOKEN;
320     //     _balances[_msgSender()] = _totalSupply;  
321     // }
322     
323     constructor () public {
324         _name = "ATTN";
325         _symbol = "ATTN";
326         _decimals = 6;
327         ONE_TOKEN = (10 ** uint256(_decimals)); 
328         _totalSupply = 1000000000 * ONE_TOKEN;
329         _balances[_msgSender()] = _totalSupply;  
330     }
331 
332     /**
333      * @dev Returns the name of the token.
334      */
335     function name() public view returns (string memory) {
336         return _name;
337     }
338 
339     /**
340      * @dev Returns the symbol of the token, usually a shorter version of the
341      * name.
342      */
343     function symbol() public view returns (string memory) {
344         return _symbol;
345     }
346 
347     /**
348      * @dev Returns the number of decimals used to get its user representation.
349      * For example, if `decimals` equals `2`, a balance of `505` tokens should
350      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
351      *
352      * Tokens usually opt for a value of 18, imitating the relationship between
353      * Ether and Wei.
354      *
355      * NOTE: This information is only used for _display_ purposes: it in
356      * no way affects any of the arithmetic of the contract, including
357      * {IERC20-balanceOf} and {IERC20-transfer}.
358      */
359     function decimals() public view returns (uint8) {
360         return _decimals;
361     }
362     
363     /**
364      * @dev See {IERC20-totalSupply}.
365      */
366     function totalSupply() public view returns (uint256) {
367         return _totalSupply;
368     }
369 
370     /**
371      * @dev See {IERC20-balanceOf}.
372      */
373     function balanceOf(address account) public view returns (uint256) {
374         return _balances[account];
375     }
376 
377     /**
378      * @dev See {IERC20-transfer}.
379      *
380      * Requirements:
381      *
382      * - `recipient` cannot be the zero address.
383      * - the caller must have a balance of at least `amount`.
384      */
385     function transfer(address recipient, uint256 amount) public returns (bool) {
386         _transfer(_msgSender(), recipient, amount);
387         return true;
388     }
389 
390     /**
391      * @dev See {IERC20-allowance}.
392      */
393     function allowance(address owner, address spender) public view returns (uint256) {
394         return _allowances[owner][spender];
395     }
396 
397     /**
398      * @dev See {IERC20-approve}.
399      *
400      * Requirements:
401      *
402      * - `spender` cannot be the zero address.
403      */
404     function approve(address spender, uint256 amount) public returns (bool) {
405         _approve(_msgSender(), spender, amount);
406         return true;
407     }
408 
409     /**
410      * @dev See {IERC20-transferFrom}.
411      *
412      * Emits an {Approval} event indicating the updated allowance. This is not
413      * required by the EIP. See the note at the beginning of {ERC20};
414      *
415      * Requirements:
416      * - `sender` and `recipient` cannot be the zero address.
417      * - `sender` must have a balance of at least `amount`.
418      * - the caller must have allowance for `sender`'s tokens of at least
419      * `amount`.
420      */
421     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
422         _transfer(sender, recipient, amount);
423         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
424         return true;
425     }
426 
427     /**
428      * @dev Atomically increases the allowance granted to `spender` by the caller.
429      *
430      * This is an alternative to {approve} that can be used as a mitigation for
431      * problems described in {IERC20-approve}.
432      *
433      * Emits an {Approval} event indicating the updated allowance.
434      *
435      * Requirements:
436      *
437      * - `spender` cannot be the zero address.
438      */
439     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
440         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
441         return true;
442     }
443 
444     /**
445      * @dev Atomically decreases the allowance granted to `spender` by the caller.
446      *
447      * This is an alternative to {approve} that can be used as a mitigation for
448      * problems described in {IERC20-approve}.
449      *
450      * Emits an {Approval} event indicating the updated allowance.
451      *
452      * Requirements:
453      *
454      * - `spender` cannot be the zero address.
455      * - `spender` must have allowance for the caller of at least
456      * `subtractedValue`.
457      */
458     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
459         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
460         return true;
461     }
462     
463 	
464 	/**
465      * @dev Destroys `amount` tokens from the caller.
466      *
467      * See {ERC20-_burn}.
468      */
469     function burn(uint256 amount) public returns (bool) {
470         _burn(_msgSender(), amount);
471 		return true;
472     }
473 
474     /**
475      * @dev See {ERC20-_burnFrom}.
476      */
477     function burnFrom(address account, uint256 amount) public returns (bool) {
478         _burnFrom(account, amount);
479 		return true;
480     }
481 
482     /**
483      * @dev Moves tokens `amount` from `sender` to `recipient`.
484      *
485      * This is internal function is equivalent to {transfer}, and can be used to
486      * e.g. implement automatic token fees, slashing mechanisms, etc.
487      *
488      * Emits a {Transfer} event.
489      *
490      * Requirements:
491      *
492      * - `sender` cannot be the zero address.
493      * - `recipient` cannot be the zero address.
494      * - `sender` must have a balance of at least `amount`.
495      */
496     function _transfer(address sender, address recipient, uint256 amount) internal whenNotPaused {
497         require(sender != address(0), "ERC20: transfer from the zero address");
498         require(recipient != address(0), "ERC20: transfer to the zero address");
499 
500         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
501         _balances[recipient] = _balances[recipient].add(amount);
502         emit Transfer(sender, recipient, amount);
503     }
504     
505     /**
506      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
507      *
508      * This is internal function is equivalent to `approve`, and can be used to
509      * e.g. set automatic allowances for certain subsystems, etc.
510      *
511      * Emits an {Approval} event.
512      *
513      * Requirements:
514      *
515      * - `owner` cannot be the zero address.
516      * - `spender` cannot be the zero address.
517      */
518     function _approve(address owner, address spender, uint256 amount) internal whenNotPaused {
519         require(owner != address(0), "ERC20: approve from the zero address");
520         require(spender != address(0), "ERC20: approve to the zero address");
521 
522         _allowances[owner][spender] = amount;
523         emit Approval(owner, spender, amount);
524     }
525 
526     /**
527      * @dev Destroys `amount` tokens from `account`, reducing the
528      * total supply.
529      *
530      * Emits a {Transfer} event with `to` set to the zero address.
531      *
532      * Requirements
533      *
534      * - `account` cannot be the zero address.
535      * - `account` must have at least `amount` tokens.
536      */
537     function _burn(address account, uint256 amount) internal whenNotPaused {
538         require(account != address(0), "ERC20: burn from the zero address");
539 
540         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
541         _totalSupply = _totalSupply.sub(amount);
542         emit Transfer(account, address(0), amount);
543     }
544 
545     /**
546      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
547      * from the caller's allowance.
548      *
549      * See {_burn} and {_approve}.
550      */
551     function _burnFrom(address account, uint256 amount) internal whenNotPaused {
552         _burn(account, amount);
553         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
554     }
555 }