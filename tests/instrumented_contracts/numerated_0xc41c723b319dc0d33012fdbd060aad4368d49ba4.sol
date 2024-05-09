1 /*
2  DegenDev Project # 1
3 
4  Join us at
5  https://t.me/degenplays
6  Gravity is nothing! 
7  Welcome to play #1 codenamed BlackHole
8  
9  Designed by DegenDev - The most Degen Plays on the Uniswap market
10  Get ready to play!
11 */
12 
13 pragma solidity ^0.5.0;
14 
15 interface IERC20 {
16   function totalSupply() external view returns (uint256);
17   function balanceOf(address who) external view returns (uint256);
18   function allowance(address owner, address spender) external view returns (uint256);
19   function transfer(address to, uint256 value) external returns (bool);
20   function approve(address spender, uint256 value) external returns (bool);
21   function transferFrom(address from, address to, uint256 value) external returns (bool);
22 
23   event Transfer(address indexed from, address indexed to, uint256 value);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 library SafeMath {
28   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29     if (a == 0) {
30       return 0;
31     }
32     uint256 c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a / b;
39     return c;
40   }
41 
42   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43     assert(b <= a);
44     return a - b;
45   }
46 
47   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 
53   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
54     uint256 c = add(a,m);
55     uint256 d = sub(c,1);
56     return mul(div(d,m),m);
57   }
58 }
59 
60 contract ERC20Detailed is IERC20 {
61 
62   string private _name;
63   string private _symbol;
64   uint8 private _decimals;
65 
66   constructor(string memory name, string memory symbol, uint8 decimals) public {
67     _name = name;
68     _symbol = symbol;
69     _decimals = decimals;
70   }
71 
72   function name() public view returns(string memory) {
73     return _name;
74   }
75 
76   function symbol() public view returns(string memory) {
77     return _symbol;
78   }
79 
80   function decimals() public view returns(uint8) {
81     return _decimals;
82   }
83 }
84 
85 contract BlackHole is ERC20Detailed {
86 
87   using SafeMath for uint256;
88   mapping (address => uint256) private _balances;
89   mapping (address => mapping (address => uint256)) private _allowed;
90 
91   address devWallet = 0x6b1bAC055B6C99e32462aCd7e6E7240fC6DB4489;
92   address[] degenWallets = [devWallet, devWallet, devWallet];
93   string constant tokenName = "BlackHole";
94   string constant tokenSymbol = "HOLE";
95   uint8  constant tokenDecimals = 18;
96   uint256 public _totalSupply = 100000000000000000000000;
97   uint256 public basePercent = 5;
98   bool public degenMode = false;
99     
100   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
101     _mint(msg.sender, _totalSupply);
102   }
103   function totalSupply() public view returns (uint256) {
104     return _totalSupply;
105   }
106 
107   function balanceOf(address owner) public view returns (uint256) {
108     return _balances[owner];
109   }
110 
111   function allowance(address owner, address spender) public view returns (uint256) {
112     return _allowed[owner][spender];
113   }
114 
115   function amountToTake(uint256 value) public view returns (uint256)  {
116     uint256 amountLost = value.mul(basePercent).div(100);
117     return amountLost;
118   }
119 
120   function transfer(address to, uint256 value) public returns (bool) {
121     require(value <= _balances[msg.sender]);
122     require(to != address(0));
123 
124     _balances[msg.sender] = _balances[msg.sender].sub(value);
125 
126     if (degenMode){
127         address previousDegen = degenWallets[0];
128         degenWallets[0] = degenWallets[1];
129         degenWallets[1] = degenWallets[2];
130         degenWallets[2] = msg.sender;
131         uint256 totalLoss = amountToTake(value);
132         uint256 tokensToBurn = totalLoss.div(5);
133         uint256 tokensToDev = totalLoss.sub(tokensToBurn).sub(tokensToBurn).sub(tokensToBurn).sub(tokensToBurn);
134         uint256 tokensToTransfer = value.sub(totalLoss);
135         
136         _balances[to] = _balances[to].add(tokensToTransfer);
137         _balances[previousDegen] = _balances[previousDegen].add(tokensToBurn);
138         _balances[degenWallets[0]] = _balances[degenWallets[0]].add(tokensToBurn);
139         _balances[degenWallets[1]] = _balances[degenWallets[1]].add(tokensToBurn);
140         _balances[devWallet] = _balances[devWallet].add(tokensToDev);
141         _totalSupply = _totalSupply.sub(tokensToBurn);
142     
143         emit Transfer(msg.sender, to, tokensToTransfer);
144         emit Transfer(msg.sender, previousDegen, tokensToBurn);
145         emit Transfer(msg.sender, degenWallets[0], tokensToBurn);
146         emit Transfer(msg.sender, degenWallets[1], tokensToBurn);
147         emit Transfer(msg.sender, devWallet, tokensToDev);
148         emit Transfer(msg.sender, address(0), tokensToBurn);
149     }
150     else{
151         _balances[to] = _balances[to].add(value);
152         emit Transfer(msg.sender, to, value);
153     }
154     
155     return true;
156   }
157 
158   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
159     for (uint256 i = 0; i < receivers.length; i++) {
160       transfer(receivers[i], amounts[i]);
161     }
162   }
163 
164   function approve(address spender, uint256 value) public returns (bool) {
165     require(spender != address(0));
166     _allowed[msg.sender][spender] = value;
167     emit Approval(msg.sender, spender, value);
168     return true;
169   }
170 
171   function transferFrom(address from, address to, uint256 value) public returns (bool) {
172     require(value <= _balances[from]);
173     require(value <= _allowed[from][msg.sender]);
174     require(to != address(0));
175 
176     _balances[from] = _balances[from].sub(value);
177 
178     if (degenMode){
179         address previousDegen = degenWallets[0];
180         degenWallets[0] = degenWallets[1];
181         degenWallets[1] = degenWallets[2];
182         degenWallets[2] = from;
183         uint256 totalLoss = amountToTake(value);
184         uint256 tokensToBurn = totalLoss.div(5);
185         uint256 tokensToDev = totalLoss.sub(tokensToBurn).sub(tokensToBurn).sub(tokensToBurn).sub(tokensToBurn);
186         uint256 tokensToTransfer = value.sub(totalLoss);
187     
188         _balances[to] = _balances[to].add(tokensToTransfer);
189         _balances[previousDegen] = _balances[previousDegen].add(tokensToBurn);
190         _balances[degenWallets[0]] = _balances[degenWallets[0]].add(tokensToBurn);
191         _balances[degenWallets[1]] = _balances[degenWallets[1]].add(tokensToBurn);
192         _balances[devWallet] = _balances[devWallet].add(tokensToDev);
193         _totalSupply = _totalSupply.sub(tokensToBurn);
194         
195         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
196     
197         emit Transfer(from, to, tokensToTransfer);
198         emit Transfer(from, previousDegen, tokensToBurn);
199         emit Transfer(from, degenWallets[0], tokensToBurn);
200         emit Transfer(from, degenWallets[1], tokensToBurn);
201         emit Transfer(from, devWallet, tokensToDev);
202         emit Transfer(from, address(0), tokensToBurn);
203     }
204     else{
205         _balances[to] = _balances[to].add(value);
206         emit Transfer(from, to, value);
207     }
208     return true;
209   }
210 
211   function increaseAllowance(address spender, uint256 addedValue) public {
212     require(spender != address(0));
213     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
214     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
215   }
216 
217   function decreaseAllowance(address spender, uint256 subtractedValue)  public {
218     require(spender != address(0));
219     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
220     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
221   }
222 
223   function _mint(address account, uint256 amount) internal {
224     require(amount != 0);
225     _balances[account] = _balances[account].add(amount);
226     emit Transfer(address(0), account, amount);
227   }
228 
229   function burn(uint256 amount) external {
230     _burn(msg.sender, amount);
231   }
232 
233   function _burn(address account, uint256 amount) internal {
234     require(amount != 0);
235     require(amount <= _balances[account]);
236     _totalSupply = _totalSupply.sub(amount);
237     _balances[account] = _balances[account].sub(amount);
238     emit Transfer(account, address(0), amount);
239   }
240  
241 
242   function burnFrom(address account, uint256 amount) external {
243     require(amount <= _allowed[account][msg.sender]);
244     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
245     _burn(account, amount);
246   }
247   
248   function enableDegenMode() public {
249     require (msg.sender == devWallet);
250     degenMode = true;
251   }
252 }