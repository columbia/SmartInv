1 pragma solidity ^0.5.17;
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
48 /**
49  * @title ERC20Detailed token
50  * @dev The decimals are only for visualization purposes.
51  * All the operations are done using the smallest and indivisible token unit,
52  * just as on Ethereum all the operations are done in wei.
53  */
54   contract ERC20Detailed is IERC20 {
55   string private _name;
56   string private _symbol;
57   uint8 private _decimals;
58 
59   constructor(string memory name, string memory symbol, uint8 decimals) public {
60     _name = name;
61     _symbol = symbol;
62     _decimals = decimals;
63   }
64 
65   /**
66    * @return the name of the token.
67    */
68   function name() public view returns(string memory) {
69     return _name;
70   }
71 
72   /**
73    * @return the symbol of the token.
74    */
75   function symbol() public view returns(string memory) {
76     return _symbol;
77   }
78 
79   /**
80    * @return the number of decimals of the token.
81    */
82   function decimals() public view returns(uint8) {
83     return _decimals;
84   }
85 
86   uint256[50] private ______gap;
87 }
88 
89 /*
90   SPARK Token created by Firemencrypto, 28k capped supply - 1% burn on txs
91 */
92 contract SPARKToken is ERC20Detailed {
93   using SafeMath for uint256;
94   mapping (address => uint256) private _balances;
95   mapping (address => mapping (address => uint256)) private _allowed;
96 
97   string constant tokenName = "SPARK";
98   string constant tokenSymbol = "SPRK";
99   uint8  constant tokenDecimals = 18;
100   uint256 _totalSupply = 28000000000000000000000; //28k
101   uint256 public basePercent = 100;
102 
103   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
104     _mint(msg.sender, _totalSupply);
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
119 
120   function transfer(address to, uint256 value) public returns (bool) {
121     require(value <= _balances[msg.sender]);
122     require(to != address(0));
123 
124     uint256 tokensToBurn = calcPercent(value);
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
150 function calcPercent(uint256 value) public view returns (uint256)  {
151     uint256 roundValue = value.ceil(basePercent);
152     uint256 onePercent = roundValue.mul(basePercent).div(10000);
153     return onePercent;
154   }
155 
156   function transferFrom(address from, address to, uint256 value) public returns (bool) {
157     require(value <= _balances[from]);
158     require(value <= _allowed[from][msg.sender]);
159     require(to != address(0));
160 
161     _balances[from] = _balances[from].sub(value);
162 
163     uint256 tokensToBurn = calcPercent(value);
164     uint256 tokensToTransfer = value.sub(tokensToBurn);
165 
166     _balances[to] = _balances[to].add(tokensToTransfer);
167     _totalSupply = _totalSupply.sub(tokensToBurn);
168 
169     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
170 
171     emit Transfer(from, to, tokensToTransfer);
172     emit Transfer(from, address(0), tokensToBurn);
173 
174     return true;
175   }
176 
177   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
178     require(spender != address(0));
179     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
180     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
181     return true;
182   }
183 
184   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
185     require(spender != address(0));
186     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
187     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
188     return true;
189   }
190 
191   /*
192     Internal Function - Only called once within constructor above and cannot ever be called again
193   */
194   function _mint(address account, uint256 amount) internal {
195     require(amount != 0);
196     _balances[account] = _balances[account].add(amount);
197     emit Transfer(address(0), account, amount);
198   }
199 
200   function burn(uint256 amount) external {
201     _burn(msg.sender, amount);
202   }
203 
204   function _burn(address account, uint256 amount) internal {
205     require(amount != 0);
206     require(amount <= _balances[account]);
207     _totalSupply = _totalSupply.sub(amount);
208     _balances[account] = _balances[account].sub(amount);
209     emit Transfer(account, address(0), amount);
210   }
211 
212   function burnFrom(address account, uint256 amount) external {
213     require(amount <= _allowed[account][msg.sender]);
214     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
215     _burn(account, amount);
216   }
217 }