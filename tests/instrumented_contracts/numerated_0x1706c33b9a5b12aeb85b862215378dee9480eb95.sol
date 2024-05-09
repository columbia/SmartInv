1 /**
2  * Brought to you by Clues (@CluesNY)
3  * 
4  * https://BananoDOS.cc
5  * 
6  * This smart contract was tested heavily, and is an experimental step into DeFi 2.0 (+ decentralized Staking, Farming, NFTs)
7  * 
8  * There is a burn rate of 2% for each transaction made with this smart contract.
9  * 
10  * No additional yBAN tokens can be minted; the total supply is 3402 yBAN, decreasing with every transaction, forever.
11  * 
12  * DOSvault, DOSfarm and DOSdao are additional upgrades to BananoDOS
13  * 
14  * 2020 - Clues
15  * 
16 */
17 
18 pragma solidity ^0.5.0;
19 
20 interface IERC20 {
21   function totalSupply() external view returns (uint256);
22   function balanceOf(address who) external view returns (uint256);
23   function allowance(address owner, address spender) external view returns (uint256);
24   function transfer(address to, uint256 value) external returns (bool);
25   function approve(address spender, uint256 value) external returns (bool);
26   function transferFrom(address from, address to, uint256 value) external returns (bool);
27 
28   event Transfer(address indexed from, address indexed to, uint256 value);
29   event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 library SafeMath {
33   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34     if (a == 0) {
35       return 0;
36     }
37     uint256 c = a * b;
38     assert(c / a == b);
39     return c;
40   }
41 
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a / b;
44     return c;
45   }
46 
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 
58   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
59     uint256 c = add(a,m);
60     uint256 d = sub(c,1);
61     return mul(div(d,m),m);
62   }
63 }
64 
65 contract ERC20Detailed is IERC20 {
66 
67   string private _name;
68   string private _symbol;
69   uint8 private _decimals;
70 
71   constructor(string memory name, string memory symbol, uint8 decimals) public {
72     _name = name;
73     _symbol = symbol;
74     _decimals = decimals;
75   }
76 
77   function name() public view returns(string memory) {
78     return _name;
79   }
80 
81   function symbol() public view returns(string memory) {
82     return _symbol;
83   }
84 
85   function decimals() public view returns(uint8) {
86     return _decimals;
87   }
88 }
89 
90 contract yBAN is ERC20Detailed {
91 
92   using SafeMath for uint256;
93   mapping (address => uint256) private _balances;
94   mapping (address => mapping (address => uint256)) private _allowed;
95 
96   string constant tokenName = "BananoDOS";
97   string constant tokenSymbol = "yBAN";
98   uint8  constant tokenDecimals = 18;
99   uint256 _totalSupply = 3402000000000000000000;
100   uint256 public basePercent = 100;
101 
102   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
103     _totsupply(msg.sender, _totalSupply);
104   }
105 
106   function totalSupply() public view returns (uint256) {
107     return _totalSupply;
108   }
109 
110   function balanceOf(address owner) public view returns (uint256) {
111     return _balances[owner];
112   }
113 
114   function allowance(address owner, address spender) public view returns (uint256) {
115     return _allowed[owner][spender];
116   }
117 
118   function findOnePercent(uint256 value) public view returns (uint256)  {
119     uint256 roundValue = value.ceil(basePercent);
120     uint256 onePercent = roundValue.mul(basePercent).div(5000);
121     return onePercent;
122   }
123 
124   function transfer(address to, uint256 value) public returns (bool) {
125     require(value <= _balances[msg.sender]);
126     require(to != address(0));
127 
128     uint256 tokensToBurn = findOnePercent(value);
129     uint256 tokensToTransfer = value.sub(tokensToBurn);
130 
131     _balances[msg.sender] = _balances[msg.sender].sub(value);
132     _balances[to] = _balances[to].add(tokensToTransfer);
133 
134     _totalSupply = _totalSupply.sub(tokensToBurn);
135 
136     emit Transfer(msg.sender, to, tokensToTransfer);
137     emit Transfer(msg.sender, address(0), tokensToBurn);
138     return true;
139   }
140 
141   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
142     for (uint256 i = 0; i < receivers.length; i++) {
143       transfer(receivers[i], amounts[i]);
144     }
145   }
146 
147   function approve(address spender, uint256 value) public returns (bool) {
148     require(spender != address(0));
149     _allowed[msg.sender][spender] = value;
150     emit Approval(msg.sender, spender, value);
151     return true;
152   }
153 
154   function transferFrom(address from, address to, uint256 value) public returns (bool) {
155     require(value <= _balances[from]);
156     require(value <= _allowed[from][msg.sender]);
157     require(to != address(0));
158 
159     _balances[from] = _balances[from].sub(value);
160 
161     uint256 tokensToBurn = findOnePercent(value);
162     uint256 tokensToTransfer = value.sub(tokensToBurn);
163 
164     _balances[to] = _balances[to].add(tokensToTransfer);
165     _totalSupply = _totalSupply.sub(tokensToBurn);
166 
167     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
168 
169     emit Transfer(from, to, tokensToTransfer);
170     emit Transfer(from, address(0), tokensToBurn);
171 
172     return true;
173   }
174 
175   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
176     require(spender != address(0));
177     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
178     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
179     return true;
180   }
181 
182   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
183     require(spender != address(0));
184     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
185     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
186     return true;
187   }
188 
189   function _totsupply(address account, uint256 amount) internal {
190     require(amount != 0);
191     _balances[account] = _balances[account].add(amount);
192     emit Transfer(address(0), account, amount);
193   }
194 
195   function burn(uint256 amount) external {
196     _burn(msg.sender, amount);
197   }
198 
199   function _burn(address account, uint256 amount) internal {
200     require(amount != 0);
201     require(amount <= _balances[account]);
202     _totalSupply = _totalSupply.sub(amount);
203     _balances[account] = _balances[account].sub(amount);
204     emit Transfer(account, address(0), amount);
205   }
206 
207   function burnFrom(address account, uint256 amount) external {
208     require(amount <= _allowed[account][msg.sender]);
209     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
210     _burn(account, amount);
211   }
212 }