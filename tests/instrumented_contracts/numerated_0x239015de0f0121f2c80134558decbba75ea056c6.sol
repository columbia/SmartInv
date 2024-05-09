1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 
5 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;cdo:;;;::;;:::;::;;:;;:;;;::;:::;:::;:;;:ldc;::;;;::;:;cdl:;;;;;;:::;:;;:;;;::;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
6 // ;;;;;;;;;;;;;;;;;;;;;;;:;;;;;;l00kkoc::::;cdo:::;;;::;;;:;;cc::lkd:::;;;;;;;::;ckOkkkxdc:;::;;:clc:::;;;;;;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
7 // ;;;;;;;;;;;;;;;;;;;;;;;;:ool:;:cccloxddo:;:c:;::;;;::ll:;::odcdK0o:::;;::;;;;:cdkdcccc:;;;;;;cx00dc;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
8 // ;;;;;;;;;;;;;;;;;;;;;;;;cd00l;:::::;cdkdc;;;::;;:;;::ldc;:;;::kKl;:::;;;:;;:;:x0l;:::;:odclxx0Xkl:;;:;;;::;:;cdl;;::;:;::;;::;;::::;;;;;;;;;;;;;;;;;;;
9 // ;;;;;;;;;;;;;;;;;;;;;;;:;;dKOxkOdc:;:;;;;;cdo:;;;:dkl:;;;;;:;:k0l:cc:;:;cdo:;:ldlcc:;;:cdOK0xol:;;:;;;;;:odc:ldl:;;::;;:;:ccc:;;;::;;:;:;;;;;;;;;;;;;;
10 // ;;;;;;;;;;;;;;;;;;;;;;;;;::cccokKOl;;;:::;:c:;:;:ox0KOo:;:;;:oxkddk0d:;;cdl:;;xXX0xdc;;;lKOc:;:::;:;;:;:oxxdxkkxl:;:;:;:cdxkxdc:ll::;::;;;;;;;;;;;;;;;
11 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;::;cdkdc::;;;;:;::;:;cdlcdxdc;;:;lKKxkxOXx::;cdl;cdkxxlcdxxxxxxl;;:;::;;::;;cdxxxl:;lxxl::;;:x0l;cdxkKx::;;;;:;;;;;;;;;;;;;
12 // ;;;;;;;;;;;;;;;;;;;;;;;;;:;;;:o0x;;::;;:;;;::;;:;;;;;;;;;:::oKNKk0Kxc:;;;;::o0x;;;;;coodo:;;;::;;;::;;;;;;;;;:;;:okkc;:cOKl;::cooc:::;::;;;;;;;;;;;;;;
13 // ;;;;;;;;;;;;;;;;;;;;;;;;::;;:x0kddddddddddo:;;;;:::;;;;;:;;dXNkcccloc::cooxkxl::;;:;;:;;;;:;;;;;::;;;;;;;;:;;:;;::oOdox0Kkc;::;;:;;;;;;;;;;;;;;;;;;;;;
14 // ;;;;;;;;;;;;;;;;;;;;;;;::;;:;lxxxxxxxxxxx0Kl;:;;::;;::::;:d0NNx:;;cdl::lxxl::;:::;;;;::;::;;::;;::;:::;;:;;::;;;;:;cdxxxo:;;:;::;;;;;;;;;;;;;;;;;;;;;;
15 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;;;;;;;;;;;;xOl;:;;;;;:::;;,;ck0d::;;;;:c:;;;;;;:;:::;:;cdo:;;;::::::::ccllllll:;;;;::;;;;;;:::;;::;;;;;;;;;;;;;;;;;;;;;;
16 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;::::;;;;;;;;;::c:;:;;;;;::;;,''';:;;::;;;xOl;;;;;;;::;:;;::c:::cccccllllllllllllc:;;;;;;;:;;;:;;::;;:;;;;;;;;;;;;;;;;;;;;;;
17 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,,',,;;;;:;;::x0l;:;;;;;;;;;;;:;::loooloollllllllllc:;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
18 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;,,'',;;;:;;;::;:xOl;:;;;;;;;;:;;::lllllllllllllllllc:;;;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
19 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,,'',;;:;::;;;;;;cc:;:;;;;;;;;;::lllllllllllllllllc::;;;;:::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
20 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::;;::;;;;;;;;;;;,,,'',;;;:;;:;;;;;;::::::;;::;;;::llollllllllllllll::;::;;;:::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
21 // ;;;;;;;;;;;;;;;;;;;;;;;::;;::;;;:;;;::;:;;;;;;,,''',,;;:;;;;;;;;;;;;;;;;:;;::;:::lollllllllllllllc:;;:;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
22 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;;;;;;:;;,,'''',,;:;;;;;;;;;;;;;;;;;:;;::;;coollllllllllllll::;;;;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
23 // ;;;;;;;;;;;;;;;;;;;;;::;codo:lddl:;;::;;;;,,'''',,;;:;;;;;;;;;;;;;;;;;;;;;:::clollllllllllllcc:;;;;;:::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
24 // ;;;;;;;;;;;;;;;;;;;;;;:lk0KOldKKd:ccccc:;,,'',;;;;:;;:;;;;;;;;;;;;;:;;:;;:cllllllllllllllol::;;;;::::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
25 // ;;;;;;;;;;;;;;;;;;:;;:lkKKKOldKKxdk0OOko;'''',;;;;;;;;;;;;;;;;;:;;;;::;:clllllllllllllllllc;:;;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
26 // ;;;;;;;;;;;;;;;;;:;;lx0KKKKOldKKKKKKK0o,',,,;;;:;;;;;;;;;;;;;;;;;;::::clllllllllllllllloo:;;;:;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
27 // ;;;;;;;;;;;;;;;;;:;:dKKKKKK0kOKKKKKKKKOd:ldc;;;:;;;;;;;;;;;;;;;;;;::cllllllllllllllllllol:;;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
28 // ;;;;;;;;;;;;;;;:;;;:dKKKKKKKKKKKKKKKKKK0O0Oc;:;;;;;;;;;::;;;;;::::clllllllllllllllllllol::;;;;;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
29 // ;;;;;;;;;;;;;;;:::;:dKKK0kxxxxk0KKKKKKKK0Oo:;::;;;;;;;;::;;;;::;:lollllllllllllllllllloc:;;;;:;;:;;;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
30 // ;;;;;;;;;;;;;;;;::;:cdOkdlllllodk000Odlllc;;:;;:::;;;:;;;;;;:::cclollllllllllllllllllloc:;;;;:;;;;::;;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
31 // ;;;;;;;;;;;;;;;;:::ccloolllllllloooooc:;;;:;;::;;::cccccccccclooollllllllllllllllllllloc:;;;;;;;::;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
32 // ;;;;;;;;;;;;;;;;;:lllllllllllllllllcc:;;;;::::;:cllooooooooloooooollllllllllllllllllllolccclcccccc:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
33 // ;;;;;;;;;;;;;;;;:cllllllllllllllllc::;;;;;;;;;;cooooooooddoooooodoooooooollllllllllllloooooooooooolc:;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
34 // ;;;;;;;;;;;;;;;;:clllllllllllllllc:;;:;;;;;;;;;:::::::coxxkkkkkxxkkxxxxxxdodddddddddddddooooooooooool:;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
35 // ;;;;;;;;;;;;;;;;:cllllllllllllllc:;:;;;;;;;;;;;:;;::lodxkk0KKK0OO000OOOOkxxxxkxxxxkkxkxxxxxxxoccccclc:;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
36 // ;;;;;;;;:;;;:;;::clllllllllllllc::;;;;;;;;;;;;;;;:ldkkkdddxxk000KKKK0kxxxdddxkO00000000Okkkkko::;;;;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
37 // ;;;;;;;;;:;;;;:ccllllllllllllll::;;;;;;;;;;;;;;;;:okkkxoddc;cxOO00KKK0xl;;okkO0KKKKKKKK0kkkkxol:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
38 // ;;;;;;;;;:;;::clllllllllllllllc:;;;::;;;;;;;;;;:;;coxkxokx. 'OMNOOKKKK0:  lNNNXKKKKKKKKOkkkxc;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
39 // ;;;;;;;;;;::cllllllllllllllllc::;::::;;;;;;;;;;:;;;cddllk0dox0XKOOKKKKKkooOXXKKKKKKKKKKOkkkdc;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
40 // ;;;;;;;;;;:clllllllllllllllllc;:::;;;:::;;;;;;;;::;::::lkKKKKKK0OOKKKKKKKKKKKKKKKKKKKKKK00Odc;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
41 // ;;;;;;;;;;:clllllllllllllllllc:;;;;;;;;;;;;;;;;;::;;:;:lkKKKKKK0OOOO0KKKKKKKKKKKKKKKKKKKKKOdc;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
42 // ;;;;;;;;;;:clllllllllllllllll::;;;;;;;;;;;;;;;;;::;;;;:lx0000000OOOO000000000000KKKKKKKK0Okd:;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
43 // ;;;;;;;;;;:clllllllllllllllc:::;;;;;;;;;;;;;;;;;::clllodk000000OO0000OOOO00000000KKKKK0Okdl:::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
44 // ;;;;;;;;;;:clllllllllllllllc:;:;;;;;;;;;;;;;;;;:;:cdO00OO00OOOOOkOOOOOOOOO000000000000Okdc;;::;;:;;;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
45 // ;;;;;;;;;;;clllllllllllllllc:;:;;;;;;;;;;;;;;;;:;;;:ldOOO0OOOOOOOOOOOO0OkO00000OOkOOOOkdl::::::;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
46 // ;;;;;;;;;;;cllllllllllllllllc::;;;;;;;;;;;;;;;;:;;:;;:lxOOOOOOO00000000000000OkkkO0000kolcllllcc:::;;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
47 // ;;;;;;;;;;;clllllllllllllllllc:;;;;;;;;;;;;;;;;;;;::;;cdO000000000000000000000000000Okdollllllllcc:;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
48 // ;;;;;;;;;;;clllllllllllllllllc:;;::;;;::;;;;;;;;;;::cclxO000000000000000000000000000Oxolllllllllllcc::;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
49 // ;;;;;;;;;;:cllllllllllllllllllcc:;;;;;;:;;;;;::;::cllloxO000000000000000000000000000Oxolllllllllllllc:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
50 // ;;;;;;;;;;::clllllllllllllllllllc:::;;;;;;;;;:::cllllloxO000000000000000000000000000Oxollllllllllllllc::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
51 // ;;;;;;;;;::;::clllllllllllllllllllc:::;;;;;;;::clllllloxO000000000000000000000000000Oxollllllllllllllllc:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
52 // ;;;;;;;;:;;:;;clllllllllllllllllllllcc:::;;;;;;clllllloxO000000000000000000000000000Oxolllllllllllllllllc:;;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
53 // ;;;;;;;;;;;;;:clllllllllllllllllllllllllcccccccclllllloxO000000000000000000000000000Oxollllllllllllllllllcc::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
54 // ;;;;;;;;:;;;;:cclclllllllllllllllllllllllllllllllllllloxO000000000000000000000000000Oxollllllllllllllllllllcc::::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
55 // ;;;;;;;;;;;;;;:::::clllllllllllllllllllllllllllllllllloxO000000000000000000000000Okxxdlllllllllllllllllllllllc:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
56 // ;;;;;;;;;;;;;;;::;:cclllllllllllllllllllllllllllllllllodkO00000000000000000000000Oxollllllllllllllllllllllllllc::;;;;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
57 // ;;;;;;;;;;;;;;;;;:;::ccllllllllllllllllllllllllllllllllodkO0000000000000000000000Oxollllllllllllllllllllllllllllc::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
58 // ;;;;;;;;;;;;;;;;;;:;;::ccllllllllllllllllllllllllllllllldk00000000000000000000000Oxolllllllllllllllllllllllllllllc:;;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
59 // ;;;;;;;;;;;;;;;;:;;:::;:::cclllllllllllllllllllllllllllldkO0000000000000000000000Oxollllllllllllllllllllllllllllllc:;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
60 // ;;;;;;;;;;;;;;;;;;;;;;:;;;;::::::::ccllllllllcc:cllllllldkO0000000000000000000000Oxollllllllllloollllllllllllllllllc:;:::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
61 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:::::::::::::;:clllllldkO000000000000000000000Okdlllllllllllloollllllllllllllllllcc:;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
62 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;;;;:;:clllllldkO00000000000000000000Okdlllllllllllllooolllllllllllllllllllc;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
63 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::;;;:;;;;;:clllllldkO00000000000000000000Okdlllllllllllllloolllllllllllllllllll:::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
64 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;;;;;;;;:clllllloxO000000000000000000000Okdllllllllllllooollllllllllllllllllc:::;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
65 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::;;;;:clllllloxO0000000000000000000000Okdlllllllllloooolllllllllllllllllc::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
66 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::clllllloxO000000000000000000000Okdllllllllllloolllllllllllllllllc::::;;:::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
67 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::;;;:clllllloxO000000000000000000000Oxollllllllllloolllllllllllllllc::::::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
68 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::;;;::cclllllloxO00000000000000000OOOkkxolllllllllllollllllllllllllc::;;;:;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
69 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::;::lllllllloxO000000000000000Okddoooolllllllllllllllllllllllllc::;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
70 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;:clllllllllldxkO00000000000Okdolllllllllllllllllllllllllllllllc;;:;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
71 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:cclllllllllllodkO00000000OOkdllllllllllllllllllllllllllllllllc:;::;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
72 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:::cllllllllllllllloxO0000000Okxolllllllllllllllllllllllllllllllc:;;;;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
73 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:cllllllllllllllllloxO000000Oxolllllllllllllllllllllllllllllllc:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
74 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::clllllllllllllllllloxO00000Oxolllllllllllllllllllllllllllllllc:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
75 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:clllllllllllllllllllodxkOOkkdolllllllllllllllllllllllllllllllc::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
76 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::;;;;:cllllllllllllllllllllllodxxollllllllllllllllllllllllllllllllc:;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
77 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::;:;:cllllllllllllllllllllllllodllllllllllllllllllllllllllllllllc::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
78 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;::lllllllllllllllllllllllllllllllllllllllllllllllllllllllllcc::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
79 // ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:cllllllllllllllllllllllllllllllllllllllllllllllllllllllllc::;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
80 // 
81 // A telegram bot built by @oz_dao.
82 // https://wandbot.app
83 // https://twitter.com/wand_bot
84 //
85 
86 abstract contract Context {
87     function _msgSender() internal view virtual returns (address) {
88         return msg.sender;
89     }
90 }
91 
92 abstract contract Ownable is Context {
93     address private _owner;
94 
95     event OwnershipTransferred(
96         address indexed previousOwner,
97         address indexed newOwner
98     );
99 
100     constructor() {
101         address msgSender = _msgSender();
102         _owner = msgSender;
103         emit OwnershipTransferred(address(0), msgSender);
104     }
105 
106     function owner() public view returns (address) {
107         return _owner;
108     }
109 
110     modifier onlyOwner() {
111         require(_owner == _msgSender(), "Ownable: caller is not the owner");
112         _;
113     }
114 
115     function renounceOwnership() public virtual onlyOwner {
116         emit OwnershipTransferred(_owner, address(0));
117         _owner = address(0);
118     }
119 
120     function transferOwnership(address newOwner) public virtual onlyOwner {
121         require(newOwner != address(0), "Ownable: new owner is the zero address");
122         emit OwnershipTransferred(_owner, newOwner);
123         _owner = newOwner;
124     }
125 }
126 
127 interface IERC20 {
128     function totalSupply() external view returns (uint256);
129 
130     function balanceOf(address account) external view returns (uint256);
131 
132     function transfer(address recipient, uint256 amount) external returns (bool);
133 
134     function allowance(address owner, address spender) external view returns (uint256);
135 
136     function approve(address spender, uint256 amount) external returns (bool);
137 
138     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
139 
140     event Transfer(address indexed from, address indexed to, uint256 value);
141     event Approval(address indexed owner, address indexed spender, uint256 value);
142 }
143 
144 interface IERC20Metadata is IERC20 {
145     function name() external view returns (string memory);
146 
147     function symbol() external view returns (string memory);
148 
149     function decimals() external view returns (uint8);
150 }
151 
152 contract ERC20 is Context, IERC20, IERC20Metadata {
153     mapping(address => uint256) private _balances;
154 
155     mapping(address => mapping(address => uint256)) private _allowances;
156 
157     uint256 private _totalSupply;
158 
159     string private _name;
160     string private _symbol;
161 
162     constructor(string memory name_, string memory symbol_) {
163         _name = name_;
164         _symbol = symbol_;
165     }
166 
167     function name() public view virtual override returns (string memory) {
168         return _name;
169     }
170 
171     function symbol() public view virtual override returns (string memory) {
172         return _symbol;
173     }
174 
175     function decimals() public view virtual override returns (uint8) {
176         return 18;
177     }
178 
179     function totalSupply() public view virtual override returns (uint256) {
180         return _totalSupply;
181     }
182 
183     function balanceOf(address account)
184         public
185         view
186         virtual
187         override
188         returns (uint256)
189     {
190         return _balances[account];
191     }
192 
193     function transfer(address to, uint256 amount)
194         public
195         virtual
196         override
197         returns (bool)
198     {
199         address owner = _msgSender();
200         _transfer(owner, to, amount);
201         return true;
202     }
203 
204     function allowance(address owner, address spender)
205         public
206         view
207         virtual
208         override
209         returns (uint256)
210     {
211         return _allowances[owner][spender];
212     }
213 
214     function approve(address spender, uint256 amount)
215         public
216         virtual
217         override
218         returns (bool)
219     {
220         address owner = _msgSender();
221         _approve(owner, spender, amount);
222         return true;
223     }
224 
225     function transferFrom(
226         address from,
227         address to,
228         uint256 amount
229     ) public virtual override returns (bool) {
230         address spender = _msgSender();
231         _spendAllowance(from, spender, amount);
232         _transfer(from, to, amount);
233         return true;
234     }
235 
236     function increaseAllowance(address spender, uint256 addedValue)
237         public
238         virtual
239         returns (bool)
240     {
241         address owner = _msgSender();
242         _approve(owner, spender, allowance(owner, spender) + addedValue);
243         return true;
244     }
245 
246     function decreaseAllowance(address spender, uint256 subtractedValue)
247         public
248         virtual
249         returns (bool)
250     {
251         address owner = _msgSender();
252         uint256 currentAllowance = allowance(owner, spender);
253         require(
254             currentAllowance >= subtractedValue,
255             "ERC20: decreased allowance below zero"
256         );
257         unchecked {
258             _approve(owner, spender, currentAllowance - subtractedValue);
259         }
260 
261         return true;
262     }
263 
264     function _transfer(
265         address from,
266         address to,
267         uint256 amount
268     ) internal virtual {
269         require(from != address(0));
270         require(to != address(0));
271 
272         uint256 fromBalance = _balances[from];
273         require(fromBalance >= amount);
274         unchecked {
275             _balances[from] = fromBalance - amount;
276             _balances[to] += amount;
277         }
278 
279         emit Transfer(from, to, amount);
280     }
281 
282     function _mint(address to, uint256 amount) internal virtual {
283         _totalSupply += amount;
284 
285         unchecked {
286             _balances[to] += amount;
287         }
288 
289         emit Transfer(address(0), to, amount);
290     }
291 
292     function _burn(address from, uint256 amount) internal virtual {
293         _balances[from] -= amount;
294 
295         unchecked {
296             _totalSupply -= amount;
297         }
298 
299         emit Transfer(from, address(0), amount);
300     }
301 
302     function _approve(
303         address owner,
304         address spender,
305         uint256 amount
306     ) internal virtual {
307         _allowances[owner][spender] = amount;
308         emit Approval(owner, spender, amount);
309     }
310 
311     function _spendAllowance(
312         address owner,
313         address spender,
314         uint256 amount
315     ) internal virtual {
316         uint256 currentAllowance = allowance(owner, spender);
317         if (currentAllowance != type(uint256).max) {
318             require(currentAllowance >= amount);
319             unchecked {
320                 _approve(owner, spender, currentAllowance - amount);
321             }
322         }
323     }
324 }
325 
326 interface IUniswapV2Factory {
327     function createPair(address tokenA, address tokenB)
328         external
329         returns (address pair);
330 }
331 
332 interface IUniswapV2Router02 {
333     function swapExactTokensForETHSupportingFeeOnTransferTokens(
334         uint256 amountIn,
335         uint256 amountOutMin,
336         address[] calldata path,
337         address to,
338         uint256 deadline
339     ) external;
340 
341     function factory() external pure returns (address);
342 
343     function WETH() external pure returns (address);
344 
345     function addLiquidityETH(
346         address token,
347         uint256 amountTokenDesired,
348         uint256 amountTokenMin,
349         uint256 amountETHMin,
350         address to,
351         uint256 deadline
352     )
353     external
354     payable
355     returns (
356         uint256 amountToken,
357         uint256 amountETH,
358         uint256 liquidity
359     );
360 }
361 
362 contract Wand is ERC20, Ownable {
363 
364     IUniswapV2Router02 public immutable uniswapV2Router;
365     address public uniswapV2Pair;
366     address public constant deadAddress = address(0xdead);
367 
368     bool private swapping;
369 
370     address public devWallet;
371     address public liquidityWallet;
372 
373     uint256 public maxTransactionAmount;
374     uint256 public swapTokensAtAmount;
375     uint256 public maxWallet;
376 
377     bool public tradingActive = false;
378     bool public swapEnabled = false;
379 
380     mapping(address => uint256) private _holderLastTransferTimestamp;
381     bool public transferDelayEnabled = true;    
382 
383     uint256 public buyTotalFees;
384     uint256 private buyDevFee;
385     uint256 private buyLiquidityFee;
386 
387     uint256 public sellTotalFees;
388     uint256 private sellDevFee;
389     uint256 private sellLiquidityFee;
390 
391     uint256 private tokensForDev;
392     uint256 private tokensForLiquidity;
393     uint256 private previousFee;
394 
395     mapping(address => bool) private _isExcludedFromFees;
396     mapping(address => bool) private _isExcludedMaxTransactionAmount;
397     mapping(address => bool) private automatedMarketMakerPairs;
398 
399     event SwapAndLiquify(
400         uint256 tokensSwapped,
401         uint256 ethReceived,
402         uint256 tokensIntoLiquidity
403     );
404 
405     constructor() payable ERC20("Wand", "WAND") {
406         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
407         _approve(address(this), address(uniswapV2Router), type(uint256).max);
408 
409         uint256 totalSupply = 100_000_000 ether;
410 
411         maxTransactionAmount = (totalSupply * 10) / 1000;
412         maxWallet = (totalSupply * 10) / 1000;
413         swapTokensAtAmount = (totalSupply * 1) / 1000;
414 
415         buyDevFee = 4;
416         buyLiquidityFee = 0;
417         buyTotalFees = buyDevFee + buyLiquidityFee;
418 
419         sellDevFee = 20;
420         sellLiquidityFee = 0;
421         sellTotalFees = sellDevFee + sellLiquidityFee;
422 
423         previousFee = sellTotalFees;
424 
425         devWallet = _msgSender();
426         liquidityWallet = _msgSender();
427 
428         excludeFromFees(_msgSender(), true);
429         excludeFromFees(address(this), true);
430         excludeFromFees(deadAddress, true);
431         excludeFromFees(devWallet, true);
432         excludeFromFees(liquidityWallet, true);
433 
434         excludeFromMaxTransaction(_msgSender(), true);
435         excludeFromMaxTransaction(address(this), true);
436         excludeFromMaxTransaction(deadAddress, true);
437         excludeFromMaxTransaction(address(uniswapV2Router), true);
438         excludeFromMaxTransaction(devWallet, true);
439         excludeFromMaxTransaction(liquidityWallet, true);
440 
441         _mint(msg.sender, (totalSupply * 100) / 100);
442 
443         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
444             address(this),
445             uniswapV2Router.WETH()
446         );
447         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
448         excludeFromMaxTransaction(address(uniswapV2Pair), true);        
449     }
450 
451     receive() external payable {}
452 
453     function burn(uint256 amount) external {
454         _burn(msg.sender, amount);
455     }
456 
457     function abracadabra() external onlyOwner {
458         require(!tradingActive);
459         tradingActive = true;
460         swapEnabled = true;
461     }
462 
463     function disableTransferDelay() external onlyOwner returns (bool) {
464         transferDelayEnabled = false;
465         return true;
466     }
467 
468     function updateSwapTokensAtAmount(uint256 newAmount)
469         external
470         onlyOwner
471         returns (bool)
472     {
473         require(newAmount >= (totalSupply() * 1) / 100000);
474         require(newAmount <= (totalSupply() * 5) / 1000);
475         swapTokensAtAmount = newAmount;
476         return true;
477     }
478 
479     function updateMaxWalletAndTxnAmount(
480         uint256 newTxnNum,
481         uint256 newMaxWalletNum
482     ) external onlyOwner {
483         require(newTxnNum >= ((totalSupply() * 5) / 1000));
484         require(newMaxWalletNum >= ((totalSupply() * 5) / 1000));
485         maxWallet = newMaxWalletNum;
486         maxTransactionAmount = newTxnNum;
487     }
488 
489     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner
490     {
491         _isExcludedMaxTransactionAmount[updAds] = isEx;
492     }
493 
494     function updateBuyFees(
495         uint256 _devFee,
496         uint256 _liquidityFee
497     ) external onlyOwner {
498         buyDevFee = _devFee;
499         buyLiquidityFee = _liquidityFee;
500         buyTotalFees = buyDevFee + buyLiquidityFee;
501         require(buyTotalFees <= 4, "Buy fees must be less than or equal to 4%");
502     }
503 
504     function updateSellFees(
505         uint256 _devFee,
506         uint256 _liquidityFee
507     ) external onlyOwner {
508         sellDevFee = _devFee;
509         sellLiquidityFee = _liquidityFee;
510         sellTotalFees = sellDevFee + sellLiquidityFee;
511         previousFee = sellTotalFees;
512         require(sellTotalFees <= 20, "Sell fees must be less than or equal to 20%");
513     }
514 
515     function excludeFromFees(address account, bool excluded) public onlyOwner {
516         _isExcludedFromFees[account] = excluded;
517     }
518 
519     function setDevWallet(address account) public onlyOwner {
520         devWallet = account;
521         excludeFromFees(account, true);
522         excludeFromMaxTransaction(devWallet, true);
523     }
524 
525     function withdrawStuckETH() public onlyOwner {
526         bool success;
527         (success, ) = address(msg.sender).call{value: address(this).balance}(
528             ""
529         );
530     }
531 
532     function withdrawStuckTokens(address tkn) public onlyOwner {
533         require(IERC20(tkn).balanceOf(address(this)) > 0);
534         uint256 amount = IERC20(tkn).balanceOf(address(this));
535         IERC20(tkn).transfer(msg.sender, amount);
536     }
537 
538     function _setAutomatedMarketMakerPair(address pair, bool value) private {
539         automatedMarketMakerPairs[pair] = value;
540     }
541 
542     function isExcludedFromFees(address account) public view returns (bool) {
543         return _isExcludedFromFees[account];
544     }
545 
546     function _transfer(
547         address from,
548         address to,
549         uint256 amount
550     ) internal override {
551         require(from != address(0));
552         require(to != address(0));
553 
554         if (amount == 0) {
555             super._transfer(from, to, 0);
556             return;
557         }
558 
559         if (
560             from != owner() &&
561             to != owner() &&
562             to != address(0) &&
563             to != deadAddress &&
564             !swapping
565         ) {
566             if (!tradingActive) {
567                 require(_isExcludedFromFees[from] || _isExcludedFromFees[to]);
568             }
569 
570             if (transferDelayEnabled) {
571                 if (
572                     to != owner() &&
573                     to != address(uniswapV2Router) &&
574                     to != address(uniswapV2Pair)
575                 ) {
576                     require(
577                         _holderLastTransferTimestamp[tx.origin] <
578                             block.number,
579                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
580                     );
581                     _holderLastTransferTimestamp[tx.origin] = block.number;
582                 }
583             }            
584 
585             //when buy
586             if (
587                 automatedMarketMakerPairs[from] &&
588                 !_isExcludedMaxTransactionAmount[to]
589             ) {
590                 require(amount <= maxTransactionAmount);
591                 require(amount + balanceOf(to) <= maxWallet);
592             }
593             //when sell
594             else if (
595                 automatedMarketMakerPairs[to] &&
596                 !_isExcludedMaxTransactionAmount[from]
597             ) {
598                 require(amount <= maxTransactionAmount);
599             } else if (!_isExcludedMaxTransactionAmount[to]) {
600                 require(amount + balanceOf(to) <= maxWallet);
601             }
602         }
603 
604         uint256 contractTokenBalance = balanceOf(address(this));
605 
606         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
607 
608         if (
609             canSwap &&
610             swapEnabled &&
611             !swapping &&
612             !automatedMarketMakerPairs[from] &&
613             !_isExcludedFromFees[from] &&
614             !_isExcludedFromFees[to]
615         ) {
616             swapping = true;
617 
618             swapBack();
619 
620             swapping = false;
621         }
622 
623         bool takeFee = !swapping;
624 
625         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
626             takeFee = false;
627         }
628 
629         uint256 fees = 0;
630 
631         if (takeFee) {
632             // on sell
633             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
634                 fees = amount * sellTotalFees / 100;
635                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
636                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
637             }
638             // on buy
639             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
640                 fees = amount * buyTotalFees / 100;
641                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
642                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
643             }
644 
645             if (fees > 0) {
646                 super._transfer(from, address(this), fees);
647             }
648 
649             amount -= fees;
650         }
651 
652         super._transfer(from, to, amount);
653         sellTotalFees = previousFee;
654     }
655 
656     function swapTokensForEth(uint256 tokenAmount) private {
657         address[] memory path = new address[](2);
658         path[0] = address(this);
659         path[1] = uniswapV2Router.WETH();
660 
661         _approve(address(this), address(uniswapV2Router), tokenAmount);
662 
663         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
664             tokenAmount,
665             0,
666             path,
667             address(this),
668             block.timestamp
669         );
670     }
671 
672     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
673         _approve(address(this), address(uniswapV2Router), tokenAmount);
674 
675         uniswapV2Router.addLiquidityETH{value: ethAmount}(
676             address(this),
677             tokenAmount,
678             0,
679             0,
680             liquidityWallet,
681             block.timestamp
682         );
683     }
684 
685     function swapBack() private {
686         uint256 contractBalance = balanceOf(address(this));
687         uint256 totalTokensToSwap = tokensForLiquidity +
688             tokensForDev;
689         bool success;
690 
691         if (contractBalance == 0 || totalTokensToSwap == 0) {
692             return;
693         }
694 
695         if (contractBalance > swapTokensAtAmount * 20) {
696             contractBalance = swapTokensAtAmount * 20;
697         }
698 
699         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
700             totalTokensToSwap /
701             2;
702         uint256 amountToSwapForETH = contractBalance - liquidityTokens;
703 
704         uint256 initialETHBalance = address(this).balance;
705 
706         swapTokensForEth(amountToSwapForETH);
707 
708         uint256 ethBalance = address(this).balance - initialETHBalance;
709 
710         uint256 ethForDev = ethBalance * tokensForDev / totalTokensToSwap;
711 
712         uint256 ethForLiquidity = ethBalance - ethForDev;
713 
714         tokensForLiquidity = 0;
715         tokensForDev = 0;
716 
717         if (liquidityTokens > 0 && ethForLiquidity > 0) {
718             addLiquidity(liquidityTokens, ethForLiquidity);
719             emit SwapAndLiquify(
720                 amountToSwapForETH,
721                 ethForLiquidity,
722                 tokensForLiquidity
723             );
724         }
725 
726         (success, ) = address(devWallet).call{
727             value: address(this).balance
728         }("");
729     }
730 }