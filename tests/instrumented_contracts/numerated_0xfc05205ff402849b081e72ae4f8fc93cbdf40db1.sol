1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-27
3 */
4 
5 /*
6 ***      https://lelouchlamperouge.org/     ***
7 ***      https://t.me/leloucherc            ***
8 */
9 
10 //SPDX-License-Identifier: Mines™®©
11 pragma solidity ^0.8.4;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21 
22     function balanceOf(address account) external view returns (uint256);
23 
24     function transfer(address recipient, uint256 amount)
25         external
26         returns (bool);
27 
28     function allowance(address owner, address spender)
29         external
30         view
31         returns (uint256);
32 
33     function approve(address spender, uint256 amount) external returns (bool);
34 
35     function transferFrom(
36         address sender,
37         address recipient,
38         uint256 amount
39     ) external returns (bool);
40 
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(
43         address indexed owner,
44         address indexed spender,
45         uint256 value
46     );
47 }
48 
49 library SafeMath {
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a, "SafeMath: addition overflow");
53         return c;
54     }
55 
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         return sub(a, b, "SafeMath: subtraction overflow");
58     }
59 
60     function sub(
61         uint256 a,
62         uint256 b,
63         string memory errorMessage
64     ) internal pure returns (uint256) {
65         require(b <= a, errorMessage);
66         uint256 c = a - b;
67         return c;
68     }
69 
70     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
71         if (a == 0) {
72             return 0;
73         }
74         uint256 c = a * b;
75         require(c / a == b, "SafeMath: multiplication overflow");
76         return c;
77     }
78 
79     function div(uint256 a, uint256 b) internal pure returns (uint256) {
80         return div(a, b, "SafeMath: division by zero");
81     }
82 
83     function div(
84         uint256 a,
85         uint256 b,
86         string memory errorMessage
87     ) internal pure returns (uint256) {
88         require(b > 0, errorMessage);
89         uint256 c = a / b;
90         return c;
91     }
92 }
93 
94 contract Ownable is Context {
95     address private _owner;
96     address private _previousOwner;
97     event OwnershipTransferred(
98         address indexed previousOwner,
99         address indexed newOwner
100     );
101 
102     constructor() {
103         address msgSender = _msgSender();
104         _owner = msgSender;
105         emit OwnershipTransferred(address(0), msgSender);
106     }
107 
108     function owner() public view returns (address) {
109         return _owner;
110     }
111 
112     modifier onlyOwner() {
113         require(_owner == _msgSender(), "Ownable: caller is not the owner");
114         _;
115     }
116 
117     function renounceOwnership() public virtual onlyOwner {
118         emit OwnershipTransferred(_owner, address(0));
119         _owner = address(0);
120     }
121 }
122 
123 interface IUniswapV2Factory {
124     function createPair(address tokenA, address tokenB)
125         external
126         returns (address pair);
127 }
128 
129 interface IUniswapV2Router02 {
130     function swapExactTokensForETHSupportingFeeOnTransferTokens(
131         uint256 amountIn,
132         uint256 amountOutMin,
133         address[] calldata path,
134         address to,
135         uint256 deadline
136     ) external;
137 
138     function factory() external pure returns (address);
139 
140     function WETH() external pure returns (address);
141 
142     function addLiquidityETH(
143         address token,
144         uint256 amountTokenDesired,
145         uint256 amountTokenMin,
146         uint256 amountETHMin,
147         address to,
148         uint256 deadline
149     )
150         external
151         payable
152         returns (
153             uint256 amountToken,
154             uint256 amountETH,
155             uint256 liquidity
156         );
157 }
158 
159 contract Lelouch is Context, IERC20, Ownable {
160     using SafeMath for uint256;
161     string private constant _name = "Lelouch Lamperouge";
162     string private constant _symbol = "Lelouch";
163     uint8 private constant _decimals = 9;
164     mapping(address => uint256) private _balance;
165     mapping(address => mapping(address => uint256)) private _allowances;
166     uint256 private constant _vTotal = 1000000000 * 10**9;
167     IUniswapV2Router02 private uniswapV2Router;
168     address private uniswapV2Pair;
169     bool private swapEnabled = false;
170     mapping (address => bool) private bots;
171 
172 
173     constructor() {
174         _balance[address(this)] = _vTotal;
175         emit Transfer(address(0), address(this), _vTotal);
176 
177     }
178 
179     function name() public pure returns (string memory) {
180         return _name;
181     }
182 
183     function symbol() public pure returns (string memory) {
184         return _symbol;
185     }
186 
187     function decimals() public pure returns (uint8) {
188         return _decimals;
189     }
190 
191     function totalSupply() public pure override returns (uint256) {
192         return _vTotal;
193     }
194 
195     function balanceOf(address account) public view override returns (uint256) {
196         return _balance[account];
197     }
198 
199     function transfer(address recipient, uint256 amount)
200         public
201         override
202         returns (bool)
203     {
204         _transfer(_msgSender(), recipient, amount);
205         return true;
206     }
207 
208     function allowance(address owner, address spender)
209         public
210         view
211         override
212         returns (uint256)
213     {
214         return _allowances[owner][spender];
215     }
216 
217     function approve(address spender, uint256 amount)
218         public
219         override
220         returns (bool)
221     {
222         _approve(_msgSender(), spender, amount);
223         return true;
224     }
225 
226     function transferFrom(
227         address sender,
228         address recipient,
229         uint256 amount
230     ) public override returns (bool) {
231         _transfer(sender, recipient, amount);
232         _approve(
233             sender,
234             _msgSender(),
235             _allowances[sender][_msgSender()].sub(
236                 amount,
237                 "ERC20: transfer amount exceeds allowance"
238             )
239         );
240         return true;
241     }
242 
243 
244     function _approve(
245         address owner,
246         address spender,
247         uint256 amount
248     ) private {
249         require(owner != address(0), "ERC20: approve from the zero address");
250         require(spender != address(0), "ERC20: approve to the zero address");
251         _allowances[owner][spender] = amount;
252         emit Approval(owner, spender, amount);
253     }
254 
255     function _transfer(
256         address from,
257         address to,
258         uint256 amount
259     ) private {
260         require(from != address(0), "ERC20: transfer from the zero address");
261         require(to != address(0), "ERC20: transfer to the zero address");
262         require(amount > 0, "Transfer amount must be greater than zero");
263         require(!bots[from], "Blacklisted Address.");
264         require(!bots[to], "Blacklisted Address.");
265 
266 
267         _tokenTransfer(from, to, amount);
268         
269     }
270 
271 
272     function addLiquidity() external onlyOwner() {
273         IUniswapV2Router02 _uniswapV2Router =
274             IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
275         uniswapV2Router = _uniswapV2Router;
276         _approve(address(this), address(uniswapV2Router), _vTotal);
277         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
278             .createPair(address(this), _uniswapV2Router.WETH());
279         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
280             address(this),
281             balanceOf(address(this)),
282             0,
283             0,
284             owner(),
285             block.timestamp
286         );
287         swapEnabled = true;
288         IERC20(uniswapV2Pair).approve(
289             address(uniswapV2Router),
290             type(uint256).max
291         );
292     }
293 
294     function _tokenTransfer(
295         address sender,
296         address recipient,
297         uint256 sendAmount
298     ) private {
299         _balance[sender] = _balance[sender].sub(sendAmount);
300         _balance[recipient] = _balance[recipient].add(sendAmount);
301         emit Transfer(sender, recipient, sendAmount);
302     }
303 
304 
305     function setBots(address[] memory bots_) public onlyOwner {
306         for (uint i = 0; i < bots_.length; i++) {
307             bots[bots_[i]] = true;
308         }
309     }
310     
311     function delBot(address notbot) public onlyOwner {
312         bots[notbot] = false;
313     }
314     
315     receive() external payable {}
316 
317 }