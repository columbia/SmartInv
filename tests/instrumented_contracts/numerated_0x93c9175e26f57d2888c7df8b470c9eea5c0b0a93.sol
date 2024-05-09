1 pragma solidity ^0.5.0;
2 
3 interface IERC20 {
4     /**
5      * @dev Returns the amount of tokens in existence.
6      */
7     function totalSupply() external view returns (uint256);
8 
9     /**
10      * @dev Returns the amount of tokens owned by `account`.
11      */
12     function balanceOf(address account) external view returns (uint256);
13 
14     /**
15      * @dev Moves `amount` tokens from the caller's account to `recipient`.
16      *
17      * Returns a boolean value indicating whether the operation succeeded.
18      *
19      * Emits a {Transfer} event.
20      */
21     function transfer(address recipient, uint256 amount) external returns (bool);
22 
23     /**
24      * @dev Returns the remaining number of tokens that `spender` will be
25      * allowed to spend on behalf of `owner` through {transferFrom}. This is
26      * zero by default.
27      *
28      * This value changes when {approve} or {transferFrom} are called.
29      */
30     function allowance(address owner, address spender) external view returns (uint256);
31 
32     /**
33      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * IMPORTANT: Beware that changing an allowance with this method brings the risk
38      * that someone may use both the old and the new allowance by unfortunate
39      * transaction ordering. One possible solution to mitigate this race
40      * condition is to first reduce the spender's allowance to 0 and set the
41      * desired value afterwards:
42      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
43      *
44      * Emits an {Approval} event.
45      */
46     function approve(address spender, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Moves `amount` tokens from `sender` to `recipient` using the
50      * allowance mechanism. `amount` is then deducted from the caller's
51      * allowance.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Emitted when `value` tokens are moved from one account (`from`) to
61      * another (`to`).
62      *
63      * Note that `value` may be zero.
64      */
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 
67     /**
68      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
69      * a call to {approve}. `value` is the new allowance.
70      */
71     event Approval(address indexed owner, address indexed spender, uint256 value);
72 }
73 
74 library SafeMath {
75     /**
76      * @dev Returns the addition of two unsigned integers, reverting on
77      * overflow.
78      *
79      * Counterpart to Solidity's `+` operator.
80      *
81      * Requirements:
82      * - Addition cannot overflow.
83      */
84     function add(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a + b;
86         require(c >= a, "SafeMath: addition overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the subtraction of two unsigned integers, reverting on
93      * overflow (when the result is negative).
94      *
95      * Counterpart to Solidity's `-` operator.
96      *
97      * Requirements:
98      * - Subtraction cannot overflow.
99      */
100     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101         return sub(a, b, "SafeMath: subtraction overflow");
102     }
103 
104     /**
105      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
106      * overflow (when the result is negative).
107      *
108      * Counterpart to Solidity's `-` operator.
109      *
110      * Requirements:
111      * - Subtraction cannot overflow.
112      *
113      * _Available since v2.4.0._
114      */
115     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         require(b <= a, errorMessage);
117         uint256 c = a - b;
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the multiplication of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `*` operator.
127      *
128      * Requirements:
129      * - Multiplication cannot overflow.
130      */
131     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
132         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
133         // benefit is lost if 'b' is also tested.
134         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
135         if (a == 0) {
136             return 0;
137         }
138 
139         uint256 c = a * b;
140         require(c / a == b, "SafeMath: multiplication overflow");
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the integer division of two unsigned integers. Reverts on
147      * division by zero. The result is rounded towards zero.
148      *
149      * Counterpart to Solidity's `/` operator. Note: this function uses a
150      * `revert` opcode (which leaves remaining gas untouched) while Solidity
151      * uses an invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      * - The divisor cannot be zero.
155      */
156     function div(uint256 a, uint256 b) internal pure returns (uint256) {
157         return div(a, b, "SafeMath: division by zero");
158     }
159 
160     /**
161      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
162      * division by zero. The result is rounded towards zero.
163      *
164      * Counterpart to Solidity's `/` operator. Note: this function uses a
165      * `revert` opcode (which leaves remaining gas untouched) while Solidity
166      * uses an invalid opcode to revert (consuming all remaining gas).
167      *
168      * Requirements:
169      * - The divisor cannot be zero.
170      *
171      * _Available since v2.4.0._
172      */
173     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174         // Solidity only automatically asserts when dividing by 0
175         require(b > 0, errorMessage);
176         uint256 c = a / b;
177         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
178 
179         return c;
180     }
181 
182     /**
183      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
184      * Reverts when dividing by zero.
185      *
186      * Counterpart to Solidity's `%` operator. This function uses a `revert`
187      * opcode (which leaves remaining gas untouched) while Solidity uses an
188      * invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      * - The divisor cannot be zero.
192      */
193     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
194         return mod(a, b, "SafeMath: modulo by zero");
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * Reverts with custom message when dividing by zero.
200      *
201      * Counterpart to Solidity's `%` operator. This function uses a `revert`
202      * opcode (which leaves remaining gas untouched) while Solidity uses an
203      * invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      * - The divisor cannot be zero.
207      *
208      * _Available since v2.4.0._
209      */
210     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
211         require(b != 0, errorMessage);
212         return a % b;
213     }
214 }
215 
216 contract Context {
217     // Empty internal constructor, to prevent people from mistakenly deploying
218     // an instance of this contract, which should be used via inheritance.
219     constructor () internal { }
220     // solhint-disable-previous-line no-empty-blocks
221 
222     function _msgSender() internal view returns (address payable) {
223         return msg.sender;
224     }
225 
226     function _msgData() internal view returns (bytes memory) {
227         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
228         return msg.data;
229     }
230 }
231 
232 contract Ownable is Context {
233     address private _owner;
234 
235     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
236 
237     /**
238      * @dev Initializes the contract setting the deployer as the initial owner.
239      */
240     constructor () internal {
241         address msgSender = _msgSender();
242         _owner = msgSender;
243         emit OwnershipTransferred(address(0), msgSender);
244     }
245 
246     /**
247      * @dev Returns the address of the current owner.
248      */
249     function owner() public view returns (address) {
250         return _owner;
251     }
252 
253     /**
254      * @dev Throws if called by any account other than the owner.
255      */
256     modifier onlyOwner() {
257         require(isOwner(), "Ownable: caller is not the owner");
258         _;
259     }
260 
261     /**
262      * @dev Returns true if the caller is the current owner.
263      */
264     function isOwner() public view returns (bool) {
265         return _msgSender() == _owner;
266     }
267 
268     /**
269      * @dev Leaves the contract without owner. It will not be possible to call
270      * `onlyOwner` functions anymore. Can only be called by the current owner.
271      *
272      * NOTE: Renouncing ownership will leave the contract without an owner,
273      * thereby removing any functionality that is only available to the owner.
274      */
275     function renounceOwnership() public onlyOwner {
276         emit OwnershipTransferred(_owner, address(0));
277         _owner = address(0);
278     }
279 
280     /**
281      * @dev Transfers ownership of the contract to a new account (`newOwner`).
282      * Can only be called by the current owner.
283      */
284     function transferOwnership(address newOwner) public onlyOwner {
285         _transferOwnership(newOwner);
286     }
287 
288     /**
289      * @dev Transfers ownership of the contract to a new account (`newOwner`).
290      */
291     function _transferOwnership(address newOwner) internal {
292         require(newOwner != address(0), "Ownable: new owner is the zero address");
293         emit OwnershipTransferred(_owner, newOwner);
294         _owner = newOwner;
295     }
296 }
297 
298 
299 /**
300  * @dev Implementation of the {IERC20} interface.
301  *
302  * This implementation is agnostic to the way tokens are created. This means
303  * that a supply mechanism has to be added in a derived contract using {_mint}.
304  * For a generic mechanism see {ERC20Mintable}.
305  *
306  * TIP: For a detailed writeup see our guide
307  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
308  * to implement supply mechanisms].
309  *
310  * We have followed general OpenZeppelin guidelines: functions revert instead
311  * of returning `false` on failure. This behavior is nonetheless conventional
312  * and does not conflict with the expectations of ERC20 applications.
313  *
314  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
315  * This allows applications to reconstruct the allowance for all accounts just
316  * by listening to said events. Other implementations of the EIP may not emit
317  * these events, as it isn't required by the specification.
318  *
319  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
320  * functions have been added to mitigate the well-known issues around setting
321  * allowances. See {IERC20-approve}.
322  */
323 contract ERC20 is Context, IERC20 {
324     using SafeMath for uint256;
325 
326     mapping (address => uint256) private _balances;
327 
328     mapping (address => mapping (address => uint256)) private _allowances;
329 
330     uint256 private _totalSupply;
331 
332     /**
333      * @dev See {IERC20-totalSupply}.
334      */
335     function totalSupply() public view returns (uint256) {
336         return _totalSupply;
337     }
338 
339     /**
340      * @dev See {IERC20-balanceOf}.
341      */
342     function balanceOf(address account) public view returns (uint256) {
343         return _balances[account];
344     }
345 
346     /**
347      * @dev See {IERC20-transfer}.
348      *
349      * Requirements:
350      *
351      * - `recipient` cannot be the zero address.
352      * - the caller must have a balance of at least `amount`.
353      */
354     function transfer(address recipient, uint256 amount) public returns (bool) {
355         _transfer(_msgSender(), recipient, amount);
356         return true;
357     }
358 
359     /**
360      * @dev See {IERC20-allowance}.
361      */
362     function allowance(address owner, address spender) public view returns (uint256) {
363         return _allowances[owner][spender];
364     }
365 
366     /**
367      * @dev See {IERC20-approve}.
368      *
369      * Requirements:
370      *
371      * - `spender` cannot be the zero address.
372      */
373     function approve(address spender, uint256 amount) public returns (bool) {
374         _approve(_msgSender(), spender, amount);
375         return true;
376     }
377 
378     /**
379      * @dev See {IERC20-transferFrom}.
380      *
381      * Emits an {Approval} event indicating the updated allowance. This is not
382      * required by the EIP. See the note at the beginning of {ERC20};
383      *
384      * Requirements:
385      * - `sender` and `recipient` cannot be the zero address.
386      * - `sender` must have a balance of at least `amount`.
387      * - the caller must have allowance for `sender`'s tokens of at least
388      * `amount`.
389      */
390     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
391         _transfer(sender, recipient, amount);
392         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
393         return true;
394     }
395 
396     /**
397      * @dev Atomically increases the allowance granted to `spender` by the caller.
398      *
399      * This is an alternative to {approve} that can be used as a mitigation for
400      * problems described in {IERC20-approve}.
401      *
402      * Emits an {Approval} event indicating the updated allowance.
403      *
404      * Requirements:
405      *
406      * - `spender` cannot be the zero address.
407      */
408     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
409         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
410         return true;
411     }
412 
413     /**
414      * @dev Atomically decreases the allowance granted to `spender` by the caller.
415      *
416      * This is an alternative to {approve} that can be used as a mitigation for
417      * problems described in {IERC20-approve}.
418      *
419      * Emits an {Approval} event indicating the updated allowance.
420      *
421      * Requirements:
422      *
423      * - `spender` cannot be the zero address.
424      * - `spender` must have allowance for the caller of at least
425      * `subtractedValue`.
426      */
427     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
428         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
429         return true;
430     }
431 
432     /**
433      * @dev Moves tokens `amount` from `sender` to `recipient`.
434      *
435      * This is internal function is equivalent to {transfer}, and can be used to
436      * e.g. implement automatic token fees, slashing mechanisms, etc.
437      *
438      * Emits a {Transfer} event.
439      *
440      * Requirements:
441      *
442      * - `sender` cannot be the zero address.
443      * - `recipient` cannot be the zero address.
444      * - `sender` must have a balance of at least `amount`.
445      */
446     function _transfer(address sender, address recipient, uint256 amount) internal {
447         require(sender != address(0), "ERC20: transfer from the zero address");
448         require(recipient != address(0), "ERC20: transfer to the zero address");
449 
450         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
451         _balances[recipient] = _balances[recipient].add(amount);
452         emit Transfer(sender, recipient, amount);
453     }
454 
455     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
456      * the total supply.
457      *
458      * Emits a {Transfer} event with `from` set to the zero address.
459      *
460      * Requirements
461      *
462      * - `to` cannot be the zero address.
463      */
464     function _mint(address account, uint256 amount) internal {
465         require(account != address(0), "ERC20: mint to the zero address");
466 
467         _totalSupply = _totalSupply.add(amount);
468         _balances[account] = _balances[account].add(amount);
469         emit Transfer(address(0), account, amount);
470     }
471 
472     /**
473      * @dev Destroys `amount` tokens from `account`, reducing the
474      * total supply.
475      *
476      * Emits a {Transfer} event with `to` set to the zero address.
477      *
478      * Requirements
479      *
480      * - `account` cannot be the zero address.
481      * - `account` must have at least `amount` tokens.
482      */
483     function _burn(address account, uint256 amount) internal {
484         require(account != address(0), "ERC20: burn from the zero address");
485 
486         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
487         _totalSupply = _totalSupply.sub(amount);
488         emit Transfer(account, address(0), amount);
489     }
490 
491     /**
492      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
493      *
494      * This is internal function is equivalent to `approve`, and can be used to
495      * e.g. set automatic allowances for certain subsystems, etc.
496      *
497      * Emits an {Approval} event.
498      *
499      * Requirements:
500      *
501      * - `owner` cannot be the zero address.
502      * - `spender` cannot be the zero address.
503      */
504     function _approve(address owner, address spender, uint256 amount) internal {
505         require(owner != address(0), "ERC20: approve from the zero address");
506         require(spender != address(0), "ERC20: approve to the zero address");
507 
508         _allowances[owner][spender] = amount;
509         emit Approval(owner, spender, amount);
510     }
511 
512     /**
513      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
514      * from the caller's allowance.
515      *
516      * See {_burn} and {_approve}.
517      */
518     function _burnFrom(address account, uint256 amount) internal {
519         _burn(account, amount);
520         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
521     }
522 }
523 
524 
525 contract ERC20Detailed is IERC20 {
526     string private _name;
527     string private _symbol;
528     uint8 private _decimals;
529 
530     /**
531      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
532      * these values are immutable: they can only be set once during
533      * construction.
534      */
535     constructor (string memory name, string memory symbol, uint8 decimals) public {
536         _name = name;
537         _symbol = symbol;
538         _decimals = decimals;
539     }
540 
541     /**
542      * @dev Returns the name of the token.
543      */
544     function name() public view returns (string memory) {
545         return _name;
546     }
547 
548     /**
549      * @dev Returns the symbol of the token, usually a shorter version of the
550      * name.
551      */
552     function symbol() public view returns (string memory) {
553         return _symbol;
554     }
555 
556     /**
557      * @dev Returns the number of decimals used to get its user representation.
558      * For example, if `decimals` equals `2`, a balance of `505` tokens should
559      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
560      *
561      * Tokens usually opt for a value of 18, imitating the relationship between
562      * Ether and Wei.
563      *
564      * NOTE: This information is only used for _display_ purposes: it in
565      * no way affects any of the arithmetic of the contract, including
566      * {IERC20-balanceOf} and {IERC20-transfer}.
567      */
568     function decimals() public view returns (uint8) {
569         return _decimals;
570     }
571 }
572 
573 /**
574  * @title BCUBE token contract
575  * @notice Follows ERC-20 standards
576  * @author Smit Rajput @ b-cube.ai
577  **/
578 
579 contract BCUBEToken is ERC20, ERC20Detailed, Ownable {
580     /// @notice total supply cap of BCUBE tokens
581     uint256 public cap;
582 
583     constructor(
584         string memory _name,
585         string memory _symbol,
586         uint8 _decimals,
587         uint256 initialSupply,
588         uint256 _cap
589     ) public ERC20Detailed(_name, _symbol, _decimals) {
590         require(_cap > 0, "ERC20Capped: cap is 0");
591         cap = _cap;
592         _mint(msg.sender, initialSupply);
593     }
594 
595     /// @dev minting implementation for BCUBEs, intended to be called only once i.e. after private sale
596     function mint(address account, uint256 amount) external onlyOwner {
597         require(totalSupply().add(amount) <= cap, "ERC20Capped: cap exceeded");
598         _mint(account, amount);
599     }
600 
601     /// @dev only owner can burn tokens it already owns
602     function burn(uint256 amount) external onlyOwner {
603         _burn(owner(), amount);
604     }
605 }