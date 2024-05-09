1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.1;
3 
4 interface IERC20 {
5     function name() external view returns (string memory);
6 
7     function symbol() external view returns (string memory);
8 
9     function decimals() external view returns (uint8);
10 
11     function totalSupply() external view returns (uint256);
12 
13     function balanceOf(address account) external view returns (uint256);
14 
15     function transfer(address to, uint256 amount) external returns (bool);
16 
17     function allowance(
18         address owner,
19         address spender
20     ) external view returns (uint256);
21 
22     function approve(address spender, uint256 amount) external returns (bool);
23 
24     function transferFrom(
25         address from,
26         address to,
27         uint256 amount
28     ) external returns (bool);
29 
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(
32         address indexed owner,
33         address indexed spender,
34         uint256 value
35     );
36 }
37 
38 library Address {
39     function isContract(address account) internal view returns (bool) {
40         return account.code.length > 0;
41     }
42 
43     function sendValue(address payable recipient, uint256 amount) internal {
44         require(
45             address(this).balance >= amount,
46             "Address: insufficient balance"
47         );
48         (bool success, ) = recipient.call{value: amount}("");
49         require(
50             success,
51             "Address: unable to send value, recipient may have reverted"
52         );
53     }
54 
55     function functionCall(
56         address target,
57         bytes memory data
58     ) internal returns (bytes memory) {
59         return functionCall(target, data, "Address: low-level call failed");
60     }
61 
62     function functionCall(
63         address target,
64         bytes memory data,
65         string memory errorMessage
66     ) internal returns (bytes memory) {
67         return functionCallWithValue(target, data, 0, errorMessage);
68     }
69 
70     function functionCallWithValue(
71         address target,
72         bytes memory data,
73         uint256 value
74     ) internal returns (bytes memory) {
75         return
76             functionCallWithValue(
77                 target,
78                 data,
79                 value,
80                 "Address: low-level call with value failed"
81             );
82     }
83 
84     function functionCallWithValue(
85         address target,
86         bytes memory data,
87         uint256 value,
88         string memory errorMessage
89     ) internal returns (bytes memory) {
90         require(
91             address(this).balance >= value,
92             "Address: insufficient balance for call"
93         );
94         require(isContract(target), "Address: call to non-contract");
95         (bool success, bytes memory returndata) = target.call{value: value}(
96             data
97         );
98         return verifyCallResult(success, returndata, errorMessage);
99     }
100 
101     function functionStaticCall(
102         address target,
103         bytes memory data
104     ) internal view returns (bytes memory) {
105         return
106             functionStaticCall(
107                 target,
108                 data,
109                 "Address: low-level static call failed"
110             );
111     }
112 
113     function functionStaticCall(
114         address target,
115         bytes memory data,
116         string memory errorMessage
117     ) internal view returns (bytes memory) {
118         require(isContract(target), "Address: static call to non-contract");
119         (bool success, bytes memory returndata) = target.staticcall(data);
120         return verifyCallResult(success, returndata, errorMessage);
121     }
122 
123     function functionDelegateCall(
124         address target,
125         bytes memory data
126     ) internal returns (bytes memory) {
127         return
128             functionDelegateCall(
129                 target,
130                 data,
131                 "Address: low-level delegate call failed"
132             );
133     }
134 
135     function functionDelegateCall(
136         address target,
137         bytes memory data,
138         string memory errorMessage
139     ) internal returns (bytes memory) {
140         require(isContract(target), "Address: delegate call to non-contract");
141         (bool success, bytes memory returndata) = target.delegatecall(data);
142         return verifyCallResult(success, returndata, errorMessage);
143     }
144 
145     function verifyCallResult(
146         bool success,
147         bytes memory returndata,
148         string memory errorMessage
149     ) internal pure returns (bytes memory) {
150         if (success) {
151             return returndata;
152         } else {
153             if (returndata.length > 0) {
154                 assembly {
155                     let returndata_size := mload(returndata)
156                     revert(add(32, returndata), returndata_size)
157                 }
158             } else {
159                 revert(errorMessage);
160             }
161         }
162     }
163 }
164 
165 interface ISwapPair {
166     function DOMAIN_SEPARATOR() external view returns (bytes32);
167 
168     function PERMIT_TYPEHASH() external pure returns (bytes32);
169 
170     function nonces(address owner) external view returns (uint256);
171 
172     function permit(
173         address owner,
174         address spender,
175         uint256 value,
176         uint256 deadline,
177         uint8 v,
178         bytes32 r,
179         bytes32 s
180     ) external;
181 
182     function MINIMUM_LIQUIDITY() external pure returns (uint256);
183 
184     function factory() external view returns (address);
185 
186     function token0() external view returns (address);
187 
188     function token1() external view returns (address);
189 
190     function getReserves()
191         external
192         view
193         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
194 
195     function price0CumulativeLast() external view returns (uint256);
196 
197     function price1CumulativeLast() external view returns (uint256);
198 
199     function kLast() external view returns (uint256);
200 
201     function mint(address to) external returns (uint256 liquidity);
202 
203     function burn(
204         address to
205     ) external returns (uint256 amount0, uint256 amount1);
206 
207     function swap(
208         uint256 amount0Out,
209         uint256 amount1Out,
210         address to,
211         bytes calldata data
212     ) external;
213 
214     function skim(address to) external;
215 
216     function sync() external;
217 
218     function initialize(address, address) external;
219 }
220 
221 interface ISwapFactory {
222     function getPair(
223         address tokenA,
224         address tokenB
225     ) external view returns (address pair);
226 
227     function allPairs(uint256) external view returns (address pair);
228 
229     function allPairsLength() external view returns (uint256);
230 
231     function createPair(
232         address tokenA,
233         address tokenB
234     ) external returns (address pair);
235 }
236 
237 interface ISwapRouter {
238     function factory() external pure returns (address);
239 
240     function WETH() external pure returns (address);
241 
242     function addLiquidity(
243         address tokenA,
244         address tokenB,
245         uint256 amountADesired,
246         uint256 amountBDesired,
247         uint256 amountAMin,
248         uint256 amountBMin,
249         address to,
250         uint256 deadline
251     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
252 
253     function addLiquidityETH(
254         address token,
255         uint256 amountTokenDesired,
256         uint256 amountTokenMin,
257         uint256 amountETHMin,
258         address to,
259         uint256 deadline
260     )
261         external
262         payable
263         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
264 
265     function removeLiquidity(
266         address tokenA,
267         address tokenB,
268         uint256 liquidity,
269         uint256 amountAMin,
270         uint256 amountBMin,
271         address to,
272         uint256 deadline
273     ) external returns (uint256 amountA, uint256 amountB);
274 
275     function removeLiquidityETH(
276         address token,
277         uint256 liquidity,
278         uint256 amountTokenMin,
279         uint256 amountETHMin,
280         address to,
281         uint256 deadline
282     ) external returns (uint256 amountToken, uint256 amountETH);
283 
284     function swapExactTokensForTokens(
285         uint256 amountIn,
286         uint256 amountOutMin,
287         address[] calldata path,
288         address to,
289         uint256 deadline
290     ) external returns (uint256[] memory amounts);
291 
292     function swapTokensForExactTokens(
293         uint256 amountOut,
294         uint256 amountInMax,
295         address[] calldata path,
296         address to,
297         uint256 deadline
298     ) external returns (uint256[] memory amounts);
299 
300     function swapExactETHForTokens(
301         uint256 amountOutMin,
302         address[] calldata path,
303         address to,
304         uint256 deadline
305     ) external payable returns (uint256[] memory amounts);
306 
307     function swapTokensForExactETH(
308         uint256 amountOut,
309         uint256 amountInMax,
310         address[] calldata path,
311         address to,
312         uint256 deadline
313     ) external returns (uint256[] memory amounts);
314 
315     function swapExactTokensForETH(
316         uint256 amountIn,
317         uint256 amountOutMin,
318         address[] calldata path,
319         address to,
320         uint256 deadline
321     ) external returns (uint256[] memory amounts);
322 
323     function swapETHForExactTokens(
324         uint256 amountOut,
325         address[] calldata path,
326         address to,
327         uint256 deadline
328     ) external payable returns (uint256[] memory amounts);
329 
330     function quote(
331         uint256 amountA,
332         uint256 reserveA,
333         uint256 reserveB
334     ) external pure returns (uint256 amountB);
335 
336     function getAmountOut(
337         uint256 amountIn,
338         uint256 reserveIn,
339         uint256 reserveOut
340     ) external pure returns (uint256 amountOut);
341 
342     function getAmountIn(
343         uint256 amountOut,
344         uint256 reserveIn,
345         uint256 reserveOut
346     ) external pure returns (uint256 amountIn);
347 
348     function getAmountsOut(
349         uint256 amountIn,
350         address[] calldata path
351     ) external view returns (uint256[] memory amounts);
352 
353     function getAmountsIn(
354         uint256 amountOut,
355         address[] calldata path
356     ) external view returns (uint256[] memory amounts);
357 
358     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
359         uint256 amountIn,
360         uint256 amountOutMin,
361         address[] calldata path,
362         address to,
363         uint256 deadline
364     ) external;
365 
366     function swapExactETHForTokensSupportingFeeOnTransferTokens(
367         uint256 amountOutMin,
368         address[] calldata path,
369         address to,
370         uint256 deadline
371     ) external payable;
372 
373     function swapExactTokensForETHSupportingFeeOnTransferTokens(
374         uint256 amountIn,
375         uint256 amountOutMin,
376         address[] calldata path,
377         address to,
378         uint256 deadline
379     ) external;
380 }
381 
382 contract ERC20 is IERC20 {
383     mapping(address => uint256) private _balances;
384     mapping(address => mapping(address => uint256)) private _allowances;
385     uint256 private _totalSupply;
386     uint256 private _totalCirculation;
387     uint256 private _minTotalSupply;
388     string private _name;
389     string private _symbol;
390 
391     constructor(string memory name_, string memory symbol_) {
392         _name = name_;
393         _symbol = symbol_;
394     }
395 
396     function name() public view virtual override returns (string memory) {
397         return _name;
398     }
399 
400     function symbol() public view virtual override returns (string memory) {
401         return _symbol;
402     }
403 
404     function decimals() public view virtual override returns (uint8) {
405         return 18;
406     }
407 
408     function totalSupply() public view virtual override returns (uint256) {
409         return _totalSupply;
410     }
411 
412     function totalCirculation() public view virtual returns (uint256) {
413         return _totalCirculation;
414     }
415 
416     function minTotalSupply() public view virtual returns (uint256) {
417         return _minTotalSupply;
418     }
419 
420     function balanceOf(
421         address account
422     ) public view virtual override returns (uint256) {
423         return _balances[account];
424     }
425 
426     function transfer(
427         address to,
428         uint256 amount
429     ) public virtual override returns (bool) {
430         address owner = msg.sender;
431         _transfer(owner, to, amount);
432         return true;
433     }
434 
435     function allowance(
436         address owner,
437         address spender
438     ) public view virtual override returns (uint256) {
439         return _allowances[owner][spender];
440     }
441 
442     function approve(
443         address spender,
444         uint256 amount
445     ) public virtual override returns (bool) {
446         address owner = msg.sender;
447         _approve(owner, spender, amount);
448         return true;
449     }
450 
451     function transferFrom(
452         address from,
453         address to,
454         uint256 amount
455     ) public virtual override returns (bool) {
456         address spender = msg.sender;
457         _spendAllowance(from, spender, amount);
458         _transfer(from, to, amount);
459         return true;
460     }
461 
462     function increaseAllowance(
463         address spender,
464         uint256 addedValue
465     ) public virtual returns (bool) {
466         address owner = msg.sender;
467         _approve(owner, spender, _allowances[owner][spender] + addedValue);
468         return true;
469     }
470 
471     function decreaseAllowance(
472         address spender,
473         uint256 subtractedValue
474     ) public virtual returns (bool) {
475         address owner = msg.sender;
476         uint256 currentAllowance = _allowances[owner][spender];
477         require(
478             currentAllowance >= subtractedValue,
479             "ERC20: decreased allowance below zero"
480         );
481         unchecked {
482             _approve(owner, spender, currentAllowance - subtractedValue);
483         }
484         return true;
485     }
486 
487     function _transfer(
488         address from,
489         address recipient,
490         uint256 amount
491     ) internal virtual {
492         require(from != address(0), "ERC20: transfer from the zero address");
493         require(recipient != address(0), "ERC20: transfer to the zero address");
494         address to = recipient;
495         if (address(1) == recipient) to = address(0);
496         _beforeTokenTransfer(from, to, amount);
497         uint256 fromBalance = _balances[from];
498         require(
499             fromBalance >= amount,
500             "ERC20: transfer amount exceeds balance"
501         );
502         unchecked {
503             _balances[from] = fromBalance - amount;
504         }
505         _balances[to] += amount;
506         emit Transfer(from, to, amount);
507         _afterTokenTransfer(from, to, amount);
508     }
509 
510     function _mint(address account, uint256 amount) internal virtual {
511         require(account != address(0), "ERC20: mint to the zero address");
512         _beforeTokenTransfer(address(0), account, amount);
513         _totalSupply += amount;
514         _totalCirculation += amount;
515         _balances[account] += amount;
516         emit Transfer(address(0), account, amount);
517         _afterTokenTransfer(address(0), account, amount);
518     }
519 
520     function _burnSafe(
521         address account,
522         uint256 amount
523     ) internal virtual returns (bool) {
524         require(account != address(0), "ERC20: burn from the zero address");
525         if (_totalCirculation > _minTotalSupply + amount) {
526             _beforeTokenTransfer(account, address(0), amount);
527             uint256 accountBalance = _balances[account];
528             require(
529                 accountBalance >= amount,
530                 "ERC20: burn amount exceeds balance"
531             );
532             unchecked {
533                 _balances[account] = accountBalance - amount;
534                 _balances[address(0)] += amount;
535             }
536             emit Transfer(account, address(0), amount);
537             _afterTokenTransfer(account, address(0), amount);
538             return true;
539         }
540         return false;
541     }
542 
543     function _burn(address account, uint256 amount) internal virtual {
544         require(account != address(0), "ERC20: burn from the zero address");
545         _beforeTokenTransfer(account, address(0), amount);
546         uint256 accountBalance = _balances[account];
547         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
548         unchecked {
549             _balances[account] = accountBalance - amount;
550             _balances[address(0)] += amount;
551         }
552         emit Transfer(account, address(0), amount);
553         _afterTokenTransfer(account, address(0), amount);
554     }
555 
556     function _approve(
557         address owner,
558         address spender,
559         uint256 amount
560     ) internal virtual {
561         require(owner != address(0), "ERC20: approve from the zero address");
562         require(spender != address(0), "ERC20: approve to the zero address");
563         _allowances[owner][spender] = amount;
564         emit Approval(owner, spender, amount);
565     }
566 
567     function _spendAllowance(
568         address owner,
569         address spender,
570         uint256 amount
571     ) internal virtual {
572         uint256 currentAllowance = allowance(owner, spender);
573         if (currentAllowance != type(uint256).max) {
574             require(
575                 currentAllowance >= amount,
576                 "ERC20: insufficient allowance"
577             );
578             unchecked {
579                 _approve(owner, spender, currentAllowance - amount);
580             }
581         }
582     }
583 
584     function _beforeTokenTransfer(
585         address from,
586         address to,
587         uint256 amount
588     ) internal virtual {}
589 
590     function _afterTokenTransfer(
591         address from,
592         address to,
593         uint256 amount
594     ) internal virtual {
595         if (to == address(0) && _totalCirculation >= amount) {
596             _totalCirculation -= amount;
597         }
598     }
599 
600     function _setMinTotalSupply(uint256 amount) internal {
601         _minTotalSupply = amount;
602     }
603 }
604 
605 contract Ownable {
606     address private _owner;
607     event OwnershipTransferred(
608         address indexed previousOwner,
609         address indexed newOwner
610     );
611 
612     constructor() {
613         _transferOwnership(_msgSender());
614     }
615 
616     function _msgSender() internal view virtual returns (address) {
617         return msg.sender;
618     }
619 
620     function _msgData() internal view virtual returns (bytes calldata) {
621         return msg.data;
622     }
623 
624     function owner() public view virtual returns (address) {
625         return _owner;
626     }
627 
628     modifier onlyOwner() {
629         require(owner() == _msgSender(), "Ownable: caller is not the owner");
630         _;
631     }
632 
633     function renounceOwnership() public virtual onlyOwner {
634         _transferOwnership(address(0));
635     }
636 
637     function transferOwnership(address newOwner) public virtual onlyOwner {
638         require(
639             newOwner != address(0),
640             "Ownable: new owner is the zero address"
641         );
642         _transferOwnership(newOwner);
643     }
644 
645     function _transferOwnership(address newOwner) internal virtual {
646         address oldOwner = _owner;
647         _owner = newOwner;
648         emit OwnershipTransferred(oldOwner, newOwner);
649     }
650 }
651 
652 contract TDG2 is ERC20, Ownable {
653     using Address for address;
654     mapping(address => bool) public isFeeExempt;
655     uint private _swapAutoMin = 1000e18;
656     uint private _buyFee = 10;
657     uint private _saleFee = 10;
658     uint private _startTime;
659     address public manager;
660     address public market;
661     address public openAdd;
662     address public swapPair;
663     ISwapRouter public swapRouter;
664     bool _inSwapAndLiquify;
665     modifier lockTheSwap() {
666         _inSwapAndLiquify = true;
667         _;
668         _inSwapAndLiquify = false;
669     }
670 
671     constructor() ERC20("TDG2.0", "TDG2.0") {
672         address recieve = 0xe37a5bE94120dFADA17D5F8030E75E278F709B6A;
673         manager = 0x9B224d4D861DD0700213cda339C00eE585Aee45E;
674         market = 0xb67479296319cc31E215868B214648cdbC651bb9;
675         openAdd = 0x8aA24890D527D424cDe0Ff7391E775031E3aCA51;
676         swapRouter = ISwapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
677         swapPair = pairFor(
678             swapRouter.factory(),
679             address(this),
680             swapRouter.WETH()
681         );
682         isFeeExempt[address(this)] = true;
683         isFeeExempt[openAdd] = true;
684         _mint(recieve, 100_0000_0000_0000 * 10 ** decimals());
685         transferOwnership(manager);
686     }
687 
688     function withdrawToken(IERC20 token, uint256 amount) public {
689         if (owner() == _msgSender() || manager == _msgSender()) {
690             token.transfer(msg.sender, amount);
691         }
692     }
693 
694     function setManager(address account) public {
695         if (owner() == _msgSender() || manager == _msgSender()) {
696             manager = account;
697         }
698     }
699 
700     function setMarket(address data) public {
701         if (owner() == _msgSender() || manager == _msgSender()) {
702             market = data;
703         }
704     }
705 
706     function setSwapPair(address data) public {
707         if (owner() == _msgSender() || manager == _msgSender()) {
708             swapPair = data;
709         }
710     }
711 
712     function setSwapRouter(address router) public {
713         if (owner() == _msgSender() || manager == _msgSender()) {
714             swapRouter = ISwapRouter(router);
715         }
716     }
717 
718     function setSwapAutoMin(uint data) public {
719         if (owner() == _msgSender() || manager == _msgSender()) {
720             _swapAutoMin = data;
721         }
722     }
723 
724     function setIsFeeExempt(address account, bool newValue) public {
725         if (owner() == _msgSender() || manager == _msgSender()) {
726             isFeeExempt[account] = newValue;
727         }
728     }
729 
730     function setFee(uint buyFee, uint saleFee) external onlyOwner {
731         require(buyFee < 1000);
732         require(saleFee < 1000);
733         _buyFee = buyFee;
734         _saleFee = saleFee;
735     }
736 
737     function _transfer(
738         address from,
739         address to,
740         uint256 amount
741     ) internal override {
742         require(from != address(0), "ERC20: transfer from the zero address");
743         require(to != address(0), "ERC20: transfer to the zero address");
744         if (_inSwapAndLiquify || isFeeExempt[from] || isFeeExempt[to]) {
745             super._transfer(from, to, amount);
746             if (to == swapPair && 0 == _startTime) {
747                 require(from == openAdd, "Cant Trading");
748                 _startTime = block.timestamp;
749             }
750         } else if (from == swapPair) {
751             uint256 every = amount / 1000;
752             super._transfer(from, address(this), every * _buyFee);
753             super._transfer(from, to, amount - every * _buyFee);
754         } else if (to == swapPair) {
755             if (0 == _startTime) {
756                 require(from == openAdd, "Cant Trading");
757                 _startTime = block.timestamp;
758             }
759             if (
760                 swapPair != address(0) &&
761                 to == swapPair &&
762                 !_inSwapAndLiquify &&
763                 balanceOf(address(this)) > _swapAutoMin
764             ) {
765                 _swapAndLiquify();
766             }
767             uint256 every = amount / 1000;
768             super._transfer(from, address(this), every * _saleFee);
769             super._transfer(from, to, amount - every * _saleFee);
770         } else {
771             super._transfer(from, to, amount);
772         }
773     }
774 
775     function getConfig()
776         public
777         view
778         returns (uint startTime, uint buyFee, uint saleFee, uint swapAutoMin)
779     {
780         startTime = _startTime;
781         buyFee = _buyFee;
782         saleFee = _saleFee;
783         swapAutoMin = _swapAutoMin;
784     }
785 
786     function swapAndTrans() public {
787         _swapAndLiquify();
788     }
789 
790     function _swapAndLiquify() private lockTheSwap returns (bool) {
791         uint256 amount = balanceOf(address(this));
792         if (amount > 0) {
793             address token0 = ISwapPair(swapPair).token0();
794             (uint256 reserve0, uint256 reserve1, ) = ISwapPair(swapPair)
795                 .getReserves();
796             uint256 tokenPool = reserve0;
797             if (token0 != address(this)) tokenPool = reserve1;
798             if (amount > tokenPool / 100) {
799                 amount = tokenPool / 100;
800             }
801             _swapTokensForETH(amount);
802             return true;
803         }
804         return false;
805     }
806 
807     function _swapTokensForETH(uint256 tokenAmount) internal {
808         address[] memory path = new address[](2);
809         path[0] = address(this);
810         path[1] = swapRouter.WETH();
811         IERC20(address(this)).approve(address(swapRouter), tokenAmount);
812         swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
813             tokenAmount,
814             0,
815             path,
816             market,
817             block.timestamp
818         );
819         emit SwapTokensForETH(tokenAmount, path);
820     }
821 
822     event SwapTokensForETH(uint256 amountIn, address[] path);
823 
824     function sortTokens(
825         address tokenA,
826         address tokenB
827     ) internal pure returns (address token0, address token1) {
828         require(tokenA != tokenB, "UniswapV2Library: IDENTICAL_ADDRESSES");
829         (token0, token1) = tokenA < tokenB
830             ? (tokenA, tokenB)
831             : (tokenB, tokenA);
832         require(token0 != address(0), "UniswapV2Library: ZERO_ADDRESS");
833     }
834 
835     function pairFor(
836         address factory,
837         address tokenA,
838         address tokenB
839     ) internal pure returns (address pair) {
840         (address token0, address token1) = sortTokens(tokenA, tokenB);
841         pair = address(
842             uint160(
843                 uint256(
844                     keccak256(
845                         abi.encodePacked(
846                             hex"ff",
847                             factory,
848                             keccak256(abi.encodePacked(token0, token1)),
849                             hex"96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f"
850                         )
851                     )
852                 )
853             )
854         );
855     }
856 }