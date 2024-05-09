1 /**
2  //SPDX-License-Identifier: UNLICENSED
3  
4  𝐆𝐄𝐍𝐆𝐀𝐑 𝐓𝐎𝐊𝐄𝐍
5  
6   Telegram: https://t.me/GengarToken
7   Twitter: https://twitter.com/GengarTokenEth
8   Website: gengartoken.io
9   
10   
11 ░██████╗░███████╗███╗░░██╗░██████╗░░█████╗░██████╗░ ████████╗░█████╗░██╗░░██╗███████╗███╗░░██╗
12 ██╔════╝░██╔════╝████╗░██║██╔════╝░██╔══██╗██╔══██╗ ╚══██╔══╝██╔══██╗██║░██╔╝██╔════╝████╗░██║
13 ██║░░██╗░█████╗░░██╔██╗██║██║░░██╗░███████║██████╔╝ ░░░██║░░░██║░░██║█████═╝░█████╗░░██╔██╗██║
14 ██║░░╚██╗██╔══╝░░██║╚████║██║░░╚██╗██╔══██║██╔══██╗ ░░░██║░░░██║░░██║██╔═██╗░██╔══╝░░██║╚████║
15 ╚██████╔╝███████╗██║░╚███║╚██████╔╝██║░░██║██║░░██║ ░░░██║░░░╚█████╔╝██║░╚██╗███████╗██║░╚███║
16 ░╚═════╝░╚══════╝╚═╝░░╚══╝░╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝ ░░░╚═╝░░░░╚════╝░╚═╝░░╚═╝╚══════╝╚═╝░░╚══╝
17                   |`._         |\
18                  `   `.  .    | `.    |`.
19                   .    `.|`-. |   `-..'  \           _,.-'
20                   '      `-. `.           \ /|   _,-'   /
21               .--..'        `._`           ` |.-'      /
22                \   |                                  /
23             ,..'   '                                 /
24             `.                                      /
25             _`.---                                 /
26         _,-'               `.                 ,-  /"-._
27       ,"                   | `.             ,'|   `    `.
28     .'                     |   `.         .'  |    .     `.
29   ,'                       '   ()`.     ,'()  '    |       `.
30 '-.                    |`.  `.....-'    -----' _   |         .
31  / ,   ________..'     '  `-._              _.'/   |         :
32  ` '-"" _,.--"'         \   | `"+--......-+' //   j `"--.. , '
33     `.'"    .'           `. |   |     |   / //    .       ` '
34       `.   /               `'   |    j   /,.'     '
35         \ /                  `-.|_   |_.-'       /\
36          /                        `""          .'  \
37         j                                           .
38         |                                 _,        |
39         |             ,^._            _.-"          '
40         |          _.'    `'""`----`"'   `._       '
41         j__     _,'                         `-.'-."`
42           ',-.,' 
43 */
44 
45 pragma solidity ^0.8.4;
46 
47 abstract contract Context {
48     function _msgSender() internal view virtual returns (address) {
49         return msg.sender;
50     }
51 }
52 
53 interface IERC20 {
54     function totalSupply() external view returns (uint256);
55     function balanceOf(address account) external view returns (uint256);
56     function transfer(address recipient, uint256 amount) external returns (bool);
57     function allowance(address owner, address spender) external view returns (uint256);
58     function approve(address spender, uint256 amount) external returns (bool);
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 library SafeMath {
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a, "SafeMath: addition overflow");
68         return c;
69     }
70 
71     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
72         return sub(a, b, "SafeMath: subtraction overflow");
73     }
74 
75     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b <= a, errorMessage);
77         uint256 c = a - b;
78         return c;
79     }
80 
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         if (a == 0) {
83             return 0;
84         }
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87         return c;
88     }
89 
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         return div(a, b, "SafeMath: division by zero");
92     }
93 
94     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
95         require(b > 0, errorMessage);
96         uint256 c = a / b;
97         return c;
98     }
99 
100 }
101 
102 contract Ownable is Context {
103     address private _owner;
104     address private _previousOwner;
105     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
106 
107     constructor () {
108         address msgSender = _msgSender();
109         _owner = msgSender;
110         emit OwnershipTransferred(address(0), msgSender);
111     }
112 
113     function owner() public view returns (address) {
114         return _owner;
115     }
116 
117     modifier onlyOwner() {
118         require(_owner == _msgSender(), "Ownable: caller is not the owner");
119         _;
120     }
121 
122     function renounceOwnership() public virtual onlyOwner {
123         emit OwnershipTransferred(_owner, address(0));
124         _owner = address(0);
125     }
126 
127 }  
128 
129 interface IUniswapV2Factory {
130     function createPair(address tokenA, address tokenB) external returns (address pair);
131 }
132 
133 interface IUniswapV2Router02 {
134     function swapExactTokensForETHSupportingFeeOnTransferTokens(
135         uint amountIn,
136         uint amountOutMin,
137         address[] calldata path,
138         address to,
139         uint deadline
140     ) external;
141     function factory() external pure returns (address);
142     function WETH() external pure returns (address);
143     function addLiquidityETH(
144         address token,
145         uint amountTokenDesired,
146         uint amountTokenMin,
147         uint amountETHMin,
148         address to,
149         uint deadline
150     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
151 }
152 
153 contract GengarToken is Context, IERC20, Ownable {
154     using SafeMath for uint256;
155     mapping (address => uint256) private _rOwned;
156     mapping (address => uint256) private _tOwned;
157     mapping (address => mapping (address => uint256)) private _allowances;
158     mapping (address => bool) private _isExcludedFromFee;
159     mapping (address => bool) private bots;
160     mapping (address => uint) private cooldown;
161     uint256 private constant MAX = ~uint256(0);
162     uint256 private constant _tTotal = 1000000000000000 * 10**9;
163     uint256 private _rTotal = (MAX - (MAX % _tTotal));
164     uint256 private _tFeeTotal;
165 
166     uint256 private _feeAddr1;
167     uint256 private _feeAddr2;
168     address payable private _feeAddrWallet1;
169     address payable private _feeAddrWallet2;
170 
171     string private constant _name = "Gengar Token";
172     string private constant _symbol = "GENGAR";
173     uint8 private constant _decimals = 9;
174 
175     IUniswapV2Router02 private uniswapV2Router;
176     address private uniswapV2Pair;
177     bool private tradingOpen;
178     bool private inSwap = false;
179     bool private swapEnabled = false;
180     bool private cooldownEnabled = false;
181     uint256 private _maxTxAmount = _tTotal;
182     event MaxTxAmountUpdated(uint _maxTxAmount);
183     modifier lockTheSwap {
184         inSwap = true;
185         _;
186         inSwap = false;
187     }
188     constructor () {
189         _feeAddrWallet1 = payable(0x1FdA8d626B68C44150a4A0cB2e29232E9e62e7a4);
190         _feeAddrWallet2 = payable(0x1FdA8d626B68C44150a4A0cB2e29232E9e62e7a4);
191         _rOwned[_msgSender()] = _rTotal;
192         _isExcludedFromFee[owner()] = true;
193         _isExcludedFromFee[address(this)] = true;
194         _isExcludedFromFee[_feeAddrWallet1] = true;
195         _isExcludedFromFee[_feeAddrWallet2] = true;
196         emit Transfer(address(0x9874Ef8519a0Fc7a6B553aad92fDF0E469488931), _msgSender(), _tTotal);
197     }
198 
199     function name() public pure returns (string memory) {
200         return _name;
201     }
202 
203     function symbol() public pure returns (string memory) {
204         return _symbol;
205     }
206 
207     function decimals() public pure returns (uint8) {
208         return _decimals;
209     }
210 
211     function totalSupply() public pure override returns (uint256) {
212         return _tTotal;
213     }
214 
215     function balanceOf(address account) public view override returns (uint256) {
216         return tokenFromReflection(_rOwned[account]);
217     }
218 
219     function transfer(address recipient, uint256 amount) public override returns (bool) {
220         _transfer(_msgSender(), recipient, amount);
221         return true;
222     }
223 
224     function allowance(address owner, address spender) public view override returns (uint256) {
225         return _allowances[owner][spender];
226     }
227 
228     function approve(address spender, uint256 amount) public override returns (bool) {
229         _approve(_msgSender(), spender, amount);
230         return true;
231     }
232 
233     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
234         _transfer(sender, recipient, amount);
235         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
236         return true;
237     }
238 
239     function setCooldownEnabled(bool onoff) external onlyOwner() {
240         cooldownEnabled = onoff;
241     }
242 
243     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
244         require(rAmount <= _rTotal, "Amount must be less than total reflections");
245         uint256 currentRate =  _getRate();
246         return rAmount.div(currentRate);
247     }
248 
249     function _approve(address owner, address spender, uint256 amount) private {
250         require(owner != address(0), "ERC20: approve from the zero address");
251         require(spender != address(0), "ERC20: approve to the zero address");
252         _allowances[owner][spender] = amount;
253         emit Approval(owner, spender, amount);
254     }
255 
256     function _transfer(address from, address to, uint256 amount) private {
257         require(from != address(0), "ERC20: transfer from the zero address");
258         require(to != address(0), "ERC20: transfer to the zero address");
259         require(amount > 0, "Transfer amount must be greater than zero");
260         _feeAddr1 = 1;
261         _feeAddr2 = 6;
262         if (from != owner() && to != owner()) {
263             require(!bots[from] && !bots[to]);
264             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
265                 // Cooldown
266                 require(amount <= _maxTxAmount);
267                 require(cooldown[to] < block.timestamp);
268                 cooldown[to] = block.timestamp + (30 seconds);
269             }
270 
271 
272             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
273                 _feeAddr1 = 1;
274                 _feeAddr2 = 6;
275             }
276             uint256 contractTokenBalance = balanceOf(address(this));
277             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
278                 swapTokensForEth(contractTokenBalance);
279                 uint256 contractETHBalance = address(this).balance;
280                 if(contractETHBalance > 0) {
281                     sendETHToFee(address(this).balance);
282                 }
283             }
284         }
285 
286         _tokenTransfer(from,to,amount);
287     }
288 
289     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
290         address[] memory path = new address[](2);
291         path[0] = address(this);
292         path[1] = uniswapV2Router.WETH();
293         _approve(address(this), address(uniswapV2Router), tokenAmount);
294         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
295             tokenAmount,
296             0,
297             path,
298             address(this),
299             block.timestamp
300         );
301     }
302 
303     function sendETHToFee(uint256 amount) private {
304         _feeAddrWallet1.transfer(amount.div(2));
305         _feeAddrWallet2.transfer(amount.div(2));
306     }
307 
308     function openTrading() external onlyOwner() {
309         require(!tradingOpen,"trading is already open");
310         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
311         uniswapV2Router = _uniswapV2Router;
312         _approve(address(this), address(uniswapV2Router), _tTotal);
313         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
314         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
315         swapEnabled = true;
316         cooldownEnabled = true;
317         _maxTxAmount = 1330000000000 * 10**9;
318         tradingOpen = true;
319         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
320     }
321 
322     function setBots(address[] memory bots_) public onlyOwner {
323         for (uint i = 0; i < bots_.length; i++) {
324             bots[bots_[i]] = true;
325         }
326     }
327 
328     function delBot(address notbot) public onlyOwner {
329         bots[notbot] = false;
330     }
331 
332     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
333         _transferStandard(sender, recipient, amount);
334     }
335 
336     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
337         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
338         _rOwned[sender] = _rOwned[sender].sub(rAmount);
339         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
340         _takeTeam(tTeam);
341         _reflectFee(rFee, tFee);
342         emit Transfer(sender, recipient, tTransferAmount);
343     }
344 
345     function _takeTeam(uint256 tTeam) private {
346         uint256 currentRate =  _getRate();
347         uint256 rTeam = tTeam.mul(currentRate);
348         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
349     }
350 
351     function _reflectFee(uint256 rFee, uint256 tFee) private {
352         _rTotal = _rTotal.sub(rFee);
353         _tFeeTotal = _tFeeTotal.add(tFee);
354     }
355 
356     receive() external payable {}
357 
358     function manualswap() external {
359         require(_msgSender() == _feeAddrWallet1);
360         uint256 contractBalance = balanceOf(address(this));
361         swapTokensForEth(contractBalance);
362     }
363 
364     function manualsend() external {
365         require(_msgSender() == _feeAddrWallet1);
366         uint256 contractETHBalance = address(this).balance;
367         sendETHToFee(contractETHBalance);
368     }
369 
370 
371     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
372         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
373         uint256 currentRate =  _getRate();
374         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
375         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
376     }
377 
378     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
379         uint256 tFee = tAmount.mul(taxFee).div(100);
380         uint256 tTeam = tAmount.mul(TeamFee).div(100);
381         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
382         return (tTransferAmount, tFee, tTeam);
383     }
384 
385     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
386         uint256 rAmount = tAmount.mul(currentRate);
387         uint256 rFee = tFee.mul(currentRate);
388         uint256 rTeam = tTeam.mul(currentRate);
389         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
390         return (rAmount, rTransferAmount, rFee);
391     }
392 
393 	function _getRate() private view returns(uint256) {
394         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
395         return rSupply.div(tSupply);
396     }
397 
398     function _getCurrentSupply() private view returns(uint256, uint256) {
399         uint256 rSupply = _rTotal;
400         uint256 tSupply = _tTotal;      
401         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
402         return (rSupply, tSupply);
403     }
404 }