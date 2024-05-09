1 /**
2 
3 */
4 
5 // SPDX-License-Identifier: MIT                                                                               
6 
7 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
8 pragma solidity ^0.8.16;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         return msg.data;
17     }
18 }
19 
20 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
21 
22 
23 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
24 
25 
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30     /**
31      * @dev Emitted when `value` tokens are moved from one account (`from`) to
32      * another (`to`).
33      *
34      * Note that `value` may be zero.
35      */
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 
38     /**
39      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
40      * a call to {approve}. `value` is the new allowance.
41      */
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 
44     /**
45      * @dev Returns the amount of tokens in existence.
46      */
47     function totalSupply() external view returns (uint256);
48 
49     /**
50      * @dev Returns the amount of tokens owned by `account`.
51      */
52     function balanceOf(address account) external view returns (uint256);
53 
54     /**
55      * @dev Moves `amount` tokens from the caller's account to `to`.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transfer(address to, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Returns the remaining number of tokens that `spender` will be
65      * allowed to spend on behalf of `owner` through {transferFrom}. This is
66      * zero by default.
67      *
68      * This value changes when {approve} or {transferFrom} are called.
69      */
70     function allowance(address owner, address spender) external view returns (uint256);
71 
72     /**
73      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * IMPORTANT: Beware that changing an allowance with this method brings the risk
78      * that someone may use both the old and the new allowance by unfortunate
79      * transaction ordering. One possible solution to mitigate this race
80      * condition is to first reduce the spender's allowance to 0 and set the
81      * desired value afterwards:
82      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
83      *
84      * Emits an {Approval} event.
85      */
86     function approve(address spender, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Moves `amount` tokens from `from` to `to` using the
90      * allowance mechanism. `amount` is then deducted from the caller's
91      * allowance.
92      *
93      * Returns a boolean value indicating whether the operation succeeded.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(
98         address from,
99         address to,
100         uint256 amount
101     ) external returns (bool);
102 }
103 
104 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
105 
106 
107 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
108 
109 
110 /**
111  * @dev Interface for the optional metadata functions from the ERC20 standard.
112  *
113  * _Available since v4.1._
114  */
115 interface IERC20Metadata is IERC20 {
116     /**
117      * @dev Returns the name of the token.
118      */
119     function name() external view returns (string memory);
120 
121     /**
122      * @dev Returns the symbol of the token.
123      */
124     function symbol() external view returns (string memory);
125 
126     /**
127      * @dev Returns the decimals places of the token.
128      */
129     function decimals() external view returns (uint8);
130 }
131 
132 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
133 
134 
135 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
136 
137 
138 
139 
140 /**
141  * @dev Implementation of the {IERC20} interface.
142  *
143  * This implementation is agnostic to the way tokens are created. This means
144  * that a supply mechanism has to be added in a derived contract using {_mint}.
145  * For a generic mechanism see {ERC20PresetMinterPauser}.
146  *
147  * TIP: For a detailed writeup see our guide
148  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
149  * to implement supply mechanisms].
150  *
151  * We have followed general OpenZeppelin Contracts guidelines: functions revert
152  * instead returning `false` on failure. This behavior is nonetheless
153  * conventional and does not conflict with the expectations of ERC20
154  * applications.
155  *
156  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
157  * This allows applications to reconstruct the allowance for all accounts just
158  * by listening to said events. Other implementations of the EIP may not emit
159  * these events, as it isn't required by the specification.
160  *
161  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
162  * functions have been added to mitigate the well-known issues around setting
163  * allowances. See {IERC20-approve}.
164  */
165 contract ERC20 is Context, IERC20, IERC20Metadata {
166     mapping(address => uint256) private _balances;
167 
168     mapping(address => mapping(address => uint256)) private _allowances;
169 
170     uint256 private _totalSupply;
171 
172     string private _name;
173     string private _symbol;
174 
175     /**
176      * @dev Sets the values for {name} and {symbol}.
177      *
178      * The default value of {decimals} is 18. To select a different value for
179      * {decimals} you should overload it.
180      *
181      * All two of these values are immutable: they can only be set once during
182      * construction.
183      */
184     constructor(string memory name_, string memory symbol_) {
185         _name = name_;
186         _symbol = symbol_;
187     }
188 
189     /**
190      * @dev Returns the name of the token.
191      */
192     function name() public view virtual override returns (string memory) {
193         return _name;
194     }
195 
196     /**
197      * @dev Returns the symbol of the token, usually a shorter version of the
198      * name.
199      */
200     function symbol() public view virtual override returns (string memory) {
201         return _symbol;
202     }
203 
204     /**
205      * @dev Returns the number of decimals used to get its user representation.
206      * For example, if `decimals` equals `2`, a balance of `505` tokens should
207      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
208      *
209      * Tokens usually opt for a value of 18, imitating the relationship between
210      * Ether and Wei. This is the value {ERC20} uses, unless this function is
211      * overridden;
212      *
213      * NOTE: This information is only used for _display_ purposes: it in
214      * no way affects any of the arithmetic of the contract, including
215      * {IERC20-balanceOf} and {IERC20-transfer}.
216      */
217     function decimals() public view virtual override returns (uint8) {
218         return 18;
219     }
220 
221     /**
222      * @dev See {IERC20-totalSupply}.
223      */
224     function totalSupply() public view virtual override returns (uint256) {
225         return _totalSupply;
226     }
227 
228     /**
229      * @dev See {IERC20-balanceOf}.
230      */
231     function balanceOf(address account) public view virtual override returns (uint256) {
232         return _balances[account];
233     }
234 
235     /**
236      * @dev See {IERC20-transfer}.
237      *
238      * Requirements:
239      *
240      * - `to` cannot be the zero address.
241      * - the caller must have a balance of at least `amount`.
242      */
243     function transfer(address to, uint256 amount) public virtual override returns (bool) {
244         address owner = _msgSender();
245         _transfer(owner, to, amount);
246         return true;
247     }
248 
249     /**
250      * @dev See {IERC20-allowance}.
251      */
252     function allowance(address owner, address spender) public view virtual override returns (uint256) {
253         return _allowances[owner][spender];
254     }
255 
256     /**
257      * @dev See {IERC20-approve}.
258      *
259      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
260      * `transferFrom`. This is semantically equivalent to an infinite approval.
261      *
262      * Requirements:
263      *
264      * - `spender` cannot be the zero address.
265      */
266     function approve(address spender, uint256 amount) public virtual override returns (bool) {
267         address owner = _msgSender();
268         _approve(owner, spender, amount);
269         return true;
270     }
271 
272     /**
273      * @dev See {IERC20-transferFrom}.
274      *
275      * Emits an {Approval} event indicating the updated allowance. This is not
276      * required by the EIP. See the note at the beginning of {ERC20}.
277      *
278      * NOTE: Does not update the allowance if the current allowance
279      * is the maximum `uint256`.
280      *
281      * Requirements:
282      *
283      * - `from` and `to` cannot be the zero address.
284      * - `from` must have a balance of at least `amount`.
285      * - the caller must have allowance for ``from``'s tokens of at least
286      * `amount`.
287      */
288     function transferFrom(
289         address from,
290         address to,
291         uint256 amount
292     ) public virtual override returns (bool) {
293         address spender = _msgSender();
294         _spendAllowance(from, spender, amount);
295         _transfer(from, to, amount);
296         return true;
297     }
298 
299     /**
300      * @dev Atomically increases the allowance granted to `spender` by the caller.
301      *
302      * This is an alternative to {approve} that can be used as a mitigation for
303      * problems described in {IERC20-approve}.
304      *
305      * Emits an {Approval} event indicating the updated allowance.
306      *
307      * Requirements:
308      *
309      * - `spender` cannot be the zero address.
310      */
311     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
312         address owner = _msgSender();
313         _approve(owner, spender, allowance(owner, spender) + addedValue);
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
332         address owner = _msgSender();
333         uint256 currentAllowance = allowance(owner, spender);
334         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
335         unchecked {
336             _approve(owner, spender, currentAllowance - subtractedValue);
337         }
338 
339         return true;
340     }
341 
342     /**
343      * @dev Moves `amount` of tokens from `sender` to `recipient`.
344      *
345      * This internal function is equivalent to {transfer}, and can be used to
346      * e.g. implement automatic token fees, slashing mechanisms, etc.
347      *
348      * Emits a {Transfer} event.
349      *
350      * Requirements:
351      *
352      * - `from` cannot be the zero address.
353      * - `to` cannot be the zero address.
354      * - `from` must have a balance of at least `amount`.
355      */
356     function _transfer(
357         address from,
358         address to,
359         uint256 amount
360     ) internal virtual {
361         require(from != address(0), "ERC20: transfer from the zero address");
362         require(to != address(0), "ERC20: transfer to the zero address");
363 
364         _beforeTokenTransfer(from, to, amount);
365 
366         uint256 fromBalance = _balances[from];
367         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
368         unchecked {
369             _balances[from] = fromBalance - amount;
370         }
371         _balances[to] += amount;
372 
373         emit Transfer(from, to, amount);
374 
375         _afterTokenTransfer(from, to, amount);
376     }
377 
378     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
379      * the total supply.
380      *
381      * Emits a {Transfer} event with `from` set to the zero address.
382      *
383      * Requirements:
384      *
385      * - `account` cannot be the zero address.
386      */
387     function _mint(address account, uint256 amount) internal virtual {
388         require(account != address(0), "ERC20: mint to the zero address");
389 
390         _beforeTokenTransfer(address(0), account, amount);
391 
392         _totalSupply += amount;
393         _balances[account] += amount;
394         emit Transfer(address(0), account, amount);
395 
396         _afterTokenTransfer(address(0), account, amount);
397     }
398 
399     /**
400      * @dev Destroys `amount` tokens from `account`, reducing the
401      * total supply.
402      *
403      * Emits a {Transfer} event with `to` set to the zero address.
404      *
405      * Requirements:
406      *
407      * - `account` cannot be the zero address.
408      * - `account` must have at least `amount` tokens.
409      */
410     function _burn(address account, uint256 amount) internal virtual {
411         require(account != address(0), "ERC20: burn from the zero address");
412 
413         _beforeTokenTransfer(account, address(0), amount);
414 
415         uint256 accountBalance = _balances[account];
416         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
417         unchecked {
418             _balances[account] = accountBalance - amount;
419         }
420         _totalSupply -= amount;
421 
422         emit Transfer(account, address(0), amount);
423 
424         _afterTokenTransfer(account, address(0), amount);
425     }
426 
427     /**
428      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
429      *
430      * This internal function is equivalent to `approve`, and can be used to
431      * e.g. set automatic allowances for certain subsystems, etc.
432      *
433      * Emits an {Approval} event.
434      *
435      * Requirements:
436      *
437      * - `owner` cannot be the zero address.
438      * - `spender` cannot be the zero address.
439      */
440     function _approve(
441         address owner,
442         address spender,
443         uint256 amount
444     ) internal virtual {
445         require(owner != address(0), "ERC20: approve from the zero address");
446         require(spender != address(0), "ERC20: approve to the zero address");
447 
448         _allowances[owner][spender] = amount;
449         emit Approval(owner, spender, amount);
450     }
451 
452     /**
453      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
454      *
455      * Does not update the allowance amount in case of infinite allowance.
456      * Revert if not enough allowance is available.
457      *
458      * Might emit an {Approval} event.
459      */
460     function _spendAllowance(
461         address owner,
462         address spender,
463         uint256 amount
464     ) internal virtual {
465         uint256 currentAllowance = allowance(owner, spender);
466         if (currentAllowance != type(uint256).max) {
467             require(currentAllowance >= amount, "ERC20: insufficient allowance");
468             unchecked {
469                 _approve(owner, spender, currentAllowance - amount);
470             }
471         }
472     }
473 
474     /**
475      * @dev Hook that is called before any transfer of tokens. This includes
476      * minting and burning.
477      *
478      * Calling conditions:
479      *
480      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
481      * will be transferred to `to`.
482      * - when `from` is zero, `amount` tokens will be minted for `to`.
483      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
484      * - `from` and `to` are never both zero.
485      *
486      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
487      */
488     function _beforeTokenTransfer(
489         address from,
490         address to,
491         uint256 amount
492     ) internal virtual {}
493 
494     /**
495      * @dev Hook that is called after any transfer of tokens. This includes
496      * minting and burning.
497      *
498      * Calling conditions:
499      *
500      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
501      * has been transferred to `to`.
502      * - when `from` is zero, `amount` tokens have been minted for `to`.
503      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
504      * - `from` and `to` are never both zero.
505      *
506      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
507      */
508     function _afterTokenTransfer(
509         address from,
510         address to,
511         uint256 amount
512     ) internal virtual {}
513 }
514 
515 
516 contract Fade is ERC20 {
517     constructor() ERC20("Fade", "FADE") {
518         _mint(msg.sender, 30000000000000 * 10 ** decimals());
519     }
520 	
521 }