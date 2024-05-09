1 pragma solidity >=0.5.10;
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
48 contract Owned {
49   address public owner;
50   address public newOwner;
51 
52   event OwnershipTransferred(address indexed _from, address indexed _to);
53 
54   constructor() public {
55     owner = msg.sender;
56   }
57 
58   modifier onlyOwner {
59     require(msg.sender == owner);
60     _;
61   }
62 
63   function transferOwnership(address _newOwner) public onlyOwner {
64     newOwner = _newOwner;
65   }
66   function acceptOwnership() public {
67     require(msg.sender == newOwner);
68     emit OwnershipTransferred(owner, newOwner);
69     owner = newOwner;
70     newOwner = address(0);
71   }
72 }
73 
74 contract ERC20Detailed is IERC20, Owned {
75  
76   uint8 private _Tokendecimals;
77   string private _Tokenname;
78   string private _Tokensymbol;
79  
80   constructor(string memory name, string memory symbol, uint8 decimals) public {
81    
82    _Tokendecimals = decimals;
83     _Tokenname = name;
84     _Tokensymbol = symbol;
85    
86   }
87  
88   function name() public view returns(string memory) {
89     return _Tokenname;
90   }
91  
92   function symbol() public view returns(string memory) {
93     return _Tokensymbol;
94   }
95  
96   function decimals() public view returns(uint8) {
97     return _Tokendecimals;
98   }
99 }
100 
101 contract DoYourTip is ERC20Detailed {
102  
103   using SafeMath for uint256;
104   mapping (address => uint256) private _DoYourTipTokenBalances;
105   mapping (address => mapping (address => uint256)) private _allowed;
106   string constant tokenName = "DoYourTip";
107   string constant tokenSymbol = "DYT";
108   uint8  constant tokenDecimals = 18;
109   uint256 _totalSupply = 2000000000000000000000000;
110   
111   mapping (address => bool) private _DoYourTipTokenWhitelistAddrs;
112   bool _burningFlag = true;
113  
114   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
115     _mint(msg.sender, _totalSupply);
116   }
117  
118   function totalSupply() public view returns (uint256) {
119     return _totalSupply;
120   }
121  
122   function balanceOf(address owner) public view returns (uint256) {
123     return _DoYourTipTokenBalances[owner];
124   }
125  
126   function allowance(address owner, address spender) public view returns (uint256) {
127     return _allowed[owner][spender];
128   }
129  
130   function transfer(address to, uint256 value) public returns (bool) {
131     require(value <= _DoYourTipTokenBalances[msg.sender]);
132     require(to != address(0));
133     
134     uint256 DoYourTipTokenDecay = 0;
135     uint256 tokensToTransfer = value;
136     
137     bool burnSomeDYT = ((_burningFlag) && (_DoYourTipTokenWhitelistAddrs[to] != true) && (_DoYourTipTokenWhitelistAddrs[msg.sender] != true));
138     
139     if(burnSomeDYT) {
140         DoYourTipTokenDecay = value.div(50);
141         tokensToTransfer = value.sub(DoYourTipTokenDecay);
142     }
143     _DoYourTipTokenBalances[msg.sender] = _DoYourTipTokenBalances[msg.sender].sub(value);
144     _DoYourTipTokenBalances[to] = _DoYourTipTokenBalances[to].add(tokensToTransfer);
145     
146     if(burnSomeDYT) {
147         _totalSupply = _totalSupply.sub(DoYourTipTokenDecay);
148         emit Transfer(msg.sender, address(0), DoYourTipTokenDecay);
149     }
150     emit Transfer(msg.sender, to, tokensToTransfer);
151     return true;
152   }
153  
154   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
155     for (uint256 i = 0; i < receivers.length; i++) {
156       transfer(receivers[i], amounts[i]);
157     }
158   }
159  
160   function approve(address spender, uint256 value) public returns (bool) {
161     require(spender != address(0));
162     _allowed[msg.sender][spender] = value;
163     emit Approval(msg.sender, spender, value);
164     return true;
165   }
166  
167   function transferFrom(address from, address to, uint256 value) public returns (bool) {
168     require(value <= _DoYourTipTokenBalances[from]);
169     require(value <= _allowed[from][msg.sender]);
170     require(to != address(0));
171  
172     _DoYourTipTokenBalances[from] = _DoYourTipTokenBalances[from].sub(value);
173     
174     uint256 DoYourTipTokenDecay = 0;
175     uint256 tokensToTransfer = value;
176     bool burnSomeDYT = ((_burningFlag) && (_DoYourTipTokenWhitelistAddrs[to] != true) && (_DoYourTipTokenWhitelistAddrs[msg.sender] != true));
177     
178     if(burnSomeDYT) {
179         DoYourTipTokenDecay = value.div(50);
180         tokensToTransfer = value.sub(DoYourTipTokenDecay);
181     }
182  
183     _DoYourTipTokenBalances[to] = _DoYourTipTokenBalances[to].add(tokensToTransfer);
184     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
185  
186     emit Transfer(from, to, tokensToTransfer);
187     
188     if(burnSomeDYT) {
189         _totalSupply = _totalSupply.sub(DoYourTipTokenDecay);
190         emit Transfer(from, address(0), DoYourTipTokenDecay);
191     }
192     return true;
193   }
194  
195   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
196     require(spender != address(0));
197     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
198     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
199     return true;
200   }
201  
202   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
203     require(spender != address(0));
204     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
205     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
206     return true;
207   }
208  
209   function _mint(address account, uint256 amount) internal {
210     require(amount != 0);
211     _DoYourTipTokenBalances[account] = _DoYourTipTokenBalances[account].add(amount);
212     emit Transfer(address(0), account, amount);
213   }
214  
215   function burn(uint256 amount) external {
216     _burn(msg.sender, amount);
217   }
218  
219   function _burn(address account, uint256 amount) internal {
220     require(amount != 0);
221     require(amount <= _DoYourTipTokenBalances[account]);
222     _totalSupply = _totalSupply.sub(amount);
223     _DoYourTipTokenBalances[account] = _DoYourTipTokenBalances[account].sub(amount);
224     emit Transfer(account, address(0), amount);
225   }
226  
227   function burnFrom(address account, uint256 amount) external {
228     require(amount <= _allowed[account][msg.sender]);
229     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
230     _burn(account, amount);
231   }
232   
233   //OWNER ONLY FUNCTIONS
234 
235   function addWhitelist(address user) public onlyOwner() {
236     require(_DoYourTipTokenWhitelistAddrs[user] != true);
237     _DoYourTipTokenWhitelistAddrs[user] = true;
238   }
239   
240   function removeWhitelist(address user) public onlyOwner() {
241     require(_DoYourTipTokenWhitelistAddrs[user] == true);
242     delete _DoYourTipTokenWhitelistAddrs[user];
243   }
244 
245   function turnBurningOn() public onlyOwner() {
246     _burningFlag = true;
247   }
248 
249   function turnBurningOff() public onlyOwner() {
250     _burningFlag = false;
251   }
252 
253 }