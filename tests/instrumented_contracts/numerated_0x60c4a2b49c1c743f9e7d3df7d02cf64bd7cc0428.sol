1 /**
2  *Submitted for verification at BscScan.com on 2021-04-14
3 */
4 
5 // SPDX-License-Identifier: UNLICENSED
6 pragma solidity 0.7.5;
7 
8 
9 
10 abstract contract ReentrancyGuard {
11 
12     uint256 private constant _NOT_ENTERED = 1;
13     uint256 private constant _ENTERED = 2;
14 
15     uint256 private _status;
16 
17     constructor () {
18         _status = _NOT_ENTERED;
19     }
20 
21     modifier nonReentrant() {
22 
23         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
24 
25         _status = _ENTERED;
26 
27         _;
28 
29         _status = _NOT_ENTERED;
30     }
31 }
32 
33 // ----------------------------------------------------------------------------
34 // SafeMath library
35 // ----------------------------------------------------------------------------
36 
37 
38 library SafeMath {
39     /**
40      * @dev Returns the addition of two unsigned integers, reverting on
41      * overflow.
42      *
43      * Counterpart to Solidity's `+` operator.
44      *
45      * Requirements:
46      *
47      * - Addition cannot overflow.
48      */
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a, "SafeMath: addition overflow");
52 
53         return c;
54     }
55 
56     /**
57      * @dev Returns the subtraction of two unsigned integers, reverting on
58      * overflow (when the result is negative).
59      *
60      * Counterpart to Solidity's `-` operator.
61      *
62      * Requirements:
63      *
64      * - Subtraction cannot overflow.
65      */
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         return sub(a, b, "SafeMath: subtraction overflow");
68     }
69 
70     /**
71      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
72      * overflow (when the result is negative).
73      *
74      * Counterpart to Solidity's `-` operator.
75      *
76      * Requirements:
77      *
78      * - Subtraction cannot overflow.
79      */
80     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
81         require(b <= a, errorMessage);
82         uint256 c = a - b;
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the multiplication of two unsigned integers, reverting on
89      * overflow.
90      *
91      * Counterpart to Solidity's `*` operator.
92      *
93      * Requirements:
94      *
95      * - Multiplication cannot overflow.
96      */
97     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
98         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
99         // benefit is lost if 'b' is also tested.
100         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
101         if (a == 0) {
102             return 0;
103         }
104 
105         uint256 c = a * b;
106         require(c / a == b, "SafeMath: multiplication overflow");
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the integer division of two unsigned integers. Reverts on
113      * division by zero. The result is rounded towards zero.
114      *
115      * Counterpart to Solidity's `/` operator. Note: this function uses a
116      * `revert` opcode (which leaves remaining gas untouched) while Solidity
117      * uses an invalid opcode to revert (consuming all remaining gas).
118      *
119      * Requirements:
120      *
121      * - The divisor cannot be zero.
122      */
123     function div(uint256 a, uint256 b) internal pure returns (uint256) {
124         return div(a, b, "SafeMath: division by zero");
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator. Note: this function uses a
132      * `revert` opcode (which leaves remaining gas untouched) while Solidity
133      * uses an invalid opcode to revert (consuming all remaining gas).
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b > 0, errorMessage);
141         uint256 c = a / b;
142         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
149      * Reverts when dividing by zero.
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
160         return mod(a, b, "SafeMath: modulo by zero");
161     }
162 
163     /**
164      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
165      * Reverts with custom message when dividing by zero.
166      *
167      * Counterpart to Solidity's `%` operator. This function uses a `revert`
168      * opcode (which leaves remaining gas untouched) while Solidity uses an
169      * invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      *
173      * - The divisor cannot be zero.
174      */
175     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
176         require(b != 0, errorMessage);
177         return a % b;
178     }
179     
180     function ceil(uint a, uint m) internal pure returns (uint r) {
181         return (a + m - 1) / m * m;
182     }
183 }
184 
185 // ----------------------------------------------------------------------------
186 // Owned contract
187 // ----------------------------------------------------------------------------
188 contract Owned {
189     address payable public owner;
190 
191     event OwnershipTransferred(address indexed _from, address indexed _to);
192 
193     constructor() {
194         owner = msg.sender;
195     }
196 
197     modifier onlyOwner {
198         require(msg.sender == owner);
199         _;
200     }
201 
202     function transferOwnership(address payable _newOwner) public onlyOwner {
203         require(_newOwner != address(0), "ERC20: sending to the zero address");
204         owner = _newOwner;
205         emit OwnershipTransferred(msg.sender, _newOwner);
206     }
207 }
208 
209 // ----------------------------------------------------------------------------
210 // ERC Token Standard #20 Interface
211 // ----------------------------------------------------------------------------
212 interface IERC20 {
213     function totalSupply() external view returns (uint256);
214     function balanceOf(address tokenOwner) external view returns (uint256 balance);
215     function allowance(address tokenOwner, address spender) external view returns (uint256 remaining);
216     function transfer(address to, uint256 tokens) external returns (bool success);
217     function approve(address spender, uint256 tokens) external returns (bool success);
218     function transferFrom(address from, address to, uint256 tokens) external returns (bool success);
219     function burnTokens(uint256 _amount) external;
220     
221     function calculateFeesBeforeSend(
222         address sender,
223         address recipient,
224         uint256 amount
225     ) external view returns (uint256, uint256);
226     
227     
228     event Transfer(address indexed from, address indexed to, uint256 tokens);
229     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
230 }
231 
232 interface regreward {
233     function distributeAll() external;
234 }
235 
236 // ----------------------------------------------------------------------------
237 // ERC20 Token, with the addition of symbol, name and decimals and assisted
238 // token transfers
239 // ----------------------------------------------------------------------------
240 
241 library Roles {
242     struct Role {
243         mapping (address => bool) bearer;
244     }
245 
246     function add(Role storage role, address account) internal {
247         require(!has(role, account), "Roles: account already has role");
248         role.bearer[account] = true;
249     }
250 
251     function remove(Role storage role, address account) internal {
252         require(has(role, account), "Roles: account does not have role");
253         role.bearer[account] = false;
254     }
255 
256     function has(Role storage role, address account) internal view returns (bool) {
257         require(account != address(0), "Roles: account is the zero address");
258         return role.bearer[account];
259     }
260 }
261 
262 contract WhitelistAdminRole is Owned  {
263     using Roles for Roles.Role;
264 
265     event WhitelistAdminAdded(address indexed account);
266     event WhitelistAdminRemoved(address indexed account);
267 
268     Roles.Role private _whitelistAdmins;
269 
270    constructor () {
271         _addWhitelistAdmin(msg.sender);
272     }
273     
274     modifier onlyWhitelistAdmin() {
275         require(isWhitelistAdmin(msg.sender), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
276         _;
277     }
278 
279     function isWhitelistAdmin(address account) public view returns (bool) {
280         return _whitelistAdmins.has(account);
281     }
282     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
283         _addWhitelistAdmin(account);
284     }
285 
286     function renounceWhitelistAdmin() public {
287         _removeWhitelistAdmin(msg.sender);
288     }
289 
290     function _addWhitelistAdmin(address account) internal {
291         _whitelistAdmins.add(account);
292         emit WhitelistAdminAdded(account);
293     } 
294 
295     function _removeWhitelistAdmin(address account) internal {
296         _whitelistAdmins.remove(account);
297         emit WhitelistAdminRemoved(account);
298     }
299 }
300 contract FEGstakeTRYe is Owned, ReentrancyGuard, WhitelistAdminRole {
301     using SafeMath for uint256;
302     
303     address public TRY   = 0xc12eCeE46ed65D970EE5C899FCC7AE133AfF9b03;
304     address public fETH   = 0xf786c34106762Ab4Eeb45a51B42a62470E9D5332;
305     address public regrewardContract;
306     
307     uint256 public totalStakes = 0;
308     bool public perform = true; //if true then distribution of rewards from the pool to stakers via the withdraw function is enabled
309     uint256 public txFee = 20; // TRY has 2% TX fee, deduct this fee from total stake to not break math
310     uint256 public txFee1 = 11; // fETH has 1% TX fee, 0.1% was also added this fee from total stake to not break math
311     
312     uint256 public totalDividends = 0;
313     uint256 private scaledRemainder = 0;
314     uint256 private scaling = uint256(10) ** 12;
315     uint public round = 1;
316  
317     mapping(address => uint) public farmTime; // period that your sake it locked to keep it for farming
318     uint public lock = 0; // no locktime
319     
320     struct USER{
321         uint256 stakedTokens;
322         uint256 lastDividends;
323         uint256 fromTotalDividend;
324         uint round;
325         uint256 remainder;
326     }
327     
328     address[] internal stakeholders;
329     mapping(address => USER) stakers;
330     mapping (uint => uint256) public payouts;                   // keeps record of each payout
331     
332     event STAKED(address staker, uint256 tokens);
333     event EARNED(address staker, uint256 tokens);
334     event UNSTAKED(address staker, uint256 tokens);
335     event PAYOUT(uint256 round, uint256 tokens, address sender);
336     event CLAIMEDREWARD(address staker, uint256 reward);
337     
338     
339     function isStakeholder(address _address)
340        public
341        view
342        returns(bool)
343    {
344        for (uint256 s = 0; s < stakeholders.length; s += 1){
345            if (_address == stakeholders[s]) return (true);
346        }
347        return (false);
348    }
349    
350    function addStakeholder(address _stakeholder)
351        public
352    {
353        (bool _isStakeholder) = isStakeholder(_stakeholder);
354        if(!_isStakeholder) {
355            stakeholders.push(_stakeholder);
356            farmTime[msg.sender] =  block.timestamp;
357        }
358    }
359    
360    // ------------------------------------------------------------------------
361     // Token holders can stake their tokens using this function
362     // @param tokens number of tokens to stake
363     // ------------------------------------------------------------------------
364     function STAKE(uint256 tokens) external nonReentrant { 
365         require(IERC20(TRY).transferFrom(msg.sender, address(this), tokens), "Tokens cannot be transferred from user for locking");
366         
367             uint256 transferTxFee = (onePercent(tokens).mul(txFee)).div(10);
368             uint256 tokensToStake = (tokens.sub(transferTxFee));
369         
370             
371             // add pending rewards to remainder to be claimed by user later, if there is any existing stake
372             uint256 owing = pendingReward(msg.sender);
373             stakers[msg.sender].remainder += owing;
374             
375             stakers[msg.sender].stakedTokens = tokensToStake.add(stakers[msg.sender].stakedTokens);
376             stakers[msg.sender].lastDividends = owing;
377             stakers[msg.sender].fromTotalDividend= totalDividends;
378             stakers[msg.sender].round =  round;
379             
380             
381             totalStakes = totalStakes.add(tokensToStake);
382             
383             addStakeholder(msg.sender);
384             
385             emit STAKED(msg.sender, tokens);
386         
387     }
388     
389     // ------------------------------------------------------------------------
390     // Owners can send the funds to be distributed to stakers using this function
391     // @param tokens number of tokens to distribute
392     // ------------------------------------------------------------------------
393     function ADDFUNDS(uint256 tokens) external onlyWhitelistAdmin{ //can only be called by regrewardContract
394         uint256 transferTxFee = (onePercent(tokens).mul(txFee1)).div(10);
395         uint256 tokens_ = (tokens.sub(transferTxFee));
396         
397         _addPayout(tokens_);
398     }
399     
400     function ADDFUNDS1(uint256 tokens) external{
401         require(IERC20(fETH).transferFrom(msg.sender, address(this), tokens), "Tokens cannot be transferred from funder account");
402         uint256 transferTxFee = (onePercent(tokens).mul(txFee1)).div(10);
403         uint256 tokens_ = (tokens.sub(transferTxFee));
404         
405         _addPayout(tokens_);
406     }
407     
408     
409     
410     
411     function DisributeTxFunds() external { // Distribute tx fees collected for conversion into rewards
412         
413         uint256 transferToAmount = (IERC20(TRY).balanceOf(address(this))).sub(totalStakes);
414         require(IERC20(TRY).transfer(address(owner), transferToAmount), "Error in un-staking tokens");
415     }
416     
417     
418     // ------------------------------------------------------------------------
419     // Private function to register payouts
420     // ------------------------------------------------------------------------
421     function _addPayout(uint256 tokens_) private{
422         // divide the funds among the currently staked tokens
423         // scale the deposit and add the previous remainder
424         uint256 available = (tokens_.mul(scaling)).add(scaledRemainder); 
425         uint256 dividendPerToken = available.div(totalStakes);
426         scaledRemainder = available.mod(totalStakes);
427         
428         totalDividends = totalDividends.add(dividendPerToken);
429         payouts[round] = payouts[round - 1].add(dividendPerToken);
430         
431         emit PAYOUT(round, tokens_, msg.sender);
432         round++;
433     }
434     
435     // ------------------------------------------------------------------------
436     // Stakers can claim their pending rewards using this function
437     // ------------------------------------------------------------------------
438     function CLAIMREWARD() public nonReentrant{
439         
440         if(totalDividends > stakers[msg.sender].fromTotalDividend){
441             uint256 owing = pendingReward(msg.sender);
442         
443             owing = owing.add(stakers[msg.sender].remainder);
444             stakers[msg.sender].remainder = 0;
445         
446             require(IERC20(fETH).transfer(msg.sender,owing), "ERROR: error in sending reward from contract");
447         
448             emit CLAIMEDREWARD(msg.sender, owing);
449         
450             stakers[msg.sender].lastDividends = owing; // unscaled
451             stakers[msg.sender].round = round; // update the round
452             stakers[msg.sender].fromTotalDividend = totalDividends; // scaled
453         }
454     }
455     
456     // ------------------------------------------------------------------------
457     // Get the pending rewards of the staker
458     // @param _staker the address of the staker
459     // ------------------------------------------------------------------------    
460     function pendingReward(address staker) private returns (uint256) {
461         require(staker != address(0), "ERC20: sending to the zero address");
462         
463         uint stakersRound = stakers[staker].round;
464         uint256 amount =  ((totalDividends.sub(payouts[stakersRound - 1])).mul(stakers[staker].stakedTokens)).div(scaling);
465         stakers[staker].remainder += ((totalDividends.sub(payouts[stakersRound - 1])).mul(stakers[staker].stakedTokens)) % scaling ;
466         return amount;
467     }
468     
469     function getPendingReward(address staker) public view returns(uint256 _pendingReward) {
470         require(staker != address(0), "ERC20: sending to the zero address");
471          uint stakersRound = stakers[staker].round;
472          
473         uint256 amount =  ((totalDividends.sub(payouts[stakersRound - 1])).mul(stakers[staker].stakedTokens)).div(scaling);
474         amount += ((totalDividends.sub(payouts[stakersRound - 1])).mul(stakers[staker].stakedTokens)) % scaling ;
475         return (amount.add(stakers[staker].remainder));
476     }
477     
478     // ------------------------------------------------------------------------
479     // Stakers can un stake the staked tokens using this function
480     // @param tokens the number of tokens to withdraw
481     // ------------------------------------------------------------------------
482     function WITHDRAW(uint256 tokens) external nonReentrant{
483         require(stakers[msg.sender].stakedTokens >= tokens && tokens > 0, "Invalid token amount to withdraw");
484         
485         totalStakes = totalStakes.sub(tokens);
486         
487         // add pending rewards to remainder to be claimed by user later, if there is any existing stake
488         uint256 owing = pendingReward(msg.sender);
489         stakers[msg.sender].remainder += owing;
490                 
491         stakers[msg.sender].stakedTokens = stakers[msg.sender].stakedTokens.sub(tokens);
492         stakers[msg.sender].lastDividends = owing;
493         stakers[msg.sender].fromTotalDividend= totalDividends;
494         stakers[msg.sender].round =  round;
495         
496         
497         require(IERC20(TRY).transfer(msg.sender, tokens), "Error in un-staking tokens");
498         emit UNSTAKED(msg.sender, tokens);
499         
500         if(perform==true) {
501         regreward(regrewardContract).distributeAll();
502         }
503     }
504     
505     // ------------------------------------------------------------------------
506     // Private function to calculate 1% percentage
507     // ------------------------------------------------------------------------
508     function onePercent(uint256 _tokens) private pure returns (uint256){
509         uint256 roundValue = _tokens.ceil(100);
510         uint onePercentofTokens = roundValue.mul(100).div(100 * 10**uint(2));
511         return onePercentofTokens;
512     }
513     
514     // ------------------------------------------------------------------------
515     // Get the number of tokens staked by a staker
516     // @param _staker the address of the staker
517     // ------------------------------------------------------------------------
518     function yourStakedTRY(address staker) public view returns(uint256 stakedTRY){
519         require(staker != address(0), "ERC20: sending to the zero address");
520         
521         return stakers[staker].stakedTokens;
522     }
523     
524     // ------------------------------------------------------------------------
525     // Get the TRY balance of the token holder
526     // @param user the address of the token holder
527     // ------------------------------------------------------------------------
528     function yourTRYBalance(address user) external view returns(uint256 TRYBalance){
529         require(user != address(0), "ERC20: sending to the zero address");
530         return IERC20(TRY).balanceOf(user);
531     }
532     
533     function emergencySaveLostTokens(address _token) public onlyOwner {
534         require(IERC20(_token).transfer(owner, IERC20(_token).balanceOf(address(this))), "Error in retrieving tokens");
535         owner.transfer(address(this).balance);
536     }
537     
538     function changeregrewardContract(address _regrewardContract) external onlyOwner{
539         require(address(_regrewardContract) != address(0), "setting 0 to contract");
540         regrewardContract = _regrewardContract;
541     }
542    
543    function changePerform(bool _bool) external onlyOwner{
544         perform = _bool;
545     }
546 }