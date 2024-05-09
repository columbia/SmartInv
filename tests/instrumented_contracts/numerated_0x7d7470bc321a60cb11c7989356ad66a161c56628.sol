1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.6.0;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this;
12         return msg.data;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 library SafeMath {
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31         return c;
32     }
33 
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37 
38     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b <= a, errorMessage);
40         uint256 c = a - b;
41         return c;
42     }
43 
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50         return c;
51     }
52 
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         return div(a, b, "SafeMath: division by zero");
55     }
56 
57     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b > 0, errorMessage);
59         uint256 c = a / b;
60         return c;
61     }
62 
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         return mod(a, b, "SafeMath: modulo by zero");
65     }
66 
67     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b != 0, errorMessage);
69         return a % b;
70     }
71 }
72 
73 library Address {
74     function isContract(address account) internal view returns (bool) {
75         bytes32 codehash;
76         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
77         assembly { codehash := extcodehash(account) }
78         return (codehash != accountHash && codehash != 0x0);
79     }
80 
81     function sendValue(address payable recipient, uint256 amount) internal {
82         require(address(this).balance >= amount, "Address: insufficient balance");
83         (bool success, ) = recipient.call{ value: amount }("");
84         require(success, "Address: unable to send value, recipient may have reverted");
85     }
86 
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
92         return _functionCallWithValue(target, data, 0, errorMessage);
93     }
94 
95     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
96         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
97     }
98 
99     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
100         require(address(this).balance >= value, "Address: insufficient balance for call");
101         return _functionCallWithValue(target, data, value, errorMessage);
102     }
103 
104     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
105         require(isContract(target), "Address: call to non-contract");
106         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
107         if (success) {
108             return returndata;
109         } else {
110             if (returndata.length > 0) {
111                 assembly {
112                     let returndata_size := mload(returndata)
113                     revert(add(32, returndata), returndata_size)
114                 }
115             } else {
116                 revert(errorMessage);
117             }
118         }
119     }
120 }
121 
122 contract Ownable is Context {
123     address private _owner;
124     address private _previousOwner;
125     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
126 
127     constructor () internal {
128         address msgSender = _msgSender();
129         _owner = msgSender;
130         emit OwnershipTransferred(address(0), msgSender);
131     }
132 
133     function owner() public view returns (address) {
134         return _owner;
135     }
136 
137     modifier onlyOwner() {
138         require(_owner == _msgSender(), "Ownable: caller is not the owner");
139         _;
140     }
141 
142     function renounceOwnership() public virtual onlyOwner {
143         emit OwnershipTransferred(_owner, address(0));
144         _owner = address(0);
145     }
146 
147 } 
148 
149 interface IUniswapV2Factory {
150     function createPair(address tokenA, address tokenB) external returns (address pair);
151 }
152 
153 interface IUniswapV2Router02 {
154     function swapExactTokensForETHSupportingFeeOnTransferTokens(
155         uint amountIn,
156         uint amountOutMin,
157         address[] calldata path,
158         address to,
159         uint deadline
160     ) external;
161     function factory() external pure returns (address);
162     function WETH() external pure returns (address);
163     function addLiquidityETH(
164         address token,
165         uint amountTokenDesired,
166         uint amountTokenMin,
167         uint amountETHMin,
168         address to,
169         uint deadline
170     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
171 }
172 
173 contract ZAP is Context, IERC20, Ownable {
174     using SafeMath for uint256;
175     using Address for address;
176     
177     IUniswapV2Router02 public uniswapV2Router;
178     address public uniswapV2Pair;
179     
180     IUniswapV2Router02 public sushiswapRouter;
181     address public sushiswapPair;
182     
183     
184     string private _name = 'ZAP';
185     string private _symbol = 'ZAP';
186     uint8 private _decimals = 18;
187     
188     uint256 private constant MAX_UINT256 = ~uint256(0);
189     uint256 private constant INITIAL_FRAGMENTS_SUPPLY = 1 * 1e7 * 1e18;
190     uint256 private constant TOTAL_GONS = MAX_UINT256 - (MAX_UINT256 % INITIAL_FRAGMENTS_SUPPLY);
191     
192     uint256 public constant MAG = 10 ** 18;
193     uint256 public  rateOfChange = MAG;
194 
195     uint256 private _totalSupply;
196     uint256 public _gonsPerFragment;
197     
198     mapping(address => uint256) public _gonBalances;
199     mapping (address => mapping (address => uint256)) private _allowances;
200     mapping(address => bool) public blacklist;
201     mapping (address => uint256) public _buyInfo;
202 
203     uint256 public _percentForTxLimit = 2; //2% of total supply;
204     uint256 public _percentForRebase = 5; //5% of total supply;
205     uint256 public _timeLimitFromLastBuy = 5 minutes;
206     
207     uint256 private uniswapV2PairAmount;
208     uint256 private sushiswapPairAmount;
209     
210     bool public _live = false;
211     
212     
213     constructor () public {
214         _totalSupply = INITIAL_FRAGMENTS_SUPPLY;
215         _gonBalances[_msgSender()] = TOTAL_GONS;
216         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
217         
218         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
219         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
220         
221         sushiswapRouter = IUniswapV2Router02(0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F);
222         sushiswapPair = IUniswapV2Factory(sushiswapRouter.factory()).createPair(address(this), sushiswapRouter.WETH());
223 
224         emit Transfer(address(0), _msgSender(), _totalSupply);
225     }
226 
227     function name() public view returns (string memory) {
228         return _name;
229     }
230 
231     function symbol() public view returns (string memory) {
232         return _symbol;
233     }
234 
235     function decimals() public view returns (uint8) {
236         return _decimals;
237     }
238 
239     function totalSupply() public view override returns (uint256) {
240         return _totalSupply;
241     }
242 
243     function balanceOf(address account) public view override returns (uint256) {
244         if(account == uniswapV2Pair)
245             return uniswapV2PairAmount;
246         if(account == sushiswapPair)
247             return sushiswapPairAmount;
248         return _gonBalances[account].div(_gonsPerFragment);
249     }
250 
251     function transfer(address recipient, uint256 amount) public override returns (bool) {
252         _transfer(_msgSender(), recipient, amount);
253         return true;
254     }
255 
256     function allowance(address owner, address spender) public view override returns (uint256) {
257         return _allowances[owner][spender];
258     }
259 
260     function approve(address spender, uint256 amount) public override returns (bool) {
261         _approve(_msgSender(), spender, amount);
262         return true;
263     }
264 
265     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
266         _transfer(sender, recipient, amount);
267         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
268         return true;
269     }
270     
271     function _approve(address owner, address spender, uint256 amount) private {
272         require(owner != address(0), "ERC20: approve from the zero address");
273         require(spender != address(0), "ERC20: approve to the zero address");
274         _allowances[owner][spender] = amount;
275         emit Approval(owner, spender, amount);
276     }
277     
278     function rebasePlus(uint256 _amount) private {
279          _totalSupply = _totalSupply.add(_amount.div(5));
280         _gonsPerFragment = TOTAL_GONS.div(_totalSupply);
281     }
282 
283     function _transfer(address from, address to, uint256 amount) private {
284         require(from != address(0), "ERC20: transfer from the zero address");
285         require(to != address(0), "ERC20: transfer to the zero address");
286         require(amount > 0, "ERC20: Transfer amount must be greater than zero");
287         
288         if (from != owner() && to != owner()) {
289             uint256 txLimitAmount = _totalSupply.mul(_percentForTxLimit).div(100);
290             
291             require(amount <= txLimitAmount, "ERC20: amount exceeds the max tx limit.");
292             
293             if(from != uniswapV2Pair && from != sushiswapPair) {
294                 require(!blacklist[from] && !blacklist[to], 'ERC20: the transaction was blocked.');
295                 require(_buyInfo[from] == 0 || _buyInfo[from].add(_timeLimitFromLastBuy) < now, "ERC20: Tx not allowed yet.");
296                 
297                 if(to != address(uniswapV2Router) && to != uniswapV2Pair && to != address(sushiswapRouter) && to != sushiswapPair)
298                     _tokenTransfer(from, to, amount, 0);
299                 else
300                     _tokenTransfer(from, to, amount, 0);
301             }
302             else {
303                 if(!_live)
304                     blacklist[to] = true;
305                 
306                 require(balanceOf(to) <= txLimitAmount, 'ERC20: current balance exceeds the max limit.');
307                 
308                 _buyInfo[to] = now;
309                 _tokenTransfer(from, to, amount, 0);
310 
311                 uint256 rebaseLimitAmount = _totalSupply.mul(_percentForRebase).div(100);
312                 uint256 currentBalance = balanceOf(to);
313                 uint256 newBalance = currentBalance.add(amount);
314                 if(currentBalance < rebaseLimitAmount && newBalance < rebaseLimitAmount) {
315                     rebasePlus(amount);
316                 }
317             }
318         } else {
319             _tokenTransfer(from, to, amount, 0);
320         }
321     }
322     
323     function _tokenTransfer(address from, address to, uint256 amount, uint256 taxFee) internal {
324         if(to == uniswapV2Pair)
325             uniswapV2PairAmount = uniswapV2PairAmount.add(amount);
326         else if(from == uniswapV2Pair)
327             uniswapV2PairAmount = uniswapV2PairAmount.sub(amount);
328         else if(to == sushiswapPair)
329             sushiswapPairAmount = sushiswapPairAmount.add(amount);
330         else if(from == sushiswapPair)
331             sushiswapPairAmount = sushiswapPairAmount.sub(amount);
332         
333         uint256 burnAmount = amount.mul(taxFee).div(100);
334         uint256 transferAmount = amount.sub(burnAmount);
335         
336         uint256 gonTotalValue = amount.mul(_gonsPerFragment);
337         uint256 gonValue = transferAmount.mul(_gonsPerFragment);
338         
339         _gonBalances[from] = _gonBalances[from].sub(gonTotalValue);
340         _gonBalances[to] = _gonBalances[to].add(gonValue);
341         
342         emit Transfer(from, to, transferAmount);
343         
344         if(burnAmount > 0)
345             emit Transfer(from, address(0x0), burnAmount);
346     }
347     
348     function updateLive() external {
349         if(!_live) {
350             _live = true;
351         }
352     }
353     
354     function unblockWallet(address account) public onlyOwner {
355         blacklist[account] = false;
356     }
357     
358     function updatePercentForTxLimit(uint256 percentForTxLimit) public onlyOwner {
359         require(percentForTxLimit >= 1, 'ERC20: max tx limit should be greater than 1');
360         _percentForTxLimit = percentForTxLimit;
361     }
362 }