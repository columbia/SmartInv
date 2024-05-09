1 /*                                           
2 
3                                                   /////////////////   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@               
4                                                   /////////////////     #@@@@@@@@@@@@@@@@@@@@@@@@@@               
5                                                   /////////////////        @@@@@@@@@@@@@@@@@@@@@@@@               
6                                                   /////////////////           @@@@@@@@@@@@@@@@@@@@@               
7                                                   /////////////////             ,@@@@@@@@@@@@@@@@@@               
8                                                   /////////////////                &@@@@@@@@@@@@@@@               
9                                                   /////////////////                   @@@@@@@@@@@@@               
10                                                   /////////////////                     .@@@@@@@@@@               
11                                                   /////////////////                        &@@@@@@@               
12                                                   /////////////////                           @@@@@               
13                                                   /////////////////                              @@               
14                                                   /////////////////                                               
15                                                   /////////////////                                               
16                                                   /////////////////                                               
17                                                   /////////////////                                               
18                                                   /////////////////                                               
19                                                   /////////////////                               @               
20                                                   /////////////////                            /@@@               
21                                                   /////////////////                          @@@@@@               
22                                                   /////////////////                       @@@@@@@@@               
23                                                   /////////////////                    %@@@@@@@@@@@               
24                                                   /////////////////                 .@@@@@@@@@@@@@@               
25                                                   /////////////////               @@@@@@@@@@@@@@@@@               
26                                                   /////////////////            @@@@@@@@@@@@@@@@@@@@               
27                                                   /////////////////         *@@@@@@@@@@@@@@@@@@@@@@               
28                                                   /////////////////       @@@@@@@@@@@@@@@@@@@@@@@@@               
29                                                   /////////////////    @@@@@@@@@@@@@@@@@@@@@@@@@@@@               
30 
31 
32 
33 
34         oooooooooooo                                      .o8               ooooo      ooo               .                                       oooo        
35         `888'     `8                                     "888               `888b.     `8'             .o8                                       `888        
36          888         oooo    ooo  .ooooo.  oooo d8b  .oooo888   .ooooo.      8 `88b.    8   .ooooo.  .o888oo oooo oooo    ooo  .ooooo.  oooo d8b  888  oooo  
37          888oooo8     `88b..8P'  d88' `88b `888""8P d88' `888  d88' `88b     8   `88b.  8  d88' `88b   888    `88. `88.  .8'  d88' `88b `888""8P  888 .8P'   
38          888    "       Y888'    888   888  888     888   888  888ooo888     8     `88b.8  888ooo888   888     `88..]88..8'   888   888  888      888888.    
39          888       o  .o8"'88b   888   888  888     888   888  888    .o     8       `888  888    .o   888 .    `888'`888'    888   888  888      888 `88b.  
40         o888ooooood8 o88'   888o `Y8bod8P' d888b    `Y8bod88P" `Y8bod8P'    o8o        `8  `Y8bod8P'   "888"     `8'  `8'     `Y8bod8P' d888b    o888o o888o 
41 
42 
43 
44                                               ooooooooooooo           oooo                              
45                                               8'   888   `8           `888                              
46                                                    888       .ooooo.   888  oooo   .ooooo.  ooo. .oo.   
47                                                    888      d88' `88b  888 .8P'   d88' `88b `888P"Y88b  
48                                                    888      888   888  888888.    888ooo888  888   888  
49                                                    888      888   888  888 `88b.  888    .o  888   888  
50                                                   o888o     `Y8bod8P' o888o o888o `Y8bod8P' o888o o888o 
51 
52                                                                                           
53  */ 
54  
55  
56  /* Submitted for verification at Etherscan.io on 2023-02-06 */
57 
58 // SPDX-License-Identifier: MIT
59 // File: @openzeppelin/contracts/utils/Context.sol
60 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
61 
62 pragma solidity ^0.8.0;
63 
64 /**
65  * @dev Provides information about the current execution context, including the
66  * sender of the transaction and its data. While these are generally available
67  * via msg.sender and msg.data, they should not be accessed in such a direct
68  * manner, since when dealing with meta-transactions the account sending and
69  * paying for execution may not be the actual sender (as far as an application
70  * is concerned).
71  *
72  * This contract is only required for intermediate, library-like contracts.
73  */
74 abstract contract Context {
75     function _msgSender() internal view virtual returns (address) {
76         return msg.sender;
77     }
78 
79     function _msgData() internal view virtual returns (bytes calldata) {
80         return msg.data;
81     }
82 }
83 
84 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
85 
86 
87 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev Interface of the ERC20 standard as defined in the EIP.
93  */
94 interface IERC20 {
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 
109     /**
110      * @dev Returns the amount of tokens in existence.
111      */
112     function totalSupply() external view returns (uint256);
113 
114     /**
115      * @dev Returns the amount of tokens owned by `account`.
116      */
117     function balanceOf(address account) external view returns (uint256);
118 
119     /**
120      * @dev Moves `amount` tokens from the caller's account to `to`.
121      *
122      * Returns a boolean value indicating whether the operation succeeded.
123      *
124      * Emits a {Transfer} event.
125      */
126     function transfer(address to, uint256 amount) external returns (bool);
127 
128     /**
129      * @dev Returns the remaining number of tokens that `spender` will be
130      * allowed to spend on behalf of `owner` through {transferFrom}. This is
131      * zero by default.
132      *
133      * This value changes when {approve} or {transferFrom} are called.
134      */
135     function allowance(address owner, address spender) external view returns (uint256);
136 
137     /**
138      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
139      *
140      * Returns a boolean value indicating whether the operation succeeded.
141      *
142      * IMPORTANT: Beware that changing an allowance with this method brings the risk
143      * that someone may use both the old and the new allowance by unfortunate
144      * transaction ordering. One possible solution to mitigate this race
145      * condition is to first reduce the spender's allowance to 0 and set the
146      * desired value afterwards:
147      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148      *
149      * Emits an {Approval} event.
150      */
151     function approve(address spender, uint256 amount) external returns (bool);
152 
153     /**
154      * @dev Moves `amount` tokens from `from` to `to` using the
155      * allowance mechanism. `amount` is then deducted from the caller's
156      * allowance.
157      *
158      * Returns a boolean value indicating whether the operation succeeded.
159      *
160      * Emits a {Transfer} event.
161      */
162     function transferFrom(
163         address from,
164         address to,
165         uint256 amount
166     ) external returns (bool);
167 }
168 
169 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
170 
171 
172 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
173 
174 pragma solidity ^0.8.0;
175 
176 
177 /**
178  * @dev Interface for the optional metadata functions from the ERC20 standard.
179  *
180  * _Available since v4.1._
181  */
182 interface IERC20Metadata is IERC20 {
183     /**
184      * @dev Returns the name of the token.
185      */
186     function name() external view returns (string memory);
187 
188     /**
189      * @dev Returns the symbol of the token.
190      */
191     function symbol() external view returns (string memory);
192 
193     /**
194      * @dev Returns the decimals places of the token.
195      */
196     function decimals() external view returns (uint8);
197 }
198 
199 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
200 
201 
202 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
203 
204 pragma solidity ^0.8.0;
205 
206 
207 
208 
209 /**
210  * @dev Implementation of the {IERC20} interface.
211  *
212  * This implementation is agnostic to the way tokens are created. This means
213  * that a supply mechanism has to be added in a derived contract using {_mint}.
214  * For a generic mechanism see {ERC20PresetMinterPauser}.
215  *
216  * TIP: For a detailed writeup see our guide
217  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
218  * to implement supply mechanisms].
219  *
220  * We have followed general OpenZeppelin Contracts guidelines: functions revert
221  * instead returning `false` on failure. This behavior is nonetheless
222  * conventional and does not conflict with the expectations of ERC20
223  * applications.
224  *
225  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
226  * This allows applications to reconstruct the allowance for all accounts just
227  * by listening to said events. Other implementations of the EIP may not emit
228  * these events, as it isn't required by the specification.
229  *
230  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
231  * functions have been added to mitigate the well-known issues around setting
232  * allowances. See {IERC20-approve}.
233  */
234 contract ERC20 is Context, IERC20, IERC20Metadata {
235     mapping(address => uint256) private _balances;
236 
237     mapping(address => mapping(address => uint256)) private _allowances;
238 
239     uint256 private _totalSupply;
240 
241     string private _name;
242     string private _symbol;
243 
244     /**
245      * @dev Sets the values for {name} and {symbol}.
246      *
247      * The default value of {decimals} is 18. To select a different value for
248      * {decimals} you should overload it.
249      *
250      * All two of these values are immutable: they can only be set once during
251      * construction.
252      */
253     constructor(string memory name_, string memory symbol_) {
254         _name = name_;
255         _symbol = symbol_;
256     }
257 
258     /**
259      * @dev Returns the name of the token.
260      */
261     function name() public view virtual override returns (string memory) {
262         return _name;
263     }
264 
265     /**
266      * @dev Returns the symbol of the token, usually a shorter version of the
267      * name.
268      */
269     function symbol() public view virtual override returns (string memory) {
270         return _symbol;
271     }
272 
273     /**
274      * @dev Returns the number of decimals used to get its user representation.
275      * For example, if `decimals` equals `2`, a balance of `505` tokens should
276      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
277      *
278      * Tokens usually opt for a value of 18, imitating the relationship between
279      * Ether and Wei. This is the value {ERC20} uses, unless this function is
280      * overridden;
281      *
282      * NOTE: This information is only used for _display_ purposes: it in
283      * no way affects any of the arithmetic of the contract, including
284      * {IERC20-balanceOf} and {IERC20-transfer}.
285      */
286     function decimals() public view virtual override returns (uint8) {
287         return 18;
288     }
289 
290     /**
291      * @dev See {IERC20-totalSupply}.
292      */
293     function totalSupply() public view virtual override returns (uint256) {
294         return _totalSupply;
295     }
296 
297     /**
298      * @dev See {IERC20-balanceOf}.
299      */
300     function balanceOf(address account) public view virtual override returns (uint256) {
301         return _balances[account];
302     }
303 
304     /**
305      * @dev See {IERC20-transfer}.
306      *
307      * Requirements:
308      *
309      * - `to` cannot be the zero address.
310      * - the caller must have a balance of at least `amount`.
311      */
312     function transfer(address to, uint256 amount) public virtual override returns (bool) {
313         address owner = _msgSender();
314         _transfer(owner, to, amount);
315         return true;
316     }
317 
318     /**
319      * @dev See {IERC20-allowance}.
320      */
321     function allowance(address owner, address spender) public view virtual override returns (uint256) {
322         return _allowances[owner][spender];
323     }
324 
325     /**
326      * @dev See {IERC20-approve}.
327      *
328      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
329      * `transferFrom`. This is semantically equivalent to an infinite approval.
330      *
331      * Requirements:
332      *
333      * - `spender` cannot be the zero address.
334      */
335     function approve(address spender, uint256 amount) public virtual override returns (bool) {
336         address owner = _msgSender();
337         _approve(owner, spender, amount);
338         return true;
339     }
340 
341     /**
342      * @dev See {IERC20-transferFrom}.
343      *
344      * Emits an {Approval} event indicating the updated allowance. This is not
345      * required by the EIP. See the note at the beginning of {ERC20}.
346      *
347      * NOTE: Does not update the allowance if the current allowance
348      * is the maximum `uint256`.
349      *
350      * Requirements:
351      *
352      * - `from` and `to` cannot be the zero address.
353      * - `from` must have a balance of at least `amount`.
354      * - the caller must have allowance for ``from``'s tokens of at least
355      * `amount`.
356      */
357     function transferFrom(
358         address from,
359         address to,
360         uint256 amount
361     ) public virtual override returns (bool) {
362         address spender = _msgSender();
363         _spendAllowance(from, spender, amount);
364         _transfer(from, to, amount);
365         return true;
366     }
367 
368     /**
369      * @dev Atomically increases the allowance granted to `spender` by the caller.
370      *
371      * This is an alternative to {approve} that can be used as a mitigation for
372      * problems described in {IERC20-approve}.
373      *
374      * Emits an {Approval} event indicating the updated allowance.
375      *
376      * Requirements:
377      *
378      * - `spender` cannot be the zero address.
379      */
380     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
381         address owner = _msgSender();
382         _approve(owner, spender, allowance(owner, spender) + addedValue);
383         return true;
384     }
385 
386     /**
387      * @dev Atomically decreases the allowance granted to `spender` by the caller.
388      *
389      * This is an alternative to {approve} that can be used as a mitigation for
390      * problems described in {IERC20-approve}.
391      *
392      * Emits an {Approval} event indicating the updated allowance.
393      *
394      * Requirements:
395      *
396      * - `spender` cannot be the zero address.
397      * - `spender` must have allowance for the caller of at least
398      * `subtractedValue`.
399      */
400     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
401         address owner = _msgSender();
402         uint256 currentAllowance = allowance(owner, spender);
403         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
404         unchecked {
405             _approve(owner, spender, currentAllowance - subtractedValue);
406         }
407 
408         return true;
409     }
410 
411     /**
412      * @dev Moves `amount` of tokens from `from` to `to`.
413      *
414      * This internal function is equivalent to {transfer}, and can be used to
415      * e.g. implement automatic token fees, slashing mechanisms, etc.
416      *
417      * Emits a {Transfer} event.
418      *
419      * Requirements:
420      *
421      * - `from` cannot be the zero address.
422      * - `to` cannot be the zero address.
423      * - `from` must have a balance of at least `amount`.
424      */
425     function _transfer(
426         address from,
427         address to,
428         uint256 amount
429     ) internal virtual {
430         require(from != address(0), "ERC20: transfer from the zero address");
431         require(to != address(0), "ERC20: transfer to the zero address");
432 
433         _beforeTokenTransfer(from, to, amount);
434 
435         uint256 fromBalance = _balances[from];
436         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
437         unchecked {
438             _balances[from] = fromBalance - amount;
439             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
440             // decrementing then incrementing.
441             _balances[to] += amount;
442         }
443 
444         emit Transfer(from, to, amount);
445 
446         _afterTokenTransfer(from, to, amount);
447     }
448 
449     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
450      * the total supply.
451      *
452      * Emits a {Transfer} event with `from` set to the zero address.
453      *
454      * Requirements:
455      *
456      * - `account` cannot be the zero address.
457      */
458     function _mint(address account, uint256 amount) internal virtual {
459         require(account != address(0), "ERC20: mint to the zero address");
460 
461         _beforeTokenTransfer(address(0), account, amount);
462 
463         _totalSupply += amount;
464         unchecked {
465             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
466             _balances[account] += amount;
467         }
468         emit Transfer(address(0), account, amount);
469 
470         _afterTokenTransfer(address(0), account, amount);
471     }
472 
473     /**
474      * @dev Destroys `amount` tokens from `account`, reducing the
475      * total supply.
476      *
477      * Emits a {Transfer} event with `to` set to the zero address.
478      *
479      * Requirements:
480      *
481      * - `account` cannot be the zero address.
482      * - `account` must have at least `amount` tokens.
483      */
484     function _burn(address account, uint256 amount) internal virtual {
485         require(account != address(0), "ERC20: burn from the zero address");
486 
487         _beforeTokenTransfer(account, address(0), amount);
488 
489         uint256 accountBalance = _balances[account];
490         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
491         unchecked {
492             _balances[account] = accountBalance - amount;
493             // Overflow not possible: amount <= accountBalance <= totalSupply.
494             _totalSupply -= amount;
495         }
496 
497         emit Transfer(account, address(0), amount);
498 
499         _afterTokenTransfer(account, address(0), amount);
500     }
501 
502     /**
503      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
504      *
505      * This internal function is equivalent to `approve`, and can be used to
506      * e.g. set automatic allowances for certain subsystems, etc.
507      *
508      * Emits an {Approval} event.
509      *
510      * Requirements:
511      *
512      * - `owner` cannot be the zero address.
513      * - `spender` cannot be the zero address.
514      */
515     function _approve(
516         address owner,
517         address spender,
518         uint256 amount
519     ) internal virtual {
520         require(owner != address(0), "ERC20: approve from the zero address");
521         require(spender != address(0), "ERC20: approve to the zero address");
522 
523         _allowances[owner][spender] = amount;
524         emit Approval(owner, spender, amount);
525     }
526 
527     /**
528      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
529      *
530      * Does not update the allowance amount in case of infinite allowance.
531      * Revert if not enough allowance is available.
532      *
533      * Might emit an {Approval} event.
534      */
535     function _spendAllowance(
536         address owner,
537         address spender,
538         uint256 amount
539     ) internal virtual {
540         uint256 currentAllowance = allowance(owner, spender);
541         if (currentAllowance != type(uint256).max) {
542             require(currentAllowance >= amount, "ERC20: insufficient allowance");
543             unchecked {
544                 _approve(owner, spender, currentAllowance - amount);
545             }
546         }
547     }
548 
549     /**
550      * @dev Hook that is called before any transfer of tokens. This includes
551      * minting and burning.
552      *
553      * Calling conditions:
554      *
555      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
556      * will be transferred to `to`.
557      * - when `from` is zero, `amount` tokens will be minted for `to`.
558      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
559      * - `from` and `to` are never both zero.
560      *
561      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
562      */
563     function _beforeTokenTransfer(
564         address from,
565         address to,
566         uint256 amount
567     ) internal virtual {}
568 
569     /**
570      * @dev Hook that is called after any transfer of tokens. This includes
571      * minting and burning.
572      *
573      * Calling conditions:
574      *
575      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
576      * has been transferred to `to`.
577      * - when `from` is zero, `amount` tokens have been minted for `to`.
578      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
579      * - `from` and `to` are never both zero.
580      *
581      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
582      */
583     function _afterTokenTransfer(
584         address from,
585         address to,
586         uint256 amount
587     ) internal virtual {}
588 }
589 
590 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol
591 
592 
593 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Capped.sol)
594 
595 pragma solidity ^0.8.0;
596 
597 
598 /**
599  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
600  */
601 abstract contract ERC20Capped is ERC20 {
602     uint256 private immutable _cap;
603 
604     /**
605      * @dev Sets the value of the `cap`. This value is immutable, it can only be
606      * set once during construction.
607      */
608     constructor(uint256 cap_) {
609         require(cap_ > 0, "ERC20Capped: cap is 0");
610         _cap = cap_;
611     }
612 
613     /**
614      * @dev Returns the cap on the token's total supply.
615      */
616     function cap() public view virtual returns (uint256) {
617         return _cap;
618     }
619 
620     /**
621      * @dev See {ERC20-_mint}.
622      */
623     function _mint(address account, uint256 amount) internal virtual override {
624         require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
625         super._mint(account, amount);
626     }
627 }
628 
629 // File: contracts/token-distribution/ExordeToken.sol
630 
631 
632 
633 pragma solidity 0.8.8;
634 
635 
636 /**
637 @title Exorde Network ERC20 Token
638 @author Mathias Dail - CTO @ Exorde Labs
639 */
640 
641 contract ExordeToken is  ERC20Capped {
642     constructor() ERC20 ("Exorde Network Token", "EXD") ERC20Capped(200*(10**6)*(10**18)) {
643         _mint(0xd27b4910372155743878737dE0A80008C55D50D1, 200*(10**6)*(10**18)); // 200 000 000 (two hundred million) EXD, with 18 decimals (by default)
644     }
645 }