1 /** 
2  * ok I need TOKEN TO RELEASE, like VERY SOON. I cant take this anymore.
3  * every day I am checking updates and it is saying the same.
4  * every day, check progress, no progress.
5  * I cant take this anymore, I have been waiting way too long for this.
6  * it is what it is.
7  * but I need the token to RELEASE ALREADY.
8  * can devs DO SOMETHING??
9  */
10 
11 
12 
13 
14 
15 
16 
17 
18 
19 
20 
21 
22 
23 
24 
25 
26 
27 
28 
29 
30 
31 
32 
33 
34 // File: @openzeppelin/contracts/utils/Context.sol
35 
36 
37 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
38 
39 pragma solidity ^0.8.0;
40 
41 /**
42  * @dev Provides information about the current execution context, including the
43  * sender of the transaction and its data. While these are generally available
44  * via msg.sender and msg.data, they should not be accessed in such a direct
45  * manner, since when dealing with meta-transactions the account sending and
46  * paying for execution may not be the actual sender (as far as an application
47  * is concerned).
48  *
49  * This contract is only required for intermediate, library-like contracts.
50  */
51 abstract contract Context {
52     function _msgSender() internal view virtual returns (address) {
53         return msg.sender;
54     }
55 
56     function _msgData() internal view virtual returns (bytes calldata) {
57         return msg.data;
58     }
59 }
60 
61 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
62 
63 
64 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
65 
66 pragma solidity ^0.8.0;
67 
68 /**
69  * @dev Interface of the ERC20 standard as defined in the EIP.
70  */
71 interface IERC20 {
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 
86     /**
87      * @dev Returns the amount of tokens in existence.
88      */
89     function totalSupply() external view returns (uint256);
90 
91     /**
92      * @dev Returns the amount of tokens owned by `account`.
93      */
94     function balanceOf(address account) external view returns (uint256);
95 
96     /**
97      * @dev Moves `amount` tokens from the caller's account to `to`.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transfer(address to, uint256 amount) external returns (bool);
104 
105     /**
106      * @dev Returns the remaining number of tokens that `spender` will be
107      * allowed to spend on behalf of `owner` through {transferFrom}. This is
108      * zero by default.
109      *
110      * This value changes when {approve} or {transferFrom} are called.
111      */
112     function allowance(address owner, address spender) external view returns (uint256);
113 
114     /**
115      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
116      *
117      * Returns a boolean value indicating whether the operation succeeded.
118      *
119      * IMPORTANT: Beware that changing an allowance with this method brings the risk
120      * that someone may use both the old and the new allowance by unfortunate
121      * transaction ordering. One possible solution to mitigate this race
122      * condition is to first reduce the spender's allowance to 0 and set the
123      * desired value afterwards:
124      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
125      *
126      * Emits an {Approval} event.
127      */
128     function approve(address spender, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Moves `amount` tokens from `from` to `to` using the
132      * allowance mechanism. `amount` is then deducted from the caller's
133      * allowance.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * Emits a {Transfer} event.
138      */
139     function transferFrom(
140         address from,
141         address to,
142         uint256 amount
143     ) external returns (bool);
144 }
145 
146 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
147 
148 
149 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
150 
151 pragma solidity ^0.8.0;
152 
153 
154 /**
155  * @dev Interface for the optional metadata functions from the ERC20 standard.
156  *
157  * _Available since v4.1._
158  */
159 interface IERC20Metadata is IERC20 {
160     /**
161      * @dev Returns the name of the token.
162      */
163     function name() external view returns (string memory);
164 
165     /**
166      * @dev Returns the symbol of the token.
167      */
168     function symbol() external view returns (string memory);
169 
170     /**
171      * @dev Returns the decimals places of the token.
172      */
173     function decimals() external view returns (uint8);
174 }
175 
176 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
177 
178 
179 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
180 
181 pragma solidity ^0.8.0;
182 
183 
184 
185 
186 /**
187  * @dev Implementation of the {IERC20} interface.
188  *
189  * This implementation is agnostic to the way tokens are created. This means
190  * that a supply mechanism has to be added in a derived contract using {_mint}.
191  * For a generic mechanism see {ERC20PresetMinterPauser}.
192  *
193  * TIP: For a detailed writeup see our guide
194  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
195  * to implement supply mechanisms].
196  *
197  * We have followed general OpenZeppelin Contracts guidelines: functions revert
198  * instead returning `false` on failure. This behavior is nonetheless
199  * conventional and does not conflict with the expectations of ERC20
200  * applications.
201  *
202  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
203  * This allows applications to reconstruct the allowance for all accounts just
204  * by listening to said events. Other implementations of the EIP may not emit
205  * these events, as it isn't required by the specification.
206  *
207  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
208  * functions have been added to mitigate the well-known issues around setting
209  * allowances. See {IERC20-approve}.
210  */
211 contract ERC20 is Context, IERC20, IERC20Metadata {
212     mapping(address => uint256) private _balances;
213 
214     mapping(address => mapping(address => uint256)) private _allowances;
215 
216     uint256 private _totalSupply;
217 
218     string private _name;
219     string private _symbol;
220 
221     /**
222      * @dev Sets the values for {name} and {symbol}.
223      *
224      * The default value of {decimals} is 18. To select a different value for
225      * {decimals} you should overload it.
226      *
227      * All two of these values are immutable: they can only be set once during
228      * construction.
229      */
230     constructor(string memory name_, string memory symbol_) {
231         _name = name_;
232         _symbol = symbol_;
233     }
234 
235     /**
236      * @dev Returns the name of the token.
237      */
238     function name() public view virtual override returns (string memory) {
239         return _name;
240     }
241 
242     /**
243      * @dev Returns the symbol of the token, usually a shorter version of the
244      * name.
245      */
246     function symbol() public view virtual override returns (string memory) {
247         return _symbol;
248     }
249 
250     /**
251      * @dev Returns the number of decimals used to get its user representation.
252      * For example, if `decimals` equals `2`, a balance of `505` tokens should
253      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
254      *
255      * Tokens usually opt for a value of 18, imitating the relationship between
256      * Ether and Wei. This is the value {ERC20} uses, unless this function is
257      * overridden;
258      *
259      * NOTE: This information is only used for _display_ purposes: it in
260      * no way affects any of the arithmetic of the contract, including
261      * {IERC20-balanceOf} and {IERC20-transfer}.
262      */
263     function decimals() public view virtual override returns (uint8) {
264         return 18;
265     }
266 
267     /**
268      * @dev See {IERC20-totalSupply}.
269      */
270     function totalSupply() public view virtual override returns (uint256) {
271         return _totalSupply;
272     }
273 
274     /**
275      * @dev See {IERC20-balanceOf}.
276      */
277     function balanceOf(address account) public view virtual override returns (uint256) {
278         return _balances[account];
279     }
280 
281     /**
282      * @dev See {IERC20-transfer}.
283      *
284      * Requirements:
285      *
286      * - `to` cannot be the zero address.
287      * - the caller must have a balance of at least `amount`.
288      */
289     function transfer(address to, uint256 amount) public virtual override returns (bool) {
290         address owner = _msgSender();
291         _transfer(owner, to, amount);
292         return true;
293     }
294 
295     /**
296      * @dev See {IERC20-allowance}.
297      */
298     function allowance(address owner, address spender) public view virtual override returns (uint256) {
299         return _allowances[owner][spender];
300     }
301 
302     /**
303      * @dev See {IERC20-approve}.
304      *
305      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
306      * `transferFrom`. This is semantically equivalent to an infinite approval.
307      *
308      * Requirements:
309      *
310      * - `spender` cannot be the zero address.
311      */
312     function approve(address spender, uint256 amount) public virtual override returns (bool) {
313         address owner = _msgSender();
314         _approve(owner, spender, amount);
315         return true;
316     }
317 
318     /**
319      * @dev See {IERC20-transferFrom}.
320      *
321      * Emits an {Approval} event indicating the updated allowance. This is not
322      * required by the EIP. See the note at the beginning of {ERC20}.
323      *
324      * NOTE: Does not update the allowance if the current allowance
325      * is the maximum `uint256`.
326      *
327      * Requirements:
328      *
329      * - `from` and `to` cannot be the zero address.
330      * - `from` must have a balance of at least `amount`.
331      * - the caller must have allowance for ``from``'s tokens of at least
332      * `amount`.
333      */
334     function transferFrom(
335         address from,
336         address to,
337         uint256 amount
338     ) public virtual override returns (bool) {
339         address spender = _msgSender();
340         _spendAllowance(from, spender, amount);
341         _transfer(from, to, amount);
342         return true;
343     }
344 
345     /**
346      * @dev Atomically increases the allowance granted to `spender` by the caller.
347      *
348      * This is an alternative to {approve} that can be used as a mitigation for
349      * problems described in {IERC20-approve}.
350      *
351      * Emits an {Approval} event indicating the updated allowance.
352      *
353      * Requirements:
354      *
355      * - `spender` cannot be the zero address.
356      */
357     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
358         address owner = _msgSender();
359         _approve(owner, spender, allowance(owner, spender) + addedValue);
360         return true;
361     }
362 
363     /**
364      * @dev Atomically decreases the allowance granted to `spender` by the caller.
365      *
366      * This is an alternative to {approve} that can be used as a mitigation for
367      * problems described in {IERC20-approve}.
368      *
369      * Emits an {Approval} event indicating the updated allowance.
370      *
371      * Requirements:
372      *
373      * - `spender` cannot be the zero address.
374      * - `spender` must have allowance for the caller of at least
375      * `subtractedValue`.
376      */
377     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
378         address owner = _msgSender();
379         uint256 currentAllowance = allowance(owner, spender);
380         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
381         unchecked {
382             _approve(owner, spender, currentAllowance - subtractedValue);
383         }
384 
385         return true;
386     }
387 
388     /**
389      * @dev Moves `amount` of tokens from `from` to `to`.
390      *
391      * This internal function is equivalent to {transfer}, and can be used to
392      * e.g. implement automatic token fees, slashing mechanisms, etc.
393      *
394      * Emits a {Transfer} event.
395      *
396      * Requirements:
397      *
398      * - `from` cannot be the zero address.
399      * - `to` cannot be the zero address.
400      * - `from` must have a balance of at least `amount`.
401      */
402     function _transfer(
403         address from,
404         address to,
405         uint256 amount
406     ) internal virtual {
407         require(from != address(0), "ERC20: transfer from the zero address");
408         require(to != address(0), "ERC20: transfer to the zero address");
409 
410         _beforeTokenTransfer(from, to, amount);
411 
412         uint256 fromBalance = _balances[from];
413         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
414         unchecked {
415             _balances[from] = fromBalance - amount;
416             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
417             // decrementing then incrementing.
418             _balances[to] += amount;
419         }
420 
421         emit Transfer(from, to, amount);
422 
423         _afterTokenTransfer(from, to, amount);
424     }
425 
426     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
427      * the total supply.
428      *
429      * Emits a {Transfer} event with `from` set to the zero address.
430      *
431      * Requirements:
432      *
433      * - `account` cannot be the zero address.
434      */
435     function _mint(address account, uint256 amount) internal virtual {
436         require(account != address(0), "ERC20: mint to the zero address");
437 
438         _beforeTokenTransfer(address(0), account, amount);
439 
440         _totalSupply += amount;
441         unchecked {
442             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
443             _balances[account] += amount;
444         }
445         emit Transfer(address(0), account, amount);
446 
447         _afterTokenTransfer(address(0), account, amount);
448     }
449 
450     /**
451      * @dev Destroys `amount` tokens from `account`, reducing the
452      * total supply.
453      *
454      * Emits a {Transfer} event with `to` set to the zero address.
455      *
456      * Requirements:
457      *
458      * - `account` cannot be the zero address.
459      * - `account` must have at least `amount` tokens.
460      */
461     function _burn(address account, uint256 amount) internal virtual {
462         require(account != address(0), "ERC20: burn from the zero address");
463 
464         _beforeTokenTransfer(account, address(0), amount);
465 
466         uint256 accountBalance = _balances[account];
467         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
468         unchecked {
469             _balances[account] = accountBalance - amount;
470             // Overflow not possible: amount <= accountBalance <= totalSupply.
471             _totalSupply -= amount;
472         }
473 
474         emit Transfer(account, address(0), amount);
475 
476         _afterTokenTransfer(account, address(0), amount);
477     }
478 
479     /**
480      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
481      *
482      * This internal function is equivalent to `approve`, and can be used to
483      * e.g. set automatic allowances for certain subsystems, etc.
484      *
485      * Emits an {Approval} event.
486      *
487      * Requirements:
488      *
489      * - `owner` cannot be the zero address.
490      * - `spender` cannot be the zero address.
491      */
492     function _approve(
493         address owner,
494         address spender,
495         uint256 amount
496     ) internal virtual {
497         require(owner != address(0), "ERC20: approve from the zero address");
498         require(spender != address(0), "ERC20: approve to the zero address");
499 
500         _allowances[owner][spender] = amount;
501         emit Approval(owner, spender, amount);
502     }
503 
504     /**
505      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
506      *
507      * Does not update the allowance amount in case of infinite allowance.
508      * Revert if not enough allowance is available.
509      *
510      * Might emit an {Approval} event.
511      */
512     function _spendAllowance(
513         address owner,
514         address spender,
515         uint256 amount
516     ) internal virtual {
517         uint256 currentAllowance = allowance(owner, spender);
518         if (currentAllowance != type(uint256).max) {
519             require(currentAllowance >= amount, "ERC20: insufficient allowance");
520             unchecked {
521                 _approve(owner, spender, currentAllowance - amount);
522             }
523         }
524     }
525 
526     /**
527      * @dev Hook that is called before any transfer of tokens. This includes
528      * minting and burning.
529      *
530      * Calling conditions:
531      *
532      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
533      * will be transferred to `to`.
534      * - when `from` is zero, `amount` tokens will be minted for `to`.
535      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
536      * - `from` and `to` are never both zero.
537      *
538      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
539      */
540     function _beforeTokenTransfer(
541         address from,
542         address to,
543         uint256 amount
544     ) internal virtual {}
545 
546     /**
547      * @dev Hook that is called after any transfer of tokens. This includes
548      * minting and burning.
549      *
550      * Calling conditions:
551      *
552      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
553      * has been transferred to `to`.
554      * - when `from` is zero, `amount` tokens have been minted for `to`.
555      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
556      * - `from` and `to` are never both zero.
557      *
558      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
559      */
560     function _afterTokenTransfer(
561         address from,
562         address to,
563         uint256 amount
564     ) internal virtual {}
565 }
566 
567 // File: Four.sol
568 
569 
570 pragma solidity ^0.8.19;
571 
572 
573 
574 contract Four is ERC20 {
575     constructor(address project, uint _supply) ERC20("Four", "FOUR") {
576         _mint(project, _supply);
577     }
578 }