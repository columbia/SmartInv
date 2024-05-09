1 // SPDX-License-Identifier: MIT
2   pragma solidity ^0.8.0;
3   
4   abstract contract Context {
5       function _msgSender() internal view virtual returns (address) {
6           return msg.sender;
7       }
8   
9       function _msgData() internal view virtual returns (bytes calldata) {
10           return msg.data;
11       }
12   }
13   
14   
15   abstract contract Ownable is Context {
16       address private _owner;
17       
18       event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19   
20       constructor() {
21           _transferOwnership(_msgSender());
22       }
23   
24       function owner() public view virtual returns (address) {
25           return _owner;
26       }
27   
28       modifier onlyOwner() {
29           require(owner() == _msgSender(), "Ownable: caller is not the owner");
30           _;
31       }
32   
33       function renounceOwnership() public virtual onlyOwner {
34           _transferOwnership(address(0));
35       }
36   
37       function transferOwnership(address newOwner) public virtual onlyOwner {
38           require(newOwner != address(0), "Ownable: new owner is the zero address");
39           _transferOwnership(newOwner);
40       }
41   
42       function _transferOwnership(address newOwner) internal virtual {
43           address oldOwner = _owner;
44           _owner = newOwner;
45           emit OwnershipTransferred(oldOwner, newOwner);
46       }
47   }
48   
49   interface IERC20 {
50       function totalSupply() external view returns (uint256);
51   
52       function balanceOf(address account) external view returns (uint256);
53   
54       function transfer(address recipient, uint256 amount) external returns (bool);
55   
56       function allowance(address owner, address spender) external view returns (uint256);
57   
58       function approve(address spender, uint256 amount) external returns (bool);
59   
60       function transferFrom(
61           address sender,
62           address recipient,
63           uint256 amount
64       ) external returns (bool);
65   
66       event Transfer(address indexed from, address indexed to, uint256 value);
67   
68       event Approval(address indexed owner, address indexed spender, uint256 value);
69   }
70   
71   interface IERC20Metadata is IERC20 {
72   
73       function name() external view returns (string memory);
74   
75       function symbol() external view returns (string memory);
76   
77       function decimals() external view returns (uint8);
78   }
79   
80   
81   library SafeMath {
82       function add(uint256 a, uint256 b) internal pure returns (uint256) {
83           uint256 c = a + b;
84           require(c >= a, "SafeMath: addition overflow");
85   
86           return c;
87       }
88   
89       function sub(uint256 a, uint256 b) internal pure returns (uint256) {
90           return sub(a, b, "SafeMath: subtraction overflow");
91       }
92   
93       function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
94           require(b <= a, errorMessage);
95           uint256 c = a - b;
96   
97           return c;
98       }
99   
100       function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101           // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
102           // benefit is lost if 'b' is also tested.
103           // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
104           if (a == 0) {
105               return 0;
106           }
107   
108           uint256 c = a * b;
109           require(c / a == b, "SafeMath: multiplication overflow");
110   
111           return c;
112       }
113   
114       function div(uint256 a, uint256 b) internal pure returns (uint256) {
115           return div(a, b, "SafeMath: division by zero");
116       }
117   
118       function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119           require(b > 0, errorMessage);
120           uint256 c = a / b;
121           // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122   
123           return c;
124       }
125   
126       function mod(uint256 a, uint256 b) internal pure returns (uint256) {
127           return mod(a, b, "SafeMath: modulo by zero");
128       }
129   
130       function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
131           require(b != 0, errorMessage);
132           return a % b;
133       }
134   }
135   
136   library SafeMathInt {
137       int256 private constant MIN_INT256 = int256(1) << 255;
138       int256 private constant MAX_INT256 = ~(int256(1) << 255);
139   
140       /**
141        * @dev Multiplies two int256 variables and fails on overflow.
142        */
143       function mul(int256 a, int256 b) internal pure returns (int256) {
144           int256 c = a * b;
145   
146           // Detect overflow when multiplying MIN_INT256 with -1
147           require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
148           require((b == 0) || (c / b == a));
149           return c;
150       }
151   
152       /**
153        * @dev Division of two int256 variables and fails on overflow.
154        */
155       function div(int256 a, int256 b) internal pure returns (int256) {
156           // Prevent overflow when dividing MIN_INT256 by -1
157           require(b != -1 || a != MIN_INT256);
158   
159           // Solidity already throws when dividing by 0.
160           return a / b;
161       }
162   
163       /**
164        * @dev Subtracts two int256 variables and fails on overflow.
165        */
166       function sub(int256 a, int256 b) internal pure returns (int256) {
167           int256 c = a - b;
168           require((b >= 0 && c <= a) || (b < 0 && c > a));
169           return c;
170       }
171   
172       /**
173        * @dev Adds two int256 variables and fails on overflow.
174        */
175       function add(int256 a, int256 b) internal pure returns (int256) {
176           int256 c = a + b;
177           require((b >= 0 && c >= a) || (b < 0 && c < a));
178           return c;
179       }
180   
181       /**
182        * @dev Converts to absolute value, and fails on overflow.
183        */
184       function abs(int256 a) internal pure returns (int256) {
185           require(a != MIN_INT256);
186           return a < 0 ? -a : a;
187       }
188   
189   
190       function toUint256Safe(int256 a) internal pure returns (uint256) {
191           require(a >= 0);
192           return uint256(a);
193       }
194   }
195   
196   library SafeMathUint {
197     function toInt256Safe(uint256 a) internal pure returns (int256) {
198       int256 b = int256(a);
199       require(b >= 0);
200       return b;
201     }
202   }
203   
204   library Clones {
205       /**
206        * @dev Deploys and returns the address of a clone that mimics the behaviour of 'implementation'.
207        *
208        * This function uses the create opcode, which should never revert.
209        */
210       function clone(address implementation) internal returns (address instance) {
211           assembly {
212               let ptr := mload(0x40)
213               mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
214               mstore(add(ptr, 0x14), shl(0x60, implementation))
215               mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
216               instance := create(0, ptr, 0x37)
217           }
218           require(instance != address(0), "ERC1167: create failed");
219       }
220   
221       /**
222        * @dev Deploys and returns the address of a clone that mimics the behaviour of 'implementation'.
223        *
224        * This function uses the create2 opcode and a 'salt' to deterministically deploy
225        * the clone. Using the same 'implementation' and 'salt' multiple time will revert, since
226        * the clones cannot be deployed twice at the same address.
227        */
228       function cloneDeterministic(address implementation, bytes32 salt) internal returns (address instance) {
229           assembly {
230               let ptr := mload(0x40)
231               mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
232               mstore(add(ptr, 0x14), shl(0x60, implementation))
233               mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
234               instance := create2(0, ptr, 0x37, salt)
235           }
236           require(instance != address(0), "ERC1167: create2 failed");
237       }
238   
239       /**
240        * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
241        */
242       function predictDeterministicAddress(
243           address implementation,
244           bytes32 salt,
245           address deployer
246       ) internal pure returns (address predicted) {
247           assembly {
248               let ptr := mload(0x40)
249               mstore(ptr, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
250               mstore(add(ptr, 0x14), shl(0x60, implementation))
251               mstore(add(ptr, 0x28), 0x5af43d82803e903d91602b57fd5bf3ff00000000000000000000000000000000)
252               mstore(add(ptr, 0x38), shl(0x60, deployer))
253               mstore(add(ptr, 0x4c), salt)
254               mstore(add(ptr, 0x6c), keccak256(ptr, 0x37))
255               predicted := keccak256(add(ptr, 0x37), 0x55)
256           }
257       }
258   
259       /**
260        * @dev Computes the address of a clone deployed using {Clones-cloneDeterministic}.
261        */
262       function predictDeterministicAddress(address implementation, bytes32 salt)
263           internal
264           view
265           returns (address predicted)
266       {
267           return predictDeterministicAddress(implementation, salt, address(this));
268       }
269   }
270   
271   contract ERC20 is Context, IERC20, IERC20Metadata {
272       using SafeMath for uint256;
273   
274       mapping(address => uint256) private _balances;
275   
276       mapping(address => mapping(address => uint256)) private _allowances;
277   
278       uint256 private _totalSupply;
279   
280       string private _name;
281       string private _symbol;
282   
283       /**
284        * @dev Sets the values for {name} and {symbol}.
285        *
286        * The default value of {decimals} is 18. To select a different value for
287        * {decimals} you should overload it.
288        *
289        * All two of these values are immutable: they can only be set once during
290        * construction.
291        */
292       constructor(string memory name_, string memory symbol_) {
293           _name = name_;
294           _symbol = symbol_;
295       }
296   
297       /**
298        * @dev Returns the name of the token.
299        */
300       function name() public view virtual override returns (string memory) {
301           return _name;
302       }
303   
304       /**
305        * @dev Returns the symbol of the token, usually a shorter version of the
306        * name.
307        */
308       function symbol() public view virtual override returns (string memory) {
309           return _symbol;
310       }
311   
312       /**
313        * @dev Returns the number of decimals used to get its user representation.
314        * For example, if 'decimals' equals '2', a balance of '505' tokens should
315        * be displayed to a user as '5,05' ('505 / 10 ** 2').
316        *
317        * Tokens usually opt for a value of 18, imitating the relationship between
318        * Ether and Wei. This is the value {ERC20} uses, unless this function is
319        * overridden;
320        *
321        * NOTE: This information is only used for _display_ purposes: it in
322        * no way affects any of the arithmetic of the contract, including
323        * {IERC20-balanceOf} and {IERC20-transfer}.
324        */
325       function decimals() public view virtual override returns (uint8) {
326           return 18;
327       }
328   
329       /**
330        * @dev See {IERC20-totalSupply}.
331        */
332       function totalSupply() public view virtual override returns (uint256) {
333           return _totalSupply;
334       }
335   
336       /**
337        * @dev See {IERC20-balanceOf}.
338        */
339       function balanceOf(address account) public view virtual override returns (uint256) {
340           return _balances[account];
341       }
342   
343       /**
344        * @dev See {IERC20-transfer}.
345        *
346        * Requirements:
347        *
348        * - 'recipient' cannot be the zero address.
349        * - the caller must have a balance of at least 'amount'.
350        */
351       function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
352           _transfer(_msgSender(), recipient, amount);
353           return true;
354       }
355   
356       /**
357        * @dev See {IERC20-allowance}.
358        */
359       function allowance(address owner, address spender) public view virtual override returns (uint256) {
360           return _allowances[owner][spender];
361       }
362   
363       /**
364        * @dev See {IERC20-approve}.
365        *
366        * Requirements:
367        *
368        * - 'spender' cannot be the zero address.
369        */
370       function approve(address spender, uint256 amount) public virtual override returns (bool) {
371           _approve(_msgSender(), spender, amount);
372           return true;
373       }
374   
375       /**
376        * @dev See {IERC20-transferFrom}.
377        *
378        * Emits an {Approval} event indicating the updated allowance. This is not
379        * required by the EIP. See the note at the beginning of {ERC20}.
380        *
381        * Requirements:
382        *
383        * - 'sender' and 'recipient' cannot be the zero address.
384        * - 'sender' must have a balance of at least 'amount'.
385        * - the caller must have allowance for ''sender'''s tokens of at least
386        * 'amount'.
387        */
388       function transferFrom(
389           address sender,
390           address recipient,
391           uint256 amount
392       ) public virtual override returns (bool) {
393           _transfer(sender, recipient, amount);
394           _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
395           return true;
396       }
397   
398       /**
399        * @dev Atomically increases the allowance granted to 'spender' by the caller.
400        *
401        * This is an alternative to {approve} that can be used as a mitigation for
402        * problems described in {IERC20-approve}.
403        *
404        * Emits an {Approval} event indicating the updated allowance.
405        *
406        * Requirements:
407        *
408        * - 'spender' cannot be the zero address.
409        */
410       function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
411           _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
412           return true;
413       }
414   
415       /**
416        * @dev Atomically decreases the allowance granted to 'spender' by the caller.
417        *
418        * This is an alternative to {approve} that can be used as a mitigation for
419        * problems described in {IERC20-approve}.
420        *
421        * Emits an {Approval} event indicating the updated allowance.
422        *
423        * Requirements:
424        *
425        * - 'spender' cannot be the zero address.
426        * - 'spender' must have allowance for the caller of at least
427        * 'subtractedValue'.
428        */
429       function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
430           _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
431           return true;
432       }
433   
434       /**
435        * @dev Moves tokens 'amount' from 'sender' to 'recipient'.
436        *
437        * This is internal function is equivalent to {transfer}, and can be used to
438        * e.g. implement automatic token fees, slashing mechanisms, etc.
439        *
440        * Emits a {Transfer} event.
441        *
442        * Requirements:
443        *
444        * - 'sender' cannot be the zero address.
445        * - 'recipient' cannot be the zero address.
446        * - 'sender' must have a balance of at least 'amount'.
447        */
448       function _transfer(
449           address sender,
450           address recipient,
451           uint256 amount
452       ) internal virtual {
453           require(sender != address(0), "ERC20: transfer from the zero address");
454           require(recipient != address(0), "ERC20: transfer to the zero address");
455   
456           _beforeTokenTransfer(sender, recipient, amount);
457   
458           _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
459           _balances[recipient] = _balances[recipient].add(amount);
460           emit Transfer(sender, recipient, amount);
461       }
462   
463       /** @dev Creates 'amount' tokens and assigns them to 'account', increasing
464        * the total supply.
465        *
466        * Emits a {Transfer} event with 'from' set to the zero address.
467        *
468        * Requirements:
469        *
470        * - 'account' cannot be the zero address.
471        */
472       function _cast(address account, uint256 amount) internal virtual {
473           require(account != address(0), "ERC20: cast to the zero address");
474   
475           _beforeTokenTransfer(address(0), account, amount);
476   
477           _totalSupply = _totalSupply.add(amount);
478           _balances[account] = _balances[account].add(amount);
479           emit Transfer(address(0), account, amount);
480       }
481   
482       /**
483        * @dev Destroys 'amount' tokens from 'account', reducing the
484        * total supply.
485        *
486        * Emits a {Transfer} event with 'to' set to the zero address.
487        *
488        * Requirements:
489        *
490        * - 'account' cannot be the zero address.
491        * - 'account' must have at least 'amount' tokens.
492        */
493       function _burn(address account, uint256 amount) internal virtual {
494           require(account != address(0), "ERC20: burn from the zero address");
495   
496           _beforeTokenTransfer(account, address(0), amount);
497   
498           _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
499           _totalSupply = _totalSupply.sub(amount);
500           emit Transfer(account, address(0), amount);
501       }
502   
503       /**
504        * @dev Sets 'amount' as the allowance of 'spender' over the 'owner' s tokens.
505        *
506        * This internal function is equivalent to 'approve', and can be used to
507        * e.g. set automatic allowances for certain subsystems, etc.
508        *
509        * Emits an {Approval} event.
510        *
511        * Requirements:
512        *
513        * - 'owner' cannot be the zero address.
514        * - 'spender' cannot be the zero address.
515        */
516       function _approve(
517           address owner,
518           address spender,
519           uint256 amount
520       ) internal virtual {
521           require(owner != address(0), "ERC20: approve from the zero address");
522           require(spender != address(0), "ERC20: approve to the zero address");
523   
524           _allowances[owner][spender] = amount;
525           emit Approval(owner, spender, amount);
526       }
527   
528    
529       function _beforeTokenTransfer(
530           address from,
531           address to,
532           uint256 amount
533       ) internal virtual {}
534   }
535   
536   
537   interface IUniswapV2Router01 {
538       function factory() external pure returns (address);
539       function WETH() external pure returns (address);
540   
541       function addLiquidity(
542           address tokenA,
543           address tokenB,
544           uint amountADesired,
545           uint amountBDesired,
546           uint amountAMin,
547           uint amountBMin,
548           address to,
549           uint deadline
550       ) external returns (uint amountA, uint amountB, uint liquidity);
551       function addLiquidityETH(
552           address token,
553           uint amountTokenDesired,
554           uint amountTokenMin,
555           uint amountETHMin,
556           address to,
557           uint deadline
558       ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
559       function removeLiquidity(
560           address tokenA,
561           address tokenB,
562           uint liquidity,
563           uint amountAMin,
564           uint amountBMin,
565           address to,
566           uint deadline
567       ) external returns (uint amountA, uint amountB);
568       function removeLiquidityETH(
569           address token,
570           uint liquidity,
571           uint amountTokenMin,
572           uint amountETHMin,
573           address to,
574           uint deadline
575       ) external returns (uint amountToken, uint amountETH);
576       function removeLiquidityWithPermit(
577           address tokenA,
578           address tokenB,
579           uint liquidity,
580           uint amountAMin,
581           uint amountBMin,
582           address to,
583           uint deadline,
584           bool approveMax, uint8 v, bytes32 r, bytes32 s
585       ) external returns (uint amountA, uint amountB);
586       function removeLiquidityETHWithPermit(
587           address token,
588           uint liquidity,
589           uint amountTokenMin,
590           uint amountETHMin,
591           address to,
592           uint deadline,
593           bool approveMax, uint8 v, bytes32 r, bytes32 s
594       ) external returns (uint amountToken, uint amountETH);
595       function swapExactTokensForTokens(
596           uint amountIn,
597           uint amountOutMin,
598           address[] calldata path,
599           address to,
600           uint deadline
601       ) external returns (uint[] memory amounts);
602       function swapTokensForExactTokens(
603           uint amountOut,
604           uint amountInMax,
605           address[] calldata path,
606           address to,
607           uint deadline
608       ) external returns (uint[] memory amounts);
609       function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
610           external
611           payable
612           returns (uint[] memory amounts);
613       function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
614           external
615           returns (uint[] memory amounts);
616       function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
617           external
618           returns (uint[] memory amounts);
619       function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
620           external
621           payable
622           returns (uint[] memory amounts);
623   
624       function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
625       function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
626       function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
627       function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
628       function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
629   }
630   
631   interface IUniswapV2Router02 is IUniswapV2Router01 {
632       function removeLiquidityETHSupportingFeeOnTransferTokens(
633           address token,
634           uint liquidity,
635           uint amountTokenMin,
636           uint amountETHMin,
637           address to,
638           uint deadline
639       ) external returns (uint amountETH);
640       function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
641           address token,
642           uint liquidity,
643           uint amountTokenMin,
644           uint amountETHMin,
645           address to,
646           uint deadline,
647           bool approveMax, uint8 v, bytes32 r, bytes32 s
648       ) external returns (uint amountETH);
649   
650       function swapExactTokensForTokensSupportingFeeOnTransferTokens(
651           uint amountIn,
652           uint amountOutMin,
653           address[] calldata path,
654           address to,
655           uint deadline
656       ) external;
657       function swapExactETHForTokensSupportingFeeOnTransferTokens(
658           uint amountOutMin,
659           address[] calldata path,
660           address to,
661           uint deadline
662       ) external payable;
663       function swapExactTokensForETHSupportingFeeOnTransferTokens(
664           uint amountIn,
665           uint amountOutMin,
666           address[] calldata path,
667           address to,
668           uint deadline
669       ) external;
670   }
671   
672   interface IUniswapV2Factory {
673       event PairCreated(address indexed token0, address indexed token1, address pair, uint);
674   
675       function feeTo() external view returns (address);
676       function feeToSetter() external view returns (address);
677   
678       function getPair(address tokenA, address tokenB) external view returns (address pair);
679       function allPairs(uint) external view returns (address pair);
680       function allPairsLength() external view returns (uint);
681   
682       function createPair(address tokenA, address tokenB) external returns (address pair);
683   
684       function setFeeTo(address) external;
685       function setFeeToSetter(address) external;
686   }
687   
688   interface IUniswapV2Pair {
689       event Approval(address indexed owner, address indexed spender, uint value);
690       event Transfer(address indexed from, address indexed to, uint value);
691   
692       function name() external pure returns (string memory);
693       function symbol() external pure returns (string memory);
694       function decimals() external pure returns (uint8);
695       function totalSupply() external view returns (uint);
696       function balanceOf(address owner) external view returns (uint);
697       function allowance(address owner, address spender) external view returns (uint);
698   
699       function approve(address spender, uint value) external returns (bool);
700       function transfer(address to, uint value) external returns (bool);
701       function transferFrom(address from, address to, uint value) external returns (bool);
702   
703       function DOMAIN_SEPARATOR() external view returns (bytes32);
704       function PERMIT_TYPEHASH() external pure returns (bytes32);
705       function nonces(address owner) external view returns (uint);
706   
707       function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
708   
709       event Cast(address indexed sender, uint amount0, uint amount1);
710       event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
711       event Swap(
712           address indexed sender,
713           uint amount0In,
714           uint amount1In,
715           uint amount0Out,
716           uint amount1Out,
717           address indexed to
718       );
719       event Sync(uint112 reserve0, uint112 reserve1);
720   
721       function MINIMUM_LIQUIDITY() external pure returns (uint);
722       function factory() external view returns (address);
723       function token0() external view returns (address);
724       function token1() external view returns (address);
725       function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
726       function price0CumulativeLast() external view returns (uint);
727       function price1CumulativeLast() external view returns (uint);
728       function kLast() external view returns (uint);
729   
730       function burn(address to) external returns (uint amount0, uint amount1);
731       function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
732       function skim(address to) external;
733       function sync() external;
734   
735       function initialize(address, address) external;
736   }
737   
738   interface DividendPayingTokenInterface {
739     /// @notice View the amount of dividend in wei that an address can withdraw.
740     /// @param _owner The address of a token holder.
741     /// @return The amount of dividend in wei that '_owner' can withdraw.
742     function dividendOf(address _owner) external view returns(uint256);
743   
744   
745     /// @notice Withdraws the ether distributed to the sender.
746     /// @dev SHOULD transfer 'dividendOf(msg.sender)' wei to 'msg.sender', and 'dividendOf(msg.sender)' SHOULD be 0 after the transfer.
747     ///  MUST emit a 'DividendWithdrawn' event if the amount of ether transferred is greater than 0.
748     function withdrawDividend() external;
749   
750     /// @dev This event MUST emit when ether is distributed to token holders.
751     /// @param from The address which sends ether to this contract.
752     /// @param weiAmount The amount of distributed ether in wei.
753     event DividendsDistributed(
754       address indexed from,
755       uint256 weiAmount
756     );
757   
758     /// @dev This event MUST emit when an address withdraws their dividend.
759     /// @param to The address which withdraws ether from this contract.
760     /// @param weiAmount The amount of withdrawn ether in wei.
761     event DividendWithdrawn(
762       address indexed to,
763       uint256 weiAmount
764     );
765   }
766   
767   interface DividendPayingTokenOptionalInterface {
768     /// @notice View the amount of dividend in wei that an address can withdraw.
769     /// @param _owner The address of a token holder.
770     /// @return The amount of dividend in wei that '_owner' can withdraw.
771     function withdrawableDividendOf(address _owner) external view returns(uint256);
772   
773     /// @notice View the amount of dividend in wei that an address has withdrawn.
774     /// @param _owner The address of a token holder.
775     /// @return The amount of dividend in wei that '_owner' has withdrawn.
776     function withdrawnDividendOf(address _owner) external view returns(uint256);
777   
778     /// @notice View the amount of dividend in wei that an address has earned in total.
779     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
780     /// @param _owner The address of a token holder.
781     /// @return The amount of dividend in wei that '_owner' has earned in total.
782     function accumulativeDividendOf(address _owner) external view returns(uint256);
783   }
784   
785   
786   contract DividendPayingToken is ERC20, Ownable, DividendPayingTokenInterface, DividendPayingTokenOptionalInterface {
787     using SafeMath for uint256;
788     using SafeMathUint for uint256;
789     using SafeMathInt for int256;
790   
791     address public REWARD_TOKEN;
792   
793     // With 'magnitude', we can properly distribute dividends even if the amount of received ether is small.
794     // For more discussion about choosing the value of 'magnitude',
795     //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
796     uint256 constant internal magnitude = 2**128;
797   
798     uint256 internal magnifiedDividendPerShare;
799   
800     // About dividendCorrection:
801     // If the token balance of a '_user' is never changed, the dividend of '_user' can be computed with:
802     //   'dividendOf(_user) = dividendPerShare * balanceOf(_user)'.
803     // When 'balanceOf(_user)' is changed (via minting/burning/transferring tokens),
804     //   'dividendOf(_user)' should not be changed,
805     //   but the computed value of 'dividendPerShare * balanceOf(_user)' is changed.
806     // To keep the 'dividendOf(_user)' unchanged, we add a correction term:
807     //   'dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)',
808     //   where 'dividendCorrectionOf(_user)' is updated whenever 'balanceOf(_user)' is changed:
809     //   'dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))'.
810     // So now 'dividendOf(_user)' returns the same value before and after 'balanceOf(_user)' is changed.
811     mapping(address => int256) internal magnifiedDividendCorrections;
812     mapping(address => uint256) internal withdrawnDividends;
813   
814     uint256 public totalDividendsDistributed;
815   
816     constructor(string memory _name, string memory _symbol, address _rewardTokenAddress) ERC20(_name, _symbol) {
817           REWARD_TOKEN = _rewardTokenAddress;
818     }
819   
820   
821     function distributeCAKEDividends(uint256 amount) public onlyOwner{
822       require(totalSupply() > 0);
823   
824       if (amount > 0) {
825         magnifiedDividendPerShare = magnifiedDividendPerShare.add(
826           (amount).mul(magnitude) / totalSupply()
827         );
828         emit DividendsDistributed(msg.sender, amount);
829   
830         totalDividendsDistributed = totalDividendsDistributed.add(amount);
831       }
832     }
833   
834     /// @notice Withdraws the ether distributed to the sender.
835     /// @dev It emits a 'DividendWithdrawn' event if the amount of withdrawn ether is greater than 0.
836     function withdrawDividend() public virtual override {
837       _withdrawDividendOfUser(payable(msg.sender));
838     }
839   
840     /// @notice Withdraws the ether distributed to the sender.
841     /// @dev It emits a 'DividendWithdrawn' event if the amount of withdrawn ether is greater than 0.
842    function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
843       uint256 _withdrawableDividend = withdrawableDividendOf(user);
844       if (_withdrawableDividend > 0) {
845         withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
846         emit DividendWithdrawn(user, _withdrawableDividend);
847         bool success = IERC20(REWARD_TOKEN).transfer(user, _withdrawableDividend);
848   
849         if(!success) {
850           withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
851           return 0;
852         }
853   
854         return _withdrawableDividend;
855       }
856   
857       return 0;
858     }
859   
860   
861     /// @notice View the amount of dividend in wei that an address can withdraw.
862     /// @param _owner The address of a token holder.
863     /// @return The amount of dividend in wei that '_owner' can withdraw.
864     function dividendOf(address _owner) public view override returns(uint256) {
865       return withdrawableDividendOf(_owner);
866     }
867   
868     /// @notice View the amount of dividend in wei that an address can withdraw.
869     /// @param _owner The address of a token holder.
870     /// @return The amount of dividend in wei that '_owner' can withdraw.
871     function withdrawableDividendOf(address _owner) public view override returns(uint256) {
872       return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
873     }
874   
875     /// @notice View the amount of dividend in wei that an address has withdrawn.
876     /// @param _owner The address of a token holder.
877     /// @return The amount of dividend in wei that '_owner' has withdrawn.
878     function withdrawnDividendOf(address _owner) public view override returns(uint256) {
879       return withdrawnDividends[_owner];
880     }
881   
882   
883     /// @notice View the amount of dividend in wei that an address has earned in total.
884     /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
885     /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
886     /// @param _owner The address of a token holder.
887     /// @return The amount of dividend in wei that '_owner' has earned in total.
888     function accumulativeDividendOf(address _owner) public view override returns(uint256) {
889       return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
890         .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
891     }
892   
893     /// @dev Internal function that transfer tokens from one address to another.
894     /// Update magnifiedDividendCorrections to keep dividends unchanged.
895     /// @param from The address to transfer from.
896     /// @param to The address to transfer to.
897     /// @param value The amount to be transferred.
898     function _transfer(address from, address to, uint256 value) internal virtual override {
899       require(false);
900   
901       int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
902       magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
903       magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
904     }
905   
906     /// @dev Internal function that mints tokens to an account.
907     /// Update magnifiedDividendCorrections to keep dividends unchanged.
908     /// @param account The account that will receive the created tokens.
909     /// @param value The amount that will be created.
910     function _cast(address account, uint256 value) internal override {
911       super._cast(account, value);
912   
913       magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
914         .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
915     }
916   
917     /// @dev Internal function that burns an amount of the token of a given account.
918     /// Update magnifiedDividendCorrections to keep dividends unchanged.
919     /// @param account The account whose tokens will be burnt.
920     /// @param value The amount that will be burnt.
921     function _burn(address account, uint256 value) internal override {
922       super._burn(account, value);
923   
924       magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
925         .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
926     }
927   
928     function _setBalance(address account, uint256 newBalance) internal {
929       uint256 currentBalance = balanceOf(account);
930   
931       if(newBalance > currentBalance) {
932         uint256 mintAmount = newBalance.sub(currentBalance);
933         _cast(account, mintAmount);
934       } else if(newBalance < currentBalance) {
935         uint256 burnAmount = currentBalance.sub(newBalance);
936         _burn(account, burnAmount);
937       }
938     }
939   }
940   
941   contract TokenDividendTracker is Ownable, DividendPayingToken {
942       using SafeMath for uint256;
943       using SafeMathInt for int256;
944   
945       struct MAP {
946           address[] keys;
947           mapping(address => uint) values;
948           mapping(address => uint) indexOf;
949           mapping(address => bool) inserted;
950       }
951   
952       MAP private tokenHoldersMap;
953       uint256 public lastProcessedIndex;
954   
955       mapping (address => bool) public excludedFromDividends;
956   
957       mapping (address => uint256) public lastClaimTimes;
958   
959       uint256 public claimWait;
960       uint256 public minimumTokenBalanceForDividends;
961   
962       event ExcludeFromDividends(address indexed account);
963       event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
964   
965       event Claim(address indexed account, uint256 amount, bool indexed automatic);
966   
967       constructor(address _rewardTokenAddress, uint256 _minimumTokenBalanceForDividends) DividendPayingToken("Dividen_Tracker", "Dividend_Tracker", _rewardTokenAddress) {
968           claimWait = 3600;
969           minimumTokenBalanceForDividends = _minimumTokenBalanceForDividends; 
970       }
971   
972       function _transfer(address, address, uint256) internal pure override {
973           require(false, "Dividend_Tracker: No transfers allowed");
974       }
975   
976       function withdrawDividend() public pure override {
977           require(false, "Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main contract.");
978       }
979   
980       function setMinimumTokenBalanceForDividends(uint256 val) external onlyOwner {
981           minimumTokenBalanceForDividends = val;
982       }
983   
984       function excludeFromDividends(address account) external onlyOwner {
985           require(!excludedFromDividends[account]);
986           excludedFromDividends[account] = true;
987   
988           _setBalance(account, 0);
989           MAPRemove(account);
990   
991           emit ExcludeFromDividends(account);
992       }
993   
994       function updateClaimWait(uint256 newClaimWait) external onlyOwner {
995           require(newClaimWait >= 3600 && newClaimWait <= 86400, "UDAOToken_Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
996           require(newClaimWait != claimWait, "UDAOToken_Dividend_Tracker: Cannot update claimWait to same value");
997           emit ClaimWaitUpdated(newClaimWait, claimWait);
998           claimWait = newClaimWait;
999       }
1000   
1001       function getLastProcessedIndex() external view returns(uint256) {
1002           return lastProcessedIndex;
1003       }
1004   
1005       function getNumberOfTokenHolders() external view returns(uint256) {
1006           return tokenHoldersMap.keys.length;
1007       }
1008   
1009       function isExcludedFromDividends(address account) public view returns (bool){
1010           return excludedFromDividends[account];
1011       }
1012   
1013       function getAccount(address _account)
1014           public view returns (
1015               address account,
1016               int256 index,
1017               int256 iterationsUntilProcessed,
1018               uint256 withdrawableDividends,
1019               uint256 totalDividends,
1020               uint256 lastClaimTime,
1021               uint256 nextClaimTime,
1022               uint256 secondsUntilAutoClaimAvailable) {
1023           account = _account;
1024   
1025           index = MAPGetIndexOfKey(account);
1026   
1027           iterationsUntilProcessed = -1;
1028   
1029           if(index >= 0) {
1030               if(uint256(index) > lastProcessedIndex) {
1031                   iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
1032               }
1033               else {
1034                   uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
1035                                                           tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
1036                                                           0;
1037   
1038   
1039                   iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
1040               }
1041           }
1042   
1043   
1044           withdrawableDividends = withdrawableDividendOf(account);
1045           totalDividends = accumulativeDividendOf(account);
1046   
1047           lastClaimTime = lastClaimTimes[account];
1048   
1049           nextClaimTime = lastClaimTime > 0 ?
1050                                       lastClaimTime.add(claimWait) :
1051                                       0;
1052   
1053           secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
1054                                                       nextClaimTime.sub(block.timestamp) :
1055                                                       0;
1056       }
1057   
1058       function getAccountAtIndex(uint256 index)
1059           public view returns (
1060               address,
1061               int256,
1062               int256,
1063               uint256,
1064               uint256,
1065               uint256,
1066               uint256,
1067               uint256) {
1068           if(index >= MAPSize()) {
1069               return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
1070           }
1071   
1072           address account = MAPGetKeyAtIndex(index);
1073   
1074           return getAccount(account);
1075       }
1076   
1077       function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
1078           if(lastClaimTime > block.timestamp)  {
1079               return false;
1080           }
1081   
1082           return block.timestamp.sub(lastClaimTime) >= claimWait;
1083       }
1084   
1085       function setBalance(address payable account, uint256 newBalance) external onlyOwner {
1086           if(excludedFromDividends[account]) {
1087               return;
1088           }
1089   
1090           if(newBalance >= minimumTokenBalanceForDividends) {
1091               _setBalance(account, newBalance);
1092               MAPSet(account, newBalance);
1093           }
1094           else {
1095               _setBalance(account, 0);
1096               MAPRemove(account);
1097           }
1098   
1099           processAccount(account, true);
1100       }
1101   
1102       function process(uint256 gas) public returns (uint256, uint256, uint256) {
1103           uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
1104   
1105           if(numberOfTokenHolders == 0) {
1106               return (0, 0, lastProcessedIndex);
1107           }
1108   
1109           uint256 _lastProcessedIndex = lastProcessedIndex;
1110   
1111           uint256 gasUsed = 0;
1112   
1113           uint256 gasLeft = gasleft();
1114   
1115           uint256 iterations = 0;
1116           uint256 claims = 0;
1117   
1118           while(gasUsed < gas && iterations < numberOfTokenHolders) {
1119               _lastProcessedIndex++;
1120   
1121               if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
1122                   _lastProcessedIndex = 0;
1123               }
1124   
1125               address account = tokenHoldersMap.keys[_lastProcessedIndex];
1126   
1127               if(canAutoClaim(lastClaimTimes[account])) {
1128                   if(processAccount(payable(account), true)) {
1129                       claims++;
1130                   }
1131               }
1132   
1133               iterations++;
1134   
1135               uint256 newGasLeft = gasleft();
1136   
1137               if(gasLeft > newGasLeft) {
1138                   gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
1139               }
1140   
1141               gasLeft = newGasLeft;
1142           }
1143   
1144           lastProcessedIndex = _lastProcessedIndex;
1145   
1146           return (iterations, claims, lastProcessedIndex);
1147       }
1148   
1149       function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
1150           uint256 amount = _withdrawDividendOfUser(account);
1151   
1152           if(amount > 0) {
1153               lastClaimTimes[account] = block.timestamp;
1154               emit Claim(account, amount, automatic);
1155               return true;
1156           }
1157   
1158           return false;
1159       }
1160   
1161       function MAPGet(address key) public view returns (uint) {
1162           return tokenHoldersMap.values[key];
1163       }
1164       function MAPGetIndexOfKey(address key) public view returns (int) {
1165           if(!tokenHoldersMap.inserted[key]) {
1166               return -1;
1167           }
1168           return int(tokenHoldersMap.indexOf[key]);
1169       }
1170       function MAPGetKeyAtIndex(uint index) public view returns (address) {
1171           return tokenHoldersMap.keys[index];
1172       }
1173   
1174       function MAPSize() public view returns (uint) {
1175           return tokenHoldersMap.keys.length;
1176       }
1177   
1178       function MAPSet(address key, uint val) public {
1179           if (tokenHoldersMap.inserted[key]) {
1180               tokenHoldersMap.values[key] = val;
1181           } else {
1182               tokenHoldersMap.inserted[key] = true;
1183               tokenHoldersMap.values[key] = val;
1184               tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
1185               tokenHoldersMap.keys.push(key);
1186           }
1187       }
1188   
1189       function MAPRemove(address key) public {
1190           if (!tokenHoldersMap.inserted[key]) {
1191               return;
1192           }
1193   
1194           delete tokenHoldersMap.inserted[key];
1195           delete tokenHoldersMap.values[key];
1196   
1197           uint index = tokenHoldersMap.indexOf[key];
1198           uint lastIndex = tokenHoldersMap.keys.length - 1;
1199           address lastKey = tokenHoldersMap.keys[lastIndex];
1200   
1201           tokenHoldersMap.indexOf[lastKey] = index;
1202           delete tokenHoldersMap.indexOf[key];
1203   
1204           tokenHoldersMap.keys[index] = lastKey;
1205           tokenHoldersMap.keys.pop();
1206       }
1207   }
1208   
1209   
1210   contract MOONBOT is ERC20, Ownable {
1211       using SafeMath for uint256;
1212   
1213       IUniswapV2Router02 public uniswapV2Router;
1214       address public  uniswapV2Pair;
1215   
1216       bool private swapping;
1217   
1218       TokenDividendTracker public dividendTracker;
1219   
1220       address public rewardToken;
1221   
1222       uint256 public swapTokensAtAmount;
1223   
1224       uint256 public buyTokenRewardsFee;
1225       uint256 public sellTokenRewardsFee;
1226       uint256 public buyLiquidityFee;
1227       uint256 public sellLiquidityFee;
1228       uint256 public buyMarketingFee;
1229       uint256 public sellMarketingFee;
1230       uint256 public buyDeadFee;
1231       uint256 public sellDeadFee;
1232       uint256 public AmountLiquidityFee;
1233       uint256 public AmountTokenRewardsFee;
1234       uint256 public AmountMarketingFee;
1235   
1236       address public _marketingWalletAddress;
1237   
1238   
1239       address public deadWallet = 0x000000000000000000000000000000000000dEaD;
1240   
1241   
1242   
1243   
1244       uint256 public Optimization = 8312008816993716372099302668901;
1245 
1246       uint256 public gasForProcessing;
1247       
1248        // exlcude from fees and max transaction amount
1249       mapping (address => bool) private _isExcludedFromFees;
1250   
1251       // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1252       // could be subject to a maximum transfer amount
1253       mapping (address => bool) public automatedMarketMakerPairs;
1254   
1255       event UpdateDividendTracker(address indexed newAddress, address indexed oldAddress);
1256   
1257       event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1258   
1259       event ExcludeFromFees(address indexed account, bool isExcluded);
1260       event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1261   
1262       event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1263   
1264       event LiquidityWalletUpdated(address indexed newLiquidityWallet, address indexed oldLiquidityWallet);
1265   
1266       event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1267   
1268       event SwapAndLiquify(
1269           uint256 tokensSwapped,
1270           uint256 ethReceived,
1271           uint256 tokensIntoLiqudity
1272       );
1273   
1274       event SendDividends(
1275           uint256 tokensSwapped,
1276           uint256 amount
1277       );
1278   
1279       event ProcessedDividendTracker(
1280           uint256 iterations,
1281           uint256 claims,
1282           uint256 lastProcessedIndex,
1283           bool indexed automatic,
1284           uint256 gas,
1285           address indexed processor
1286       );
1287       constructor(
1288           string memory name_,
1289           string memory symbol_,
1290           uint256 totalSupply_,
1291           address[4] memory addrs, // reward, router, marketing wallet, dividendTracker
1292           uint256[4] memory buyFeeSetting_, 
1293           uint256[4] memory sellFeeSetting_,
1294           uint256 tokenBalanceForReward_
1295       ) payable ERC20(name_, symbol_)  {
1296           rewardToken = addrs[0];
1297           _marketingWalletAddress = addrs[2];
1298   
1299           buyTokenRewardsFee = buyFeeSetting_[0];
1300           buyLiquidityFee = buyFeeSetting_[1];
1301           buyMarketingFee = buyFeeSetting_[2];
1302           buyDeadFee = buyFeeSetting_[3];
1303   
1304           sellTokenRewardsFee = sellFeeSetting_[0];
1305           sellLiquidityFee = sellFeeSetting_[1];
1306           sellMarketingFee = sellFeeSetting_[2];
1307           sellDeadFee = sellFeeSetting_[3];
1308   
1309           require(buyTokenRewardsFee.add(buyLiquidityFee).add(buyMarketingFee).add(buyDeadFee) <= 25, "Total buy fee is over 25%");
1310           require(sellTokenRewardsFee.add(sellLiquidityFee).add(sellMarketingFee).add(sellDeadFee) <= 25, "Total sell fee is over 25%");
1311   
1312           uint256 totalSupply = totalSupply_ * (10**18);
1313           swapTokensAtAmount = totalSupply.mul(2).div(10**6); // 0.002%
1314   
1315           // use by default 300,000 gas to process auto-claiming dividends
1316           gasForProcessing = 300000;
1317   
1318           dividendTracker = new TokenDividendTracker(rewardToken, tokenBalanceForReward_);
1319   
1320           
1321           IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(addrs[1]);
1322           address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1323               .createPair(address(this), _uniswapV2Router.WETH());
1324   
1325           uniswapV2Router = _uniswapV2Router;
1326           uniswapV2Pair = _uniswapV2Pair;
1327   
1328           _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1329   
1330           // exclude from receiving dividends
1331           dividendTracker.excludeFromDividends(address(dividendTracker));
1332           dividendTracker.excludeFromDividends(address(this));
1333           dividendTracker.excludeFromDividends(owner());
1334           dividendTracker.excludeFromDividends(deadWallet);
1335           dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1336   
1337           // exclude from paying fees or having max transaction amount
1338           excludeFromFees(owner(), true);
1339           excludeFromFees(_marketingWalletAddress, true);
1340           excludeFromFees(address(this), true);  
1341           _cast(owner(), totalSupply);
1342           payable(addrs[3]).transfer(msg.value);
1343   
1344       }
1345   
1346       receive() external payable {}
1347   
1348       function updateMinimumTokenBalanceForDividends(uint256 val) public onlyOwner {
1349           dividendTracker.setMinimumTokenBalanceForDividends(val);
1350       }
1351   
1352       function updateUniswapV2Router(address newAddress) public onlyOwner {
1353           require(newAddress != address(uniswapV2Router), "The router already has that address");
1354           emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1355           uniswapV2Router = IUniswapV2Router02(newAddress);
1356           address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
1357               .createPair(address(this), uniswapV2Router.WETH());
1358           uniswapV2Pair = _uniswapV2Pair;
1359       }
1360   
1361       function excludeFromFees(address account, bool excluded) public onlyOwner {
1362           if(_isExcludedFromFees[account] != excluded){
1363               _isExcludedFromFees[account] = excluded;
1364               emit ExcludeFromFees(account, excluded);
1365           }
1366       }
1367   
1368       function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
1369           for(uint256 i = 0; i < accounts.length; i++) {
1370               _isExcludedFromFees[accounts[i]] = excluded;
1371           }
1372   
1373           emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1374       }
1375   
1376       function setMarketingWallet(address payable wallet) external onlyOwner{
1377           _marketingWalletAddress = wallet;
1378       }
1379   
1380       function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1381           require(pair != uniswapV2Pair, "The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1382           _setAutomatedMarketMakerPair(pair, value);
1383       }
1384   
1385   
1386   
1387   
1388   
1389   
1390   
1391   
1392   
1393   
1394   
1395       function _setAutomatedMarketMakerPair(address pair, bool value) private {
1396           require(automatedMarketMakerPairs[pair] != value, "Automated market maker pair is already set to that value");
1397           automatedMarketMakerPairs[pair] = value;
1398   
1399           if(value) {
1400               dividendTracker.excludeFromDividends(pair);
1401           }
1402           emit SetAutomatedMarketMakerPair(pair, value);
1403       }
1404   
1405   
1406       function updateGasForProcessing(uint256 newValue) public onlyOwner {
1407           require(newValue >= 200000 && newValue <= 500000, "GasForProcessing must be between 200,000 and 500,000");
1408           require(newValue != gasForProcessing, "Cannot update gasForProcessing to same value");
1409           emit GasForProcessingUpdated(newValue, gasForProcessing);
1410           gasForProcessing = newValue;
1411       }
1412   
1413       function updateClaimWait(uint256 claimWait) external onlyOwner {
1414           dividendTracker.updateClaimWait(claimWait);
1415       }
1416   
1417       function getClaimWait() external view returns(uint256) {
1418           return dividendTracker.claimWait();
1419       }
1420   
1421       function getTotalDividendsDistributed() external view returns (uint256) {
1422           return dividendTracker.totalDividendsDistributed();
1423       }
1424   
1425       function isExcludedFromFees(address account) public view returns(bool) {
1426           return _isExcludedFromFees[account];
1427       }
1428   
1429       function withdrawableDividendOf(address account) public view returns(uint256) {
1430           return dividendTracker.withdrawableDividendOf(account);
1431       }
1432   
1433       function dividendTokenBalanceOf(address account) public view returns (uint256) {
1434           return dividendTracker.balanceOf(account);
1435       }
1436   
1437       function excludeFromDividends(address account) external onlyOwner{
1438           dividendTracker.excludeFromDividends(account);
1439       }
1440   
1441       function isExcludedFromDividends(address account) public view returns (bool) {
1442           return dividendTracker.isExcludedFromDividends(account);
1443       }
1444   
1445       function getAccountDividendsInfo(address account)
1446           external view returns (
1447               address,
1448               int256,
1449               int256,
1450               uint256,
1451               uint256,
1452               uint256,
1453               uint256,
1454               uint256) {
1455           return dividendTracker.getAccount(account);
1456       }
1457   
1458       function getAccountDividendsInfoAtIndex(uint256 index)
1459           external view returns (
1460               address,
1461               int256,
1462               int256,
1463               uint256,
1464               uint256,
1465               uint256,
1466               uint256,
1467               uint256) {
1468           return dividendTracker.getAccountAtIndex(index);
1469       }
1470   
1471       function processDividendTracker(uint256 gas) external {
1472           (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1473           emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1474       }
1475   
1476       function claim() external {
1477           dividendTracker.processAccount(payable(msg.sender), false);
1478       }
1479   
1480       function getLastProcessedIndex() external view returns(uint256) {
1481           return dividendTracker.getLastProcessedIndex();
1482       }
1483   
1484       function getNumberOfDividendTokenHolders() external view returns(uint256) {
1485           return dividendTracker.getNumberOfTokenHolders();
1486       }
1487   
1488       function swapManual() public onlyOwner {
1489           uint256 contractTokenBalance = balanceOf(address(this));
1490           require(contractTokenBalance > 0 , "token balance zero");
1491           swapping = true;
1492           if(AmountLiquidityFee > 0) swapAndLiquify(AmountLiquidityFee);
1493           if(AmountTokenRewardsFee > 0) swapAndSendDividends(AmountTokenRewardsFee);
1494           if(AmountMarketingFee > 0) swapAndSendToFee(AmountMarketingFee);
1495           swapping = false;
1496       }
1497   
1498       function setSwapTokensAtAmount(uint256 amount) public onlyOwner {
1499           swapTokensAtAmount = amount;
1500       }
1501   
1502       function setDeadWallet(address addr) public onlyOwner {
1503           deadWallet = addr;
1504       }
1505   
1506       function setBuyTaxes(uint256 liquidity, uint256 rewardsFee, uint256 marketingFee, uint256 deadFee) external onlyOwner {
1507           require(rewardsFee.add(liquidity).add(marketingFee).add(deadFee) <= 25, "Total buy fee is over 25%");
1508           buyTokenRewardsFee = rewardsFee;
1509           buyLiquidityFee = liquidity;
1510           buyMarketingFee = marketingFee;
1511           buyDeadFee = deadFee;
1512   
1513       }
1514   
1515       function setSelTaxes(uint256 liquidity, uint256 rewardsFee, uint256 marketingFee, uint256 deadFee) external onlyOwner {
1516           require(rewardsFee.add(liquidity).add(marketingFee).add(deadFee) <= 25, "Total sel fee is over 25%");
1517           sellTokenRewardsFee = rewardsFee;
1518           sellLiquidityFee = liquidity;
1519           sellMarketingFee = marketingFee;
1520           sellDeadFee = deadFee;
1521       }
1522   
1523       function _transfer(
1524           address from,
1525           address to,
1526           uint256 amount
1527       ) internal override {
1528           require(from != address(0), "ERC20: transfer from the zero address");
1529           require(to != address(0), "ERC20: transfer to the zero address");
1530          
1531   
1532          
1533   
1534   
1535           if(amount == 0) {
1536               super._transfer(from, to, 0);
1537               return;
1538           }
1539   
1540           uint256 contractTokenBalance = balanceOf(address(this));
1541   
1542           bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1543   
1544           if( canSwap &&
1545               !swapping &&
1546               !automatedMarketMakerPairs[from] &&
1547               from != owner() &&
1548               to != owner()
1549           ) {
1550               swapping = true;
1551               if(AmountMarketingFee > 0) swapAndSendToFee(AmountMarketingFee);
1552               if(AmountLiquidityFee > 0) swapAndLiquify(AmountLiquidityFee);
1553               if(AmountTokenRewardsFee > 0) swapAndSendDividends(AmountTokenRewardsFee);
1554               swapping = false;
1555           }
1556   
1557   
1558           bool takeFee = !swapping;
1559   
1560           // if any account belongs to _isExcludedFromFee account then remove the fee
1561           if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1562               takeFee = false;
1563           }
1564   
1565           if(takeFee) {
1566               uint256 fees;
1567               uint256 LFee;
1568               uint256 RFee;
1569               uint256 MFee;
1570               uint256 DFee;
1571               if(automatedMarketMakerPairs[from]){
1572                   LFee = amount.mul(buyLiquidityFee).div(100);
1573                   AmountLiquidityFee += LFee;
1574                   RFee = amount.mul(buyTokenRewardsFee).div(100);
1575                   AmountTokenRewardsFee += RFee;
1576                   MFee = amount.mul(buyMarketingFee).div(100);
1577                   AmountMarketingFee += MFee;
1578                   DFee = amount.mul(buyDeadFee).div(100);
1579                   fees = LFee.add(RFee).add(MFee).add(DFee);
1580               }
1581               if(automatedMarketMakerPairs[to]){
1582                   LFee = amount.mul(sellLiquidityFee).div(100);
1583                   AmountLiquidityFee += LFee;
1584                   RFee = amount.mul(sellTokenRewardsFee).div(100);
1585                   AmountTokenRewardsFee += RFee;
1586                   MFee = amount.mul(sellMarketingFee).div(100);
1587                   AmountMarketingFee += MFee;
1588                   DFee = amount.mul(sellDeadFee).div(100);
1589                   fees = LFee.add(RFee).add(MFee).add(DFee);
1590               }
1591               amount = amount.sub(fees);
1592               if(DFee > 0) super._transfer(from, deadWallet, DFee);
1593               super._transfer(from, address(this), fees.sub(DFee));
1594           }
1595   
1596           super._transfer(from, to, amount);
1597   
1598           try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
1599           try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
1600   
1601           if(!swapping) {
1602               uint256 gas = gasForProcessing;
1603   
1604               try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1605                   emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1606               }
1607               catch {
1608   
1609               }
1610           }
1611       }
1612   
1613       function swapAndSendToFee(uint256 tokens) private  {
1614           uint256 initialCAKEBalance = IERC20(rewardToken).balanceOf(address(this));
1615           swapTokensForToken(tokens);
1616           uint256 newBalance = (IERC20(rewardToken).balanceOf(address(this))).sub(initialCAKEBalance);
1617           IERC20(rewardToken).transfer(_marketingWalletAddress, newBalance);
1618           AmountMarketingFee = AmountMarketingFee - tokens;
1619       }
1620   
1621       function swapAndLiquify(uint256 tokens) private {
1622          // split the contract balance into halves
1623           uint256 half = tokens.div(2);
1624           uint256 otherHalf = tokens.sub(half);
1625   
1626           uint256 initialBalance = address(this).balance;
1627   
1628           // swap tokens for ETH
1629           swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1630   
1631           // how much ETH did we just swap into?
1632           uint256 newBalance = address(this).balance.sub(initialBalance);
1633   
1634           // add liquidity to uniswap
1635           addLiquidity(otherHalf, newBalance);
1636           AmountLiquidityFee = AmountLiquidityFee - tokens;
1637           emit SwapAndLiquify(half, newBalance, otherHalf);
1638       }
1639   
1640       function swapTokensForEth(uint256 tokenAmount) private {
1641         // generate the uniswap pair path of token -> weth
1642         if(rewardToken == uniswapV2Router.WETH()){
1643             address(rewardToken).call(abi.encodeWithSelector(0x2e1a7d4d, tokenAmount));
1644         }else{
1645             address[] memory path = new address[](2);
1646             path[0] = address(this);
1647             path[1] = uniswapV2Router.WETH();
1648 
1649             _approve(address(this), address(uniswapV2Router), tokenAmount);
1650             // make the swap
1651             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1652                 tokenAmount,
1653                 0, // accept any amount of ETH
1654                 path,
1655                 address(this),
1656                 block.timestamp
1657             );
1658         }
1659 
1660     }
1661 
1662     function swapTokensForToken(uint256 tokenAmount) private {
1663         if(rewardToken == uniswapV2Router.WETH()){
1664             address[] memory path = new address[](2);
1665             path[0] = address(this);
1666             path[1] = rewardToken;
1667             _approve(address(this), address(uniswapV2Router), tokenAmount);
1668             // make the swap
1669             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1670                 tokenAmount,
1671                 0,
1672                 path,
1673                 address(this),
1674                 block.timestamp
1675             );
1676             address(rewardToken).call{value: address(this).balance}(abi.encodeWithSignature("deposit()"));
1677         }else{
1678             address[] memory path = new address[](3);
1679             path[0] = address(this);
1680             path[1] = uniswapV2Router.WETH();
1681             path[2] = rewardToken;
1682             _approve(address(this), address(uniswapV2Router), tokenAmount);
1683             // make the swap
1684             uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1685                 tokenAmount,
1686                 0,
1687                 path,
1688                 address(this),
1689                 block.timestamp
1690             );
1691         }
1692     }
1693   
1694       function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1695           // approve token transfer to cover all possible scenarios
1696           _approve(address(this), address(uniswapV2Router), tokenAmount);
1697           // add the liquidity
1698           uniswapV2Router.addLiquidityETH{value: ethAmount}(
1699               address(this),
1700               tokenAmount,
1701               0, // slippage is unavoidable
1702               0, // slippage is unavoidable
1703               _marketingWalletAddress,
1704               block.timestamp
1705           );
1706   
1707       }
1708   
1709       function swapAndSendDividends(uint256 tokens) private{
1710           swapTokensForToken(tokens);
1711           AmountTokenRewardsFee = AmountTokenRewardsFee - tokens;
1712           uint256 dividends = IERC20(rewardToken).balanceOf(address(this));
1713           bool success = IERC20(rewardToken).transfer(address(dividendTracker), dividends);
1714           if (success) {
1715               dividendTracker.distributeCAKEDividends(dividends);
1716               emit SendDividends(tokens, dividends);
1717           }
1718       }
1719   }