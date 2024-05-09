1 /** Peng.Finance, Deflationary Yield Farming */
2 pragma solidity ^0.5.17;
3 
4 interface IERC20 {
5   function totalSupply() external view returns (uint256);
6   function balanceOf(address who) external view returns (uint256);
7   function allowance(address owner, address spender) external view returns (uint256);
8   function transfer(address to, uint256 value) external returns (bool);
9   function approve(address spender, uint256 value) external returns (bool);
10   function transferFrom(address from, address to, uint256 value) external returns (bool);
11 
12   event Transfer(address indexed from, address indexed to, uint256 value);
13   event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 library SafeMath {
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     if (a == 0) {
19       return 0;
20     }
21     uint256 c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a / b;
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal pure returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 
42   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
43     uint256 c = add(a,m);
44     uint256 d = sub(c,1);
45     return mul(div(d,m),m);
46   }
47 }
48 
49 contract ERC20Detailed is IERC20 {
50 
51   string private _name;
52   string private _symbol;
53   uint8 private _decimals;
54 
55   constructor(string memory name, string memory symbol, uint8 decimals) public {
56     _name = name;
57     _symbol = symbol;
58     _decimals = decimals;
59   }
60 
61   function name() public view returns(string memory) {
62     return _name;
63   }
64 
65   function symbol() public view returns(string memory) {
66     return _symbol;
67   }
68 
69   function decimals() public view returns(uint8) {
70     return _decimals;
71   }
72 }
73 
74 contract Penguin is ERC20Detailed {
75     using SafeMath for uint256;
76   mapping (address => uint256) private _balances;
77   mapping (address => mapping (address => uint256)) private _allowed;
78 
79   string constant tokenName = "Penguin Finance";
80   string constant tokenSymbol = "Penguin";
81   uint8  constant tokenDecimals = 18;
82   uint256 _totalSupply = 3000000000000000000000;
83   uint256 public basePercent = 100;
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
101   function findOnePercent(uint256 value) public view returns (uint256)  {
102     uint256 roundValue = value.ceil(basePercent);
103     uint256 onePercent = roundValue.mul(basePercent).div(10000);
104     return onePercent;
105   }
106 
107   function transfer(address to, uint256 value) public returns (bool) {
108     require(value <= _balances[msg.sender]);
109     require(to != address(0));
110 
111     uint256 tokensToBurn = findOnePercent(value);
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
124   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
125     for (uint256 i = 0; i < receivers.length; i++) {
126       transfer(receivers[i], amounts[i]);
127     }
128   }
129 
130   function approve(address spender, uint256 value) public returns (bool) {
131     require(spender != address(0));
132     _allowed[msg.sender][spender] = value;
133     emit Approval(msg.sender, spender, value);
134     return true;
135   }
136 
137   function transferFrom(address from, address to, uint256 value) public returns (bool) {
138     require(value <= _balances[from]);
139     require(value <= _allowed[from][msg.sender]);
140     require(to != address(0));
141 
142     _balances[from] = _balances[from].sub(value);
143 
144     uint256 tokensToBurn = findOnePercent(value);
145     uint256 tokensToTransfer = value.sub(tokensToBurn);
146 
147     _balances[to] = _balances[to].add(tokensToTransfer);
148     _totalSupply = _totalSupply.sub(tokensToBurn);
149 
150     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
151 
152     emit Transfer(from, to, tokensToTransfer);
153     emit Transfer(from, address(0), tokensToBurn);
154 
155     return true;
156   }
157 
158   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
159     require(spender != address(0));
160     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
161     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
162     return true;
163   }
164 
165   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
166     require(spender != address(0));
167     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
168     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
169     return true;
170   }
171     function _mint(address account, uint256 amount) internal {
172     require(amount != 0);
173     _balances[account] = _balances[account].add(amount);
174     emit Transfer(address(0), account, amount);
175   }
176   function burn(uint256 amount) external {
177     _burn(msg.sender, amount);
178   }
179 
180   function _burn(address account, uint256 amount) internal {
181     require(amount != 0);
182     require(amount <= _balances[account]);
183     _totalSupply = _totalSupply.sub(amount);
184     _balances[account] = _balances[account].sub(amount);
185     emit Transfer(account, address(0), amount);
186   }
187 
188   function burnFrom(address account, uint256 amount) external {
189     require(amount <= _allowed[account][msg.sender]);
190     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
191     _burn(account, amount);
192   }
193 }