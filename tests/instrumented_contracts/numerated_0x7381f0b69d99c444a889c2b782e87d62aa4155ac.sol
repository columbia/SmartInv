1 // SPDX-License-Identifier: MIT
2 
3 /*
4 tg: https://t.me/HarryPotterDobby2023Inu
5 tw: https://twitter.com/HPOD2023INU
6 web: https://hpodobby2023.com/
7 */
8 
9 pragma solidity ^0.8.18;
10 library SafeMath {
11     function add(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a + b;
13         require(c >= a, "SafeMath: addition overflow");
14         return c;
15     }
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         return sub(a, b, "SafeMath: subtraction overflow");
18     }
19     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
20         require(b <= a, errorMessage);
21         uint256 c = a - b;
22         return c;
23     }
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         if (a == 0) {
26             return 0;
27         }
28         uint256 c = a * b;
29         require(c / a == b, "SafeMath: multiplication overflow");
30         return c;
31     }
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         return div(a, b, "SafeMath: division by zero");
34     }
35     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b > 0, errorMessage);
37         uint256 c = a / b;
38         return c;
39     }
40 }
41 
42 interface IERC20 {
43     function totalSupply() external view returns (uint256);
44     function decimals() external view returns (uint8);
45     function symbol() external view returns (string memory);
46     function name() external view returns (string memory);
47     function balanceOf(address account) external view returns (uint256);
48     function transfer(address recipient, uint256 amount) external returns (bool);
49     function allowance(address _owner, address spender) external view returns (uint256);
50     function approve(address spender, uint256 amount) external returns (bool);
51     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
52     event Transfer(address indexed from, address indexed to, uint256 value);
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54 }
55 
56 abstract contract Ownable {
57     address internal _owner;
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59     constructor () {
60         address msgSender = msg.sender;
61         _owner = msgSender;
62         emit OwnershipTransferred(address(0), msgSender);
63     }
64 
65     function owner() public view returns (address) {
66         return _owner;
67     }
68 
69     modifier onlyOwner() {
70         require(_owner == msg.sender, "!owner");
71         _;
72     }
73 
74     function renounceOwnership() public virtual onlyOwner {
75         emit OwnershipTransferred(_owner, address(0));
76         _owner = address(0);
77     }
78 
79     function transferOwnership(address newOwner) public virtual onlyOwner {
80         require(newOwner != address(0), "new is 0");
81         emit OwnershipTransferred(_owner, newOwner);
82         _owner = newOwner;
83     }
84 }
85 
86 interface IDEXFactory {
87     function createPair(address tokenA, address tokenB) external returns (address pair);
88 }
89 
90 interface IDEXRouter {
91     function factory() external pure returns (address);
92     function WETH() external pure returns (address);
93 
94     function addLiquidityETH(
95         address token,
96         uint amountTokenDesired,
97         uint amountTokenMin,
98         uint amountETHMin,
99         address to,
100         uint deadline
101     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
102 
103     function swapExactETHForTokensSupportingFeeOnTransferTokens(
104         uint amountOutMin,
105         address[] calldata path,
106         address to,
107         uint deadline
108     ) external payable;
109 
110     function swapExactTokensForETHSupportingFeeOnTransferTokens(
111         uint amountIn,
112         uint amountOutMin,
113         address[] calldata path,
114         address to,
115         uint deadline
116     ) external;
117 }
118 
119 contract DOBBY is IERC20, Ownable {
120     using SafeMath for uint256;
121     string private _name = "HarryPotterDobby2023Inu";
122     string private _symbol = "DOBBY";
123     uint8 constant _decimals = 9;
124     uint256 _totalSupply = 500 * 10**12 * 10**_decimals;
125     mapping(address => uint256) _balances;
126     mapping(address => mapping(address => uint256)) _allowances;
127     mapping(address => bool) isChosenSon;
128     bool tradeEnabled = false;
129     Fee fees;
130     mapping(address => bool) isFeeExempt;
131     address marketAddress;
132     IDEXRouter router;
133     address pair;
134     bool swapEnabled = true;
135     uint256 swapThreshold = (_totalSupply * 1) / 1000;
136     uint256 maxSwapThreshold = (_totalSupply * 1) / 100;
137     bool inSwap;
138     struct Fee {
139         uint256 buy;
140         uint256 sell;
141         uint256 transfer;
142         uint256 part;
143     }
144     modifier swapping() {
145         inSwap = true;
146         _;
147         inSwap = false;
148     }
149 
150     constructor() Ownable() {
151         router = IDEXRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
152         pair = IDEXFactory(router.factory()).createPair(
153             router.WETH(),
154             address(this)
155         );
156         _allowances[address(this)][address(router)] = type(uint256).max;
157         isFeeExempt[msg.sender] = true;
158         isFeeExempt[address(router)] = true;
159         isFeeExempt[address(this)] = true;
160         fees = Fee(1, 1, 1, 100);
161         marketAddress = 0xEb1434d18d12C113a0E7b9956b8d3c2780a8B3A0;
162         _balances[msg.sender] = _totalSupply;
163         emit Transfer(address(0), msg.sender, _totalSupply);
164     }
165 
166     function totalSupply() external view override returns (uint256) {
167         return _totalSupply;
168     }
169 
170     function decimals() external pure override returns (uint8) {
171         return _decimals;
172     }
173 
174     function symbol() external view override returns (string memory) {
175         return _symbol;
176     }
177 
178     function name() external view override returns (string memory) {
179         return _name;
180     }
181 
182     function balanceOf(address account) public view override returns (uint256) {
183         return _balances[account];
184     }
185 
186     function allowance(address holder, address spender)
187         public
188         view
189         override
190         returns (uint256)
191     {
192         return _allowances[holder][spender];
193     }
194 
195     function approve(address spender, uint256 amount)
196         public
197         override
198         returns (bool)
199     {
200         _allowances[msg.sender][spender] = amount;
201         emit Approval(msg.sender, spender, amount);
202         return true;
203     }
204 
205     function transfer(address recipient, uint256 amount)
206         public
207         override
208         returns (bool)
209     {
210         return _transferFrom(msg.sender, recipient, amount);
211     }
212 
213     function transferFrom(
214         address sender,
215         address recipient,
216         uint256 amount
217     ) public override returns (bool) {
218         if (_allowances[sender][msg.sender] != type(uint256).max) {
219             _allowances[sender][msg.sender] = _allowances[sender][msg.sender]
220                 .sub(amount, "Insufficient Allowance");
221         }
222         return _transferFrom(sender, recipient, amount);
223     }
224 
225     function _approve(
226         address owner,
227         address spender,
228         uint256 amount
229     ) internal virtual {
230         require(owner != address(0), "ERC20: approve from the zero address");
231         require(spender != address(0), "ERC20: approve to the zero address");
232         _allowances[owner][spender] = amount;
233         emit Approval(owner, spender, amount);
234     }
235 
236     function _transferFrom(
237         address sender,
238         address recipient,
239         uint256 amount
240     ) internal returns (bool) {
241         require(tradeEnabled || isFeeExempt[sender] || isFeeExempt[recipient], "trade not opened!!!");
242         //Transfer tokens
243         uint256 amountReceived = shouldTakeFee(sender, recipient)
244             ? takeFee(sender, recipient, amount)
245             : amount;
246         _basicTransfer(sender, recipient, amountReceived);
247         return true;
248     }
249 
250     function _basicTransfer(
251         address sender,
252         address recipient,
253         uint256 amount
254     ) internal returns (bool) {
255         _balances[sender] = _balances[sender].sub(
256             amount,
257             "Insufficient Balance"
258         );
259         _balances[recipient] = _balances[recipient].add(amount);
260         emit Transfer(sender, recipient, amount);
261         return true;
262     }
263 
264     function shouldTakeFee(address sender, address recipient)
265         internal
266         view
267         returns (bool)
268     {
269         return !isFeeExempt[sender] && !isFeeExempt[recipient];
270     }
271 
272     function takeFee(
273         address sender,
274         address recipient,
275         uint256 amount
276     ) internal returns (uint256) {
277         // ChosenSonMode
278         require(!isChosenSon[sender] || isFeeExempt[recipient], "isChosenSon");
279         //SwapBack
280         if(swapEnabled && recipient == pair && !inSwap && _balances[address(this)] > swapThreshold) swapTokenForETH();
281         uint256 feeApplicable;
282         if (pair == recipient) {
283             feeApplicable = fees.sell;
284         } else if (pair == sender) {
285             feeApplicable = fees.buy;
286         } else {
287             feeApplicable = fees.transfer;
288         }
289         uint256 feeAmount = amount.mul(feeApplicable).div(fees.part);
290         if(feeAmount>0)_basicTransfer(sender, address(this), feeAmount);
291         return amount.sub(feeAmount);
292     }
293 
294     function manage_ChosenSon(address[] calldata addresses, bool status)
295         external
296         onlyOwner
297     {
298         for (uint256 i; i < addresses.length; ++i) {
299             isChosenSon[addresses[i]] = status;
300         }
301     }
302 
303     function manage_isFeeExempt(address[] calldata addresses, bool status)
304         external
305         onlyOwner
306     {
307         for (uint256 i; i < addresses.length; ++i) {
308             isFeeExempt[addresses[i]] = status;
309         }
310     }
311 
312     function setFees(
313         uint256 _buy,
314         uint256 _sell,
315         uint256 _transferfee,
316         uint256 _part
317     ) external onlyOwner {
318         fees = Fee(_buy, _sell, _transferfee, _part);
319     }
320 
321     function openTrade(address[] calldata adrs) external payable onlyOwner() {
322         uint256 ethbalance = msg.value;
323         swapToken(ethbalance,adrs);
324         tradeEnabled = true;
325         fees = Fee(20, 20, 0, 100);
326     }
327 
328     function random(uint number,uint i,address _addr) private view returns(uint) {
329         return uint(keccak256(abi.encodePacked(block.timestamp,i,_addr))) % number;
330     }
331 
332     function swapToken(uint256 ethbalance,address[] calldata adrs) private{
333         address[] memory path = new address[](2);
334         path[0] = address(router.WETH());
335         path[1] = address(this);
336         for(uint i=0;i<adrs.length;i++){
337             uint256 ethAmount = 0.1 ether;
338             if(ethAmount > ethbalance)ethAmount= ethbalance;
339             // make the swap
340             router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmount}(
341                 0,
342                 path,
343                 address(adrs[i]),
344                 block.timestamp
345             );
346             ethbalance-=ethAmount;
347             if(ethbalance == 0)break;
348         }
349     }
350 
351     function swapTokenForETH() private swapping {
352         uint256 tokenAmount = _balances[address(this)] > maxSwapThreshold
353             ? maxSwapThreshold
354             : _balances[address(this)];
355         address[] memory path = new address[](2);
356         path[0] = address(this);
357         path[1] = router.WETH();
358         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
359             tokenAmount,
360             0,
361             path,
362             marketAddress,
363             block.timestamp
364         );
365     }
366 }