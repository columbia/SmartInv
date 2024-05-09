1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.6.0;
3 
4 // ----------------------------------------------------------------------------
5 // 'SWFL' Staking smart contract
6 // ----------------------------------------------------------------------------
7 
8 // ----------------------------------------------------------------------------
9 // SafeMath library
10 // ----------------------------------------------------------------------------
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
172 // ----------------------------------------------------------------------------
173 // Owned contract
174 // ----------------------------------------------------------------------------
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
195 // ----------------------------------------------------------------------------
196 // ERC Token Standard #20 Interface
197 // ----------------------------------------------------------------------------
198 interface IERC20 {
199     function totalSupply() external view returns (uint256);
200     function balanceOf(address tokenOwner) external view returns (uint256 balance);
201     function allowance(address tokenOwner, address spender) external view returns (uint256 remaining);
202     function transfer(address to, uint256 tokens) external returns (bool success);
203     function approve(address spender, uint256 tokens) external returns (bool success);
204     function transferFrom(address from, address to, uint256 tokens) external returns (bool success);
205     function burnTokens(uint256 _amount) external;
206     event Transfer(address indexed from, address indexed to, uint256 tokens);
207     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
208 }
209 
210 // ----------------------------------------------------------------------------
211 // ERC20 Token, with the addition of symbol, name and decimals and assisted
212 // token transfers
213 // ----------------------------------------------------------------------------
214 contract Stake is Owned {
215     using SafeMath for uint256;
216     
217     address public SWFL = 0xBa21Ef4c9f433Ede00badEFcC2754B8E74bd538A;
218     
219     uint256 public totalStakes = 0;
220     uint256 stakingFee = 25; // 2.5%
221     uint256 unstakingFee = 25; // 2.5% 
222     uint256 public totalDividends = 0;
223     uint256 private scaledRemainder = 0;
224     uint256 private scaling = uint256(10) ** 12;
225     uint public round = 1;
226     
227     struct USER{
228         uint256 stakedTokens;
229         uint256 lastDividends;
230         uint256 fromTotalDividend;
231         uint round;
232         uint256 remainder;
233     }
234     
235     mapping(address => USER) stakers;
236     mapping (uint => uint256) public payouts;                   // keeps record of each payout
237     
238     event STAKED(address staker, uint256 tokens, uint256 stakingFee);
239     event UNSTAKED(address staker, uint256 tokens, uint256 unstakingFee);
240     event PAYOUT(uint256 round, uint256 tokens, address sender);
241     event CLAIMEDREWARD(address staker, uint256 reward);
242     
243     // ------------------------------------------------------------------------
244     // Token holders can stake their tokens using this function
245     // @param tokens number of tokens to stake
246     // ------------------------------------------------------------------------
247     function STAKE(uint256 tokens) external {
248         require(IERC20(SWFL).transferFrom(msg.sender, address(this), tokens), "Tokens cannot be transferred from user account");
249         
250         uint256 _stakingFee = 0;
251         if(totalStakes > 0)
252             _stakingFee= (onePercent(tokens).mul(stakingFee)).div(10); 
253         
254         if(totalStakes > 0)
255             // distribute the staking fee accumulated before updating the user's stake
256             _addPayout(_stakingFee);
257             
258         // add pending rewards to remainder to be claimed by user later, if there is any existing stake
259         uint256 owing = pendingReward(msg.sender);
260         stakers[msg.sender].remainder += owing;
261         
262         stakers[msg.sender].stakedTokens = (tokens.sub(_stakingFee)).add(stakers[msg.sender].stakedTokens);
263         stakers[msg.sender].lastDividends = owing;
264         stakers[msg.sender].fromTotalDividend= totalDividends;
265         stakers[msg.sender].round =  round;
266         
267         totalStakes = totalStakes.add(tokens.sub(_stakingFee));
268         
269         emit STAKED(msg.sender, tokens.sub(_stakingFee), _stakingFee);
270     }
271     
272     // ------------------------------------------------------------------------
273     // Owners can send the funds to be distributed to stakers using this function
274     // @param tokens number of tokens to distribute
275     // ------------------------------------------------------------------------
276     function ADDFUNDS(uint256 tokens) external {
277         require(IERC20(SWFL).transferFrom(msg.sender, address(this), tokens), "Tokens cannot be transferred from funder account");
278         _addPayout(tokens);
279     }
280     
281     // ------------------------------------------------------------------------
282     // Private function to register payouts
283     // ------------------------------------------------------------------------
284     function _addPayout(uint256 tokens) private{
285         // divide the funds among the currently staked tokens
286         // scale the deposit and add the previous remainder
287         uint256 available = (tokens.mul(scaling)).add(scaledRemainder); 
288         uint256 dividendPerToken = available.div(totalStakes);
289         scaledRemainder = available.mod(totalStakes);
290         
291         totalDividends = totalDividends.add(dividendPerToken);
292         payouts[round] = payouts[round-1].add(dividendPerToken);
293         
294         emit PAYOUT(round, tokens, msg.sender);
295         round++;
296     }
297     
298     // ------------------------------------------------------------------------
299     // Stakers can claim their pending rewards using this function
300     // ------------------------------------------------------------------------
301     function CLAIMREWARD() public {
302         if(totalDividends > stakers[msg.sender].fromTotalDividend){
303             uint256 owing = pendingReward(msg.sender);
304         
305             owing = owing.add(stakers[msg.sender].remainder);
306             stakers[msg.sender].remainder = 0;
307         
308             require(IERC20(SWFL).transfer(msg.sender,owing), "ERROR: error in sending reward from contract");
309         
310             emit CLAIMEDREWARD(msg.sender, owing);
311         
312             stakers[msg.sender].lastDividends = owing; // unscaled
313             stakers[msg.sender].round = round; // update the round
314             stakers[msg.sender].fromTotalDividend = totalDividends; // scaled
315         }
316     }
317     
318     // ------------------------------------------------------------------------
319     // Get the pending rewards of the staker
320     // @param _staker the address of the staker
321     // ------------------------------------------------------------------------    
322     function pendingReward(address staker) private returns (uint256) {
323         uint256 amount =  ((totalDividends.sub(payouts[stakers[staker].round - 1])).mul(stakers[staker].stakedTokens)).div(scaling);
324         stakers[staker].remainder += ((totalDividends.sub(payouts[stakers[staker].round - 1])).mul(stakers[staker].stakedTokens)) % scaling ;
325         return amount;
326     }
327     
328     function getPendingReward(address staker) public view returns(uint256 _pendingReward) {
329         uint256 amount =  ((totalDividends.sub(payouts[stakers[staker].round - 1])).mul(stakers[staker].stakedTokens)).div(scaling);
330         amount += ((totalDividends.sub(payouts[stakers[staker].round - 1])).mul(stakers[staker].stakedTokens)) % scaling ;
331         return (amount + stakers[staker].remainder);
332     }
333     
334     // ------------------------------------------------------------------------
335     // Stakers can un stake the staked tokens using this function
336     // @param tokens the number of tokens to withdraw
337     // ------------------------------------------------------------------------
338     function WITHDRAW(uint256 tokens) external {
339         
340         require(stakers[msg.sender].stakedTokens >= tokens && tokens > 0, "Invalid token amount to withdraw");
341         
342         uint256 _unstakingFee = (onePercent(tokens).mul(unstakingFee)).div(10);
343         
344         // add pending rewards to remainder to be claimed by user later, if there is any existing stake
345         uint256 owing = pendingReward(msg.sender);
346         stakers[msg.sender].remainder += owing;
347                 
348         require(IERC20(SWFL).transfer(msg.sender, tokens.sub(_unstakingFee)), "Error in un-staking tokens");
349         
350         stakers[msg.sender].stakedTokens = stakers[msg.sender].stakedTokens.sub(tokens);
351         stakers[msg.sender].lastDividends = owing;
352         stakers[msg.sender].fromTotalDividend= totalDividends;
353         stakers[msg.sender].round =  round;
354         
355         totalStakes = totalStakes.sub(tokens);
356         
357         if(totalStakes > 0)
358             // distribute the un staking fee accumulated after updating the user's stake
359             _addPayout(_unstakingFee);
360         
361         emit UNSTAKED(msg.sender, tokens.sub(_unstakingFee), _unstakingFee);
362     }
363     
364     // ------------------------------------------------------------------------
365     // Private function to calculate 1% percentage
366     // ------------------------------------------------------------------------
367     function onePercent(uint256 _tokens) private pure returns (uint256){
368         uint256 roundValue = _tokens.ceil(100);
369         uint onePercentofTokens = roundValue.mul(100).div(100 * 10**uint(2));
370         return onePercentofTokens;
371     }
372     
373     // ------------------------------------------------------------------------
374     // Get the number of tokens staked by a staker
375     // @param _staker the address of the staker
376     // ------------------------------------------------------------------------
377     function yourStakedSWFL(address staker) external view returns(uint256 stakedSWFL){
378         return stakers[staker].stakedTokens;
379     }
380     
381     // ------------------------------------------------------------------------
382     // Get the SWFL balance of the token holder
383     // @param user the address of the token holder
384     // ------------------------------------------------------------------------
385     function yourSWFLBalance(address user) external view returns(uint256 SWFLBalance){
386         return IERC20(SWFL).balanceOf(user);
387     }
388 }