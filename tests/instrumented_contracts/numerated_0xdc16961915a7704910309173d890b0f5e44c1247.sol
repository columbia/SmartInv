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
73 contract aDeFi is ERC20Detailed {
74 
75   using SafeMath for uint256;
76   mapping (address => uint256) private _balances;
77   mapping (address => mapping (address => uint256)) private _allowed;
78 
79   string constant tokenName = "antiDeFi";
80   string constant tokenSymbol = "aDeFi";
81   uint8  constant tokenDecimals = 0;
82   uint256 _totalSupply = 100000000;
83   uint256 public basePercent = 100;
84   
85     /**
86     * Mint is in constructor dipshit
87     */
88     
89   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
90     _mint(msg.sender, _totalSupply);
91   }
92   function totalSupply() public view returns (uint256) {
93     return _totalSupply;
94   }
95 
96   function balanceOf(address owner) public view returns (uint256) {
97     return _balances[owner];
98   }
99 
100   function allowance(address owner, address spender) public view returns (uint256) {
101     return _allowed[owner][spender];
102   }
103 
104   function killDEFI(uint256 value) public view returns (uint256)  {
105     uint256 roundValue = value.ceil(basePercent);
106     uint256 onePercent = roundValue.mul(basePercent).div(2000);
107     return onePercent;
108   }
109 
110   function transfer(address to, uint256 value) public returns (bool) {
111     require(value <= _balances[msg.sender]);
112     require(to != address(0));
113 
114     uint256 tokensToBurn = killDEFI(value);
115     uint256 tokensToTransfer = value.sub(tokensToBurn);
116 
117     _balances[msg.sender] = _balances[msg.sender].sub(value);
118     _balances[to] = _balances[to].add(tokensToTransfer);
119 
120     _totalSupply = _totalSupply.sub(tokensToBurn);
121 
122     emit Transfer(msg.sender, to, tokensToTransfer);
123     emit Transfer(msg.sender, address(0), tokensToBurn);
124     return true;
125   }
126 
127   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
128     for (uint256 i = 0; i < receivers.length; i++) {
129       transfer(receivers[i], amounts[i]);
130     }
131   }
132 
133   function approve(address spender, uint256 value) public returns (bool) {
134     require(spender != address(0));
135     _allowed[msg.sender][spender] = value;
136     emit Approval(msg.sender, spender, value);
137     return true;
138   }
139 
140   function transferFrom(address from, address to, uint256 value) public returns (bool) {
141     require(value <= _balances[from]);
142     require(value <= _allowed[from][msg.sender]);
143     require(to != address(0));
144 
145     _balances[from] = _balances[from].sub(value);
146 
147     uint256 tokensToBurn = killDEFI(value);
148     uint256 tokensToTransfer = value.sub(tokensToBurn);
149 
150     _balances[to] = _balances[to].add(tokensToTransfer);
151     _totalSupply = _totalSupply.sub(tokensToBurn);
152 
153     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
154 
155     emit Transfer(from, to, tokensToTransfer);
156     emit Transfer(from, address(0), tokensToBurn);
157 
158     return true;
159   }
160 
161   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
162     require(spender != address(0));
163     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
164     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
165     return true;
166   }
167 
168   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
169     require(spender != address(0));
170     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
171     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
172     return true;
173   }
174 
175   function _mint(address account, uint256 amount) internal {
176     require(amount != 0);
177     _balances[account] = _balances[account].add(amount);
178     emit Transfer(address(0), account, amount);
179   }
180 
181   function burn(uint256 amount) external {
182     _burn(msg.sender, amount);
183   }
184 
185   function _burn(address account, uint256 amount) internal {
186     require(amount != 0);
187     require(amount <= _balances[account]);
188     _totalSupply = _totalSupply.sub(amount);
189     _balances[account] = _balances[account].sub(amount);
190     emit Transfer(account, address(0), amount);
191   }
192 
193   function burnFrom(address account, uint256 amount) external {
194     require(amount <= _allowed[account][msg.sender]);
195     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
196     _burn(account, amount);
197   }
198 }