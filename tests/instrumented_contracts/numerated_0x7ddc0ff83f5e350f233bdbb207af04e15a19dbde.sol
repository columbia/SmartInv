1 /** HYPE FINANCE STAKING POOL NUMBER 2 
2 * 2000 TOKEN LIMIT 
3 * 30 DAYS LOCKED PERIOD 
4 * APY REFRESH EVERY WEEK 
5 * PAYMENT OF DIVIDENDS EVERY SUNDAY 11:59PM EASTERN TIME 
6 * HYPE FINANCE 50 THOUSAND US DOLLARS BONUS POOL 
7 */
8 // SPDX-License-Identifier: UNLICENSED
9 pragma solidity ^0.7.4;
10 
11 // ----------------------------------------------------------------------------
12 // 'Hype' Staking smart contract. 2% deposit and withdrawal fees are rewarded to all staking members based on their staking amount.
13 // ----------------------------------------------------------------------------
14 
15 // ----------------------------------------------------------------------------
16 // SafeMath library
17 // ----------------------------------------------------------------------------
18 
19 /**
20  * @dev Wrappers over Solidity's arithmetic operations with added overflow
21  * checks.
22  *
23  * Arithmetic operations in Solidity wrap on overflow. This can easily result
24  * in bugs, because programmers usually assume that an overflow raises an
25  * error, which is the standard behavior in high level programming languages.
26  * `SafeMath` restores this intuition by reverting the transaction when an
27  * operation overflows.
28  *
29  * Using this library instead of the unchecked operations eliminates an entire
30  * class of bugs, so it's recommended to use it always.
31  */
32 library SafeMath {
33     /**
34      * @dev Returns the addition of two unsigned integers, reverting on
35      * overflow.
36      *
37      * Counterpart to Solidity's `+` operator.
38      *
39      * Requirements:
40      *
41      * - Addition cannot overflow.
42      */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a, "SafeMath: addition overflow");
46 
47         return c;
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      *
58      * - Subtraction cannot overflow.
59      */
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         return sub(a, b, "SafeMath: subtraction overflow");
62     }
63 
64     /**
65      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
66      * overflow (when the result is negative).
67      *
68      * Counterpart to Solidity's `-` operator.
69      *
70      * Requirements:
71      *
72      * - Subtraction cannot overflow.
73      */
74     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
75         require(b <= a, errorMessage);
76         uint256 c = a - b;
77 
78         return c;
79     }
80 
81     /**
82      * @dev Returns the multiplication of two unsigned integers, reverting on
83      * overflow.
84      *
85      * Counterpart to Solidity's `*` operator.
86      *
87      * Requirements:
88      *
89      * - Multiplication cannot overflow.
90      */
91     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
92         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
93         // benefit is lost if 'b' is also tested.
94         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
95         if (a == 0) {
96             return 0;
97         }
98 
99         uint256 c = a * b;
100         require(c / a == b, "SafeMath: multiplication overflow");
101 
102         return c;
103     }
104 
105     /**
106      * @dev Returns the integer division of two unsigned integers. Reverts on
107      * division by zero. The result is rounded towards zero.
108      *
109      * Counterpart to Solidity's `/` operator. Note: this function uses a
110      * `revert` opcode (which leaves remaining gas untouched) while Solidity
111      * uses an invalid opcode to revert (consuming all remaining gas).
112      *
113      * Requirements:
114      *
115      * - The divisor cannot be zero.
116      */
117     function div(uint256 a, uint256 b) internal pure returns (uint256) {
118         return div(a, b, "SafeMath: division by zero");
119     }
120 
121     /**
122      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
123      * division by zero. The result is rounded towards zero.
124      *
125      * Counterpart to Solidity's `/` operator. Note: this function uses a
126      * `revert` opcode (which leaves remaining gas untouched) while Solidity
127      * uses an invalid opcode to revert (consuming all remaining gas).
128      *
129      * Requirements:
130      *
131      * - The divisor cannot be zero.
132      */
133     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134         require(b > 0, errorMessage);
135         uint256 c = a / b;
136         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return mod(a, b, "SafeMath: modulo by zero");
155     }
156 
157     /**
158      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
159      * Reverts with custom message when dividing by zero.
160      *
161      * Counterpart to Solidity's `%` operator. This function uses a `revert`
162      * opcode (which leaves remaining gas untouched) while Solidity uses an
163      * invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      *
167      * - The divisor cannot be zero.
168      */
169     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b != 0, errorMessage);
171         return a % b;
172     }
173     
174     function ceil(uint a, uint m) internal pure returns (uint r) {
175         return (a + m - 1) / m * m;
176     }
177 }
178 
179 // ----------------------------------------------------------------------------
180 // Owned contract
181 // ----------------------------------------------------------------------------
182 contract Owned {
183     address payable public owner;
184 
185     event OwnershipTransferred(address indexed _from, address indexed _to);
186 
187     constructor() {
188         owner = msg.sender;
189     }
190 
191     modifier onlyOwner {
192         require(msg.sender == owner);
193         _;
194     }
195 
196     function transferOwnership(address payable _newOwner) public onlyOwner {
197         require(_newOwner != address(0), "ERC20: sending to the zero address");
198         owner = _newOwner;
199         emit OwnershipTransferred(msg.sender, _newOwner);
200     }
201 }
202 
203 // ----------------------------------------------------------------------------
204 // ERC Token Standard #20 Interface
205 // ----------------------------------------------------------------------------
206 interface IERC20 {
207     function totalSupply() external view returns (uint256);
208     function balanceOf(address tokenOwner) external view returns (uint256 balance);
209     function allowance(address tokenOwner, address spender) external view returns (uint256 remaining);
210     function transfer(address to, uint256 tokens) external returns (bool success);
211     function approve(address spender, uint256 tokens) external returns (bool success);
212     function transferFrom(address from, address to, uint256 tokens) external returns (bool success);
213     function transferFromStake(address from, address to, uint256 tokens) external returns (bool success);
214     function burnTokens(uint256 _amount) external;
215     event Transfer(address indexed from, address indexed to, uint256 tokens);
216     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
217 }
218 
219 // ----------------------------------------------------------------------------
220 // ERC20 Token, with the addition of symbol, name and decimals and assisted
221 // token transfers
222 // ----------------------------------------------------------------------------
223 contract HypeStake is Owned {
224     using SafeMath for uint256;
225     
226     address public Hype = 0x610c67be018A5C5bdC70ACd8DC19688A11421073;
227     address rewardMaker = 0x181b3a5c476fEecC97Cf7f31Ea51093f324B726f;
228     
229     uint256 public totalStakes = 0;
230     uint256 stakingFee = 20; // 2%
231     uint256 unstakingFee = 20; // 20% 
232     uint256 public totalDividends = 0;
233     uint256 private scaledRemainder = 0;
234     uint256 private scaling = uint256(10) ** 12;
235     uint public round = 1;
236     uint256 public maxAllowed = 2000000000000000000000; //2000 tokens total allowed to be staked
237     uint public blockPerDay = 6539;
238     uint public locktime = 1 * blockPerDay; //1days lock to test
239     
240     /* Fees breaker, to protect withdraws if anything ever goes wrong */
241     bool public breaker = false; // withdraw can be lock,, default unlocked
242     mapping(address => uint) public farmLock; // period that your sake it locked to keep it for farming
243     //uint public lock = 0; // farm lock in blocks ~ 0 days for 15s/block
244     //address public admin;
245     
246     struct USER{
247         uint256 stakedTokens;
248         uint256 lastDividends;
249         uint256 fromTotalDividend;
250         uint round;
251         uint256 remainder;
252     }
253     
254         address[] internal stakeholders;
255     mapping(address => USER) stakers;
256     mapping (uint => uint256) public payouts;                   // keeps record of each payout
257     
258     event STAKED(address staker, uint256 tokens, uint256 stakingFee);
259     event EARNED(address staker, uint256 tokens);
260     event UNSTAKED(address staker, uint256 tokens, uint256 unstakingFee);
261     event PAYOUT(uint256 round, uint256 tokens, address sender);
262     event CLAIMEDREWARD(address staker, uint256 reward);
263     event WithdrawalLockDurationSet(uint256 value, address sender);
264     
265     function setBreaker(bool _breaker) external onlyOwner {
266         //require(msg.sender == admin, "admin only");
267         breaker = _breaker;
268     }
269     
270     
271    
272     function calculateReward(address _stakeholder)
273         public
274         view
275         returns(uint256)
276     {
277         uint256 bal = yourStakedHype(_stakeholder);
278         return bal.div(totalStakes);
279     }
280 
281 
282     function distributeRewards(uint256 tokens)
283         public
284     {
285         require(msg.sender == address(rewardMaker), "ERC20: You'r not allowed to use this function");
286         require(IERC20(Hype).transferFromStake(msg.sender, address(this), tokens), "Tokens cannot be transferred from funder account");
287         
288         _addPayout(tokens);
289         
290         
291     }
292     
293     function isStakeholder(address _address)
294        public
295        view
296        returns(bool)
297    {
298        for (uint256 s = 0; s < stakeholders.length; s += 1){
299            if (_address == stakeholders[s]) return (true);
300        }
301        return (false);
302    }
303    
304    function addStakeholder(address _stakeholder)
305        public
306    {
307        (bool _isStakeholder) = isStakeholder(_stakeholder);
308        if(!_isStakeholder) stakeholders.push(_stakeholder);
309    }
310    
311 
312 
313     // ------------------------------------------------------------------------
314     // Token holders can stake their tokens using this function
315     // @param tokens number of tokens to stake
316     // ------------------------------------------------------------------------
317     function STAKE(uint256 tokens) external {
318         require(totalStakes <= maxAllowed, "Total Stakes amount exceed");
319         require(IERC20(Hype).transferFromStake(msg.sender, address(this), tokens), "Tokens cannot be transferred from user account");
320         
321         
322             uint256 _stakingFee = 0;
323             if(totalStakes > 0)
324                 _stakingFee= (onePercent(tokens).mul(stakingFee)).div(10); 
325             
326             if(totalStakes > 0)
327                 // distribute the staking fee accumulated before updating the user's stake
328                 _addPayout(_stakingFee);
329                 
330             // add pending rewards to remainder to be claimed by user later, if there is any existing stake
331             uint256 owing = pendingReward(msg.sender);
332             stakers[msg.sender].remainder += owing;
333             
334             stakers[msg.sender].stakedTokens = (tokens.sub(_stakingFee)).add(stakers[msg.sender].stakedTokens);
335             stakers[msg.sender].lastDividends = owing;
336             stakers[msg.sender].fromTotalDividend= totalDividends;
337             stakers[msg.sender].round =  round;
338             
339             (bool _isStakeholder) = isStakeholder(msg.sender);
340              if(!_isStakeholder) farmLock[msg.sender] =  block.timestamp;
341             
342             
343             totalStakes = totalStakes.add(tokens.sub(_stakingFee));
344             
345             addStakeholder(msg.sender);
346             
347             emit STAKED(msg.sender, tokens.sub(_stakingFee), _stakingFee);
348         
349     }
350     
351     
352     function calculateExitBlock(address _staker) public view returns (uint256){
353         require(_staker != address(0), "ERC20: sending to the zero address");
354         
355        // uint enterBlock = farmLock[msg.sender];
356         //uint exitBlock = enterBlock.add(locktime)
357         
358         return farmLock[msg.sender];
359     }
360     
361     // ------------------------------------------------------------------------
362     // Owners can send the funds to be distributed to stakers using this function
363     // @param tokens number of tokens to distribute
364     // ------------------------------------------------------------------------
365     function ADDFUNDS(uint256 tokens) external {
366         
367         require(IERC20(Hype).transferFromStake(msg.sender, address(this), tokens), "Tokens cannot be transferred from funder account");
368         _addPayout(tokens);
369     }
370     
371     // ------------------------------------------------------------------------
372     // Private function to register payouts
373     // ------------------------------------------------------------------------
374     function _addPayout(uint256 tokens) private{
375         // divide the funds among the currently staked tokens
376         // scale the deposit and add the previous remainder
377         uint256 available = (tokens.mul(scaling)).add(scaledRemainder); 
378         uint256 dividendPerToken = available.div(totalStakes);
379         scaledRemainder = available.mod(totalStakes);
380         
381         totalDividends = totalDividends.add(dividendPerToken);
382         payouts[round] = payouts[round - 1].add(dividendPerToken);
383         
384         emit PAYOUT(round, tokens, msg.sender);
385         round++;
386     }
387     
388     // ------------------------------------------------------------------------
389     // Stakers can claim their pending rewards using this function
390     // ------------------------------------------------------------------------
391     function CLAIMREWARD() public {
392         
393         if(totalDividends > stakers[msg.sender].fromTotalDividend){
394             uint256 owing = pendingReward(msg.sender);
395         
396             owing = owing.add(stakers[msg.sender].remainder);
397             stakers[msg.sender].remainder = 0;
398         
399             require(IERC20(Hype).transfer(msg.sender,owing), "ERROR: error in sending reward from contract");
400         
401             emit CLAIMEDREWARD(msg.sender, owing);
402         
403             stakers[msg.sender].lastDividends = owing; // unscaled
404             stakers[msg.sender].round = round; // update the round
405             stakers[msg.sender].fromTotalDividend = totalDividends; // scaled
406         }
407     }
408     
409     // ------------------------------------------------------------------------
410     // Get the pending rewards of the staker
411     // @param _staker the address of the staker
412     // ------------------------------------------------------------------------    
413     function pendingReward(address staker) private returns (uint256) {
414         require(staker != address(0), "ERC20: sending to the zero address");
415         
416         uint stakersRound = stakers[staker].round;
417         uint256 amount =  ((totalDividends.sub(payouts[stakersRound - 1])).mul(stakers[staker].stakedTokens)).div(scaling);
418         stakers[staker].remainder += ((totalDividends.sub(payouts[stakersRound - 1])).mul(stakers[staker].stakedTokens)) % scaling ;
419         return amount;
420     }
421     
422     function getPendingReward(address staker) public view returns(uint256 _pendingReward) {
423         require(staker != address(0), "ERC20: sending to the zero address");
424          uint stakersRound = stakers[staker].round;
425          
426         uint256 amount =  ((totalDividends.sub(payouts[stakersRound - 1])).mul(stakers[staker].stakedTokens)).div(scaling);
427         amount += ((totalDividends.sub(payouts[stakersRound - 1])).mul(stakers[staker].stakedTokens)) % scaling ;
428         return (amount.add(stakers[staker].remainder));
429     }
430     
431     // ------------------------------------------------------------------------
432     // Stakers can un stake the staked tokens using this function
433     // @param tokens the number of tokens to withdraw
434     // ------------------------------------------------------------------------
435     function WITHDRAW(uint256 tokens) external {
436         require(breaker == false, "Admin Restricted WITHDRAW");
437         require(stakers[msg.sender].stakedTokens >= tokens && tokens > 0, "Invalid token amount to withdraw");
438         
439         //uint exitBlock = calculateExitBlock(msg.sender);
440         require(farmLock[msg.sender]+30 days <= block.timestamp, "Withdraw can only be done after 30 days");
441         
442         
443         uint256 _unstakingFee = (onePercent(tokens).mul(unstakingFee)).div(10);
444         
445         // add pending rewards to remainder to be claimed by user later, if there is any existing stake
446         uint256 owing = pendingReward(msg.sender);
447         stakers[msg.sender].remainder += owing;
448                 
449         require(IERC20(Hype).transfer(msg.sender, tokens.sub(_unstakingFee)), "Error in un-staking tokens");
450         
451         stakers[msg.sender].stakedTokens = stakers[msg.sender].stakedTokens.sub(tokens);
452         stakers[msg.sender].lastDividends = owing;
453         stakers[msg.sender].fromTotalDividend= totalDividends;
454         stakers[msg.sender].round =  round;
455         
456         totalStakes = totalStakes.sub(tokens);
457         
458         if(totalStakes > 0)
459             // distribute the un staking fee accumulated after updating the user's stake
460             _addPayout(_unstakingFee);
461         
462         emit UNSTAKED(msg.sender, tokens.sub(_unstakingFee), _unstakingFee);
463     }
464     
465     // ------------------------------------------------------------------------
466     // Private function to calculate 1% percentage
467     // ------------------------------------------------------------------------
468     function onePercent(uint256 _tokens) private pure returns (uint256){
469         uint256 roundValue = _tokens.ceil(100);
470         uint onePercentofTokens = roundValue.mul(100).div(100 * 10**uint(2));
471         return onePercentofTokens;
472     }
473     
474     // ------------------------------------------------------------------------
475     // Get the number of tokens staked by a staker
476     // @param _staker the address of the staker
477     // ------------------------------------------------------------------------
478     function yourStakedHype(address staker) public view returns(uint256 stakedHype){
479         require(staker != address(0), "ERC20: sending to the zero address");
480         
481         return stakers[staker].stakedTokens;
482     }
483     
484     // ------------------------------------------------------------------------
485     // Get the Hype balance of the token holder
486     // @param user the address of the token holder
487     // ------------------------------------------------------------------------
488     function yourHypeBalance(address user) external view returns(uint256 HypeBalance){
489         require(user != address(0), "ERC20: sending to the zero address");
490         return IERC20(Hype).balanceOf(user);
491     }
492     
493    
494 }