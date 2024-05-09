1 /**
2  YF Beam social contract with functionality base for staking, yield farming, governance, and Moonbeam migration.
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
19 /**
20  Safe Math
21 */
22 
23 library SafeMath {
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     uint256 c = a / b;
35     return c;
36   }
37 
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 
49   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
50     uint256 c = add(a,m);
51     uint256 d = sub(c,1);
52     return mul(div(d,m),m);
53   }
54 }
55 
56 /**
57  Create ERC20 token // make burn amount 0 // allow connectivity with Moonbeam
58 */
59 contract ERC20Detailed is IERC20 {
60 
61   string private _name;
62   string private _symbol;
63   uint8 private _decimals;
64 
65   constructor(string memory name, string memory symbol, uint8 decimals) public {
66     _name = name;
67     _symbol = symbol;
68     _decimals = decimals;
69   }
70 
71   function name() public view returns(string memory) {
72     return _name;
73   }
74 
75   function symbol() public view returns(string memory) {
76     return _symbol;
77   }
78 
79   function decimals() public view returns(uint8) {
80     return _decimals;
81   }
82 }
83 
84 contract AYFBeam is ERC20Detailed {
85 
86   using SafeMath for uint256;
87   mapping (address => uint256) private _balances;
88   mapping (address => mapping (address => uint256)) private _allowed;
89 
90   string constant tokenName = "YF Beam";
91   string constant tokenSymbol = "YFBM";
92   uint8  constant tokenDecimals = 18;
93   uint256 _totalSupply = 35000000000000000000000;
94   uint256 public basePercent = 100;
95 
96   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
97     _mint(msg.sender, _totalSupply);
98   }
99 
100   function totalSupply() public view returns (uint256) {
101     return _totalSupply;
102   }
103 
104   function balanceOf(address owner) public view returns (uint256) {
105     return _balances[owner];
106   }
107 
108   function allowance(address owner, address spender) public view returns (uint256) {
109     return _allowed[owner][spender];
110   }
111 
112   function findOnePercent(uint256 value) public view returns (uint256)  {
113     uint256 roundValue = value.ceil(basePercent);
114     uint256 onePercent = roundValue.mul(basePercent).div(10000);
115     return onePercent;
116   }
117 /**
118  Allow token to be traded/sent from account to account // allow for staking and governance plug-in
119 */
120   function transfer(address to, uint256 value) public returns (bool) {
121     require(value <= _balances[msg.sender]);
122     require(to != address(0));
123 
124     uint256 tokensToBurn = 0;
125     uint256 tokensToTransfer = value.sub(tokensToBurn);
126 
127     _balances[msg.sender] = _balances[msg.sender].sub(value);
128     _balances[to] = _balances[to].add(tokensToTransfer);
129 
130     _totalSupply = _totalSupply.sub(tokensToBurn);
131 
132     emit Transfer(msg.sender, to, tokensToTransfer);
133     emit Transfer(msg.sender, address(0), tokensToBurn);
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
151     require(value <= _balances[from]);
152     require(value <= _allowed[from][msg.sender]);
153     require(to != address(0));
154 
155     _balances[from] = _balances[from].sub(value);
156 
157     uint256 tokensToBurn = 0;
158     uint256 tokensToTransfer = value.sub(tokensToBurn);
159 
160     _balances[to] = _balances[to].add(tokensToTransfer);
161     _totalSupply = _totalSupply.sub(tokensToBurn);
162 
163     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
164 
165     emit Transfer(from, to, tokensToTransfer);
166     emit Transfer(from, address(0), tokensToBurn);
167 
168     return true;
169   }
170 
171   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
172     require(spender != address(0));
173     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
174     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
175     return true;
176   }
177 
178   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
179     require(spender != address(0));
180     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
181     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
182     return true;
183   }
184 
185 /*  1-time token mint/creation function.  This function is called only 1 time, when the contract is going live.
186     After it is called, it will return "true" and can never be used again.  Tokens are only minted during contract creation, and cannot be done again.*/
187   function _mint(address account, uint256 amount) internal {
188     require(amount != 0);
189     _balances[account] = _balances[account].add(amount);
190     emit Transfer(address(0), account, amount);
191   }
192 
193   function burn(uint256 amount) external {
194     _burn(msg.sender, amount);
195   }
196 
197   function _burn(address account, uint256 amount) internal {
198     require(amount != 0);
199     require(amount <= _balances[account]);
200     _totalSupply = _totalSupply.sub(amount);
201     _balances[account] = _balances[account].sub(amount);
202     emit Transfer(account, address(0), amount);
203   }
204 
205   function burnFrom(address account, uint256 amount) external {
206     require(amount <= _allowed[account][msg.sender]);
207     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
208     _burn(account, amount);
209   }
210 }
211 /**
212  social experiment token
213 */