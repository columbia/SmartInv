1 pragma solidity 0.8.20;
2 
3 /**
4  * SPDX-License-Identifier: MIT
5  */
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal pure virtual returns (bytes calldata) {
13         return msg.data;
14     }
15 }
16 
17 abstract contract Ownable is Context {
18     address private _owner;
19 
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21     constructor() {
22         _transferOwnership(_msgSender());
23     }
24     function owner() public view virtual returns (address) {
25         return _owner;
26     }
27     modifier onlyOwner() {
28         require(owner() == _msgSender(), "Ownable: caller is not the owner");
29         _;
30     }
31     function renounceOwnership() public virtual onlyOwner {
32         _transferOwnership(address(0));
33     }
34     function transferOwnership(address newOwner) public virtual onlyOwner {
35         require(newOwner != address(0), "Ownable: new owner is the zero address");
36         _transferOwnership(newOwner);
37     }
38     function _transferOwnership(address newOwner) internal virtual {
39         address oldOwner = _owner;
40         _owner = newOwner;
41         emit OwnershipTransferred(oldOwner, newOwner);
42     }
43 }
44 
45 
46 interface IDexFactory {
47     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
48     function createPair(address tokenA, address tokenB) external returns (address pair);
49 }
50 
51 library Address {
52     function isContract(address account) internal view returns (bool) {
53         // This method relies on extcodesize, which returns 0 for contracts in
54         // construction, since the code is only stored at the end of the
55         // constructor execution.
56 
57         uint256 size;
58         assembly {
59             size := extcodesize(account)
60         }
61         return size > 0;
62     }
63     function sendValue(address payable recipient, uint256 amount) internal {
64         require(address(this).balance >= amount, "Address: insufficient balance");
65 
66         (bool success, ) = recipient.call{value: amount}("");
67         require(success, "Address: unable to send value, recipient may have reverted");
68     }
69     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
70         return functionCall(target, data, "Address: low-level call failed");
71     }
72     function functionCall(
73         address target,
74         bytes memory data,
75         string memory errorMessage
76     ) internal returns (bytes memory) {
77         return functionCallWithValue(target, data, 0, errorMessage);
78     }
79     function functionCallWithValue(
80         address target,
81         bytes memory data,
82         uint256 value
83     ) internal returns (bytes memory) {
84         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
85     }
86     function functionCallWithValue(
87         address target,
88         bytes memory data,
89         uint256 value,
90         string memory errorMessage
91     ) internal returns (bytes memory) {
92         require(address(this).balance >= value, "Address: insufficient balance for call");
93         require(isContract(target), "Address: call to non-contract");
94 
95         (bool success, bytes memory returndata) = target.call{value: value}(data);
96         return verifyCallResult(success, returndata, errorMessage);
97     }
98     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
99         return functionStaticCall(target, data, "Address: low-level static call failed");
100     }
101     function functionStaticCall(
102         address target,
103         bytes memory data,
104         string memory errorMessage
105     ) internal view returns (bytes memory) {
106         require(isContract(target), "Address: static call to non-contract");
107 
108         (bool success, bytes memory returndata) = target.staticcall(data);
109         return verifyCallResult(success, returndata, errorMessage);
110     }
111     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
112         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
113     }
114     function functionDelegateCall(
115         address target,
116         bytes memory data,
117         string memory errorMessage
118     ) internal returns (bytes memory) {
119         require(isContract(target), "Address: delegate call to non-contract");
120 
121         (bool success, bytes memory returndata) = target.delegatecall(data);
122         return verifyCallResult(success, returndata, errorMessage);
123     }
124     function verifyCallResult(
125         bool success,
126         bytes memory returndata,
127         string memory errorMessage
128     ) internal pure returns (bytes memory) {
129         if (success) {
130             return returndata;
131         } else {
132             // Look for revert reason and bubble it up if present
133             if (returndata.length > 0) {
134                 // The easiest way to bubble the revert reason is using memory via assembly
135 
136                 assembly {
137                     let returndata_size := mload(returndata)
138                     revert(add(32, returndata), returndata_size)
139                 }
140             } else {
141                 revert(errorMessage);
142             }
143         }
144     }
145 }
146 
147 interface IDexRouter {
148     function factory() external pure returns (address);
149     function WETH() external pure returns (address);
150 
151     function addLiquidity(
152         address tokenA,
153         address tokenB,
154         uint amountADesired,
155         uint amountBDesired,
156         uint amountAMin,
157         uint amountBMin,
158         address to,
159         uint deadline
160     ) external returns (uint amountA, uint amountB, uint liquidity);
161     function addLiquidityETH(
162         address token,
163         uint amountTokenDesired,
164         uint amountTokenMin,
165         uint amountETHMin,
166         address to,
167         uint deadline
168     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
169     function removeLiquidity(
170         address tokenA,
171         address tokenB,
172         uint liquidity,
173         uint amountAMin,
174         uint amountBMin,
175         address to,
176         uint deadline
177     ) external returns (uint amountA, uint amountB);
178     function removeLiquidityETH(
179         address token,
180         uint liquidity,
181         uint amountTokenMin,
182         uint amountETHMin,
183         address to,
184         uint deadline
185     ) external returns (uint amountToken, uint amountETH);
186     function removeLiquidityWithPermit(
187         address tokenA,
188         address tokenB,
189         uint liquidity,
190         uint amountAMin,
191         uint amountBMin,
192         address to,
193         uint deadline,
194         bool approveMax, uint8 v, bytes32 r, bytes32 s
195     ) external returns (uint amountA, uint amountB);
196     function removeLiquidityETHWithPermit(
197         address token,
198         uint liquidity,
199         uint amountTokenMin,
200         uint amountETHMin,
201         address to,
202         uint deadline,
203         bool approveMax, uint8 v, bytes32 r, bytes32 s
204     ) external returns (uint amountToken, uint amountETH);
205     function swapExactTokensForTokens(
206         uint amountIn,
207         uint amountOutMin,
208         address[] calldata path,
209         address to,
210         uint deadline
211     ) external returns (uint[] memory amounts);
212     function swapTokensForExactTokens(
213         uint amountOut,
214         uint amountInMax,
215         address[] calldata path,
216         address to,
217         uint deadline
218     ) external returns (uint[] memory amounts);
219     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
220     external
221     payable
222     returns (uint[] memory amounts);
223     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
224     external
225     returns (uint[] memory amounts);
226     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
227     external
228     returns (uint[] memory amounts);
229     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
230     external
231     payable
232     returns (uint[] memory amounts);
233 
234     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
235     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
236     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
237     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
238     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
239 
240     function removeLiquidityETHSupportingFeeOnTransferTokens(
241         address token,
242         uint liquidity,
243         uint amountTokenMin,
244         uint amountETHMin,
245         address to,
246         uint deadline
247     ) external returns (uint amountETH);
248     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
249         address token,
250         uint liquidity,
251         uint amountTokenMin,
252         uint amountETHMin,
253         address to,
254         uint deadline,
255         bool approveMax, uint8 v, bytes32 r, bytes32 s
256     ) external returns (uint amountETH);
257 
258     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
259         uint amountIn,
260         uint amountOutMin,
261         address[] calldata path,
262         address to,
263         uint deadline
264     ) external;
265     function swapExactETHForTokensSupportingFeeOnTransferTokens(
266         uint amountOutMin,
267         address[] calldata path,
268         address to,
269         uint deadline
270     ) external payable;
271     function swapExactTokensForETHSupportingFeeOnTransferTokens(
272         uint amountIn,
273         uint amountOutMin,
274         address[] calldata path,
275         address to,
276         uint deadline
277     ) external;
278 }
279 
280 interface IAntiSnipe {
281   function setTokenOwner(address owner, address pair) external;
282 
283   function onPreTransferCheck(
284     address from,
285     address to,
286     uint256 amount
287   ) external;
288 }
289 
290 contract SaferThanMoon is Context, Ownable {
291     using Address for address;
292     
293     string private _name = "SaferThanMoon";
294     string private _symbol = "SAFER";
295     uint8 private _decimals = 9;
296 
297     mapping(address => uint256) private _rOwned;
298     mapping(address => uint256) private _tOwned;
299     mapping(address => mapping(address => uint256)) private _allowances;
300     address[] private _excluded;
301     mapping(address => bool) private _isExcludedFromRewards;
302 
303     address constant public routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
304 
305     mapping(address => bool) private _taxWhitelist;
306 
307     address public marketingWallet = 0x9D92ffDf0831f77Daf885A3eb893828984256996;
308     bool directSend = false;
309 
310     uint256 private constant MAX = type(uint256).max;
311     uint256 private _tTotal = 5_000_000_000 * (10 ** _decimals);
312     uint256 private _rTotal = (MAX - (MAX % _tTotal));
313     uint256 private _tFeeTotal;
314 
315     address public burnAddress = 0x000000000000000000000000000000000000dEaD;
316     mapping (address => bool) public liquidityPools;
317 
318     bool public swapEnabled = true;
319     bool public inSwap = false;
320 
321     IAntiSnipe public antisnipe;
322     uint256 public protectedFrom;
323     bool public protectionEnabled = false;
324 
325     uint256 public _taxFee = 5;
326 
327     uint256 public _marketingFees = 1;
328 
329     uint256 public maxWallet = _tTotal * 4 / 1000;
330 
331     uint256 public minTokenNumberToSell = _tTotal / 10000;
332     
333     uint256 public tokenLaunched;
334 
335     event Transfer(address indexed from, address indexed to, uint256 value);
336     event Approval(
337         address indexed owner,
338         address indexed spender,
339         uint256 value
340     );
341     
342     modifier swapping() { inSwap = true; _; inSwap = false; }
343 
344     constructor() {
345         _tOwned[msg.sender] = _tTotal;
346         _rOwned[msg.sender] = _rTotal;
347 
348         _taxWhitelist[msg.sender] = true;
349         _taxWhitelist[address(this)] = true;
350         
351         _isExcludedFromRewards[address(this)] = true;
352         _excluded.push(address(this));
353         _isExcludedFromRewards[msg.sender] = true;
354         _excluded.push(msg.sender);
355         
356         emit Transfer(address(0), _msgSender(), _tTotal);
357     }
358 
359     function name() public view returns (string memory) {
360         return _name;
361     }
362 
363     function symbol() public view returns (string memory) {
364         return _symbol;
365     }
366 
367     function decimals() public view returns (uint8) {
368         return _decimals;
369     }
370 
371     function totalSupply() public view returns (uint256) {
372         return _tTotal;
373     }
374 
375     function balanceOf(address account) public view returns (uint256) {
376         if (_isExcludedFromRewards[account]) return _tOwned[account];
377         return tokenFromReflection(_rOwned[account]);
378     }
379     
380     function isExcludedFromReward(address account) public view returns (bool) {
381         return _isExcludedFromRewards[account];
382     }
383 
384     function excludeFromReward(address account) public onlyOwner {
385         require(
386             !_isExcludedFromRewards[account],
387             "Account is already excluded"
388         );
389         if (_rOwned[account] > 0) {
390             _tOwned[account] = tokenFromReflection(_rOwned[account]);
391         }
392         _isExcludedFromRewards[account] = true;
393         _excluded.push(account);
394     }
395 
396     function includeInReward(address account) public onlyOwner {
397         require(_isExcludedFromRewards[account], "Account is not excluded");
398         for (uint256 i = 0; i < _excluded.length; i++) {
399             if (_excluded[i] == account) {
400                 _excluded[i] = _excluded[_excluded.length - 1];
401                 _tOwned[account] = 0;
402                 _isExcludedFromRewards[account] = false;
403                 _excluded.pop();
404                 break;
405             }
406         }
407     }
408 
409 
410     function allowance(address _owner, address spender)
411         public
412         view
413         returns (uint256)
414     {
415         return _allowances[_owner][spender];
416     }
417 
418     function totalFees() public view returns (uint256) {
419         return _tFeeTotal;
420     }
421 
422     function approve(address spender, uint256 amount) public returns (bool) {
423         _approve(_msgSender(), spender, amount);
424         return true;
425     }
426 
427     function transfer(address recipient, uint256 amount) public returns (bool) {
428         _transfer(_msgSender(), recipient, amount);
429         return true;
430     }
431 
432     function transferFrom(
433         address sender,
434         address recipient,
435         uint256 amount
436     ) public returns (bool) {
437         _transfer(sender, recipient, amount);
438         _approve(
439             sender,
440             _msgSender(),
441             _allowances[sender][_msgSender()] - amount
442         );
443         return true;
444     }
445 
446     function increaseAllowance(address spender, uint256 addedValue)
447         public
448         virtual
449         returns (bool)
450     {
451         _approve(
452             _msgSender(),
453             spender,
454             _allowances[_msgSender()][spender] + addedValue
455         );
456         return true;
457     }
458 
459     function decreaseAllowance(address spender, uint256 subtractedValue)
460         public
461         virtual
462         returns (bool)
463     {
464         _approve(
465             _msgSender(),
466             spender,
467             _allowances[_msgSender()][spender] - subtractedValue
468         );
469         return true;
470     }
471 
472     function tokenFromReflection(uint256 rAmount)
473         public
474         view
475         returns (uint256)
476     {
477         require(rAmount <= _rTotal, "Amount must < total reflections");
478         uint256 currentRate = _getRate();
479         return rAmount / currentRate;
480     }
481 
482     function setAccountWhitelisted(address account, bool whitelisted) public onlyOwner
483     {
484         _taxWhitelist[account] = whitelisted;
485     }
486 
487     function toggleMarketing() external onlyOwner {
488         if(_taxFee > 0)
489             _marketingFees = 0;
490         else
491             _marketingFees = 1;
492     }
493 
494     function toggleReflection() external onlyOwner {
495         if(_taxFee > 0)
496             _taxFee = 0;
497         else
498             _taxFee = 5;
499     }
500     
501     function setMinAmountToSell(uint256 _divisor) external onlyOwner {
502         minTokenNumberToSell = _tTotal / _divisor;
503     }
504 
505     function setMarketingWallet(address _newAddress) external onlyOwner {
506         marketingWallet = _newAddress;
507     }
508 
509     function setswapEnabled(bool _enabled) public onlyOwner {
510         swapEnabled = _enabled;
511     }
512     
513     function addLiquidityPool(address lp, bool isPool) external onlyOwner {
514         liquidityPools[lp] = isPool;
515         excludeFromReward(lp);
516     }
517 
518     receive() external payable {}
519 
520     function _reflectFee(uint256 rFee, uint256 tFee) private {
521         _rTotal = _rTotal - rFee;
522         unchecked {
523             _tFeeTotal += tFee;
524         }
525     }
526 
527     function _getValues(uint256 tAmount, bool selling, bool takeFee)
528         private
529         view
530         returns (
531             uint256,
532             uint256,
533             uint256,
534             uint256,
535             uint256,
536             uint256
537         )
538     {
539         (
540             uint256 tTransferAmount,
541             uint256 tFee,
542             uint256 tLiquidity
543         ) = _getTValues(tAmount, selling, takeFee);
544 
545         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
546             tAmount,
547             tFee,
548             tLiquidity,
549             _getRate()
550         );
551         return (
552             rAmount,
553             rTransferAmount,
554             rFee,
555             tTransferAmount,
556             tFee,
557             tLiquidity
558         );
559     }
560 
561     function _getTValues(uint256 tAmount, bool selling, bool takeFee)
562         private
563         view
564         returns (
565             uint256,
566             uint256,
567             uint256
568         )
569     {
570         uint256 tFee = (takeFee ? calculateTaxFee(tAmount, selling) : 0);
571         uint256 tLiquidity = (takeFee ? calculateLiquidityFee(tAmount, selling) : 0);
572         uint256 tTransferAmount = tAmount - (tFee + tLiquidity);
573         return (tTransferAmount, tFee, tLiquidity);
574     }
575 
576     function _getRValues(
577         uint256 tAmount,
578         uint256 tFee,
579         uint256 tLiquidity,
580         uint256 currentRate
581     )
582         private
583         pure
584         returns (
585             uint256,
586             uint256,
587             uint256
588         )
589     {
590         uint256 rAmount = tAmount * currentRate;
591         uint256 rFee = tFee * currentRate;
592         uint256 rLiquidity = tLiquidity * currentRate;
593         uint256 rTransferAmount = rAmount - (rFee + rLiquidity);
594         return (rAmount, rTransferAmount, rFee);
595     }
596 
597     function _getRate() public view returns (uint256) {
598         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
599         return rSupply / tSupply;
600     }
601 
602     function _getCurrentSupply() private view returns (uint256, uint256) {
603         uint256 rSupply = _rTotal;
604         uint256 tSupply = _tTotal;
605         for (uint256 i = 0; i < _excluded.length; i++) {
606             if (
607                 _rOwned[_excluded[i]] > rSupply ||
608                 _tOwned[_excluded[i]] > tSupply
609             ) return (_rTotal, _tTotal);
610             rSupply -= _rOwned[_excluded[i]];
611             tSupply -= _tOwned[_excluded[i]];
612         }
613 
614 
615         if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
616         return (rSupply, tSupply);
617     }
618 
619     function _takeLiquidity(uint256 tLiquidity) private {
620         uint256 currentRate = _getRate();
621         uint256 rLiquidity = tLiquidity * currentRate;
622 
623         _rOwned[address(this)] += rLiquidity;
624         if (_isExcludedFromRewards[address(this)])
625             _tOwned[address(this)] += tLiquidity;
626     }
627 
628     function calculateTaxFee(uint256 _amount, bool selling) private view returns (uint256) {
629         if (!selling) return 0;
630         return (_amount * _taxFee) / 100;
631     }
632 
633     function calculateLiquidityFee(uint256 _amount, bool selling)
634         private
635         view
636         returns (uint256)
637     {
638         if(block.timestamp - tokenLaunched <= 30 minutes) {
639             //first 30m
640             return (_amount * 5) / 100;
641         }
642         else if(block.timestamp - tokenLaunched <= 90 minutes) {
643             //next 1hr
644             return (_amount * (selling ? 0 : 5 )) / 100;
645         }
646         //std
647         return (_amount * (selling ? 0 : _marketingFees )) / 100;
648     }
649 
650     function isWhitelisted(address account) public view returns (bool) {
651         return _taxWhitelist[account];
652     }
653     
654     function launch(address _as) external payable onlyOwner {
655     	require(tokenLaunched == 0);
656 
657         IDexRouter router = IDexRouter(routerAddress);
658 
659         address pair = IDexFactory(router.factory()).createPair(
660             address(this),
661             router.WETH()
662         );
663         liquidityPools[pair] = true;
664 
665         antisnipe = IAntiSnipe(_as);
666         antisnipe.setTokenOwner(address(this), pair);
667 
668         _isExcludedFromRewards[pair] = true;
669         _excluded.push(pair);
670         
671         _approve(address(this), routerAddress, MAX);
672         _approve(msg.sender, routerAddress, _tTotal);
673 
674         router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,msg.sender,block.timestamp);
675 
676         protectionEnabled = true;
677         tokenLaunched = block.timestamp;
678     }
679 
680     function updateApproval() external {
681         _approve(address(this), routerAddress, MAX);
682     }
683 
684     function setProtection(bool _enable) external onlyOwner {
685         protectionEnabled = _enable;
686     }
687 
688     function setAntisnipe(address _as, address pair) external onlyOwner {
689         antisnipe = IAntiSnipe(_as);
690         antisnipe.setTokenOwner(address(this), pair);
691     }
692 
693     function removemaxWallet() external onlyOwner {
694         maxWallet = _tTotal;
695     }
696 
697     function _approve(
698         address _owner,
699         address spender,
700         uint256 amount
701     ) internal {
702         require(_owner != address(0), "ERC20: approve from zero address");
703         require(spender != address(0), "ERC20: approve to zero address");
704 
705         _allowances[_owner][spender] = amount;
706         emit Approval(_owner, spender, amount);
707     }
708 
709     function _transfer(
710         address from,
711         address to,
712         uint256 amount
713     ) private {
714         require(from != address(0), "ERC20: transfer from 0x0");
715         require(to != address(0), "ERC20: transfer to 0x0");
716         
717         bool takeFee = true;
718 
719         if (_taxWhitelist[from] || _taxWhitelist[to]) {
720             takeFee = false;
721         }
722 
723         if(takeFee && !liquidityPools[to]) {
724             require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
725         }
726 
727         if (takeFee && shouldSwap(to)) swapAndLiquify(amount);
728 
729         _tokenTransfer(from, to, amount, takeFee);
730 
731         if(protectionEnabled){
732             antisnipe.onPreTransferCheck(from, to, amount);
733         }
734     }
735 
736     function _tokenTransfer(
737         address sender,
738         address recipient,
739         uint256 amount,
740         bool takeFee
741     ) private {
742         (
743             uint256 rAmount,
744             uint256 rTransferAmount,
745             uint256 rFee,
746             uint256 tTransferAmount,
747             uint256 tFee,
748             uint256 tLiquidity
749         ) = _getValues(amount, liquidityPools[recipient], takeFee);
750         _rOwned[sender] -= rAmount;
751         if (_isExcludedFromRewards[sender])
752             _tOwned[sender] -= amount;
753         if (_isExcludedFromRewards[recipient])
754             _tOwned[recipient] += tTransferAmount;
755         _rOwned[recipient] += rTransferAmount;
756         if(tLiquidity > 0)
757             _takeLiquidity(tLiquidity);
758         if(rFee > 0 || tFee > 0)
759             _reflectFee(rFee, tFee);
760         
761         emit Transfer(sender, recipient, tTransferAmount);
762     }
763 
764     function _transferStandard(
765         address sender,
766         address recipient,
767         uint256 tAmount
768     ) private {
769         
770     }
771     
772     function shouldSwap(address to) internal view returns(bool) {
773         return 
774             !inSwap &&
775             swapEnabled &&
776             balanceOf(address(this)) >= minTokenNumberToSell &&
777             !liquidityPools[msg.sender] &&
778             liquidityPools[to];
779     }
780     
781     function swapAndLiquify(uint256 amount) internal swapping {
782         uint256 amountToSwap = minTokenNumberToSell;
783         if(amount < amountToSwap) amountToSwap = amount;
784         if(amountToSwap == 0) return;
785 
786         IDexRouter router = IDexRouter(routerAddress);
787         address[] memory path = new address[](2);
788         path[0] = address(this);
789         path[1] = router.WETH();
790         
791         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
792             amountToSwap,
793             0,
794             path,
795             address(this),
796             block.timestamp
797         );
798 
799         uint256 forMarketing = address(this).balance;
800         bool sent;
801         
802         if (forMarketing > 0 && directSend) {
803             (sent, ) = marketingWallet.call{value: forMarketing}("");
804         }
805     }
806 
807     function updateDirectSend(bool _value) external onlyOwner {
808         directSend = _value;
809     }
810 
811     function extractEthPortion(address _to, uint256 _percent) external onlyOwner {
812         bool sent;
813         (sent, ) = _to.call{value: address(this).balance * _percent / 100}("");
814     }
815 
816     function extractEth() external {
817         bool sent;
818         (sent, ) = marketingWallet.call{value: address(this).balance}("");
819     }
820 	
821     function airdrop(address[] calldata _addresses, uint256[] calldata _amount) external onlyOwner
822     {
823         require(_addresses.length == _amount.length);
824         bool previousSwap = swapEnabled;
825         bool previousProtection = protectionEnabled;
826         swapEnabled = false;
827         protectionEnabled = false;
828         for (uint256 i = 0; i < _addresses.length; i++) {
829             _transfer(msg.sender, _addresses[i], _amount[i] * (10 ** _decimals));
830         }
831         swapEnabled = previousSwap;
832         protectionEnabled = previousProtection;
833     }
834 }