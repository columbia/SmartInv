1 // File: contracts/interfaces/IERC20Sumswap.sol
2 
3 pragma solidity >=0.5.0;
4 
5 interface IERC20Sumswap{
6     event Approval(address indexed owner, address indexed spender, uint value);
7     event Transfer(address indexed from, address indexed to, uint value);
8 
9     function name() external view returns (string memory);
10     function symbol() external view returns (string memory);
11     function decimals() external view returns (uint8);
12     function totalSupply() external view returns (uint);
13     function balanceOf(address owner) external view returns (uint);
14     function allowance(address owner, address spender) external view returns (uint);
15 
16     function approve(address spender, uint value) external returns (bool);
17     function transfer(address to, uint value) external returns (bool);
18     function transferFrom(address from, address to, uint value) external returns (bool);
19 }
20 
21 // File: @openzeppelin/contracts/GSN/Context.sol
22 
23 
24 
25 pragma solidity >=0.6.0 <0.8.0;
26 
27 /*
28  * @dev Provides information about the current execution context, including the
29  * sender of the transaction and its data. While these are generally available
30  * via msg.sender and msg.data, they should not be accessed in such a direct
31  * manner, since when dealing with GSN meta-transactions the account sending and
32  * paying for execution may not be the actual sender (as far as an application
33  * is concerned).
34  *
35  * This contract is only required for intermediate, library-like contracts.
36  */
37 abstract contract Context {
38     function _msgSender() internal view virtual returns (address payable) {
39         return msg.sender;
40     }
41 
42     function _msgData() internal view virtual returns (bytes memory) {
43         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
44         return msg.data;
45     }
46 }
47 
48 // File: @openzeppelin/contracts/access/Ownable.sol
49 
50 
51 
52 pragma solidity >=0.6.0 <0.8.0;
53 
54 /**
55  * @dev Contract module which provides a basic access control mechanism, where
56  * there is an account (an owner) that can be granted exclusive access to
57  * specific functions.
58  *
59  * By default, the owner account will be the one that deploys the contract. This
60  * can later be changed with {transferOwnership}.
61  *
62  * This module is used through inheritance. It will make available the modifier
63  * `onlyOwner`, which can be applied to your functions to restrict their use to
64  * the owner.
65  */
66 abstract contract Ownable is Context {
67     address private _owner;
68 
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     /**
72      * @dev Initializes the contract setting the deployer as the initial owner.
73      */
74     constructor () internal {
75         address msgSender = _msgSender();
76         _owner = msgSender;
77         emit OwnershipTransferred(address(0), msgSender);
78     }
79 
80     /**
81      * @dev Returns the address of the current owner.
82      */
83     function owner() public view returns (address) {
84         return _owner;
85     }
86 
87     /**
88      * @dev Throws if called by any account other than the owner.
89      */
90     modifier onlyOwner() {
91         require(_owner == _msgSender(), "Ownable: caller is not the owner");
92         _;
93     }
94 
95     /**
96      * @dev Leaves the contract without owner. It will not be possible to call
97      * `onlyOwner` functions anymore. Can only be called by the current owner.
98      *
99      * NOTE: Renouncing ownership will leave the contract without an owner,
100      * thereby removing any functionality that is only available to the owner.
101      */
102     function renounceOwnership() public virtual onlyOwner {
103         emit OwnershipTransferred(_owner, address(0));
104         _owner = address(0);
105     }
106 
107     /**
108      * @dev Transfers ownership of the contract to a new account (`newOwner`).
109      * Can only be called by the current owner.
110      */
111     function transferOwnership(address newOwner) public virtual onlyOwner {
112         require(newOwner != address(0), "Ownable: new owner is the zero address");
113         emit OwnershipTransferred(_owner, newOwner);
114         _owner = newOwner;
115     }
116 }
117 
118 // File: @openzeppelin/contracts/math/SafeMath.sol
119 
120 
121 
122 pragma solidity >=0.6.0 <0.8.0;
123 
124 /**
125  * @dev Wrappers over Solidity's arithmetic operations with added overflow
126  * checks.
127  *
128  * Arithmetic operations in Solidity wrap on overflow. This can easily result
129  * in bugs, because programmers usually assume that an overflow raises an
130  * error, which is the standard behavior in high level programming languages.
131  * `SafeMath` restores this intuition by reverting the transaction when an
132  * operation overflows.
133  *
134  * Using this library instead of the unchecked operations eliminates an entire
135  * class of bugs, so it's recommended to use it always.
136  */
137 library SafeMath {
138     /**
139      * @dev Returns the addition of two unsigned integers, reverting on
140      * overflow.
141      *
142      * Counterpart to Solidity's `+` operator.
143      *
144      * Requirements:
145      *
146      * - Addition cannot overflow.
147      */
148     function add(uint256 a, uint256 b) internal pure returns (uint256) {
149         uint256 c = a + b;
150         require(c >= a, "SafeMath: addition overflow");
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      *
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
166         return sub(a, b, "SafeMath: subtraction overflow");
167     }
168 
169     /**
170      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
171      * overflow (when the result is negative).
172      *
173      * Counterpart to Solidity's `-` operator.
174      *
175      * Requirements:
176      *
177      * - Subtraction cannot overflow.
178      */
179     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
180         require(b <= a, errorMessage);
181         uint256 c = a - b;
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the multiplication of two unsigned integers, reverting on
188      * overflow.
189      *
190      * Counterpart to Solidity's `*` operator.
191      *
192      * Requirements:
193      *
194      * - Multiplication cannot overflow.
195      */
196     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
197         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
198         // benefit is lost if 'b' is also tested.
199         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
200         if (a == 0) {
201             return 0;
202         }
203 
204         uint256 c = a * b;
205         require(c / a == b, "SafeMath: multiplication overflow");
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b) internal pure returns (uint256) {
223         return div(a, b, "SafeMath: division by zero");
224     }
225 
226     /**
227      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
228      * division by zero. The result is rounded towards zero.
229      *
230      * Counterpart to Solidity's `/` operator. Note: this function uses a
231      * `revert` opcode (which leaves remaining gas untouched) while Solidity
232      * uses an invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         require(b > 0, errorMessage);
240         uint256 c = a / b;
241         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
242 
243         return c;
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248      * Reverts when dividing by zero.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
259         return mod(a, b, "SafeMath: modulo by zero");
260     }
261 
262     /**
263      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
264      * Reverts with custom message when dividing by zero.
265      *
266      * Counterpart to Solidity's `%` operator. This function uses a `revert`
267      * opcode (which leaves remaining gas untouched) while Solidity uses an
268      * invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      *
272      * - The divisor cannot be zero.
273      */
274     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
275         require(b != 0, errorMessage);
276         return a % b;
277     }
278 }
279 
280 // File: contracts/Release.sol
281 
282 pragma solidity ^0.6.0;
283 
284 
285 
286 
287 interface ISummaMode {
288     function priBalanceOf(address account) external view returns (uint256);
289     function pubBalanceOf(address account) external view returns (uint256);
290 }
291 
292 contract Release is Ownable {
293 
294     using SafeMath for uint256;
295     address public summaMode;
296     address public summa;
297     mapping(address => uint256) private withDraw;
298     bool public releaseSwitch;
299     bool public firstReleaseSwitch;
300     uint256 public startTime = 1;
301 
302     uint256 public duration = 5400;
303 
304     constructor(address addrMode, address addrSumma) public payable{
305         summaMode = addrMode;
306         summa = addrSumma;
307     }
308 
309     function setReleaseSwitchOpen() public onlyOwner {
310         if (!releaseSwitch) {
311             releaseSwitch = true;
312             startTime = block.number;
313         }
314     }
315 
316     function setFirstReleaseSwitchOpen() public onlyOwner {
317         if (!firstReleaseSwitch) {
318             firstReleaseSwitch = true;
319         }
320     }
321 
322     function unReleaseOf(address addr) public view returns (uint256){
323         return ISummaMode(summaMode).priBalanceOf(addr).add(ISummaMode(summaMode).pubBalanceOf(addr)).sub(releasedOf(addr));
324     }
325 
326     function releasedOf(address addr) public view returns (uint256){
327         uint256 balance = ISummaMode(summaMode).priBalanceOf(addr).add(ISummaMode(summaMode).pubBalanceOf(addr));
328         if(firstReleaseSwitch && startTime == 1){
329             return balance.mul(10).div(100);
330         } else if (releaseSwitch && block.number >= startTime && startTime != 1) {
331             uint256 dayNum = block.number - startTime;
332             if (dayNum >= 486000) {
333                 return balance;
334             }else {
335                 uint256 tempBalance = balance.mul(10).div(100).add(dayNum.div(duration).mul(balance.div(100)));
336                 if(tempBalance > balance){
337                     return balance;
338                 }
339                 return tempBalance;
340             }
341         } else {
342             return 0;
343         }
344     }
345 
346     function releasedSubWithDrawOf(address addr) public view returns (uint256){
347         return releasedOf(addr).sub(withDraw[addr]);
348     }
349 
350     function withDrawSumma() public {
351         uint tempBalance = releasedSubWithDrawOf(_msgSender());
352         if (tempBalance > 0) {
353             withDraw[_msgSender()] = withDraw[_msgSender()].add(tempBalance);
354             IERC20Sumswap(summa).transfer(_msgSender(), tempBalance);
355         }
356     }
357 
358     function withdrawETH() public onlyOwner {
359         msg.sender.transfer(address(this).balance);
360     }
361 
362     function withdrawToken(address addr) public onlyOwner {
363         IERC20Sumswap(addr).transfer(_msgSender(), IERC20Sumswap(addr).balanceOf(address(this)));
364     }
365 
366     receive() external payable {
367     }
368 }