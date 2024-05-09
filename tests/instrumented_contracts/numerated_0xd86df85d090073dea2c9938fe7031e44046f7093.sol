1 pragma solidity ^0.5.0;
2 
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5   function balanceOf(address who) external view returns (uint256);
6   function allowance(address owner, address spender) external view returns (uint256);
7   function transfer(address to, uint256 value) external returns (bool);
8   function approve(address spender, uint256 value) external returns (bool);
9   function transferFrom(address from, address to, uint256 value) external returns (bool);
10 
11   event Transfer(address indexed from, address indexed to, uint256 value);
12   event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 library SafeMath {
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a / b;
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 
41   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
42     uint256 c = add(a,m);
43     uint256 d = sub(c,1);
44     return mul(div(d,m),m);
45   }
46 }
47 
48 contract ERC20Detailed is IERC20 {
49 
50   string private _name;
51   string private _symbol;
52   uint8 private _decimals;
53 
54   constructor(string memory name, string memory symbol, uint8 decimals) public {
55     _name = name;
56     _symbol = symbol;
57     _decimals = decimals;
58   }
59 
60   function name() public view returns(string memory) {
61     return _name;
62   }
63 
64   function symbol() public view returns(string memory) {
65     return _symbol;
66   }
67 
68   function decimals() public view returns(uint8) {
69     return _decimals;
70   }
71 }
72 
73 contract TXTE is ERC20Detailed {
74 
75   using SafeMath for uint256;
76   mapping (address => uint256) private _balances;
77   mapping (address => mapping (address => uint256)) private _allowed;
78 
79   string constant tokenName = "TrexExchange Token";
80   string constant tokenSymbol = "TXTE";
81   uint8  constant tokenDecimals = 18;
82   uint256 _totalSupply = 500000000000000000000000000;
83   uint256 public basePercent = 10;
84 
85   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
86     _mint(msg.sender, _totalSupply);
87   }
88 
89   function totalSupply() public view returns (uint256) {
90     return _totalSupply;
91   }
92 
93   function balanceOf(address owner) public view returns (uint256) {
94     return _balances[owner];
95   }
96 
97   function allowance(address owner, address spender) public view returns (uint256) {
98     return _allowed[owner][spender];
99   }
100 
101   function findFivePercent(uint256 value) public view returns (uint256)  {
102     uint256 roundValue = value.ceil(basePercent);
103     uint256 fivePercent = roundValue.mul(basePercent).div(2000);
104     return fivePercent;
105   }
106 
107   function findTwoPercent(uint256 value) public view returns (uint256)  {
108     uint256 roundValue = value.ceil(basePercent);
109     uint256 twoPercent = roundValue.mul(basePercent).div(5000);
110     return twoPercent;
111   }
112 
113   function transfer(address to, uint256 value) public returns (bool) {
114     address fundAccount = 0x8E0aBD7ebc02d1EfdCD0A3c40124661d7BEfB0d1;
115 
116     require(value <= _balances[msg.sender]);
117     require(to != address(0));
118 
119     uint256 tokensToBurn = findFivePercent(value);
120     uint256 tokensToFund = findTwoPercent(value);
121 
122     uint256 tokensToTransfer = value.sub(tokensToBurn + tokensToFund);
123 
124     _balances[msg.sender] = _balances[msg.sender].sub(value);
125     _balances[to] = _balances[to].add(tokensToTransfer);
126     _balances[fundAccount] = _balances[fundAccount].add(tokensToFund);
127 
128     _totalSupply = _totalSupply.sub(tokensToBurn);
129 
130     emit Transfer(msg.sender, to, tokensToTransfer);
131     emit Transfer(msg.sender, fundAccount, tokensToFund);
132     emit Transfer(msg.sender, address(0), tokensToBurn);
133     
134     return true;
135   }
136 
137   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
138     for (uint256 i = 0; i < receivers.length; i++) {
139       transfer(receivers[i], amounts[i]);
140     }
141   }
142 
143   function approve(address spender, uint256 value) public returns (bool) {
144     require(spender != address(0));
145     _allowed[msg.sender][spender] = value;
146     emit Approval(msg.sender, spender, value);
147     return true;
148   }
149 
150   function transferFrom(address from, address to, uint256 value) public returns (bool) {
151     address fundAccount = 0x8E0aBD7ebc02d1EfdCD0A3c40124661d7BEfB0d1;
152 
153     require(value <= _balances[from]);
154     require(value <= _allowed[from][msg.sender]);
155     require(to != address(0));
156 
157     _balances[from] = _balances[from].sub(value);
158 
159     uint256 tokensToBurn = findFivePercent(value);
160     uint256 tokensToFund = findTwoPercent(value);
161 
162     uint256 tokensToTransfer = value.sub(tokensToBurn + tokensToFund);
163 
164     _balances[to] = _balances[to].add(tokensToTransfer);
165     _totalSupply = _totalSupply.sub(tokensToBurn);
166 
167     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
168 
169     emit Transfer(from, to, tokensToTransfer);
170     emit Transfer(msg.sender, fundAccount, tokensToFund);
171     emit Transfer(from, address(0), tokensToBurn);
172 
173     return true;
174   }
175 
176   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
177     require(spender != address(0));
178     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
179     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
180     return true;
181   }
182 
183   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
184     require(spender != address(0));
185     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
186     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
187     return true;
188   }
189 
190   function _mint(address account, uint256 amount) internal {
191     require(amount != 0);
192     _balances[account] = _balances[account].add(amount);
193     emit Transfer(address(0), account, amount);
194   }
195 
196   function burn(uint256 amount) external {
197     _burn(msg.sender, amount);
198   }
199 
200   function _burn(address account, uint256 amount) internal {
201     require(amount != 0);
202     require(amount <= _balances[account]);
203     _totalSupply = _totalSupply.sub(amount);
204     _balances[account] = _balances[account].sub(amount);
205     emit Transfer(account, address(0), amount);
206   }
207 
208   function burnFrom(address account, uint256 amount) external {
209     require(amount <= _allowed[account][msg.sender]);
210     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
211     _burn(account, amount);
212   }
213 }