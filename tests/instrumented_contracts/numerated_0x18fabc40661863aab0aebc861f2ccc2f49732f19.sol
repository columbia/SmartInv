1 /*
2 INFERNO (BLAZE)
3 
4 website:  https://inferno.cash
5 
6 discord:  https://discord.gg/VCbevQ
7 
8 2,000,000 BLAZE Initial Supply
9 
10 1,000,000 BLAZE can be claimed on the website
11 
12 2% Burn on Every Transfer
13 
14 1% Goes to Cummunity Fund Project from Every Transfer
15 
16 Community is chosen by the user every month
17 
18 
19 */
20 
21 pragma solidity ^0.5.0;
22 
23 interface IERC20 {
24   function totalSupply() external view returns (uint256);
25   function balanceOf(address who) external view returns (uint256);
26   function allowance(address owner, address spender) external view returns (uint256);
27   function transfer(address to, uint256 value) external returns (bool);
28   function approve(address spender, uint256 value) external returns (bool);
29   function transferFrom(address from, address to, uint256 value) external returns (bool);
30 
31   event Transfer(address indexed from, address indexed to, uint256 value);
32   event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 library SafeMath {
36   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37     if (a == 0) {
38       return 0;
39     }
40     uint256 c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a / b;
47     return c;
48   }
49 
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   function add(uint256 a, uint256 b) internal pure returns (uint256) {
56     uint256 c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 
61   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
62     uint256 c = add(a,m);
63     uint256 d = sub(c,1);
64     return mul(div(d,m),m);
65   }
66 }
67 
68 contract ERC20Detailed is IERC20 {
69 
70   uint8 private _Tokendecimals;
71   string private _Tokenname;
72   string private _Tokensymbol;
73 
74   constructor(string memory name, string memory symbol, uint8 decimals) public {
75    
76    _Tokendecimals = decimals;
77     _Tokenname = name;
78     _Tokensymbol = symbol;
79     
80   }
81 
82   function name() public view returns(string memory) {
83     return _Tokenname;
84   }
85 
86   function symbol() public view returns(string memory) {
87     return _Tokensymbol;
88   }
89 
90   function decimals() public view returns(uint8) {
91     return _Tokendecimals;
92   }
93 }
94 
95 /**end here**/
96 
97 contract Inferno is ERC20Detailed {
98 
99   using SafeMath for uint256;
100   mapping (address => uint256) private _InfernoTokenBalances;
101   mapping (address => mapping (address => uint256)) private _allowed;
102   mapping (address => uint256) public _lastClaimBlock;
103   string constant tokenName = "Inferno";
104   string constant tokenSymbol = "BLAZE";
105   uint8  constant tokenDecimals = 18;
106   uint256 _totalSupply = 2000000e18;
107   uint256 public _nextClaimAmount = 1000e18;
108   address public admin;
109   uint256 public _InfernoFund = 2000000e18;
110   bool public _allowClaims = false;
111   address public _communityAccount;
112   uint256 public _claimPrice = 0;
113  
114  
115   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
116     //_mint(msg.sender, _totalSupply);
117     admin = msg.sender;
118     _communityAccount = msg.sender;   //just until we set one
119   }
120 
121 
122 
123   function totalSupply() public view returns (uint256) {
124     return _totalSupply;
125   }
126 
127   function myTokens() public view returns (uint256) {
128     return _InfernoTokenBalances[msg.sender];
129   }
130 
131   function balanceOf(address owner) public view returns (uint256) {
132     return _InfernoTokenBalances[owner];
133   }
134 
135   function allowance(address owner, address spender) public view returns (uint256) {
136     return _allowed[owner][spender];
137   }
138 
139   function setAllowClaims(bool _setClaims) public {
140     require(msg.sender == admin);
141     _allowClaims = _setClaims;
142   }
143 
144   function setCommunityAcccount(address _newAccount) public {
145     require(msg.sender == admin);
146     _communityAccount = _newAccount;
147   }
148 
149   function setClaimPrice(uint256 _newPrice) public {    //normally price is zero, this will be bot defense if necessary
150     require(msg.sender == admin);
151     _claimPrice = _newPrice;
152   }
153 
154   function distributeETH(address payable _to, uint _amount) public {
155     require(msg.sender == admin);
156     require(_amount <= address(this).balance);
157     _to.transfer(_amount);
158   }
159   
160 
161 
162   function transfer(address to, uint256 value) public returns (bool) {
163     require(value <= _InfernoTokenBalances[msg.sender]);
164     require(to != address(0));
165 
166     uint256 InfernoTokenDecay = value.div(50);   //2%
167     uint256 tokensToTransfer = value.sub(InfernoTokenDecay);
168 
169     uint256 communityAmount = value.div(100);   //1%
170     _InfernoTokenBalances[_communityAccount] = _InfernoTokenBalances[_communityAccount].add(communityAmount);
171     tokensToTransfer = tokensToTransfer.sub(communityAmount);
172 
173     _InfernoTokenBalances[msg.sender] = _InfernoTokenBalances[msg.sender].sub(value);
174     _InfernoTokenBalances[to] = _InfernoTokenBalances[to].add(tokensToTransfer);
175 
176     _totalSupply = _totalSupply.sub(InfernoTokenDecay);
177 
178     emit Transfer(msg.sender, to, tokensToTransfer);
179     emit Transfer(msg.sender, address(0), InfernoTokenDecay);
180     emit Transfer(msg.sender, _communityAccount, communityAmount);
181     return true;
182   }
183 
184   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
185     for (uint256 i = 0; i < receivers.length; i++) {
186       transfer(receivers[i], amounts[i]);
187     }
188   }
189 
190   function approve(address spender, uint256 value) public returns (bool) {
191     require(spender != address(0));
192     _allowed[msg.sender][spender] = value;
193     emit Approval(msg.sender, spender, value);
194     return true;
195   }
196 
197   function transferFrom(address from, address to, uint256 value) public returns (bool) {
198     require(value <= _InfernoTokenBalances[from]);
199     require(value <= _allowed[from][msg.sender]);
200     require(to != address(0));
201 
202     _InfernoTokenBalances[from] = _InfernoTokenBalances[from].sub(value);
203 
204     uint256 InfernoTokenDecay = value.div(50);
205     uint256 tokensToTransfer = value.sub(InfernoTokenDecay);
206 
207      uint256 communityAmount = value.div(100);   //1%
208     _InfernoTokenBalances[_communityAccount] = _InfernoTokenBalances[_communityAccount].add(communityAmount);
209     tokensToTransfer = tokensToTransfer.sub(communityAmount);
210 
211     _InfernoTokenBalances[to] = _InfernoTokenBalances[to].add(tokensToTransfer);
212     _totalSupply = _totalSupply.sub(InfernoTokenDecay);
213 
214     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
215 
216     emit Transfer(from, to, tokensToTransfer);
217     emit Transfer(from, address(0), InfernoTokenDecay);
218     emit Transfer(from, _communityAccount, communityAmount);
219 
220     return true;
221   }
222 
223   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
224     require(spender != address(0));
225     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
226     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
227     return true;
228   }
229 
230   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
231     require(spender != address(0));
232     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
233     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
234     return true;
235   }
236 
237   function burn(uint256 amount) public {
238     _burn(msg.sender, amount);
239   }
240 
241   function _burn(address account, uint256 amount) internal {
242     require(amount != 0);
243     require(amount <= _InfernoTokenBalances[account]);
244     _totalSupply = _totalSupply.sub(amount);
245     _InfernoTokenBalances[account] = _InfernoTokenBalances[account].sub(amount);
246     emit Transfer(account, address(0), amount);
247   }
248 
249   function burnFrom(address account, uint256 amount) external {
250     require(amount <= _allowed[account][msg.sender]);
251     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
252     _burn(account, amount);
253   }
254 
255   function claim() payable public  {
256     require(_allowClaims || (msg.sender == admin));
257     require((block.number.sub(_lastClaimBlock[msg.sender])) >= 5900);
258     require((msg.value >= (_claimPrice.mul(_nextClaimAmount).div(1e18))) || (msg.sender == admin));
259     _InfernoTokenBalances[msg.sender] = _InfernoTokenBalances[msg.sender].add(_nextClaimAmount);
260     emit Transfer(address(this), msg.sender, _nextClaimAmount);
261     _InfernoFund = _InfernoFund.add(_nextClaimAmount);
262     _totalSupply = _totalSupply.add(_nextClaimAmount.mul(2));
263     _nextClaimAmount = _nextClaimAmount.mul(999).div(1000);
264     _lastClaimBlock[msg.sender] = block.number;
265       
266   }
267 
268   function distributeFund(address _to, uint256 _amount) public {
269       require(msg.sender == admin);
270       require(_amount <= _InfernoFund);
271       _InfernoFund = _InfernoFund.sub(_amount);
272       _InfernoTokenBalances[_to] = _InfernoTokenBalances[_to].add(_amount);
273       emit Transfer(address(this), _to, _amount);
274   }
275 
276 }