1 /*
2 INFERNO (BLAZE)
3 
4 website:  https://inferno.cash
5 
6 discord:  https://discord.gg/VCbevQ
7 
8 3,000,000 BLAZE Initial Supply
9 
10 2% Burn on Every Transfer
11 
12 1% Goes to Cummunity Fund Project from Every Transfer
13 
14 Community is chosen by the user every month
15 
16 
17 */
18 
19 pragma solidity ^0.5.0;
20 
21 
22 interface IERC20 {
23   function totalSupply() external view returns (uint256);
24   function balanceOf(address who) external view returns (uint256);
25   function allowance(address owner, address spender) external view returns (uint256);
26   function transfer(address to, uint256 value) external returns (bool);
27   function approve(address spender, uint256 value) external returns (bool);
28   function transferFrom(address from, address to, uint256 value) external returns (bool);
29 
30   event Transfer(address indexed from, address indexed to, uint256 value);
31   event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 library SafeMath {
35   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36     if (a == 0) {
37       return 0;
38     }
39     uint256 c = a * b;
40     assert(c / a == b);
41     return c;
42   }
43 
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a / b;
46     return c;
47   }
48 
49   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 
60   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
61     uint256 c = add(a,m);
62     uint256 d = sub(c,1);
63     return mul(div(d,m),m);
64   }
65 }
66 
67 contract ERC20Detailed is IERC20 {
68 
69   uint8 private _Tokendecimals;
70   string private _Tokenname;
71   string private _Tokensymbol;
72 
73   constructor(string memory name, string memory symbol, uint8 decimals) public {
74    
75    _Tokendecimals = decimals;
76     _Tokenname = name;
77     _Tokensymbol = symbol;
78     
79   }
80 
81   function name() public view returns(string memory) {
82     return _Tokenname;
83   }
84 
85   function symbol() public view returns(string memory) {
86     return _Tokensymbol;
87   }
88 
89   function decimals() public view returns(uint8) {
90     return _Tokendecimals;
91   }
92 }
93 
94 /**end here**/
95 
96 contract Inferno is ERC20Detailed {
97 
98   using SafeMath for uint256;
99   mapping (address => uint256) private _InfernoTokenBalances;
100   mapping (address => mapping (address => uint256)) private _allowed;
101   string constant tokenName = "Inferno";
102   string constant tokenSymbol = "BLAZE";
103   uint8  constant tokenDecimals = 18;
104   uint256 _totalSupply = 3000000e18;
105   address public admin;
106   uint256 public _InfernoFund = 3000000e18;    
107   address public _communityAccount;
108 
109 
110  
111  
112   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
113     //_mint(msg.sender, _totalSupply);
114     admin = msg.sender;
115     _communityAccount = msg.sender;   //just until we set one
116   }
117 
118 
119 
120   function totalSupply() public view returns (uint256) {
121     return _totalSupply;
122   }
123 
124   function myTokens() public view returns (uint256) {
125     return _InfernoTokenBalances[msg.sender];
126   }
127 
128   function balanceOf(address owner) public view returns (uint256) {
129     return _InfernoTokenBalances[owner];
130   }
131 
132   function allowance(address owner, address spender) public view returns (uint256) {
133     return _allowed[owner][spender];
134   }
135 
136   function setCommunityAcccount(address _newAccount) public {
137     require(msg.sender == admin);
138     _communityAccount = _newAccount;
139   }
140  
141 
142   function transfer(address to, uint256 value) public returns (bool) {
143     require(value <= _InfernoTokenBalances[msg.sender]);
144     require(to != address(0));
145 
146     uint256 InfernoTokenDecay = value.div(50);   //2%
147     uint256 tokensToTransfer = value.sub(InfernoTokenDecay);
148 
149     uint256 communityAmount = value.div(100);   //1%
150     _InfernoTokenBalances[_communityAccount] = _InfernoTokenBalances[_communityAccount].add(communityAmount);
151     tokensToTransfer = tokensToTransfer.sub(communityAmount);
152 
153     _InfernoTokenBalances[msg.sender] = _InfernoTokenBalances[msg.sender].sub(value);
154     _InfernoTokenBalances[to] = _InfernoTokenBalances[to].add(tokensToTransfer);
155 
156     _totalSupply = _totalSupply.sub(InfernoTokenDecay);
157 
158     emit Transfer(msg.sender, to, tokensToTransfer);
159     emit Transfer(msg.sender, address(0), InfernoTokenDecay);
160     emit Transfer(msg.sender, _communityAccount, communityAmount);
161     return true;
162   }
163 
164   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
165     for (uint256 i = 0; i < receivers.length; i++) {
166       transfer(receivers[i], amounts[i]);
167     }
168   }
169 
170  function multiSend(address[] memory receivers, uint256[] memory amounts) public {  //this is mainly for resetting from the snapshot
171     require(msg.sender == admin);
172     for (uint256 i = 0; i < receivers.length; i++) {
173       //transfer(receivers[i], amounts[i]);
174       _InfernoTokenBalances[receivers[i]] = amounts[i];
175       _InfernoFund = _InfernoFund.sub(amounts[i]);
176       emit Transfer(address(this), receivers[i], amounts[i]);
177     }
178   }
179 
180 
181   function approve(address spender, uint256 value) public returns (bool) {
182     require(spender != address(0));
183     _allowed[msg.sender][spender] = value;
184     emit Approval(msg.sender, spender, value);
185     return true;
186   }
187 
188   function transferFrom(address from, address to, uint256 value) public returns (bool) {
189     require(value <= _InfernoTokenBalances[from]);
190     require(value <= _allowed[from][msg.sender]);
191     require(to != address(0));
192 
193     _InfernoTokenBalances[from] = _InfernoTokenBalances[from].sub(value);
194 
195     uint256 InfernoTokenDecay = value.div(50);
196     uint256 tokensToTransfer = value.sub(InfernoTokenDecay);
197 
198      uint256 communityAmount = value.div(100);   //1%
199     _InfernoTokenBalances[_communityAccount] = _InfernoTokenBalances[_communityAccount].add(communityAmount);
200     tokensToTransfer = tokensToTransfer.sub(communityAmount);
201 
202     _InfernoTokenBalances[to] = _InfernoTokenBalances[to].add(tokensToTransfer);
203     _totalSupply = _totalSupply.sub(InfernoTokenDecay);
204 
205     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
206 
207     emit Transfer(from, to, tokensToTransfer);
208     emit Transfer(from, address(0), InfernoTokenDecay);
209     emit Transfer(from, _communityAccount, communityAmount);
210 
211     return true;
212   }
213 
214   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
215     require(spender != address(0));
216     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
217     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
218     return true;
219   }
220 
221   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
222     require(spender != address(0));
223     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
224     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
225     return true;
226   }
227 
228   function burn(uint256 amount) public {
229     _burn(msg.sender, amount);
230   }
231 
232   function _burn(address account, uint256 amount) internal {
233     require(amount != 0);
234     require(amount <= _InfernoTokenBalances[account]);
235     _totalSupply = _totalSupply.sub(amount);
236     _InfernoTokenBalances[account] = _InfernoTokenBalances[account].sub(amount);
237     emit Transfer(account, address(0), amount);
238   }
239 
240   function burnFrom(address account, uint256 amount) external {
241     require(amount <= _allowed[account][msg.sender]);
242     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
243     _burn(account, amount);
244   }
245 
246   function distributeFund(address _to, uint256 _amount) public {
247       require(msg.sender == admin);
248       require(_amount <= _InfernoFund);
249       _InfernoFund = _InfernoFund.sub(_amount);
250       _InfernoTokenBalances[_to] = _InfernoTokenBalances[_to].add(_amount);
251       emit Transfer(address(this), _to, _amount);
252   }
253 
254 }