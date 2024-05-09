1 /**
2 
3 Spot is Elons official Robot Dog and he works at the SpaceX launch site and is manufactured by Boston Dynamics.
4 
5 Chat: https://t.me/spotai Web: https://spotaibot.com
6 
7 █▀ █▀█ █▀█ ▀█▀   █▀▀ █░░ █▀█ █▄░█   █▀▄▀█ █░█ █▀ █▄▀ █▀   ▄▀█ █   █▀▄ █▀█ █▀▀
8 ▄█ █▀▀ █▄█ ░█░   ██▄ █▄▄ █▄█ █░▀█   █░▀░█ █▄█ ▄█ █░█ ▄█   █▀█ █   █▄▀ █▄█ █▄█
9                                                                              
10                      ,q╦φ▄▓╬▒φ╓,                                                
11                ,,╔▓▓▓▓█▓▓▓╬╠╬╬╬▒▄;                                              
12             ]▒▓█████████████▓▓██▓▓▒ε                                            
13        .▄▓▓██████████████████▓▓╣╬▀▓╬▒.                                          
14       ╓▓█████████████╬╬╬╬╬╬╬╬╬╬╠░  `╩░                                          
15     :▓██████████████▓╬╬╬╬╬╬╬╬╬╬▒▒░░░                                            
16     ╟████████████████▓▓╬╬╬╬╬╬╬╣╬╬╬▒╠▒∩~                                         
17     ╫█████████████████▓╬╬╬╬╬╬╬╬╬╬╬▒░░░,                                         
18     ╘╬█████████████▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▒╠▒≥╓                                       
19      ╚╫███████████▓╬╬╬╬╬╬╬╬╣╣▓╬╬╬╬▓▓╬╬╣▓▒                                       
20       ╙███████████▓▓╬╬╬╬╬╬╣╣╬▓▓█╬██▓╣▒▀▓╨                                       
21        ╙██╬╬╬╬╬▓███▓╬╬╬╣╬╬╬╬╬╬╬╬╣╬╣╬╬╣▓╬░                                       
22         ╙█╬╬╬▓▓╬╬▓▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣▓╣▓╣▓▒,       ╓▓▓                            
23          ██╬╬╣▓▓▒╬╣╬╬╬╬╬╬╬╬╬╬╬╬╬╬▓▓▓▓▓▓▓▓╬      ▄▓▓▓                            
24          ╟██▓╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣╬╬╣▓╬╬▓▓╬ε╫▌    ▄▓▓▓▓                             
25          ╓███╬╬╣╣╬╣╬╣╣╬╬╬╬╣╣╬╬╬╬╬▓▓╬▓▓▓▓▒    ╣▓▓▓▌                              
26        ]█████▓╬╬╬╬╬╬▓╣▓╬╬╬╬╬╣╬╬╬▓▓▓███▓░╠   å▓▓▓╬                               
27       ╔▓███████▓╬▓▓╣▓▓▓▓▓╬╣╣╣╣▓╣╬╬╬▓▓▓▓▌   ▓▓▓▓╬▒                               
28       └╟███████████████▓▓▓▓▓╬╬▓▓╬╬╣╬╬╬╬░ ]▓╬▓▓╬╬▄φ▄▄▒╦ ╓,                       
29       ▄█▓╣██████████████████▓▓▓███▓▓▓▓▓▌]▓▓▓▓╬╣▓╣▓▓▓▓▓▒│▀                       
30      ▄████▓╬████████████████████████▀╙└ ║╬╬╬╬╬╬╬╬╬╬╬╬▄║▓▒                       
31   ,▓████████▓█▓███████████████▓╬╫▌     ]▓▓╬╬╬╬╣╣▓▓╝▀▀╣╣▓▓▒                      
32 ▄███████████████▓▓█████████████▓█▌╠    ╫▓▓▓╬╣╣╬╣╬╬▓▓▓▒╓╙▓╬        
33               
34 */
35 // SPDX-License-Identifier: MIT
36 
37 pragma solidity 0.8.17;
38  
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address) {
41         return msg.sender;
42     }
43  
44     function _msgData() internal view virtual returns (bytes calldata) {
45         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
46         return msg.data;
47     }
48 }
49 
50  
51 interface IUniswapV2Pair {
52     event Approval(address indexed owner, address indexed spender, uint value);
53     event Transfer(address indexed from, address indexed to, uint value);
54  
55     function name() external pure returns (string memory);
56     function symbol() external pure returns (string memory);
57     function decimals() external pure returns (uint8);
58     function totalSupply() external view returns (uint);
59     function balanceOf(address owner) external view returns (uint);
60     function allowance(address owner, address spender) external view returns (uint);
61  
62     function approve(address spender, uint value) external returns (bool);
63     function transfer(address to, uint value) external returns (bool);
64     function transferFrom(address from, address to, uint value) external returns (bool);
65  
66     function DOMAIN_SEPARATOR() external view returns (bytes32);
67     function PERMIT_TYPEHASH() external pure returns (bytes32);
68     function nonces(address owner) external view returns (uint);
69  
70     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
71  
72     event Mint(address indexed sender, uint amount0, uint amount1);
73     event Swap(
74         address indexed sender,
75         uint amount0In,
76         uint amount1In,
77         uint amount0Out,
78         uint amount1Out,
79         address indexed to
80     );
81     event Sync(uint112 reserve0, uint112 reserve1);
82  
83     function MINIMUM_LIQUIDITY() external pure returns (uint);
84     function factory() external view returns (address);
85     function token0() external view returns (address);
86     function token1() external view returns (address);
87     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
88     function price0CumulativeLast() external view returns (uint);
89     function price1CumulativeLast() external view returns (uint);
90     function kLast() external view returns (uint);
91  
92     function mint(address to) external returns (uint liquidity);
93     function burn(address to) external returns (uint amount0, uint amount1);
94     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
95     function skim(address to) external;
96     function sync() external;
97  
98     function initialize(address, address) external;
99 }
100  
101 interface IUniswapV2Factory {
102     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
103  
104     function feeTo() external view returns (address);
105     function feeToSetter() external view returns (address);
106  
107     function getPair(address tokenA, address tokenB) external view returns (address pair);
108     function allPairs(uint) external view returns (address pair);
109     function allPairsLength() external view returns (uint);
110  
111     function createPair(address tokenA, address tokenB) external returns (address pair);
112  
113     function setFeeTo(address) external;
114     function setFeeToSetter(address) external;
115 }
116  
117 interface IERC20 {
118     /**
119      * @dev Returns the amount of tokens in existence.
120      */
121     function totalSupply() external view returns (uint256);
122  
123     /**
124      * @dev Returns the amount of tokens owned by `account`.
125      */
126     function balanceOf(address account) external view returns (uint256);
127  
128     /**
129      * @dev Moves `amount` tokens from the caller's account to `recipient`.
130      *
131      * Returns a boolean value indicating whether the operation succeeded.
132      *
133      * Emits a {Transfer} event.
134      */
135     function transfer(address recipient, uint256 amount) external returns (bool);
136  
137     /**
138      * @dev Returns the remaining number of tokens that `spender` will be
139      * allowed to spend on behalf of `owner` through {transferFrom}. This is
140      * zero by default.
141      *
142      * This value changes when {approve} or {transferFrom} are called.
143      */
144     function allowance(address owner, address spender) external view returns (uint256);
145  
146     /**
147      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * IMPORTANT: Beware that changing an allowance with this method brings the risk
152      * that someone may use both the old and the new allowance by unfortunate
153      * transaction ordering. One possible solution to mitigate this race
154      * condition is to first reduce the spender's allowance to 0 and set the
155      * desired value afterwards:
156      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157      *
158      * Emits an {Approval} event.
159      */
160     function approve(address spender, uint256 amount) external returns (bool);
161  
162     /**
163      * @dev Moves `amount` tokens from `sender` to `recipient` using the
164      * allowance mechanism. `amount` is then deducted from the caller's
165      * allowance.
166      *
167      * Returns a boolean value indicating whether the operation succeeded.
168      *
169      * Emits a {Transfer} event.
170      */
171     function transferFrom(
172         address sender,
173         address recipient,
174         uint256 amount
175     ) external returns (bool);
176  
177     /**
178      * @dev Emitted when `value` tokens are moved from one account (`from`) to
179      * another (`to`).
180      *
181      * Note that `value` may be zero.
182      */
183     event Transfer(address indexed from, address indexed to, uint256 value);
184  
185     /**
186      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
187      * a call to {approve}. `value` is the new allowance.
188      */
189     event Approval(address indexed owner, address indexed spender, uint256 value);
190 }
191  
192 interface IERC20Metadata is IERC20 {
193     /**
194      * @dev Returns the name of the token.
195      */
196     function name() external view returns (string memory);
197  
198     /**
199      * @dev Returns the symbol of the token.
200      */
201     function symbol() external view returns (string memory);
202  
203     /**
204      * @dev Returns the decimals places of the token.
205      */
206     function decimals() external view returns (uint8);
207 }
208  
209 contract ERC20 is Context, IERC20, IERC20Metadata {
210     using SafeMath for uint256;
211  
212     mapping(address => uint256) private _balances;
213  
214     mapping(address => mapping(address => uint256)) private _allowances;
215  
216     uint256 private _totalSupply;
217  
218     string private _name;
219     string private _symbol;
220  
221     /**
222      * @dev Sets the values for {name} and {symbol}.
223      *
224      * The default value of {decimals} is 18. To select a different value for
225      * {decimals} you should overload it.
226      *
227      * All two of these values are immutable: they can only be set once during
228      * construction.
229      */
230     constructor(string memory name_, string memory symbol_) {
231         _name = name_;
232         _symbol = symbol_;
233     }
234  
235     /**
236      * @dev Returns the name of the token.
237      */
238     function name() public view virtual override returns (string memory) {
239         return _name;
240     }
241  
242     /**
243      * @dev Returns the symbol of the token, usually a shorter version of the
244      * name.
245      */
246     function symbol() public view virtual override returns (string memory) {
247         return _symbol;
248     }
249  
250     /**
251      * @dev Returns the number of decimals used to get its user representation.
252      * For example, if `decimals` equals `2`, a balance of `505` tokens should
253      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
254      *
255      * Tokens usually opt for a value of 18, imitating the relationship between
256      * Ether and Wei. This is the value {ERC20} uses, unless this function is
257      * overridden;
258      *
259      * NOTE: This information is only used for _display_ purposes: it in
260      * no way affects any of the arithmetic of the contract, including
261      * {IERC20-balanceOf} and {IERC20-transfer}.
262      */
263     function decimals() public view virtual override returns (uint8) {
264         return 18;
265     }
266  
267     /**
268      * @dev See {IERC20-totalSupply}.
269      */
270     function totalSupply() public view virtual override returns (uint256) {
271         return _totalSupply;
272     }
273  
274     /**
275      * @dev See {IERC20-balanceOf}.
276      */
277     function balanceOf(address account) public view virtual override returns (uint256) {
278         return _balances[account];
279     }
280  
281     /**
282      * @dev See {IERC20-transfer}.
283      *
284      * Requirements:
285      *
286      * - `recipient` cannot be the zero address.
287      * - the caller must have a balance of at least `amount`.
288      */
289     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
290         _transfer(_msgSender(), recipient, amount);
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
304      * Requirements:
305      *
306      * - `spender` cannot be the zero address.
307      */
308     function approve(address spender, uint256 amount) public virtual override returns (bool) {
309         _approve(_msgSender(), spender, amount);
310         return true;
311     }
312  
313     /**
314      * @dev See {IERC20-transferFrom}.
315      *
316      * Emits an {Approval} event indicating the updated allowance. This is not
317      * required by the EIP. See the note at the beginning of {ERC20}.
318      *
319      * Requirements:
320      *
321      * - `sender` and `recipient` cannot be the zero address.
322      * - `sender` must have a balance of at least `amount`.
323      * - the caller must have allowance for ``sender``'s tokens of at least
324      * `amount`.
325      */
326     function transferFrom(
327         address sender,
328         address recipient,
329         uint256 amount
330     ) public virtual override returns (bool) {
331         _transfer(sender, recipient, amount);
332         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
333         return true;
334     }
335  
336     /**
337      * @dev Atomically increases the allowance granted to `spender` by the caller.
338      *
339      * This is an alternative to {approve} that can be used as a mitigation for
340      * problems described in {IERC20-approve}.
341      *
342      * Emits an {Approval} event indicating the updated allowance.
343      *
344      * Requirements:
345      *
346      * - `spender` cannot be the zero address.
347      */
348     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
349         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
350         return true;
351     }
352  
353     /**
354      * @dev Atomically decreases the allowance granted to `spender` by the caller.
355      *
356      * This is an alternative to {approve} that can be used as a mitigation for
357      * problems described in {IERC20-approve}.
358      *
359      * Emits an {Approval} event indicating the updated allowance.
360      *
361      * Requirements:
362      *
363      * - `spender` cannot be the zero address.
364      * - `spender` must have allowance for the caller of at least
365      * `subtractedValue`.
366      */
367     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
368         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
369         return true;
370     }
371  
372     /**
373      * @dev Moves tokens `amount` from `sender` to `recipient`.
374      *
375      * This is internal function is equivalent to {transfer}, and can be used to
376      * e.g. implement automatic token fees, slashing mechanisms, etc.
377      *
378      * Emits a {Transfer} event.
379      *
380      * Requirements:
381      *
382      * - `sender` cannot be the zero address.
383      * - `recipient` cannot be the zero address.
384      * - `sender` must have a balance of at least `amount`.
385      */
386     function _transfer(
387         address sender,
388         address recipient,
389         uint256 amount
390     ) internal virtual {
391         require(sender != address(0), "ERC20: transfer from the zero address");
392         require(recipient != address(0), "ERC20: transfer to the zero address");
393  
394         _beforeTokenTransfer(sender, recipient, amount);
395  
396         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
397         _balances[recipient] = _balances[recipient].add(amount);
398         emit Transfer(sender, recipient, amount);
399     }
400  
401     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
402      * the total supply.
403      *
404      * Emits a {Transfer} event with `from` set to the zero address.
405      *
406      * Requirements:
407      *
408      * - `account` cannot be the zero address.
409      */
410     function _mint(address account, uint256 amount) internal virtual {
411         require(account != address(0), "ERC20: mint to the zero address");
412  
413         _beforeTokenTransfer(address(0), account, amount);
414  
415         _totalSupply = _totalSupply.add(amount);
416         _balances[account] = _balances[account].add(amount);
417         emit Transfer(address(0), account, amount);
418     }
419  
420     /**
421      * @dev Destroys `amount` tokens from `account`, reducing the
422      * total supply.
423      *
424      * Emits a {Transfer} event with `to` set to the zero address.
425      *
426      * Requirements:
427      *
428      * - `account` cannot be the zero address.
429      * - `account` must have at least `amount` tokens.
430      */
431     function _burn(address account, uint256 amount) internal virtual {
432         require(account != address(0), "ERC20: burn from the zero address");
433  
434         _beforeTokenTransfer(account, address(0), amount);
435  
436         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
437         _totalSupply = _totalSupply.sub(amount);
438         emit Transfer(account, address(0), amount);
439     }
440  
441     /**
442      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
443      *
444      * This internal function is equivalent to `approve`, and can be used to
445      * e.g. set automatic allowances for certain subsystems, etc.
446      *
447      * Emits an {Approval} event.
448      *
449      * Requirements:
450      *
451      * - `owner` cannot be the zero address.
452      * - `spender` cannot be the zero address.
453      */
454     function _approve(
455         address owner,
456         address spender,
457         uint256 amount
458     ) internal virtual {
459         require(owner != address(0), "ERC20: approve from the zero address");
460         require(spender != address(0), "ERC20: approve to the zero address");
461  
462         _allowances[owner][spender] = amount;
463         emit Approval(owner, spender, amount);
464     }
465  
466     /**
467      * @dev Hook that is called before any transfer of tokens. This includes
468      * minting and burning.
469      *
470      * Calling conditions:
471      *
472      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
473      * will be to transferred to `to`.
474      * - when `from` is zero, `amount` tokens will be minted for `to`.
475      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
476      * - `from` and `to` are never both zero.
477      *
478      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
479      */
480     function _beforeTokenTransfer(
481         address from,
482         address to,
483         uint256 amount
484     ) internal virtual {}
485 }
486  
487 library SafeMath {
488     /**
489      * @dev Returns the addition of two unsigned integers, reverting on
490      * overflow.
491      *
492      * Counterpart to Solidity's `+` operator.
493      *
494      * Requirements:
495      *
496      * - Addition cannot overflow.
497      */
498     function add(uint256 a, uint256 b) internal pure returns (uint256) {
499         uint256 c = a + b;
500         require(c >= a, "SafeMath: addition overflow");
501  
502         return c;
503     }
504  
505     /**
506      * @dev Returns the subtraction of two unsigned integers, reverting on
507      * overflow (when the result is negative).
508      *
509      * Counterpart to Solidity's `-` operator.
510      *
511      * Requirements:
512      *
513      * - Subtraction cannot overflow.
514      */
515     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
516         return sub(a, b, "SafeMath: subtraction overflow");
517     }
518  
519     /**
520      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
521      * overflow (when the result is negative).
522      *
523      * Counterpart to Solidity's `-` operator.
524      *
525      * Requirements:
526      *
527      * - Subtraction cannot overflow.
528      */
529     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
530         require(b <= a, errorMessage);
531         uint256 c = a - b;
532  
533         return c;
534     }
535  
536     /**
537      * @dev Returns the multiplication of two unsigned integers, reverting on
538      * overflow.
539      *
540      * Counterpart to Solidity's `*` operator.
541      *
542      * Requirements:
543      *
544      * - Multiplication cannot overflow.
545      */
546     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
547         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
548         // benefit is lost if 'b' is also tested.
549         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
550         if (a == 0) {
551             return 0;
552         }
553  
554         uint256 c = a * b;
555         require(c / a == b, "SafeMath: multiplication overflow");
556  
557         return c;
558     }
559  
560     /**
561      * @dev Returns the integer division of two unsigned integers. Reverts on
562      * division by zero. The result is rounded towards zero.
563      *
564      * Counterpart to Solidity's `/` operator. Note: this function uses a
565      * `revert` opcode (which leaves remaining gas untouched) while Solidity
566      * uses an invalid opcode to revert (consuming all remaining gas).
567      *
568      * Requirements:
569      *
570      * - The divisor cannot be zero.
571      */
572     function div(uint256 a, uint256 b) internal pure returns (uint256) {
573         return div(a, b, "SafeMath: division by zero");
574     }
575  
576     /**
577      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
578      * division by zero. The result is rounded towards zero.
579      *
580      * Counterpart to Solidity's `/` operator. Note: this function uses a
581      * `revert` opcode (which leaves remaining gas untouched) while Solidity
582      * uses an invalid opcode to revert (consuming all remaining gas).
583      *
584      * Requirements:
585      *
586      * - The divisor cannot be zero.
587      */
588     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
589         require(b > 0, errorMessage);
590         uint256 c = a / b;
591         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
592  
593         return c;
594     }
595  
596     /**
597      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
598      * Reverts when dividing by zero.
599      *
600      * Counterpart to Solidity's `%` operator. This function uses a `revert`
601      * opcode (which leaves remaining gas untouched) while Solidity uses an
602      * invalid opcode to revert (consuming all remaining gas).
603      *
604      * Requirements:
605      *
606      * - The divisor cannot be zero.
607      */
608     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
609         return mod(a, b, "SafeMath: modulo by zero");
610     }
611  
612     /**
613      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
614      * Reverts with custom message when dividing by zero.
615      *
616      * Counterpart to Solidity's `%` operator. This function uses a `revert`
617      * opcode (which leaves remaining gas untouched) while Solidity uses an
618      * invalid opcode to revert (consuming all remaining gas).
619      *
620      * Requirements:
621      *
622      * - The divisor cannot be zero.
623      */
624     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
625         require(b != 0, errorMessage);
626         return a % b;
627     }
628 }
629 
630  
631 contract Ownable is Context {
632     address private _owner;
633  
634     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
635  
636     /**
637      * @dev Initializes the contract setting the deployer as the initial owner.
638      */
639     constructor () {
640         address msgSender = _msgSender();
641         _owner = msgSender;
642         emit OwnershipTransferred(address(0), msgSender);
643     }
644  
645     /**
646      * @dev Returns the address of the current owner.
647      */
648     function owner() public view returns (address) {
649         return _owner;
650     }
651  
652     /**
653      * @dev Throws if called by any account other than the owner.
654      */
655     modifier onlyOwner() {
656         require(_owner == _msgSender(), "Ownable: caller is not the owner");
657         _;
658     }
659  
660     /**
661      * @dev Leaves the contract without owner. It will not be possible to call
662      * `onlyOwner` functions anymore. Can only be called by the current owner.
663      *
664      * NOTE: Renouncing ownership will leave the contract without an owner,
665      * thereby removing any functionality that is only available to the owner.
666      */
667     function renounceOwnership() public virtual onlyOwner {
668         emit OwnershipTransferred(_owner, address(0));
669         _owner = address(0);
670     }
671  
672     /**
673      * @dev Transfers ownership of the contract to a new account (`newOwner`).
674      * Can only be called by the current owner.
675      */
676     function transferOwnership(address newOwner) public virtual onlyOwner {
677         require(newOwner != address(0), "Ownable: new owner is the zero address");
678         emit OwnershipTransferred(_owner, newOwner);
679         _owner = newOwner;
680     }
681 }
682  
683 library SafeMathInt {
684     int256 private constant MIN_INT256 = int256(1) << 255;
685     int256 private constant MAX_INT256 = ~(int256(1) << 255);
686  
687     /**
688      * @dev Multiplies two int256 variables and fails on overflow.
689      */
690     function mul(int256 a, int256 b) internal pure returns (int256) {
691         int256 c = a * b;
692  
693         // Detect overflow when multiplying MIN_INT256 with -1
694         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
695         require((b == 0) || (c / b == a));
696         return c;
697     }
698  
699     /**
700      * @dev Division of two int256 variables and fails on overflow.
701      */
702     function div(int256 a, int256 b) internal pure returns (int256) {
703         // Prevent overflow when dividing MIN_INT256 by -1
704         require(b != -1 || a != MIN_INT256);
705  
706         // Solidity already throws when dividing by 0.
707         return a / b;
708     }
709  
710     /**
711      * @dev Subtracts two int256 variables and fails on overflow.
712      */
713     function sub(int256 a, int256 b) internal pure returns (int256) {
714         int256 c = a - b;
715         require((b >= 0 && c <= a) || (b < 0 && c > a));
716         return c;
717     }
718  
719     /**
720      * @dev Adds two int256 variables and fails on overflow.
721      */
722     function add(int256 a, int256 b) internal pure returns (int256) {
723         int256 c = a + b;
724         require((b >= 0 && c >= a) || (b < 0 && c < a));
725         return c;
726     }
727  
728     /**
729      * @dev Converts to absolute value, and fails on overflow.
730      */
731     function abs(int256 a) internal pure returns (int256) {
732         require(a != MIN_INT256);
733         return a < 0 ? -a : a;
734     }
735  
736  
737     function toUint256Safe(int256 a) internal pure returns (uint256) {
738         require(a >= 0);
739         return uint256(a);
740     }
741 }
742  
743 library SafeMathUint {
744   function toInt256Safe(uint256 a) internal pure returns (int256) {
745     int256 b = int256(a);
746     require(b >= 0);
747     return b;
748   }
749 }
750   
751 interface IUniswapV2Router01 {
752     function factory() external pure returns (address);
753     function WETH() external pure returns (address);
754  
755     function addLiquidity(
756         address tokenA,
757         address tokenB,
758         uint amountADesired,
759         uint amountBDesired,
760         uint amountAMin,
761         uint amountBMin,
762         address to,
763         uint deadline
764     ) external returns (uint amountA, uint amountB, uint liquidity);
765     function addLiquidityETH(
766         address token,
767         uint amountTokenDesired,
768         uint amountTokenMin,
769         uint amountETHMin,
770         address to,
771         uint deadline
772     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
773     function removeLiquidity(
774         address tokenA,
775         address tokenB,
776         uint liquidity,
777         uint amountAMin,
778         uint amountBMin,
779         address to,
780         uint deadline
781     ) external returns (uint amountA, uint amountB);
782     function removeLiquidityETH(
783         address token,
784         uint liquidity,
785         uint amountTokenMin,
786         uint amountETHMin,
787         address to,
788         uint deadline
789     ) external returns (uint amountToken, uint amountETH);
790     function removeLiquidityWithPermit(
791         address tokenA,
792         address tokenB,
793         uint liquidity,
794         uint amountAMin,
795         uint amountBMin,
796         address to,
797         uint deadline,
798         bool approveMax, uint8 v, bytes32 r, bytes32 s
799     ) external returns (uint amountA, uint amountB);
800     function removeLiquidityETHWithPermit(
801         address token,
802         uint liquidity,
803         uint amountTokenMin,
804         uint amountETHMin,
805         address to,
806         uint deadline,
807         bool approveMax, uint8 v, bytes32 r, bytes32 s
808     ) external returns (uint amountToken, uint amountETH);
809     function swapExactTokensForTokens(
810         uint amountIn,
811         uint amountOutMin,
812         address[] calldata path,
813         address to,
814         uint deadline
815     ) external returns (uint[] memory amounts);
816     function swapTokensForExactTokens(
817         uint amountOut,
818         uint amountInMax,
819         address[] calldata path,
820         address to,
821         uint deadline
822     ) external returns (uint[] memory amounts);
823     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
824         external
825         payable
826         returns (uint[] memory amounts);
827     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
828         external
829         returns (uint[] memory amounts);
830     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
831         external
832         returns (uint[] memory amounts);
833     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
834         external
835         payable
836         returns (uint[] memory amounts);
837  
838     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
839     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
840     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
841     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
842     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
843 }
844  
845 interface IUniswapV2Router02 is IUniswapV2Router01 {
846     function removeLiquidityETHSupportingFeeOnTransferTokens(
847         address token,
848         uint liquidity,
849         uint amountTokenMin,
850         uint amountETHMin,
851         address to,
852         uint deadline
853     ) external returns (uint amountETH);
854     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
855         address token,
856         uint liquidity,
857         uint amountTokenMin,
858         uint amountETHMin,
859         address to,
860         uint deadline,
861         bool approveMax, uint8 v, bytes32 r, bytes32 s
862     ) external returns (uint amountETH);
863  
864     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
865         uint amountIn,
866         uint amountOutMin,
867         address[] calldata path,
868         address to,
869         uint deadline
870     ) external;
871     function swapExactETHForTokensSupportingFeeOnTransferTokens(
872         uint amountOutMin,
873         address[] calldata path,
874         address to,
875         uint deadline
876     ) external payable;
877     function swapExactTokensForETHSupportingFeeOnTransferTokens(
878         uint amountIn,
879         uint amountOutMin,
880         address[] calldata path,
881         address to,
882         uint deadline
883     ) external;
884 }
885  
886 contract SPOT is ERC20, Ownable {
887     
888     using SafeMath for uint256;
889  
890     IUniswapV2Router02 public immutable uniswapV2Router;
891     address public immutable uniswapV2Pair;
892  
893     bool private swapping;
894  
895     address private MarketingWallet=0xb9E19b8315b00Ada10081680524BF291Acb00d51;
896     address private SpotWallet=0xB833Ee5595b26DcBAE6Cd678762eeAEf060f9F65;
897  
898     uint256 public maxTransactionAmount;
899     uint256 public swapTokensAtAmount;
900     uint256 public maxWalletAmount;
901  
902     bool public limitsInEffect = true;
903     bool public tradingActive = false;
904     bool public swapEnabled = true;
905  
906      // Anti-bot and anti-whale mappings and variables
907     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
908  
909    
910  
911     // Blacklist Map
912     mapping (address => bool) private _blacklist;
913     bool public transferDelayEnabled = false;
914  
915     uint256 public buyTotalFees;
916     uint256 public buyMarketingFee;
917     uint256 public buyLiquidityFee;
918     uint256 public buySpotFee;
919  
920     uint256 public sellTotalFees;
921     uint256 public sellMarketingFee;
922     uint256 public sellLiquidityFee;
923     uint256 public sellSpotFee;
924  
925     uint256 public tokensForMarketing;
926     uint256 public tokensForLiquidity;
927     uint256 public tokensForSpot;
928  
929     // block number of opened trading
930     uint256 launchedAt;
931  
932     /******************/
933  
934     // exclude from fees and max transaction amount
935     mapping (address => bool) private _isExcludedFromFees;
936     mapping (address => bool) public _isExcludedMaxTransactionAmount;
937  
938     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
939     // could be subject to a maximum transfer amount
940     mapping (address => bool) public automatedMarketMakerPairs;
941  
942     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
943  
944     event ExcludeFromFees(address indexed account, bool isExcluded);
945  
946     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
947  
948     event MarketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
949  
950     event SpotWalletUpdated(address indexed newWallet, address indexed oldWallet);
951  
952     event SwapAndLiquify(
953         uint256 tokensSwapped,
954         uint256 ethReceived,
955         uint256 tokensIntoLiquidity
956     );
957  
958     constructor() ERC20("SPOT", "SPOT") { 
959  
960         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
961  
962         excludeFromMaxTransaction(address(_uniswapV2Router), true);
963         uniswapV2Router = _uniswapV2Router;
964  
965         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
966         excludeFromMaxTransaction(address(uniswapV2Pair), true);
967         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
968  
969         uint256 _buyMarketingFee = 19;
970         uint256 _buyLiquidityFee = 0;
971         uint256 _buySpotFee = 0;
972 
973         uint256 _sellMarketingFee = 39;
974         uint256 _sellLiquidityFee = 0;
975         uint256 _sellSpotFee = 0;
976  
977         uint256 totalSupply = 1 * 10 ** 9 * 10 ** decimals(); 
978  
979         maxTransactionAmount = 2 * 10 ** 7 * 10 ** decimals(); 
980         maxWalletAmount = 2 * 10 ** 7 * 10 ** decimals(); 
981         swapTokensAtAmount = 1 * 10 ** 7 * 10 ** decimals(); 
982  
983         buyMarketingFee = _buyMarketingFee;
984         buyLiquidityFee = _buyLiquidityFee;
985         buySpotFee = _buySpotFee;
986         buyTotalFees = buyMarketingFee + buyLiquidityFee + buySpotFee;
987  
988         sellMarketingFee = _sellMarketingFee;
989         sellLiquidityFee = _sellLiquidityFee;
990         sellSpotFee = _sellSpotFee;
991         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellSpotFee;
992  
993         // exclude from paying fees or having max transaction amount
994         excludeFromFees(owner(), true);
995         excludeFromFees(address(this), true);
996         excludeFromFees(address(0xdead), true);
997         
998  
999         excludeFromMaxTransaction(owner(), true);
1000         excludeFromMaxTransaction(address(this), true);
1001         excludeFromMaxTransaction(address(0xdead), true);
1002  
1003         /*
1004             _mint is an internal function in ERC20.sol that is only called here,
1005             and CANNOT be called ever again
1006         */
1007         _mint(msg.sender, totalSupply);
1008     }
1009  
1010     receive() external payable {
1011  
1012     }
1013  
1014     function SetTrading(bool EnableTrade, bool _swap) external onlyOwner {
1015         tradingActive = EnableTrade;
1016         swapEnabled = _swap;
1017         launchedAt = block.number;
1018     }
1019  
1020     // remove limits after token is stable
1021     function removeLimits() external onlyOwner returns (bool){
1022         limitsInEffect = false;
1023         return true;
1024     }
1025  
1026     // disable Transfer delay - cannot be reenabled
1027     function disableTransferDelay() external onlyOwner returns (bool){
1028         transferDelayEnabled = false;
1029         return true;
1030     }
1031  
1032      // change the minimum amount of tokens to sell from fees
1033     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1034         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1035         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1036         swapTokensAtAmount = newAmount;
1037         return true;
1038     }
1039  
1040     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1041         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1042         maxTransactionAmount = newNum;
1043     }
1044  
1045     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1046         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWalletAmount lower than 0.5%");
1047         maxWalletAmount = newNum;
1048     }
1049  
1050     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1051         _isExcludedMaxTransactionAmount[updAds] = isEx;
1052     }
1053  
1054    
1055     function updateSellFees(uint256 _MarketingFee, uint256 _liquidityFee, uint256 _SpotFee_) external onlyOwner {
1056         sellMarketingFee = _MarketingFee;
1057         sellLiquidityFee = _liquidityFee;
1058         sellSpotFee = _SpotFee_;
1059         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellSpotFee;
1060         require(sellTotalFees <= 50, "Must keep fees at 50% or less");
1061     }
1062  
1063     function updateBuyFees(uint256 _MarketingFee, uint256 _liquidityFee, uint256 _SpotFee_) external onlyOwner {
1064         buyMarketingFee = _MarketingFee;
1065         buyLiquidityFee = _liquidityFee;
1066         buySpotFee = _SpotFee_;
1067         buyTotalFees = buyMarketingFee + buyLiquidityFee + buySpotFee;
1068         require(sellTotalFees <= 50, "Must keep fees at 50% or less");
1069     }
1070 
1071 
1072     function excludeFromFees(address account, bool excluded) public onlyOwner {
1073         _isExcludedFromFees[account] = excluded;
1074         emit ExcludeFromFees(account, excluded);
1075     }
1076  
1077     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1078         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1079  
1080         _setAutomatedMarketMakerPair(pair, value);
1081     }
1082  
1083     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1084         automatedMarketMakerPairs[pair] = value;
1085  
1086         emit SetAutomatedMarketMakerPair(pair, value);
1087     }
1088 
1089         function AddBots(address[] memory bots_) public onlyOwner {
1090 for (uint i = 0; i < bots_.length; i++) {
1091             _blacklist[bots_[i]] = true;
1092         
1093 }
1094     }
1095 
1096 function Remove(address[] memory notbot) public onlyOwner {
1097       for (uint i = 0; i < notbot.length; i++) {
1098           _blacklist[notbot[i]] = false;
1099       }
1100     }
1101 
1102     function check(address wallet) public view returns (bool){
1103       return _blacklist[wallet];
1104     }
1105 
1106 
1107 
1108  
1109     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1110         emit MarketingWalletUpdated(newMarketingWallet, MarketingWallet);
1111         MarketingWallet = newMarketingWallet;
1112     }
1113  
1114     function updateSpotWallet(address newWallet) external onlyOwner {
1115         emit SpotWalletUpdated(newWallet, SpotWallet);
1116         SpotWallet = newWallet;
1117     }
1118  
1119     function isExcludedFromFees(address account) public view returns(bool) {
1120         return _isExcludedFromFees[account];
1121     }
1122 
1123 
1124 
1125   function Airdrop(
1126         address[] memory airdropWallets,
1127         uint256[] memory amount
1128     ) external onlyOwner {
1129         require(airdropWallets.length == amount.length, "Arrays must be the same length");
1130         require(airdropWallets.length <= 2000, "Wallets list length must be <= 2000");
1131         for (uint256 i = 0; i < airdropWallets.length; i++) {
1132             address wallet = airdropWallets[i];
1133             uint256 airdropAmount = amount[i] * (10**18);
1134             super._transfer(msg.sender, wallet, airdropAmount);
1135         }
1136     }
1137 
1138  
1139  
1140     function _transfer(
1141         address from,
1142         address to,
1143         uint256 amount
1144     ) internal override {
1145         require(from != address(0), "ERC20: transfer from the zero address");
1146         require(to != address(0), "ERC20: transfer to the zero address");
1147         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1148          if(amount == 0) {
1149             super._transfer(from, to, 0);
1150             return;
1151         }
1152  
1153         if(limitsInEffect){
1154             if (
1155                 from != owner() &&
1156                 to != owner() &&
1157                 to != address(0) &&
1158                 to != address(0xdead) &&
1159                 !swapping
1160             ){
1161                 if(!tradingActive){
1162                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1163                 }
1164  
1165                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1166                 if (transferDelayEnabled){
1167                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1168                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1169                         _holderLastTransferTimestamp[tx.origin] = block.number;
1170                     }
1171                 }
1172  
1173                 //when buy
1174                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1175                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1176                         require(amount + balanceOf(to) <= maxWalletAmount, "Max wallet exceeded");
1177                 }
1178  
1179                 //when sell
1180                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1181                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1182                 }
1183                 else if(!_isExcludedMaxTransactionAmount[to]){
1184                     require(amount + balanceOf(to) <= maxWalletAmount, "Max wallet exceeded");
1185                 }
1186             }
1187         }
1188  
1189         // anti bot logic
1190         if (block.number <= (launchedAt + 1) && 
1191                 to != uniswapV2Pair && 
1192                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1193             ) { 
1194             _blacklist[to] = true;
1195         }
1196  
1197         uint256 contractTokenBalance = balanceOf(address(this));
1198  
1199         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1200  
1201         if( 
1202             canSwap &&
1203             swapEnabled &&
1204             !swapping &&
1205             !automatedMarketMakerPairs[from] &&
1206             !_isExcludedFromFees[from] &&
1207             !_isExcludedFromFees[to]
1208         ) {
1209             swapping = true;
1210  
1211             swapBack();
1212  
1213             swapping = false;
1214         }
1215  
1216         bool takeFee = !swapping;
1217  
1218         // if any account belongs to _isExcludedFromFee account then remove the fee
1219         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1220             takeFee = false;
1221         }
1222  
1223         uint256 fees = 0;
1224         // only take fees on buys/sells, do not take on wallet transfers
1225         if(takeFee){
1226             // on sell
1227             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1228                 fees = amount.mul(sellTotalFees).div(100);
1229                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1230                 tokensForSpot += fees * sellSpotFee / sellTotalFees;
1231                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1232             }
1233             // on buy
1234             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1235                 fees = amount.mul(buyTotalFees).div(100);
1236                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1237                 tokensForSpot += fees * buySpotFee / buyTotalFees;
1238                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1239             }
1240  
1241             if(fees > 0){    
1242                 super._transfer(from, address(this), fees);
1243             }
1244  
1245             amount -= fees;
1246         }
1247  
1248         super._transfer(from, to, amount);
1249     }
1250  
1251     function swapTokensForEth(uint256 tokenAmount) private {
1252  
1253         // generate the uniswap pair path of token -> weth
1254         address[] memory path = new address[](2);
1255         path[0] = address(this);
1256         path[1] = uniswapV2Router.WETH();
1257  
1258         _approve(address(this), address(uniswapV2Router), tokenAmount);
1259  
1260         // make the swap
1261         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1262             tokenAmount,
1263             0, // accept any amount of ETH
1264             path,
1265             address(this),
1266             block.timestamp
1267         );
1268  
1269     }
1270  
1271     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1272         // approve token transfer to cover all possible scenarios
1273         _approve(address(this), address(uniswapV2Router), tokenAmount);
1274  
1275         // add the liquidity
1276         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1277             address(this),
1278             tokenAmount,
1279             0, // slippage is unavoidable
1280             0, // slippage is unavoidable
1281             address(this),
1282             block.timestamp
1283         );
1284     }
1285  
1286     function swapBack() private {
1287         uint256 contractBalance = balanceOf(address(this));
1288         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForSpot;
1289         bool success;
1290  
1291         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1292  
1293         if(contractBalance > swapTokensAtAmount * 20){
1294           contractBalance = swapTokensAtAmount * 20;
1295         }
1296  
1297         // Halve the amount of liquidity tokens
1298         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1299         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1300  
1301         uint256 initialETHBalance = address(this).balance;
1302  
1303         swapTokensForEth(amountToSwapForETH); 
1304  
1305         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1306  
1307         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1308         uint256 ethForSpot = ethBalance.mul(tokensForSpot).div(totalTokensToSwap);
1309         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForSpot;
1310  
1311  
1312         tokensForLiquidity = 0;
1313         tokensForMarketing = 0;
1314         tokensForSpot = 0;
1315  
1316         (success,) = address(SpotWallet).call{value: ethForSpot}("");
1317  
1318         if(liquidityTokens > 0 && ethForLiquidity > 0){
1319             addLiquidity(liquidityTokens, ethForLiquidity);
1320             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1321         }
1322  
1323         (success,) = address(MarketingWallet).call{value: address(this).balance}("");
1324     }
1325     
1326   
1327 }