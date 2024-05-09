1 // SPDX-License-Identifier: MIT
2 /*************************************************************************
3 
4 Twitter:https://twitter.com/Erc20Pogai
5 
6 ****************************************************************************/
7 
8 // File: @openzeppelin/contracts/utils/Context.sol
9 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
10 pragma solidity ^0.8.0;
11 /**
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30 
31 
32 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
33 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP.
38  */
39 interface IERC20 {
40     /**
41      * @dev Emitted when `value` tokens are moved from one account (`from`) to
42      * another (`to`).
43      *
44      * Note that `value` may be zero.
45      */
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 
48     /**
49      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
50      * a call to {approve}. `value` is the new allowance.
51      */
52     event Approval(address indexed owner, address indexed spender, uint256 value);
53 
54     /**
55      * @dev Returns the amount of tokens in existence.
56      */
57     function totalSupply() external view returns (uint256);
58 
59     /**
60      * @dev Returns the amount of tokens owned by `account`.
61      */
62     function balanceOf(address account) external view returns (uint256);
63 
64     /**
65      * @dev Moves `amount` tokens from the caller's account to `to`.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transfer(address to, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Returns the remaining number of tokens that `spender` will be
75      * allowed to spend on behalf of `owner` through {transferFrom}. This is
76      * zero by default.
77      *
78      * This value changes when {approve} or {transferFrom} are called.
79      */
80     function allowance(address owner, address spender) external view returns (uint256);
81 
82     /**
83      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * IMPORTANT: Beware that changing an allowance with this method brings the risk
88      * that someone may use both the old and the new allowance by unfortunate
89      * transaction ordering. One possible solution to mitigate this race
90      * condition is to first reduce the spender's allowance to 0 and set the
91      * desired value afterwards:
92      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
93      *
94      * Emits an {Approval} event.
95      */
96     function approve(address spender, uint256 amount) external returns (bool);
97 
98     /**
99      * @dev Moves `amount` tokens from `from` to `to` using the
100      * allowance mechanism. `amount` is then deducted from the caller's
101      * allowance.
102      *
103      * Returns a boolean value indicating whether the operation succeeded.
104      *
105      * Emits a {Transfer} event.
106      */
107     function transferFrom(
108         address from,
109         address to,
110         uint256 amount
111     ) external returns (bool);
112 }
113 
114 
115 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
116 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
117 pragma solidity ^0.8.0;
118 /**
119  * @dev Interface for the optional metadata functions from the ERC20 standard.
120  *
121  * _Available since v4.1._
122  */
123 interface IERC20Metadata is IERC20 {
124     /**
125      * @dev Returns the name of the token.
126      */
127     function name() external view returns (string memory);
128 
129     /**
130      * @dev Returns the symbol of the token.
131      */
132     function symbol() external view returns (string memory);
133 
134     /**
135      * @dev Returns the decimals places of the token.
136      */
137     function decimals() external view returns (uint8);
138 }
139 
140 
141 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
142 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
143 pragma solidity ^0.8.0;
144 
145 /**
146  * @dev Implementation of the {IERC20} interface.
147  *
148  * This implementation is agnostic to the way tokens are created. This means
149  * that a supply mechanism has to be added in a derived contract using {_mint}.
150  * For a generic mechanism see {ERC20PresetMinterPauser}.
151  *
152  * TIP: For a detailed writeup see our guide
153  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
154  * to implement supply mechanisms].
155  *
156  * We have followed general OpenZeppelin Contracts guidelines: functions revert
157  * instead returning `false` on failure. This behavior is nonetheless
158  * conventional and does not conflict with the expectations of ERC20
159  * applications.
160  *
161  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
162  * This allows applications to reconstruct the allowance for all accounts just
163  * by listening to said events. Other implementations of the EIP may not emit
164  * these events, as it isn't required by the specification.
165  *
166  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
167  * functions have been added to mitigate the well-known issues around setting
168  * allowances. See {IERC20-approve}.
169  */
170 contract ERC20 is Context, IERC20, IERC20Metadata {
171     mapping(address => uint256) private _balances;
172 
173     mapping(address => mapping(address => uint256)) private _allowances;
174 
175     uint256 private _totalSupply;
176 
177     string private _name;
178     string private _symbol;
179 
180     /**
181      * @dev Sets the values for {name} and {symbol}.
182      *
183      * The default value of {decimals} is 18. To select a different value for
184      * {decimals} you should overload it.
185      *
186      * All two of these values are immutable: they can only be set once during
187      * construction.
188      */
189     constructor(string memory name_, string memory symbol_) {
190         _name = name_;
191         _symbol = symbol_;
192     }
193 
194     /**
195      * @dev Returns the name of the token.
196      */
197     function name() public view virtual override returns (string memory) {
198         return _name;
199     }
200 
201     /**
202      * @dev Returns the symbol of the token, usually a shorter version of the
203      * name.
204      */
205     function symbol() public view virtual override returns (string memory) {
206         return _symbol;
207     }
208 
209     /**
210      * @dev Returns the number of decimals used to get its user representation.
211      * For example, if `decimals` equals `2`, a balance of `505` tokens should
212      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
213      *
214      * Tokens usually opt for a value of 18, imitating the relationship between
215      * Ether and Wei. This is the value {ERC20} uses, unless this function is
216      * overridden;
217      *
218      * NOTE: This information is only used for _display_ purposes: it in
219      * no way affects any of the arithmetic of the contract, including
220      * {IERC20-balanceOf} and {IERC20-transfer}.
221      */
222     function decimals() public view virtual override returns (uint8) {
223         return 18;
224     }
225 
226     /**
227      * @dev See {IERC20-totalSupply}.
228      */
229     function totalSupply() public view virtual override returns (uint256) {
230         return _totalSupply;
231     }
232 
233     /**
234      * @dev See {IERC20-balanceOf}.
235      */
236     function balanceOf(address account) public view virtual override returns (uint256) {
237         return _balances[account];
238     }
239 
240     /**
241      * @dev See {IERC20-transfer}.
242      *
243      * Requirements:
244      *
245      * - `to` cannot be the zero address.
246      * - the caller must have a balance of at least `amount`.
247      */
248     function transfer(address to, uint256 amount) public virtual override returns (bool) {
249         address owner = _msgSender();
250         _transfer(owner, to, amount);
251         return true;
252     }
253 
254     /**
255      * @dev See {IERC20-allowance}.
256      */
257     function allowance(address owner, address spender) public view virtual override returns (uint256) {
258         return _allowances[owner][spender];
259     }
260 
261     /**
262      * @dev See {IERC20-approve}.
263      *
264      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
265      * `transferFrom`. This is semantically equivalent to an infinite approval.
266      *
267      * Requirements:
268      *
269      * - `spender` cannot be the zero address.
270      */
271     function approve(address spender, uint256 amount) public virtual override returns (bool) {
272         address owner = _msgSender();
273         _approve(owner, spender, amount);
274         return true;
275     }
276 
277     /**
278      * @dev See {IERC20-transferFrom}.
279      *
280      * Emits an {Approval} event indicating the updated allowance. This is not
281      * required by the EIP. See the note at the beginning of {ERC20}.
282      *
283      * NOTE: Does not update the allowance if the current allowance
284      * is the maximum `uint256`.
285      *
286      * Requirements:
287      *
288      * - `from` and `to` cannot be the zero address.
289      * - `from` must have a balance of at least `amount`.
290      * - the caller must have allowance for ``from``'s tokens of at least
291      * `amount`.
292      */
293     function transferFrom(
294         address from,
295         address to,
296         uint256 amount
297     ) public virtual override returns (bool) {
298         address spender = _msgSender();
299         _spendAllowance(from, spender, amount);
300         _transfer(from, to, amount);
301         return true;
302     }
303 
304     /**
305      * @dev Atomically increases the allowance granted to `spender` by the caller.
306      *
307      * This is an alternative to {approve} that can be used as a mitigation for
308      * problems described in {IERC20-approve}.
309      *
310      * Emits an {Approval} event indicating the updated allowance.
311      *
312      * Requirements:
313      *
314      * - `spender` cannot be the zero address.
315      */
316     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
317         address owner = _msgSender();
318         _approve(owner, spender, allowance(owner, spender) + addedValue);
319         return true;
320     }
321 
322     /**
323      * @dev Atomically decreases the allowance granted to `spender` by the caller.
324      *
325      * This is an alternative to {approve} that can be used as a mitigation for
326      * problems described in {IERC20-approve}.
327      *
328      * Emits an {Approval} event indicating the updated allowance.
329      *
330      * Requirements:
331      *
332      * - `spender` cannot be the zero address.
333      * - `spender` must have allowance for the caller of at least
334      * `subtractedValue`.
335      */
336     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
337         address owner = _msgSender();
338         uint256 currentAllowance = allowance(owner, spender);
339         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
340         unchecked {
341             _approve(owner, spender, currentAllowance - subtractedValue);
342         }
343 
344         return true;
345     }
346 
347     /**
348      * @dev Moves `amount` of tokens from `from` to `to`.
349      *
350      * This internal function is equivalent to {transfer}, and can be used to
351      * e.g. implement automatic token fees, slashing mechanisms, etc.
352      *
353      * Emits a {Transfer} event.
354      *
355      * Requirements:
356      *
357      * - `from` cannot be the zero address.
358      * - `to` cannot be the zero address.
359      * - `from` must have a balance of at least `amount`.
360      */
361     function _transfer(
362         address from,
363         address to,
364         uint256 amount
365     ) internal virtual {
366         require(from != address(0), "ERC20: transfer from the zero address");
367         require(to != address(0), "ERC20: transfer to the zero address");
368 
369         _beforeTokenTransfer(from, to, amount);
370 
371         uint256 fromBalance = _balances[from];
372         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
373         unchecked {
374             _balances[from] = fromBalance - amount;
375             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
376             // decrementing then incrementing.
377             _balances[to] += amount;
378         }
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
400         unchecked {
401             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
402             _balances[account] += amount;
403         }
404         emit Transfer(address(0), account, amount);
405 
406         _afterTokenTransfer(address(0), account, amount);
407     }
408 
409     /**
410      * @dev Destroys `amount` tokens from `account`, reducing the
411      * total supply.
412      *
413      * Emits a {Transfer} event with `to` set to the zero address.
414      *
415      * Requirements:
416      *
417      * - `account` cannot be the zero address.
418      * - `account` must have at least `amount` tokens.
419      */
420     function _burn(address account, uint256 amount) internal virtual {
421         require(account != address(0), "ERC20: burn from the zero address");
422 
423         _beforeTokenTransfer(account, address(0), amount);
424 
425         uint256 accountBalance = _balances[account];
426         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
427         unchecked {
428             _balances[account] = accountBalance - amount;
429             // Overflow not possible: amount <= accountBalance <= totalSupply.
430             _totalSupply -= amount;
431         }
432 
433         emit Transfer(account, address(0), amount);
434 
435         _afterTokenTransfer(account, address(0), amount);
436     }
437 
438     /**
439      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
440      *
441      * This internal function is equivalent to `approve`, and can be used to
442      * e.g. set automatic allowances for certain subsystems, etc.
443      *
444      * Emits an {Approval} event.
445      *
446      * Requirements:
447      *
448      * - `owner` cannot be the zero address.
449      * - `spender` cannot be the zero address.
450      */
451     function _approve(
452         address owner,
453         address spender,
454         uint256 amount
455     ) internal virtual {
456         require(owner != address(0), "ERC20: approve from the zero address");
457         require(spender != address(0), "ERC20: approve to the zero address");
458 
459         _allowances[owner][spender] = amount;
460         emit Approval(owner, spender, amount);
461     }
462 
463     /**
464      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
465      *
466      * Does not update the allowance amount in case of infinite allowance.
467      * Revert if not enough allowance is available.
468      *
469      * Might emit an {Approval} event.
470      */
471     function _spendAllowance(
472         address owner,
473         address spender,
474         uint256 amount
475     ) internal virtual {
476         uint256 currentAllowance = allowance(owner, spender);
477         if (currentAllowance != type(uint256).max) {
478             require(currentAllowance >= amount, "ERC20: insufficient allowance");
479             unchecked {
480                 _approve(owner, spender, currentAllowance - amount);
481             }
482         }
483     }
484 
485     /**
486      * @dev Hook that is called before any transfer of tokens. This includes
487      * minting and burning.
488      *
489      * Calling conditions:
490      *
491      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
492      * will be transferred to `to`.
493      * - when `from` is zero, `amount` tokens will be minted for `to`.
494      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
495      * - `from` and `to` are never both zero.
496      *
497      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
498      */
499     function _beforeTokenTransfer(
500         address from,
501         address to,
502         uint256 amount
503     ) internal virtual {}
504 
505     /**
506      * @dev Hook that is called after any transfer of tokens. This includes
507      * minting and burning.
508      *
509      * Calling conditions:
510      *
511      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
512      * has been transferred to `to`.
513      * - when `from` is zero, `amount` tokens have been minted for `to`.
514      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
515      * - `from` and `to` are never both zero.
516      *
517      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
518      */
519     function _afterTokenTransfer(
520         address from,
521         address to,
522         uint256 amount
523     ) internal virtual {}
524 }
525 
526 pragma solidity ^0.8.0;
527 contract Pogai is ERC20 {
528     constructor() ERC20("Pogai", "Pogai") {
529         _mint(msg.sender, 1000 * 10 ** 9 * 10 ** decimals());
530     }
531 }