1 /**
2  *Submitted for verification at Etherscan.io on 2019-06-05
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
78 contract ClaymoreToken is ERC20Detailed {
79 
80   using SafeMath for uint256;
81   mapping (address => uint256) private _ClaymoreTokenBalances;
82   mapping (address => mapping (address => uint256)) private _allowed;
83   string constant tokenName = "Claymore";
84   string constant tokenSymbol = "CLM";
85   uint8  constant tokenDecimals = 18;
86   uint256 _totalSupply = 50000000*(10**uint256(tokenDecimals));
87   uint256 _totalBurned;
88   bool fullSupplyUnlocked;
89   address owner;
90  
91   
92 
93   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
94     _mint(msg.sender, _totalSupply);
95     owner = msg.sender;
96   }
97 
98   function totalSupply() public view returns (uint256) {
99     return _totalSupply;
100   }
101   function totalBurned() public view returns(uint256){
102       return _totalBurned;
103   }
104 
105   function balanceOf(address owner) public view returns (uint256) {
106     return _ClaymoreTokenBalances[owner];
107   }
108   function allowance(address owner, address spender) public view returns (uint256) {
109     return _allowed[owner][spender];
110   }
111   function unlockFullSupply() public
112   {
113      require(msg.sender == owner);
114      require(!fullSupplyUnlocked);
115      
116      uint256 mintAmount = 50000000*(10**uint256(tokenDecimals));
117      _mint(owner, mintAmount);
118      fullSupplyUnlocked = true;
119      _totalSupply = _totalSupply.add(mintAmount);
120   }
121   function transfer(address to, uint256 value) public returns (bool) {
122     require(value <= _ClaymoreTokenBalances[msg.sender]);
123     require(to != address(0));
124     require(to != address(this));
125 
126     uint256 ClaymoreTokenDecay = value.div(50);
127     uint256 tokensToTransfer = value.sub(ClaymoreTokenDecay);
128 
129     _ClaymoreTokenBalances[msg.sender] = _ClaymoreTokenBalances[msg.sender].sub(value);
130     _ClaymoreTokenBalances[to] = _ClaymoreTokenBalances[to].add(tokensToTransfer);
131 
132     _totalSupply = _totalSupply.sub(ClaymoreTokenDecay);
133     _totalBurned = _totalBurned.add(ClaymoreTokenDecay);
134 
135     emit Transfer(msg.sender, to, tokensToTransfer);
136     emit Transfer(msg.sender, address(0), ClaymoreTokenDecay);
137     return true;
138   }
139 
140   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
141     for (uint256 i = 0; i < receivers.length; i++) {
142       transfer(receivers[i], amounts[i]);
143     }
144   }
145 
146   function approve(address spender, uint256 value) public returns (bool) {
147     require(spender != address(0));
148     _allowed[msg.sender][spender] = value;
149     emit Approval(msg.sender, spender, value);
150     return true;
151   }
152 
153   function transferFrom(address from, address to, uint256 value) public returns (bool) {
154     require(value <= _ClaymoreTokenBalances[from]);
155     require(value <= _allowed[from][msg.sender]);
156     require(to != address(0));
157 
158     _ClaymoreTokenBalances[from] = _ClaymoreTokenBalances[from].sub(value);
159 
160     uint256 ClaymoreTokenDecay = value.div(50);
161     uint256 tokensToTransfer = value.sub(ClaymoreTokenDecay);
162 
163     _ClaymoreTokenBalances[to] = _ClaymoreTokenBalances[to].add(tokensToTransfer);
164     _totalSupply = _totalSupply.sub(ClaymoreTokenDecay);
165     _totalBurned = _totalBurned.add(ClaymoreTokenDecay);
166     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
167 
168     emit Transfer(from, to, tokensToTransfer);
169     emit Transfer(from, address(0), ClaymoreTokenDecay);
170 
171     return true;
172   }
173 
174   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
175     require(spender != address(0));
176     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
177     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
178     return true;
179   }
180 
181   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
182     require(spender != address(0));
183     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
184     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
185     return true;
186   }
187 
188   function _mint(address account, uint256 amount) internal {
189     require(amount != 0);
190     _ClaymoreTokenBalances[account] = _ClaymoreTokenBalances[account].add(amount);
191     emit Transfer(address(0), account, amount);
192   }
193 
194   function burn(uint256 amount) external {
195     _burn(msg.sender, amount);
196   }
197 
198   function _burn(address account, uint256 amount) internal {
199     require(amount != 0);
200     require(amount <= _ClaymoreTokenBalances[account]);
201     _totalSupply = _totalSupply.sub(amount);
202     _ClaymoreTokenBalances[account] = _ClaymoreTokenBalances[account].sub(amount);
203     emit Transfer(account, address(0), amount);
204   }
205 
206   function burnFrom(address account, uint256 amount) external {
207     require(amount <= _allowed[account][msg.sender]);
208     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
209     _burn(account, amount);
210   }
211 }