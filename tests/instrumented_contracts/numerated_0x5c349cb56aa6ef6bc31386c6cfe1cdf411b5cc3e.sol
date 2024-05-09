1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.6.0;
3 
4 /**
5  * Finswap(FNSP) Staking contract
6  */
7 
8 /**
9  * SafeMath library
10  */
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations with added overflow
14  * checks.
15  *
16  * Arithmetic operations in Solidity wrap on overflow. This can easily result
17  * in bugs, because programmers usually assume that an overflow raises an
18  * error, which is the standard behavior in high level programming languages.
19  * `SafeMath` restores this intuition by reverting the transaction when an
20  * operation overflows.
21  *
22  * Using this library instead of the unchecked operations eliminates an entire
23  * class of bugs, so it's recommended to use it always.
24  */
25 library SafeMath {
26     /**
27      * @dev Returns the addition of two unsigned integers, reverting on
28      * overflow.
29      *
30      * Counterpart to Solidity's `+` operator.
31      *
32      * Requirements:
33      *
34      * - Addition cannot overflow.
35      */
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         require(c >= a, "SafeMath: addition overflow");
39 
40         return c;
41     }
42 
43     /**
44      * @dev Returns the subtraction of two unsigned integers, reverting on
45      * overflow (when the result is negative).
46      *
47      * Counterpart to Solidity's `-` operator.
48      *
49      * Requirements:
50      *
51      * - Subtraction cannot overflow.
52      */
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         return sub(a, b, "SafeMath: subtraction overflow");
55     }
56 
57     /**
58      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
59      * overflow (when the result is negative).
60      *
61      * Counterpart to Solidity's `-` operator.
62      *
63      * Requirements:
64      *
65      * - Subtraction cannot overflow.
66      */
67     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b <= a, errorMessage);
69         uint256 c = a - b;
70 
71         return c;
72     }
73 
74     /**
75      * @dev Returns the multiplication of two unsigned integers, reverting on
76      * overflow.
77      *
78      * Counterpart to Solidity's `*` operator.
79      *
80      * Requirements:
81      *
82      * - Multiplication cannot overflow.
83      */
84     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
86         // benefit is lost if 'b' is also tested.
87         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
88         if (a == 0) {
89             return 0;
90         }
91 
92         uint256 c = a * b;
93         require(c / a == b, "SafeMath: multiplication overflow");
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the integer division of two unsigned integers. Reverts on
100      * division by zero. The result is rounded towards zero.
101      *
102      * Counterpart to Solidity's `/` operator. Note: this function uses a
103      * `revert` opcode (which leaves remaining gas untouched) while Solidity
104      * uses an invalid opcode to revert (consuming all remaining gas).
105      *
106      * Requirements:
107      *
108      * - The divisor cannot be zero.
109      */
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         return div(a, b, "SafeMath: division by zero");
112     }
113 
114     /**
115      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
116      * division by zero. The result is rounded towards zero.
117      *
118      * Counterpart to Solidity's `/` operator. Note: this function uses a
119      * `revert` opcode (which leaves remaining gas untouched) while Solidity
120      * uses an invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      *
124      * - The divisor cannot be zero.
125      */
126     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
127         require(b > 0, errorMessage);
128         uint256 c = a / b;
129         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
136      * Reverts when dividing by zero.
137      *
138      * Counterpart to Solidity's `%` operator. This function uses a `revert`
139      * opcode (which leaves remaining gas untouched) while Solidity uses an
140      * invalid opcode to revert (consuming all remaining gas).
141      *
142      * Requirements:
143      *
144      * - The divisor cannot be zero.
145      */
146     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
147         return mod(a, b, "SafeMath: modulo by zero");
148     }
149 
150     /**
151      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
152      * Reverts with custom message when dividing by zero.
153      *
154      * Counterpart to Solidity's `%` operator. This function uses a `revert`
155      * opcode (which leaves remaining gas untouched) while Solidity uses an
156      * invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      *
160      * - The divisor cannot be zero.
161      */
162     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
163         require(b != 0, errorMessage);
164         return a % b;
165     }
166     
167     function ceil(uint a, uint m) internal pure returns (uint r) {
168         return (a + m - 1) / m * m;
169     }
170 }
171 
172 /**
173  * Owned contract
174  */
175 contract Owned {
176     address payable public owner;
177 
178     event OwnershipTransferred(address indexed _from, address indexed _to);
179 
180     constructor() public {
181         owner = msg.sender;
182     }
183 
184     modifier onlyOwner {
185         require(msg.sender == owner);
186         _;
187     }
188 
189     function transferOwnership(address payable _newOwner) public onlyOwner {
190         owner = _newOwner;
191         emit OwnershipTransferred(msg.sender, _newOwner);
192     }
193 }
194 
195 /**
196  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
197  * the optional functions; to access them see `ERC20Detailed`.
198  */
199 interface IERC20 {
200     function totalSupply() external view returns (uint256);
201     function balanceOf(address tokenOwner) external view returns (uint256 balance);
202     function allowance(address tokenOwner, address spender) external view returns (uint256 remaining);
203     function transfer(address to, uint256 tokens) external returns (bool success);
204     function approve(address spender, uint256 tokens) external returns (bool success);
205     function transferFrom(address from, address to, uint256 tokens) external returns (bool success);
206     function burnTokens(uint256 _amount) external;
207     event Transfer(address indexed from, address indexed to, uint256 tokens);
208     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
209 }
210 
211 /**
212  * ERC20 Token, with the addition of symbol, name and decimals and assisted
213  * token transfers
214  */
215 
216 contract FNSPStake is Owned {
217     using SafeMath for uint256;
218     
219     // Contract address for FNSP mainnet token
220     address public FNSP = 0x3B78dc5736a49BD297Dd2E4d62daA83D35A22749;
221     
222     uint256 public totalStakes = 0;
223     uint256 stakingFee = 10; // 1%
224     uint256 unstakingFee = 30; // 3% 
225     uint256 public totalDividends = 0;
226     uint256 private scaledRemainder = 0;
227     uint256 private scaling = uint256(10) ** 12;
228     uint public round = 1;
229     
230     struct USER{
231         uint256 stakedTokens;
232         uint256 lastDividends;
233         uint256 fromTotalDividend;
234         uint round;
235         uint256 remainder;
236     }
237     
238     mapping(address => USER) stakers;
239     mapping (uint => uint256) public payouts; // keeps record of each payout
240     
241     event STAKED(address staker, uint256 tokens, uint256 stakingFee);
242     event UNSTAKED(address staker, uint256 tokens, uint256 unstakingFee);
243     event PAYOUT(uint256 round, uint256 tokens, address sender);
244     event CLAIMEDREWARD(address staker, uint256 reward);
245     
246     /**
247     * Token holders can stake their tokens using this function
248     * @param tokens number of tokens to stake
249     */
250     function STAKE(uint256 tokens) external {
251         require(IERC20(FNSP).transferFrom(msg.sender, address(this), tokens), "Tokens cannot be transferred from user account");
252         
253         uint256 _stakingFee = 0;
254         if(totalStakes > 0)
255             _stakingFee= (onePercent(tokens).mul(stakingFee)).div(10); 
256         
257         if(totalStakes > 0)
258             // distribute the staking fee accumulated before updating the user's stake
259             _addPayout(_stakingFee);
260             
261         // add pending rewards to remainder to be claimed by user later, if there is any existing stake
262         uint256 owing = pendingReward(msg.sender);
263         stakers[msg.sender].remainder += owing;
264         
265         stakers[msg.sender].stakedTokens = (tokens.sub(_stakingFee)).add(stakers[msg.sender].stakedTokens);
266         stakers[msg.sender].lastDividends = owing;
267         stakers[msg.sender].fromTotalDividend= totalDividends;
268         stakers[msg.sender].round =  round;
269         
270         totalStakes = totalStakes.add(tokens.sub(_stakingFee));
271         
272         emit STAKED(msg.sender, tokens.sub(_stakingFee), _stakingFee);
273     }
274     
275     /**
276     * Owners can send the funds to be distributed to stakers using this function
277     * @param tokens number of tokens to distribute
278     */
279     function ADDFUNDS(uint256 tokens) external {
280         require(IERC20(FNSP).transferFrom(msg.sender, address(this), tokens), "Tokens cannot be transferred from funder account");
281         _addPayout(tokens);
282     }
283     
284     
285     /**
286     * Private function to register payouts
287     */
288     function _addPayout(uint256 tokens) private{
289         // divide the funds among the currently staked tokens
290         // scale the deposit and add the previous remainder
291         uint256 available = (tokens.mul(scaling)).add(scaledRemainder); 
292         uint256 dividendPerToken = available.div(totalStakes);
293         scaledRemainder = available.mod(totalStakes);
294         
295         totalDividends = totalDividends.add(dividendPerToken);
296         payouts[round] = payouts[round-1].add(dividendPerToken);
297         
298         emit PAYOUT(round, tokens, msg.sender);
299         round++;
300     }
301     
302     /**
303     * Stakers can claim their pending rewards using this function
304     */
305     function CLAIMREWARD() public {
306         if(totalDividends > stakers[msg.sender].fromTotalDividend){
307             uint256 owing = pendingReward(msg.sender);
308         
309             owing = owing.add(stakers[msg.sender].remainder);
310             stakers[msg.sender].remainder = 0;
311         
312             require(IERC20(FNSP).transfer(msg.sender,owing), "ERROR: error in sending reward from contract");
313         
314             emit CLAIMEDREWARD(msg.sender, owing);
315         
316             stakers[msg.sender].lastDividends = owing; // unscaled
317             stakers[msg.sender].round = round; // update the round
318             stakers[msg.sender].fromTotalDividend = totalDividends; // scaled
319         }
320     }
321     
322 
323     /**
324     * Get the pending rewards of the staker
325     * @param staker the address of the staker
326     */ 
327     function pendingReward(address staker) private returns (uint256) {
328         uint256 amount =  ((totalDividends.sub(payouts[stakers[staker].round - 1])).mul(stakers[staker].stakedTokens)).div(scaling);
329         stakers[staker].remainder += ((totalDividends.sub(payouts[stakers[staker].round - 1])).mul(stakers[staker].stakedTokens)) % scaling ;
330         return amount;
331     }
332     
333     function getPendingReward(address staker) public view returns(uint256 _pendingReward) {
334         uint256 amount =  ((totalDividends.sub(payouts[stakers[staker].round - 1])).mul(stakers[staker].stakedTokens)).div(scaling);
335         amount += ((totalDividends.sub(payouts[stakers[staker].round - 1])).mul(stakers[staker].stakedTokens)) % scaling ;
336         return (amount + stakers[staker].remainder);
337     }
338     
339 
340     /**
341     * Stakers can un stake the staked tokens using this function
342     *  @param tokens the number of tokens to withdraw
343     */ 
344     function WITHDRAW(uint256 tokens) external {
345         
346         require(stakers[msg.sender].stakedTokens >= tokens && tokens > 0, "Invalid token amount to withdraw");
347         
348         uint256 _unstakingFee = (onePercent(tokens).mul(unstakingFee)).div(10);
349         
350         // add pending rewards to remainder to be claimed by user later, if there is any existing stake
351         uint256 owing = pendingReward(msg.sender);
352         stakers[msg.sender].remainder += owing;
353                 
354         require(IERC20(FNSP).transfer(msg.sender, tokens.sub(_unstakingFee)), "Error in un-staking tokens");
355         
356         stakers[msg.sender].stakedTokens = stakers[msg.sender].stakedTokens.sub(tokens);
357         stakers[msg.sender].lastDividends = owing;
358         stakers[msg.sender].fromTotalDividend= totalDividends;
359         stakers[msg.sender].round =  round;
360         
361         totalStakes = totalStakes.sub(tokens);
362         
363         if(totalStakes > 0)
364             // distribute the un staking fee accumulated after updating the user's stake
365             _addPayout(_unstakingFee);
366         
367         emit UNSTAKED(msg.sender, tokens.sub(_unstakingFee), _unstakingFee);
368     }
369     
370 
371     /**
372     * Private function to calculate 1% percent
373     *  @param _tokens the number of tokens to withdraw
374     */ 
375     function onePercent(uint256 _tokens) private pure returns (uint256){
376         uint256 roundValue = _tokens.ceil(100);
377         uint onePercentofTokens = roundValue.mul(100).div(100 * 10**uint(2));
378         return onePercentofTokens;
379     }
380     
381     /**
382     * Get the number of tokens staked by a staker
383     *  @param staker the address of the staker
384     */ 
385     function yourStakedFNSP(address staker) external view returns(uint256 stakedFNSP){
386         return stakers[staker].stakedTokens;
387     }
388     
389     /**
390     * Get the FNSP balance of the token holder
391     *  @param user the address of the token holder
392     */ 
393     function yourFNSPBalance(address user) external view returns(uint256 FNSPBalance){
394         return IERC20(FNSP).balanceOf(user);
395     }
396 }