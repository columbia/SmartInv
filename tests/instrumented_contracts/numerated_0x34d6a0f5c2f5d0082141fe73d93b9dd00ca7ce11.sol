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
73 contract GOLD is ERC20Detailed {
74 
75   using SafeMath for uint256;
76   mapping (address => uint256) private _balances;
77   mapping (address => mapping (address => uint256)) private _allowed;
78 
79   string constant tokenName = "GOLDEN TOKEN";
80   string constant tokenSymbol = "GOLD";
81   uint8  constant tokenDecimals = 18;
82   uint256 _totalSupply = 1000000000000000000000000;
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
102    // uint256 roundValue = value.ceil(basePercent);
103     uint256 onePercent = value.mul(basePercent).div(10000);
104    
105     return onePercent;
106   }
107 
108   function transfer(address to, uint256 value) public returns (bool) {
109     require(value <= _balances[msg.sender]);
110     require(to != address(0));
111 
112     uint256 tokensToBurn = findOnePercent(value);
113     uint256 tokensToTransfer = value.sub(tokensToBurn);
114 
115     _balances[msg.sender] = _balances[msg.sender].sub(value);
116     _balances[to] = _balances[to].add(tokensToTransfer);
117 
118     _totalSupply = _totalSupply.sub(tokensToBurn);
119 
120     emit Transfer(msg.sender, to, tokensToTransfer);
121     emit Transfer(msg.sender, address(0), tokensToBurn);
122     return true;
123   }
124 
125   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
126     for (uint256 i = 0; i < receivers.length; i++) {
127       transfer(receivers[i], amounts[i]);
128     }
129   }
130 
131   function approve(address spender, uint256 value) public returns (bool) {
132     require(spender != address(0));
133     _allowed[msg.sender][spender] = value;
134     emit Approval(msg.sender, spender, value);
135     return true;
136   }
137 
138   function transferFrom(address from, address to, uint256 value) public returns (bool) {
139     require(value <= _balances[from]);
140     require(value <= _allowed[from][msg.sender]);
141     require(to != address(0));
142 
143     _balances[from] = _balances[from].sub(value);
144 
145     uint256 tokensToBurn = findOnePercent(value);
146     uint256 tokensToTransfer = value.sub(tokensToBurn);
147 
148     _balances[to] = _balances[to].add(tokensToTransfer);
149     _totalSupply = _totalSupply.sub(tokensToBurn);
150 
151     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
152 
153     emit Transfer(from, to, tokensToTransfer);
154     emit Transfer(from, address(0), tokensToBurn);
155 
156     return true;
157   }
158 
159   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
160     require(spender != address(0));
161     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
162     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
163     return true;
164   }
165 
166   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
167     require(spender != address(0));
168     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
169     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
170     return true;
171   }
172 
173   function _mint(address account, uint256 amount) internal {
174     require(amount != 0);
175     _balances[account] = _balances[account].add(amount);
176     emit Transfer(address(0), account, amount);
177   }
178 
179   function burn(uint256 amount) external {
180     _burn(msg.sender, amount);
181   }
182 
183   function _burn(address account, uint256 amount) internal {
184     require(amount != 0);
185     require(amount <= _balances[account]);
186     _totalSupply = _totalSupply.sub(amount);
187     _balances[account] = _balances[account].sub(amount);
188     emit Transfer(account, address(0), amount);
189   }
190 
191   function burnFrom(address account, uint256 amount) external {
192     require(amount <= _allowed[account][msg.sender]);
193     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
194     _burn(account, amount);
195   }
196 }