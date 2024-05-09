1 /**
2  * Brought to you by Clues (@CluesNY)
3  * 
4  * https://erebus.cash
5  * 
6  * This smart contract was tested heavily, and is an experimental step into DeFi 2.0
7  * 
8  * This smart contract is a modified version of my previous yBAN code.
9  * 
10  * There is a burn rate of 2% for each transaction made with this smart contract.
11  * 
12  * No additional yERB tokens can be minted; the total supply is 1701 yERB, decreasing with every transaction, forever.
13  * 
14  * 
15  * 2020 - signed by Clues (twitter.com/CluesNY)
16  * 
17 */
18 
19 pragma solidity ^0.5.0;
20 
21 interface IERC20 {
22   function totalSupply() external view returns (uint256);
23   function balanceOf(address who) external view returns (uint256);
24   function allowance(address owner, address spender) external view returns (uint256);
25   function transfer(address to, uint256 value) external returns (bool);
26   function approve(address spender, uint256 value) external returns (bool);
27   function transferFrom(address from, address to, uint256 value) external returns (bool);
28 
29   event Transfer(address indexed from, address indexed to, uint256 value);
30   event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 library SafeMath {
34   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35     if (a == 0) {
36       return 0;
37     }
38     uint256 c = a * b;
39     assert(c / a == b);
40     return c;
41   }
42 
43   function div(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a / b;
45     return c;
46   }
47 
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   function add(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 
59   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
60     uint256 c = add(a,m);
61     uint256 d = sub(c,1);
62     return mul(div(d,m),m);
63   }
64 }
65 
66 contract ERC20Detailed is IERC20 {
67 
68   string private _name;
69   string private _symbol;
70   uint8 private _decimals;
71 
72   constructor(string memory name, string memory symbol, uint8 decimals) public {
73     _name = name;
74     _symbol = symbol;
75     _decimals = decimals;
76   }
77 
78   function name() public view returns(string memory) {
79     return _name;
80   }
81 
82   function symbol() public view returns(string memory) {
83     return _symbol;
84   }
85 
86   function decimals() public view returns(uint8) {
87     return _decimals;
88   }
89 }
90 
91 contract yERB is ERC20Detailed {
92 
93   using SafeMath for uint256;
94   mapping (address => uint256) private _balances;
95   mapping (address => mapping (address => uint256)) private _allowed;
96 
97   string constant tokenName = "erebus protocol";
98   string constant tokenSymbol = "yERB";
99   uint8  constant tokenDecimals = 18;
100   uint256 _totalSupply = 1701000000000000000000;
101   uint256 public basePercent = 100;
102 
103   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
104     _totsupply(msg.sender, _totalSupply);
105   }
106 
107   function totalSupply() public view returns (uint256) {
108     return _totalSupply;
109   }
110 
111   function balanceOf(address owner) public view returns (uint256) {
112     return _balances[owner];
113   }
114 
115   function allowance(address owner, address spender) public view returns (uint256) {
116     return _allowed[owner][spender];
117   }
118 
119   function findOnePercent(uint256 value) public view returns (uint256)  {
120     uint256 roundValue = value.ceil(basePercent);
121     uint256 onePercent = roundValue.mul(basePercent).div(5000);
122     return onePercent;
123   }
124 
125   function transfer(address to, uint256 value) public returns (bool) {
126     require(value <= _balances[msg.sender]);
127     require(to != address(0));
128 
129     uint256 tokensToBurn = findOnePercent(value);
130     uint256 tokensToTransfer = value.sub(tokensToBurn);
131 
132     _balances[msg.sender] = _balances[msg.sender].sub(value);
133     _balances[to] = _balances[to].add(tokensToTransfer);
134 
135     _totalSupply = _totalSupply.sub(tokensToBurn);
136 
137     emit Transfer(msg.sender, to, tokensToTransfer);
138     emit Transfer(msg.sender, address(0), tokensToBurn);
139     return true;
140   }
141 
142   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
143     for (uint256 i = 0; i < receivers.length; i++) {
144       transfer(receivers[i], amounts[i]);
145     }
146   }
147 
148   function approve(address spender, uint256 value) public returns (bool) {
149     require(spender != address(0));
150     _allowed[msg.sender][spender] = value;
151     emit Approval(msg.sender, spender, value);
152     return true;
153   }
154 
155   function transferFrom(address from, address to, uint256 value) public returns (bool) {
156     require(value <= _balances[from]);
157     require(value <= _allowed[from][msg.sender]);
158     require(to != address(0));
159 
160     _balances[from] = _balances[from].sub(value);
161 
162     uint256 tokensToBurn = findOnePercent(value);
163     uint256 tokensToTransfer = value.sub(tokensToBurn);
164 
165     _balances[to] = _balances[to].add(tokensToTransfer);
166     _totalSupply = _totalSupply.sub(tokensToBurn);
167 
168     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
169 
170     emit Transfer(from, to, tokensToTransfer);
171     emit Transfer(from, address(0), tokensToBurn);
172 
173     return true;
174   }
175 
176   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
177     require(spender != address(0));
178     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
179     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
180     return true;
181   }
182 
183   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
184     require(spender != address(0));
185     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
186     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
187     return true;
188   }
189 
190   function _totsupply(address account, uint256 amount) internal {
191     require(amount != 0);
192     _balances[account] = _balances[account].add(amount);
193     emit Transfer(address(0), account, amount);
194   }
195 
196   function burn(uint256 amount) external {
197     _burn(msg.sender, amount);
198   }
199 
200   function _burn(address account, uint256 amount) internal {
201     require(amount != 0);
202     require(amount <= _balances[account]);
203     _totalSupply = _totalSupply.sub(amount);
204     _balances[account] = _balances[account].sub(amount);
205     emit Transfer(account, address(0), amount);
206   }
207 
208   function burnFrom(address account, uint256 amount) external {
209     require(amount <= _allowed[account][msg.sender]);
210     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
211     _burn(account, amount);
212   }
213 }