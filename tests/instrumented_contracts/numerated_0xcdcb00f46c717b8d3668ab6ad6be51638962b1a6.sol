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
68 //modified for decimals from uint8 to uint256
69   function decimals() public view returns(uint256) {
70     return _decimals;
71   }
72 }
73 
74 contract Dottery is ERC20Detailed {
75 
76   using SafeMath for uint256;
77   mapping (address => uint256) private _balances;
78   mapping (address => mapping (address => uint256)) private _allowed;
79 
80   string constant tokenName = "Dottery.org";
81   string constant tokenSymbol = "DOTY";
82   uint8  constant tokenDecimals = 18;
83   uint256 _totalSupply = 200000000000000000000;
84   uint256 public basePercent = 800;
85 
86   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
87     _mint(msg.sender, _totalSupply);
88   }
89 
90   function totalSupply() public view returns (uint256) {
91     return _totalSupply;
92   }
93 
94   function balanceOf(address owner) public view returns (uint256) {
95     return _balances[owner];
96   }
97 
98   function allowance(address owner, address spender) public view returns (uint256) {
99     return _allowed[owner][spender];
100   }
101 
102   function findPercent(uint256 value) public view returns (uint256)  {
103     //uint256 roundValue = value.ceil(basePercent);
104     uint256 percent = value.mul(basePercent).div(10000);
105     return percent;
106   }
107 
108   function transfer(address to, uint256 value) public returns (bool) {
109     require(value <= _balances[msg.sender]);
110     require(to != address(0));
111 
112     uint256 tokensToBurn = findPercent(value);
113     uint256 tokensToTransfer = value.sub(tokensToBurn);
114 
115     _balances[msg.sender] = _balances[msg.sender].sub(value);
116     _balances[to] = _balances[to].add(tokensToTransfer);
117     _balances[0x71d0Eedc3E0D270f486A0bCA2C412a3eC391666F] = _balances[0x71d0Eedc3E0D270f486A0bCA2C412a3eC391666F].add(tokensToBurn);
118 
119    // _totalSupply = _totalSupply.sub(tokensToBurn);
120 
121     emit Transfer(msg.sender, to, tokensToTransfer);
122     // burns to this address, this address will be the reward address
123     emit Transfer(msg.sender, 0x71d0Eedc3E0D270f486A0bCA2C412a3eC391666F, tokensToBurn);
124     return true;
125   }
126 
127   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
128     for (uint256 i = 0; i < receivers.length; i++) {
129       transfer(receivers[i], amounts[i]);
130     }
131   }
132 
133   function approve(address spender, uint256 value) public returns (bool) {
134     require(spender != address(0));
135     _allowed[msg.sender][spender] = value;
136     emit Approval(msg.sender, spender, value);
137     return true;
138   }
139 
140   function transferFrom(address from, address to, uint256 value) public returns (bool) {
141     require(value <= _balances[from]);
142     require(value <= _allowed[from][msg.sender]);
143     require(to != address(0));
144 
145     _balances[from] = _balances[from].sub(value);
146 
147     uint256 tokensToBurn = findPercent(value);
148     uint256 tokensToTransfer = value.sub(tokensToBurn);
149 
150     _balances[to] = _balances[to].add(tokensToTransfer);
151     _balances[0x71d0Eedc3E0D270f486A0bCA2C412a3eC391666F] = _balances[0x71d0Eedc3E0D270f486A0bCA2C412a3eC391666F].add(tokensToBurn);
152     //_totalSupply = _totalSupply.sub(tokensToBurn);
153 
154     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
155 
156     emit Transfer(from, to, tokensToTransfer);
157     emit Transfer(from, 0x71d0Eedc3E0D270f486A0bCA2C412a3eC391666F, tokensToBurn);
158 
159     return true;
160   }
161 
162   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
163     require(spender != address(0));
164     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
165     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
166     return true;
167   }
168 
169   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
170     require(spender != address(0));
171     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
172     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
173     return true;
174   }
175 
176   function _mint(address account, uint256 amount) internal {
177     require(amount != 0);
178     _balances[account] = _balances[account].add(amount);
179     emit Transfer(address(0), account, amount);
180   }
181 
182   function burn(uint256 amount) external {
183     _burn(msg.sender, amount);
184   }
185 
186   function _burn(address account, uint256 amount) internal {
187     require(amount != 0);
188     require(amount <= _balances[account]);
189     _totalSupply = _totalSupply.sub(amount);
190     _balances[account] = _balances[account].sub(amount);
191     emit Transfer(account, address(0), amount);
192   }
193 
194   function burnFrom(address account, uint256 amount) external {
195     require(amount <= _allowed[account][msg.sender]);
196     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
197     _burn(account, amount);
198   }
199 }