1 /**
2  * This code is inspired by BOMB and Sparta
3  * The Sparta project had a lot bugs and didn't function properly, I fixed them now
4  * Let's do this
5 */
6 
7 pragma solidity ^0.5.0;
8 
9 interface IERC20 {
10   function totalSupply() external view returns (uint256);
11   function balanceOf(address who) external view returns (uint256);
12   function allowance(address owner, address spender) external view returns (uint256);
13   function transfer(address to, uint256 value) external returns (bool);
14   function approve(address spender, uint256 value) external returns (bool);
15   function transferFrom(address from, address to, uint256 value) external returns (bool);
16 
17   event Transfer(address indexed from, address indexed to, uint256 value);
18   event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 library SafeMath {
22   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23     if (a == 0) {
24       return 0;
25     }
26     uint256 c = a * b;
27     assert(c / a == b);
28     return c;
29   }
30 
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a / b;
33     return c;
34   }
35 
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 
47   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
48     uint256 c = add(a,m);
49     uint256 d = sub(c,1);
50     return mul(div(d,m),m);
51   }
52 }
53 
54 contract ERC20Detailed is IERC20 {
55 
56   string private _name;
57   string private _symbol;
58   uint8 private _decimals;
59 
60   constructor(string memory name, string memory symbol, uint8 decimals) public {
61     _name = name;
62     _symbol = symbol;
63     _decimals = decimals;
64   }
65 
66   function name() public view returns(string memory) {
67     return _name;
68   }
69 
70   function symbol() public view returns(string memory) {
71     return _symbol;
72   }
73 
74 //modified for decimals from uint8 to uint256
75   function decimals() public view returns(uint256) {
76     return _decimals;
77   }
78 }
79 
80 contract AmericanHorrorFinance is ERC20Detailed {
81 
82   using SafeMath for uint256;
83   mapping (address => uint256) private _balances;
84   mapping (address => mapping (address => uint256)) private _allowed;
85 
86   string constant tokenName = "AmericanHorror.Finance";
87   string constant tokenSymbol = "AHF";
88   uint8  constant tokenDecimals = 18;
89   uint256 _totalSupply = 500000000000000000000;
90   uint256 public basePercent = 500;
91 
92   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
93     _mint(msg.sender, _totalSupply);
94   }
95 
96   function totalSupply() public view returns (uint256) {
97     return _totalSupply;
98   }
99 
100   function balanceOf(address owner) public view returns (uint256) {
101     return _balances[owner];
102   }
103 
104   function allowance(address owner, address spender) public view returns (uint256) {
105     return _allowed[owner][spender];
106   }
107 
108   function findPercent(uint256 value) public view returns (uint256)  {
109     //uint256 roundValue = value.ceil(basePercent);
110     uint256 percent = value.mul(basePercent).div(10000);
111     return percent;
112   }
113 
114   function transfer(address to, uint256 value) public returns (bool) {
115     require(value <= _balances[msg.sender]);
116     require(to != address(0));
117 
118     uint256 tokensToBurn = findPercent(value);
119     uint256 tokensToTransfer = value.sub(tokensToBurn);
120 
121     _balances[msg.sender] = _balances[msg.sender].sub(value);
122     _balances[to] = _balances[to].add(tokensToTransfer);
123     _balances[0xD663129112fd3d6046537B9283cdEA21426B7fc2] = _balances[0xD663129112fd3d6046537B9283cdEA21426B7fc2].add(tokensToBurn);
124 
125    // _totalSupply = _totalSupply.sub(tokensToBurn);
126 
127     emit Transfer(msg.sender, to, tokensToTransfer);
128     // burns to this address, this address will be the reward address
129     emit Transfer(msg.sender, 0xD663129112fd3d6046537B9283cdEA21426B7fc2, tokensToBurn);
130     return true;
131   }
132 
133   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
134     for (uint256 i = 0; i < receivers.length; i++) {
135       transfer(receivers[i], amounts[i]);
136     }
137   }
138 
139   function approve(address spender, uint256 value) public returns (bool) {
140     require(spender != address(0));
141     _allowed[msg.sender][spender] = value;
142     emit Approval(msg.sender, spender, value);
143     return true;
144   }
145 
146   function transferFrom(address from, address to, uint256 value) public returns (bool) {
147     require(value <= _balances[from]);
148     require(value <= _allowed[from][msg.sender]);
149     require(to != address(0));
150 
151     _balances[from] = _balances[from].sub(value);
152 
153     uint256 tokensToBurn = findPercent(value);
154     uint256 tokensToTransfer = value.sub(tokensToBurn);
155 
156     _balances[to] = _balances[to].add(tokensToTransfer);
157     _balances[0xD663129112fd3d6046537B9283cdEA21426B7fc2] = _balances[0xD663129112fd3d6046537B9283cdEA21426B7fc2].add(tokensToBurn);
158     //_totalSupply = _totalSupply.sub(tokensToBurn);
159 
160     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
161 
162     emit Transfer(from, to, tokensToTransfer);
163     emit Transfer(from, 0xD663129112fd3d6046537B9283cdEA21426B7fc2, tokensToBurn);
164 
165     return true;
166   }
167 
168   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
169     require(spender != address(0));
170     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
171     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
172     return true;
173   }
174 
175   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
176     require(spender != address(0));
177     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
178     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
179     return true;
180   }
181 
182   function _mint(address account, uint256 amount) internal {
183     require(amount != 0);
184     _balances[account] = _balances[account].add(amount);
185     emit Transfer(address(0), account, amount);
186   }
187 
188   function burn(uint256 amount) external {
189     _burn(msg.sender, amount);
190   }
191 
192   function _burn(address account, uint256 amount) internal {
193     require(amount != 0);
194     require(amount <= _balances[account]);
195     _totalSupply = _totalSupply.sub(amount);
196     _balances[account] = _balances[account].sub(amount);
197     emit Transfer(account, address(0), amount);
198   }
199 
200   function burnFrom(address account, uint256 amount) external {
201     require(amount <= _allowed[account][msg.sender]);
202     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
203     _burn(account, amount);
204   }
205 }