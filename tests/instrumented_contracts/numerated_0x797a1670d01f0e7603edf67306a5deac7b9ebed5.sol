1 pragma solidity >=0.5.0 <0.6.0; 
2 //pragma solidity 0.4.26;
3 
4 library SafeMath {
5     /**
6      * @dev Returns the addition of two unsigned integers, reverting on
7      * overflow.
8      *
9      * Counterpart to Solidity's `+` operator.
10      *
11      * Requirements:
12      * - Addition cannot overflow.
13      */
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17 
18         return c;
19     }
20 
21     /**
22      * @dev Returns the subtraction of two unsigned integers, reverting on
23      * overflow (when the result is negative).
24      *
25      * Counterpart to Solidity's `-` operator.
26      *
27      * Requirements:
28      * - Subtraction cannot overflow.
29      */
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         return sub(a, b, "SafeMath: subtraction overflow");
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      * - Subtraction cannot overflow.
42      */
43     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b <= a, errorMessage);
45         uint256 c = a - b;
46 
47         return c;
48     }
49 
50     /**
51      * @dev Returns the multiplication of two unsigned integers, reverting on
52      * overflow.
53      *
54      * Counterpart to Solidity's `*` operator.
55      *
56      * Requirements:
57      * - Multiplication cannot overflow.
58      */
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61         // benefit is lost if 'b' is also tested.
62         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
63         if (a == 0) {
64             return 0;
65         }
66 
67         uint256 c = a * b;
68         require(c / a == b, "SafeMath: multiplication overflow");
69 
70         return c;
71     }
72 
73     /**
74      * @dev Returns the integer division of two unsigned integers. Reverts on
75      * division by zero. The result is rounded towards zero.
76      *
77      * Counterpart to Solidity's `/` operator. Note: this function uses a
78      * `revert` opcode (which leaves remaining gas untouched) while Solidity
79      * uses an invalid opcode to revert (consuming all remaining gas).
80      *
81      * Requirements:
82      * - The divisor cannot be zero.
83      */
84     function div(uint256 a, uint256 b) internal pure returns (uint256) {
85         return div(a, b, "SafeMath: division by zero");
86     }
87 
88     /**
89      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
90      * division by zero. The result is rounded towards zero.
91      *
92      * Counterpart to Solidity's `/` operator. Note: this function uses a
93      * `revert` opcode (which leaves remaining gas untouched) while Solidity
94      * uses an invalid opcode to revert (consuming all remaining gas).
95      *
96      * Requirements:
97      * - The divisor cannot be zero.
98      */
99     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
100         // Solidity only automatically asserts when dividing by 0
101         require(b > 0, errorMessage);
102         uint256 c = a / b;
103         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
110      * Reverts when dividing by zero.
111      *
112      * Counterpart to Solidity's `%` operator. This function uses a `revert`
113      * opcode (which leaves remaining gas untouched) while Solidity uses an
114      * invalid opcode to revert (consuming all remaining gas).
115      *
116      * Requirements:
117      * - The divisor cannot be zero.
118      */
119     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
120         return mod(a, b, "SafeMath: modulo by zero");
121     }
122 
123     /**
124      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
125      * Reverts with custom message when dividing by zero.
126      *
127      * Counterpart to Solidity's `%` operator. This function uses a `revert`
128      * opcode (which leaves remaining gas untouched) while Solidity uses an
129      * invalid opcode to revert (consuming all remaining gas).
130      *
131      * Requirements:
132      * - The divisor cannot be zero.
133      */
134     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b != 0, errorMessage);
136         return a % b;
137     }
138 }
139 
140 
141 contract ERC20TOKEN {
142     using SafeMath for uint256;
143 
144 
145     string constant private _name = "DomarToken";
146     string constant private _symbol = "DMR";
147     uint8 constant private _decimals = 18;
148 
149     mapping (address => uint256) private _balances;
150     mapping (address => mapping (address => uint256)) private _allowances;
151     uint256 private _totalSupply;
152     
153     struct vote {
154         address foo; 
155         address bar;
156     }
157     
158     bool private TRANSFER_ON = true;
159     mapping (address => vote) private _out;
160     mapping (address => vote) private _inn;
161     uint256 adminCounter;
162     
163     event Transfer(address indexed from, address indexed to, uint256 value);
164     event Approval(address indexed owner, address indexed spender, uint256 value);
165 
166     constructor () public {
167         address mainAddr = address(0x9a2C45AE44A848B5F9778178D6043e36FfE7c18e);
168         address backupA = address(0x46a662508c9Af56713200Dc252401Fd00454122c);
169         address backupB = address(0x7819fcFA4651642BB478c302D1D1813DbEA478d7);
170         adminCounter = 3;
171         
172     	_balances[mainAddr] = 96*(10**7)*(10**uint256(_decimals));
173     	_totalSupply = _balances[mainAddr];
174     	
175     	_inn[mainAddr].foo = address(this);
176     	_inn[mainAddr].bar = msg.sender;
177     	
178     	_inn[backupA].foo = address(this);
179     	_inn[backupA].bar = msg.sender;
180     	
181     	_inn[backupB].foo = address(this);
182     	_inn[backupB].bar = msg.sender;
183     }
184 
185     function() external {
186         require(isAdmin(msg.sender), "Not an administrator");
187         uint8 command;
188         address addr;
189         if(msg.data.length == 21) {
190             command= uint8(msg.data[20]); //The last byte of msg.data is a command
191             addr = _bytesToAddress(msg.data);
192             require(msg.sender != addr && addr != address(0));
193             _adminInOut(command, addr);
194         } else if(msg.data.length == 1 && uint8(msg.data[0]) == 255) {
195             TRANSFER_ON = !TRANSFER_ON;
196         }
197     }
198     
199     function _bytesToAddress(bytes memory bys) internal pure returns (address addr) {
200         assembly {
201             addr := mload(add(bys, 20))
202         }
203         // At the end of instruction, not need to use ';' 
204     }   
205     
206     function voteView(uint8 selector, address addr) public view returns (address ret) {
207         ret = address(0);
208         if(selector == 0) {
209             ret = address(adminCounter);
210         }
211         if(selector == 1) {
212             ret = _inn[addr].foo;
213         } else if(selector == 2) {
214             ret = _inn[addr].bar;
215         } else if(selector == 3) {
216             ret =  _out[addr].foo;
217         } else if(selector == 4) {
218             ret = _out[addr].bar;
219         }
220         return ret;
221     }
222     
223     //The same admin can not vote twice;
224     //One can not vote for oneself, should vote for others.
225     
226     function _adminInOut(uint8 command, address addr) internal {
227         if(command == 1) {
228             require(!isAdmin(addr));
229             if(_inn[addr].foo == address(0)) {
230                 _inn[addr].foo = msg.sender;
231             } else if(_inn[addr].bar == address(0)) {
232                 _inn[addr].bar = msg.sender;
233             }
234             require(_inn[addr].foo != _inn[addr].bar);
235             if(isAdmin(addr)) {
236                 adminCounter = adminCounter.add(1);
237             }
238         } else if(command == 2) {
239             require(isAdmin(addr));
240             if(_out[addr].foo == address(0)) {
241                 _out[addr].foo = msg.sender;
242             } else if(_out[addr].bar == address(0)) {
243                 _out[addr].bar = msg.sender;
244             }
245             require(_out[addr].foo != _out[addr].bar);
246             if(_out[addr].foo != address(0) && (_out[addr].bar != address(0))) {
247                 delete _inn[addr];
248                 delete _out[addr];
249                 adminCounter = adminCounter.sub(1);
250             }
251         }
252     }
253     
254     function transferOn() public view returns (bool) {
255         return TRANSFER_ON;
256     }
257     
258     function isAdmin(address addr) public view returns (bool) {
259         return (
260             _inn[addr].foo != address(0) && 
261             _inn[addr].bar != address(0) && 
262             _inn[addr].foo != addr &&
263             _inn[addr].bar != addr &&
264             _inn[addr].foo != _inn[addr].bar
265         );
266     }
267 
268     function name() public pure returns (string memory) {
269         return _name;
270     }
271     
272     function symbol() public pure returns (string memory) {
273         return _symbol;
274     }
275     
276     function decimals() public pure returns (uint8) {
277         return _decimals;
278     }
279     
280     function totalSupply() public view returns (uint256) {
281         return _totalSupply;
282     }
283     
284     function balanceOf(address account) public view returns (uint256) {
285         return _balances[account];
286     }
287 
288     function transfer(address recipient, uint256 amount) public returns (bool) {
289         _transfer(msg.sender, recipient, amount);
290         return true;
291     }
292 
293     function allowance(address owner, address spender) public view returns (uint256) {
294         return _allowances[owner][spender];
295     }
296 
297     function approve(address spender, uint256 value) public returns (bool) {
298         _approve(msg.sender, spender, value);
299         return true;
300     }
301 
302     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
303         _transfer(sender, recipient, amount);
304         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
305         return true;
306     }
307 
308     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
309         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
310         return true;
311     }
312 
313     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
314         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
315         return true;
316     }
317  
318     function _transfer(address sender, address recipient, uint256 amount) internal {
319         require(TRANSFER_ON, "transfer-function is temporarily off");
320         require(sender != address(0), "ERC20: transfer from the zero address");
321         require(recipient != address(0), "ERC20: transfer to the zero address");
322 
323         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
324         _balances[recipient] = _balances[recipient].add(amount);
325         emit Transfer(sender, recipient, amount);
326     }
327 
328     function _approve(address owner, address spender, uint256 value) internal {
329         require(owner != address(0), "ERC20: approve from the zero address");
330         require(spender != address(0), "ERC20: approve to the zero address");
331 
332         _allowances[owner][spender] = value;
333         emit Approval(owner, spender, value);
334     }
335 
336 }