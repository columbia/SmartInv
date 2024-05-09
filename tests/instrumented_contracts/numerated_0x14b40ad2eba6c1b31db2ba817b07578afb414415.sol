1 // SPDX-License-Identifier: Unlicensed
2 
3         pragma solidity ^0.8.4;
4 
5         interface IERC20 {
6             
7             function totalSupply() external view returns (uint256);
8             function balanceOf(address account) external view returns (uint256);
9             function transfer(address recipient, uint256 amount) external returns (bool);
10             function allowance(address owner, address spender) external view returns (uint256);
11             function approve(address spender, uint256 amount) external returns (bool);
12             function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
13             
14             event Transfer(address indexed from, address indexed to, uint256 value);
15             event Approval(address indexed owner, address indexed spender, uint256 value);
16         }
17 
18         library SafeMath {
19             
20             function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
21                 unchecked {
22                     uint256 c = a + b;
23                     if (c < a) return (false, 0);
24                     return (true, c);
25                 }
26             }
27             
28             function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
29                 unchecked {
30                     if (b > a) return (false, 0);
31                     return (true, a - b);
32                 }
33             }
34             
35             function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36                 unchecked {
37                     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
38                     // benefit is lost if 'b' is also tested.
39                     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
40                     if (a == 0) return (true, 0);
41                     uint256 c = a * b;
42                     if (c / a != b) return (false, 0);
43                     return (true, c);
44                 }
45             }
46             
47             function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48                 unchecked {
49                     if (b == 0) return (false, 0);
50                     return (true, a / b);
51                 }
52             }
53             
54             function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
55                 unchecked {
56                     if (b == 0) return (false, 0);
57                     return (true, a % b);
58                 }
59             }
60 
61             function add(uint256 a, uint256 b) internal pure returns (uint256) {
62                 return a + b;
63             }
64 
65 
66             function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67                 return a - b;
68             }
69 
70 
71             function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72                 return a * b;
73             }
74             
75             function div(uint256 a, uint256 b) internal pure returns (uint256) {
76                 return a / b;
77             }
78 
79 
80             function mod(uint256 a, uint256 b) internal pure returns (uint256) {
81                 return a % b;
82             }
83             
84             function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85                 unchecked {
86                     require(b <= a, errorMessage);
87                     return a - b;
88                 }
89             }
90             
91             function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92                 unchecked {
93                     require(b > 0, errorMessage);
94                     return a / b;
95                 }
96             }
97             
98             function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
99                 unchecked {
100                     require(b > 0, errorMessage);
101                     return a % b;
102                 }
103             }
104         }
105 
106         abstract contract Context {
107             function _msgSender() internal view virtual returns (address) {
108                 return msg.sender;
109             }
110 
111             function _msgData() internal view virtual returns (bytes calldata) {
112                 this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
113                 return msg.data;
114             }
115         }
116 
117         library Address {
118             
119             function isContract(address account) internal view returns (bool) {
120                 uint256 size;
121                 assembly { size := extcodesize(account) }
122                 return size > 0;
123             }
124 
125             function sendValue(address payable recipient, uint256 amount) internal {
126                 require(address(this).balance >= amount, "Address: insufficient balance");
127                 (bool success, ) = recipient.call{ value: amount }("");
128                 require(success, "Address: unable to send value, recipient may have reverted");
129             }
130             
131             function functionCall(address target, bytes memory data) internal returns (bytes memory) {
132             return functionCall(target, data, "Address: low-level call failed");
133             }
134             
135             function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
136                 return functionCallWithValue(target, data, 0, errorMessage);
137             }
138             
139             function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
140                 return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
141             }
142             
143             function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
144                 require(address(this).balance >= value, "Address: insufficient balance for call");
145                 require(isContract(target), "Address: call to non-contract");
146                 (bool success, bytes memory returndata) = target.call{ value: value }(data);
147                 return _verifyCallResult(success, returndata, errorMessage);
148             }
149             
150             function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
151                 return functionStaticCall(target, data, "Address: low-level static call failed");
152             }
153             
154             function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
155                 require(isContract(target), "Address: static call to non-contract");
156                 (bool success, bytes memory returndata) = target.staticcall(data);
157                 return _verifyCallResult(success, returndata, errorMessage);
158             }
159 
160 
161             function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
162                 return functionDelegateCall(target, data, "Address: low-level delegate call failed");
163             }
164             
165             function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
166                 require(isContract(target), "Address: delegate call to non-contract");
167                 (bool success, bytes memory returndata) = target.delegatecall(data);
168                 return _verifyCallResult(success, returndata, errorMessage);
169             }
170 
171             function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
172                 if (success) {
173                     return returndata;
174                 } else {
175                     if (returndata.length > 0) {
176                         assembly {
177                             let returndata_size := mload(returndata)
178                             revert(add(32, returndata), returndata_size)
179                         }
180                     } else {
181                         revert(errorMessage);
182                     }
183                 }
184             }
185         }
186 
187         abstract contract Ownable is Context {
188             address internal _owner;
189             address private _previousOwner;
190 
191             event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
192             constructor () {
193                 _owner = _msgSender();
194                 emit OwnershipTransferred(address(0), _owner);
195             }
196             
197             function owner() public view virtual returns (address) {
198                 return _owner;
199             }
200             
201             modifier onlyOwner() {
202                 require(owner() == _msgSender(), "Ownable: caller is not the owner");
203                 _;
204             }
205             
206             function renounceOwnership() public virtual onlyOwner {
207                 emit OwnershipTransferred(_owner, address(0));
208                 _owner = address(0);
209             }
210 
211 
212             function transferOwnership(address newOwner) public virtual onlyOwner {
213                 require(newOwner != address(0), "Ownable: new owner is the zero address");
214                 emit OwnershipTransferred(_owner, newOwner);
215                 _owner = newOwner;
216             }
217         }
218 
219         contract LockToken is Ownable {
220 
221         bool public isOpen = false;
222         mapping(address => bool) private _whiteList;
223         modifier open(address from, address to) {
224             require(isOpen || _whiteList[from] || _whiteList[to], " Trading is not Open");
225             _;
226         }
227 
228         constructor() {
229             _whiteList[msg.sender] = true;
230             _whiteList[address(this)] = true;
231         }
232 
233         function openTrade(bool value) external onlyOwner {
234             isOpen = value;
235         }
236 
237         function includeToWhiteList(address _users, bool _trueFalse) external onlyOwner 
238         {
239             _whiteList[_users] = _trueFalse;
240         }
241     }
242         interface IERC20Metadata is IERC20 {
243             /**
244             * @dev Returns the name of the token.
245             */
246             function name() external view returns (string memory);
247 
248             /**
249             * @dev Returns the symbol of the token.
250             */
251             function symbol() external view returns (string memory);
252 
253             /**
254             * @dev Returns the decimals places of the token.
255             */
256             function decimals() external view returns (uint8);
257         }
258         contract ERC20 is Context,Ownable, IERC20, IERC20Metadata {
259             using SafeMath for uint256;
260 
261             mapping(address => uint256) private _balances;
262 
263             mapping(address => mapping(address => uint256)) private _allowances;
264 
265             uint256 private _totalSupply;
266 
267             string private _name;
268             string private _symbol;
269 
270             /**
271             * @dev Sets the values for {name} and {symbol}.
272             *
273             * The default value of {decimals} is 18. To select a different value for
274             * {decimals} you should overload it.
275             *
276             * All two of these values are immutable: they can only be set once during
277             * construction.
278             */
279             constructor(string memory name_, string memory symbol_) {
280                 _name = name_;
281                 _symbol = symbol_;
282             }
283 
284             /**
285             * @dev Returns the name of the token.
286             */
287             function name() public view virtual override returns (string memory) {
288                 return _name;
289             }
290 
291             /**
292             * @dev Returns the symbol of the token, usually a shorter version of the
293             * name.
294             */
295             function symbol() public view virtual override returns (string memory) {
296                 return _symbol;
297             }
298 
299             /**
300             * @dev Returns the number of decimals used to get its user representation.
301             * For example, if `decimals` equals `2`, a balance of `505` tokens should
302             * be displayed to a user as `5,05` (`505 / 10 ** 2`).
303             *
304             * Tokens usually opt for a value of 18, imitating the relationship between
305             * Ether and Wei. This is the value {ERC20} uses, unless this function is
306             * overridden;
307             *
308             * NOTE: This information is only used for _display_ purposes: it in
309             * no way affects any of the arithmetic of the contract, including
310             * {IERC20-balanceOf} and {IERC20-transfer}.
311             */
312             function decimals() public view virtual override returns (uint8) {
313                 return 18;
314             }
315 
316             /**
317             * @dev See {IERC20-totalSupply}.
318             */
319             function totalSupply() public view virtual override returns (uint256) {
320                 return _totalSupply;
321             }
322 
323             /**
324             * @dev See {IERC20-balanceOf}.
325             */
326             function balanceOf(address account) public view virtual override returns (uint256) {
327                 return _balances[account];
328             }
329 
330             /**
331             * @dev See {IERC20-transfer}.
332             *
333             * Requirements:
334             *
335             * - `recipient` cannot be the zero address.
336             * - the caller must have a balance of at least `amount`.
337             */
338             function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
339                 _transfer(_msgSender(), recipient, amount);
340                 return true;
341             }
342 
343             /**
344             * @dev See {IERC20-allowance}.
345             */
346             function allowance(address owner, address spender) public view virtual override returns (uint256) {
347                 return _allowances[owner][spender];
348             }
349 
350             /**
351             * @dev See {IERC20-approve}.
352             *
353             * Requirements:
354             *
355             * - `spender` cannot be the zero address.
356             */
357             function approve(address spender, uint256 amount) public virtual override returns (bool) {
358                 _approve(_msgSender(), spender, amount);
359                 return true;
360             }
361 
362             /**
363             * @dev See {IERC20-transferFrom}.
364             *
365             * Emits an {Approval} event indicating the updated allowance. This is not
366             * required by the EIP. See the note at the beginning of {ERC20}.
367             *
368             * Requirements:
369             *
370             * - `sender` and `recipient` cannot be the zero address.
371             * - `sender` must have a balance of at least `amount`.
372             * - the caller must have allowance for ``sender``'s tokens of at least
373             * `amount`.
374             */
375             function transferFrom(
376                 address sender,
377                 address recipient,
378                 uint256 amount
379             ) public virtual override returns (bool) {
380                 _transfer(sender, recipient, amount);
381                 _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
382                 return true;
383             }
384 
385             /**
386             * @dev Atomically increases the allowance granted to `spender` by the caller.
387             *
388             * This is an alternative to {approve} that can be used as a mitigation for
389             * problems described in {IERC20-approve}.
390             *
391             * Emits an {Approval} event indicating the updated allowance.
392             *
393             * Requirements:
394             *
395             * - `spender` cannot be the zero address.
396             */
397             function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
398                 _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
399                 return true;
400             }
401 
402             /**
403             * @dev Atomically decreases the allowance granted to `spender` by the caller.
404             *
405             * This is an alternative to {approve} that can be used as a mitigation for
406             * problems described in {IERC20-approve}.
407             *
408             * Emits an {Approval} event indicating the updated allowance.
409             *
410             * Requirements:
411             *
412             * - `spender` cannot be the zero address.
413             * - `spender` must have allowance for the caller of at least
414             * `subtractedValue`.
415             */
416             function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
417                 _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
418                 return true;
419             }
420 
421             /**
422             * @dev Moves tokens `amount` from `sender` to `recipient`.
423             *
424             * This is internal function is equivalent to {transfer}, and can be used to
425             * e.g. implement automatic token fees, slashing mechanisms, etc.
426             *
427             * Emits a {Transfer} event.
428             *
429             * Requirements:
430             *
431             * - `sender` cannot be the zero address.
432             * - `recipient` cannot be the zero address.
433             * - `sender` must have a balance of at least `amount`.
434             */
435             function _transfer(
436                 address sender,
437                 address recipient,
438                 uint256 amount
439             ) internal virtual {
440                 require(sender != address(0), "ERC20: transfer from the zero address");
441                 require(recipient != address(0), "ERC20: transfer to the zero address");
442 
443                 _beforeTokenTransfer(sender, recipient, amount);
444 
445                 _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
446                 _balances[recipient] = _balances[recipient].add(amount);
447                 emit Transfer(sender, recipient, amount);
448             }
449 
450             /** @dev Creates `amount` tokens and assigns them to `account`, increasing
451             * the total supply.
452             *
453             * Emits a {Transfer} event with `from` set to the zero address.
454             *
455             * Requirements:
456             *
457             * - `account` cannot be the zero address.
458             */
459             function _mint(address account, uint256 amount) internal virtual {
460                 require(account != address(0), "ERC20: mint to the zero address");
461 
462                 _beforeTokenTransfer(address(0), account, amount);
463 
464                 _totalSupply = _totalSupply.add(amount);
465                 _balances[account] = _balances[account].add(amount);
466                 emit Transfer(address(0), account, amount);
467             }
468 
469             /**
470             * @dev Destroys `amount` tokens from `account`, reducing the
471             * total supply.
472             *
473             * Emits a {Transfer} event with `to` set to the zero address.
474             *
475             * Requirements:
476             *
477             * - `account` cannot be the zero address.
478             * - `account` must have at least `amount` tokens.
479             */
480             function _burn(address account, uint256 amount) internal virtual {
481                 require(account != address(0), "ERC20: burn from the zero address");
482 
483                 _beforeTokenTransfer(account, address(0), amount);
484 
485                 _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
486                 _totalSupply = _totalSupply.sub(amount);
487                 emit Transfer(account, address(0), amount);
488             }
489 
490             /**
491             * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
492             *
493             * This internal function is equivalent to `approve`, and can be used to
494             * e.g. set automatic allowances for certain subsystems, etc.
495             *
496             * Emits an {Approval} event.
497             *
498             * Requirements:
499             *
500             * - `owner` cannot be the zero address.
501             * - `spender` cannot be the zero address.
502             */
503             function _approve(
504                 address owner,
505                 address spender,
506                 uint256 amount
507             ) internal virtual {
508                 require(owner != address(0), "ERC20: approve from the zero address");
509                 require(spender != address(0), "ERC20: approve to the zero address");
510 
511                 _allowances[owner][spender] = amount;
512                 emit Approval(owner, spender, amount);
513             }
514 
515             /**
516             * @dev Hook that is called before any transfer of tokens. This includes
517             * minting and burning.
518             *
519             * Calling conditions:
520             *
521             * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
522             * will be to transferred to `to`.
523             * - when `from` is zero, `amount` tokens will be minted for `to`.
524             * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
525             * - `from` and `to` are never both zero.
526             *
527             * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
528             */
529             function _beforeTokenTransfer(
530                 address from,
531                 address to,
532                 uint256 amount
533             ) internal virtual {}
534         }
535 
536 
537         interface IUniswapV2Factory {
538             event PairCreated(address indexed token0, address indexed token1, address pair, uint);
539             function feeTo() external view returns (address);
540             function feeToSetter() external view returns (address);
541             function getPair(address tokenA, address tokenB) external view returns (address pair);
542             function allPairs(uint) external view returns (address pair);
543             function allPairsLength() external view returns (uint);
544             function createPair(address tokenA, address tokenB) external returns (address pair);
545             function setFeeTo(address) external;
546             function setFeeToSetter(address) external;
547         }
548 
549         interface IUniswapV2Pair {
550             event Approval(address indexed owner, address indexed spender, uint value);
551             event Transfer(address indexed from, address indexed to, uint value);
552             function name() external pure returns (string memory);
553             function symbol() external pure returns (string memory);
554             function decimals() external pure returns (uint8);
555             function totalSupply() external view returns (uint);
556             function balanceOf(address owner) external view returns (uint);
557             function allowance(address owner, address spender) external view returns (uint);
558             function approve(address spender, uint value) external returns (bool);
559             function transfer(address to, uint value) external returns (bool);
560             function transferFrom(address from, address to, uint value) external returns (bool);
561             function DOMAIN_SEPARATOR() external view returns (bytes32);
562             function PERMIT_TYPEHASH() external pure returns (bytes32);
563             function nonces(address owner) external view returns (uint);
564             function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
565             event Mint(address indexed sender, uint amount0, uint amount1);
566             event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
567             event Swap(
568                 address indexed sender,
569                 uint amount0In,
570                 uint amount1In,
571                 uint amount0Out,
572                 uint amount1Out,
573                 address indexed to
574             );
575             event Sync(uint112 reserve0, uint112 reserve1);
576             function MINIMUM_LIQUIDITY() external pure returns (uint);
577             function factory() external view returns (address);
578             function token0() external view returns (address);
579             function token1() external view returns (address);
580             function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
581             function price0CumulativeLast() external view returns (uint);
582             function price1CumulativeLast() external view returns (uint);
583             function kLast() external view returns (uint);
584             function mint(address to) external returns (uint liquidity);
585             function burn(address to) external returns (uint amount0, uint amount1);
586             function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
587             function skim(address to) external;
588             function sync() external;
589             function initialize(address, address) external;
590         }
591 
592         interface IUniswapV2Router01 {
593             function factory() external pure returns (address);
594             function WETH() external pure returns (address);
595             function addLiquidity(
596                 address tokenA,
597                 address tokenB,
598                 uint amountADesired,
599                 uint amountBDesired,
600                 uint amountAMin,
601                 uint amountBMin,
602                 address to,
603                 uint deadline
604             ) external returns (uint amountA, uint amountB, uint liquidity);
605             function addLiquidityETH(
606                 address token,
607                 uint amountTokenDesired,
608                 uint amountTokenMin,
609                 uint amountETHMin,
610                 address to,
611                 uint deadline
612             ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
613             function removeLiquidity(
614                 address tokenA,
615                 address tokenB,
616                 uint liquidity,
617                 uint amountAMin,
618                 uint amountBMin,
619                 address to,
620                 uint deadline
621             ) external returns (uint amountA, uint amountB);
622             function removeLiquidityETH(
623                 address token,
624                 uint liquidity,
625                 uint amountTokenMin,
626                 uint amountETHMin,
627                 address to,
628                 uint deadline
629             ) external returns (uint amountToken, uint amountETH);
630             function removeLiquidityWithPermit(
631                 address tokenA,
632                 address tokenB,
633                 uint liquidity,
634                 uint amountAMin,
635                 uint amountBMin,
636                 address to,
637                 uint deadline,
638                 bool approveMax, uint8 v, bytes32 r, bytes32 s
639             ) external returns (uint amountA, uint amountB);
640             function removeLiquidityETHWithPermit(
641                 address token,
642                 uint liquidity,
643                 uint amountTokenMin,
644                 uint amountETHMin,
645                 address to,
646                 uint deadline,
647                 bool approveMax, uint8 v, bytes32 r, bytes32 s
648             ) external returns (uint amountToken, uint amountETH);
649             function swapExactTokensForTokens(
650                 uint amountIn,
651                 uint amountOutMin,
652                 address[] calldata path,
653                 address to,
654                 uint deadline
655             ) external returns (uint[] memory amounts);
656             function swapTokensForExactTokens(
657                 uint amountOut,
658                 uint amountInMax,
659                 address[] calldata path,
660                 address to,
661                 uint deadline
662             ) external returns (uint[] memory amounts);
663             function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
664                 external
665                 payable
666                 returns (uint[] memory amounts);
667             function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
668                 external
669                 returns (uint[] memory amounts);
670             function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
671                 external
672                 returns (uint[] memory amounts);
673             function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
674                 external
675                 payable
676                 returns (uint[] memory amounts);
677 
678             function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
679             function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
680             function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
681             function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
682             function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
683         }
684 
685         interface IUniswapV2Router02 is IUniswapV2Router01 {
686             function removeLiquidityETHSupportingFeeOnTransferTokens(
687                 address token,
688                 uint liquidity,
689                 uint amountTokenMin,
690                 uint amountETHMin,
691                 address to,
692                 uint deadline
693             ) external returns (uint amountETH);
694             function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
695                 address token,
696                 uint liquidity,
697                 uint amountTokenMin,
698                 uint amountETHMin,
699                 address to,
700                 uint deadline,
701                 bool approveMax, uint8 v, bytes32 r, bytes32 s
702             ) external returns (uint amountETH);
703 
704             function swapExactTokensForTokensSupportingFeeOnTransferTokens(
705                 uint amountIn,
706                 uint amountOutMin,
707                 address[] calldata path,
708                 address to,
709                 uint deadline
710             ) external;
711             function swapExactETHForTokensSupportingFeeOnTransferTokens(
712                 uint amountOutMin,
713                 address[] calldata path,
714                 address to,
715                 uint deadline
716             ) external payable;
717             function swapExactTokensForETHSupportingFeeOnTransferTokens(
718                 uint amountIn,
719                 uint amountOutMin,
720                 address[] calldata path,
721                 address to,
722                 uint deadline
723             ) external;
724         }
725 
726         contract TOKEN is ERC20, LockToken {
727             using SafeMath for uint256;
728             using Address for address;
729 
730             mapping (address => bool) private _isExcludedFromFee;
731             address public _marketingWalletAddress;   
732             address public _floorAddress;
733             uint256 public _liquidityFee;
734             uint256 private _previousLiquidityFee;
735             uint256 public _marketingFee;
736             uint256 private _previousMarketingFee;
737             uint256 public _floorFee;
738             uint256 private _previousFloorFee;
739             IUniswapV2Router02 public uniswapV2Router;
740             address public uniswapV2Pair;
741             bool inSwapAndLiquify;
742             bool public swapAndLiquifyEnabled = true;
743             uint256 public numTokensSellToAddToLiquidity;
744             uint256 public _maxWalletBalance;
745             event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
746             event SwapAndLiquifyEnabledUpdated(bool enabled);
747             
748             constructor () ERC20("colR Coin", "$colR"){
749 
750 
751                 _liquidityFee = 10;
752                 _previousLiquidityFee = _liquidityFee;        
753                 _marketingFee = 60;
754                 _previousMarketingFee = _marketingFee;
755                 _floorFee =30;
756                 _previousFloorFee = _floorFee;
757                 numTokensSellToAddToLiquidity = 50000 * 10 ** decimals();
758                 _maxWalletBalance = 200000 * 10 ** decimals();
759                 _marketingWalletAddress = 0x8A941E486772D8187B87F313a5676140842cA2b1;
760                 _floorAddress = 0xd281d8A332370f0D0DE52253629AcB897D1d621C;
761                 
762                 IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
763                 // Create a uniswap pair for this new token
764                 uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
765                     .createPair(address(this), _uniswapV2Router.WETH());
766 
767                 // set the rest of the contract variables
768                 uniswapV2Router = _uniswapV2Router;
769                 
770                 //exclude owner and this contract from fee
771                 _isExcludedFromFee[_msgSender()] = true;
772                 _isExcludedFromFee[address(this)] = true;
773             
774 
775                 /*
776                     _mint is an internal function in ERC20.sol that is only called here,
777                     and CANNOT be called ever again
778                 */
779                 _mint(owner(), 100000000 * 10 ** decimals());		
780                 
781             }
782 
783             function excludeFromFee(address account) public onlyOwner {
784                 _isExcludedFromFee[account] = true;
785             }
786             
787             function includeInFee(address account) public onlyOwner {
788                 _isExcludedFromFee[account] = false;
789             }
790             
791             function setLiquidityFeePercent(uint256 taxFee) external onlyOwner {
792                 _liquidityFee = taxFee;
793             }
794 
795             function setMarketingFeePercent(uint256 devFee) external onlyOwner {
796                 _marketingFee = devFee;
797             } 
798             
799             function setFloorFeePercent(uint256 floorFee) external onlyOwner {
800                 _floorFee = floorFee;
801             }
802 
803             function setMarketingWalletAddress(address _addr) external onlyOwner {
804                 _marketingWalletAddress = _addr;
805             }
806 
807             function setFloorWalletAddress(address _addr) external onlyOwner {
808                 _floorAddress = _addr;
809             }
810             
811             function setNumTokensSellToAddToLiquidity(uint256 amount) external onlyOwner {
812                 numTokensSellToAddToLiquidity = amount * 10 ** decimals();
813             }
814 
815             function setMaxBalance(uint256 maxBalancePercent) external onlyOwner {
816                 _maxWalletBalance = maxBalancePercent * 10** decimals();
817             }
818 
819             function setRouterAddress(address newRouter) external onlyOwner {
820                 IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(newRouter);
821                 uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
822                 uniswapV2Router = _uniswapV2Router;
823             }
824 
825             function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
826                 swapAndLiquifyEnabled = _enabled;
827                 emit SwapAndLiquifyEnabledUpdated(_enabled);
828             }
829             
830             //to recieve ETH from uniswapV2Router when swaping
831             receive() external payable {}
832 
833             // to withdraw stucked ETH 
834             function withdrawStuckedFunds(uint amount) external onlyOwner{
835                 // This is the current recommended method to use.
836                 (bool sent,) = _owner.call{value: amount}("");
837                 require(sent, "Failed to send ETH");    
838             }
839 
840             // Withdraw stuked tokens 
841             function withdrawStuckedTokens(address tokenAddress, uint256 tokens) external onlyOwner returns (bool success){
842             return IERC20(tokenAddress).transfer(msg.sender, tokens);
843             }
844         
845 
846             function isExcludedFromFee(address account) public view returns(bool) {
847                 return _isExcludedFromFee[account];
848             }
849 
850             function _transfer(
851                 address from,
852                 address to,
853                 uint256 amount
854             ) internal override open(from, to) {
855                 require(from != address(0), "ERC20: transfer from the zero address");
856                 require(to != address(0), "ERC20: transfer to the zero address");
857                 require(amount > 0, "Transfer amount must be greater than zero");
858                 
859                 if (from != owner() && to != uniswapV2Pair)
860                 require(
861                 balanceOf(to).add(amount) <= _maxWalletBalance,
862                 "Balance is exceeding maxWalletBalance"
863                 );
864 
865                 uint256 contractTokenBalance = balanceOf(address(this)); 
866                 bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
867                 if (
868                     overMinTokenBalance &&
869                     !inSwapAndLiquify &&
870                     from != uniswapV2Pair &&
871                     swapAndLiquifyEnabled
872                 ) {
873                     contractTokenBalance = numTokensSellToAddToLiquidity;
874                     inSwapAndLiquify = true;
875                     swapBack(contractTokenBalance);
876                     inSwapAndLiquify = false;
877                 }
878                 
879                 if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
880                 super._transfer(from, to, amount);
881                 }
882                 else
883                 {
884                     uint256 lpTokens = amount.mul(_liquidityFee).div(1000);
885                     uint256 marketingTokens = amount.mul(_marketingFee).div(1000);
886                     uint256 floorTokens = amount.mul(_floorFee).div(1000);
887                     amount= amount.sub(lpTokens).sub(marketingTokens).sub(floorTokens);
888                     super._transfer(from, address(this), lpTokens.add(floorTokens).add(marketingTokens));
889                     super._transfer(from, to, amount);
890                 }
891                 
892             }
893 
894             function swapBack(uint256 contractBalance) private {
895 
896                 uint256 tokensForLiquidity = contractBalance.mul(_liquidityFee).div(1000);
897                 uint256 marketingTokens = contractBalance.mul(_marketingFee).div(1000);
898                 uint256 floorTokens = contractBalance.mul(_floorFee).div(1000);
899 
900 
901                 uint256 totalTokensToSwap = tokensForLiquidity + marketingTokens + floorTokens ;
902                 
903                 if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
904 
905                 bool success;
906                 
907                 // Halve the amount of liquidity tokens
908                 uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
909                 
910                 swapTokensForEth(contractBalance - liquidityTokens); 
911                 
912                 uint256 ethBalance = address(this).balance;
913                 uint256 ethForLiquidity = ethBalance;
914 
915                 uint256 ethForMarketing = ethBalance * marketingTokens / (totalTokensToSwap - (tokensForLiquidity/2));
916                 uint256 ethForFloor = ethBalance * floorTokens / (totalTokensToSwap - (tokensForLiquidity/2));
917 
918                 ethForLiquidity -= ethForMarketing + ethForFloor ;
919                                 
920                 if(liquidityTokens > 0 && ethForLiquidity > 0){
921                     addLiquidity(liquidityTokens, ethForLiquidity);
922 
923                 }
924 
925                 (success,) = address(_marketingWalletAddress).call{value: ethForMarketing}("");
926                 (success,) = address(_floorAddress).call{value: ethForFloor}("");
927 
928         }       
929 
930         
931 
932             function swapTokensForEth(uint256 tokenAmount) private {
933                 address[] memory path = new address[](2);
934                 path[0] = address(this);
935                 path[1] = uniswapV2Router.WETH();
936                 _approve(address(this), address(uniswapV2Router), tokenAmount);
937                 uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
938                     tokenAmount,
939                     0, // accept any amount of ETH
940                     path,
941                     address(this),
942                     block.timestamp
943                 );
944             }
945 
946             function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
947                 _approve(address(this), address(uniswapV2Router), tokenAmount);
948                 uniswapV2Router.addLiquidityETH{value: ethAmount}(
949                     address(this),
950                     tokenAmount,
951                     0, // slippage is unavoidable
952                     0, // slippage is unavoidable
953                     owner(),
954                     block.timestamp
955                 );
956             }
957 
958         function airdrop(address[] memory wallets, uint256[] memory amounts) external onlyOwner {
959         require(wallets.length == amounts.length, "arrays must be the same length");
960         require(wallets.length <= 200, "Can only airdrop 200 wallets per txn due to gas limits");
961             
962         for (uint i=0; i<wallets.length; i++) {
963             address wallet = wallets[i];
964             uint256 amount = amounts[i] * 10 ** decimals();
965             transfer(wallet, amount);
966         }
967     }
968         }