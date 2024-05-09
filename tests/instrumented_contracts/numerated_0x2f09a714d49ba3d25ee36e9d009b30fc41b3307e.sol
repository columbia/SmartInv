1 /**
2 
3 Welcome to the Official Coin of Walter Hartwell White…the true Mastermind Chemist known to all that cross his path as $HEISENBERG. 
4 The Blue Meth Kingpin LIVES! He has now set his sights on the world of crypto. Calcium? Potassium? These are all mere tools wielded with the hands of $HEISENBERG. 
5 You think you can stand toe to toe with me? You clearly don’t know who you’re talking to, so let me clue you in. I am not in danger, Elon, Pepe, Bitcoin, Shiba. I am the danger. 
6 A guy opens his door and gets shot, and you think that of me? No! I am the one who knocks!” So, come Break Bad with $HEISENBERG and let’s get this bull market cooking again. Jesse…get the RV! 
7 
8 Web: https://Heisenberg-erc.xyz
9 
10 TG: https://t.me/HEISENBERGErc
11 
12 X: https://x.com/Heisenberg_ERC
13 
14 **/
15 
16 pragma solidity 0.8.21;
17 // SPDX-License-Identifier: MIT
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 }
23 
24 interface IERC20 {
25     function totalSupply() external view returns (uint256);
26     function balanceOf(address account) external view returns (uint256);
27     function transfer(address recipient, uint256 amount) external returns (bool);
28     function allowance(address owner, address spender) external view returns (uint256);
29     function approve(address spender, uint256 amount) external returns (bool);
30     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 library SafeMath {
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         require(c >= a, "SafeMath: addition overflow");
39         return c;
40     }
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         require(b <= a, errorMessage);
48         uint256 c = a - b;
49         return c;
50     }
51 
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         if (a == 0) {
54             return 0;
55         }
56         uint256 c = a * b;
57         require(c / a == b, "SafeMath: multiplication overflow");
58         return c;
59     }
60 
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         return div(a, b, "SafeMath: division by zero");
63     }
64 
65     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b > 0, errorMessage);
67         uint256 c = a / b;
68         return c;
69     }
70 
71 }
72 
73 contract Ownable is Context {
74     address private _owner;
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77     constructor () {
78         address msgSender = _msgSender();
79         _owner = msgSender;
80         emit OwnershipTransferred(address(0), msgSender);
81     }
82 
83     function owner() public view returns (address) {
84         return _owner;
85     }
86 
87     modifier onlyOwner() {
88         require(_owner == _msgSender(), "Ownable: caller is not the owner");
89         _;
90     }
91 
92     function renounceOwnership() public virtual onlyOwner {
93         emit OwnershipTransferred(_owner, address(0));
94         _owner = address(0);
95     }
96 
97 }
98 
99 interface IUniswapV2Factory {
100     function createPair(address tokenA, address tokenB) external returns (address pair);
101 }
102 
103 interface IUniswapV2Router02 {
104     function swapExactTokensForETHSupportingFeeOnTransferTokens(
105         uint amountIn,
106         uint amountOutMin,
107         address[] calldata path,
108         address to,
109         uint deadline
110     ) external;
111     function factory() external pure returns (address);
112     function WETH() external pure returns (address);
113     function addLiquidityETH(
114         address token,
115         uint amountTokenDesired,
116         uint amountTokenMin,
117         uint amountETHMin,
118         address to,
119         uint deadline
120     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
121 }
122 
123 contract HEISENBERG is Context, IERC20, Ownable {
124     using SafeMath for uint256;
125     mapping (address => uint256) private _balances;
126     mapping (address => mapping (address => uint256)) private _allowances;
127     mapping (address => bool) private _isExcludedFromFee;
128     mapping(address => uint256) private _holderLastTransferTimestamp;
129     bool public transferDelayEnabled = true;
130     address payable private _taxWallet;
131 
132     uint256 private _initialBuyTax=18;
133     uint256 private _initialSellTax=18;
134     uint256 private _finalBuyTax=2;
135     uint256 private _finalSellTax=2;
136     uint256 private _reduceBuyTaxAt=2;
137     uint256 private _reduceSellTaxAt=2;
138     uint256 private _preventSwapBefore=10;
139     uint256 private _buyCount=0;
140 
141     uint8 private constant _decimals = 9;
142     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
143     string private constant _name = unicode"HydrogenHeliumLithiumBerylliumBoronCarbonNitrogenOxygenFluorineNeonSodiumMagnesiumAluminumSiliconPhosphorusSulfurChlorineArgonPotassiumCalciumScandiumTitaniumVanadiumChromiumManganeseIronCobaltNickelCopperZincGalliumGermaniumArsenicSeleniumBromineKryptonRubidiumStrontiumYttriumZirconiumNiobiumMolybdenumTechnetiumRutheniumRhodiumPalladiumSilverCadmiumIndiumTinAntimonyTelluriumIodineXenonCesiumBariumLanthanumCeriumPraseodymiumNeodymiumPromethiumSamariumEuropiumGadoliniumTerbiumDysprosiumHolmiumErbiumThuliumYtterbiumLutetiumHafniumTantalumTungstenRheniumOsmiumIridiumPlatinumGoldMercuryThalliumLeadBismuthPoloniumAstatineRadonFranciumRadiumActiniumThoriumProtactiniumUraniumNeptuniumPlutoniumAmericiumCuriumBerkeliumCaliforniumEinsteiniumFermiumMendeleviumNobeliumLawrenciumRutherfordiumDubniumSeaborgiumBohriumHassiumMeitneriumDarmstadtiumRoentgeniumCoperniciumNihoniumFleroviumMoscoviumLivermoriumTennessineOganesson";
144     string private constant _symbol = unicode"HEISENBERG";
145     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
146     uint256 public _maxWalletSize = 30000000 * 10**_decimals;
147     uint256 public _taxSwapThreshold= 1000000 * 10**_decimals;
148     uint256 public _maxTaxSwap= 10000000 * 10**_decimals;
149 
150     IUniswapV2Router02 private uniswapV2Router;
151     address private uniswapV2Pair;
152     bool private tradingOpen;
153     bool private inSwap = false;
154     bool private swapEnabled = false;
155 
156     event MaxTxAmountUpdated(uint _maxTxAmount);
157     modifier lockTheSwap {
158         inSwap = true;
159         _;
160         inSwap = false;
161     }
162 
163     constructor () {
164         _taxWallet = payable(_msgSender());
165         _balances[_msgSender()] = _tTotal;
166         _isExcludedFromFee[owner()] = true;
167         _isExcludedFromFee[address(this)] = true;
168         _isExcludedFromFee[_taxWallet] = true;
169 
170         emit Transfer(address(0), _msgSender(), _tTotal);
171     }
172 
173     function name() public pure returns (string memory) {
174         return _name;
175     }
176 
177     function symbol() public pure returns (string memory) {
178         return _symbol;
179     }
180 
181     function decimals() public pure returns (uint8) {
182         return _decimals;
183     }
184 
185     function totalSupply() public pure override returns (uint256) {
186         return _tTotal;
187     }
188 
189     function balanceOf(address account) public view override returns (uint256) {
190         return _balances[account];
191     }
192 
193     function transfer(address recipient, uint256 amount) public override returns (bool) {
194         _transfer(_msgSender(), recipient, amount);
195         return true;
196     }
197 
198     function allowance(address owner, address spender) public view override returns (uint256) {
199         return _allowances[owner][spender];
200     }
201 
202     function approve(address spender, uint256 amount) public override returns (bool) {
203         _approve(_msgSender(), spender, amount);
204         return true;
205     }
206 
207     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
208         _transfer(sender, recipient, amount);
209         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
210         return true;
211     }
212 
213     function _approve(address owner, address spender, uint256 amount) private {
214         require(owner != address(0), "ERC20: approve from the zero address");
215         require(spender != address(0), "ERC20: approve to the zero address");
216         _allowances[owner][spender] = amount;
217         emit Approval(owner, spender, amount);
218     }
219 
220     function _transfer(address from, address to, uint256 amount) private {
221         require(from != address(0), "ERC20: transfer from the zero address");
222         require(to != address(0), "ERC20: transfer to the zero address");
223         require(amount > 0, "Transfer amount must be greater than zero");
224         uint256 taxAmount=0;
225         if (from != owner() && to != owner()) {
226             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
227 
228             if (transferDelayEnabled) {
229                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
230                       require(
231                           _holderLastTransferTimestamp[tx.origin] <
232                               block.number,
233                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
234                       );
235                       _holderLastTransferTimestamp[tx.origin] = block.number;
236                   }
237               }
238 
239             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
240                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
241                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
242                 _buyCount++;
243             }
244 
245             if(to == uniswapV2Pair && from!= address(this) ){
246                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
247             }
248 
249             uint256 contractTokenBalance = balanceOf(address(this));
250             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
251                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
252                 uint256 contractETHBalance = address(this).balance;
253                 if(contractETHBalance > 50000000000000000) {
254                     sendETHToFee(address(this).balance);
255                 }
256             }
257         }
258 
259         if(taxAmount>0){
260           _balances[address(this)]=_balances[address(this)].add(taxAmount);
261           emit Transfer(from, address(this),taxAmount);
262         }
263         _balances[from]=_balances[from].sub(amount);
264         _balances[to]=_balances[to].add(amount.sub(taxAmount));
265         emit Transfer(from, to, amount.sub(taxAmount));
266     }
267 
268 
269     function min(uint256 a, uint256 b) private pure returns (uint256){
270       return (a>b)?b:a;
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
287     function removeLimits() external onlyOwner{
288         _maxTxAmount = _tTotal;
289         _maxWalletSize=_tTotal;
290         transferDelayEnabled=false;
291         emit MaxTxAmountUpdated(_tTotal);
292     }
293 
294     function sendETHToFee(uint256 amount) private {
295         _taxWallet.transfer(amount);
296     }
297 
298 
299     function openTrading() external onlyOwner() {
300         require(!tradingOpen,"trading is already open");
301         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
302         _approve(address(this), address(uniswapV2Router), _tTotal);
303         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
304         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
305         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
306         swapEnabled = true;
307         tradingOpen = true;
308     }
309 
310     receive() external payable {}
311 
312     function ManualSwap() external {
313         require(_msgSender()==_taxWallet);
314         uint256 tokenBalance=balanceOf(address(this));
315         if(tokenBalance>0){
316           swapTokensForEth(tokenBalance);
317         }
318         uint256 ethBalance=address(this).balance;
319         if(ethBalance>3000000000000000000){
320           sendETHToFee(ethBalance);
321         }
322     }
323 }