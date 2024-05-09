1 pragma solidity ^0.6.0;
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
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address payable) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes memory) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 contract Ownable {
26     address payable public owner;
27 
28     event OwnershipTransferred(address indexed _from, address indexed _to);
29 
30     constructor() public {
31         owner = msg.sender;
32     }
33 
34     modifier onlyOwner {
35         require(msg.sender == owner);
36         _;
37     }
38 
39     function transferOwnership(address payable _newOwner) public onlyOwner {
40         owner = _newOwner;
41         emit OwnershipTransferred(msg.sender, _newOwner);
42     }
43 }
44 
45 /**
46  * @dev Wrappers over Solidity's arithmetic operations with added overflow
47  * checks.
48  *
49  * Arithmetic operations in Solidity wrap on overflow. This can easily result
50  * in bugs, because programmers usually assume that an overflow raises an
51  * error, which is the standard behavior in high level programming languages.
52  * `SafeMath` restores this intuition by reverting the transaction when an
53  * operation overflows.
54  *
55  * Using this library instead of the unchecked operations eliminates an entire
56  * class of bugs, so it's recommended to use it always.
57  */
58 library SafeMath {
59     /**
60      * @dev Returns the addition of two unsigned integers, reverting on
61      * overflow.
62      *
63      * Counterpart to Solidity's `+` operator.
64      *
65      * Requirements:
66      *
67      * - Addition cannot overflow.
68      */
69     function add(uint256 a, uint256 b) internal pure returns (uint256) {
70         uint256 c = a + b;
71         require(c >= a, "SafeMath: addition overflow");
72 
73         return c;
74     }
75 
76     /**
77      * @dev Returns the subtraction of two unsigned integers, reverting on
78      * overflow (when the result is negative).
79      *
80      * Counterpart to Solidity's `-` operator.
81      *
82      * Requirements:
83      *
84      * - Subtraction cannot overflow.
85      */
86     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87         return sub(a, b, "SafeMath: subtraction overflow");
88     }
89 
90     /**
91      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
92      * overflow (when the result is negative).
93      *
94      * Counterpart to Solidity's `-` operator.
95      *
96      * Requirements:
97      *
98      * - Subtraction cannot overflow.
99      */
100     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
101         require(b <= a, errorMessage);
102         uint256 c = a - b;
103 
104         return c;
105     }
106 
107     /**
108      * @dev Returns the multiplication of two unsigned integers, reverting on
109      * overflow.
110      *
111      * Counterpart to Solidity's `*` operator.
112      *
113      * Requirements:
114      *
115      * - Multiplication cannot overflow.
116      */
117     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
118         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
119         // benefit is lost if 'b' is also tested.
120         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
121         if (a == 0) {
122             return 0;
123         }
124 
125         uint256 c = a * b;
126         require(c / a == b, "SafeMath: multiplication overflow");
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the integer division of two unsigned integers. Reverts on
133      * division by zero. The result is rounded towards zero.
134      *
135      * Counterpart to Solidity's `/` operator. Note: this function uses a
136      * `revert` opcode (which leaves remaining gas untouched) while Solidity
137      * uses an invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function div(uint256 a, uint256 b) internal pure returns (uint256) {
144         return div(a, b, "SafeMath: division by zero");
145     }
146 
147     /**
148      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
149      * division by zero. The result is rounded towards zero.
150      *
151      * Counterpart to Solidity's `/` operator. Note: this function uses a
152      * `revert` opcode (which leaves remaining gas untouched) while Solidity
153      * uses an invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      *
157      * - The divisor cannot be zero.
158      */
159     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b > 0, errorMessage);
161         uint256 c = a / b;
162         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
169      * Reverts when dividing by zero.
170      *
171      * Counterpart to Solidity's `%` operator. This function uses a `revert`
172      * opcode (which leaves remaining gas untouched) while Solidity uses an
173      * invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      *
177      * - The divisor cannot be zero.
178      */
179     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
180         return mod(a, b, "SafeMath: modulo by zero");
181     }
182 
183     /**
184      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
185      * Reverts with custom message when dividing by zero.
186      *
187      * Counterpart to Solidity's `%` operator. This function uses a `revert`
188      * opcode (which leaves remaining gas untouched) while Solidity uses an
189      * invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
196         require(b != 0, errorMessage);
197         return a % b;
198     }
199 }
200 
201 
202 /**
203  * @dev Interface of the ERC20 standard as defined in the EIP.
204  */
205 interface IERC20 {
206     /**
207      * @dev Returns the amount of tokens in existence.
208      */
209     function totalSupply() external view returns (uint256);
210 
211     /**
212      * @dev Returns the amount of tokens owned by `account`.
213      */
214     function balanceOf(address account) external view returns (uint256);
215 
216     /**
217      * @dev Moves `amount` tokens from the caller's account to `recipient`.
218      *
219      * Returns a boolean value indicating whether the operation succeeded.
220      *
221      * Emits a {Transfer} event.
222      */
223     function transfer(address recipient, uint256 amount) external returns (bool);
224 
225     /**
226      * @dev Returns the remaining number of tokens that `spender` will be
227      * allowed to spend on behalf of `owner` through {transferFrom}. This is
228      * zero by default.
229      *
230      * This value changes when {approve} or {transferFrom} are called.
231      */
232     function allowance(address owner, address spender) external view returns (uint256);
233 
234     /**
235      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
236      *
237      * Returns a boolean value indicating whether the operation succeeded.
238      *
239      * IMPORTANT: Beware that changing an allowance with this method brings the risk
240      * that someone may use both the old and the new allowance by unfortunate
241      * transaction ordering. One possible solution to mitigate this race
242      * condition is to first reduce the spender's allowance to 0 and set the
243      * desired value afterwards:
244      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
245      *
246      * Emits an {Approval} event.
247      */
248     function approve(address spender, uint256 amount) external returns (bool);
249 
250     /**
251      * @dev Moves `amount` tokens from `sender` to `recipient` using the
252      * allowance mechanism. `amount` is then deducted from the caller's
253      * allowance.
254      *
255      * Returns a boolean value indicating whether the operation succeeded.
256      *
257      * Emits a {Transfer} event.
258      */
259     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
260 
261     /**
262      * @dev Emitted when `value` tokens are moved from one account (`from`) to
263      * another (`to`).
264      *
265      * Note that `value` may be zero.
266      */
267     event Transfer(address indexed from, address indexed to, uint256 value);
268 
269     /**
270      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
271      * a call to {approve}. `value` is the new allowance.
272      */
273     event Approval(address indexed owner, address indexed spender, uint256 value);
274 }
275 
276 
277 // SPDX-License-Identifier: MIT
278 
279 pragma solidity 0.6.0;
280 
281 
282 /**
283  * @dev Implementation of the {IERC20} interface.
284  *
285  * This implementation is agnostic to the way tokens are created. This means
286  * that a supply mechanism has to be added in a derived contract using {_createToken}.
287  *
288  * TIP: For a detailed writeup see our guide
289  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
290  * to implement supply mechanisms].
291  *
292  * We have followed general OpenZeppelin guidelines: functions revert instead
293  * of returning `false` on failure. This behavior is nonetheless conventional
294  * and does not conflict with the expectations of ERC20 applications.
295  *
296  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
297  * This allows applications to reconstruct the allowance for all accounts just
298  * by listening to said events. Other implementations of the EIP may not emit
299  * these events, as it isn't required by the specification.
300  *
301  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
302  * functions have been added to mitigate the well-known issues around setting
303  * allowances. See {IERC20-approve}.
304  */
305 contract ERC20 is Context, IERC20 {
306     using SafeMath for uint256;
307 
308     mapping (address => uint256) private _balances;
309     mapping (address => mapping (address => uint256)) private _allowances;
310     mapping (address => bool) public _whitelistedAddresses;
311 
312     uint256 private _totalSupply;
313     uint256 private _burnedSupply;
314     uint256 private _burnRate;
315     string private _name;
316     string private _symbol;
317     uint256 private _decimals;
318 
319     /**
320      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
321      * a default value of 18.
322      *
323      * To select a different value for {decimals}, use {_setupDecimals}.
324      *
325      * All three of these values are immutable: they can only be set once during
326      * construction.
327      */
328     constructor (string memory name, string memory symbol, uint256 decimals, uint256 burnrate, uint256 initSupply) public {
329         _name = name;
330         _symbol = symbol;
331         _decimals = decimals;
332         _burnRate = burnrate;
333         _totalSupply = 0;
334         _createToken(msg.sender, initSupply*(10**_decimals));
335         _burnedSupply = 0;
336     }
337 
338     /**
339      * @dev Returns the name of the token.
340      */
341     function name() public view returns (string memory) {
342         return _name;
343     }
344 
345     /**
346      * @dev Returns the symbol of the token, usually a shorter version of the
347      * name.
348      */
349     function symbol() public view returns (string memory) {
350         return _symbol;
351     }
352 
353     /**
354      * @dev Returns the number of decimals used to get its user representation.
355      * For example, if `decimals` equals `2`, a balance of `505` tokens should
356      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
357      *
358      * Tokens usually opt for a value of 18, imitating the relationship between
359      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
360      * called.
361      *
362      * NOTE: This information is only used for _display_ purposes: it in
363      * no way affects any of the arithmetic of the contract, including
364      * {IERC20-balanceOf} and {IERC20-transfer}.
365      */
366     function decimals() public view returns (uint256) {
367         return _decimals;
368     }
369 
370     /**
371      * @dev See {IERC20-totalSupply}.
372      */
373     function totalSupply() public view override returns (uint256) {
374         return _totalSupply;
375     }
376 
377     /**
378      * @dev Returns the amount of burned tokens.
379      */
380     function burnedSupply() public view returns (uint256) {
381         return _burnedSupply;
382     }
383 
384     /**
385      * @dev Returns the burnrate.
386      */
387     function burnRate() public view returns (uint256) {
388         return _burnRate;
389     }
390 
391     /**
392      * @dev See {IERC20-balanceOf}.
393      */
394     function balanceOf(address account) public view override returns (uint256) {
395         return _balances[account];
396     }
397 
398     /**
399      * @dev See {IERC20-transfer}.
400      *
401      * Requirements:
402      *
403      * - `recipient` cannot be the zero address.
404      * - the caller must have a balance of at least `amount`.
405      */
406     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
407         _transfer(_msgSender(), recipient, amount);
408         return true;
409     }
410 
411     /**
412      * @dev See {IERC20-transfer}.
413      *
414      * Requirements:
415      *
416      * - `account` cannot be the zero address.
417      * - the caller must have a balance of at least `amount`.
418      */
419     function burn(uint256 amount) public virtual returns (bool) {
420         _burn(_msgSender(), amount);
421         return true;
422     }
423 
424     /**
425      * @dev See {IERC20-allowance}.
426      */
427     function allowance(address owner, address spender) public view virtual override returns (uint256) {
428         return _allowances[owner][spender];
429     }
430 
431     /**
432      * @dev See {IERC20-approve}.
433      *
434      * Requirements:
435      *
436      * - `spender` cannot be the zero address.
437      */
438     function approve(address spender, uint256 amount) public virtual override returns (bool) {
439         _approve(_msgSender(), spender, amount);
440         return true;
441     }
442 
443     /**
444      * @dev See {IERC20-transferFrom}.
445      *
446      * Emits an {Approval} event indicating the updated allowance. This is not
447      * required by the EIP. See the note at the beginning of {ERC20};
448      *
449      * Requirements:
450      * - `sender` and `recipient` cannot be the zero address.
451      * - `sender` must have a balance of at least `amount`.
452      * - the caller must have allowance for ``sender``'s tokens of at least
453      * `amount`.
454      */
455     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
456         _transfer(sender, recipient, amount);
457         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
458         return true;
459     }
460 
461     /**
462      * @dev Atomically increases the allowance granted to `spender` by the caller.
463      *
464      * This is an alternative to {approve} that can be used as a mitigation for
465      * problems described in {IERC20-approve}.
466      *
467      * Emits an {Approval} event indicating the updated allowance.
468      *
469      * Requirements:
470      *
471      * - `spender` cannot be the zero address.
472      */
473     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
474         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
475         return true;
476     }
477 
478     /**
479      * @dev Atomically decreases the allowance granted to `spender` by the caller.
480      *
481      * This is an alternative to {approve} that can be used as a mitigation for
482      * problems described in {IERC20-approve}.
483      *
484      * Emits an {Approval} event indicating the updated allowance.
485      *
486      * Requirements:
487      *
488      * - `spender` cannot be the zero address.
489      * - `spender` must have allowance for the caller of at least
490      * `subtractedValue`.
491      */
492     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
493         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
494         return true;
495     }
496 
497     /**
498      * @dev Moves tokens `amount` from `sender` to `recipient`.
499      *
500      * This is internal function is equivalent to {transfer}, and can be used to
501      * e.g. implement automatic token fees, slashing mechanisms, etc.
502      *
503      * Emits a {Transfer} event.
504      *
505      * Requirements:
506      *
507      * - `sender` cannot be the zero address.
508      * - `recipient` cannot be the zero address.
509      * - `sender` must have a balance of at least `amount`.
510      */
511     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
512         require(sender != address(0), "ERC20: transfer from the zero address");
513         require(recipient != address(0), "ERC20: transfer to the zero address");
514 
515         if (_whitelistedAddresses[sender] == true || _whitelistedAddresses[recipient] == true) {
516             _beforeTokenTransfer(sender, recipient, amount);
517             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
518             _balances[recipient] = _balances[recipient].add(amount);
519             emit Transfer(sender, recipient, amount);
520         } else {
521             uint256 amount_burn = amount.mul(_burnRate).div(100);
522             uint256 amount_send = amount.sub(amount_burn);
523             require(amount == amount_send + amount_burn, "Burn value invalid");
524             _burn(sender, amount_burn);
525             amount = amount_send;
526             _beforeTokenTransfer(sender, recipient, amount);
527             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
528             _balances[recipient] = _balances[recipient].add(amount);
529             emit Transfer(sender, recipient, amount);
530         }
531     }
532 
533     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
534      * the total supply.
535      *
536      * Emits a {Transfer} event with `from` set to the zero address.
537      *
538      * Requirements
539      *
540      * - `to` cannot be the zero address.
541      * 
542      * HINT: This function is 'internal' and therefore can only be called from another
543      * function inside this contract!
544      */
545     function _createToken(address account, uint256 amount) internal virtual {
546         require(account != address(0), "ERC20: mint to the zero address");
547         _beforeTokenTransfer(address(0), account, amount);
548         _totalSupply = _totalSupply.add(amount);
549         _balances[account] = _balances[account].add(amount);
550         emit Transfer(address(0), account, amount);
551     }
552 
553     /**
554      * @dev Destroys `amount` tokens from `account`, reducing the
555      * total supply.
556      *
557      * Emits a {Transfer} event with `to` set to the zero address.
558      *
559      * Requirements
560      *
561      * - `account` cannot be the zero address.
562      * - `account` must have at least `amount` tokens.
563      */
564     function _burn(address account, uint256 amount) internal virtual {
565         require(account != address(0), "ERC20: burn from the zero address");
566         _beforeTokenTransfer(account, address(0), amount);
567         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
568         _totalSupply = _totalSupply.sub(amount);
569         _burnedSupply = _burnedSupply.add(amount);
570         emit Transfer(account, address(0), amount);
571     }
572 
573     /**
574      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
575      *
576      * This is internal function is equivalent to `approve`, and can be used to
577      * e.g. set automatic allowances for certain subsystems, etc.
578      *
579      * Emits an {Approval} event.
580      *
581      * Requirements:
582      *
583      * - `owner` cannot be the zero address.
584      * - `spender` cannot be the zero address.
585      */
586     function _approve(address owner, address spender, uint256 amount) internal virtual {
587         require(owner != address(0), "ERC20: approve from the zero address");
588         require(spender != address(0), "ERC20: approve to the zero address");
589         _allowances[owner][spender] = amount;
590         emit Approval(owner, spender, amount);
591     }
592 
593     /**
594      * @dev Sets {burnRate} to a value other than the initial one.
595      */
596     function _setupBurnrate(uint8 burnrate_) internal virtual {
597         _burnRate = burnrate_;
598     }
599 
600     /**
601      * @dev Hook that is called before any transfer of tokens. This includes
602      * burning.
603      *
604      * Calling conditions:
605      *
606      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
607      * will be to transferred to `to`..
608      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
609      * - `from` and `to` are never both zero.
610      *
611      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
612      */
613     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
614 }
615 
616 
617 
618 // OBR Token
619 contract OBR is ERC20("OBR", "OBR", 18, 2, 50000), Ownable{
620   
621    
622 
623     function setBurnrate(uint8 burnrate_) public onlyOwner {
624         _setupBurnrate(burnrate_);
625     }
626 
627     function addWhitelistedAddress(address _address) public onlyOwner {
628         _whitelistedAddresses[_address] = true;
629     }
630 
631     function removeWhitelistedAddress(address _address) public onlyOwner {
632         _whitelistedAddresses[_address] = false;
633     }
634 }