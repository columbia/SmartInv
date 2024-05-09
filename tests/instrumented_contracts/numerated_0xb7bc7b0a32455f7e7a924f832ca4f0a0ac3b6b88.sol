1 pragma solidity ^0.5.0;
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
55      * _Available since v2.4.0._
56      */
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the multiplication of two unsigned integers, reverting on
66      * overflow.
67      *
68      * Counterpart to Solidity's `*` operator.
69      *
70      * Requirements:
71      * - Multiplication cannot overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the integer division of two unsigned integers. Reverts on
89      * division by zero. The result is rounded towards zero.
90      *
91      * Counterpart to Solidity's `/` operator. Note: this function uses a
92      * `revert` opcode (which leaves remaining gas untouched) while Solidity
93      * uses an invalid opcode to revert (consuming all remaining gas).
94      *
95      * Requirements:
96      * - The divisor cannot be zero.
97      */
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return div(a, b, "SafeMath: division by zero");
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      *
113      * _Available since v2.4.0._
114      */
115     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         // Solidity only automatically asserts when dividing by 0
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
126      * Reverts when dividing by zero.
127      *
128      * Counterpart to Solidity's `%` operator. This function uses a `revert`
129      * opcode (which leaves remaining gas untouched) while Solidity uses an
130      * invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      * - The divisor cannot be zero.
134      */
135     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136         return mod(a, b, "SafeMath: modulo by zero");
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141      * Reverts with custom message when dividing by zero.
142      *
143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
144      * opcode (which leaves remaining gas untouched) while Solidity uses an
145      * invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      * - The divisor cannot be zero.
149      *
150      * _Available since v2.4.0._
151      */
152     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
153         require(b != 0, errorMessage);
154         return a % b;
155     }
156 }
157 
158 /**
159  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
160  * the optional functions; to access them see {ERC20Detailed}.
161  */
162 interface IERC20 {
163     /**
164      * @dev Returns the amount of tokens in existence.
165      */
166     function totalSupply() external view returns (uint256);
167 
168     /**
169      * @dev Returns the amount of tokens owned by `account`.
170      */
171     function balanceOf(address account) external view returns (uint256);
172 
173     /**
174      * @dev Moves `amount` tokens from the caller's account to `recipient`.
175      *
176      * Returns a boolean value indicating whether the operation succeeded.
177      *
178      * Emits a {Transfer} event.
179      */
180     function transfer(address recipient, uint256 amount) external returns (bool);
181 
182     /**
183      * @dev Returns the remaining number of tokens that `spender` will be
184      * allowed to spend on behalf of `owner` through {transferFrom}. This is
185      * zero by default.
186      *
187      * This value changes when {approve} or {transferFrom} are called.
188      */
189     function allowance(address owner, address spender) external view returns (uint256);
190 
191     /**
192      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
193      *
194      * Returns a boolean value indicating whether the operation succeeded.
195      *
196      * IMPORTANT: Beware that changing an allowance with this method brings the risk
197      * that someone may use both the old and the new allowance by unfortunate
198      * transaction ordering. One possible solution to mitigate this race
199      * condition is to first reduce the spender's allowance to 0 and set the
200      * desired value afterwards:
201      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
202      *
203      * Emits an {Approval} event.
204      */
205     function approve(address spender, uint256 amount) external returns (bool);
206 
207     /**
208      * @dev Moves `amount` tokens from `sender` to `recipient` using the
209      * allowance mechanism. `amount` is then deducted from the caller's
210      * allowance.
211      *
212      * Returns a boolean value indicating whether the operation succeeded.
213      *
214      * Emits a {Transfer} event.
215      */
216     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
217 
218     /**
219      * @dev Emitted when `value` tokens are moved from one account (`from`) to
220      * another (`to`).
221      *
222      * Note that `value` may be zero.
223      */
224     event Transfer(address indexed from, address indexed to, uint256 value);
225 
226     /**
227      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
228      * a call to {approve}. `value` is the new allowance.
229      */
230     event Approval(address indexed owner, address indexed spender, uint256 value);
231 }
232 
233 contract ERC20 is IERC20 {
234     using SafeMath for uint256;
235 
236     mapping (address => uint256) private _balances;
237 
238     mapping (address => mapping (address => uint256)) private _allowances;
239 
240     uint256 private _totalSupply;
241 
242     string private _name;
243     string private _symbol;
244     uint8 private _decimals;
245 
246     constructor (string memory name, string memory symbol) public {
247         _name = name;
248         _symbol = symbol;
249         _decimals = 18;
250     }
251 
252     /**
253      * @dev Returns the name of the token.
254      */
255     function name() public view returns (string memory) {
256         return _name;
257     }
258 
259     /**
260      * @dev Returns the symbol of the token, usually a shorter version of the
261      * name.
262      */
263     function symbol() public view returns (string memory) {
264         return _symbol;
265     }
266 
267     /**
268      * @dev Returns the number of decimals used to get its user representation.
269      * For example, if `decimals` equals `2`, a balance of `505` tokens should
270      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
271      *
272      * Tokens usually opt for a value of 18, imitating the relationship between
273      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
274      * called.
275      *
276      * NOTE: This information is only used for _display_ purposes: it in
277      * no way affects any of the arithmetic of the contract, including
278      * {IERC20-balanceOf} and {IERC20-transfer}.
279      */
280 
281     function decimals() public view returns (uint8) {
282         return _decimals;
283     }
284     
285     /**
286      * @dev See {IERC20-totalSupply}.
287      */
288     function totalSupply() public view returns (uint256) {
289         return _totalSupply;
290     }
291 
292     /**
293      * @dev See {IERC20-balanceOf}.
294      */
295     function balanceOf(address account) public view returns (uint256) {
296         return _balances[account];
297     }
298 
299     /**
300      * @dev See {IERC20-transfer}.
301      *
302      * Requirements:
303      *
304      * - `recipient` cannot be the zero address.
305      * - the caller must have a balance of at least `amount`.
306      */
307     function transfer(address recipient, uint256 amount) public returns (bool) {
308         _transfer(msg.sender, recipient, amount);
309         return true;
310     }
311 
312     /**
313      * @dev See {IERC20-allowance}.
314      */
315     function allowance(address owner, address spender) public view returns (uint256) {
316         return _allowances[owner][spender];
317     }
318 
319     /**
320      * @dev See {IERC20-approve}.
321      *
322      * Requirements:
323      *
324      * - `spender` cannot be the zero address.
325      */
326     function approve(address spender, uint256 amount) public returns (bool) {
327         _approve(msg.sender, spender, amount);
328         return true;
329     }
330 
331     /**
332      * @dev See {IERC20-transferFrom}.
333      *
334      * Emits an {Approval} event indicating the updated allowance. This is not
335      * required by the EIP. See the note at the beginning of {ERC20};
336      *
337      * Requirements:
338      * - `sender` and `recipient` cannot be the zero address.
339      * - `sender` must have a balance of at least `amount`.
340      * - the caller must have allowance for `sender`'s tokens of at least
341      * `amount`.
342      */
343     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
344         _transfer(sender, recipient, amount);
345         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
346         return true;
347     }
348 
349     /**
350      * @dev Atomically increases the allowance granted to `spender` by the caller.
351      *
352      * This is an alternative to {approve} that can be used as a mitigation for
353      * problems described in {IERC20-approve}.
354      *
355      * Emits an {Approval} event indicating the updated allowance.
356      *
357      * Requirements:
358      *
359      * - `spender` cannot be the zero address.
360      */
361     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
362         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
363         return true;
364     }
365 
366     /**
367      * @dev Atomically decreases the allowance granted to `spender` by the caller.
368      *
369      * This is an alternative to {approve} that can be used as a mitigation for
370      * problems described in {IERC20-approve}.
371      *
372      * Emits an {Approval} event indicating the updated allowance.
373      *
374      * Requirements:
375      *
376      * - `spender` cannot be the zero address.
377      * - `spender` must have allowance for the caller of at least
378      * `subtractedValue`.
379      */
380     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
381         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
382         return true;
383     }
384 
385     /**
386      * @dev Moves tokens `amount` from `sender` to `recipient`.
387      *
388      * This is internal function is equivalent to {transfer}, and can be used to
389      * e.g. implement automatic token fees, slashing mechanisms, etc.
390      *
391      * Emits a {Transfer} event.
392      *
393      * Requirements:
394      *
395      * - `sender` cannot be the zero address.
396      * - `recipient` cannot be the zero address.
397      * - `sender` must have a balance of at least `amount`.
398      */
399     function _transfer(address sender, address recipient, uint256 amount) internal {
400         require(sender != address(0), "ERC20: transfer from the zero address");
401         require(recipient != address(0), "ERC20: transfer to the zero address");
402 
403         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
404         _balances[recipient] = _balances[recipient].add(amount);
405         emit Transfer(sender, recipient, amount);
406     }
407 
408     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
409      * the total supply.
410      *
411      * Emits a {Transfer} event with `from` set to the zero address.
412      *
413      * Requirements
414      *
415      * - `to` cannot be the zero address.
416      */
417     function _mint(address account, uint256 amount) internal {
418         require(account != address(0), "ERC20: mint to the zero address");
419 
420         _totalSupply = _totalSupply.add(amount);
421         _balances[account] = _balances[account].add(amount);
422         emit Transfer(address(0), account, amount);
423     }
424 
425     /**
426      * @dev Destroys `amount` tokens from `account`, reducing the
427      * total supply.
428      *
429      * Emits a {Transfer} event with `to` set to the zero address.
430      *
431      * Requirements
432      *
433      * - `account` cannot be the zero address.
434      * - `account` must have at least `amount` tokens.
435      */
436     function _burn(address account, uint256 amount) internal {
437         require(account != address(0), "ERC20: burn from the zero address");
438 
439         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
440         _totalSupply = _totalSupply.sub(amount);
441         emit Transfer(account, address(0), amount);
442     }
443 
444     /**
445      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
446      *
447      * This is internal function is equivalent to `approve`, and can be used to
448      * e.g. set automatic allowances for certain subsystems, etc.
449      *
450      * Emits an {Approval} event.
451      *
452      * Requirements:
453      *
454      * - `owner` cannot be the zero address.
455      * - `spender` cannot be the zero address.
456      */
457     function _approve(address owner, address spender, uint256 amount) internal {
458         require(owner != address(0), "ERC20: approve from the zero address");
459         require(spender != address(0), "ERC20: approve to the zero address");
460 
461         _allowances[owner][spender] = amount;
462         emit Approval(owner, spender, amount);
463     }
464 
465     /**
466      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
467      * from the caller's allowance.
468      *
469      * See {_burn} and {_approve}.
470      */
471     function _burnFrom(address account, uint256 amount) internal {
472         _burn(account, amount);
473         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount, "ERC20: burn amount exceeds allowance"));
474     }
475 }
476 
477 contract MultiOwnable {
478   address[] private _owner;
479 
480   event OwnershipTransferred(address indexed previousOwner,address indexed newOwner);
481 
482   constructor() internal {
483     _owner.push(msg.sender);
484     emit OwnershipTransferred(address(0), _owner[0]);
485   }
486 
487   function checkOwner() private view returns (bool) {
488     for (uint8 i = 0; i < _owner.length; i++) {
489       if (_owner[i] == msg.sender) {
490         return true;
491       }
492     }
493     return false;
494   }
495 
496   function checkNewOwner(address _address) private view returns (bool) {
497     for (uint8 i = 0; i < _owner.length; i++) {
498       if (_owner[i] == _address) {
499         return false;
500       }
501     }
502     return true;
503   }
504 
505   modifier isAnOwner() {
506     require(checkOwner(), "Ownable: caller is not the owner");
507     _;
508   }
509 
510   function renounceOwnership() public isAnOwner {
511     for (uint8 i = 0; i < _owner.length; i++) {
512       if (_owner[i] == msg.sender) {
513         _owner[i] = address(0);
514         emit OwnershipTransferred(_owner[i], msg.sender);
515       }
516     }
517   }
518 
519   function getOwners() public view returns (address[] memory) {
520     return _owner;
521   }
522 
523   function addOwnerShip(address newOwner) public isAnOwner {
524     _addOwnerShip(newOwner);
525   }
526 
527   function _addOwnerShip(address newOwner) internal {
528     require(newOwner != address(0), "Ownable: new owner is the zero address");
529     require(checkNewOwner(newOwner), "Owner already exists");
530     _owner.push(newOwner);
531     emit OwnershipTransferred(_owner[_owner.length - 1], newOwner);
532   }
533 }
534 
535 contract WarLordToken is MultiOwnable, ERC20{
536     constructor (string memory name, string memory symbol) public ERC20(name, symbol) MultiOwnable(){
537     
538 	}
539 	
540 	function warlordMint(address account, uint256 amount) external isAnOwner{
541         _mint(account, amount);
542     }
543 
544     function warlordBurn(address account, uint256 amount) external isAnOwner{
545         _burn(account, amount);
546     }
547 	
548 	function addOwner(address _newOwner) external isAnOwner {
549         addOwnerShip(_newOwner);
550     }
551 
552     function getOwner() external view isAnOwner{
553         getOwners();
554     }
555 
556     function renounceOwner() external isAnOwner {
557         renounceOwnership();
558     }
559 	
560     
561 	
562     
563 }