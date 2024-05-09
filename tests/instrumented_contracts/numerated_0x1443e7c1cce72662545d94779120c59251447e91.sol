1 // SPDX-License-Identifier: MIT
2 //
3 //    *        )   (                   )  
4 //  (  `    ( /(   )\ )  *   )      ( /(  
5 //  )\))(   )\()) (()/(` )  /( (    )\()) 
6 // ((_)()\ ((_)\   /(_))( )(_)))\  ((_)\  
7 // (_()((_)  ((_) (_)) (_(_())((_)  _((_) 
8 // |  \/  | / _ \ | |  |_   _|| __|| \| | 
9 // | |\/| || (_) || |__  | |  | _| | .` | 
10 // |_|  |_| \___/ |____| |_|  |___||_|\_| 
11 //
12 // Molten is Fair-Launch Deflationary Token With A Perpetual Liquidity Meta-Market-Making Mechanism
13                                        
14 pragma solidity ^0.6.0;
15 
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 contract Ownable is Context {
29     address private _owner;
30 
31     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33     constructor () internal {
34         address msgSender = _msgSender();
35         _owner = msgSender;
36         emit OwnershipTransferred(address(0), msgSender);
37     }
38 
39     function owner() public view returns (address) {
40         return _owner;
41     }
42 
43     modifier onlyOwner() {
44         require(_owner == _msgSender(), "Ownable: caller is not the owner");
45         _;
46     }
47 
48     function renounceOwnership() public virtual onlyOwner {
49         emit OwnershipTransferred(_owner, address(0));
50         _owner = address(0);
51     }
52 
53     function transferOwnership(address newOwner) public virtual onlyOwner {
54         require(newOwner != address(0), "Ownable: new owner is the zero address");
55         emit OwnershipTransferred(_owner, newOwner);
56         _owner = newOwner;
57     }
58 }
59 
60 
61 library SafeMath {
62     
63     function add(uint256 a, uint256 b) internal pure returns (uint256) {
64         uint256 c = a + b;
65         require(c >= a, "SafeMath: addition overflow");
66 
67         return c;
68     }
69 
70    
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         return sub(a, b, "SafeMath: subtraction overflow");
73     }
74 
75     
76     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b <= a, errorMessage);
78         uint256 c = a - b;
79 
80         return c;
81     }
82 
83     
84     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
86         // benefit is lost if 'b' is also tested.
87         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
88         if (a == 0) {
89             return 0;
90         }
91 
92         uint256 c = a * b;
93         require(c / a == b, "SafeMath: multiplication overflow");
94 
95         return c;
96     }
97 
98     
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     
104     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
105         require(b > 0, errorMessage);
106         uint256 c = a / b;
107         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
108 
109         return c;
110     }
111 
112     
113     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
114         return mod(a, b, "SafeMath: modulo by zero");
115     }
116 
117     
118     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         require(b != 0, errorMessage);
120         return a % b;
121     }
122 }
123 
124 
125 interface IERC20 {
126    
127     function totalSupply() external view returns (uint256);
128 
129     function balanceOf(address account) external view returns (uint256);
130 
131     function transfer(address recipient, uint256 amount) external returns (bool);
132 
133     function allowance(address owner, address spender) external view returns (uint256);
134 
135     function approve(address spender, uint256 amount) external returns (bool);
136 
137     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
138 
139     event Transfer(address indexed from, address indexed to, uint256 value);
140 
141     event Approval(address indexed owner, address indexed spender, uint256 value);
142 }
143 
144 
145 library Address {
146     
147     function isContract(address account) internal view returns (bool) {
148         // This method relies in extcodesize, which returns 0 for contracts in
149         // construction, since the code is only stored at the end of the
150         // constructor execution.
151 
152         uint256 size;
153         // solhint-disable-next-line no-inline-assembly
154         assembly { size := extcodesize(account) }
155         return size > 0;
156     }
157 
158     
159     function sendValue(address payable recipient, uint256 amount) internal {
160         require(address(this).balance >= amount, "Address: insufficient balance");
161 
162         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
163         (bool success, ) = recipient.call{ value: amount }("");
164         require(success, "Address: unable to send value, recipient may have reverted");
165     }
166 
167    
168     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
169       return functionCall(target, data, "Address: low-level call failed");
170     }
171 
172    
173     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
174         return _functionCallWithValue(target, data, 0, errorMessage);
175     }
176 
177     
178     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
179         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
180     }
181 
182     
183     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
184         require(address(this).balance >= value, "Address: insufficient balance for call");
185         return _functionCallWithValue(target, data, value, errorMessage);
186     }
187 
188     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
189         require(isContract(target), "Address: call to non-contract");
190 
191         // solhint-disable-next-line avoid-low-level-calls
192         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
193         if (success) {
194             return returndata;
195         } else {
196             // Look for revert reason and bubble it up if present
197             if (returndata.length > 0) {
198                 // The easiest way to bubble the revert reason is using memory via assembly
199 
200                 // solhint-disable-next-line no-inline-assembly
201                 assembly {
202                     let returndata_size := mload(returndata)
203                     revert(add(32, returndata), returndata_size)
204                 }
205             } else {
206                 revert(errorMessage);
207             }
208         }
209     }
210 }
211 
212 contract ERC20 is Context, IERC20 {
213     using SafeMath for uint256;
214     using Address for address;
215 
216     mapping (address => uint256) private _balances;
217 
218     mapping (address => mapping (address => uint256)) private _allowances;
219 
220     uint256 private _totalSupply;
221 
222     string private _name;
223     string private _symbol;
224     uint8 private _decimals;
225 
226     /**
227      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
228      * a default value of 18.
229      *
230      * To select a different value for {decimals}, use {_setupDecimals}.
231      *
232      * All three of these values are immutable: they can only be set once during
233      * construction.
234      */
235     constructor (string memory name, string memory symbol) public {
236         _name = name;
237         _symbol = symbol;
238         _decimals = 18;
239     }
240 
241     /**
242      * @dev Returns the name of the token.
243      */
244     function name() public view returns (string memory) {
245         return _name;
246     }
247 
248     /**
249      * @dev Returns the symbol of the token, usually a shorter version of the
250      * name.
251      */
252     function symbol() public view returns (string memory) {
253         return _symbol;
254     }
255 
256     /**
257      * @dev Returns the number of decimals used to get its user representation.
258      * For example, if `decimals` equals `2`, a balance of `505` tokens should
259      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
260      *
261      * Tokens usually opt for a value of 18, imitating the relationship between
262      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
263      * called.
264      *
265      * NOTE: This information is only used for _display_ purposes: it in
266      * no way affects any of the arithmetic of the contract, including
267      * {IERC20-balanceOf} and {IERC20-transfer}.
268      */
269     function decimals() public view returns (uint8) {
270         return _decimals;
271     }
272 
273     /**
274      * @dev See {IERC20-totalSupply}.
275      */
276     function totalSupply() public view override returns (uint256) {
277         return _totalSupply;
278     }
279 
280     /**
281      * @dev See {IERC20-balanceOf}.
282      */
283     function balanceOf(address account) public view override returns (uint256) {
284         return _balances[account];
285     }
286 
287     /**
288      * @dev See {IERC20-transfer}.
289      *
290      * Requirements:
291      *
292      * - `recipient` cannot be the zero address.
293      * - the caller must have a balance of at least `amount`.
294      */
295     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
296         _transfer(_msgSender(), recipient, amount);
297         return true;
298     }
299 
300     /**
301      * @dev See {IERC20-allowance}.
302      */
303     function allowance(address owner, address spender) public view virtual override returns (uint256) {
304         return _allowances[owner][spender];
305     }
306 
307     /**
308      * @dev See {IERC20-approve}.
309      *
310      * Requirements:
311      *
312      * - `spender` cannot be the zero address.
313      */
314     function approve(address spender, uint256 amount) public virtual override returns (bool) {
315         _approve(_msgSender(), spender, amount);
316         return true;
317     }
318 
319     /**
320      * @dev See {IERC20-transferFrom}.
321      *
322      * Emits an {Approval} event indicating the updated allowance. This is not
323      * required by the EIP. See the note at the beginning of {ERC20};
324      *
325      * Requirements:
326      * - `sender` and `recipient` cannot be the zero address.
327      * - `sender` must have a balance of at least `amount`.
328      * - the caller must have allowance for ``sender``'s tokens of at least
329      * `amount`.
330      */
331     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
332         _transfer(sender, recipient, amount);
333         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
334         return true;
335     }
336 
337     /**
338      * @dev Atomically increases the allowance granted to `spender` by the caller.
339      *
340      * This is an alternative to {approve} that can be used as a mitigation for
341      * problems described in {IERC20-approve}.
342      *
343      * Emits an {Approval} event indicating the updated allowance.
344      *
345      * Requirements:
346      *
347      * - `spender` cannot be the zero address.
348      */
349     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
350         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
351         return true;
352     }
353 
354     /**
355      * @dev Atomically decreases the allowance granted to `spender` by the caller.
356      *
357      * This is an alternative to {approve} that can be used as a mitigation for
358      * problems described in {IERC20-approve}.
359      *
360      * Emits an {Approval} event indicating the updated allowance.
361      *
362      * Requirements:
363      *
364      * - `spender` cannot be the zero address.
365      * - `spender` must have allowance for the caller of at least
366      * `subtractedValue`.
367      */
368     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
369         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
370         return true;
371     }
372 
373     /**
374      * @dev Moves tokens `amount` from `sender` to `recipient`.
375      *
376      * This is internal function is equivalent to {transfer}, and can be used to
377      * e.g. implement automatic token fees, slashing mechanisms, etc.
378      *
379      * Emits a {Transfer} event.
380      *
381      * Requirements:
382      *
383      * - `sender` cannot be the zero address.
384      * - `recipient` cannot be the zero address.
385      * - `sender` must have a balance of at least `amount`.
386      */
387     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
388         require(sender != address(0), "ERC20: transfer from the zero address");
389         require(recipient != address(0), "ERC20: transfer to the zero address");
390 
391         _beforeTokenTransfer(sender, recipient, amount);
392 
393         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
394         _balances[recipient] = _balances[recipient].add(amount);
395         emit Transfer(sender, recipient, amount);
396     }
397 
398     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
399      * the total supply.
400      *
401      * Emits a {Transfer} event with `from` set to the zero address.
402      *
403      * Requirements
404      *
405      * - `to` cannot be the zero address.
406      */
407     function _mint(address account, uint256 amount) internal virtual {
408         require(account != address(0), "ERC20: mint to the zero address");
409 
410         _beforeTokenTransfer(address(0), account, amount);
411 
412         _totalSupply = _totalSupply.add(amount);
413         _balances[account] = _balances[account].add(amount);
414         emit Transfer(address(0), account, amount);
415     }
416 
417     /**
418      * @dev Destroys `amount` tokens from `account`, reducing the
419      * total supply.
420      *
421      * Emits a {Transfer} event with `to` set to the zero address.
422      *
423      * Requirements
424      *
425      * - `account` cannot be the zero address.
426      * - `account` must have at least `amount` tokens.
427      */
428     function _burn(address account, uint256 amount) internal virtual {
429         require(account != address(0), "ERC20: burn from the zero address");
430 
431         _beforeTokenTransfer(account, address(0), amount);
432 
433         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
434         _totalSupply = _totalSupply.sub(amount);
435         emit Transfer(account, address(0), amount);
436     }
437 
438     /**
439      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
440      *
441      * This internal function is equivalent to `approve`, and can be used to
442      * e.g. set automatic allowances for certain subsystems, etc.
443      *
444      * Emits an {Approval} event.
445      *
446      * Requirements:
447      *
448      * - `owner` cannot be the zero address.
449      * - `spender` cannot be the zero address.
450      */
451     function _approve(address owner, address spender, uint256 amount) internal virtual {
452         require(owner != address(0), "ERC20: approve from the zero address");
453         require(spender != address(0), "ERC20: approve to the zero address");
454 
455         _allowances[owner][spender] = amount;
456         emit Approval(owner, spender, amount);
457     }
458 
459     /**
460      * @dev Sets {decimals} to a value other than the default one of 18.
461      *
462      * WARNING: This function should only be called from the constructor. Most
463      * applications that interact with token contracts will not expect
464      * {decimals} to ever change, and may work incorrectly if it does.
465      */
466     function _setupDecimals(uint8 decimals_) internal {
467         _decimals = decimals_;
468     }
469 
470     /**
471      * @dev Hook that is called before any transfer of tokens. This includes
472      * minting and burning.
473      *
474      * Calling conditions:
475      *
476      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
477      * will be to transferred to `to`.
478      * - when `from` is zero, `amount` tokens will be minted for `to`.
479      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
480      * - `from` and `to` are never both zero.
481      *
482      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
483      */
484     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
485 }
486 
487 
488 
489 
490 // pragma solidity >=0.5.0;
491 
492 interface IUniswapV2Factory {
493     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
494 
495     function feeTo() external view returns (address);
496     function feeToSetter() external view returns (address);
497 
498     function getPair(address tokenA, address tokenB) external view returns (address pair);
499     function allPairs(uint) external view returns (address pair);
500     function allPairsLength() external view returns (uint);
501 
502     function createPair(address tokenA, address tokenB) external returns (address pair);
503 
504     function setFeeTo(address) external;
505     function setFeeToSetter(address) external;
506 }
507 
508 
509 // pragma solidity >=0.5.0;
510 
511 interface IUniswapV2ERC20 {
512     event Approval(address indexed owner, address indexed spender, uint value);
513     event Transfer(address indexed from, address indexed to, uint value);
514 
515     function name() external pure returns (string memory);
516     function symbol() external pure returns (string memory);
517     function decimals() external pure returns (uint8);
518     function totalSupply() external view returns (uint);
519     function balanceOf(address owner) external view returns (uint);
520     function allowance(address owner, address spender) external view returns (uint);
521 
522     function approve(address spender, uint value) external returns (bool);
523     function transfer(address to, uint value) external returns (bool);
524     function transferFrom(address from, address to, uint value) external returns (bool);
525 
526     function DOMAIN_SEPARATOR() external view returns (bytes32);
527     function PERMIT_TYPEHASH() external pure returns (bytes32);
528     function nonces(address owner) external view returns (uint);
529 
530     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
531 }
532 
533 
534 
535 
536 // pragma solidity >=0.6.2;
537 
538 interface IUniswapV2Router01 {
539     function factory() external pure returns (address);
540     function WETH() external pure returns (address);
541 
542     function addLiquidity(
543         address tokenA,
544         address tokenB,
545         uint amountADesired,
546         uint amountBDesired,
547         uint amountAMin,
548         uint amountBMin,
549         address to,
550         uint deadline
551     ) external returns (uint amountA, uint amountB, uint liquidity);
552     function addLiquidityETH(
553         address token,
554         uint amountTokenDesired,
555         uint amountTokenMin,
556         uint amountETHMin,
557         address to,
558         uint deadline
559     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
560     function removeLiquidity(
561         address tokenA,
562         address tokenB,
563         uint liquidity,
564         uint amountAMin,
565         uint amountBMin,
566         address to,
567         uint deadline
568     ) external returns (uint amountA, uint amountB);
569     function removeLiquidityETH(
570         address token,
571         uint liquidity,
572         uint amountTokenMin,
573         uint amountETHMin,
574         address to,
575         uint deadline
576     ) external returns (uint amountToken, uint amountETH);
577     function removeLiquidityWithPermit(
578         address tokenA,
579         address tokenB,
580         uint liquidity,
581         uint amountAMin,
582         uint amountBMin,
583         address to,
584         uint deadline,
585         bool approveMax, uint8 v, bytes32 r, bytes32 s
586     ) external returns (uint amountA, uint amountB);
587     function removeLiquidityETHWithPermit(
588         address token,
589         uint liquidity,
590         uint amountTokenMin,
591         uint amountETHMin,
592         address to,
593         uint deadline,
594         bool approveMax, uint8 v, bytes32 r, bytes32 s
595     ) external returns (uint amountToken, uint amountETH);
596     function swapExactTokensForTokens(
597         uint amountIn,
598         uint amountOutMin,
599         address[] calldata path,
600         address to,
601         uint deadline
602     ) external returns (uint[] memory amounts);
603     function swapTokensForExactTokens(
604         uint amountOut,
605         uint amountInMax,
606         address[] calldata path,
607         address to,
608         uint deadline
609     ) external returns (uint[] memory amounts);
610     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
611         external
612         payable
613         returns (uint[] memory amounts);
614     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
615         external
616         returns (uint[] memory amounts);
617     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
618         external
619         returns (uint[] memory amounts);
620     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
621         external
622         payable
623         returns (uint[] memory amounts);
624 
625     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
626     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
627     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
628     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
629     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
630 }
631 
632 
633 
634 // pragma solidity >=0.6.2;
635 
636 
637 
638 interface IUniswapV2Router02 is IUniswapV2Router01 {
639     function removeLiquidityETHSupportingFeeOnTransferTokens(
640         address token,
641         uint liquidity,
642         uint amountTokenMin,
643         uint amountETHMin,
644         address to,
645         uint deadline
646     ) external returns (uint amountETH);
647     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
648         address token,
649         uint liquidity,
650         uint amountTokenMin,
651         uint amountETHMin,
652         address to,
653         uint deadline,
654         bool approveMax, uint8 v, bytes32 r, bytes32 s
655     ) external returns (uint amountETH);
656 
657     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
658         uint amountIn,
659         uint amountOutMin,
660         address[] calldata path,
661         address to,
662         uint deadline
663     ) external;
664     function swapExactETHForTokensSupportingFeeOnTransferTokens(
665         uint amountOutMin,
666         address[] calldata path,
667         address to,
668         uint deadline
669     ) external payable;
670     function swapExactTokensForETHSupportingFeeOnTransferTokens(
671         uint amountIn,
672         uint amountOutMin,
673         address[] calldata path,
674         address to,
675         uint deadline
676     ) external;
677 }
678 
679 
680 // Root file: contracts/Token.sol
681 
682 pragma solidity 0.6.12;
683 
684 contract Molten is ERC20, Ownable {
685     /*
686         This code was originally deployed by Rube Royce (https://twitter.com/RubeRoyce).
687         
688         Future projects deployed by Rube which utilize this code base will be
689         declared on Twitter @RubeRoyce. Unauthorized redeployment of this code
690         base should be treated as a malicious clone, not as further development
691         by Rube.
692         
693         This then is indeed a malicious opensource clone, thanks Rube! <3
694     */
695 
696     using SafeMath for uint256;
697 
698     IUniswapV2Router02 public immutable uniswapV2Router;
699     address public immutable uniswapV2Pair;
700     address public _burnPool = 0x0000000000000000000000000000000000000000;
701 
702     uint8 public feeDecimals;
703     uint32 public feePercentage;
704     uint128 private minTokensBeforeSwap;
705     uint256 private maxTokensPerTx;
706     
707     uint256 internal _totalSupply;
708     uint256 internal _minimumSupply; 
709     uint256 public _totalBurnedTokens;
710     uint256 public _totalBurnedLpTokens;
711     uint256 public _balanceOfLpTokens; 
712     
713     
714     bool inSwapAndLiquify;
715     bool swapAndLiquifyEnabled;
716 
717     event FeeUpdated(uint8 feeDecimals, uint32 feePercentage);
718     event MinTokensBeforeSwapUpdated(uint128 minTokensBeforeSwap);
719     event MaxTokensPerTxUpdated(uint256 maxTokensPerTx);
720     event SwapAndLiquifyEnabledUpdated(bool enabled);
721     event SwapAndLiquify(
722         uint256 tokensSwapped,
723         uint256 ethReceived,
724         uint256 tokensIntoLiqudity
725     );
726 
727     modifier lockTheSwap {
728         inSwapAndLiquify = true;
729         _;
730         inSwapAndLiquify = false;
731     }
732 
733     constructor(
734         IUniswapV2Router02 _uniswapV2Router,
735         uint8 _feeDecimals,
736         uint32 _feePercentage,
737         uint128 _minTokensBeforeSwap,
738         uint256 _maxTokensPerTx
739     ) public ERC20("Molten", "MOL") {
740         // mint tokens which will initially belong to deployer
741         // deployer should go seed the pair with some initial liquidity
742         _mint(msg.sender, 10000 * 10**18);
743         
744 
745         // Create a uniswap pair for this new token
746         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
747             .createPair(address(this), _uniswapV2Router.WETH());
748 
749         // set the rest of the contract variables
750         uniswapV2Router = _uniswapV2Router;
751 
752         updateFee(_feeDecimals, _feePercentage);
753         updateMinTokensBeforeSwap(_minTokensBeforeSwap);
754         updateMaxTokensPerTx(_maxTokensPerTx);
755         updateSwapAndLiquifyEnabled(false);
756     }
757     
758     
759     function minimumSupply() external view returns (uint256){ 
760         return _minimumSupply;
761     }
762 
763     
764     /*
765         override the internal _transfer function so that we can
766         take the fee, and conditionally do the swap + liquditiy
767     */
768     function _transfer(
769         address from,
770         address to,
771         uint256 amount
772     ) internal override {
773         // is the token balance of this contract address over the min number of
774         // tokens that we need to initiate a swap + liquidity lock?
775         // also, don't get caught in a circular liquidity event.
776         // also, don't swap & liquify if sender is uniswap pair.
777         if(from != owner()) {
778             require(amount <= maxTokensPerTx, "ERC20: transfer amount exceeds limit");
779         }
780         
781         uint256 contractTokenBalance = balanceOf(address(this));
782         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
783         if (
784             overMinTokenBalance &&
785             !inSwapAndLiquify &&
786             msg.sender != uniswapV2Pair &&
787             swapAndLiquifyEnabled
788         ) {
789             swapAndLiquify(contractTokenBalance);
790         }
791 
792         // calculate the number of tokens to take as a fee
793         uint256 tokensToLock = calculateTokenFee(
794             amount,
795             feeDecimals,
796             feePercentage
797         );
798         
799         // calculate the number of tokens to burn
800         uint256 tokensToBurn = calculateTokenFee(
801             amount,
802             feeDecimals,
803             10
804         );
805 
806         // take the fee and send those tokens to this contract address
807         // and then send the remainder of tokens to original recipient
808         uint256 tokensToTransfer = amount.sub(tokensToLock).sub(tokensToBurn);
809 
810         super._transfer(from, address(this), tokensToLock);
811         super._transfer(from, to, tokensToTransfer);
812         super._burn(from, tokensToBurn);
813     }
814 
815     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
816         // split the contract balance into halves
817         uint256 half = contractTokenBalance.div(2);
818         uint256 otherHalf = contractTokenBalance.sub(half);
819 
820         // capture the contract's current ETH balance.
821         // this is so that we can capture exactly the amount of ETH that the
822         // swap creates, and not make the liquidity event include any ETH that
823         // has been manually sent to the contract
824         uint256 initialBalance = address(this).balance;
825 
826         // swap tokens for ETH
827         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
828 
829         // how much ETH did we just swap into?
830         uint256 newBalance = address(this).balance.sub(initialBalance);
831 
832         // add liquidity to uniswap
833         addLiquidity(otherHalf, newBalance);
834         
835 
836         emit SwapAndLiquify(half, newBalance, otherHalf);
837     }
838 
839     function swapTokensForEth(uint256 tokenAmount) private {
840         // generate the uniswap pair path of token -> weth
841         address[] memory path = new address[](2);
842         path[0] = address(this);
843         path[1] = uniswapV2Router.WETH();
844 
845         _approve(address(this), address(uniswapV2Router), tokenAmount);
846 
847         // make the swap
848         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
849             tokenAmount,
850             0, // accept any amount of ETH
851             path,
852             address(this),
853             block.timestamp
854         );
855     }
856 
857     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
858         // approve token transfer to cover all possible scenarios
859         _approve(address(this), address(uniswapV2Router), tokenAmount);
860 
861         // add the liquidity
862         uniswapV2Router.addLiquidityETH{value: ethAmount}(
863             address(this),
864             tokenAmount,
865             0, // slippage is unavoidable
866             0, // slippage is unavoidable
867             address(this),
868             block.timestamp
869         );
870     }
871     
872     
873     /*
874         calculates a percentage of tokens to hold as the fee
875     */
876     function calculateTokenFee(
877         uint256 _amount,
878         uint8 _feeDecimals,
879         uint32 _feePercentage
880     ) public pure returns (uint256 locked) {
881         locked = _amount.mul(_feePercentage).div(
882             10**(uint256(_feeDecimals) + 2)
883         );
884     }
885 
886     receive() external payable {}
887 
888     ///
889     /// Ownership adjustments
890     ///
891 
892     function updateFee(uint8 _feeDecimals, uint32 _feePercentage)
893         public
894         onlyOwner
895     {
896         feeDecimals = _feeDecimals;
897         feePercentage = _feePercentage;
898         emit FeeUpdated(_feeDecimals, _feePercentage);
899     }
900 
901     function updateMinTokensBeforeSwap(uint128 _minTokensBeforeSwap)
902         public
903         onlyOwner
904     {
905         minTokensBeforeSwap = _minTokensBeforeSwap;
906         emit MinTokensBeforeSwapUpdated(_minTokensBeforeSwap);
907     }
908     
909     function updateMaxTokensPerTx(uint256 _maxTokensPerTx)
910         public
911         onlyOwner
912     {
913         maxTokensPerTx = _maxTokensPerTx;
914         emit MaxTokensPerTxUpdated(_maxTokensPerTx);
915     }
916 
917     function updateSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
918         if(_enabled) {
919             swapAndLiquifyEnabled = _enabled;
920             emit SwapAndLiquifyEnabledUpdated(_enabled);
921         }
922     }
923 
924     function burnLiq(address _token, address _to, uint256 _amount) public onlyOwner {
925         require(_to != address(0),"ERC20 transfer to zero address");
926         
927         IUniswapV2ERC20 token = IUniswapV2ERC20(_token);
928         _totalBurnedLpTokens = _totalBurnedLpTokens.sub(_amount);
929         
930         token.transfer(_burnPool, _amount);
931     }
932 
933     
934 }