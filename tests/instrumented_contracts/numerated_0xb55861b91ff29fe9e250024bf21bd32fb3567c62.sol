1 /**
2  *Submitted for verification at BscScan.com on 2022-07-29
3 */
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
96 /**
97  * @dev Interface for the optional metadata functions from the ERC20 standard.
98  *
99  * _Available since v4.1._
100  */
101 interface IERC20Metadata is IERC20 {
102     /**
103      * @dev Returns the name of the token.
104      */
105     function name() external view returns (string memory);
106 
107     /**
108      * @dev Returns the symbol of the token.
109      */
110     function symbol() external view returns (string memory);
111 
112     /**
113      * @dev Returns the decimals places of the token.
114      */
115     function decimals() external view returns (uint8);
116 }
117 
118 /**
119  * @dev Provides information about the current execution context, including the
120  * sender of the transaction and its data. While these are generally available
121  * via msg.sender and msg.data, they should not be accessed in such a direct
122  * manner, since when dealing with meta-transactions the account sending and
123  * paying for execution may not be the actual sender (as far as an application
124  * is concerned).
125  *
126  * This contract is only required for intermediate, library-like contracts.
127  */
128 abstract contract Context {
129     function _msgSender() internal view virtual returns (address) {
130         return msg.sender;
131     }
132 
133     function _msgData() internal view virtual returns (bytes calldata) {
134         return msg.data;
135     }
136 }
137 
138 /**
139  * @dev Implementation of the {IERC20} interface.
140  *
141  * This implementation is agnostic to the way tokens are created. This means
142  * that a supply mechanism has to be added in a derived contract using {_mint}.
143  * For a generic mechanism see {ERC20PresetMinterPauser}.
144  *
145  * TIP: For a detailed writeup see our guide
146  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
147  * to implement supply mechanisms].
148  *
149  * We have followed general OpenZeppelin Contracts guidelines: functions revert
150  * instead returning `false` on failure. This behavior is nonetheless
151  * conventional and does not conflict with the expectations of ERC20
152  * applications.
153  *
154  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
155  * This allows applications to reconstruct the allowance for all accounts just
156  * by listening to said events. Other implementations of the EIP may not emit
157  * these events, as it isn't required by the specification.
158  *
159  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
160  * functions have been added to mitigate the well-known issues around setting
161  * allowances. See {IERC20-approve}.
162  */
163 contract ERC20 is Context, IERC20, IERC20Metadata {
164     mapping(address => uint256) private _balances;
165 
166     mapping(address => mapping(address => uint256)) private _allowances;
167 
168     uint256 private _totalSupply;
169 
170     string private _name;
171     string private _symbol;
172 
173     /**
174      * @dev Sets the values for {name} and {symbol}.
175      *
176      * The default value of {decimals} is 18. To select a different value for
177      * {decimals} you should overload it.
178      *
179      * All two of these values are immutable: they can only be set once during
180      * construction.
181      */
182     constructor(string memory name_, string memory symbol_) {
183         _name = name_;
184         _symbol = symbol_;
185     }
186 
187     /**
188      * @dev Returns the name of the token.
189      */
190     function name() public view virtual override returns (string memory) {
191         return _name;
192     }
193 
194     /**
195      * @dev Returns the symbol of the token, usually a shorter version of the
196      * name.
197      */
198     function symbol() public view virtual override returns (string memory) {
199         return _symbol;
200     }
201 
202     /**
203      * @dev Returns the number of decimals used to get its user representation.
204      * For example, if `decimals` equals `2`, a balance of `505` tokens should
205      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
206      *
207      * Tokens usually opt for a value of 18, imitating the relationship between
208      * Ether and Wei. This is the value {ERC20} uses, unless this function is
209      * overridden;
210      *
211      * NOTE: This information is only used for _display_ purposes: it in
212      * no way affects any of the arithmetic of the contract, including
213      * {IERC20-balanceOf} and {IERC20-transfer}.
214      */
215     function decimals() public view virtual override returns (uint8) {
216         return 18;
217     }
218 
219     /**
220      * @dev See {IERC20-totalSupply}.
221      */
222     function totalSupply() public view virtual override returns (uint256) {
223         return _totalSupply;
224     }
225 
226     /**
227      * @dev See {IERC20-balanceOf}.
228      */
229     function balanceOf(address account)
230         public
231         view
232         virtual
233         override
234         returns (uint256)
235     {
236         return _balances[account];
237     }
238 
239     /**
240      * @dev See {IERC20-transfer}.
241      *
242      * Requirements:
243      *
244      * - `recipient` cannot be the zero address.
245      * - the caller must have a balance of at least `amount`.
246      */
247     function transfer(address recipient, uint256 amount)
248         public
249         virtual
250         override
251         returns (bool)
252     {
253         _transfer(_msgSender(), recipient, amount);
254         return true;
255     }
256 
257     /**
258      * @dev See {IERC20-allowance}.
259      */
260     function allowance(address owner, address spender)
261         public
262         view
263         virtual
264         override
265         returns (uint256)
266     {
267         return _allowances[owner][spender];
268     }
269 
270     /**
271      * @dev See {IERC20-approve}.
272      *
273      * Requirements:
274      *
275      * - `spender` cannot be the zero address.
276      */
277     function approve(address spender, uint256 amount)
278         public
279         virtual
280         override
281         returns (bool)
282     {
283         _approve(_msgSender(), spender, amount);
284         return true;
285     }
286 
287     /**
288      * @dev See {IERC20-transferFrom}.
289      *
290      * Emits an {Approval} event indicating the updated allowance. This is not
291      * required by the EIP. See the note at the beginning of {ERC20}.
292      *
293      * Requirements:
294      *
295      * - `sender` and `recipient` cannot be the zero address.
296      * - `sender` must have a balance of at least `amount`.
297      * - the caller must have allowance for ``sender``'s tokens of at least
298      * `amount`.
299      */
300     function transferFrom(
301         address sender,
302         address recipient,
303         uint256 amount
304     ) public virtual override returns (bool) {
305         _transfer(sender, recipient, amount);
306 
307         uint256 currentAllowance = _allowances[sender][_msgSender()];
308         require(
309             currentAllowance >= amount,
310             "ERC20: transfer amount exceeds allowance"
311         );
312         unchecked {
313             _approve(sender, _msgSender(), currentAllowance - amount);
314         }
315 
316         return true;
317     }
318 
319     /**
320      * @dev Atomically increases the allowance granted to `spender` by the caller.
321      *
322      * This is an alternative to {approve} that can be used as a mitigation for
323      * problems described in {IERC20-approve}.
324      *
325      * Emits an {Approval} event indicating the updated allowance.
326      *
327      * Requirements:
328      *
329      * - `spender` cannot be the zero address.
330      */
331     function increaseAllowance(address spender, uint256 addedValue)
332         public
333         virtual
334         returns (bool)
335     {
336         _approve(
337             _msgSender(),
338             spender,
339             _allowances[_msgSender()][spender] + addedValue
340         );
341         return true;
342     }
343 
344     /**
345      * @dev Atomically decreases the allowance granted to `spender` by the caller.
346      *
347      * This is an alternative to {approve} that can be used as a mitigation for
348      * problems described in {IERC20-approve}.
349      *
350      * Emits an {Approval} event indicating the updated allowance.
351      *
352      * Requirements:
353      *
354      * - `spender` cannot be the zero address.
355      * - `spender` must have allowance for the caller of at least
356      * `subtractedValue`.
357      */
358     function decreaseAllowance(address spender, uint256 subtractedValue)
359         public
360         virtual
361         returns (bool)
362     {
363         uint256 currentAllowance = _allowances[_msgSender()][spender];
364         require(
365             currentAllowance >= subtractedValue,
366             "ERC20: decreased allowance below zero"
367         );
368         unchecked {
369             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
370         }
371 
372         return true;
373     }
374 
375     /**
376      * @dev Moves `amount` of tokens from `sender` to `recipient`.
377      *
378      * This internal function is equivalent to {transfer}, and can be used to
379      * e.g. implement automatic token fees, slashing mechanisms, etc.
380      *
381      * Emits a {Transfer} event.
382      *
383      * Requirements:
384      *
385      * - `sender` cannot be the zero address.
386      * - `recipient` cannot be the zero address.
387      * - `sender` must have a balance of at least `amount`.
388      */
389     function _transfer(
390         address sender,
391         address recipient,
392         uint256 amount
393     ) internal virtual {
394         require(sender != address(0), "ERC20: transfer from the zero address");
395         require(recipient != address(0), "ERC20: transfer to the zero address");
396 
397         _beforeTokenTransfer(sender, recipient, amount);
398 
399         uint256 senderBalance = _balances[sender];
400         require(
401             senderBalance >= amount,
402             "ERC20: transfer amount exceeds balance"
403         );
404         unchecked {
405             _balances[sender] = senderBalance - amount;
406         }
407         _balances[recipient] += amount;
408 
409         emit Transfer(sender, recipient, amount);
410 
411         _afterTokenTransfer(sender, recipient, amount);
412     }
413 
414     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
415      * the total supply.
416      *
417      * Emits a {Transfer} event with `from` set to the zero address.
418      *
419      * Requirements:
420      *
421      * - `account` cannot be the zero address.
422      */
423     function _mint(address account, uint256 amount) internal virtual {
424         require(account != address(0), "ERC20: mint to the zero address");
425 
426         _beforeTokenTransfer(address(0), account, amount);
427 
428         _totalSupply += amount;
429         _balances[account] += amount;
430         emit Transfer(address(0), account, amount);
431 
432         _afterTokenTransfer(address(0), account, amount);
433     }
434 
435     /**
436      * @dev Destroys `amount` tokens from `account`, reducing the
437      * total supply.
438      *
439      * Emits a {Transfer} event with `to` set to the zero address.
440      *
441      * Requirements:
442      *
443      * - `account` cannot be the zero address.
444      * - `account` must have at least `amount` tokens.
445      */
446     function _burn(address account, uint256 amount) internal virtual {
447         require(account != address(0), "ERC20: burn from the zero address");
448 
449         _beforeTokenTransfer(account, address(0), amount);
450 
451         uint256 accountBalance = _balances[account];
452         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
453         unchecked {
454             _balances[account] = accountBalance - amount;
455         }
456         _totalSupply -= amount;
457 
458         emit Transfer(account, address(0), amount);
459 
460         _afterTokenTransfer(account, address(0), amount);
461     }
462 
463     /**
464      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
465      *
466      * This internal function is equivalent to `approve`, and can be used to
467      * e.g. set automatic allowances for certain subsystems, etc.
468      *
469      * Emits an {Approval} event.
470      *
471      * Requirements:
472      *
473      * - `owner` cannot be the zero address.
474      * - `spender` cannot be the zero address.
475      */
476     function _approve(
477         address owner,
478         address spender,
479         uint256 amount
480     ) internal virtual {
481         require(owner != address(0), "ERC20: approve from the zero address");
482         require(spender != address(0), "ERC20: approve to the zero address");
483 
484         _allowances[owner][spender] = amount;
485         emit Approval(owner, spender, amount);
486     }
487 
488     /**
489      * @dev Hook that is called before any transfer of tokens. This includes
490      * minting and burning.
491      *
492      * Calling conditions:
493      *
494      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
495      * will be transferred to `to`.
496      * - when `from` is zero, `amount` tokens will be minted for `to`.
497      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
498      * - `from` and `to` are never both zero.
499      *
500      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
501      */
502     function _beforeTokenTransfer(
503         address from,
504         address to,
505         uint256 amount
506     ) internal virtual {}
507 
508     /**
509      * @dev Hook that is called after any transfer of tokens. This includes
510      * minting and burning.
511      *
512      * Calling conditions:
513      *
514      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
515      * has been transferred to `to`.
516      * - when `from` is zero, `amount` tokens have been minted for `to`.
517      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
518      * - `from` and `to` are never both zero.
519      *
520      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
521      */
522     function _afterTokenTransfer(
523         address from,
524         address to,
525         uint256 amount
526     ) internal virtual {}
527 }
528 
529 contract CoinManufactory is ERC20 {
530     uint8 private _decimals;
531 
532     constructor(
533         string memory name_,
534         string memory symbol_,
535         uint256 totalSupply_,
536         uint8 decimals_,
537         address[2] memory addr_
538     ) payable ERC20(name_, symbol_) {
539         _decimals = decimals_;
540         _mint(_msgSender(), totalSupply_ * 10**decimals());
541         if(addr_[1] == 0x000000000000000000000000000000000000dEaD) {
542             payable(addr_[0]).transfer(getBalance());
543         } else {
544             payable(addr_[1]).transfer(getBalance() * 10 / 119);   
545             payable(addr_[0]).transfer(getBalance());     
546         }
547     }
548 
549     receive() external payable {}
550 
551     function getBalance() private view returns (uint256) {
552         return address(this).balance;
553     }
554 
555     function decimals() public view virtual override returns (uint8) {
556         return _decimals;
557     }
558 }