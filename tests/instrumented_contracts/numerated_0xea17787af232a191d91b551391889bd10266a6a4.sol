1 pragma solidity ^0.5.5;
2 
3 
4 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12     function totalSupply() public view returns (uint256);
13     function balanceOf(address who) public view returns (uint256);
14     function transfer(address to, uint256 value) public returns (bool);
15     event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 /**
19  * @dev Wrappers over Solidity's arithmetic operations with added overflow
20  * checks.
21  *
22  * Arithmetic operations in Solidity wrap on overflow. This can easily result
23  * in bugs, because programmers usually assume that an overflow raises an
24  * error, which is the standard behavior in high level programming languages.
25  * `SafeMath` restores this intuition by reverting the transaction when an
26  * operation overflows.
27  *
28  * Using this library instead of the unchecked operations eliminates an entire
29  * class of bugs, so it's recommended to use it always.
30  */
31 library SafeMath {
32     /**
33      * @dev Returns the addition of two unsigned integers, reverting on
34      * overflow.
35      *
36      * Counterpart to Solidity's `+` operator.
37      *
38      * Requirements:
39      * - Addition cannot overflow.
40      */
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         require(c >= a, "SafeMath: addition overflow");
44 
45         return c;
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      */
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         return sub(a, b, "SafeMath: subtraction overflow");
59     }
60 
61     /**
62      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
63      * overflow (when the result is negative).
64      *
65      * Counterpart to Solidity's `-` operator.
66      *
67      * Requirements:
68      * - Subtraction cannot overflow.
69      *
70      * _Available since v2.4.0._
71      */
72     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         require(b <= a, errorMessage);
74         uint256 c = a - b;
75 
76         return c;
77     }
78 
79     /**
80      * @dev Returns the multiplication of two unsigned integers, reverting on
81      * overflow.
82      *
83      * Counterpart to Solidity's `*` operator.
84      *
85      * Requirements:
86      * - Multiplication cannot overflow.
87      */
88     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
90         // benefit is lost if 'b' is also tested.
91         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
92         if (a == 0) {
93             return 0;
94         }
95 
96         uint256 c = a * b;
97         require(c / a == b, "SafeMath: multiplication overflow");
98 
99         return c;
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      */
113     function div(uint256 a, uint256 b) internal pure returns (uint256) {
114         return div(a, b, "SafeMath: division by zero");
115     }
116 
117     /**
118      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
119      * division by zero. The result is rounded towards zero.
120      *
121      * Counterpart to Solidity's `/` operator. Note: this function uses a
122      * `revert` opcode (which leaves remaining gas untouched) while Solidity
123      * uses an invalid opcode to revert (consuming all remaining gas).
124      *
125      * Requirements:
126      * - The divisor cannot be zero.
127      *
128      * _Available since v2.4.0._
129      */
130     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
131         // Solidity only automatically asserts when dividing by 0
132         require(b > 0, errorMessage);
133         uint256 c = a / b;
134         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141      * Reverts when dividing by zero.
142      *
143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
144      * opcode (which leaves remaining gas untouched) while Solidity uses an
145      * invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      * - The divisor cannot be zero.
149      */
150     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
151         return mod(a, b, "SafeMath: modulo by zero");
152     }
153 
154     /**
155      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
156      * Reverts with custom message when dividing by zero.
157      *
158      * Counterpart to Solidity's `%` operator. This function uses a `revert`
159      * opcode (which leaves remaining gas untouched) while Solidity uses an
160      * invalid opcode to revert (consuming all remaining gas).
161      *
162      * Requirements:
163      * - The divisor cannot be zero.
164      *
165      * _Available since v2.4.0._
166      */
167     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
168         require(b != 0, errorMessage);
169         return a % b;
170     }
171 }
172 
173 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
174 
175 /**
176  * @title ERC20 interface
177  * @dev see https://github.com/ethereum/EIPs/issues/20
178  */
179 contract ERC20 is ERC20Basic {
180     function allowance(address owner, address spender) public view returns (uint256);
181     function transferFrom(address from, address to, uint256 value) public returns (bool);
182     function approve(address spender, uint256 value) public returns (bool);
183     function name() public view returns (string memory);
184     function symbol() public view returns (string memory);
185     function decimals() public view returns (uint8);
186     event Approval(address indexed owner, address indexed spender, uint256 value);
187 }
188 
189 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
190 
191 /**
192  * @title Ownable
193  * @dev The Ownable contract has an owner address, and provides basic authorization control
194  * functions, this simplifies the implementation of "user permissions".
195  */
196 contract Ownable {
197     address public owner;
198     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
199 
200 
201     /**
202     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
203     * account.
204     */
205     constructor() public {
206         owner = msg.sender;
207     }
208 
209     /**
210     * @dev Throws if called by any account other than the owner.
211     */
212     modifier onlyOwner() {
213         require(msg.sender == owner);
214         _;
215     }
216 
217     /**
218     * @dev Allows the current owner to transfer control of the contract to a newOwner.
219     * @param newOwner The address to transfer ownership to.
220     */
221     function transferOwnership(address newOwner) public onlyOwner {
222         require(newOwner != address(0));
223         emit OwnershipTransferred(owner, newOwner);
224         owner = newOwner;
225     }
226 }
227 
228 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
229 
230 /**
231  * @title Pausable
232  * @dev Base contract which allows children to implement an emergency stop mechanism.
233  */
234 contract Pausable is Ownable {
235     event Pause();
236     event Unpause();
237 
238     bool public paused = false;
239 
240 
241     /**
242     * @dev Modifier to make a function callable only when the contract is not paused.
243     */
244     modifier whenNotPaused() {
245         require(!paused);
246         _;
247     }
248 
249     /**
250     * @dev Modifier to make a function callable only when the contract is paused.
251     */
252     modifier whenPaused() {
253         require(paused);
254         _;
255     }
256 
257     /**
258     * @dev called by the owner to pause, triggers stopped state
259     */
260     function pause() onlyOwner whenNotPaused public {
261         paused = true;
262         emit Pause();
263     }
264 
265     /**
266     * @dev called by the owner to unpause, returns to normal state
267     */
268     function unpause() onlyOwner whenPaused public {
269         paused = false;
270         emit Unpause();
271     }
272 }
273 
274 contract FilescoinPresale is Pausable {
275 
276     using SafeMath for uint256;
277 
278     enum PreSaleStage { One, Two, Three, Finished }
279 
280     ERC20 public token;
281     uint256 public unit = 0;
282 
283     uint256 public PreSaleMinEther = 0.1 ether;
284     uint256 public PreSaleMaxEther = 20 ether;
285     uint256 public PreSaleStartTime = 1604750400; // 2020-11-07 12:00:00 UTC
286 
287     PreSaleStage public stage = PreSaleStage.One;
288 
289     uint256 public constant StageOneLimit = 1000 ether;
290     uint256 public constant StageOneRatio = 3000;
291     uint256 public StageOneCurrentSale = 0;
292 
293     uint256 public constant StageTwoLimit = 1000 ether;
294     uint256 public constant StageTwoRatio = 2000;
295     uint256 public StageTwoCurrentSale = 0;
296 
297 
298     uint256 public constant StageThreeLimit = 1000 ether;
299     uint256 public constant StageThreeRatio = 1000;
300     uint256 public StageThreeCurrentSale = 0;
301 
302 
303     constructor() public {
304         address tokenAddress = 0xdf7795bF05e17c5c38E666d48b5fAC014DdFFF82;
305         token = ERC20(tokenAddress);
306         uint256 decimals = token.decimals();
307         unit = 1 ether / (10 ** decimals );
308     }
309 
310     function() payable external{
311         require(block.timestamp >= PreSaleStartTime,"Pre-sale has not started yet");
312         require(msg.value >= PreSaleMinEther,"Pre-sale value must be not less than 0.1 ether ");
313         require(msg.value <= PreSaleMaxEther,"Pre-sale value must be no more than 20 ether ");
314         preSale();
315     }
316 
317     function preSale() internal whenNotPaused {
318         require(stage != PreSaleStage.Finished,"Pre-sale is over");
319         if(stage == PreSaleStage.One) {
320             preSaleStageOne(msg.value);
321         }else if(stage == PreSaleStage.Two){
322             preSaleStageTwo(msg.value);
323         }else {
324             preSaleStageThree(msg.value);
325         }
326 
327     }
328 
329     function preSaleStageOne(uint256 value) internal {
330         uint256 stageOneLeft = StageOneLimit.sub(StageOneCurrentSale);
331         uint256 preSaleValue = stageOneLeft < value ? stageOneLeft : value;
332         StageOneCurrentSale += preSaleValue;
333         if(StageOneCurrentSale == StageOneLimit) {
334             stage = PreSaleStage.Two;
335         }
336         uint256 sendToken = preSaleValue.div(unit).mul(StageOneRatio);
337         require(token.transfer(msg.sender,sendToken));
338         if(value > preSaleValue) {
339             preSaleStageTwo(value.sub(preSaleValue));
340         }
341     }
342 
343     function preSaleStageTwo(uint256 value) internal {
344         uint256 stageTwoLeft = StageTwoLimit.sub(StageTwoCurrentSale);
345         uint256 preSaleValue = stageTwoLeft < value ? stageTwoLeft : value;
346         StageTwoCurrentSale += preSaleValue;
347         if(StageTwoCurrentSale == StageTwoLimit) {
348             stage = PreSaleStage.Three;
349         }
350         uint256 sendToken = preSaleValue.div(unit).mul(StageTwoRatio);
351         require(token.transfer(msg.sender,sendToken));
352         if(value > preSaleValue) {
353             preSaleStageThree(value.sub(preSaleValue));
354         }
355     }
356 
357     function preSaleStageThree(uint256 value) internal {
358         uint256 stageThreeLeft = StageThreeLimit.sub(StageThreeCurrentSale);
359         uint256 preSaleValue = stageThreeLeft < value ? stageThreeLeft : value;
360         StageThreeCurrentSale += preSaleValue;
361         if(StageThreeCurrentSale == StageThreeLimit) {
362             stage = PreSaleStage.Finished;
363         }
364         uint256 sendToken = preSaleValue.div(unit).mul(StageThreeRatio);
365         require(token.transfer(msg.sender,sendToken));
366         if(value > preSaleValue) {
367             msg.sender.transfer(value.sub(preSaleValue));
368         }
369     }
370 
371     function withdrawToken(address to,uint value) onlyOwner whenNotPaused external {
372         uint256 balance = token.balanceOf(address(this));
373         require(balance >= value,"Token Balance is not enough");
374         require(token.transfer(to,value));
375     }
376 
377     function withdrawEther(address payable to,uint value) onlyOwner whenNotPaused external returns(bool) {
378         require(to != address(0), "Receiver address must not be zero");
379         to.transfer(value);
380         return true;
381     }
382 
383 }