1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-03
3  * This code is inspired by BOMB
4  * List of modifications:
5  * A change from integer to Decimals 
6  * Change of Transfer fucntion, burn doesn't send to adress 0, but to an address we control
7  * Modified burn value
8  * Modified Burn function to not round
9 */
10 
11 pragma solidity ^0.5.0;
12 
13 interface IERC20 {
14   function totalSupply() external view returns (uint256);
15   function balanceOf(address who) external view returns (uint256);
16   function allowance(address owner, address spender) external view returns (uint256);
17   function transfer(address to, uint256 value) external returns (bool);
18   function approve(address spender, uint256 value) external returns (bool);
19   function transferFrom(address from, address to, uint256 value) external returns (bool);
20 
21   event Transfer(address indexed from, address indexed to, uint256 value);
22   event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     if (a == 0) {
28       return 0;
29     }
30     uint256 c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   function div(uint256 a, uint256 b) internal pure returns (uint256) {
36     uint256 c = a / b;
37     return c;
38   }
39 
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     assert(b <= a);
42     return a - b;
43   }
44 
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 
51   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
52     uint256 c = add(a,m);
53     uint256 d = sub(c,1);
54     return mul(div(d,m),m);
55   }
56 }
57 
58 contract ERC20Detailed is IERC20 {
59 
60   string private _name;
61   string private _symbol;
62   uint8 private _decimals;
63 
64   constructor(string memory name, string memory symbol, uint8 decimals) public {
65     _name = name;
66     _symbol = symbol;
67     _decimals = decimals;
68   }
69 
70   function name() public view returns(string memory) {
71     return _name;
72   }
73 
74   function symbol() public view returns(string memory) {
75     return _symbol;
76   }
77 
78 //modified for decimals from uint8 to uint256
79   function decimals() public view returns(uint256) {
80     return _decimals;
81   }
82 }
83 
84 contract SpartaFinance is ERC20Detailed {
85 
86   using SafeMath for uint256;
87   mapping (address => uint256) private _balances;
88   mapping (address => mapping (address => uint256)) private _allowed;
89 
90   string constant tokenName = "Sparta.Finance";
91   string constant tokenSymbol = "SPARTA";
92   uint8  constant tokenDecimals = 18;
93   uint256 _totalSupply = 300000000000000000000;
94   uint256 public basePercent = 500;
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
112   function findPercent(uint256 value) public view returns (uint256)  {
113     //uint256 roundValue = value.ceil(basePercent);
114     uint256 percent = value.mul(basePercent).div(10000);
115     return percent;
116   }
117 
118   function transfer(address to, uint256 value) public returns (bool) {
119     require(value <= _balances[msg.sender]);
120     require(to != address(0));
121 
122     uint256 tokensToBurn = findPercent(value);
123     uint256 tokensToTransfer = value.sub(tokensToBurn);
124 
125     _balances[msg.sender] = _balances[msg.sender].sub(value);
126     _balances[to] = _balances[to].add(tokensToTransfer);
127 
128     _totalSupply = _totalSupply.sub(tokensToBurn);
129 
130     emit Transfer(msg.sender, to, tokensToTransfer);
131     // burns to this address, this address will be the reward address
132     emit Transfer(msg.sender, 0xC4cEc35DF46f625057C5a450F540dCBe3b123F5E, tokensToBurn);
133     return true;
134   }
135 
136   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
137     for (uint256 i = 0; i < receivers.length; i++) {
138       transfer(receivers[i], amounts[i]);
139     }
140   }
141 
142   function approve(address spender, uint256 value) public returns (bool) {
143     require(spender != address(0));
144     _allowed[msg.sender][spender] = value;
145     emit Approval(msg.sender, spender, value);
146     return true;
147   }
148 
149   function transferFrom(address from, address to, uint256 value) public returns (bool) {
150     require(value <= _balances[from]);
151     require(value <= _allowed[from][msg.sender]);
152     require(to != address(0));
153 
154     _balances[from] = _balances[from].sub(value);
155 
156     uint256 tokensToBurn = findPercent(value);
157     uint256 tokensToTransfer = value.sub(tokensToBurn);
158 
159     _balances[to] = _balances[to].add(tokensToTransfer);
160     _totalSupply = _totalSupply.sub(tokensToBurn);
161 
162     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
163 
164     emit Transfer(from, to, tokensToTransfer);
165     emit Transfer(from, address(0), tokensToBurn);
166 
167     return true;
168   }
169 
170   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
171     require(spender != address(0));
172     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
173     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
174     return true;
175   }
176 
177   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
178     require(spender != address(0));
179     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
180     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
181     return true;
182   }
183 
184   function _mint(address account, uint256 amount) internal {
185     require(amount != 0);
186     _balances[account] = _balances[account].add(amount);
187     emit Transfer(address(0), account, amount);
188   }
189 
190   function burn(uint256 amount) external {
191     _burn(msg.sender, amount);
192   }
193 
194   function _burn(address account, uint256 amount) internal {
195     require(amount != 0);
196     require(amount <= _balances[account]);
197     _totalSupply = _totalSupply.sub(amount);
198     _balances[account] = _balances[account].sub(amount);
199     emit Transfer(account, address(0), amount);
200   }
201 
202   function burnFrom(address account, uint256 amount) external {
203     require(amount <= _allowed[account][msg.sender]);
204     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
205     _burn(account, amount);
206   }
207 }