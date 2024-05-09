1 pragma solidity ^0.5.0;
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
48 contract ERC20Detailed is IERC20 {
49 
50   string private _name;
51   string private _symbol;
52   uint8 private _decimals;
53 
54   constructor(string memory name, string memory symbol, uint8 decimals) public {
55     _name = name;
56     _symbol = symbol;
57     _decimals = decimals;
58   }
59 
60   function name() public view returns(string memory) {
61     return _name;
62   }
63 
64   function symbol() public view returns(string memory) {
65     return _symbol;
66   }
67 
68   function decimals() public view returns(uint8) {
69     return _decimals;
70   }
71 }
72 
73 contract YAB is ERC20Detailed {
74 
75   using SafeMath for uint256;
76   address _owner;
77   
78   mapping (address => uint256) private _balances;
79   mapping (address => mapping (address => uint256)) private _allowed;
80   mapping (address => bool) public whitelist;
81   
82   string constant tokenName = "Yet Another Bomb";
83   string constant tokenSymbol = "YAB";
84   
85   uint8 constant tokenDecimals = 0;
86   uint256 public _totalSupply = 1000000;
87   uint256 public _totalClaimed;
88   uint256 public basePercent = 100;
89   uint256 public airdropAmount;
90   
91   modifier onlyOwner() {
92       require(msg.sender == _owner);
93       _;
94   }
95   
96   modifier onlyWhitelist() {
97       require(whitelist[msg.sender] == true);
98       _;
99   }
100 
101   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
102     _owner = msg.sender;
103     airdropAmount = 400;
104   }
105   
106   function setAirdropAmount(uint256 _amount) external onlyOwner {
107       airdropAmount = _amount;
108   }
109   
110   function enableWhitelist(address[] memory addresses) public onlyOwner {
111       for (uint i = 0; i < addresses.length; i++) {
112           whitelist[addresses[i]] = true;
113       }
114   }
115   
116   function withdrawForeignTokens(address _contract) external {
117       IERC20 token = IERC20(_contract);
118       uint256 amount = token.balanceOf(address(this));
119       token.transfer(_owner, amount);
120   }
121   
122   function getAirdrop() external onlyWhitelist {
123       require(_totalClaimed.add(airdropAmount) <= _totalSupply);
124       _totalClaimed = _totalClaimed.add(airdropAmount);
125       whitelist[msg.sender] = false;
126       _mint(msg.sender, airdropAmount);
127   }
128   
129   function checkWhitelist() public view returns (bool) {
130       return whitelist[msg.sender];
131   }
132 
133   function totalSupply() public view returns (uint256) {
134     return _totalSupply;
135   }
136 
137   function balanceOf(address owner) public view returns (uint256) {
138     return _balances[owner];
139   }
140 
141   function allowance(address owner, address spender) public view returns (uint256) {
142     return _allowed[owner][spender];
143   }
144 
145   function findOnePercent(uint256 value) public view returns (uint256)  {
146     uint256 roundValue = value.ceil(basePercent);
147     uint256 onePercent = roundValue.mul(basePercent).div(10000);
148     return onePercent;
149   }
150 
151   function transfer(address to, uint256 value) public returns (bool) {
152     require(value <= _balances[msg.sender]);
153     require(to != address(0));
154 
155     uint256 tokensToBurn = findOnePercent(value);
156     uint256 tokensToTransfer = value.sub(tokensToBurn);
157 
158     _balances[msg.sender] = _balances[msg.sender].sub(value);
159     _balances[to] = _balances[to].add(tokensToTransfer);
160 
161     _totalSupply = _totalSupply.sub(tokensToBurn);
162 
163     emit Transfer(msg.sender, to, tokensToTransfer);
164     emit Transfer(msg.sender, address(0), tokensToBurn);
165     return true;
166   }
167 
168   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
169     for (uint256 i = 0; i < receivers.length; i++) {
170       transfer(receivers[i], amounts[i]);
171     }
172   }
173 
174   function approve(address spender, uint256 value) public returns (bool) {
175     require(spender != address(0));
176     _allowed[msg.sender][spender] = value;
177     emit Approval(msg.sender, spender, value);
178     return true;
179   }
180 
181   function transferFrom(address from, address to, uint256 value) public returns (bool) {
182     require(value <= _balances[from]);
183     require(value <= _allowed[from][msg.sender]);
184     require(to != address(0));
185 
186     _balances[from] = _balances[from].sub(value);
187 
188     uint256 tokensToBurn = findOnePercent(value);
189     uint256 tokensToTransfer = value.sub(tokensToBurn);
190 
191     _balances[to] = _balances[to].add(tokensToTransfer);
192     _totalSupply = _totalSupply.sub(tokensToBurn);
193 
194     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
195 
196     emit Transfer(from, to, tokensToTransfer);
197     emit Transfer(from, address(0), tokensToBurn);
198 
199     return true;
200   }
201 
202   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
203     require(spender != address(0));
204     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
205     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
206     return true;
207   }
208 
209   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
210     require(spender != address(0));
211     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
212     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
213     return true;
214   }
215 
216   function _mint(address account, uint256 amount) internal {
217     require(amount != 0);
218     _balances[account] = _balances[account].add(amount);
219     emit Transfer(address(0), account, amount);
220   }
221 
222   function burn(uint256 amount) external {
223     _burn(msg.sender, amount);
224   }
225 
226   function _burn(address account, uint256 amount) internal {
227     require(amount != 0);
228     require(amount <= _balances[account]);
229     _totalSupply = _totalSupply.sub(amount);
230     _balances[account] = _balances[account].sub(amount);
231     emit Transfer(account, address(0), amount);
232   }
233 
234   function burnFrom(address account, uint256 amount) external {
235     require(amount <= _allowed[account][msg.sender]);
236     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
237     _burn(account, amount);
238   }
239 }