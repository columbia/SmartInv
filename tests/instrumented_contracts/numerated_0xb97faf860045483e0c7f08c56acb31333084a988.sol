1 pragma solidity ^0.6.0;
2 // SPDX-License-Identifier: UNLICENSED
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      *
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      *
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      *
57      * - Subtraction cannot overflow.
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      *
74      * - Multiplication cannot overflow.
75      */
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
78         // benefit is lost if 'b' is also tested.
79         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
80         if (a == 0) {
81             return 0;
82         }
83 
84         uint256 c = a * b;
85         require(c / a == b, "SafeMath: multiplication overflow");
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the integer division of two unsigned integers. Reverts on
92      * division by zero. The result is rounded towards zero.
93      *
94      * Counterpart to Solidity's `/` operator. Note: this function uses a
95      * `revert` opcode (which leaves remaining gas untouched) while Solidity
96      * uses an invalid opcode to revert (consuming all remaining gas).
97      *
98      * Requirements:
99      *
100      * - The divisor cannot be zero.
101      */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105 
106     /**
107      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
108      * division by zero. The result is rounded towards zero.
109      *
110      * Counterpart to Solidity's `/` operator. Note: this function uses a
111      * `revert` opcode (which leaves remaining gas untouched) while Solidity
112      * uses an invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      *
116      * - The divisor cannot be zero.
117      */
118     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         return mod(a, b, "SafeMath: modulo by zero");
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts with custom message when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158     
159     function ceil(uint256 a, uint256 m) internal pure returns (uint256 r) {
160         require(m != 0, "SafeMath: to ceil number shall not be zero");
161         return (a + m - 1) / m * m;
162     }
163 }
164 
165 
166 // ----------------------------------------------------------------------------
167 // ERC Token Standard #20 Interface
168 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
169 // ----------------------------------------------------------------------------
170 /**
171  * @dev Interface of the ERC20 standard as defined in the EIP.
172  */
173 interface IERC20 {
174     /**
175      * @dev Returns the amount of tokens in existence.
176      */
177     function totalSupply() external view returns (uint256);
178 
179     /**
180      * @dev Returns the amount of tokens owned by `account`.
181      */
182     function balanceOf(address account) external view returns (uint256);
183 
184     /**
185      * @dev Moves `amount` tokens from the caller's account to `recipient`.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * Emits a {Transfer} event.
190      */
191     function transfer(address recipient, uint256 amount) external returns (bool);
192 
193     /**
194      * @dev Returns the remaining number of tokens that `spender` will be
195      * allowed to spend on behalf of `owner` through {transferFrom}. This is
196      * zero by default.
197      *
198      * This value changes when {approve} or {transferFrom} are called.
199      */
200     function allowance(address owner, address spender) external view returns (uint256);
201 
202     /**
203      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
204      *
205      * Returns a boolean value indicating whether the operation succeeded.
206      *
207      * IMPORTANT: Beware that changing an allowance with this method brings the risk
208      * that someone may use both the old and the new allowance by unfortunate
209      * transaction ordering. One possible solution to mitigate this race
210      * condition is to first reduce the spender's allowance to 0 and set the
211      * desired value afterwards:
212      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
213      *
214      * Emits an {Approval} event.
215      */
216     function approve(address spender, uint256 amount) external returns (bool);
217 
218     /**
219      * @dev Moves `amount` tokens from `sender` to `recipient` using the
220      * allowance mechanism. `amount` is then deducted from the caller's
221      * allowance.
222      *
223      * Returns a boolean value indicating whether the operation succeeded.
224      *
225      * Emits a {Transfer} event.
226      */
227     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
228 
229     /**
230      * @dev Emitted when `value` tokens are moved from one account (`from`) to
231      * another (`to`).
232      *
233      * Note that `value` may be zero.
234      */
235     event Transfer(address indexed from, address indexed to, uint256 value);
236 
237     /**
238      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
239      * a call to {approve}. `value` is the new allowance.
240      */
241     event Approval(address indexed owner, address indexed spender, uint256 value);
242 }
243 
244 // ----------------------------------------------------------------------------
245 // Owned contract
246 // ----------------------------------------------------------------------------
247 contract Owned {
248     address payable public owner;
249 
250     event OwnershipTransferred(address indexed _from, address indexed _to);
251 
252     constructor() public {
253         owner = msg.sender;
254     }
255 
256     modifier onlyOwner {
257         require(msg.sender == owner);
258         _;
259     }
260 
261     function transferOwnership(address payable _newOwner) public onlyOwner {
262         owner = _newOwner;
263         emit OwnershipTransferred(msg.sender, _newOwner);
264     }
265 }
266 
267 // ----------------------------------------------------------------------------
268 // 'VANILLA' token AND staking contract
269 
270 // Symbol      : VNLA
271 // Name        : Vanilla Network
272 // Total supply: 1,000,000 (1 million)
273 // Min supply  : 100k 
274 // Decimals    : 18
275 
276 
277 // ----------------------------------------------------------------------------
278 // ERC20 Token, with the addition of symbol, name and decimals and assisted
279 // token transfers
280 // ----------------------------------------------------------------------------
281 contract Vanilla is IERC20, Owned {
282     using SafeMath for uint256;
283    
284     string public symbol = "VNLA";
285     string public  name = "Vanilla Network";
286     uint256 public decimals = 18;
287     address airdropContract;
288     uint256 _totalSupply = 98447685 * 10 ** (16); // 984,476.85 
289     
290     mapping(address => uint256) balances;
291     mapping(address => mapping(address => uint256)) allowed;
292    
293     // ------------------------------------------------------------------------
294     // Constructor
295     // ------------------------------------------------------------------------
296     constructor(address icoContract, address _airdropContract) public {
297         airdropContract = _airdropContract;
298         owner = 0xFa50b82cbf2942008A097B6289F39b1bb797C5Cd;
299         
300         balances[icoContract] =  150000 * 10 ** (18); // 150,000
301         emit Transfer(address(0), icoContract, 150000 * 10 ** (18));
302         
303         balances[address(owner)] =   54195664  * 10 ** (16); // 541,956.64
304         emit Transfer(address(0), address(owner), 54195664  * 10 ** (16));
305         
306         balances[address(airdropContract)] =   2925202086 * 10 ** (14); // 292520.2086
307         emit Transfer(address(0), address(airdropContract), 2925202086 * 10 ** (14));
308     }
309 
310    
311     /** ERC20Interface function's implementation **/
312    
313     function totalSupply() external override view returns (uint256){
314        return _totalSupply;
315     }
316    
317     // ------------------------------------------------------------------------
318     // Get the token balance for account `tokenOwner`
319     // ------------------------------------------------------------------------
320     function balanceOf(address tokenOwner) external override view returns (uint256 balance) {
321         return balances[tokenOwner];
322     }
323     
324     // ------------------------------------------------------------------------
325     // Token owner can approve for `spender` to transferFrom(...) `tokens`
326     // from the token owner's account
327     // ------------------------------------------------------------------------
328     function approve(address spender, uint256 tokens) external override returns (bool success){
329         allowed[msg.sender][spender] = tokens;
330         emit Approval(msg.sender,spender,tokens);
331         return true;
332     }
333     
334     // ------------------------------------------------------------------------
335     // Returns the amount of tokens approved by the owner that can be
336     // transferred to the spender's account
337     // ------------------------------------------------------------------------
338     function allowance(address tokenOwner, address spender) external override view returns (uint256 remaining) {
339         return allowed[tokenOwner][spender];
340     }
341 
342     // ------------------------------------------------------------------------
343     // Transfer the balance from token owner's account to `to` account
344     // - Owner's account must have sufficient balance to transfer
345     // - 0 value transfers are allowed
346     // ------------------------------------------------------------------------
347     function transfer(address to, uint256 tokens) public override returns (bool success) {
348         // prevent transfer to 0x0, use burn instead
349         require(address(to) != address(0));
350         require(balances[msg.sender] >= tokens );
351         require(balances[to] + tokens >= balances[to]);
352         
353         balances[msg.sender] = balances[msg.sender].sub(tokens);
354         
355         uint256 deduction = deductionsToApply(tokens);
356         applyDeductions(deduction);
357         
358         balances[to] = balances[to].add(tokens.sub(deduction));
359         emit Transfer(msg.sender, to, tokens.sub(deduction));
360         return true;
361     }
362     
363     // ------------------------------------------------------------------------
364     // Transfer `tokens` from the `from` account to the `to` account
365     //
366     // The calling account must already have sufficient tokens approve(...)-d
367     // for spending from the `from` account and
368     // - From account must have sufficient balance to transfer
369     // - Spender must have sufficient allowance to transfer
370     // - 0 value transfers are allowed
371     // ------------------------------------------------------------------------
372     function transferFrom(address from, address to, uint256 tokens) external override returns (bool success){
373         require(tokens <= allowed[from][msg.sender]); //check allowance
374         require(balances[from] >= tokens);
375         balances[from] = balances[from].sub(tokens);
376         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
377       
378         uint256 deduction = deductionsToApply(tokens);
379         applyDeductions(deduction);
380        
381         balances[to] = balances[to].add(tokens.sub(deduction));
382         emit Transfer(from, to, tokens.sub(tokens));
383         return true;
384     }
385     
386     function _transfer(address to, uint256 tokens, bool rewards) internal returns(bool){
387         // prevent transfer to 0x0, use burn instead
388         require(address(to) != address(0));
389         require(balances[address(this)] >= tokens );
390         require(balances[to] + tokens >= balances[to]);
391         
392         balances[address(this)] = balances[address(this)].sub(tokens);
393         
394         uint256 deduction = 0;
395         
396         if(!rewards){
397             deduction = deductionsToApply(tokens);
398             applyDeductions(deduction);
399         }
400         
401         balances[to] = balances[to].add(tokens.sub(deduction));
402             
403         emit Transfer(address(this),to,tokens.sub(deduction));
404         
405         return true;
406     }
407 
408     function deductionsToApply(uint256 tokens) private view returns(uint256){
409         uint256 deduction = 0;
410         uint256 minSupply = 100000 * 10 ** (18);
411         
412         if(_totalSupply > minSupply && msg.sender != airdropContract){
413         
414             deduction = onePercent(tokens).mul(5); // 5% transaction cost
415         
416             if(_totalSupply.sub(deduction) < minSupply)
417                 deduction = _totalSupply.sub(minSupply);
418         }
419         
420         return deduction;
421     }
422     
423     function applyDeductions(uint256 deduction) private{
424         if(stakedCoins == 0){
425             burnTokens(deduction);
426         }
427         else{
428             burnTokens(deduction.div(2));
429             disburse(deduction.div(2));
430         }
431     }
432     
433     // ------------------------------------------------------------------------
434     // Burn the ``value` amount of tokens from the `account`
435     // ------------------------------------------------------------------------
436     function burnTokens(uint256 value) internal{
437         require(_totalSupply >= value); // burn only unsold tokens
438         _totalSupply = _totalSupply.sub(value);
439         emit Transfer(msg.sender, address(0), value);
440     }
441     
442     // ------------------------------------------------------------------------
443     // Calculates onePercent of the uint256 amount sent
444     // ------------------------------------------------------------------------
445     function onePercent(uint256 _tokens) internal pure returns (uint256){
446         uint256 roundValue = _tokens.ceil(100);
447         uint onePercentofTokens = roundValue.mul(100).div(100 * 10**uint(2));
448         return onePercentofTokens;
449     }
450     
451     
452     /********************************STAKING CONTRACT**********************************/
453     
454     uint256 deployTime;
455     uint256 private totalDividentPoints;
456     uint256 private unclaimedDividendPoints;
457     uint256 pointMultiplier = 1000000000000000000;
458     uint256 public stakedCoins;
459     
460     uint256 public totalRewardsClaimed;
461     
462     bool public stakingOpen;
463     
464     struct  Account {
465         uint256 balance;
466         uint256 lastDividentPoints;
467         uint256 timeInvest;
468         uint256 lastClaimed;
469         uint256 rewardsClaimed;
470         uint256 pending;
471     }
472 
473     mapping(address => Account) accounts;
474     
475     function openStaking() external onlyOwner{
476         require(!stakingOpen, "staking already open");
477         stakingOpen = true;
478     }
479     
480     function STAKE(uint256 _tokens) external returns(bool){
481         require(stakingOpen, "staking is close");
482         // gets VANILLA tokens from user to contract address
483         require(transfer(address(this), _tokens), "In sufficient tokens in user wallet");
484         
485         // require(_tokens >= 100 * 10 ** (18), "Minimum stake allowed is 100 EZG");
486         
487         uint256 owing = dividendsOwing(msg.sender);
488         
489         if(owing > 0) // early stakes
490             accounts[msg.sender].pending = owing;
491         
492         addToStake(_tokens);
493         
494         return true;
495     }
496     
497     function addToStake(uint256 _tokens) private{
498         uint256 deduction = deductionsToApply(_tokens);
499         
500         if(accounts[msg.sender].balance == 0 ) // first time staking
501             accounts[msg.sender].timeInvest = now;
502             
503         stakedCoins = stakedCoins.add(_tokens.sub(deduction));
504         accounts[msg.sender].balance = accounts[msg.sender].balance.add(_tokens.sub(deduction));
505         accounts[msg.sender].lastDividentPoints = totalDividentPoints;
506         
507         accounts[msg.sender].lastClaimed = now;
508         
509     }
510     
511     function stakingStartedAt(address user) external view returns(uint256){
512         return accounts[user].timeInvest;
513     }
514     
515     function pendingReward(address _user) external view returns(uint256){
516         uint256 owing = dividendsOwing(_user);
517         return owing;
518     }
519     
520     function dividendsOwing(address investor) internal view returns (uint256){
521         uint256 newDividendPoints = totalDividentPoints.sub(accounts[investor].lastDividentPoints);
522         return (((accounts[investor].balance).mul(newDividendPoints)).div(pointMultiplier)).add(accounts[investor].pending);
523     }
524    
525     function updateDividend(address investor) internal returns(uint256){
526         uint256 owing = dividendsOwing(investor);
527         if (owing > 0){
528             unclaimedDividendPoints = unclaimedDividendPoints.sub(owing);
529             accounts[investor].lastDividentPoints = totalDividentPoints;
530             accounts[investor].pending = 0;
531         }
532         return owing;
533     }
534    
535     function activeStake(address _user) external view returns (uint256){
536         return accounts[_user].balance;
537     }
538     
539     function UNSTAKE(uint256 tokens) external returns (bool){
540         require(accounts[msg.sender].balance > 0);
541         
542         uint256 owing = updateDividend(msg.sender);
543         
544         if(owing > 0) // unclaimed reward
545             accounts[msg.sender].pending = owing;
546         
547         stakedCoins = stakedCoins.sub(tokens);
548 
549         require(_transfer(msg.sender, tokens, false));
550        
551         accounts[msg.sender].balance = accounts[msg.sender].balance.sub(tokens);
552         
553         return true;
554     }
555    
556     function disburse(uint256 amount) internal{
557         balances[address(this)] = balances[address(this)].add(amount);
558         
559         uint256 unnormalized = amount.mul(pointMultiplier);
560         totalDividentPoints = totalDividentPoints.add(unnormalized.div(stakedCoins));
561         unclaimedDividendPoints = unclaimedDividendPoints.add(amount);
562     }
563    
564     function claimReward() external returns(bool){
565         uint256 owing = updateDividend(msg.sender);
566         
567         require(owing > 0);
568 
569         require(_transfer(msg.sender, owing, true));
570         
571         accounts[msg.sender].rewardsClaimed = accounts[msg.sender].rewardsClaimed.add(owing);
572        
573         totalRewardsClaimed = totalRewardsClaimed.add(owing);
574         return true;
575     }
576     
577     function rewardsClaimed(address _user) external view returns(uint256 rewardClaimed){
578         return accounts[_user].rewardsClaimed;
579     }
580     
581     function reinvest() external {
582         uint256 owing = updateDividend(msg.sender);
583         
584         require(owing > 0);
585         
586         // if there is any pending reward, people can add it to existing stake
587         
588         addToStake(owing);
589     }
590 }