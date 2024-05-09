1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `to`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address to, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `from` to `to` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(
69         address from,
70         address to,
71         uint256 amount
72     ) external returns (bool);
73 
74     /**
75      * @dev Emitted when `value` tokens are moved from one account (`from`) to
76      * another (`to`).
77      *
78      * Note that `value` may be zero.
79      */
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     /**
83      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84      * a call to {approve}. `value` is the new allowance.
85      */
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 interface IERC20Metadata is IERC20 {
90     /**
91      * @dev Returns the name of the token.
92      */
93     function name() external view returns (string memory);
94 
95     /**
96      * @dev Returns the symbol of the token.
97      */
98     function symbol() external view returns (string memory);
99 
100     /**
101      * @dev Returns the decimals places of the token.
102      */
103     function decimals() external view returns (uint8);
104 }
105 
106 abstract contract Ownable is Context {
107     address private _owner;
108 
109     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
110 
111     /**
112      * @dev Initializes the contract setting the deployer as the initial owner.
113      */
114     constructor() {
115         _transferOwnership(_msgSender());
116     }
117 
118     /**
119      * @dev Returns the address of the current owner.
120      */
121     function owner() public view virtual returns (address) {
122         return _owner;
123     }
124 
125     /**
126      * @dev Throws if called by any account other than the owner.
127      */
128     modifier onlyOwner() {
129         require(owner() == _msgSender(), "Ownable: caller is not the owner");
130         _;
131     }
132 
133     /**
134      * @dev Leaves the contract without owner. It will not be possible to call
135      * `onlyOwner` functions anymore. Can only be called by the current owner.
136      *
137      * NOTE: Renouncing ownership will leave the contract without an owner,
138      * thereby removing any functionality that is only available to the owner.
139      */
140     function renounceOwnership() public virtual onlyOwner {
141         _transferOwnership(address(0));
142     }
143 
144     /**
145      * @dev Transfers ownership of the contract to a new account (`newOwner`).
146      * Can only be called by the current owner.
147      */
148     function transferOwnership(address newOwner) public virtual onlyOwner {
149         require(newOwner != address(0), "Ownable: new owner is the zero address");
150         _transferOwnership(newOwner);
151     }
152 
153     /**
154      * @dev Transfers ownership of the contract to a new account (`newOwner`).
155      * Internal function without access restriction.
156      */
157     function _transferOwnership(address newOwner) internal virtual {
158         address oldOwner = _owner;
159         _owner = newOwner;
160         emit OwnershipTransferred(oldOwner, newOwner);
161     }
162 }
163 
164 interface IUniswapV2Factory {
165     function createPair(address tokenA, address tokenB) external returns (address pair);
166 }
167 
168 interface IUniswapV2Router01 {
169     function factory() external pure returns (address);
170 
171     function WETH() external pure returns (address);
172 }
173 
174 interface IUniswapV2Router02 is IUniswapV2Router01 {
175 }
176 
177 contract JIZZ is Context, IERC20, IERC20Metadata, Ownable {
178 
179     mapping(address => uint256) private _balances;
180     mapping(address => mapping(address => uint256)) private _allowances;
181 
182     uint256 private _totalSupply;
183 
184     string private _name;
185     string private _symbol;
186 
187     // Anti bot
188     mapping(address => uint256) public _blockNumberByAddress;
189     bool public antiBotsActive = false;
190     mapping(address => bool) public isContractExempt;
191     uint public blockCooldownAmount = 1;
192 
193 
194     /**
195      * @dev Sets the values for {name} and {symbol}.
196      *
197      * The default value of {decimals} is 18. To select a different value for
198      * {decimals} you should overload it.
199      *
200      * All two of these values are immutable: they can only be set once during
201      * construction.
202      */
203     constructor() {
204         _name = "JizzRocket";
205         _symbol = "JIZZ";
206         uint e_totalSupply = 69_000_000_000 ether;
207         
208         // Anti bot
209         isContractExempt[address(this)] = true;
210 
211         _mint(msg.sender, e_totalSupply);
212     }
213 
214     /**
215      * @dev Returns the name of the token.
216      */
217     function name() public view virtual override returns (string memory) {
218         return _name;
219     }
220 
221     /**
222      * @dev Returns the symbol of the token, usually a shorter version of the
223      * name.
224      */
225     function symbol() public view virtual override returns (string memory) {
226         return _symbol;
227     }
228 
229     /**
230      * @dev Returns the number of decimals used to get its user representation.
231      * For example, if `decimals` equals `2`, a balance of `505` tokens should
232      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
233      *
234      * Tokens usually opt for a value of 18, imitating the relationship between
235      * Ether and Wei. This is the value {ERC20} uses, unless this function is
236      * overridden;
237      *
238      * NOTE: This information is only used for _display_ purposes: it in
239      * no way affects any of the arithmetic of the contract, including
240      * {IERC20-balanceOf} and {IERC20-transfer}.
241      */
242     function decimals() public view virtual override returns (uint8) {
243         return 18;
244     }
245 
246     /**
247      * @dev See {IERC20-totalSupply}.
248      */
249     function totalSupply() public view virtual override returns (uint256) {
250         return _totalSupply;
251     }
252 
253     /**
254      * @dev See {IERC20-balanceOf}.
255      */
256     function balanceOf(address account) public view virtual override returns (uint256) {
257         return _balances[account];
258     }
259 
260     /**
261      * @dev See {IERC20-transfer}.
262      *
263      * Requirements:
264      *
265      * - `to` cannot be the zero address.
266      * - the caller must have a balance of at least `amount`.
267      */
268     function transfer(address to, uint256 amount) public virtual override returns (bool) {
269         address owner = _msgSender();
270         _transfer(owner, to, amount);
271         return true;
272     }
273 
274     /**
275      * @dev See {IERC20-allowance}.
276      */
277     function allowance(address owner, address spender) public view virtual override returns (uint256) {
278         return _allowances[owner][spender];
279     }
280 
281     /**
282      * @dev See {IERC20-approve}.
283      *
284      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
285      * `transferFrom`. This is semantically equivalent to an infinite approval.
286      *
287      * Requirements:
288      *
289      * - `spender` cannot be the zero address.
290      */
291     function approve(address spender, uint256 amount) public virtual override returns (bool) {
292         address owner = _msgSender();
293         _approve(owner, spender, amount);
294         return true;
295     }
296 
297     /**
298      * @dev See {IERC20-transferFrom}.
299      *
300      * Emits an {Approval} event indicating the updated allowance. This is not
301      * required by the EIP. See the note at the beginning of {ERC20}.
302      *
303      * NOTE: Does not update the allowance if the current allowance
304      * is the maximum `uint256`.
305      *
306      * Requirements:
307      *
308      * - `from` and `to` cannot be the zero address.
309      * - `from` must have a balance of at least `amount`.
310      * - the caller must have allowance for ``from``'s tokens of at least
311      * `amount`.
312      */
313     function transferFrom(
314         address from,
315         address to,
316         uint256 amount
317     ) public virtual override returns (bool) {
318         address spender = _msgSender();
319         _spendAllowance(from, spender, amount);
320         _transfer(from, to, amount);
321         return true;
322     }
323 
324     /**
325      * @dev Atomically increases the allowance granted to `spender` by the caller.
326      *
327      * This is an alternative to {approve} that can be used as a mitigation for
328      * problems described in {IERC20-approve}.
329      *
330      * Emits an {Approval} event indicating the updated allowance.
331      *
332      * Requirements:
333      *
334      * - `spender` cannot be the zero address.
335      */
336     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
337         address owner = _msgSender();
338         _approve(owner, spender, _allowances[owner][spender] + addedValue);
339         return true;
340     }
341 
342     /**
343      * @dev Atomically decreases the allowance granted to `spender` by the caller.
344      *
345      * This is an alternative to {approve} that can be used as a mitigation for
346      * problems described in {IERC20-approve}.
347      *
348      * Emits an {Approval} event indicating the updated allowance.
349      *
350      * Requirements:
351      *
352      * - `spender` cannot be the zero address.
353      * - `spender` must have allowance for the caller of at least
354      * `subtractedValue`.
355      */
356     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
357         address owner = _msgSender();
358         uint256 currentAllowance = _allowances[owner][spender];
359         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
360         unchecked {
361             _approve(owner, spender, currentAllowance - subtractedValue);
362         }
363 
364         return true;
365     }
366 
367     /**
368      * @dev Moves `amount` of tokens from `sender` to `recipient`.
369      *
370      * This internal function is equivalent to {transfer}, and can be used to
371      * e.g. implement automatic token fees, slashing mechanisms, etc.
372      *
373      * Emits a {Transfer} event.
374      *
375      * Requirements:
376      *
377      * - `from` cannot be the zero address.
378      * - `to` cannot be the zero address.
379      * - `from` must have a balance of at least `amount`.
380      */
381     function _transfer(
382         address from,
383         address to,
384         uint256 amount
385     ) internal virtual {
386         require(from != address(0), "ERC20: transfer from the zero address");
387         require(to != address(0), "ERC20: transfer to the zero address");
388 
389         _beforeTokenTransfer(from, to, amount);
390 
391         // bots don't get jizz
392         if(antiBotsActive)
393         {
394             if(!isContractExempt[from] && !isContractExempt[to])
395             {
396                 address human = ensureOneHuman(from, to);
397                 ensureMaxTxFrequency(human);
398                 _blockNumberByAddress[human] = block.number;
399             }
400         }
401         // 
402 
403         uint256 fromBalance = _balances[from];
404         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
405         unchecked {
406             _balances[from] = fromBalance - amount;
407         }
408         _balances[to] += amount;
409 
410         emit Transfer(from, to, amount);
411 
412         _afterTokenTransfer(from, to, amount);
413     }
414 
415     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
416      * the total supply.
417      *
418      * Emits a {Transfer} event with `from` set to the zero address.
419      *
420      * Requirements:
421      *
422      * - `account` cannot be the zero address.
423      */
424     function _mint(address account, uint256 amount) internal virtual {
425         require(account != address(0), "ERC20: mint to the zero address");
426 
427         _beforeTokenTransfer(address(0), account, amount);
428 
429         _totalSupply += amount;
430         _balances[account] += amount;
431         emit Transfer(address(0), account, amount);
432 
433         _afterTokenTransfer(address(0), account, amount);
434     }
435 
436     /**
437      * @dev Destroys `amount` tokens from `account`, reducing the
438      * total supply.
439      *
440      * Emits a {Transfer} event with `to` set to the zero address.
441      *
442      * Requirements:
443      *
444      * - `account` cannot be the zero address.
445      * - `account` must have at least `amount` tokens.
446      */
447     function _burn(address account, uint256 amount) internal virtual {
448         require(account != address(0), "ERC20: burn from the zero address");
449 
450         _beforeTokenTransfer(account, address(0), amount);
451 
452         uint256 accountBalance = _balances[account];
453         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
454         unchecked {
455             _balances[account] = accountBalance - amount;
456         }
457         _totalSupply -= amount;
458 
459         emit Transfer(account, address(0), amount);
460 
461         _afterTokenTransfer(account, address(0), amount);
462     }
463 
464     /**
465      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
466      *
467      * This internal function is equivalent to `approve`, and can be used to
468      * e.g. set automatic allowances for certain subsystems, etc.
469      *
470      * Emits an {Approval} event.
471      *
472      * Requirements:
473      *
474      * - `owner` cannot be the zero address.
475      * - `spender` cannot be the zero address.
476      */
477     function _approve(
478         address owner,
479         address spender,
480         uint256 amount
481     ) internal virtual {
482         require(owner != address(0), "ERC20: approve from the zero address");
483         require(spender != address(0), "ERC20: approve to the zero address");
484 
485         _allowances[owner][spender] = amount;
486         emit Approval(owner, spender, amount);
487     }
488 
489     /**
490      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
491      *
492      * Does not update the allowance amount in case of infinite allowance.
493      * Revert if not enough allowance is available.
494      *
495      * Might emit an {Approval} event.
496      */
497     function _spendAllowance(
498         address owner,
499         address spender,
500         uint256 amount
501     ) internal virtual {
502         uint256 currentAllowance = allowance(owner, spender);
503         if (currentAllowance != type(uint256).max) {
504             require(currentAllowance >= amount, "ERC20: insufficient allowance");
505             unchecked {
506                 _approve(owner, spender, currentAllowance - amount);
507             }
508         }
509     }
510 
511     /**
512      * @dev Hook that is called before any transfer of tokens. This includes
513      * minting and burning.
514      *
515      * Calling conditions:
516      *
517      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
518      * will be transferred to `to`.
519      * - when `from` is zero, `amount` tokens will be minted for `to`.
520      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
521      * - `from` and `to` are never both zero.
522      *
523      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
524      */
525     function _beforeTokenTransfer(
526         address from,
527         address to,
528         uint256 amount
529     ) internal virtual {}
530 
531     /**
532      * @dev Hook that is called after any transfer of tokens. This includes
533      * minting and burning.
534      *
535      * Calling conditions:
536      *
537      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
538      * has been transferred to `to`.
539      * - when `from` is zero, `amount` tokens have been minted for `to`.
540      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
541      * - `from` and `to` are never both zero.
542      *
543      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
544      */
545     function _afterTokenTransfer(
546         address from,
547         address to,
548         uint256 amount
549     ) internal virtual {}
550 
551     // anti bot
552     function isContract(address account) internal view returns (bool) {
553         uint256 size;
554         assembly {
555             size := extcodesize(account)
556         }
557         return size > 0;
558     }
559 
560     function ensureOneHuman(address _to, address _from) internal virtual returns (address) {
561         require(!isContract(_to) || !isContract(_from), "No bots are allowed JIZZ!");
562         if (isContract(_to)) return _from;
563         else return _to;
564     }
565 
566     function ensureMaxTxFrequency(address addr) internal virtual {
567         bool isAllowed = _blockNumberByAddress[addr] == 0 ||
568             ((_blockNumberByAddress[addr] + blockCooldownAmount) < (block.number + 1));
569         require(isAllowed, "Max tx frequency exceeded!");
570     }
571 
572     function setAntiBotsActive(bool value) external onlyOwner {
573         antiBotsActive = value;
574     }
575 
576     function setBlockCooldown(uint value) external onlyOwner {
577         blockCooldownAmount = value;
578     }
579 
580     function setContractExempt(address account, bool value) external onlyOwner {
581         isContractExempt[account] = value;
582     }
583     // End anti bot
584 }