1 pragma solidity ^0.4.18; // solhint-disable-line
2 
3 //http://0xbtcminer.surge.sh/
4  
5 contract MineFarmer{
6     //uint256 EGGS_PER_SHRIMP_PER_SECOND=1;
7     uint256 public EGGS_TO_HATCH_1SHRIMP=86400;//for final version should be seconds in a day
8     uint256 public STARTING_SHRIMP=300;
9     uint256 PSN=10000;
10     uint256 PSNH=5000;
11     bool public initialized=false;
12     address public ceoAddress;
13     mapping (address => uint256) public hatcheryShrimp;
14     mapping (address => uint256) public claimedEggs;
15     mapping (address => uint256) public lastHatch;
16     mapping (address => address) public referrals;
17     uint256 public marketEggs;
18     _0xBitcoinToken Token = _0xBitcoinToken(0xB6eD7644C69416d67B522e20bC294A9a9B405B31);
19     address partnerAddress;
20     constructor() public{
21         ceoAddress=0x85abE8E3bed0d4891ba201Af1e212FE50bb65a26;
22         partnerAddress = 0x20C945800de43394F70D789874a4daC9cFA57451;
23     }
24     function hatchEggs(address ref) public{
25         require(initialized);
26         if(referrals[msg.sender]==0 && referrals[msg.sender]!=msg.sender){
27             referrals[msg.sender]=ref;
28         }
29         uint256 eggsUsed=getMyEggs();
30         uint256 newShrimp=SafeMath.div(eggsUsed,EGGS_TO_HATCH_1SHRIMP);
31         hatcheryShrimp[msg.sender]=SafeMath.add(hatcheryShrimp[msg.sender],newShrimp);
32         claimedEggs[msg.sender]=0;
33         lastHatch[msg.sender]=now;
34         
35         //send referral eggs
36         claimedEggs[referrals[msg.sender]]=SafeMath.add(claimedEggs[referrals[msg.sender]],SafeMath.div(eggsUsed,5));
37         
38         //boost market to nerf shrimp hoarding
39         marketEggs=SafeMath.add(marketEggs,SafeMath.div(eggsUsed,10));
40     }
41     function sellEggs() public{
42         require(initialized);
43         uint256 hasEggs=getMyEggs();
44         uint256 eggValue=calculateEggSell(hasEggs);
45         uint256 fee=devFee(eggValue);
46         claimedEggs[msg.sender]=0;
47         lastHatch[msg.sender]=now;
48         marketEggs=SafeMath.add(marketEggs,hasEggs);
49         devFeeHandle(fee);
50         Token.transfer(msg.sender, SafeMath.sub(eggValue, fee)); 
51     }
52     function buyEggs(uint256 _incoming, address who) internal{
53         require(initialized);
54         uint256 eggsBought=calculateEggBuy(_incoming,SafeMath.sub(Token.balanceOf(address(this)),_incoming));
55         eggsBought=SafeMath.sub(eggsBought,devFee(eggsBought));
56         uint256 fee = devFee(_incoming);
57         devFeeHandle(fee);
58         claimedEggs[who]=SafeMath.add(claimedEggs[who],eggsBought);
59     }
60     
61     function receiveApproval(address receiveFrom, uint256 tkn, address tknaddr, bytes empty){
62         require(tknaddr == address(Token) && msg.sender == tknaddr);
63         Token.transferFrom(receiveFrom, address(this), tkn);
64         buyEggs(tkn, receiveFrom);
65     }
66     
67     //magic trade balancing algorithm
68     function calculateTrade(uint256 rt,uint256 rs, uint256 bs) public view returns(uint256){
69         //(PSN*bs)/(PSNH+((PSN*rs+PSNH*rt)/rt));
70         return SafeMath.div(SafeMath.mul(PSN,bs),SafeMath.add(PSNH,SafeMath.div(SafeMath.add(SafeMath.mul(PSN,rs),SafeMath.mul(PSNH,rt)),rt)));
71     }
72     function calculateEggSell(uint256 eggs) public view returns(uint256){
73         return calculateTrade(eggs,marketEggs,Token.balanceOf(address(this)));
74     }
75     function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256){
76         return calculateTrade(eth,contractBalance,marketEggs);
77     }
78     function calculateEggBuySimple(uint256 eth) public view returns(uint256){
79         return calculateEggBuy(eth,Token.balanceOf(address(this)));
80     }
81     function devFee(uint256 amount) public view returns(uint256){
82         return SafeMath.div(SafeMath.mul(amount,4),100);
83     }
84     
85     function devFeeHandle(uint256 fee) internal{
86         Token.transfer(ceoAddress, fee/2);
87         Token.transfer(partnerAddress, SafeMath.sub(fee,fee/2));
88     }
89     function seedMarket(uint256 eggs, uint256 tkn) public{
90         require(marketEggs==0);
91         if (tkn>0){
92             Token.transferFrom(msg.sender, address(this), tkn);
93         }
94         initialized=true;
95         marketEggs=eggs;
96     }
97     function getFreeShrimp() public{
98         require(initialized);
99         require(hatcheryShrimp[msg.sender]==0);
100         lastHatch[msg.sender]=now;
101         hatcheryShrimp[msg.sender]=STARTING_SHRIMP;
102     }
103     function getBalance() public view returns(uint256){
104         return Token.balanceOf(address(this));
105     }
106     function getMyShrimp() public view returns(uint256){
107         return hatcheryShrimp[msg.sender];
108     }
109     function getMyEggs() public view returns(uint256){
110         return SafeMath.add(claimedEggs[msg.sender],getEggsSinceLastHatch(msg.sender));
111     }
112     function getEggsSinceLastHatch(address adr) public view returns(uint256){
113         uint256 secondsPassed=min(EGGS_TO_HATCH_1SHRIMP,SafeMath.sub(now,lastHatch[adr]));
114         return SafeMath.mul(secondsPassed,hatcheryShrimp[adr]);
115     }
116     function min(uint256 a, uint256 b) private pure returns (uint256) {
117         return a < b ? a : b;
118     }
119 }
120 
121 library SafeMath {
122 
123   /**
124   * @dev Multiplies two numbers, throws on overflow.
125   */
126   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
127     if (a == 0) {
128       return 0;
129     }
130     uint256 c = a * b;
131     assert(c / a == b);
132     return c;
133   }
134 
135   /**
136   * @dev Integer division of two numbers, truncating the quotient.
137   */
138   function div(uint256 a, uint256 b) internal pure returns (uint256) {
139     // assert(b > 0); // Solidity automatically throws when dividing by 0
140     uint256 c = a / b;
141     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
142     return c;
143   }
144 
145   /**
146   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
147   */
148   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
149     assert(b <= a);
150     return a - b;
151   }
152 
153   /**
154   * @dev Adds two numbers, throws on overflow.
155   */
156   function add(uint256 a, uint256 b) internal pure returns (uint256) {
157     uint256 c = a + b;
158     assert(c >= a);
159     return c;
160   }
161 }
162 
163 
164 library ExtendedMath {
165     //return the smaller of the two inputs (a or b)
166     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
167         if(a > b) return b;
168         return a;
169     }
170 }
171 // ----------------------------------------------------------------------------
172 // ERC Token Standard #20 Interface
173 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
174 // ----------------------------------------------------------------------------
175 contract ERC20Interface {
176     function totalSupply() public constant returns (uint);
177     function balanceOf(address tokenOwner) public constant returns (uint balance);
178     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
179     function transfer(address to, uint tokens) public returns (bool success);
180     function approve(address spender, uint tokens) public returns (bool success);
181     function transferFrom(address from, address to, uint tokens) public returns (bool success);
182     event Transfer(address indexed from, address indexed to, uint tokens);
183     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
184 }
185 // ----------------------------------------------------------------------------
186 // Contract function to receive approval and execute function in one call
187 //
188 // Borrowed from MiniMeToken
189 // ----------------------------------------------------------------------------
190 contract ApproveAndCallFallBack {
191     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
192 }
193 // ----------------------------------------------------------------------------
194 // Owned contract
195 // ----------------------------------------------------------------------------
196 contract Owned {
197     address public owner;
198     address public newOwner;
199     event OwnershipTransferred(address indexed _from, address indexed _to);
200     function Owned() public {
201         owner = msg.sender;
202     }
203     modifier onlyOwner {
204         require(msg.sender == owner);
205         _;
206     }
207     function transferOwnership(address _newOwner) public onlyOwner {
208         newOwner = _newOwner;
209     }
210     function acceptOwnership() public {
211         require(msg.sender == newOwner);
212         OwnershipTransferred(owner, newOwner);
213         owner = newOwner;
214         newOwner = address(0);
215     }
216 }
217 
218 // ----------------------------------------------------------------------------
219 // ERC20 Token, with the addition of symbol, name and decimals and an
220 // initial fixed supply
221 // ----------------------------------------------------------------------------
222 contract _0xBitcoinToken is ERC20Interface, Owned {
223     using SafeMath for uint;
224     using ExtendedMath for uint;
225     string public symbol;
226     string public  name;
227     uint8 public decimals;
228     uint public _totalSupply;
229      uint public latestDifficultyPeriodStarted;
230     uint public epochCount;//number of 'blocks' mined
231     uint public _BLOCKS_PER_READJUSTMENT = 1024;
232     //a little number
233     uint public  _MINIMUM_TARGET = 2**16;
234       //a big number is easier ; just find a solution that is smaller
235     //uint public  _MAXIMUM_TARGET = 2**224;  bitcoin uses 224
236     uint public  _MAXIMUM_TARGET = 2**234;
237     uint public miningTarget;
238     bytes32 public challengeNumber;   //generate a new one when a new reward is minted
239     uint public rewardEra;
240     uint public maxSupplyForEra;
241     address public lastRewardTo;
242     uint public lastRewardAmount;
243     uint public lastRewardEthBlockNumber;
244     bool locked = false;
245     mapping(bytes32 => bytes32) solutionForChallenge;
246     uint public tokensMinted;
247     mapping(address => uint) balances;
248     mapping(address => mapping(address => uint)) allowed;
249     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
250     // ------------------------------------------------------------------------
251     // Constructor
252     // ------------------------------------------------------------------------
253     function _0xBitcoinToken() public onlyOwner{
254         symbol = "0xBTC";
255         name = "0xBitcoin Token";
256         decimals = 8;
257         _totalSupply = 21000000 * 10**uint(decimals);
258         if(locked) revert();
259         balances[msg.sender] = 2100000 * 10**uint(decimals);
260         balances[0x14723a09acff6d2a60dcdf7aa4aff308fddc160c] = 2100000 * 10**uint(decimals);
261         locked = true;
262         tokensMinted = 0;
263         rewardEra = 0;
264         maxSupplyForEra = _totalSupply.div(2);
265         miningTarget = _MAXIMUM_TARGET;
266         latestDifficultyPeriodStarted = block.number;
267         _startNewMiningEpoch();
268         //The owner gets nothing! You must mine this ERC20 token
269         //balances[owner] = _totalSupply;
270         //Transfer(address(0), owner, _totalSupply);
271     }
272         function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
273             //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
274             bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
275             //the challenge digest must match the expected
276             if (digest != challenge_digest) revert();
277             //the digest must be smaller than the target
278             if(uint256(digest) > miningTarget) revert();
279             //only allow one reward for each challenge
280              bytes32 solution = solutionForChallenge[challengeNumber];
281              solutionForChallenge[challengeNumber] = digest;
282              if(solution != 0x0) revert();  //prevent the same answer from awarding twice
283             uint reward_amount = getMiningReward();
284             balances[msg.sender] = balances[msg.sender].add(reward_amount);
285             tokensMinted = tokensMinted.add(reward_amount);
286             //Cannot mint more tokens than there are
287             assert(tokensMinted <= maxSupplyForEra);
288             //set readonly diagnostics data
289             lastRewardTo = msg.sender;
290             lastRewardAmount = reward_amount;
291             lastRewardEthBlockNumber = block.number;
292              _startNewMiningEpoch();
293               Mint(msg.sender, reward_amount, epochCount, challengeNumber );
294            return true;
295         }
296     //a new 'block' to be mined
297     function _startNewMiningEpoch() internal {
298       //if max supply for the era will be exceeded next reward round then enter the new era before that happens
299       //40 is the final reward era, almost all tokens minted
300       //once the final era is reached, more tokens will not be given out because the assert function
301       if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 39)
302       {
303         rewardEra = rewardEra + 1;
304       }
305       //set the next minted supply at which the era will change
306       // total supply is 2100000000000000  because of 8 decimal places
307       maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
308       epochCount = epochCount.add(1);
309       //every so often, readjust difficulty. Dont readjust when deploying
310       if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
311       {
312         _reAdjustDifficulty();
313       }
314       //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
315       //do this last since this is a protection mechanism in the mint() function
316       challengeNumber = block.blockhash(block.number - 1);
317     }
318     //https://en.bitcoin.it/wiki/Difficulty#What_is_the_formula_for_difficulty.3F
319     //as of 2017 the bitcoin difficulty was up to 17 zeroes, it was only 8 in the early days
320     //readjust the target by 5 percent
321     function _reAdjustDifficulty() internal {
322         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
323         //assume 360 ethereum blocks per hour
324         //we want miners to spend 10 minutes to mine each 'block', about 60 ethereum blocks = one 0xbitcoin epoch
325         uint epochsMined = _BLOCKS_PER_READJUSTMENT; //256
326         uint targetEthBlocksPerDiffPeriod = epochsMined * 60; //should be 60 times slower than ethereum
327         //if there were less eth blocks passed in time than expected
328         if( ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod )
329         {
330           uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div( ethBlocksSinceLastDifficultyPeriod );
331           uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
332           // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.
333           //make it harder
334           miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %
335         }else{
336           uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div( targetEthBlocksPerDiffPeriod );
337           uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
338           //make it easier
339           miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %
340         }
341         latestDifficultyPeriodStarted = block.number;
342         if(miningTarget < _MINIMUM_TARGET) //very difficult
343         {
344           miningTarget = _MINIMUM_TARGET;
345         }
346         if(miningTarget > _MAXIMUM_TARGET) //very easy
347         {
348           miningTarget = _MAXIMUM_TARGET;
349         }
350     }
351     //this is a recent ethereum block hash, used to prevent pre-mining future blocks
352     function getChallengeNumber() public constant returns (bytes32) {
353         return challengeNumber;
354     }
355     //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
356      function getMiningDifficulty() public constant returns (uint) {
357         return _MAXIMUM_TARGET.div(miningTarget);
358     }
359     function getMiningTarget() public constant returns (uint) {
360        return miningTarget;
361    }
362     //21m coins total
363     //reward begins at 50 and is cut in half every reward era (as tokens are mined)
364     function getMiningReward() public constant returns (uint) {
365         //once we get half way thru the coins, only get 25 per block
366          //every reward era, the reward amount halves.
367          return (50 * 10**uint(decimals) ).div( 2**rewardEra ) ;
368     }
369     //help debug mining software
370     function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
371         bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
372         return digest;
373       }
374         //help debug mining software
375       function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
376           bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
377           if(uint256(digest) > testTarget) revert();
378           return (digest == challenge_digest);
379         }
380     // ------------------------------------------------------------------------
381     // Total supply
382     // ------------------------------------------------------------------------
383     function totalSupply() public constant returns (uint) {
384         return _totalSupply  - balances[address(0)];
385     }
386     // ------------------------------------------------------------------------
387     // Get the token balance for account `tokenOwner`
388     // ------------------------------------------------------------------------
389     function balanceOf(address tokenOwner) public constant returns (uint balance) {
390         return balances[tokenOwner];
391     }
392     // ------------------------------------------------------------------------
393     // Transfer the balance from token owner's account to `to` account
394     // - Owner's account must have sufficient balance to transfer
395     // - 0 value transfers are allowed
396     // ------------------------------------------------------------------------
397     function transfer(address to, uint tokens) public returns (bool success) {
398         balances[msg.sender] = balances[msg.sender].sub(tokens);
399         balances[to] = balances[to].add(tokens);
400         Transfer(msg.sender, to, tokens);
401         return true;
402     }
403     // ------------------------------------------------------------------------
404     // Token owner can approve for `spender` to transferFrom(...) `tokens`
405     // from the token owner's account
406     //
407     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
408     // recommends that there are no checks for the approval double-spend attack
409     // as this should be implemented in user interfaces
410     // ------------------------------------------------------------------------
411     function approve(address spender, uint tokens) public returns (bool success) {
412         allowed[msg.sender][spender] = tokens;
413         Approval(msg.sender, spender, tokens);
414         return true;
415     }
416     // ------------------------------------------------------------------------
417     // Transfer `tokens` from the `from` account to the `to` account
418     //
419     // The calling account must already have sufficient tokens approve(...)-d
420     // for spending from the `from` account and
421     // - From account must have sufficient balance to transfer
422     // - Spender must have sufficient allowance to transfer
423     // - 0 value transfers are allowed
424     // ------------------------------------------------------------------------
425     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
426         balances[from] = balances[from].sub(tokens);
427         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
428         balances[to] = balances[to].add(tokens);
429         Transfer(from, to, tokens);
430         return true;
431     }
432     // ------------------------------------------------------------------------
433     // Returns the amount of tokens approved by the owner that can be
434     // transferred to the spender's account
435     // ------------------------------------------------------------------------
436     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
437         return allowed[tokenOwner][spender];
438     }
439     // ------------------------------------------------------------------------
440     // Token owner can approve for `spender` to transferFrom(...) `tokens`
441     // from the token owner's account. The `spender` contract function
442     // `receiveApproval(...)` is then executed
443     // ------------------------------------------------------------------------
444     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
445         allowed[msg.sender][spender] = tokens;
446         Approval(msg.sender, spender, tokens);
447         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
448         return true;
449     }
450     // ------------------------------------------------------------------------
451     // Don't accept ETH
452     // ------------------------------------------------------------------------
453     function () public payable {
454         revert();
455     }
456     // ------------------------------------------------------------------------
457     // Owner can transfer out any accidentally sent ERC20 tokens
458     // ------------------------------------------------------------------------
459     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
460         return ERC20Interface(tokenAddress).transfer(owner, tokens);
461     }
462 }