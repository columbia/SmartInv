1 // SPDX-License-Identifier: MITs
2 pragma solidity 0.8.19;
3 
4 /**
5  *  ____  _      _        _    ___
6  * |  _ \(_) ___| |__    / \  |_ _|
7  * | |_) | |/ __| '_ \  / _ \  | |
8  * |  _ <| | (__| | | |/ ___ \ | |
9  * |_| \_\_|\___|_| |_/_/   \_\___|
10  *
11  * AI-powered Image generator & Voice GPT assistant.
12  * We have already established a functional product with our in-house ChatGPT assistant and AI Image Generator.
13  *
14  * Homepage: https://richai.app/
15  * Twitter: https://twitter.com/richaiApp
16  * Telegram: https://t.me/richaiofficial
17  * Discord: https://discord.gg/VQ9FcnHXXe
18  *
19  * Total Supply: 1 Billion Tokens
20  * Set slippage to 3-4%: 1% to LP, 2% tax for Marketing & AI Development
21  *
22  * Telegram Bot:
23  * - AI Chatbot
24  * - AI image generator with over 10 styles
25  * - Private chat with the bot
26  * - Add the bot to your Telegram channel
27  *
28  * Discord Bot:
29  * - AI Chatbot
30  * - AI image generator with over 10 styles
31  * - Customize images with 6 options
32  * - Add the bot to your Discord community
33  *
34  * Web App:
35  * - AI chatbot with voice commands
36  * - AI image generator
37  * - Visual customizations
38  * - Easy to use interface
39  *
40  * Android App:
41  * - AI chatbot with voice commands
42  * - AI image generator
43  * - Visual customizations
44 */
45 
46 /**
47  * @dev Interface of the ERC20 standard as defined in the EIP.
48  */
49 interface IERC20 {
50     /**
51      * @dev Emitted when `value` tokens are moved from one account (`from`) to
52      * another (`to`).
53      *
54      * Note that `value` may be zero.
55      */
56     event Transfer(address indexed from, address indexed to, uint256 value);
57 
58     /**
59      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
60      * a call to {approve}. `value` is the new allowance.
61      */
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 
64     /**
65      * @dev Returns the amount of tokens in existence.
66      */
67     function totalSupply() external view returns (uint256);
68 
69     /**
70      * @dev Returns the amount of tokens owned by `account`.
71      */
72     function balanceOf(address account) external view returns (uint256);
73 
74     /**
75      * @dev Moves `amount` tokens from the caller's account to `to`.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transfer(address to, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Returns the remaining number of tokens that `spender` will be
85      * allowed to spend on behalf of `owner` through {transferFrom}. This is
86      * zero by default.
87      *
88      * This value changes when {approve} or {transferFrom} are called.
89      */
90     function allowance(address owner, address spender) external view returns (uint256);
91 
92     /**
93      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * IMPORTANT: Beware that changing an allowance with this method brings the risk
98      * that someone may use both the old and the new allowance by unfortunate
99      * transaction ordering. One possible solution to mitigate this race
100      * condition is to first reduce the spender's allowance to 0 and set the
101      * desired value afterwards:
102      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
103      *
104      * Emits an {Approval} event.
105      */
106     function approve(address spender, uint256 amount) external returns (bool);
107 
108     /**
109      * @dev Moves `amount` tokens from `from` to `to` using the
110      * allowance mechanism. `amount` is then deducted from the caller's
111      * allowance.
112      *
113      * Returns a boolean value indicating whether the operation succeeded.
114      *
115      * Emits a {Transfer} event.
116      */
117     function transferFrom(
118         address from,
119         address to,
120         uint256 amount
121     ) external returns (bool);
122 }
123 
124 /**
125  * @dev Interface for the optional metadata functions from the ERC20 standard.
126  *
127  * _Available since v4.1._
128  */
129 interface IERC20Metadata is IERC20 {
130     /**
131      * @dev Returns the name of the token.
132      */
133     function name() external view returns (string memory);
134 
135     /**
136      * @dev Returns the symbol of the token.
137      */
138     function symbol() external view returns (string memory);
139 
140     /**
141      * @dev Returns the decimals places of the token.
142      */
143     function decimals() external view returns (uint8);
144 }
145 
146 /**
147  * @dev Provides information about the current execution context, including the
148  * sender of the transaction and its data. While these are generally available
149  * via msg.sender and msg.data, they should not be accessed in such a direct
150  * manner, since when dealing with meta-transactions the account sending and
151  * paying for execution may not be the actual sender (as far as an application
152  * is concerned).
153  *
154  * This contract is only required for intermediate, library-like contracts.
155  */
156 abstract contract Context {
157     function _msgSender() internal view virtual returns (address) {
158         return msg.sender;
159     }
160 
161     function _msgData() internal view virtual returns (bytes calldata) {
162         return msg.data;
163     }
164 }
165 
166 /**
167  * @dev Implementation of the {IERC20} interface.
168  *
169  * This implementation is agnostic to the way tokens are created. This means
170  * that a supply mechanism has to be added in a derived contract using {_mint}.
171  * For a generic mechanism see {ERC20PresetMinterPauser}.
172  *
173  * TIP: For a detailed writeup see our guide
174  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
175  * to implement supply mechanisms].
176  *
177  * We have followed general OpenZeppelin Contracts guidelines: functions revert
178  * instead returning `false` on failure. This behavior is nonetheless
179  * conventional and does not conflict with the expectations of ERC20
180  * applications.
181  *
182  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
183  * This allows applications to reconstruct the allowance for all accounts just
184  * by listening to said events. Other implementations of the EIP may not emit
185  * these events, as it isn't required by the specification.
186  *
187  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
188  * functions have been added to mitigate the well-known issues around setting
189  * allowances. See {IERC20-approve}.
190  */
191 contract ERC20 is Context, IERC20, IERC20Metadata {
192     mapping(address => uint256) private _balances;
193 
194     mapping(address => mapping(address => uint256)) private _allowances;
195 
196     uint256 private _totalSupply;
197 
198     string private _name;
199     string private _symbol;
200 
201     /**
202      * @dev Sets the values for {name} and {symbol}.
203      *
204      * The default value of {decimals} is 18. To select a different value for
205      * {decimals} you should overload it.
206      *
207      * All two of these values are immutable: they can only be set once during
208      * construction.
209      */
210     constructor(string memory name_, string memory symbol_) {
211         _name = name_;
212         _symbol = symbol_;
213     }
214 
215     /**
216      * @dev Returns the name of the token.
217      */
218     function name() public view virtual override returns (string memory) {
219         return _name;
220     }
221 
222     /**
223      * @dev Returns the symbol of the token, usually a shorter version of the
224      * name.
225      */
226     function symbol() public view virtual override returns (string memory) {
227         return _symbol;
228     }
229 
230     /**
231      * @dev Returns the number of decimals used to get its user representation.
232      * For example, if `decimals` equals `2`, a balance of `505` tokens should
233      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
234      *
235      * Tokens usually opt for a value of 18, imitating the relationship between
236      * Ether and Wei. This is the value {ERC20} uses, unless this function is
237      * overridden;
238      *
239      * NOTE: This information is only used for _display_ purposes: it in
240      * no way affects any of the arithmetic of the contract, including
241      * {IERC20-balanceOf} and {IERC20-transfer}.
242      */
243     function decimals() public view virtual override returns (uint8) {
244         return 18;
245     }
246 
247     /**
248      * @dev See {IERC20-totalSupply}.
249      */
250     function totalSupply() public view virtual override returns (uint256) {
251         return _totalSupply;
252     }
253 
254     /**
255      * @dev See {IERC20-balanceOf}.
256      */
257     function balanceOf(address account) public view virtual override returns (uint256) {
258         return _balances[account];
259     }
260 
261     /**
262      * @dev See {IERC20-transfer}.
263      *
264      * Requirements:
265      *
266      * - `to` cannot be the zero address.
267      * - the caller must have a balance of at least `amount`.
268      */
269     function transfer(address to, uint256 amount) public virtual override returns (bool) {
270         address owner = _msgSender();
271         _transfer(owner, to, amount);
272         return true;
273     }
274 
275     /**
276      * @dev See {IERC20-allowance}.
277      */
278     function allowance(address owner, address spender) public view virtual override returns (uint256) {
279         return _allowances[owner][spender];
280     }
281 
282     /**
283      * @dev See {IERC20-approve}.
284      *
285      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
286      * `transferFrom`. This is semantically equivalent to an infinite approval.
287      *
288      * Requirements:
289      *
290      * - `spender` cannot be the zero address.
291      */
292     function approve(address spender, uint256 amount) public virtual override returns (bool) {
293         address owner = _msgSender();
294         _approve(owner, spender, amount);
295         return true;
296     }
297 
298     /**
299      * @dev See {IERC20-transferFrom}.
300      *
301      * Emits an {Approval} event indicating the updated allowance. This is not
302      * required by the EIP. See the note at the beginning of {ERC20}.
303      *
304      * NOTE: Does not update the allowance if the current allowance
305      * is the maximum `uint256`.
306      *
307      * Requirements:
308      *
309      * - `from` and `to` cannot be the zero address.
310      * - `from` must have a balance of at least `amount`.
311      * - the caller must have allowance for ``from``'s tokens of at least
312      * `amount`.
313      */
314     function transferFrom(
315         address from,
316         address to,
317         uint256 amount
318     ) public virtual override returns (bool) {
319         address spender = _msgSender();
320         _spendAllowance(from, spender, amount);
321         _transfer(from, to, amount);
322         return true;
323     }
324 
325     /**
326      * @dev Atomically increases the allowance granted to `spender` by the caller.
327      *
328      * This is an alternative to {approve} that can be used as a mitigation for
329      * problems described in {IERC20-approve}.
330      *
331      * Emits an {Approval} event indicating the updated allowance.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      */
337     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
338         address owner = _msgSender();
339         _approve(owner, spender, allowance(owner, spender) + addedValue);
340         return true;
341     }
342 
343     /**
344      * @dev Atomically decreases the allowance granted to `spender` by the caller.
345      *
346      * This is an alternative to {approve} that can be used as a mitigation for
347      * problems described in {IERC20-approve}.
348      *
349      * Emits an {Approval} event indicating the updated allowance.
350      *
351      * Requirements:
352      *
353      * - `spender` cannot be the zero address.
354      * - `spender` must have allowance for the caller of at least
355      * `subtractedValue`.
356      */
357     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
358         address owner = _msgSender();
359         uint256 currentAllowance = allowance(owner, spender);
360         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
361         unchecked {
362             _approve(owner, spender, currentAllowance - subtractedValue);
363         }
364 
365         return true;
366     }
367 
368     /**
369      * @dev Moves `amount` of tokens from `from` to `to`.
370      *
371      * This internal function is equivalent to {transfer}, and can be used to
372      * e.g. implement automatic token fees, slashing mechanisms, etc.
373      *
374      * Emits a {Transfer} event.
375      *
376      * Requirements:
377      *
378      * - `from` cannot be the zero address.
379      * - `to` cannot be the zero address.
380      * - `from` must have a balance of at least `amount`.
381      */
382     function _transfer(
383         address from,
384         address to,
385         uint256 amount
386     ) internal virtual {
387         require(from != address(0), "ERC20: transfer from the zero address");
388         require(to != address(0), "ERC20: transfer to the zero address");
389 
390         _beforeTokenTransfer(from, to, amount);
391 
392         uint256 fromBalance = _balances[from];
393         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
394         unchecked {
395             _balances[from] = fromBalance - amount;
396             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
397             // decrementing then incrementing.
398             _balances[to] += amount;
399         }
400 
401         emit Transfer(from, to, amount);
402 
403         _afterTokenTransfer(from, to, amount);
404     }
405 
406     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
407      * the total supply.
408      *
409      * Emits a {Transfer} event with `from` set to the zero address.
410      *
411      * Requirements:
412      *
413      * - `account` cannot be the zero address.
414      */
415     function _mint(address account, uint256 amount) internal virtual {
416         require(account != address(0), "ERC20: mint to the zero address");
417 
418         _beforeTokenTransfer(address(0), account, amount);
419 
420         _totalSupply += amount;
421         unchecked {
422             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
423             _balances[account] += amount;
424         }
425         emit Transfer(address(0), account, amount);
426 
427         _afterTokenTransfer(address(0), account, amount);
428     }
429 
430     /**
431      * @dev Destroys `amount` tokens from `account`, reducing the
432      * total supply.
433      *
434      * Emits a {Transfer} event with `to` set to the zero address.
435      *
436      * Requirements:
437      *
438      * - `account` cannot be the zero address.
439      * - `account` must have at least `amount` tokens.
440      */
441     function _burn(address account, uint256 amount) internal virtual {
442         require(account != address(0), "ERC20: burn from the zero address");
443 
444         _beforeTokenTransfer(account, address(0), amount);
445 
446         uint256 accountBalance = _balances[account];
447         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
448         unchecked {
449             _balances[account] = accountBalance - amount;
450             // Overflow not possible: amount <= accountBalance <= totalSupply.
451             _totalSupply -= amount;
452         }
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
485      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
486      *
487      * Does not update the allowance amount in case of infinite allowance.
488      * Revert if not enough allowance is available.
489      *
490      * Might emit an {Approval} event.
491      */
492     function _spendAllowance(
493         address owner,
494         address spender,
495         uint256 amount
496     ) internal virtual {
497         uint256 currentAllowance = allowance(owner, spender);
498         if (currentAllowance != type(uint256).max) {
499             require(currentAllowance >= amount, "ERC20: insufficient allowance");
500             unchecked {
501                 _approve(owner, spender, currentAllowance - amount);
502             }
503         }
504     }
505 
506     /**
507      * @dev Hook that is called before any transfer of tokens. This includes
508      * minting and burning.
509      *
510      * Calling conditions:
511      *
512      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
513      * will be transferred to `to`.
514      * - when `from` is zero, `amount` tokens will be minted for `to`.
515      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
516      * - `from` and `to` are never both zero.
517      *
518      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
519      */
520     function _beforeTokenTransfer(
521         address from,
522         address to,
523         uint256 amount
524     ) internal virtual {}
525 
526     /**
527      * @dev Hook that is called after any transfer of tokens. This includes
528      * minting and burning.
529      *
530      * Calling conditions:
531      *
532      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
533      * has been transferred to `to`.
534      * - when `from` is zero, `amount` tokens have been minted for `to`.
535      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
536      * - `from` and `to` are never both zero.
537      *
538      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
539      */
540     function _afterTokenTransfer(
541         address from,
542         address to,
543         uint256 amount
544     ) internal virtual {}
545 }
546 
547 /**
548  * @dev Extension of {ERC20} that allows token holders to destroy both their own
549  * tokens and those that they have an allowance for, in a way that can be
550  * recognized off-chain (via event analysis).
551  */
552 abstract contract ERC20Burnable is Context, ERC20 {
553     /**
554      * @dev Destroys `amount` tokens from the caller.
555      *
556      * See {ERC20-_burn}.
557      */
558     function burn(uint256 amount) public virtual {
559         _burn(_msgSender(), amount);
560     }
561 
562     /**
563      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
564      * allowance.
565      *
566      * See {ERC20-_burn} and {ERC20-allowance}.
567      *
568      * Requirements:
569      *
570      * - the caller must have allowance for ``accounts``'s tokens of at least
571      * `amount`.
572      */
573     function burnFrom(address account, uint256 amount) public virtual {
574         _spendAllowance(account, _msgSender(), amount);
575         _burn(account, amount);
576     }
577 }
578 
579 interface IUniswapV2Router01 {
580     function factory() external pure returns (address);
581     function WETH() external pure returns (address);
582 
583     function addLiquidity(
584         address tokenA,
585         address tokenB,
586         uint amountADesired,
587         uint amountBDesired,
588         uint amountAMin,
589         uint amountBMin,
590         address to,
591         uint deadline
592     ) external returns (uint amountA, uint amountB, uint liquidity);
593     function addLiquidityETH(
594         address token,
595         uint amountTokenDesired,
596         uint amountTokenMin,
597         uint amountETHMin,
598         address to,
599         uint deadline
600     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
601     function removeLiquidity(
602         address tokenA,
603         address tokenB,
604         uint liquidity,
605         uint amountAMin,
606         uint amountBMin,
607         address to,
608         uint deadline
609     ) external returns (uint amountA, uint amountB);
610     function removeLiquidityETH(
611         address token,
612         uint liquidity,
613         uint amountTokenMin,
614         uint amountETHMin,
615         address to,
616         uint deadline
617     ) external returns (uint amountToken, uint amountETH);
618     function removeLiquidityWithPermit(
619         address tokenA,
620         address tokenB,
621         uint liquidity,
622         uint amountAMin,
623         uint amountBMin,
624         address to,
625         uint deadline,
626         bool approveMax, uint8 v, bytes32 r, bytes32 s
627     ) external returns (uint amountA, uint amountB);
628     function removeLiquidityETHWithPermit(
629         address token,
630         uint liquidity,
631         uint amountTokenMin,
632         uint amountETHMin,
633         address to,
634         uint deadline,
635         bool approveMax, uint8 v, bytes32 r, bytes32 s
636     ) external returns (uint amountToken, uint amountETH);
637     function swapExactTokensForTokens(
638         uint amountIn,
639         uint amountOutMin,
640         address[] calldata path,
641         address to,
642         uint deadline
643     ) external returns (uint[] memory amounts);
644     function swapTokensForExactTokens(
645         uint amountOut,
646         uint amountInMax,
647         address[] calldata path,
648         address to,
649         uint deadline
650     ) external returns (uint[] memory amounts);
651     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
652         external
653         payable
654         returns (uint[] memory amounts);
655     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
656         external
657         returns (uint[] memory amounts);
658     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
659         external
660         returns (uint[] memory amounts);
661     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
662         external
663         payable
664         returns (uint[] memory amounts);
665 
666     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
667     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
668     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
669     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
670     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
671 }
672 
673 interface IUniswapV2Router02 is IUniswapV2Router01 {
674     function removeLiquidityETHSupportingFeeOnTransferTokens(
675         address token,
676         uint liquidity,
677         uint amountTokenMin,
678         uint amountETHMin,
679         address to,
680         uint deadline
681     ) external returns (uint amountETH);
682     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
683         address token,
684         uint liquidity,
685         uint amountTokenMin,
686         uint amountETHMin,
687         address to,
688         uint deadline,
689         bool approveMax, uint8 v, bytes32 r, bytes32 s
690     ) external returns (uint amountETH);
691 
692     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
693         uint amountIn,
694         uint amountOutMin,
695         address[] calldata path,
696         address to,
697         uint deadline
698     ) external;
699     function swapExactETHForTokensSupportingFeeOnTransferTokens(
700         uint amountOutMin,
701         address[] calldata path,
702         address to,
703         uint deadline
704     ) external payable;
705     function swapExactTokensForETHSupportingFeeOnTransferTokens(
706         uint amountIn,
707         uint amountOutMin,
708         address[] calldata path,
709         address to,
710         uint deadline
711     ) external;
712 }
713 
714 interface IUniswapV2Factory {
715     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
716 
717     function feeTo() external view returns (address);
718     function feeToSetter() external view returns (address);
719 
720     function getPair(address tokenA, address tokenB) external view returns (address pair);
721     function allPairs(uint) external view returns (address pair);
722     function allPairsLength() external view returns (uint);
723 
724     function createPair(address tokenA, address tokenB) external returns (address pair);
725 
726     function setFeeTo(address) external;
727     function setFeeToSetter(address) external;
728 }
729 
730 contract RichAi is ERC20Burnable {
731     string private constant _name = "RichAI";
732     string private constant _symbol = "RICHAI";
733     uint8 private constant _decimals = 18;
734     uint256 private constant _supply = 1_000_000_000; // 1 billion tokens
735 
736     uint256 public constant TOKENS_TO_SEND = 100000 * 10**_decimals;
737     uint256 public constant TOKENS_TO_SELL_AND_LIQUIFY = 100000 * 10**_decimals;
738 
739     uint256 public constant MAX_TX_AMOUNT = 10000001 * 10**_decimals;
740     uint256 public constant MAX_WALLET_AMOUNT = 10000001 * 10**_decimals;
741 
742     uint256 public constant TAX_FOR_LIQUIDITY = 1;
743     uint256 public constant TAX_FOR_MARKETING = 1;
744     uint256 public constant TAX_FOR_DEVELOPER = 1;
745 
746     uint256 public marketingReserves = 0;
747     uint256 public developerReserves = 0;
748 
749     address public constant MARKETING_WALLET = 0x9da6A12c5F1bE1eD532Fa28354D896781eA971B2;
750     address public constant DEVELOPER_WALLET = 0xF279C263EFbAd7A123866737D1735De837287A0a;
751 
752     address private constant DEAD = 0x000000000000000000000000000000000000dEaD;
753     address private constant ZERO = 0x0000000000000000000000000000000000000000;
754 
755     mapping(address => bool) public _isExcludedFromFee;
756 
757     event PairUpdated(address _address);
758     event ExcludedFromFeeUpdated(address _address, bool _status);
759 
760     IUniswapV2Router02 public immutable uniswapV2Router;
761     address public uniswapV2Pair;
762 
763     bool inSwapAndLiquify;
764 
765     event SwapAndLiquify(
766         uint256 tokensSwapped,
767         uint256 ethReceived,
768         uint256 tokensIntoLiqudity
769     );
770 
771     event FeePaid(
772         uint256 tokens,
773         uint256 eth
774     );
775 
776     modifier lockTheSwap() {
777         inSwapAndLiquify = true;
778         _;
779         inSwapAndLiquify = false;
780     }
781 
782     //  ===================================================
783     //  CONSTRUCTOR
784     //  ===================================================
785 
786     constructor() ERC20(_name, _symbol) {
787         _mint(msg.sender, (_supply * 10**_decimals));
788 
789         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //eth mainnet
790         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
791 
792         uniswapV2Router = _uniswapV2Router;
793 
794         _isExcludedFromFee[msg.sender] = true;
795         _isExcludedFromFee[MARKETING_WALLET] = true;
796         _isExcludedFromFee[DEVELOPER_WALLET] = true;
797         _isExcludedFromFee[address(uniswapV2Router)] = true;
798     }
799 
800     //  ===================================================
801     //  INTERNAL
802     //  ===================================================
803 
804     function _transfer(address from, address to, uint256 amount) internal override {
805         require(from != ZERO, "ERC20: transfer from the zero address");
806         require(to != ZERO, "ERC20: transfer to the zero address");
807         require(balanceOf(from) >= amount, "ERC20: transfer amount exceeds balance");
808 
809         if ((from == uniswapV2Pair || to == uniswapV2Pair) && !inSwapAndLiquify) {
810             if (from != uniswapV2Pair) {
811                 uint256 contractLiquidityBalance = balanceOf(address(this)) - (marketingReserves + developerReserves);
812                 if (contractLiquidityBalance >= TOKENS_TO_SELL_AND_LIQUIFY) {
813                     _swapAndLiquify(TOKENS_TO_SELL_AND_LIQUIFY);
814                 }
815 
816                 if (marketingReserves >= TOKENS_TO_SEND) {
817                     _swapFeeAndSend(TOKENS_TO_SEND * 2);
818                     marketingReserves -= TOKENS_TO_SEND;
819                     developerReserves -= TOKENS_TO_SEND;
820                 }
821             }
822 
823             uint256 transferAmount;
824             if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
825                 transferAmount = amount;
826             } else {
827                 require(amount <= MAX_TX_AMOUNT, "ERC20: transfer amount exceeds the max transaction amount");
828 
829                 if (from == uniswapV2Pair){
830                     require((amount + balanceOf(to)) <= MAX_WALLET_AMOUNT, "ERC20: balance amount exceeded max wallet amount limit");
831                 }
832 
833                 uint256 marketingShare = ((amount * TAX_FOR_MARKETING) / 100);
834                 uint256 developersShare = ((amount * TAX_FOR_DEVELOPER) / 100);
835                 uint256 liquidityShare = ((amount * TAX_FOR_LIQUIDITY) / 100);
836 
837                 marketingReserves += marketingShare;
838                 developerReserves += developersShare;
839 
840                 transferAmount = amount - (marketingShare + developersShare + liquidityShare);
841                 super._transfer(from, address(this), (marketingShare + developersShare + liquidityShare));
842             }
843 
844             super._transfer(from, to, transferAmount);
845         } else {
846             super._transfer(from, to, amount);
847         }
848     }
849 
850     function _swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
851         uint256 half = (contractTokenBalance / 2);
852         uint256 otherHalf = (contractTokenBalance - half);
853 
854         uint256 initialBalance = address(this).balance;
855 
856         _swapTokensForEth(half);
857 
858         uint256 newBalance = (address(this).balance - initialBalance);
859 
860         _addLiquidity(otherHalf, address(this).balance);
861 
862         emit SwapAndLiquify(half, newBalance, otherHalf);
863     }
864 
865     function _swapFeeAndSend(uint256 amount) private lockTheSwap {
866         _swapTokensForEth(amount);
867 
868         bool success;
869         uint256 ethReceived = address(this).balance;
870 
871         (success,) = address(MARKETING_WALLET).call{ value: ethReceived / 2 }("");
872         (success,) = address(DEVELOPER_WALLET).call{ value: ethReceived / 2 }("");
873 
874         emit FeePaid(amount, ethReceived);
875     }
876 
877 
878     function _swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
879         address[] memory path = new address[](2);
880         path[0] = address(this);
881         path[1] = uniswapV2Router.WETH();
882 
883         _approve(address(this), address(uniswapV2Router), tokenAmount);
884 
885         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
886             tokenAmount,
887             0,
888             path,
889             address(this),
890             block.timestamp
891         );
892     }
893 
894     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount)
895         private
896         lockTheSwap
897     {
898         _approve(address(this), address(uniswapV2Router), tokenAmount);
899 
900         uniswapV2Router.addLiquidityETH{value: ethAmount}(
901             address(this),
902             tokenAmount,
903             0,
904             0,
905             MARKETING_WALLET,
906             block.timestamp
907         );
908     }
909 
910     receive() external payable {}
911 
912     fallback() external payable {}
913 }