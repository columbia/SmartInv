1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.16;
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
164 contract MUNGER is Context, IERC20, IERC20Metadata, Ownable {
165     // Openzeppelin variables
166     mapping(address => uint256) private _balances;
167 
168     mapping(address => mapping(address => uint256)) private _allowances;
169 
170     uint256 private _totalSupply;
171 
172     string private _name;
173     string private _symbol;
174 
175     // Openzeppelin functions
176 
177     /**
178      * @dev Sets the values for {name} and {symbol}.
179      *
180      * The default value of {decimals} is 18. To select a different value for
181      * {decimals} you should overload it.
182      *
183      * All two of these values are immutable: they can only be set once during
184      * construction.
185      */
186     constructor() {
187         // Editable
188         _name = "Munger Coin";
189         _symbol = "MUNGER";
190         uint e_totalSupply = 1_000_000_000_000 ether;
191         // End editable
192 
193         _mint(msg.sender, e_totalSupply);
194     }
195 
196     /**
197      * @dev Returns the name of the token.
198      */
199     function name() public view virtual override returns (string memory) {
200         return _name;
201     }
202 
203     /**
204      * @dev Returns the symbol of the token, usually a shorter version of the
205      * name.
206      */
207     function symbol() public view virtual override returns (string memory) {
208         return _symbol;
209     }
210 
211     /**
212      * @dev Returns the number of decimals used to get its user representation.
213      * For example, if `decimals` equals `2`, a balance of `505` tokens should
214      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
215      *
216      * Tokens usually opt for a value of 18, imitating the relationship between
217      * Ether and Wei. This is the value {ERC20} uses, unless this function is
218      * overridden;
219      *
220      * NOTE: This information is only used for _display_ purposes: it in
221      * no way affects any of the arithmetic of the contract, including
222      * {IERC20-balanceOf} and {IERC20-transfer}.
223      */
224     function decimals() public view virtual override returns (uint8) {
225         return 18;
226     }
227 
228     /**
229      * @dev See {IERC20-totalSupply}.
230      */
231     function totalSupply() public view virtual override returns (uint256) {
232         return _totalSupply;
233     }
234 
235     /**
236      * @dev See {IERC20-balanceOf}.
237      */
238     function balanceOf(address account) public view virtual override returns (uint256) {
239         return _balances[account];
240     }
241 
242     /**
243      * @dev See {IERC20-transfer}.
244      *
245      * Requirements:
246      *
247      * - `to` cannot be the zero address.
248      * - the caller must have a balance of at least `amount`.
249      */
250     function transfer(address to, uint256 amount) public virtual override returns (bool) {
251         address owner = _msgSender();
252         _transfer(owner, to, amount);
253         return true;
254     }
255 
256     /**
257      * @dev See {IERC20-allowance}.
258      */
259     function allowance(address owner, address spender) public view virtual override returns (uint256) {
260         return _allowances[owner][spender];
261     }
262 
263     /**
264      * @dev See {IERC20-approve}.
265      *
266      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
267      * `transferFrom`. This is semantically equivalent to an infinite approval.
268      *
269      * Requirements:
270      *
271      * - `spender` cannot be the zero address.
272      */
273     function approve(address spender, uint256 amount) public virtual override returns (bool) {
274         address owner = _msgSender();
275         _approve(owner, spender, amount);
276         return true;
277     }
278 
279     /**
280      * @dev See {IERC20-transferFrom}.
281      *
282      * Emits an {Approval} event indicating the updated allowance. This is not
283      * required by the EIP. See the note at the beginning of {ERC20}.
284      *
285      * NOTE: Does not update the allowance if the current allowance
286      * is the maximum `uint256`.
287      *
288      * Requirements:
289      *
290      * - `from` and `to` cannot be the zero address.
291      * - `from` must have a balance of at least `amount`.
292      * - the caller must have allowance for ``from``'s tokens of at least
293      * `amount`.
294      */
295     function transferFrom(
296         address from,
297         address to,
298         uint256 amount
299     ) public virtual override returns (bool) {
300         address spender = _msgSender();
301         _spendAllowance(from, spender, amount);
302         _transfer(from, to, amount);
303         return true;
304     }
305 
306     /**
307      * @dev Atomically increases the allowance granted to `spender` by the caller.
308      *
309      * This is an alternative to {approve} that can be used as a mitigation for
310      * problems described in {IERC20-approve}.
311      *
312      * Emits an {Approval} event indicating the updated allowance.
313      *
314      * Requirements:
315      *
316      * - `spender` cannot be the zero address.
317      */
318     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
319         address owner = _msgSender();
320         _approve(owner, spender, _allowances[owner][spender] + addedValue);
321         return true;
322     }
323 
324     /**
325      * @dev Atomically decreases the allowance granted to `spender` by the caller.
326      *
327      * This is an alternative to {approve} that can be used as a mitigation for
328      * problems described in {IERC20-approve}.
329      *
330      * Emits an {Approval} event indicating the updated allowance.
331      *
332      * Requirements:
333      *
334      * - `spender` cannot be the zero address.
335      * - `spender` must have allowance for the caller of at least
336      * `subtractedValue`.
337      */
338     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
339         address owner = _msgSender();
340         uint256 currentAllowance = _allowances[owner][spender];
341         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
342         unchecked {
343             _approve(owner, spender, currentAllowance - subtractedValue);
344         }
345 
346         return true;
347     }
348 
349     /**
350      * @dev Moves `amount` of tokens from `sender` to `recipient`.
351      *
352      * This internal function is equivalent to {transfer}, and can be used to
353      * e.g. implement automatic token fees, slashing mechanisms, etc.
354      *
355      * Emits a {Transfer} event.
356      *
357      * Requirements:
358      *
359      * - `from` cannot be the zero address.
360      * - `to` cannot be the zero address.
361      * - `from` must have a balance of at least `amount`.
362      */
363     function _transfer(
364         address from,
365         address to,
366         uint256 amount
367     ) internal virtual {
368         require(from != address(0), "ERC20: transfer from the zero address");
369         require(to != address(0), "ERC20: transfer to the zero address");
370 
371         _beforeTokenTransfer(from, to, amount);
372 
373         uint256 fromBalance = _balances[from];
374         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
375         unchecked {
376             _balances[from] = fromBalance - amount;
377         }
378         _balances[to] += amount;
379 
380         emit Transfer(from, to, amount);
381 
382         _afterTokenTransfer(from, to, amount);
383     }
384 
385     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
386      * the total supply.
387      *
388      * Emits a {Transfer} event with `from` set to the zero address.
389      *
390      * Requirements:
391      *
392      * - `account` cannot be the zero address.
393      */
394     function _mint(address account, uint256 amount) internal virtual {
395         require(account != address(0), "ERC20: mint to the zero address");
396 
397         _beforeTokenTransfer(address(0), account, amount);
398 
399         _totalSupply += amount;
400         _balances[account] += amount;
401         emit Transfer(address(0), account, amount);
402 
403         _afterTokenTransfer(address(0), account, amount);
404     }
405 
406     /**
407      * @dev Destroys `amount` tokens from `account`, reducing the
408      * total supply.
409      *
410      * Emits a {Transfer} event with `to` set to the zero address.
411      *
412      * Requirements:
413      *
414      * - `account` cannot be the zero address.
415      * - `account` must have at least `amount` tokens.
416      */
417     function _burn(address account, uint256 amount) internal virtual {
418         require(account != address(0), "ERC20: burn from the zero address");
419 
420         _beforeTokenTransfer(account, address(0), amount);
421 
422         uint256 accountBalance = _balances[account];
423         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
424         unchecked {
425             _balances[account] = accountBalance - amount;
426         }
427         _totalSupply -= amount;
428 
429         emit Transfer(account, address(0), amount);
430 
431         _afterTokenTransfer(account, address(0), amount);
432     }
433 
434     /**
435      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
436      *
437      * This internal function is equivalent to `approve`, and can be used to
438      * e.g. set automatic allowances for certain subsystems, etc.
439      *
440      * Emits an {Approval} event.
441      *
442      * Requirements:
443      *
444      * - `owner` cannot be the zero address.
445      * - `spender` cannot be the zero address.
446      */
447     function _approve(
448         address owner,
449         address spender,
450         uint256 amount
451     ) internal virtual {
452         require(owner != address(0), "ERC20: approve from the zero address");
453         require(spender != address(0), "ERC20: approve to the zero address");
454 
455         _allowances[owner][spender] = amount;
456         emit Approval(owner, spender, amount);
457     }
458 
459     /**
460      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
461      *
462      * Does not update the allowance amount in case of infinite allowance.
463      * Revert if not enough allowance is available.
464      *
465      * Might emit an {Approval} event.
466      */
467     function _spendAllowance(
468         address owner,
469         address spender,
470         uint256 amount
471     ) internal virtual {
472         uint256 currentAllowance = allowance(owner, spender);
473         if (currentAllowance != type(uint256).max) {
474             require(currentAllowance >= amount, "ERC20: insufficient allowance");
475             unchecked {
476                 _approve(owner, spender, currentAllowance - amount);
477             }
478         }
479     }
480 
481     /**
482      * @dev Hook that is called before any transfer of tokens. This includes
483      * minting and burning.
484      *
485      * Calling conditions:
486      *
487      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
488      * will be transferred to `to`.
489      * - when `from` is zero, `amount` tokens will be minted for `to`.
490      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
491      * - `from` and `to` are never both zero.
492      *
493      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
494      */
495     function _beforeTokenTransfer(
496         address from,
497         address to,
498         uint256 amount
499     ) internal virtual {}
500 
501     /**
502      * @dev Hook that is called after any transfer of tokens. This includes
503      * minting and burning.
504      *
505      * Calling conditions:
506      *
507      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
508      * has been transferred to `to`.
509      * - when `from` is zero, `amount` tokens have been minted for `to`.
510      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
511      * - `from` and `to` are never both zero.
512      *
513      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
514      */
515     function _afterTokenTransfer(
516         address from,
517         address to,
518         uint256 amount
519     ) internal virtual {}
520 }