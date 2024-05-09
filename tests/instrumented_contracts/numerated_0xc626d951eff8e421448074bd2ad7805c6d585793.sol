1 /**
2 
3                                       
4                       TIGER KING
5     https://t.me/theOfficialTigerKing
6 
7   https://www.tiger-king.org
8 
9 */
10 
11 
12 // SPDX-License-Identifier: Unlicensed
13 pragma solidity ^0.5.0;
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
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
85 contract TigerKing is ERC20Detailed {
86 
87   using SafeMath for uint256;
88   mapping (address => uint256) private _balances;
89   mapping (address => mapping (address => uint256)) private _allowed;
90 
91   string constant tokenName = "Tiger King";
92   string constant tokenSymbol = "TKING";
93   uint8  constant tokenDecimals = 18;
94   uint256 _totalSupply = 1000000000000 *10**18;
95   uint256 public basePercent = 100;
96   uint256 public _burnStopAmount;
97   uint256 public _lastTokenSupply;
98   
99   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
100 
101     _mint(msg.sender, _totalSupply);
102     _burnStopAmount = 0;
103     _lastTokenSupply = 200000 * 10**18;
104   }
105 
106   function totalSupply() public view returns (uint256) {
107     return _totalSupply;
108   }
109 
110   function balanceOf(address owner) public view returns (uint256) {
111     return _balances[owner];
112   }
113 
114   function allowance(address owner, address spender) public view returns (uint256) {
115     return _allowed[owner][spender];
116   }
117 
118   function findOnePercent(uint256 value) public view returns (uint256)  {
119     uint256 roundValue = value.ceil(basePercent);
120     uint256 onePercent = roundValue.mul(basePercent).div(10000);
121     return onePercent;
122   }
123 
124   function transfer(address to, uint256 value) public returns (bool) {
125     require(value <= _balances[msg.sender]);
126     require(to != address(0));
127 
128     uint256 tokensToBurn = findOnePercent(value);
129     uint256 tokensToTransfer = value.sub(tokensToBurn);
130 
131     _balances[msg.sender] = _balances[msg.sender].sub(value);
132     _balances[to] = _balances[to].add(tokensToTransfer);
133 
134     _totalSupply = _totalSupply.sub(tokensToBurn);
135 
136     emit Transfer(msg.sender, to, tokensToTransfer);
137     emit Transfer(msg.sender, address(0), tokensToBurn);
138     return true;
139   }
140 
141   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
142     for (uint256 i = 0; i < receivers.length; i++) {
143       transfer(receivers[i], amounts[i]);
144     }
145   }
146 
147   function approve(address spender, uint256 value) public returns (bool) {
148     require(spender != address(0));
149     _allowed[msg.sender][spender] = value;
150     emit Approval(msg.sender, spender, value);
151     return true;
152   }
153 
154   function transferFrom(address from, address to, uint256 value) public returns (bool) {
155     require(value <= _balances[from]);
156     require(value <= _allowed[from][msg.sender]);
157     require(to != address(0));
158 
159     _balances[from] = _balances[from].sub(value);
160 
161     uint256 tokensToBurn = findOnePercent(value);
162     uint256 tokensToTransfer = value.sub(tokensToBurn);
163 
164     _balances[to] = _balances[to].add(tokensToTransfer);
165     _totalSupply = _totalSupply.sub(tokensToBurn);
166 
167     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
168 
169     emit Transfer(from, to, tokensToTransfer);
170     emit Transfer(from, address(0), tokensToBurn);
171 
172     return true;
173   }
174 
175   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
176     require(spender != address(0));
177     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
178     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
179     return true;
180   }
181 
182   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
183     require(spender != address(0));
184     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
185     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
186     return true;
187   }
188 
189   function _mint(address account, uint256 amount) internal {
190     require(amount != 0);
191     _balances[account] = _balances[account].add(amount);
192     emit Transfer(address(0), account, amount);
193   }
194 
195   function burn(uint256 amount) external {
196     _burn(msg.sender, amount);
197   }
198   function _burn(address account, uint256 amount) internal {
199     require(amount != 0);
200     require(amount <= _balances[account]);
201     _totalSupply = _totalSupply.sub(amount);
202     _balances[account] = _balances[account].sub(amount);
203     emit Transfer(account, address(0), amount);
204   }
205 
206   function burnFrom(address account, uint256 amount) external {
207     require(amount <= _allowed[account][msg.sender]);
208     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
209     _burn(account, amount);
210   }
211 }