1 /*
2 *  statera.sol
3 *  STA V3 deflationary index token smart contract
4 *  2020-05-29
5 **/
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
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a / b;
31     return c;
32   }
33 
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint256 a, uint256 b) internal pure returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 
45   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
46     uint256 c = add(a,m);
47     uint256 d = sub(c,1);
48     return mul(div(d,m),m);
49   }
50 }
51 
52 contract ERC20Detailed is IERC20 {
53 
54   string private _name;
55   string private _symbol;
56   uint8 private _decimals;
57 
58   constructor(string memory name, string memory symbol, uint8 decimals) public {
59     _name = name;
60     _symbol = symbol;
61     _decimals = decimals;
62   }
63 
64   function name() public view returns(string memory) {
65     return _name;
66   }
67 
68   function symbol() public view returns(string memory) {
69     return _symbol;
70   }
71 
72   function decimals() public view returns(uint8) {
73     return _decimals;
74   }
75 }
76 
77 contract Statera is ERC20Detailed {
78 
79   using SafeMath for uint256;
80   mapping (address => uint256) private _balances;
81   mapping (address => mapping (address => uint256)) private _allowed;
82 
83   string constant tokenName = "Statera";
84   string constant tokenSymbol = "STA";
85   uint8  constant tokenDecimals = 18;
86   uint256 _totalSupply = 101000000000000000000000000;
87   uint256 public basePercent = 100;
88 
89   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
90     _issue(msg.sender, _totalSupply);
91   }
92 
93   function totalSupply() public view returns (uint256) {
94     return _totalSupply;
95   }
96 
97   function balanceOf(address owner) public view returns (uint256) {
98     return _balances[owner];
99   }
100 
101   function allowance(address owner, address spender) public view returns (uint256) {
102     return _allowed[owner][spender];
103   }
104 
105   function cut(uint256 value) public view returns (uint256)  {
106     uint256 roundValue = value.ceil(basePercent);
107     uint256 cutValue = roundValue.mul(basePercent).div(10000);
108     return cutValue;
109   }
110 
111   function transfer(address to, uint256 value) public returns (bool) {
112     require(value <= _balances[msg.sender]);
113     require(to != address(0));
114 
115     uint256 tokensToBurn = cut(value);
116     uint256 tokensToTransfer = value.sub(tokensToBurn);
117 
118     _balances[msg.sender] = _balances[msg.sender].sub(value);
119     _balances[to] = _balances[to].add(tokensToTransfer);
120 
121     _totalSupply = _totalSupply.sub(tokensToBurn);
122 
123     emit Transfer(msg.sender, to, tokensToTransfer);
124     emit Transfer(msg.sender, address(0), tokensToBurn);
125     return true;
126   }
127 
128 
129   function approve(address spender, uint256 value) public returns (bool) {
130     require(spender != address(0));
131     _allowed[msg.sender][spender] = value;
132     emit Approval(msg.sender, spender, value);
133     return true;
134   }
135 
136   function transferFrom(address from, address to, uint256 value) public returns (bool) {
137     require(value <= _balances[from]);
138     require(value <= _allowed[from][msg.sender]);
139     require(to != address(0));
140 
141     _balances[from] = _balances[from].sub(value);
142 
143     uint256 tokensToBurn = cut(value);
144     uint256 tokensToTransfer = value.sub(tokensToBurn);
145 
146     _balances[to] = _balances[to].add(tokensToTransfer);
147     _totalSupply = _totalSupply.sub(tokensToBurn);
148 
149     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
150 
151     emit Transfer(from, to, tokensToTransfer);
152     emit Transfer(from, address(0), tokensToBurn);
153 
154     return true;
155   }
156 
157   function upAllowance(address spender, uint256 addedValue) public returns (bool) {
158     require(spender != address(0));
159     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
160     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
161     return true;
162   }
163 
164   function downAllowance(address spender, uint256 subtractedValue) public returns (bool) {
165     require(spender != address(0));
166     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
167     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
168     return true;
169   }
170 
171   function _issue(address account, uint256 amount) internal {
172     require(amount != 0);
173     _balances[account] = _balances[account].add(amount);
174     emit Transfer(address(0), account, amount);
175   }
176 
177   function destroy(uint256 amount) external {
178     _destroy(msg.sender, amount);
179   }
180 
181   function _destroy(address account, uint256 amount) internal {
182     require(amount != 0);
183     require(amount <= _balances[account]);
184     _totalSupply = _totalSupply.sub(amount);
185     _balances[account] = _balances[account].sub(amount);
186     emit Transfer(account, address(0), amount);
187   }
188 
189   function destroyFrom(address account, uint256 amount) external {
190     require(amount <= _allowed[account][msg.sender]);
191     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
192     _destroy(account, amount);
193   }
194 }