1 // Sources flattened with hardhat v2.6.7 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.3.2
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount)
31         external
32         returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender)
42         external
43         view
44         returns (uint256);
45 
46     /**
47      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * IMPORTANT: Beware that changing an allowance with this method brings the risk
52      * that someone may use both the old and the new allowance by unfortunate
53      * transaction ordering. One possible solution to mitigate this race
54      * condition is to first reduce the spender's allowance to 0 and set the
55      * desired value afterwards:
56      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
57      *
58      * Emits an {Approval} event.
59      */
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Moves `amount` tokens from `sender` to `recipient` using the
64      * allowance mechanism. `amount` is then deducted from the caller's
65      * allowance.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transferFrom(
72         address sender,
73         address recipient,
74         uint256 amount
75     ) external returns (bool);
76 
77     /**
78      * @dev Emitted when `value` tokens are moved from one account (`from`) to
79      * another (`to`).
80      *
81      * Note that `value` may be zero.
82      */
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 
85     /**
86      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
87      * a call to {approve}. `value` is the new allowance.
88      */
89     event Approval(
90         address indexed owner,
91         address indexed spender,
92         uint256 value
93     );
94 }
95 
96 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.3.2
97 
98 pragma solidity ^0.8.0;
99 
100 /**
101  * @dev Interface for the optional metadata functions from the ERC20 standard.
102  *
103  * _Available since v4.1._
104  */
105 interface IERC20Metadata is IERC20 {
106     /**
107      * @dev Returns the name of the token.
108      */
109     function name() external view returns (string memory);
110 
111     /**
112      * @dev Returns the symbol of the token.
113      */
114     function symbol() external view returns (string memory);
115 
116     /**
117      * @dev Returns the decimals places of the token.
118      */
119     function decimals() external view returns (uint8);
120 }
121 
122 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
123 
124 pragma solidity ^0.8.0;
125 
126 /**
127  * @dev Provides information about the current execution context, including the
128  * sender of the transaction and its data. While these are generally available
129  * via msg.sender and msg.data, they should not be accessed in such a direct
130  * manner, since when dealing with meta-transactions the account sending and
131  * paying for execution may not be the actual sender (as far as an application
132  * is concerned).
133  *
134  * This contract is only required for intermediate, library-like contracts.
135  */
136 abstract contract Context {
137     function _msgSender() internal view virtual returns (address) {
138         return msg.sender;
139     }
140 
141     function _msgData() internal view virtual returns (bytes calldata) {
142         return msg.data;
143     }
144 }
145 
146 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.3.2
147 
148 pragma solidity ^0.8.0;
149 
150 /**
151  * @dev Implementation of the {IERC20} interface.
152  *
153  * This implementation is agnostic to the way tokens are created. This means
154  * that a supply mechanism has to be added in a derived contract using {_mint}.
155  * For a generic mechanism see {ERC20PresetMinterPauser}.
156  *
157  * TIP: For a detailed writeup see our guide
158  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
159  * to implement supply mechanisms].
160  *
161  * We have followed general OpenZeppelin Contracts guidelines: functions revert
162  * instead returning `false` on failure. This behavior is nonetheless
163  * conventional and does not conflict with the expectations of ERC20
164  * applications.
165  *
166  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
167  * This allows applications to reconstruct the allowance for all accounts just
168  * by listening to said events. Other implementations of the EIP may not emit
169  * these events, as it isn't required by the specification.
170  *
171  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
172  * functions have been added to mitigate the well-known issues around setting
173  * allowances. See {IERC20-approve}.
174  */
175 contract ERC20 is Context, IERC20, IERC20Metadata {
176     mapping(address => uint256) private _balances;
177 
178     mapping(address => mapping(address => uint256)) private _allowances;
179 
180     uint256 private _totalSupply;
181 
182     string private _name;
183     string private _symbol;
184 
185     /**
186      * @dev Sets the values for {name} and {symbol}.
187      *
188      * The default value of {decimals} is 18. To select a different value for
189      * {decimals} you should overload it.
190      *
191      * All two of these values are immutable: they can only be set once during
192      * construction.
193      */
194     constructor(string memory name_, string memory symbol_) {
195         _name = name_;
196         _symbol = symbol_;
197     }
198 
199     /**
200      * @dev Returns the name of the token.
201      */
202     function name() public view virtual override returns (string memory) {
203         return _name;
204     }
205 
206     /**
207      * @dev Returns the symbol of the token, usually a shorter version of the
208      * name.
209      */
210     function symbol() public view virtual override returns (string memory) {
211         return _symbol;
212     }
213 
214     /**
215      * @dev Returns the number of decimals used to get its user representation.
216      * For example, if `decimals` equals `2`, a balance of `505` tokens should
217      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
218      *
219      * Tokens usually opt for a value of 18, imitating the relationship between
220      * Ether and Wei. This is the value {ERC20} uses, unless this function is
221      * overridden;
222      *
223      * NOTE: This information is only used for _display_ purposes: it in
224      * no way affects any of the arithmetic of the contract, including
225      * {IERC20-balanceOf} and {IERC20-transfer}.
226      */
227     function decimals() public view virtual override returns (uint8) {
228         return 18;
229     }
230 
231     /**
232      * @dev See {IERC20-totalSupply}.
233      */
234     function totalSupply() public view virtual override returns (uint256) {
235         return _totalSupply;
236     }
237 
238     /**
239      * @dev See {IERC20-balanceOf}.
240      */
241     function balanceOf(address account)
242         public
243         view
244         virtual
245         override
246         returns (uint256)
247     {
248         return _balances[account];
249     }
250 
251     /**
252      * @dev See {IERC20-transfer}.
253      *
254      * Requirements:
255      *
256      * - `recipient` cannot be the zero address.
257      * - the caller must have a balance of at least `amount`.
258      */
259     function transfer(address recipient, uint256 amount)
260         public
261         virtual
262         override
263         returns (bool)
264     {
265         _transfer(_msgSender(), recipient, amount);
266         return true;
267     }
268 
269     /**
270      * @dev See {IERC20-allowance}.
271      */
272     function allowance(address owner, address spender)
273         public
274         view
275         virtual
276         override
277         returns (uint256)
278     {
279         return _allowances[owner][spender];
280     }
281 
282     /**
283      * @dev See {IERC20-approve}.
284      *
285      * Requirements:
286      *
287      * - `spender` cannot be the zero address.
288      */
289     function approve(address spender, uint256 amount)
290         public
291         virtual
292         override
293         returns (bool)
294     {
295         _approve(_msgSender(), spender, amount);
296         return true;
297     }
298 
299     /**
300      * @dev See {IERC20-transferFrom}.
301      *
302      * Emits an {Approval} event indicating the updated allowance. This is not
303      * required by the EIP. See the note at the beginning of {ERC20}.
304      *
305      * Requirements:
306      *
307      * - `sender` and `recipient` cannot be the zero address.
308      * - `sender` must have a balance of at least `amount`.
309      * - the caller must have allowance for ``sender``'s tokens of at least
310      * `amount`.
311      */
312     function transferFrom(
313         address sender,
314         address recipient,
315         uint256 amount
316     ) public virtual override returns (bool) {
317         _transfer(sender, recipient, amount);
318 
319         uint256 currentAllowance = _allowances[sender][_msgSender()];
320         require(
321             currentAllowance >= amount,
322             'ERC20: transfer amount exceeds allowance'
323         );
324         unchecked {
325             _approve(sender, _msgSender(), currentAllowance - amount);
326         }
327 
328         return true;
329     }
330 
331     /**
332      * @dev Atomically increases the allowance granted to `spender` by the caller.
333      *
334      * This is an alternative to {approve} that can be used as a mitigation for
335      * problems described in {IERC20-approve}.
336      *
337      * Emits an {Approval} event indicating the updated allowance.
338      *
339      * Requirements:
340      *
341      * - `spender` cannot be the zero address.
342      */
343     function increaseAllowance(address spender, uint256 addedValue)
344         public
345         virtual
346         returns (bool)
347     {
348         _approve(
349             _msgSender(),
350             spender,
351             _allowances[_msgSender()][spender] + addedValue
352         );
353         return true;
354     }
355 
356     /**
357      * @dev Atomically decreases the allowance granted to `spender` by the caller.
358      *
359      * This is an alternative to {approve} that can be used as a mitigation for
360      * problems described in {IERC20-approve}.
361      *
362      * Emits an {Approval} event indicating the updated allowance.
363      *
364      * Requirements:
365      *
366      * - `spender` cannot be the zero address.
367      * - `spender` must have allowance for the caller of at least
368      * `subtractedValue`.
369      */
370     function decreaseAllowance(address spender, uint256 subtractedValue)
371         public
372         virtual
373         returns (bool)
374     {
375         uint256 currentAllowance = _allowances[_msgSender()][spender];
376         require(
377             currentAllowance >= subtractedValue,
378             'ERC20: decreased allowance below zero'
379         );
380         unchecked {
381             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
382         }
383 
384         return true;
385     }
386 
387     /**
388      * @dev Moves `amount` of tokens from `sender` to `recipient`.
389      *
390      * This internal function is equivalent to {transfer}, and can be used to
391      * e.g. implement automatic token fees, slashing mechanisms, etc.
392      *
393      * Emits a {Transfer} event.
394      *
395      * Requirements:
396      *
397      * - `sender` cannot be the zero address.
398      * - `recipient` cannot be the zero address.
399      * - `sender` must have a balance of at least `amount`.
400      */
401     function _transfer(
402         address sender,
403         address recipient,
404         uint256 amount
405     ) internal virtual {
406         require(sender != address(0), 'ERC20: transfer from the zero address');
407         require(recipient != address(0), 'ERC20: transfer to the zero address');
408 
409         _beforeTokenTransfer(sender, recipient, amount);
410 
411         uint256 senderBalance = _balances[sender];
412         require(
413             senderBalance >= amount,
414             'ERC20: transfer amount exceeds balance'
415         );
416         unchecked {
417             _balances[sender] = senderBalance - amount;
418         }
419         _balances[recipient] += amount;
420 
421         emit Transfer(sender, recipient, amount);
422 
423         _afterTokenTransfer(sender, recipient, amount);
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
436         require(account != address(0), 'ERC20: mint to the zero address');
437 
438         _beforeTokenTransfer(address(0), account, amount);
439 
440         _totalSupply += amount;
441         _balances[account] += amount;
442         emit Transfer(address(0), account, amount);
443 
444         _afterTokenTransfer(address(0), account, amount);
445     }
446 
447     /**
448      * @dev Destroys `amount` tokens from `account`, reducing the
449      * total supply.
450      *
451      * Emits a {Transfer} event with `to` set to the zero address.
452      *
453      * Requirements:
454      *
455      * - `account` cannot be the zero address.
456      * - `account` must have at least `amount` tokens.
457      */
458     function _burn(address account, uint256 amount) internal virtual {
459         require(account != address(0), 'ERC20: burn from the zero address');
460 
461         _beforeTokenTransfer(account, address(0), amount);
462 
463         uint256 accountBalance = _balances[account];
464         require(accountBalance >= amount, 'ERC20: burn amount exceeds balance');
465         unchecked {
466             _balances[account] = accountBalance - amount;
467         }
468         _totalSupply -= amount;
469 
470         emit Transfer(account, address(0), amount);
471 
472         _afterTokenTransfer(account, address(0), amount);
473     }
474 
475     /**
476      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
477      *
478      * This internal function is equivalent to `approve`, and can be used to
479      * e.g. set automatic allowances for certain subsystems, etc.
480      *
481      * Emits an {Approval} event.
482      *
483      * Requirements:
484      *
485      * - `owner` cannot be the zero address.
486      * - `spender` cannot be the zero address.
487      */
488     function _approve(
489         address owner,
490         address spender,
491         uint256 amount
492     ) internal virtual {
493         require(owner != address(0), 'ERC20: approve from the zero address');
494         require(spender != address(0), 'ERC20: approve to the zero address');
495 
496         _allowances[owner][spender] = amount;
497         emit Approval(owner, spender, amount);
498     }
499 
500     /**
501      * @dev Hook that is called before any transfer of tokens. This includes
502      * minting and burning.
503      *
504      * Calling conditions:
505      *
506      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
507      * will be transferred to `to`.
508      * - when `from` is zero, `amount` tokens will be minted for `to`.
509      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
510      * - `from` and `to` are never both zero.
511      *
512      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
513      */
514     function _beforeTokenTransfer(
515         address from,
516         address to,
517         uint256 amount
518     ) internal virtual {}
519 
520     /**
521      * @dev Hook that is called after any transfer of tokens. This includes
522      * minting and burning.
523      *
524      * Calling conditions:
525      *
526      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
527      * has been transferred to `to`.
528      * - when `from` is zero, `amount` tokens have been minted for `to`.
529      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
530      * - `from` and `to` are never both zero.
531      *
532      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
533      */
534     function _afterTokenTransfer(
535         address from,
536         address to,
537         uint256 amount
538     ) internal virtual {}
539 }
540 
541 // File contracts/TanksERC20.sol
542 
543 pragma solidity ^0.8.7;
544 
545 contract TANKS is ERC20 {
546     constructor(uint256 initialSupply) ERC20('Tanks', 'TANKS') {
547         _mint(_msgSender(), initialSupply);
548     }
549 }