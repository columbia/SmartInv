1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 interface IERC20 {
5     /**
6      * @dev Returns the amount of tokens in existence.
7      */
8     function totalSupply() external view returns (uint256);
9 
10     /**
11      * @dev Returns the amount of tokens owned by `account`.
12      */
13     function balanceOf(address account) external view returns (uint256);
14 
15     /**
16      * @dev Moves `amount` tokens from the caller's account to `recipient`.
17      *
18      * Returns a boolean value indicating whether the operation succeeded.
19      *
20      * Emits a {Transfer} event.
21      */
22     function transfer(address recipient, uint256 amount) external returns (bool);
23 
24     /**
25      * @dev Returns the remaining number of tokens that `spender` will be
26      * allowed to spend on behalf of `owner` through {transferFrom}. This is
27      * zero by default.
28      *
29      * This value changes when {approve} or {transferFrom} are called.
30      */
31     function allowance(address owner, address spender) external view returns (uint256);
32 
33     /**
34      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * IMPORTANT: Beware that changing an allowance with this method brings the risk
39      * that someone may use both the old and the new allowance by unfortunate
40      * transaction ordering. One possible solution to mitigate this race
41      * condition is to first reduce the spender's allowance to 0 and set the
42      * desired value afterwards:
43      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
44      *
45      * Emits an {Approval} event.
46      */
47     function approve(address spender, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Moves `amount` tokens from `sender` to `recipient` using the
51      * allowance mechanism. `amount` is then deducted from the caller's
52      * allowance.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transferFrom(
59         address sender,
60         address recipient,
61         uint256 amount
62     ) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 interface IERC20Metadata is IERC20 {
79     /**
80      * @dev Returns the name of the token.
81      */
82     function name() external view returns (string memory);
83 
84     /**
85      * @dev Returns the symbol of the token.
86      */
87     function symbol() external view returns (string memory);
88 
89     /**
90      * @dev Returns the decimals places of the token.
91      */
92     function decimals() external view returns (uint8);
93 }
94 abstract contract Context {
95     function _msgSender() internal view virtual returns (address) {
96         return msg.sender;
97     }
98 
99     function _msgData() internal view virtual returns (bytes calldata) {
100         return msg.data;
101     }
102 }
103 contract ERC20 is Context, IERC20, IERC20Metadata {
104     mapping(address => uint256) private _balances;
105 
106     mapping(address => mapping(address => uint256)) private _allowances;
107 
108     uint256 private _totalSupply;
109 
110     string private _name;
111     string private _symbol;
112 
113     /**
114      * @dev Sets the values for {name} and {symbol}.
115      *
116      * The default value of {decimals} is 18. To select a different value for
117      * {decimals} you should overload it.
118      *
119      * All two of these values are immutable: they can only be set once during
120      * construction.
121      */
122     constructor(string memory name_, string memory symbol_) {
123         _name = name_;
124         _symbol = symbol_;
125     }
126 
127     /**
128      * @dev Returns the name of the token.
129      */
130     function name() public view virtual override returns (string memory) {
131         return _name;
132     }
133 
134     /**
135      * @dev Returns the symbol of the token, usually a shorter version of the
136      * name.
137      */
138     function symbol() public view virtual override returns (string memory) {
139         return _symbol;
140     }
141 
142     /**
143      * @dev Returns the number of decimals used to get its user representation.
144      * For example, if `decimals` equals `2`, a balance of `505` tokens should
145      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
146      *
147      * Tokens usually opt for a value of 18, imitating the relationship between
148      * Ether and Wei. This is the value {ERC20} uses, unless this function is
149      * overridden;
150      *
151      * NOTE: This information is only used for _display_ purposes: it in
152      * no way affects any of the arithmetic of the contract, including
153      * {IERC20-balanceOf} and {IERC20-transfer}.
154      */
155     function decimals() public view virtual override returns (uint8) {
156         return 18;
157     }
158 
159     /**
160      * @dev See {IERC20-totalSupply}.
161      */
162     function totalSupply() public view virtual override returns (uint256) {
163         return _totalSupply;
164     }
165 
166     /**
167      * @dev See {IERC20-balanceOf}.
168      */
169     function balanceOf(address account) public view virtual override returns (uint256) {
170         return _balances[account];
171     }
172 
173     /**
174      * @dev See {IERC20-transfer}.
175      *
176      * Requirements:
177      *
178      * - `recipient` cannot be the zero address.
179      * - the caller must have a balance of at least `amount`.
180      */
181     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
182         _transfer(_msgSender(), recipient, amount);
183         return true;
184     }
185 
186     /**
187      * @dev See {IERC20-allowance}.
188      */
189     function allowance(address owner, address spender) public view virtual override returns (uint256) {
190         return _allowances[owner][spender];
191     }
192 
193     /**
194      * @dev See {IERC20-approve}.
195      *
196      * Requirements:
197      *
198      * - `spender` cannot be the zero address.
199      */
200     function approve(address spender, uint256 amount) public virtual override returns (bool) {
201         _approve(_msgSender(), spender, amount);
202         return true;
203     }
204 
205     /**
206      * @dev See {IERC20-transferFrom}.
207      *
208      * Emits an {Approval} event indicating the updated allowance. This is not
209      * required by the EIP. See the note at the beginning of {ERC20}.
210      *
211      * Requirements:
212      *
213      * - `sender` and `recipient` cannot be the zero address.
214      * - `sender` must have a balance of at least `amount`.
215      * - the caller must have allowance for ``sender``'s tokens of at least
216      * `amount`.
217      */
218     function transferFrom(
219         address sender,
220         address recipient,
221         uint256 amount
222     ) public virtual override returns (bool) {
223         _transfer(sender, recipient, amount);
224 
225         uint256 currentAllowance = _allowances[sender][_msgSender()];
226         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
227         unchecked {
228             _approve(sender, _msgSender(), currentAllowance - amount);
229         }
230 
231         return true;
232     }
233 
234     /**
235      * @dev Atomically increases the allowance granted to `spender` by the caller.
236      *
237      * This is an alternative to {approve} that can be used as a mitigation for
238      * problems described in {IERC20-approve}.
239      *
240      * Emits an {Approval} event indicating the updated allowance.
241      *
242      * Requirements:
243      *
244      * - `spender` cannot be the zero address.
245      */
246     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
247         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
248         return true;
249     }
250 
251     /**
252      * @dev Atomically decreases the allowance granted to `spender` by the caller.
253      *
254      * This is an alternative to {approve} that can be used as a mitigation for
255      * problems described in {IERC20-approve}.
256      *
257      * Emits an {Approval} event indicating the updated allowance.
258      *
259      * Requirements:
260      *
261      * - `spender` cannot be the zero address.
262      * - `spender` must have allowance for the caller of at least
263      * `subtractedValue`.
264      */
265     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
266         uint256 currentAllowance = _allowances[_msgSender()][spender];
267         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
268         unchecked {
269             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
270         }
271 
272         return true;
273     }
274 
275     /**
276      * @dev Moves `amount` of tokens from `sender` to `recipient`.
277      *
278      * This internal function is equivalent to {transfer}, and can be used to
279      * e.g. implement automatic token fees, slashing mechanisms, etc.
280      *
281      * Emits a {Transfer} event.
282      *
283      * Requirements:
284      *
285      * - `sender` cannot be the zero address.
286      * - `recipient` cannot be the zero address.
287      * - `sender` must have a balance of at least `amount`.
288      */
289     function _transfer(
290         address sender,
291         address recipient,
292         uint256 amount
293     ) internal virtual {
294         require(sender != address(0), "ERC20: transfer from the zero address");
295         require(recipient != address(0), "ERC20: transfer to the zero address");
296 
297         _beforeTokenTransfer(sender, recipient, amount);
298 
299         uint256 senderBalance = _balances[sender];
300         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
301         unchecked {
302             _balances[sender] = senderBalance - amount;
303         }
304         _balances[recipient] += amount;
305 
306         emit Transfer(sender, recipient, amount);
307 
308         _afterTokenTransfer(sender, recipient, amount);
309     }
310 
311     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
312      * the total supply.
313      *
314      * Emits a {Transfer} event with `from` set to the zero address.
315      *
316      * Requirements:
317      *
318      * - `account` cannot be the zero address.
319      */
320     function _mint(address account, uint256 amount) internal virtual {
321         require(account != address(0), "ERC20: mint to the zero address");
322 
323         _beforeTokenTransfer(address(0), account, amount);
324 
325         _totalSupply += amount;
326         _balances[account] += amount;
327         emit Transfer(address(0), account, amount);
328 
329         _afterTokenTransfer(address(0), account, amount);
330     }
331 
332     /**
333      * @dev Destroys `amount` tokens from `account`, reducing the
334      * total supply.
335      *
336      * Emits a {Transfer} event with `to` set to the zero address.
337      *
338      * Requirements:
339      *
340      * - `account` cannot be the zero address.
341      * - `account` must have at least `amount` tokens.
342      */
343     function _burn(address account, uint256 amount) internal virtual {
344         require(account != address(0), "ERC20: burn from the zero address");
345 
346         _beforeTokenTransfer(account, address(0), amount);
347 
348         uint256 accountBalance = _balances[account];
349         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
350         unchecked {
351             _balances[account] = accountBalance - amount;
352         }
353         _totalSupply -= amount;
354 
355         emit Transfer(account, address(0), amount);
356 
357         _afterTokenTransfer(account, address(0), amount);
358     }
359 
360     /**
361      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
362      *
363      * This internal function is equivalent to `approve`, and can be used to
364      * e.g. set automatic allowances for certain subsystems, etc.
365      *
366      * Emits an {Approval} event.
367      *
368      * Requirements:
369      *
370      * - `owner` cannot be the zero address.
371      * - `spender` cannot be the zero address.
372      */
373     function _approve(
374         address owner,
375         address spender,
376         uint256 amount
377     ) internal virtual {
378         require(owner != address(0), "ERC20: approve from the zero address");
379         require(spender != address(0), "ERC20: approve to the zero address");
380 
381         _allowances[owner][spender] = amount;
382         emit Approval(owner, spender, amount);
383     }
384 
385     /**
386      * @dev Hook that is called before any transfer of tokens. This includes
387      * minting and burning.
388      *
389      * Calling conditions:
390      *
391      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
392      * will be transferred to `to`.
393      * - when `from` is zero, `amount` tokens will be minted for `to`.
394      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
395      * - `from` and `to` are never both zero.
396      *
397      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
398      */
399     function _beforeTokenTransfer(
400         address from,
401         address to,
402         uint256 amount
403     ) internal virtual {}
404 
405     /**
406      * @dev Hook that is called after any transfer of tokens. This includes
407      * minting and burning.
408      *
409      * Calling conditions:
410      *
411      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
412      * has been transferred to `to`.
413      * - when `from` is zero, `amount` tokens have been minted for `to`.
414      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
415      * - `from` and `to` are never both zero.
416      *
417      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
418      */
419     function _afterTokenTransfer(
420         address from,
421         address to,
422         uint256 amount
423     ) internal virtual {}
424 }
425 abstract contract ERC20Burnable is Context, ERC20 {
426     /**
427      * @dev Destroys `amount` tokens from the caller.
428      *
429      * See {ERC20-_burn}.
430      */
431     function burn(uint256 amount) public virtual {
432         _burn(_msgSender(), amount);
433     }
434 
435     /**
436      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
437      * allowance.
438      *
439      * See {ERC20-_burn} and {ERC20-allowance}.
440      *
441      * Requirements:
442      *
443      * - the caller must have allowance for ``accounts``'s tokens of at least
444      * `amount`.
445      */
446     function burnFrom(address account, uint256 amount) public virtual {
447         uint256 currentAllowance = allowance(account, _msgSender());
448         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
449         unchecked {
450             _approve(account, _msgSender(), currentAllowance - amount);
451         }
452         _burn(account, amount);
453     }
454 }
455 abstract contract Ownable is Context {
456     address private _owner;
457 
458     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
459 
460     /**
461      * @dev Initializes the contract setting the deployer as the initial owner.
462      */
463     constructor() {
464         _transferOwnership(_msgSender());
465     }
466 
467     /**
468      * @dev Returns the address of the current owner.
469      */
470     function owner() public view virtual returns (address) {
471         return _owner;
472     }
473 
474     /**
475      * @dev Throws if called by any account other than the owner.
476      */
477     modifier onlyOwner() {
478         require(owner() == _msgSender(), "Ownable: caller is not the owner");
479         _;
480     }
481 
482     /**
483      * @dev Leaves the contract without owner. It will not be possible to call
484      * `onlyOwner` functions anymore. Can only be called by the current owner.
485      *
486      * NOTE: Renouncing ownership will leave the contract without an owner,
487      * thereby removing any functionality that is only available to the owner.
488      */
489     function renounceOwnership() public virtual onlyOwner {
490         _transferOwnership(address(0));
491     }
492 
493     /**
494      * @dev Transfers ownership of the contract to a new account (`newOwner`).
495      * Can only be called by the current owner.
496      */
497     function transferOwnership(address newOwner) public virtual onlyOwner {
498         require(newOwner != address(0), "Ownable: new owner is the zero address");
499         _transferOwnership(newOwner);
500     }
501 
502     /**
503      * @dev Transfers ownership of the contract to a new account (`newOwner`).
504      * Internal function without access restriction.
505      */
506     function _transferOwnership(address newOwner) internal virtual {
507         address oldOwner = _owner;
508         _owner = newOwner;
509         emit OwnershipTransferred(oldOwner, newOwner);
510     }
511 }
512 contract MetaverseDog is ERC20, ERC20Burnable, Ownable {
513     constructor() ERC20("Metaverse Dog", "MVDG") {
514         _mint(msg.sender, 100000000000 * 10 ** decimals());
515     }
516 
517     function mint(address to, uint256 amount) public onlyOwner {
518         _mint(to, amount);
519     }
520 }