1 /**
2  *Created for Walnut Finance
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9   function balanceOf(address who) external view returns (uint256);
10   function allowance(address owner, address spender) external view returns (uint256);
11   function transfer(address to, uint256 value) external returns (bool);
12   function approve(address spender, uint256 value) external returns (bool);
13   function transferFrom(address from, address to, uint256 value) external returns (bool);
14 
15   event Transfer(address indexed from, address indexed to, uint256 value);
16   event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a / b;
31     return c;
32   }
33 
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 
45   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
46     uint256 c = add(a,m);
47     uint256 d = sub(c,1);
48     return mul(div(d,m),m);
49   }
50 }
51 
52 contract ERC20Detailed is IERC20 {
53 
54   string private _name;
55   string private _symbol;
56   uint8 private _decimals;
57 
58   constructor(string memory name, string memory symbol, uint8 decimals) public {
59     _name = name;
60     _symbol = symbol;
61     _decimals = decimals;
62   }
63 
64   function name() public view returns(string memory) {
65     return _name;
66   }
67 
68   function symbol() public view returns(string memory) {
69     return _symbol;
70   }
71 
72   function decimals() public view returns(uint8) {
73     return _decimals;
74   }
75 }
76 
77 contract WTF is ERC20Detailed {
78 
79   using SafeMath for uint256;
80   mapping (address => uint256) private _balances;
81   mapping (address => mapping (address => uint256)) private _allowed;
82 
83   string constant tokenName = "Walnut.Finance";
84   string constant tokenSymbol = "WTF";
85   uint8  constant tokenDecimals = 18;
86   uint256 _totalSupply = 100000000000000000000000;
87   uint256 public basePercent = 100;
88 
89   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
90     _mint(msg.sender, _totalSupply);
91   }
92 
93   function totalSupply() public view returns (uint256) {
94     return _totalSupply;
95   }
96 
97   function balanceOf(address owner) public view returns (uint256) {
98     return _balances[owner];
99   }
100 
101   function allowance(address owner, address spender) public view returns (uint256) {
102     return _allowed[owner][spender];
103   }
104 
105   function findOnePercent(uint256 value) public view returns (uint256)  {
106     uint256 roundValue = value.ceil(basePercent);
107     uint256 onePercent = roundValue.mul(basePercent).div(10000);
108     return onePercent;
109   }
110 
111   function transfer(address to, uint256 value) public returns (bool) {
112     require(value <= _balances[msg.sender]);
113     require(to != address(0));
114 
115     uint256 tokensToBurn = findOnePercent(value);
116     uint256 tokensToTransfer = value.sub(tokensToBurn);
117 
118     _balances[msg.sender] = _balances[msg.sender].sub(value);
119     _balances[to] = _balances[to].add(tokensToTransfer);
120 
121     _totalSupply = _totalSupply.sub(tokensToBurn);
122 
123     emit Transfer(msg.sender, to, tokensToTransfer);
124     emit Transfer(msg.sender, address(0), tokensToBurn);
125     return true;
126   }
127 
128   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
129     for (uint256 i = 0; i < receivers.length; i++) {
130       transfer(receivers[i], amounts[i]);
131     }
132   }
133 
134   function approve(address spender, uint256 value) public returns (bool) {
135     require(spender != address(0));
136     _allowed[msg.sender][spender] = value;
137     emit Approval(msg.sender, spender, value);
138     return true;
139   }
140 
141   function transferFrom(address from, address to, uint256 value) public returns (bool) {
142     require(value <= _balances[from]);
143     require(value <= _allowed[from][msg.sender]);
144     require(to != address(0));
145 
146     _balances[from] = _balances[from].sub(value);
147 
148     uint256 tokensToBurn = findOnePercent(value);
149     uint256 tokensToTransfer = value.sub(tokensToBurn);
150 
151     _balances[to] = _balances[to].add(tokensToTransfer);
152     _totalSupply = _totalSupply.sub(tokensToBurn);
153 
154     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
155 
156     emit Transfer(from, to, tokensToTransfer);
157     emit Transfer(from, address(0), tokensToBurn);
158 
159     return true;
160   }
161 
162   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
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
178     _balances[account] = _balances[account].add(amount);
179     emit Transfer(address(0), account, amount);
180   }
181 
182   function burn(uint256 amount) external {
183     _burn(msg.sender, amount);
184   }
185 
186   function _burn(address account, uint256 amount) internal {
187     require(amount != 0);
188     require(amount <= _balances[account]);
189     _totalSupply = _totalSupply.sub(amount);
190     _balances[account] = _balances[account].sub(amount);
191     emit Transfer(account, address(0), amount);
192   }
193 
194   function burnFrom(address account, uint256 amount) external {
195     require(amount <= _allowed[account][msg.sender]);
196     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
197     _burn(account, amount);
198   }
199 }