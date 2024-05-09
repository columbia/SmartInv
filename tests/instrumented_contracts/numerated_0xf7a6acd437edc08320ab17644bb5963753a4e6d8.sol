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
50   uint8 private _Tokendecimals;
51   string private _Tokenname;
52   string private _Tokensymbol;
53 
54   constructor(string memory name, string memory symbol, uint8 decimals) public {
55    
56    _Tokendecimals = decimals;
57     _Tokenname = name;
58     _Tokensymbol = symbol;
59     
60   }
61 
62   function name() public view returns(string memory) {
63     return _Tokenname;
64   }
65 
66   function symbol() public view returns(string memory) {
67     return _Tokensymbol;
68   }
69 
70   function decimals() public view returns(uint8) {
71     return _Tokendecimals;
72   }
73 }
74 
75 contract PivvrDS is ERC20Detailed {
76 
77   using SafeMath for uint256;
78   mapping (address => uint256) private _PivvrDSTokenBalances;
79   mapping (address => mapping (address => uint256)) private _allowed;
80   string constant tokenName = "PivvrDS";
81   string constant tokenSymbol = "PDS";
82   uint8  constant tokenDecimals = 18;
83   uint256 _totalSupply = 578000000000000000000000;
84  
85  
86   
87 
88   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
89     _mint(msg.sender, _totalSupply);
90   }
91 
92   function totalSupply() public view returns (uint256) {
93     return _totalSupply;
94   }
95 
96   function balanceOf(address owner) public view returns (uint256) {
97     return _PivvrDSTokenBalances[owner];
98   }
99 
100   function allowance(address owner, address spender) public view returns (uint256) {
101     return _allowed[owner][spender];
102   }
103 
104 
105 
106   function transfer(address to, uint256 value) public returns (bool) {
107     require(value <= _PivvrDSTokenBalances[msg.sender]);
108     require(to != address(0));
109 
110     uint256 PivvrDSTokenDecay = value.div(500);
111     uint256 tokensToTransfer = value.sub(PivvrDSTokenDecay);
112 
113     _PivvrDSTokenBalances[msg.sender] = _PivvrDSTokenBalances[msg.sender].sub(value);
114     _PivvrDSTokenBalances[to] = _PivvrDSTokenBalances[to].add(tokensToTransfer);
115 
116     _totalSupply = _totalSupply.sub(PivvrDSTokenDecay);
117 
118     emit Transfer(msg.sender, to, tokensToTransfer);
119     emit Transfer(msg.sender, address(0), PivvrDSTokenDecay);
120     return true;
121   }
122 
123   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
124     for (uint256 i = 0; i < receivers.length; i++) {
125       transfer(receivers[i], amounts[i]);
126     }
127   }
128 
129   function approve(address spender, uint256 value) public returns (bool) {
130     require(spender != address(0));
131     _allowed[msg.sender][spender] = value;
132     emit Approval(msg.sender, spender, value);
133     return true;
134   }
135 
136   function transferFrom(address from, address to, uint256 value) public returns (bool) {
137     require(value <= _PivvrDSTokenBalances[from]);
138     require(value <= _allowed[from][msg.sender]);
139     require(to != address(0));
140 
141     _PivvrDSTokenBalances[from] = _PivvrDSTokenBalances[from].sub(value);
142 
143     uint256 PivvrDSTokenDecay = value.div(500);
144     uint256 tokensToTransfer = value.sub(PivvrDSTokenDecay);
145 
146     _PivvrDSTokenBalances[to] = _PivvrDSTokenBalances[to].add(tokensToTransfer);
147     _totalSupply = _totalSupply.sub(PivvrDSTokenDecay);
148 
149     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
150 
151     emit Transfer(from, to, tokensToTransfer);
152     emit Transfer(from, address(0), PivvrDSTokenDecay);
153 
154     return true;
155   }
156 
157   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
158     require(spender != address(0));
159     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
160     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
161     return true;
162   }
163 
164   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
165     require(spender != address(0));
166     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
167     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
168     return true;
169   }
170 
171   function _mint(address account, uint256 amount) internal {
172     require(amount != 0);
173     _PivvrDSTokenBalances[account] = _PivvrDSTokenBalances[account].add(amount);
174     emit Transfer(address(0), account, amount);
175   }
176 
177   function burn(uint256 amount) external {
178     _burn(msg.sender, amount);
179   }
180 
181   function _burn(address account, uint256 amount) internal {
182     require(amount != 0);
183     require(amount <= _PivvrDSTokenBalances[account]);
184     _totalSupply = _totalSupply.sub(amount);
185     _PivvrDSTokenBalances[account] = _PivvrDSTokenBalances[account].sub(amount);
186     emit Transfer(account, address(0), amount);
187   }
188 
189   function burnFrom(address account, uint256 amount) external {
190     require(amount <= _allowed[account][msg.sender]);
191     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
192     _burn(account, amount);
193   }
194 }