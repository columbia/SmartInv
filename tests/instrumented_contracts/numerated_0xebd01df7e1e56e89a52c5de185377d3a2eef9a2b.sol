1 pragma solidity ^0.5.1;
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
15 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
16  
17  /**
18  * @title SafeMath
19  * @dev Unsigned math operations with safety checks that revert on error
20  */
21 library SafeMath {
22     /**
23     * @dev Multiplies two unsigned integers, reverts on overflow.
24     */
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
27         // benefit is lost if 'b' is also tested.
28         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
29         if (a == 0) {
30             return 0;
31         }
32 
33         uint256 c = a * b;
34         require(c / a == b);
35 
36         return c;
37     }
38 
39     /**
40     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
41     */
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         // Solidity only automatically asserts when dividing by 0
44         require(b > 0);
45         uint256 c = a / b;
46         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47 
48         return c;
49     }
50 
51     /**
52     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
53     */
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         require(b <= a);
56         uint256 c = a - b;
57 
58         return c;
59     }
60 
61     /**
62     * @dev Adds two unsigned integers, reverts on overflow.
63     */
64     function add(uint256 a, uint256 b) internal pure returns (uint256) {
65         uint256 c = a + b;
66         require(c >= a);
67 
68         return c;
69     }
70 
71     /**
72     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
73     * reverts when dividing by zero.
74     */
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         require(b != 0);
77         return a % b;
78     }
79 
80     /**
81     * @dev Round number upwards to its nearest integer,
82 	*/
83   function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
84     uint256 c = add(a,m);
85     uint256 d = sub(c,1);
86     return mul(div(d,m),m);
87   }
88 }
89 
90 contract ERC20 is IERC20 {
91 
92   string private _name;
93   string private _symbol;
94   uint8 private _decimals;
95 
96   constructor(string memory name, string memory symbol, uint8 decimals) public {
97     _name = name;
98     _symbol = symbol;
99     _decimals = decimals;
100   }
101 
102   function name() public view returns(string memory) {
103     return _name;
104   }
105 
106   function symbol() public view returns(string memory) {
107     return _symbol;
108   }
109 
110   function decimals() public view returns(uint8) {
111     return _decimals;
112   }
113 }
114 
115 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
122  * Originally based on code by FirstBlood:
123  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
124  *
125  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
126  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
127  * compliant implementations may not do it.
128  */
129 contract FlameHyre is ERC20 {
130 
131   using SafeMath for uint256;
132   mapping (address => uint256) private _balances;
133   mapping (address => mapping (address => uint256)) private _allowed;
134 
135   string constant tokenName = "FlameHyre Token";
136   string constant tokenSymbol = "FHT";
137   uint8  constant tokenDecimals = 8;
138   uint256 _totalSupply = 200000000000000;
139   uint256 public basePercent = 100;
140 
141   constructor() public payable ERC20(tokenName, tokenSymbol, tokenDecimals) {
142     _mint(msg.sender, _totalSupply);
143   }
144 
145   function totalSupply() public view returns (uint256) {
146     return _totalSupply;
147   }
148 
149   function balanceOf(address owner) public view returns (uint256) {
150     return _balances[owner];
151   }
152 
153   function allowance(address owner, address spender) public view returns (uint256) {
154     return _allowed[owner][spender];
155   }
156 
157   function findOnePercent(uint256 value) public view returns (uint256)  {
158     uint256 roundValue = value.ceil(basePercent);
159     uint256 onePercent = roundValue.mul(basePercent).div(10000);
160     return onePercent;
161   }
162 
163   function transfer(address to, uint256 value) public returns (bool) {
164     require(value <= _balances[msg.sender]);
165     require(to != address(0));
166 
167     uint256 tokensToBurn = findOnePercent(value);
168     uint256 tokensToTransfer = value.sub(tokensToBurn);
169 
170     _balances[msg.sender] = _balances[msg.sender].sub(value);
171     _balances[to] = _balances[to].add(tokensToTransfer);
172 
173     _totalSupply = _totalSupply.sub(tokensToBurn);
174 
175     emit Transfer(msg.sender, to, tokensToTransfer);
176     emit Transfer(msg.sender, address(0), tokensToBurn);
177     return true;
178   }
179 
180   function multiTransfer(address[] memory receivers, uint256[] memory amounts) public {
181     for (uint256 i = 0; i < receivers.length; i++) {
182       transfer(receivers[i], amounts[i]);
183     }
184   }
185 
186   function approve(address spender, uint256 value) public returns (bool) {
187     require(spender != address(0));
188     _allowed[msg.sender][spender] = value;
189     emit Approval(msg.sender, spender, value);
190     return true;
191   }
192 
193   function transferFrom(address from, address to, uint256 value) public returns (bool) {
194     require(value <= _balances[from]);
195     require(value <= _allowed[from][msg.sender]);
196     require(to != address(0));
197 
198     _balances[from] = _balances[from].sub(value);
199 
200     uint256 tokensToBurn = findOnePercent(value);
201     uint256 tokensToTransfer = value.sub(tokensToBurn);
202 
203     _balances[to] = _balances[to].add(tokensToTransfer);
204     _totalSupply = _totalSupply.sub(tokensToBurn);
205 
206     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
207 
208     emit Transfer(from, to, tokensToTransfer);
209     emit Transfer(from, address(0), tokensToBurn);
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
228   function _mint(address account, uint256 amount) internal {
229     require(amount != 0);
230     _balances[account] = _balances[account].add(amount);
231     emit Transfer(address(0), account, amount);
232   }
233 
234   function burn(uint256 amount) external {
235     _burn(msg.sender, amount);
236   }
237 
238   function _burn(address account, uint256 amount) internal {
239     require(amount != 0);
240     require(amount <= _balances[account]);
241     _totalSupply = _totalSupply.sub(amount);
242     _balances[account] = _balances[account].sub(amount);
243     emit Transfer(account, address(0), amount);
244   }
245 
246   function burnFrom(address account, uint256 amount) external {
247     require(amount <= _allowed[account][msg.sender]);
248     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(amount);
249     _burn(account, amount);
250   }
251 }