1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-19
3 */
4  
5 pragma solidity ^0.5.0;
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
54   uint8 private _Tokendecimals;
55   string private _Tokenname;
56   string private _Tokensymbol;
57  
58   constructor(string memory name, string memory symbol, uint8 decimals) public {
59    
60    _Tokendecimals = decimals;
61     _Tokenname = name;
62     _Tokensymbol = symbol;
63    
64   }
65  
66   function name() public view returns(string memory) {
67     return _Tokenname;
68   }
69  
70   function symbol() public view returns(string memory) {
71     return _Tokensymbol;
72   }
73  
74   function decimals() public view returns(uint8) {
75     return _Tokendecimals;
76   }
77 }
78  
79 /**end here**/
80  
81 contract INC8Token is ERC20Detailed {
82  
83   using SafeMath for uint256;
84   mapping (address => uint256) private _INC8TokenBalances;
85   mapping (address => mapping (address => uint256)) private _allowed;
86   string constant tokenName = "Incinerate Token v2";
87   string constant tokenSymbol = "INC8";
88   uint8  constant tokenDecimals = 2;
89   uint256 _totalSupply = 100000000;
90  
91  
92  
93  
94   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
95     _mint(msg.sender, _totalSupply);
96   }
97  
98   function totalSupply() public view returns (uint256) {
99     return _totalSupply;
100   }
101  
102   function balanceOf(address owner) public view returns (uint256) {
103     return _INC8TokenBalances[owner];
104   }
105  
106   function allowance(address owner, address spender) public view returns (uint256) {
107     return _allowed[owner][spender];
108   }
109  
110  
111  
112   function transfer(address to, uint256 value) public returns (bool) {
113     require(value <= _INC8TokenBalances[msg.sender]);
114     require(to != address(0));
115  
116     uint256 INC8TokenDecay = value.div(20);
117     uint256 tokensToTransfer = value.sub(INC8TokenDecay);
118  
119     _INC8TokenBalances[msg.sender] = _INC8TokenBalances[msg.sender].sub(value);
120     _INC8TokenBalances[to] = _INC8TokenBalances[to].add(tokensToTransfer);
121  
122     _totalSupply = _totalSupply.sub(INC8TokenDecay);
123  
124     emit Transfer(msg.sender, to, tokensToTransfer);
125     emit Transfer(msg.sender, address(0), INC8TokenDecay);
126     return true;
127   }
128  
129   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
130     for (uint256 i = 0; i < receivers.length; i++) {
131       transfer(receivers[i], amounts[i]);
132     }
133   }
134  
135   function approve(address spender, uint256 value) public returns (bool) {
136     require(spender != address(0));
137     _allowed[msg.sender][spender] = value;
138     emit Approval(msg.sender, spender, value);
139     return true;
140   }
141  
142   function transferFrom(address from, address to, uint256 value) public returns (bool) {
143     require(value <= _INC8TokenBalances[from]);
144     require(value <= _allowed[from][msg.sender]);
145     require(to != address(0));
146  
147     _INC8TokenBalances[from] = _INC8TokenBalances[from].sub(value);
148  
149     uint256 INC8TokenDecay = value.div(20);
150     uint256 tokensToTransfer = value.sub(INC8TokenDecay);
151  
152     _INC8TokenBalances[to] = _INC8TokenBalances[to].add(tokensToTransfer);
153     _totalSupply = _totalSupply.sub(INC8TokenDecay);
154  
155     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
156  
157     emit Transfer(from, to, tokensToTransfer);
158     emit Transfer(from, address(0), INC8TokenDecay);
159  
160     return true;
161   }
162  
163   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
164     require(spender != address(0));
165     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
166     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
167     return true;
168   }
169  
170   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
171     require(spender != address(0));
172     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
173     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
174     return true;
175   }
176  
177   function _mint(address account, uint256 amount) internal {
178     require(amount != 0);
179     _INC8TokenBalances[account] = _INC8TokenBalances[account].add(amount);
180     emit Transfer(address(0), account, amount);
181   }
182  
183   function burn(uint256 amount) external {
184     _burn(msg.sender, amount);
185   }
186  
187   function _burn(address account, uint256 amount) internal {
188     require(amount != 0);
189     require(amount <= _INC8TokenBalances[account]);
190     _totalSupply = _totalSupply.sub(amount);
191     _INC8TokenBalances[account] = _INC8TokenBalances[account].sub(amount);
192     emit Transfer(account, address(0), amount);
193   }
194  
195   function burnFrom(address account, uint256 amount) external {
196     require(amount <= _allowed[account][msg.sender]);
197     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
198     _burn(account, amount);
199   }
200 }