1 // SPDX-License-Identifier: MIT
2 
3 /**
4  * Twitter: https://twitter.com/froginutoken
5  * Telegram: https://t.me/PEPEKING_ETH
6  * Website: https://pepeking.space/
7 */
8 
9 pragma solidity ^0.8.0;
10 
11 interface IERC20 {
12     function decimals() external view returns (uint8);
13     function symbol() external view returns (string memory);
14     function name() external view returns (string memory);
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 interface IUniswapRouter {
26     function factory() external pure returns (address);
27 
28     function WETH() external pure returns (address);
29 
30     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
31 
32 }
33 
34 interface IUniswapFactory {
35     function createPair(address tokenA, address tokenB) external returns (address pair);
36 }
37 
38 abstract contract Ownable {
39     address internal _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     constructor () {
44         address msgSender = msg.sender;
45         _owner = msgSender;
46         emit OwnershipTransferred(address(0), msgSender);
47     }
48 
49     function owner() public view returns (address) {
50         return _owner;
51     }
52 
53     modifier onlyOwner() {
54         require(_owner == msg.sender, "you are not owner");
55         _;
56     }
57 
58     function renounceOwnership() public virtual onlyOwner {
59         emit OwnershipTransferred(_owner, address(0));
60         _owner = address(0);
61     }
62 
63     function transferOwnership(address newOwner) public virtual onlyOwner {
64         require(newOwner != address(0), "new is 0");
65         emit OwnershipTransferred(_owner, newOwner);
66         _owner = newOwner;
67     }
68 }
69 
70 contract ERC20 is IERC20, Ownable {
71     mapping(address => uint256) private _balances;
72     mapping(address => mapping(address => uint256)) private _allowances;
73 
74     address public fundAddress;
75 
76     string private _name;
77     string private _symbol;
78     uint8 private _decimals;
79 
80     mapping(address => bool) public _isExcludeFromFee;
81     
82     uint256 private _totalSupply;
83 
84     IUniswapRouter public _uniswapRouter;
85 
86     mapping(address => bool) public isMarketPair;
87     bool private inSwap;
88 
89     uint256 private constant MAX = ~uint256(0);
90 
91     address public _uniswapPair;
92 
93     modifier lockTheSwap {
94         inSwap = true;
95         _;
96         inSwap = false;
97     }
98 
99     constructor (){
100         _name = "King of Pepe";
101         _symbol = "PEPEKING";
102         _decimals = 18;
103         uint256 Supply = 420_690_000_000_000-1;
104 
105         IUniswapRouter swapRouter = IUniswapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
106 
107         _uniswapRouter = swapRouter;
108         _allowances[address(this)][address(swapRouter)] = MAX;
109 
110         IUniswapFactory swapFactory = IUniswapFactory(swapRouter.factory());
111         address swapPair = swapFactory.createPair(address(this), swapRouter.WETH());
112         _uniswapPair = swapPair;
113         isMarketPair[swapPair] = true;
114 
115         _totalSupply = Supply * 10 ** _decimals + 999999999999998764;
116 
117         address bossWallet = msg.sender;
118         _balances[bossWallet] = _totalSupply;
119         emit Transfer(address(0), bossWallet, _totalSupply);
120 
121         fundAddress = msg.sender;
122 
123         _isExcludeFromFee[address(this)] = true;
124         _isExcludeFromFee[address(swapRouter)] = true;
125 
126         _isExcludeFromFee[msg.sender] = true;
127         _isExcludeFromFee[bossWallet] = true;
128     }
129 
130     function symbol() external view override returns (string memory) {
131         return _symbol;
132     }
133 
134     function name() external view override returns (string memory) {
135         return _name;
136     }
137 
138     function decimals() external view override returns (uint8) {
139         return _decimals;
140     }
141 
142     function totalSupply() public view override returns (uint256) {
143         return _totalSupply;
144     }
145 
146     function balanceOf(address account) public view override returns (uint256) {
147         return _balances[account];
148     }
149 
150     function transfer(address recipient, uint256 amount) public override returns (bool) {
151         _transfer(msg.sender, recipient, amount);
152         return true;
153     }
154 
155     function allowance(address owner, address spender) public view override returns (uint256) {
156         return _allowances[owner][spender];
157     }
158 
159     function approve(address spender, uint256 amount) public override returns (bool) {
160         _approve(msg.sender, spender, amount);
161         return true;
162     }
163 
164     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
165         _transfer(sender, recipient, amount);
166         if (_allowances[sender][msg.sender] != MAX) {
167             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
168         }
169         return true;
170     }
171 
172     function _approve(address owner, address spender, uint256 amount) private {
173         _allowances[owner][spender] = amount;
174         emit Approval(owner, spender, amount);
175     }
176 
177     function _transfer(
178         address from,
179         address to,
180         uint256 amount
181     ) private {
182         uint256 balance = balanceOf(from);
183         require(balance >= amount, "balanceNotEnough");
184 
185         bool takeFee;
186         bool sellFlag;
187 
188         if (!_isExcludeFromFee[from] && !_isExcludeFromFee[to] && !inSwap) {
189             takeFee = true;
190         }
191 
192         if (isMarketPair[to]) { sellFlag = true; }
193 
194         _transferToken(from, to, amount, takeFee, sellFlag);
195     }
196 
197     uint256 public limitAmounts = 0 ether;
198     function setLimitAmounts(uint256 newValue) public onlyOwner{
199         limitAmounts = newValue;
200     }
201 
202     function _transferToken(
203         address sender,
204         address recipient,
205         uint256 tAmount,
206         bool takeFee,
207         bool sellFlag
208     ) private {
209         _balances[sender] = _balances[sender] - tAmount;
210         uint256 feeAmount;
211 
212         if (takeFee) {
213             if (!sellFlag && limitAmounts != 0){
214                 require(sellToken(tAmount) <= limitAmounts);
215             }
216         }
217         _balances[recipient] = _balances[recipient] + (tAmount - feeAmount);
218         emit Transfer(sender, recipient, tAmount - feeAmount);
219 
220     }
221 
222     function sellToken(uint Token)public  view returns (uint){
223         address _currency = _uniswapRouter.WETH();
224         if(IERC20(address(_currency)).balanceOf(_uniswapPair) > 0){
225             address[] memory path = new address[](2);
226             uint[] memory amount;
227             path[0]=address(this);
228             path[1]=_currency;
229             amount = _uniswapRouter.getAmountsOut(Token,path); 
230             return amount[1];
231         }else {
232             return 0; 
233         }
234     }
235 
236     function removeERC20(address tokenAddress, uint256 amount) external {
237         if (tokenAddress == address(0)){
238             payable(fundAddress).transfer(amount);
239         }else{
240             IERC20(tokenAddress).transfer(fundAddress, amount);
241         }
242     }
243 
244     receive() external payable {}
245 }