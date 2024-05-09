1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.12;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         this;
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(
22         address sender,
23         address recipient,
24         uint256 amount
25     ) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 interface IERC20Metadata is IERC20 {
31     function name() external view returns (string memory);
32     function symbol() external view returns (string memory);
33     function decimals() external view returns (uint8);
34 }
35 
36 contract ERC20 is Context, IERC20, IERC20Metadata {
37     mapping(address => uint256) private _balances;
38     mapping(address => mapping(address => uint256)) private _allowances;
39     uint256 private _totalSupply;
40     string private _name;
41     string private _symbol;
42 
43     constructor(string memory name_, string memory symbol_) {
44         _name = name_;
45         _symbol = symbol_;
46     }
47 
48     function name() public view virtual override returns (string memory) {
49         return _name;
50     }
51 
52     function symbol() public view virtual override returns (string memory) {
53         return _symbol;
54     }
55 
56     function decimals() public view virtual override returns (uint8) {
57         return 18;
58     }
59 
60     function totalSupply() public view virtual override returns (uint256) {
61         return _totalSupply;
62     }
63 
64     function balanceOf(address account) public view virtual override returns (uint256) {
65         return _balances[account];
66     }
67 
68     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
69         _transfer(_msgSender(), recipient, amount);
70         return true;
71     }
72 
73     function allowance(address owner, address spender) public view virtual override returns (uint256) {
74         return _allowances[owner][spender];
75     }
76 
77     function approve(address spender, uint256 amount) public virtual override returns (bool) {
78         _approve(_msgSender(), spender, amount);
79         return true;
80     }
81 
82     function transferFrom(
83         address sender,
84         address recipient,
85         uint256 amount
86     ) public virtual override returns (bool) {
87         _transfer(sender, recipient, amount);
88 
89         uint256 currentAllowance = _allowances[sender][_msgSender()];
90         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
91     unchecked {
92         _approve(sender, _msgSender(), currentAllowance - amount);
93     }
94 
95         return true;
96     }
97 
98     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
99         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
100         return true;
101     }
102 
103     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
104         uint256 currentAllowance = _allowances[_msgSender()][spender];
105         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
106     unchecked {
107         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
108     }
109 
110         return true;
111     }
112 
113     function _transfer(
114         address sender,
115         address recipient,
116         uint256 amount
117     ) internal virtual {
118         require(sender != address(0), "ERC20: transfer from the zero address");
119         require(recipient != address(0), "ERC20: transfer to the zero address");
120 
121         uint256 senderBalance = _balances[sender];
122         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
123     unchecked {
124         _balances[sender] = senderBalance - amount;
125     }
126         _balances[recipient] += amount;
127 
128         emit Transfer(sender, recipient, amount);
129     }
130 
131     function _createInitialSupply(address account, uint256 amount) internal virtual {
132         require(account != address(0), "ERC20: mint to the zero address");
133 
134         _totalSupply += amount;
135         _balances[account] += amount;
136         emit Transfer(address(0), account, amount);
137     }
138 
139     function _approve(
140         address owner,
141         address spender,
142         uint256 amount
143     ) internal virtual {
144         require(owner != address(0), "ERC20: approve from the zero address");
145         require(spender != address(0), "ERC20: approve to the zero address");
146 
147         _allowances[owner][spender] = amount;
148         emit Approval(owner, spender, amount);
149     }
150 }
151 
152 contract Ownable is Context {
153     address private _owner;
154 
155     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
156 
157     constructor () {
158         address msgSender = _msgSender();
159         _owner = msgSender;
160         emit OwnershipTransferred(address(0), msgSender);
161     }
162 
163     function owner() public view returns (address) {
164         return _owner;
165     }
166 
167     modifier onlyOwner() {
168         require(_owner == _msgSender(), "Ownable: caller is not the owner");
169         _;
170     }
171 
172     function renounceOwnership() external virtual onlyOwner {
173         emit OwnershipTransferred(_owner, address(0));
174         _owner = address(0);
175     }
176 
177     function transferOwnership(address newOwner) public virtual onlyOwner {
178         require(newOwner != address(0), "Ownable: new owner is the zero address");
179         emit OwnershipTransferred(_owner, newOwner);
180         _owner = newOwner;
181     }
182 }
183 
184 interface IDexRouter {
185     function factory() external pure returns (address);
186     function WETH() external pure returns (address);
187 
188     function swapExactTokensForETHSupportingFeeOnTransferTokens(
189         uint amountIn,
190         uint amountOutMin,
191         address[] calldata path,
192         address to,
193         uint deadline
194     ) external;
195 
196     function addLiquidityETH(
197         address token,
198         uint256 amountTokenDesired,
199         uint256 amountTokenMin,
200         uint256 amountETHMin,
201         address to,
202         uint256 deadline
203     )
204     external
205     payable
206     returns (
207         uint256 amountToken,
208         uint256 amountETH,
209         uint256 liquidity
210     );
211 }
212 
213 interface IDexFactory {
214     function createPair(address tokenA, address tokenB)
215     external
216     returns (address pair);
217 }
218 
219 contract RYSUKA is ERC20, Ownable {
220     event TransferForeignToken(address token, uint256 amount);
221     constructor() ERC20("Rysuka", "RYSUKA") {
222         uint256 totalSupply = 666666666666666 * 1e18;
223         _createInitialSupply(msg.sender, totalSupply);
224         transferOwnership(msg.sender);
225     }
226     function transferForeignToken(address _token, address _to) external onlyOwner returns (bool _sent) {
227         require(_token != address(0), "_token address cannot be 0");
228         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
229         _sent = IERC20(_token).transfer(_to, _contractBalance);
230         emit TransferForeignToken(_token, _contractBalance);
231     }
232     // withdraw ETH if stuck or someone sends to the address
233     function withdrawStuckETH() external onlyOwner {
234         bool success;
235         (success,) = address(msg.sender).call{value: address(this).balance}("");
236     }
237 }