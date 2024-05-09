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
50   string private _name;
51   string private _symbol;
52   uint8 private _decimals;
53 
54   constructor(string memory name, string memory symbol, uint8 decimals) public {
55     _name = name;
56     _symbol = symbol;
57     _decimals = decimals;
58   }
59 
60   function name() public view returns(string memory) {
61     return _name;
62   }
63 
64   function symbol() public view returns(string memory) {
65     return _symbol;
66   }
67 
68   function decimals() public view returns(uint8) {
69     return _decimals;
70   }
71 }
72 
73 contract BAGS is ERC20Detailed {
74 
75   using SafeMath for uint256;
76   mapping (address => uint256) private _balances;
77   mapping (address => mapping (address => uint256)) private _allowed;
78 
79   string constant tokenName     = "BAGS token";
80   string constant tokenSymbol   = "BAGS";
81   uint8  constant tokenDecimals = 18;
82   uint256 _totalSupply          = 1000000000000000000000000;
83   uint256 constant noFee        = 10000000000000000001;
84 
85   //2254066
86   //uint256 constant startBlock            = 8074686; //2%
87   uint256 constant heightEnd20Percent    = 10328752; //1%
88   uint256 constant heightEnd10Percent    = 12582818; //0.5%
89   uint256 constant heightEnd05Percent    = 14836884; //0.25%
90 
91   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
92     _mint(msg.sender, _totalSupply);
93   }
94 
95   function totalSupply() public view returns (uint256) {
96     return _totalSupply;
97   }
98 
99   function balanceOf(address owner) public view returns (uint256) {
100     return _balances[owner];
101   }
102 
103   function allowance(address owner, address spender) public view returns (uint256) {
104     return _allowed[owner][spender];
105   }
106 
107     function findPercent(uint256 value) public view returns (uint256)  {
108         //uint256 roundValue = value.ceil(basePercent);
109         uint256 currentRate = returnRate();
110         uint256 onePercent  = value.div(currentRate);
111         return onePercent;
112     }
113 
114     function returnRate() public view returns(uint256) {
115         if                                       ( block.number < heightEnd20Percent)  return 50;  
116         if (block.number >= heightEnd20Percent  && block.number < heightEnd10Percent)  return 100; 
117         if (block.number >= heightEnd10Percent  && block.number < heightEnd05Percent)  return 200; 
118         if (block.number >= heightEnd05Percent)                                        return 400;
119     }
120 
121 
122 
123   function transfer(address to, uint256 value) public returns (bool) {
124     require(value <= _balances[msg.sender]);
125     require(to != address(0));
126     
127     if (value < noFee) {
128         _transferBurnNo(to,value);
129     } else {
130         _transferBurnYes(to,value);
131     }
132 
133     return true;
134   }
135 
136 
137   function _transferBurnYes(address to, uint256 value) internal {
138     require(value <= _balances[msg.sender]);
139     require(to != address(0));
140     require(value >= noFee);
141 
142     uint256 tokensToBurn = findPercent(value);
143     uint256 tokensToTransfer = value.sub(tokensToBurn);
144 
145     _balances[msg.sender] = _balances[msg.sender].sub(value);
146     _balances[to] = _balances[to].add(tokensToTransfer);
147 
148     _totalSupply = _totalSupply.sub(tokensToBurn);
149 
150     emit Transfer(msg.sender, to, tokensToTransfer);
151     emit Transfer(msg.sender, address(0), tokensToBurn);
152   }
153 
154   function _transferBurnNo(address to, uint256 value) internal {
155     require(value <= _balances[msg.sender]);
156     require(to != address(0));
157     require(value < noFee);
158 
159     _balances[msg.sender] = _balances[msg.sender].sub(value);
160     _balances[to] = _balances[to].add(value);
161 
162     emit Transfer(msg.sender, to, value);
163   }
164 
165   function approve(address spender, uint256 value) public returns (bool) {
166     require(spender != address(0));
167     _allowed[msg.sender][spender] = value;
168     emit Approval(msg.sender, spender, value);
169     return true;
170   }
171 
172   function transferFrom(address from, address to, uint256 value) public returns (bool) {
173     require(value <= _balances[from]);
174     require(value <= _allowed[from][msg.sender]);
175     require(to != address(0));
176 
177     if (value < noFee) {
178         _transferFromBurnNo(from, to, value);
179     } else {
180         _transferFromBurnYes(from, to, value);
181     }
182 
183     return true;
184   }
185 
186 function _transferFromBurnYes(address from, address to, uint256 value) internal {
187     require(value <= _balances[from]);
188     require(value <= _allowed[from][msg.sender]);
189     require(to != address(0));
190     require(value >= noFee);
191 
192     _balances[from] = _balances[from].sub(value);
193 
194     uint256 tokensToBurn = findPercent(value);
195     uint256 tokensToTransfer = value.sub(tokensToBurn);
196 
197     _balances[to] = _balances[to].add(tokensToTransfer);
198     _totalSupply = _totalSupply.sub(tokensToBurn);
199 
200     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
201 
202     emit Transfer(from, to, tokensToTransfer);
203     emit Transfer(from, address(0), tokensToBurn);
204 
205   }
206 
207 function _transferFromBurnNo(address from, address to, uint256 value) internal {
208     require(value <= _balances[from]);
209     require(value <= _allowed[from][msg.sender]);
210     require(to != address(0));
211     require(value < noFee);
212 
213 
214     _balances[from] = _balances[from].sub(value);
215     _balances[to]   = _balances[to].add(value);
216 
217     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
218 
219     emit Transfer(from, to, value);
220 
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
237   function _mint(address account, uint256 amount) internal {
238     require(amount != 0);
239     _balances[account] = _balances[account].add(amount);
240     emit Transfer(address(0), account, amount);
241   }
242 
243   function burn(uint256 amount) external {
244     _burn(msg.sender, amount);
245   }
246 
247   function _burn(address account, uint256 amount) internal {
248     require(amount != 0);
249     require(amount <= _balances[account]);
250     _totalSupply = _totalSupply.sub(amount);
251     _balances[account] = _balances[account].sub(amount);
252     emit Transfer(account, address(0), amount);
253   }
254 
255   function burnFrom(address account, uint256 amount) external {
256     require(amount <= _allowed[account][msg.sender]);
257     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
258     _burn(account, amount);
259   }
260 }