1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.7.5;
3 
4 
5 
6 abstract contract ReentrancyGuard {
7 
8     uint256 private constant _NOT_ENTERED = 1;
9     uint256 private constant _ENTERED = 2;
10 
11     uint256 private _status;
12 
13     constructor () {
14         _status = _NOT_ENTERED;
15     }
16 
17     modifier nonReentrant() {
18 
19         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
20 
21         _status = _ENTERED;
22 
23         _;
24 
25         _status = _NOT_ENTERED;
26     }
27 }
28 
29 // ----------------------------------------------------------------------------
30 // SafeMath library
31 // ----------------------------------------------------------------------------
32 
33 
34 library SafeMath {
35     /**
36      * @dev Returns the addition of two unsigned integers, reverting on
37      * overflow.
38      *
39      * Counterpart to Solidity's `+` operator.
40      *
41      * Requirements:
42      *
43      * - Addition cannot overflow.
44      */
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a, "SafeMath: addition overflow");
48 
49         return c;
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         return sub(a, b, "SafeMath: subtraction overflow");
64     }
65 
66     /**
67      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
68      * overflow (when the result is negative).
69      *
70      * Counterpart to Solidity's `-` operator.
71      *
72      * Requirements:
73      *
74      * - Subtraction cannot overflow.
75      */
76     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b <= a, errorMessage);
78         uint256 c = a - b;
79 
80         return c;
81     }
82 
83     /**
84      * @dev Returns the multiplication of two unsigned integers, reverting on
85      * overflow.
86      *
87      * Counterpart to Solidity's `*` operator.
88      *
89      * Requirements:
90      *
91      * - Multiplication cannot overflow.
92      */
93     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
94         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
95         // benefit is lost if 'b' is also tested.
96         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
97         if (a == 0) {
98             return 0;
99         }
100 
101         uint256 c = a * b;
102         require(c / a == b, "SafeMath: multiplication overflow");
103 
104         return c;
105     }
106 
107     /**
108      * @dev Returns the integer division of two unsigned integers. Reverts on
109      * division by zero. The result is rounded towards zero.
110      *
111      * Counterpart to Solidity's `/` operator. Note: this function uses a
112      * `revert` opcode (which leaves remaining gas untouched) while Solidity
113      * uses an invalid opcode to revert (consuming all remaining gas).
114      *
115      * Requirements:
116      *
117      * - The divisor cannot be zero.
118      */
119     function div(uint256 a, uint256 b) internal pure returns (uint256) {
120         return div(a, b, "SafeMath: division by zero");
121     }
122 
123     /**
124      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
125      * division by zero. The result is rounded towards zero.
126      *
127      * Counterpart to Solidity's `/` operator. Note: this function uses a
128      * `revert` opcode (which leaves remaining gas untouched) while Solidity
129      * uses an invalid opcode to revert (consuming all remaining gas).
130      *
131      * Requirements:
132      *
133      * - The divisor cannot be zero.
134      */
135     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b > 0, errorMessage);
137         uint256 c = a / b;
138         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
156         return mod(a, b, "SafeMath: modulo by zero");
157     }
158 
159     /**
160      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
161      * Reverts with custom message when dividing by zero.
162      *
163      * Counterpart to Solidity's `%` operator. This function uses a `revert`
164      * opcode (which leaves remaining gas untouched) while Solidity uses an
165      * invalid opcode to revert (consuming all remaining gas).
166      *
167      * Requirements:
168      *
169      * - The divisor cannot be zero.
170      */
171     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172         require(b != 0, errorMessage);
173         return a % b;
174     }
175     
176     function ceil(uint a, uint m) internal pure returns (uint r) {
177         return (a + m - 1) / m * m;
178     }
179 }
180 
181 // ----------------------------------------------------------------------------
182 // Owned contract
183 // ----------------------------------------------------------------------------
184 contract Owned {
185     address payable public owner;
186 
187     event OwnershipTransferred(address indexed _from, address indexed _to);
188 
189     constructor() {
190         owner = msg.sender;
191     }
192 
193     modifier onlyOwner {
194         require(msg.sender == owner);
195         _;
196     }
197 
198     function transferOwnership(address payable _newOwner) public onlyOwner {
199         require(_newOwner != address(0), "ERC20: sending to the zero address");
200         owner = _newOwner;
201         emit OwnershipTransferred(msg.sender, _newOwner);
202     }
203 }
204 
205 // ----------------------------------------------------------------------------
206 // ERC Token Standard #20 Interface
207 // ----------------------------------------------------------------------------
208 interface IERC20 {
209     function totalSupply() external view returns (uint256);
210     function balanceOf(address tokenOwner) external view returns (uint256 balance);
211     function allowance(address tokenOwner, address spender) external view returns (uint256 remaining);
212     function transfer(address to, uint256 tokens) external returns (bool success);
213     function approve(address spender, uint256 tokens) external returns (bool success);
214     function transferFrom(address from, address to, uint256 tokens) external returns (bool success);
215     function burnTokens(uint256 _amount) external;
216     
217     function calculateFeesBeforeSend(
218         address sender,
219         address recipient,
220         uint256 amount
221     ) external view returns (uint256, uint256);
222     
223     
224     event Transfer(address indexed from, address indexed to, uint256 tokens);
225     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
226 }
227 
228 interface regreward {
229     function distributeAll() external;
230 }
231 
232 // ----------------------------------------------------------------------------
233 // ERC20 Token, with the addition of symbol, name and decimals and assisted
234 // token transfers
235 // ----------------------------------------------------------------------------
236 
237 library Roles {
238     struct Role {
239         mapping (address => bool) bearer;
240     }
241 
242     function add(Role storage role, address account) internal {
243         require(!has(role, account), "Roles: account already has role");
244         role.bearer[account] = true;
245     }
246 
247     function remove(Role storage role, address account) internal {
248         require(has(role, account), "Roles: account does not have role");
249         role.bearer[account] = false;
250     }
251 
252     function has(Role storage role, address account) internal view returns (bool) {
253         require(account != address(0), "Roles: account is the zero address");
254         return role.bearer[account];
255     }
256 }
257 
258 contract WhitelistAdminRole is Owned  {
259     using Roles for Roles.Role;
260 
261     event WhitelistAdminAdded(address indexed account);
262     event WhitelistAdminRemoved(address indexed account);
263 
264     Roles.Role private _whitelistAdmins;
265 
266    constructor () {
267         _addWhitelistAdmin(msg.sender);
268     }
269     
270     modifier onlyWhitelistAdmin() {
271         require(isWhitelistAdmin(msg.sender), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
272         _;
273     }
274 
275     function isWhitelistAdmin(address account) public view returns (bool) {
276         return _whitelistAdmins.has(account);
277     }
278     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
279         _addWhitelistAdmin(account);
280     }
281 
282     function renounceWhitelistAdmin() public {
283         _removeWhitelistAdmin(msg.sender);
284     }
285 
286     function _addWhitelistAdmin(address account) internal {
287         _whitelistAdmins.add(account);
288         emit WhitelistAdminAdded(account);
289     } 
290 
291     function _removeWhitelistAdmin(address account) internal {
292         _whitelistAdmins.remove(account);
293         emit WhitelistAdminRemoved(account);
294     }
295 }
296 contract stake$GOLD is Owned, ReentrancyGuard, WhitelistAdminRole {
297     using SafeMath for uint256;
298     
299     address public $GOLD   = 0xf1b8762a7fa8C244e36F7234EDF40cFaE24394e3;
300     address public fETH   = 0xf786c34106762Ab4Eeb45a51B42a62470E9D5332;
301     address public regrewardContract;
302     
303     uint256 public totalStakes = 0;
304     bool public perform = false; //if true then distribution of rewards from the pool to stakers via the withdraw function is enabled
305     uint256 public txFee = 0; // $GOLD has 2% TX fee, deduct this fee from total stake to not break math
306     uint256 public txFee1 = 11; // fETH has 1% TX fee, 0.1% was also added this fee from total stake to not break math
307     
308     uint256 public totalDividends = 0;
309     uint256 private scaledRemainder = 0;
310     uint256 private scaling = uint256(10) ** 12;
311     uint public round = 1;
312  
313     mapping(address => uint) public farmTime; // period that your sake it locked to keep it for farming
314     uint public lock = 0; // no locktime
315     
316     struct USER{
317         uint256 stakedTokens;
318         uint256 lastDividends;
319         uint256 fromTotalDividend;
320         uint round;
321         uint256 remainder;
322     }
323     
324     address[] internal stakeholders;
325     mapping(address => USER) stakers;
326     mapping (uint => uint256) public payouts;                   // keeps record of each payout
327     
328     event STAKED(address staker, uint256 tokens);
329     event EARNED(address staker, uint256 tokens);
330     event UNSTAKED(address staker, uint256 tokens);
331     event PAYOUT(uint256 round, uint256 tokens, address sender);
332     event CLAIMEDREWARD(address staker, uint256 reward);
333     
334     
335     function isStakeholder(address _address)
336        public
337        view
338        returns(bool)
339    {
340        for (uint256 s = 0; s < stakeholders.length; s += 1){
341            if (_address == stakeholders[s]) return (true);
342        }
343        return (false);
344    }
345    
346    function addStakeholder(address _stakeholder)
347        public
348    {
349        (bool _isStakeholder) = isStakeholder(_stakeholder);
350        if(!_isStakeholder) {
351            stakeholders.push(_stakeholder);
352            farmTime[msg.sender] =  block.timestamp;
353        }
354    }
355    
356    // ------------------------------------------------------------------------
357     // Token holders can stake their tokens using this function
358     // @param tokens number of tokens to stake
359     // ------------------------------------------------------------------------
360     function STAKE(uint256 tokens) external nonReentrant { 
361         require(IERC20($GOLD).transferFrom(msg.sender, address(this), tokens), "Tokens cannot be transferred from user for locking");
362         
363             uint256 transferTxFee = (onePercent(tokens).mul(txFee)).div(10);
364             uint256 tokensToStake = (tokens.sub(transferTxFee));
365         
366             
367             // add pending rewards to remainder to be claimed by user later, if there is any existing stake
368             uint256 owing = pendingReward(msg.sender);
369             stakers[msg.sender].remainder += owing;
370             
371             stakers[msg.sender].stakedTokens = tokensToStake.add(stakers[msg.sender].stakedTokens);
372             stakers[msg.sender].lastDividends = owing;
373             stakers[msg.sender].fromTotalDividend= totalDividends;
374             stakers[msg.sender].round =  round;
375             
376             
377             totalStakes = totalStakes.add(tokensToStake);
378             
379             addStakeholder(msg.sender);
380             
381             emit STAKED(msg.sender, tokens);
382         
383     }
384     
385     // ------------------------------------------------------------------------
386     // Owners can send the funds to be distributed to stakers using this function
387     // @param tokens number of tokens to distribute
388     // ------------------------------------------------------------------------
389     function ADDFUNDS(uint256 tokens) external onlyWhitelistAdmin{ //can only be called by regrewardContract
390         uint256 transferTxFee = (onePercent(tokens).mul(txFee1)).div(10);
391         uint256 tokens_ = (tokens.sub(transferTxFee));
392         
393         _addPayout(tokens_);
394     }
395     
396     function ADDFUNDS1(uint256 tokens) external{
397         require(IERC20(fETH).transferFrom(msg.sender, address(this), tokens), "Tokens cannot be transferred from funder account");
398         uint256 transferTxFee = (onePercent(tokens).mul(txFee1)).div(10);
399         uint256 tokens_ = (tokens.sub(transferTxFee));
400         
401         _addPayout(tokens_);
402     }
403     
404     
405     
406     
407     function DisributeTxFunds() external { // Distribute tx fees collected for conversion into rewards
408         
409         uint256 transferToAmount = (IERC20($GOLD).balanceOf(address(this))).sub(totalStakes);
410         require(IERC20($GOLD).transfer(address(owner), transferToAmount), "Error in un-staking tokens");
411     }
412     
413     
414     // ------------------------------------------------------------------------
415     // Private function to register payouts
416     // ------------------------------------------------------------------------
417     function _addPayout(uint256 tokens_) private{
418         // divide the funds among the currently staked tokens
419         // scale the deposit and add the previous remainder
420         uint256 available = (tokens_.mul(scaling)).add(scaledRemainder); 
421         uint256 dividendPerToken = available.div(totalStakes);
422         scaledRemainder = available.mod(totalStakes);
423         
424         totalDividends = totalDividends.add(dividendPerToken);
425         payouts[round] = payouts[round - 1].add(dividendPerToken);
426         
427         emit PAYOUT(round, tokens_, msg.sender);
428         round++;
429     }
430     
431     // ------------------------------------------------------------------------
432     // Stakers can claim their pending rewards using this function
433     // ------------------------------------------------------------------------
434     function CLAIMREWARD() public nonReentrant{
435         
436         if(totalDividends > stakers[msg.sender].fromTotalDividend){
437             uint256 owing = pendingReward(msg.sender);
438         
439             owing = owing.add(stakers[msg.sender].remainder);
440             stakers[msg.sender].remainder = 0;
441         
442             require(IERC20(fETH).transfer(msg.sender,owing), "ERROR: error in sending reward from contract");
443         
444             emit CLAIMEDREWARD(msg.sender, owing);
445         
446             stakers[msg.sender].lastDividends = owing; // unscaled
447             stakers[msg.sender].round = round; // update the round
448             stakers[msg.sender].fromTotalDividend = totalDividends; // scaled
449         }
450     }
451     
452     // ------------------------------------------------------------------------
453     // Get the pending rewards of the staker
454     // @param _staker the address of the staker
455     // ------------------------------------------------------------------------    
456     function pendingReward(address staker) private returns (uint256) {
457         require(staker != address(0), "ERC20: sending to the zero address");
458         
459         uint stakersRound = stakers[staker].round;
460         uint256 amount =  ((totalDividends.sub(payouts[stakersRound - 1])).mul(stakers[staker].stakedTokens)).div(scaling);
461         stakers[staker].remainder += ((totalDividends.sub(payouts[stakersRound - 1])).mul(stakers[staker].stakedTokens)) % scaling ;
462         return amount;
463     }
464     
465     function getPendingReward(address staker) public view returns(uint256 _pendingReward) {
466         require(staker != address(0), "ERC20: sending to the zero address");
467          uint stakersRound = stakers[staker].round;
468          
469         uint256 amount =  ((totalDividends.sub(payouts[stakersRound - 1])).mul(stakers[staker].stakedTokens)).div(scaling);
470         amount += ((totalDividends.sub(payouts[stakersRound - 1])).mul(stakers[staker].stakedTokens)) % scaling ;
471         return (amount.add(stakers[staker].remainder));
472     }
473     
474     // ------------------------------------------------------------------------
475     // Stakers can un stake the staked tokens using this function
476     // @param tokens the number of tokens to withdraw
477     // ------------------------------------------------------------------------
478     function WITHDRAW(uint256 tokens) external nonReentrant{
479         require(stakers[msg.sender].stakedTokens >= tokens && tokens > 0, "Invalid token amount to withdraw");
480         
481         totalStakes = totalStakes.sub(tokens);
482         
483         // add pending rewards to remainder to be claimed by user later, if there is any existing stake
484         uint256 owing = pendingReward(msg.sender);
485         stakers[msg.sender].remainder += owing;
486                 
487         stakers[msg.sender].stakedTokens = stakers[msg.sender].stakedTokens.sub(tokens);
488         stakers[msg.sender].lastDividends = owing;
489         stakers[msg.sender].fromTotalDividend= totalDividends;
490         stakers[msg.sender].round =  round;
491         
492         
493         require(IERC20($GOLD).transfer(msg.sender, tokens), "Error in un-staking tokens");
494         emit UNSTAKED(msg.sender, tokens);
495         
496         if(perform==true) {
497         regreward(regrewardContract).distributeAll();
498         }
499     }
500     
501     // ------------------------------------------------------------------------
502     // Private function to calculate 1% percentage
503     // ------------------------------------------------------------------------
504     function onePercent(uint256 _tokens) private pure returns (uint256){
505         uint256 roundValue = _tokens.ceil(100);
506         uint onePercentofTokens = roundValue.mul(100).div(100 * 10**uint(2));
507         return onePercentofTokens;
508     }
509     
510     // ------------------------------------------------------------------------
511     // Get the number of tokens staked by a staker
512     // @param _staker the address of the staker
513     // ------------------------------------------------------------------------
514     function yourStaked$GOLD(address staker) public view returns(uint256 staked$GOLD){
515         require(staker != address(0), "ERC20: sending to the zero address");
516         
517         return stakers[staker].stakedTokens;
518     }
519     
520     // ------------------------------------------------------------------------
521     // Get the $GOLD balance of the token holder
522     // @param user the address of the token holder
523     // ------------------------------------------------------------------------
524     function your$GOLDBalance(address user) external view returns(uint256 $GOLDBalance){
525         require(user != address(0), "ERC20: sending to the zero address");
526         return IERC20($GOLD).balanceOf(user);
527     }
528     
529     function emergencySaveLostTokens(address _token) public onlyOwner {
530         require(IERC20(_token).transfer(owner, IERC20(_token).balanceOf(address(this))), "Error in retrieving tokens");
531         owner.transfer(address(this).balance);
532     }
533     
534     function changeregrewardContract(address _regrewardContract) external onlyOwner{
535         require(address(_regrewardContract) != address(0), "setting 0 to contract");
536         regrewardContract = _regrewardContract;
537     }
538    
539    function changePerform(bool _bool) external onlyOwner{
540         perform = _bool;
541     }
542 }