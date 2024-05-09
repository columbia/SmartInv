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
73 contract BOMBv3 is ERC20Detailed {
74 
75   using SafeMath for uint256;
76   mapping (address => uint256) private _balances;
77   mapping (address => mapping (address => uint256)) private _allowed;
78 
79   string constant tokenName = "THE BOMB";
80   string constant tokenSymbol = "BOMB";
81   uint8  constant tokenDecimals = 0;
82   uint256 _totalSupply = 1000000;
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
124   function approve(address spender, uint256 value) public returns (bool) {
125     require(spender != address(0));
126     _allowed[msg.sender][spender] = value;
127     emit Approval(msg.sender, spender, value);
128     return true;
129   }
130 
131   function transferFrom(address from, address to, uint256 value) public returns (bool) {
132     require(value <= _balances[from]);
133     require(value <= _allowed[from][msg.sender]);
134     require(to != address(0));
135 
136     _balances[from] = _balances[from].sub(value);
137 
138     uint256 tokensToBurn = findOnePercent(value);
139     uint256 tokensToTransfer = value.sub(tokensToBurn);
140 
141     _balances[to] = _balances[to].add(tokensToTransfer);
142     _totalSupply = _totalSupply.sub(tokensToBurn);
143 
144     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
145 
146     emit Transfer(from, to, tokensToTransfer);
147     emit Transfer(from, address(0), tokensToBurn);
148 
149     return true;
150   }
151 
152   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
153     require(spender != address(0));
154     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
155     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
156     return true;
157   }
158 
159   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
160     require(spender != address(0));
161     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
162     return true;
163   }
164 
165   function _mint(address account, uint256 amount) internal {
166     require(amount != 0);
167     _balances[account] = _balances[account].add(amount);
168     emit Transfer(address(0), account, amount);
169   }
170 
171   function _burn(address account, uint256 amount) internal {
172     require(amount != 0);
173     require(amount <= _balances[account]);
174     _totalSupply = _totalSupply.sub(amount);
175     _balances[account] = _balances[account].sub(amount);
176     emit Transfer(account, address(0), amount);
177   }
178 
179   function _burnFrom(address account, uint256 amount) internal {
180     require(amount <= _allowed[account][msg.sender]);
181     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
182     _burn(account, amount);
183   }
184 }