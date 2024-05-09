1 /**
2 * 
3 ████████  ██████     ███    ███ ███████     ██ ███    ██  ██████  ███████ ███████  █████  ██      ███████ 
4    ██    ██          ████  ████ ██         ██  ████   ██ ██    ██ ██      ██      ██   ██ ██      ██      
5    ██    ██   ███    ██ ████ ██ █████     ██   ██ ██  ██ ██    ██ ███████ █████   ███████ ██      ███████ 
6    ██    ██    ██    ██  ██  ██ ██       ██    ██  ██ ██ ██    ██      ██ ██      ██   ██ ██           ██ 
7    ██     ██████  ██ ██      ██ ███████ ██     ██   ████  ██████  ███████ ███████ ██   ██ ███████ ███████ 
8                                                                                                           
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
78   function decimals() public view returns(uint8) {
79     return _decimals;
80   }
81 }
82 
83 contract noSEAL is ERC20Detailed {
84 
85   using SafeMath for uint256;
86   mapping (address => uint256) private _balances;
87   mapping (address => mapping (address => uint256)) private _allowed;
88 
89   string constant tokenName = "noSEAL";
90   string constant tokenSymbol = "nSEAL";
91   uint8  constant tokenDecimals = 0;
92   uint256 _totalSupply = 100000000;
93   uint256 public basePercent = 100;
94   
95     /**
96     * Mint is in constructor dipshit
97     */
98     
99   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
100     _mint(msg.sender, _totalSupply);
101   }
102   function totalSupply() public view returns (uint256) {
103     return _totalSupply;
104   }
105 
106   function balanceOf(address owner) public view returns (uint256) {
107     return _balances[owner];
108   }
109 
110   function allowance(address owner, address spender) public view returns (uint256) {
111     return _allowed[owner][spender];
112   }
113 
114   function killSeals(uint256 value) public view returns (uint256)  {
115     uint256 roundValue = value.ceil(basePercent);
116     uint256 onePercent = roundValue.mul(basePercent).div(2000);
117     return onePercent;
118   }
119 
120   function transfer(address to, uint256 value) public returns (bool) {
121     require(value <= _balances[msg.sender]);
122     require(to != address(0));
123 
124     uint256 tokensToBurn = killSeals(value);
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
157     uint256 tokensToBurn = killSeals(value);
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
185   function _mint(address account, uint256 amount) internal {
186     require(amount != 0);
187     _balances[account] = _balances[account].add(amount);
188     emit Transfer(address(0), account, amount);
189   }
190 
191   function burn(uint256 amount) external {
192     _burn(msg.sender, amount);
193   }
194 
195   function _burn(address account, uint256 amount) internal {
196     require(amount != 0);
197     require(amount <= _balances[account]);
198     _totalSupply = _totalSupply.sub(amount);
199     _balances[account] = _balances[account].sub(amount);
200     emit Transfer(account, address(0), amount);
201   }
202 
203   function burnFrom(address account, uint256 amount) external {
204     require(amount <= _allowed[account][msg.sender]);
205     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
206     _burn(account, amount);
207   }
208 }