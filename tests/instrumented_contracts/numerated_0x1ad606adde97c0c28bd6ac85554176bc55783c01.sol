1 pragma solidity ^0.5.0;
2 
3 
4 
5 /*
6  * @title: MOONDAY
7  * @website: moonday.finance
8  * @telegram: @moondayfinance
9  * 1% burn to fuel our rockets.
10  * We are just trying to go to the Moon.
11  */
12 
13 
14 interface IERC20 {
15   function totalSupply() external view returns (uint256);
16   function balanceOf(address who) external view returns (uint256);
17   function allowance(address owner, address spender) external view returns (uint256);
18   function transfer(address to, uint256 value) external returns (bool);
19   function approve(address spender, uint256 value) external returns (bool);
20   function transferFrom(address from, address to, uint256 value) external returns (bool);
21 
22   event Transfer(address indexed from, address indexed to, uint256 value);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 library SafeMath {
27   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28     if (a == 0) {
29       return 0;
30     }
31     
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
62   uint8 public _Tokendecimals;
63   string public _Tokenname;
64   string public _Tokensymbol;
65 
66   constructor(string memory name, string memory symbol, uint8 decimals) public {
67    
68     _Tokendecimals = decimals;
69     _Tokenname = name;
70     _Tokensymbol = symbol;
71     
72   }
73 
74   function name() public view returns(string memory) {
75     return _Tokenname;
76   }
77 
78   function symbol() public view returns(string memory) {
79     return _Tokensymbol;
80   }
81 
82   function decimals() public view returns(uint8) {
83     return _Tokendecimals;
84   }
85 }
86 
87 contract MOONDAY is ERC20Detailed {
88 
89   using SafeMath for uint256;
90   mapping (address => uint256) public _MOONDAYTokenBalances;
91   mapping (address => mapping (address => uint256)) public _allowed;
92   string constant tokenName = "moonday.finance";
93   string constant tokenSymbol = "MOONDAY";
94   uint8  constant tokenDecimals = 18;
95   uint256 _totalSupply = 1969000000000000000000;
96 
97 
98   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
99     _mint(msg.sender, _totalSupply);
100   }
101 
102   function totalSupply() public view returns (uint256) {
103     return _totalSupply;
104   }
105 
106   function balanceOf(address owner) public view returns (uint256) {
107     return _MOONDAYTokenBalances[owner];
108   }
109 
110 
111   function transfer(address to, uint256 value) public returns (bool) {
112     require(value <= _MOONDAYTokenBalances[msg.sender]);
113     require(to != address(0));
114 
115     uint256 MOONDAYTokenDecay = value.div(100);
116     uint256 tokensToTransfer = value.sub(MOONDAYTokenDecay);
117 
118     _MOONDAYTokenBalances[msg.sender] = _MOONDAYTokenBalances[msg.sender].sub(value);
119     _MOONDAYTokenBalances[to] = _MOONDAYTokenBalances[to].add(tokensToTransfer);
120 
121     _totalSupply = _totalSupply.sub(MOONDAYTokenDecay);
122 
123     emit Transfer(msg.sender, to, tokensToTransfer);
124     emit Transfer(msg.sender, address(0), MOONDAYTokenDecay);
125     return true;
126   }
127   
128 
129   function allowance(address owner, address spender) public view returns (uint256) {
130     return _allowed[owner][spender];
131   }
132 
133 
134   function approve(address spender, uint256 value) public returns (bool) {
135     require(spender != address(0));
136     _allowed[msg.sender][spender] = value;
137     emit Approval(msg.sender, spender, value);
138     return true;
139   }
140 
141   function transferFrom(address from, address to, uint256 value) public returns (bool) {
142     require(value <= _MOONDAYTokenBalances[from]);
143     require(value <= _allowed[from][msg.sender]);
144     require(to != address(0));
145 
146     _MOONDAYTokenBalances[from] = _MOONDAYTokenBalances[from].sub(value);
147 
148     uint256 MOONDAYTokenDecay = value.div(100);
149     uint256 tokensToTransfer = value.sub(MOONDAYTokenDecay);
150 
151     _MOONDAYTokenBalances[to] = _MOONDAYTokenBalances[to].add(tokensToTransfer);
152     _totalSupply = _totalSupply.sub(MOONDAYTokenDecay);
153 
154     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
155 
156     emit Transfer(from, to, tokensToTransfer);
157     emit Transfer(from, address(0), MOONDAYTokenDecay);
158 
159     return true;
160   }
161   
162     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
163     require(spender != address(0));
164     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
165     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
166     return true;
167   }
168 
169   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
170     require(spender != address(0));
171     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
172     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
173     return true;
174   }
175 
176   function _mint(address account, uint256 amount) internal {
177     require(amount != 0);
178     _MOONDAYTokenBalances[account] = _MOONDAYTokenBalances[account].add(amount);
179     emit Transfer(address(0), account, amount);
180   }
181 
182   function burn(uint256 amount) external {
183     _burn(msg.sender, amount);
184   }
185 
186   function _burn(address account, uint256 amount) internal {
187     require(amount != 0);
188     require(amount <= _MOONDAYTokenBalances[account]);
189     _totalSupply = _totalSupply.sub(amount);
190     _MOONDAYTokenBalances[account] = _MOONDAYTokenBalances[account].sub(amount);
191     emit Transfer(account, address(0), amount);
192   }
193 
194   function burnFrom(address account, uint256 amount) external {
195     require(amount <= _allowed[account][msg.sender]);
196     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
197     _burn(account, amount);
198   }
199 }