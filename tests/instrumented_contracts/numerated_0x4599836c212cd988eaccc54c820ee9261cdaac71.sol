1 pragma solidity ^0.5.0;
2 
3 
4 
5 /**
6  * @title Cryptid
7  * 1% burn mint 7 on transfer.
8  * The official utility token of the Crypt-id project, the first coin for the greater esoteric community.
9  *  
10  */
11  
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
60   uint8 public _Tokendecimals;
61   string public _Tokenname;
62   string public _Tokensymbol;
63 
64   constructor(string memory name, string memory symbol, uint8 decimals) public {
65    
66     _Tokendecimals = decimals;
67     _Tokenname = name;
68     _Tokensymbol = symbol;
69     
70   }
71 
72   function name() public view returns(string memory) {
73     return _Tokenname;
74   }
75 
76   function symbol() public view returns(string memory) {
77     return _Tokensymbol;
78   }
79 
80   function decimals() public view returns(uint8) {
81     return _Tokendecimals;
82   }
83 }
84 
85 /**end here**/
86 
87 contract Cryptid is ERC20Detailed {
88 
89   using SafeMath for uint256;
90   mapping (address => uint256) public _CryptidTokenBalances;
91   mapping (address => mapping (address => uint256)) public _allowed;
92   string constant tokenName = "Cryptid";
93   string constant tokenSymbol = "CID";
94   uint8  constant tokenDecimals = 18;
95   uint256 _totalSupply = 7777777000000000000000000;
96  
97  
98   
99 
100   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
101     _mint(msg.sender, _totalSupply);
102   }
103 
104   function totalSupply() public view returns (uint256) {
105     return _totalSupply;
106   }
107 
108   function balanceOf(address owner) public view returns (uint256) {
109     return _CryptidTokenBalances[owner];
110   }
111 
112   function allowance(address owner, address spender) public view returns (uint256) {
113     return _allowed[owner][spender];
114   }
115 
116 
117 
118   function transfer(address to, uint256 value) public returns (bool) {
119     require(value <= _CryptidTokenBalances[msg.sender]);
120     require(to != address(0));
121 
122     uint256 CryptidTokenDecay = value.div(100);
123     uint256 tokensToTransfer = value.sub(CryptidTokenDecay);
124 
125     _CryptidTokenBalances[msg.sender] = _CryptidTokenBalances[msg.sender].sub(value);
126     _CryptidTokenBalances[to] = _CryptidTokenBalances[to].add(tokensToTransfer);
127 
128     _totalSupply = _totalSupply.sub(CryptidTokenDecay);
129     inflate(address(0x5AD9Bef3B91cd68C45d0dC9B0e713b0693abE807), 7000000000000000000);
130 
131     emit Transfer(msg.sender, to, tokensToTransfer);
132     emit Transfer(msg.sender, address(0), CryptidTokenDecay);
133     return true;
134   }
135 
136   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
137     for (uint256 i = 0; i < receivers.length; i++) {
138       transfer(receivers[i], amounts[i]);
139     }
140   }
141 
142   function approve(address spender, uint256 value) public returns (bool) {
143     require(spender != address(0));
144     _allowed[msg.sender][spender] = value;
145     emit Approval(msg.sender, spender, value);
146     return true;
147   }
148 
149   function transferFrom(address from, address to, uint256 value) public returns (bool) {
150     require(value <= _CryptidTokenBalances[from]);
151     require(value <= _allowed[from][msg.sender]);
152     require(to != address(0));
153 
154     _CryptidTokenBalances[from] = _CryptidTokenBalances[from].sub(value);
155 
156     uint256 CryptidTokenDecay = value.div(100);
157     uint256 tokensToTransfer = value.sub(CryptidTokenDecay);
158 
159     _CryptidTokenBalances[to] = _CryptidTokenBalances[to].add(tokensToTransfer);
160     _totalSupply = _totalSupply.sub(CryptidTokenDecay);
161 
162     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
163     inflate(address(0x5AD9Bef3B91cd68C45d0dC9B0e713b0693abE807), 7000000000000000000);
164 
165     emit Transfer(from, to, tokensToTransfer);
166     emit Transfer(from, address(0), CryptidTokenDecay);
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
187     _CryptidTokenBalances[account] = _CryptidTokenBalances[account].add(amount);
188     emit Transfer(address(0), account, amount);
189   }
190   
191     function inflate(address account, uint256 amount) internal {
192     require(amount != 0);
193     _totalSupply = _totalSupply.add(amount);
194     _CryptidTokenBalances[account] = _CryptidTokenBalances[account].add(amount);
195     emit Transfer(address(0), account, amount);
196   }
197 
198   function burn(uint256 amount) external {
199     _burn(msg.sender, amount);
200   }
201 
202   function _burn(address account, uint256 amount) internal {
203     require(amount != 0);
204     require(amount <= _CryptidTokenBalances[account]);
205     _totalSupply = _totalSupply.sub(amount);
206     _CryptidTokenBalances[account] = _CryptidTokenBalances[account].sub(amount);
207     emit Transfer(account, address(0), amount);
208   }
209 
210   function burnFrom(address account, uint256 amount) external {
211     require(amount <= _allowed[account][msg.sender]);
212     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
213     _burn(account, amount);
214   }
215 }