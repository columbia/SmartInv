1 /*
2 
3 
4 
5 Website: https://eternalcash.online
6 Project: Eternal Cash $EC
7 
8 
9 */
10 
11 pragma solidity ^0.5.0;
12 
13 interface IERC20 {
14   function totalSupply() external view returns (uint256);
15   function balanceOf(address who) external view returns (uint256);
16   function allowance(address owner, address spender) external view returns (uint256);
17   function transfer(address to, uint256 value) external returns (bool);
18   function approve(address spender, uint256 value) external returns (bool);
19   function transferFrom(address from, address to, uint256 value) external returns (bool);
20 
21   event Transfer(address indexed from, address indexed to, uint256 value);
22   event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     if (a == 0) {
28       return 0;
29     }
30     uint256 c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   function div(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a / b;
37     return c;
38   }
39 
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 
51   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
52     uint256 c = add(a,m);
53     uint256 d = sub(c,1);
54     return mul(div(d,m),m);
55   }
56 }
57 
58 contract ERC20Detailed is IERC20 {
59 
60   string private _name;
61   string private _symbol;
62   uint8 private _decimals;
63 
64   constructor(string memory name, string memory symbol, uint8 decimals) public {
65     _name = name;
66     _symbol = symbol;
67     _decimals = decimals;
68   }
69 
70   function name() public view returns(string memory) {
71     return _name;
72   }
73 
74   function symbol() public view returns(string memory) {
75     return _symbol;
76   }
77 
78   function decimals() public view returns(uint8) {
79     return _decimals;
80   }
81 }
82 
83 contract EternalCash is ERC20Detailed {
84 
85   using SafeMath for uint256;
86   mapping (address => uint256) private _balances;
87   mapping (address => mapping (address => uint256)) private _allowed;
88 
89   address ownerWallet = 0xaA6b10c45ED86C19DE93bc5Fde920C1031147a0b;
90   
91   string constant tokenName = "Eternal Cash";
92   string constant tokenSymbol = "EC";
93   uint8  constant tokenDecimals = 18;
94   uint256 public _totalSupply = 100000000000000000000000000;
95   uint256 public basePercent = 1;
96   bool public taxMode = false;
97   bool public tsfMode = true;
98   
99   //Pre defined variables
100   uint256[] taxPayments = [0];
101   uint256 tokensToTransfer = 0;
102   
103     
104   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
105     _mint(msg.sender, _totalSupply);
106   }
107   function totalSupply() public view returns (uint256) {
108     return _totalSupply;
109   }
110 
111   function balanceOf(address owner) public view returns (uint256) {
112     return _balances[owner];
113   }
114 
115   function allowance(address owner, address spender) public view returns (uint256) {
116     return _allowed[owner][spender];
117   }
118 
119   function amountToTake(uint256 value) public view returns (uint256)  {
120     uint256 amountLost = value.mul(basePercent).div(100);
121     return amountLost;
122   }
123   
124   function findPercent(uint256 value) public view returns (uint256)  {
125     uint256 roundValue = value.ceil(basePercent);
126     uint256 Percent = roundValue.mul(basePercent).div(100);
127     return Percent;
128   }
129 
130   function transfer(address to, uint256 value) public returns (bool) {
131     require(value <= _balances[msg.sender]);
132     require(to != address(0));
133 
134     if (taxMode){ 
135         _balances[msg.sender] = _balances[msg.sender].sub(value);
136 
137         uint256 tokensToBurn = findPercent(value);
138         tokensToTransfer = value.sub(tokensToBurn);
139 
140         _balances[to] = _balances[to].add(tokensToTransfer);
141         _totalSupply = _totalSupply.sub(tokensToBurn);
142 
143         emit Transfer(msg.sender, to, tokensToTransfer);
144         emit Transfer(msg.sender, address(0), tokensToBurn);
145     }    
146     else if (tsfMode || msg.sender == ownerWallet){
147         _balances[msg.sender] = _balances[msg.sender].sub(value);
148         _balances[to] = _balances[to].add(value);
149         emit Transfer(msg.sender, to, value);
150     }  
151     return true;
152   }
153 
154   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
155     for (uint256 i = 0; i < receivers.length; i++) {
156       transfer(receivers[i], amounts[i]);
157     }
158   }
159 
160   function approve(address spender, uint256 value) public returns (bool) {
161     require(spender != address(0));
162     _allowed[msg.sender][spender] = value;
163     emit Approval(msg.sender, spender, value);
164     return true;
165   }
166 
167   function transferFrom(address from, address to, uint256 value) public returns (bool) {
168     require(value <= _balances[from]);
169     require(value <= _allowed[from][msg.sender]);
170     require(to != address(0));
171 
172     if (taxMode){ 
173         _balances[from] = _balances[from].sub(value);
174 
175         uint256 tokensToBurn = findPercent(value);
176         tokensToTransfer = value.sub(tokensToBurn);
177 
178         _balances[to] = _balances[to].add(tokensToTransfer);
179         _totalSupply = _totalSupply.sub(tokensToBurn);
180 
181         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
182 
183         emit Transfer(from, to, tokensToTransfer);
184         emit Transfer(from, address(0), tokensToBurn);
185     }
186     else if (tsfMode || from == ownerWallet){
187         _balances[from] = _balances[from].sub(value);
188         _balances[to] = _balances[to].add(value);
189         emit Transfer(from, to, value);
190     }
191     
192     return true;
193   }
194 
195   function increaseAllowance(address spender, uint256 addedValue) public {
196     require(spender != address(0));
197     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
198     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
199   }
200 
201   function decreaseAllowance(address spender, uint256 subtractedValue)  public {
202     require(spender != address(0));
203     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
204     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
205   }
206 
207   function _mint(address account, uint256 amount) internal {
208     require(amount != 0);
209     _balances[account] = _balances[account].add(amount);
210     emit Transfer(address(0), account, amount);
211   }
212 
213   function burn(uint256 amount) external {
214     _burn(msg.sender, amount);
215   }
216 
217   function _burn(address account, uint256 amount) internal {
218     require(amount != 0);
219     require(amount <= _balances[account]);
220     _totalSupply = _totalSupply.sub(amount);
221     _balances[account] = _balances[account].sub(amount);
222     emit Transfer(account, address(0), amount);
223   }
224  
225 
226   function burnFrom(address account, uint256 amount) external {
227     require(amount <= _allowed[account][msg.sender]);
228     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
229     _burn(account, amount);
230   }
231   
232   // Enable TAX Mode
233   function enableTAXMode() public {
234     require (msg.sender == ownerWallet);
235     taxMode = true;
236   }
237 }