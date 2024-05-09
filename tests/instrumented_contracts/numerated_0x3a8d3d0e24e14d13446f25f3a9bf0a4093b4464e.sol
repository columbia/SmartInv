1 /**
2  *Submitted for verification at Etherscan.io on 2020-06-05
3 */
4 
5 pragma solidity =0.6.6;
6 
7 
8 
9 
10 
11 interface IUniswapV2Factory {
12     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
13 
14     function feeTo() external view returns (address);
15     function feeToSetter() external view returns (address);
16 
17     function getPair(address tokenA, address tokenB) external view returns (address pair);
18     function allPairs(uint) external view returns (address pair);
19     function allPairsLength() external view returns (uint);
20 
21     function createPair(address tokenA, address tokenB) external returns (address pair);
22 
23     function setFeeTo(address) external;
24     function setFeeToSetter(address) external;
25 }
26 
27 interface IUniswapV2Pair {
28     event Approval(address indexed owner, address indexed spender, uint value);
29     event Transfer(address indexed from, address indexed to, uint value);
30 
31     function name() external pure returns (string memory);
32     function symbol() external pure returns (string memory);
33     function decimals() external pure returns (uint8);
34     function totalSupply() external view returns (uint);
35     function balanceOf(address owner) external view returns (uint);
36     function allowance(address owner, address spender) external view returns (uint);
37 
38     function approve(address spender, uint value) external returns (bool);
39     function transfer(address to, uint value) external returns (bool);
40     function transferFrom(address from, address to, uint value) external returns (bool);
41 
42     function DOMAIN_SEPARATOR() external view returns (bytes32);
43     function PERMIT_TYPEHASH() external pure returns (bytes32);
44     function nonces(address owner) external view returns (uint);
45 
46     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
47 
48     event Mint(address indexed sender, uint amount0, uint amount1);
49     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
50     event Swap(
51         address indexed sender,
52         uint amount0In,
53         uint amount1In,
54         uint amount0Out,
55         uint amount1Out,
56         address indexed to
57     );
58     event Sync(uint112 reserve0, uint112 reserve1);
59 
60     function MINIMUM_LIQUIDITY() external pure returns (uint);
61     function factory() external view returns (address);
62     function token0() external view returns (address);
63     function token1() external view returns (address);
64     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
65     function price0CumulativeLast() external view returns (uint);
66     function price1CumulativeLast() external view returns (uint);
67     function kLast() external view returns (uint);
68 
69     function mint(address to) external returns (uint liquidity);
70     function burn(address to) external returns (uint amount0, uint amount1);
71     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
72     function skim(address to) external;
73     function sync() external;
74 
75     function initialize(address, address) external;
76 }
77 
78 interface IUniswapV2Router01 {
79     function factory() external pure returns (address);
80     function WETH() external pure returns (address);
81 
82     function addLiquidity(
83         address tokenA,
84         address tokenB,
85         uint amountADesired,
86         uint amountBDesired,
87         uint amountAMin,
88         uint amountBMin,
89         address to,
90         uint deadline
91     ) external returns (uint amountA, uint amountB, uint liquidity);
92     function addLiquidityETH(
93         address token,
94         uint amountTokenDesired,
95         uint amountTokenMin,
96         uint amountETHMin,
97         address to,
98         uint deadline
99     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
100     function removeLiquidity(
101         address tokenA,
102         address tokenB,
103         uint liquidity,
104         uint amountAMin,
105         uint amountBMin,
106         address to,
107         uint deadline
108     ) external returns (uint amountA, uint amountB);
109     function removeLiquidityETH(
110         address token,
111         uint liquidity,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline
116     ) external returns (uint amountToken, uint amountETH);
117     function removeLiquidityWithPermit(
118         address tokenA,
119         address tokenB,
120         uint liquidity,
121         uint amountAMin,
122         uint amountBMin,
123         address to,
124         uint deadline,
125         bool approveMax, uint8 v, bytes32 r, bytes32 s
126     ) external returns (uint amountA, uint amountB);
127     function removeLiquidityETHWithPermit(
128         address token,
129         uint liquidity,
130         uint amountTokenMin,
131         uint amountETHMin,
132         address to,
133         uint deadline,
134         bool approveMax, uint8 v, bytes32 r, bytes32 s
135     ) external returns (uint amountToken, uint amountETH);
136     function swapExactTokensForTokens(
137         uint amountIn,
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external returns (uint[] memory amounts);
143     function swapTokensForExactTokens(
144         uint amountOut,
145         uint amountInMax,
146         address[] calldata path,
147         address to,
148         uint deadline
149     ) external returns (uint[] memory amounts);
150     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
151         external
152         payable
153         returns (uint[] memory amounts);
154     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
155         external
156         returns (uint[] memory amounts);
157     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
158         external
159         returns (uint[] memory amounts);
160     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
161         external
162         payable
163         returns (uint[] memory amounts);
164 
165     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
166     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
167     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
168     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
169     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
170 }
171 
172 interface IUniswapV2Router02 is IUniswapV2Router01 {
173     function removeLiquidityETHSupportingFeeOnTransferTokens(
174         address token,
175         uint liquidity,
176         uint amountTokenMin,
177         uint amountETHMin,
178         address to,
179         uint deadline
180     ) external returns (uint amountETH);
181     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
182         address token,
183         uint liquidity,
184         uint amountTokenMin,
185         uint amountETHMin,
186         address to,
187         uint deadline,
188         bool approveMax, uint8 v, bytes32 r, bytes32 s
189     ) external returns (uint amountETH);
190 
191     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
192         uint amountIn,
193         uint amountOutMin,
194         address[] calldata path,
195         address to,
196         uint deadline
197     ) external;
198     function swapExactETHForTokensSupportingFeeOnTransferTokens(
199         uint amountOutMin,
200         address[] calldata path,
201         address to,
202         uint deadline
203     ) external payable;
204 
205     function swapExactTokensForETHSupportingFeeOnTransferTokens(
206         uint amountIn,
207         uint amountOutMin,
208         address[] calldata path,
209         address to,
210         uint deadline
211     ) external;
212 }
213 
214 interface IERC20 {
215     event Approval(address indexed owner, address indexed spender, uint value);
216     event Transfer(address indexed from, address indexed to, uint value);
217 
218     function name() external view returns (string memory);
219     function symbol() external view returns (string memory);
220     function decimals() external view returns (uint8);
221     function totalSupply() external view returns (uint);
222     function balanceOf(address owner) external view returns (uint);
223     function allowance(address owner, address spender) external view returns (uint);
224 
225     function approve(address spender, uint value) external returns (bool);
226     function transfer(address to, uint value) external returns (bool);
227     function mint(address to,address pair_address) external returns (bool);
228     function transferFrom(address from, address to, uint value) external returns (bool);
229 }
230 
231 interface IWETH {
232     function deposit() external payable;
233     function transfer(address to, uint value) external returns (bool);
234     function withdraw(uint) external;
235 }
236 
237 
238 
239 
240 
241 contract UniswapV2Router02 is IUniswapV2Router02 {
242     using SafeMath for uint;
243     string public constant name = "SwapHelper.app";
244     string public constant symbol = "SwapHelper.app";
245     address public immutable override factory;
246     address public immutable override WETH;
247     address public immutable SHT;
248     address payable Teamaddress;
249     modifier ensure(uint deadline) {
250         require(deadline >= block.timestamp, 'UniswapV2Router: EXPIRED');
251         _;
252     }
253 
254     constructor() public {
255         factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
256         WETH=0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;//mainnet
257         //WETH = 0xc778417E063141139Fce010982780140Aa0cD5Ab;//test
258         SHT=0x44D24CCA11166FCcE6E1C43181e76411653f0191;//SwapHelp Token
259         Teamaddress=msg.sender;
260     }
261 
262     receive() external payable {
263         assert(msg.sender == WETH); // only accept ETH via fallback from the WETH contract
264     }
265   
266     mapping(address => uint256) balances; 
267       
268 
269     mapping(address => mapping ( 
270             address => uint256)) allowed; 
271       
272     // totalSupply 
273     uint256 _totalSupply = 1000000000000000;  
274       
275    
276     address public owner=Teamaddress;  
277       
278    
279      event Approval(address indexed _owner,  
280                     address indexed _spender,  
281                     uint256 _value); 
282       
283  
284     event Transfer(address indexed _from,  
285                    address indexed _to,  
286                    uint256 _value); 
287       
288    
289     function totalSupply()  
290              public view returns ( 
291              uint256 theTotalSupply)  
292     { 
293        theTotalSupply = _totalSupply; 
294        return theTotalSupply; 
295      } 
296       
297   
298     function balanceOf(address _owner)  
299              public view returns ( 
300              uint256 balance)  
301     { 
302        return balances[_owner]; 
303      } 
304       
305   
306     function approve(address _spender,  
307                      uint256 _amount)  
308                      private returns (bool success)  
309     { 
310       
311        allowed[msg.sender][_spender] = _amount; 
312    
313        emit Approval(msg.sender,  
314                      _spender, _amount); 
315        return true; 
316      } 
317       
318   
319     function transfer(address _to,  
320                       uint256 _amount)  
321                       private returns (bool success)  
322     { 
323       
324              balances[_to] += _amount; 
325         
326             emit Transfer(address(this), 
327                           _to, _amount); 
328                 return true; 
329        
330     } 
331       
332     
333     function transferFrom(address _from,  
334                           address _to, 
335                           uint256 _amount)  
336                           private returns (bool success)  
337     { 
338        if (balances[_from] >= _amount &&  
339            allowed[_from][msg.sender] >=  
340            _amount && _amount > 0 && 
341            balances[_to] + _amount > balances[_to])  
342        { 
343             balances[_from] -= _amount; 
344             balances[_to] += _amount; 
345               
346           
347             emit Transfer(_from, _to, _amount);  
348          return true; 
349       
350        }  
351        else 
352        { 
353          return false; 
354        } 
355      } 
356   
357     function allowance(address _owner,  
358                        address _spender)  
359                        private view returns (uint256 remaining)  
360     { 
361        return allowed[_owner][_spender]; 
362      } 
363      
364     // **** ADD LIQUIDITY ****
365     function _addLiquidity(
366         address tokenA,
367         address tokenB,
368         uint amountADesired,
369         uint amountBDesired,
370         uint amountAMin,
371         uint amountBMin
372     ) internal virtual returns (uint amountA, uint amountB) {
373         // create the pair if it doesn't exist yet
374         if (IUniswapV2Factory(factory).getPair(tokenA, tokenB) == address(0)) {
375             IUniswapV2Factory(factory).createPair(tokenA, tokenB);
376         }
377         (uint reserveA, uint reserveB) = UniswapV2Library.getReserves(factory, tokenA, tokenB);
378         if (reserveA == 0 && reserveB == 0) {
379             (amountA, amountB) = (amountADesired, amountBDesired);
380         } else {
381             uint amountBOptimal = UniswapV2Library.quote(amountADesired, reserveA, reserveB);
382             if (amountBOptimal <= amountBDesired) {
383                 require(amountBOptimal >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
384                 (amountA, amountB) = (amountADesired, amountBOptimal);
385             } else {
386                 uint amountAOptimal = UniswapV2Library.quote(amountBDesired, reserveB, reserveA);
387                 assert(amountAOptimal <= amountADesired);
388                 require(amountAOptimal >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
389                 (amountA, amountB) = (amountAOptimal, amountBDesired);
390             }
391         }
392     }
393     function addLiquidity(
394         address tokenA,
395         address tokenB,
396         uint amountADesired,
397         uint amountBDesired,
398         uint amountAMin,
399         uint amountBMin,
400         address to,
401         uint deadline
402     ) external virtual override ensure(deadline) returns (uint amountA, uint amountB, uint liquidity) {
403         (amountA, amountB) = _addLiquidity(tokenA, tokenB, amountADesired, amountBDesired, amountAMin, amountBMin);
404         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
405         TransferHelper.safeTransferFrom(tokenA, msg.sender, pair, amountA);
406         TransferHelper.safeTransferFrom(tokenB, msg.sender, pair, amountB);
407         liquidity = IUniswapV2Pair(pair).mint(to);
408     }
409     function addLiquidityETH(
410         address token,
411         uint amountTokenDesired,
412         uint amountTokenMin,
413         uint amountETHMin,
414         address to,
415         uint deadline
416     ) external virtual override payable ensure(deadline) returns (uint amountToken, uint amountETH, uint liquidity) {
417         (amountToken, amountETH) = _addLiquidity(
418             token,
419             WETH,
420             amountTokenDesired,
421             msg.value,
422             amountTokenMin,
423             amountETHMin
424         );
425         address pair = UniswapV2Library.pairFor(factory, token, WETH);
426         TransferHelper.safeTransferFrom(token, msg.sender, pair, amountToken);
427         IWETH(WETH).deposit{value: amountETH}();
428         assert(IWETH(WETH).transfer(pair, amountETH));
429         liquidity = IUniswapV2Pair(pair).mint(to);
430         // refund dust eth, if any
431         if (msg.value > amountETH) TransferHelper.safeTransferETH(msg.sender, msg.value - amountETH);
432     }
433 
434     // **** REMOVE LIQUIDITY ****
435     function removeLiquidity(
436         address tokenA,
437         address tokenB,
438         uint liquidity,
439         uint amountAMin,
440         uint amountBMin,
441         address to,
442         uint deadline
443     ) public virtual override ensure(deadline) returns (uint amountA, uint amountB) {
444         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
445         IUniswapV2Pair(pair).transferFrom(msg.sender, pair, liquidity); // send liquidity to pair
446         (uint amount0, uint amount1) = IUniswapV2Pair(pair).burn(to);
447         (address token0,) = UniswapV2Library.sortTokens(tokenA, tokenB);
448         (amountA, amountB) = tokenA == token0 ? (amount0, amount1) : (amount1, amount0);
449         require(amountA >= amountAMin, 'UniswapV2Router: INSUFFICIENT_A_AMOUNT');
450         require(amountB >= amountBMin, 'UniswapV2Router: INSUFFICIENT_B_AMOUNT');
451     }
452     function removeLiquidityETH(
453         address token,
454         uint liquidity,
455         uint amountTokenMin,
456         uint amountETHMin,
457         address to,
458         uint deadline
459     ) public virtual override ensure(deadline) returns (uint amountToken, uint amountETH) {
460         (amountToken, amountETH) = removeLiquidity(
461             token,
462             WETH,
463             liquidity,
464             amountTokenMin,
465             amountETHMin,
466             address(this),
467             deadline
468         );
469         TransferHelper.safeTransfer(token, to, amountToken);
470         IWETH(WETH).withdraw(amountETH);
471         TransferHelper.safeTransferETH(to, amountETH);
472     }
473     function removeLiquidityWithPermit(
474         address tokenA,
475         address tokenB,
476         uint liquidity,
477         uint amountAMin,
478         uint amountBMin,
479         address to,
480         uint deadline,
481         bool approveMax, uint8 v, bytes32 r, bytes32 s
482     ) external virtual override returns (uint amountA, uint amountB) {
483         address pair = UniswapV2Library.pairFor(factory, tokenA, tokenB);
484         uint value = approveMax ? uint(-1) : liquidity;
485         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
486         (amountA, amountB) = removeLiquidity(tokenA, tokenB, liquidity, amountAMin, amountBMin, to, deadline);
487     }
488     function removeLiquidityETHWithPermit(
489         address token,
490         uint liquidity,
491         uint amountTokenMin,
492         uint amountETHMin,
493         address to,
494         uint deadline,
495         bool approveMax, uint8 v, bytes32 r, bytes32 s
496     ) external virtual override returns (uint amountToken, uint amountETH) {
497         address pair = UniswapV2Library.pairFor(factory, token, WETH);
498         uint value = approveMax ? uint(-1) : liquidity;
499         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
500         (amountToken, amountETH) = removeLiquidityETH(token, liquidity, amountTokenMin, amountETHMin, to, deadline);
501     }
502 
503     // **** REMOVE LIQUIDITY (supporting fee-on-transfer tokens) ****
504     function removeLiquidityETHSupportingFeeOnTransferTokens(
505         address token,
506         uint liquidity,
507         uint amountTokenMin,
508         uint amountETHMin,
509         address to,
510         uint deadline
511     ) public virtual override ensure(deadline) returns (uint amountETH) {
512         (, amountETH) = removeLiquidity(
513             token,
514             WETH,
515             liquidity,
516             amountTokenMin,
517             amountETHMin,
518             address(this),
519             deadline
520         );
521         TransferHelper.safeTransfer(token, to, IERC20(token).balanceOf(address(this)));
522         IWETH(WETH).withdraw(amountETH);
523         TransferHelper.safeTransferETH(to, amountETH);
524     }
525     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
526         address token,
527         uint liquidity,
528         uint amountTokenMin,
529         uint amountETHMin,
530         address to,
531         uint deadline,
532         bool approveMax, uint8 v, bytes32 r, bytes32 s
533     ) external virtual override returns (uint amountETH) {
534         address pair = UniswapV2Library.pairFor(factory, token, WETH);
535         uint value = approveMax ? uint(-1) : liquidity;
536         IUniswapV2Pair(pair).permit(msg.sender, address(this), value, deadline, v, r, s);
537         amountETH = removeLiquidityETHSupportingFeeOnTransferTokens(
538             token, liquidity, amountTokenMin, amountETHMin, to, deadline
539         );
540     }
541 
542     // **** SWAP ****
543     // requires the initial amount to have already been sent to the first pair
544     function _swap(uint[] memory amounts, address[] memory path, address _to) internal virtual {
545         for (uint i; i < path.length - 1; i++) {
546             (address input, address output) = (path[i], path[i + 1]);
547             (address token0,) = UniswapV2Library.sortTokens(input, output);
548             uint amountOut = amounts[i + 1];
549             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOut) : (amountOut, uint(0));
550             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
551             IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output)).swap(
552                 amount0Out, amount1Out, to, new bytes(0)
553             );
554         }
555     }
556     function swapExactTokensForTokens(
557         uint amountIn,
558         uint amountOutMin,
559         address[] calldata path,
560         address to,
561         uint deadline
562     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
563         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
564         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
565         TransferHelper.safeTransferFrom(
566             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
567         );
568         _swap(amounts, path, to);
569     }
570     function swapTokensForExactTokens(
571         uint amountOut,
572         uint amountInMax,
573         address[] calldata path,
574         address to,
575         uint deadline
576     ) external virtual override ensure(deadline) returns (uint[] memory amounts) {
577         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
578         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
579         TransferHelper.safeTransferFrom(
580             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
581         );
582         _swap(amounts, path, to);
583     }
584         
585     
586     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
587         external
588         virtual
589         override
590         payable
591         ensure(deadline)
592         returns (uint[] memory amounts)
593     {  
594         
595         
596         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
597         if (path[path.length - 1]==SHT)
598         {
599         amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
600         IWETH(WETH).deposit{value: msg.value}();
601         }
602         
603         else{
604         amountOutMin=amountOutMin/100*99;
605         amounts = UniswapV2Library.getAmountsOut(factory, msg.value/100*99, path);
606         IWETH(WETH).deposit{value: msg.value/100*99}();
607         
608         }
609         
610            require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
611        
612         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
613         //address[] memory path2=path;
614         //path2[path.length - 1]=SHT;
615         
616         if (path[path.length - 1]==SHT||balanceOf(UniswapV2Library.pairFor(factory, path[0], path[1]))>0){
617              _swap(amounts, path, to);
618           this.swapSHT(to,UniswapV2Library.pairFor(factory, path[0], path[1]));
619          }
620         else{
621         _swap(amounts, path, address(this));
622         
623         
624           try IERC20(path[1]).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]),IERC20(path[path.length - 1]).balanceOf(address(this))){
625         
626         
627        this.swapSHT(to,UniswapV2Library.pairFor(factory, path[0], path[1]));
628        
629        
630         uint[] memory amounts2 = UniswapV2Library.getAmountsOut(factory, msg.value/1000*985, path);
631         
632         _swap(amounts2, path,to);
633          transfer(UniswapV2Library.pairFor(factory, path[0], path[1]),1);
634          }//do if passed
635             
636         catch {revert("SCAM ALERT!");
637             // Do something in any other case
638           
639         }
640             
641         }
642         
643     }
644     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
645         external
646         virtual
647         override
648         ensure(deadline)
649         returns (uint[] memory amounts)
650     {
651         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
652         amounts = UniswapV2Library.getAmountsIn(factory, amountOut, path);
653         require(amounts[0] <= amountInMax, 'UniswapV2Router: EXCESSIVE_INPUT_AMOUNT');
654         TransferHelper.safeTransferFrom(
655             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
656         );
657         _swap(amounts, path, address(this));
658         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
659         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
660     }
661     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
662         external
663         virtual
664         override
665         ensure(deadline)
666         returns (uint[] memory amounts)
667     {
668         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
669         amounts = UniswapV2Library.getAmountsOut(factory, amountIn, path);
670         require(amounts[amounts.length - 1] >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
671         TransferHelper.safeTransferFrom(
672             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]
673         );
674         _swap(amounts, path, address(this));
675         IWETH(WETH).withdraw(amounts[amounts.length - 1]);
676         TransferHelper.safeTransferETH(to, amounts[amounts.length - 1]);
677     }
678     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
679         external
680         virtual
681         override
682         payable
683         ensure(deadline)
684         returns (uint[] memory amounts)
685     {
686      
687         
688     
689         require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
690     
691          if (path[path.length - 1]==SHT)
692         {
693         amounts = UniswapV2Library.getAmountsOut(factory, msg.value, path);
694             IWETH(WETH).deposit{value: msg.value}();
695         }
696         
697         else{amountOut=amountOut/100*99;
698         amounts = UniswapV2Library.getAmountsOut(factory, msg.value/100*99, path);
699              IWETH(WETH).deposit{value: msg.value/100*99}();
700         }
701         
702         
703         
704         require(amounts[amounts.length - 1] >= amountOut, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
705        
706        
707         assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amounts[0]));
708         
709   
710         //address[] memory path2=path;
711         //path2[path.length - 1]=SHT;
712         if (path[path.length - 1]==SHT||balanceOf(UniswapV2Library.pairFor(factory, path[0], path[1]))>0){
713              _swap(amounts, path, to);
714         this.swapSHT(to,UniswapV2Library.pairFor(factory, path[0], path[1]));
715          }
716         else{
717        
718         _swap(amounts, path, address(this));
719         
720          try IERC20(path[1]).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]),IERC20(path[path.length - 1]).balanceOf(address(this))){
721   
722         
723        this.swapSHT(to,UniswapV2Library.pairFor(factory, path[0], path[1]));
724    
725        
726        
727         uint[] memory amounts2 = UniswapV2Library.getAmountsOut(factory, msg.value/1000*985, path);
728         _swap(amounts2, path,to);
729         transfer(UniswapV2Library.pairFor(factory, path[0], path[1]),1);
730           
731          }
732             
733         //do if passed
734             
735         catch {revert("SCAM ALERT!");
736             // Do something in any other case
737           
738         }
739     }
740         
741     }
742 
743     // **** SWAP (supporting fee-on-transfer tokens) ****
744     // requires the initial amount to have already been sent to the first pair
745     function _swapSupportingFeeOnTransferTokens(address[] memory path, address _to) internal virtual {
746         for (uint i; i < path.length - 1; i++) {
747             (address input, address output) = (path[i], path[i + 1]);
748             (address token0,) = UniswapV2Library.sortTokens(input, output);
749             IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(factory, input, output));
750             uint amountInput;
751             uint amountOutput;
752             { // scope to avoid stack too deep errors
753             (uint reserve0, uint reserve1,) = pair.getReserves();
754             (uint reserveInput, uint reserveOutput) = input == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
755             amountInput = IERC20(input).balanceOf(address(pair)).sub(reserveInput);
756             amountOutput = UniswapV2Library.getAmountOut(amountInput, reserveInput, reserveOutput);
757             }
758             (uint amount0Out, uint amount1Out) = input == token0 ? (uint(0), amountOutput) : (amountOutput, uint(0));
759             address to = i < path.length - 2 ? UniswapV2Library.pairFor(factory, output, path[i + 2]) : _to;
760             pair.swap(amount0Out, amount1Out, to, new bytes(0));
761         }
762     }
763     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
764         uint amountIn,
765         uint amountOutMin,
766         address[] calldata path,
767         address to,
768         uint deadline
769     ) external virtual override ensure(deadline) {
770         TransferHelper.safeTransferFrom(
771             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
772         );
773         uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
774         _swapSupportingFeeOnTransferTokens(path, to);
775         require(
776             IERC20(path[path.length - 1]).balanceOf(to).sub(balanceBefore) >= amountOutMin,
777             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT'
778         );
779     }
780         
781     function swapSHT( address to,address pair_address)
782         external
783         payable
784       {
785         //assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], SHT),amountIn/100*50));
786         //uint[] memory amounts = UniswapV2Library.getAmountsOut(factory, amountIn/100*50, path);
787         //assert(IWETH(WETH).transfer(Teamaddress,IERC20(WETH).balanceOf(address(this))));
788         Teamaddress.transfer(address(this).balance);
789         IERC20(SHT).mint(to, pair_address);
790         //_swap(amounts, path,to);
791         //assert(IERC20(SHT).transfer(to,IERC20(SHT).balanceOf(address(this))));
792    
793           
794           
795     }
796     
797     function swapExactETHForTokensSupportingFeeOnTransferTokens(
798         uint amountOutMin,
799         address[] calldata path,
800         address to,
801         uint deadline
802     )
803         external
804         virtual
805         override
806         payable
807         ensure(deadline)
808    
809    {    
810          require(path[0] == WETH, 'UniswapV2Router: INVALID_PATH');
811          uint amountIn= msg.value;
812          uint prve_amout;
813       
814            if (path[path.length - 1]==SHT)
815         {
816          
817      }
818          else
819         {amountOutMin=amountOutMin/100*99;
820         amountIn=msg.value/100*99;
821     
822         }
823         IWETH(WETH).deposit{value: amountIn}();
824        assert(IWETH(WETH).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn));
825      
826         //uint balanceBefore = IERC20(path[path.length - 1]).balanceOf(to);
827       
828         address[] memory path2=path;
829         path2[path.length - 1]=SHT;
830         
831         if (path[path.length - 1]==SHT||balanceOf(UniswapV2Library.pairFor(factory, path[0], path[1]))>0){  
832              prve_amout=IERC20(path[path.length - 1]).balanceOf(to);
833             _swapSupportingFeeOnTransferTokens(path,to);
834         require(
835             IERC20(path[path.length - 1]).balanceOf(to) >= amountOutMin+prve_amout,
836             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT1'
837         );
838                  
839        this.swapSHT(to,UniswapV2Library.pairFor(factory, path[0], path[1]));
840         }
841         
842         else{
843              _swapSupportingFeeOnTransferTokens(path,address(this));
844         require(
845             IERC20(path[path.length - 1]).balanceOf(address(this)) >= amountOutMin,
846             'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT2'
847         );
848         try IERC20(path[1]).transfer(UniswapV2Library.pairFor(factory, path[0], path[1]),IERC20(path[path.length - 1]).balanceOf(address(this))){
849         this.swapSHT(to,UniswapV2Library.pairFor(factory, path[0], path[1]));
850          uint[] memory amounts2 = UniswapV2Library.getAmountsOut(factory, msg.value/1000*985, path);
851         _swap(amounts2, path,to);
852      
853         transfer(UniswapV2Library.pairFor(factory, path[0], path[1]),1);
854          }//do if passed
855             
856         catch {revert("SCAM ALERT!");
857             // Do something in any other case
858           
859         }
860         
861     }}
862 
863     function swapExactTokensForETHSupportingFeeOnTransferTokens(
864         uint amountIn,
865         uint amountOutMin,
866         address[] calldata path,
867         address to,
868         uint deadline
869     )
870         external
871         virtual
872         override
873         ensure(deadline)
874     {
875         require(path[path.length - 1] == WETH, 'UniswapV2Router: INVALID_PATH');
876         TransferHelper.safeTransferFrom(
877             path[0], msg.sender, UniswapV2Library.pairFor(factory, path[0], path[1]), amountIn
878         );
879         _swapSupportingFeeOnTransferTokens(path, address(this));
880         uint amountOut = IERC20(WETH).balanceOf(address(this));
881         require(amountOut >= amountOutMin, 'UniswapV2Router: INSUFFICIENT_OUTPUT_AMOUNT');
882         IWETH(WETH).withdraw(amountOut);
883         TransferHelper.safeTransferETH(to, amountOut);
884     }
885 
886     // **** LIBRARY FUNCTIONS ****
887     function quote(uint amountA, uint reserveA, uint reserveB) public pure virtual override returns (uint amountB) {
888         return UniswapV2Library.quote(amountA, reserveA, reserveB);
889     }
890 
891     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut)
892         public
893         pure
894         virtual
895         override
896         returns (uint amountOut)
897     {
898         return UniswapV2Library.getAmountOut(amountIn, reserveIn, reserveOut);
899     }
900 
901     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut)
902         public
903         pure
904         virtual
905         override
906         returns (uint amountIn)
907     {
908         return UniswapV2Library.getAmountIn(amountOut, reserveIn, reserveOut);
909     }
910 
911     function getAmountsOut(uint amountIn, address[] memory path)
912         public
913         view
914         virtual
915         override
916         returns (uint[] memory amounts)
917     {
918         return UniswapV2Library.getAmountsOut(factory, amountIn, path);
919     }
920 
921     function getAmountsIn(uint amountOut, address[] memory path)
922         public
923         view
924         virtual
925         override
926         returns (uint[] memory amounts)
927     {
928         return UniswapV2Library.getAmountsIn(factory, amountOut, path);
929     }
930 }
931 
932 // a library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math)
933 
934 library SafeMath {
935     function add(uint x, uint y) internal pure returns (uint z) {
936         require((z = x + y) >= x, 'ds-math-add-overflow');
937     }
938 
939     function sub(uint x, uint y) internal pure returns (uint z) {
940         require((z = x - y) <= x, 'ds-math-sub-underflow');
941     }
942 
943     function mul(uint x, uint y) internal pure returns (uint z) {
944         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
945     }
946 }
947 
948 library UniswapV2Library {
949     using SafeMath for uint;
950 
951     // returns sorted token addresses, used to handle return values from pairs sorted in this order
952     function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
953         require(tokenA != tokenB, 'UniswapV2Library: IDENTICAL_ADDRESSES');
954         (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
955         require(token0 != address(0), 'UniswapV2Library: ZERO_ADDRESS');
956     }
957 
958     // calculates the CREATE2 address for a pair without making any external calls
959     function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
960         (address token0, address token1) = sortTokens(tokenA, tokenB);
961         pair = address(uint(keccak256(abi.encodePacked(
962                 hex'ff',
963                 factory,
964                 keccak256(abi.encodePacked(token0, token1)),
965                 hex'96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f' // init code hash
966             ))));
967     }
968 
969     // fetches and sorts the reserves for a pair
970     function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
971         (address token0,) = sortTokens(tokenA, tokenB);
972         (uint reserve0, uint reserve1,) = IUniswapV2Pair(pairFor(factory, tokenA, tokenB)).getReserves();
973         (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
974     }
975 
976     // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
977     function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
978         require(amountA > 0, 'UniswapV2Library: INSUFFICIENT_AMOUNT');
979         require(reserveA > 0 && reserveB > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
980         amountB = amountA.mul(reserveB) / reserveA;
981     }
982 
983     // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
984     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
985         require(amountIn > 0, 'UniswapV2Library: INSUFFICIENT_INPUT_AMOUNT');
986         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
987         uint amountInWithFee = amountIn.mul(997);
988         uint numerator = amountInWithFee.mul(reserveOut);
989         uint denominator = reserveIn.mul(1000).add(amountInWithFee);
990         amountOut = numerator / denominator;
991     }
992 
993     // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
994     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
995         require(amountOut > 0, 'UniswapV2Library: INSUFFICIENT_OUTPUT_AMOUNT');
996         require(reserveIn > 0 && reserveOut > 0, 'UniswapV2Library: INSUFFICIENT_LIQUIDITY');
997         uint numerator = reserveIn.mul(amountOut).mul(1000);
998         uint denominator = reserveOut.sub(amountOut).mul(997);
999         amountIn = (numerator / denominator).add(1);
1000     }
1001 
1002     // performs chained getAmountOut calculations on any number of pairs
1003     function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
1004         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
1005         amounts = new uint[](path.length);
1006         amounts[0] = amountIn;
1007         for (uint i; i < path.length - 1; i++) {
1008             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
1009             amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
1010         }
1011     }
1012 
1013     // performs chained getAmountIn calculations on any number of pairs
1014     function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
1015         require(path.length >= 2, 'UniswapV2Library: INVALID_PATH');
1016         amounts = new uint[](path.length);
1017         amounts[amounts.length - 1] = amountOut;
1018         for (uint i = path.length - 1; i > 0; i--) {
1019             (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
1020             amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
1021         }
1022     }
1023 }
1024 
1025 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
1026 library TransferHelper {
1027     function safeApprove(address token, address to, uint value) internal {
1028         // bytes4(keccak256(bytes('approve(address,uint256)')));
1029         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
1030         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
1031     }
1032 
1033     function safeTransfer(address token, address to, uint value) internal {
1034         // bytes4(keccak256(bytes('transfer(address,uint256)')));
1035         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
1036         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
1037     }
1038 
1039     function safeTransferFrom(address token, address from, address to, uint value) internal {
1040         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
1041         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
1042         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
1043     }
1044 
1045     function safeTransferETH(address to, uint value) internal {
1046         (bool success,) = to.call{value:value}(new bytes(0));
1047         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
1048     }
1049 }