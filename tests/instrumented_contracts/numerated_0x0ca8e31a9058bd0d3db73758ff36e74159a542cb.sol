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
46   function floor(uint256 a, uint256 m) internal pure returns (uint256) {
47     uint256 c = add(a,m);
48     uint256 d = add(c,1);
49     return mul(div(d,m),m);
50   }
51 }
52 
53 contract ERC20Detailed is IERC20 {
54 
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
65   function name() public view returns(string memory) {
66     return _name;
67   }
68 
69   function symbol() public view returns(string memory) {
70     return _symbol;
71   }
72 
73   function decimals() public view returns(uint8) {
74     return _decimals;
75   }
76 }
77 
78 contract SPIKECOREv2 is ERC20Detailed {
79 
80   using SafeMath for uint256;
81   mapping (address => uint256) private _balances;
82   mapping (address => mapping (address => uint256)) private _allowed;
83 
84   string constant tokenName = "SPIKECORE";
85   string constant tokenSymbol = "SPK";
86   uint8  constant tokenDecimals = 0;
87   uint256 _totalSupply = 50000;
88   uint256 public baseMultiplier = 3;
89   uint256 public defaultBurn = 1;
90   uint256 public basePercent = 100;
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
108   function findThreePercent(uint256 value) public view returns (uint256)  {
109     if(value<=33){
110         uint256 ThreePercent = defaultBurn;
111         return ThreePercent;
112     }
113     else{
114         uint256 TheePercent = value.mul(baseMultiplier).div(basePercent);
115         uint256 ThreePercent = TheePercent.ceil(defaultBurn);
116         return ThreePercent;
117     }
118     
119   }
120 
121   function transfer(address to, uint256 value) public returns (bool) {
122     require(value <= _balances[msg.sender]);
123     require(to != address(0));
124 
125     uint256 tokensToBurn = findThreePercent(value);
126     uint256 tokensToTransfer = value.sub(tokensToBurn);
127 
128     _balances[msg.sender] = _balances[msg.sender].sub(value);
129     _balances[to] = _balances[to].add(tokensToTransfer);
130 
131     _totalSupply = _totalSupply.sub(tokensToBurn);
132 
133     emit Transfer(msg.sender, to, tokensToTransfer);
134     emit Transfer(msg.sender, address(0), tokensToBurn);
135     return true;
136   }
137 
138   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
139     for (uint256 i = 0; i < receivers.length; i++) {
140       transfer(receivers[i], amounts[i]);
141     }
142   }
143 
144   function approve(address spender, uint256 value) public returns (bool) {
145     require(spender != address(0));
146     _allowed[msg.sender][spender] = value;
147     emit Approval(msg.sender, spender, value);
148     return true;
149   }
150 
151   function transferFrom(address from, address to, uint256 value) public returns (bool) {
152     require(value <= _balances[from]);
153     require(value <= _allowed[from][msg.sender]);
154     require(to != address(0));
155 
156     _balances[from] = _balances[from].sub(value);
157 
158     uint256 tokensToBurn = findThreePercent(value);
159     uint256 tokensToTransfer = value.sub(tokensToBurn);
160 
161     _balances[to] = _balances[to].add(tokensToTransfer);
162     _totalSupply = _totalSupply.sub(tokensToBurn);
163 
164     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
165 
166     emit Transfer(from, to, tokensToTransfer);
167     emit Transfer(from, address(0), tokensToBurn);
168 
169     return true;
170   }
171 
172   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
173     require(spender != address(0));
174     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
175     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
176     return true;
177   }
178 
179   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
180     require(spender != address(0));
181     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
182     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
183     return true;
184   }
185 
186   function _mint(address account, uint256 amount) internal {
187     require(amount != 0);
188     _balances[account] = _balances[account].add(amount);
189     emit Transfer(address(0), account, amount);
190   }
191 
192   function burn(uint256 amount) external {
193     _burn(msg.sender, amount);
194   }
195 
196   function _burn(address account, uint256 amount) internal {
197     require(amount != 0);
198     require(amount <= _balances[account]);
199     _totalSupply = _totalSupply.sub(amount);
200     _balances[account] = _balances[account].sub(amount);
201     emit Transfer(account, address(0), amount);
202   }
203 
204   function burnFrom(address account, uint256 amount) external {
205     require(amount <= _allowed[account][msg.sender]);
206     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
207     _burn(account, amount);
208   }
209 }