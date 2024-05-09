1 //SPDX-License-Identifier: UNLICENSED
2 
3 /**
4 This is an extremely experimental project. Invest at your own risk.
5 This is ENTHROPY, an experiment to find order in chaos.
6 Stealth launch, no social, nada. Feel free to make them, if you wish. After all, it's your duty.
7 Contract has been audited with Mythx (https://mythx.io/), you can find the audit here https://blockchain.mypinata.cloud/ipfs/QmbrVGDRhkM54PTkr3YcuXdzRgumuDEdCCD7BZkkKuurmp
8 Taxes are differentiated for buys/transfers and sells.
9 BUY/TRANSFER: 1% LIQ, 1% DEV, 1% MULTISIGNATURE.
10 SELL: 1.66% LIQ, 1.66% DEV, 1.66% MULTISIGNATURE.
11 
12 Total supply 100000000000
13 Max transaction is 500000000 - 0.5%
14 Max wallet is 1000000000 - 1%
15 
16 Take a look at this countdown - https://www.tickcounter.com/countdown/3181804/enthropy-phase-2
17 When the timer will hit 0:00:00, liq will be taken out from the contract and burned and the multisignature contract (0x4be06AC6f859c54D397B3948127Cd36404eCF698) will be given to the crowd with Auth access.
18 Every function in the contract (and of course the funds) will be available to the multisignature, except set_owner() and set_dev_share(). Don't worry, I will teach you.
19 Top 20 holders at that time will be granted an nft to certify their partecipation and a spot in the multisignature wallet. In the subsequent hours you'll be contacted by me via either a transaction on the blockchain or with the Blockscan chat (https://chat.blockscan.com/).
20 From that point on, everything will be on your hands. You and your team will have freedom to move, freedom to add or remove people from the multisig, freedom to make this fly or kill it.
21 If you will behave and not fuck each other, I will show myself, be a counselor and, in case you wish, help you build utilities.
22 
23 You can reach me on Blockscan chat or by sending an empty transaction with a message to the deployer address, in case you wish. I will answer the same way
24 Occasionally I may send transactions with messages directly to the contract, look out for them. Or not, up to you.
25 Good luck.
26 */
27 
28 /* mythx-disable SWC-101*/
29 
30 pragma solidity 0.8.7;
31 
32 
33 library SafeMath {
34 
35     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         unchecked {
37             uint256 c = a + b;
38             if (c < a) return (false, 0);
39             return (true, c);
40         }
41     }
42 
43     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
44         unchecked {
45             if (b > a) return (false, 0);
46             return (true, a - b);
47         }
48     }
49 
50     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
51         unchecked {
52             if (a == 0) return (true, 0);
53             uint256 c = a * b;
54             if (c / a != b) return (false, 0);
55             return (true, c);
56         }
57     }
58 
59     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
60         unchecked {
61             if (b == 0) return (false, 0);
62             return (true, a / b);
63         }
64     }
65 
66     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a % b);
70         }
71     }
72 
73     function add(uint256 a, uint256 b) internal pure returns (uint256) {
74         return a + b;
75     }
76 
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         return a - b;
79     }
80 
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         return a * b;
83     }
84 
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         return a / b;
87     }
88 
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         return a % b;
91     }
92 
93     function sub(
94         uint256 a,
95         uint256 b,
96         string memory errorMessage
97     ) internal pure returns (uint256) {
98         unchecked {
99             require(b <= a, errorMessage);
100             return a - b;
101         }
102     }
103 
104     function div(
105         uint256 a,
106         uint256 b,
107         string memory errorMessage
108     ) internal pure returns (uint256) {
109         unchecked {
110             require(b > 0, errorMessage);
111             return a / b;
112         }
113     }
114 
115     function mod(
116         uint256 a,
117         uint256 b,
118         string memory errorMessage
119     ) internal pure returns (uint256) {
120         unchecked {
121             require(b > 0, errorMessage);
122             return a % b;
123         }
124     }
125 }
126 
127 interface ERC20 {
128     function totalSupply() external view returns (uint _totalSupply);
129     function balanceOf(address _owner) external view returns (uint balance);
130     function transfer(address _to, uint _value) external returns (bool success);
131     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
132     function approve(address _spender, uint _value) external returns (bool success);
133     function allowance(address _owner, address _spender) external view returns (uint remaining);
134     event Transfer(address indexed _from, address indexed _to, uint _value);
135     event Approval(address indexed _owner, address indexed _spender, uint _value);
136 }
137 
138 interface IUniswapFactory {
139     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
140 
141     function feeTo() external view returns (address);
142     function feeToSetter() external view returns (address);
143     function getPair(address tokenA, address tokenB) external view returns (address pair);
144     function allPairs(uint) external view returns (address pair);
145     function allPairsLength() external view returns (uint);
146     function createPair(address tokenA, address tokenB) external returns (address pair);
147     function setFeeTo(address) external;
148     function setFeeToSetter(address) external;
149 }
150 
151 interface IUniswapRouter01 {
152     function addLiquidity(
153         address tokenA,
154         address tokenB,
155         uint amountADesired,
156         uint amountBDesired,
157         uint amountAMin,
158         uint amountBMin,
159         address to,
160         uint deadline
161     ) external returns (uint amountA, uint amountB, uint liquidity);
162     function addLiquidityETH(
163         address token,
164         uint amountTokenDesired,
165         uint amountTokenMin,
166         uint amountETHMin,
167         address to,
168         uint deadline
169     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
170     function removeLiquidity(
171         address tokenA,
172         address tokenB,
173         uint liquidity,
174         uint amountAMin,
175         uint amountBMin,
176         address to,
177         uint deadline
178     ) external returns (uint amountA, uint amountB);
179     function removeLiquidityETH(
180         address token,
181         uint liquidity,
182         uint amountTokenMin,
183         uint amountETHMin,
184         address to,
185         uint deadline
186     ) external returns (uint amountToken, uint amountETH);
187     function removeLiquidityWithPermit(
188         address tokenA,
189         address tokenB,
190         uint liquidity,
191         uint amountAMin,
192         uint amountBMin,
193         address to,
194         uint deadline,
195         bool approveMax, uint8 v, bytes32 r, bytes32 s
196     ) external returns (uint amountA, uint amountB);
197     function removeLiquidityETHWithPermit(
198         address token,
199         uint liquidity,
200         uint amountTokenMin,
201         uint amountETHMin,
202         address to,
203         uint deadline,
204         bool approveMax, uint8 v, bytes32 r, bytes32 s
205     ) external returns (uint amountToken, uint amountETH);
206     function swapExactTokensForTokens(
207         uint amountIn,
208         uint amountOutMin,
209         address[] calldata path,
210         address to,
211         uint deadline
212     ) external returns (uint[] memory amounts);
213     function swapTokensForExactTokens(
214         uint amountOut,
215         uint amountInMax,
216         address[] calldata path,
217         address to,
218         uint deadline
219     ) external returns (uint[] memory amounts);
220     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
221     external
222     payable
223     returns (uint[] memory amounts);
224     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
225     external
226     returns (uint[] memory amounts);
227     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
228     external
229     returns (uint[] memory amounts);
230     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
231     external
232     payable
233     returns (uint[] memory amounts);
234 
235     function factory() external pure returns (address);
236     function WETH() external pure returns (address);
237     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
238     function getamountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
239     function getamountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
240     function getamountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
241     function getamountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
242 }
243 
244 interface IUniswapRouter02 is IUniswapRouter01 {
245     function removeLiquidityETHSupportingFeeOnTransferTokens(
246         address token,
247         uint liquidity,
248         uint amountTokenMin,
249         uint amountETHMin,
250         address to,
251         uint deadline
252     ) external returns (uint amountETH);
253     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
254         address token,
255         uint liquidity,
256         uint amountTokenMin,
257         uint amountETHMin,
258         address to,
259         uint deadline,
260         bool approveMax, uint8 v, bytes32 r, bytes32 s
261     ) external returns (uint amountETH);
262     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
263         uint amountIn,
264         uint amountOutMin,
265         address[] calldata path,
266         address to,
267         uint deadline
268     ) external;
269     function swapExactETHForTokensSupportingFeeOnTransferTokens(
270         uint amountOutMin,
271         address[] calldata path,
272         address to,
273         uint deadline
274     ) external payable;
275     function swapExactTokensForETHSupportingFeeOnTransferTokens(
276         uint amountIn,
277         uint amountOutMin,
278         address[] calldata path,
279         address to,
280         uint deadline
281     ) external;
282 }
283 
284 
285 interface IUniswapV2Pair {
286   event Approval(address indexed owner, address indexed spender, uint value);
287   event Transfer(address indexed from, address indexed to, uint value);
288 
289   function name() external pure returns (string memory);
290   function symbol() external pure returns (string memory);
291   function decimals() external pure returns (uint8);
292   function totalSupply() external view returns (uint);
293   function balanceOf(address owner) external view returns (uint);
294   function allowance(address owner, address spender) external view returns (uint);
295 
296   function approve(address spender, uint value) external returns (bool);
297   function transfer(address to, uint value) external returns (bool);
298   function transferFrom(address from, address to, uint value) external returns (bool);
299 
300   function DOMAIN_SEPARATOR() external view returns (bytes32);
301   function PERMIT_TYPEHASH() external pure returns (bytes32);
302   function nonces(address owner) external view returns (uint);
303 
304   function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
305 
306   event Mint(address indexed sender, uint amount0, uint amount1);
307   event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
308   event Swap(
309       address indexed sender,
310       uint amount0In,
311       uint amount1In,
312       uint amount0Out,
313       uint amount1Out,
314       address indexed to
315   );
316   event Sync(uint112 reserve0, uint112 reserve1);
317 
318   function MINIMUM_LIQUIDITY() external pure returns (uint);
319   function factory() external view returns (address);
320   function token0() external view returns (address);
321   function token1() external view returns (address);
322   function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
323   function price0CumulativeLast() external view returns (uint);
324   function price1CumulativeLast() external view returns (uint);
325   function kLast() external view returns (uint);
326 
327   function mint(address to) external returns (uint liquidity);
328   function burn(address to) external returns (uint amount0, uint amount1);
329   function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
330   function skim(address to) external;
331   function sync() external;
332 }
333 
334 contract smart {
335     using SafeMath for uint;
336 
337     address public router_address = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
338     IUniswapRouter02 public router = IUniswapRouter02(router_address);
339 
340     function create_weth_pair(address token) private returns (address, IUniswapV2Pair) {
341        address pair_address = IUniswapFactory(router.factory()).createPair(token, router.WETH());
342        return (pair_address, IUniswapV2Pair(pair_address));
343     }
344 
345     function get_weth_reserve(address pair_address) private  view returns(uint, uint) {
346         IUniswapV2Pair pair = IUniswapV2Pair(pair_address);
347         uint112 token_reserve;
348         uint112 native_reserve;
349         uint32 last_timestamp;
350         (token_reserve, native_reserve, last_timestamp) = pair.getReserves();
351         return (token_reserve, native_reserve);
352     }
353 
354     function get_weth_price_impact(address token, uint amount, bool sell) private view returns(uint) {
355         address pair_address = IUniswapFactory(router.factory()).getPair(token, router.WETH());
356         (uint res_token, uint res_weth) = get_weth_reserve(pair_address);
357         uint impact;
358         if(sell) {
359             impact = (amount.mul(100)).div(res_token);
360         } else {
361             impact = (amount.mul(100)).div(res_weth);
362         }
363         return impact;
364     }
365 }
366 
367 
368 
369 contract protected {
370 
371     bool public bot_smasher = true;
372     bool public trade_enabled = false;
373 
374     mapping (address => bool) public is_auth;
375 
376     function authorized(address addy) public view returns(bool) {
377         return is_auth[addy];
378     }
379 
380     function set_authorized(address addy, bool booly) public onlyAuth {
381         is_auth[addy] = booly;
382     }
383 
384     modifier onlyAuth() {
385         require( is_auth[msg.sender] || msg.sender==owner, "not owner");
386         _;
387     }
388 
389     address public owner;
390     address public developer;
391 
392     modifier onlyDev {
393         require(msg.sender==developer);
394         _;
395     }
396 
397     modifier onlyOwner() {
398         require(msg.sender==owner, "not owner");
399         _;
400     }
401 
402     bool public locked;
403     modifier safe() {
404         require(!locked, "reentrant");
405         locked = true;
406         _;
407         locked = false;
408     }
409 
410     receive() external payable {}
411     fallback() external payable {}
412 }
413 
414 contract ENTHROPY is smart, protected, ERC20 {
415 
416     using SafeMath for uint;
417     using SafeMath for uint8;
418 
419     mapping(address => bool) public tax_free;
420     mapping(address => bool) public lock_free;
421     mapping(address => bool) public is_black;
422     mapping(address => bool) public is_free_from_max_tx;
423     mapping(address => bool) public is_free_from_max_wallet;
424 
425 
426     string public constant _name = 'EnTHropy';
427     string public constant _symbol = 'EnTH';
428     uint8 public constant _decimals = 18;
429     uint256 public constant InitialSupply= 100 * (10**9) * (10**_decimals);
430     uint256 public constant _circulatingSupply= InitialSupply;
431     address public constant UniswapRouter=0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
432     address public constant Dead = 0x000000000000000000000000000000000000dEaD;
433     address public multisignature = 0x4be06AC6f859c54D397B3948127Cd36404eCF698;
434 
435     mapping(address => uint) public last_tx;
436 
437     bool public pegged = true;
438     bool public manual_swap = false;
439 
440     uint public dev_balance;
441     uint public multisig_balance;
442 
443     uint8 public buy_tax = 3;
444     uint8 public sell_tax = 5;
445     uint8 public transfer_tax = 3;
446 
447     uint8 public max_wallet = 1;
448     uint8 public max_perK = 5;
449 
450     uint8 devShare = 33;
451     uint8 liquidityShare = 34;
452     uint8 multisigShare = 33;
453 
454     uint public swap_treshold = (_circulatingSupply.div(300));
455 
456     mapping (address => uint256) public _balances;
457     mapping (address => mapping (address => uint256)) public _allowances;
458 
459     address public pair_address;
460     IUniswapV2Pair public pair;
461 
462     constructor() {
463         owner = msg.sender;
464         developer = msg.sender;
465         is_auth[owner] = true;
466         pair_address = IUniswapFactory(router.factory()).createPair(address(this), router.WETH());
467         pair = IUniswapV2Pair(pair_address);
468         tax_free[msg.sender] = true;
469         tax_free[multisignature] = true;
470         is_free_from_max_wallet[pair_address] = true;
471         _balances[developer] = totalSupply();
472         emit Transfer(Dead, address(this), totalSupply());
473         _approve(address(this), address(router), _circulatingSupply);
474         _approve(address(owner), address(router), _circulatingSupply);
475     }
476 
477     function _transfer(address sender, address recipient, uint amount) public {
478 
479         bool isExcluded = (tax_free[sender] || tax_free[recipient] || is_auth[sender] || is_auth[recipient]);
480 
481         bool isContractTransfer=(sender==address(this) || recipient==address(this));
482 
483         bool isLiquidityTransfer = ((sender == pair_address && recipient == UniswapRouter)
484         || (recipient == pair_address && sender == UniswapRouter));
485 
486 
487         if (isExcluded || isContractTransfer || isLiquidityTransfer) {
488             _feelessTransfer(sender, recipient, amount);
489         } else {
490             _taxedTransfer(sender, recipient, amount);
491         }
492 
493     }
494 
495     function max_tx() public view returns (uint) {
496         return ((_circulatingSupply * max_perK).div(1000));
497     }
498 
499     function _taxedTransfer(address sender, address recipient, uint amount) private {
500         require(!is_black[sender] && !is_black[recipient], "Blacklisted");
501 
502         if(!bot_smasher) {
503             require(trade_enabled, "STOP");
504         } else {
505             if(!trade_enabled) {
506                 emit Transfer(sender, recipient, 0);
507                 return;
508             }
509         }
510 
511         if(!is_free_from_max_tx[sender]) {
512             require(amount <= max_tx());
513         }
514 
515         if(!is_free_from_max_wallet[recipient]) {
516             require((_balances[recipient]+amount) < ((_circulatingSupply*max_wallet)/100), "Max wallet on recipient");
517         }
518 
519         bool isSell=recipient== pair_address|| recipient == router_address;
520 
521         (uint taxedAmount, uint taxes) = calculateFees(amount, isSell);
522 
523         if((_balances[address(this)] > swap_treshold) && !manual_swap && !locked) {
524             if(isSell && !manual_swap) {
525                 swap_taxes(amount);
526             }
527         }
528 
529         _balances[sender] = _balances[sender].sub(amount);
530         _balances[recipient] = _balances[recipient].add(taxedAmount);
531         _balances[address(this)] = _balances[address(this)].add(taxes);
532         emit Transfer(sender, address(this), taxes);
533         emit Transfer(sender, recipient, taxedAmount);
534     }
535 
536     function calculateFees(uint amount, bool isSell) private view returns (uint taxedAmount_, uint taxes_) {
537         uint8 tax;
538 
539         if(isSell) {
540             tax = sell_tax;
541         } else {
542             tax = buy_tax;
543         }
544 
545         uint taxes_coin = (amount*tax)/100;
546         uint taxed_amount = amount - taxes_coin;
547         return (taxed_amount, taxes_coin);
548 
549     }
550 
551     function swap_taxes(uint256 tx_amount) private safe{
552         uint256 contractBalance = _balances[address(this)];
553         uint16 totalTax = liquidityShare + multisigShare + devShare;
554         uint256 amount_to_swap = (swap_treshold.mul(75)).div(100);
555 
556         if(amount_to_swap > tx_amount) {
557             if(pegged) {
558                 amount_to_swap = tx_amount;
559             }
560         }
561         if(contractBalance<amount_to_swap){
562             return;
563         }
564 
565         uint256 tokenForLiquidity=(amount_to_swap*liquidityShare)/totalTax;
566         uint256 tokenForMarketing= (amount_to_swap * multisigShare)/totalTax;
567         uint256 tokenFordev= (amount_to_swap * devShare)/totalTax;
568 
569         uint256 liqToken=tokenForLiquidity/2;
570         uint256 liqETHToken=tokenForLiquidity-liqToken;
571 
572         uint256 swapToken=liqETHToken+tokenForMarketing+tokenFordev;
573         uint256 initialETHBalance = address(this).balance;
574         address[] memory path = new address[](2);
575         path[0] = address(this);
576         path[1] = router.WETH();
577         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
578             swapToken,
579             0,
580             path,
581             address(this),
582             block.timestamp
583             );
584         uint256 newETH=(address(this).balance - initialETHBalance);
585         uint256 liqETH = (newETH*liqETHToken)/swapToken;
586         router.addLiquidityETH{value: liqETH} (
587             address(this),
588             liqToken,
589             0,
590             0,
591             address(this),
592             block.timestamp);
593 
594         uint256 generatedETH=(address(this).balance - initialETHBalance);
595         uint256 multisigSplit = (generatedETH * multisigShare)/100;
596         uint256 devSplit = (generatedETH * devShare)/100;
597         multisig_balance += multisigSplit;
598         dev_balance += devSplit;
599     }
600 
601 
602     function _feelessTransfer(address sender, address recipient, uint amount) private {
603         _balances[sender] -= amount;
604         _balances[recipient] += amount;
605         emit Transfer(sender, recipient, amount);
606     }
607 
608     function ready_set_launch() public onlyDev {
609         require(trade_enabled == false);
610         bot_smasher = false;
611         trade_enabled = true;
612     }
613 
614     function withdraw_dev() public onlyDev {
615         uint256 amount=dev_balance;
616         dev_balance=0;
617         (bool sent, ) = developer.call{value: (amount)}("");
618         require(sent, "Error");
619     }
620 
621     function withdraw_multisig() public onlyAuth {
622         uint256 amount=multisig_balance;
623         multisig_balance=0;
624         (bool sent, ) = multisignature.call{value: (amount)}("");
625         require(sent, "Error");
626     }
627 
628     function emergency_withdraw() public onlyAuth {
629 
630         uint256 amount = (((address(this).balance)*95)/100);
631         uint256 amount_dev = amount.mul(devShare.div(devShare + multisigShare));
632         uint256 amount_multisig = amount.mul(multisigShare.div(devShare + multisigShare));
633         dev_balance=0;
634         multisig_balance=0;
635         (bool sentdev, ) = developer.call{value: (amount_dev)}("");
636         (bool sentmulti, ) = multisignature.call{value: (amount_multisig)}("");
637         require(sentdev, "Error");
638         require(sentmulti, "Error");
639     }
640 
641     function set_dev_share(uint8 dev) public onlyDev {
642         require(dev <= 33, "33 max");
643         devShare = dev;
644     }
645 
646     function set_shares(uint8 liq, uint8 multisig) public onlyAuth {
647         liquidityShare = liq;
648         multisigShare = multisig;
649         require((liq+multisig)<=66, "Need to be 66 max");
650         uint totalShares = liquidityShare.add(multisigShare).add(devShare);
651         if (totalShares < 100) {
652             devShare.add(100-totalShares);
653         }
654     }
655 
656     function set_taxes(uint8 buy, uint8 sell) public onlyAuth {
657         buy_tax = buy;
658         sell_tax = sell;
659         require(buy > 0 && sell > 0, "At least 1");
660         require(buy< 15 && sell < 15, "No honeypot");
661     }
662 
663     function set_manual_swap(bool booly) public onlyAuth {
664         manual_swap = booly;
665     }
666 
667     function execute_manual_swap(uint256 amount) public onlyAuth {
668         require(amount < _balances[address(this)], "dude there are not enough token");
669         swap_taxes(amount);
670     }
671 
672     function rescue_tokens(address tknAddress) public onlyAuth {
673         ERC20 token = ERC20(tknAddress);
674         uint256 ourBalance = token.balanceOf(address(this));
675         require(ourBalance>0, "No tokens in our balance");
676         token.transfer(msg.sender, ourBalance);
677     }
678 
679     function set_max_tx(uint8 maxtx) public onlyAuth {
680         max_perK = maxtx;
681         require(maxtx >= 5, "At least 5, remember that it's /1000, so 5 = 0.5%");
682     }
683 
684     function set_max_wallet(uint8 maxwallet) public onlyAuth {
685         max_wallet = maxwallet;
686         require(maxwallet >= 1, "At least 1, remember that it's /100, so 1 = 1%");
687     }
688 
689     function set_free_from_max_tx(address addy, bool booly) public onlyAuth {
690         is_free_from_max_tx[addy] = booly;
691     }
692 
693     function set_free_from_max_wallet(address addy, bool booly) public onlyAuth {
694         is_free_from_max_wallet[addy] = booly;
695     }
696 
697     function set_free_tax(address addy, bool booly) public onlyAuth {
698         tax_free[addy] = booly;
699     }
700 
701     function set_owner(address newowner) public onlyDev {
702         owner = newowner;
703         is_auth[newowner] = true;
704     }
705 
706     function control_blacklist(address to_control, bool booly) public onlyAuth {
707         require(!(to_control==developer));
708         is_black[to_control] = booly;
709     }
710 
711     function set_pegged_swap(bool booly) public onlyAuth {
712         pegged = booly;
713     }
714 
715     function getOwner() external view returns (address) {
716         return owner;
717     }
718 
719     function name() external pure returns (string memory) {
720         return _name;
721     }
722 
723     function symbol() external pure returns (string memory) {
724         return _symbol;
725     }
726 
727     function decimals() external pure returns (uint8) {
728         return _decimals;
729     }
730 
731     function totalSupply() pure public override returns (uint256) {
732         return _circulatingSupply;
733     }
734 
735     function balanceOf(address account) external view override returns (uint256) {
736         return _balances[account];
737     }
738 
739     function transfer(address recipient, uint256 amount) external override returns (bool) {
740         _transfer(msg.sender, recipient, amount);
741         return true;
742     }
743 
744     function allowance(address _owner, address spender) external view override returns (uint256) {
745         return _allowances[_owner][spender];
746     }
747 
748     function approve(address spender, uint256 amount) external override returns (bool) {
749         _approve(msg.sender, spender, amount);
750         return true;
751     }
752     function _approve(address _owner, address spender, uint256 amount) private {
753         require(_owner != address(0), "Approve from zero");
754         require(spender != address(0), "Approve to zero");
755 
756         _allowances[_owner][spender] = amount;
757         emit Approval(_owner, spender, amount);
758     }
759 
760     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
761         _transfer(sender, recipient, amount);
762 
763         uint256 currentAllowance = _allowances[sender][msg.sender];
764         require(currentAllowance >= amount, "Transfer > allowance");
765 
766         _approve(sender, msg.sender, currentAllowance - amount);
767         return true;
768     }
769 
770 
771     function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
772         _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
773         return true;
774     }
775 
776     function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
777         uint256 currentAllowance = _allowances[msg.sender][spender];
778         require(currentAllowance >= subtractedValue, "<0 allowance");
779 
780         _approve(msg.sender, spender, currentAllowance - subtractedValue);
781         return true;
782     }
783 
784 }
785 
786  /* mythx-enable SWC-101*/