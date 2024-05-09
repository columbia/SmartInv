1 pragma solidity ^0.5.0;
2 
3 /*
4 *  statera.sol
5 *  STA V2 deflationary index token smart contract
6 *  2020-04-28
7 **/
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
74   function decimals() public view returns(uint8) {
75     return _decimals;
76   }
77 }
78 
79 contract Statera is ERC20Detailed {
80 
81   using SafeMath for uint256;
82   mapping (address => uint256) private _balances;
83   mapping (address => mapping (address => uint256)) private _allowed;
84 
85   string constant tokenName = "Statera";
86   string constant tokenSymbol = "STA";
87   uint8  constant tokenDecimals = 18;
88   uint256 _totalSupply = 101000000000000000000000000;
89   uint256 public basePercent = 100;
90 
91   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
92     _issue(msg.sender, _totalSupply);
93   }
94 
95   function totalSupply() public view returns (uint256) {
96     return _totalSupply;
97   }
98 
99   function balanceOf(address owner) public view returns (uint256) {
100     return _balances[owner];
101   }
102 
103   function allowance(address owner, address spender) public view returns (uint256) {
104     return _allowed[owner][spender];
105   }
106 
107   function cut(uint256 value) public view returns (uint256)  {
108     uint256 roundValue = value.ceil(basePercent);
109     uint256 cutValue = roundValue.mul(basePercent).div(10000);
110     return cutValue;
111   }
112 
113   function transfer(address to, uint256 value) public returns (bool) {
114     require(value <= _balances[msg.sender]);
115     require(to != address(0));
116 
117     uint256 tokensToBurn = cut(value);
118     uint256 tokensToTransfer = value.sub(tokensToBurn);
119 
120     _balances[msg.sender] = _balances[msg.sender].sub(value);
121     _balances[to] = _balances[to].add(tokensToTransfer);
122 
123     _totalSupply = _totalSupply.sub(tokensToBurn);
124 
125     emit Transfer(msg.sender, to, tokensToTransfer);
126     emit Transfer(msg.sender, address(0), tokensToBurn);
127     return true;
128   }
129 
130 
131   function approve(address spender, uint256 value) public returns (bool) {
132     require(spender != address(0));
133     _allowed[msg.sender][spender] = value;
134     emit Approval(msg.sender, spender, value);
135     return true;
136   }
137 
138   function transferFrom(address from, address to, uint256 value) public returns (bool) {
139     require(value <= _balances[from]);
140     require(value <= _allowed[from][msg.sender]);
141     require(to != address(0));
142 
143     _balances[from] = _balances[from].sub(value);
144 
145     uint256 tokensToBurn = cut(value);
146     uint256 tokensToTransfer = value.sub(tokensToBurn);
147 
148     _balances[to] = _balances[to].add(tokensToTransfer);
149     _totalSupply = _totalSupply.sub(tokensToBurn);
150 
151     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
152 
153     emit Transfer(from, to, tokensToTransfer);
154     emit Transfer(from, address(0), tokensToBurn);
155 
156     return true;
157   }
158 
159   function upAllowance(address spender, uint256 addedValue) public returns (bool) {
160     require(spender != address(0));
161     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
162     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
163     return true;
164   }
165 
166   function downAllowance(address spender, uint256 subtractedValue) public returns (bool) {
167     require(spender != address(0));
168     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
169     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
170     return true;
171   }
172 
173   function _issue(address account, uint256 amount) internal {
174     require(amount != 0);
175     _balances[account] = _balances[account].add(amount);
176     emit Transfer(address(0), account, amount);
177   }
178 
179   function destroy(uint256 amount) external {
180     _destroy(msg.sender, amount);
181   }
182 
183   function _destroy(address account, uint256 amount) internal {
184     require(amount != 0);
185     require(amount <= _balances[account]);
186     _totalSupply = _totalSupply.sub(amount);
187     _balances[account] = _balances[account].sub(amount);
188     emit Transfer(account, address(0), amount);
189   }
190 
191   function destroyFrom(address account, uint256 amount) external {
192     require(amount <= _allowed[account][msg.sender]);
193     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
194     _destroy(account, amount);
195   }
196 }