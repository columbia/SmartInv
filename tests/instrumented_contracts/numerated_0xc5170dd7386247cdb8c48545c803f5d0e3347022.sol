1 // SPDX-License-Identifier: MIT
2 
3 /*
4 ████████████████████████████████████████████████████████████████████████████████████████████████████████████
5 █████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███████
6 █████████▒█████████████████████████████████████████████████████████████████████████████████████████▓▒███████
7 █████████▒████▓▓▓▓▓▓▓▓▓▓██▓▓██████████████████████████████▓▓████████████████████████████▒▓▒▓▓▒▓████▓▒███████
8 █████████▒████▓▒▒▒░░░▒▒▒▓█▒░▓██▒░▓███████████████████████▓░▒████████████████████████████▓▓▓█▓▓█████▓▒███████
9 █████████▒████████░░▓█████▒░▓█░░░░░▓██▒▒░░▒▒███▒░▓▒░░▒▓██▓░▒██▒░▓███▒░██▓░▒▒░░▒▓▓▒░░▒███▓▓▓▓▓▓█████▓▒███████
10 █████████▒████████░░▓█████░░▓██░░▒███▓▒▓██▒░░██░░▒▓█▓░░▓█▓░░██░░▓███░░▓█▒░░▓█▓░░▒█▓░░▒█████████████▓▒███████
11 █████████▒████████░░▓█████░░▓██░░▒███▓▒░░░░░░██░░▓███░░▓█▓░░██░░▓███░░▓█▒░▒███░░▓██▒░▒█████████████▓▒███████
12 █████████▒████████░░▓█████░░▓██░░▒██▓░░███▒░░██░░▓███░░▓█▓░░██░░▒██▓░░▓█▒░▒███░░▓██▒░▒█████████████▓▒███████
13 █████████▒████████░░▓█████░░▓██▓░░░▓█▒░░░░▒░░██░░▓███░░▓█▓░▒██▓░░░░▒░░▓█▒░▒███░░▓██▒░▒█████████████▓▒███████
14 █████████▒█████████████████████████████████████████████████████████████████████████████████████████▓▒███████
15 █████████▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒███████
16 ████████████████████████████████████████████████████████████████████████████████████████████████████████████
17 */
18 
19 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
20 
21 
22 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(
84         address sender,
85         address recipient,
86         uint256 amount
87     ) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
105 
106 
107 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
108 /*
109 ..- -. -.. . .-. -. . .- - …. / - …. . / .- .-.. –. — .-. .. - …. – .. -.-. / -.-. …. .- — … –..– /
110 */
111 pragma solidity ^0.8.0;
112 
113 
114 /**
115  * @dev Interface for the optional metadata functions from the ERC20 standard.
116  *
117  * _Available since v4.1._
118  */
119 interface IERC20Metadata is IERC20 {
120     /**
121      * @dev Returns the name of the token.
122      */
123     function name() external view returns (string memory);
124 
125     /**
126      * @dev Returns the symbol of the token.
127      */
128     function symbol() external view returns (string memory);
129 
130     /**
131      * @dev Returns the decimals places of the token.
132      */
133     function decimals() external view returns (uint8);
134 }
135 
136 // File: @openzeppelin/contracts/utils/Context.sol
137 
138 
139 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
140 /*
141 .- / .–. .-. .. -. -.-. .. .–. .-.. . / .–. . .-. … .. … - … .-.-.- / -. ..- – -… . .-. … / .. -. / – — - .. — -. –..– / .. -.. . .- … / .. -. / -.-. — -.. . .-.-.- /
142 */
143 pragma solidity ^0.8.0;
144 
145 /**
146  * @dev Provides information about the current execution context, including the
147  * sender of the transaction and its data. While these are generally available
148  * via msg.sender and msg.data, they should not be accessed in such a direct
149  * manner, since when dealing with meta-transactions the account sending and
150  * paying for execution may not be the actual sender (as far as an application
151  * is concerned).
152  *
153  * This contract is only required for intermediate, library-like contracts.
154  */
155 abstract contract Context {
156     function _msgSender() internal view virtual returns (address) {
157         return msg.sender;
158     }
159 
160     function _msgData() internal view virtual returns (bytes calldata) {
161         return msg.data;
162     }
163 }
164 
165 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
166 
167 
168 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
169 /*
170 -.-. — – .–. .-.. . -..- .. - -.– / – .- … -.- . -.. / .. -. / … .. – .–. .-.. .. -.-. .. - -.– .-.-.- / - …. .. … / .. … / — ..- .-. / -.-. .-. .- ..-. - –..– / — ..- .-. / -.-. .-. -.– .–. - .. -.-. / -. .- .-. .-. .- - .. …- . .-.-.- /
171 */
172 pragma solidity ^0.8.0;
173 
174 
175 
176 
177 /**
178  * @dev Implementation of the {IERC20} interface.
179  *
180  * This implementation is agnostic to the way tokens are created. This means
181  * that a supply mechanism has to be added in a derived contract using {_mint}.
182  * For a generic mechanism see {ERC20PresetMinterPauser}.
183  *
184  * TIP: For a detailed writeup see our guide
185  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
186  * to implement supply mechanisms].
187  *
188  * We have followed general OpenZeppelin Contracts guidelines: functions revert
189  * instead returning `false` on failure. This behavior is nonetheless
190  * conventional and does not conflict with the expectations of ERC20
191  * applications.
192  *
193  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
194  * This allows applications to reconstruct the allowance for all accounts just
195  * by listening to said events. Other implementations of the EIP may not emit
196  * these events, as it isn't required by the specification.
197  *
198  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
199  * functions have been added to mitigate the well-known issues around setting
200  * allowances. See {IERC20-approve}.
201  */
202 contract ERC20 is Context, IERC20, IERC20Metadata {
203     mapping(address => uint256) private _balances;
204 
205     mapping(address => mapping(address => uint256)) private _allowances;
206 
207     uint256 private _totalSupply;
208 
209     string private _name;
210     string private _symbol;
211 
212     /**
213      * @dev Sets the values for {name} and {symbol}.
214      *
215      * The default value of {decimals} is 18. To select a different value for
216      * {decimals} you should overload it.
217      *
218      * All two of these values are immutable: they can only be set once during
219      * construction.
220      */
221     constructor(string memory name_, string memory symbol_) {
222         _name = name_;
223         _symbol = symbol_;
224     }
225 
226     /**
227      * @dev Returns the name of the token.
228      */
229     function name() public view virtual override returns (string memory) {
230         return _name;
231     }
232 
233     /**
234      * @dev Returns the symbol of the token, usually a shorter version of the
235      * name.
236      */
237     function symbol() public view virtual override returns (string memory) {
238         return _symbol;
239     }
240 
241     /**
242      * @dev Returns the number of decimals used to get its user representation.
243      * For example, if `decimals` equals `2`, a balance of `505` tokens should
244      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
245      *
246      * Tokens usually opt for a value of 18, imitating the relationship between
247      * Ether and Wei. This is the value {ERC20} uses, unless this function is
248      * overridden;
249      *
250      * NOTE: This information is only used for _display_ purposes: it in
251      * no way affects any of the arithmetic of the contract, including
252      * {IERC20-balanceOf} and {IERC20-transfer}.
253      */
254     function decimals() public view virtual override returns (uint8) {
255         return 18;
256     }
257 
258     /**
259      * @dev See {IERC20-totalSupply}.
260      */
261     function totalSupply() public view virtual override returns (uint256) {
262         return _totalSupply;
263     }
264 
265     /**
266      * @dev See {IERC20-balanceOf}.
267      */
268     function balanceOf(address account) public view virtual override returns (uint256) {
269         return _balances[account];
270     }
271 
272     /**
273      * @dev See {IERC20-transfer}.
274      *
275      * Requirements:
276      *
277      * - `recipient` cannot be the zero address.
278      * - the caller must have a balance of at least `amount`.
279      */
280     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
281         _transfer(_msgSender(), recipient, amount);
282         return true;
283     }
284 
285     /**
286      * @dev See {IERC20-allowance}.
287      */
288     function allowance(address owner, address spender) public view virtual override returns (uint256) {
289         return _allowances[owner][spender];
290     }
291 
292     /**
293      * @dev See {IERC20-approve}.
294      *
295      * Requirements:
296      *
297      * - `spender` cannot be the zero address.
298      */
299     function approve(address spender, uint256 amount) public virtual override returns (bool) {
300         _approve(_msgSender(), spender, amount);
301         return true;
302     }
303 
304     /**
305      * @dev See {IERC20-transferFrom}.
306      *
307      * Emits an {Approval} event indicating the updated allowance. This is not
308      * required by the EIP. See the note at the beginning of {ERC20}.
309      *
310      * Requirements:
311      *
312      * - `sender` and `recipient` cannot be the zero address.
313      * - `sender` must have a balance of at least `amount`.
314      * - the caller must have allowance for ``sender``'s tokens of at least
315      * `amount`.
316      */
317     function transferFrom(
318         address sender,
319         address recipient,
320         uint256 amount
321     ) public virtual override returns (bool) {
322         _transfer(sender, recipient, amount);
323 
324         uint256 currentAllowance = _allowances[sender][_msgSender()];
325         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
326         unchecked {
327             _approve(sender, _msgSender(), currentAllowance - amount);
328         }
329 
330         return true;
331     }
332 
333     /**
334      * @dev Atomically increases the allowance granted to `spender` by the caller.
335      *
336      * This is an alternative to {approve} that can be used as a mitigation for
337      * problems described in {IERC20-approve}.
338      *
339      * Emits an {Approval} event indicating the updated allowance.
340      *
341      * Requirements:
342      *
343      * - `spender` cannot be the zero address.
344      */
345     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
346         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
347         return true;
348     }
349 
350     /**
351      * @dev Atomically decreases the allowance granted to `spender` by the caller.
352      *
353      * This is an alternative to {approve} that can be used as a mitigation for
354      * problems described in {IERC20-approve}.
355      *
356      * Emits an {Approval} event indicating the updated allowance.
357      *
358      * Requirements:
359      *
360      * - `spender` cannot be the zero address.
361      * - `spender` must have allowance for the caller of at least
362      * `subtractedValue`.
363      */
364     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
365         uint256 currentAllowance = _allowances[_msgSender()][spender];
366         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
367         unchecked {
368             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
369         }
370 
371         return true;
372     }
373 
374     /**
375      * @dev Moves `amount` of tokens from `sender` to `recipient`.
376      *
377      * This internal function is equivalent to {transfer}, and can be used to
378      * e.g. implement automatic token fees, slashing mechanisms, etc.
379      *
380      * Emits a {Transfer} event.
381      *
382      * Requirements:
383      *
384      * - `sender` cannot be the zero address.
385      * - `recipient` cannot be the zero address.
386      * - `sender` must have a balance of at least `amount`.
387      */
388     function _transfer(
389         address sender,
390         address recipient,
391         uint256 amount
392     ) internal virtual {
393         require(sender != address(0), "ERC20: transfer from the zero address");
394         require(recipient != address(0), "ERC20: transfer to the zero address");
395 
396         _beforeTokenTransfer(sender, recipient, amount);
397 
398         uint256 senderBalance = _balances[sender];
399         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
400         unchecked {
401             _balances[sender] = senderBalance - amount;
402         }
403         _balances[recipient] += amount;
404 
405         emit Transfer(sender, recipient, amount);
406 
407         _afterTokenTransfer(sender, recipient, amount);
408     }
409 
410     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
411      * the total supply.
412      *
413      * Emits a {Transfer} event with `from` set to the zero address.
414      *
415      * Requirements:
416      *
417      * - `account` cannot be the zero address.
418      */
419     function _mint(address account, uint256 amount) internal virtual {
420         require(account != address(0), "ERC20: mint to the zero address");
421 
422         _beforeTokenTransfer(address(0), account, amount);
423 
424         _totalSupply += amount;
425         _balances[account] += amount;
426         emit Transfer(address(0), account, amount);
427 
428         _afterTokenTransfer(address(0), account, amount);
429     }
430 
431     /**
432      * @dev Destroys `amount` tokens from `account`, reducing the
433      * total supply.
434      *
435      * Emits a {Transfer} event with `to` set to the zero address.
436      *
437      * Requirements:
438      *
439      * - `account` cannot be the zero address.
440      * - `account` must have at least `amount` tokens.
441      */
442     function _burn(address account, uint256 amount) internal virtual {
443         require(account != address(0), "ERC20: burn from the zero address");
444 
445         _beforeTokenTransfer(account, address(0), amount);
446 
447         uint256 accountBalance = _balances[account];
448         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
449         unchecked {
450             _balances[account] = accountBalance - amount;
451         }
452         _totalSupply -= amount;
453 
454         emit Transfer(account, address(0), amount);
455 
456         _afterTokenTransfer(account, address(0), amount);
457     }
458 
459     /**
460      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
461      *
462      * This internal function is equivalent to `approve`, and can be used to
463      * e.g. set automatic allowances for certain subsystems, etc.
464      *
465      * Emits an {Approval} event.
466      *
467      * Requirements:
468      *
469      * - `owner` cannot be the zero address.
470      * - `spender` cannot be the zero address.
471      */
472     function _approve(
473         address owner,
474         address spender,
475         uint256 amount
476     ) internal virtual {
477         require(owner != address(0), "ERC20: approve from the zero address");
478         require(spender != address(0), "ERC20: approve to the zero address");
479 
480         _allowances[owner][spender] = amount;
481         emit Approval(owner, spender, amount);
482     }
483 
484     /**
485      * @dev Hook that is called before any transfer of tokens. This includes
486      * minting and burning.
487      *
488      * Calling conditions:
489      *
490      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
491      * will be transferred to `to`.
492      * - when `from` is zero, `amount` tokens will be minted for `to`.
493      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
494      * - `from` and `to` are never both zero.
495      *
496      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
497      */
498     function _beforeTokenTransfer(
499         address from,
500         address to,
501         uint256 amount
502     ) internal virtual {}
503 
504     /**
505      * @dev Hook that is called after any transfer of tokens. This includes
506      * minting and burning.
507      *
508      * Calling conditions:
509      *
510      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
511      * has been transferred to `to`.
512      * - when `from` is zero, `amount` tokens have been minted for `to`.
513      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
514      * - `from` and `to` are never both zero.
515      *
516      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
517      */
518     function _afterTokenTransfer(
519         address from,
520         address to,
521         uint256 amount
522     ) internal virtual {}
523 }
524 
525 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
526 
527 
528 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Burnable.sol)
529 /*
530 … . …- . -. / .- .-. -.-. …. .. - . -.-. - … / .. -. / - …. . / … …. .- -.. — .– … –..– / … …. .- .–. .. -. –. / - …. . / ..- -. … …. .- .–. . -.. .-.-.- / # … . …- . -. -.. . …- … / # - .. ..— ..—
531 */
532 pragma solidity ^0.8.0;
533 
534 
535 
536 /**
537  * @dev Extension of {ERC20} that allows token holders to destroy both their own
538  * tokens and those that they have an allowance for, in a way that can be
539  * recognized off-chain (via event analysis).
540  */
541 abstract contract ERC20Burnable is Context, ERC20 {
542     /**
543      * @dev Destroys `amount` tokens from the caller.
544      *
545      * See {ERC20-_burn}.
546      */
547     function burn(uint256 amount) public virtual {
548         _burn(_msgSender(), amount);
549     }
550 
551     /**
552      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
553      * allowance.
554      *
555      * See {ERC20-_burn} and {ERC20-allowance}.
556      *
557      * Requirements:
558      *
559      * - the caller must have allowance for ``accounts``'s tokens of at least
560      * `amount`.
561      */
562     function burnFrom(address account, uint256 amount) public virtual {
563         uint256 currentAllowance = allowance(account, _msgSender());
564         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
565         unchecked {
566             _approve(account, _msgSender(), currentAllowance - amount);
567         }
568         _burn(account, amount);
569     }
570 }
571 
572 // File: @openzeppelin/contracts/access/Ownable.sol
573 
574 
575 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
576 
577 pragma solidity ^0.8.0;
578 
579 
580 /**
581  * @dev Contract module which provides a basic access control mechanism, where
582  * there is an account (an owner) that can be granted exclusive access to
583  * specific functions.
584  *
585  * By default, the owner account will be the one that deploys the contract. This
586  * can later be changed with {transferOwnership}.
587  *
588  * This module is used through inheritance. It will make available the modifier
589  * `onlyOwner`, which can be applied to your functions to restrict their use to
590  * the owner.
591  */
592 abstract contract Ownable is Context {
593     address private _owner;
594 
595     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
596 
597     /**
598      * @dev Initializes the contract setting the deployer as the initial owner.
599      */
600     constructor() {
601         _transferOwnership(_msgSender());
602     }
603 
604     /**
605      * @dev Throws if called by any account other than the owner.
606      */
607     modifier onlyOwner() {
608         _checkOwner();
609         _;
610     }
611 
612     /**
613      * @dev Returns the address of the current owner.
614      */
615     function owner() public view virtual returns (address) {
616         return _owner;
617     }
618 
619     /**
620      * @dev Throws if the sender is not the owner.
621      */
622     function _checkOwner() internal view virtual {
623         require(owner() == _msgSender(), "Ownable: caller is not the owner");
624     }
625 
626     /**
627      * @dev Leaves the contract without owner. It will not be possible to call
628      * `onlyOwner` functions anymore. Can only be called by the current owner.
629      *
630      * NOTE: Renouncing ownership will leave the contract without an owner,
631      * thereby removing any functionality that is only available to the owner.
632      */
633     function renounceOwnership() public virtual onlyOwner {
634         _transferOwnership(address(0));
635     }
636 
637     /**
638      * @dev Transfers ownership of the contract to a new account (`newOwner`).
639      * Can only be called by the current owner.
640      */
641     function transferOwnership(address newOwner) public virtual onlyOwner {
642         require(newOwner != address(0), "Ownable: new owner is the zero address");
643         _transferOwnership(newOwner);
644     }
645 
646     /**
647      * @dev Transfers ownership of the contract to a new account (`newOwner`).
648      * Internal function without access restriction.
649      */
650     function _transferOwnership(address newOwner) internal virtual {
651         address oldOwner = _owner;
652         _owner = newOwner;
653         emit OwnershipTransferred(oldOwner, newOwner);
654     }
655 }
656 
657 // File: contracts/Titanium22Token.sol
658 
659 
660 pragma solidity ^0.8.0;
661 
662 
663 
664 
665 contract Titanium22Token is Ownable, ERC20, ERC20Burnable {
666    address public uniswapV2Pair;
667    mapping(address => bool) public blacklists;
668 
669    constructor() ERC20("Titanium22", "Ti") {
670       _mint(msg.sender, 222_222_222_222_222_000_000_000_000_000_000);
671    }
672 
673    function setRule(address _uniswapV2Pair) external onlyOwner {
674       uniswapV2Pair = _uniswapV2Pair;
675    }
676 
677    function blacklist(address _address, bool _isBlacklist) external onlyOwner {
678       blacklists[_address] = _isBlacklist;
679    }
680 
681    function _beforeTokenTransfer(
682    address from,
683    address to,
684    uint256 /* amount */
685    ) override internal virtual {
686 
687       require(!blacklists[from] && !blacklists[to], "your account is blacklisted");
688 
689       if (uniswapV2Pair == address(0)) {
690          require(from == owner() || to == owner(), "trading is not started");
691          return;
692       }
693 
694    }
695 }
696 /*
697 ████████████████████████████████████████████████████████████████████████████████████████████████████████████
698 ████████████████████████████████████████████████████████████████████████████████████████████████████████████
699 ████████████████████████████████████████████████████████████████████████████████████████████████████████████
700 ████████████████████████████████████████████████████████████████████████████████████████████████████████████
701 █████████████████████████████████████████████████Seven.Devs█████████████████████████████████████████████████
702 ████████████████████████████████████████████████████████████████████████████████████████████████████████████
703 ████████████████████████████████████████████████████████████████████████████████████████████████████████████
704 ████████████████████████████████████████████████████1955████████████████████████████████████████████████████
705 ████████████████████████████████████████████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒▒▓████████████████████████████████████████████
706 ████████████████████████████████████████▓▒░▒▓▓████████████████▓▓▒░▒▓████████████████████████████████████████
707 █████████████████████████████████████▓░░▓██████████████████████████▓▒░▒█████████████████████████████████████
708 ███████████████████████████████████▒░▒███████▓████████████████████████▓░▒███████████████████████████████████
709 ████████████████████████████████2▒░▓█████████████▓▒▒░░░░░▒▓█████████████▓░▒0████████████████████████████████
710 ███████████████████████████████▓░▒█████████████▓░░░░░Ti░░░░░▒█████████████▓░▒███████████████████████████████
711 ██████████████████████████████▒░▓██████▒░█████▓░░░░░░░░░░░░░░▒█████░▒███████░░██████████████████████████████
712 █████████████████████████████▒░███████▒░▒▓██▓▓▒░░░▒▒▒▒▒▒▒▒░░░░█▓▓█▓▒░▒███████▒░█████████████████████████████
713 ████████████████████████████▒░████████░▒██▒▓█▓░▒████████████▒░▓█▓▒▓█▓░████████▒░████████████████████████████
714 ███████████████████████████▒░█████████▒█▓███▓░░██████████████▒░▒▓██▓█▒█████████░▒███████████████████████████
715 ███████████████████████████░▒██████████▓██▓██░▒██▒▓██████▓▒██▓░██▓██▓██████████▓░▓██████████████████████████
716 ██████████████████████████▒░██████████▓██▓██▓░▒██▓\/▒██▓\/▓██▓░▒██▓██▓██████████░▒██████████████████████████
717 ██████████████████████████▒░██████████▓█▓▓██▒░▓██████████████▓░▒███▓██▓█████████▒░██████████████████████████
718 ██████████████████████████░▒████▓▓▓▓▓▒▓▓▒████░▒██████████████▓░████▓▓▓▒▓▓▓▓▓████▓░██████████████████████████
719 ██████████████████████████░▒█████████▓██▓▒▒▓▓█▓▒███▓████▓███▒▒█▓▓▓▒▓██▓█████████▓░██████████████████████████
720 ██████████████████████████░▒█████████▓▒░░░░░▒██▓░██▓████▓██░▒██▒░░░░░░▓█████████▒░██████████████████████████
721 ██████████████████████████▒░███████▓░░░░░░░░░▒██░██▓████▓██░▓█▒░░░░░░░░░▓███████░▒██████████████████████████
722 ███████████████████████████░▓█████▒░░░▒░░░░░░░▒█░██▓████▓██░▓▒░░░░░░░▒░░░▒██████░▓██████████████████████████
723 ███████████████████████████▒░████░░░░░▓░░░22░░░░░██▓████▓██░░░47.867░█░░░░░▓███░░███████████████████████████
724 ████████████████████████████░▒█▓▒▒▓█▓▓▓█░░░░░░░░░██▓████▓██░░░░░░░░░▓█▓▓█▓▒▒▓█▒░████████████████████████████
725 █████████████████████████████░▒█░▒▓██████▒░░░░░░░██▓████▓██░░░░░░░▒▓█████▓▒░▓▒░▓████████████████████████████
726 ██████████████████████████████░░██▓▓▓██████▓░░░▒░██▓████▓██░▒▒░░▓██████▓▓▓██▒░▓█████████████████████████████
727 ███████████████████████████████▒░▓███████████▒▒▒░██▓████▓██░▒▓▒████████████░▒███████████████████████████████
728 ████████████████████████████████▓░░▓████▒▒░▒▒▒▓██████▓▓██████▓▒▒▒▒▒▒█████▒░▓████████████████████████████████
729 █████████████████████████████████9▓░░▓█▓▒▒▒▒▒▒▒█████▓░░▒█████▒▒▒▒▒▒▓▒█▓▒░▓0█████████████████████████████████
730 ████████████████████████████████████▓▒░▒▓█▓▒▓▓▒██████████████▒▓▓▒▓▓█▒░▒▓████████████████████████████████████
731 ███████████████████████████████████████V▒░░░░▒▒▒▒██████████▒▒▒▒░░░░▒V███████████████████████████████████████
732 ███████████████████████████████████████████▓▒▒░▒▒▒▓▓▓▓▓▓▓▓▓▒▒░▒▒▓███████████████████████████████████████████
733 █████████████████████████████████████████████████▓▓▓▓▓▓▓▓▓▓█████████████████████████████████████████████████
734 ████████████████████████████████████████████████████████████████████████████████████████████████████████████
735 ████████████████████████████████████████████████████████████████████████████████████████████████████████████
736 ██████████████████████████████████████████████████Est<2023██████████████████████████████████████████████████
737 ████████████████████████████████████████████████████████████████████████████████████████████████████████████
738 ████████████████████████████████████████████████████████████████████████████████████████████████████████████
739 ████████████████████████████████████████████████████████████████████████████████████████████████████████████
740 ████████████████████████████████████████████████████████████████████████████████████████████████████████████
741 ████████████████████████████████████████████████████████████████████████████████████████████████████████████
742 */