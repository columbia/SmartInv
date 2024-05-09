1 // Partial License: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 
80 // Partial License: MIT
81 
82 pragma solidity ^0.6.0;
83 
84 /*
85  * @dev Provides information about the current execution context, including the
86  * sender of the transaction and its data. While these are generally available
87  * via msg.sender and msg.data, they should not be accessed in such a direct
88  * manner, since when dealing with GSN meta-transactions the account sending and
89  * paying for execution may not be the actual sender (as far as an application
90  * is concerned).
91  *
92  * This contract is only required for intermediate, library-like contracts.
93  */
94 abstract contract Context {
95     function _msgSender() internal view virtual returns (address payable) {
96         return msg.sender;
97     }
98 
99     function _msgData() internal view virtual returns (bytes memory) {
100         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
101         return msg.data;
102     }
103 }
104 
105 
106 // Partial License: MIT
107 
108 pragma solidity ^0.6.0;
109 
110 
111 /**
112  * @dev Contract module which provides a basic access control mechanism, where
113  * there is an account (an owner) that can be granted exclusive access to
114  * specific functions.
115  *
116  * By default, the owner account will be the one that deploys the contract. This
117  * can later be changed with {transferOwnership}.
118  *
119  * This module is used through inheritance. It will make available the modifier
120  * `onlyOwner`, which can be applied to your functions to restrict their use to
121  * the owner.
122  */
123 contract Ownable is Context {
124     address private _owner;
125 
126     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
127 
128     /**
129      * @dev Initializes the contract setting the deployer as the initial owner.
130      */
131     constructor () internal {
132         address msgSender = _msgSender();
133         _owner = msgSender;
134         emit OwnershipTransferred(address(0), msgSender);
135     }
136 
137     /**
138      * @dev Returns the address of the current owner.
139      */
140     function owner() public view returns (address) {
141         return _owner;
142     }
143 
144     /**
145      * @dev Throws if called by any account other than the owner.
146      */
147     modifier onlyOwner() {
148         require(_owner == _msgSender(), "Ownable: caller is not the owner");
149         _;
150     }
151 
152     /**
153      * @dev Leaves the contract without owner. It will not be possible to call
154      * `onlyOwner` functions anymore. Can only be called by the current owner.
155      *
156      * NOTE: Renouncing ownership will leave the contract without an owner,
157      * thereby removing any functionality that is only available to the owner.
158      */
159     function renounceOwnership() public virtual onlyOwner {
160         emit OwnershipTransferred(_owner, address(0));
161         _owner = address(0);
162     }
163 
164     /**
165      * @dev Transfers ownership of the contract to a new account (`newOwner`).
166      * Can only be called by the current owner.
167      */
168     function transferOwnership(address newOwner) public virtual onlyOwner {
169         require(newOwner != address(0), "Ownable: new owner is the zero address");
170         emit OwnershipTransferred(_owner, newOwner);
171         _owner = newOwner;
172     }
173 }
174 
175 
176 // Partial License: MIT
177 
178 pragma solidity ^0.6.0;
179 
180 /**
181  * @dev Wrappers over Solidity's arithmetic operations with added overflow
182  * checks.
183  *
184  * Arithmetic operations in Solidity wrap on overflow. This can easily result
185  * in bugs, because programmers usually assume that an overflow raises an
186  * error, which is the standard behavior in high level programming languages.
187  * `SafeMath` restores this intuition by reverting the transaction when an
188  * operation overflows.
189  *
190  * Using this library instead of the unchecked operations eliminates an entire
191  * class of bugs, so it's recommended to use it always.
192  */
193 library SafeMath {
194     /**
195      * @dev Returns the addition of two unsigned integers, reverting on
196      * overflow.
197      *
198      * Counterpart to Solidity's `+` operator.
199      *
200      * Requirements:
201      *
202      * - Addition cannot overflow.
203      */
204     function add(uint256 a, uint256 b) internal pure returns (uint256) {
205         uint256 c = a + b;
206         require(c >= a, "SafeMath: addition overflow");
207 
208         return c;
209     }
210 
211     /**
212      * @dev Returns the subtraction of two unsigned integers, reverting on
213      * overflow (when the result is negative).
214      *
215      * Counterpart to Solidity's `-` operator.
216      *
217      * Requirements:
218      *
219      * - Subtraction cannot overflow.
220      */
221     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
222         return sub(a, b, "SafeMath: subtraction overflow");
223     }
224 
225     /**
226      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
227      * overflow (when the result is negative).
228      *
229      * Counterpart to Solidity's `-` operator.
230      *
231      * Requirements:
232      *
233      * - Subtraction cannot overflow.
234      */
235     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b <= a, errorMessage);
237         uint256 c = a - b;
238 
239         return c;
240     }
241 
242     /**
243      * @dev Returns the multiplication of two unsigned integers, reverting on
244      * overflow.
245      *
246      * Counterpart to Solidity's `*` operator.
247      *
248      * Requirements:
249      *
250      * - Multiplication cannot overflow.
251      */
252     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
253         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
254         // benefit is lost if 'b' is also tested.
255         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
256         if (a == 0) {
257             return 0;
258         }
259 
260         uint256 c = a * b;
261         require(c / a == b, "SafeMath: multiplication overflow");
262 
263         return c;
264     }
265 
266     /**
267      * @dev Returns the integer division of two unsigned integers. Reverts on
268      * division by zero. The result is rounded towards zero.
269      *
270      * Counterpart to Solidity's `/` operator. Note: this function uses a
271      * `revert` opcode (which leaves remaining gas untouched) while Solidity
272      * uses an invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      *
276      * - The divisor cannot be zero.
277      */
278     function div(uint256 a, uint256 b) internal pure returns (uint256) {
279         return div(a, b, "SafeMath: division by zero");
280     }
281 
282     /**
283      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
284      * division by zero. The result is rounded towards zero.
285      *
286      * Counterpart to Solidity's `/` operator. Note: this function uses a
287      * `revert` opcode (which leaves remaining gas untouched) while Solidity
288      * uses an invalid opcode to revert (consuming all remaining gas).
289      *
290      * Requirements:
291      *
292      * - The divisor cannot be zero.
293      */
294     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
295         require(b > 0, errorMessage);
296         uint256 c = a / b;
297         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
298 
299         return c;
300     }
301 
302     /**
303      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
304      * Reverts when dividing by zero.
305      *
306      * Counterpart to Solidity's `%` operator. This function uses a `revert`
307      * opcode (which leaves remaining gas untouched) while Solidity uses an
308      * invalid opcode to revert (consuming all remaining gas).
309      *
310      * Requirements:
311      *
312      * - The divisor cannot be zero.
313      */
314     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
315         return mod(a, b, "SafeMath: modulo by zero");
316     }
317 
318     /**
319      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
320      * Reverts with custom message when dividing by zero.
321      *
322      * Counterpart to Solidity's `%` operator. This function uses a `revert`
323      * opcode (which leaves remaining gas untouched) while Solidity uses an
324      * invalid opcode to revert (consuming all remaining gas).
325      *
326      * Requirements:
327      *
328      * - The divisor cannot be zero.
329      */
330     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
331         require(b != 0, errorMessage);
332         return a % b;
333     }
334 }
335 
336 
337 pragma solidity 0.6.6;
338 
339 
340 
341 contract ETHYSPresale is Ownable {
342     using SafeMath for uint256;
343     IERC20 public ethys;
344 
345     // BP
346     uint256 constant BP = 10000;
347 
348     // sale params
349     bool    public started;
350     uint256 public price;
351     uint256 public cap;
352     uint256 public ends;
353     uint256 public maxEnds;
354     bool    public paused;
355     uint256 public minimum;
356     uint256 public maximum;
357 
358     // stats:
359     uint256 public totalOwed;
360     uint256 public weiRaised;
361 
362     mapping(address => uint256) public claimable;
363 
364     constructor (address addr) public { ethys = IERC20(addr); }
365 
366     // pause contract preventing further purchase.
367     // pausing however has no effect on those who
368     // have already purchased.
369     function pause(bool _paused)            public onlyOwner { paused = _paused;}
370     function setPrice(uint256 _price)       public onlyOwner { price = _price; }
371     function setMinimum(uint256 _minimum)   public onlyOwner { minimum = _minimum; }
372     function setMaximum(uint256 _maximum)   public onlyOwner { maximum = _maximum; }
373     function setCap(uint256 _cap)           public onlyOwner { cap = _cap; }
374     
375     // set the date the contract will unlock.
376     // capped to max end date
377     function setEnds(uint256 _ends)   public onlyOwner {
378         require(_ends <= maxEnds, "end date is capped");
379         ends = _ends;
380     }
381     
382     // unlock contract early
383     function unlock() public onlyOwner { ends = 0; paused = true; }
384 
385     function withdrawETH(address payable _addr, uint256 amount) public onlyOwner {
386         _addr.transfer(amount);
387     }
388     
389     function withdrawETHOwner(uint256 amount) public onlyOwner {
390         msg.sender.transfer(amount);   
391     }
392 
393     function withdrawUnsold(address _addr, uint256 amount) public onlyOwner {
394         require(amount <= ethys.balanceOf(address(this)).sub(totalOwed), "insufficient balance");
395         ethys.transfer(_addr, amount);
396     }
397 
398     // start the presale
399     function startPresale(uint256 _maxEnds, uint256 _ends) public onlyOwner {
400         require(!started, "already started!");
401         require(price > 0, "set price first!");
402         require(minimum > 0, "set minimum first!");
403         require(maximum > minimum, "set maximum first!");
404         require(_maxEnds > _ends, "end date first!");
405         require(cap > 0, "set a cap first");
406 
407         started = true;
408         paused = false;
409         maxEnds = _maxEnds;
410         ends = _ends;
411     }
412 
413     // the amount of ethy purchased
414     function calculateAmountPurchased(uint256 _value) public view returns (uint256) {
415         return _value.mul(BP).div(price).mul(1e18).div(BP);
416     }
417 
418     // claim your purchased tokens
419     function claim() public {
420         //solium-disable-next-line
421         require(block.timestamp > ends, "presale has not yet ended");
422         require(claimable[msg.sender] > 0, "nothing to claim");
423 
424         uint256 amount = claimable[msg.sender];
425 
426         // update user and stats
427         claimable[msg.sender] = 0;
428         totalOwed = totalOwed.sub(amount);
429 
430         // send owed tokens
431         require(ethys.transfer(msg.sender, amount), "failed to claim");
432     }
433 
434     // purchase tokens
435     function buy() public payable {
436         //solium-disable-next-line
437         require(!paused, "presale is paused");
438         require(msg.value >= minimum, "amount too small");
439         require(weiRaised.add(msg.value) < cap, "cap hit");
440 
441         uint256 amount = calculateAmountPurchased(msg.value);
442         require(totalOwed.add(amount) <= ethys.balanceOf(address(this)), "sold out");
443         require(claimable[msg.sender].add(msg.value) <= maximum, "maximum purchase cap hit");
444 
445         // update user and stats:
446         claimable[msg.sender] = claimable[msg.sender].add(amount);
447         totalOwed = totalOwed.add(amount);
448         weiRaised = weiRaised.add(msg.value);
449     }
450     
451     fallback() external payable { buy(); }
452     receive() external payable { buy(); }
453 }