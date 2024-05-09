1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 
26 /**
27  * @dev Contract module which provides a basic access control mechanism, where
28  * there is an account (an owner) that can be granted exclusive access to
29  * specific functions.
30  *
31  * By default, the owner account will be the one that deploys the contract. This
32  * can later be changed with {transferOwnership}.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor() {
47         _transferOwnership(_msgSender());
48     }
49 
50     /**
51      * @dev Returns the address of the current owner.
52      */
53     function owner() public view virtual returns (address) {
54         return _owner;
55     }
56 
57     /**
58      * @dev Throws if called by any account other than the owner.
59      */
60     modifier onlyOwner() {
61         require(owner() == _msgSender(), "Ownable: caller is not the owner");
62         _;
63     }
64 
65     /**
66      * @dev Leaves the contract without owner. It will not be possible to call
67      * `onlyOwner` functions anymore. Can only be called by the current owner.
68      *
69      * NOTE: Renouncing ownership will leave the contract without an owner,
70      * thereby removing any functionality that is only available to the owner.
71      */
72     function renounceOwnership() public virtual onlyOwner {
73         _transferOwnership(address(0));
74     }
75 
76     /**
77      * @dev Transfers ownership of the contract to a new account (`newOwner`).
78      * Can only be called by the current owner.
79      */
80     function transferOwnership(address newOwner) public virtual onlyOwner {
81         require(newOwner != address(0), "Ownable: new owner is the zero address");
82         _transferOwnership(newOwner);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Internal function without access restriction.
88      */
89     function _transferOwnership(address newOwner) internal virtual {
90         address oldOwner = _owner;
91         _owner = newOwner;
92         emit OwnershipTransferred(oldOwner, newOwner);
93     }
94 }
95 
96 
97 /**
98  * @dev Interface of the ERC20 standard as defined in the EIP.
99  */
100 interface IERC20 {
101     /**
102      * @dev Returns the amount of tokens in existence.
103      */
104     function totalSupply() external view returns (uint256);
105 
106     /**
107      * @dev Returns the amount of tokens owned by `account`.
108      */
109     function balanceOf(address account) external view returns (uint256);
110 
111     /**
112      * @dev Moves `amount` tokens from the caller's account to `recipient`.
113      *
114      * Returns a boolean value indicating whether the operation succeeded.
115      *
116      * Emits a {Transfer} event.
117      */
118     function transfer(address recipient, uint256 amount) external returns (bool);
119 
120     /**
121      * @dev Returns the remaining number of tokens that `spender` will be
122      * allowed to spend on behalf of `owner` through {transferFrom}. This is
123      * zero by default.
124      *
125      * This value changes when {approve} or {transferFrom} are called.
126      */
127     function allowance(address owner, address spender) external view returns (uint256);
128 
129     /**
130      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * IMPORTANT: Beware that changing an allowance with this method brings the risk
135      * that someone may use both the old and the new allowance by unfortunate
136      * transaction ordering. One possible solution to mitigate this race
137      * condition is to first reduce the spender's allowance to 0 and set the
138      * desired value afterwards:
139      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140      *
141      * Emits an {Approval} event.
142      */
143     function approve(address spender, uint256 amount) external returns (bool);
144 
145     /**
146      * @dev Moves `amount` tokens from `sender` to `recipient` using the
147      * allowance mechanism. `amount` is then deducted from the caller's
148      * allowance.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * Emits a {Transfer} event.
153      */
154     function transferFrom(
155         address sender,
156         address recipient,
157         uint256 amount
158     ) external returns (bool);
159 
160     /**
161      * @dev Emitted when `value` tokens are moved from one account (`from`) to
162      * another (`to`).
163      *
164      * Note that `value` may be zero.
165      */
166     event Transfer(address indexed from, address indexed to, uint256 value);
167 
168     /**
169      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
170      * a call to {approve}. `value` is the new allowance.
171      */
172     event Approval(address indexed owner, address indexed spender, uint256 value);
173 }
174 
175 
176 /**
177  * @dev Interface for the optional metadata functions from the ERC20 standard.
178  *
179  * _Available since v4.1._
180  */
181 interface IERC20Metadata is IERC20 {
182     /**
183      * @dev Returns the name of the token.
184      */
185     function name() external view returns (string memory);
186 
187     /**
188      * @dev Returns the symbol of the token.
189      */
190     function symbol() external view returns (string memory);
191 
192     /**
193      * @dev Returns the decimals places of the token.
194      */
195     function decimals() external view returns (uint8);
196 }
197 
198 /**
199  * @dev Implementation of the {IERC20} interface.
200  *
201  * This implementation is agnostic to the way tokens are created. This means
202  * that a supply mechanism has to be added in a derived contract using {_mint}.
203  * For a generic mechanism see {ERC20PresetMinterPauser}.
204  *
205  * TIP: For a detailed writeup see our guide
206  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
207  * to implement supply mechanisms].
208  *
209  * We have followed general OpenZeppelin Contracts guidelines: functions revert
210  * instead returning `false` on failure. This behavior is nonetheless
211  * conventional and does not conflict with the expectations of ERC20
212  * applications.
213  *
214  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
215  * This allows applications to reconstruct the allowance for all accounts just
216  * by listening to said events. Other implementations of the EIP may not emit
217  * these events, as it isn't required by the specification.
218  *
219  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
220  * functions have been added to mitigate the well-known issues around setting
221  * allowances. See {IERC20-approve}.
222  */
223 
224 contract ERC20 is Context, IERC20, IERC20Metadata {
225     mapping(address => uint256) private _balances;
226 
227     mapping(address => mapping(address => uint256)) private _allowances;
228 
229     uint256 private _totalSupply;
230 
231     string private _name;
232     string private _symbol;
233 
234     /**
235      * @dev Sets the values for {name} and {symbol}.
236      *
237      * The default value of {decimals} is 18. To select a different value for
238      * {decimals} you should overload it.
239      *
240      * All two of these values are immutable: they can only be set once during
241      * construction.
242      */
243     constructor(string memory name_, string memory symbol_) {
244         _name = name_;
245         _symbol = symbol_;
246     }
247 
248     /**
249      * @dev Returns the name of the token.
250      */
251     function name() public view virtual override returns (string memory) {
252         return _name;
253     }
254 
255     /**
256      * @dev Returns the symbol of the token, usually a shorter version of the
257      * name.
258      */
259     function symbol() public view virtual override returns (string memory) {
260         return _symbol;
261     }
262 
263     /**
264      * @dev Returns the number of decimals used to get its user representation.
265      * For example, if `decimals` equals `2`, a balance of `505` tokens should
266      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
267      *
268      * Tokens usually opt for a value of 18, imitating the relationship between
269      * Ether and Wei. This is the value {ERC20} uses, unless this function is
270      * overridden;
271      *
272      * NOTE: This information is only used for _display_ purposes: it in
273      * no way affects any of the arithmetic of the contract, including
274      * {IERC20-balanceOf} and {IERC20-transfer}.
275      */
276     function decimals() public view virtual override returns (uint8) {
277         return 18;
278     }
279 
280     /**
281      * @dev See {IERC20-totalSupply}.
282      */
283     function totalSupply() public view virtual override returns (uint256) {
284         return _totalSupply;
285     }
286 
287     /**
288      * @dev See {IERC20-balanceOf}.
289      */
290     function balanceOf(address account) public view virtual override returns (uint256) {
291         return _balances[account];
292     }
293 
294     /**
295      * @dev See {IERC20-transfer}.
296      *
297      * Requirements:
298      *
299      * - `recipient` cannot be the zero address.
300      * - the caller must have a balance of at least `amount`.
301      */
302     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
303         _transfer(_msgSender(), recipient, amount);
304         return true;
305     }
306 
307     /**
308      * @dev See {IERC20-allowance}.
309      */
310     function allowance(address owner, address spender) public view virtual override returns (uint256) {
311         return _allowances[owner][spender];
312     }
313 
314     /**
315      * @dev See {IERC20-approve}.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      */
321     function approve(address spender, uint256 amount) public virtual override returns (bool) {
322         _approve(_msgSender(), spender, amount);
323         return true;
324     }
325 
326     /**
327      * @dev See {IERC20-transferFrom}.
328      *
329      * Emits an {Approval} event indicating the updated allowance. This is not
330      * required by the EIP. See the note at the beginning of {ERC20}.
331      *
332      * Requirements:
333      *
334      * - `sender` and `recipient` cannot be the zero address.
335      * - `sender` must have a balance of at least `amount`.
336      * - the caller must have allowance for ``sender``'s tokens of at least
337      * `amount`.
338      */
339     function transferFrom(
340         address sender,
341         address recipient,
342         uint256 amount
343     ) public virtual override returns (bool) {
344         _transfer(sender, recipient, amount);
345 
346         uint256 currentAllowance = _allowances[sender][_msgSender()];
347         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
348         unchecked {
349             _approve(sender, _msgSender(), currentAllowance - amount);
350         }
351 
352         return true;
353     }
354 
355     /**
356      * @dev Atomically increases the allowance granted to `spender` by the caller.
357      *
358      * This is an alternative to {approve} that can be used as a mitigation for
359      * problems described in {IERC20-approve}.
360      *
361      * Emits an {Approval} event indicating the updated allowance.
362      *
363      * Requirements:
364      *
365      * - `spender` cannot be the zero address.
366      */
367     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
368         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
369         return true;
370     }
371 
372     /**
373      * @dev Atomically decreases the allowance granted to `spender` by the caller.
374      *
375      * This is an alternative to {approve} that can be used as a mitigation for
376      * problems described in {IERC20-approve}.
377      *
378      * Emits an {Approval} event indicating the updated allowance.
379      *
380      * Requirements:
381      *
382      * - `spender` cannot be the zero address.
383      * - `spender` must have allowance for the caller of at least
384      * `subtractedValue`.
385      */
386     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
387         uint256 currentAllowance = _allowances[_msgSender()][spender];
388         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
389         unchecked {
390             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
391         }
392 
393         return true;
394     }
395 
396     /**
397      * @dev Moves `amount` of tokens from `sender` to `recipient`.
398      *
399      * This internal function is equivalent to {transfer}, and can be used to
400      * e.g. implement automatic token fees, slashing mechanisms, etc.
401      *
402      * Emits a {Transfer} event.
403      *
404      * Requirements:
405      *
406      * - `sender` cannot be the zero address.
407      * - `recipient` cannot be the zero address.
408      * - `sender` must have a balance of at least `amount`.
409      */
410     function _transfer(
411         address sender,
412         address recipient,
413         uint256 amount
414     ) internal virtual {
415         require(sender != address(0), "ERC20: transfer from the zero address");
416         require(recipient != address(0), "ERC20: transfer to the zero address");
417 
418         _beforeTokenTransfer(sender, recipient, amount);
419 
420         uint256 senderBalance = _balances[sender];
421         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
422         unchecked {
423             _balances[sender] = senderBalance - amount;
424         }
425         _balances[recipient] += amount;
426 
427         emit Transfer(sender, recipient, amount);
428 
429         _afterTokenTransfer(sender, recipient, amount);
430     }
431 
432     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
433      * the total supply.
434      *
435      * Emits a {Transfer} event with `from` set to the zero address.
436      *
437      * Requirements:
438      *
439      * - `account` cannot be the zero address.
440      */
441     function _mint(address account, uint256 amount) internal virtual {
442         require(account != address(0), "ERC20: mint to the zero address");
443 
444         _beforeTokenTransfer(address(0), account, amount);
445 
446         _totalSupply += amount;
447         _balances[account] += amount;
448         emit Transfer(address(0), account, amount);
449 
450         _afterTokenTransfer(address(0), account, amount);
451     }
452 
453     /**
454      * @dev Destroys `amount` tokens from `account`, reducing the
455      * total supply.
456      *
457      * Emits a {Transfer} event with `to` set to the zero address.
458      *
459      * Requirements:
460      *
461      * - `account` cannot be the zero address.
462      * - `account` must have at least `amount` tokens.
463      */
464     function _burn(address account, uint256 amount) internal virtual {
465         require(account != address(0), "ERC20: burn from the zero address");
466 
467         _beforeTokenTransfer(account, address(0), amount);
468 
469         uint256 accountBalance = _balances[account];
470         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
471         unchecked {
472             _balances[account] = accountBalance - amount;
473         }
474         _totalSupply -= amount;
475 
476         emit Transfer(account, address(0), amount);
477 
478         _afterTokenTransfer(account, address(0), amount);
479     }
480 
481     /**
482      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
483      *
484      * This internal function is equivalent to `approve`, and can be used to
485      * e.g. set automatic allowances for certain subsystems, etc.
486      *
487      * Emits an {Approval} event.
488      *
489      * Requirements:
490      *
491      * - `owner` cannot be the zero address.
492      * - `spender` cannot be the zero address.
493      */
494     function _approve(
495         address owner,
496         address spender,
497         uint256 amount
498     ) internal virtual {
499         require(owner != address(0), "ERC20: approve from the zero address");
500         require(spender != address(0), "ERC20: approve to the zero address");
501 
502         _allowances[owner][spender] = amount;
503         emit Approval(owner, spender, amount);
504     }
505 
506     /**
507      * @dev Hook that is called before any transfer of tokens. This includes
508      * minting and burning.
509      *
510      * Calling conditions:
511      *
512      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
513      * will be transferred to `to`.
514      * - when `from` is zero, `amount` tokens will be minted for `to`.
515      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
516      * - `from` and `to` are never both zero.
517      *
518      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
519      */
520     function _beforeTokenTransfer(
521         address from,
522         address to,
523         uint256 amount
524     ) internal virtual {}
525 
526     /**
527      * @dev Hook that is called after any transfer of tokens. This includes
528      * minting and burning.
529      *
530      * Calling conditions:
531      *
532      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
533      * has been transferred to `to`.
534      * - when `from` is zero, `amount` tokens have been minted for `to`.
535      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
536      * - `from` and `to` are never both zero.
537      *
538      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
539      */
540     function _afterTokenTransfer(
541         address from,
542         address to,
543         uint256 amount
544     ) internal virtual {}
545 }
546 
547 
548 contract POOPOOToken is Ownable, ERC20 {
549     bool public limited;
550     uint256 public maxHoldingAmount;
551     uint256 public minHoldingAmount;
552     address public uniswapV2Pair;
553 
554     constructor() ERC20("Poopoo", "POOPOO") {
555         _mint(msg.sender, 420_690_000_000_000 * 10**18);
556     }
557 
558 
559     function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
560         limited = _limited;
561         uniswapV2Pair = _uniswapV2Pair;
562         maxHoldingAmount = _maxHoldingAmount;
563         minHoldingAmount = _minHoldingAmount;
564     }
565 
566     function _beforeTokenTransfer(
567         address from,
568         address to,
569         uint256 amount
570     ) override internal virtual {
571         if (uniswapV2Pair == address(0)) {
572             require(from == owner() || to == owner(), "trading is not started");
573             return;
574         }
575 
576         if (limited && from == uniswapV2Pair) {
577             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
578         }
579     }
580 
581     function burn(uint256 value) external {
582         _burn(msg.sender, value);
583     }
584 }