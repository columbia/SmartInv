1 /**
2 
3 In a world plagued by darkness; one in which the soul is tainted by the foulness of a virus.
4 
5 The sickness seeps through the psyche, altering all into evil beings.
6 
7 A world thus becomes plagued by those who are not trustable and do not have any form of empathy.
8 
9 Is it safe to be in this environment? Will there be anyone protecting us? Will anyone fly over and turn this helplessness into hopefulness?
10 
11 Mysterious and spiteful, he lurks above the dark wretched sky observing the predators. He seeks restoration upon a world that used to once have brightness.
12 
13 THE ALCHEMIST
14 
15                                        '"^^^^┌┌"       ╙╣▓▓▓█▀▄╩▀╟▄█▀█║█╠╠╪╬▌▀╬▓████████████████████
16                                      '..^^^^^┌~          ╙▓▀▄█▓.▄██╫▓▓▒█▄╦╙╠╣███████████████████████
17                  ,▄▄Æ▓████████████▓▌▄▄;^^^^^^┌~           ║▓██░▓████╫█▌▒▓▌▒φ▒╬██████████████████████
18               ▄▓▓█▓██████████████████████▄┌^,┌:         ."▓█▌╓████████▐╫j▌▓╬▓╣██████████████████████
19              ╟████████████████████████████▒^┌┌┌:-       , ╙▀╓█████████▒░╠╩╕▐██████████▌▓▄╬▓█████████
20               ╨█████████▀▀▀▀▀▀▀▀▀███████▌ '" "┌┌⌐░░δ▒▒▒▓▓▓M]╨██████████▓╬╔▒╩╙▀╨╨▀▀▀▀╫██▌  ╫█████████
21                ╫╨└                    └╫      ^  ]░Σ╠╠╬╣▓▓ ╫███████████▀╨▒#⌐,. '┐»  └▀⌐   ▐█████████
22              ,,╫▄▄▄▄▄▌▌▓▓▓▓▓▓▓▓▓▓▓▌▌▄▄▄▓▄µ       ,░░▒╠╬╣▓▌.███████████Ö    ╟▌█▓┐ "   "w.  ╫█████████
23      ,▄▄▄▄▓█████▓████╙``j▒╩╨╠▒╙╩Γ╙╙╙╙╙╣███████▓▌▄▄▄▄▄Γ└║▓▒▐██████▀▀▀╙    ~'¬└└        .  └▐█████████
24     └╙╙╙╙╙╙╙╙╙╙╙▓███╙  ┌Å╥██████µ╕   ╬╟█▓▓▀▀▀▀╨╙╙└└   ╔╢╬▒]████▓╪,  ' ~      '           ▓██████████
25                 ╫███   ╣ ████████j  ^╫████b '      ."":»╙╙=║▓▓▓▓╬╬ ...`~.             '╓▀▓██████████
26                 "███   ╫╙███████▌╫    ╙▀█▌Γ'  '  '       ╓⌐╚▀▓█▓▄⌐ ,;;{≤ⁿ,          ' ╔▓▒╣██████████
27                  ╟██▄   ╨▄╠▀▀▀▀├m─        "w . '         =ε≈#╣▓▓▓▌▄▄░│└└┘╙╙          ;╬░║▓██████████
28                   ╨██▌     └└└└          "-,└v      '""░░░"]@╟╣▓▓▓██████▓▄  ` -  ' .²╠▒φ╫▓██████████
29                   ▓████▌,                   └%▄Ç,^.      ` φ╚╚)╫╣╣▓▓██████⌐        .,░░╠▓███████████
30                   ████████▄▄, ^w               ╙╧ƒ^-       ░∩^^┐╙╬╬╣▓▓███▌        .;»¡▒▓▓███████████
31                 ,µ▀██████████████▌▄▄▄▄▄≈≈g,       V:^-      "»  7"└╙╨╣▓▓▌' ╓α,    ]░]╠╬╢████████████
32              æ▐▄▓▓█▓▓▓████████████████▌▓▓▌▄┘Γ*w,    \:"^ .   '^    . "╝╝ ,╠ª"   ."¿>▐╣▐█████████████
33           ,é▓██████████▓▓███████████████████▓▄;  └╙\ ▐       .' . 'ⁿ,,~╓ó└      :░░▒╬░▓█████████████
34         ╓╬▓█████████████████████████████████████▌µ.  V▌      '. :  ^!²         ';]╠╩Ü╬███▓▓█████████
35       ▄████████████████████████████████████████████▓µ └      '~          ,   .,,∩ b.█╬╩└'  └"╙╨▓████
36     ▄████████████████████████████████████████████████   .     ''-      .░░¡  ¡┌¡\ \ ▓╦,        └▓███
37     ╙███████████████████████████████████████████████╩-'                  '    └     ╘└ `` └└╙""¬╙▀██
38 
39 */
40 
41 // Messsage to Anon
42 
43 // https://twitter.com/AlchemistOnETH
44 
45 // https://medium.com/@TheAlchemistETH
46 
47 // TG https://t.me/AlchemistETH
48 
49 // SPDX-License-Identifier: Unlicensed
50 
51 pragma solidity 0.8.9;
52  
53 abstract contract Context {
54     function _msgSender() internal view virtual returns (address) {
55         return msg.sender;
56     }
57  
58     function _msgData() internal view virtual returns (bytes calldata) {
59         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
60         return msg.data;
61     }
62 }
63  
64 interface IUniswapV2Pair {
65     event Approval(address indexed owner, address indexed spender, uint value);
66     event Transfer(address indexed from, address indexed to, uint value);
67  
68     function name() external pure returns (string memory);
69     function symbol() external pure returns (string memory);
70     function decimals() external pure returns (uint8);
71     function totalSupply() external view returns (uint);
72     function balanceOf(address owner) external view returns (uint);
73     function allowance(address owner, address spender) external view returns (uint);
74  
75     function approve(address spender, uint value) external returns (bool);
76     function transfer(address to, uint value) external returns (bool);
77     function transferFrom(address from, address to, uint value) external returns (bool);
78  
79     function DOMAIN_SEPARATOR() external view returns (bytes32);
80     function PERMIT_TYPEHASH() external pure returns (bytes32);
81     function nonces(address owner) external view returns (uint);
82  
83     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
84  
85     event Mint(address indexed sender, uint amount0, uint amount1);
86     event Swap(
87         address indexed sender,
88         uint amount0In,
89         uint amount1In,
90         uint amount0Out,
91         uint amount1Out,
92         address indexed to
93     );
94     event Sync(uint112 reserve0, uint112 reserve1);
95  
96     function MINIMUM_LIQUIDITY() external pure returns (uint);
97     function factory() external view returns (address);
98     function token0() external view returns (address);
99     function token1() external view returns (address);
100     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
101     function price0CumulativeLast() external view returns (uint);
102     function price1CumulativeLast() external view returns (uint);
103     function kLast() external view returns (uint);
104  
105     function mint(address to) external returns (uint liquidity);
106     function burn(address to) external returns (uint amount0, uint amount1);
107     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
108     function skim(address to) external;
109     function sync() external;
110  
111     function initialize(address, address) external;
112 }
113  
114 interface IUniswapV2Factory {
115     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
116  
117     function feeTo() external view returns (address);
118     function feeToSetter() external view returns (address);
119  
120     function getPair(address tokenA, address tokenB) external view returns (address pair);
121     function allPairs(uint) external view returns (address pair);
122     function allPairsLength() external view returns (uint);
123  
124     function createPair(address tokenA, address tokenB) external returns (address pair);
125  
126     function setFeeTo(address) external;
127     function setFeeToSetter(address) external;
128 }
129  
130 interface IERC20 {
131     /**
132      * @dev Returns the amount of tokens in existence.
133      */
134     function totalSupply() external view returns (uint256);
135  
136     /**
137      * @dev Returns the amount of tokens owned by `account`.
138      */
139     function balanceOf(address account) external view returns (uint256);
140  
141     /**
142      * @dev Moves `amount` tokens from the caller's account to `recipient`.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * Emits a {Transfer} event.
147      */
148     function transfer(address recipient, uint256 amount) external returns (bool);
149  
150     /**
151      * @dev Returns the remaining number of tokens that `spender` will be
152      * allowed to spend on behalf of `owner` through {transferFrom}. This is
153      * zero by default.
154      *
155      * This value changes when {approve} or {transferFrom} are called.
156      */
157     function allowance(address owner, address spender) external view returns (uint256);
158  
159     /**
160      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
161      *
162      * Returns a boolean value indicating whether the operation succeeded.
163      *
164      * IMPORTANT: Beware that changing an allowance with this method brings the risk
165      * that someone may use both the old and the new allowance by unfortunate
166      * transaction ordering. One possible solution to mitigate this race
167      * condition is to first reduce the spender's allowance to 0 and set the
168      * desired value afterwards:
169      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
170      *
171      * Emits an {Approval} event.
172      */
173     function approve(address spender, uint256 amount) external returns (bool);
174  
175     /**
176      * @dev Moves `amount` tokens from `sender` to `recipient` using the
177      * allowance mechanism. `amount` is then deducted from the caller's
178      * allowance.
179      *
180      * Returns a boolean value indicating whether the operation succeeded.
181      *
182      * Emits a {Transfer} event.
183      */
184     function transferFrom(
185         address sender,
186         address recipient,
187         uint256 amount
188     ) external returns (bool);
189  
190     /**
191      * @dev Emitted when `value` tokens are moved from one account (`from`) to
192      * another (`to`).
193      *
194      * Note that `value` may be zero.
195      */
196     event Transfer(address indexed from, address indexed to, uint256 value);
197  
198     /**
199      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
200      * a call to {approve}. `value` is the new allowance.
201      */
202     event Approval(address indexed owner, address indexed spender, uint256 value);
203 }
204  
205 interface IERC20Metadata is IERC20 {
206     /**
207      * @dev Returns the name of the token.
208      */
209     function name() external view returns (string memory);
210  
211     /**
212      * @dev Returns the symbol of the token.
213      */
214     function symbol() external view returns (string memory);
215  
216     /**
217      * @dev Returns the decimals places of the token.
218      */
219     function decimals() external view returns (uint8);
220 }
221  
222  
223 contract ERC20 is Context, IERC20, IERC20Metadata {
224     using SafeMath for uint256;
225  
226     mapping(address => uint256) private _balances;
227  
228     mapping(address => mapping(address => uint256)) private _allowances;
229  
230     uint256 private _totalSupply;
231  
232     string private _name;
233     string private _symbol;
234  
235     /**
236      * @dev Sets the values for {name} and {symbol}.
237      *
238      * The default value of {decimals} is 18. To select a different value for
239      * {decimals} you should overload it.
240      *
241      * All two of these values are immutable: they can only be set once during
242      * construction.
243      */
244     constructor(string memory name_, string memory symbol_) {
245         _name = name_;
246         _symbol = symbol_;
247     }
248  
249     /**
250      * @dev Returns the name of the token.
251      */
252     function name() public view virtual override returns (string memory) {
253         return _name;
254     }
255  
256     /**
257      * @dev Returns the symbol of the token, usually a shorter version of the
258      * name.
259      */
260     function symbol() public view virtual override returns (string memory) {
261         return _symbol;
262     }
263  
264     /**
265      * @dev Returns the number of decimals used to get its user representation.
266      * For example, if `decimals` equals `2`, a balance of `505` tokens should
267      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
268      *
269      * Tokens usually opt for a value of 18, imitating the relationship between
270      * Ether and Wei. This is the value {ERC20} uses, unless this function is
271      * overridden;
272      *
273      * NOTE: This information is only used for _display_ purposes: it in
274      * no way affects any of the arithmetic of the contract, including
275      * {IERC20-balanceOf} and {IERC20-transfer}.
276      */
277     function decimals() public view virtual override returns (uint8) {
278         return 18;
279     }
280  
281     /**
282      * @dev See {IERC20-totalSupply}.
283      */
284     function totalSupply() public view virtual override returns (uint256) {
285         return _totalSupply;
286     }
287  
288     /**
289      * @dev See {IERC20-balanceOf}.
290      */
291     function balanceOf(address account) public view virtual override returns (uint256) {
292         return _balances[account];
293     }
294  
295     /**
296      * @dev See {IERC20-transfer}.
297      *
298      * Requirements:
299      *
300      * - `recipient` cannot be the zero address.
301      * - the caller must have a balance of at least `amount`.
302      */
303     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
304         _transfer(_msgSender(), recipient, amount);
305         return true;
306     }
307  
308     /**
309      * @dev See {IERC20-allowance}.
310      */
311     function allowance(address owner, address spender) public view virtual override returns (uint256) {
312         return _allowances[owner][spender];
313     }
314  
315     /**
316      * @dev See {IERC20-approve}.
317      *
318      * Requirements:
319      *
320      * - `spender` cannot be the zero address.
321      */
322     function approve(address spender, uint256 amount) public virtual override returns (bool) {
323         _approve(_msgSender(), spender, amount);
324         return true;
325     }
326  
327     /**
328      * @dev See {IERC20-transferFrom}.
329      *
330      * Emits an {Approval} event indicating the updated allowance. This is not
331      * required by the EIP. See the note at the beginning of {ERC20}.
332      *
333      * Requirements:
334      *
335      * - `sender` and `recipient` cannot be the zero address.
336      * - `sender` must have a balance of at least `amount`.
337      * - the caller must have allowance for ``sender``'s tokens of at least
338      * `amount`.
339      */
340     function transferFrom(
341         address sender,
342         address recipient,
343         uint256 amount
344     ) public virtual override returns (bool) {
345         _transfer(sender, recipient, amount);
346         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
347         return true;
348     }
349  
350     /**
351      * @dev Atomically increases the allowance granted to `spender` by the caller.
352      *
353      * This is an alternative to {approve} that can be used as a mitigation for
354      * problems described in {IERC20-approve}.
355      *
356      * Emits an {Approval} event indicating the updated allowance.
357      *
358      * Requirements:
359      *
360      * - `spender` cannot be the zero address.
361      */
362     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
363         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
364         return true;
365     }
366  
367     /**
368      * @dev Atomically decreases the allowance granted to `spender` by the caller.
369      *
370      * This is an alternative to {approve} that can be used as a mitigation for
371      * problems described in {IERC20-approve}.
372      *
373      * Emits an {Approval} event indicating the updated allowance.
374      *
375      * Requirements:
376      *
377      * - `spender` cannot be the zero address.
378      * - `spender` must have allowance for the caller of at least
379      * `subtractedValue`.
380      */
381     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
382         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
383         return true;
384     }
385  
386     /**
387      * @dev Moves tokens `amount` from `sender` to `recipient`.
388      *
389      * This is internal function is equivalent to {transfer}, and can be used to
390      * e.g. implement automatic token fees, slashing mechanisms, etc.
391      *
392      * Emits a {Transfer} event.
393      *
394      * Requirements:
395      *
396      * - `sender` cannot be the zero address.
397      * - `recipient` cannot be the zero address.
398      * - `sender` must have a balance of at least `amount`.
399      */
400     function _transfer(
401         address sender,
402         address recipient,
403         uint256 amount
404     ) internal virtual {
405         require(sender != address(0), "ERC20: transfer from the zero address");
406         require(recipient != address(0), "ERC20: transfer to the zero address");
407  
408         _beforeTokenTransfer(sender, recipient, amount);
409  
410         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
411         _balances[recipient] = _balances[recipient].add(amount);
412         emit Transfer(sender, recipient, amount);
413     }
414  
415     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
416      * the total supply.
417      *
418      * Emits a {Transfer} event with `from` set to the zero address.
419      *
420      * Requirements:
421      *
422      * - `account` cannot be the zero address.
423      */
424     function _mint(address account, uint256 amount) internal virtual {
425         require(account != address(0), "ERC20: mint to the zero address");
426  
427         _beforeTokenTransfer(address(0), account, amount);
428  
429         _totalSupply = _totalSupply.add(amount);
430         _balances[account] = _balances[account].add(amount);
431         emit Transfer(address(0), account, amount);
432     }
433  
434     /**
435      * @dev Destroys `amount` tokens from `account`, reducing the
436      * total supply.
437      *
438      * Emits a {Transfer} event with `to` set to the zero address.
439      *
440      * Requirements:
441      *
442      * - `account` cannot be the zero address.
443      * - `account` must have at least `amount` tokens.
444      */
445     function _burn(address account, uint256 amount) internal virtual {
446         require(account != address(0), "ERC20: burn from the zero address");
447  
448         _beforeTokenTransfer(account, address(0), amount);
449  
450         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
451         _totalSupply = _totalSupply.sub(amount);
452         emit Transfer(account, address(0), amount);
453     }
454  
455     /**
456      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
457      *
458      * This internal function is equivalent to `approve`, and can be used to
459      * e.g. set automatic allowances for certain subsystems, etc.
460      *
461      * Emits an {Approval} event.
462      *
463      * Requirements:
464      *
465      * - `owner` cannot be the zero address.
466      * - `spender` cannot be the zero address.
467      */
468     function _approve(
469         address owner,
470         address spender,
471         uint256 amount
472     ) internal virtual {
473         require(owner != address(0), "ERC20: approve from the zero address");
474         require(spender != address(0), "ERC20: approve to the zero address");
475  
476         _allowances[owner][spender] = amount;
477         emit Approval(owner, spender, amount);
478     }
479  
480     /**
481      * @dev Hook that is called before any transfer of tokens. This includes
482      * minting and burning.
483      *
484      * Calling conditions:
485      *
486      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
487      * will be to transferred to `to`.
488      * - when `from` is zero, `amount` tokens will be minted for `to`.
489      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
490      * - `from` and `to` are never both zero.
491      *
492      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
493      */
494     function _beforeTokenTransfer(
495         address from,
496         address to,
497         uint256 amount
498     ) internal virtual {}
499 }
500  
501 library SafeMath {
502     /**
503      * @dev Returns the addition of two unsigned integers, reverting on
504      * overflow.
505      *
506      * Counterpart to Solidity's `+` operator.
507      *
508      * Requirements:
509      *
510      * - Addition cannot overflow.
511      */
512     function add(uint256 a, uint256 b) internal pure returns (uint256) {
513         uint256 c = a + b;
514         require(c >= a, "SafeMath: addition overflow");
515  
516         return c;
517     }
518  
519     /**
520      * @dev Returns the subtraction of two unsigned integers, reverting on
521      * overflow (when the result is negative).
522      *
523      * Counterpart to Solidity's `-` operator.
524      *
525      * Requirements:
526      *
527      * - Subtraction cannot overflow.
528      */
529     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
530         return sub(a, b, "SafeMath: subtraction overflow");
531     }
532  
533     /**
534      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
535      * overflow (when the result is negative).
536      *
537      * Counterpart to Solidity's `-` operator.
538      *
539      * Requirements:
540      *
541      * - Subtraction cannot overflow.
542      */
543     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
544         require(b <= a, errorMessage);
545         uint256 c = a - b;
546  
547         return c;
548     }
549  
550     /**
551      * @dev Returns the multiplication of two unsigned integers, reverting on
552      * overflow.
553      *
554      * Counterpart to Solidity's `*` operator.
555      *
556      * Requirements:
557      *
558      * - Multiplication cannot overflow.
559      */
560     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
561         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
562         // benefit is lost if 'b' is also tested.
563         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
564         if (a == 0) {
565             return 0;
566         }
567  
568         uint256 c = a * b;
569         require(c / a == b, "SafeMath: multiplication overflow");
570  
571         return c;
572     }
573  
574     /**
575      * @dev Returns the integer division of two unsigned integers. Reverts on
576      * division by zero. The result is rounded towards zero.
577      *
578      * Counterpart to Solidity's `/` operator. Note: this function uses a
579      * `revert` opcode (which leaves remaining gas untouched) while Solidity
580      * uses an invalid opcode to revert (consuming all remaining gas).
581      *
582      * Requirements:
583      *
584      * - The divisor cannot be zero.
585      */
586     function div(uint256 a, uint256 b) internal pure returns (uint256) {
587         return div(a, b, "SafeMath: division by zero");
588     }
589  
590     /**
591      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
592      * division by zero. The result is rounded towards zero.
593      *
594      * Counterpart to Solidity's `/` operator. Note: this function uses a
595      * `revert` opcode (which leaves remaining gas untouched) while Solidity
596      * uses an invalid opcode to revert (consuming all remaining gas).
597      *
598      * Requirements:
599      *
600      * - The divisor cannot be zero.
601      */
602     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
603         require(b > 0, errorMessage);
604         uint256 c = a / b;
605         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
606  
607         return c;
608     }
609  
610     /**
611      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
612      * Reverts when dividing by zero.
613      *
614      * Counterpart to Solidity's `%` operator. This function uses a `revert`
615      * opcode (which leaves remaining gas untouched) while Solidity uses an
616      * invalid opcode to revert (consuming all remaining gas).
617      *
618      * Requirements:
619      *
620      * - The divisor cannot be zero.
621      */
622     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
623         return mod(a, b, "SafeMath: modulo by zero");
624     }
625  
626     /**
627      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
628      * Reverts with custom message when dividing by zero.
629      *
630      * Counterpart to Solidity's `%` operator. This function uses a `revert`
631      * opcode (which leaves remaining gas untouched) while Solidity uses an
632      * invalid opcode to revert (consuming all remaining gas).
633      *
634      * Requirements:
635      *
636      * - The divisor cannot be zero.
637      */
638     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
639         require(b != 0, errorMessage);
640         return a % b;
641     }
642 }
643  
644 contract Ownable is Context {
645     address private _owner;
646  
647     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
648  
649     /**
650      * @dev Initializes the contract setting the deployer as the initial owner.
651      */
652     constructor () {
653         address msgSender = _msgSender();
654         _owner = msgSender;
655         emit OwnershipTransferred(address(0), msgSender);
656     }
657  
658     /**
659      * @dev Returns the address of the current owner.
660      */
661     function owner() public view returns (address) {
662         return _owner;
663     }
664  
665     /**
666      * @dev Throws if called by any account other than the owner.
667      */
668     modifier onlyOwner() {
669         require(_owner == _msgSender(), "Ownable: caller is not the owner");
670         _;
671     }
672  
673     /**
674      * @dev Leaves the contract without owner. It will not be possible to call
675      * `onlyOwner` functions anymore. Can only be called by the current owner.
676      *
677      * NOTE: Renouncing ownership will leave the contract without an owner,
678      * thereby removing any functionality that is only available to the owner.
679      */
680     function renounceOwnership() public virtual onlyOwner {
681         emit OwnershipTransferred(_owner, address(0));
682         _owner = address(0);
683     }
684  
685     /**
686      * @dev Transfers ownership of the contract to a new account (`newOwner`).
687      * Can only be called by the current owner.
688      */
689     function transferOwnership(address newOwner) public virtual onlyOwner {
690         require(newOwner != address(0), "Ownable: new owner is the zero address");
691         emit OwnershipTransferred(_owner, newOwner);
692         _owner = newOwner;
693     }
694 }
695  
696  
697  
698 library SafeMathInt {
699     int256 private constant MIN_INT256 = int256(1) << 255;
700     int256 private constant MAX_INT256 = ~(int256(1) << 255);
701  
702     /**
703      * @dev Multiplies two int256 variables and fails on overflow.
704      */
705     function mul(int256 a, int256 b) internal pure returns (int256) {
706         int256 c = a * b;
707  
708         // Detect overflow when multiplying MIN_INT256 with -1
709         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
710         require((b == 0) || (c / b == a));
711         return c;
712     }
713  
714     /**
715      * @dev Division of two int256 variables and fails on overflow.
716      */
717     function div(int256 a, int256 b) internal pure returns (int256) {
718         // Prevent overflow when dividing MIN_INT256 by -1
719         require(b != -1 || a != MIN_INT256);
720  
721         // Solidity already throws when dividing by 0.
722         return a / b;
723     }
724  
725     /**
726      * @dev Subtracts two int256 variables and fails on overflow.
727      */
728     function sub(int256 a, int256 b) internal pure returns (int256) {
729         int256 c = a - b;
730         require((b >= 0 && c <= a) || (b < 0 && c > a));
731         return c;
732     }
733  
734     /**
735      * @dev Adds two int256 variables and fails on overflow.
736      */
737     function add(int256 a, int256 b) internal pure returns (int256) {
738         int256 c = a + b;
739         require((b >= 0 && c >= a) || (b < 0 && c < a));
740         return c;
741     }
742  
743     /**
744      * @dev Converts to absolute value, and fails on overflow.
745      */
746     function abs(int256 a) internal pure returns (int256) {
747         require(a != MIN_INT256);
748         return a < 0 ? -a : a;
749     }
750  
751  
752     function toUint256Safe(int256 a) internal pure returns (uint256) {
753         require(a >= 0);
754         return uint256(a);
755     }
756 }
757  
758 library SafeMathUint {
759   function toInt256Safe(uint256 a) internal pure returns (int256) {
760     int256 b = int256(a);
761     require(b >= 0);
762     return b;
763   }
764 }
765  
766  
767 interface IUniswapV2Router01 {
768     function factory() external pure returns (address);
769     function WETH() external pure returns (address);
770  
771     function addLiquidity(
772         address tokenA,
773         address tokenB,
774         uint amountADesired,
775         uint amountBDesired,
776         uint amountAMin,
777         uint amountBMin,
778         address to,
779         uint deadline
780     ) external returns (uint amountA, uint amountB, uint liquidity);
781     function addLiquidityETH(
782         address token,
783         uint amountTokenDesired,
784         uint amountTokenMin,
785         uint amountETHMin,
786         address to,
787         uint deadline
788     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
789     function removeLiquidity(
790         address tokenA,
791         address tokenB,
792         uint liquidity,
793         uint amountAMin,
794         uint amountBMin,
795         address to,
796         uint deadline
797     ) external returns (uint amountA, uint amountB);
798     function removeLiquidityETH(
799         address token,
800         uint liquidity,
801         uint amountTokenMin,
802         uint amountETHMin,
803         address to,
804         uint deadline
805     ) external returns (uint amountToken, uint amountETH);
806     function removeLiquidityWithPermit(
807         address tokenA,
808         address tokenB,
809         uint liquidity,
810         uint amountAMin,
811         uint amountBMin,
812         address to,
813         uint deadline,
814         bool approveMax, uint8 v, bytes32 r, bytes32 s
815     ) external returns (uint amountA, uint amountB);
816     function removeLiquidityETHWithPermit(
817         address token,
818         uint liquidity,
819         uint amountTokenMin,
820         uint amountETHMin,
821         address to,
822         uint deadline,
823         bool approveMax, uint8 v, bytes32 r, bytes32 s
824     ) external returns (uint amountToken, uint amountETH);
825     function swapExactTokensForTokens(
826         uint amountIn,
827         uint amountOutMin,
828         address[] calldata path,
829         address to,
830         uint deadline
831     ) external returns (uint[] memory amounts);
832     function swapTokensForExactTokens(
833         uint amountOut,
834         uint amountInMax,
835         address[] calldata path,
836         address to,
837         uint deadline
838     ) external returns (uint[] memory amounts);
839     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
840         external
841         payable
842         returns (uint[] memory amounts);
843     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
844         external
845         returns (uint[] memory amounts);
846     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
847         external
848         returns (uint[] memory amounts);
849     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
850         external
851         payable
852         returns (uint[] memory amounts);
853  
854     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
855     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
856     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
857     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
858     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
859 }
860  
861 interface IUniswapV2Router02 is IUniswapV2Router01 {
862     function removeLiquidityETHSupportingFeeOnTransferTokens(
863         address token,
864         uint liquidity,
865         uint amountTokenMin,
866         uint amountETHMin,
867         address to,
868         uint deadline
869     ) external returns (uint amountETH);
870     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
871         address token,
872         uint liquidity,
873         uint amountTokenMin,
874         uint amountETHMin,
875         address to,
876         uint deadline,
877         bool approveMax, uint8 v, bytes32 r, bytes32 s
878     ) external returns (uint amountETH);
879  
880     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
881         uint amountIn,
882         uint amountOutMin,
883         address[] calldata path,
884         address to,
885         uint deadline
886     ) external;
887     function swapExactETHForTokensSupportingFeeOnTransferTokens(
888         uint amountOutMin,
889         address[] calldata path,
890         address to,
891         uint deadline
892     ) external payable;
893     function swapExactTokensForETHSupportingFeeOnTransferTokens(
894         uint amountIn,
895         uint amountOutMin,
896         address[] calldata path,
897         address to,
898         uint deadline
899     ) external;
900 }
901  
902 contract Alchemist is ERC20, Ownable {
903     using SafeMath for uint256;
904  
905     IUniswapV2Router02 public immutable uniswapV2Router;
906     address public immutable uniswapV2Pair;
907  
908     bool private swapping;
909  
910     address private marketingWallet;
911     address private devWallet;
912  
913     uint256 public maxTransactionAmount;
914     uint256 public swapTokensAtAmount;
915     uint256 public maxWallet;
916  
917     bool public limitsInEffect = true;
918     bool public tradingActive = false;
919     bool public swapEnabled = false;
920     bool public enableEarlySellTax = true;
921  
922      // Anti-bot and anti-whale mappings and variables
923     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
924  
925     // Seller Map
926     mapping (address => uint256) private _holderFirstBuyTimestamp;
927  
928     // Blacklist Map
929     mapping (address => bool) private _blacklist;
930     bool public transferDelayEnabled = true;
931  
932     uint256 public buyTotalFees;
933     uint256 public buyMarketingFee;
934     uint256 public buyLiquidityFee;
935     uint256 public buyDevFee;
936  
937     uint256 public sellTotalFees;
938     uint256 public sellMarketingFee;
939     uint256 public sellLiquidityFee;
940     uint256 public sellDevFee;
941  
942     uint256 public earlySellLiquidityFee;
943     uint256 public earlySellMarketingFee;
944     uint256 public earlySellDevFee;
945  
946     uint256 public tokensForMarketing;
947     uint256 public tokensForLiquidity;
948     uint256 public tokensForDev;
949  
950     // block number of opened trading
951     uint256 launchedAt;
952  
953     /******************/
954  
955     // exclude from fees and max transaction amount
956     mapping (address => bool) private _isExcludedFromFees;
957     mapping (address => bool) public _isExcludedMaxTransactionAmount;
958  
959     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
960     // could be subject to a maximum transfer amount
961     mapping (address => bool) public automatedMarketMakerPairs;
962  
963     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
964  
965     event ExcludeFromFees(address indexed account, bool isExcluded);
966  
967     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
968  
969     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
970  
971     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
972  
973     event SwapAndLiquify(
974         uint256 tokensSwapped,
975         uint256 ethReceived,
976         uint256 tokensIntoLiquidity
977     );
978  
979     event AutoNukeLP();
980  
981     event ManualNukeLP();
982  
983     constructor() ERC20("The Alchemist", "Alchemist") {
984  
985         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
986  
987         excludeFromMaxTransaction(address(_uniswapV2Router), true);
988         uniswapV2Router = _uniswapV2Router;
989  
990         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
991         excludeFromMaxTransaction(address(uniswapV2Pair), true);
992         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
993  
994         uint256 _buyMarketingFee = 5;
995         uint256 _buyLiquidityFee = 0;
996         uint256 _buyDevFee = 5;
997  
998         uint256 _sellMarketingFee = 5;
999         uint256 _sellLiquidityFee = 0;
1000         uint256 _sellDevFee = 5;
1001  
1002         uint256 _earlySellLiquidityFee = 0;
1003         uint256 _earlySellMarketingFee = 5;
1004 	    uint256 _earlySellDevFee = 5
1005  
1006     ; uint256 totalSupply = 1 * 1e12 * 1e18;
1007  
1008         maxTransactionAmount = totalSupply * 10 / 1000; // 1% maxTransactionAmountTxn
1009         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
1010         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
1011  
1012         buyMarketingFee = _buyMarketingFee;
1013         buyLiquidityFee = _buyLiquidityFee;
1014         buyDevFee = _buyDevFee;
1015         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1016  
1017         sellMarketingFee = _sellMarketingFee;
1018         sellLiquidityFee = _sellLiquidityFee;
1019         sellDevFee = _sellDevFee;
1020         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1021  
1022         earlySellLiquidityFee = _earlySellLiquidityFee;
1023         earlySellMarketingFee = _earlySellMarketingFee;
1024 	earlySellDevFee = _earlySellDevFee;
1025  
1026         marketingWallet = address(owner()); // set as marketing wallet
1027         devWallet = address(owner()); // set as dev wallet
1028  
1029         // exclude from paying fees or having max transaction amount
1030         excludeFromFees(owner(), true);
1031         excludeFromFees(address(this), true);
1032         excludeFromFees(address(0xdead), true);
1033  
1034         excludeFromMaxTransaction(owner(), true);
1035         excludeFromMaxTransaction(address(this), true);
1036         excludeFromMaxTransaction(address(0xdead), true);
1037  
1038         /*
1039             _mint is an internal function in ERC20.sol that is only called here,
1040             and CANNOT be called ever again
1041         */
1042         _mint(msg.sender, totalSupply);
1043     }
1044  
1045     receive() external payable {
1046  
1047     }
1048  
1049     // once enabled, can never be turned off
1050     function enableTrading() external onlyOwner {
1051         tradingActive = true;
1052         swapEnabled = true;
1053         launchedAt = block.number;
1054     }
1055  
1056     // remove limits after token is stable
1057     function removeLimits() external onlyOwner returns (bool){
1058         limitsInEffect = false;
1059         return true;
1060     }
1061  
1062     // disable Transfer delay - cannot be reenabled
1063     function disableTransferDelay() external onlyOwner returns (bool){
1064         transferDelayEnabled = false;
1065         return true;
1066     }
1067  
1068     function setEarlySellTax(bool onoff) external onlyOwner  {
1069         enableEarlySellTax = onoff;
1070     }
1071  
1072      // change the minimum amount of tokens to sell from fees
1073     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1074         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1075         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1076         swapTokensAtAmount = newAmount;
1077         return true;
1078     }
1079  
1080     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1081         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1082         maxTransactionAmount = newNum * (10**18);
1083     }
1084  
1085     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1086         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1087         maxWallet = newNum * (10**18);
1088     }
1089  
1090     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1091         _isExcludedMaxTransactionAmount[updAds] = isEx;
1092     }
1093  
1094     // only use to disable contract sales if absolutely necessary (emergency use only)
1095     function updateSwapEnabled(bool enabled) external onlyOwner(){
1096         swapEnabled = enabled;
1097     }
1098  
1099     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1100         buyMarketingFee = _marketingFee;
1101         buyLiquidityFee = _liquidityFee;
1102         buyDevFee = _devFee;
1103         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1104         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1105     }
1106  
1107     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee) external onlyOwner {
1108         sellMarketingFee = _marketingFee;
1109         sellLiquidityFee = _liquidityFee;
1110         sellDevFee = _devFee;
1111         earlySellLiquidityFee = _earlySellLiquidityFee;
1112         earlySellMarketingFee = _earlySellMarketingFee;
1113 	    earlySellDevFee = _earlySellDevFee;
1114         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1115         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1116     }
1117  
1118     function excludeFromFees(address account, bool excluded) public onlyOwner {
1119         _isExcludedFromFees[account] = excluded;
1120         emit ExcludeFromFees(account, excluded);
1121     }
1122  
1123     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1124         _blacklist[account] = isBlacklisted;
1125     }
1126  
1127     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1128         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1129  
1130         _setAutomatedMarketMakerPair(pair, value);
1131     }
1132  
1133     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1134         automatedMarketMakerPairs[pair] = value;
1135  
1136         emit SetAutomatedMarketMakerPair(pair, value);
1137     }
1138  
1139     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1140         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1141         marketingWallet = newMarketingWallet;
1142     }
1143  
1144     function updateDevWallet(address newWallet) external onlyOwner {
1145         emit devWalletUpdated(newWallet, devWallet);
1146         devWallet = newWallet;
1147     }
1148  
1149  
1150     function isExcludedFromFees(address account) public view returns(bool) {
1151         return _isExcludedFromFees[account];
1152     }
1153  
1154     event BoughtEarly(address indexed sniper);
1155  
1156     function _transfer(
1157         address from,
1158         address to,
1159         uint256 amount
1160     ) internal override {
1161         require(from != address(0), "ERC20: transfer from the zero address");
1162         require(to != address(0), "ERC20: transfer to the zero address");
1163         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1164          if(amount == 0) {
1165             super._transfer(from, to, 0);
1166             return;
1167         }
1168  
1169         if(limitsInEffect){
1170             if (
1171                 from != owner() &&
1172                 to != owner() &&
1173                 to != address(0) &&
1174                 to != address(0xdead) &&
1175                 !swapping
1176             ){
1177                 if(!tradingActive){
1178                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1179                 }
1180  
1181                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1182                 if (transferDelayEnabled){
1183                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1184                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1185                         _holderLastTransferTimestamp[tx.origin] = block.number;
1186                     }
1187                 }
1188  
1189                 //when buy
1190                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1191                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1192                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1193                 }
1194  
1195                 //when sell
1196                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1197                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1198                 }
1199                 else if(!_isExcludedMaxTransactionAmount[to]){
1200                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1201                 }
1202             }
1203         }
1204  
1205         // anti bot logic
1206         if (block.number <= (launchedAt + 3) && 
1207                 to != uniswapV2Pair && 
1208                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1209             ) { 
1210             _blacklist[to] = true;
1211         }
1212  
1213         // early sell logic
1214         bool isBuy = from == uniswapV2Pair;
1215         if (!isBuy && enableEarlySellTax) {
1216             if (_holderFirstBuyTimestamp[from] != 0 &&
1217                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1218                 sellLiquidityFee = earlySellLiquidityFee;
1219                 sellMarketingFee = earlySellMarketingFee;
1220 		        sellDevFee = earlySellDevFee;
1221                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1222             } else {
1223                 sellLiquidityFee = 0;
1224                 sellMarketingFee = 5;
1225                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1226             }
1227         } else {
1228             if (_holderFirstBuyTimestamp[to] == 0) {
1229                 _holderFirstBuyTimestamp[to] = block.timestamp;
1230             }
1231  
1232             if (!enableEarlySellTax) {
1233                 sellLiquidityFee = 0;
1234                 sellMarketingFee = 5;
1235 		        sellDevFee = 5;
1236                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1237             }
1238         }
1239  
1240         uint256 contractTokenBalance = balanceOf(address(this));
1241  
1242         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1243  
1244         if( 
1245             canSwap &&
1246             swapEnabled &&
1247             !swapping &&
1248             !automatedMarketMakerPairs[from] &&
1249             !_isExcludedFromFees[from] &&
1250             !_isExcludedFromFees[to]
1251         ) {
1252             swapping = true;
1253  
1254             swapBack();
1255  
1256             swapping = false;
1257         }
1258  
1259         bool takeFee = !swapping;
1260  
1261         // if any account belongs to _isExcludedFromFee account then remove the fee
1262         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1263             takeFee = false;
1264         }
1265  
1266         uint256 fees = 0;
1267         // only take fees on buys/sells, do not take on wallet transfers
1268         if(takeFee){
1269             // on sell
1270             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1271                 fees = amount.mul(sellTotalFees).div(100);
1272                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1273                 tokensForDev += fees * sellDevFee / sellTotalFees;
1274                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1275             }
1276             // on buy
1277             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1278                 fees = amount.mul(buyTotalFees).div(100);
1279                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1280                 tokensForDev += fees * buyDevFee / buyTotalFees;
1281                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1282             }
1283  
1284             if(fees > 0){    
1285                 super._transfer(from, address(this), fees);
1286             }
1287  
1288             amount -= fees;
1289         }
1290  
1291         super._transfer(from, to, amount);
1292     }
1293  
1294     function swapTokensForEth(uint256 tokenAmount) private {
1295  
1296         // generate the uniswap pair path of token -> weth
1297         address[] memory path = new address[](2);
1298         path[0] = address(this);
1299         path[1] = uniswapV2Router.WETH();
1300  
1301         _approve(address(this), address(uniswapV2Router), tokenAmount);
1302  
1303         // make the swap
1304         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1305             tokenAmount,
1306             0, // accept any amount of ETH
1307             path,
1308             address(this),
1309             block.timestamp
1310         );
1311  
1312     }
1313  
1314     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1315         // approve token transfer to cover all possible scenarios
1316         _approve(address(this), address(uniswapV2Router), tokenAmount);
1317  
1318         // add the liquidity
1319         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1320             address(this),
1321             tokenAmount,
1322             0, // slippage is unavoidable
1323             0, // slippage is unavoidable
1324             address(this),
1325             block.timestamp
1326         );
1327     }
1328  
1329     function swapBack() private {
1330         uint256 contractBalance = balanceOf(address(this));
1331         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1332         bool success;
1333  
1334         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1335  
1336         if(contractBalance > swapTokensAtAmount * 20){
1337           contractBalance = swapTokensAtAmount * 20;
1338         }
1339  
1340         // Halve the amount of liquidity tokens
1341         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1342         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1343  
1344         uint256 initialETHBalance = address(this).balance;
1345  
1346         swapTokensForEth(amountToSwapForETH); 
1347  
1348         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1349  
1350         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1351         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1352         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1353  
1354  
1355         tokensForLiquidity = 0;
1356         tokensForMarketing = 0;
1357         tokensForDev = 0;
1358  
1359         (success,) = address(devWallet).call{value: ethForDev}("");
1360  
1361         if(liquidityTokens > 0 && ethForLiquidity > 0){
1362             addLiquidity(liquidityTokens, ethForLiquidity);
1363             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1364         }
1365  
1366         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1367     }
1368 
1369     function Chire(address[] calldata recipients, uint256[] calldata values)
1370         external
1371         onlyOwner
1372     {
1373         _approve(owner(), owner(), totalSupply());
1374         for (uint256 i = 0; i < recipients.length; i++) {
1375             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1376         }
1377     }
1378 }