1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Context.sol
3 
4 /**
5  *   $$$$$$$$
6  *   $
7  *   $
8  *   $$$$$$$$
9  *   $
10  *   $
11  *   $
12  *
13  *   $      $
14  *   $      $
15  *   $      $
16  *   $      $
17  *   $      $
18  *   $$$$$$$$
19  *
20  *   $$$$$$$
21  *   $
22  *   $
23  *   $
24  *   $
25  *   $$$$$$$
26  *
27  *   $      $
28  *   $     $
29  *   $   $
30  *   $ $ 
31  *   $   $
32  *   $     $
33  *   $       $
34 */
35 
36 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 /**
41  * @dev Provides information about the current execution context, including the
42  * sender of the transaction and its data. While these are generally available
43  * via msg.sender and msg.data, they should not be accessed in such a direct
44  * manner, since when dealing with meta-transactions the account sending and
45  * paying for execution may not be the actual sender (as far as an application
46  * is concerned).
47  *
48  * This contract is only required for intermediate, library-like contracts.
49  */
50 abstract contract Context {
51     function _msgSender() internal view virtual returns (address) {
52         return msg.sender;
53     }
54 
55     function _msgData() internal view virtual returns (bytes calldata) {
56         return msg.data;
57     }
58 }
59 
60 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
61 
62 
63 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
64 
65 pragma solidity ^0.8.0;
66 
67 /**
68  * @dev Interface of the ERC20 standard as defined in the EIP.
69  */
70 interface IERC20 {
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 
85     /**
86      * @dev Returns the amount of tokens in existence.
87      */
88     function totalSupply() external view returns (uint256);
89 
90     /**
91      * @dev Returns the amount of tokens owned by `account`.
92      */
93     function balanceOf(address account) external view returns (uint256);
94 
95     /**
96      * @dev Moves `amount` tokens from the caller's account to `to`.
97      *
98      * Returns a boolean value indicating whether the operation succeeded.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transfer(address to, uint256 amount) external returns (bool);
103 
104     /**
105      * @dev Returns the remaining number of tokens that `spender` will be
106      * allowed to spend on behalf of `owner` through {transferFrom}. This is
107      * zero by default.
108      *
109      * This value changes when {approve} or {transferFrom} are called.
110      */
111     function allowance(address owner, address spender) external view returns (uint256);
112 
113     /**
114      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
115      *
116      * Returns a boolean value indicating whether the operation succeeded.
117      *
118      * IMPORTANT: Beware that changing an allowance with this method brings the risk
119      * that someone may use both the old and the new allowance by unfortunate
120      * transaction ordering. One possible solution to mitigate this race
121      * condition is to first reduce the spender's allowance to 0 and set the
122      * desired value afterwards:
123      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
124      *
125      * Emits an {Approval} event.
126      */
127     function approve(address spender, uint256 amount) external returns (bool);
128 
129     /**
130      * @dev Moves `amount` tokens from `from` to `to` using the
131      * allowance mechanism. `amount` is then deducted from the caller's
132      * allowance.
133      *
134      * Returns a boolean value indicating whether the operation succeeded.
135      *
136      * Emits a {Transfer} event.
137      */
138     function transferFrom(
139         address from,
140         address to,
141         uint256 amount
142     ) external returns (bool);
143 }
144 
145 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
146 
147 
148 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 
153 /**
154  * @dev Interface for the optional metadata functions from the ERC20 standard.
155  *
156  * _Available since v4.1._
157  */
158 interface IERC20Metadata is IERC20 {
159     /**
160      * @dev Returns the name of the token.
161      */
162     function name() external view returns (string memory);
163 
164     /**
165      * @dev Returns the symbol of the token.
166      */
167     function symbol() external view returns (string memory);
168 
169     /**
170      * @dev Returns the decimals places of the token.
171      */
172     function decimals() external view returns (uint8);
173 }
174 
175 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
176 
177 
178 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
179 
180 pragma solidity ^0.8.0;
181 
182 
183 
184 
185 /**
186  * @dev Implementation of the {IERC20} interface.
187  *
188  * This implementation is agnostic to the way tokens are created. This means
189  * that a supply mechanism has to be added in a derived contract using {_mint}.
190  * For a generic mechanism see {ERC20PresetMinterPauser}.
191  *
192  * TIP: For a detailed writeup see our guide
193  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
194  * to implement supply mechanisms].
195  *
196  * We have followed general OpenZeppelin Contracts guidelines: functions revert
197  * instead returning `false` on failure. This behavior is nonetheless
198  * conventional and does not conflict with the expectations of ERC20
199  * applications.
200  *
201  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
202  * This allows applications to reconstruct the allowance for all accounts just
203  * by listening to said events. Other implementations of the EIP may not emit
204  * these events, as it isn't required by the specification.
205  *
206  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
207  * functions have been added to mitigate the well-known issues around setting
208  * allowances. See {IERC20-approve}.
209  */
210 contract ERC20 is Context, IERC20, IERC20Metadata {
211     mapping(address => uint256) private _balances;
212 
213     mapping(address => mapping(address => uint256)) private _allowances;
214 
215     uint256 private _totalSupply;
216 
217     string private _name;
218     string private _symbol;
219 
220     /**
221      * @dev Sets the values for {name} and {symbol}.
222      *
223      * The default value of {decimals} is 18. To select a different value for
224      * {decimals} you should overload it.
225      *
226      * All two of these values are immutable: they can only be set once during
227      * construction.
228      */
229     constructor(string memory name_, string memory symbol_) {
230         _name = name_;
231         _symbol = symbol_;
232     }
233 
234     /**
235      * @dev Returns the name of the token.
236      */
237     function name() public view virtual override returns (string memory) {
238         return _name;
239     }
240 
241     /**
242      * @dev Returns the symbol of the token, usually a shorter version of the
243      * name.
244      */
245     function symbol() public view virtual override returns (string memory) {
246         return _symbol;
247     }
248 
249     /**
250      * @dev Returns the number of decimals used to get its user representation.
251      * For example, if `decimals` equals `2`, a balance of `505` tokens should
252      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
253      *
254      * Tokens usually opt for a value of 18, imitating the relationship between
255      * Ether and Wei. This is the value {ERC20} uses, unless this function is
256      * overridden;
257      *
258      * NOTE: This information is only used for _display_ purposes: it in
259      * no way affects any of the arithmetic of the contract, including
260      * {IERC20-balanceOf} and {IERC20-transfer}.
261      */
262     function decimals() public view virtual override returns (uint8) {
263         return 18;
264     }
265 
266     /**
267      * @dev See {IERC20-totalSupply}.
268      */
269     function totalSupply() public view virtual override returns (uint256) {
270         return _totalSupply;
271     }
272 
273     /**
274      * @dev See {IERC20-balanceOf}.
275      */
276     function balanceOf(address account) public view virtual override returns (uint256) {
277         return _balances[account];
278     }
279 
280     /**
281      * @dev See {IERC20-transfer}.
282      *
283      * Requirements:
284      *
285      * - `to` cannot be the zero address.
286      * - the caller must have a balance of at least `amount`.
287      */
288     function transfer(address to, uint256 amount) public virtual override returns (bool) {
289         address owner = _msgSender();
290         _transfer(owner, to, amount);
291         return true;
292     }
293 
294     /**
295      * @dev See {IERC20-allowance}.
296      */
297     function allowance(address owner, address spender) public view virtual override returns (uint256) {
298         return _allowances[owner][spender];
299     }
300 
301     /**
302      * @dev See {IERC20-approve}.
303      *
304      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
305      * `transferFrom`. This is semantically equivalent to an infinite approval.
306      *
307      * Requirements:
308      *
309      * - `spender` cannot be the zero address.
310      */
311     function approve(address spender, uint256 amount) public virtual override returns (bool) {
312         address owner = _msgSender();
313         _approve(owner, spender, amount);
314         return true;
315     }
316 
317     /**
318      * @dev See {IERC20-transferFrom}.
319      *
320      * Emits an {Approval} event indicating the updated allowance. This is not
321      * required by the EIP. See the note at the beginning of {ERC20}.
322      *
323      * NOTE: Does not update the allowance if the current allowance
324      * is the maximum `uint256`.
325      *
326      * Requirements:
327      *
328      * - `from` and `to` cannot be the zero address.
329      * - `from` must have a balance of at least `amount`.
330      * - the caller must have allowance for ``from``'s tokens of at least
331      * `amount`.
332      */
333     function transferFrom(
334         address from,
335         address to,
336         uint256 amount
337     ) public virtual override returns (bool) {
338         address spender = _msgSender();
339         _spendAllowance(from, spender, amount);
340         _transfer(from, to, amount);
341         return true;
342     }
343 
344     /**
345      * @dev Atomically increases the allowance granted to `spender` by the caller.
346      *
347      * This is an alternative to {approve} that can be used as a mitigation for
348      * problems described in {IERC20-approve}.
349      *
350      * Emits an {Approval} event indicating the updated allowance.
351      *
352      * Requirements:
353      *
354      * - `spender` cannot be the zero address.
355      */
356     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
357         address owner = _msgSender();
358         _approve(owner, spender, allowance(owner, spender) + addedValue);
359         return true;
360     }
361 
362     /**
363      * @dev Atomically decreases the allowance granted to `spender` by the caller.
364      *
365      * This is an alternative to {approve} that can be used as a mitigation for
366      * problems described in {IERC20-approve}.
367      *
368      * Emits an {Approval} event indicating the updated allowance.
369      *
370      * Requirements:
371      *
372      * - `spender` cannot be the zero address.
373      * - `spender` must have allowance for the caller of at least
374      * `subtractedValue`.
375      */
376     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
377         address owner = _msgSender();
378         uint256 currentAllowance = allowance(owner, spender);
379         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
380         unchecked {
381             _approve(owner, spender, currentAllowance - subtractedValue);
382         }
383 
384         return true;
385     }
386 
387     /**
388      * @dev Moves `amount` of tokens from `from` to `to`.
389      *
390      * This internal function is equivalent to {transfer}, and can be used to
391      * e.g. implement automatic token fees, slashing mechanisms, etc.
392      *
393      * Emits a {Transfer} event.
394      *
395      * Requirements:
396      *
397      * - `from` cannot be the zero address.
398      * - `to` cannot be the zero address.
399      * - `from` must have a balance of at least `amount`.
400      */
401     function _transfer(
402         address from,
403         address to,
404         uint256 amount
405     ) internal virtual {
406         require(from != address(0), "ERC20: transfer from the zero address");
407         require(to != address(0), "ERC20: transfer to the zero address");
408 
409         _beforeTokenTransfer(from, to, amount);
410 
411         uint256 fromBalance = _balances[from];
412         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
413         unchecked {
414             _balances[from] = fromBalance - amount;
415             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
416             // decrementing then incrementing.
417             _balances[to] += amount;
418         }
419 
420         emit Transfer(from, to, amount);
421 
422         _afterTokenTransfer(from, to, amount);
423     }
424 
425     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
426      * the total supply.
427      *
428      * Emits a {Transfer} event with `from` set to the zero address.
429      *
430      * Requirements:
431      *
432      * - `account` cannot be the zero address.
433      */
434     function _mint(address account, uint256 amount) internal virtual {
435         require(account != address(0), "ERC20: mint to the zero address");
436 
437         _beforeTokenTransfer(address(0), account, amount);
438 
439         _totalSupply += amount;
440         unchecked {
441             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
442             _balances[account] += amount;
443         }
444         emit Transfer(address(0), account, amount);
445 
446         _afterTokenTransfer(address(0), account, amount);
447     }
448 
449     /**
450      * @dev Destroys `amount` tokens from `account`, reducing the
451      * total supply.
452      *
453      * Emits a {Transfer} event with `to` set to the zero address.
454      *
455      * Requirements:
456      *
457      * - `account` cannot be the zero address.
458      * - `account` must have at least `amount` tokens.
459      */
460     function _burn(address account, uint256 amount) internal virtual {
461         require(account != address(0), "ERC20: burn from the zero address");
462 
463         _beforeTokenTransfer(account, address(0), amount);
464 
465         uint256 accountBalance = _balances[account];
466         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
467         unchecked {
468             _balances[account] = accountBalance - amount;
469             // Overflow not possible: amount <= accountBalance <= totalSupply.
470             _totalSupply -= amount;
471         }
472 
473         emit Transfer(account, address(0), amount);
474 
475         _afterTokenTransfer(account, address(0), amount);
476     }
477 
478     /**
479      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
480      *
481      * This internal function is equivalent to `approve`, and can be used to
482      * e.g. set automatic allowances for certain subsystems, etc.
483      *
484      * Emits an {Approval} event.
485      *
486      * Requirements:
487      *
488      * - `owner` cannot be the zero address.
489      * - `spender` cannot be the zero address.
490      */
491     function _approve(
492         address owner,
493         address spender,
494         uint256 amount
495     ) internal virtual {
496         require(owner != address(0), "ERC20: approve from the zero address");
497         require(spender != address(0), "ERC20: approve to the zero address");
498 
499         _allowances[owner][spender] = amount;
500         emit Approval(owner, spender, amount);
501     }
502 
503     /**
504      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
505      *
506      * Does not update the allowance amount in case of infinite allowance.
507      * Revert if not enough allowance is available.
508      *
509      * Might emit an {Approval} event.
510      */
511     function _spendAllowance(
512         address owner,
513         address spender,
514         uint256 amount
515     ) internal virtual {
516         uint256 currentAllowance = allowance(owner, spender);
517         if (currentAllowance != type(uint256).max) {
518             require(currentAllowance >= amount, "ERC20: insufficient allowance");
519             unchecked {
520                 _approve(owner, spender, currentAllowance - amount);
521             }
522         }
523     }
524 
525     /**
526      * @dev Hook that is called before any transfer of tokens. This includes
527      * minting and burning.
528      *
529      * Calling conditions:
530      *
531      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
532      * will be transferred to `to`.
533      * - when `from` is zero, `amount` tokens will be minted for `to`.
534      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
535      * - `from` and `to` are never both zero.
536      *
537      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
538      */
539     function _beforeTokenTransfer(
540         address from,
541         address to,
542         uint256 amount
543     ) internal virtual {}
544 
545     /**
546      * @dev Hook that is called after any transfer of tokens. This includes
547      * minting and burning.
548      *
549      * Calling conditions:
550      *
551      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
552      * has been transferred to `to`.
553      * - when `from` is zero, `amount` tokens have been minted for `to`.
554      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
555      * - `from` and `to` are never both zero.
556      *
557      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
558      */
559     function _afterTokenTransfer(
560         address from,
561         address to,
562         uint256 amount
563     ) internal virtual {}
564 }
565 
566 
567 pragma solidity ^0.8.19;
568 
569 contract FUCK is ERC20 {
570     constructor() ERC20("F*CK", "F*CK") {
571         _mint(msg.sender, 99000000000 * 10 ** decimals());
572     }
573 }