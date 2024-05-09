1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'Kiwi Token' contract
5 // Mineable ERC20 Token using Proof Of Work
6 //
7 // Symbol      : Kiwi
8 // Name        : Kiwi Token
9 // Total supply: 7 000 000 000 (7 Billion)
10 // Decimals    : 8
11 //
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
16 // Safe maths
17 // ----------------------------------------------------------------------------
18 
19 library SafeMath {
20     function add(uint a, uint b) internal pure returns (uint c) {
21         c = a + b;
22         require(c >= a);
23     }
24 
25     function sub(uint a, uint b) internal pure returns (uint c) {
26         require(b <= a);
27         c = a - b;
28     }
29 
30     function mul(uint a, uint b) internal pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34 
35     function div(uint a, uint b) internal pure returns (uint c) {
36         require(b > 0);
37         c = a / b;
38     }
39 }
40 
41 
42 library ExtendedMath {
43 
44     //return the smaller of the two inputs (a or b)
45     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
46         if(a > b) return b;
47         return a;
48     }
49 }
50 
51 // ----------------------------------------------------------------------------
52 // ERC Token Standard #20 Interface
53 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
54 // ----------------------------------------------------------------------------
55 
56 contract ERC20Interface {
57     function totalSupply() public constant returns (uint);
58     function balanceOf(address tokenOwner) public constant returns (uint balance);
59     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
60     function transfer(address to, uint tokens) public returns (bool success);
61     function approve(address spender, uint tokens) public returns (bool success);
62     function transferFrom(address from, address to, uint tokens) public returns (bool success);
63 
64     event Transfer(address indexed from, address indexed to, uint tokens);
65     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
66 }
67 
68 // ----------------------------------------------------------------------------
69 // Contract function to receive approval and execute function in one call
70 //
71 // Borrowed from MiniMeToken
72 // ----------------------------------------------------------------------------
73 
74 contract ApproveAndCallFallBack {
75     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
76 }
77 
78 
79 // ----------------------------------------------------------------------------
80 // Owned contract
81 // ----------------------------------------------------------------------------
82 contract Owned {
83     address public owner;
84     address public newOwner;
85 
86     event OwnershipTransferred(address indexed _from, address indexed _to);
87 
88     function Owned() public {
89         owner = msg.sender;
90     }
91 
92     modifier onlyOwner {
93         require(msg.sender == owner);
94         _;
95     }
96 
97     function transferOwnership(address _newOwner) public onlyOwner {
98         newOwner = _newOwner;
99     }
100 
101     function acceptOwnership() public {
102         require(msg.sender == newOwner);
103         OwnershipTransferred(owner, newOwner);
104         owner = newOwner;
105         newOwner = address(0);
106     }
107 }
108 
109 interface EIP918Interface  {
110 
111     function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
112 
113     function getChallengeNumber() public constant returns (bytes32);
114 
115     function getMiningDifficulty() public constant returns (uint);
116 
117     function getMiningTarget() public constant returns (uint);
118 
119     function getMiningReward() public constant returns (uint);
120 
121     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
122 
123 }
124 
125 
126 // ----------------------------------------------------------------------------
127 // Mineable ERC918 / ERC20 Token
128 // ----------------------------------------------------------------------------
129 
130 contract _KiwiToken is ERC20Interface, Owned, EIP918Interface {
131 
132     using SafeMath for uint;
133     using ExtendedMath for uint;
134 
135     string public symbol;
136     string public  name;
137     uint8 public decimals;
138     uint public _totalSupply;
139     uint public latestDifficultyPeriodStarted;
140     uint public epochCount;                 //number of 'blocks' mined
141     uint public _BLOCKS_PER_READJUSTMENT = 512;
142 
143     //a little number and a big number
144     uint public  _MINIMUM_TARGET = 2**16;
145     uint public  _MAXIMUM_TARGET = 2**234;
146 
147     uint public miningTarget;
148     bytes32 public challengeNumber;   //generate a new one when a new reward is minted
149 
150     uint public rewardEra;
151     uint public maxSupplyForEra;
152 
153     address public lastRewardTo;
154     uint public lastRewardAmount;
155     uint public lastRewardEthBlockNumber;
156 
157     bool locked = false;
158 
159     mapping(bytes32 => bytes32) solutionForChallenge;
160 
161     uint public tokensMinted;
162 
163     mapping(address => uint) balances;
164     mapping(address => mapping(address => uint)) allowed;
165 
166     // ------------------------------------------------------------------------
167     // Constructor
168     // ------------------------------------------------------------------------
169     function _KiwiToken() public onlyOwner{
170 
171         symbol = "KIWI";
172         name = "KIWI Token";
173         decimals = 8;
174         _totalSupply = 7000000000 * 10**uint(decimals);
175 
176         if(locked) revert();
177 
178         locked = true;
179         tokensMinted = 0;
180         rewardEra = 0;
181         maxSupplyForEra = _totalSupply.div(2);
182         miningTarget = _MAXIMUM_TARGET;
183         latestDifficultyPeriodStarted = block.number;
184 
185         _startNewMiningEpoch();
186 
187     }
188 
189     function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
190 
191       //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
192       bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
193 
194       //the challenge digest must match the expected
195       if (digest != challenge_digest) revert();
196 
197       //the digest must be smaller than the target
198       if(uint256(digest) > miningTarget) revert();
199 
200       //only allow one reward for each challenge
201       bytes32 solution = solutionForChallenge[challengeNumber];
202       solutionForChallenge[challengeNumber] = digest;
203       if(solution != 0x0) revert();  //prevent the same answer from awarding twice
204 
205       uint reward_amount = getMiningReward();
206       balances[msg.sender] = balances[msg.sender].add(reward_amount);
207       tokensMinted = tokensMinted.add(reward_amount);
208 
209       //Cannot mint more tokens than there are
210       assert(tokensMinted <= maxSupplyForEra);
211 
212       //set readonly diagnostics data
213       lastRewardTo = msg.sender;
214       lastRewardAmount = reward_amount;
215       lastRewardEthBlockNumber = block.number;
216 
217       _startNewMiningEpoch();
218 
219       Mint(msg.sender, reward_amount, epochCount, challengeNumber );
220 
221       return true;
222 
223     }
224 
225     //a new 'block' to be mined
226     function _startNewMiningEpoch() internal {
227 
228       //if max supply for the era will be exceeded next reward round then enter the new era before that happens
229 
230       //40 is the final reward era, almost all tokens minted
231       //once the final era is reached, more tokens will not be given out because the assert function
232       if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 39)
233       {
234         rewardEra = rewardEra + 1;
235       }
236 
237       //set the next minted supply at which the era will change
238       // total supply is 700000000000000000  because of 8 decimal places
239       maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
240 
241       epochCount = epochCount.add(1);
242 
243       //every so often, readjust difficulty. Dont readjust when deploying
244       if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
245       {
246         _reAdjustDifficulty();
247       }
248 
249       //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
250       //do this last since this is a protection mechanism in the mint() function
251       challengeNumber = block.blockhash(block.number - 1);
252 
253     }
254 
255     //readjust the target by 5 percent
256     function _reAdjustDifficulty() internal {
257 
258         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
259         //assume 360 ethereum blocks per hour
260 
261         //we want miners to spend 2 minutes to mine each 'block', about 12 ethereum blocks = one kiwi epoch
262         uint epochsMined = _BLOCKS_PER_READJUSTMENT;
263 
264         uint targetEthBlocksPerDiffPeriod = epochsMined * 12; //should be 12 times slower than ethereum
265 
266         //if there were less eth blocks passed in time than expected
267         if( ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod )
268         {
269           uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div( ethBlocksSinceLastDifficultyPeriod );
270 
271           uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
272           // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.
273 
274           //make it harder
275           miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %
276         }else{
277           uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div( targetEthBlocksPerDiffPeriod );
278           uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
279 
280           //make it easier
281           miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %
282         }
283 
284         latestDifficultyPeriodStarted = block.number;
285 
286         if(miningTarget < _MINIMUM_TARGET) //very difficult
287         {
288           miningTarget = _MINIMUM_TARGET;
289         }
290 
291         if(miningTarget > _MAXIMUM_TARGET) //very easy
292         {
293           miningTarget = _MAXIMUM_TARGET;
294         }
295     }
296 
297 
298     //this is a recent ethereum block hash, used to prevent pre-mining future blocks
299     function getChallengeNumber() public constant returns (bytes32) {
300         return challengeNumber;
301     }
302 
303     //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
304      function getMiningDifficulty() public constant returns (uint) {
305         return _MAXIMUM_TARGET.div(miningTarget);
306     }
307 
308     function getMiningTarget() public constant returns (uint) {
309        return miningTarget;
310    }
311 
312     //reward is cut in half every reward era (as tokens are mined)
313     function getMiningReward() public constant returns (uint) {
314          //every reward era, the reward amount halves.
315          return (5000 * 10**uint(decimals) ).div( 2**rewardEra ) ;
316     }
317 
318     //help debug mining software
319     function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
320         bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
321         return digest;
322       }
323 
324       //help debug mining software
325       function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
326           bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
327           if(uint256(digest) > testTarget) revert();
328           return (digest == challenge_digest);
329         }
330 
331     // ------------------------------------------------------------------------
332     // Total supply
333     // ------------------------------------------------------------------------
334     function totalSupply() public constant returns (uint) {
335         return _totalSupply  - balances[address(0)];
336     }
337 
338     // ------------------------------------------------------------------------
339     // Get the token balance for account `tokenOwner`
340     // ------------------------------------------------------------------------
341     function balanceOf(address tokenOwner) public constant returns (uint balance) {
342         return balances[tokenOwner];
343     }
344 
345     // ------------------------------------------------------------------------
346     // Transfer the balance from token owner's account to `to` account
347     // - Owner's account must have sufficient balance to transfer
348     // - 0 value transfers are allowed
349     // ------------------------------------------------------------------------
350     function transfer(address to, uint tokens) public returns (bool success) {
351         balances[msg.sender] = balances[msg.sender].sub(tokens);
352         balances[to] = balances[to].add(tokens);
353         Transfer(msg.sender, to, tokens);
354         return true;
355     }
356 
357     // ------------------------------------------------------------------------
358     // Token owner can approve for `spender` to transferFrom(...) `tokens`
359     // from the token owner's account
360     //
361     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
362     // recommends that there are no checks for the approval double-spend attack
363     // as this should be implemented in user interfaces
364     // ------------------------------------------------------------------------
365     function approve(address spender, uint tokens) public returns (bool success) {
366         allowed[msg.sender][spender] = tokens;
367         Approval(msg.sender, spender, tokens);
368         return true;
369     }
370 
371     // ------------------------------------------------------------------------
372     // Transfer `tokens` from the `from` account to the `to` account
373     //
374     // The calling account must already have sufficient tokens approve(...)-d
375     // for spending from the `from` account and
376     // - From account must have sufficient balance to transfer
377     // - Spender must have sufficient allowance to transfer
378     // - 0 value transfers are allowed
379     // ------------------------------------------------------------------------
380     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
381         balances[from] = balances[from].sub(tokens);
382         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
383         balances[to] = balances[to].add(tokens);
384         Transfer(from, to, tokens);
385         return true;
386     }
387 
388     // ------------------------------------------------------------------------
389     // Returns the amount of tokens approved by the owner that can be
390     // transferred to the spender's account
391     // ------------------------------------------------------------------------
392     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
393         return allowed[tokenOwner][spender];
394     }
395 
396 
397     // ------------------------------------------------------------------------
398     // Token owner can approve for `spender` to transferFrom(...) `tokens`
399     // from the token owner's account. The `spender` contract function
400     // `receiveApproval(...)` is then executed
401     // ------------------------------------------------------------------------
402     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
403         allowed[msg.sender][spender] = tokens;
404         Approval(msg.sender, spender, tokens);
405         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
406         return true;
407     }
408 
409     // ------------------------------------------------------------------------
410     // Don't accept ETH
411     // ------------------------------------------------------------------------
412     function () public payable {
413         revert();
414     }
415 
416     // ------------------------------------------------------------------------
417     // Owner can transfer out any accidentally sent ERC20 tokens
418     // ------------------------------------------------------------------------
419     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
420         return ERC20Interface(tokenAddress).transfer(owner, tokens);
421     }
422 
423 }