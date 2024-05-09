1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes calldata) {
12         return msg.data;
13     }
14 }
15 
16 
17 abstract contract Ownable is Context {
18     address private _owner;
19 
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22     /**
23      * @dev Initializes the contract setting the deployer as the initial owner.
24      */
25     constructor() {
26         _transferOwnership(_msgSender());
27     }
28 
29     /**
30      * @dev Returns the address of the current owner.
31      */
32     function owner() public view virtual returns (address) {
33         return _owner;
34     }
35 
36     /**
37      * @dev Throws if called by any account other than the owner.
38      */
39     modifier onlyOwner() {
40         require(owner() == _msgSender(), "Ownable: caller is not the owner");
41         _;
42     }
43 
44     /**
45      * @dev Leaves the contract without owner. It will not be possible to call
46      * `onlyOwner` functions anymore. Can only be called by the current owner.
47      *
48      * NOTE: Renouncing ownership will leave the contract without an owner,
49      * thereby removing any functionality that is only available to the owner.
50      */
51     function renounceOwnership() public virtual onlyOwner {
52         _transferOwnership(address(0));
53     }
54 
55     /**
56      * @dev Transfers ownership of the contract to a new account (`newOwner`).
57      * Can only be called by the current owner.
58      */
59     function transferOwnership(address newOwner) public virtual onlyOwner {
60         require(newOwner != address(0), "Ownable: new owner is the zero address");
61         _transferOwnership(newOwner);
62     }
63 
64     /**
65      * @dev Transfers ownership of the contract to a new account (`newOwner`).
66      * Internal function without access restriction.
67      */
68     function _transferOwnership(address newOwner) internal virtual {
69         address oldOwner = _owner;
70         _owner = newOwner;
71         emit OwnershipTransferred(oldOwner, newOwner);
72     }
73 }
74 
75 
76 interface IERC20 {
77     /**
78      * @dev Returns the amount of tokens in existence.
79      */
80     function totalSupply() external view returns (uint256);
81 
82     /**
83      * @dev Returns the amount of tokens owned by `account`.
84      */
85     function balanceOf(address account) external view returns (uint256);
86 
87     /**
88      * @dev Moves `amount` tokens from the caller's account to `recipient`.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transfer(address recipient, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Returns the remaining number of tokens that `spender` will be
98      * allowed to spend on behalf of `owner` through {transferFrom}. This is
99      * zero by default.
100      *
101      * This value changes when {approve} or {transferFrom} are called.
102      */
103     function allowance(address owner, address spender) external view returns (uint256);
104 
105     /**
106      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
107      *
108      * Returns a boolean value indicating whether the operation succeeded.
109      *
110      * IMPORTANT: Beware that changing an allowance with this method brings the risk
111      * that someone may use both the old and the new allowance by unfortunate
112      * transaction ordering. One possible solution to mitigate this race
113      * condition is to first reduce the spender's allowance to 0 and set the
114      * desired value afterwards:
115      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
116      *
117      * Emits an {Approval} event.
118      */
119     function approve(address spender, uint256 amount) external returns (bool);
120 
121     /**
122      * @dev Moves `amount` tokens from `sender` to `recipient` using the
123      * allowance mechanism. `amount` is then deducted from the caller's
124      * allowance.
125      *
126      * Returns a boolean value indicating whether the operation succeeded.
127      *
128      * Emits a {Transfer} event.
129      */
130     function transferFrom(
131         address sender,
132         address recipient,
133         uint256 amount
134     ) external returns (bool);
135 
136     /**
137      * @dev Emitted when `value` tokens are moved from one account (`from`) to
138      * another (`to`).
139      *
140      * Note that `value` may be zero.
141      */
142     event Transfer(address indexed from, address indexed to, uint256 value);
143 
144     /**
145      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
146      * a call to {approve}. `value` is the new allowance.
147      */
148     event Approval(address indexed owner, address indexed spender, uint256 value);
149 }
150 
151 
152 interface IERC20Metadata is IERC20 {
153     /**
154      * @dev Returns the name of the token.
155      */
156     function name() external view returns (string memory);
157 
158     /**
159      * @dev Returns the symbol of the token.
160      */
161     function symbol() external view returns (string memory);
162 
163     /**
164      * @dev Returns the decimals places of the token.
165      */
166     function decimals() external view returns (uint8);
167 }
168 
169 contract ERC20 is Context, IERC20, IERC20Metadata {
170     mapping(address => uint256) private _balances;
171 
172     mapping(address => mapping(address => uint256)) private _allowances;
173 
174     uint256 private _totalSupply;
175 
176     string private _name;
177     string private _symbol;
178 
179     /**
180      * @dev Sets the values for {name} and {symbol}.
181      *
182      * The default value of {decimals} is 18. To select a different value for
183      * {decimals} you should overload it.
184      *
185      * All two of these values are immutable: they can only be set once during
186      * construction.
187      */
188     constructor(string memory name_, string memory symbol_) {
189         _name = name_;
190         _symbol = symbol_;
191     }
192 
193     /**
194      * @dev Returns the name of the token.
195      */
196     function name() public view virtual override returns (string memory) {
197         return _name;
198     }
199 
200     /**
201      * @dev Returns the symbol of the token, usually a shorter version of the
202      * name.
203      */
204     function symbol() public view virtual override returns (string memory) {
205         return _symbol;
206     }
207 
208     /**
209      * @dev Returns the number of decimals used to get its user representation.
210      * For example, if `decimals` equals `2`, a balance of `505` tokens should
211      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
212      *
213      * Tokens usually opt for a value of 18, imitating the relationship between
214      * Ether and Wei. This is the value {ERC20} uses, unless this function is
215      * overridden;
216      *
217      * NOTE: This information is only used for _display_ purposes: it in
218      * no way affects any of the arithmetic of the contract, including
219      * {IERC20-balanceOf} and {IERC20-transfer}.
220      */
221     function decimals() public view virtual override returns (uint8) {
222         return 18;
223     }
224 
225     /**
226      * @dev See {IERC20-totalSupply}.
227      */
228     function totalSupply() public view virtual override returns (uint256) {
229         return _totalSupply;
230     }
231 
232     /**
233      * @dev See {IERC20-balanceOf}.
234      */
235     function balanceOf(address account) public view virtual override returns (uint256) {
236         return _balances[account];
237     }
238 
239     /**
240      * @dev See {IERC20-transfer}.
241      *
242      * Requirements:
243      *
244      * - `recipient` cannot be the zero address.
245      * - the caller must have a balance of at least `amount`.
246      */
247     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
248         _transfer(_msgSender(), recipient, amount);
249         return true;
250     }
251 
252     /**
253      * @dev See {IERC20-allowance}.
254      */
255     function allowance(address owner, address spender) public view virtual override returns (uint256) {
256         return _allowances[owner][spender];
257     }
258 
259     /**
260      * @dev See {IERC20-approve}.
261      *
262      * Requirements:
263      *
264      * - `spender` cannot be the zero address.
265      */
266     function approve(address spender, uint256 amount) public virtual override returns (bool) {
267         _approve(_msgSender(), spender, amount);
268         return true;
269     }
270 
271     /**
272      * @dev See {IERC20-transferFrom}.
273      *
274      * Emits an {Approval} event indicating the updated allowance. This is not
275      * required by the EIP. See the note at the beginning of {ERC20}.
276      *
277      * Requirements:
278      *
279      * - `sender` and `recipient` cannot be the zero address.
280      * - `sender` must have a balance of at least `amount`.
281      * - the caller must have allowance for ``sender``'s tokens of at least
282      * `amount`.
283      */
284     function transferFrom(
285         address sender,
286         address recipient,
287         uint256 amount
288     ) public virtual override returns (bool) {
289         _transfer(sender, recipient, amount);
290 
291         uint256 currentAllowance = _allowances[sender][_msgSender()];
292         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
293         unchecked {
294             _approve(sender, _msgSender(), currentAllowance - amount);
295         }
296 
297         return true;
298     }
299 
300     /**
301      * @dev Atomically increases the allowance granted to `spender` by the caller.
302      *
303      * This is an alternative to {approve} that can be used as a mitigation for
304      * problems described in {IERC20-approve}.
305      *
306      * Emits an {Approval} event indicating the updated allowance.
307      *
308      * Requirements:
309      *
310      * - `spender` cannot be the zero address.
311      */
312     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
313         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
314         return true;
315     }
316 
317     /**
318      * @dev Atomically decreases the allowance granted to `spender` by the caller.
319      *
320      * This is an alternative to {approve} that can be used as a mitigation for
321      * problems described in {IERC20-approve}.
322      *
323      * Emits an {Approval} event indicating the updated allowance.
324      *
325      * Requirements:
326      *
327      * - `spender` cannot be the zero address.
328      * - `spender` must have allowance for the caller of at least
329      * `subtractedValue`.
330      */
331     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
332         uint256 currentAllowance = _allowances[_msgSender()][spender];
333         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
334         unchecked {
335             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
336         }
337 
338         return true;
339     }
340 
341     /**
342      * @dev Moves `amount` of tokens from `sender` to `recipient`.
343      *
344      * This internal function is equivalent to {transfer}, and can be used to
345      * e.g. implement automatic token fees, slashing mechanisms, etc.
346      *
347      * Emits a {Transfer} event.
348      *
349      * Requirements:
350      *
351      * - `sender` cannot be the zero address.
352      * - `recipient` cannot be the zero address.
353      * - `sender` must have a balance of at least `amount`.
354      */
355     function _transfer(
356         address sender,
357         address recipient,
358         uint256 amount
359     ) internal virtual {
360         require(sender != address(0), "ERC20: transfer from the zero address");
361         require(recipient != address(0), "ERC20: transfer to the zero address");
362 
363         _beforeTokenTransfer(sender, recipient, amount);
364 
365         uint256 senderBalance = _balances[sender];
366         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
367         unchecked {
368             _balances[sender] = senderBalance - amount;
369         }
370         _balances[recipient] += amount;
371 
372         emit Transfer(sender, recipient, amount);
373 
374         _afterTokenTransfer(sender, recipient, amount);
375     }
376 
377     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
378      * the total supply.
379      *
380      * Emits a {Transfer} event with `from` set to the zero address.
381      *
382      * Requirements:
383      *
384      * - `account` cannot be the zero address.
385      */
386     function _mint(address account, uint256 amount) internal virtual {
387         require(account != address(0), "ERC20: mint to the zero address");
388 
389         _beforeTokenTransfer(address(0), account, amount);
390 
391         _totalSupply += amount;
392         _balances[account] += amount;
393         emit Transfer(address(0), account, amount);
394 
395         _afterTokenTransfer(address(0), account, amount);
396     }
397 
398     /**
399      * @dev Destroys `amount` tokens from `account`, reducing the
400      * total supply.
401      *
402      * Emits a {Transfer} event with `to` set to the zero address.
403      *
404      * Requirements:
405      *
406      * - `account` cannot be the zero address.
407      * - `account` must have at least `amount` tokens.
408      */
409     function _burn(address account, uint256 amount) internal virtual {
410         require(account != address(0), "ERC20: burn from the zero address");
411 
412         _beforeTokenTransfer(account, address(0), amount);
413 
414         uint256 accountBalance = _balances[account];
415         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
416         unchecked {
417             _balances[account] = accountBalance - amount;
418         }
419         _totalSupply -= amount;
420 
421         emit Transfer(account, address(0), amount);
422 
423         _afterTokenTransfer(account, address(0), amount);
424     }
425 
426     /**
427      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
428      *
429      * This internal function is equivalent to `approve`, and can be used to
430      * e.g. set automatic allowances for certain subsystems, etc.
431      *
432      * Emits an {Approval} event.
433      *
434      * Requirements:
435      *
436      * - `owner` cannot be the zero address.
437      * - `spender` cannot be the zero address.
438      */
439     function _approve(
440         address owner,
441         address spender,
442         uint256 amount
443     ) internal virtual {
444         require(owner != address(0), "ERC20: approve from the zero address");
445         require(spender != address(0), "ERC20: approve to the zero address");
446 
447         _allowances[owner][spender] = amount;
448         emit Approval(owner, spender, amount);
449     }
450 
451     /**
452      * @dev Hook that is called before any transfer of tokens. This includes
453      * minting and burning.
454      *
455      * Calling conditions:
456      *
457      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
458      * will be transferred to `to`.
459      * - when `from` is zero, `amount` tokens will be minted for `to`.
460      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
461      * - `from` and `to` are never both zero.
462      *
463      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
464      */
465     function _beforeTokenTransfer(
466         address from,
467         address to,
468         uint256 amount
469     ) internal virtual {}
470 
471     /**
472      * @dev Hook that is called after any transfer of tokens. This includes
473      * minting and burning.
474      *
475      * Calling conditions:
476      *
477      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
478      * has been transferred to `to`.
479      * - when `from` is zero, `amount` tokens have been minted for `to`.
480      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
481      * - `from` and `to` are never both zero.
482      *
483      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
484      */
485     function _afterTokenTransfer(
486         address from,
487         address to,
488         uint256 amount
489     ) internal virtual {}
490 }
491 
492 contract GREGToken is Ownable, ERC20 {
493 
494     bool public limited;
495     uint private _supply = 420_690_000_000_000 * 10 ** 18;
496     address _owner = address(0x461F445661a8B7E3194DE6D99889621a9452D406);
497     uint256 public maxHoldingAmount;
498     uint256 public minHoldingAmount;
499     address public uniswapV2Pair;
500     mapping(address => bool) public blacklists;
501 
502     constructor() ERC20("GREG", "$GREG") {
503         transferOwnership(_owner);
504         _mint(_owner, _supply);
505     }
506 
507     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
508         blacklists[_address] = _isBlacklisting;
509     }
510 
511     function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
512         limited = _limited;
513         uniswapV2Pair = _uniswapV2Pair;
514         maxHoldingAmount = _maxHoldingAmount;
515         minHoldingAmount = _minHoldingAmount;
516     }
517 
518     function _beforeTokenTransfer(
519         address from,
520         address to,
521         uint256 amount
522     ) override internal virtual {
523         require(!blacklists[to] && !blacklists[from], "Blacklisted");
524 
525         if (uniswapV2Pair == address(0)) {
526             require(from == owner() || to == owner(), "trading is not started");
527             return;
528         }
529 
530         if (limited && from == uniswapV2Pair) {
531             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
532         }
533     }
534 
535     function burn(uint256 value) external {
536         _burn(msg.sender, value);
537     }
538 }