1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.7.4;
3 
4 // ----------------------------------------------------------------------------
5 // 'Hype.Bet' Staking smart contract. 
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
180     constructor() {
181         owner = msg.sender;
182     }
183 
184     modifier onlyOwner {
185         require(msg.sender == owner);
186         _;
187     }
188 
189     function transferOwnership(address payable _newOwner) public onlyOwner {
190         require(_newOwner != address(0), "ERC20: sending to the zero address");
191         owner = _newOwner;
192         emit OwnershipTransferred(msg.sender, _newOwner);
193     }
194 }
195 
196 // ----------------------------------------------------------------------------
197 // ERC Token Standard #20 Interface
198 // ----------------------------------------------------------------------------
199 interface IERC20 {
200     function totalSupply() external view returns (uint256);
201     function balanceOf(address tokenOwner) external view returns (uint256 balance);
202     function allowance(address tokenOwner, address spender) external view returns (uint256 remaining);
203     function transfer(address to, uint256 tokens) external returns (bool success);
204     function approve(address spender, uint256 tokens) external returns (bool success);
205     function transferFrom(address from, address to, uint256 tokens) external returns (bool success);
206     function burnTokens(uint256 _amount) external;
207     function calculateAmountsAfterFee(
208         address sender,
209         address recipient,
210         uint256 amount
211     ) external view returns (uint256 transferToAmount, uint256 transferToFeeDistributorAmount, uint256 transferToOwnerFeeDistributorAmount);
212     event Transfer(address indexed from, address indexed to, uint256 tokens);
213     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
214 }
215 
216 // ----------------------------------------------------------------------------
217 // ERC20 Token, with the addition of symbol, name and decimals and assisted
218 // token transfers
219 // ----------------------------------------------------------------------------
220 contract HypeBet_Stake is Owned {
221     using SafeMath for uint256;
222     
223     address public Hype_Bet = 0xc9Dfcd0A1dD2D7BB6Fd2EF91A16a6a1c4E9846Dd;
224     
225     uint256 public totalStakes = 0;
226     uint256 public totalDividends = 0;
227     uint256 private scaledRemainder = 0;
228     uint256 private scaling = uint256(10) ** 12;
229     uint public round = 1;
230     uint256 public maxAllowed = 100000000000000000000000; //100000 tokens total allowed to be staked
231     
232     /* Fees breaker, to protect withdraws if anything ever goes wrong */
233     bool public breaker = false; // withdraw can be lock,, default unlocked
234     mapping(address => uint) public farmLock; // period that your sake it locked to keep it for farming
235     //uint public lock = 0; // farm lock in blocks ~ 0 days for 15s/block
236     //address public admin;
237     
238     struct USER{
239         uint256 stakedTokens;
240         uint256 lastDividends;
241         uint256 fromTotalDividend;
242         uint round;
243         uint256 remainder;
244     }
245     
246         address[] internal stakeholders;
247     mapping(address => USER) stakers;
248     mapping (uint => uint256) public payouts;                   // keeps record of each payout
249     
250     event STAKED(address staker, uint256 tokens);
251     event EARNED(address staker, uint256 tokens);
252     event UNSTAKED(address staker, uint256 tokens);
253     event PAYOUT(uint256 round, uint256 tokens, address sender);
254     event CLAIMEDREWARD(address staker, uint256 reward);
255     event WithdrawalLockDurationSet(uint256 value, address sender);
256     
257     function setBreaker(bool _breaker) external onlyOwner {
258         breaker = _breaker;
259     }
260     
261     
262     function isStakeholder(address _address)
263        public
264        view
265        returns(bool)
266    {
267        for (uint256 s = 0; s < stakeholders.length; s += 1){
268            if (_address == stakeholders[s]) return (true);
269        }
270        return (false);
271    }
272    
273    function addStakeholder(address _stakeholder)
274        public
275    {
276        (bool _isStakeholder) = isStakeholder(_stakeholder);
277        if(!_isStakeholder) stakeholders.push(_stakeholder);
278    }
279    
280 
281 
282     // ------------------------------------------------------------------------
283     // Token holders can stake their tokens using this function
284     // @param tokens number of tokens to stake
285     // ------------------------------------------------------------------------
286     function STAKE(uint256 tokens) external {
287         require(totalStakes <= maxAllowed, "Max Stake amount exceed");
288         require(IERC20(Hype_Bet).transferFrom(msg.sender, address(this), tokens), "Tokens cannot be transferred from user account");
289         
290         (uint256 transferToAmount,,) = IERC20(Hype_Bet).calculateAmountsAfterFee(msg.sender, address(this), tokens);
291         
292             
293             // add pending rewards to remainder to be claimed by user later, if there is any existing stake
294             uint256 owing = pendingReward(msg.sender);
295             stakers[msg.sender].remainder += owing;
296             
297             stakers[msg.sender].stakedTokens = transferToAmount.add(stakers[msg.sender].stakedTokens);
298             stakers[msg.sender].lastDividends = owing;
299             stakers[msg.sender].fromTotalDividend= totalDividends;
300             stakers[msg.sender].round =  round;
301             
302             (bool _isStakeholder) = isStakeholder(msg.sender);
303              if(!_isStakeholder) farmLock[msg.sender] =  block.timestamp;
304             
305             
306             totalStakes = totalStakes.add(transferToAmount);
307             
308             addStakeholder(msg.sender);
309             
310             emit STAKED(msg.sender, transferToAmount);
311         
312     }
313     
314     // ------------------------------------------------------------------------
315     // Owners can send the funds to be distributed to stakers using this function
316     // @param tokens number of tokens to distribute
317     // ------------------------------------------------------------------------
318     function ADDFUNDS(uint256 tokens) external {
319         
320         require(IERC20(Hype_Bet).transferFrom(msg.sender, address(this), tokens), "Tokens cannot be transferred from funder account");
321         (uint256 transferToAmount,,) = IERC20(Hype_Bet).calculateAmountsAfterFee(msg.sender, address(this), tokens);
322         _addPayout(transferToAmount);
323     }
324     
325     // ------------------------------------------------------------------------
326     // Private function to register payouts
327     // ------------------------------------------------------------------------
328     function _addPayout(uint256 tokens) private{
329         // divide the funds among the currently staked tokens
330         // scale the deposit and add the previous remainder
331         uint256 available = (tokens.mul(scaling)).add(scaledRemainder); 
332         uint256 dividendPerToken = available.div(totalStakes);
333         scaledRemainder = available.mod(totalStakes);
334         
335         totalDividends = totalDividends.add(dividendPerToken);
336         payouts[round] = payouts[round - 1].add(dividendPerToken);
337         
338         emit PAYOUT(round, tokens, msg.sender);
339         round++;
340     }
341     
342     // ------------------------------------------------------------------------
343     // Stakers can claim their pending rewards using this function
344     // ------------------------------------------------------------------------
345     function CLAIMREWARD() public {
346         
347         if(totalDividends > stakers[msg.sender].fromTotalDividend){
348             uint256 owing = pendingReward(msg.sender);
349         
350             owing = owing.add(stakers[msg.sender].remainder);
351             stakers[msg.sender].remainder = 0;
352         
353             require(IERC20(Hype_Bet).transfer(msg.sender,owing), "ERROR: error in sending reward from contract");
354         
355             emit CLAIMEDREWARD(msg.sender, owing);
356         
357             stakers[msg.sender].lastDividends = owing; // unscaled
358             stakers[msg.sender].round = round; // update the round
359             stakers[msg.sender].fromTotalDividend = totalDividends; // scaled
360         }
361     }
362     
363     // ------------------------------------------------------------------------
364     // Get the pending rewards of the staker
365     // @param _staker the address of the staker
366     // ------------------------------------------------------------------------    
367     function pendingReward(address staker) private returns (uint256) {
368         require(staker != address(0), "ERC20: sending to the zero address");
369         
370         uint stakersRound = stakers[staker].round;
371         uint256 amount =  ((totalDividends.sub(payouts[stakersRound - 1])).mul(stakers[staker].stakedTokens)).div(scaling);
372         stakers[staker].remainder += ((totalDividends.sub(payouts[stakersRound - 1])).mul(stakers[staker].stakedTokens)) % scaling ;
373         return amount;
374     }
375     
376     function getPendingReward(address staker) public view returns(uint256 _pendingReward) {
377         require(staker != address(0), "ERC20: sending to the zero address");
378          uint stakersRound = stakers[staker].round;
379          
380         uint256 amount =  ((totalDividends.sub(payouts[stakersRound - 1])).mul(stakers[staker].stakedTokens)).div(scaling);
381         amount += ((totalDividends.sub(payouts[stakersRound - 1])).mul(stakers[staker].stakedTokens)) % scaling ;
382         return (amount.add(stakers[staker].remainder));
383     }
384     
385     // ------------------------------------------------------------------------
386     // Stakers can un stake the staked tokens using this function
387     // @param tokens the number of tokens to withdraw
388     // ------------------------------------------------------------------------
389     function WITHDRAW(uint256 tokens) external {
390         require(breaker == false, "Admin Restricted WITHDRAW");
391         require(stakers[msg.sender].stakedTokens >= tokens && tokens > 0, "Invalid token amount to withdraw");
392         
393         totalStakes = totalStakes.sub(tokens);
394         
395         // add pending rewards to remainder to be claimed by user later, if there is any existing stake
396         uint256 owing = pendingReward(msg.sender);
397         stakers[msg.sender].remainder += owing;
398                 
399         stakers[msg.sender].stakedTokens = stakers[msg.sender].stakedTokens.sub(tokens);
400         stakers[msg.sender].lastDividends = owing;
401         stakers[msg.sender].fromTotalDividend= totalDividends;
402         stakers[msg.sender].round =  round;
403         
404         
405         require(IERC20(Hype_Bet).transfer(msg.sender, tokens), "Error in un-staking tokens");
406         emit UNSTAKED(msg.sender, tokens);
407     }
408     
409     // ------------------------------------------------------------------------
410     // Private function to calculate 1% percentage
411     // ------------------------------------------------------------------------
412     function onePercent(uint256 _tokens) private pure returns (uint256){
413         uint256 roundValue = _tokens.ceil(100);
414         uint onePercentofTokens = roundValue.mul(100).div(100 * 10**uint(2));
415         return onePercentofTokens;
416     }
417     
418     // ------------------------------------------------------------------------
419     // Get the number of tokens staked by a staker
420     // @param _staker the address of the staker
421     // ------------------------------------------------------------------------
422     function yourStakedHype_Bet(address staker) public view returns(uint256 stakedHype_Bet){
423         require(staker != address(0), "ERC20: sending to the zero address");
424         
425         return stakers[staker].stakedTokens;
426     }
427     
428     // ------------------------------------------------------------------------
429     // Get the Hype_Bet balance of the token holder
430     // @param user the address of the token holder
431     // ------------------------------------------------------------------------
432     function yourHype_BetBalance(address user) external view returns(uint256 Hype_BetBalance){
433         require(user != address(0), "ERC20: sending to the zero address");
434         return IERC20(Hype_Bet).balanceOf(user);
435     }
436     
437    
438 }