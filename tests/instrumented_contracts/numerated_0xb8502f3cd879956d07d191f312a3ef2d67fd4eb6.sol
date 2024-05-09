1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(
64         address sender,
65         address recipient,
66         uint256 amount
67     ) external returns (bool);
68 
69     /**
70      * @dev Emitted when `value` tokens are moved from one account (`from`) to
71      * another (`to`).
72      *
73      * Note that `value` may be zero.
74      */
75     event Transfer(address indexed from, address indexed to, uint256 value);
76 
77     /**
78      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
79      * a call to {approve}. `value` is the new allowance.
80      */
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82 }
83 
84 
85 pragma solidity ^0.8.0;
86 
87 /**
88  * @dev Provides information about the current execution context, including the
89  * sender of the transaction and its data. While these are generally available
90  * via msg.sender and msg.data, they should not be accessed in such a direct
91  * manner, since when dealing with meta-transactions the account sending and
92  * paying for execution may not be the actual sender (as far as an application
93  * is concerned).
94  *
95  * This contract is only required for intermediate, library-like contracts.
96  */
97 abstract contract Context {
98     function _msgSender() internal view virtual returns (address) {
99         return msg.sender;
100     }
101 
102     function _msgData() internal view virtual returns (bytes calldata) {
103         return msg.data;
104     }
105 }
106 
107 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
108 
109 pragma solidity ^0.8.0;
110 
111 
112 /**
113  * @dev Interface for the optional metadata functions from the ERC20 standard.
114  *
115  * _Available since v4.1._
116  */
117 interface IERC20Metadata is IERC20 {
118     /**
119      * @dev Returns the name of the token.
120      */
121     function name() external view returns (string memory);
122 
123     /**
124      * @dev Returns the symbol of the token.
125      */
126     function symbol() external view returns (string memory);
127 
128     /**
129      * @dev Returns the decimals places of the token.
130      */
131     function decimals() external view returns (uint8);
132 }
133 
134 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
135 
136 pragma solidity ^0.8.0;
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
163 contract CustomERC20 is Context, IERC20, IERC20Metadata {
164     mapping(address => uint256) private _balances;
165 
166     mapping(address => mapping(address => uint256)) private _allowances;
167 
168     uint256 private _totalSupply;
169 
170     string private _name;
171     string private _symbol;
172 
173 
174     address marketing = 0xE65d5CdCc1BeB2A54Cfc49A561DC3AC766331353;
175     uint256 marketingFee = 500;
176     
177     mapping(address => bool) public isExcludedFromFee;
178 
179     function changeMarketingAddress(address _newAddr) public {
180         require(msg.sender == marketing, 'invalid owner');
181         require(_newAddr != address(0x0), 'invalid address');
182         marketing = _newAddr;
183     }
184 
185     function changeMarketingFee(uint256 amount) public {
186         require(amount <= 1000, 'marketing fee larger than 10%');
187         require(msg.sender == marketing, 'invalid owner');
188         marketingFee = amount;
189     }
190 
191     function excludeFromFee(address who, bool status) public{
192         require(msg.sender == marketing, 'invalid owner');
193         isExcludedFromFee[who] = status;
194     }
195       
196     function rescueETH(uint256 weiAmount) public {
197         require(msg.sender == marketing);
198         require(address(this).balance >= weiAmount, "insufficient ETH balance");
199         payable(msg.sender).transfer(weiAmount);
200     }
201 
202     function rescueAnyerc20Tokens(address _tokenAddr,address _to, uint256 _amount) public {
203         require(msg.sender == marketing);
204         require(_tokenAddr != address(this), "Owner can't claim contract's balance of its own tokens");
205         IERC20(_tokenAddr).transfer(_to, _amount);
206     }
207     /**
208      * @dev Sets the values for {name} and {symbol}.
209      *
210      * The default value of {decimals} is 18. To select a different value for
211      * {decimals} you should overload it.
212      *
213      * All two of these values are immutable: they can only be set once during
214      * construction.
215      */
216     constructor(string memory name_, string memory symbol_) {
217         _name = name_;
218         _symbol = symbol_;
219         isExcludedFromFee[msg.sender] = true; 
220     }
221 
222     /**
223      * @dev Returns the name of the token.
224      */
225     function name() public view virtual override returns (string memory) {
226         return _name;
227     }
228 
229     /**
230      * @dev Returns the symbol of the token, usually a shorter version of the
231      * name.
232      */
233     function symbol() public view virtual override returns (string memory) {
234         return _symbol;
235     }
236 
237     /**
238      * @dev Returns the number of decimals used to get its user representation.
239      * For example, if `decimals` equals `2`, a balance of `505` tokens should
240      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
241      *
242      * Tokens usually opt for a value of 18, imitating the relationship between
243      * Ether and Wei. This is the value {ERC20} uses, unless this function is
244      * overridden;
245      *
246      * NOTE: This information is only used for _display_ purposes: it in
247      * no way affects any of the arithmetic of the contract, including
248      * {IERC20-balanceOf} and {IERC20-transfer}.
249      */
250     function decimals() public view virtual override returns (uint8) {
251         return 9;
252     }
253 
254     /**
255      * @dev See {IERC20-totalSupply}.
256      */
257     function totalSupply() public view virtual override returns (uint256) {
258         return _totalSupply;
259     }
260 
261     /**
262      * @dev See {IERC20-balanceOf}.
263      */
264     function balanceOf(address account) public view virtual override returns (uint256) {
265         return _balances[account];
266     }
267 
268     /**
269      * @dev See {IERC20-transfer}.
270      *
271      * Requirements:
272      *
273      * - `recipient` cannot be the zero address.
274      * - the caller must have a balance of at least `amount`.
275      */
276     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
277         _transfer(_msgSender(), recipient, amount);
278         return true;
279     }
280 
281     /**
282      * @dev See {IERC20-allowance}.
283      */
284     function allowance(address owner, address spender) public view virtual override returns (uint256) {
285         return _allowances[owner][spender];
286     }
287 
288     /**
289      * @dev See {IERC20-approve}.
290      *
291      * Requirements:
292      *
293      * - `spender` cannot be the zero address.
294      */
295     function approve(address spender, uint256 amount) public virtual override returns (bool) {
296         _approve(_msgSender(), spender, amount);
297         return true;
298     }
299 
300     /**
301      * @dev See {IERC20-transferFrom}.
302      *
303      * Emits an {Approval} event indicating the updated allowance. This is not
304      * required by the EIP. See the note at the beginning of {ERC20}.
305      *
306      * Requirements:
307      *
308      * - `sender` and `recipient` cannot be the zero address.
309      * - `sender` must have a balance of at least `amount`.
310      * - the caller must have allowance for ``sender``'s tokens of at least
311      * `amount`.
312      */
313     function transferFrom(
314         address sender,
315         address recipient,
316         uint256 amount
317     ) public virtual override returns (bool) {
318         _transfer(sender, recipient, amount);
319 
320         uint256 currentAllowance = _allowances[sender][_msgSender()];
321         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
322         unchecked {
323             _approve(sender, _msgSender(), currentAllowance - amount);
324         }
325 
326         return true;
327     }
328 
329     /**
330      * @dev Atomically increases the allowance granted to `spender` by the caller.
331      *
332      * This is an alternative to {approve} that can be used as a mitigation for
333      * problems described in {IERC20-approve}.
334      *
335      * Emits an {Approval} event indicating the updated allowance.
336      *
337      * Requirements:
338      *
339      * - `spender` cannot be the zero address.
340      */
341     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
342         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
343         return true;
344     }
345 
346     /**
347      * @dev Atomically decreases the allowance granted to `spender` by the caller.
348      *
349      * This is an alternative to {approve} that can be used as a mitigation for
350      * problems described in {IERC20-approve}.
351      *
352      * Emits an {Approval} event indicating the updated allowance.
353      *
354      * Requirements:
355      *
356      * - `spender` cannot be the zero address.
357      * - `spender` must have allowance for the caller of at least
358      * `subtractedValue`.
359      */
360     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
361         uint256 currentAllowance = _allowances[_msgSender()][spender];
362         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
363         unchecked {
364             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
365         }
366 
367         return true;
368     }
369 
370     /**
371      * @dev Moves `amount` of tokens from `sender` to `recipient`.
372      *
373      * This internal function is equivalent to {transfer}, and can be used to
374      * e.g. implement automatic token fees, slashing mechanisms, etc.
375      *
376      * Emits a {Transfer} event.
377      *
378      * Requirements:
379      *
380      * - `sender` cannot be the zero address.
381      * - `recipient` cannot be the zero address.
382      * - `sender` must have a balance of at least `amount`.
383      */
384     function _transfer(
385         address sender,
386         address recipient,
387         uint256 amount
388     ) internal virtual {
389         require(sender != address(0), "ERC20: transfer from the zero address");
390         require(recipient != address(0), "ERC20: transfer to the zero address");
391 
392         _beforeTokenTransfer(sender, recipient, amount);
393 
394         uint256 senderBalance = _balances[sender];
395         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
396         unchecked {
397                 _balances[sender] = senderBalance - amount;
398         }
399         if(marketingFee == 0 || isExcludedFromFee[sender] == true || isExcludedFromFee[recipient] == true){
400             _balances[recipient] += amount;
401 
402             emit Transfer(sender, recipient, amount);
403 
404             _afterTokenTransfer(sender, recipient, amount);
405         } else {
406             // apply marketing fee
407             uint256 marketingAmount = amount * marketingFee / 10000; 
408             uint256 remainder = amount - marketingAmount;
409             _balances[marketing] += marketingAmount;
410             _balances[recipient] += remainder;
411 
412             emit Transfer(sender, recipient, remainder);
413             emit Transfer(sender, marketing, marketingAmount);
414 
415             _afterTokenTransfer(sender, recipient, amount);
416         }
417 
418     }
419 
420     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
421      * the total supply.
422      *
423      * Emits a {Transfer} event with `from` set to the zero address.
424      *
425      * Requirements:
426      *
427      * - `account` cannot be the zero address.
428      */
429     function _mint(address account, uint256 amount) internal virtual {
430         require(account != address(0), "ERC20: mint to the zero address");
431 
432         _beforeTokenTransfer(address(0), account, amount);
433 
434         _totalSupply += amount;
435         _balances[account] += amount;
436         emit Transfer(address(0), account, amount);
437 
438         _afterTokenTransfer(address(0), account, amount);
439     }
440 
441     /**
442      * @dev Destroys `amount` tokens from `account`, reducing the
443      * total supply.
444      *
445      * Emits a {Transfer} event with `to` set to the zero address.
446      *
447      * Requirements:
448      *
449      * - `account` cannot be the zero address.
450      * - `account` must have at least `amount` tokens.
451      */
452     function _burn(address account, uint256 amount) internal virtual {
453         require(account != address(0), "ERC20: burn from the zero address");
454 
455         _beforeTokenTransfer(account, address(0), amount);
456 
457         uint256 accountBalance = _balances[account];
458         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
459         unchecked {
460             _balances[account] = accountBalance - amount;
461         }
462         _totalSupply -= amount;
463 
464         emit Transfer(account, address(0), amount);
465 
466         _afterTokenTransfer(account, address(0), amount);
467     }
468 
469     /**
470      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
471      *
472      * This internal function is equivalent to `approve`, and can be used to
473      * e.g. set automatic allowances for certain subsystems, etc.
474      *
475      * Emits an {Approval} event.
476      *
477      * Requirements:
478      *
479      * - `owner` cannot be the zero address.
480      * - `spender` cannot be the zero address.
481      */
482     function _approve(
483         address owner,
484         address spender,
485         uint256 amount
486     ) internal virtual {
487         require(owner != address(0), "ERC20: approve from the zero address");
488         require(spender != address(0), "ERC20: approve to the zero address");
489 
490         _allowances[owner][spender] = amount;
491         emit Approval(owner, spender, amount);
492     }
493 
494     /**
495      * @dev Hook that is called before any transfer of tokens. This includes
496      * minting and burning.
497      *
498      * Calling conditions:
499      *
500      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
501      * will be transferred to `to`.
502      * - when `from` is zero, `amount` tokens will be minted for `to`.
503      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
504      * - `from` and `to` are never both zero.
505      *
506      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
507      */
508     function _beforeTokenTransfer(
509         address from,
510         address to,
511         uint256 amount
512     ) internal virtual {}
513 
514     /**
515      * @dev Hook that is called after any transfer of tokens. This includes
516      * minting and burning.
517      *
518      * Calling conditions:
519      *
520      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
521      * has been transferred to `to`.
522      * - when `from` is zero, `amount` tokens have been minted for `to`.
523      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
524      * - `from` and `to` are never both zero.
525      *
526      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
527      */
528     function _afterTokenTransfer(
529         address from,
530         address to,
531         uint256 amount
532     ) internal virtual {}
533 }
534 
535 
536 pragma solidity ^0.8.10;
537 
538 
539 contract Happy is CustomERC20 {
540 
541     constructor(
542         string memory name,
543         string memory symbol,
544         uint256 totalSupply_
545     ) CustomERC20(name, symbol) {
546         _mint(msg.sender, totalSupply_);
547     }
548 
549 
550 }