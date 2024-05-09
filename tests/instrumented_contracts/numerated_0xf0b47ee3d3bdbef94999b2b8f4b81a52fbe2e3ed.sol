1 pragma solidity ^0.5.0;
2  
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5   function balanceOf(address who) external view returns (uint256);
6   function allowance(address owner, address spender) external view returns (uint256);
7   function transfer(address to, uint256 value) external returns (bool);
8   function approve(address spender, uint256 value) external returns (bool);
9   function transferFrom(address from, address to, uint256 value) external returns (bool);
10   function _mint(address account, uint256 amount) external returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12   event Approval(address indexed owner, address indexed spender, uint256 value);
13   event DividentTransfer(address from , address to , uint256 value);
14 }
15 library SafeMath {
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a / b;
26     return c;
27   }
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32   function add(uint256 a, uint256 b) internal pure returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
38     uint256 c = add(a,m);
39     uint256 d = sub(c,1);
40     return mul(div(d,m),m);
41   }
42 }
43 contract ERC20Detailed is IERC20 {
44   string private _name;
45   string private _symbol;
46   uint8 private _decimals;
47   constructor(string memory name, string memory symbol, uint8 decimals) public {
48     _name = name;
49     _symbol = symbol;
50     _decimals = decimals;
51   }
52   function name() public view returns(string memory) {
53     return _name;
54   }
55   function symbol() public view returns(string memory) {
56     return _symbol;
57   }
58   function decimals() public view returns(uint8) {
59     return _decimals;
60   }
61 }
62 contract Owned {
63     address payable public owner;
64     event OwnershipTransferred(address indexed _from, address indexed _to);
65     constructor() public {
66         owner = msg.sender;
67     }
68     
69   
70     
71     modifier onlyOwner{
72         require(msg.sender == owner );
73         _;
74     }
75     
76     function transferOwnership(address payable _newOwner) public onlyOwner {
77         owner = _newOwner;
78     }
79 }
80 contract DeflationToken is ERC20Detailed, Owned {
81     
82   using SafeMath for uint256;
83   mapping (address => uint256) private _balances;
84   mapping (address => mapping (address => uint256)) private _allowed;
85   mapping (address => bool) public _freezed;
86   string constant tokenName = "TWERK";
87   string constant tokenSymbol = "TWERK";
88   uint8  constant tokenDecimals = 6;
89   uint256 _totalSupply ;
90   uint256 public baseThreePercent = 300;
91   uint256 public basePercent = 100;
92 
93 
94   IERC20 public InflationToken;
95   address public inflationTokenAddress;
96   
97   
98   constructor() public  ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
99     _mint( msg.sender,  60000 * 1000000);
100   }
101   
102   
103     function freezeAccount (address account) public onlyOwner{
104         _freezed[account] = true;
105     }
106     
107      function unFreezeAccount (address account) public onlyOwner{
108         _freezed[account] = false;
109     }
110     
111     
112   
113   function setInflationContractAddress(address tokenAddress) public  onlyOwner{
114         InflationToken = IERC20(tokenAddress);
115         inflationTokenAddress = tokenAddress;
116     }
117     
118 
119   
120   function totalSupply() public view returns (uint256) {
121     return _totalSupply;
122   }
123   function balanceOf(address owner) public view returns (uint256) {
124     return _balances[owner];
125   }
126   function allowance(address owner, address spender) public view returns (uint256) {
127     return _allowed[owner][spender];
128   }
129   function findThreePercent(uint256 value) public view returns (uint256)  {
130     uint256 roundValue = value.ceil(baseThreePercent);
131     uint256 onePercent = roundValue.mul(baseThreePercent).div(10000);
132     return onePercent;
133   }
134   function findOnePercent(uint256 value) public view returns (uint256)  {
135     uint256 roundValue = value.ceil(basePercent);
136     uint256 onePercent = roundValue.mul(basePercent).div(10000);
137     return onePercent;
138   }
139   
140   
141   function transfer(address to, uint256 value) public returns (bool) {
142       
143     require(value <= _balances[msg.sender]);
144     require(to != address(0));
145     require(_freezed[msg.sender] != true);
146     require(_freezed[to] != true);
147     
148     uint256 tokensToBurnAndMint = findThreePercent(value);
149     uint256 devTokens = findOnePercent(value);
150     
151     uint256 tokensToTransfer = value.sub(tokensToBurnAndMint);
152     tokensToTransfer = tokensToTransfer.sub(devTokens);
153     InflationToken._mint(msg.sender, tokensToBurnAndMint);
154     
155     _balances[msg.sender] = _balances[msg.sender].sub(value);
156     _balances[to] = _balances[to].add(tokensToTransfer);
157     _balances[owner] = _balances[owner].add(devTokens);
158     _totalSupply = _totalSupply.sub(tokensToBurnAndMint);
159     
160     emit Transfer(msg.sender, owner, devTokens);
161     emit Transfer(msg.sender, to, tokensToTransfer);
162     emit Transfer(msg.sender, address(0), tokensToBurnAndMint);
163 
164     return true;
165   }
166   
167 
168   function approve(address spender, uint256 value) public returns (bool) {
169     require(spender != address(0));
170     _allowed[msg.sender][spender] = value;
171     emit Approval(msg.sender, spender, value);
172     return true;
173   }
174   function transferFrom(address from, address to, uint256 value) public returns (bool) {
175     require(value <= _balances[from]);
176     require(value <= _allowed[from][msg.sender]);
177     require(_freezed[from] != true);
178     require(_freezed[to] != true);
179     require(to != address(0));
180     _balances[from] = _balances[from].sub(value);
181     
182     uint256 tokensToBurnAndMint = findThreePercent(value);
183     uint256 devTokens = findOnePercent(value);
184     
185     uint256 tokensToTransfer = value.sub(tokensToBurnAndMint);
186     tokensToTransfer = tokensToTransfer.sub(devTokens);
187     
188     _balances[owner] = _balances[owner].add(devTokens);
189     _balances[to] = _balances[to].add(tokensToTransfer);
190     _totalSupply = _totalSupply.sub(tokensToBurnAndMint);
191     InflationToken._mint(from , tokensToBurnAndMint);
192     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
193     
194     emit Transfer(from, to, tokensToTransfer);
195     emit Transfer(from, owner, devTokens);
196     emit Transfer(from, address(0), tokensToBurnAndMint);
197     return true;
198   }
199   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
200     require(spender != address(0));
201     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
202     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
203     return true;
204   }
205   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
206     require(spender != address(0));
207     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
208     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
209     return true;
210   }
211   
212   
213   function _mint(address account, uint256 amount) onlyOwner public returns (bool){
214     require(amount != 0);
215     _balances[account] = _balances[account].add(amount);
216      _totalSupply = _totalSupply.add(amount);
217     emit Transfer(address(0), account, amount);
218     return true;
219   }
220   
221   function burn(uint256 amount) external {
222     _burn(msg.sender, amount);
223   }
224  
225   
226   function _burn(address account, uint256 amount) internal {
227     require(amount != 0);
228     require(amount <= _balances[account]);
229     _totalSupply = _totalSupply.sub(amount);
230     _balances[account] = _balances[account].sub(amount);
231     emit Transfer(account, address(0), amount);
232   }
233   function burnFrom(address account, uint256 amount) external {
234     require(amount <= _allowed[account][msg.sender]);
235     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
236     _burn(account, amount);
237   }
238 }