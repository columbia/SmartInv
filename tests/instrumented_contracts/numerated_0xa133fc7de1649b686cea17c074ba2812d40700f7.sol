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
41   function ceil(uint256 a) internal pure returns (uint256) {
42     uint256 c = div(a,100);
43     // uint256 d = sub(c,1);
44     return c;
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
73 contract Fltc is ERC20Detailed {
74 
75   using SafeMath for uint256;
76   mapping (address => uint256) private _balances;
77   mapping (address => mapping (address => uint256)) private _allowed;
78 
79   string constant tokenName = "FLTC";
80   string constant tokenSymbol = "FLTC";
81   uint8  constant tokenDecimals = 15;
82   uint256 _totalSupply = 2121212121000000000000000;
83   uint256 public basePercent = 100;
84 
85   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
86     _mint(msg.sender, _totalSupply);
87   }
88   
89   function getBalance(address addr) public view returns(uint){
90     return addr.balance;
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
105   function findOnePercent(uint256 value) public view returns (uint256)  {
106       if (balanceOf(address(0)) >= 2100212121000000000000000) {
107           return 0;
108       }
109     uint256 roundValue = value.ceil();
110     uint256 onePercent = roundValue.mul(basePercent).div(basePercent);
111     return onePercent;
112   }
113 
114   function transfer(address to, uint256 value) public returns (bool) {
115     require(value <= _balances[msg.sender]);
116     require(to != address(0));
117 
118     uint256 tokensToBurn = findOnePercent(value);
119     uint256 tokensToTransfer = value.sub(tokensToBurn);
120 
121     _balances[msg.sender] = _balances[msg.sender].sub(value);
122     _balances[to] = _balances[to].add(tokensToTransfer);
123     
124     _balances[address(0)] = _balances[address(0)].add(tokensToBurn);
125 
126     _totalSupply = _totalSupply.sub(tokensToBurn);
127 
128     emit Transfer(msg.sender, to, tokensToTransfer);
129     emit Transfer(msg.sender, address(0), tokensToBurn);
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
153     uint256 tokensToBurn = findOnePercent(value);
154     uint256 tokensToTransfer = value.sub(tokensToBurn);
155 
156     _balances[to] = _balances[to].add(tokensToTransfer);
157     _totalSupply = _totalSupply.sub(tokensToBurn);
158 
159     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
160 
161     emit Transfer(from, to, tokensToTransfer);
162     emit Transfer(from, address(0), tokensToBurn);
163 
164     return true;
165   }
166 
167   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
168     require(spender != address(0));
169     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
170     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
171     return true;
172   }
173 
174   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
175     require(spender != address(0));
176     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
177     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
178     return true;
179   }
180 
181   function _mint(address account, uint256 amount) internal {
182     require(amount != 0);
183     _balances[account] = _balances[account].add(amount);
184     emit Transfer(address(0), account, amount);
185   }
186 
187   function burn(uint256 amount) external {
188     _burn(msg.sender, amount);
189   }
190 
191   function _burn(address account, uint256 amount) internal {
192     require(amount != 0);
193     require(amount <= _balances[account]);
194     _totalSupply = _totalSupply.sub(amount);
195     _balances[account] = _balances[account].sub(amount);
196     emit Transfer(account, address(0), amount);
197   }
198 
199   function burnFrom(address account, uint256 amount) external {
200     require(amount <= _allowed[account][msg.sender]);
201     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
202     _burn(account, amount);
203   }
204 }