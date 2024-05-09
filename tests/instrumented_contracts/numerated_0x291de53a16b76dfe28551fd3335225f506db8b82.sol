1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 //
5 //  Symbol       : 0xGOLD
6 //  Name         : 0xGold Token
7 //  Total supply : 5000000 (5 million)
8 //  Decimals     : 10
9 //
10 // ----------------------------------------------------------------------------
11 // Safe maths
12 // ----------------------------------------------------------------------------
13 
14 library SafeMath {
15     function add(uint a, uint b) internal pure returns (uint c) {
16         c = a + b;
17         require(c >= a);
18     }
19 
20     function sub(uint a, uint b) internal pure returns (uint c) {
21         require(b <= a);
22         c = a - b;
23     }
24 
25     function mul(uint a, uint b) internal pure returns (uint c) {
26         c = a * b;
27         require(a == 0 || c / a == b);
28     }
29 
30     function div(uint a, uint b) internal pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 library ExtendedMath {
37     //return the smaller of the two inputs (a or b)
38     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
39         if(a > b) return b;
40         return a;
41     }
42 }
43 
44 // ----------------------------------------------------------------------------
45 // ERC-20 Token Interface
46 // ----------------------------------------------------------------------------
47 
48 contract ERC20Interface {
49     function totalSupply() public constant returns (uint);
50     function balanceOf(address tokenOwner) public constant returns (uint balance);
51     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
52     function transfer(address to, uint tokens) public returns (bool success);
53     function approve(address spender, uint tokens) public returns (bool success);
54     function transferFrom(address from, address to, uint tokens) public returns (bool success);
55 
56     event Transfer(address indexed from, address indexed to, uint tokens);
57     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
58 }
59 
60 // ----------------------------------------------------------------------------
61 // Contract function to receive approval and execute function in one call
62 // ----------------------------------------------------------------------------
63 
64 contract ApproveAndCallFallBack {
65     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
66 }
67 
68 
69 // ----------------------------------------------------------------------------
70 // Owned contract
71 // ----------------------------------------------------------------------------
72 contract Owned {
73     address public owner;
74     address public newOwner;
75 
76     event OwnershipTransferred(address indexed _from, address indexed _to);
77 
78     function Owned() public {
79         owner = msg.sender;
80     }
81 
82     modifier onlyOwner {
83         require(msg.sender == owner);
84         _;
85     }
86 
87     function transferOwnership(address _newOwner) public onlyOwner {
88         newOwner = _newOwner;
89     }
90 
91     function acceptOwnership() public {
92         require(msg.sender == newOwner);
93         OwnershipTransferred(owner, newOwner);
94         owner = newOwner;
95         newOwner = address(0);
96     }
97 }
98 
99 contract ERC918Interface  {
100 
101     function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
102 
103     function getChallengeNumber() public constant returns (bytes32);
104 
105     function getMiningDifficulty() public constant returns (uint);
106 
107     function getMiningTarget() public constant returns (uint);
108 
109     function getMiningReward() public constant returns (uint);
110 
111     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
112 
113     address public lastRewardTo;
114     uint public lastRewardAmount;
115     uint public lastRewardEthBlockNumber;
116     bytes32 public challengeNumber;
117 
118 
119 }
120 
121 // ----------------------------------------------------------------------------
122 // ERC-20 Token
123 // ----------------------------------------------------------------------------
124 
125 contract _0xGoldToken is ERC20Interface, Owned, ERC918Interface {
126 
127     using SafeMath for uint;
128     using ExtendedMath for uint;
129 
130     string public symbol;
131     string public  name;
132     uint8 public decimals;
133     uint public _totalSupply;
134     uint public latestDifficultyPeriodStarted;
135     uint public epochCount;                 //number of 'blocks' mined
136     uint public _BLOCKS_PER_READJUSTMENT = 100;
137 
138     //a little number and a big number
139     uint public  _MINIMUM_TARGET = 2**16;
140     uint public  _MAXIMUM_TARGET = 2**234;
141     
142     address public parentAddress;     // for merge mining
143 
144     uint public miningTarget;
145     bytes32 public challengeNumber;   //generate a new one when a new reward is minted
146 
147     uint public rewardEra;
148     uint public maxSupplyForEra;
149 
150     address public lastRewardTo;
151     uint public lastRewardAmount;
152     uint public lastRewardEthBlockNumber;
153 
154     bool locked = false;
155 
156     mapping(bytes32 => bytes32) solutionForChallenge;
157 
158     uint public tokensMinted;
159 
160     mapping(address => uint) balances;
161     mapping(address => mapping(address => uint)) allowed;
162 
163     // ------------------------------------------------------------------------
164     // Constructor
165     // ------------------------------------------------------------------------
166     function _0xGoldToken() public onlyOwner{
167 
168         symbol = "0xGOLD";
169         name = "0xGold Token";
170         decimals = 10;
171         _totalSupply = 5000000 * 10**uint(decimals);
172 
173         if(locked) revert();
174 
175         locked = true;
176         tokensMinted = 500000000000000; // 50,000
177         rewardEra = 0;
178         maxSupplyForEra = _totalSupply.div(2);
179         miningTarget = _MAXIMUM_TARGET;
180         latestDifficultyPeriodStarted = block.number;
181 
182         _startNewMiningEpoch();
183         
184         parentAddress = 0xB6eD7644C69416d67B522e20bC294A9a9B405B31; // for merge mining
185         
186         balances[owner] = tokensMinted;
187         Transfer(address(0), owner, tokensMinted);
188 
189 
190     }
191 
192     function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
193 
194       //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
195       bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
196 
197       //the challenge digest must match the expected
198       if (digest != challenge_digest) revert();
199 
200       //the digest must be smaller than the target
201       if(uint256(digest) > miningTarget) revert();
202 
203       //only allow one reward for each challenge
204       bytes32 solution = solutionForChallenge[challengeNumber];
205       solutionForChallenge[challengeNumber] = digest;
206       if(solution != 0x0) revert();  //prevent the same answer from awarding twice
207 
208       uint reward_amount = getMiningReward();
209       balances[msg.sender] = balances[msg.sender].add(reward_amount);
210       tokensMinted = tokensMinted.add(reward_amount);
211 
212       //Cannot mint more tokens than there are
213       assert(tokensMinted <= maxSupplyForEra);
214 
215       //set readonly diagnostics data
216       lastRewardTo = msg.sender;
217       lastRewardAmount = reward_amount;
218       lastRewardEthBlockNumber = block.number;
219 
220       _startNewMiningEpoch();
221 
222       Mint(msg.sender, reward_amount, epochCount, challengeNumber );
223 
224       return true;
225 
226     }
227 
228     //a new 'block' to be mined
229     function _startNewMiningEpoch() internal {
230 
231       //if max supply for the era will be exceeded next reward round then enter the new era before that happens
232 
233       //2 is the final reward era, almost all tokens minted
234       //once the final era is reached, more tokens will not be given out because the assert function
235       if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 2)
236       {
237         rewardEra = rewardEra + 1;
238       }
239 
240       //set the next minted supply at which the era will change
241       // total supply is 50000000000000000  because of 10 decimal places
242       maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
243 
244       epochCount = epochCount.add(1);
245 
246       //every so often, readjust difficulty. Dont readjust when deploying
247       if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
248       {
249         _reAdjustDifficulty();
250       }
251 
252       //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
253       //do this last since this is a protection mechanism in the mint() function
254       challengeNumber = block.blockhash(block.number - 1);
255 
256     }
257 
258     //readjust the target by 5 percent
259     function _reAdjustDifficulty() internal {
260 
261         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
262         //assume 240 ethereum blocks per hour
263 
264         //we want miners to spend 7 minutes to mine each 'block', about 28 ethereum blocks = one 0xGOLD epoch
265         uint epochsMined = _BLOCKS_PER_READJUSTMENT; //256
266 
267         uint targetEthBlocksPerDiffPeriod = epochsMined * 28; //should be 28 times slower than ethereum
268 
269         //if there were less eth blocks passed in time than expected
270         if( ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod )
271         {
272           uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div( ethBlocksSinceLastDifficultyPeriod );
273 
274           uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
275           // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.
276 
277           //make it harder
278           miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %
279         }else{
280           uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div( targetEthBlocksPerDiffPeriod );
281           uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
282 
283           //make it easier
284           miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %
285         }
286 
287         latestDifficultyPeriodStarted = block.number;
288 
289         if(miningTarget < _MINIMUM_TARGET) //very difficult
290         {
291           miningTarget = _MINIMUM_TARGET;
292         }
293 
294         if(miningTarget > _MAXIMUM_TARGET) //very easy
295         {
296           miningTarget = _MAXIMUM_TARGET;
297         }
298     }
299 
300 
301     //this is a recent ethereum block hash, used to prevent pre-mining future blocks
302     function getChallengeNumber() public constant returns (bytes32) {
303         return challengeNumber;
304     }
305 
306     //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
307      function getMiningDifficulty() public constant returns (uint) {
308         return _MAXIMUM_TARGET.div(miningTarget);
309     }
310 
311     function getMiningTarget() public constant returns (uint) {
312        return miningTarget;
313    }
314 
315     //reward is cut in half every reward era (as tokens are mined)
316     function getMiningReward() public constant returns (uint) {
317          //every reward era, the reward amount halves.
318          return (16 * 10**uint(decimals) ).div( 2**rewardEra ) ;
319     }
320 
321     //help debug mining software
322     function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
323         bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
324         return digest;
325       }
326 
327       //help debug mining software
328       function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
329           bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
330           if(uint256(digest) > testTarget) revert();
331           return (digest == challenge_digest);
332         }
333 
334     // ------------------------------------------------------------------------
335     // Total supply
336     // ------------------------------------------------------------------------
337     function totalSupply() public constant returns (uint) {
338         return _totalSupply  - balances[address(0)];
339     }
340 
341     // ------------------------------------------------------------------------
342     // Get the token balance for account `tokenOwner`
343     // ------------------------------------------------------------------------
344     function balanceOf(address tokenOwner) public constant returns (uint balance) {
345         return balances[tokenOwner];
346     }
347 
348     // ------------------------------------------------------------------------
349     // Transfer the balance from token owner's account to `to` account
350     // - Owner's account must have sufficient balance to transfer
351     // - 0 value transfers are allowed
352     // ------------------------------------------------------------------------
353     function transfer(address to, uint tokens) public returns (bool success) {
354         balances[msg.sender] = balances[msg.sender].sub(tokens);
355         balances[to] = balances[to].add(tokens);
356         Transfer(msg.sender, to, tokens);
357         return true;
358     }
359 
360     // ------------------------------------------------------------------------
361     // Token owner can approve for `spender` to transferFrom(...) `tokens`
362     // from the token owner's account
363     // ------------------------------------------------------------------------
364     function approve(address spender, uint tokens) public returns (bool success) {
365         allowed[msg.sender][spender] = tokens;
366         Approval(msg.sender, spender, tokens);
367         return true;
368     }
369 
370     // ------------------------------------------------------------------------
371     // Transfer `tokens` from the `from` account to the `to` account
372     // ------------------------------------------------------------------------
373     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
374         balances[from] = balances[from].sub(tokens);
375         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
376         balances[to] = balances[to].add(tokens);
377         Transfer(from, to, tokens);
378         return true;
379     }
380 
381     // ------------------------------------------------------------------------
382     // Returns the amount of tokens approved by the owner that can be
383     // transferred to the spender's account
384     // ------------------------------------------------------------------------
385     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
386         return allowed[tokenOwner][spender];
387     }
388 
389 
390     // ------------------------------------------------------------------------
391     // Token owner can approve for `spender` to transferFrom(...) `tokens`
392     // from the token owner's account. The `spender` contract function
393     // `receiveApproval(...)` is then executed
394     // ------------------------------------------------------------------------
395     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
396         allowed[msg.sender][spender] = tokens;
397         Approval(msg.sender, spender, tokens);
398         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
399         return true;
400     }
401 
402     // ------------------------------------------------------------------------
403     // Don't accept ETH
404     // ------------------------------------------------------------------------
405     function () public payable {
406         revert();
407     }
408 
409     // ------------------------------------------------------------------------
410     // Owner can transfer out any accidentally sent ERC20 tokens
411     // ------------------------------------------------------------------------
412     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
413         return ERC20Interface(tokenAddress).transfer(owner, tokens);
414     }
415     
416     // ------------------------------------------------------------------------
417     // Merge Mining
418     // ------------------------------------------------------------------------
419     
420     function merge() public returns (bool success) {
421 
422             bytes32 future_challengeNumber = block.blockhash(block.number - 1);
423             if(challengeNumber == future_challengeNumber){
424                 return false; // ( this is likely the second time that mergeMint() has been called in a transaction, so return false (don't revert))
425             }
426 
427             //verify Parent::lastRewardTo == msg.sender;
428             if(ERC918Interface(parentAddress).lastRewardTo() != msg.sender){
429                 return false; // a different address called mint last so return false ( don't revert)
430             }
431             
432             //verify Parent::lastRewardEthBlockNumber == block.number;
433 
434             if(ERC918Interface(parentAddress).lastRewardEthBlockNumber() != block.number){
435                 return false; // parent::mint() was called in a different block number so return false ( don't revert)
436             }
437 
438 
439              bytes32 parentChallengeNumber = ERC918Interface(parentAddress).challengeNumber();
440              bytes32 solution = solutionForChallenge[parentChallengeNumber];
441              if(solution != 0x0) return false;  //prevent the same answer from awarding twice
442              bytes32 digest = 'merge';
443              solutionForChallenge[parentChallengeNumber] = digest;
444 
445 
446             //so now we may safely run the relevant logic to give an award to the sender, and update the contract
447             
448                        uint reward_amount = getMiningReward();
449 
450             balances[msg.sender] = balances[msg.sender].add(reward_amount);
451 
452             tokensMinted = tokensMinted.add(reward_amount);
453 
454 
455             //Cannot mint more tokens than there are
456             assert(tokensMinted <= maxSupplyForEra);
457 
458             //set readonly diagnostics data
459             lastRewardTo = msg.sender;
460             lastRewardAmount = reward_amount;
461             lastRewardEthBlockNumber = block.number;
462 
463 
464              _startNewMiningEpoch();
465 
466               Mint(msg.sender, reward_amount, epochCount, 0 ); // use 0 to indicate a merge mine
467 
468            return true;
469 
470         }
471 
472 
473 }