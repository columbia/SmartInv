1 // SPDX-License-Identifier: MIT
2 //.#
3 //(//#*             ((#%
4 //.//(((((          (((##
5 //(/*,,,//((#########%%%((
6 //      /(*,,((######%%###%&&%%%%%(,
7 //     #(#//###%#####%%%%(##&%#%%%%%(
8 //    (#**#%%%%%####.% %(%%%%%..#%&@%(
9 //    ####%%%%%%%%##,#%.(%%%%%%%%%&@@&
10 //   (##(#%%%%%%%%%%%%%%%%%%%/.....&&&&#
11 //  (###(%%%%%%%%%%%%%%%%%%%%#*...,(&&@# #
12 //  ##(##(%%%&&&%%%%%%%%#####/***.,&&@&/ #
13 // (##((##(%%%%%&&&&%%%%////*//**/&&&&,
14 //##((#(((((%%%&&&%%%%%%%%%%%%%%&&&&,
15 //#####///(%%%%#%&&&&&&&&&&&&&&&&##%%
16 //((%%%%%%(#%%%%%%%#####%&&&&&&####%%%
17 //((#%%%%%%%%%%%%%%%%%%%%######%%%%%%%
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev Interface of the ERC20 standard as defined in the EIP.
23  */
24 interface IERC20 {
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `recipient`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address recipient, uint256 amount) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `sender` to `recipient` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(
79         address sender,
80         address recipient,
81         uint256 amount
82     ) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 /**
100  * @dev Interface for the optional metadata functions from the ERC20 standard.
101  *
102  * _Available since v4.1._
103  */
104 interface IERC20Metadata is IERC20 {
105     /**
106      * @dev Returns the name of the token.
107      */
108     function name() external view returns (string memory);
109 
110     /**
111      * @dev Returns the symbol of the token.
112      */
113     function symbol() external view returns (string memory);
114 
115     /**
116      * @dev Returns the decimals places of the token.
117      */
118     function decimals() external view returns (uint8);
119 }
120 
121 /**
122  * @dev Provides information about the current execution context, including the
123  * sender of the transaction and its data. While these are generally available
124  * via msg.sender and msg.data, they should not be accessed in such a direct
125  * manner, since when dealing with meta-transactions the account sending and
126  * paying for execution may not be the actual sender (as far as an application
127  * is concerned).
128  *
129  * This contract is only required for intermediate, library-like contracts.
130  */
131 abstract contract Context {
132     function _msgSender() internal view virtual returns (address) {
133         return msg.sender;
134     }
135 
136     function _msgData() internal view virtual returns (bytes calldata) {
137         return msg.data;
138     }
139 }
140 
141 contract ERC20 is Context, IERC20, IERC20Metadata {
142     mapping(address => uint256) private _balances;
143 
144     mapping(address => mapping(address => uint256)) private _allowances;
145 
146     uint256 private _totalSupply;
147 
148     string private _name;
149     string private _symbol;
150 
151     /**
152      * @dev Sets the values for {name} and {symbol}.
153      *
154      * The default value of {decimals} is 18. To select a different value for
155      * {decimals} you should overload it.
156      *
157      * All two of these values are immutable: they can only be set once during
158      * construction.
159      */
160     constructor(string memory name_, string memory symbol_) {
161         _name = name_;
162         _symbol = symbol_;
163     }
164 
165     /**
166      * @dev Returns the name of the token.
167      */
168     function name() public view virtual override returns (string memory) {
169         return _name;
170     }
171 
172     /**
173      * @dev Returns the symbol of the token, usually a shorter version of the
174      * name.
175      */
176     function symbol() public view virtual override returns (string memory) {
177         return _symbol;
178     }
179 
180     /**
181      * @dev Returns the number of decimals used to get its user representation.
182      * For example, if `decimals` equals `2`, a balance of `505` tokens should
183      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
184      *
185      * Tokens usually opt for a value of 18, imitating the relationship between
186      * Ether and Wei. This is the value {ERC20} uses, unless this function is
187      * overridden;
188      *
189      * NOTE: This information is only used for _display_ purposes: it in
190      * no way affects any of the arithmetic of the contract, including
191      * {IERC20-balanceOf} and {IERC20-transfer}.
192      */
193     function decimals() public view virtual override returns (uint8) {
194         return 18;
195     }
196 
197     /**
198      * @dev See {IERC20-totalSupply}.
199      */
200     function totalSupply() public view virtual override returns (uint256) {
201         return _totalSupply;
202     }
203 
204     /**
205      * @dev See {IERC20-balanceOf}.
206      */
207     function balanceOf(address account) public view virtual override returns (uint256) {
208         return _balances[account];
209     }
210 
211     /**
212      * @dev See {IERC20-transfer}.
213      *
214      * Requirements:
215      *
216      * - `recipient` cannot be the zero address.
217      * - the caller must have a balance of at least `amount`.
218      */
219     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
220         _transfer(_msgSender(), recipient, amount);
221         return true;
222     }
223 
224     /**
225      * @dev See {IERC20-allowance}.
226      */
227     function allowance(address owner, address spender) public view virtual override returns (uint256) {
228         return _allowances[owner][spender];
229     }
230 
231     /**
232      * @dev See {IERC20-approve}.
233      *
234      * Requirements:
235      *
236      * - `spender` cannot be the zero address.
237      */
238     function approve(address spender, uint256 amount) public virtual override returns (bool) {
239         _approve(_msgSender(), spender, amount);
240         return true;
241     }
242 
243     /**
244      * @dev See {IERC20-transferFrom}.
245      *
246      * Emits an {Approval} event indicating the updated allowance. This is not
247      * required by the EIP. See the note at the beginning of {ERC20}.
248      *
249      * Requirements:
250      *
251      * - `sender` and `recipient` cannot be the zero address.
252      * - `sender` must have a balance of at least `amount`.
253      * - the caller must have allowance for ``sender``'s tokens of at least
254      * `amount`.
255      */
256     function transferFrom(
257         address sender,
258         address recipient,
259         uint256 amount
260     ) public virtual override returns (bool) {
261         _transfer(sender, recipient, amount);
262 
263         uint256 currentAllowance = _allowances[sender][_msgSender()];
264         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
265     unchecked {
266         _approve(sender, _msgSender(), currentAllowance - amount);
267     }
268 
269         return true;
270     }
271 
272     /**
273      * @dev Atomically increases the allowance granted to `spender` by the caller.
274      *
275      * This is an alternative to {approve} that can be used as a mitigation for
276      * problems described in {IERC20-approve}.
277      *
278      * Emits an {Approval} event indicating the updated allowance.
279      *
280      * Requirements:
281      *
282      * - `spender` cannot be the zero address.
283      */
284     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
285         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
286         return true;
287     }
288 
289     /**
290      * @dev Atomically decreases the allowance granted to `spender` by the caller.
291      *
292      * This is an alternative to {approve} that can be used as a mitigation for
293      * problems described in {IERC20-approve}.
294      *
295      * Emits an {Approval} event indicating the updated allowance.
296      *
297      * Requirements:
298      *
299      * - `spender` cannot be the zero address.
300      * - `spender` must have allowance for the caller of at least
301      * `subtractedValue`.
302      */
303     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
304         uint256 currentAllowance = _allowances[_msgSender()][spender];
305         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
306     unchecked {
307         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
308     }
309 
310         return true;
311     }
312 
313     /**
314      * @dev Moves `amount` of tokens from `sender` to `recipient`.
315      *
316      * This internal function is equivalent to {transfer}, and can be used to
317      * e.g. implement automatic token fees, slashing mechanisms, etc.
318      *
319      * Emits a {Transfer} event.
320      *
321      * Requirements:
322      *
323      * - `sender` cannot be the zero address.
324      * - `recipient` cannot be the zero address.
325      * - `sender` must have a balance of at least `amount`.
326      */
327     function _transfer(
328         address sender,
329         address recipient,
330         uint256 amount
331     ) internal virtual {
332         require(sender != address(0), "ERC20: transfer from the zero address");
333         require(recipient != address(0), "ERC20: transfer to the zero address");
334 
335         _beforeTokenTransfer(sender, recipient, amount);
336 
337         uint256 senderBalance = _balances[sender];
338         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
339     unchecked {
340         _balances[sender] = senderBalance - amount;
341     }
342         _balances[recipient] += amount;
343 
344         emit Transfer(sender, recipient, amount);
345 
346         _afterTokenTransfer(sender, recipient, amount);
347     }
348 
349     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
350      * the total supply.
351      *
352      * Emits a {Transfer} event with `from` set to the zero address.
353      *
354      * Requirements:
355      *
356      * - `account` cannot be the zero address.
357      */
358     function _mint(address account, uint256 amount) internal virtual {
359         require(account != address(0), "ERC20: mint to the zero address");
360 
361         _beforeTokenTransfer(address(0), account, amount);
362 
363         _totalSupply += amount;
364         _balances[account] += amount;
365         emit Transfer(address(0), account, amount);
366 
367         _afterTokenTransfer(address(0), account, amount);
368     }
369 
370     /**
371      * @dev Destroys `amount` tokens from `account`, reducing the
372      * total supply.
373      *
374      * Emits a {Transfer} event with `to` set to the zero address.
375      *
376      * Requirements:
377      *
378      * - `account` cannot be the zero address.
379      * - `account` must have at least `amount` tokens.
380      */
381     function _burn(address account, uint256 amount) internal virtual {
382         require(account != address(0), "ERC20: burn from the zero address");
383 
384         _beforeTokenTransfer(account, address(0), amount);
385 
386         uint256 accountBalance = _balances[account];
387         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
388     unchecked {
389         _balances[account] = accountBalance - amount;
390     }
391         _totalSupply -= amount;
392 
393         emit Transfer(account, address(0), amount);
394 
395         _afterTokenTransfer(account, address(0), amount);
396     }
397 
398     /**
399      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
400      *
401      * This internal function is equivalent to `approve`, and can be used to
402      * e.g. set automatic allowances for certain subsystems, etc.
403      *
404      * Emits an {Approval} event.
405      *
406      * Requirements:
407      *
408      * - `owner` cannot be the zero address.
409      * - `spender` cannot be the zero address.
410      */
411     function _approve(
412         address owner,
413         address spender,
414         uint256 amount
415     ) internal virtual {
416         require(owner != address(0), "ERC20: approve from the zero address");
417         require(spender != address(0), "ERC20: approve to the zero address");
418 
419         _allowances[owner][spender] = amount;
420         emit Approval(owner, spender, amount);
421     }
422 
423     /**
424      * @dev Hook that is called before any transfer of tokens. This includes
425      * minting and burning.
426      *
427      * Calling conditions:
428      *
429      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
430      * will be transferred to `to`.
431      * - when `from` is zero, `amount` tokens will be minted for `to`.
432      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
433      * - `from` and `to` are never both zero.
434      *
435      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
436      */
437     function _beforeTokenTransfer(
438         address from,
439         address to,
440         uint256 amount
441     ) internal virtual {}
442 
443     /**
444      * @dev Hook that is called after any transfer of tokens. This includes
445      * minting and burning.
446      *
447      * Calling conditions:
448      *
449      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
450      * has been transferred to `to`.
451      * - when `from` is zero, `amount` tokens have been minted for `to`.
452      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
453      * - `from` and `to` are never both zero.
454      *
455      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
456      */
457     function _afterTokenTransfer(
458         address from,
459         address to,
460         uint256 amount
461     ) internal virtual {}
462 }
463 
464 /**
465  * @dev Extension of {ERC20} that allows token holders to destroy both their own
466  * tokens and those that they have an allowance for, in a way that can be
467  * recognized off-chain (via event analysis).
468  */
469 abstract contract ERC20Burnable is Context, ERC20 {
470     /**
471      * @dev Destroys `amount` tokens from the caller.
472      *
473      * See {ERC20-_burn}.
474      */
475     function burn(uint256 amount) public virtual {
476         _burn(_msgSender(), amount);
477     }
478 
479     /**
480      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
481      * allowance.
482      *
483      * See {ERC20-_burn} and {ERC20-allowance}.
484      *
485      * Requirements:
486      *
487      * - the caller must have allowance for ``accounts``'s tokens of at least
488      * `amount`.
489      */
490     function burnFrom(address account, uint256 amount) public virtual {
491         uint256 currentAllowance = allowance(account, _msgSender());
492         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
493     unchecked {
494         _approve(account, _msgSender(), currentAllowance - amount);
495     }
496         _burn(account, amount);
497     }
498 }
499 
500 contract MetaDoge is ERC20Burnable {
501     constructor() ERC20("Meta Doge", "METADOGE") {
502         _mint(_msgSender(), 1_000_000_000_000_000_000_000_000_000_000_000);
503     }
504 }