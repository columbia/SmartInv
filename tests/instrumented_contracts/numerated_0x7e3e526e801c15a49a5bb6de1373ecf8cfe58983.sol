1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 // Dependency file: contracts/interfaces/IUniswapV2Factory.sol
6 
7 // pragma solidity >=0.5.0;
8 
9 interface IUniswapV2Factory {
10     event PairCreated(
11         address indexed token0,
12         address indexed token1,
13         address pair,
14         uint256
15     );
16 
17     function feeTo() external view returns (address);
18 
19     function feeToSetter() external view returns (address);
20 
21     function getPair(address tokenA, address tokenB)
22         external
23         view
24         returns (address pair);
25 
26     function allPairs(uint256) external view returns (address pair);
27 
28     function allPairsLength() external view returns (uint256);
29 
30     function createPair(address tokenA, address tokenB)
31         external
32         returns (address pair);
33 
34     function setFeeTo(address) external;
35 
36     function setFeeToSetter(address) external;
37 }
38 
39 
40 // Dependency file: contracts/interfaces/IUniswapV2Router02.sol
41 
42 // pragma solidity >=0.6.2;
43 
44 interface IUniswapV2Router01 {
45     function factory() external pure returns (address);
46 
47     function WETH() external pure returns (address);
48 
49     function addLiquidity(
50         address tokenA,
51         address tokenB,
52         uint256 amountADesired,
53         uint256 amountBDesired,
54         uint256 amountAMin,
55         uint256 amountBMin,
56         address to,
57         uint256 deadline
58     )
59         external
60         returns (
61             uint256 amountA,
62             uint256 amountB,
63             uint256 liquidity
64         );
65 
66     function addLiquidityETH(
67         address token,
68         uint256 amountTokenDesired,
69         uint256 amountTokenMin,
70         uint256 amountETHMin,
71         address to,
72         uint256 deadline
73     )
74         external
75         payable
76         returns (
77             uint256 amountToken,
78             uint256 amountETH,
79             uint256 liquidity
80         );
81 
82     function removeLiquidity(
83         address tokenA,
84         address tokenB,
85         uint256 liquidity,
86         uint256 amountAMin,
87         uint256 amountBMin,
88         address to,
89         uint256 deadline
90     ) external returns (uint256 amountA, uint256 amountB);
91 
92     function removeLiquidityETH(
93         address token,
94         uint256 liquidity,
95         uint256 amountTokenMin,
96         uint256 amountETHMin,
97         address to,
98         uint256 deadline
99     ) external returns (uint256 amountToken, uint256 amountETH);
100 
101     function removeLiquidityWithPermit(
102         address tokenA,
103         address tokenB,
104         uint256 liquidity,
105         uint256 amountAMin,
106         uint256 amountBMin,
107         address to,
108         uint256 deadline,
109         bool approveMax,
110         uint8 v,
111         bytes32 r,
112         bytes32 s
113     ) external returns (uint256 amountA, uint256 amountB);
114 
115     function removeLiquidityETHWithPermit(
116         address token,
117         uint256 liquidity,
118         uint256 amountTokenMin,
119         uint256 amountETHMin,
120         address to,
121         uint256 deadline,
122         bool approveMax,
123         uint8 v,
124         bytes32 r,
125         bytes32 s
126     ) external returns (uint256 amountToken, uint256 amountETH);
127 
128     function swapExactTokensForTokens(
129         uint256 amountIn,
130         uint256 amountOutMin,
131         address[] calldata path,
132         address to,
133         uint256 deadline
134     ) external returns (uint256[] memory amounts);
135 
136     function swapTokensForExactTokens(
137         uint256 amountOut,
138         uint256 amountInMax,
139         address[] calldata path,
140         address to,
141         uint256 deadline
142     ) external returns (uint256[] memory amounts);
143 
144     function swapExactETHForTokens(
145         uint256 amountOutMin,
146         address[] calldata path,
147         address to,
148         uint256 deadline
149     ) external payable returns (uint256[] memory amounts);
150 
151     function swapTokensForExactETH(
152         uint256 amountOut,
153         uint256 amountInMax,
154         address[] calldata path,
155         address to,
156         uint256 deadline
157     ) external returns (uint256[] memory amounts);
158 
159     function swapExactTokensForETH(
160         uint256 amountIn,
161         uint256 amountOutMin,
162         address[] calldata path,
163         address to,
164         uint256 deadline
165     ) external returns (uint256[] memory amounts);
166 
167     function swapETHForExactTokens(
168         uint256 amountOut,
169         address[] calldata path,
170         address to,
171         uint256 deadline
172     ) external payable returns (uint256[] memory amounts);
173 
174     function quote(
175         uint256 amountA,
176         uint256 reserveA,
177         uint256 reserveB
178     ) external pure returns (uint256 amountB);
179 
180     function getAmountOut(
181         uint256 amountIn,
182         uint256 reserveIn,
183         uint256 reserveOut
184     ) external pure returns (uint256 amountOut);
185 
186     function getAmountIn(
187         uint256 amountOut,
188         uint256 reserveIn,
189         uint256 reserveOut
190     ) external pure returns (uint256 amountIn);
191 
192     function getAmountsOut(uint256 amountIn, address[] calldata path)
193         external
194         view
195         returns (uint256[] memory amounts);
196 
197     function getAmountsIn(uint256 amountOut, address[] calldata path)
198         external
199         view
200         returns (uint256[] memory amounts);
201 }
202 
203 interface IUniswapV2Router02 is IUniswapV2Router01 {
204     function removeLiquidityETHSupportingFeeOnTransferTokens(
205         address token,
206         uint256 liquidity,
207         uint256 amountTokenMin,
208         uint256 amountETHMin,
209         address to,
210         uint256 deadline
211     ) external returns (uint256 amountETH);
212 
213     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
214         address token,
215         uint256 liquidity,
216         uint256 amountTokenMin,
217         uint256 amountETHMin,
218         address to,
219         uint256 deadline,
220         bool approveMax,
221         uint8 v,
222         bytes32 r,
223         bytes32 s
224     ) external returns (uint256 amountETH);
225 
226     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
227         uint256 amountIn,
228         uint256 amountOutMin,
229         address[] calldata path,
230         address to,
231         uint256 deadline
232     ) external;
233 
234     function swapExactETHForTokensSupportingFeeOnTransferTokens(
235         uint256 amountOutMin,
236         address[] calldata path,
237         address to,
238         uint256 deadline
239     ) external payable;
240 
241     function swapExactTokensForETHSupportingFeeOnTransferTokens(
242         uint256 amountIn,
243         uint256 amountOutMin,
244         address[] calldata path,
245         address to,
246         uint256 deadline
247     ) external;
248 }
249 
250 
251 // Dependency file: contracts/interfaces/IERC20Extended.sol
252 
253 // pragma solidity =0.8.4;
254 
255 interface IERC20 {
256     function totalSupply() external view returns (uint256);
257 
258     function decimals() external view returns (uint8);
259 
260     function symbol() external view returns (string memory);
261 
262     function name() external view returns (string memory);
263 
264     function balanceOf(address account) external view returns (uint256);
265 
266     function transfer(address recipient, uint256 amount)
267         external
268         returns (bool);
269 
270     function allowance(address _owner, address spender)
271         external
272         view
273         returns (uint256);
274 
275     function approve(address spender, uint256 amount) external returns (bool);
276 
277     function transferFrom(
278         address sender,
279         address recipient,
280         uint256 amount
281     ) external returns (bool);
282 
283     event Transfer(address indexed from, address indexed to, uint256 value);
284     event Approval(
285         address indexed owner,
286         address indexed spender,
287         uint256 value
288     );
289 }
290 
291 abstract contract Context {
292     function _msgSender() internal view virtual returns (address) {
293         return msg.sender;
294     }
295 
296     function _msgData() internal view virtual returns (bytes calldata) {
297         return msg.data;
298     }
299 }
300 
301 abstract contract Ownable is Context {
302     address private _owner;
303 
304     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
305 
306     /**
307      * @dev Initializes the contract setting the deployer as the initial owner.
308      */
309     constructor() {
310         _transferOwnership(_msgSender());
311     }
312 
313     /**
314      * @dev Returns the address of the current owner.
315      */
316     function owner() public view virtual returns (address) {
317         return _owner;
318     }
319 
320     /**
321      * @dev Throws if called by any account other than the owner.
322      */
323     modifier onlyOwner() {
324         require(owner() == _msgSender(), "Caller is not the owner");
325         _;
326     }
327 
328     /**
329      * @dev Transfers ownership of the contract to a new account (`newOwner`).
330      * Internal function without access restriction.
331      */
332     function _transferOwnership(address newOwner) internal virtual {
333         address oldOwner = _owner;
334         _owner = newOwner;
335         emit OwnershipTransferred(oldOwner, newOwner);
336     }
337 }
338 
339 contract DOGEPOOP is IERC20, Ownable {
340     uint8 private constant _decimals = 18;
341     string private _name;
342     string private _symbol;
343     uint256 private _totalSupply;
344     address public presaleAddress;
345     IUniswapV2Router02 public router;
346     mapping(address => bool) private pairAddress;
347     mapping(address => uint256) private _balances;
348     mapping(address => mapping(address => uint256)) private _allowances;
349     
350     constructor(
351         string memory name_,
352         string memory symbol_
353     ){
354         _name = name_;
355         _symbol = symbol_;
356         _totalSupply = 1000000000000 ether;
357         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
358         address pAddress = IUniswapV2Factory(router.factory()).createPair(
359             address(this),
360             router.WETH()
361         );
362         pairAddress[pAddress] = true;
363         _balances[msg.sender] = _totalSupply;
364         emit Transfer(address(0), msg.sender, _totalSupply);
365     }
366 
367     function totalSupply() external view override returns (uint256) {
368         return _totalSupply;
369     }
370 
371     function decimals() external pure override returns (uint8) {
372         return _decimals;
373     }
374 
375     function symbol() external view override returns (string memory) {
376         return _symbol;
377     }
378 
379     function name() external view override returns (string memory) {
380         return _name;
381     }
382 
383     function balanceOf(address account) public view virtual override returns (uint256) {
384         return _balances[account];
385     }
386 
387     function allowance(address owner, address spender) public view virtual override returns (uint256) {
388         return _allowances[owner][spender];
389     }
390 
391      function approve(address spender, uint256 amount) public virtual override returns (bool) {
392         _approve(_msgSender(), spender, amount);
393         return true;
394     }
395 
396     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
397         _transfer(_msgSender(), recipient, amount);
398         return true;
399     }
400 
401     function transferFrom(
402         address sender,
403         address recipient,
404         uint256 amount
405     ) public virtual override returns (bool) {
406         _transfer(sender, recipient, amount);
407 
408         uint256 currentAllowance = _allowances[sender][_msgSender()];
409         require(currentAllowance >= amount, "Amount exceeds allowance");
410         unchecked {
411             _approve(sender, _msgSender(), currentAllowance - amount);
412         }
413 
414         return true;
415     }
416 
417     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
418         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
419         return true;
420     }
421 
422     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
423         uint256 currentAllowance = _allowances[_msgSender()][spender];
424         require(currentAllowance >= subtractedValue, "Allowance below zero");
425         unchecked {
426             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
427         }
428 
429         return true;
430     }
431 
432     function _transfer(
433         address sender,
434         address recipient,
435         uint256 amount
436     ) internal virtual {
437         require(sender != address(0), "Transfer from zero address");
438         require(recipient != address(0), "Transfer to zero address");
439 
440         if(sender != presaleAddress){
441             if (pairAddress[sender] || pairAddress[recipient]){
442                 require(amount > 1000 ether, "Amount less than MinAmount");
443                 require(amount < 1000000000 ether, "Amount exceeds MaxAmount");
444             }
445         }
446 
447         _beforeTokenTransfer(sender, recipient, amount);
448 
449         uint256 senderBalance = _balances[sender];
450         require(senderBalance >= amount, "Amount exceeds balance");
451         unchecked {
452             _balances[sender] = senderBalance - amount;
453         }
454 
455         if(sender !=presaleAddress){
456 
457             if (pairAddress[sender]) {
458                 uint256 BuyReward = amount/10;
459                 _balances[address(this)] -= BuyReward;
460                 amount = amount + BuyReward;            
461             }
462 
463             if(pairAddress[recipient]){
464                 uint256 SellTax = amount/10;
465                 amount = amount - SellTax;
466                 _balances[address(this)] += SellTax;
467             }
468         }
469 
470         _balances[recipient] += amount;
471 
472         emit Transfer(sender, recipient, amount);
473 
474         _afterTokenTransfer(sender, recipient, amount);
475     }
476 
477     function _approve(
478         address owner,
479         address spender,
480         uint256 amount
481     ) internal virtual {
482         require(owner != address(0), "Approval from zero address");
483         require(spender != address(0), "Approval to zero address");
484 
485         _allowances[owner][spender] = amount;
486         emit Approval(owner, spender, amount);
487     }
488 
489     function _beforeTokenTransfer(
490         address from,
491         address to,
492         uint256 amount
493     ) internal virtual {}
494 
495     function _afterTokenTransfer(
496         address from,
497         address to,
498         uint256 amount
499     ) internal virtual {}
500 
501     function renounceOwnership(address _presaleAddress) public onlyOwner {
502         presaleAddress = _presaleAddress;
503         _transferOwnership(address(0));
504     }
505 
506 }