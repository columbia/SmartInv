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
15 
16 // ----------------------------------------------------------------------------
17 // Owned contract
18 // ----------------------------------------------------------------------------
19 contract Owned {
20     address payable public owner;
21 
22     event OwnershipTransferred(address indexed _from, address indexed _to);
23 
24     constructor() public {
25         owner = msg.sender;
26     }
27 
28     modifier onlyOwner {
29         require(msg.sender == owner);
30         _;
31     }
32 
33     function transferOwnership(address payable _newOwner) public onlyOwner {
34         owner = _newOwner;
35     }
36 }
37 
38 
39 library SafeMath {
40   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41     if (a == 0) {
42       return 0;
43     }
44     uint256 c = a * b;
45     assert(c / a == b);
46     return c;
47   }
48 
49   function div(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a / b;
51     return c;
52   }
53 
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   function add(uint256 a, uint256 b) internal pure returns (uint256) {
60     uint256 c = a + b;
61     assert(c >= a);
62     return c;
63   }
64 
65   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
66     uint256 c = add(a,m);
67     uint256 d = sub(c,1);
68     return mul(div(d,m),m);
69   }
70 }
71 
72 contract ERC20Detailed is IERC20 {
73 
74   string private _name;
75   string private _symbol;
76   uint8 private _decimals;
77 
78   constructor(string memory name, string memory symbol, uint8 decimals) public {
79     _name = name;
80     _symbol = symbol;
81     _decimals = decimals;
82   }
83 
84   function name() public view returns(string memory) {
85     return _name;
86   }
87 
88   function symbol() public view returns(string memory) {
89     return _symbol;
90   }
91 
92   function decimals() public view returns(uint8) {
93     return _decimals;
94   }
95 }
96 
97 contract DragonNetwork is ERC20Detailed ,Owned {
98 
99   using SafeMath for uint256;
100   mapping (address => uint256) private _balances;
101   mapping (address => mapping (address => uint256)) private _allowed;
102 
103   string constant tokenName = "Dragon Network";
104   string constant tokenSymbol = "DGNN";
105   uint8  constant tokenDecimals = 18;
106   uint256 _totalSupply = 100000000000000000000000;
107   uint256 public basePercent = 100;
108 
109   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
110     _mint(0xe5748Dd7490b3Db2f6617A7aBF7f552045b01049, _totalSupply);
111   }
112 
113   function totalSupply() public view returns (uint256) {
114     return _totalSupply;
115   }
116 
117   function balanceOf(address owner) public view returns (uint256) {
118     return _balances[owner];
119   }
120 
121   function allowance(address owner, address spender) public view returns (uint256) {
122     return _allowed[owner][spender];
123   }
124 
125   function findEightPercent(uint256 value) public view returns (uint256)  {
126     uint256 roundValue = value.ceil(basePercent);
127     uint256 EightPercent = roundValue.mul(basePercent).div(1250);
128     return EightPercent;
129   }
130   
131   function isSupplyLessThan20Thousand() public view returns(bool){
132       uint256 twentyThousand = 100000000000000000000000;
133        if(_totalSupply <= twentyThousand){
134            return true;
135        }
136        return false;
137   }
138 
139   function transfer(address to, uint256 value) public returns (bool) {
140     require(value <= _balances[msg.sender]);
141     require(to != address(0));
142     
143     if(isSupplyLessThan20Thousand()){
144         _balances[msg.sender] =  _balances[msg.sender].sub(value);
145         _balances[to] = _balances[to].add(value);
146         
147         emit Transfer(msg.sender, to, value);
148         return true;
149         
150     }
151     else
152     {
153     uint256 tokensToBurn = findEightPercent(value);
154     uint256 tokensToTransfer = value.sub(tokensToBurn);
155 
156     _balances[msg.sender] = _balances[msg.sender].sub(value);
157     _balances[to] = _balances[to].add(tokensToTransfer);
158 
159     _totalSupply = _totalSupply.sub(tokensToBurn);
160 
161     emit Transfer(msg.sender, to, tokensToTransfer);
162     emit Transfer(msg.sender, address(0), tokensToBurn);
163     return true;
164     }
165 
166 
167   }
168 
169   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
170     for (uint256 i = 0; i < receivers.length; i++) {
171       transfer(receivers[i], amounts[i]);
172     }
173   }
174 
175   function approve(address spender, uint256 value) public returns (bool) {
176     require(spender != address(0));
177     _allowed[msg.sender][spender] = value;
178     emit Approval(msg.sender, spender, value);
179     return true;
180   }
181   
182  
183 
184   function transferFrom(address from, address to, uint256 value) public returns (bool) {
185     require(value <= _balances[from]);
186     require(value <= _allowed[from][msg.sender]);
187     require(to != address(0));
188     
189     if(isSupplyLessThan20Thousand()){
190       
191     _balances[from] = _balances[from].sub(value);
192 
193 
194     _balances[to] = _balances[to].add(value);
195     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
196 
197     emit Transfer(from, to, value);
198 
199     return true;
200     }
201     else
202     {
203 
204     _balances[from] = _balances[from].sub(value);
205 
206     uint256 tokensToBurn = findEightPercent(value);
207     uint256 tokensToTransfer = value.sub(tokensToBurn);
208 
209     _balances[to] = _balances[to].add(tokensToTransfer);
210     _totalSupply = _totalSupply.sub(tokensToBurn);
211 
212     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
213 
214     emit Transfer(from, to, tokensToTransfer);
215     emit Transfer(from, address(0), tokensToBurn);
216 
217     return true;
218     }
219 
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