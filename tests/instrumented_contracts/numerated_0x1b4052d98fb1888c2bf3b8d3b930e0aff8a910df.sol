1 /**
2  * official website https://communitytoken.network
3 */
4 
5 pragma solidity ^0.5.17;
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
54   string private _name;
55   string private _symbol;
56   uint8 private _decimals;
57 
58   constructor(string memory name, string memory symbol, uint8 decimals) public {
59     _name = name;
60     _symbol = symbol;
61     _decimals = decimals;
62   }
63 
64   function name() public view returns(string memory) {
65     return _name;
66   }
67 
68   function symbol() public view returns(string memory) {
69     return _symbol;
70   }
71 
72   function decimals() public view returns(uint8) {
73     return _decimals;
74   }
75 }
76 
77 contract COM is ERC20Detailed {
78 
79   using SafeMath for uint256;
80   mapping (address => uint256) private _balances;
81   mapping (address => mapping (address => uint256)) private _allowed;
82 
83   string constant tokenName     = "Community Token";
84   string constant tokenSymbol   = "COM";
85   uint8  constant tokenDecimals = 18;
86   uint256 _totalSupply          = 1000000000000000000000000;
87   uint256 constant noFee        = 10000000000000000001;
88 
89   //2254066
90   //uint256 constant startBlock            = 8074686; //2%
91   uint256 constant heightEnd20Percent    = 10328752; //1%
92   uint256 constant heightEnd10Percent    = 12582818; //0.5%
93   uint256 constant heightEnd05Percent    = 14836884; //0.25%
94 
95   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
96     _mint(msg.sender, _totalSupply);
97   }
98 
99   function totalSupply() public view returns (uint256) {
100     return _totalSupply;
101   }
102 
103   function balanceOf(address owner) public view returns (uint256) {
104     return _balances[owner];
105   }
106 
107   function allowance(address owner, address spender) public view returns (uint256) {
108     return _allowed[owner][spender];
109   }
110 
111     function findPercent(uint256 value) public view returns (uint256)  {
112         //uint256 roundValue = value.ceil(basePercent);
113         uint256 currentRate = returnRate();
114         uint256 onePercent  = value.div(currentRate);
115         return onePercent;
116     }
117 
118     function returnRate() public view returns(uint256) {
119         if                                       ( block.number < heightEnd20Percent)  return 50;  
120         if (block.number >= heightEnd20Percent  && block.number < heightEnd10Percent)  return 100; 
121         if (block.number >= heightEnd10Percent  && block.number < heightEnd05Percent)  return 200; 
122         if (block.number >= heightEnd05Percent)                                        return 400;
123     }
124 
125 
126 
127   function transfer(address to, uint256 value) public returns (bool) {
128     require(value <= _balances[msg.sender]);
129     require(to != address(0));
130     
131     if (value < noFee) {
132         _transferBurnNo(to,value);
133     } else {
134         _transferBurnYes(to,value);
135     }
136 
137     return true;
138   }
139 
140 
141   function _transferBurnYes(address to, uint256 value) internal {
142     require(value <= _balances[msg.sender]);
143     require(to != address(0));
144     require(value >= noFee);
145 
146     uint256 tokensToBurn = findPercent(value);
147     uint256 tokensToTransfer = value.sub(tokensToBurn);
148 
149     _balances[msg.sender] = _balances[msg.sender].sub(value);
150     _balances[to] = _balances[to].add(tokensToTransfer);
151 
152     _totalSupply = _totalSupply.sub(tokensToBurn);
153 
154     emit Transfer(msg.sender, to, tokensToTransfer);
155     emit Transfer(msg.sender, address(0), tokensToBurn);
156   }
157 
158   function _transferBurnNo(address to, uint256 value) internal {
159     require(value <= _balances[msg.sender]);
160     require(to != address(0));
161     require(value < noFee);
162 
163     _balances[msg.sender] = _balances[msg.sender].sub(value);
164     _balances[to] = _balances[to].add(value);
165 
166     emit Transfer(msg.sender, to, value);
167   }
168 
169   function approve(address spender, uint256 value) public returns (bool) {
170     require(spender != address(0));
171     _allowed[msg.sender][spender] = value;
172     emit Approval(msg.sender, spender, value);
173     return true;
174   }
175 
176   function transferFrom(address from, address to, uint256 value) public returns (bool) {
177     require(value <= _balances[from]);
178     require(value <= _allowed[from][msg.sender]);
179     require(to != address(0));
180 
181     if (value < noFee) {
182         _transferFromBurnNo(from, to, value);
183     } else {
184         _transferFromBurnYes(from, to, value);
185     }
186 
187     return true;
188   }
189 
190 function _transferFromBurnYes(address from, address to, uint256 value) internal {
191     require(value <= _balances[from]);
192     require(value <= _allowed[from][msg.sender]);
193     require(to != address(0));
194     require(value >= noFee);
195 
196     _balances[from] = _balances[from].sub(value);
197 
198     uint256 tokensToBurn = findPercent(value);
199     uint256 tokensToTransfer = value.sub(tokensToBurn);
200 
201     _balances[to] = _balances[to].add(tokensToTransfer);
202     _totalSupply = _totalSupply.sub(tokensToBurn);
203 
204     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
205 
206     emit Transfer(from, to, tokensToTransfer);
207     emit Transfer(from, address(0), tokensToBurn);
208 
209   }
210 
211 function _transferFromBurnNo(address from, address to, uint256 value) internal {
212     require(value <= _balances[from]);
213     require(value <= _allowed[from][msg.sender]);
214     require(to != address(0));
215     require(value < noFee);
216 
217 
218     _balances[from] = _balances[from].sub(value);
219     _balances[to]   = _balances[to].add(value);
220 
221     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
222 
223     emit Transfer(from, to, value);
224 
225   }
226 
227   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
228     require(spender != address(0));
229     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
230     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
231     return true;
232   }
233 
234   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
235     require(spender != address(0));
236     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
237     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
238     return true;
239   }
240 
241   function _mint(address account, uint256 amount) internal {
242     require(amount != 0);
243     _balances[account] = _balances[account].add(amount);
244     emit Transfer(address(0), account, amount);
245   }
246 
247   function burn(uint256 amount) external {
248     _burn(msg.sender, amount);
249   }
250 
251   function _burn(address account, uint256 amount) internal {
252     require(amount != 0);
253     require(amount <= _balances[account]);
254     _totalSupply = _totalSupply.sub(amount);
255     _balances[account] = _balances[account].sub(amount);
256     emit Transfer(account, address(0), amount);
257   }
258 
259   function burnFrom(address account, uint256 amount) external {
260     require(amount <= _allowed[account][msg.sender]);
261     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
262     _burn(account, amount);
263   }
264 }