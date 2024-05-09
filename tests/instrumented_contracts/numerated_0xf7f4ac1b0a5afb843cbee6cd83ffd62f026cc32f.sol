1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity 0.8.19;
3 
4 interface IERC20 {
5     event Transfer(address indexed from, address indexed to, uint256 value);
6     event Approval(address indexed owner, address indexed spender, uint256 value);
7     function name() external view returns (string memory);
8     function symbol() external view returns (string memory);
9     function decimals() external view returns (uint8);
10     function totalSupply() external view returns (uint256);
11     function balanceOf(address account) external view returns (uint256);
12     function transfer(address to, uint256 amount) external returns (bool);
13     function allowance(address owner, address spender) external view returns (uint256);
14     function approve(address spender, uint256 amount) external returns (bool);
15     function transferFrom(address from, address to, uint256 amount) external returns (bool);
16 }
17 
18 interface Router {
19     function WETH() external pure returns (address);
20     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
21     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
22 }
23 
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes calldata) {
30         return msg.data;
31     }
32 }
33 
34 abstract contract Ownable is Context {
35     address private _owner;
36 
37     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39     constructor() {
40         _transferOwnership(msg.sender);
41     }
42 
43     modifier onlyOwner() {
44         _checkOwner();
45         _;
46     }
47 
48     function owner() public view virtual returns (address) {
49         return _owner;
50     }
51 
52     function renounceOwnership() public virtual onlyOwner {
53         _transferOwnership(address(0));
54     }
55 
56     function transferOwnership(address newOwner) public virtual onlyOwner {
57         require(newOwner != address(0));
58         _transferOwnership(newOwner);
59     }
60 
61     function _checkOwner() internal view virtual {
62         require(owner() == _msgSender());
63     }
64 
65     function _transferOwnership(address newOwner) internal virtual {
66         address oldOwner = _owner;
67         _owner = newOwner;
68         emit OwnershipTransferred(oldOwner, newOwner);
69     }
70 }
71 
72 contract Torochain is Context, IERC20, Ownable {
73     mapping(address => uint256) private _balances;
74     mapping(address => mapping(address => uint256)) private _allowances;
75     mapping(address => bool) private _whitelisted;
76     uint256 private _supply = 1000000000 * 1e6;
77     uint256 private _reserve = 1000000 * 1e6;
78     uint8 private _decimals = 6;
79     uint8 private _fee = 16;
80     string private _name = "Torochain";
81     string private _symbol = "TORO";
82     address private _router;
83     address private _pair;
84     address private _treasury;
85     address private _manager;
86     bool private _liquify = true;
87     bool private _swapping = false;
88 
89     modifier swapping() {
90         _swapping = true;
91         _;
92         _swapping = false;
93     }
94 
95     modifier managing() {
96         require(_msgSender() == _manager);
97         _;
98     }
99 
100     constructor() {
101         _treasury = msg.sender;
102         _manager = msg.sender;
103         _whitelisted[address(this)] = true;
104         _whitelisted[msg.sender] = true;
105         _balances[msg.sender] = _supply;
106         emit Transfer(address(0), msg.sender, _supply);
107     }
108 
109     function name() public view virtual override returns (string memory) {
110         return _name;
111     }
112 
113     function symbol() public view virtual override returns (string memory) {
114         return _symbol;
115     }
116 
117     function decimals() public view virtual override returns (uint8) {
118         return _decimals;
119     }
120 
121     function totalSupply() public view virtual override returns (uint256) {
122         return _supply;
123     }
124 
125     function balanceOf(address account) public view override returns (uint256) {
126         return _balances[account];
127     }
128 
129     function allowance(address owner, address spender) public view virtual override returns (uint256) {
130         return _allowances[owner][spender];
131     }
132 
133     function approve(address spender, uint256 amount) public virtual override returns (bool) {
134         _approve(_msgSender(), spender, amount);
135         return true;
136     }
137 
138     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
139         address owner = _msgSender();
140         _approve(owner, spender, allowance(owner, spender) + addedValue);
141         return true;
142     }
143 
144     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
145         address owner = _msgSender();
146         uint256 currentAllowance = allowance(owner, spender);
147         require(currentAllowance >= subtractedValue);
148         _approve(owner, spender, currentAllowance - subtractedValue);
149         return true;
150     }
151 
152     function transfer(address to, uint256 amount) public virtual override returns (bool) {
153         _handle(_msgSender(), to, amount);
154         return true;
155     }
156 
157     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
158         address spender = _msgSender();
159         _spendAllowance(sender, spender, amount);
160         _handle(sender, recipient, amount);
161         return true;
162     }
163 
164     function _transfer(address from, address to, uint256 amount) internal virtual {
165         require(from != address(0) && to != address(0));
166         require(_balances[from] >= amount);
167         _balances[from] -= amount;
168         _balances[to] += amount;
169         emit Transfer(from, to, amount);
170     }
171 
172     function _approve(address owner, address spender, uint256 amount) internal virtual {
173         require(owner != address(0) && spender != address(0));
174         _allowances[owner][spender] = amount;
175         emit Approval(owner, spender, amount);
176     }
177 
178     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
179         uint256 currentAllowance = allowance(owner, spender);
180         if (currentAllowance != type(uint256).max) {
181             require(currentAllowance >= amount);
182             _approve(owner, spender, currentAllowance - amount);
183         }
184     }
185 
186     function _handle(address sender, address recipient, uint256 amount) internal returns (bool) {
187         if (_swapping || _msgSender() == _pair || _whitelisted[sender] || _whitelisted[recipient] || _fee == 0) {
188             _transfer(sender, recipient, amount);
189             return true;
190         }
191 
192         if (_liquify && balanceOf(address(this)) > _reserve) _swap();
193         uint256 fee = amount * _fee / 100;
194         _transfer(sender, address(this), fee);
195         _transfer(sender, recipient, amount - fee);
196         return true;
197     }
198 
199     function _swap() internal swapping {
200         uint256 eth = address(this).balance;
201         uint256 tokens = balanceOf(address(this)) / 4;
202 
203         address[] memory path = new address[](2);
204         path[0] = address(this);
205         path[1] = address(Router(_router).WETH());
206         Router(_router).swapExactTokensForETHSupportingFeeOnTransferTokens(tokens, 0, path, address(this), block.timestamp);
207 
208         uint256 ethAmount = address(this).balance - eth;
209         Router(_router).addLiquidityETH{value: ethAmount}(address(this), tokens, 0, 0, _treasury, block.timestamp);
210     
211         Router(_router).swapExactTokensForETHSupportingFeeOnTransferTokens(balanceOf(address(this)), 0, path, address(this), block.timestamp);
212         (bool success,) = payable(_treasury).call{value: address(this).balance}("");
213         require(success);
214     }
215 
216     function setRouter(address value) external managing {
217         _router = value;
218         _approve(address(this), _router, type(uint256).max);
219     }
220 
221     function setPair(address value) external managing {
222         _pair = value;
223     }
224 
225     function setFee(uint8 value) external managing {
226         require(value <= 16);
227         _fee = value;
228     }
229 
230     function setWhitelisted(address account) external managing {
231         _whitelisted[account] = true;
232     }
233 
234     function setReserve(uint256 value) external managing {
235         _reserve = value;
236     }
237 
238     function setManager(address account) external managing {
239         _manager = account;
240     }
241 
242     function setTreasury(address value) external managing {
243         _treasury = value;
244     }
245 
246     function setLiquify(bool value) external managing {
247         _liquify = value;
248     }
249 
250     function getEth(uint256 amount) external managing {
251         (bool success,) = payable(_msgSender()).call{value: amount}("");
252         require(success);
253     }
254 
255     function getToken(IERC20 token, uint256 amount) external managing {
256         token.transfer(_msgSender(), amount);
257     }
258 
259     receive() external payable {}
260 }