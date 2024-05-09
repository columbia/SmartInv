1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 
5 
6 //   /$$$$$$            /$$$$$$$                                                    /$$          
7 //  /$$$_  $$          | $$__  $$                                                  |__/          
8 // | $$$$\ $$ /$$   /$$| $$  \ $$  /$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$$  /$$$$$$  /$$ /$$$$$$$ 
9 // | $$ $$ $$|  $$ /$$/| $$  | $$ /$$__  $$ /$$__  $$ /$$__  $$ /$$_____/ /$$__  $$| $$| $$__  $$
10 // | $$\ $$$$ \  $$$$/ | $$  | $$| $$  \ $$| $$  \ $$| $$$$$$$$| $$      | $$  \ $$| $$| $$  \ $$
11 // | $$ \ $$$  >$$  $$ | $$  | $$| $$  | $$| $$  | $$| $$_____/| $$      | $$  | $$| $$| $$  | $$
12 // |  $$$$$$/ /$$/\  $$| $$$$$$$/|  $$$$$$/|  $$$$$$$|  $$$$$$$|  $$$$$$$|  $$$$$$/| $$| $$  | $$
13 //  \______/ |__/  \__/|_______/  \______/  \____  $$ \_______/ \_______/ \______/ |__/|__/  |__/
14 //                                          /$$  \ $$                                            
15 //                                         |  $$$$$$/                                            
16 //                                          \______/
17 //
18 // Official OxDogecoin website: http://0xdogecoin.com
19 
20 // '0xDogecoin' contract
21 // Mineable ERC20 Token using Proof Of Work
22 //
23 // Symbol      : 0xDoge
24 // Name        : 0xDogecoin
25 // Total supply: 1 000 000 000 (1 Billion)
26 // Decimals    : 8
27 //
28 // ----------------------------------------------------------------------------
29 
30 
31 // ----------------------------------------------------------------------------
32 // Safe maths
33 // ----------------------------------------------------------------------------
34 
35 library SafeMath {
36     function add(uint a, uint b) internal pure returns (uint c) {
37         c = a + b;
38         require(c >= a);
39     }
40 
41     function sub(uint a, uint b) internal pure returns (uint c) {
42         require(b <= a);
43         c = a - b;
44     }
45 
46     function mul(uint a, uint b) internal pure returns (uint c) {
47         c = a * b;
48         require(a == 0 || c / a == b);
49     }
50 
51     function div(uint a, uint b) internal pure returns (uint c) {
52         require(b > 0);
53         c = a / b;
54     }
55 }
56 
57 
58 library ExtendedMath {
59 
60     //return the smaller of the two inputs (a or b)
61     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
62         if(a > b) return b;
63         return a;
64     }
65 }
66 
67 // ----------------------------------------------------------------------------
68 // ERC Token Standard #20 Interface
69 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
70 // ----------------------------------------------------------------------------
71 
72 contract ERC20Interface {
73     function totalSupply() public constant returns (uint);
74     function balanceOf(address tokenOwner) public constant returns (uint balance);
75     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
76     function transfer(address to, uint tokens) public returns (bool success);
77     function approve(address spender, uint tokens) public returns (bool success);
78     function transferFrom(address from, address to, uint tokens) public returns (bool success);
79 
80     event Transfer(address indexed from, address indexed to, uint tokens);
81     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
82 }
83 
84 // ----------------------------------------------------------------------------
85 // Contract function to receive approval and execute function in one call
86 //
87 // Borrowed from MiniMeToken
88 // ----------------------------------------------------------------------------
89 
90 contract ApproveAndCallFallBack {
91     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
92 }
93 
94 
95 // ----------------------------------------------------------------------------
96 // Owned contract
97 // ----------------------------------------------------------------------------
98 contract Owned {
99     address public owner;
100     address public newOwner;
101 
102     event OwnershipTransferred(address indexed _from, address indexed _to);
103 
104     function Owned() public {
105         owner = msg.sender;
106     }
107 
108     modifier onlyOwner {
109         require(msg.sender == owner);
110         _;
111     }
112 
113     function transferOwnership(address _newOwner) public onlyOwner {
114         newOwner = _newOwner;
115     }
116 
117     function acceptOwnership() public {
118         require(msg.sender == newOwner);
119         OwnershipTransferred(owner, newOwner);
120         owner = newOwner;
121         newOwner = address(0);
122     }
123 }
124 
125 interface EIP918Interface  {
126 
127     function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
128 
129     function getChallengeNumber() public constant returns (bytes32);
130 
131     function getMiningDifficulty() public constant returns (uint);
132 
133     function getMiningTarget() public constant returns (uint);
134 
135     function getMiningReward() public constant returns (uint);
136 
137     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
138 
139 }
140 
141 
142 // ----------------------------------------------------------------------------
143 // Mineable ERC918 / ERC20 Token
144 // ----------------------------------------------------------------------------
145 
146 contract _0xDogecoin is ERC20Interface, Owned, EIP918Interface {
147 
148     using SafeMath for uint;
149     using ExtendedMath for uint;
150 
151     string public symbol;
152     string public  name;
153     uint8 public decimals;
154     uint public _totalSupply;
155     uint public latestDifficultyPeriodStarted;
156     uint public epochCount;                 //number of 'blocks' mined
157     uint public _BLOCKS_PER_READJUSTMENT = 512;
158 
159     //a little number and a big number
160     uint public  _MINIMUM_TARGET = 2**16;
161     uint public  _MAXIMUM_TARGET = 2**234;
162 
163     uint public miningTarget;
164     bytes32 public challengeNumber;   //generate a new one when a new reward is minted
165 
166     uint public rewardEra;
167     uint public maxSupplyForEra;
168 
169     address public lastRewardTo;
170     uint public lastRewardAmount;
171     uint public lastRewardEthBlockNumber;
172 
173     bool locked = false;
174 
175     mapping(bytes32 => bytes32) solutionForChallenge;
176 
177     uint public tokensMinted;
178 
179     mapping(address => uint) balances;
180     mapping(address => mapping(address => uint)) allowed;
181 
182     // ------------------------------------------------------------------------
183     // Constructor
184     // ------------------------------------------------------------------------
185     function _0xDogecoin() public onlyOwner{
186 
187         symbol = "0xDoge";
188         name = "0xDogecoin";
189         decimals = 8;
190         _totalSupply = 1000000000 * 10**uint(decimals);
191 
192         if(locked) revert();
193 
194         locked = true;
195         tokensMinted = 0;
196         rewardEra = 0;
197         maxSupplyForEra = _totalSupply.div(2);
198         miningTarget = _MAXIMUM_TARGET;
199         latestDifficultyPeriodStarted = block.number;
200 
201         _startNewMiningEpoch();
202 
203     }
204 
205     function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
206 
207       //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
208       bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
209 
210       //the challenge digest must match the expected
211       if (digest != challenge_digest) revert();
212 
213       //the digest must be smaller than the target
214       if(uint256(digest) > miningTarget) revert();
215 
216       //only allow one reward for each challenge
217       bytes32 solution = solutionForChallenge[challengeNumber];
218       solutionForChallenge[challengeNumber] = digest;
219       if(solution != 0x0) revert();  //prevent the same answer from awarding twice
220 
221       uint reward_amount = getMiningReward();
222       balances[msg.sender] = balances[msg.sender].add(reward_amount);
223       tokensMinted = tokensMinted.add(reward_amount);
224 
225       //Cannot mint more tokens than there are
226       assert(tokensMinted <= maxSupplyForEra);
227 
228       //set readonly diagnostics data
229       lastRewardTo = msg.sender;
230       lastRewardAmount = reward_amount;
231       lastRewardEthBlockNumber = block.number;
232 
233       _startNewMiningEpoch();
234 
235       Mint(msg.sender, reward_amount, epochCount, challengeNumber );
236 
237       return true;
238 
239     }
240 
241     //a new 'block' to be mined
242     function _startNewMiningEpoch() internal {
243 
244       //if max supply for the era will be exceeded next reward round then enter the new era before that happens
245 
246       //40 is the final reward era, almost all tokens minted
247       //once the final era is reached, more tokens will not be given out because the assert function
248       if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 39)
249       {
250         rewardEra = rewardEra + 1;
251       }
252 
253       //set the next minted supply at which the era will change
254       // total supply is 100000000000000000  because of 8 decimal places
255       maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
256 
257       epochCount = epochCount.add(1);
258 
259       //every so often, readjust difficulty. Dont readjust when deploying
260       if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
261       {
262         _reAdjustDifficulty();
263       }
264 
265       //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
266       //do this last since this is a protection mechanism in the mint() function
267       challengeNumber = block.blockhash(block.number - 1);
268 
269     }
270 
271     //readjust the target by 5 percent
272     function _reAdjustDifficulty() internal {
273 
274         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
275         //assume 360 ethereum blocks per hour
276 
277         //we want miners to spend 2 minutes to mine each 'block', about 12 ethereum blocks = one 0xDoge epoch
278         uint epochsMined = _BLOCKS_PER_READJUSTMENT;
279 
280         uint targetEthBlocksPerDiffPeriod = epochsMined * 12; //should be 12 times slower than ethereum
281 
282         //if there were less eth blocks passed in time than expected
283         if( ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod )
284         {
285           uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div( ethBlocksSinceLastDifficultyPeriod );
286 
287           uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
288           // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.
289 
290           //make it harder
291           miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %
292         }else{
293           uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div( targetEthBlocksPerDiffPeriod );
294           uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
295 
296           //make it easier
297           miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %
298         }
299 
300         latestDifficultyPeriodStarted = block.number;
301 
302         if(miningTarget < _MINIMUM_TARGET) //very difficult
303         {
304           miningTarget = _MINIMUM_TARGET;
305         }
306 
307         if(miningTarget > _MAXIMUM_TARGET) //very easy
308         {
309           miningTarget = _MAXIMUM_TARGET;
310         }
311     }
312 
313 
314     //this is a recent ethereum block hash, used to prevent pre-mining future blocks
315     function getChallengeNumber() public constant returns (bytes32) {
316         return challengeNumber;
317     }
318 
319     //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
320      function getMiningDifficulty() public constant returns (uint) {
321         return _MAXIMUM_TARGET.div(miningTarget);
322     }
323 
324     function getMiningTarget() public constant returns (uint) {
325        return miningTarget;
326    }
327 
328     //reward is cut in half every reward era (as tokens are mined)
329     function getMiningReward() public constant returns (uint) {
330          //every reward era, the reward amount halves.
331          return (5000 * 10**uint(decimals) ).div( 2**rewardEra ) ;
332     }
333 
334     //help debug mining software
335     function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
336         bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
337         return digest;
338       }
339 
340       //help debug mining software
341       function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
342           bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
343           if(uint256(digest) > testTarget) revert();
344           return (digest == challenge_digest);
345         }
346 
347     // ------------------------------------------------------------------------
348     // Total supply
349     // ------------------------------------------------------------------------
350     function totalSupply() public constant returns (uint) {
351         return _totalSupply  - balances[address(0)];
352     }
353 
354     // ------------------------------------------------------------------------
355     // Get the token balance for account `tokenOwner`
356     // ------------------------------------------------------------------------
357     function balanceOf(address tokenOwner) public constant returns (uint balance) {
358         return balances[tokenOwner];
359     }
360 
361     // ------------------------------------------------------------------------
362     // Transfer the balance from token owner's account to `to` account
363     // - Owner's account must have sufficient balance to transfer
364     // - 0 value transfers are allowed
365     // ------------------------------------------------------------------------
366     function transfer(address to, uint tokens) public returns (bool success) {
367         balances[msg.sender] = balances[msg.sender].sub(tokens);
368         balances[to] = balances[to].add(tokens);
369         Transfer(msg.sender, to, tokens);
370         return true;
371     }
372 
373     // ------------------------------------------------------------------------
374     // Token owner can approve for `spender` to transferFrom(...) `tokens`
375     // from the token owner's account
376     //
377     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
378     // recommends that there are no checks for the approval double-spend attack
379     // as this should be implemented in user interfaces
380     // ------------------------------------------------------------------------
381     function approve(address spender, uint tokens) public returns (bool success) {
382         allowed[msg.sender][spender] = tokens;
383         Approval(msg.sender, spender, tokens);
384         return true;
385     }
386 
387     // ------------------------------------------------------------------------
388     // Transfer `tokens` from the `from` account to the `to` account
389     //
390     // The calling account must already have sufficient tokens approve(...)-d
391     // for spending from the `from` account and
392     // - From account must have sufficient balance to transfer
393     // - Spender must have sufficient allowance to transfer
394     // - 0 value transfers are allowed
395     // ------------------------------------------------------------------------
396     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
397         balances[from] = balances[from].sub(tokens);
398         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
399         balances[to] = balances[to].add(tokens);
400         Transfer(from, to, tokens);
401         return true;
402     }
403 
404     // ------------------------------------------------------------------------
405     // Returns the amount of tokens approved by the owner that can be
406     // transferred to the spender's account
407     // ------------------------------------------------------------------------
408     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
409         return allowed[tokenOwner][spender];
410     }
411 
412 
413     // ------------------------------------------------------------------------
414     // Token owner can approve for `spender` to transferFrom(...) `tokens`
415     // from the token owner's account. The `spender` contract function
416     // `receiveApproval(...)` is then executed
417     // ------------------------------------------------------------------------
418     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
419         allowed[msg.sender][spender] = tokens;
420         Approval(msg.sender, spender, tokens);
421         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
422         return true;
423     }
424 
425     // ------------------------------------------------------------------------
426     // Don't accept ETH
427     // ------------------------------------------------------------------------
428     function () public payable {
429         revert();
430     }
431 
432     // ------------------------------------------------------------------------
433     // Owner can transfer out any accidentally sent ERC20 tokens
434     // ------------------------------------------------------------------------
435     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
436         return ERC20Interface(tokenAddress).transfer(owner, tokens);
437     }
438 
439 }