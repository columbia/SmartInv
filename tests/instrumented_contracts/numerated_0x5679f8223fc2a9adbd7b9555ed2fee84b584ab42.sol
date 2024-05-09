1 /**
2  *Submitted for verification at Etherscan.io on 2019-07-07
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
19 
20 // ----------------------------------------------------------------------------
21 // Owned contract
22 // ----------------------------------------------------------------------------
23 contract Owned {
24     address payable public owner;
25 
26     event OwnershipTransferred(address indexed _from, address indexed _to);
27 
28     constructor() public {
29         owner = msg.sender;
30     }
31 
32     modifier onlyOwner {
33         require(msg.sender == owner);
34         _;
35     }
36 
37     function transferOwnership(address payable _newOwner) public onlyOwner {
38         owner = _newOwner;
39     }
40 }
41 
42 
43 library SafeMath {
44   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45     if (a == 0) {
46       return 0;
47     }
48     uint256 c = a * b;
49     assert(c / a == b);
50     return c;
51   }
52 
53   function div(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a / b;
55     return c;
56   }
57 
58   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   function add(uint256 a, uint256 b) internal pure returns (uint256) {
64     uint256 c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 
69   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
70     uint256 c = add(a,m);
71     uint256 d = sub(c,1);
72     return mul(div(d,m),m);
73   }
74 }
75 
76 contract ERC20Detailed is IERC20 {
77 
78   string private _name;
79   string private _symbol;
80   uint8 private _decimals;
81 
82   constructor(string memory name, string memory symbol, uint8 decimals) public {
83     _name = name;
84     _symbol = symbol;
85     _decimals = decimals;
86   }
87 
88   function name() public view returns(string memory) {
89     return _name;
90   }
91 
92   function symbol() public view returns(string memory) {
93     return _symbol;
94   }
95 
96   function decimals() public view returns(uint8) {
97     return _decimals;
98   }
99 }
100 
101 contract Kaboom is ERC20Detailed ,Owned {
102 
103   using SafeMath for uint256;
104   mapping (address => uint256) private _balances;
105   mapping (address => mapping (address => uint256)) private _allowed;
106 
107   string constant tokenName = "Kaboom";
108   string constant tokenSymbol = "Boom";
109   uint8  constant tokenDecimals = 18;
110   uint256 _totalSupply = 1000000 * 10 ** 18;
111   uint256 public basePercent = 100;
112 
113   constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) {
114     _mint(0x29537611D1F7df84Adb075969f38F591DEef5A55, _totalSupply);
115   }
116 
117   function totalSupply() public view returns (uint256) {
118     return _totalSupply;
119   }
120 
121   function balanceOf(address owner) public view returns (uint256) {
122     return _balances[owner];
123   }
124 
125   function allowance(address owner, address spender) public view returns (uint256) {
126     return _allowed[owner][spender];
127   }
128 
129   function findFivePercent(uint256 value) public view returns (uint256)  {
130     uint256 roundValue = value.ceil(basePercent);
131     uint256 onePercent = roundValue.mul(basePercent).div(2000);
132     return onePercent;
133   }
134   
135   function isSupplyLessThan100Thousand() public view returns(bool){
136       uint256 hunderedThousand = 100000 * 10 ** 18;
137        if(_totalSupply <= hunderedThousand){
138            return true;
139        }
140        return false;
141   }
142 
143   function transfer(address to, uint256 value) public returns (bool) {
144     require(value <= _balances[msg.sender]);
145     require(to != address(0));
146     
147     if(isSupplyLessThan100Thousand()){
148         _balances[msg.sender] =  _balances[msg.sender].sub(value);
149         _balances[to] = _balances[to].add(value);
150         
151         emit Transfer(msg.sender, to, value);
152         return true;
153         
154     }
155     else
156     {
157     uint256 tokensToBurn = findFivePercent(value);
158     uint256 tokensToTransfer = value.sub(tokensToBurn);
159 
160     _balances[msg.sender] = _balances[msg.sender].sub(value);
161     _balances[to] = _balances[to].add(tokensToTransfer);
162 
163     _totalSupply = _totalSupply.sub(tokensToBurn);
164 
165     emit Transfer(msg.sender, to, tokensToTransfer);
166     emit Transfer(msg.sender, address(0), tokensToBurn);
167     return true;
168     }
169 
170 
171   }
172 
173   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
174     for (uint256 i = 0; i < receivers.length; i++) {
175       transfer(receivers[i], amounts[i]);
176     }
177   }
178 
179   function approve(address spender, uint256 value) public returns (bool) {
180     require(spender != address(0));
181     _allowed[msg.sender][spender] = value;
182     emit Approval(msg.sender, spender, value);
183     return true;
184   }
185   
186  
187 
188   function transferFrom(address from, address to, uint256 value) public returns (bool) {
189     require(value <= _balances[from]);
190     require(value <= _allowed[from][msg.sender]);
191     require(to != address(0));
192     
193     if(isSupplyLessThan100Thousand()){
194       
195     _balances[from] = _balances[from].sub(value);
196 
197 
198     _balances[to] = _balances[to].add(value);
199     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
200 
201     emit Transfer(from, to, value);
202 
203     return true;
204     }
205     else
206     {
207 
208     _balances[from] = _balances[from].sub(value);
209 
210     uint256 tokensToBurn = findFivePercent(value);
211     uint256 tokensToTransfer = value.sub(tokensToBurn);
212 
213     _balances[to] = _balances[to].add(tokensToTransfer);
214     _totalSupply = _totalSupply.sub(tokensToBurn);
215 
216     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
217 
218     emit Transfer(from, to, tokensToTransfer);
219     emit Transfer(from, address(0), tokensToBurn);
220 
221     return true;
222     }
223 
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