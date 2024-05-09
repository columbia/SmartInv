1 /*
2   ________            ___    __                    __                 ____             __                   __
3  /_  __/ /_  ___     /   |  / /_  _________  _____/ /_  ___  _____   / __ \_________  / /_____  _________  / /
4   / / / __ \/ _ \   / /| | / __ \/ ___/ __ \/ ___/ __ \/ _ \/ ___/  / /_/ / ___/ __ \/ __/ __ \/ ___/ __ \/ / 
5  / / / / / /  __/  / ___ |/ /_/ (__  ) /_/ / /  / /_/ /  __/ /     / ____/ /  / /_/ / /_/ /_/ / /__/ /_/ / /  
6 /_/ /_/ /_/\___/  /_/  |_/_.___/____/\____/_/  /_.___/\___/_/     /_/   /_/   \____/\__/\____/\___/\____/_/   
7 
8   _____             __  _             _____          __               __ 
9  / ___/______ ___ _/ /_(_)__  ___    / ___/__  ___  / /________ _____/ /_
10 / /__/ __/ -_) _ `/ __/ / _ \/ _ \  / /__/ _ \/ _ \/ __/ __/ _ `/ __/ __/
11 \___/_/  \__/\_,_/\__/_/\___/_//_/  \___/\___/_//_/\__/_/  \_,_/\__/\__/ 
12 
13 */
14 
15 pragma solidity ^0.7.0;
16 //SPDX-License-Identifier: UNLICENSED
17 
18 interface IERC20 {
19     function totalSupply() external view returns (uint);
20     function balanceOf(address who) external view returns (uint);
21     function allowance(address owner, address spender) external view returns (uint);
22     function transfer(address to, uint value) external returns (bool);
23     function approve(address spender, uint value) external returns (bool);
24     function transferFrom(address from, address to, uint value) external returns (bool);
25     event Transfer(address indexed from, address indexed to, uint value);
26     event Approval(address indexed owner, address indexed spender, uint value);
27     
28     function unPauseTransferForever() external;
29     function uniswapV2Pair() external returns(address);
30 }
31 interface IUNIv2 {
32     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) 
33     external 
34     payable 
35     returns (uint amountToken, uint amountETH, uint liquidity);
36     
37     function WETH() external pure returns (address);
38 
39 }
40 
41 interface IUnicrypt {
42     event onDeposit(address, uint256, uint256);
43     event onWithdraw(address, uint256);
44     function depositToken(address token, uint256 amount, uint256 unlock_date) external payable; 
45     function withdrawToken(address token, uint256 amount) external;
46 
47 }
48 
49 interface IUniswapV2Factory {
50   event PairCreated(address indexed token0, address indexed token1, address pair, uint);
51 
52   function createPair(address tokenA, address tokenB) external returns (address pair);
53 }
54 
55 abstract contract Context {
56     function _msgSender() internal view virtual returns (address payable) {
57         return msg.sender;
58     }
59 
60     function _msgData() internal view virtual returns (bytes memory) {
61         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
62         return msg.data;
63     }
64 }
65 
66 abstract contract ReentrancyGuard {
67     // Booleans are more expensive than uint256 or any type that takes up a full
68     // word because each write operation emits an extra SLOAD to first read the
69     // slot's contents, replace the bits taken up by the boolean, and then write
70     // back. This is the compiler's defense against contract upgrades and
71     // pointer aliasing, and it cannot be disabled.
72 
73     // The values being non-zero value makes deployment a bit more expensive,
74     // but in exchange the refund on every call to nonReentrant will be lower in
75     // amount. Since refunds are capped to a percentage of the total
76     // transaction's gas, it is best to keep them low in cases like this one, to
77     // increase the likelihood of the full refund coming into effect.
78     uint256 private constant _NOT_ENTERED = 1;
79     uint256 private constant _ENTERED = 2;
80 
81     uint256 private _status;
82 
83     constructor () {
84         _status = _NOT_ENTERED;
85     }
86 
87     /**
88      * @dev Prevents a contract from calling itself, directly or indirectly.
89      * Calling a `nonReentrant` function from another `nonReentrant`
90      * function is not supported. It is possible to prevent this from happening
91      * by making the `nonReentrant` function external, and make it call a
92      * `private` function that does the actual work.
93      */
94     modifier nonReentrant() {
95         // On the first call to nonReentrant, _notEntered will be true
96         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
97 
98         // Any calls to nonReentrant after this point will fail
99         _status = _ENTERED;
100 
101         _;
102 
103         // By storing the original value once again, a refund is triggered (see
104         // https://eips.ethereum.org/EIPS/eip-2200)
105         _status = _NOT_ENTERED;
106     }
107 }
108 
109 
110 contract AbsorberPresale is Context, ReentrancyGuard {
111     using SafeMath for uint;
112     IERC20 public ABS;
113     address public _burnPool = 0x000000000000000000000000000000000000dEaD;
114 
115     IUNIv2 constant uniswap =  IUNIv2(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
116     IUniswapV2Factory constant uniswapFactory = IUniswapV2Factory(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
117     IUnicrypt constant unicrypt = IUnicrypt(0x17e00383A843A9922bCA3B280C0ADE9f8BA48449);
118     
119     uint public tokensBought;
120     bool public isStopped = false;
121     bool public teamClaimed = false;
122     bool public moonMissionStarted = false;
123     bool public isRefundEnabled = false;
124     bool public presaleStarted = false;
125     bool justTrigger = false;
126     uint constant teamTokens = 70000 ether;
127 
128     address payable owner;
129     address payable constant owner1 = 0xad5395627309774916B08b721C228f18D9973530;
130     address payable constant owner2 = 0xe1cDA441ffA203eCA692E3398f3C3346Ee2B786e;
131     address payable constant owner3 = 0xe99AbaEbE6Ed58A6b61C7eb3791D149de7791Fd5;
132     
133     address public pool;
134     
135     uint256 public liquidityUnlock;
136     
137     uint256 public ethSent;
138     uint256 constant tokensPerETH = 800;
139     uint256 public lockedLiquidityAmount;
140     uint256 public timeTowithdrawTeamTokens;
141     uint256 public refundTime; 
142     mapping(address => uint) ethSpent;
143     
144      modifier onlyOwner() {
145         require(msg.sender == owner, "You are not the owner");
146         _;
147     }
148     
149     constructor() {
150         owner = msg.sender; 
151         liquidityUnlock = block.timestamp.add(365 days);
152         refundTime = block.timestamp.add(7 days);
153     }
154     
155     
156     receive() external payable {
157         
158         buyTokens();
159     }
160     
161     function SUPER_DUPER_EMERGENCY_ALLOW_REFUNDS_DO_NOT_FUCKING_CALL_IT_FOR_FUN() external onlyOwner nonReentrant {
162         isRefundEnabled = true;
163         isStopped = true;
164     }
165     
166     function getRefund() external nonReentrant {
167         require(msg.sender == tx.origin);
168         require(!justTrigger);
169         // Refund should be enabled by the owner OR 7 days passed 
170         require(isRefundEnabled || block.timestamp >= refundTime,"Cannot refund");
171         address payable user = msg.sender;
172         uint256 amount = ethSpent[user];
173         ethSpent[user] = 0;
174         user.transfer(amount);
175     }
176     
177     function lockWithUnicrypt() external onlyOwner  {
178         pool = ABS.uniswapV2Pair();
179         IERC20 liquidityTokens = IERC20(pool);
180         uint256 liquidityBalance = liquidityTokens.balanceOf(address(this));
181         uint256 timeToLuck = liquidityUnlock;
182         liquidityTokens.approve(address(unicrypt), liquidityBalance);
183 
184         unicrypt.depositToken{value: 0} (pool, liquidityBalance, timeToLuck);
185         lockedLiquidityAmount = lockedLiquidityAmount.add(liquidityBalance);
186     }
187     
188     function withdrawFromUnicrypt(uint256 amount) external onlyOwner {
189         unicrypt.withdrawToken(pool, amount);
190     }
191     
192     function withdrawTeamTokens() external onlyOwner nonReentrant {
193         require(teamClaimed);
194         require(block.timestamp >= timeTowithdrawTeamTokens, "Cannot withdraw yet");
195         uint256 tokesToClaim = 7000 ether;
196         uint256 amount = tokesToClaim.div(3); 
197         ABS.transfer(owner1, amount);
198         ABS.transfer(owner2, amount);
199         ABS.transfer(owner3, amount);
200         timeTowithdrawTeamTokens = block.timestamp.add(10 days);
201     }
202 
203     function setABS(IERC20 addr) external onlyOwner nonReentrant {
204         require(ABS == IERC20(address(0)), "You can set the address only once");
205         ABS = addr;
206     }
207     
208     function startPresale() external onlyOwner { 
209         presaleStarted = true;
210     }
211     
212      function pausePresale() external onlyOwner { 
213         presaleStarted = false;
214     }
215 
216     function buyTokens() public payable nonReentrant {
217         require(msg.sender == tx.origin);
218         require(presaleStarted == true, "Presale is paused, do not send ETH");
219         require(ABS != IERC20(address(0)), "Main contract address not set");
220         require(!isStopped, "Presale stopped by contract, do not send ETH");
221         require(msg.value >= 0.1 ether, "You sent less than 0.1 ETH");
222         require(msg.value <= 3 ether, "You sent more than 3 ETH");
223         require(ethSent < 349 ether, "Hard cap reached");
224         require (msg.value.add(ethSent) <= 349 ether, "Hardcap will be reached");
225         require(ethSpent[msg.sender].add(msg.value) <= 3 ether, "You cannot buy more");
226         uint256 tokens = msg.value.mul(tokensPerETH);
227         require(ABS.balanceOf(address(this)) >= tokens, "Not enough tokens in the contract");
228         ethSpent[msg.sender] = ethSpent[msg.sender].add(msg.value);
229         tokensBought = tokensBought.add(tokens);
230         ethSent = ethSent.add(msg.value);
231         ABS.transfer(msg.sender, tokens);
232     }
233    
234     function userEthSpenttInPresale(address user) external view returns(uint){
235         return ethSpent[user];
236     }
237     
238  
239     
240     function claimTeamFeeAndAddLiquidity() external onlyOwner  {
241        require(!teamClaimed);
242        uint256 amountETH = address(this).balance.mul(10).div(100); 
243        uint256 amountETH2 = address(this).balance.mul(15).div(100); 
244        uint256 amountETH3 = address(this).balance.mul(8).div(100); 
245        owner1.transfer(amountETH);
246        owner2.transfer(amountETH2);
247        owner3.transfer(amountETH3);
248        teamClaimed = true;
249        
250        addLiquidity();
251     }
252         
253     function addLiquidity() internal {
254         uint256 ETH = address(this).balance;
255         uint256 tokensForUniswap = address(this).balance.mul(675);
256         uint256 tokensToBurn = ABS.balanceOf(address(this)).sub(tokensForUniswap).sub(teamTokens);
257         ABS.unPauseTransferForever();
258         ABS.approve(address(uniswap), tokensForUniswap);
259         uniswap.addLiquidityETH
260         { value: ETH }
261         (
262             address(ABS),
263             tokensForUniswap,
264             tokensForUniswap,
265             ETH,
266             address(this),
267             block.timestamp
268         );
269        
270        if (tokensToBurn > 0){
271            ABS.transfer(_burnPool ,tokensToBurn);
272        }
273        
274        justTrigger = true;
275        
276         if(!isStopped)
277             isStopped = true;
278             
279    }
280     
281     function withdrawLockedTokensAfter1Year(address tokenAddress, uint256 tokenAmount) external onlyOwner  {
282         require(block.timestamp >= liquidityUnlock, "You cannot withdraw yet");
283         IERC20(tokenAddress).transfer(owner, tokenAmount);
284     }
285 
286 }
287 
288 
289 library SafeMath {
290     /**
291      * @dev Returns the addition of two unsigned integers, reverting on
292      * overflow.
293      *
294      * Counterpart to Solidity's `+` operator.
295      *
296      * Requirements:
297      *
298      * - Addition cannot overflow.
299      */
300     function add(uint256 a, uint256 b) internal pure returns (uint256) {
301         uint256 c = a + b;
302         require(c >= a, "SafeMath: addition overflow");
303 
304         return c;
305     }
306 
307     /**
308      * @dev Returns the subtraction of two unsigned integers, reverting on
309      * overflow (when the result is negative).
310      *
311      * Counterpart to Solidity's `-` operator.
312      *
313      * Requirements:
314      *
315      * - Subtraction cannot overflow.
316      */
317     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
318         return sub(a, b, "SafeMath: subtraction overflow");
319     }
320 
321     /**
322      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
323      * overflow (when the result is negative).
324      *
325      * Counterpart to Solidity's `-` operator.
326      *
327      * Requirements:
328      *
329      * - Subtraction cannot overflow.
330      */
331     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
332         require(b <= a, errorMessage);
333         uint256 c = a - b;
334 
335         return c;
336     }
337 
338     /**
339      * @dev Returns the multiplication of two unsigned integers, reverting on
340      * overflow.
341      *
342      * Counterpart to Solidity's `*` operator.
343      *
344      * Requirements:
345      *
346      * - Multiplication cannot overflow.
347      */
348     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
349         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
350         // benefit is lost if 'b' is also tested.
351         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
352         if (a == 0) {
353             return 0;
354         }
355 
356         uint256 c = a * b;
357         require(c / a == b, "SafeMath: multiplication overflow");
358 
359         return c;
360     }
361 
362     /**
363      * @dev Returns the integer division of two unsigned integers. Reverts on
364      * division by zero. The result is rounded towards zero.
365      *
366      * Counterpart to Solidity's `/` operator. Note: this function uses a
367      * `revert` opcode (which leaves remaining gas untouched) while Solidity
368      * uses an invalid opcode to revert (consuming all remaining gas).
369      *
370      * Requirements:
371      *
372      * - The divisor cannot be zero.
373      */
374     function div(uint256 a, uint256 b) internal pure returns (uint256) {
375         return div(a, b, "SafeMath: division by zero");
376     }
377 
378     /**
379      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
380      * division by zero. The result is rounded towards zero.
381      *
382      * Counterpart to Solidity's `/` operator. Note: this function uses a
383      * `revert` opcode (which leaves remaining gas untouched) while Solidity
384      * uses an invalid opcode to revert (consuming all remaining gas).
385      *
386      * Requirements:
387      *
388      * - The divisor cannot be zero.
389      */
390     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
391         require(b > 0, errorMessage);
392         uint256 c = a / b;
393         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
394 
395         return c;
396     }
397 
398     /**
399      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
400      * Reverts when dividing by zero.
401      *
402      * Counterpart to Solidity's `%` operator. This function uses a `revert`
403      * opcode (which leaves remaining gas untouched) while Solidity uses an
404      * invalid opcode to revert (consuming all remaining gas).
405      *
406      * Requirements:
407      *
408      * - The divisor cannot be zero.
409      */
410     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
411         return mod(a, b, "SafeMath: modulo by zero");
412     }
413 
414     /**
415      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
416      * Reverts with custom message when dividing by zero.
417      *
418      * Counterpart to Solidity's `%` operator. This function uses a `revert`
419      * opcode (which leaves remaining gas untouched) while Solidity uses an
420      * invalid opcode to revert (consuming all remaining gas).
421      *
422      * Requirements:
423      *
424      * - The divisor cannot be zero.
425      */
426     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
427         require(b != 0, errorMessage);
428         return a % b;
429     }
430 }