1 pragma solidity >=0.4.21 <0.7.0;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
48      * overflow (when the result is negative).
49      *
50      * Counterpart to Solidity's `-` operator.
51      *
52      * Requirements:
53      * - Subtraction cannot overflow.
54      *
55      * _Available since v2.4.0._
56      */
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the multiplication of two unsigned integers, reverting on
66      * overflow.
67      *
68      * Counterpart to Solidity's `*` operator.
69      *
70      * Requirements:
71      * - Multiplication cannot overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the integer division of two unsigned integers. Reverts on
89      * division by zero. The result is rounded towards zero.
90      *
91      * Counterpart to Solidity's `/` operator. Note: this function uses a
92      * `revert` opcode (which leaves remaining gas untouched) while Solidity
93      * uses an invalid opcode to revert (consuming all remaining gas).
94      *
95      * Requirements:
96      * - The divisor cannot be zero.
97      */
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return div(a, b, "SafeMath: division by zero");
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      *
113      * _Available since v2.4.0._
114      */
115     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         // Solidity only automatically asserts when dividing by 0
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
126      * Reverts when dividing by zero.
127      *
128      * Counterpart to Solidity's `%` operator. This function uses a `revert`
129      * opcode (which leaves remaining gas untouched) while Solidity uses an
130      * invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      * - The divisor cannot be zero.
134      */
135     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136         return mod(a, b, "SafeMath: modulo by zero");
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141      * Reverts with custom message when dividing by zero.
142      *
143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
144      * opcode (which leaves remaining gas untouched) while Solidity uses an
145      * invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      * - The divisor cannot be zero.
149      *
150      * _Available since v2.4.0._
151      */
152     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
153         require(b != 0, errorMessage);
154         return a % b;
155     }
156 }
157 contract Ownable {
158 
159     address private _owner;
160 
161     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
162 
163     constructor() internal {
164         _owner = msg.sender;
165         emit OwnershipTransferred(address(0), _owner);
166     }
167 
168     function owner() public view returns (address) {
169         return _owner;
170     }
171 
172     function isOwner() public view returns (bool) {
173         return msg.sender == _owner;
174     }
175 
176     modifier onlyOwner() {
177         require(msg.sender == _owner, "Ownable: caller is not the owner");
178         _;
179     }
180 
181     function transferOwnership(address newOwner) public onlyOwner {
182         require(newOwner != address(0), "Ownable: new owner is the zero address");
183         emit OwnershipTransferred(_owner, newOwner);
184         _owner = newOwner;
185     }
186 
187 }
188 
189 library Address {
190 
191     function isContract(address account) internal view returns (bool) {
192         uint256 size;
193         assembly { size := extcodesize(account) } //solium-disable-line security/no-inline-assembly
194         return size > 0;
195     }
196 
197     function toPayable(address account) internal pure returns (address payable) {
198         return address(uint160(account));
199     }
200 
201 }
202 interface IERC20 {
203 
204     function balanceOf(address account) external view returns (uint256);
205     function transfer(address recipient, uint256 amount) external returns (bool);
206     function allowance(address owner, address spender) external view returns (uint256);
207     function approve(address spender, uint256 amount) external returns (bool);
208     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
209     event Transfer(address indexed from, address indexed to, uint256 value);
210     event Approval(address indexed owner, address indexed spender, uint256 value);
211 
212 }
213 contract ETOCoin is Ownable, IERC20 {
214 
215     using SafeMath for uint256;
216     using Address for address;
217 
218     string public constant name = 'Electustok';
219     string public constant symbol = 'ETO';
220     uint256 public constant decimals = 18;
221     uint256 public constant totalSupply = 6400 * 10000 * 10 ** decimals;
222 
223     uint256 public constant FounderAllocation = 6400 * 10000 * 10 ** decimals;
224     uint256 public constant FounderActivitytyAmount = 220 * 10000 * 10 ** decimals;
225     uint256 public constant FounderLockupAmount = 180 * 10000 * 10 ** decimals;
226     uint256 public constant FounderLockupCliff = 180 days;
227     uint256 public constant FounderReleaseAmount = 30 * 10000 * 10 ** decimals;
228     uint256 public constant FounderReleaseInterval = 30 days;
229 
230     address public founder = address(0);
231     uint256 public founderLockupStartTime = 0;
232     uint256 public founderReleasedAmount = 0;
233 
234     mapping (address => uint256) private _balances;
235     mapping (address => mapping (address => uint256)) private _allowances;
236 
237     event Transfer(address indexed from, address indexed to, uint256 value);
238     event Approval(address indexed from, address indexed to, uint256 value);
239     event ChangeFounder(address indexed previousFounder, address indexed newFounder);
240     event SetMinter(address indexed minter);
241     //only this accout[0] can't transfer
242     constructor(address _founder, address _operator) public {
243         require(_founder != address(0), "founder is the zero address");
244         require(_operator != address(0), "operator is the zero address");
245         founder = _founder;
246         founderLockupStartTime = block.timestamp;
247         _balances[address(this)] = totalSupply;
248         _transfer(address(this), _operator, FounderAllocation.sub(FounderLockupAmount));
249     }
250 
251     function release() public {
252         //get the current timestamp
253         uint256 currentTime = block.timestamp;
254         uint256 cliffTime = founderLockupStartTime.add(FounderLockupCliff);
255         //when the time not reached then return
256         if (currentTime < cliffTime) return;
257         //over the base return
258         if (founderReleasedAmount >= FounderLockupAmount) return;
259         uint256 month = currentTime.sub(cliffTime).div(FounderReleaseInterval);
260         uint256 releaseAmount = month.mul(FounderReleaseAmount);
261         //freed every month
262         if (releaseAmount > FounderLockupAmount) releaseAmount = FounderLockupAmount;
263         if (releaseAmount <= founderReleasedAmount) return;
264         uint256 amount = releaseAmount.sub(founderReleasedAmount);
265         founderReleasedAmount = releaseAmount;
266         _transfer(address(this), founder, amount);
267     }
268 
269     function balanceOf(address account) public view returns (uint256) {
270         return _balances[account];
271     }
272 
273     function transfer(address to, uint256 amount) public returns (bool) {
274         _transfer(msg.sender, to, amount);
275         return true;
276     }
277 
278     function allowance(address from, address to) public view returns (uint256) {
279         return _allowances[from][to];
280     }
281 
282     function approve(address to, uint256 amount) public returns (bool) {
283         _approve(msg.sender, to, amount);
284         return true;
285     }
286 
287     function transferFrom(address from, address to, uint256 amount) public returns (bool) {
288         uint256 remaining = _allowances[from][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance");
289 
290         _transfer(from, to, amount);
291         _approve(from, msg.sender, remaining);
292         return true;
293     }
294 
295     function _transfer(address from, address to, uint256 amount) private {
296         require(from != address(0), "ERC20: transfer from the zero address");
297         require(to != address(0), "ERC20: transfer to the zero address");
298 
299         _balances[from] = _balances[from].sub(amount, "ERC20: transfer amount exceeds balance");
300         _balances[to] = _balances[to].add(amount);
301         emit Transfer(from, to, amount);
302     }
303 
304     function _approve(address from, address to, uint256 amount) private {
305         require(from != address(0), "ERC20: approve from the zero address");
306         require(to != address(0), "ERC20: approve to the zero address");
307 
308         _allowances[from][to] = amount;
309         emit Approval(from, to, amount);
310     }
311 
312     function changeFounder(address _founder) public onlyOwner {
313         require(_founder != address(0), "ElectustokCoin: founder is the zero address");
314 
315         emit ChangeFounder(founder, _founder);
316         founder = _founder;
317     }
318 
319     function setMinter(address minter) public onlyOwner {
320         require(minter != address(0), "ElectustokCoin: minter is the zero address");
321         require(minter.isContract(), "ElectustokCoin: minter is not contract");
322         _transfer(address(this), minter, totalSupply.sub(FounderAllocation));
323         emit SetMinter(minter);
324     }
325 
326 }