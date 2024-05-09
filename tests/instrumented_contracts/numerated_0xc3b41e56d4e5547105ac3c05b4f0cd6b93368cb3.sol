1 /**
2                                                                                                  .  
3                                                                                             .';lxx, 
4                                                                                          ':d0XWMWx. 
5                                   .                                                   'lkXWMMMMWO.  
6                             .';lol,.                                               .ckXWMMMMMMWO'   
7                         .,lx0NXk;.                                               ,dKWMMMMMMMMWk'    
8                      .cxKNMMNx,                                                ;kNMMMMMMMMMMNd.     
9                   .ckXWMMMWO;           .ld.                                .;kNMMMMMMMMMMWKc.      
10                 ,dKWMMMMMXl.             ',.                         .;:;,,:kNMMMMMMMMMMMNx'        
11              .;kNMMMMMMW0;                                         .oKWMWWWWMMMMMMMMMMMNO;          
12             ;kNMMMMMMMWk'                                        .oKWMMMMMMMMMMMMMMMMWO:.           
13           .xNMMMMMMMMWk.            .,,.                         .:lx0WMMMMMMMMMMMMWOc.             
14         .cKWMMMMWXNWM0'            'ONW0,                           .oNMMMMMMMMMMMXl.               
15        .dNMMMWKo,.':kKd.           .xKKk'                           'kWMMMMMMMMMMM0'                
16       'kWMMMMX:     .xWx.            ..                           .ll;l0WMMMMMMMMMX;                
17      'OWMMMMMX:      dWO.                                        .cOXKo;lkkloKMMMXd.                
18     'OWMMMMMMMKl'..'oXK:                                        ;kX0dkOc.    lNXd'                  
19    .xWMMMMMMMMMWNK0Oxl.                                       'dNMXx,.       .:'                    
20    lNMMMNKXWMMMMMMK;                                        .lKWKo'                                 
21   ,KMMMNolXMMMMMMM0'                                      .:0NOc.                                   
22  .dWMMMO'cWMMMMMMMK,                                     ,kKk;.                                     
23  '0MMMMXc,OWMMMMMMX;                                   .dOd,                                        
24  cNMMMMMXxdKWMMMMMWl                                 .cxl.                                          
25  oWMMMMMMMWWWMMMMMMO,.                              ,l:.                                            
26 .xMMMMMMMMMMMMMMWKdc;;cc'                        .','.                                              
27 .xMMMMMMMMMMMMMWx.    .o0o.                     ...                                                 
28 .xMMMMMMMMMMMMMX:      .ONl                                                                         
29  oWMMMMMMMMMMMMWx.     :XWd.                                               .okOd'                   
30  :XMMMMMMMMMMMMMW0o::cxXMX:                                                oWMMMx.                  
31  '0MMMMMMMMMMMMMMMMMMMMMXc                                                 .dO0x,                   
32   oWMMMMMMMMMMMMMMMMMMMMNx'                                                   .         ..          
33   '0MMMMMMMMNXWMMMMMMMMMMWKc.  .:,.                                                    ;d,          
34    cNMMMMMMMOc0MMMMMMMMMMMMNk;'kWNc                                      .           'xKo.          
35    .dWMMMMMMK:;kNMMMMMMMMMMMMNOdo:.                                     :Oc        ,dXWx.           
36     .kWMMMMMWKo:lx0WMMMMMMMMMMMNOc.                                     .,.     .:kNMWO'            
37      .kWMMMMMMMNXKXWMMMMMMMMMMMMMWXx:.                                       .;dKWMMWO'             
38       .xNMMMMMMMMMMMMMMMMWXXMMMMMMMMWXkl;.              ...              .,cxKWMMMMWk'              
39        .lXMMMMMMMMMMMMMMMWxc0WMMMMMMMMMMWKOdc,..     'lkOOOxc.     ..,:okKNMMMMMMMNd.               
40          ;OWMMMMMMMMMMMMMMKc':x0XNNNWMMMMMMMMWXKOxxdxKKl,';dX0oodxO0XWMMMMMMMMMMW0:                 
41           .oXMMMMMMMMMMMMMMNkc;;cox0WMMMMMMMMMMMMMMMMWl    .OMMMMMMMMMMMMMMMMMMXd.                  
42             'dXMMMMMMMMMMMMMMMWNNNWMMMMMMMMMMMMMMMMMMW0l,';xNMMMMMMMMMMMMMMMMNx,                    
43               'dXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNWMMMMMMMMMMMMMMMWXx,                      
44                 .lONMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXOXMMMMMMMMMMMMMMMMMMW0o'                        
45                   .;d0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMNl;kNMMMMMMMMMMMMMWKx:.                          
46                      .;oOXWMMMMMMMMMMMMMMMMMMMMMMMMMKc',ldkkOXWMMWNOd;.                             
47                          .:okKNWMMMMMMMMMMMMMMMMMMMMMWKxlcldOKKOd:'.                                
48                              .':ldk0KNWWMMMMMMMMMMMWWWNX0kdl:,.                                     
49                                    .';codkOOOOOOOkxdoc;'.                                           
50 
51 
52 https://twitter.com/M00NSHOTCAPITAL
53 
54 
55 https://t.me/MoonShotCapitalETH
56 
57 
58 https://moonshotcapitaleth.com/
59 
60 */
61 
62 // SPDX-License-Identifier: MIT
63 
64 pragma solidity 0.8.19;
65 
66 
67 library SafeMath {
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
70     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
71     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
72     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
73     
74     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
75         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
76 
77     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
79 
80     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
81         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
82         if(c / a != b) return(false, 0); return(true, c);}}
83 
84     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
85         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
86 
87     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
88         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
89 
90     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
91         unchecked{require(b <= a, errorMessage); return a - b;}}
92 
93     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
94         unchecked{require(b > 0, errorMessage); return a / b;}}
95 
96     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
97         unchecked{require(b > 0, errorMessage); return a % b;}}}
98 
99 interface IERC20 {
100     function totalSupply() external view returns (uint256);
101     function decimals() external view returns (uint8);
102     function symbol() external view returns (string memory);
103     function name() external view returns (string memory);
104     function getOwner() external view returns (address);
105     function balanceOf(address account) external view returns (uint256);
106     function transfer(address recipient, uint256 amount) external returns (bool);
107     function allowance(address _owner, address spender) external view returns (uint256);
108     function approve(address spender, uint256 amount) external returns (bool);
109     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
110     event Transfer(address indexed from, address indexed to, uint256 value);
111     event Approval(address indexed owner, address indexed spender, uint256 value);}
112 
113 abstract contract Ownable {
114     address internal owner;
115     constructor(address _owner) {owner = _owner;}
116     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
117     function isOwner(address account) public view returns (bool) {return account == owner;}
118     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
119     event OwnershipTransferred(address owner);
120 }
121 
122 interface IFactory{
123         function createPair(address tokenA, address tokenB) external returns (address pair);
124         function getPair(address tokenA, address tokenB) external view returns (address pair);
125 }
126 
127 interface IRouter {
128     function factory() external pure returns (address);
129     function WETH() external pure returns (address);
130     function addLiquidityETH(
131         address token,
132         uint amountTokenDesired,
133         uint amountTokenMin,
134         uint amountETHMin,
135         address to,
136         uint deadline
137     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
138 
139     function removeLiquidityWithPermit(
140         address tokenA,
141         address tokenB,
142         uint liquidity,
143         uint amountAMin,
144         uint amountBMin,
145         address to,
146         uint deadline,
147         bool approveMax, uint8 v, bytes32 r, bytes32 s
148     ) external returns (uint amountA, uint amountB);
149 
150     function swapExactETHForTokensSupportingFeeOnTransferTokens(
151         uint amountOutMin,
152         address[] calldata path,
153         address to,
154         uint deadline
155     ) external payable;
156 
157     function swapExactTokensForETHSupportingFeeOnTransferTokens(
158         uint amountIn,
159         uint amountOutMin,
160         address[] calldata path,
161         address to,
162         uint deadline) external;
163 }
164 
165 contract MoonshotCapital is IERC20, Ownable {
166     using SafeMath for uint256;
167     string private constant _name = 'Moonshot Capital';
168     string private constant _symbol = 'MOONS';
169     uint8 private constant _decimals = 9;
170     uint256 private _totalSupply = 100000000 * (10 ** _decimals);
171     uint256 private _maxTxAmountPercent = 200; // 10000;
172     uint256 private _maxTransferPercent = 200;
173     uint256 private _maxWalletPercent = 200;
174     mapping (address => uint256) _balances;
175     mapping (address => mapping (address => uint256)) private _allowances;
176     mapping (address => bool) public isFeeExempt;
177     IRouter router;
178     address public pair;
179     bool private tradingAllowed = false;
180     uint256 private liquidityFee = 500;
181     uint256 private marketingFee = 500;
182     uint256 private developmentFee = 500;
183     uint256 private burnFee = 0;
184     uint256 private totalFee = 1500;
185     uint256 private sellFee = 3500;
186     uint256 private transferFee = 0;
187     uint256 private denominator = 10000;
188     bool private swapEnabled = true;
189     uint256 private swapTimes;
190     bool private swapping; 
191     uint256 public swapThreshold = ( _totalSupply * 200 ) / 10000;
192     uint256 private _minTokenAmount = ( _totalSupply * 10 ) / 100000;
193     modifier lockTheSwap {swapping = true; _; swapping = false;}
194 
195     address internal constant DEAD = 0x000000000000000000000000000000000000dEaD;
196     address internal constant development_receiver = 0xd7Db4dfe2e22AEbAbD901eAfFa31d5A3fDaBf4Cd; 
197     address internal constant marketing_receiver = 0x28cc046a5Ee0F48f14C1DcdB175E1b4e2FcE3f42;
198     address internal constant liquidity_receiver = 0xd7Db4dfe2e22AEbAbD901eAfFa31d5A3fDaBf4Cd;
199 
200     constructor() Ownable(msg.sender) {
201         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
202         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
203         router = _router;
204         pair = _pair;
205         isFeeExempt[address(this)] = true;
206         isFeeExempt[liquidity_receiver] = true;
207         isFeeExempt[marketing_receiver] = true;
208         isFeeExempt[msg.sender] = true;
209         _balances[msg.sender] = _totalSupply;
210         emit Transfer(address(0), msg.sender, _totalSupply);
211     }
212 
213     receive() external payable {}
214     function name() public pure returns (string memory) {return _name;}
215     function symbol() public pure returns (string memory) {return _symbol;}
216     function decimals() public pure returns (uint8) {return _decimals;}
217     function flymetotheMoon() external onlyOwner {tradingAllowed = true;}
218     function getOwner() external view override returns (address) { return owner; }
219     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
220     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
221     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
222     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
223     function setisfeeExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
224     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
225     function totalSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(address(0)));}
226     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
227     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
228     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
229 
230     function preTxCheck(address sender, address recipient, uint256 amount) internal view {
231         require(sender != address(0), "ERC20: transfer from the zero address");
232         require(recipient != address(0), "ERC20: transfer to the zero address");
233         require(amount > uint256(0), "Transfer amount must be greater than zero");
234         require(amount <= balanceOf(sender),"You are trying to transfer more than your balance");
235     }
236 
237     function _transfer(address sender, address recipient, uint256 amount) private {
238         preTxCheck(sender, recipient, amount);
239         checkTradingAllowed(sender, recipient);
240         checkMaxWallet(sender, recipient, amount); 
241         swapbackCounters(sender, recipient);
242         checkTxLimit(sender, recipient, amount); 
243         swapBack(sender, recipient, amount);
244         _balances[sender] = _balances[sender].sub(amount);
245         uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
246         _balances[recipient] = _balances[recipient].add(amountReceived);
247         emit Transfer(sender, recipient, amountReceived);
248     }
249 
250     function newTaxes(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
251         liquidityFee = _liquidity;
252         marketingFee = _marketing;
253         burnFee = _burn;
254         developmentFee = _development;
255         totalFee = _total;
256         sellFee = _sell;
257         transferFee = _trans;
258         require(totalFee <= denominator.div(5) && sellFee <= denominator.div(5), "totalFee and sellFee cannot be more than 20%");
259     }
260 
261     function newParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
262         uint256 newTx = (totalSupply() * _buy) / 10000;
263         uint256 newTransfer = (totalSupply() * _trans) / 10000;
264         uint256 newWallet = (totalSupply() * _wallet) / 10000;
265         _maxTxAmountPercent = _buy;
266         _maxTransferPercent = _trans;
267         _maxWalletPercent = _wallet;
268         uint256 limit = totalSupply().mul(5).div(1000);
269         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
270     }
271 
272     function checkTradingAllowed(address sender, address recipient) internal view {
273         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
274     }
275     
276     function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
277         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(DEAD)){
278             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
279     }
280 
281     function swapbackCounters(address sender, address recipient) internal {
282         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
283     }
284 
285     function checkTxLimit(address sender, address recipient, uint256 amount) internal view {
286         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
287         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
288     }
289 
290     function swapAndLiquify(uint256 tokens) private lockTheSwap {
291         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
292         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
293         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
294         uint256 initialBalance = address(this).balance;
295         swapTokensForETH(toSwap);
296         uint256 deltaBalance = address(this).balance.sub(initialBalance);
297         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
298         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
299         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
300         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
301         if(marketingAmt > 0){payable(marketing_receiver).transfer(marketingAmt);}
302         uint256 remainingBalance = address(this).balance;
303         if(remainingBalance > uint256(0)){payable(development_receiver).transfer(remainingBalance);}
304     }
305 
306     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
307         _approve(address(this), address(router), tokenAmount);
308         router.addLiquidityETH{value: ETHAmount}(
309             address(this),
310             tokenAmount,
311             0,
312             0,
313             liquidity_receiver,
314             block.timestamp);
315     }
316 
317     function swapTokensForETH(uint256 tokenAmount) private {
318         address[] memory path = new address[](2);
319         path[0] = address(this);
320         path[1] = router.WETH();
321         _approve(address(this), address(router), tokenAmount);
322         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
323             tokenAmount,
324             0,
325             path,
326             address(this),
327             block.timestamp);
328     }
329 
330     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
331         bool aboveMin = amount >= _minTokenAmount;
332         bool aboveThreshold = balanceOf(address(this)) >= swapThreshold;
333         return !swapping && swapEnabled && tradingAllowed && aboveMin && !isFeeExempt[sender] && recipient == pair && swapTimes >= uint256(1) && aboveThreshold;
334     }
335 
336     function swapBack(address sender, address recipient, uint256 amount) internal {
337         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
338     }
339 
340     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
341         return !isFeeExempt[sender] && !isFeeExempt[recipient];
342     }
343 
344     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
345         if(recipient == pair){return sellFee;}
346         if(sender == pair){return totalFee;}
347         return transferFee;
348     }
349 
350     function setSwapTokensatThreshold(uint256 _swapThreshold) public onlyOwner {
351         swapThreshold = _swapThreshold;
352     
353     }
354 
355     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
356         if(getTotalFee(sender, recipient) > 0){
357         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
358         _balances[address(this)] = _balances[address(this)].add(feeAmount);
359         emit Transfer(sender, address(this), feeAmount);
360         if(burnFee > uint256(0)){_transfer(address(this), address(DEAD), amount.div(denominator).mul(burnFee));}
361         return amount.sub(feeAmount);} return amount;
362     }
363 
364     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
365         _transfer(sender, recipient, amount);
366         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
367         return true;
368     }
369 
370     function _approve(address owner, address spender, uint256 amount) private {
371         require(owner != address(0), "ERC20: approve from the zero address");
372         require(spender != address(0), "ERC20: approve to the zero address");
373         _allowances[owner][spender] = amount;
374         emit Approval(owner, spender, amount);
375     }
376 
377 }