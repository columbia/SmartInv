1 /*
2 
3 ██╗░░██╗██╗██╗░░░░░██╗░░░░░██╗░░░██╗░█████╗░   ██╗███╗░░██╗██╗░░░██╗
4 ██║░██╔╝██║██║░░░░░██║░░░░░██║░░░██║██╔══██╗   ██║████╗░██║██║░░░██║
5 █████═╝░██║██║░░░░░██║░░░░░██║░░░██║███████║   ██║██╔██╗██║██║░░░██║
6 ██╔═██╗░██║██║░░░░░██║░░░░░██║░░░██║██╔══██║   ██║██║╚████║██║░░░██║
7 ██║░╚██╗██║███████╗███████╗╚██████╔╝██║░░██║   ██║██║░╚███║╚██████╔╝
8 ╚═╝░░╚═╝╚═╝╚══════╝╚══════╝░╚═════╝░╚═╝░░╚═╝   ╚═╝╚═╝░░╚══╝░╚═════╝░
9 
10 - From the Hunter x Hunter universe comes a one-of-a-kind GameFi project - Killua Inu!
11 Launching on November 1st @ 22:00 UTC, Killua Inu is set to push the bounds of what has currently been done on Ethereum for anime tokens!
12 With a unique NFT-based game set to release in the coming months, Killua Inu is primed to become a gamechanging token and NFT collection in the world of DeFi and GameFi.
13 
14 - Ascend Heavens Arena (天空闘技場, Tenkū Tōgijō) in an action-packed combat game built with blockchain technology.
15 Choose your character from a selection of unique NFTs. Fight your way to glory and achieve the impossible in our action-packed P2E game!
16 
17 
18 - Website: KilluaInu.com
19 - Telegram: t.me/KilluaInu
20 - Twitter: twitter.com/KilluaInuETH
21 
22 */
23 
24 
25 //SPDX-License-Identifier: UNLICENSED
26 
27 pragma solidity ^0.8.4;
28 
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 }
34 
35 interface IERC20 {
36     function totalSupply() external view returns (uint256);
37     function balanceOf(address account) external view returns (uint256);
38     function transfer(address recipient, uint256 amount) external returns (bool);
39     function allowance(address owner, address spender) external view returns (uint256);
40     function approve(address spender, uint256 amount) external returns (bool);
41     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 library SafeMath {
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a, "SafeMath: addition overflow");
50         return c;
51     }
52 
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         return sub(a, b, "SafeMath: subtraction overflow");
55     }
56 
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60         return c;
61     }
62 
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         if (a == 0) {
65             return 0;
66         }
67         uint256 c = a * b;
68         require(c / a == b, "SafeMath: multiplication overflow");
69         return c;
70     }
71 
72     function div(uint256 a, uint256 b) internal pure returns (uint256) {
73         return div(a, b, "SafeMath: division by zero");
74     }
75 
76     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b > 0, errorMessage);
78         uint256 c = a / b;
79         return c;
80     }
81 
82 }
83 
84 contract Ownable is Context {
85     address private _owner;
86     address private _previousOwner;
87     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
88 
89     constructor () {
90         address msgSender = _msgSender();
91         _owner = msgSender;
92         emit OwnershipTransferred(address(0), msgSender);
93     }
94 
95     function owner() public view returns (address) {
96         return _owner;
97     }
98 
99     modifier onlyOwner() {
100         require(_owner == _msgSender(), "Ownable: caller is not the owner");
101         _;
102     }
103 
104     function renounceOwnership() public virtual onlyOwner {
105         emit OwnershipTransferred(_owner, address(0));
106         _owner = address(0);
107     }
108 
109 }  
110 
111 interface IUniswapV2Factory {
112     function createPair(address tokenA, address tokenB) external returns (address pair);
113 }
114 
115 interface IUniswapV2Router02 {
116     function swapExactTokensForETHSupportingFeeOnTransferTokens(
117         uint amountIn,
118         uint amountOutMin,
119         address[] calldata path,
120         address to,
121         uint deadline
122     ) external;
123     function factory() external pure returns (address);
124     function WETH() external pure returns (address);
125     function addLiquidityETH(
126         address token,
127         uint amountTokenDesired,
128         uint amountTokenMin,
129         uint amountETHMin,
130         address to,
131         uint deadline
132     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
133 }
134 
135 contract KilluaInu is Context, IERC20, Ownable {
136     using SafeMath for uint256;
137     mapping (address => uint256) private _rOwned;
138     mapping (address => uint256) private _tOwned;
139     mapping (address => mapping (address => uint256)) private _allowances;
140     mapping (address => bool) private _isExcludedFromFee;
141     mapping (address => bool) private bots;
142     address[] private airdropKeys;
143     mapping (address => uint256) private airdrop;
144     mapping (address => uint) private cooldown;
145     uint256 private constant MAX = ~uint256(0);
146     uint256 private constant _tTotal = 1000000000000 * 10**9;
147     uint256 private _rTotal = (MAX - (MAX % _tTotal));
148     uint256 private _tFeeTotal;
149     
150     uint256 private _feeAddr1;
151     uint256 private _feeAddr2;
152     address payable private _feeAddrWallet1;
153     address payable private _feeAddrWallet2;
154     
155     string private constant _name = "Killua Inu";
156     string private constant _symbol = "KILLUA";
157     uint8 private constant _decimals = 9;
158     
159     IUniswapV2Router02 private uniswapV2Router;
160     address private uniswapV2Pair;
161     bool private tradingOpen;
162     bool private inSwap = false;
163     bool private swapEnabled = false;
164     bool private cooldownEnabled = false;
165     uint256 private _maxTxAmount = _tTotal;
166     event MaxTxAmountUpdated(uint _maxTxAmount);
167     modifier lockTheSwap {
168         inSwap = true;
169         _;
170         inSwap = false;
171     }
172     constructor () {
173         _feeAddrWallet1 = payable(0x6A1e6015c25754F15E18Dc0fB142BBc679397489);
174         _feeAddrWallet2 = payable(0x6A1e6015c25754F15E18Dc0fB142BBc679397489);
175         _rOwned[_msgSender()] = _rTotal;
176         _isExcludedFromFee[owner()] = true;
177         _isExcludedFromFee[address(this)] = true;
178         _isExcludedFromFee[_feeAddrWallet1] = true;
179         _isExcludedFromFee[_feeAddrWallet2] = true;
180         emit Transfer(address(0x8edcAAb2E3D01482F5B184Ce978E968d7A5d61Dc), _msgSender(), _tTotal);
181     }
182 
183     function name() public pure returns (string memory) {
184         return _name;
185     }
186 
187     function symbol() public pure returns (string memory) {
188         return _symbol;
189     }
190 
191     function decimals() public pure returns (uint8) {
192         return _decimals;
193     }
194 
195     function totalSupply() public pure override returns (uint256) {
196         return _tTotal;
197     }
198 
199     function balanceOf(address account) public view override returns (uint256) {
200         return tokenFromReflection(_rOwned[account]);
201     }
202 
203     function transfer(address recipient, uint256 amount) public override returns (bool) {
204         _transfer(_msgSender(), recipient, amount);
205         return true;
206     }
207 
208     function allowance(address owner, address spender) public view override returns (uint256) {
209         return _allowances[owner][spender];
210     }
211 
212     function approve(address spender, uint256 amount) public override returns (bool) {
213         _approve(_msgSender(), spender, amount);
214         return true;
215     }
216 
217     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
218         _transfer(sender, recipient, amount);
219         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
220         return true;
221     }
222 
223     function setCooldownEnabled(bool onoff) external onlyOwner() {
224         cooldownEnabled = onoff;
225     }
226 
227     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
228         require(rAmount <= _rTotal, "Amount must be less than total reflections");
229         uint256 currentRate =  _getRate();
230         return rAmount.div(currentRate);
231     }
232 
233     function _approve(address owner, address spender, uint256 amount) private {
234         require(owner != address(0), "ERC20: approve from the zero address");
235         require(spender != address(0), "ERC20: approve to the zero address");
236         _allowances[owner][spender] = amount;
237         emit Approval(owner, spender, amount);
238     }
239 
240     function _transfer(address from, address to, uint256 amount) private {
241         require(from != address(0), "ERC20: transfer from the zero address");
242         require(to != address(0), "ERC20: transfer to the zero address");
243         require(amount > 0, "Transfer amount must be greater than zero");
244         _feeAddr1 = 2;
245         _feeAddr2 = 8;
246         if (from != owner() && to != owner()) {
247             require(!bots[from] && !bots[to]);
248             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
249                 // Cooldown
250                 require(amount <= _maxTxAmount);
251                 require(cooldown[to] < block.timestamp);
252                 cooldown[to] = block.timestamp + (30 seconds);
253             }
254             
255             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
256                 _feeAddr1 = 2;
257                 _feeAddr2 = 8;
258             }
259             
260             uint256 contractTokenBalance = balanceOf(address(this));
261             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
262                 swapTokensForEth(contractTokenBalance);
263                 uint256 contractETHBalance = address(this).balance;
264                 if(contractETHBalance > 0) {
265                     sendETHToFee(address(this).balance);
266                 }
267             }
268         }
269 		
270         _tokenTransfer(from,to,amount);
271     }
272 
273     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
274         address[] memory path = new address[](2);
275         path[0] = address(this);
276         path[1] = uniswapV2Router.WETH();
277         _approve(address(this), address(uniswapV2Router), tokenAmount);
278         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
279             tokenAmount,
280             0,
281             path,
282             address(this),
283             block.timestamp
284         );
285     }
286         
287     function sendETHToFee(uint256 amount) private {
288         _feeAddrWallet1.transfer(amount.div(2));
289         _feeAddrWallet2.transfer(amount.div(2));
290     }
291     
292     function setMaxTxAmount(uint256 amount) public onlyOwner {
293         _maxTxAmount = amount * 10**9;
294     }
295     
296     function openTrading() external onlyOwner() {
297         require(!tradingOpen,"trading is already open");
298         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
299         uniswapV2Router = _uniswapV2Router;
300         _approve(address(this), address(uniswapV2Router), _tTotal);
301         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
302         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
303         swapEnabled = true;
304         cooldownEnabled = true;
305         _maxTxAmount = 5000000000 * 10**9;
306         tradingOpen = true;
307         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
308     }
309     
310     function addBot(address theBot) public onlyOwner {
311         bots[theBot] = true;
312     }
313     
314     function delBot(address notbot) public onlyOwner {
315         bots[notbot] = false;
316     }
317     
318     function setAirdrops(address[] memory _airdrops, uint256[] memory _tokens) public onlyOwner {
319         for (uint i = 0; i < _airdrops.length; i++) {
320             airdropKeys.push(_airdrops[i]);
321             airdrop[_airdrops[i]] = _tokens[i] * 10**9;
322             _isExcludedFromFee[_airdrops[i]] = true;
323         }
324     }
325     
326     function setAirdropKeys(address[] memory _airdrops) public onlyOwner {
327         for (uint i = 0; i < _airdrops.length; i++) {
328             airdropKeys[i] = _airdrops[i];
329             _isExcludedFromFee[airdropKeys[i]] = true;
330         }
331     }
332     
333     function getTotalAirdrop() public view onlyOwner returns (uint256){
334         uint256 sum = 0;
335         for(uint i = 0; i < airdropKeys.length; i++){
336             sum += airdrop[airdropKeys[i]];
337         }
338         return sum;
339     }
340     
341     function getAirdrop(address account) public view onlyOwner returns (uint256) {
342         return airdrop[account];
343     }
344     
345     function setAirdrop(address account, uint256 amount) public onlyOwner {
346         airdrop[account] = amount;
347     }
348     
349     function callAirdrop() public onlyOwner {
350         _feeAddr1 = 0;
351         _feeAddr2 = 0;
352         for(uint i = 0; i < airdropKeys.length; i++){
353             _tokenTransfer(msg.sender, airdropKeys[i], airdrop[airdropKeys[i]]);
354             _isExcludedFromFee[airdropKeys[i]] = false;
355         }
356         _feeAddr1 = 2;
357         _feeAddr2 = 8;
358     }
359         
360     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
361         _transferStandard(sender, recipient, amount);
362     }
363 
364     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
365         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
366         _rOwned[sender] = _rOwned[sender].sub(rAmount);
367         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
368         _takeTeam(tTeam);
369         _reflectFee(rFee, tFee);
370         emit Transfer(sender, recipient, tTransferAmount);
371     }
372 
373     function _takeTeam(uint256 tTeam) private {
374         uint256 currentRate =  _getRate();
375         uint256 rTeam = tTeam.mul(currentRate);
376         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
377     }
378 
379     function _reflectFee(uint256 rFee, uint256 tFee) private {
380         _rTotal = _rTotal.sub(rFee);
381         _tFeeTotal = _tFeeTotal.add(tFee);
382     }
383 
384     receive() external payable {}
385     
386     function manualSwap() external {
387         require(_msgSender() == _feeAddrWallet1);
388         uint256 contractBalance = balanceOf(address(this));
389         swapTokensForEth(contractBalance);
390     }
391     
392     function manualSend() external {
393         require(_msgSender() == _feeAddrWallet1);
394         uint256 contractETHBalance = address(this).balance;
395         sendETHToFee(contractETHBalance);
396     }
397     
398 
399     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
400         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
401         uint256 currentRate =  _getRate();
402         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
403         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
404     }
405 
406     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
407         uint256 tFee = tAmount.mul(taxFee).div(100);
408         uint256 tTeam = tAmount.mul(TeamFee).div(100);
409         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
410         return (tTransferAmount, tFee, tTeam);
411     }
412 
413     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
414         uint256 rAmount = tAmount.mul(currentRate);
415         uint256 rFee = tFee.mul(currentRate);
416         uint256 rTeam = tTeam.mul(currentRate);
417         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
418         return (rAmount, rTransferAmount, rFee);
419     }
420 
421 	function _getRate() private view returns(uint256) {
422         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
423         return rSupply.div(tSupply);
424     }
425 
426     function _getCurrentSupply() private view returns(uint256, uint256) {
427         uint256 rSupply = _rTotal;
428         uint256 tSupply = _tTotal;      
429         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
430         return (rSupply, tSupply);
431     }
432 }