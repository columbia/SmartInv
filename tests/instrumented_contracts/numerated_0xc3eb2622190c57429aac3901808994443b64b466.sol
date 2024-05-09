1 pragma solidity ^0.6.0;
2 
3 interface IERC20 {
4     
5     function totalSupply() external view returns (uint256);
6 
7     function balanceOf(address account) external view returns (uint256);
8 
9     function transfer(address recipient, uint256 amount) external returns (bool);
10 
11     function allowance(address owner, address spender) external view returns (uint256);
12 
13     function approve(address spender, uint256 amount) external returns (bool);
14 
15     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address payable) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 contract Ownable is Context {
34     address private _owner;
35 
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38     constructor () internal {
39         address msgSender = _msgSender();
40         _owner = msgSender;
41         emit OwnershipTransferred(address(0), msgSender);
42     }
43 
44     function owner() public view returns (address) {
45         return _owner;
46     }
47 
48     modifier onlyOwner() {
49         require(_owner == _msgSender(), "Ownable: caller is not the owner");
50         _;
51     }
52 
53     function renounceOwnership() public virtual onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     function transferOwnership(address newOwner) public virtual onlyOwner {
59         require(newOwner != address(0), "Ownable: new owner is the zero address");
60         emit OwnershipTransferred(_owner, newOwner);
61         _owner = newOwner;
62     }
63 }
64 
65 contract Pausable is Context {
66    
67     event Paused(address account);
68 
69     event Unpaused(address account);
70 
71     bool private _paused;
72 
73     constructor () internal {
74         _paused = false;
75     }
76 
77     function paused() public view returns (bool) {
78         return _paused;
79     }
80 
81     modifier whenNotPaused() {
82         require(!_paused, "Pausable: paused");
83         _;
84     }
85 
86     modifier whenPaused() {
87         require(_paused, "Pausable: not paused");
88         _;
89     }
90 
91     function _pause() internal virtual whenNotPaused {
92         _paused = true;
93         emit Paused(_msgSender());
94     }
95 
96     function _unpause() internal virtual whenPaused {
97         _paused = false;
98         emit Unpaused(_msgSender());
99     }
100 }
101 
102 /**
103  * @dev Wrappers over Solidity's arithmetic operations with added overflow
104  * checks.
105  *
106  * Arithmetic operations in Solidity wrap on overflow. This can easily result
107  * in bugs, because programmers usually assume that an overflow raises an
108  * error, which is the standard behavior in high level programming languages.
109  * `SafeMath` restores this intuition by reverting the transaction when an
110  * operation overflows.
111  *
112  * Using this library instead of the unchecked operations eliminates an entire
113  * class of bugs, so it's recommended to use it always.
114  */
115 library SafeMath {
116     /**
117      * @dev Returns the addition of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `+` operator.
121      *
122      * Requirements:
123      *
124      * - Addition cannot overflow.
125      */
126     function add(uint256 a, uint256 b) internal pure returns (uint256) {
127         uint256 c = a + b;
128         require(c >= a, "SafeMath: addition overflow");
129 
130         return c;
131     }
132 
133     /**
134      * @dev Returns the subtraction of two unsigned integers, reverting on
135      * overflow (when the result is negative).
136      *
137      * Counterpart to Solidity's `-` operator.
138      *
139      * Requirements:
140      *
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144         return sub(a, b, "SafeMath: subtraction overflow");
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      *
155      * - Subtraction cannot overflow.
156      */
157     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b <= a, errorMessage);
159         uint256 c = a - b;
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the multiplication of two unsigned integers, reverting on
166      * overflow.
167      *
168      * Counterpart to Solidity's `*` operator.
169      *
170      * Requirements:
171      *
172      * - Multiplication cannot overflow.
173      */
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
178         if (a == 0) {
179             return 0;
180         }
181 
182         uint256 c = a * b;
183         require(c / a == b, "SafeMath: multiplication overflow");
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         return div(a, b, "SafeMath: division by zero");
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
217         require(b > 0, errorMessage);
218         uint256 c = a / b;
219         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
220 
221         return c;
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
237         return mod(a, b, "SafeMath: modulo by zero");
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts with custom message when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
253         require(b != 0, errorMessage);
254         return a % b;
255     }
256 }
257 contract OROToken is Context, IERC20, Ownable, Pausable {
258     using SafeMath for uint256;
259 
260     mapping (address => uint256) private _balances;
261 
262     mapping (address => mapping (address => uint256)) private _allowances;
263 
264     modifier onlyDistributor() {
265         require(msg.sender == distributionContractAddress , "Caller is not the distributor");
266         _;
267     }
268 
269     string public name;
270     string public symbol;
271     uint256 private _totalSupply;
272     uint8 public decimals;
273 
274     address public distributionContractAddress;
275 
276     constructor () public {
277         name = "ORO Token";
278         symbol = "ORO";
279         decimals = 18;
280         _totalSupply = 100000000;
281         _totalSupply = _totalSupply * (10**18);
282         _balances[msg.sender] = _totalSupply;
283         distributionContractAddress = address(0);
284         emit Transfer(address(0), msg.sender, _totalSupply);
285     }
286 
287     function totalSupply() external view override returns (uint256) {
288         return _totalSupply;
289     }
290 
291     function balanceOf(address account) public view override returns (uint256) {
292         return _balances[account];
293     }
294 
295     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
296         _transfer(_msgSender(), recipient, amount);
297         return true;
298     }
299 
300     function allowance(address owner, address spender) public view virtual override returns (uint256) {
301         return _allowances[owner][spender];
302     }
303 
304     function updateDistributionContract(address _address) onlyOwner whenNotPaused external {
305         distributionContractAddress = _address;
306     }
307 
308     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
309         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
310         return true;
311     }
312 
313     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
314         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
315         return true;
316     }
317 
318     function approve(address spender, uint256 amount) public virtual override returns (bool) {
319         _approve(_msgSender(), spender, amount);
320         return true;
321     }
322 
323     function transferFrom(address sender, address recipient, uint256 amount) whenNotPaused public virtual override returns (bool) {
324         _transfer(sender, recipient, amount);
325         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
326         return true;
327     }
328 
329     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
330         require(sender != address(0), "ERC20: transfer from the zero address");
331         require(recipient != address(0), "ERC20: transfer to the zero address");
332         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
333         _balances[recipient] = _balances[recipient].add(amount);
334         emit Transfer(sender, recipient, amount);
335     }
336 
337     function _mint(address account, uint256 amount) internal virtual {
338         require(account != address(0), "ERC20: mint to the zero address");
339         _totalSupply = _totalSupply.add(amount);
340         _balances[account] = _balances[account].add(amount);
341         emit Transfer(address(0), account, amount);
342     }
343 
344     function _burn(address account, uint256 amount) internal virtual {
345         require(account != address(0), "ERC20: burn from the zero address");
346         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
347         _totalSupply = _totalSupply.sub(amount);
348         emit Transfer(account, address(0), amount);
349     }
350 
351     function _approve(address owner, address spender, uint256 amount) internal virtual {
352         require(owner != address(0), "ERC20: approve from the zero address");
353         require(spender != address(0), "ERC20: approve to the zero address");
354         _allowances[owner][spender] = amount;
355         emit Approval(owner, spender, amount);
356     }
357     
358     function mint(address _to, uint256 _amount) onlyDistributor whenNotPaused  external {
359         _mint(_to, _amount);
360     }
361 
362     function burn(address _from, uint256 _amount) onlyOwner whenNotPaused external {
363         _burn(_from, _amount);
364     }
365 
366     function pause() onlyOwner whenNotPaused external {
367         _pause();
368     }
369 
370     function unpause() onlyOwner whenPaused external {
371         _unpause();
372     }
373 }