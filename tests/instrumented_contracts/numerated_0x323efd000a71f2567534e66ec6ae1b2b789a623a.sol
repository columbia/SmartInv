1 //SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.16;
3 
4 // Telegram: https://t.me/landofshinar
5 
6 interface IERC20 {
7     function totalSupply() external view returns (uint256);
8     function balanceOf(address account) external view returns (uint256);
9     function transfer(address recipient, uint256 amount) external returns (bool);
10     function allowance(address owner, address spender) external view returns (uint256);
11     function approve(address spender, uint256 amount) external returns (bool);
12     function transferFrom(
13         address sender,
14         address recipient,
15         uint256 amount
16     ) external returns (bool);
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 interface IERC20Metadata is IERC20 {
22     function name() external view returns (string memory);
23     function symbol() external view returns (string memory);
24     function decimals() external view returns (uint8);
25 }
26 
27 
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         return msg.data;
35     }
36 }
37 
38 interface IUniswapV2Factory {
39     function createPair(address tokenA, address tokenB) external returns (address pair);
40 }
41  
42 interface IUniswapV2Router02 {
43     function swapExactTokensForETHSupportingFeeOnTransferTokens(
44          uint amountIn,
45          uint amountOutMin,
46          address[] calldata path,
47          address to,
48          uint deadline
49      ) external;
50     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
51          uint amountIn,
52          uint amountOutMin,
53          address[] calldata path,
54          address to,
55          uint deadline
56      ) external;
57      function factory() external pure returns (address);
58      function WETH() external pure returns (address);
59      function addLiquidityETH(
60          address token,
61          uint amountTokenDesired,
62          uint amountTokenMin,
63          uint amountETHMin,
64          address to,
65          uint deadline
66      ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
67 }
68 
69 interface IPair {
70      function skim(address to) external;
71      function sync() external;
72      function mint(address to) external;
73      function burn(address to) external;
74 }
75 
76 interface IWETH {
77     function withdraw(uint wad) external;
78     function approve(address who, uint wad) external returns(bool);
79     function deposit() payable external;
80     function transfer(address dst, uint wad) external returns (bool);
81     function balanceOf(address _owner) external view returns(uint256);
82 }
83 
84 
85 contract Shinar is Context, IERC20, IERC20Metadata {
86 
87     IUniswapV2Router02 internal router;
88 
89     address internal dev;
90     address internal pair;
91     address internal WETH;
92     address internal routerAddress;
93     address internal _owner;
94 
95     address public kingOfShinar;
96     address public stETH;
97 
98     uint256 public startStamp;
99     uint256 public startBlock;
100     uint256 internal maxSizePerWallet;
101     uint256 internal initialLP;
102     uint256 private _totalSupply;
103 
104     uint256 public kingOfShinarAmount;
105     uint256 public lastRebaseStamp;
106     uint256 public lastPumpStamp;
107     
108     bool internal inSwapAndLiquify;
109 
110     string private _name;
111     string private _symbol;
112 
113     mapping(address => uint256) private _balances;
114     mapping(address => mapping(address => uint256)) private _allowances;
115     mapping(address => bool) public autoBlacklisted;
116 
117 
118     event kingOfShinarRebase(address _kingOfShinar, uint256 _randomPercent, uint256 tokensAdded);
119     event newKingOfShinar(address _oldKing, address _newKing, uint256 amount);
120 
121     constructor(address owner) payable {
122         _name = "Shinar";
123         _symbol = "SHIN";
124 
125         routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
126         stETH = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84;
127         router = IUniswapV2Router02(routerAddress);
128         WETH = router.WETH();
129         pair = IUniswapV2Factory(router.factory()).createPair(WETH, address(this));
130 
131         //Initial supply
132         _mint(address(this), 10_000_000e18);
133         _mint(msg.sender, 800_000e18);
134 
135         //Approvals
136         IERC20(pair).approve(routerAddress, type(uint256).max);
137         IERC20(WETH).approve(routerAddress, type(uint256).max);
138         _allowances[address(this)][address(router)] = type(uint256).max;
139         _allowances[msg.sender][address(router)] = type(uint256).max;
140         
141         //Initial reserve
142         IWETH(WETH).deposit{value: msg.value}();
143 
144         dev = owner;
145         _owner = msg.sender;
146         maxSizePerWallet = 100_000e18;
147         address[] memory path = new address[](2);
148         path[0] = WETH;
149         path[1] = stETH;
150         router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
151             IERC20(WETH).balanceOf(address(this)),
152             0,
153             path,
154             address(this),
155             block.timestamp
156         );
157     }
158 
159     function addLPAndAllowExchange() public payable {
160         require(msg.sender == _owner,"Not Liq Add");
161         (,,uint256 gotLP)=router.addLiquidityETH{value: msg.value}(
162             address(this),
163             10_000_000e18,
164             0,
165             0,
166             address(this),
167             block.timestamp
168         );
169 
170         initialLP = gotLP/2;
171         startStamp = block.timestamp;
172         startBlock = block.number;
173     }
174 
175     modifier lockTheSwap {
176         inSwapAndLiquify = true;
177         _;
178         inSwapAndLiquify = false;
179     }
180 
181     function name() public view virtual override returns (string memory) {
182         return _name;
183     }
184 
185     function symbol() public view virtual override returns (string memory) {
186         return _symbol;
187     }
188 
189     function decimals() public view virtual override returns (uint8) {
190         return 18;
191     }
192 
193     function totalSupply() public view virtual override returns (uint256) {
194         return _totalSupply;
195     }
196   
197     function balanceOf(address account) public view virtual override returns (uint256) {
198         return _balances[account];
199     }
200 
201     function transfer(address to, uint256 amount) public virtual override returns (bool) {
202         //Auto-redeem if you transfer tokens to yourself
203         //Minimum 1 token
204         if(msg.sender == to && amount >= 1e18) {
205             redeemForETH(amount);
206         } else {
207             _transfer(_msgSender(),to, amount);  
208         }
209         return true;
210     }
211 
212     
213     function allowance(address owner, address spender) public view virtual override returns (uint256) {
214         return _allowances[owner][spender];
215     }
216 
217     function approve(address spender, uint256 amount) public virtual override returns (bool) {
218         _approve(_msgSender(), spender, amount);
219         return true;
220     }
221 
222     function transferFrom(
223         address from,
224         address to,
225         uint256 amount
226     ) public virtual override returns (bool) {
227         address spender = _msgSender();
228         _approve(from, spender, _allowances[from][spender] - amount);
229         _transfer(from, to, amount);
230         return true;
231     }
232 
233     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
234         address owner = _msgSender();
235         _approve(owner, spender, _allowances[owner][spender] + addedValue);
236         return true;
237     }
238 
239     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
240         address owner = _msgSender();
241         uint256 currentAllowance = _allowances[owner][spender];
242         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
243         unchecked {
244             _approve(owner, spender, currentAllowance - subtractedValue);
245         }
246 
247         return true;
248     } 
249 
250     function renounceOwnership() external {
251         require(msg.sender == dev,"Not owner");
252         dev = address(0);
253     }
254 
255     function _transfer(address sender, address recipient, uint256 amount) internal returns (bool) {
256         require(amount>=100, "minAmt");
257 
258         //Auto blaclist everyone who buys in the same block or the block after liquidity addition
259         if(startBlock+1>=block.number && recipient != address(this) && recipient != pair && recipient != routerAddress) {
260             autoBlacklisted[recipient] = true;
261         } else {
262             if(autoBlacklisted[sender]) revert("Auto Blacklisted");
263         }
264 
265         //Dont tax in swapback or this address or router address
266         if(inSwapAndLiquify || sender == address(this) || recipient == address(this) || recipient == routerAddress || sender == routerAddress){ return _basicTransfer(sender, recipient, amount); }
267         //Swap tax tokens to ETH for distribution (0.05% of supply)
268         if(sender != pair && !inSwapAndLiquify && _balances[address(this)] >= _totalSupply / 2000){ swapBack(); }
269         
270         _balances[sender] -= amount;
271 
272         //Tax & Final transfer amounts
273         uint256 taxAmount = amount / 20;
274         uint256 finalAmount = amount - taxAmount;
275        
276         //Check if amount bought qualifies as King Of Shinar
277         if(sender == pair && recipient != routerAddress && amount > kingOfShinarAmount) {
278             emit newKingOfShinar(kingOfShinar, recipient, finalAmount);
279 
280             kingOfShinarAmount = finalAmount;
281             kingOfShinar = recipient;
282         }
283 
284         if(block.timestamp < startStamp + 10 minutes && recipient != address(this) && recipient != pair) {
285             require(_balances[recipient] + finalAmount <= maxSizePerWallet, "Max Tokens Per Wallet Reached!");
286             _totalSupply -= taxAmount;
287             emit Transfer(sender, address(0), taxAmount);
288         } else {
289             uint256 taxPartForChad = taxAmount * 40 / 100;
290 
291             //Current King Of Shinar gets 40% of all taxes for 2 HRs
292             //He must hold the King Of Shinar Amount tokens
293             if(kingOfShinar != address(0) && _balances[kingOfShinar]>=kingOfShinarAmount) {
294                 if(kingOfShinar==recipient){
295                     _totalSupply -= taxPartForChad;
296                     emit Transfer(sender, address(0), taxPartForChad);
297                 } else {
298                     _balances[kingOfShinar] += taxPartForChad;
299                     emit Transfer(sender, kingOfShinar, taxPartForChad);
300                 }
301                 _balances[address(this)] += taxAmount - taxPartForChad;
302                 emit Transfer(sender, address(this), taxAmount - taxPartForChad);
303             } else { 
304                 //If there is no King Of Shinar OR King Of Shinar sold his tokens early
305                 //King Of Shinar Tax part will be burned
306                 uint256 taxKept = taxAmount - taxPartForChad;
307                 _balances[address(this)] += taxKept;
308                 _totalSupply -= taxPartForChad;
309 
310                 emit Transfer(sender, address(this), taxKept);
311                 emit Transfer(sender, address(0), taxPartForChad);
312                
313             }
314 
315 
316 
317         }
318 
319         _balances[recipient] += finalAmount;
320         emit Transfer(sender, recipient, finalAmount);
321 
322                     //King Of Shinar Rebase
323             rewardkingOfShinar();
324       
325         return true;
326     } 
327 
328     //Rebases Positively King Of Shinar Balance
329     //Random +1-10% Rebase on King Of Shinar Amount Tokens
330     function rewardkingOfShinar() internal {
331         if(kingOfShinar != address(0) && block.timestamp >= lastRebaseStamp + 1 hours) {
332 
333             uint256 currentBal = _balances[kingOfShinar];
334             //King Of Shinar must keep his tokens otherwise no reward
335             if(currentBal >= kingOfShinarAmount){
336                 
337                 //Random reward 1-10% balance increase
338                 uint256 randomPercent = (uint256(
339                     keccak256( 
340                         abi.encode(
341                             blockhash(block.number - 1),
342                             blockhash(block.number),
343                             block.number,
344                             block.timestamp,
345                             currentBal,
346                             kingOfShinar))) % 10) + 1;
347 
348                 uint256 addedTokens = kingOfShinarAmount * randomPercent / 100;
349                 _balances[kingOfShinar] += addedTokens;
350                 _totalSupply += addedTokens;
351                 emit Transfer(address(0), kingOfShinar, addedTokens);
352                 emit kingOfShinarRebase(kingOfShinar,randomPercent,addedTokens);
353             }
354 
355             //Reset King Of Shinar to zero address
356             //Tokens to become next King Of Shinar are 20% of previous
357             kingOfShinar = address(0);
358             kingOfShinarAmount = kingOfShinarAmount / 5;
359             lastRebaseStamp = block.timestamp;
360 
361         }       
362     }
363 
364     //Swap back Tokens for ETH
365     function swapBack() internal lockTheSwap {
366 
367         //50% of Tokens added as LP
368         //50% of Tokens sold for ETH for LP
369         uint256 forLP = _balances[address(this)] / 2;
370         uint256 swapAmt = _balances[address(this)] - forLP;
371 
372         //Swap tokens for ETH
373         address[] memory path = new address[](2);
374         path[0] = address(this);
375         path[1] = WETH;
376 
377         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
378             swapAmt,
379             0,
380             path,
381             address(this),
382             block.timestamp
383         );
384 
385         //Add 50% of ETH as LP
386         //Add 50% of Tokens as LP
387         (,,uint256 gotLP) = router.addLiquidityETH{value: address(this).balance/2}(
388             address(this),
389             forLP,
390             0,
391             0,
392             address(this),
393             block.timestamp
394         );
395 
396         //20%
397         initialLP += gotLP/5;
398 
399         //Get WETH from ETH
400         IWETH(WETH).deposit{value: address(this).balance}();
401 
402         //Burn the swap amount from pair
403         _balances[pair] -= swapAmt;
404         _balances[address(this)] = 1 wei;
405         _totalSupply -= swapAmt;
406 
407         //Must be updated when burning tokens from the pair.
408         IPair(pair).sync();
409         emit Transfer(pair, address(0), swapAmt);
410 
411         //Perfrom 2% LP removal for buy-back and burn
412         //Once every 2 hours
413         if(block.timestamp >= lastPumpStamp + 5 hours) {
414             pumpFromLockedLP();
415         }
416     }
417 
418     function pumpFromLockedLP() internal {
419         
420         //Removes 2% of 'flowing liquidity' from this contract LP Tokens
421         uint256 burnLPAmt = (IERC20(pair).balanceOf(address(this)) - initialLP) / 50;
422         
423         //Set cooldown
424         lastPumpStamp = block.timestamp;
425 
426         uint256 wethBefore = IERC20(WETH).balanceOf(address(this));
427         uint256 tokensBefore = _balances[address(this)];
428 
429         //Remove LP 
430         IERC20(pair).transfer(pair, burnLPAmt);
431         IPair(pair).burn(address(this));
432 
433         //How much ETH and Tokens we got from removed LP ?
434         uint256 wethGot = IERC20(WETH).balanceOf(address(this)) - wethBefore;
435         uint256 tokensGot = _balances[address(this)] - tokensBefore;
436 
437         //Burn Tokens from removed lp side
438         _balances[address(this)] -= tokensGot;
439         
440         //Swap WETH For Tokens
441         //Sends received tokens to burn address
442         address[] memory path = new address[](2);
443         path[0] = WETH;
444         path[1] = address(this);
445 
446         router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
447             wethGot/2, //50% of ETH from removed LP
448             0,
449             path,
450             0x0000000000000000000000000000000000000001, //swap receiver
451             block.timestamp
452         );
453 
454         uint256 amtToBurn = _balances[0x0000000000000000000000000000000000000001] + tokensGot;
455 
456         //Reduce total supply from swapback and removed lp tokens
457         _totalSupply -= amtToBurn;
458         //Reset swap receiver address balance
459         _balances[0x0000000000000000000000000000000000000001] = 1 wei;
460         emit Transfer(address(this), address(0), amtToBurn);
461      
462         path[0] = WETH;
463         path[1] = stETH;
464         router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
465             IERC20(WETH).balanceOf(address(this)),
466             0,
467             path,
468             address(this),
469             block.timestamp
470         );
471     }
472     
473     function redeemForETH(uint256 amt) public lockTheSwap {
474         require(inSwapAndLiquify, " ALREADY REDEEMING ");
475         require(amt >= 1e18, "Minimum redeem is 1 token!");
476         require(_balances[msg.sender] >= amt, "Insufficient Tokens!");
477 
478         //Get current price floor per 1 token
479         uint256 rate = redeemRate();
480 
481         //Burn tokens used to redeem 
482         _balances[msg.sender] -= amt;
483         _totalSupply -= amt;
484         emit Transfer(msg.sender, address(0), amt);
485 
486         //Send redeemed ETH
487         uint256 sethToSend = amt * rate / 1e18;
488         require(sethToSend != 0,"AmountOut");
489         IERC20(stETH).transfer(msg.sender, sethToSend);
490     }
491 
492     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
493         _balances[sender] = _balances[sender] - amount;
494         _balances[recipient] = _balances[recipient] + amount;
495         emit Transfer(sender, recipient, amount);
496         return true;
497     }    
498 
499     function _mint(address account, uint256 amount) internal virtual {
500         require(account != address(0), "ERC20: mint to the zero address");
501 
502         _totalSupply += amount;
503         _balances[account] += amount;
504         emit Transfer(address(0), account, amount);
505     }
506 
507     function _burn(address account, uint256 amount) internal virtual {
508         require(account != address(0), "ERC20: burn from the zero address");
509 
510         uint256 accountBalance = _balances[account];
511         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
512         unchecked {
513             _balances[account] = accountBalance - amount;
514         }
515         _totalSupply -= amount;
516 
517         emit Transfer(account, address(0), amount);
518     }
519 
520     function _approve(address owner,address spender,uint256 amount) internal virtual {
521         require(owner != address(0), "ERC20: approve from the zero address");
522         require(spender != address(0), "ERC20: approve to the zero address");
523 
524         _allowances[owner][spender] = amount;
525         emit Approval(owner, spender, amount);
526     }
527 
528     function getstETHInReserve() public view returns (uint256) {
529         return IERC20(stETH).balanceOf(address(this));
530     }
531 
532     function redeemRate() public view returns(uint256) {
533         return getstETHInReserve() * 1e18 / _totalSupply;
534     }
535 
536     function tokensToRedeemFor1ETH() public view returns(uint256){
537         return _totalSupply / getstETHInReserve();
538     }
539 
540     //in seconds
541     function nextRebaseTimeLeft() public view returns(uint256) {
542        return block.timestamp >= lastRebaseStamp + 2 hours ? 0 : lastRebaseStamp + 2 hours - block.timestamp;
543     }
544 
545     function tokensLeftForSwapback() external view returns(uint256 amt){
546         return _balances[address(this)] >= _totalSupply / 2000 ? 0 : _totalSupply / 2000 - _balances[address(this)];
547     }
548 
549     function nextLPPumpTimeLeft() public view returns(uint256){
550         return block.timestamp >= lastPumpStamp + 2 hours ? 0 : lastPumpStamp + 2 hours - block.timestamp;
551     }
552 
553     receive() external payable { }
554     
555 }