1 // File: contracts/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see `ERC20Detailed`.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a `Transfer` event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through `transferFrom`. This is
35      * zero by default.
36      *
37      * This value changes when `approve` or `transferFrom` are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * > Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an `Approval` event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a `Transfer` event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to `approve`. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 // File: contracts/contracts/math/SafeMath.sol
84 
85 pragma solidity ^0.5.0;
86 
87 /**
88  * @dev Wrappers over Solidity's arithmetic operations with added overflow
89  * checks.
90  *
91  * Arithmetic operations in Solidity wrap on overflow. This can easily result
92  * in bugs, because programmers usually assume that an overflow raises an
93  * error, which is the standard behavior in high level programming languages.
94  * `SafeMath` restores this intuition by reverting the transaction when an
95  * operation overflows.
96  *
97  * Using this library instead of the unchecked operations eliminates an entire
98  * class of bugs, so it's recommended to use it always.
99  */
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      * - Addition cannot overflow.
109      */
110     function add(uint256 a, uint256 b) internal pure returns (uint256) {
111         uint256 c = a + b;
112         require(c >= a, "SafeMath: addition overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      * - Subtraction cannot overflow.
125      */
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         require(b <= a, "SafeMath: subtraction overflow");
128         uint256 c = a - b;
129 
130         return c;
131     }
132 
133     /**
134      * @dev Returns the multiplication of two unsigned integers, reverting on
135      * overflow.
136      *
137      * Counterpart to Solidity's `*` operator.
138      *
139      * Requirements:
140      * - Multiplication cannot overflow.
141      */
142     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
143         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
144         // benefit is lost if 'b' is also tested.
145         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
146         if (a == 0) {
147             return 0;
148         }
149 
150         uint256 c = a * b;
151         require(c / a == b, "SafeMath: multiplication overflow");
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the integer division of two unsigned integers. Reverts on
158      * division by zero. The result is rounded towards zero.
159      *
160      * Counterpart to Solidity's `/` operator. Note: this function uses a
161      * `revert` opcode (which leaves remaining gas untouched) while Solidity
162      * uses an invalid opcode to revert (consuming all remaining gas).
163      *
164      * Requirements:
165      * - The divisor cannot be zero.
166      */
167     function div(uint256 a, uint256 b) internal pure returns (uint256) {
168         // Solidity only automatically asserts when dividing by 0
169         require(b > 0, "SafeMath: division by zero");
170         uint256 c = a / b;
171         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
178      * Reverts when dividing by zero.
179      *
180      * Counterpart to Solidity's `%` operator. This function uses a `revert`
181      * opcode (which leaves remaining gas untouched) while Solidity uses an
182      * invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      * - The divisor cannot be zero.
186      */
187     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
188         require(b != 0, "SafeMath: modulo by zero");
189         return a % b;
190     }
191 }
192 
193 // File: contracts/contracts/token/ERC20/ERC20.sol
194 
195 pragma solidity ^0.5.0;
196 
197 
198 /**
199  * @dev Implementation of the `IERC20` interface.
200  *
201  * This implementation is agnostic to the way tokens are created. This means
202  * that a supply mechanism has to be added in a derived contract using `_mint`.
203  * For a generic mechanism see `ERC20Mintable`.
204  *
205  * *For a detailed writeup see our guide [How to implement supply
206  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
207  *
208  * We have followed general OpenZeppelin guidelines: functions revert instead
209  * of returning `false` on failure. This behavior is nonetheless conventional
210  * and does not conflict with the expectations of ERC20 applications.
211  *
212  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
213  * This allows applications to reconstruct the allowance for all accounts just
214  * by listening to said events. Other implementations of the EIP may not emit
215  * these events, as it isn't required by the specification.
216  *
217  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
218  * functions have been added to mitigate the well-known issues around setting
219  * allowances. See `IERC20.approve`.
220  */
221 contract ERC20 is IERC20 {
222     using SafeMath for uint256;
223 
224     mapping (address => uint256) private _balances;
225 
226     mapping (address => mapping (address => uint256)) private _allowances;
227 
228     uint256 private _totalSupply;
229 
230     string private _name;
231     string private _symbol;
232     uint8 private _decimals;
233 
234     constructor (string memory name, string memory symbol) public {
235         _name = name;
236         _symbol = symbol;
237         _decimals = 9;
238     }
239 
240     /**
241      * @dev Returns the name of the token.
242      */
243     function name() public view returns (string memory) {
244         return _name;
245     }
246 
247     /**
248      * @dev Returns the symbol of the token, usually a shorter version of the
249      * name.
250      */
251     function symbol() public view returns (string memory) {
252         return _symbol;
253     }
254 
255     /**
256      * @dev Returns the number of decimals used to get its user representation.
257      * For example, if `decimals` equals `2`, a balance of `505` tokens should
258      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
259      *
260      * Tokens usually opt for a value of 18, imitating the relationship between
261      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
262      * called.
263      *
264      * NOTE: This information is only used for _display_ purposes: it in
265      * no way affects any of the arithmetic of the contract, including
266      * {IERC20-balanceOf} and {IERC20-transfer}.
267      */
268 
269     function decimals() public view returns (uint8) {
270         return _decimals;
271     }
272     
273     /**
274      * @dev See `IERC20.totalSupply`.
275      */
276     function totalSupply() public view returns (uint256) {
277         return _totalSupply;
278     }
279 
280     /**
281      * @dev See `IERC20.balanceOf`.
282      */
283     function balanceOf(address account) public view returns (uint256) {
284         return _balances[account];
285     }
286 
287     /**
288      * @dev See `IERC20.transfer`.
289      *
290      * Requirements:
291      *
292      * - `recipient` cannot be the zero address.
293      * - the caller must have a balance of at least `amount`.
294      */
295     function transfer(address recipient, uint256 amount) public returns (bool) {
296         _transfer(msg.sender, recipient, amount);
297         return true;
298     }
299 
300     /**
301      * @dev See `IERC20.allowance`.
302      */
303     function allowance(address owner, address spender) public view returns (uint256) {
304         return _allowances[owner][spender];
305     }
306 
307     /**
308      * @dev See `IERC20.approve`.
309      *
310      * Requirements:
311      *
312      * - `spender` cannot be the zero address.
313      */
314     function approve(address spender, uint256 value) public returns (bool) {
315         _approve(msg.sender, spender, value);
316         return true;
317     }
318 
319     /**
320      * @dev See `IERC20.transferFrom`.
321      *
322      * Emits an `Approval` event indicating the updated allowance. This is not
323      * required by the EIP. See the note at the beginning of `ERC20`;
324      *
325      * Requirements:
326      * - `sender` and `recipient` cannot be the zero address.
327      * - `sender` must have a balance of at least `value`.
328      * - the caller must have allowance for `sender`'s tokens of at least
329      * `amount`.
330      */
331     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
332         _transfer(sender, recipient, amount);
333         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
334         return true;
335     }
336 
337     /**
338      * @dev Atomically increases the allowance granted to `spender` by the caller.
339      *
340      * This is an alternative to `approve` that can be used as a mitigation for
341      * problems described in `IERC20.approve`.
342      *
343      * Emits an `Approval` event indicating the updated allowance.
344      *
345      * Requirements:
346      *
347      * - `spender` cannot be the zero address.
348      */
349     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
350         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
351         return true;
352     }
353 
354     /**
355      * @dev Atomically decreases the allowance granted to `spender` by the caller.
356      *
357      * This is an alternative to `approve` that can be used as a mitigation for
358      * problems described in `IERC20.approve`.
359      *
360      * Emits an `Approval` event indicating the updated allowance.
361      *
362      * Requirements:
363      *
364      * - `spender` cannot be the zero address.
365      * - `spender` must have allowance for the caller of at least
366      * `subtractedValue`.
367      */
368     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
369         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
370         return true;
371     }
372 
373     /**
374      * @dev Moves tokens `amount` from `sender` to `recipient`.
375      *
376      * This is internal function is equivalent to `transfer`, and can be used to
377      * e.g. implement automatic token fees, slashing mechanisms, etc.
378      *
379      * Emits a `Transfer` event.
380      *
381      * Requirements:
382      *
383      * - `sender` cannot be the zero address.
384      * - `recipient` cannot be the zero address.
385      * - `sender` must have a balance of at least `amount`.
386      */
387     function _transfer(address sender, address recipient, uint256 amount) internal {
388         require(sender != address(0), "ERC20: transfer from the zero address");
389         require(recipient != address(0), "ERC20: transfer to the zero address");
390 
391         _balances[sender] = _balances[sender].sub(amount);
392         _balances[recipient] = _balances[recipient].add(amount);
393         emit Transfer(sender, recipient, amount);
394     }
395 
396     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
397      * the total supply.
398      *
399      * Emits a `Transfer` event with `from` set to the zero address.
400      *
401      * Requirements
402      *
403      * - `to` cannot be the zero address.
404      */
405     function _mint(address account, uint256 amount) internal {
406         require(account != address(0), "ERC20: mint to the zero address");
407 
408         _totalSupply = _totalSupply.add(amount);
409         _balances[account] = _balances[account].add(amount);
410         emit Transfer(address(0), account, amount);
411     }
412 
413      /**
414      * @dev Destoys `amount` tokens from `account`, reducing the
415      * total supply.
416      *
417      * Emits a `Transfer` event with `to` set to the zero address.
418      *
419      * Requirements
420      *
421      * - `account` cannot be the zero address.
422      * - `account` must have at least `amount` tokens.
423      */
424     function _burn(address account, uint256 value) internal {
425         require(account != address(0), "ERC20: burn from the zero address");
426 
427         _totalSupply = _totalSupply.sub(value);
428         _balances[account] = _balances[account].sub(value);
429         emit Transfer(account, address(0), value);
430     }
431 
432     /**
433      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
434      *
435      * This is internal function is equivalent to `approve`, and can be used to
436      * e.g. set automatic allowances for certain subsystems, etc.
437      *
438      * Emits an `Approval` event.
439      *
440      * Requirements:
441      *
442      * - `owner` cannot be the zero address.
443      * - `spender` cannot be the zero address.
444      */
445     function _approve(address owner, address spender, uint256 value) internal {
446         require(owner != address(0), "ERC20: approve from the zero address");
447         require(spender != address(0), "ERC20: approve to the zero address");
448 
449         _allowances[owner][spender] = value;
450         emit Approval(owner, spender, value);
451     }
452 
453 
454     /**
455      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
456      * from the caller's allowance.
457      *
458      * See `_burn` and `_approve`.
459      */
460     function _burnFrom(address account, uint256 amount) internal {
461         _burn(account, amount);
462         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
463     }
464 }
465 
466 // File: contracts/contracts/ownership/MultOwnable.sol
467 
468 pragma solidity ^0.5.0;
469 
470 
471 contract MultOwnable {
472   address[] private _owner;
473 
474   event OwnershipTransferred(
475     address indexed previousOwner,
476     address indexed newOwner
477   );
478 
479   constructor() internal {
480     _owner.push(msg.sender);
481     emit OwnershipTransferred(address(0), _owner[0]);
482   }
483 
484   function checkOwner() private view returns (bool) {
485     for (uint8 i = 0; i < _owner.length; i++) {
486       if (_owner[i] == msg.sender) {
487         return true;
488       }
489     }
490     return false;
491   }
492 
493   function checkNewOwner(address _address) private view returns (bool) {
494     for (uint8 i = 0; i < _owner.length; i++) {
495       if (_owner[i] == _address) {
496         return false;
497       }
498     }
499     return true;
500   }
501 
502   modifier isAnOwner() {
503     require(checkOwner(), "Ownable: caller is not the owner");
504     _;
505   }
506 
507   function renounceOwnership() public isAnOwner {
508     for (uint8 i = 0; i < _owner.length; i++) {
509       if (_owner[i] == msg.sender) {
510         _owner[i] = address(0);
511         emit OwnershipTransferred(_owner[i], msg.sender);
512       }
513     }
514   }
515 
516   function getOwners() public view returns (address[] memory) {
517     return _owner;
518   }
519 
520   function addOwnerShip(address newOwner) public isAnOwner {
521     _addOwnerShip(newOwner);
522   }
523 
524   function _addOwnerShip(address newOwner) internal {
525     require(newOwner != address(0), "Ownable: new owner is the zero address");
526     require(checkNewOwner(newOwner), "Owner already exists");
527     _owner.push(newOwner);
528     emit OwnershipTransferred(_owner[_owner.length - 1], newOwner);
529   }
530 }
531 
532 // File: contracts/TulipToken.sol
533 
534 pragma solidity ^0.5.16;
535 
536 
537 
538 contract TulipToken is MultOwnable, ERC20{
539     constructor (string memory name, string memory symbol) public ERC20(name, symbol) MultOwnable(){
540     }
541 
542     function contractMint(address account, uint256 amount) external isAnOwner{
543         _mint(account, amount);
544     }
545 
546     function contractBurn(address account, uint256 amount) external isAnOwner{
547         _burn(account, amount);
548     }
549 
550 
551      /* ========== RESTRICTED FUNCTIONS ========== */
552     function addOwner(address _newOwner) external isAnOwner {
553         addOwnerShip(_newOwner);
554     }
555 
556     function getOwner() external view isAnOwner{
557         getOwners();
558     }
559 
560     function renounceOwner() external isAnOwner {
561         renounceOwnership();
562     }
563 }