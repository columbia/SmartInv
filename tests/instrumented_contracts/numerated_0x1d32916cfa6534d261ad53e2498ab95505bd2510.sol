1 //SPDX-License-Identifier: SimPL-2.0
2 pragma solidity ^0.6.0;
3 
4 library SafeMath {
5     /**
6      * @dev Returns the addition of two unsigned integers, reverting on
7      * overflow.
8      *
9      * Counterpart to Solidity's `+` operator.
10      *
11      * Requirements:
12      *
13      * - Addition cannot overflow.
14      */
15     function add(uint256 a, uint256 b) internal pure returns (uint256) {
16         uint256 c = a + b;
17         require(c >= a, "SafeMath: addition overflow");
18 
19         return c;
20     }
21 
22     /**
23      * @dev Returns the subtraction of two unsigned integers, reverting on
24      * overflow (when the result is negative).
25      *
26      * Counterpart to Solidity's `-` operator.
27      *
28      * Requirements:
29      *
30      * - Subtraction cannot overflow.
31      */
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     /**
37      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
38      * overflow (when the result is negative).
39      *
40      * Counterpart to Solidity's `-` operator.
41      *
42      * Requirements:
43      *
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         require(b <= a, errorMessage);
48         uint256 c = a - b;
49 
50         return c;
51     }
52 
53     /**
54      * @dev Returns the multiplication of two unsigned integers, reverting on
55      * overflow.
56      *
57      * Counterpart to Solidity's `*` operator.
58      *
59      * Requirements:
60      *
61      * - Multiplication cannot overflow.
62      */
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
65         // benefit is lost if 'b' is also tested.
66         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
67         if (a == 0) {
68             return 0;
69         }
70 
71         uint256 c = a * b;
72         require(c / a == b, "SafeMath: multiplication overflow");
73 
74         return c;
75     }
76 
77     /**
78      * @dev Returns the integer division of two unsigned integers. Reverts on
79      * division by zero. The result is rounded towards zero.
80      *
81      * Counterpart to Solidity's `/` operator. Note: this function uses a
82      * `revert` opcode (which leaves remaining gas untouched) while Solidity
83      * uses an invalid opcode to revert (consuming all remaining gas).
84      *
85      * Requirements:
86      *
87      * - The divisor cannot be zero.
88      */
89     function div(uint256 a, uint256 b) internal pure returns (uint256) {
90         return div(a, b, "SafeMath: division by zero");
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
106         require(b > 0, errorMessage);
107         uint256 c = a / b;
108         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
109 
110         return c;
111     }
112 
113     /**
114      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
115      * Reverts when dividing by zero.
116      *
117      * Counterpart to Solidity's `%` operator. This function uses a `revert`
118      * opcode (which leaves remaining gas untouched) while Solidity uses an
119      * invalid opcode to revert (consuming all remaining gas).
120      *
121      * Requirements:
122      *
123      * - The divisor cannot be zero.
124      */
125     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
126         return mod(a, b, "SafeMath: modulo by zero");
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts with custom message when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
142         require(b != 0, errorMessage);
143         return a % b;
144     }
145 }
146 
147 contract Ownable {
148 
149     address private _owner;
150 
151     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
152 
153     /**
154      * @dev Initializes the contract setting the deployer as the initial owner.
155      */
156     constructor () internal {
157         _owner = msg.sender;
158         emit OwnershipTransferred(address(0), msg.sender);
159     }
160 
161     /**
162      * @dev Returns the address of the current owner.
163      */
164     function owner() public view returns (address) {
165         return _owner;
166     }
167 
168     /**
169      * @dev Throws if called by any account other than the owner.
170      */
171     modifier onlyOwner() {
172         require(_owner == msg.sender, "YouSwap: CALLER_IS_NOT_THE_OWNER");
173         _;
174     }
175 
176     /**
177      * @dev Leaves the contract without owner. It will not be possible to call
178      * `onlyOwner` functions anymore. Can only be called by the current owner.
179      *
180      * NOTE: Renouncing ownership will leave the contract without an owner,
181      * thereby removing any functionality that is only available to the owner.
182      */
183     function renounceOwnership() public virtual onlyOwner {
184         emit OwnershipTransferred(_owner, address(0));
185         _owner = address(0);
186     }
187 
188     /**
189      * @dev Transfers ownership of the contract to a new account (`newOwner`).
190      * Can only be called by the current owner.
191      */
192     function transferOwnership(address newOwner) public virtual onlyOwner {
193         require(newOwner != address(0), "YouSwap: NEW_OWNER_IS_THE_ZERO_ADDRESS");
194         emit OwnershipTransferred(_owner, newOwner);
195         _owner = newOwner;
196     }
197 }
198 
199 interface ITokenYou {
200     /**
201     * @dev Returns the amount of tokens in existence.
202     */
203     function totalSupply() external view returns (uint256);
204 
205     /**
206      * @dev Returns the amount of tokens owned by `account`.
207      */
208     function balanceOf(address account) external view returns (uint256);
209 
210     /**
211      * @dev Moves `amount` tokens from the caller's account to `recipient`.
212      *
213      * Returns a boolean value indicating whether the operation succeeded.
214      *
215      * Emits a {Transfer} event.
216      */
217     function transfer(address recipient, uint256 amount) external returns (bool);
218 
219     /**
220      * @dev Returns the remaining number of tokens that `spender` will be
221      * allowed to spend on behalf of `owner` through {transferFrom}. This is
222      * zero by default.
223      *
224      * This value changes when {approve} or {transferFrom} are called.
225      */
226     function allowance(address owner, address spender) external view returns (uint256);
227 
228     /**
229      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
230      *
231      * Returns a boolean value indicating whether the operation succeeded.
232      *
233      * IMPORTANT: Beware that changing an allowance with this method brings the risk
234      * that someone may use both the old and the new allowance by unfortunate
235      * transaction ordering. One possible solution to mitigate this race
236      * condition is to first reduce the spender's allowance to 0 and set the
237      * desired value afterwards:
238      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239      *
240      * Emits an {Approval} event.
241      */
242     function approve(address spender, uint256 amount) external returns (bool);
243 
244     /**
245      * @dev Moves `amount` tokens from `sender` to `recipient` using the
246      * allowance mechanism. `amount` is then deducted from the caller's
247      * allowance.
248      *
249      * Returns a boolean value indicating whether the operation succeeded.
250      *
251      * Emits a {Transfer} event.
252      */
253     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
254 
255     /**
256      * @dev Emitted when `value` tokens are moved from one account (`from`) to
257      * another (`to`).
258      *
259      * Note that `value` may be zero.
260      */
261     event Transfer(address indexed from, address indexed to, uint256 value);
262 
263     /**
264      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
265      * a call to {approve}. `value` is the new allowance.
266      */
267     event Approval(address indexed owner, address indexed spender, uint256 value);
268 
269     event MaxSupplyChanged(uint256 oldValue, uint256 newValue);
270 
271     function resetMaxSupply(uint256 newValue) external;
272 
273     function mint(address recipient, uint256 amount) external;
274 
275     function burn(uint256 amount) external;
276 
277     function burnFrom(address account, uint256 amount) external;
278 }
279 
280 contract TokenYou is Ownable, ITokenYou {
281     using SafeMath for uint256;
282 
283     string private constant _name = 'YouSwap';
284     string private constant _symbol = 'YOU';
285     uint8 private constant _decimals = 6;
286     uint256 private _totalSupply;
287     uint256 private _transfers;
288     uint256 private _holders;
289     uint256 private _maxSupply;
290     mapping(address => uint256) private _balanceOf;
291     mapping(address => mapping(address => uint256)) private _allowances;
292 
293     mapping(address => uint8) private _minters;
294 
295     constructor() public {
296         _totalSupply = 0;
297         _transfers = 0;
298         _holders = 0;
299         _maxSupply = 2 * 10 ** 14;
300     }
301 
302     /**
303       * @dev Returns the name of the token.
304       */
305     function name() public pure returns (string memory) {
306         return _name;
307     }
308 
309     /**
310      * @dev Returns the symbol of the token, usually a shorter version of the
311      * name.
312      */
313     function symbol() public pure returns (string memory) {
314         return _symbol;
315     }
316 
317     /**
318      * @dev Returns the number of decimals used to get its user representation.
319      * For example, if `decimals` equals `2`, a balance of `505` tokens should
320      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
321      *
322      * Tokens usually opt for a value of 18, imitating the relationship between
323      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
324      * called.
325      *
326      * NOTE: This information is only used for _display_ purposes: it in
327      * no way affects any of the arithmetic of the contract, including
328      * {ITokenYou-balanceOf} and {ITokenYou-transfer}.
329      */
330     function decimals() public pure returns (uint8) {
331         return _decimals;
332     }
333 
334     /**
335      * @dev See {ITokenYou-totalSupply}.
336      */
337     function totalSupply() public view override returns (uint256) {
338         return _totalSupply;
339     }
340 
341     /**
342    * @dev See {ITokenYou-maxSupply}.
343    */
344     function maxSupply() public view returns (uint256) {
345         return _maxSupply;
346     }
347 
348     function transfers() public view returns (uint256) {
349         return _transfers;
350     }
351 
352     function holders() public view returns (uint256) {
353         return _holders;
354     }
355 
356     /**
357      * @dev See {ITokenYou-balanceOf}.
358      */
359     function balanceOf(address account) public view override returns (uint256) {
360         return _balanceOf[account];
361     }
362 
363     /**
364      * @dev See {ITokenYou-transfer}.
365      *
366      * Requirements:
367      *
368      * - `recipient` cannot be the zero address.
369      * - the caller must have a balance of at least `amount`.
370      */
371     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
372         _transfer(msg.sender, recipient, amount);
373         return true;
374     }
375 
376     /**
377      * @dev See {ITokenYou-allowance}.
378      */
379     function allowance(address owner, address spender) public view virtual override returns (uint256) {
380         return _allowances[owner][spender];
381     }
382 
383     /**
384      * @dev See {ITokenYou-approve}.
385      *
386      * Requirements:
387      *
388      * - `spender` cannot be the zero address.
389      */
390     function approve(address spender, uint256 amount) public override returns (bool) {
391         _approve(msg.sender, spender, amount);
392         return true;
393     }
394 
395     /**
396      * @dev See {ITokenYou-transferFrom}.
397      *
398      * Emits an {Approval} event indicating the updated allowance. This is not
399      * required by the EIP. See the note at the beginning of {ERC20}.
400      *
401      * Requirements:
402      *
403      * - `sender` and `recipient` cannot be the zero address.
404      * - `sender` must have a balance of at least `amount`.
405      * - the caller must have allowance for ``sender``'s tokens of at least
406      * `amount`.
407      */
408     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
409         _transfer(sender, recipient, amount);
410         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "YouSwap: TRANSFER_AMOUNT_EXCEEDS_ALLOWANCE"));
411         return true;
412     }
413 
414     /**
415      * @dev Atomically increases the allowance granted to `spender` by the caller.
416      *
417      * This is an alternative to {approve} that can be used as a mitigation for
418      * problems described in {ITokenYou-approve}.
419      *
420      * Emits an {Approval} event indicating the updated allowance.
421      *
422      * Requirements:
423      *
424      * - `spender` cannot be the zero address.
425      */
426     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
427         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
428         return true;
429     }
430 
431     /**
432      * @dev Atomically decreases the allowance granted to `spender` by the caller.
433      *
434      * This is an alternative to {approve} that can be used as a mitigation for
435      * problems described in {ITokenYou-approve}.
436      *
437      * Emits an {Approval} event indicating the updated allowance.
438      *
439      * Requirements:
440      *
441      * - `spender` cannot be the zero address.
442      * - `spender` must have allowance for the caller of at least
443      * `subtractedValue`.
444      */
445     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
446         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "YouSwap: DECREASED_ALLOWANCE_BELOW_ZERO"));
447         return true;
448     }
449 
450     /**
451      * @dev Moves tokens `amount` from `sender` to `recipient`.
452      *
453      * This is internal function is equivalent to {transfer}, and can be used to
454      * e.g. implement automatic token fees, slashing mechanisms, etc.
455      *
456      * Emits a {Transfer} event.
457      *
458      * Requirements:
459      *
460      * - `sender` cannot be the zero address.
461      * - `recipient` cannot be the zero address.
462      * - `sender` must have a balance of at least `amount`.
463      */
464     function _transfer(address sender, address recipient, uint256 amount) internal {
465         require(sender != address(0), "YouSwap: TRANSFER_FROM_THE_ZERO_ADDRESS");
466         require(recipient != address(0), "YouSwap: TRANSFER_TO_THE_ZERO_ADDRESS");
467         require(amount > 0, "YouSwap: TRANSFER_ZERO_AMOUNT");
468 
469         if (_balanceOf[recipient] == 0) _holders++;
470 
471         _balanceOf[sender] = _balanceOf[sender].sub(amount, "YouSwap: TRANSFER_AMOUNT_EXCEEDS_BALANCE");
472         _balanceOf[recipient] = _balanceOf[recipient].add(amount);
473 
474         _transfers ++;
475 
476         if (_balanceOf[sender] == 0) _holders--;
477 
478         emit Transfer(sender, recipient, amount);
479     }
480 
481     /**
482      * @dev Destroys `amount` tokens from `account`, reducing the
483      * total supply.
484      *
485      * Emits a {Transfer} event with `to` set to the zero address.
486      *
487      * Requirements:
488      *
489      * - `account` cannot be the zero address.
490      * - `account` must have at least `amount` tokens.
491      */
492     function _burn(address account, uint256 amount) internal {
493         require(account != address(0), "YouSwap: BURN_FROM_THE_ZERO_ADDRESS");
494         require(_balanceOf[account] > 0, "YouSwap: INSUFFICIENT_FUNDS");
495 
496         _balanceOf[account] = _balanceOf[account].sub(amount, "YouSwap: BURN_AMOUNT_EXCEEDS_BALANCE");
497         if (_balanceOf[account] == 0) _holders --;
498         _totalSupply = _totalSupply.sub(amount);
499         _transfers++;
500         emit Transfer(account, address(0), amount);
501     }
502 
503     /**
504      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
505      *
506      * This internal function is equivalent to `approve`, and can be used to
507      * e.g. set automatic allowances for certain subsystems, etc.
508      *
509      * Emits an {Approval} event.
510      *
511      * Requirements:
512      *
513      * - `owner` cannot be the zero address.
514      * - `spender` cannot be the zero address.
515      */
516     function _approve(address owner, address spender, uint256 amount) internal {
517         require(owner != address(0), "YouSwap: APPROVE_FROM_THE_ZERO_ADDRESS");
518         require(spender != address(0), "YouSwap: APPROVE_TO_THE_ZERO_ADDRESS");
519 
520         _allowances[owner][spender] = amount;
521         emit Approval(owner, spender, amount);
522     }
523 
524     /**
525      * @dev Destroys `amount` tokens from the caller.
526      *
527      * See {TokenYou-_burn}.
528      */
529     function burn(uint256 amount) external override {
530         _burn(msg.sender, amount);
531     }
532 
533     /**
534      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
535      * allowance.
536      *
537      * See {TokenYou-_burn} and {TokenYou-allowance}.
538      *
539      * Requirements:
540      *
541      * - the caller must have allowance for ``accounts``'s tokens of at least
542      * `amount`.
543      */
544     function burnFrom(address account, uint256 amount) external override {
545         uint256 decreasedAllowance = allowance(account, msg.sender).sub(amount, "YouSwap: BURN_AMOUNT_EXCEEDS_ALLOWANCE");
546 
547         _approve(account, msg.sender, decreasedAllowance);
548         _burn(account, amount);
549     }
550 
551     modifier isMinter() {
552         require(_minters[msg.sender] == 1, "YouSwap: IS_NOT_A_MINTER");
553         _;
554     }
555 
556     function isContract(address account) internal view returns (bool) {
557         uint256 size;
558         assembly {size := extcodesize(account)}
559         return size > 0;
560     }
561 
562     function mint(address recipient, uint256 amount) external override isMinter {
563         require(_totalSupply.add(amount) <= _maxSupply, 'YouSwap: EXCEEDS_MAX_SUPPLY');
564         _totalSupply = _totalSupply.add(amount);
565 
566         if (_balanceOf[recipient] == 0) _holders++;
567         _balanceOf[recipient] = _balanceOf[recipient].add(amount);
568 
569         _transfers++;
570         emit Transfer(address(0), recipient, amount);
571     }
572 
573     function addMinter(address account) external onlyOwner {
574         require(isContract(account), "YouSwap: MUST_BE_A_CONTRACT_ADDRESS");
575         _minters[account] = 1;
576     }
577 
578     function removeMinter(address account) external onlyOwner {
579         _minters[account] = 0;
580     }
581 
582     function resetMaxSupply(uint256 newValue) external override onlyOwner {
583         require(newValue > _totalSupply && newValue < _maxSupply, 'YouSwap: NOT_ALLOWED');
584         emit MaxSupplyChanged(_maxSupply, newValue);
585         _maxSupply = newValue;
586     }
587 }