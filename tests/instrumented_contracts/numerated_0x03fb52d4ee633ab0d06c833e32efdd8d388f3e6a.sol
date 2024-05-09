1 pragma solidity ^0.5.9;
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
73 contract BlackHole is ERC20Detailed {
74 
75   using SafeMath for uint256;
76   mapping (address => uint256) private _balances;
77   mapping (address => mapping (address => uint256)) private _allowed;
78 
79   string constant tokenName = "Black Hole";
80   string constant tokenSymbol = "HOLE";
81   uint8  constant tokenDecimals = 18;
82   uint256 _totalSupply = 2500000000000000000000000;
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
101   function findTwentyPercent(uint256 value) public view returns (uint256)  {
102     uint256 roundValue = value.ceil(basePercent);
103     uint256 TwentyPercent = roundValue.mul(basePercent).div(500);
104     return TwentyPercent;
105   }
106 
107   function transfer(address to, uint256 value) public returns (bool) {
108     require(value <= _balances[msg.sender]);
109     require(to != address(0));
110 
111     uint256 tokensToBurn = findTwentyPercent(value);
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
130   function multiTransferSingleAmount(address[] memory receivers, uint256 amount) public {
131     uint256 toSend = amount * 10**18;
132 
133     for (uint256 i = 0; i < receivers.length; i++) {
134       transfer(receivers[i], toSend);
135     }
136   }
137 
138   function approve(address spender, uint256 value) public returns (bool) {
139     require(spender != address(0));
140     _allowed[msg.sender][spender] = value;
141     emit Approval(msg.sender, spender, value);
142     return true;
143   }
144 
145   function transferFrom(address from, address to, uint256 value) public returns (bool) {
146     require(value <= _balances[from]);
147     require(value <= _allowed[from][msg.sender]);
148     require(to != address(0));
149 
150     _balances[from] = _balances[from].sub(value);
151 
152     uint256 tokensToBurn = findTwentyPercent(value);
153     uint256 tokensToTransfer = value.sub(tokensToBurn);
154 
155     _balances[to] = _balances[to].add(tokensToTransfer);
156     _totalSupply = _totalSupply.sub(tokensToBurn);
157 
158     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
159 
160     emit Transfer(from, to, tokensToTransfer);
161     emit Transfer(from, address(0), tokensToBurn);
162 
163     return true;
164   }
165 
166   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
167     require(spender != address(0));
168     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
169     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
170     return true;
171   }
172 
173   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
174     require(spender != address(0));
175     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
176     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
177     return true;
178   }
179 
180   function _mint(address account, uint256 amount) internal {
181     require(amount != 0);
182     _balances[account] = _balances[account].add(amount);
183     emit Transfer(address(0), account, amount);
184   }
185 
186   function burn(uint256 amount) external {
187     _burn(msg.sender, amount);
188   }
189 
190   function _burn(address account, uint256 amount) internal {
191     require(amount != 0);
192     require(amount <= _balances[account]);
193     _totalSupply = _totalSupply.sub(amount);
194     _balances[account] = _balances[account].sub(amount);
195     emit Transfer(account, address(0), amount);
196   }
197 
198   function burnFrom(address account, uint256 amount) external {
199     require(amount <= _allowed[account][msg.sender]);
200     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
201     _burn(account, amount);
202   }
203 }