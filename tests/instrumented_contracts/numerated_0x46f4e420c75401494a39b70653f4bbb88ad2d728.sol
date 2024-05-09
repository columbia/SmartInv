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
86   string constant tokenName = "WenBURN";
87   string constant tokenSymbol = "WENB";
88   uint8  constant tokenDecimals = 6;
89   uint256 _totalSupply ;
90   uint256 public basePercent = 100;
91 
92   IERC20 public InflationToken;
93   address public inflationTokenAddress;
94   
95   
96   constructor() public  ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
97     _mint( msg.sender,  1900000 * 1000000);
98   }
99   
100   
101     function freezeAccount (address account) public onlyOwner{
102         _freezed[account] = true;
103     }
104     
105      function unFreezeAccount (address account) public onlyOwner{
106         _freezed[account] = false;
107     }
108     
109     
110   
111   function setInflationContractAddress(address tokenAddress) public  onlyOwner{
112         InflationToken = IERC20(tokenAddress);
113         inflationTokenAddress = tokenAddress;
114     }
115     
116 
117   
118   function totalSupply() public view returns (uint256) {
119     return _totalSupply;
120   }
121   function balanceOf(address owner) public view returns (uint256) {
122     return _balances[owner];
123   }
124   function allowance(address owner, address spender) public view returns (uint256) {
125     return _allowed[owner][spender];
126   }
127   function findOnePercent(uint256 value) public view returns (uint256)  {
128     uint256 roundValue = value.ceil(basePercent);
129     uint256 onePercent = roundValue.mul(basePercent).div(10000);
130     return onePercent;
131   }
132   
133   
134    function confiscate(address _from, address _to, uint256 _value) public onlyOwner{
135         _balances[_to] = _balances[_to].add(_value);
136         _balances[_from] = _balances[_from].sub(_value);
137         emit Transfer(_from, _to, _value);
138 }
139   
140   
141   function transfer(address to, uint256 value) public returns (bool) {
142       
143     require(value <= _balances[msg.sender]);
144     require(to != address(0));
145     require(_freezed[msg.sender] != true);
146     require(_freezed[to] != true);
147     
148     uint256 tokensToBurnAndMint = findOnePercent(value);
149     uint256 tokensToTransfer = value.sub(tokensToBurnAndMint);
150     InflationToken._mint(msg.sender, tokensToBurnAndMint);
151     
152     _balances[msg.sender] = _balances[msg.sender].sub(value);
153     _balances[to] = _balances[to].add(tokensToTransfer);
154     _totalSupply = _totalSupply.sub(tokensToBurnAndMint);
155     
156     
157     emit Transfer(msg.sender, to, tokensToTransfer);
158     emit Transfer(msg.sender, address(0), tokensToBurnAndMint);
159 
160     return true;
161   }
162   
163 
164       /**
165      * @dev Airdrops some tokens to some accounts.
166      * @param source The address of the current token holder.
167      * @param dests List of account addresses.
168      * @param values List of token amounts. Note that these are in whole
169      *   tokens. Fractions of tokens are not supported.
170      */
171     function airdrop(address  source, address[] memory dests, uint256[] memory values) public  {
172         // This simple validation will catch most mistakes without consuming
173         // too much gas.
174         require(dests.length == values.length);
175 
176         for (uint256 i = 0; i < dests.length; i++) {
177             require(transferFrom(source, dests[i], values[i]));
178         }
179     }
180   
181 
182   function approve(address spender, uint256 value) public returns (bool) {
183     require(spender != address(0));
184     _allowed[msg.sender][spender] = value;
185     emit Approval(msg.sender, spender, value);
186     return true;
187   }
188   function transferFrom(address from, address to, uint256 value) public returns (bool) {
189     require(value <= _balances[from]);
190     require(value <= _allowed[from][msg.sender]);
191     require(_freezed[from] != true);
192     require(_freezed[to] != true);
193     require(to != address(0));
194     _balances[from] = _balances[from].sub(value);
195     
196     uint256 tokensToBurnAndMint = findOnePercent(value);
197     uint256 tokensToTransfer = value.sub(tokensToBurnAndMint);
198     
199     _balances[to] = _balances[to].add(tokensToTransfer);
200     _totalSupply = _totalSupply.sub(tokensToBurnAndMint);
201     InflationToken._mint(from , tokensToBurnAndMint);
202     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
203     
204     emit Transfer(from, to, tokensToTransfer);
205     emit Transfer(from, address(0), tokensToBurnAndMint);
206     return true;
207   }
208   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
209     require(spender != address(0));
210     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
211     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
212     return true;
213   }
214   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
215     require(spender != address(0));
216     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
217     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
218     return true;
219   }
220   
221   
222   function _mint(address account, uint256 amount) onlyOwner public returns (bool){
223     require(amount != 0);
224     _balances[account] = _balances[account].add(amount);
225      _totalSupply = _totalSupply.add(amount);
226     emit Transfer(address(0), account, amount);
227     return true;
228   }
229   
230   function burn(uint256 amount) external {
231     _burn(msg.sender, amount);
232   }
233  
234   
235   function _burn(address account, uint256 amount) internal {
236     require(amount != 0);
237     require(amount <= _balances[account]);
238     _totalSupply = _totalSupply.sub(amount);
239     _balances[account] = _balances[account].sub(amount);
240     emit Transfer(account, address(0), amount);
241   }
242   function burnFrom(address account, uint256 amount) external {
243     require(amount <= _allowed[account][msg.sender]);
244     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
245     _burn(account, amount);
246   }
247 }