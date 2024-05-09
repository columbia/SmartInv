1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.7.5;
4 
5 interface IOwnable {
6 
7   function owner() external view returns (address);
8 
9   function renounceOwnership() external;
10   
11   function transferOwnership( address newOwner_ ) external;
12 }
13 
14 contract Ownable is IOwnable {
15     
16   address internal _owner;
17 
18   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20   /**
21    * @dev Initializes the contract setting the deployer as the initial owner.
22    */
23   constructor () {
24     _owner = msg.sender;
25     emit OwnershipTransferred( address(0), _owner );
26   }
27 
28   /**
29    * @dev Returns the address of the current owner.
30    */
31   function owner() public view override returns (address) {
32     return _owner;
33   }
34 
35   /**
36    * @dev Throws if called by any account other than the owner.
37    */
38   modifier onlyOwner() {
39     require( _owner == msg.sender, "Ownable: caller is not the owner" );
40     _;
41   }
42 
43   /**
44    * @dev Leaves the contract without owner. It will not be possible to call
45    * `onlyOwner` functions anymore. Can only be called by the current owner.
46    *
47    * NOTE: Renouncing ownership will leave the contract without an owner,
48    * thereby removing any functionality that is only available to the owner.
49    */
50   function renounceOwnership() public virtual override onlyOwner() {
51     emit OwnershipTransferred( _owner, address(0) );
52     _owner = address(0);
53   }
54 
55   /**
56    * @dev Transfers ownership of the contract to a new account (`newOwner`).
57    * Can only be called by the current owner.
58    */
59   function transferOwnership( address newOwner_ ) public virtual override onlyOwner() {
60     require( newOwner_ != address(0), "Ownable: new owner is the zero address");
61     emit OwnershipTransferred( _owner, newOwner_ );
62     _owner = newOwner_;
63   }
64 }
65 
66 interface IERC20 {
67 
68   function decimals() external view returns (uint8);
69   /**
70    * @dev Returns the amount of tokens in existence.
71    */
72   function totalSupply() external view returns (uint256);
73 
74   /**
75    * @dev Returns the amount of tokens owned by `account`.
76    */
77   function balanceOf(address account) external view returns (uint256);
78 
79   /**
80    * @dev Moves `amount` tokens from the caller's account to `recipient`.
81    *
82    * Returns a boolean value indicating whether the operation succeeded.
83    *
84    * Emits a {Transfer} event.
85    */
86   function transfer(address recipient, uint256 amount) external returns (bool);
87 
88   /**
89    * @dev Returns the remaining number of tokens that `spender` will be
90    * allowed to spend on behalf of `owner` through {transferFrom}. This is
91    * zero by default.
92    *
93    * This value changes when {approve} or {transferFrom} are called.
94    */
95   function allowance(address owner, address spender) external view returns (uint256);
96 
97   /**
98    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
99    *
100    * Returns a boolean value indicating whether the operation succeeded.
101    *
102    * IMPORTANT: Beware that changing an allowance with this method brings the risk
103    * that someone may use both the old and the new allowance by unfortunate
104    * transaction ordering. One possible solution to mitigate this race
105    * condition is to first reduce the spender's allowance to 0 and set the
106    * desired value afterwards:
107    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
108    *
109    * Emits an {Approval} event.
110    */
111   function approve(address spender, uint256 amount) external returns (bool);
112 
113   /**
114    * @dev Moves `amount` tokens from `sender` to `recipient` using the
115    * allowance mechanism. `amount` is then deducted from the caller's
116    * allowance.
117    *
118    * Returns a boolean value indicating whether the operation succeeded.
119    *
120    * Emits a {Transfer} event.
121    */
122   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
123 
124   /**
125    * @dev Emitted when `value` tokens are moved from one account (`from`) to
126    * another (`to`).
127    *
128    * Note that `value` may be zero.
129    */
130   event Transfer(address indexed from, address indexed to, uint256 value);
131 
132   /**
133    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
134    * a call to {approve}. `value` is the new allowance.
135    */
136   event Approval(address indexed owner, address indexed spender, uint256 value);
137 }
138 
139 library SafeMath {
140     /**
141      * @dev Returns the addition of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `+` operator.
145      *
146      * Requirements:
147      *
148      * - Addition cannot overflow.
149      */
150     function add(uint256 a, uint256 b) internal pure returns (uint256) {
151         uint256 c = a + b;
152         require(c >= a, "SafeMath: addition overflow");
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      *
165      * - Subtraction cannot overflow.
166      */
167     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
168         return sub(a, b, "SafeMath: subtraction overflow");
169     }
170 
171     /**
172      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
173      * overflow (when the result is negative).
174      *
175      * Counterpart to Solidity's `-` operator.
176      *
177      * Requirements:
178      *
179      * - Subtraction cannot overflow.
180      */
181     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
182         require(b <= a, errorMessage);
183         uint256 c = a - b;
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the multiplication of two unsigned integers, reverting on
190      * overflow.
191      *
192      * Counterpart to Solidity's `*` operator.
193      *
194      * Requirements:
195      *
196      * - Multiplication cannot overflow.
197      */
198     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
199         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
200         // benefit is lost if 'b' is also tested.
201         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
202         if (a == 0) {
203             return 0;
204         }
205 
206         uint256 c = a * b;
207         require(c / a == b, "SafeMath: multiplication overflow");
208 
209         return c;
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers. Reverts on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function div(uint256 a, uint256 b) internal pure returns (uint256) {
225         return div(a, b, "SafeMath: division by zero");
226     }
227 
228     /**
229      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
230      * division by zero. The result is rounded towards zero.
231      *
232      * Counterpart to Solidity's `/` operator. Note: this function uses a
233      * `revert` opcode (which leaves remaining gas untouched) while Solidity
234      * uses an invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
241         require(b > 0, errorMessage);
242         uint256 c = a / b;
243         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
244 
245         return c;
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
261         return mod(a, b, "SafeMath: modulo by zero");
262     }
263 
264     /**
265      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
266      * Reverts with custom message when dividing by zero.
267      *
268      * Counterpart to Solidity's `%` operator. This function uses a `revert`
269      * opcode (which leaves remaining gas untouched) while Solidity uses an
270      * invalid opcode to revert (consuming all remaining gas).
271      *
272      * Requirements:
273      *
274      * - The divisor cannot be zero.
275      */
276     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
277         require(b != 0, errorMessage);
278         return a % b;
279     }
280 
281     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
282     function sqrrt(uint256 a) internal pure returns (uint c) {
283         if (a > 3) {
284             c = a;
285             uint b = add( div( a, 2), 1 );
286             while (b < c) {
287                 c = b;
288                 b = div( add( div( a, b ), b), 2 );
289             }
290         } else if (a != 0) {
291             c = 1;
292         }
293     }
294 
295     /*
296      * Expects percentage to be trailed by 00,
297     */
298     function percentageAmount( uint256 total_, uint8 percentage_ ) internal pure returns ( uint256 percentAmount_ ) {
299         return div( mul( total_, percentage_ ), 1000 );
300     }
301 
302     /*
303      * Expects percentage to be trailed by 00,
304     */
305     function substractPercentage( uint256 total_, uint8 percentageToSub_ ) internal pure returns ( uint256 result_ ) {
306         return sub( total_, div( mul( total_, percentageToSub_ ), 1000 ) );
307     }
308 
309     function percentageOfTotal( uint256 part_, uint256 total_ ) internal pure returns ( uint256 percent_ ) {
310         return div( mul(part_, 100) , total_ );
311     }
312 
313     /**
314      * Taken from Hypersonic https://github.com/M2629/HyperSonic/blob/main/Math.sol
315      * @dev Returns the average of two numbers. The result is rounded towards
316      * zero.
317      */
318     function average(uint256 a, uint256 b) internal pure returns (uint256) {
319         // (a + b) / 2 can overflow, so we distribute
320         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
321     }
322 
323     function quadraticPricing( uint256 payment_, uint256 multiplier_ ) internal pure returns (uint256) {
324         return sqrrt( mul( multiplier_, payment_ ) );
325     }
326 
327   function bondingCurve( uint256 supply_, uint256 multiplier_ ) internal pure returns (uint256) {
328       return mul( multiplier_, supply_ );
329   }
330 }
331 
332 contract aOHMMigration is Ownable {
333     using SafeMath for uint256;
334 
335     uint256 swapEndBlock;
336 
337     IERC20 public OHM;
338     IERC20 public aOHM;
339     
340     bool public isInitialized;
341 
342     mapping(address => uint256) public senderInfo;
343     
344     modifier onlyInitialized() {
345         require(isInitialized, "not initialized");
346         _;
347     }
348     
349     modifier notInitialized() {
350         require( !isInitialized, "already initialized" );
351         _;
352     }
353 
354     function initialize (
355         address _OHM,
356         address _aOHM,
357         uint256 _swapDuration
358     ) public onlyOwner() notInitialized() {
359         OHM = IERC20(_OHM);
360         aOHM = IERC20(_aOHM);
361         swapEndBlock = block.number.add(_swapDuration);
362         isInitialized = true;
363     }
364 
365     function migrate(uint256 amount) external onlyInitialized() {
366         require(
367             aOHM.balanceOf(msg.sender) >= amount,
368             "amount above user balance"
369         );
370         require(block.number < swapEndBlock, "swapping of aOHM has ended");
371 
372         aOHM.transferFrom(msg.sender, address(this), amount);
373         senderInfo[msg.sender] = senderInfo[msg.sender].add(amount);
374         OHM.transfer(msg.sender, amount);
375     }
376 
377     function reclaim() external {
378         require(senderInfo[msg.sender] > 0, "user has no aOHM to withdraw");
379         require(
380             block.number > swapEndBlock,
381             "aOHM swap is still ongoing"
382         );
383 
384         uint256 amount = senderInfo[msg.sender];
385         senderInfo[msg.sender] = 0;
386         aOHM.transfer(msg.sender, amount);
387     }
388 
389     function withdraw() external onlyOwner() {
390         require(block.number > swapEndBlock, "swapping of aOHM has not ended");
391         uint256 amount = OHM.balanceOf(address(this));
392 
393         OHM.transfer(msg.sender, amount);
394     }
395 }