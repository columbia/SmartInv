1 pragma solidity =0.8.21;
2 // SPDX-License-Identifier: MIT
3 
4 library SafeMath {
5     /**
6      * @dev Returns the addition of two unsigned integers, with an overflow flag.
7      *
8      * _Available since v3.4._
9      */
10     function tryAdd(uint256 a, uint256 b)
11         internal
12         pure
13         returns (bool, uint256)
14     {
15         unchecked {
16             uint256 c = a + b;
17             if (c < a) return (false, 0);
18             return (true, c);
19         }
20     }
21 
22     /**
23      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
24      *
25      * _Available since v3.4._
26      */
27     function trySub(uint256 a, uint256 b)
28         internal
29         pure
30         returns (bool, uint256)
31     {
32         unchecked {
33             if (b > a) return (false, 0);
34             return (true, a - b);
35         }
36     }
37 
38     /**
39      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
40      *
41      * _Available since v3.4._
42      */
43     function tryMul(uint256 a, uint256 b)
44         internal
45         pure
46         returns (bool, uint256)
47     {
48         unchecked {
49             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
50             // benefit is lost if 'b' is also tested.
51             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
52             if (a == 0) return (true, 0);
53             uint256 c = a * b;
54             if (c / a != b) return (false, 0);
55             return (true, c);
56         }
57     }
58 
59     /**
60      * @dev Returns the division of two unsigned integers, with a division by zero flag.
61      *
62      * _Available since v3.4._
63      */
64     function tryDiv(uint256 a, uint256 b)
65         internal
66         pure
67         returns (bool, uint256)
68     {
69         unchecked {
70             if (b == 0) return (false, 0);
71             return (true, a / b);
72         }
73     }
74 
75     /**
76      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
77      *
78      * _Available since v3.4._
79      */
80     function tryMod(uint256 a, uint256 b)
81         internal
82         pure
83         returns (bool, uint256)
84     {
85         unchecked {
86             if (b == 0) return (false, 0);
87             return (true, a % b);
88         }
89     }
90 
91     /**
92      * @dev Returns the addition of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `+` operator.
96      *
97      * Requirements:
98      *
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         return a + b;
103     }
104 
105     /**
106      * @dev Returns the subtraction of two unsigned integers, reverting on
107      * overflow (when the result is negative).
108      *
109      * Counterpart to Solidity's `-` operator.
110      *
111      * Requirements:
112      *
113      * - Subtraction cannot overflow.
114      */
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         return a - b;
117     }
118 
119     /**
120      * @dev Returns the multiplication of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `*` operator.
124      *
125      * Requirements:
126      *
127      * - Multiplication cannot overflow.
128      */
129     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
130         return a * b;
131     }
132 
133     /**
134      * @dev Returns the integer division of two unsigned integers, reverting on
135      * division by zero. The result is rounded towards zero.
136      *
137      * Counterpart to Solidity's `/` operator.
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function div(uint256 a, uint256 b) internal pure returns (uint256) {
144         return a / b;
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
149      * reverting when dividing by zero.
150      *
151      * Counterpart to Solidity's `%` operator. This function uses a `revert`
152      * opcode (which leaves remaining gas untouched) while Solidity uses an
153      * invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      *
157      * - The divisor cannot be zero.
158      */
159     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
160         return a % b;
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165      * overflow (when the result is negative).
166      *
167      * CAUTION: This function is deprecated because it requires allocating memory for the error
168      * message unnecessarily. For custom revert reasons use {trySub}.
169      *
170      * Counterpart to Solidity's `-` operator.
171      *
172      * Requirements:
173      *
174      * - Subtraction cannot overflow.
175      */
176     function sub(
177         uint256 a,
178         uint256 b,
179         string memory errorMessage
180     ) internal pure returns (uint256) {
181         unchecked {
182             require(b <= a, errorMessage);
183             return a - b;
184         }
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(
200         uint256 a,
201         uint256 b,
202         string memory errorMessage
203     ) internal pure returns (uint256) {
204         unchecked {
205             require(b > 0, errorMessage);
206             return a / b;
207         }
208     }
209 
210     /**
211      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212      * reverting with custom message when dividing by zero.
213      *
214      * CAUTION: This function is deprecated because it requires allocating memory for the error
215      * message unnecessarily. For custom revert reasons use {tryMod}.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function mod(
226         uint256 a,
227         uint256 b,
228         string memory errorMessage
229     ) internal pure returns (uint256) {
230         unchecked {
231             require(b > 0, errorMessage);
232             return a % b;
233         }
234     }
235 }
236 
237 abstract contract Context {
238     function _msgSender() internal view virtual returns (address) {
239         return msg.sender;
240     }
241 
242     function _msgData() internal view virtual returns (bytes calldata) {
243         return msg.data;
244     }
245 }
246 
247 abstract contract Ownable is Context {
248     address private _owner;
249 
250     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
251 
252     constructor() {
253         _setOwner(_msgSender());
254     }
255 
256     function owner() public view virtual returns (address) {
257         return _owner;
258     }
259 
260     modifier onlyOwner() {
261         require(owner() == _msgSender(), "Ownable: caller is not the owner");
262         _;
263     }
264 
265     function renounceOwnership() public virtual onlyOwner {
266         _setOwner(address(0));
267     }
268 
269     function transferOwnership(address newOwner) public virtual onlyOwner {
270         require(newOwner != address(0), "Ownable: new owner is the zero address");
271         _setOwner(newOwner);
272     }
273 
274     function _setOwner(address newOwner) private {
275         address oldOwner = _owner;
276         _owner = newOwner;
277         emit OwnershipTransferred(oldOwner, newOwner);
278     }
279 }
280 
281 interface IERC20 {
282 
283     function totalSupply() external view returns (uint256);
284 
285     function balanceOf(address account) external view returns (uint256);
286 
287     function transfer(address recipient, uint256 amount) external returns (bool);
288 
289     function allowance(address owner, address spender) external view returns (uint256);
290 
291     function approve(address spender, uint256 amount) external returns (bool);
292 
293     function transferFrom(
294         address sender,
295         address recipient,
296         uint256 amount
297     ) external returns (bool);
298 
299     event Transfer(address indexed from, address indexed to, uint256 value);
300 
301     event Approval(address indexed owner, address indexed spender, uint256 value);
302 }
303 
304 interface IUniswapV2Router {
305     function swapExactETHForTokensSupportingFeeOnTransferTokens(
306         uint amountOutMin,
307         address[] calldata path,
308         address to,
309         uint deadline
310     ) external payable;
311 }
312 
313 contract WagerStaking is Ownable {
314     using SafeMath for uint256;
315 
316     mapping(address => bool) public staked;
317     mapping(address => uint256) public tokenBalanceLedger_;
318     mapping(address => uint256) public stakeStartTime;
319 
320     address public stakeTokenAddress = 0x63a60C5469379149757Cc3e58453202eBDB7e933;
321     IERC20 public stakeToken;  
322 
323     uint256 public totalTokens = 0;
324 
325     uint256 public allEthHistoric = 0;
326 
327     uint256 public profitPerShare_;
328 
329     mapping(address => uint256) public payoutsTo_;
330 
331     uint256 constant internal magnitude = 2**64;
332 
333     constructor() {
334         stakeToken = IERC20(stakeTokenAddress);
335     }
336 
337     receive() external payable {
338         profitPerShare_ +=  (msg.value * magnitude) / totalTokens;
339         allEthHistoric += msg.value;
340     }
341     
342     function deposit() public payable {
343         profitPerShare_ +=  (msg.value * magnitude) / totalTokens;
344         allEthHistoric += msg.value;
345     }
346 
347     function stakeTokens(uint amount) public {
348 
349         stakeToken.transferFrom(msg.sender, address(this), amount);
350 
351         uint256 currentDivs = getDividends(msg.sender);
352 
353         tokenBalanceLedger_[msg.sender] += amount;
354         staked[msg.sender] = true;
355 
356         totalTokens += amount;
357 
358         stakeStartTime[msg.sender] = block.timestamp;
359 
360         payoutsTo_[msg.sender] += (getDividends(msg.sender) - currentDivs);
361     }
362 
363     function exitFromStakingPool() public {
364         withdrawDividends();
365 
366         stakeToken.transfer(msg.sender, tokenBalanceLedger_[msg.sender]);
367 
368         totalTokens -= tokenBalanceLedger_[msg.sender];
369         tokenBalanceLedger_[msg.sender] = 0;
370         staked[msg.sender] = false;
371         payoutsTo_[msg.sender] = 0;
372     }
373 
374     function getDividends(address user) public view returns(uint256) {
375         uint256 allDivs = (tokenBalanceLedger_[user] * profitPerShare_) / magnitude;
376 
377         uint256 profit = allDivs - payoutsTo_[user];
378 
379         return profit;
380     }
381 
382     function getTokenBalance(address user) public view returns(uint256) {
383         return tokenBalanceLedger_[user];
384     }
385 
386     function withdrawDividends() public {
387         uint256 myDivs = getDividends(msg.sender);
388 
389         payoutsTo_[msg.sender] += myDivs;
390         payable(msg.sender).transfer(myDivs);
391     }
392 
393 }