1 pragma solidity >= 0.6.3;
2 
3 contract Context {
4   constructor () internal { }
5   function _msgSender() internal view virtual returns (address payable) {
6     return msg.sender;
7   }
8   function _msgData() internal view virtual returns (bytes memory) {
9     this;
10     return msg.data;
11   }
12 }
13 contract Owned {
14   address public owner;
15   address public newOwner;
16 
17   event OwnershipTransferred(address indexed _from, address indexed _to);
18 
19   constructor() public {
20     owner = msg.sender;
21   }
22 
23   modifier onlyOwner {
24     require(msg.sender == owner);
25     _;
26   }
27 
28   function transferOwnership(address _newOwner) public onlyOwner {
29     newOwner = _newOwner;
30   }
31   function acceptOwnership() public {
32     require(msg.sender == newOwner);
33     emit OwnershipTransferred(owner, newOwner);
34     owner = newOwner;
35     newOwner = address(0);
36   }
37 }
38 contract glaretoken is Context, Owned {
39   using SafeMath for uint256;
40 
41   event Transfer(address indexed from, address indexed to, uint256 value);
42   event Approval(address indexed owner, address indexed spender, uint256 value);
43 
44   constructor() public {
45     symbol = "GLX";
46     name = "Glare";
47     decimals = 18;
48   }
49 
50   modifier onlyGlare {
51     require(msg.sender == glare);
52     _;
53   }
54 
55   mapping (address => uint256) private _balances;
56 
57   mapping (address => mapping (address => uint256)) private _allowances;
58 
59   string public symbol;
60   string public name;
61   uint256 public decimals;
62   uint256 private _totalSupply;
63 
64   address public glare;
65 
66   //AIRDROP VARIABLES
67   uint256 public airdropSize;
68   bool public airdropActive;
69   uint256 public airdropIndex;
70   mapping(uint256 => mapping(address => bool)) public airdropTaken;
71 
72   function totalSupply() public view returns (uint256) {
73     return _totalSupply;
74   }
75   function balanceOf(address account) public view returns (uint256) {
76     return _balances[account];
77   }
78   function transfer(address recipient, uint256 amount) public virtual returns (bool) {
79     _transfer(_msgSender(), recipient, amount);
80     return true;
81   }
82   function allowance(address owner, address spender) public view virtual returns (uint256) {
83     return _allowances[owner][spender];
84   }
85   function approve(address spender, uint256 amount) public virtual returns (bool) {
86     _approve(_msgSender(), spender, amount);
87     return true;
88   }
89   function transferFrom(address sender, address recipient, uint256 amount) public virtual returns (bool) {
90     _transfer(sender, recipient, amount);
91     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
92     return true;
93   }
94   function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
95     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
96     return true;
97   }
98   function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
99     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
100     return true;
101   }
102   function mint(address account, uint256 amount) public onlyGlare() {
103     require(account != address(0), "ERC20: mint to the zero address");
104 
105     _beforeTokenTransfer(address(0), account, amount);
106 
107     _totalSupply = _totalSupply.add(amount);
108     _balances[account] = _balances[account].add(amount);
109     emit Transfer(address(0), account, amount);
110   }
111   function burn(address account, uint256 amount) public onlyGlare() {
112     require(account != address(0), "ERC20: burn from the zero address");
113 
114     _beforeTokenTransfer(account, address(0), amount);
115 
116     _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
117     _totalSupply = _totalSupply.sub(amount);
118     emit Transfer(account, address(0), amount);
119   }
120   function _transfer(address sender, address recipient, uint256 amount) internal virtual {
121     require(sender != address(0), "ERC20: transfer from the zero address");
122     require(recipient != address(0), "ERC20: transfer to the zero address");
123 
124     _beforeTokenTransfer(sender, recipient, amount);
125 
126     _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
127     _balances[recipient] = _balances[recipient].add(amount);
128     emit Transfer(sender, recipient, amount);
129   }
130   function _approve(address owner, address spender, uint256 amount) internal virtual {
131     require(owner != address(0), "ERC20: approve from the zero address");
132     require(spender != address(0), "ERC20: approve to the zero address");
133 
134     _allowances[owner][spender] = amount;
135     emit Approval(owner, spender, amount);
136   }
137   function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
138   function setGlare(address _glare) public onlyOwner() {
139     glare = _glare;
140   }
141   function claimAirdrop() public {
142     require(_balances[address(this)] >= airdropSize);
143     require(airdropActive == true);
144     require(airdropTaken[airdropIndex][msg.sender] == false);
145     airdropTaken[airdropIndex][msg.sender] = true;
146     _transfer(address(this), msg.sender, airdropSize);
147   }
148   function setAirdropSize(uint256 amount) public onlyOwner() {
149     airdropSize = amount;
150   }
151   function setAirdropActive(bool status) public onlyOwner() {
152     airdropActive = status;
153   }
154   function setAirdropIndex(uint256 index) public onlyOwner() {
155     airdropIndex = index;
156   }
157 }
158 
159 library SafeMath {
160   /**
161   * @dev Returns the addition of two unsigned integers, reverting on
162   * overflow.
163   *
164   * Counterpart to Solidity's `+` operator.
165   *
166   * Requirements:
167   * - Addition cannot overflow.
168   */
169   function add(uint256 a, uint256 b) internal pure returns (uint256) {
170     uint256 c = a + b;
171     require(c >= a, "SafeMath: addition overflow");
172 
173     return c;
174   }
175 
176   /**
177   * @dev Returns the subtraction of two unsigned integers, reverting on
178   * overflow (when the result is negative).
179   *
180   * Counterpart to Solidity's `-` operator.
181   *
182   * Requirements:
183   * - Subtraction cannot overflow.
184   */
185   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
186     return sub(a, b, "SafeMath: subtraction overflow");
187   }
188 
189   /**
190   * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
191   * overflow (when the result is negative).
192   *
193   * Counterpart to Solidity's `-` operator.
194   *
195   * Requirements:
196   * - Subtraction cannot overflow.
197   *
198   * _Available since v2.4.0._
199   */
200   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
201     require(b <= a, errorMessage);
202     uint256 c = a - b;
203 
204     return c;
205   }
206 
207   /**
208   * @dev Returns the multiplication of two unsigned integers, reverting on
209   * overflow.
210   *
211   * Counterpart to Solidity's `*` operator.
212   *
213   * Requirements:
214   * - Multiplication cannot overflow.
215   */
216   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
217     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
218     // benefit is lost if 'b' is also tested.
219     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
220     if (a == 0) {
221       return 0;
222     }
223 
224     uint256 c = a * b;
225     require(c / a == b, "SafeMath: multiplication overflow");
226 
227     return c;
228   }
229 
230   /**
231   * @dev Returns the integer division of two unsigned integers. Reverts on
232   * division by zero. The result is rounded towards zero.
233   *
234   * Counterpart to Solidity's `/` operator. Note: this function uses a
235   * `revert` opcode (which leaves remaining gas untouched) while Solidity
236   * uses an invalid opcode to revert (consuming all remaining gas).
237   *
238   * Requirements:
239   * - The divisor cannot be zero.
240   */
241   function div(uint256 a, uint256 b) internal pure returns (uint256) {
242     return div(a, b, "SafeMath: division by zero");
243   }
244 
245   /**
246   * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
247   * division by zero. The result is rounded towards zero.
248   *
249   * Counterpart to Solidity's `/` operator. Note: this function uses a
250   * `revert` opcode (which leaves remaining gas untouched) while Solidity
251   * uses an invalid opcode to revert (consuming all remaining gas).
252   *
253   * Requirements:
254   * - The divisor cannot be zero.
255   *
256   * _Available since v2.4.0._
257   */
258   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
259     // Solidity only automatically asserts when dividing by 0
260     require(b > 0, errorMessage);
261     uint256 c = a / b;
262     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
263 
264     return c;
265   }
266 
267   /**
268   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
269   * Reverts when dividing by zero.
270   *
271   * Counterpart to Solidity's `%` operator. This function uses a `revert`
272   * opcode (which leaves remaining gas untouched) while Solidity uses an
273   * invalid opcode to revert (consuming all remaining gas).
274   *
275   * Requirements:
276   * - The divisor cannot be zero.
277   */
278   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
279     return mod(a, b, "SafeMath: modulo by zero");
280   }
281 
282   /**
283   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
284   * Reverts with custom message when dividing by zero.
285   *
286   * Counterpart to Solidity's `%` operator. This function uses a `revert`
287   * opcode (which leaves remaining gas untouched) while Solidity uses an
288   * invalid opcode to revert (consuming all remaining gas).
289   *
290   * Requirements:
291   * - The divisor cannot be zero.
292   *
293   * _Available since v2.4.0._
294   */
295   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
296     require(b != 0, errorMessage);
297     return a % b;
298   }
299 }