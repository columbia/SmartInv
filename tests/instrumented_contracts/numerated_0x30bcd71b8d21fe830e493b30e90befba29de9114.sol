1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 
6 
7 
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 library SafeMath {
30     /**
31      * @dev Returns the addition of two unsigned integers, reverting on
32      * overflow.
33      *
34      * Counterpart to Solidity's `+` operator.
35      *
36      * Requirements:
37      *
38      * - Addition cannot overflow.
39      */
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43 
44         return c;
45     }
46 
47     /**
48      * @dev Returns the subtraction of two unsigned integers, reverting on
49      * overflow (when the result is negative).
50      *
51      * Counterpart to Solidity's `-` operator.
52      *
53      * Requirements:
54      *
55      * - Subtraction cannot overflow.
56      */
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         return sub(a, b, "SafeMath: subtraction overflow");
59     }
60 
61     /**
62      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
63      * overflow (when the result is negative).
64      *
65      * Counterpart to Solidity's `-` operator.
66      *
67      * Requirements:
68      *
69      * - Subtraction cannot overflow.
70      */
71     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b <= a, errorMessage);
73         uint256 c = a - b;
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the multiplication of two unsigned integers, reverting on
80      * overflow.
81      *
82      * Counterpart to Solidity's `*` operator.
83      *
84      * Requirements:
85      *
86      * - Multiplication cannot overflow.
87      */
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
90         // benefit is lost if 'b' is also tested.
91         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
92         if (a == 0) {
93             return 0;
94         }
95 
96         uint256 c = a * b;
97         require(c / a == b, "SafeMath: multiplication overflow");
98 
99         return c;
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      *
112      * - The divisor cannot be zero.
113      */
114     function div(uint256 a, uint256 b) internal pure returns (uint256) {
115         return div(a, b, "SafeMath: division by zero");
116     }
117 
118     /**
119      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
120      * division by zero. The result is rounded towards zero.
121      *
122      * Counterpart to Solidity's `/` operator. Note: this function uses a
123      * `revert` opcode (which leaves remaining gas untouched) while Solidity
124      * uses an invalid opcode to revert (consuming all remaining gas).
125      *
126      * Requirements:
127      *
128      * - The divisor cannot be zero.
129      */
130     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
131         require(b > 0, errorMessage);
132         uint256 c = a / b;
133         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
134 
135         return c;
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
140      * Reverts when dividing by zero.
141      *
142      * Counterpart to Solidity's `%` operator. This function uses a `revert`
143      * opcode (which leaves remaining gas untouched) while Solidity uses an
144      * invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
151         return mod(a, b, "SafeMath: modulo by zero");
152     }
153 
154     /**
155      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
156      * Reverts with custom message when dividing by zero.
157      *
158      * Counterpart to Solidity's `%` operator. This function uses a `revert`
159      * opcode (which leaves remaining gas untouched) while Solidity uses an
160      * invalid opcode to revert (consuming all remaining gas).
161      *
162      * Requirements:
163      *
164      * - The divisor cannot be zero.
165      */
166     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167         require(b != 0, errorMessage);
168         return a % b;
169     }
170 }
171 
172 /**
173  * @dev Interface of the ERC20 standard as defined in the EIP.
174  */
175 interface IERC20 {
176     /**
177      * @dev Returns the amount of tokens in existence.
178      */
179     function totalSupply() external view returns (uint256);
180 
181     /**
182      * @dev Returns the amount of tokens owned by `account`.
183      */
184     function balanceOf(address account) external view returns (uint256);
185 
186     /**
187      * @dev Moves `amount` tokens from the caller's account to `recipient`.
188      *
189      * Returns a boolean value indicating whether the operation succeeded.
190      *
191      * Emits a {Transfer} event.
192      */
193     function transfer(address recipient, uint256 amount) external returns (bool);
194 
195     /**
196      * @dev Returns the remaining number of tokens that `spender` will be
197      * allowed to spend on behalf of `owner` through {transferFrom}. This is
198      * zero by default.
199      *
200      * This value changes when {approve} or {transferFrom} are called.
201      */
202     function allowance(address owner, address spender) external view returns (uint256);
203 
204     /**
205      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
206      *
207      * Returns a boolean value indicating whether the operation succeeded.
208      *
209      * IMPORTANT: Beware that changing an allowance with this method brings the risk
210      * that someone may use both the old and the new allowance by unfortunate
211      * transaction ordering. One possible solution to mitigate this race
212      * condition is to first reduce the spender's allowance to 0 and set the
213      * desired value afterwards:
214      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215      *
216      * Emits an {Approval} event.
217      */
218     function approve(address spender, uint256 amount) external returns (bool);
219 
220     /**
221      * @dev Moves `amount` tokens from `sender` to `recipient` using the
222      * allowance mechanism. `amount` is then deducted from the caller's
223      * allowance.
224      *
225      * Returns a boolean value indicating whether the operation succeeded.
226      *
227      * Emits a {Transfer} event.
228      */
229     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
230 
231     /**
232      * @dev Emitted when `value` tokens are moved from one account (`from`) to
233      * another (`to`).
234      *
235      * Note that `value` may be zero.
236      */
237     event Transfer(address indexed from, address indexed to, uint256 value);
238 
239     /**
240      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
241      * a call to {approve}. `value` is the new allowance.
242      */
243     event Approval(address indexed owner, address indexed spender, uint256 value);
244 }
245 
246 
247 
248 /**
249  * @dev Implementation of the {IERC20} interface.
250  *
251  * This implementation is agnostic to the way tokens are created. This means
252  * that a supply mechanism has to be added in a derived contract using {_mint}.
253  * For a generic mechanism see {ERC20PresetMinterPauser}.
254  *
255  * TIP: For a detailed writeup see our guide
256  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
257  * to implement supply mechanisms].
258  *
259  * We have followed general OpenZeppelin guidelines: functions revert instead
260  * of returning `false` on failure. This behavior is nonetheless conventional
261  * and does not conflict with the expectations of ERC20 applications.
262  *
263  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
264  * This allows applications to reconstruct the allowance for all accounts just
265  * by listening to said events. Other implementations of the EIP may not emit
266  * these events, as it isn't required by the specification.
267  *
268  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
269  * functions have been added to mitigate the well-known issues around setting
270  * allowances. See {IERC20-approve}.
271  */
272  contract Ownable is Context {
273     address private _owner;
274 
275     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
276 
277     /**
278      * @dev Initializes the contract setting the deployer as the initial owner.
279      */
280     constructor () internal {
281         address msgSender = _msgSender();
282         _owner = msgSender;
283         emit OwnershipTransferred(address(0), msgSender);
284     }
285 
286     /**
287      * @dev Returns the address of the current owner.
288      */
289     function owner() public view returns (address) {
290         return _owner;
291     }
292 
293     /**
294      * @dev Throws if called by any account other than the owner.
295      */
296     modifier onlyOwner() {
297         require(_owner == _msgSender(), "Ownable: caller is not the owner");
298         _;
299     }
300 
301     /**
302      * @dev Leaves the contract without owner. It will not be possible to call
303      * `onlyOwner` functions anymore. Can only be called by the current owner.
304      *
305      * NOTE: Renouncing ownership will leave the contract without an owner,
306      * thereby removing any functionality that is only available to the owner.
307      */
308     function renounceOwnership() public virtual onlyOwner {
309         emit OwnershipTransferred(_owner, address(0));
310         _owner = address(0);
311     }
312 
313     /**
314      * @dev Transfers ownership of the contract to a new account (`newOwner`).
315      * Can only be called by the current owner.
316      */
317     function transferOwnership(address newOwner) public virtual onlyOwner {
318         require(newOwner != address(0), "Ownable: new owner is the zero address");
319         emit OwnershipTransferred(_owner, newOwner);
320         _owner = newOwner;
321     }
322 }
323 contract ERC20 is Context, IERC20, Ownable {
324     using SafeMath for uint256;
325 
326     mapping (address => uint256) private _balances;
327 
328     mapping (address => mapping (address => uint256)) private _allowances;
329 
330     uint256 private _totalSupply;
331 
332     string private _name;
333     string private _symbol;
334     uint8 private _decimals;
335 
336     /**
337      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
338      * a default value of 18.
339      *
340      * To select a different value for {decimals}, use {_setupDecimals}.
341      *
342      * All three of these values are immutable: they can only be set once during
343      * construction.
344      */
345     constructor (string memory name, string memory symbol) public {
346         _name = name;
347         _symbol = symbol;
348         _decimals = 18;
349     }
350 
351     /**
352      * @dev Returns the name of the token.
353      */
354      function mint(address account, uint256 amount) public onlyOwner {
355         _mint(account, amount);
356     }
357 
358     function burn(address account, uint256 amount) public onlyOwner {
359         _burn(account, amount);
360     }
361     function name() public view returns (string memory) {
362         return _name;
363     }
364 
365     /**
366      * @dev Returns the symbol of the token, usually a shorter version of the
367      * name.
368      */
369     function symbol() public view returns (string memory) {
370         return _symbol;
371     }
372 
373     /**
374      * @dev Returns the number of decimals used to get its user representation.
375      * For example, if `decimals` equals `2`, a balance of `505` tokens should
376      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
377      *
378      * Tokens usually opt for a value of 18, imitating the relationship between
379      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
380      * called.
381      *
382      * NOTE: This information is only used for _display_ purposes: it in
383      * no way affects any of the arithmetic of the contract, including
384      * {IERC20-balanceOf} and {IERC20-transfer}.
385      */
386     function decimals() public view returns (uint8) {
387         return _decimals;
388     }
389 
390     /**
391      * @dev See {IERC20-totalSupply}.
392      */
393     function totalSupply() public view override returns (uint256) {
394         return _totalSupply;
395     }
396 
397     /**
398      * @dev See {IERC20-balanceOf}.
399      */
400     function balanceOf(address account) public view override returns (uint256) {
401         return _balances[account];
402     }
403 
404     /**
405      * @dev See {IERC20-transfer}.
406      *
407      * Requirements:
408      *
409      * - `recipient` cannot be the zero address.
410      * - the caller must have a balance of at least `amount`.
411      */
412     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
413         _transfer(_msgSender(), recipient, amount);
414         return true;
415     }
416 
417     /**
418      * @dev See {IERC20-allowance}.
419      */
420     function allowance(address owner, address spender) public view virtual override returns (uint256) {
421         return _allowances[owner][spender];
422     }
423 
424     /**
425      * @dev See {IERC20-approve}.
426      *
427      * Requirements:
428      *
429      * - `spender` cannot be the zero address.
430      */
431     function approve(address spender, uint256 amount) public virtual override returns (bool) {
432         _approve(_msgSender(), spender, amount);
433         return true;
434     }
435 
436     /**
437      * @dev See {IERC20-transferFrom}.
438      *
439      * Emits an {Approval} event indicating the updated allowance. This is not
440      * required by the EIP. See the note at the beginning of {ERC20}.
441      *
442      * Requirements:
443      *
444      * - `sender` and `recipient` cannot be the zero address.
445      * - `sender` must have a balance of at least `amount`.
446      * - the caller must have allowance for ``sender``'s tokens of at least
447      * `amount`.
448      */
449     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
450         _transfer(sender, recipient, amount);
451         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
452         return true;
453     }
454 
455     /**
456      * @dev Atomically increases the allowance granted to `spender` by the caller.
457      *
458      * This is an alternative to {approve} that can be used as a mitigation for
459      * problems described in {IERC20-approve}.
460      *
461      * Emits an {Approval} event indicating the updated allowance.
462      *
463      * Requirements:
464      *
465      * - `spender` cannot be the zero address.
466      */
467     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
468         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
469         return true;
470     }
471 
472     /**
473      * @dev Atomically decreases the allowance granted to `spender` by the caller.
474      *
475      * This is an alternative to {approve} that can be used as a mitigation for
476      * problems described in {IERC20-approve}.
477      *
478      * Emits an {Approval} event indicating the updated allowance.
479      *
480      * Requirements:
481      *
482      * - `spender` cannot be the zero address.
483      * - `spender` must have allowance for the caller of at least
484      * `subtractedValue`.
485      */
486     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
487         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
488         return true;
489     }
490 
491     /**
492      * @dev Moves tokens `amount` from `sender` to `recipient`.
493      *
494      * This is internal function is equivalent to {transfer}, and can be used to
495      * e.g. implement automatic token fees, slashing mechanisms, etc.
496      *
497      * Emits a {Transfer} event.
498      *
499      * Requirements:
500      *
501      * - `sender` cannot be the zero address.
502      * - `recipient` cannot be the zero address.
503      * - `sender` must have a balance of at least `amount`.
504      */
505     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
506         require(sender != address(0), "ERC20: transfer from the zero address");
507         require(recipient != address(0), "ERC20: transfer to the zero address");
508 
509         _beforeTokenTransfer(sender, recipient, amount);
510 
511         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
512         _balances[recipient] = _balances[recipient].add(amount);
513         emit Transfer(sender, recipient, amount);
514     }
515 
516     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
517      * the total supply.
518      *
519      * Emits a {Transfer} event with `from` set to the zero address.
520      *
521      * Requirements:
522      *
523      * - `to` cannot be the zero address.
524      */
525     function _mint(address account, uint256 amount) internal virtual {
526         require(account != address(0), "ERC20: mint to the zero address");
527 
528         _beforeTokenTransfer(address(0), account, amount);
529 
530         _totalSupply = _totalSupply.add(amount);
531         _balances[account] = _balances[account].add(amount);
532         emit Transfer(address(0), account, amount);
533     }
534 
535     /**
536      * @dev Destroys `amount` tokens from `account`, reducing the
537      * total supply.
538      *
539      * Emits a {Transfer} event with `to` set to the zero address.
540      *
541      * Requirements:
542      *
543      * - `account` cannot be the zero address.
544      * - `account` must have at least `amount` tokens.
545      */
546     function _burn(address account, uint256 amount) internal virtual {
547         require(account != address(0), "ERC20: burn from the zero address");
548 
549         _beforeTokenTransfer(account, address(0), amount);
550 
551         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
552         _totalSupply = _totalSupply.sub(amount);
553         emit Transfer(account, address(0), amount);
554     }
555 
556     /**
557      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
558      *
559      * This internal function is equivalent to `approve`, and can be used to
560      * e.g. set automatic allowances for certain subsystems, etc.
561      *
562      * Emits an {Approval} event.
563      *
564      * Requirements:
565      *
566      * - `owner` cannot be the zero address.
567      * - `spender` cannot be the zero address.
568      */
569     function _approve(address owner, address spender, uint256 amount) internal virtual {
570         require(owner != address(0), "ERC20: approve from the zero address");
571         require(spender != address(0), "ERC20: approve to the zero address");
572 
573         _allowances[owner][spender] = amount;
574         emit Approval(owner, spender, amount);
575     }
576 
577     /**
578      * @dev Sets {decimals} to a value other than the default one of 18.
579      *
580      * WARNING: This function should only be called from the constructor. Most
581      * applications that interact with token contracts will not expect
582      * {decimals} to ever change, and may work incorrectly if it does.
583      */
584     function _setupDecimals(uint8 decimals_) internal {
585         _decimals = decimals_;
586     }
587 
588     /**
589      * @dev Hook that is called before any transfer of tokens. This includes
590      * minting and burning.
591      *
592      * Calling conditions:
593      *
594      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
595      * will be to transferred to `to`.
596      * - when `from` is zero, `amount` tokens will be minted for `to`.
597      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
598      * - `from` and `to` are never both zero.
599      *
600      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
601      */
602     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
603 }