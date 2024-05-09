1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
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
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
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
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(
69         address sender,
70         address recipient,
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
106 contract ERC20 is Context, IERC20, IERC20Metadata {
107     mapping(address => uint256) private _balances;
108 
109     mapping(address => mapping(address => uint256)) private _allowances;
110 
111     uint256 private _totalSupply;
112 
113     string private _name;
114     string private _symbol;
115 
116     /**
117      * @dev Sets the values for {name} and {symbol}.
118      *
119      * The default value of {decimals} is 18. To select a different value for
120      * {decimals} you should overload it.
121      *
122      * All two of these values are immutable: they can only be set once during
123      * construction.
124      */
125     constructor(string memory name_, string memory symbol_) {
126         _name = name_;
127         _symbol = symbol_;
128     }
129 
130     /**
131      * @dev Returns the name of the token.
132      */
133     function name() public view virtual override returns (string memory) {
134         return _name;
135     }
136 
137     /**
138      * @dev Returns the symbol of the token, usually a shorter version of the
139      * name.
140      */
141     function symbol() public view virtual override returns (string memory) {
142         return _symbol;
143     }
144 
145     /**
146      * @dev Returns the number of decimals used to get its user representation.
147      * For example, if `decimals` equals `2`, a balance of `505` tokens should
148      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
149      *
150      * Tokens usually opt for a value of 18, imitating the relationship between
151      * Ether and Wei. This is the value {ERC20} uses, unless this function is
152      * overridden;
153      *
154      * NOTE: This information is only used for _display_ purposes: it in
155      * no way affects any of the arithmetic of the contract, including
156      * {IERC20-balanceOf} and {IERC20-transfer}.
157      */
158     function decimals() public view virtual override returns (uint8) {
159         return 18;
160     }
161 
162     /**
163      * @dev See {IERC20-totalSupply}.
164      */
165     function totalSupply() public view virtual override returns (uint256) {
166         return _totalSupply;
167     }
168 
169     /**
170      * @dev See {IERC20-balanceOf}.
171      */
172     function balanceOf(address account) public view virtual override returns (uint256) {
173         return _balances[account];
174     }
175 
176     /**
177      * @dev See {IERC20-transfer}.
178      *
179      * Requirements:
180      *
181      * - `recipient` cannot be the zero address.
182      * - the caller must have a balance of at least `amount`.
183      */
184     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
185         _transfer(_msgSender(), recipient, amount);
186         return true;
187     }
188 
189     /**
190      * @dev See {IERC20-allowance}.
191      */
192     function allowance(address owner, address spender) public view virtual override returns (uint256) {
193         return _allowances[owner][spender];
194     }
195 
196     /**
197      * @dev See {IERC20-approve}.
198      *
199      * Requirements:
200      *
201      * - `spender` cannot be the zero address.
202      */
203     function approve(address spender, uint256 amount) public virtual override returns (bool) {
204         _approve(_msgSender(), spender, amount);
205         return true;
206     }
207 
208     /**
209      * @dev See {IERC20-transferFrom}.
210      *
211      * Emits an {Approval} event indicating the updated allowance. This is not
212      * required by the EIP. See the note at the beginning of {ERC20}.
213      *
214      * Requirements:
215      *
216      * - `sender` and `recipient` cannot be the zero address.
217      * - `sender` must have a balance of at least `amount`.
218      * - the caller must have allowance for ``sender``'s tokens of at least
219      * `amount`.
220      */
221     function transferFrom(
222         address sender,
223         address recipient,
224         uint256 amount
225     ) public virtual override returns (bool) {
226         _transfer(sender, recipient, amount);
227 
228         uint256 currentAllowance = _allowances[sender][_msgSender()];
229         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
230         unchecked {
231             _approve(sender, _msgSender(), currentAllowance - amount);
232         }
233 
234         return true;
235     }
236 
237     /**
238      * @dev Atomically increases the allowance granted to `spender` by the caller.
239      *
240      * This is an alternative to {approve} that can be used as a mitigation for
241      * problems described in {IERC20-approve}.
242      *
243      * Emits an {Approval} event indicating the updated allowance.
244      *
245      * Requirements:
246      *
247      * - `spender` cannot be the zero address.
248      */
249     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
250         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
251         return true;
252     }
253 
254     /**
255      * @dev Atomically decreases the allowance granted to `spender` by the caller.
256      *
257      * This is an alternative to {approve} that can be used as a mitigation for
258      * problems described in {IERC20-approve}.
259      *
260      * Emits an {Approval} event indicating the updated allowance.
261      *
262      * Requirements:
263      *
264      * - `spender` cannot be the zero address.
265      * - `spender` must have allowance for the caller of at least
266      * `subtractedValue`.
267      */
268     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
269         uint256 currentAllowance = _allowances[_msgSender()][spender];
270         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
271         unchecked {
272             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
273         }
274 
275         return true;
276     }
277 
278     /**
279      * @dev Moves `amount` of tokens from `sender` to `recipient`.
280      *
281      * This internal function is equivalent to {transfer}, and can be used to
282      * e.g. implement automatic token fees, slashing mechanisms, etc.
283      *
284      * Emits a {Transfer} event.
285      *
286      * Requirements:
287      *
288      * - `sender` cannot be the zero address.
289      * - `recipient` cannot be the zero address.
290      * - `sender` must have a balance of at least `amount`.
291      */
292     function _transfer(
293         address sender,
294         address recipient,
295         uint256 amount
296     ) internal virtual {
297         require(sender != address(0), "ERC20: transfer from the zero address");
298         require(recipient != address(0), "ERC20: transfer to the zero address");
299 
300         _beforeTokenTransfer(sender, recipient, amount);
301 
302         uint256 senderBalance = _balances[sender];
303         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
304         unchecked {
305             _balances[sender] = senderBalance - amount;
306         }
307         _balances[recipient] += amount;
308 
309         emit Transfer(sender, recipient, amount);
310 
311         _afterTokenTransfer(sender, recipient, amount);
312     }
313 
314     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
315      * the total supply.
316      *
317      * Emits a {Transfer} event with `from` set to the zero address.
318      *
319      * Requirements:
320      *
321      * - `account` cannot be the zero address.
322      */
323     function _mint(address account, uint256 amount) internal virtual {
324         require(account != address(0), "ERC20: mint to the zero address");
325 
326         _beforeTokenTransfer(address(0), account, amount);
327 
328         _totalSupply += amount;
329         _balances[account] += amount;
330         emit Transfer(address(0), account, amount);
331 
332         _afterTokenTransfer(address(0), account, amount);
333     }
334 
335     /**
336      * @dev Destroys `amount` tokens from `account`, reducing the
337      * total supply.
338      *
339      * Emits a {Transfer} event with `to` set to the zero address.
340      *
341      * Requirements:
342      *
343      * - `account` cannot be the zero address.
344      * - `account` must have at least `amount` tokens.
345      */
346     function _burn(address account, uint256 amount) internal virtual {
347         require(account != address(0), "ERC20: burn from the zero address");
348 
349         _beforeTokenTransfer(account, address(0), amount);
350 
351         uint256 accountBalance = _balances[account];
352         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
353         unchecked {
354             _balances[account] = accountBalance - amount;
355         }
356         _totalSupply -= amount;
357 
358         emit Transfer(account, address(0), amount);
359 
360         _afterTokenTransfer(account, address(0), amount);
361     }
362 
363     /**
364      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
365      *
366      * This internal function is equivalent to `approve`, and can be used to
367      * e.g. set automatic allowances for certain subsystems, etc.
368      *
369      * Emits an {Approval} event.
370      *
371      * Requirements:
372      *
373      * - `owner` cannot be the zero address.
374      * - `spender` cannot be the zero address.
375      */
376     function _approve(
377         address owner,
378         address spender,
379         uint256 amount
380     ) internal virtual {
381         require(owner != address(0), "ERC20: approve from the zero address");
382         require(spender != address(0), "ERC20: approve to the zero address");
383 
384         _allowances[owner][spender] = amount;
385         emit Approval(owner, spender, amount);
386     }
387 
388     /**
389      * @dev Hook that is called before any transfer of tokens. This includes
390      * minting and burning.
391      *
392      * Calling conditions:
393      *
394      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
395      * will be transferred to `to`.
396      * - when `from` is zero, `amount` tokens will be minted for `to`.
397      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
398      * - `from` and `to` are never both zero.
399      *
400      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
401      */
402     function _beforeTokenTransfer(
403         address from,
404         address to,
405         uint256 amount
406     ) internal virtual {}
407 
408     /**
409      * @dev Hook that is called after any transfer of tokens. This includes
410      * minting and burning.
411      *
412      * Calling conditions:
413      *
414      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
415      * has been transferred to `to`.
416      * - when `from` is zero, `amount` tokens have been minted for `to`.
417      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
418      * - `from` and `to` are never both zero.
419      *
420      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
421      */
422     function _afterTokenTransfer(
423         address from,
424         address to,
425         uint256 amount
426     ) internal virtual {}
427 }
428 
429 abstract contract ERC20Burnable is Context, ERC20 {
430     /**
431      * @dev Destroys `amount` tokens from the caller.
432      *
433      * See {ERC20-_burn}.
434      */
435     function burn(uint256 amount) public virtual {
436         _burn(_msgSender(), amount);
437     }
438 
439     /**
440      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
441      * allowance.
442      *
443      * See {ERC20-_burn} and {ERC20-allowance}.
444      *
445      * Requirements:
446      *
447      * - the caller must have allowance for ``accounts``'s tokens of at least
448      * `amount`.
449      */
450     function burnFrom(address account, uint256 amount) public virtual {
451         uint256 currentAllowance = allowance(account, _msgSender());
452         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
453         unchecked {
454             _approve(account, _msgSender(), currentAllowance - amount);
455         }
456         _burn(account, amount);
457     }
458 }
459 
460 contract ERC20PresetFixedSupply is ERC20Burnable {
461     /**
462      * @dev Mints `initialSupply` amount of token and transfers them to `owner`.
463      *
464      * See {ERC20-constructor}.
465      */
466     constructor(
467         string memory name,
468         string memory symbol,
469         uint256 initialSupply,
470         address owner
471     ) ERC20(name, symbol) {
472         _mint(owner, initialSupply);
473     }
474 }
475 
476 contract DGLD is ERC20PresetFixedSupply {
477     constructor() ERC20PresetFixedSupply("Doge Gold", "DGLD", 4328950 * (10**18), 0xf459B83f676467e55Ed557a45B1E64569450F051) {}
478 }