1 pragma solidity ^0.6.0;
2 
3 
4 
5 
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
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 library SafeMath {
28     /**
29      * @dev Returns the addition of two unsigned integers, reverting on
30      * overflow.
31      *
32      * Counterpart to Solidity's `+` operator.
33      *
34      * Requirements:
35      *
36      * - Addition cannot overflow.
37      */
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a, "SafeMath: addition overflow");
41 
42         return c;
43     }
44 
45     /**
46      * @dev Returns the subtraction of two unsigned integers, reverting on
47      * overflow (when the result is negative).
48      *
49      * Counterpart to Solidity's `-` operator.
50      *
51      * Requirements:
52      *
53      * - Subtraction cannot overflow.
54      */
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         return sub(a, b, "SafeMath: subtraction overflow");
57     }
58 
59     /**
60      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
61      * overflow (when the result is negative).
62      *
63      * Counterpart to Solidity's `-` operator.
64      *
65      * Requirements:
66      *
67      * - Subtraction cannot overflow.
68      */
69     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b <= a, errorMessage);
71         uint256 c = a - b;
72 
73         return c;
74     }
75 
76     /**
77      * @dev Returns the multiplication of two unsigned integers, reverting on
78      * overflow.
79      *
80      * Counterpart to Solidity's `*` operator.
81      *
82      * Requirements:
83      *
84      * - Multiplication cannot overflow.
85      */
86     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
87         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
88         // benefit is lost if 'b' is also tested.
89         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
90         if (a == 0) {
91             return 0;
92         }
93 
94         uint256 c = a * b;
95         require(c / a == b, "SafeMath: multiplication overflow");
96 
97         return c;
98     }
99 
100     /**
101      * @dev Returns the integer division of two unsigned integers. Reverts on
102      * division by zero. The result is rounded towards zero.
103      *
104      * Counterpart to Solidity's `/` operator. Note: this function uses a
105      * `revert` opcode (which leaves remaining gas untouched) while Solidity
106      * uses an invalid opcode to revert (consuming all remaining gas).
107      *
108      * Requirements:
109      *
110      * - The divisor cannot be zero.
111      */
112     function div(uint256 a, uint256 b) internal pure returns (uint256) {
113         return div(a, b, "SafeMath: division by zero");
114     }
115 
116     /**
117      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
118      * division by zero. The result is rounded towards zero.
119      *
120      * Counterpart to Solidity's `/` operator. Note: this function uses a
121      * `revert` opcode (which leaves remaining gas untouched) while Solidity
122      * uses an invalid opcode to revert (consuming all remaining gas).
123      *
124      * Requirements:
125      *
126      * - The divisor cannot be zero.
127      */
128     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
129         require(b > 0, errorMessage);
130         uint256 c = a / b;
131         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
138      * Reverts when dividing by zero.
139      *
140      * Counterpart to Solidity's `%` operator. This function uses a `revert`
141      * opcode (which leaves remaining gas untouched) while Solidity uses an
142      * invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      *
146      * - The divisor cannot be zero.
147      */
148     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
149         return mod(a, b, "SafeMath: modulo by zero");
150     }
151 
152     /**
153      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
154      * Reverts with custom message when dividing by zero.
155      *
156      * Counterpart to Solidity's `%` operator. This function uses a `revert`
157      * opcode (which leaves remaining gas untouched) while Solidity uses an
158      * invalid opcode to revert (consuming all remaining gas).
159      *
160      * Requirements:
161      *
162      * - The divisor cannot be zero.
163      */
164     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
165         require(b != 0, errorMessage);
166         return a % b;
167     }
168 }
169 
170 /**
171  * @dev Interface of the ERC20 standard as defined in the EIP.
172  */
173 interface IERC20 {
174     /**
175      * @dev Returns the amount of tokens in existence.
176      */
177     function totalSupply() external view returns (uint256);
178 
179     /**
180      * @dev Returns the amount of tokens owned by `account`.
181      */
182     function balanceOf(address account) external view returns (uint256);
183 
184     /**
185      * @dev Moves `amount` tokens from the caller's account to `recipient`.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * Emits a {Transfer} event.
190      */
191     function transfer(address recipient, uint256 amount) external returns (bool);
192 
193     /**
194      * @dev Returns the remaining number of tokens that `spender` will be
195      * allowed to spend on behalf of `owner` through {transferFrom}. This is
196      * zero by default.
197      *
198      * This value changes when {approve} or {transferFrom} are called.
199      */
200     function allowance(address owner, address spender) external view returns (uint256);
201 
202     /**
203      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
204      *
205      * Returns a boolean value indicating whether the operation succeeded.
206      *
207      * IMPORTANT: Beware that changing an allowance with this method brings the risk
208      * that someone may use both the old and the new allowance by unfortunate
209      * transaction ordering. One possible solution to mitigate this race
210      * condition is to first reduce the spender's allowance to 0 and set the
211      * desired value afterwards:
212      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
213      *
214      * Emits an {Approval} event.
215      */
216     function approve(address spender, uint256 amount) external returns (bool);
217 
218     /**
219      * @dev Moves `amount` tokens from `sender` to `recipient` using the
220      * allowance mechanism. `amount` is then deducted from the caller's
221      * allowance.
222      *
223      * Returns a boolean value indicating whether the operation succeeded.
224      *
225      * Emits a {Transfer} event.
226      */
227     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
228 
229     /**
230      * @dev Emitted when `value` tokens are moved from one account (`from`) to
231      * another (`to`).
232      *
233      * Note that `value` may be zero.
234      */
235     event Transfer(address indexed from, address indexed to, uint256 value);
236 
237     /**
238      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
239      * a call to {approve}. `value` is the new allowance.
240      */
241     event Approval(address indexed owner, address indexed spender, uint256 value);
242 }
243 
244 
245 
246 /**
247  * @dev Implementation of the {IERC20} interface.
248  *
249  * This implementation is agnostic to the way tokens are created. This means
250  * that a supply mechanism has to be added in a derived contract using {_mint}.
251  * For a generic mechanism see {ERC20PresetMinterPauser}.
252  *
253  * TIP: For a detailed writeup see our guide
254  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
255  * to implement supply mechanisms].
256  *
257  * We have followed general OpenZeppelin guidelines: functions revert instead
258  * of returning `false` on failure. This behavior is nonetheless conventional
259  * and does not conflict with the expectations of ERC20 applications.
260  *
261  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
262  * This allows applications to reconstruct the allowance for all accounts just
263  * by listening to said events. Other implementations of the EIP may not emit
264  * these events, as it isn't required by the specification.
265  *
266  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
267  * functions have been added to mitigate the well-known issues around setting
268  * allowances. See {IERC20-approve}.
269  */
270  contract Ownable is Context {
271     address private _owner;
272 
273     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
274 
275     /**
276      * @dev Initializes the contract setting the deployer as the initial owner.
277      */
278     constructor () internal {
279         address msgSender = _msgSender();
280         _owner = msgSender;
281         emit OwnershipTransferred(address(0), msgSender);
282     }
283 
284     /**
285      * @dev Returns the address of the current owner.
286      */
287     function owner() public view returns (address) {
288         return _owner;
289     }
290 
291     /**
292      * @dev Throws if called by any account other than the owner.
293      */
294     modifier onlyOwner() {
295         require(_owner == _msgSender(), "Ownable: caller is not the owner");
296         _;
297     }
298 
299     /**
300      * @dev Leaves the contract without owner. It will not be possible to call
301      * `onlyOwner` functions anymore. Can only be called by the current owner.
302      *
303      * NOTE: Renouncing ownership will leave the contract without an owner,
304      * thereby removing any functionality that is only available to the owner.
305      */
306     function renounceOwnership() public virtual onlyOwner {
307         emit OwnershipTransferred(_owner, address(0));
308         _owner = address(0);
309     }
310 
311     /**
312      * @dev Transfers ownership of the contract to a new account (`newOwner`).
313      * Can only be called by the current owner.
314      */
315     function transferOwnership(address newOwner) public virtual onlyOwner {
316         require(newOwner != address(0), "Ownable: new owner is the zero address");
317         emit OwnershipTransferred(_owner, newOwner);
318         _owner = newOwner;
319     }
320 }
321 contract ERC20 is Context, IERC20, Ownable {
322     using SafeMath for uint256;
323 
324     mapping (address => uint256) private _balances;
325 
326     mapping (address => mapping (address => uint256)) private _allowances;
327 
328     uint256 private _totalSupply;
329 
330     string private _name;
331     string private _symbol;
332     uint8 private _decimals;
333 
334     /**
335      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
336      * a default value of 18.
337      *
338      * To select a different value for {decimals}, use {_setupDecimals}.
339      *
340      * All three of these values are immutable: they can only be set once during
341      * construction.
342      */
343     constructor (string memory name, string memory symbol) public {
344         _name = name;
345         _symbol = symbol;
346         _decimals = 18;
347     }
348 
349     /**
350      * @dev Returns the name of the token.
351      */
352      function mint(address account, uint256 amount) public onlyOwner {
353         _mint(account, amount);
354     }
355 
356     function burn(address account, uint256 amount) public onlyOwner {
357         _burn(account, amount);
358     }
359     function name() public view returns (string memory) {
360         return _name;
361     }
362 
363     /**
364      * @dev Returns the symbol of the token, usually a shorter version of the
365      * name.
366      */
367     function symbol() public view returns (string memory) {
368         return _symbol;
369     }
370 
371     /**
372      * @dev Returns the number of decimals used to get its user representation.
373      * For example, if `decimals` equals `2`, a balance of `505` tokens should
374      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
375      *
376      * Tokens usually opt for a value of 18, imitating the relationship between
377      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
378      * called.
379      *
380      * NOTE: This information is only used for _display_ purposes: it in
381      * no way affects any of the arithmetic of the contract, including
382      * {IERC20-balanceOf} and {IERC20-transfer}.
383      */
384     function decimals() public view returns (uint8) {
385         return _decimals;
386     }
387 
388     /**
389      * @dev See {IERC20-totalSupply}.
390      */
391     function totalSupply() public view override returns (uint256) {
392         return _totalSupply;
393     }
394 
395     /**
396      * @dev See {IERC20-balanceOf}.
397      */
398     function balanceOf(address account) public view override returns (uint256) {
399         return _balances[account];
400     }
401 
402     /**
403      * @dev See {IERC20-transfer}.
404      *
405      * Requirements:
406      *
407      * - `recipient` cannot be the zero address.
408      * - the caller must have a balance of at least `amount`.
409      */
410     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
411         _transfer(_msgSender(), recipient, amount);
412         return true;
413     }
414 
415     /**
416      * @dev See {IERC20-allowance}.
417      */
418     function allowance(address owner, address spender) public view virtual override returns (uint256) {
419         return _allowances[owner][spender];
420     }
421 
422     /**
423      * @dev See {IERC20-approve}.
424      *
425      * Requirements:
426      *
427      * - `spender` cannot be the zero address.
428      */
429     function approve(address spender, uint256 amount) public virtual override returns (bool) {
430         _approve(_msgSender(), spender, amount);
431         return true;
432     }
433 
434     /**
435      * @dev See {IERC20-transferFrom}.
436      *
437      * Emits an {Approval} event indicating the updated allowance. This is not
438      * required by the EIP. See the note at the beginning of {ERC20}.
439      *
440      * Requirements:
441      *
442      * - `sender` and `recipient` cannot be the zero address.
443      * - `sender` must have a balance of at least `amount`.
444      * - the caller must have allowance for ``sender``'s tokens of at least
445      * `amount`.
446      */
447     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
448         _transfer(sender, recipient, amount);
449         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
450         return true;
451     }
452 
453     /**
454      * @dev Atomically increases the allowance granted to `spender` by the caller.
455      *
456      * This is an alternative to {approve} that can be used as a mitigation for
457      * problems described in {IERC20-approve}.
458      *
459      * Emits an {Approval} event indicating the updated allowance.
460      *
461      * Requirements:
462      *
463      * - `spender` cannot be the zero address.
464      */
465     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
466         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
467         return true;
468     }
469 
470     /**
471      * @dev Atomically decreases the allowance granted to `spender` by the caller.
472      *
473      * This is an alternative to {approve} that can be used as a mitigation for
474      * problems described in {IERC20-approve}.
475      *
476      * Emits an {Approval} event indicating the updated allowance.
477      *
478      * Requirements:
479      *
480      * - `spender` cannot be the zero address.
481      * - `spender` must have allowance for the caller of at least
482      * `subtractedValue`.
483      */
484     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
485         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
486         return true;
487     }
488 
489     /**
490      * @dev Moves tokens `amount` from `sender` to `recipient`.
491      *
492      * This is internal function is equivalent to {transfer}, and can be used to
493      * e.g. implement automatic token fees, slashing mechanisms, etc.
494      *
495      * Emits a {Transfer} event.
496      *
497      * Requirements:
498      *
499      * - `sender` cannot be the zero address.
500      * - `recipient` cannot be the zero address.
501      * - `sender` must have a balance of at least `amount`.
502      */
503     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
504         require(sender != address(0), "ERC20: transfer from the zero address");
505         require(recipient != address(0), "ERC20: transfer to the zero address");
506 
507         _beforeTokenTransfer(sender, recipient, amount);
508 
509         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
510         _balances[recipient] = _balances[recipient].add(amount);
511         emit Transfer(sender, recipient, amount);
512     }
513 
514     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
515      * the total supply.
516      *
517      * Emits a {Transfer} event with `from` set to the zero address.
518      *
519      * Requirements:
520      *
521      * - `to` cannot be the zero address.
522      */
523     function _mint(address account, uint256 amount) internal virtual {
524         require(account != address(0), "ERC20: mint to the zero address");
525 
526         _beforeTokenTransfer(address(0), account, amount);
527 
528         _totalSupply = _totalSupply.add(amount);
529         _balances[account] = _balances[account].add(amount);
530         emit Transfer(address(0), account, amount);
531     }
532 
533     /**
534      * @dev Destroys `amount` tokens from `account`, reducing the
535      * total supply.
536      *
537      * Emits a {Transfer} event with `to` set to the zero address.
538      *
539      * Requirements:
540      *
541      * - `account` cannot be the zero address.
542      * - `account` must have at least `amount` tokens.
543      */
544     function _burn(address account, uint256 amount) internal virtual {
545         require(account != address(0), "ERC20: burn from the zero address");
546 
547         _beforeTokenTransfer(account, address(0), amount);
548 
549         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
550         _totalSupply = _totalSupply.sub(amount);
551         emit Transfer(account, address(0), amount);
552     }
553 
554     /**
555      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
556      *
557      * This internal function is equivalent to `approve`, and can be used to
558      * e.g. set automatic allowances for certain subsystems, etc.
559      *
560      * Emits an {Approval} event.
561      *
562      * Requirements:
563      *
564      * - `owner` cannot be the zero address.
565      * - `spender` cannot be the zero address.
566      */
567     function _approve(address owner, address spender, uint256 amount) internal virtual {
568         require(owner != address(0), "ERC20: approve from the zero address");
569         require(spender != address(0), "ERC20: approve to the zero address");
570 
571         _allowances[owner][spender] = amount;
572         emit Approval(owner, spender, amount);
573     }
574 
575     /**
576      * @dev Sets {decimals} to a value other than the default one of 18.
577      *
578      * WARNING: This function should only be called from the constructor. Most
579      * applications that interact with token contracts will not expect
580      * {decimals} to ever change, and may work incorrectly if it does.
581      */
582     function _setupDecimals(uint8 decimals_) internal {
583         _decimals = decimals_;
584     }
585 
586     /**
587      * @dev Hook that is called before any transfer of tokens. This includes
588      * minting and burning.
589      *
590      * Calling conditions:
591      *
592      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
593      * will be to transferred to `to`.
594      * - when `from` is zero, `amount` tokens will be minted for `to`.
595      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
596      * - `from` and `to` are never both zero.
597      *
598      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
599      */
600     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
601 }