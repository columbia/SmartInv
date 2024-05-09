1 /**
2  *Submitted for verification at Etherscan.io on 2019-08-03
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2019-06-19
7 */
8 
9 pragma solidity ^0.5.9;
10 
11 interface IERC20 {
12   function totalSupply() external view returns (uint256);
13   function balanceOf(address who) external view returns (uint256);
14   function allowance(address owner, address spender) external view returns (uint256);
15   function transfer(address to, uint256 value) external returns (bool);
16   function approve(address spender, uint256 value) external returns (bool);
17   function transferFrom(address from, address to, uint256 value) external returns (bool);
18 
19   event Transfer(address indexed from, address indexed to, uint256 value);
20   event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
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
56 contract ERC20Detailed is IERC20 {
57 
58   string private _name;
59   string private _symbol;
60   uint8 private _decimals;
61 
62   constructor(string memory name, string memory symbol, uint8 decimals) public {
63     _name = name;
64     _symbol = symbol;
65     _decimals = decimals;
66   }
67 
68   function name() public view returns(string memory) {
69     return _name;
70   }
71 
72   function symbol() public view returns(string memory) {
73     return _symbol;
74   }
75 
76   function decimals() public view returns(uint8) {
77     return _decimals;
78   }
79 }
80 
81 contract Astra is ERC20Detailed {
82 
83   using SafeMath for uint256;
84   mapping (address => uint256) private _balances;
85   mapping (address => mapping (address => uint256)) private _allowed;
86 
87   string constant tokenName = "Astra";
88   string constant tokenSymbol = "AST";
89   uint8  constant tokenDecimals = 8;
90   uint256 _totalSupply = 10000000e8;
91   uint256 public basePercent = 100;
92 
93   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
94     _mint(msg.sender, _totalSupply);
95   }
96 
97   function totalSupply() public view returns (uint256) {
98     return _totalSupply;
99   }
100 
101   function balanceOf(address owner) public view returns (uint256) {
102     return _balances[owner];
103   }
104 
105   function allowance(address owner, address spender) public view returns (uint256) {
106     return _allowed[owner][spender];
107   }
108 
109   function findFiftyPercent(uint256 value) public view returns (uint256)  {
110     uint256 roundValue = value.ceil(basePercent);
111     uint256 oneTenthPercent = roundValue.mul(basePercent).div(100000);
112     return oneTenthPercent;
113   }
114 
115   function transfer(address to, uint256 value) public returns (bool) {
116     require(value <= _balances[msg.sender]);
117     require(to != address(0));
118 
119     uint256 tokensToBurn = findFiftyPercent(value);
120     uint256 tokensToTransfer = value.sub(tokensToBurn);
121 
122     _balances[msg.sender] = _balances[msg.sender].sub(value);
123     _balances[to] = _balances[to].add(tokensToTransfer);
124 
125     _totalSupply = _totalSupply.sub(tokensToBurn);
126 
127     emit Transfer(msg.sender, to, tokensToTransfer);
128     emit Transfer(msg.sender, address(0), tokensToBurn);
129     return true;
130   }
131 
132   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
133     for (uint256 i = 0; i < receivers.length; i++) {
134       transfer(receivers[i], amounts[i]);
135     }
136   }
137 
138   function approve(address spender, uint256 value) public returns (bool) {
139     require(spender != address(0));
140     _allowed[msg.sender][spender] = value;
141     emit Approval(msg.sender, spender, value);
142     return true;
143   }
144 
145   function transferFrom(address from, address to, uint256 value) public returns (bool) {
146     require(value <= _balances[from]);
147     require(value <= _allowed[from][msg.sender]);
148     require(to != address(0));
149 
150     _balances[from] = _balances[from].sub(value);
151 
152     uint256 tokensToBurn = findFiftyPercent(value);
153     uint256 tokensToTransfer = value.sub(tokensToBurn);
154 
155     _balances[to] = _balances[to].add(tokensToTransfer);
156     _totalSupply = _totalSupply.sub(tokensToBurn);
157 
158     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
159 
160     emit Transfer(from, to, tokensToTransfer);
161     emit Transfer(from, address(0), tokensToBurn);
162 
163     return true;
164   }
165 
166   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
167     require(spender != address(0));
168     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
169     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
170     return true;
171   }
172 
173   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
174     require(spender != address(0));
175     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
176     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
177     return true;
178   }
179 
180   function _mint(address account, uint256 amount) internal {
181     require(amount != 0);
182     _balances[account] = _balances[account].add(amount);
183     emit Transfer(address(0), account, amount);
184   }
185 
186   function burn(uint256 amount) external {
187     _burn(msg.sender, amount);
188   }
189 
190   function _burn(address account, uint256 amount) internal {
191     require(amount != 0);
192     require(amount <= _balances[account]);
193     _totalSupply = _totalSupply.sub(amount);
194     _balances[account] = _balances[account].sub(amount);
195     emit Transfer(account, address(0), amount);
196   }
197 
198   function burnFrom(address account, uint256 amount) external {
199     require(amount <= _allowed[account][msg.sender]);
200     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
201     _burn(account, amount);
202   }
203 }