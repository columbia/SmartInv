1 pragma solidity ^0.5.0;
2 
3 interface IERC20 {
4     
5       function totalSupply() external view returns (uint256);
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
74 contract IDOGE is ERC20Detailed {
75 
76   using SafeMath for uint256;
77   mapping (address => uint256) private _balances;
78   mapping (address => mapping (address => uint256)) private _allowed;
79 
80   string constant tokenName = "INDICADOGE";
81   string constant tokenSymbol = "IDOGE";
82   uint8  constant tokenDecimals = 18;
83   uint256 _totalSupply = 1000000000000 *10**18;
84   uint256 public basePercent = 100;
85   uint256 public _burnStopAmount;
86   uint256 public _lastTokenSupply;
87   
88   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
89 
90     _mint(msg.sender, _totalSupply);
91     _burnStopAmount = 0;
92     _lastTokenSupply = 200000 * 10**18;
93   }
94 
95   function totalSupply() public view returns (uint256) {
96     return _totalSupply;
97   }
98 
99   function balanceOf(address owner) public view returns (uint256) {
100     return _balances[owner];
101   }
102 
103   function allowance(address owner, address spender) public view returns (uint256) {
104     return _allowed[owner][spender];
105   }
106 
107   function findOnePercent(uint256 value) public view returns (uint256)  {
108     uint256 roundValue = value.ceil(basePercent);
109     uint256 onePercent = roundValue.mul(basePercent).div(10000);
110     return onePercent;
111   }
112 
113   function transfer(address to, uint256 value) public returns (bool) {
114     require(value <= _balances[msg.sender]);
115     require(to != address(0));
116 
117     uint256 tokensToBurn = findOnePercent(value);
118     uint256 tokensToTransfer = value.sub(tokensToBurn);
119 
120     _balances[msg.sender] = _balances[msg.sender].sub(value);
121     _balances[to] = _balances[to].add(tokensToTransfer);
122 
123     _totalSupply = _totalSupply.sub(tokensToBurn);
124 
125     emit Transfer(msg.sender, to, tokensToTransfer);
126     emit Transfer(msg.sender, address(0), tokensToBurn);
127     return true;
128   }
129 
130   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
131     for (uint256 i = 0; i < receivers.length; i++) {
132       transfer(receivers[i], amounts[i]);
133     }
134   }
135 
136   function approve(address spender, uint256 value) public returns (bool) {
137     require(spender != address(0));
138     _allowed[msg.sender][spender] = value;
139     emit Approval(msg.sender, spender, value);
140     return true;
141   }
142 
143   function transferFrom(address from, address to, uint256 value) public returns (bool) {
144     require(value <= _balances[from]);
145     require(value <= _allowed[from][msg.sender]);
146     require(to != address(0));
147 
148     _balances[from] = _balances[from].sub(value);
149 
150     uint256 tokensToBurn = findOnePercent(value);
151     uint256 tokensToTransfer = value.sub(tokensToBurn);
152 
153     _balances[to] = _balances[to].add(tokensToTransfer);
154     _totalSupply = _totalSupply.sub(tokensToBurn);
155 
156     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
157 
158     emit Transfer(from, to, tokensToTransfer);
159     emit Transfer(from, address(0), tokensToBurn);
160 
161     return true;
162   }
163 
164   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
165     require(spender != address(0));
166     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
167     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
168     return true;
169   }
170 
171   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
172     require(spender != address(0));
173     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
174     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
175     return true;
176   }
177 
178   function _mint(address account, uint256 amount) internal {
179     require(amount != 0);
180     _balances[account] = _balances[account].add(amount);
181     emit Transfer(address(0), account, amount);
182   }
183 
184   function burn(uint256 amount) external {
185     _burn(msg.sender, amount);
186   }
187   function _burn(address account, uint256 amount) internal {
188     require(amount != 0);
189     require(amount <= _balances[account]);
190     _totalSupply = _totalSupply.sub(amount);
191     _balances[account] = _balances[account].sub(amount);
192     emit Transfer(account, address(0), amount);
193   }
194 
195   function burnFrom(address account, uint256 amount) external {
196     require(amount <= _allowed[account][msg.sender]);
197     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
198     _burn(account, amount);
199   }
200 }