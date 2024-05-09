1 /*                                                              
2                                                                                                     
3                                        `.-:+osyhhhhhhyso+:-.`                                       
4                                    .:+ydmNNNNNNNNNNNNNNNNNNmdy+:.                                   
5                                 .+ymNNNNNNNNNNNNNNNNNNNNNNNNNNNNmy+.                                
6                              `/hmNNNNNNNNmdys+//:::://+sydmNNNNNNNNmh/`                             
7                            .odNNNNNNNdy+-.`              `.-+ydNNNNNNNdo.                           
8                          `omNNNNNNdo-`                        `-odNNNNNNmo`                         
9                         :dNNNNNNh/`                              `/hNNNNNNd:                        
10                       `oNNNNNNh:                     /-/.           :hNNNNNNo`                      
11                      `yNNNNNm+`                      mNNm-           `+mNNNNNy`                     
12                     `hNNNNNd-                        hNNNm.            -dNNNNNh`                    
13                     yNNNNNd.                         .ymNNh             .dNNNNNy                    
14                    /NNNNNm.                            -mNNys+.          .mNNNNN/                   
15                   `mNNNNN:                           `:hNNNNNNNs`         :NNNNNm`                  
16                   /NNNNNh                          `+dNNNNNNNNNNd.         hNNNNN/                  
17                   yNNNNN/               .:+syyhhhhhmNNNNNNNNNNNNNm`        /NNNNNy                  
18                   dNNNNN.            `+dNNNNNNNNNNNNNNNNNNNNNNNmd+         .NNNNNd                  
19                   mNNNNN`           -dNNNNNNNNNNNNNNNNNNNNNNm-             `NNNNNm                  
20                   dNNNNN.          -NNNNNNNNNNNNNNNNNNNNNNNN+              .NNNNNd                  
21                   yNNNNN/          dNNNNNNNNNNNNNNNNNNNNNNNN:              /NNNNNy                  
22                   /NNNNNh         .NNNNNNNNNNNNNNNNNNNNNNNNd`              hNNNNN/                  
23                   `mNNNNN:        -NNNNNNNNNNNNNNNNNNNNNNNh.              :NNNNNm`                  
24                    /NNNNNm.       `NNNNNNNNNNNNNNNNNNNNNh:               .mNNNNN/                   
25                     yNNNNNd.      .yNNNNNNNNNNNNNNNdmNNN/               .dNNNNNy                    
26                     `hNNNNNd-    `dmNNNNNNNNNNNNdo-`.hNNh              -dNNNNNh`                    
27                      `yNNNNNm+`   oNNmmNNNNNNNNNy.   `sNNdo.         `+mNNNNNy`                     
28                       `oNNNNNNh:   ....++///+++++.     -+++.        :hNNNNNNo`                      
29                         :dNNNNNNh/`                              `/hNNNNNNd:                        
30                          `omNNNNNNdo-`                        `-odNNNNNNmo`                         
31                            .odNNNNNNNdy+-.`              `.-+ydNNNNNNNdo.                           
32                              `/hmNNNNNNNNmdys+//:::://+sydmNNNNNNNNmh/`                             
33                                 .+ymNNNNNNNNNNNNNNNNNNNNNNNNNNNNmy+.                                
34                                    .:+ydmNNNNNNNNNNNNNNNNNNmdy+:.                                   
35                                        `.-:+yourewelcome+:-.`                                       
36  /$$$$$$$  /$$                                               /$$      /$$                                        
37 | $$__  $$| $$                                              | $$$    /$$$                                        
38 | $$  \ $$| $$  /$$$$$$  /$$   /$$ /$$   /$$  /$$$$$$$      | $$$$  /$$$$  /$$$$$$  /$$$$$$$   /$$$$$$  /$$   /$$
39 | $$$$$$$/| $$ /$$__  $$|  $$ /$$/| $$  | $$ /$$_____/      | $$ $$/$$ $$ /$$__  $$| $$__  $$ /$$__  $$| $$  | $$
40 | $$____/ | $$| $$$$$$$$ \  $$$$/ | $$  | $$|  $$$$$$       | $$  $$$| $$| $$  \ $$| $$  \ $$| $$$$$$$$| $$  | $$
41 | $$      | $$| $$_____/  >$$  $$ | $$  | $$ \____  $$      | $$\  $ | $$| $$  | $$| $$  | $$| $$_____/| $$  | $$
42 | $$      | $$|  $$$$$$$ /$$/\  $$|  $$$$$$/ /$$$$$$$/      | $$ \/  | $$|  $$$$$$/| $$  | $$|  $$$$$$$|  $$$$$$$
43 |__/      |__/ \_______/|__/  \__/ \______/ |_______/       |__/     |__/ \______/ |__/  |__/ \_______/ \____  $$
44                                                                                                         /$$  | $$
45                                                                                                        |  $$$$$$/
46                                                                                                        \______/ 
47 
48 */  
49 
50 
51 // This program is free software: you can redistribute it and/or modify
52 // it under the terms of the GNU General Public License as published by
53 // the Free Software Foundation, either version 3 of the License, or
54 // (at your option) any later version.
55 
56 // This program is distributed in the hope that it will be useful,
57 // but WITHOUT ANY WARRANTY; without even the implied warranty of
58 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
59 // GNU General Public License for more details.
60 
61 // You should have received a copy of the GNU General Public License
62 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
63 
64 
65 
66 pragma solidity 0.7.4;
67 
68 
69 interface ERC20 {
70     function totalSupply() external view returns(uint supply);
71 
72     function balanceOf(address _owner) external view returns(uint balance);
73 
74     function transfer(address _to, uint _value) external returns(bool success);
75 
76     function transferFrom(address _from, address _to, uint _value) external returns(bool success);
77 
78     function approve(address _spender, uint _value) external returns(bool success);
79 
80     function allowance(address _owner, address _spender) external view returns(uint remaining);
81 
82     function decimals() external view returns(uint digits);
83     event Approval(address indexed _owner, address indexed _spender, uint _value);
84 }
85 
86 interface WrappedETH {
87     function totalSupply() external view returns(uint supply);
88 
89     function balanceOf(address _owner) external view returns(uint balance);
90 
91     function transfer(address _to, uint _value) external returns(bool success);
92 
93     function transferFrom(address _from, address _to, uint _value) external returns(bool success);
94 
95     function approve(address _spender, uint _value) external returns(bool success);
96 
97     function allowance(address _owner, address _spender) external view returns(uint remaining);
98 
99     function decimals() external view returns(uint digits);
100     event Approval(address indexed _owner, address indexed _spender, uint _value);
101 
102     function deposit() external payable;
103 
104     function withdraw(uint256 wad) external;
105 
106 }
107 
108 interface UniswapFactory{
109   function getPair(address tokenA, address tokenB) external view returns (address pair);
110 }
111 
112 interface LPERC20{
113 
114     function token0() external view returns(address);
115     function token1() external view returns(address);
116 }
117 
118 
119 
120 interface UniswapV2{
121 
122 
123    function addLiquidity ( address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline ) external returns ( uint256 amountA, uint256 amountB, uint256 liquidity );
124    function addLiquidityETH ( address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline ) external returns ( uint256 amountToken, uint256 amountETH, uint256 liquidity );
125    function removeLiquidityETH ( address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline ) external returns ( uint256 amountToken, uint256 amountETH );
126    function removeLiquidity ( address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline ) external returns ( uint256 amountA, uint256 amountB );
127 
128    function swapExactTokensForTokens ( uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline ) external returns ( uint256[] memory amounts );
129     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
130         external
131         payable
132         returns (uint[] memory amounts);
133    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
134 
135 }
136 
137 
138 
139 
140 
141 library SafeMath {
142   function mul(uint256 a, uint256 b) internal view returns (uint256) {
143     uint256 c = a * b;
144     assert(a == 0 || c / a == b);
145     return c;
146   }
147 
148   function div(uint256 a, uint256 b) internal view returns (uint256) {
149     assert(b > 0); // Solidity automatically throws when dividing by 0
150     uint256 c = a / b;
151     assert(a == b * c + a % b); // There is no case in which this doesn't hold
152     return c;
153   }
154 
155 
156 
157   function sub(uint256 a, uint256 b) internal view returns (uint256) {
158     assert(b <= a);
159     return a - b;
160   }
161 
162   function add(uint256 a, uint256 b) internal view returns (uint256) {
163     uint256 c = a + b;
164     assert(c >= a);
165     return c;
166   }
167 
168 }
169 
170 
171 contract WrapAndUnWrap{
172 
173   using SafeMath
174     for uint256;
175 
176   address payable public owner;
177   //placehodler token address for specifying eth tokens
178   address public ETH_TOKEN_ADDRESS  = address(0x0);
179   address public WETH_TOKEN_ADDRESS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
180   WrappedETH wethToken = WrappedETH(WETH_TOKEN_ADDRESS);
181   uint256 approvalAmount = 1000000000000000000000000000000;
182   uint256 longTimeFromNow = 1000000000000000000000000000;
183   address uniAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
184   address uniFactoryAddress = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
185   UniswapV2 uniswapExchange = UniswapV2(uniAddress);
186   UniswapFactory factory = UniswapFactory(uniFactoryAddress);
187   mapping (address => address[]) public lpTokenAddressToPairs;
188   mapping(string=>address) public stablecoins;
189   mapping(address=>mapping(address=>address[])) public presetPaths;
190   bool public changeRecpientIsOwner;
191   uint256 public fee = 0;
192   uint256 public maxfee = 0;
193 
194 
195   modifier onlyOwner {
196         require(
197             msg.sender == owner,
198             "Only owner can call this function."
199         );
200         _;
201 }
202 
203     fallback() external payable {
204     }
205 
206   constructor() public payable {
207          stablecoins["DAI"] = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
208          stablecoins["USDT"] = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
209          stablecoins["USDC"] = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
210          changeRecpientIsOwner = false;
211         owner= msg.sender;
212 
213   }
214 
215   function wrap(address sourceToken, address[] memory destinationTokens, uint256 amount) public payable returns(address, uint256){
216 
217 
218     ERC20 sToken = ERC20(sourceToken);
219     ERC20 dToken = ERC20(destinationTokens[0]);
220 
221       if(destinationTokens.length==1){
222 
223         if(sourceToken != ETH_TOKEN_ADDRESS){
224           require(sToken.transferFrom(msg.sender, address(this), amount), "You have not approved this contract or do not have enough token for this transfer 1");
225           if(sToken.allowance(address(this), uniAddress) < amount.mul(2)){
226                   sToken.approve(uniAddress, amount.mul(3));
227             }
228         }
229 
230         conductUniswap(sourceToken, destinationTokens[0], amount);
231         uint256 thisBalance = dToken.balanceOf(address(this));
232         dToken.transfer(msg.sender, thisBalance);
233         return (destinationTokens[0], thisBalance);
234 
235       }
236 
237       else{
238 
239         bool updatedweth =false;
240         if(sourceToken == ETH_TOKEN_ADDRESS){
241           WrappedETH sToken1 = WrappedETH(WETH_TOKEN_ADDRESS);
242           sToken1.deposit{value:msg.value}();
243           sToken = ERC20(WETH_TOKEN_ADDRESS);
244           amount = msg.value;
245           sourceToken = WETH_TOKEN_ADDRESS;
246           updatedweth =true;
247         }
248 
249 
250         if(sourceToken != ETH_TOKEN_ADDRESS && updatedweth==false){
251           require(sToken.transferFrom(msg.sender, address(this), amount), "You have not approved this contract or do not have enough token for this transfer  2");
252           if(sToken.allowance(address(this), uniAddress) < amount.mul(2)){
253                   sToken.approve(uniAddress, amount.mul(3));
254             }
255         }
256 
257         if(destinationTokens[0] == ETH_TOKEN_ADDRESS){
258               destinationTokens[0] = WETH_TOKEN_ADDRESS;
259         }
260         if(destinationTokens[1] == ETH_TOKEN_ADDRESS){
261             destinationTokens[1] = WETH_TOKEN_ADDRESS;
262         }
263 
264 
265 
266         if(sourceToken !=destinationTokens[0]){
267             conductUniswap(sourceToken, destinationTokens[0], amount.div(2));
268         }
269         if(sourceToken !=destinationTokens[1]){
270 
271             conductUniswap(sourceToken, destinationTokens[1], amount.div(2));
272         }
273 
274         ERC20 dToken2 = ERC20(destinationTokens[1]);
275         uint256 dTokenBalance = dToken.balanceOf(address(this));
276         uint256 dTokenBalance2 = dToken2.balanceOf(address(this));
277 
278         if(dToken.allowance(address(this), uniAddress) < dTokenBalance.mul(2)){
279              dToken.approve(uniAddress, dTokenBalance.mul(3));
280         }
281 
282         if(dToken2.allowance(address(this), uniAddress) < dTokenBalance2.mul(2)){
283             dToken2.approve(uniAddress, dTokenBalance2.mul(3));
284         }
285 
286         (,,uint liquidityCoins)  = uniswapExchange.addLiquidity(destinationTokens[0],destinationTokens[1], dTokenBalance, dTokenBalance2, 1,1, address(this), longTimeFromNow);
287 
288         address thisPairAddress = factory.getPair(destinationTokens[0],destinationTokens[1]);
289         ERC20 lpToken = ERC20(thisPairAddress);
290         lpTokenAddressToPairs[thisPairAddress] =[destinationTokens[0], destinationTokens[1]];
291         uint256 thisBalance =lpToken.balanceOf(address(this));
292 
293         if(fee>0){
294             uint256 totalFee = (thisBalance.mul(fee)).div(10000);
295             if(totalFee >0){
296                 lpToken.transfer(owner, totalFee);
297             }
298             thisBalance =lpToken.balanceOf(address(this));
299             lpToken.transfer(msg.sender, thisBalance);
300 
301         }
302         else{
303             lpToken.transfer(msg.sender, thisBalance);
304         }
305 
306 
307         //transfer any change to changeRecipient (from a pair imbalance. Should never be more than a few basis points)
308         address changeRecipient = msg.sender;
309         if(changeRecpientIsOwner == true){
310             changeRecipient = owner;
311         }
312         if(dToken.balanceOf(address(this)) >0){
313             dToken.transfer(changeRecipient, dToken.balanceOf(address(this)));
314         }
315         if(dToken2.balanceOf(address(this)) >0){
316             dToken2.transfer(changeRecipient, dToken2.balanceOf(address(this)));
317         }
318 
319         return (thisPairAddress,thisBalance) ;
320       }
321 
322 
323 
324     }
325 
326     function updateStableCoinAddress(string memory coinName, address newAddress) public onlyOwner returns(bool){
327         stablecoins[coinName] = newAddress;
328         return true;
329 
330     }
331 
332     function updatePresetPaths(address sellToken, address buyToken, address[] memory newPath ) public onlyOwner returns(bool){
333         presetPaths[sellToken][buyToken] = newPath;
334         return true;
335     }
336 
337     //owner can turn on ability to collect a small fee from trade imbalances on LP conversions
338     function updateChangeRecipientBool(bool changeRecpientIsOwnerBool ) public onlyOwner returns(bool){
339         changeRecpientIsOwner = changeRecpientIsOwnerBool;
340         return true;
341     }
342 
343 
344 
345       function unwrap(address sourceToken, address destinationToken, uint256 amount) public payable returns( uint256){
346 
347         address originalDestinationToken = destinationToken;
348         ERC20 sToken = ERC20(sourceToken);
349         if(destinationToken == ETH_TOKEN_ADDRESS){
350             destinationToken = WETH_TOKEN_ADDRESS;
351         }
352         ERC20 dToken = ERC20(destinationToken);
353 
354         if(sourceToken != ETH_TOKEN_ADDRESS){
355           require(sToken.transferFrom(msg.sender, address(this), amount), "You have not approved this contract or do not have enough token for this transfer  3 unwrapping");
356         }
357 
358         LPERC20 thisLpInfo = LPERC20(sourceToken);
359         lpTokenAddressToPairs[sourceToken] = [thisLpInfo.token0(), thisLpInfo.token1()];
360 
361           if(lpTokenAddressToPairs[sourceToken].length !=0){
362             if(sToken.allowance(address(this), uniAddress) < amount.mul(2)){
363                   sToken.approve(uniAddress, amount.mul(3));
364             }
365 
366           uniswapExchange.removeLiquidity(lpTokenAddressToPairs[sourceToken][0], lpTokenAddressToPairs[sourceToken][1], amount, 0,0, address(this), longTimeFromNow);
367 
368           ERC20 pToken1 = ERC20(lpTokenAddressToPairs[sourceToken][0]);
369           ERC20 pToken2 = ERC20(lpTokenAddressToPairs[sourceToken][1]);
370 
371           uint256 pTokenBalance = pToken1.balanceOf(address(this));
372           uint256 pTokenBalance2 = pToken2.balanceOf(address(this));
373 
374            if(pToken1.allowance(address(this), uniAddress) < pTokenBalance.mul(2)){
375                   pToken1.approve(uniAddress, pTokenBalance.mul(3));
376             }
377 
378             if(pToken2.allowance(address(this), uniAddress) < pTokenBalance2.mul(2)){
379                   pToken2.approve(uniAddress, pTokenBalance2.mul(3));
380             }
381 
382           if(lpTokenAddressToPairs[sourceToken][0] != destinationToken){
383               conductUniswap(lpTokenAddressToPairs[sourceToken][0], destinationToken, pTokenBalance);
384           }
385           if(lpTokenAddressToPairs[sourceToken][1] != destinationToken){
386               conductUniswap(lpTokenAddressToPairs[sourceToken][1], destinationToken, pTokenBalance2);
387           }
388 
389 
390           uint256 destinationTokenBalance = dToken.balanceOf(address(this));
391 
392           if(originalDestinationToken == ETH_TOKEN_ADDRESS){
393               wethToken.withdraw(destinationTokenBalance);
394               if(fee >0){
395                   uint256 totalFee = (address(this).balance.mul(fee)).div(10000);
396                   if(totalFee >0){
397                       owner.transfer(totalFee);
398                   }
399                   msg.sender.transfer(address(this).balance);
400               }
401               else{
402                 msg.sender.transfer(address(this).balance);
403               }
404           }
405           else{
406               if(fee >0){
407                    uint256 totalFee = (destinationTokenBalance.mul(fee)).div(10000);
408                    if(totalFee >0){
409                        dToken.transfer(owner, totalFee);
410                    }
411                    destinationTokenBalance = dToken.balanceOf(address(this));
412                    dToken.transfer(msg.sender, destinationTokenBalance);
413 
414               }
415               else{
416                dToken.transfer(msg.sender, destinationTokenBalance);
417               }
418           }
419 
420 
421           return destinationTokenBalance;
422 
423         }
424 
425         else{
426 
427             if(sToken.allowance(address(this), uniAddress) < amount.mul(2)){
428                   sToken.approve(uniAddress, amount.mul(3));
429             }
430             if(sourceToken != destinationToken){
431                 conductUniswap(sourceToken, destinationToken, amount);
432             }
433           uint256 destinationTokenBalance = dToken.balanceOf(address(this));
434           dToken.transfer(msg.sender, destinationTokenBalance);
435           return destinationTokenBalance;
436         }
437 
438       }
439 
440   function updateOwnerAddress(address payable newOwner) onlyOwner public returns (bool){
441      owner = newOwner;
442      return true;
443    }
444 
445    function updateUniswapExchange(address newAddress ) public onlyOwner returns (bool){
446 
447     uniswapExchange = UniswapV2( newAddress);
448     uniAddress = newAddress;
449     return true;
450 
451   }
452 
453   function updateUniswapFactory(address newAddress ) public onlyOwner returns (bool){
454 
455    factory = UniswapFactory( newAddress);
456    uniFactoryAddress = newAddress;
457    return true;
458 
459  }
460 
461 
462   function conductUniswap(address sellToken, address buyToken, uint amount) internal returns (uint256 amounts1){
463 
464             if(sellToken ==ETH_TOKEN_ADDRESS && buyToken == WETH_TOKEN_ADDRESS){
465                 wethToken.deposit{value:msg.value}();
466             }
467             else if(sellToken == address(0x0)){
468 
469                // address [] memory addresses = new address[](2);
470                address [] memory addresses = getBestPath(WETH_TOKEN_ADDRESS, buyToken, amount);
471                 //addresses[0] = WETH_TOKEN_ADDRESS;
472                 //addresses[1] = buyToken;
473                 uniswapExchange.swapExactETHForTokens{value:msg.value}(0, addresses, address(this), 1000000000000000 );
474 
475             }
476 
477             else if(sellToken == WETH_TOKEN_ADDRESS){
478                 wethToken.withdraw(amount);
479 
480                 //address [] memory addresses = new address[](2);
481                 address [] memory addresses = getBestPath(WETH_TOKEN_ADDRESS, buyToken, amount);
482                 //addresses[0] = WETH_TOKEN_ADDRESS;
483                 //addresses[1] = buyToken;
484                 uniswapExchange.swapExactETHForTokens{value:amount}(0, addresses, address(this), 1000000000000000 );
485 
486             }
487 
488 
489 
490             else{
491 
492           address [] memory addresses = getBestPath(sellToken, buyToken, amount);
493            uint256 [] memory amounts = conductUniswapT4T(addresses, amount );
494            uint256 resultingTokens = amounts[amounts.length-1];
495            return resultingTokens;
496             }
497     }
498 
499 
500     //gets the best path to route the transaction on Uniswap
501     function getBestPath(address sellToken, address buyToken, uint256 amount) public view returns (address[] memory){
502 
503         address [] memory defaultPath =new address[](2);
504         defaultPath[0]=sellToken;
505         defaultPath[1] = buyToken;
506 
507 
508         if(presetPaths[sellToken][buyToken].length !=0){
509             return presetPaths[sellToken][buyToken];
510         }
511 
512 
513         if(sellToken == stablecoins["DAI"] || sellToken == stablecoins["USDC"] || sellToken == stablecoins["USDT"]){
514             return defaultPath;
515         }
516         if(buyToken == stablecoins["DAI"] || buyToken == stablecoins["USDC"] || buyToken == stablecoins["USDT"]){
517             return defaultPath;
518         }
519 
520 
521 
522         address[] memory daiPath = new address[](3);
523         address[] memory usdcPath =new address[](3);
524         address[] memory usdtPath =new address[](3);
525 
526         daiPath[0] = sellToken;
527         daiPath[1] = stablecoins["DAI"];
528         daiPath[2] = buyToken;
529 
530         usdcPath[0] = sellToken;
531         usdcPath[1] = stablecoins["USDC"];
532         usdcPath[2] = buyToken;
533 
534         usdtPath[0] = sellToken;
535         usdtPath[1] = stablecoins["USDT"];
536         usdtPath[2] = buyToken;
537 
538 
539         uint256 directPathOutput =  getPriceFromUniswap(defaultPath, amount)[1];
540 
541 
542         uint256[] memory daiPathOutputRaw = getPriceFromUniswap(daiPath, amount);
543         uint256[]  memory usdtPathOutputRaw = getPriceFromUniswap(usdtPath, amount);
544         uint256[]  memory usdcPathOutputRaw = getPriceFromUniswap(usdcPath, amount);
545 
546         //uint256 directPathOutput = directPathOutputRaw[directPathOutputRaw.length-1];
547         uint256 daiPathOutput = daiPathOutputRaw[daiPathOutputRaw.length-1];
548         uint256 usdtPathOutput = usdtPathOutputRaw[usdtPathOutputRaw.length-1];
549         uint256 usdcPathOutput = usdcPathOutputRaw[usdcPathOutputRaw.length-1];
550 
551         uint256 bestPathOutput = directPathOutput;
552         address[] memory bestPath = new address[](2);
553         address[] memory bestPath3 = new address[](3);
554         //return defaultPath;
555         bestPath = defaultPath;
556 
557         bool isTwoPath = true;
558 
559         if(directPathOutput < daiPathOutput){
560             isTwoPath=false;
561             bestPathOutput = daiPathOutput;
562             bestPath3 = daiPath;
563         }
564         if(bestPathOutput < usdcPathOutput){
565             isTwoPath=false;
566             bestPathOutput = usdcPathOutput;
567             bestPath3 = usdcPath;
568         }
569          if(bestPathOutput < usdtPathOutput){
570              isTwoPath=false;
571             bestPathOutput = usdtPathOutput;
572             bestPath3 = usdtPath;
573         }
574 
575         require(bestPathOutput >0, "This trade will result in getting zero tokens back. Reverting");
576 
577         if(isTwoPath==true){
578               return bestPath;
579         }
580         else{
581             return bestPath3;
582         }
583 
584 
585 
586     }
587 
588     function getPriceFromUniswap(address  [] memory theAddresses, uint amount) public view returns (uint256[] memory amounts1){
589 
590 
591         try uniswapExchange.getAmountsOut(amount,theAddresses ) returns (uint256[] memory amounts){
592             return amounts;
593         }
594         catch  {
595             uint256 [] memory amounts2= new uint256[](2);
596             amounts2[0]=0;
597             amounts2[1]=0;
598             return amounts2;
599 
600         }
601 
602     }
603 
604     function conductUniswapT4T(address  [] memory theAddresses, uint amount) internal returns (uint256[] memory amounts1){
605 
606            uint256 deadline = 1000000000000000;
607            uint256 [] memory amounts =  uniswapExchange.swapExactTokensForTokens(amount, 0, theAddresses, address(this),deadline );
608            return amounts;
609 
610     }
611 
612     function adminEmergencyWithdrawTokens(address token, uint amount, address payable destination) public onlyOwner returns(bool) {
613 
614       if (address(token) == ETH_TOKEN_ADDRESS) {
615           destination.transfer(amount);
616       }
617       else {
618           ERC20 tokenToken = ERC20(token);
619           require(tokenToken.transfer(destination, amount));
620       }
621       return true;
622   }
623 
624 
625   function setFee(uint256 newFee) public onlyOwner returns (bool){
626     require(newFee<=maxfee, "Admin cannot set the fee higher than the current maxfee");
627     fee = newFee;
628     return true;
629   }
630 
631 
632   function setMaxFee(uint256 newMax) public onlyOwner returns (bool){
633     require(maxfee==0, "Admin can only set max fee once and it is perm");
634     maxfee = newMax;
635     return true;
636   }
637 
638   function addLPPair(address lpAddress, address token1, address token2) onlyOwner public returns (bool){
639       lpTokenAddressToPairs[lpAddress] = [token1, token2];
640       return true;
641   }
642 
643   function getLPTokenByPair(address token1, address token2) view public returns (address lpAddr){
644       address thisPairAddress = factory.getPair(token1,token2);
645       return thisPairAddress;
646   }
647 
648    function getUserTokenBalance(address userAddress, address tokenAddress) public view returns (uint256){
649     ERC20 token = ERC20(tokenAddress);
650     return token.balanceOf(userAddress);
651 
652   }
653 
654 }