1 pragma solidity 0.5.16;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) 
7             return 0;
8         uint256 c = a * b;
9         require(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         require(b > 0);
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
20         require(b > 0);
21         uint256 c = a / b;
22         if(a % b != 0)
23             c = c + 1;
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         require(b <= a);
29         uint256 c = a - b;
30         return c;
31     }
32 
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a);
36         return c;
37     }
38 
39     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
40         require(b != 0);
41         return a % b;
42     }
43 
44     int256 constant private INT256_MIN = -2^255;
45 
46     function mul(int256 a, int256 b) internal pure returns (int256) {
47         if (a == 0) 
48             return 0;
49         int256 c = a * b;
50         require(c / a == b && (a != -1 || b != INT256_MIN));
51         return c;
52     }
53 
54     function div(int256 a, int256 b) internal pure returns (int256) {
55         require(b != 0 && (b != -1 || a != INT256_MIN));
56         int256 c = a / b;
57         return c;
58     }
59 
60     function sub(int256 a, int256 b) internal pure returns (int256) {
61         int256 c = a - b;
62         require((b >= 0 && c <= a) || (b < 0 && c > a));
63         return c;
64     }
65 
66     function add(int256 a, int256 b) internal pure returns (int256) {
67         int256 c = a + b;
68         require((b >= 0 && c >= a) || (b < 0 && c < a));
69         return c;
70     }
71 
72     function sqrt(int256 x) internal pure returns (int256) {
73         int256 z = add(x / 2, 1);
74         int256 y = x;
75         while (z < y)
76         {
77             y = z;
78             z = ((add((x / z), z)) / 2);
79         }
80         return y;
81     }
82 }
83 
84 
85 contract ERC20 {
86     using SafeMath for uint256;
87 
88     mapping (address => uint256) internal _balances;
89     mapping (address => mapping (address => uint256)) internal _allowed;
90     
91     event Transfer(address indexed from, address indexed to, uint256 value);
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 
94     uint256 internal _totalSupply;
95 
96     /**
97     * @dev Total number of tokens in existence
98     */
99     function totalSupply() public view returns (uint256) {
100         return _totalSupply;
101     }
102 
103     /**
104     * @dev Gets the balance of the specified address.
105     * @param owner The address to query the balance of.
106     * @return A uint256 representing the amount owned by the passed address.
107     */
108     function balanceOf(address owner) public view returns (uint256) {
109         return _balances[owner];
110     }
111 
112     /**
113     * @dev Function to check the amount of tokens that an owner allowed to a spender.
114     * @param owner address The address which owns the funds.
115     * @param spender address The address which will spend the funds.
116     * @return A uint256 specifying the amount of tokens still available for the spender.
117     */
118     function allowance(address owner, address spender) public view returns (uint256) {
119         return _allowed[owner][spender];
120     }
121 
122     /**
123     * @dev Transfer token to a specified address
124     * @param to The address to transfer to.
125     * @param value The amount to be transferred.
126     */
127     function transfer(address to, uint256 value) public returns (bool) {
128         _transfer(msg.sender, to, value);
129         return true;
130     }
131 
132     /**
133     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
134     * Beware that changing an allowance with this method brings the risk that someone may use both the old
135     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
136     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
137     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138     * @param spender The address which will spend the funds.
139     * @param value The amount of tokens to be spent.
140     */
141     function approve(address spender, uint256 value) public returns (bool) {
142         _allowed[msg.sender][spender] = value;
143         emit Approval(msg.sender, spender, value);
144         return true;
145     }
146 
147     /**
148     * @dev Transfer tokens from one address to another.
149     * Note that while this function emits an Approval event, this is not required as per the specification,
150     * and other compliant implementations may not emit the event.
151     * @param from address The address which you want to send tokens from
152     * @param to address The address which you want to transfer to
153     * @param value uint256 the amount of tokens to be transferred
154     */
155     function transferFrom(address from, address to, uint256 value) public returns (bool) {
156         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
157         _transfer(from, to, value);
158         return true;
159     }
160 
161     function _transfer(address from, address to, uint256 value) internal {
162         require(to != address(0));
163         _balances[from] = _balances[from].sub(value);
164         _balances[to] = _balances[to].add(value);
165         emit Transfer(from, to, value);
166     }
167 
168 }
169 
170 contract ERC20Mintable is ERC20 {
171     string public name;
172     string public symbol;
173     uint8 public decimals;
174 
175     function _mint(address to, uint256 amount) internal {
176         _balances[to] = _balances[to].add(amount);
177         _totalSupply = _totalSupply.add(amount);
178         emit Transfer(address(0), to, amount);
179     }
180 
181     function _burn(address from, uint256 amount) internal {
182         _balances[from] = _balances[from].sub(amount);
183         _totalSupply = _totalSupply.sub(amount);
184         emit Transfer(from, address(0), amount);
185     }
186 }
187 
188 contract CERC20 is ERC20 {
189     function borrow(uint256) external returns (uint256);
190     function borrowBalanceCurrent(address) external returns (uint256);
191     function repayBorrow(uint256) external returns (uint256);
192     function mint(uint256) external returns (uint256);
193     function redeemUnderlying(uint256) external returns (uint256);
194     function balanceOfUnderlying(address) external returns (uint256);
195 }
196 
197 
198 interface Comptroller {
199     function enterMarkets(address[] calldata) external returns (uint256[] memory);
200 }
201 
202 contract UniswapV2Router02 {
203     function swapExactTokensForTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
204 }
205 
206 contract blackholeswap is ERC20Mintable {
207     using SafeMath for *;
208 
209     /***********************************|
210     |        Variables && Events        |
211     |__________________________________*/
212 
213     Comptroller constant comptroller = Comptroller(0x3d9819210A31b4961b30EF54bE2aeD79B9c9Cd3B);
214     UniswapV2Router02 constant uniswap = UniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
215 
216     ERC20 constant Comp = ERC20(0xc00e94Cb662C3520282E6f5717214004A7f26888);
217     ERC20 constant Dai = ERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
218     ERC20 constant USDC = ERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
219     CERC20 constant cDai = CERC20(0x5d3a536E4D6DbD6114cc1Ead35777bAB948E3643);
220     CERC20 constant cUSDC = CERC20(0x39AA39c021dfbaE8faC545936693aC917d5E7563);
221 
222     event Purchases(address indexed buyer, address indexed sell_token, uint256 inputs, address indexed buy_token, uint256 outputs);
223     event AddLiquidity(address indexed provider, uint256 share, int256 DAIAmount, int256 USDCAmount);
224     event RemoveLiquidity(address indexed provider, uint256 share, int256 DAIAmount, int256 USDCAmount);
225 
226     /***********************************|
227     |            Constsructor           |
228     |__________________________________*/
229 
230     constructor() public {
231         symbol = "BHSc$";
232         name = "BlackHoleSwap-Compound DAI/USDC v1";
233         decimals = 18;
234 
235         Dai.approve(address(cDai), uint256(-1));
236         USDC.approve(address(cUSDC), uint256(-1));
237         Comp.approve(address(uniswap), uint256(-1));
238 
239         address[] memory cTokens = new address[](2);
240         cTokens[0] = address(cDai);
241         cTokens[1] = address(cUSDC);
242         uint256[] memory errors = comptroller.enterMarkets(cTokens);
243         require(errors[0] == 0 && errors[1] == 0, "Comptroller.enterMarkets failed.");
244 
245         admin = msg.sender;
246     }
247 
248     /***********************************|
249     |        Governmence & Params       |
250     |__________________________________*/
251 
252     uint256 public fee = 0.99985e18;
253     uint256 public protocolFee = 0;
254     uint256 public constant amplifier = 0.75e18;
255 
256     address private admin;
257     address private vault;
258 
259     function setAdmin(address _admin) external {
260         require(msg.sender == admin);
261         admin = _admin;
262     }
263 
264     function setParams(uint256 _fee, uint256 _protocolFee) external {
265         require(msg.sender == admin);
266         require(_fee < 1e18 && _fee >= 0.99e18); //0 < fee <= 1%
267         if(_protocolFee > 0)
268             require(uint256(1e18).sub(_fee).div(_protocolFee) >= 3); //protocolFee < 33.3% fee
269         fee = _fee;
270         protocolFee = _protocolFee;
271     }
272 
273     function setVault(address _vault) external {
274         require(msg.sender == admin);
275         vault = _vault;
276     }
277 
278     /***********************************|
279     |         Getter Functions          |
280     |__________________________________*/
281 
282     function getDaiBalance() public returns (uint256, uint256) {
283         if (cDai.balanceOf(address(this)) <= 10)
284             return (0, cDai.borrowBalanceCurrent(address(this)));
285         else
286             return (cDai.balanceOfUnderlying(address(this)), cDai.borrowBalanceCurrent(address(this)));
287     }
288 
289     function getUSDCBalance() public returns (uint256, uint256) {
290         if (cUSDC.balanceOf(address(this)) <= 10)
291             return (0, cUSDC.borrowBalanceCurrent(address(this)).mul(rate()) );
292         else
293             return (cUSDC.balanceOfUnderlying(address(this)).mul(rate()), cUSDC.borrowBalanceCurrent(address(this)).mul(rate()));
294     }
295 
296     // DAI + USDC
297     function S() external returns (uint256) {
298         (uint256 a, uint256 b) = getDaiBalance();
299         (uint256 c, uint256 d) = getUSDCBalance();
300         return(a.add(c).sub(b).sub(d));
301     }
302 
303     function F(int256 _x, int256 x, int256 y) internal pure returns (int256 _y) {
304         int256 k;
305         int256 c;
306         {
307             // u = x + ay, v = y + ax
308             int256 u = x.add(y.mul(int256(amplifier)).div(1e18));
309             int256 v = y.add(x.mul(int256(amplifier)).div(1e18));
310             k = u.mul(v); // k = u * v
311             c = _x.mul(_x).sub( k.mul(1e18).div(int256(amplifier)) ); // c = x^2 - k/a
312         }
313         
314         int256 cst = int256(amplifier).add(1e36.div(int256(amplifier))); // a + 1/a
315         int256 b = _x.mul(cst).div(1e18); 
316 
317         // y^2 + by + c = 0
318         // D = b^2 - 4c
319         // _y = (-b + sqrt(D)) / 2
320 
321         int256 D = b.mul(b).sub(c.mul(4));
322 
323         require(D >= 0, "no root");
324 
325         _y = (-b).add(D.sqrt()).div(2);
326 
327     }
328 
329     function getInputPrice(uint256 input, uint256 a, uint256 b, uint256 c, uint256 d) public pure returns (uint256) {
330         int256 x = int256(a).sub(int256(b));
331         int256 y = int256(c).sub(int256(d));
332         int256 _x = x.add(int256(input));
333 
334         int256 _y = F(_x, x, y);
335 
336         return uint256(y.sub(_y));
337     }
338 
339     function getOutputPrice(uint256 output, uint256 a, uint256 b, uint256 c, uint256 d) public pure returns (uint256) {
340         int256 x = int256(a).sub(int256(b));
341         int256 y = int256(c).sub(int256(d));
342         int256 _y = y.sub(int256(output));
343 
344         int256 _x = F(_y, y, x);
345 
346         return uint256(_x.sub(x));
347     }
348 
349     function rate() public pure returns (uint256) {
350         return 1e12;
351     }
352 
353     /***********************************|
354     |        Exchange Functions         |
355     |__________________________________*/
356     
357     function calcFee(uint256 input, uint256 a, uint256 b, uint256 c, uint256 d) internal {
358         if(protocolFee > 0) {
359             uint256 _fee = input.mul(protocolFee).mul(_totalSupply).div(1e18).div( a.add(c).sub(b).sub(d) );
360             _mint(vault, _fee);
361         }
362     }
363 
364     function dai2usdcIn(uint256 input, uint256 min_output, uint256 deadline) external returns (uint256) {
365         require(block.timestamp <= deadline, "EXPIRED");
366         (uint256 a, uint256 b) = getDaiBalance();
367         (uint256 c, uint256 d) = getUSDCBalance();
368 
369         uint256 output = getInputPrice(input.mul(fee).div(1e18), a, b, c, d);
370         securityCheck(input, output, a, b, c, d);
371         output = output.div(rate());
372         require(output >= min_output, "SLIPPAGE_DETECTED");
373 
374         calcFee(input, a, b, c, d);
375 
376         doTransferIn(Dai, cDai, b, msg.sender, input);
377         doTransferOut(USDC, cUSDC, c.div(rate()), msg.sender, output);
378 
379         emit Purchases(msg.sender, address(Dai), input, address(USDC), output);
380 
381         return output;
382     }
383     
384     function usdc2daiIn(uint256 input, uint256 min_output, uint256 deadline) external returns (uint256) {
385         require(block.timestamp <= deadline, "EXPIRED");
386         (uint256 a, uint256 b) = getDaiBalance();
387         (uint256 c, uint256 d) = getUSDCBalance();
388 
389         uint256 output = getInputPrice(input.mul(fee).div(1e6), c, d, a, b); // input * rate() * fee / 1e18
390         securityCheck(input.mul(rate()), output, c, d, a, b);
391         require(output >= min_output, "SLIPPAGE_DETECTED");
392         
393         calcFee(input.mul(rate()), a, b, c, d);
394         
395         doTransferIn(USDC, cUSDC, d.div(rate()), msg.sender, input);
396         doTransferOut(Dai, cDai, a, msg.sender, output);
397 
398         emit Purchases(msg.sender, address(USDC), input, address(Dai), output);
399 
400         return output;
401     }
402 
403     function dai2usdcOut(uint256 max_input, uint256 output, uint256 deadline) external returns (uint256) {
404         require(block.timestamp <= deadline, "EXPIRED");
405         (uint256 a, uint256 b) = getDaiBalance();
406         (uint256 c, uint256 d) = getUSDCBalance();
407 
408         uint256 input = getOutputPrice(output.mul(rate()), a, b, c, d);
409         securityCheck(input, output.mul(rate()), a, b, c, d);
410         input = input.mul(1e18).divCeil(fee);
411         require(input <= max_input, "SLIPPAGE_DETECTED");
412 
413         calcFee(input, a, b, c, d);
414 
415         doTransferIn(Dai, cDai, b, msg.sender, input);
416         doTransferOut(USDC, cUSDC, c.div(rate()), msg.sender, output);
417 
418         emit Purchases(msg.sender, address(Dai), input, address(USDC), output);
419 
420         return input;
421     }
422     
423     function usdc2daiOut(uint256 max_input, uint256 output, uint256 deadline) external returns (uint256) {
424         require(block.timestamp <= deadline, "EXPIRED");
425         (uint256 a, uint256 b) = getDaiBalance();
426         (uint256 c, uint256 d) = getUSDCBalance();
427 
428         uint256 input = getOutputPrice(output, c, d, a, b);
429         securityCheck(input, output, c, d, a, b);
430         input = input.mul(1e6).divCeil(fee); // input * 1e18 / fee / 1e12
431         require(input <= max_input, "SLIPPAGE_DETECTED");
432 
433         calcFee(input.mul(rate()), a, b, c, d);
434 
435         doTransferIn(USDC, cUSDC, d.div(rate()), msg.sender, input);
436         doTransferOut(Dai, cDai, a, msg.sender, output);
437 
438         emit Purchases(msg.sender, address(USDC), input, address(Dai), output);
439 
440         return input;
441     }
442     
443     function doTransferIn(ERC20 token, CERC20 ctoken, uint256 debt, address from, uint256 amount) internal {
444         require(token.transferFrom(from, address(this), amount));
445 
446         if(debt > 0) {
447             if(debt >= amount) {
448                 require(ctoken.repayBorrow(amount) == 0, "ctoken.repayBorrow failed");
449             }
450             else {
451                 require(ctoken.repayBorrow(debt) == 0, "ctoken.repayBorrow failed");
452                 require(ctoken.mint(amount.sub(debt)) == 0, "ctoken.mint failed");
453             }
454         }
455         else {
456             require(ctoken.mint(amount) == 0, "ctoken.mint failed");
457         }
458     }
459 
460     function doTransferOut(ERC20 token, CERC20 ctoken, uint256 balance, address to, uint256 amount) internal {
461         if(balance >= amount) {
462             require(ctoken.redeemUnderlying(amount) == 0, "ctoken.redeemUnderlying failed");
463         }
464         else {
465             if(balance == 0) {
466                 require(ctoken.borrow(amount) == 0, "ctoken.borrow failed");
467             }
468             else {
469                 require(ctoken.redeemUnderlying(balance) == 0, "ctoken.redeemUnderlying failed");
470                 require(ctoken.borrow(amount.sub(balance)) == 0, "ctoken.borrow failed");
471             }
472         }
473 
474         require(token.transfer(to, amount));
475     }
476 
477     function securityCheck(uint256 input, uint256 output, uint256 a, uint256 b, uint256 c, uint256 d) internal pure {
478         if(c < output.add(d))
479             require(output.add(d).sub(c).mul(100) < input.add(a).sub(b).mul(62), "DEBT_TOO_MUCH"); // debt/collateral < 62%
480     }
481 
482     /***********************************|
483     |        Liquidity Functions        |
484     |__________________________________*/
485 
486     function addLiquidity(uint256 share, uint256[4] calldata tokens) external returns (uint256 dai_in, uint256 dai_out, uint256 usdc_in, uint256 usdc_out) {
487         require(share >= 1e15, 'INVALID_ARGUMENT'); // 1000 * rate()
488 
489         collectComp();
490 
491         if (_totalSupply > 0) {
492             (uint256 a, uint256 b) = getDaiBalance();
493             (uint256 c, uint256 d) = getUSDCBalance();
494 
495             dai_in = share.mul(a).divCeil(_totalSupply);
496             dai_out = share.mul(b).div(_totalSupply);
497             usdc_in = share.mul(c).divCeil(_totalSupply.mul(rate()));
498             usdc_out = share.mul(d).div(_totalSupply.mul(rate()));
499             require(dai_in <= tokens[0] && dai_out >= tokens[1] && usdc_in <= tokens[2] && usdc_out >= tokens[3], "SLIPPAGE_DETECTED");
500             
501             _mint(msg.sender, share);
502 
503             if(dai_in > 0)
504                 doTransferIn(Dai, cDai, b, msg.sender, dai_in);
505             if(usdc_in > 0)
506                 doTransferIn(USDC, cUSDC, d.div(rate()), msg.sender, usdc_in);
507             if(dai_out > 0)
508                 doTransferOut(Dai, cDai, a, msg.sender, dai_out);
509             if(usdc_out > 0)
510                 doTransferOut(USDC, cUSDC, c.div(rate()), msg.sender, usdc_out);
511 
512             int256 dai_amount = int256(dai_in).sub(int256(dai_out));
513             int256 usdc_amount = int256(usdc_in).sub(int256(usdc_out));
514 
515             emit AddLiquidity(msg.sender, share, dai_amount, usdc_amount);
516             return (dai_in, dai_out, usdc_in, usdc_out);
517         } else {
518             uint256 dai_amount = share.divCeil(2);
519             uint256 usdc_amount = share.divCeil(rate().mul(2));
520 
521             _mint(msg.sender, share);
522             doTransferIn(Dai, cDai, 0, msg.sender, dai_amount);
523             doTransferIn(USDC, cUSDC, 0, msg.sender, usdc_amount);
524             
525             emit AddLiquidity(msg.sender, share, int256(dai_amount), int256(usdc_amount));
526             return (dai_amount, 0, usdc_amount, 0);
527         }
528     }
529 
530     function removeLiquidity(uint256 share, uint256[4] calldata tokens) external returns (uint256 dai_in, uint256 dai_out, uint256 usdc_in, uint256 usdc_out) {
531         require(share > 0, 'INVALID_ARGUMENT');
532 
533         collectComp();
534 
535         (uint256 a, uint256 b) = getDaiBalance();
536         (uint256 c, uint256 d) = getUSDCBalance();
537 
538         dai_out = share.mul(a).div(_totalSupply);
539         dai_in = share.mul(b).divCeil(_totalSupply);
540         usdc_out = share.mul(c).div(_totalSupply.mul(rate()));
541         usdc_in = share.mul(d).divCeil(_totalSupply.mul(rate()));
542         require(dai_in <= tokens[0] && dai_out >= tokens[1] && usdc_in <= tokens[2] && usdc_out >= tokens[3], "SLIPPAGE_DETECTED");
543 
544         _burn(msg.sender, share);
545 
546         if(dai_in > 0)
547             doTransferIn(Dai, cDai, b, msg.sender, dai_in);
548         if(usdc_in > 0)
549             doTransferIn(USDC, cUSDC, d.div(rate()), msg.sender, usdc_in);
550         if(dai_out > 0)
551             doTransferOut(Dai, cDai, a, msg.sender, dai_out);
552         if(usdc_out > 0)
553             doTransferOut(USDC, cUSDC, c.div(rate()), msg.sender, usdc_out);
554 
555         int256 dai_amount = int256(dai_out).sub(int256(dai_in));
556         int256 usdc_amount = int256(usdc_out).sub(int256(usdc_in));
557 
558         emit RemoveLiquidity(msg.sender, share, dai_amount, usdc_amount);
559 
560         return(dai_in, dai_out, usdc_in, usdc_out);
561     }
562 
563     /***********************************|
564     |           Collect Comp            |
565     |__________________________________*/
566 
567     function collectComp() public {
568         uint256 _comp = Comp.balanceOf(address(this));
569         if(_comp == 0) return;
570 
571         (uint256 a, uint256 b) = getDaiBalance();
572         (uint256 c, uint256 d) = getUSDCBalance();
573 
574         bool isDai = a.add(d) > c.add(b);
575 
576         address[] memory path = new address[](3);
577         path[0] = address(Comp);
578         path[1] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; //weth
579         path[2] = isDai ? address(Dai) : address(USDC);
580         uint256[] memory amounts = uniswap.swapExactTokensForTokens(_comp, 0, path, address(this), now);
581 
582         if(isDai)
583             require(cDai.mint(amounts[2]) == 0, "ctoken.mint failed");
584         else
585             require(cUSDC.mint(amounts[2]) == 0, "ctoken.mint failed");
586 
587     }
588 
589 }