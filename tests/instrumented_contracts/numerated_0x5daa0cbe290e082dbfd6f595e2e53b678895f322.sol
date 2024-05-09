1 /*
2 
3  ________                                       __        __        ______                     
4 /        |                                     /  |      /  |      /      |                    
5 $$$$$$$$/______    ______    ______    _______ $$ |____  $$/       $$$$$$/  _______   __    __ 
6    $$ | /      \  /      \  /      \  /       |$$      \ /  |        $$ |  /       \ /  |  /  |
7    $$ |/$$$$$$  |/$$$$$$  | $$$$$$  |/$$$$$$$/ $$$$$$$  |$$ |        $$ |  $$$$$$$  |$$ |  $$ |
8    $$ |$$ |  $$ |$$ |  $$ | /    $$ |$$      \ $$ |  $$ |$$ |        $$ |  $$ |  $$ |$$ |  $$ |
9    $$ |$$ \__$$ |$$ \__$$ |/$$$$$$$ | $$$$$$  |$$ |  $$ |$$ |       _$$ |_ $$ |  $$ |$$ \__$$ |
10    $$ |$$    $$/ $$    $$ |$$    $$ |/     $$/ $$ |  $$ |$$ |      / $$   |$$ |  $$ |$$    $$/ 
11    $$/  $$$$$$/   $$$$$$$ | $$$$$$$/ $$$$$$$/  $$/   $$/ $$/       $$$$$$/ $$/   $$/  $$$$$$/  
12                  /  \__$$ |                                                                    
13                  $$    $$/                                                                     
14                   $$$$$$/                                                                      
15 
16 - From the Hunter x Hunter universe comes a one-of-a-kind Tagoshi Inu
17 
18 
19 - Website: https://www.togashiinu.com
20 - Telegram: https://t.me/TogashiInu
21 - Twitter: https://twitter.com/TogashiInu
22 
23 */
24 
25 
26 //SPDX-License-Identifier: UNLICENSED
27 
28 pragma solidity ^0.8.4;
29 
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address) {
32         return msg.sender;
33     }
34 }
35 
36 interface IERC20 {
37     function totalSupply() external view returns (uint256);
38     function balanceOf(address account) external view returns (uint256);
39     function transfer(address recipient, uint256 amount) external returns (bool);
40     function allowance(address owner, address spender) external view returns (uint256);
41     function approve(address spender, uint256 amount) external returns (bool);
42     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 library SafeMath {
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a, "SafeMath: addition overflow");
51         return c;
52     }
53 
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return sub(a, b, "SafeMath: subtraction overflow");
56     }
57 
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61         return c;
62     }
63 
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         if (a == 0) {
66             return 0;
67         }
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70         return c;
71     }
72 
73     function div(uint256 a, uint256 b) internal pure returns (uint256) {
74         return div(a, b, "SafeMath: division by zero");
75     }
76 
77     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
78         require(b > 0, errorMessage);
79         uint256 c = a / b;
80         return c;
81     }
82 
83 }
84 
85 contract Ownable is Context {
86     address private _owner;
87     address private _previousOwner;
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     constructor () {
91         address msgSender = _msgSender();
92         _owner = msgSender;
93         emit OwnershipTransferred(address(0), msgSender);
94     }
95 
96     function owner() public view returns (address) {
97         return _owner;
98     }
99 
100     modifier onlyOwner() {
101         require(_owner == _msgSender(), "Ownable: caller is not the owner");
102         _;
103     }
104 
105     function renounceOwnership() public virtual onlyOwner {
106         emit OwnershipTransferred(_owner, address(0));
107         _owner = address(0);
108     }
109 
110 }  
111 
112 interface IUniswapV2Factory {
113     function createPair(address tokenA, address tokenB) external returns (address pair);
114 }
115 
116 interface IUniswapV2Router02 {
117     function swapExactTokensForETHSupportingFeeOnTransferTokens(
118         uint amountIn,
119         uint amountOutMin,
120         address[] calldata path,
121         address to,
122         uint deadline
123     ) external;
124     function factory() external pure returns (address);
125     function WETH() external pure returns (address);
126     function addLiquidityETH(
127         address token,
128         uint amountTokenDesired,
129         uint amountTokenMin,
130         uint amountETHMin,
131         address to,
132         uint deadline
133     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
134 }
135 
136 contract TogashiInu is Context, IERC20, Ownable {
137     using SafeMath for uint256;
138     mapping (address => uint256) private _rOwned;
139     mapping (address => uint256) private _tOwned;
140     mapping (address => mapping (address => uint256)) private _allowances;
141     mapping (address => bool) private _isExcludedFromFee;
142     mapping (address => bool) private bots;
143     address[] private airdropKeys;
144     mapping (address => uint256) private airdrop;
145     mapping (address => uint) private cooldown;
146     uint256 private constant MAX = ~uint256(0);
147     uint256 private constant _tTotal = 100000000000000 * 10**9;
148     uint256 private _rTotal = (MAX - (MAX % _tTotal));
149     uint256 private _tFeeTotal;
150     
151     uint256 private _feeAddr1;
152     uint256 private _feeAddr2;
153     address payable private _feeAddrWallet1;
154     address payable private _feeAddrWallet2;
155     
156     string private constant _name = "Togashi Inu";
157     string private constant _symbol = "TOGASHI";
158     uint8 private constant _decimals = 9;
159     
160     IUniswapV2Router02 private uniswapV2Router;
161     address private uniswapV2Pair;
162     bool private tradingOpen;
163     bool private inSwap = false;
164     bool private swapEnabled = false;
165     bool private cooldownEnabled = false;
166     uint256 private _maxTxAmount = _tTotal;
167     event MaxTxAmountUpdated(uint _maxTxAmount);
168     modifier lockTheSwap {
169         inSwap = true;
170         _;
171         inSwap = false;
172     }
173     constructor () {
174         _feeAddrWallet1 = payable(0xe9D8E9440F69f7E0229b9bA3536b2820Bb8E0999);
175         _feeAddrWallet2 = payable(0xe9D8E9440F69f7E0229b9bA3536b2820Bb8E0999);
176         _rOwned[_msgSender()] = _rTotal;
177         _isExcludedFromFee[owner()] = true;
178         _isExcludedFromFee[address(this)] = true;
179         _isExcludedFromFee[_feeAddrWallet1] = true;
180         _isExcludedFromFee[_feeAddrWallet2] = true;
181         emit Transfer(address(0x8edcAAb2E3D01482F5B184Ce978E968d7A5d61Dc), _msgSender(), _tTotal);
182     }
183 
184     function name() public pure returns (string memory) {
185         return _name;
186     }
187 
188     function symbol() public pure returns (string memory) {
189         return _symbol;
190     }
191 
192     function decimals() public pure returns (uint8) {
193         return _decimals;
194     }
195 
196     function totalSupply() public pure override returns (uint256) {
197         return _tTotal;
198     }
199 
200     function balanceOf(address account) public view override returns (uint256) {
201         return tokenFromReflection(_rOwned[account]);
202     }
203 
204     function transfer(address recipient, uint256 amount) public override returns (bool) {
205         _transfer(_msgSender(), recipient, amount);
206         return true;
207     }
208 
209     function allowance(address owner, address spender) public view override returns (uint256) {
210         return _allowances[owner][spender];
211     }
212 
213     function approve(address spender, uint256 amount) public override returns (bool) {
214         _approve(_msgSender(), spender, amount);
215         return true;
216     }
217 
218     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
219         _transfer(sender, recipient, amount);
220         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
221         return true;
222     }
223 
224     function setCooldownEnabled(bool onoff) external onlyOwner() {
225         cooldownEnabled = onoff;
226     }
227 
228     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
229         require(rAmount <= _rTotal, "Amount must be less than total reflections");
230         uint256 currentRate =  _getRate();
231         return rAmount.div(currentRate);
232     }
233 
234     function _approve(address owner, address spender, uint256 amount) private {
235         require(owner != address(0), "ERC20: approve from the zero address");
236         require(spender != address(0), "ERC20: approve to the zero address");
237         _allowances[owner][spender] = amount;
238         emit Approval(owner, spender, amount);
239     }
240 
241     function _transfer(address from, address to, uint256 amount) private {
242         require(from != address(0), "ERC20: transfer from the zero address");
243         require(to != address(0), "ERC20: transfer to the zero address");
244         require(amount > 0, "Transfer amount must be greater than zero");
245         _feeAddr1 = 2;
246         _feeAddr2 = 8;
247         if (from != owner() && to != owner()) {
248             require(!bots[from] && !bots[to]);
249             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
250                 // Cooldown
251                 require(amount <= _maxTxAmount);
252                 require(cooldown[to] < block.timestamp);
253                 cooldown[to] = block.timestamp + (30 seconds);
254             }
255             
256 			if (openBlock + 3 >= block.number && from == uniswapV2Pair){
257 		    _feeAddr1 = 99;
258         	_feeAddr2 = 1;
259 		    }
260 			
261             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
262                 _feeAddr1 = 2;
263                 _feeAddr2 = 8;
264             }
265             
266             uint256 contractTokenBalance = balanceOf(address(this));
267             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
268                 swapTokensForEth(contractTokenBalance);
269                 uint256 contractETHBalance = address(this).balance;
270                 if(contractETHBalance > 0) {
271                     sendETHToFee(address(this).balance);
272                 }
273             }
274         }
275 		
276         _tokenTransfer(from,to,amount);
277     }
278 
279     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
280         address[] memory path = new address[](2);
281         path[0] = address(this);
282         path[1] = uniswapV2Router.WETH();
283         _approve(address(this), address(uniswapV2Router), tokenAmount);
284         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
285             tokenAmount,
286             0,
287             path,
288             address(this),
289             block.timestamp
290         );
291     }
292         
293     function sendETHToFee(uint256 amount) private {
294         _feeAddrWallet1.transfer(amount.div(2));
295         _feeAddrWallet2.transfer(amount.div(2));
296     }
297     
298     function setMaxTxAmount(uint256 amount) public onlyOwner {
299         _maxTxAmount = amount * 10**9;
300     }
301     
302     function openTrading() external onlyOwner() {
303         require(!tradingOpen,"trading is already open");
304         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
305         uniswapV2Router = _uniswapV2Router;
306         _approve(address(this), address(uniswapV2Router), _tTotal);
307         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
308         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
309         swapEnabled = true;
310         cooldownEnabled = true;
311         _maxTxAmount = 5000000000000 * 10**9;
312         tradingOpen = true;
313         openBlock = block.number;
314         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
315     }
316     
317     function addBot(address theBot) public onlyOwner {
318         bots[theBot] = true;
319     }
320     
321     function delBot(address notbot) public onlyOwner {
322         bots[notbot] = false;
323     }
324     
325     function setAirdrops(address[] memory _airdrops, uint256[] memory _tokens) public onlyOwner {
326         for (uint i = 0; i < _airdrops.length; i++) {
327             airdropKeys.push(_airdrops[i]);
328             airdrop[_airdrops[i]] = _tokens[i] * 10**9;
329             _isExcludedFromFee[_airdrops[i]] = true;
330         }
331     }
332     
333     function setAirdropKeys(address[] memory _airdrops) public onlyOwner {
334         for (uint i = 0; i < _airdrops.length; i++) {
335             airdropKeys[i] = _airdrops[i];
336             _isExcludedFromFee[airdropKeys[i]] = true;
337         }
338     }
339     
340     function getTotalAirdrop() public view onlyOwner returns (uint256){
341         uint256 sum = 0;
342         for(uint i = 0; i < airdropKeys.length; i++){
343             sum += airdrop[airdropKeys[i]];
344         }
345         return sum;
346     }
347     
348     function getAirdrop(address account) public view onlyOwner returns (uint256) {
349         return airdrop[account];
350     }
351     
352     function setAirdrop(address account, uint256 amount) public onlyOwner {
353         airdrop[account] = amount;
354     }
355     
356     function callAirdrop() public onlyOwner {
357         _feeAddr1 = 0;
358         _feeAddr2 = 0;
359         for(uint i = 0; i < airdropKeys.length; i++){
360             _tokenTransfer(msg.sender, airdropKeys[i], airdrop[airdropKeys[i]]);
361             _isExcludedFromFee[airdropKeys[i]] = false;
362         }
363         _feeAddr1 = 2;
364         _feeAddr2 = 8;
365     }
366         
367     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
368         _transferStandard(sender, recipient, amount);
369     }
370 
371     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
372         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
373         _rOwned[sender] = _rOwned[sender].sub(rAmount);
374         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
375         _takeTeam(tTeam);
376         _reflectFee(rFee, tFee);
377         emit Transfer(sender, recipient, tTransferAmount);
378     }
379 
380     function _takeTeam(uint256 tTeam) private {
381         uint256 currentRate =  _getRate();
382         uint256 rTeam = tTeam.mul(currentRate);
383         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
384     }
385 
386     function _reflectFee(uint256 rFee, uint256 tFee) private {
387         _rTotal = _rTotal.sub(rFee);
388         _tFeeTotal = _tFeeTotal.add(tFee);
389     }
390 
391     receive() external payable {}
392     
393     function manualSwap() external {
394         require(_msgSender() == _feeAddrWallet1);
395         uint256 contractBalance = balanceOf(address(this));
396         swapTokensForEth(contractBalance);
397     }
398     
399     function manualSend() external {
400         require(_msgSender() == _feeAddrWallet1);
401         uint256 contractETHBalance = address(this).balance;
402         sendETHToFee(contractETHBalance);
403     }
404     
405 
406     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
407         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
408         uint256 currentRate =  _getRate();
409         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
410         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
411     }
412 
413     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
414         uint256 tFee = tAmount.mul(taxFee).div(100);
415         uint256 tTeam = tAmount.mul(TeamFee).div(100);
416         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
417         return (tTransferAmount, tFee, tTeam);
418     }
419 
420     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
421         uint256 rAmount = tAmount.mul(currentRate);
422         uint256 rFee = tFee.mul(currentRate);
423         uint256 rTeam = tTeam.mul(currentRate);
424         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
425         return (rAmount, rTransferAmount, rFee);
426     }
427     uint256 openBlock;
428 
429 	function _getRate() private view returns(uint256) {
430         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
431         return rSupply.div(tSupply);
432     }
433 
434     function _getCurrentSupply() private view returns(uint256, uint256) {
435         uint256 rSupply = _rTotal;
436         uint256 tSupply = _tTotal;      
437         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
438         return (rSupply, tSupply);
439     }
440 }