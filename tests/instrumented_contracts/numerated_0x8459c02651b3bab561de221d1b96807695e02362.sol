1 /**
2    
3                                                                            %&%  
4                                                                          %&%%%  
5                                                                        %&%%%%%% 
6                                                                      ##%%%%%%%% 
7                                                                    ##%%%%%%%%%% 
8                                                                  ##%%%%%%%%%%%% 
9                                                                ##%%%%%%%%%%%%%% 
10                                                              ###%############## 
11                                                            ((###################
12                                                          ((&####################
13                                                        ((&######################
14                                                      ((&########################
15                                                    //&###### %%###########  ####
16                                                    %        %%%#########        
17                                                            %%%#########         
18                                                           %%%#########          
19                                                          %%&((((((((            
20                                                         %%&((((((((             
21                                                        %%&((((((((              
22                                                 %     %%&((((((((               
23                                            %&%%%%%%  %%&///////                 
24                                          %%%%%######%%(///////                  
25                                         %%///%%((((%%////////                   
26                          %%%%%%%%     %%&/////%%//%%////////                    
27                         ####&####((  ##//////  ####///////                      
28               %       ##////##((///##&////(     ##/////                         
29          ##&####(    #&////  ##///##(((((                                       
30        *#//##&(////##///(     ####&/////                                        
31       #////  ##///#&///         #////                                           
32     #////      ###////                                                          
33    &///                                                                         
34  &//.                                                                            
35 
36 
37     Trade crypto assets with fixed returns on short-term price movements.
38 
39 
40                 WW: https://stonks.bet/
41                 TG: https://t.me/StonksPortal
42                 TW: https://twitter.com/StonksToken
43 
44 */
45 
46 
47 
48 // SPDX-License-Identifier: MIT         
49 pragma solidity 0.8.9;
50 
51 abstract contract Context {
52     function _msgSender() internal view virtual returns (address) {
53         return msg.sender;
54     }
55 
56     function _msgData() internal view virtual returns (bytes calldata) {
57         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
58         return msg.data;
59     }
60 }
61 
62 interface IUniswapV2Pair {
63     event Approval(address indexed owner, address indexed spender, uint value);
64     event Transfer(address indexed from, address indexed to, uint value);
65 
66     function name() external pure returns (string memory);
67     function symbol() external pure returns (string memory);
68     function decimals() external pure returns (uint8);
69     function totalSupply() external view returns (uint);
70     function balanceOf(address owner) external view returns (uint);
71     function allowance(address owner, address spender) external view returns (uint);
72 
73     function approve(address spender, uint value) external returns (bool);
74     function transfer(address to, uint value) external returns (bool);
75     function transferFrom(address from, address to, uint value) external returns (bool);
76 
77     function DOMAIN_SEPARATOR() external view returns (bytes32);
78     function PERMIT_TYPEHASH() external pure returns (bytes32);
79     function nonces(address owner) external view returns (uint);
80 
81     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
82 
83     event Mint(address indexed sender, uint amount0, uint amount1);
84     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
85     event Swap(
86         address indexed sender,
87         uint amount0In,
88         uint amount1In,
89         uint amount0Out,
90         uint amount1Out,
91         address indexed to
92     );
93     event Sync(uint112 reserve0, uint112 reserve1);
94 
95     function MINIMUM_LIQUIDITY() external pure returns (uint);
96     function factory() external view returns (address);
97     function token0() external view returns (address);
98     function token1() external view returns (address);
99     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
100     function price0CumulativeLast() external view returns (uint);
101     function price1CumulativeLast() external view returns (uint);
102     function kLast() external view returns (uint);
103 
104     function mint(address to) external returns (uint liquidity);
105     function burn(address to) external returns (uint amount0, uint amount1);
106     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
107     function skim(address to) external;
108     function sync() external;
109 
110     function initialize(address, address) external;
111 }
112 
113 interface IUniswapV2Factory {
114     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
115 
116     function feeTo() external view returns (address);
117     function feeToSetter() external view returns (address);
118 
119     function getPair(address tokenA, address tokenB) external view returns (address pair);
120     function allPairs(uint) external view returns (address pair);
121     function allPairsLength() external view returns (uint);
122 
123     function createPair(address tokenA, address tokenB) external returns (address pair);
124 
125     function setFeeTo(address) external;
126     function setFeeToSetter(address) external;
127 }
128 
129 interface IERC20 {
130     /**
131      * @dev Returns the amount of tokens in existence.
132      */
133     function totalSupply() external view returns (uint256);
134 
135     /**
136      * @dev Returns the amount of tokens owned by `account`.
137      */
138     function balanceOf(address account) external view returns (uint256);
139 
140     /**
141      * @dev Moves `amount` tokens from the caller's account to `recipient`.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * Emits a {Transfer} event.
146      */
147     function transfer(address recipient, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Returns the remaining number of tokens that `spender` will be
151      * allowed to spend on behalf of `owner` through {transferFrom}. This is
152      * zero by default.
153      *
154      * This value changes when {approve} or {transferFrom} are called.
155      */
156     function allowance(address owner, address spender) external view returns (uint256);
157 
158     /**
159      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * IMPORTANT: Beware that changing an allowance with this method brings the risk
164      * that someone may use both the old and the new allowance by unfortunate
165      * transacgtion ordering. One possible solution to mitigate this race
166      * condition is to first reduce the spender's allowance to 0 and set the
167      * desired value afterwards:
168      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169      *
170      * Emits an {Approval} event.
171      */
172     function approve(address spender, uint256 amount) external returns (bool);
173 
174     /**
175      * @dev Moves `amount` tokens from `sender` to `recipient` using the
176      * allowance mechanism. `amount` is then deducted from the caller's
177      * allowance.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * Emits a {Transfer} event.
182      */
183     function transferFrom(
184         address sender,
185         address recipient,
186         uint256 amount
187     ) external returns (bool);
188 
189     /**
190      * @dev Emitted when `value` tokens are moved from one account (`from`) to
191      * another (`to`).
192      *
193      * Note that `value` may be zero.
194      */
195     event Transfer(address indexed from, address indexed to, uint256 value);
196 
197     /**
198      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
199      * a call to {approve}. `value` is the new allowance.
200      */
201     event Approval(address indexed owner, address indexed spender, uint256 value);
202 }
203 
204 interface IERC20Metadata is IERC20 {
205     /**
206      * @dev Returns the name of the token.
207      */
208     function name() external view returns (string memory);
209 
210     /**
211      * @dev Returns the symbol of the token.
212      */
213     function symbol() external view returns (string memory);
214 
215     /**
216      * @dev Returns the decimals places of the token.
217      */
218     function decimals() external view returns (uint8);
219 }
220 
221 
222 contract ERC20 is Context, IERC20, IERC20Metadata {
223     using SafeMath for uint256;
224 
225     mapping(address => uint256) private _balances;
226 
227     mapping(address => mapping(address => uint256)) private _allowances;
228 
229     uint256 private _totalSupply;
230 
231     string private _name;
232     string private _symbol;
233 
234     /**
235      * @dev Sets the values for {name} and {symbol}.
236      *
237      * The default value of {decimals} is 18. To select a different value for
238      * {decimals} you should overload it.
239      *
240      * All two of these values are immutable: they can only be set once during
241      * construction.
242      */
243     constructor(string memory name_, string memory symbol_) {
244         _name = name_;
245         _symbol = symbol_;
246     }
247 
248     /**
249      * @dev Returns the name of the token.
250      */
251     function name() public view virtual override returns (string memory) {
252         return _name;
253     }
254 
255     /**
256      * @dev Returns the symbol of the token, usually a shorter version of the
257      * name.
258      */
259     function symbol() public view virtual override returns (string memory) {
260         return _symbol;
261     }
262 
263     /**
264      * @dev Returns the number of decimals used to get its user representation.
265      * For example, if `decimals` equals `2`, a balance of `505` tokens should
266      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
267      *
268      * Tokens usually opt for a value of 18, imitating the relationship between
269      * Ether and Wei. This is the value {ERC20} uses, unless this function is
270      * overridden;
271      *
272      * NOTE: This information is only used for _display_ purposes: it in
273      * no way affects any of the arithmetic of the contract, including
274      * {IERC20-balanceOf} and {IERC20-transfer}.
275      */
276     function decimals() public view virtual override returns (uint8) {
277         return 18;
278     }
279 
280     /**
281      * @dev See {IERC20-totalSupply}.
282      */
283     function totalSupply() public view virtual override returns (uint256) {
284         return _totalSupply;
285     }
286 
287     /**
288      * @dev See {IERC20-balanceOf}.
289      */
290     function balanceOf(address account) public view virtual override returns (uint256) {
291         return _balances[account];
292     }
293 
294     /**
295      * @dev See {IERC20-transfer}.
296      *
297      * Requirements:
298      *
299      * - `recipient` cannot be the zero address.
300      * - the caller must have a balance of at least `amount`.
301      */
302     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
303         _transfer(_msgSender(), recipient, amount);
304         return true;
305     }
306 
307     /**
308      * @dev See {IERC20-allowance}.
309      */
310     function allowance(address owner, address spender) public view virtual override returns (uint256) {
311         return _allowances[owner][spender];
312     }
313 
314     /**
315      * @dev See {IERC20-approve}.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      */
321     function approve(address spender, uint256 amount) public virtual override returns (bool) {
322         _approve(_msgSender(), spender, amount);
323         return true;
324     }
325 
326     /**
327      * @dev See {IERC20-transferFrom}.
328      *
329      * Emits an {Approval} event indicating the updated allowance. This is not
330      * required by the EIP. See the note at the beginning of {ERC20}.
331      *
332      * Requirements:
333      *
334      * - `sender` and `recipient` cannot be the zero address.
335      * - `sender` must have a balance of at least `amount`.
336      * - the caller must have allowance for ``sender``'s tokens of at least
337      * `amount`.
338      */
339     function transferFrom(
340         address sender,
341         address recipient,
342         uint256 amount
343     ) public virtual override returns (bool) {
344         _transfer(sender, recipient, amount);
345         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
346         return true;
347     }
348 
349     /**
350      * @dev Atomically increases the allowance granted to `spender` by the caller.
351      *
352      * This is an alternative to {approve} that can be used as a mitigation for
353      * problems described in {IERC20-approve}.
354      *
355      * Emits an {Approval} event indicating the updated allowance.
356      *
357      * Requirements:
358      *
359      * - `spender` cannot be the zero address.
360      */
361     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
362         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
363         return true;
364     }
365 
366     /**
367      * @dev Atomically decreases the allowance granted to `spender` by the caller.
368      *
369      * This is an alternative to {approve} that can be used as a mitigation for
370      * problems described in {IERC20-approve}.
371      *
372      * Emits an {Approval} event indicating the updated allowance.
373      *
374      * Requirements:
375      *
376      * - `spender` cannot be the zero address.
377      * - `spender` must have allowance for the caller of at least
378      * `subtractedValue`.
379      */
380     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
381         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
382         return true;
383     }
384 
385     /**
386      * @dev Moves tokens `amount` from `sender` to `recipient`.
387      *
388      * This is internal function is equivalent to {transfer}, and can be used to
389      * e.g. implement automatic token fees, slashing mechanisms, etc.
390      *
391      * Emits a {Transfer} event.
392      *
393      * Requirements:
394      *
395      * - `sender` cannot be the zero address.
396      * - `recipient` cannot be the zero address.
397      * - `sender` must have a balance of at least `amount`.
398      */
399     function _transfer(
400         address sender,
401         address recipient,
402         uint256 amount
403     ) internal virtual {
404         require(sender != address(0), "ERC20: transfer from the zero address");
405         require(recipient != address(0), "ERC20: transfer to the zero address");
406 
407         _beforeTokenTransfer(sender, recipient, amount);
408 
409         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
410         _balances[recipient] = _balances[recipient].add(amount);
411         emit Transfer(sender, recipient, amount);
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
428         _totalSupply = _totalSupply.add(amount);
429         _balances[account] = _balances[account].add(amount);
430         emit Transfer(address(0), account, amount);
431     }
432 
433     /**
434      * @dev Destroys `amount` tokens from `account`, reducing the
435      * total supply.
436      *
437      * Emits a {Transfer} event with `to` set to the zero address.
438      *
439      * Requirements:
440      *
441      * - `account` cannot be the zero address.
442      * - `account` must have at least `amount` tokens.
443      */
444     function _burn(address account, uint256 amount) internal virtual {
445         require(account != address(0), "ERC20: burn from the zero address");
446 
447         _beforeTokenTransfer(account, address(0), amount);
448 
449         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
450         _totalSupply = _totalSupply.sub(amount);
451         emit Transfer(account, address(0), amount);
452     }
453 
454     /**
455      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
456      *
457      * This internal function is equivalent to `approve`, and can be used to
458      * e.g. set automatic allowances for certain subsystems, etc.
459      *
460      * Emits an {Approval} event.
461      *
462      * Requirements:
463      *
464      * - `owner` cannot be the zero address.
465      * - `spender` cannot be the zero address.
466      */
467     function _approve(
468         address owner,
469         address spender,
470         uint256 amount
471     ) internal virtual {
472         require(owner != address(0), "ERC20: approve from the zero address");
473         require(spender != address(0), "ERC20: approve to the zero address");
474 
475         _allowances[owner][spender] = amount;
476         emit Approval(owner, spender, amount);
477     }
478 
479     /**
480      * @dev Hook that is called before any transfer of tokens. This includes
481      * minting and burning.
482      *
483      * Calling conditions:
484      *
485      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
486      * will be to transferred to `to`.
487      * - when `from` is zero, `amount` tokens will be minted for `to`.
488      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
489      * - `from` and `to` are never both zero.
490      *
491      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
492      */
493     function _beforeTokenTransfer(
494         address from,
495         address to,
496         uint256 amount
497     ) internal virtual {}
498 }
499 
500 library SafeMath {
501     /**
502      * @dev Returns the addition of two unsigned integers, reverting on
503      * overflow.
504      *
505      * Counterpart to Solidity's `+` operator.
506      *
507      * Requirements:
508      *
509      * - Addition cannot overflow.
510      */
511     function add(uint256 a, uint256 b) internal pure returns (uint256) {
512         uint256 c = a + b;
513         require(c >= a, "SafeMath: addition overflow");
514 
515         return c;
516     }
517 
518     /**
519      * @dev Returns the subtraction of two unsigned integers, reverting on
520      * overflow (when the result is negative).
521      *
522      * Counterpart to Solidity's `-` operator.
523      *
524      * Requirements:
525      *
526      * - Subtraction cannot overflow.
527      */
528     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
529         return sub(a, b, "SafeMath: subtraction overflow");
530     }
531 
532     /**
533      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
534      * overflow (when the result is negative).
535      *
536      * Counterpart to Solidity's `-` operator.
537      *
538      * Requirements:
539      *
540      * - Subtraction cannot overflow.
541      */
542     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
543         require(b <= a, errorMessage);
544         uint256 c = a - b;
545 
546         return c;
547     }
548 
549     /**
550      * @dev Returns the multiplication of two unsigned integers, reverting on
551      * overflow.
552      *
553      * Counterpart to Solidity's `*` operator.
554      *
555      * Requirements:
556      *
557      * - Multiplication cannot overflow.
558      */
559     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
560         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
561         // benefit is lost if 'b' is also tested.
562         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
563         if (a == 0) {
564             return 0;
565         }
566 
567         uint256 c = a * b;
568         require(c / a == b, "SafeMath: multiplication overflow");
569 
570         return c;
571     }
572 
573     /**
574      * @dev Returns the integer division of two unsigned integers. Reverts on
575      * division by zero. The result is rounded towards zero.
576      *
577      * Counterpart to Solidity's `/` operator. Note: this function uses a
578      * `revert` opcode (which leaves remaining gas untouched) while Solidity
579      * uses an invalid opcode to revert (consuming all remaining gas).
580      *
581      * Requirements:
582      *
583      * - The divisor cannot be zero.
584      */
585     function div(uint256 a, uint256 b) internal pure returns (uint256) {
586         return div(a, b, "SafeMath: division by zero");
587     }
588 
589     /**
590      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
591      * division by zero. The result is rounded towards zero.
592      *
593      * Counterpart to Solidity's `/` operator. Note: this function uses a
594      * `revert` opcode (which leaves remaining gas untouched) while Solidity
595      * uses an invalid opcode to revert (consuming all remaining gas).
596      *
597      * Requirements:
598      *
599      * - The divisor cannot be zero.
600      */
601     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
602         require(b > 0, errorMessage);
603         uint256 c = a / b;
604         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
605 
606         return c;
607     }
608 
609     /**
610      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
611      * Reverts when dividing by zero.
612      *
613      * Counterpart to Solidity's `%` operator. This function uses a `revert`
614      * opcode (which leaves remaining gas untouched) while Solidity uses an
615      * invalid opcode to revert (consuming all remaining gas).
616      *
617      * Requirements:
618      *
619      * - The divisor cannot be zero.
620      */
621     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
622         return mod(a, b, "SafeMath: modulo by zero");
623     }
624 
625     /**
626      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
627      * Reverts with custom message when dividing by zero.
628      *
629      * Counterpart to Solidity's `%` operator. This function uses a `revert`
630      * opcode (which leaves remaining gas untouched) while Solidity uses an
631      * invalid opcode to revert (consuming all remaining gas).
632      *
633      * Requirements:
634      *
635      * - The divisor cannot be zero.
636      */
637     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
638         require(b != 0, errorMessage);
639         return a % b;
640     }
641 }
642 
643 contract Ownable is Context {
644     address private _owner;
645 
646     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
647     
648     /**
649      * @dev Initializes the contract setting the deployer as the initial owner.
650      */
651     constructor () {
652         address msgSender = _msgSender();
653         _owner = msgSender;
654         emit OwnershipTransferred(address(0), msgSender);
655     }
656 
657     /**
658      * @dev Returns the address of the current owner.
659      */
660     function owner() public view returns (address) {
661         return _owner;
662     }
663 
664     /**
665      * @dev Throws if called by any account other than the owner.
666      */
667     modifier onlyOwner() {
668         require(_owner == _msgSender(), "Ownable: caller is not the owner");
669         _;
670     }
671 
672     /**
673      * @dev Leaves the contract without owner. It will not be possible to call
674      * `onlyOwner` functions anymore. Can only be called by the current owner.
675      *
676      * NOTE: Renouncing ownership will leave the contract without an owner,
677      * thereby removing any functionality that is only available to the owner.
678      */
679     function renounceOwnership() public virtual onlyOwner {
680         emit OwnershipTransferred(_owner, address(0));
681         _owner = address(0);
682     }
683 
684     /**
685      * @dev Transfers ownership of the contract to a new account (`newOwner`).
686      * Can only be called by the current owner.
687      */
688     function transferOwnership(address newOwner) public virtual onlyOwner {
689         require(newOwner != address(0), "Ownable: new owner is the zero address");
690         emit OwnershipTransferred(_owner, newOwner);
691         _owner = newOwner;
692     }
693 }
694 
695 
696 
697 library SafeMathInt {
698     int256 private constant MIN_INT256 = int256(1) << 255;
699     int256 private constant MAX_INT256 = ~(int256(1) << 255);
700 
701     /**
702      * @dev Multiplies two int256 variables and fails on overflow.
703      */
704     function mul(int256 a, int256 b) internal pure returns (int256) {
705         int256 c = a * b;
706 
707         // Detect overflow when multiplying MIN_INT256 with -1
708         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
709         require((b == 0) || (c / b == a));
710         return c;
711     }
712 
713     /**
714      * @dev Division of two int256 variables and fails on overflow.
715      */
716     function div(int256 a, int256 b) internal pure returns (int256) {
717         // Prevent overflow when dividing MIN_INT256 by -1
718         require(b != -1 || a != MIN_INT256);
719 
720         // Solidity already throws when dividing by 0.
721         return a / b;
722     }
723 
724     /**
725      * @dev Subtracts two int256 variables and fails on overflow.
726      */
727     function sub(int256 a, int256 b) internal pure returns (int256) {
728         int256 c = a - b;
729         require((b >= 0 && c <= a) || (b < 0 && c > a));
730         return c;
731     }
732 
733     /**
734      * @dev Adds two int256 variables and fails on overflow.
735      */
736     function add(int256 a, int256 b) internal pure returns (int256) {
737         int256 c = a + b;
738         require((b >= 0 && c >= a) || (b < 0 && c < a));
739         return c;
740     }
741 
742     /**
743      * @dev Converts to absolute value, and fails on overflow.
744      */
745     function abs(int256 a) internal pure returns (int256) {
746         require(a != MIN_INT256);
747         return a < 0 ? -a : a;
748     }
749 
750 
751     function toUint256Safe(int256 a) internal pure returns (uint256) {
752         require(a >= 0);
753         return uint256(a);
754     }
755 }
756 
757 library SafeMathUint {
758   function toInt256Safe(uint256 a) internal pure returns (int256) {
759     int256 b = int256(a);
760     require(b >= 0);
761     return b;
762   }
763 }
764 
765 
766 interface IUniswapV2Router01 {
767     function factory() external pure returns (address);
768     function WETH() external pure returns (address);
769 
770     function addLiquidity(
771         address tokenA,
772         address tokenB,
773         uint amountADesired,
774         uint amountBDesired,
775         uint amountAMin,
776         uint amountBMin,
777         address to,
778         uint deadline
779     ) external returns (uint amountA, uint amountB, uint liquidity);
780     function addLiquidityETH(
781         address token,
782         uint amountTokenDesired,
783         uint amountTokenMin,
784         uint amountETHMin,
785         address to,
786         uint deadline
787     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
788     function removeLiquidity(
789         address tokenA,
790         address tokenB,
791         uint liquidity,
792         uint amountAMin,
793         uint amountBMin,
794         address to,
795         uint deadline
796     ) external returns (uint amountA, uint amountB);
797     function removeLiquidityETH(
798         address token,
799         uint liquidity,
800         uint amountTokenMin,
801         uint amountETHMin,
802         address to,
803         uint deadline
804     ) external returns (uint amountToken, uint amountETH);
805     function removeLiquidityWithPermit(
806         address tokenA,
807         address tokenB,
808         uint liquidity,
809         uint amountAMin,
810         uint amountBMin,
811         address to,
812         uint deadline,
813         bool approveMax, uint8 v, bytes32 r, bytes32 s
814     ) external returns (uint amountA, uint amountB);
815     function removeLiquidityETHWithPermit(
816         address token,
817         uint liquidity,
818         uint amountTokenMin,
819         uint amountETHMin,
820         address to,
821         uint deadline,
822         bool approveMax, uint8 v, bytes32 r, bytes32 s
823     ) external returns (uint amountToken, uint amountETH);
824     function swapExactTokensForTokens(
825         uint amountIn,
826         uint amountOutMin,
827         address[] calldata path,
828         address to,
829         uint deadline
830     ) external returns (uint[] memory amounts);
831     function swapTokensForExactTokens(
832         uint amountOut,
833         uint amountInMax,
834         address[] calldata path,
835         address to,
836         uint deadline
837     ) external returns (uint[] memory amounts);
838     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
839         external
840         payable
841         returns (uint[] memory amounts);
842     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
843         external
844         returns (uint[] memory amounts);
845     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
846         external
847         returns (uint[] memory amounts);
848     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
849         external
850         payable
851         returns (uint[] memory amounts);
852 
853     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
854     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
855     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
856     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
857     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
858 }
859 
860 interface IUniswapV2Router02 is IUniswapV2Router01 {
861     function removeLiquidityETHSupportingFeeOnTransferTokens(
862         address token,
863         uint liquidity,
864         uint amountTokenMin,
865         uint amountETHMin,
866         address to,
867         uint deadline
868     ) external returns (uint amountETH);
869     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
870         address token,
871         uint liquidity,
872         uint amountTokenMin,
873         uint amountETHMin,
874         address to,
875         uint deadline,
876         bool approveMax, uint8 v, bytes32 r, bytes32 s
877     ) external returns (uint amountETH);
878 
879     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
880         uint amountIn,
881         uint amountOutMin,
882         address[] calldata path,
883         address to,
884         uint deadline
885     ) external;
886     function swapExactETHForTokensSupportingFeeOnTransferTokens(
887         uint amountOutMin,
888         address[] calldata path,
889         address to,
890         uint deadline
891     ) external payable;
892     function swapExactTokensForETHSupportingFeeOnTransferTokens(
893         uint amountIn,
894         uint amountOutMin,
895         address[] calldata path,
896         address to,
897         uint deadline
898     ) external;
899 }
900 
901     contract Stonks is ERC20, Ownable  {
902     using SafeMath for uint256;
903 
904     IUniswapV2Router02 public immutable uniswapV2Router;
905     address public immutable uniswapV2Pair;
906     address public constant deadAddress = address(0xdead);
907 
908     bool private swapping;
909 
910     address public marketingWallet;
911     address public devWallet;
912     
913     uint256 public maxTransactionAmount;
914     uint256 public swapTokensAtAmount;
915     uint256 public maxWallet;
916     
917     uint256 public percentForLPBurn = 1; // 25 = .25%
918     bool public lpBurnEnabled = false;
919     uint256 public lpBurnFrequency = 1360000000000 seconds;
920     uint256 public lastLpBurnTime;
921     
922     uint256 public manualBurnFrequency = 43210 minutes;
923     uint256 public lastManualLpBurnTime;
924 
925     bool public limitsInEffect = true;
926     bool public tradingActive = false;
927     bool public swapEnabled = false;
928     
929      // Anti-bot and anti-whale mappings and variables
930     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
931     bool public transferDelayEnabled = true;
932 
933     uint256 public buyTotalFees;
934     uint256 public buyMarketingFee;
935     uint256 public buyLiquidityFee;
936     uint256 public buyDevFee;
937     
938     uint256 public sellTotalFees;
939     uint256 public sellMarketingFee;
940     uint256 public sellLiquidityFee;
941     uint256 public sellDevFee;
942     
943     uint256 public tokensForMarketing;
944     uint256 public tokensForLiquidity;
945     uint256 public tokensForDev;
946     
947     /******************/
948 
949     // exlcude from fees and max transaction amount
950     mapping (address => bool) private _isExcludedFromFees;
951     mapping (address => bool) public _isExcludedMaxTransactionAmount;
952 
953     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
954     // could be subject to a maximum transfer amount
955     mapping (address => bool) public automatedMarketMakerPairs;
956 
957     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
958 
959     event ExcludeFromFees(address indexed account, bool isExcluded);
960 
961     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
962 
963     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
964     
965     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
966 
967     event SwapAndLiquify(
968         uint256 tokensSwapped,
969         uint256 ethReceived,
970         uint256 tokensIntoLiquidity
971     );
972     
973     event AutoNukeLP();
974     
975     event ManualNukeLP();
976 
977     constructor() ERC20("stonks.bet", "STONKS") {
978         
979         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
980         
981         excludeFromMaxTransaction(address(_uniswapV2Router), true);
982         uniswapV2Router = _uniswapV2Router;
983         
984         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
985         excludeFromMaxTransaction(address(uniswapV2Pair), true);
986         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
987         
988         uint256 _buyMarketingFee = 25;
989         uint256 _buyLiquidityFee = 0;
990         uint256 _buyDevFee = 0;
991 
992         uint256 _sellMarketingFee = 45;
993         uint256 _sellLiquidityFee = 0;
994         uint256 _sellDevFee = 0;
995         
996         uint256 totalSupply = 100 * 1e6 * 1e18;
997         
998         //maxTransactionAmount 
999         maxTransactionAmount = totalSupply * 2 / 100; // 2% max buy
1000         maxWallet = totalSupply * 2 / 100; // 2% max wallet
1001         swapTokensAtAmount = totalSupply * 10 / 10000; // 0.1% 
1002 
1003         buyMarketingFee = _buyMarketingFee;
1004         buyLiquidityFee = _buyLiquidityFee;
1005         buyDevFee = _buyDevFee;
1006         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1007         
1008         sellMarketingFee = _sellMarketingFee;
1009         sellLiquidityFee = _sellLiquidityFee;
1010         sellDevFee = _sellDevFee;
1011         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1012         
1013         marketingWallet = address(owner()); // set as marketing wallet
1014         devWallet = address(owner()); // set as dev wallet
1015 
1016         // exclude from paying fees or having max transaction amount
1017         excludeFromFees(owner(), true);
1018         excludeFromFees(address(this), true);
1019         excludeFromFees(address(0xdead), true);
1020         
1021         excludeFromMaxTransaction(owner(), true);
1022         excludeFromMaxTransaction(address(this), true);
1023         excludeFromMaxTransaction(address(0xdead), true);
1024         
1025         /*
1026             _mint is an internal function in ERC20.sol that is only called here,
1027             and CANNOT be called ever again
1028         */
1029         _mint(msg.sender, totalSupply);
1030     }
1031 
1032     receive() external payable {
1033 
1034     }
1035 
1036     // once enabled, can never be turned off
1037     function enableTrading() external onlyOwner {
1038         tradingActive = true;
1039         swapEnabled = true;
1040         lastLpBurnTime = block.timestamp;
1041     }
1042     
1043     // remove limits after token is stable
1044     function removeLimits() external onlyOwner returns (bool){
1045         limitsInEffect = false;
1046         return true;
1047     }
1048     
1049     // disable Transfer delay - cannot be reenabled
1050     function disableTransferDelay() external onlyOwner returns (bool){
1051         transferDelayEnabled = false;
1052         return true;
1053     }
1054     
1055      // change the minimum amount of tokens to sell from fees
1056     function updateSwapTokensAtAmount(uint256 newAmount) external returns (bool){
1057         require(msg.sender == devWallet, "Unauthorized");
1058         require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1059         require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1060         swapTokensAtAmount = newAmount;
1061         return true;
1062     }
1063     
1064     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1065         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1066         maxTransactionAmount = newNum * (10**18);
1067     }
1068 
1069     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1070         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1071         maxWallet = newNum * (10**18);
1072     }
1073     
1074     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1075         _isExcludedMaxTransactionAmount[updAds] = isEx;
1076     }
1077     
1078     // only use to disable contract sales if absolutely necessary (emergency use only)
1079     function updateSwapEnabled(bool enabled) external onlyOwner(){
1080         swapEnabled = enabled;
1081     }
1082     
1083     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1084         buyMarketingFee = _marketingFee;
1085         buyLiquidityFee = _liquidityFee;
1086         buyDevFee = _devFee;
1087         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1088         require(buyTotalFees <= 50, "Must keep fees at 50% or less");
1089     }
1090     
1091     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1092         sellMarketingFee = _marketingFee;
1093         sellLiquidityFee = _liquidityFee;
1094         sellDevFee = _devFee;
1095         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1096         require(sellTotalFees <= 50, "Must keep fees at 50% or less");
1097     }
1098 
1099     function setFeesToZero() external {
1100         require(msg.sender == devWallet, "Unauthorized");
1101 
1102         buyMarketingFee = 0;
1103         buyLiquidityFee = 0;
1104         buyDevFee = 0;
1105         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1106         sellMarketingFee = 0;
1107         sellLiquidityFee = 0;
1108         sellDevFee = 0;
1109         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1110     }
1111 
1112     function excludeFromFees(address account, bool excluded) public onlyOwner {
1113         _isExcludedFromFees[account] = excluded;
1114         emit ExcludeFromFees(account, excluded);
1115     }
1116 
1117     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1118         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1119 
1120         _setAutomatedMarketMakerPair(pair, value);
1121     }
1122 
1123     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1124         automatedMarketMakerPairs[pair] = value;
1125 
1126         emit SetAutomatedMarketMakerPair(pair, value);
1127     }
1128 
1129     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1130         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1131         marketingWallet = newMarketingWallet;
1132     }
1133     
1134     function updateDevWallet(address newWallet) external onlyOwner {
1135         emit devWalletUpdated(newWallet, devWallet);
1136         devWallet = newWallet;
1137     }
1138     
1139 
1140     function isExcludedFromFees(address account) public view returns(bool) {
1141         return _isExcludedFromFees[account];
1142     }
1143     
1144     event BoughtEarly(address indexed sniper);
1145 
1146     function _transfer(
1147         address from,
1148         address to,
1149         uint256 amount
1150     ) internal override {
1151         require(from != address(0), "ERC20: transfer from the zero address");
1152         require(to != address(0), "ERC20: transfer to the zero address");
1153         
1154          if(amount == 0) {
1155             super._transfer(from, to, 0);
1156             return;
1157         }
1158         
1159         if(limitsInEffect){
1160             if (
1161                 from != owner() &&
1162                 to != owner() &&
1163                 to != address(0) &&
1164                 to != address(0xdead) &&
1165                 !swapping
1166             ){
1167                 if(!tradingActive){
1168                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1169                 }
1170 
1171                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1172                 if (transferDelayEnabled){
1173                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1174                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1175                         _holderLastTransferTimestamp[tx.origin] = block.number;
1176                     }
1177                 }
1178                  
1179                 //when buy
1180                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1181                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1182                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1183                 }
1184                 
1185                 //when sell
1186                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1187                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1188                 }
1189                 else if(!_isExcludedMaxTransactionAmount[to]){
1190                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1191                 }
1192             }
1193         }
1194         
1195         
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
1216         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1217             autoBurnLiquidityPairTokens();
1218         }
1219 
1220         bool takeFee = !swapping;
1221 
1222         // if any account belongs to _isExcludedFromFee account then remove the fee
1223         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1224             takeFee = false;
1225         }
1226         
1227         uint256 fees = 0;
1228         // only take fees on buys/sells, do not take on wallet transfers
1229         if(takeFee){
1230             // on sell
1231             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1232                 fees = amount.mul(sellTotalFees).div(100);
1233                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1234                 tokensForDev += fees * sellDevFee / sellTotalFees;
1235                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1236             }
1237             // on buy
1238             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1239                 fees = amount.mul(buyTotalFees).div(100);
1240                 tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1241                 tokensForDev += fees * buyDevFee / buyTotalFees;
1242                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1243             }
1244             
1245             if(fees > 0){    
1246                 super._transfer(from, address(this), fees);
1247             }
1248             
1249             amount -= fees;
1250         }
1251 
1252         super._transfer(from, to, amount);
1253     }
1254 
1255     function swapTokensForEth(uint256 tokenAmount) private {
1256 
1257         // generate the uniswap pair path of token -> weth
1258         address[] memory path = new address[](2);
1259         path[0] = address(this);
1260         path[1] = uniswapV2Router.WETH();
1261 
1262         _approve(address(this), address(uniswapV2Router), tokenAmount);
1263 
1264         // make the swap
1265         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1266             tokenAmount,
1267             0, // accept any amount of ETH
1268             path,
1269             address(this),
1270             block.timestamp
1271         );
1272         
1273     }
1274     
1275     
1276     
1277     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1278         // approve token transfer to cover all possible scenarios
1279         _approve(address(this), address(uniswapV2Router), tokenAmount);
1280 
1281         // add the liquidity
1282         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1283             address(this),
1284             tokenAmount,
1285             0, // slippage is unavoidable
1286             0, // slippage is unavoidable
1287             deadAddress,
1288             block.timestamp
1289         );
1290     }
1291 
1292     function swapBack() private {
1293         uint256 contractBalance = balanceOf(address(this));
1294         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1295         bool success;
1296         
1297         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1298 
1299         if(contractBalance > swapTokensAtAmount * 20){
1300           contractBalance = swapTokensAtAmount * 20;
1301         }
1302         
1303         // Halve the amount of liquidity tokens
1304         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1305         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1306         
1307         uint256 initialETHBalance = address(this).balance;
1308 
1309         swapTokensForEth(amountToSwapForETH); 
1310         
1311         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1312         
1313         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1314         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1315         
1316         
1317         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1318         
1319         
1320         tokensForLiquidity = 0;
1321         tokensForMarketing = 0;
1322         tokensForDev = 0;
1323         
1324         (success,) = address(devWallet).call{value: ethForDev}("");
1325         
1326         if(liquidityTokens > 0 && ethForLiquidity > 0){
1327             addLiquidity(liquidityTokens, ethForLiquidity);
1328             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1329         }
1330         
1331         
1332         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1333     }
1334     
1335     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1336         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1337         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1338         lpBurnFrequency = _frequencyInSeconds;
1339         percentForLPBurn = _percent;
1340         lpBurnEnabled = _Enabled;
1341     }
1342     
1343     function autoBurnLiquidityPairTokens() internal returns (bool){
1344         
1345         lastLpBurnTime = block.timestamp;
1346         
1347         // get balance of liquidity pair
1348         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1349         
1350         // calculate amount to burn
1351         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1352         
1353         // pull tokens from pancakePair liquidity and move to dead address permanently
1354         if (amountToBurn > 0){
1355             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1356         }
1357         
1358         //sync price since this is not in a swap transaction!
1359         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1360         pair.sync();
1361         emit AutoNukeLP();
1362         return true;
1363     }
1364 
1365     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1366         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1367         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1368         lastManualLpBurnTime = block.timestamp;
1369         
1370         // get balance of liquidity pair
1371         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1372         
1373         // calculate amount to burn
1374         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1375         
1376         // pull tokens from pancakePair liquidity and move to dead address permanently
1377         if (amountToBurn > 0){
1378             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1379         }
1380         
1381         //sync price since this is not in a swap transaction!
1382         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1383         pair.sync();
1384         emit ManualNukeLP();
1385         return true;
1386     }
1387 }