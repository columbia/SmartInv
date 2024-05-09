1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP.
5  */
6 interface IERC20 {
7     /**
8      * @dev Returns the amount of tokens in existence.
9      */
10     function totalSupply() external view returns (uint256);
11 
12     /**
13      * @dev Returns the amount of tokens owned by `account`.
14      */
15     function balanceOf(address account) external view returns (uint256);
16 
17     /**
18      * @dev Moves `amount` tokens from the caller's account to `recipient`.
19      *
20      * Returns a boolean value indicating whether the operation succeeded.
21      *
22      * Emits a {Transfer} event.
23      */
24     function transfer(address recipient, uint256 amount) external returns (bool);
25 
26     /**
27      * @dev Returns the remaining number of tokens that `spender` will be
28      * allowed to spend on behalf of `owner` through {transferFrom}. This is
29      * zero by default.
30      *
31      * This value changes when {approve} or {transferFrom} are called.
32      */
33     function allowance(address owner, address spender) external view returns (uint256);
34 
35     /**
36      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * IMPORTANT: Beware that changing an allowance with this method brings the risk
41      * that someone may use both the old and the new allowance by unfortunate
42      * transaction ordering. One possible solution to mitigate this race
43      * condition is to first reduce the spender's allowance to 0 and set the
44      * desired value afterwards:
45      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
46      *
47      * Emits an {Approval} event.
48      */
49     function approve(address spender, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Moves `amount` tokens from `sender` to `recipient` using the
53      * allowance mechanism. `amount` is then deducted from the caller's
54      * allowance.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transferFrom(
61         address sender,
62         address recipient,
63         uint256 amount
64     ) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 /**
82  * @dev Interface for the optional metadata functions from the ERC20 standard.
83  *
84  * _Available since v4.1._
85  */
86 interface IERC20Metadata is IERC20 {
87     /**
88      * @dev Returns the name of the token.
89      */
90     function name() external view returns (string memory);
91 
92     /**
93      * @dev Returns the symbol of the token.
94      */
95     function symbol() external view returns (string memory);
96 
97     /**
98      * @dev Returns the decimals places of the token.
99      */
100     function decimals() external view returns (uint8);
101 }
102 
103 /*
104  * @dev Provides information about the current execution context, including the
105  * sender of the transaction and its data. While these are generally available
106  * via msg.sender and msg.data, they should not be accessed in such a direct
107  * manner, since when dealing with meta-transactions the account sending and
108  * paying for execution may not be the actual sender (as far as an application
109  * is concerned).
110  *
111  * This contract is only required for intermediate, library-like contracts.
112  */
113 abstract contract Context {
114     function _msgSender() internal view virtual returns (address) {
115         return msg.sender;
116     }
117 
118     function _msgData() internal view virtual returns (bytes calldata) {
119         return msg.data;
120     }
121 }
122 
123 /**
124  * @dev Implementation of the {IERC20} interface.
125  *
126  * This implementation is agnostic to the way tokens are created. This means
127  * that a supply mechanism has to be added in a derived contract using {_mint}.
128  * For a generic mechanism see {ERC20PresetMinterPauser}.
129  *
130  * TIP: For a detailed writeup see our guide
131  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
132  * to implement supply mechanisms].
133  *
134  * We have followed general OpenZeppelin guidelines: functions revert instead
135  * of returning `false` on failure. This behavior is nonetheless conventional
136  * and does not conflict with the expectations of ERC20 applications.
137  *
138  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
139  * This allows applications to reconstruct the allowance for all accounts just
140  * by listening to said events. Other implementations of the EIP may not emit
141  * these events, as it isn't required by the specification.
142  *
143  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
144  * functions have been added to mitigate the well-known issues around setting
145  * allowances. See {IERC20-approve}.
146  */
147 contract ERC20 is Context, IERC20, IERC20Metadata {
148     mapping(address => uint256) private _balances;
149 
150     mapping(address => mapping(address => uint256)) private _allowances;
151 
152     uint256 private _totalSupply;
153 
154     string private _name;
155     string private _symbol;
156 
157     /**
158      * @dev Sets the values for {name} and {symbol}.
159      *
160      * The default value of {decimals} is 18. To select a different value for
161      * {decimals} you should overload it.
162      *
163      * All two of these values are immutable: they can only be set once during
164      * construction.
165      */
166     constructor(string memory name_, string memory symbol_) {
167         _name = name_;
168         _symbol = symbol_;
169     }
170 
171     /**
172      * @dev Returns the name of the token.
173      */
174     function name() public view virtual override returns (string memory) {
175         return _name;
176     }
177 
178     /**
179      * @dev Returns the symbol of the token, usually a shorter version of the
180      * name.
181      */
182     function symbol() public view virtual override returns (string memory) {
183         return _symbol;
184     }
185 
186     /**
187      * @dev Returns the number of decimals used to get its user representation.
188      * For example, if `decimals` equals `2`, a balance of `505` tokens should
189      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
190      *
191      * Tokens usually opt for a value of 18, imitating the relationship between
192      * Ether and Wei. This is the value {ERC20} uses, unless this function is
193      * overridden;
194      *
195      * NOTE: This information is only used for _display_ purposes: it in
196      * no way affects any of the arithmetic of the contract, including
197      * {IERC20-balanceOf} and {IERC20-transfer}.
198      */
199     function decimals() public view virtual override returns (uint8) {
200         return 18;
201     }
202 
203     /**
204      * @dev See {IERC20-totalSupply}.
205      */
206     function totalSupply() public view virtual override returns (uint256) {
207         return _totalSupply;
208     }
209 
210     /**
211      * @dev See {IERC20-balanceOf}.
212      */
213     function balanceOf(address account) public view virtual override returns (uint256) {
214         return _balances[account];
215     }
216 
217     /**
218      * @dev See {IERC20-transfer}.
219      *
220      * Requirements:
221      *
222      * - `recipient` cannot be the zero address.
223      * - the caller must have a balance of at least `amount`.
224      */
225     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
226         _transfer(_msgSender(), recipient, amount);
227         return true;
228     }
229 
230     /**
231      * @dev See {IERC20-allowance}.
232      */
233     function allowance(address owner, address spender) public view virtual override returns (uint256) {
234         return _allowances[owner][spender];
235     }
236 
237     /**
238      * @dev See {IERC20-approve}.
239      *
240      * Requirements:
241      *
242      * - `spender` cannot be the zero address.
243      */
244     function approve(address spender, uint256 amount) public virtual override returns (bool) {
245         _approve(_msgSender(), spender, amount);
246         return true;
247     }
248 
249     /**
250      * @dev See {IERC20-transferFrom}.
251      *
252      * Emits an {Approval} event indicating the updated allowance. This is not
253      * required by the EIP. See the note at the beginning of {ERC20}.
254      *
255      * Requirements:
256      *
257      * - `sender` and `recipient` cannot be the zero address.
258      * - `sender` must have a balance of at least `amount`.
259      * - the caller must have allowance for ``sender``'s tokens of at least
260      * `amount`.
261      */
262     function transferFrom(
263         address sender,
264         address recipient,
265         uint256 amount
266     ) public virtual override returns (bool) {
267         _transfer(sender, recipient, amount);
268 
269         uint256 currentAllowance = _allowances[sender][_msgSender()];
270         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
271         unchecked {
272             _approve(sender, _msgSender(), currentAllowance - amount);
273         }
274 
275         return true;
276     }
277 
278     /**
279      * @dev Atomically increases the allowance granted to `spender` by the caller.
280      *
281      * This is an alternative to {approve} that can be used as a mitigation for
282      * problems described in {IERC20-approve}.
283      *
284      * Emits an {Approval} event indicating the updated allowance.
285      *
286      * Requirements:
287      *
288      * - `spender` cannot be the zero address.
289      */
290     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
291         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
292         return true;
293     }
294 
295     /**
296      * @dev Atomically decreases the allowance granted to `spender` by the caller.
297      *
298      * This is an alternative to {approve} that can be used as a mitigation for
299      * problems described in {IERC20-approve}.
300      *
301      * Emits an {Approval} event indicating the updated allowance.
302      *
303      * Requirements:
304      *
305      * - `spender` cannot be the zero address.
306      * - `spender` must have allowance for the caller of at least
307      * `subtractedValue`.
308      */
309     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
310         uint256 currentAllowance = _allowances[_msgSender()][spender];
311         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
312         unchecked {
313             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
314         }
315 
316         return true;
317     }
318 
319     /**
320      * @dev Moves `amount` of tokens from `sender` to `recipient`.
321      *
322      * This internal function is equivalent to {transfer}, and can be used to
323      * e.g. implement automatic token fees, slashing mechanisms, etc.
324      *
325      * Emits a {Transfer} event.
326      *
327      * Requirements:
328      *
329      * - `sender` cannot be the zero address.
330      * - `recipient` cannot be the zero address.
331      * - `sender` must have a balance of at least `amount`.
332      */
333     function _transfer(
334         address sender,
335         address recipient,
336         uint256 amount
337     ) internal virtual {
338         require(sender != address(0), "ERC20: transfer from the zero address");
339         require(recipient != address(0), "ERC20: transfer to the zero address");
340 
341         _beforeTokenTransfer(sender, recipient, amount);
342 
343         uint256 senderBalance = _balances[sender];
344         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
345         unchecked {
346             _balances[sender] = senderBalance - amount;
347         }
348         _balances[recipient] += amount;
349 
350         emit Transfer(sender, recipient, amount);
351 
352         _afterTokenTransfer(sender, recipient, amount);
353     }
354 
355     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
356      * the total supply.
357      *
358      * Emits a {Transfer} event with `from` set to the zero address.
359      *
360      * Requirements:
361      *
362      * - `account` cannot be the zero address.
363      */
364     function _mint(address account, uint256 amount) internal virtual {
365         require(account != address(0), "ERC20: mint to the zero address");
366 
367         _beforeTokenTransfer(address(0), account, amount);
368 
369         _totalSupply += amount;
370         _balances[account] += amount;
371         emit Transfer(address(0), account, amount);
372 
373         _afterTokenTransfer(address(0), account, amount);
374     }
375 
376     /**
377      * @dev Destroys `amount` tokens from `account`, reducing the
378      * total supply.
379      *
380      * Emits a {Transfer} event with `to` set to the zero address.
381      *
382      * Requirements:
383      *
384      * - `account` cannot be the zero address.
385      * - `account` must have at least `amount` tokens.
386      */
387     function _burn(address account, uint256 amount) internal virtual {
388         require(account != address(0), "ERC20: burn from the zero address");
389 
390         _beforeTokenTransfer(account, address(0), amount);
391 
392         uint256 accountBalance = _balances[account];
393         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
394         unchecked {
395             _balances[account] = accountBalance - amount;
396         }
397         _totalSupply -= amount;
398 
399         emit Transfer(account, address(0), amount);
400 
401         _afterTokenTransfer(account, address(0), amount);
402     }
403 
404     /**
405      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
406      *
407      * This internal function is equivalent to `approve`, and can be used to
408      * e.g. set automatic allowances for certain subsystems, etc.
409      *
410      * Emits an {Approval} event.
411      *
412      * Requirements:
413      *
414      * - `owner` cannot be the zero address.
415      * - `spender` cannot be the zero address.
416      */
417     function _approve(
418         address owner,
419         address spender,
420         uint256 amount
421     ) internal virtual {
422         require(owner != address(0), "ERC20: approve from the zero address");
423         require(spender != address(0), "ERC20: approve to the zero address");
424 
425         _allowances[owner][spender] = amount;
426         emit Approval(owner, spender, amount);
427     }
428 
429     /**
430      * @dev Hook that is called before any transfer of tokens. This includes
431      * minting and burning.
432      *
433      * Calling conditions:
434      *
435      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
436      * will be transferred to `to`.
437      * - when `from` is zero, `amount` tokens will be minted for `to`.
438      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
439      * - `from` and `to` are never both zero.
440      *
441      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
442      */
443     function _beforeTokenTransfer(
444         address from,
445         address to,
446         uint256 amount
447     ) internal virtual {}
448 
449     /**
450      * @dev Hook that is called after any transfer of tokens. This includes
451      * minting and burning.
452      *
453      * Calling conditions:
454      *
455      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
456      * has been transferred to `to`.
457      * - when `from` is zero, `amount` tokens have been minted for `to`.
458      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
459      * - `from` and `to` are never both zero.
460      *
461      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
462      */
463     function _afterTokenTransfer(
464         address from,
465         address to,
466         uint256 amount
467     ) internal virtual {}
468 }
469 
470 /**
471  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
472  */
473 abstract contract ERC20Capped is ERC20 {
474     uint256 private immutable _cap;
475 
476     /**
477      * @dev Sets the value of the `cap`. This value is immutable, it can only be
478      * set once during construction.
479      */
480     constructor(uint256 cap_) {
481         require(cap_ > 0, "ERC20Capped: cap is 0");
482         _cap = cap_;
483     }
484 
485     /**
486      * @dev Returns the cap on the token's total supply.
487      */
488     function cap() public view virtual returns (uint256) {
489         return _cap;
490     }
491 
492     /**
493      * @dev See {ERC20-_mint}.
494      */
495     function _mint(address account, uint256 amount) internal virtual override {
496         require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
497         super._mint(account, amount);
498     }
499 }
500 
501 /**
502  * @dev Extension of {ERC20} that allows token holders to destroy both their own
503  * tokens and those that they have an allowance for, in a way that can be
504  * recognized off-chain (via event analysis).
505  */
506 abstract contract ERC20Burnable is Context, ERC20 {
507     /**
508      * @dev Destroys `amount` tokens from the caller.
509      *
510      * See {ERC20-_burn}.
511      */
512     function burn(uint256 amount) public virtual {
513         _burn(_msgSender(), amount);
514     }
515 
516     /**
517      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
518      * allowance.
519      *
520      * See {ERC20-_burn} and {ERC20-allowance}.
521      *
522      * Requirements:
523      *
524      * - the caller must have allowance for ``accounts``'s tokens of at least
525      * `amount`.
526      */
527     function burnFrom(address account, uint256 amount) public virtual {
528         uint256 currentAllowance = allowance(account, _msgSender());
529         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
530         unchecked {
531             _approve(account, _msgSender(), currentAllowance - amount);
532         }
533         _burn(account, amount);
534     }
535 }
536 
537 /**
538  * @dev Contract module which provides a basic access control mechanism, where
539  * there is an account (an owner) that can be granted exclusive access to
540  * specific functions.
541  *
542  * By default, the owner account will be the one that deploys the contract. This
543  * can later be changed with {transferOwnership}.
544  *
545  * This module is used through inheritance. It will make available the modifier
546  * `onlyOwner`, which can be applied to your functions to restrict their use to
547  * the owner.
548  */
549 abstract contract Ownable is Context {
550     address private _owner;
551 
552     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
553 
554     /**
555      * @dev Initializes the contract setting the deployer as the initial owner.
556      */
557     constructor() {
558         _setOwner(_msgSender());
559     }
560 
561     /**
562      * @dev Returns the address of the current owner.
563      */
564     function owner() public view virtual returns (address) {
565         return _owner;
566     }
567 
568     /**
569      * @dev Throws if called by any account other than the owner.
570      */
571     modifier onlyOwner() {
572         require(owner() == _msgSender(), "Ownable: caller is not the owner");
573         _;
574     }
575 
576     /**
577      * @dev Leaves the contract without owner. It will not be possible to call
578      * `onlyOwner` functions anymore. Can only be called by the current owner.
579      *
580      * NOTE: Renouncing ownership will leave the contract without an owner,
581      * thereby removing any functionality that is only available to the owner.
582      */
583     function renounceOwnership() public virtual onlyOwner {
584         _setOwner(address(0));
585     }
586 
587     /**
588      * @dev Transfers ownership of the contract to a new account (`newOwner`).
589      * Can only be called by the current owner.
590      */
591     function transferOwnership(address newOwner) public virtual onlyOwner {
592         require(newOwner != address(0), "Ownable: new owner is the zero address");
593         _setOwner(newOwner);
594     }
595 
596     function _setOwner(address newOwner) private {
597         address oldOwner = _owner;
598         _owner = newOwner;
599         emit OwnershipTransferred(oldOwner, newOwner);
600     }
601 }
602 
603 contract NKCLClassic is ERC20, ERC20Burnable, ERC20Capped, Ownable {
604     constructor() ERC20("NKCL Classic", "NKCLC") ERC20Capped(21000000 * 10 ** uint256(decimals())) Ownable(){
605     }
606 
607     function _mint(address account, uint256 amount) internal override(ERC20, ERC20Capped) {
608         super._mint(account, amount);
609     }
610 
611     function mint(address account, uint256 amount) public onlyOwner{
612         _mint(account, amount);
613     }
614     
615     function renounceOwnership() public override onlyOwner{
616         revert("disabled");
617     }
618 }