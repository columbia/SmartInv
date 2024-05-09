1 pragma solidity ^0.5.0;
2 
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5   function balanceOf(address who) external view returns (uint256);
6   function allowance(address owner, address spender) external view returns (uint256);
7   function transfer(address to, uint256 value) external returns (bool);
8   function approve(address spender, uint256 value) external returns (bool);
9   function transferFrom(address from, address to, uint256 value) external returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11   event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 library SafeMath {
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a / b;
26     return c;
27   }
28 
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   function add(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 
40   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
41     uint256 c = add(a,m);
42     uint256 d = sub(c,1);
43     return mul(div(d,m),m);
44   }
45 }
46 
47 contract ERC20Detailed is IERC20 {
48 
49   string private _name;
50   string private _symbol;
51   uint8 private _decimals;
52 
53   constructor(string memory name, string memory symbol, uint8 decimals) public {
54     _name = name;
55     _symbol = symbol;
56     _decimals = decimals;
57   }
58 
59   function name() public view returns(string memory) {
60     return _name;
61   }
62 
63   function symbol() public view returns(string memory) {
64     return _symbol;
65   }
66 
67   function decimals() public view returns(uint8) {
68     return _decimals;
69   }
70 }
71 
72 contract RevDao is ERC20Detailed {
73 
74   using SafeMath for uint256;
75   mapping (address => uint256) private _balances;
76   mapping (address => mapping (address => uint256)) private _allowed;
77 
78   string constant tokenName = "RevelationDAO";
79   string constant tokenSymbol = "RDAO";
80   uint8  constant tokenDecimals = 18;
81   uint256 _totalSupply = 210000000000000000000000000 ;
82   uint256 public basePercent = 100;
83   uint256 public baseCut = 1;
84 
85   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
86     _issue(msg.sender, _totalSupply);
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
101   function cut(uint256 value) public view returns (uint256)  {
102     uint256 roundValue = value.ceil(basePercent);
103     uint256 cutValue = roundValue.mul(baseCut).mul(basePercent).div(10000);
104     return cutValue;
105   }
106 
107   function transfer(address to, uint256 value) public returns (bool) {
108     require(value <= _balances[msg.sender]);
109     require(to != address(0));
110 
111     uint256 tokensToBurn = cut(value);
112     uint256 tokensToTransfer = value.sub(tokensToBurn);
113 
114     _balances[msg.sender] = _balances[msg.sender].sub(value);
115     _balances[to] = _balances[to].add(tokensToTransfer);
116 
117     _totalSupply = _totalSupply.sub(tokensToBurn);
118 
119     emit Transfer(msg.sender, to, tokensToTransfer);
120     emit Transfer(msg.sender, address(0), tokensToBurn);
121     return true;
122   }
123 
124 
125   function approve(address spender, uint256 value) public returns (bool) {
126     require(spender != address(0));
127     _allowed[msg.sender][spender] = value;
128     emit Approval(msg.sender, spender, value);
129     return true;
130   }
131 
132   function transferFrom(address from, address to, uint256 value) public returns (bool) {
133     require(value <= _balances[from]);
134     require(value <= _allowed[from][msg.sender]);
135     require(to != address(0));
136 
137     _balances[from] = _balances[from].sub(value);
138 
139     uint256 tokensToBurn = cut(value);
140     uint256 tokensToTransfer = value.sub(tokensToBurn);
141 
142     _balances[to] = _balances[to].add(tokensToTransfer);
143     _totalSupply = _totalSupply.sub(tokensToBurn);
144 
145     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
146 
147     emit Transfer(from, to, tokensToTransfer);
148     emit Transfer(from, address(0), tokensToBurn);
149 
150     return true;
151   }
152 
153   function upAllowance(address spender, uint256 addedValue) public returns (bool) {
154     require(spender != address(0));
155     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
156     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
157     return true;
158   }
159 
160   function downAllowance(address spender, uint256 subtractedValue) public returns (bool) {
161     require(spender != address(0));
162     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
163     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
164     return true;
165   }
166 
167   function _issue(address account, uint256 amount) internal {
168     require(amount != 0);
169     _balances[account] = _balances[account].add(amount);
170     emit Transfer(address(0), account, amount);
171   }
172 
173   function destroy(uint256 amount) external {
174     _destroy(msg.sender, amount);
175   }
176 
177   function _destroy(address account, uint256 amount) internal {
178     require(amount != 0);
179     require(amount <= _balances[account]);
180     _totalSupply = _totalSupply.sub(amount);
181     _balances[account] = _balances[account].sub(amount);
182     emit Transfer(account, address(0), amount);
183   }
184 
185   function destroyFrom(address account, uint256 amount) external {
186     require(amount <= _allowed[account][msg.sender]);
187     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
188     _destroy(account, amount);
189   }
190 }