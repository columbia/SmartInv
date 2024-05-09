1 /**
2  *SHRINK Smart Contract
3 */
4 
5 pragma solidity ^0.5.1;
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
19 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
20  
21  /**
22  * @title SafeMath
23  * @dev Unsigned math operations with safety checks that revert on error
24  */
25 library SafeMath {
26     /**
27     * @dev Multiplies two unsigned integers, reverts on overflow.
28     */
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
31         // benefit is lost if 'b' is also tested.
32         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
33         if (a == 0) {
34             return 0;
35         }
36 
37         uint256 c = a * b;
38         require(c / a == b);
39 
40         return c;
41     }
42 
43     /**
44     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
45     */
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         // Solidity only automatically asserts when dividing by 0
48         require(b > 0);
49         uint256 c = a / b;
50         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51 
52         return c;
53     }
54 
55     /**
56     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
57     */
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         require(b <= a);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66     * @dev Adds two unsigned integers, reverts on overflow.
67     */
68     function add(uint256 a, uint256 b) internal pure returns (uint256) {
69         uint256 c = a + b;
70         require(c >= a);
71 
72         return c;
73     }
74 
75     /**
76     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
77     * reverts when dividing by zero.
78     */
79     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
80         require(b != 0);
81         return a % b;
82     }
83 
84     /**
85     * @dev Round number upwards to its nearest integer,
86 	*/
87   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
88     uint256 c = add(a,m);
89     uint256 d = sub(c,1);
90     return mul(div(d,m),m);
91   }
92 }
93 
94 contract ERC20 is IERC20 {
95 
96   string private _name;
97   string private _symbol;
98   uint8 private _decimals;
99 
100   constructor(string memory name, string memory symbol, uint8 decimals) public {
101     _name = name;
102     _symbol = symbol;
103     _decimals = decimals;
104   }
105 
106   function name() public view returns(string memory) {
107     return _name;
108   }
109 
110   function symbol() public view returns(string memory) {
111     return _symbol;
112   }
113 
114   function decimals() public view returns(uint8) {
115     return _decimals;
116   }
117 }
118 
119 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
120 
121 /**
122  * @title Standard ERC20 token
123  *
124  * @dev Implementation of the basic standard token.
125  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
126  * Originally based on code by FirstBlood:
127  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
128  *
129  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
130  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
131  * compliant implementations may not do it.
132  */
133 contract SHRINK is ERC20 {
134 
135   using SafeMath for uint256;
136   mapping (address => uint256) private _balances;
137   mapping (address => mapping (address => uint256)) private _allowed;
138 
139   string constant tokenName = "SHRINK";
140   string constant tokenSymbol = "SHRINK";
141   uint8  constant tokenDecimals = 2;
142   uint256 _totalSupply = 100000000;
143   uint256 public basePercent = 100;
144 
145   constructor() public payable ERC20(tokenName, tokenSymbol, tokenDecimals) {
146     _mint(msg.sender, _totalSupply);
147   }
148 
149   function totalSupply() public view returns (uint256) {
150     return _totalSupply;
151   }
152 
153   function balanceOf(address owner) public view returns (uint256) {
154     return _balances[owner];
155   }
156 
157   function allowance(address owner, address spender) public view returns (uint256) {
158     return _allowed[owner][spender];
159   }
160 
161   function findOnePercent(uint256 value) public view returns (uint256)  {
162     uint256 roundValue = value.ceil(basePercent);
163     uint256 onePercent = roundValue.mul(basePercent).div(10000);
164     return onePercent;
165   }
166 
167   function transfer(address to, uint256 value) public returns (bool) {
168     require(value <= _balances[msg.sender]);
169     require(to != address(0));
170 
171     uint256 tokensToBurn = findOnePercent(value);
172     uint256 tokensToTransfer = value.sub(tokensToBurn);
173 
174     _balances[msg.sender] = _balances[msg.sender].sub(value);
175     _balances[to] = _balances[to].add(tokensToTransfer);
176 
177     _totalSupply = _totalSupply.sub(tokensToBurn);
178 
179     emit Transfer(msg.sender, to, tokensToTransfer);
180     emit Transfer(msg.sender, address(0), tokensToBurn);
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
198     require(value <= _balances[from]);
199     require(value <= _allowed[from][msg.sender]);
200     require(to != address(0));
201 
202     _balances[from] = _balances[from].sub(value);
203 
204     uint256 tokensToBurn = findOnePercent(value);
205     uint256 tokensToTransfer = value.sub(tokensToBurn);
206 
207     _balances[to] = _balances[to].add(tokensToTransfer);
208     _totalSupply = _totalSupply.sub(tokensToBurn);
209 
210     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
211 
212     emit Transfer(from, to, tokensToTransfer);
213     emit Transfer(from, address(0), tokensToBurn);
214 
215     return true;
216   }
217 
218   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
219     require(spender != address(0));
220     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
221     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
222     return true;
223   }
224 
225   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
226     require(spender != address(0));
227     _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
228     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
229     return true;
230   }
231 
232   function _mint(address account, uint256 amount) internal {
233     require(amount != 0);
234     _balances[account] = _balances[account].add(amount);
235     emit Transfer(address(0), account, amount);
236   }
237 
238   function burn(uint256 amount) external {
239     _burn(msg.sender, amount);
240   }
241 
242   function _burn(address account, uint256 amount) internal {
243     require(amount != 0);
244     require(amount <= _balances[account]);
245     _totalSupply = _totalSupply.sub(amount);
246     _balances[account] = _balances[account].sub(amount);
247     emit Transfer(account, address(0), amount);
248   }
249 
250   function burnFrom(address account, uint256 amount) external {
251     require(amount <= _allowed[account][msg.sender]);
252     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
253     _burn(account, amount);
254   }
255 }