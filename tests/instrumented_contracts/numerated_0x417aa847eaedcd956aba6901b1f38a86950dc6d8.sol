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
86   uint256[50] private __gap;
87 }
88 
89 
90 contract BURNEFIToken is ERC20Detailed {
91   using SafeMath for uint256;
92   mapping (address => uint256) private _balances;
93   mapping (address => mapping (address => uint256)) private _allowed;
94 
95   string constant tokenName = "Burnefi.finance";
96   string constant tokenSymbol = "BNFI";
97   uint8  constant tokenDecimals = 18;
98   uint256 _totalSupply = 26000000000000000000000; //26k
99   uint256 public basePercent = 100;
100 
101   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
102     _mint(msg.sender, _totalSupply);
103   }
104 
105   function totalSupply() public view returns (uint256) {
106     return _totalSupply;
107   }
108 
109   function balanceOf(address owner) public view returns (uint256) {
110     return _balances[owner];
111   }
112 
113   function allowance(address owner, address spender) public view returns (uint256) {
114     return _allowed[owner][spender];
115   }
116 
117 
118   function transfer(address to, uint256 value) public returns (bool) {
119     require(value <= _balances[msg.sender]);
120     require(to != address(0));
121 
122     uint256 tokensToBurn = calcPercent(value);
123     uint256 tokensToTransfer = value.sub(tokensToBurn);
124 
125     _balances[msg.sender] = _balances[msg.sender].sub(value);
126     _balances[to] = _balances[to].add(tokensToTransfer);
127 
128     _totalSupply = _totalSupply.sub(tokensToBurn);
129 
130     emit Transfer(msg.sender, to, tokensToTransfer);
131     emit Transfer(msg.sender, address(0), tokensToBurn);
132     return true;
133   }
134 
135   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
136     for (uint256 i = 0; i < receivers.length; i++) {
137       transfer(receivers[i], amounts[i]);
138     }
139   }
140 
141   function approve(address spender, uint256 value)
142 public returns (bool) {
143     require(spender != address(0));
144     _allowed[msg.sender][spender] = value;
145     emit Approval(msg.sender, spender, value);
146     return true;
147   }
148 
149 function calcPercent(uint256 value) public view returns (uint256)  {
150     uint256 roundValue = value.ceil(basePercent);
151     uint256 onePercent = roundValue.mul(basePercent).div(10000);
152     return onePercent;
153   }
154 
155   function transferFrom(address from, address to, uint256 value) public returns (bool) {
156     require(value <= _balances[from]);
157     require(value <= _allowed[from][msg.sender]);
158     require(to != address(0));
159 
160     _balances[from] = _balances[from].sub(value);
161 
162     uint256 tokensToBurn = calcPercent(value);
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
190   /*
191     Internal Function - Only called once within constructor above and cannot ever be called again
192   */
193   function _mint(address account, uint256 amount) internal {
194     require(amount != 0);
195     _balances[account] = _balances[account].add(amount);
196     emit Transfer(address(0), account, amount);
197   }
198 
199   function burn(uint256 amount) external {
200     _burn(msg.sender, amount);
201   }
202 
203   function _burn(address account, uint256 amount) internal {
204     require(amount != 0);
205     require(amount <= _balances[account]);
206     _totalSupply = _totalSupply.sub(amount);
207     _balances[account] = _balances[account].sub(amount);
208     emit Transfer(account, address(0), amount);
209   }
210 
211   function burnFrom(address account, uint256 amount) external {
212     require(amount <= _allowed[account][msg.sender]);
213     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
214     _burn(account, amount);
215   }
216 }