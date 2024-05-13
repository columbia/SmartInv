1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/GSN/Context.sol
4 
5 pragma solidity ^0.5.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 contract Context {
18     // Empty internal constructor, to prevent people from mistakenly deploying
19     // an instance of this contract, which should be used via inheritance.
20     constructor () internal { }
21     // solhint-disable-previous-line no-empty-blocks
22 
23     function _msgSender() internal view returns (address payable) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
34 
35 pragma solidity ^0.5.0;
36 
37 /**
38  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
39  * the optional functions; to access them see {ERC20Detailed}.
40  */
41 interface IERC20 {
42     /**
43      * @dev Returns the amount of tokens in existence.
44      */
45     function totalSupply() external view returns (uint256);
46 
47     /**
48      * @dev Returns the amount of tokens owned by `account`.
49      */
50     function balanceOf(address account) external view returns (uint256);
51 
52     /**
53      * @dev Moves `amount` tokens from the caller's account to `recipient`.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transfer(address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Returns the remaining number of tokens that `spender` will be
63      * allowed to spend on behalf of `owner` through {transferFrom}. This is
64      * zero by default.
65      *
66      * This value changes when {approve} or {transferFrom} are called.
67      */
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     /**
71      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * IMPORTANT: Beware that changing an allowance with this method brings the risk
76      * that someone may use both the old and the new allowance by unfortunate
77      * transaction ordering. One possible solution to mitigate this race
78      * condition is to first reduce the spender's allowance to 0 and set the
79      * desired value afterwards:
80      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
81      *
82      * Emits an {Approval} event.
83      */
84     function approve(address spender, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Moves `amount` tokens from `sender` to `recipient` using the
88      * allowance mechanism. `amount` is then deducted from the caller's
89      * allowance.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Emitted when `value` tokens are moved from one account (`from`) to
99      * another (`to`).
100      *
101      * Note that `value` may be zero.
102      */
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     /**
106      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
107      * a call to {approve}. `value` is the new allowance.
108      */
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 // File: @openzeppelin/contracts/math/SafeMath.sol
113 
114 pragma solidity ^0.5.0;
115 
116 /**
117  * @dev Wrappers over Solidity's arithmetic operations with added overflow
118  * checks.
119  *
120  * Arithmetic operations in Solidity wrap on overflow. This can easily result
121  * in bugs, because programmers usually assume that an overflow raises an
122  * error, which is the standard behavior in high level programming languages.
123  * `SafeMath` restores this intuition by reverting the transaction when an
124  * operation overflows.
125  *
126  * Using this library instead of the unchecked operations eliminates an entire
127  * class of bugs, so it's recommended to use it always.
128  */
129 library SafeMath {
130     /**
131      * @dev Returns the addition of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `+` operator.
135      *
136      * Requirements:
137      * - Addition cannot overflow.
138      */
139     function add(uint256 a, uint256 b) internal pure returns (uint256) {
140         uint256 c = a + b;
141         require(c >= a, "SafeMath: addition overflow");
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156         return sub(a, b, "SafeMath: subtraction overflow");
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      * - Subtraction cannot overflow.
167      *
168      * _Available since v2.4.0._
169      */
170     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b <= a, errorMessage);
172         uint256 c = a - b;
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the multiplication of two unsigned integers, reverting on
179      * overflow.
180      *
181      * Counterpart to Solidity's `*` operator.
182      *
183      * Requirements:
184      * - Multiplication cannot overflow.
185      */
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188         // benefit is lost if 'b' is also tested.
189         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
190         if (a == 0) {
191             return 0;
192         }
193 
194         uint256 c = a * b;
195         require(c / a == b, "SafeMath: multiplication overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      * - The divisor cannot be zero.
210      */
211     function div(uint256 a, uint256 b) internal pure returns (uint256) {
212         return div(a, b, "SafeMath: division by zero");
213     }
214 
215     /**
216      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
217      * division by zero. The result is rounded towards zero.
218      *
219      * Counterpart to Solidity's `/` operator. Note: this function uses a
220      * `revert` opcode (which leaves remaining gas untouched) while Solidity
221      * uses an invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      * - The divisor cannot be zero.
225      *
226      * _Available since v2.4.0._
227      */
228     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         // Solidity only automatically asserts when dividing by 0
230         require(b > 0, errorMessage);
231         uint256 c = a / b;
232         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249         return mod(a, b, "SafeMath: modulo by zero");
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts with custom message when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      * - The divisor cannot be zero.
262      *
263      * _Available since v2.4.0._
264      */
265     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b != 0, errorMessage);
267         return a % b;
268     }
269 }
270 
271 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
272 
273 pragma solidity ^0.5.0;
274 
275 
276 
277 
278 /**
279  * @dev Implementation of the {IERC20} interface.
280  *
281  * This implementation is agnostic to the way tokens are created. This means
282  * that a supply mechanism has to be added in a derived contract using {_mint}.
283  * For a generic mechanism see {ERC20Mintable}.
284  *
285  * TIP: For a detailed writeup see our guide
286  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
287  * to implement supply mechanisms].
288  *
289  * We have followed general OpenZeppelin guidelines: functions revert instead
290  * of returning `false` on failure. This behavior is nonetheless conventional
291  * and does not conflict with the expectations of ERC20 applications.
292  *
293  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
294  * This allows applications to reconstruct the allowance for all accounts just
295  * by listening to said events. Other implementations of the EIP may not emit
296  * these events, as it isn't required by the specification.
297  *
298  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
299  * functions have been added to mitigate the well-known issues around setting
300  * allowances. See {IERC20-approve}.
301  */
302 contract ERC20 is Context, IERC20 {
303     using SafeMath for uint256;
304 
305     mapping (address => uint256) private _balances;
306 
307     mapping (address => mapping (address => uint256)) private _allowances;
308 
309     uint256 private _totalSupply;
310 
311     /**
312      * @dev See {IERC20-totalSupply}.
313      */
314     function totalSupply() public view returns (uint256) {
315         return _totalSupply;
316     }
317 
318     /**
319      * @dev See {IERC20-balanceOf}.
320      */
321     function balanceOf(address account) public view returns (uint256) {
322         return _balances[account];
323     }
324 
325     /**
326      * @dev See {IERC20-transfer}.
327      *
328      * Requirements:
329      *
330      * - `recipient` cannot be the zero address.
331      * - the caller must have a balance of at least `amount`.
332      */
333     function transfer(address recipient, uint256 amount) public returns (bool) {
334         _transfer(_msgSender(), recipient, amount);
335         return true;
336     }
337 
338     /**
339      * @dev See {IERC20-allowance}.
340      */
341     function allowance(address owner, address spender) public view returns (uint256) {
342         return _allowances[owner][spender];
343     }
344 
345     /**
346      * @dev See {IERC20-approve}.
347      *
348      * Requirements:
349      *
350      * - `spender` cannot be the zero address.
351      */
352     function approve(address spender, uint256 amount) public returns (bool) {
353         _approve(_msgSender(), spender, amount);
354         return true;
355     }
356 
357     /**
358      * @dev See {IERC20-transferFrom}.
359      *
360      * Emits an {Approval} event indicating the updated allowance. This is not
361      * required by the EIP. See the note at the beginning of {ERC20};
362      *
363      * Requirements:
364      * - `sender` and `recipient` cannot be the zero address.
365      * - `sender` must have a balance of at least `amount`.
366      * - the caller must have allowance for `sender`'s tokens of at least
367      * `amount`.
368      */
369     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
370         _transfer(sender, recipient, amount);
371         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
372         return true;
373     }
374 
375     /**
376      * @dev Atomically increases the allowance granted to `spender` by the caller.
377      *
378      * This is an alternative to {approve} that can be used as a mitigation for
379      * problems described in {IERC20-approve}.
380      *
381      * Emits an {Approval} event indicating the updated allowance.
382      *
383      * Requirements:
384      *
385      * - `spender` cannot be the zero address.
386      */
387     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
388         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
389         return true;
390     }
391 
392     /**
393      * @dev Atomically decreases the allowance granted to `spender` by the caller.
394      *
395      * This is an alternative to {approve} that can be used as a mitigation for
396      * problems described in {IERC20-approve}.
397      *
398      * Emits an {Approval} event indicating the updated allowance.
399      *
400      * Requirements:
401      *
402      * - `spender` cannot be the zero address.
403      * - `spender` must have allowance for the caller of at least
404      * `subtractedValue`.
405      */
406     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
407         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
408         return true;
409     }
410 
411     /**
412      * @dev Moves tokens `amount` from `sender` to `recipient`.
413      *
414      * This is internal function is equivalent to {transfer}, and can be used to
415      * e.g. implement automatic token fees, slashing mechanisms, etc.
416      *
417      * Emits a {Transfer} event.
418      *
419      * Requirements:
420      *
421      * - `sender` cannot be the zero address.
422      * - `recipient` cannot be the zero address.
423      * - `sender` must have a balance of at least `amount`.
424      */
425     function _transfer(address sender, address recipient, uint256 amount) internal {
426         require(sender != address(0), "ERC20: transfer from the zero address");
427         require(recipient != address(0), "ERC20: transfer to the zero address");
428 
429         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
430         _balances[recipient] = _balances[recipient].add(amount);
431         emit Transfer(sender, recipient, amount);
432     }
433 
434     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
435      * the total supply.
436      *
437      * Emits a {Transfer} event with `from` set to the zero address.
438      *
439      * Requirements
440      *
441      * - `to` cannot be the zero address.
442      */
443     function _mint(address account, uint256 amount) internal {
444         require(account != address(0), "ERC20: mint to the zero address");
445 
446         _totalSupply = _totalSupply.add(amount);
447         _balances[account] = _balances[account].add(amount);
448         emit Transfer(address(0), account, amount);
449     }
450 
451     /**
452      * @dev Destroys `amount` tokens from `account`, reducing the
453      * total supply.
454      *
455      * Emits a {Transfer} event with `to` set to the zero address.
456      *
457      * Requirements
458      *
459      * - `account` cannot be the zero address.
460      * - `account` must have at least `amount` tokens.
461      */
462     function _burn(address account, uint256 amount) internal {
463         require(account != address(0), "ERC20: burn from the zero address");
464 
465         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
466         _totalSupply = _totalSupply.sub(amount);
467         emit Transfer(account, address(0), amount);
468     }
469 
470     /**
471      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
472      *
473      * This is internal function is equivalent to `approve`, and can be used to
474      * e.g. set automatic allowances for certain subsystems, etc.
475      *
476      * Emits an {Approval} event.
477      *
478      * Requirements:
479      *
480      * - `owner` cannot be the zero address.
481      * - `spender` cannot be the zero address.
482      */
483     function _approve(address owner, address spender, uint256 amount) internal {
484         require(owner != address(0), "ERC20: approve from the zero address");
485         require(spender != address(0), "ERC20: approve to the zero address");
486 
487         _allowances[owner][spender] = amount;
488         emit Approval(owner, spender, amount);
489     }
490 
491     /**
492      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
493      * from the caller's allowance.
494      *
495      * See {_burn} and {_approve}.
496      */
497     function _burnFrom(address account, uint256 amount) internal {
498         _burn(account, amount);
499         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
500     }
501 }
502 
503 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
504 
505 pragma solidity ^0.5.0;
506 
507 
508 /**
509  * @dev Optional functions from the ERC20 standard.
510  */
511 contract ERC20Detailed is IERC20 {
512     string private _name;
513     string private _symbol;
514     uint8 private _decimals;
515 
516     /**
517      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
518      * these values are immutable: they can only be set once during
519      * construction.
520      */
521     constructor (string memory name, string memory symbol, uint8 decimals) public {
522         _name = name;
523         _symbol = symbol;
524         _decimals = decimals;
525     }
526 
527     /**
528      * @dev Returns the name of the token.
529      */
530     function name() public view returns (string memory) {
531         return _name;
532     }
533 
534     /**
535      * @dev Returns the symbol of the token, usually a shorter version of the
536      * name.
537      */
538     function symbol() public view returns (string memory) {
539         return _symbol;
540     }
541 
542     /**
543      * @dev Returns the number of decimals used to get its user representation.
544      * For example, if `decimals` equals `2`, a balance of `505` tokens should
545      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
546      *
547      * Tokens usually opt for a value of 18, imitating the relationship between
548      * Ether and Wei.
549      *
550      * NOTE: This information is only used for _display_ purposes: it in
551      * no way affects any of the arithmetic of the contract, including
552      * {IERC20-balanceOf} and {IERC20-transfer}.
553      */
554     function decimals() public view returns (uint8) {
555         return _decimals;
556     }
557 }
558 
559 // File: internal/Erc20SwapAsset.sol
560 
561 pragma solidity ^0.5.0;
562 
563 
564 
565 contract Erc20SwapAsset is ERC20, ERC20Detailed {
566     event LogChangeDCRMOwner(address indexed oldOwner, address indexed newOwner, uint indexed effectiveHeight);
567     event LogSwapin(bytes32 indexed txhash, address indexed account, uint amount);
568     event LogSwapout(address indexed account, address indexed bindaddr, uint amount);
569 
570     address private _oldOwner;
571     address private _newOwner;
572     uint256 private _newOwnerEffectiveHeight;
573 
574     modifier onlyOwner() {
575         require(msg.sender == owner(), "only owner");
576         _;
577     }
578 
579     constructor(string memory name, string memory symbol, uint8 decimals) public ERC20Detailed(name, symbol, decimals) {
580         _newOwner = msg.sender;
581         _newOwnerEffectiveHeight = block.number;
582     }
583 
584     function owner() public view returns (address) {
585         if (block.number >= _newOwnerEffectiveHeight) {
586             return _newOwner;
587         }
588         return _oldOwner;
589     }
590 
591     function changeDCRMOwner(address newOwner) public onlyOwner returns (bool) {
592         require(newOwner != address(0), "new owner is the zero address");
593         _oldOwner = owner();
594         _newOwner = newOwner;
595         _newOwnerEffectiveHeight = block.number + 13300;
596         emit LogChangeDCRMOwner(_oldOwner, _newOwner, _newOwnerEffectiveHeight);
597         return true;
598     }
599 
600     function Swapin(bytes32 txhash, address account, uint256 amount) public onlyOwner returns (bool) {
601         _mint(account, amount);
602         emit LogSwapin(txhash, account, amount);
603         return true;
604     }
605 
606     function Swapout(uint256 amount, address bindaddr) public returns (bool) {
607         require(bindaddr != address(0), "bind address is the zero address");
608         _burn(_msgSender(), amount);
609         emit LogSwapout(_msgSender(), bindaddr, amount);
610         return true;
611     }
612 }
