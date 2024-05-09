1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // _       _  _  __  _   _          ___ __ ___ _   _ 
5 //   / _ \     |  \/  |/ _ \| \ | |   /\   / ____/ _ \_   _| \ | |
6 //  | | | |_  _| \  / | |  | |  \| |  /  \ | |   | |  | || | |  \| |
7 //  | | | \ \/ / |\/| | |  | | . ` | / /\ \| |   | |  | || | | . ` |
8 //  | |_| |>  <| |  | | |__| | |\  |/ __ \ |___| |__| || |_| |\  |
9 //   \___//_/\_\_|  |_|\____/|_| \_/_/    \_\_____\____/_____|_| \_|
10 //
11 //  Official website: http://0xmonacoin.org
12 // '0xMonacoin' contract
13 // Mineable ERC20 Token using Proof Of Work
14 // Symbol      : 0xMONA
15 // Name        : 0xMonacoin Token
16 // Total supply: 200,000,000.00
17 // Decimals    : 8
18 //
19 // ----------------------------------------------------------------------------
20 
21 // ----------------------------------------------------------------------------
22 // Safe maths
23 // ----------------------------------------------------------------------------
24 library SafeMath {
25     function add(uint a, uint b) internal pure returns (uint c) {
26         c = a + b;
27         require(c >= a);
28     }
29 
30     function sub(uint a, uint b) internal pure returns (uint c) {
31         require(b <= a);
32         c = a - b;
33     }
34 
35     function mul(uint a, uint b) internal pure returns (uint c) {
36         c = a * b;
37         require(a == 0 || c / a == b);
38     }
39 
40     function div(uint a, uint b) internal pure returns (uint c) {
41         require(b > 0);
42         c = a / b;
43     }
44 }
45 
46 library ExtendedMath {
47     // return the smaller of the two inputs (a or b)
48     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
49         if(a > b) return b;
50         return a;
51     }
52 }
53 
54 // ----------------------------------------------------------------------------
55 // ERC Token Standard #20 Interface
56 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
57 // ----------------------------------------------------------------------------
58 contract ERC20Interface {
59     function totalSupply() public constant returns (uint);
60     function balanceOf(address tokenOwner) public constant returns (uint balance);
61     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
62     function transfer(address to, uint tokens) public returns (bool success);
63     function approve(address spender, uint tokens) public returns (bool success);
64     function transferFrom(address from, address to, uint tokens) public returns (bool success);
65 
66     event Transfer(address indexed from, address indexed to, uint tokens);
67     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
68 }
69 
70 // ----------------------------------------------------------------------------
71 // Contract function to receive approval and execute function in one call
72 //
73 // Borrowed from MiniMeToken
74 // ----------------------------------------------------------------------------
75 contract ApproveAndCallFallBack {
76     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
77 }
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
109 // ----------------------------------------------------------------------------
110 // ERC20 Token, with the addition of symbol, name and decimals and an
111 // initial fixed supply
112 // ----------------------------------------------------------------------------
113 contract _0xMonacoinToken is ERC20Interface, Owned {
114     using SafeMath for uint;
115     using ExtendedMath for uint;
116 
117     string public symbol;
118     string public name;
119     uint8 public decimals;
120     uint public _totalSupply;
121 
122     uint public latestDifficultyPeriodStarted;
123     uint public epochCount; // number of 'blocks' mined
124     uint public _BLOCKS_PER_READJUSTMENT = 1024;
125 
126     // a little number
127     uint public _MINIMUM_TARGET = 2**16;
128 
129     // a big number is easier ; just find a solution that is smaller
130     // uint public  _MAXIMUM_TARGET = 2**224; bitcoin uses 224
131     uint public _MAXIMUM_TARGET = 2**234;
132 
133     uint public miningTarget;
134 
135     bytes32 public challengeNumber; // generate a new one when a new reward is minted
136 
137     uint public rewardEra;
138     uint public maxSupplyForEra;
139 
140     address public lastRewardTo;
141     uint public lastRewardAmount;
142     uint public lastRewardEthBlockNumber;
143 
144     bool locked = false;
145 
146     mapping(bytes32 => bytes32) solutionForChallenge;
147 
148     uint public tokensMinted;
149 
150     mapping(address => uint) balances;
151     mapping(address => mapping(address => uint)) allowed;
152 
153     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
154 
155     // ------------------------------------------------------------------------
156     // Constructor
157     // ------------------------------------------------------------------------
158     function _0xMonacoinToken() public onlyOwner{
159         symbol = "0xMONA";
160         name = "0xMonacoin Token";
161         decimals = 8;
162         _totalSupply = 200000000 * 10**uint(decimals);
163 
164         if(locked) revert();
165         locked = true;
166 
167         tokensMinted = 0;
168 
169         rewardEra = 0;
170         maxSupplyForEra = _totalSupply.div(2);
171 
172         miningTarget = _MAXIMUM_TARGET;
173 
174         latestDifficultyPeriodStarted = block.number;
175 
176         _startNewMiningEpoch();
177 
178         //The owner gets nothing! You must mine this ERC20 token
179         //balances[owner] = _totalSupply;
180         //Transfer(address(0), owner, _totalSupply);
181     }
182 
183     function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
184         // the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
185         bytes32 digest = keccak256(challengeNumber, msg.sender, nonce);
186 
187         // the challenge digest must match the expected
188         if (digest != challenge_digest) revert();
189 
190         // the digest must be smaller than the target
191         if(uint256(digest) > miningTarget) revert();
192 
193         // only allow one reward for each challenge
194         bytes32 solution = solutionForChallenge[challengeNumber];
195         solutionForChallenge[challengeNumber] = digest;
196         if(solution != 0x0) revert(); // prevent the same answer from awarding twice
197 
198         uint reward_amount = getMiningReward();
199 
200         balances[msg.sender] = balances[msg.sender].add(reward_amount);
201 
202         tokensMinted = tokensMinted.add(reward_amount);
203 
204         // Cannot mint more tokens than there are
205         assert(tokensMinted <= maxSupplyForEra);
206 
207         // set readonly diagnostics data
208         lastRewardTo = msg.sender;
209         lastRewardAmount = reward_amount;
210         lastRewardEthBlockNumber = block.number;
211 
212         _startNewMiningEpoch();
213 
214         Mint(msg.sender, reward_amount, epochCount, challengeNumber);
215 
216         return true;
217     }
218 
219     // a new 'block' to be mined
220     function _startNewMiningEpoch() internal {
221         // if max supply for the era will be exceeded next reward round then enter the new era before that happens
222 
223         // 80 is the final reward era, almost all tokens minted
224         // once the final era is reached, more tokens will not be given out because the assert function
225         if(tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 79)
226         {
227             rewardEra = rewardEra + 1;
228         }
229 
230         // set the next minted supply at which the era will change
231         // total supply is 20000000000000000  because of 8 decimal places
232         maxSupplyForEra = _totalSupply - _totalSupply.div(2**(rewardEra + 1));
233 
234         epochCount = epochCount.add(1);
235 
236         // every so often, readjust difficulty. Dont readjust when deploying
237         if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
238         {
239             _reAdjustDifficulty();
240         }
241 
242         // make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
243         // do this last since this is a protection mechanism in the mint() function
244         challengeNumber = block.blockhash(block.number - 1);
245     }
246 
247     // https://en.bitcoin.it/wiki/Difficulty#What_is_the_formula_for_difficulty.3F
248     // as of 2017 the bitcoin difficulty was up to 17 zeroes, it was only 8 in the early days
249     // readjust the target by 5 percent
250     function _reAdjustDifficulty() internal {
251         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
252         // assume 360 ethereum blocks per hour
253 
254         // we want miners to spend 10 minutes to mine each 'block', about 60 ethereum blocks = one atlantis epoch
255         uint epochsMined = _BLOCKS_PER_READJUSTMENT;
256 
257         uint targetEthBlocksPerDiffPeriod = epochsMined * 60; // should be 60 times slower than ethereum
258 
259         // if there were less eth blocks passed in time than expected
260         if(ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod)
261         {
262             uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div(ethBlocksSinceLastDifficultyPeriod);
263 
264             uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
265             // If there were 5% more blocks mined than expected then this is 5.
266             // If there were 100% more blocks mined than expected then this is 100.
267 
268             // make it harder
269             miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra)); // by up to 50 %
270         } else {
271             uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div(targetEthBlocksPerDiffPeriod);
272             uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); // always between 0 and 1000
273 
274             // make it easier
275             miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra)); // by up to 50 %
276         }
277 
278         latestDifficultyPeriodStarted = block.number;
279 
280         if(miningTarget < _MINIMUM_TARGET) // very difficult
281         {
282             miningTarget = _MINIMUM_TARGET;
283         }
284 
285         if(miningTarget > _MAXIMUM_TARGET) // very easy
286         {
287             miningTarget = _MAXIMUM_TARGET;
288         }
289     }
290 
291     // this is a recent ethereum block hash, used to prevent pre-mining future blocks
292     function getChallengeNumber() public constant returns (bytes32) {
293         return challengeNumber;
294     }
295 
296     // the number of zeroes the digest of the PoW solution requires.  Auto adjusts
297     function getMiningDifficulty() public constant returns (uint) {
298         return _MAXIMUM_TARGET.div(miningTarget);
299     }
300 
301     function getMiningTarget() public constant returns (uint) {
302         return miningTarget;
303     }
304 
305     // 200m coins total
306     // reward begins at 500 and is cut in half every reward era (as tokens are mined)
307     function getMiningReward() public constant returns (uint) {
308         // once we get half way thru the coins, only get 250 per block
309         // every reward era, the reward amount halves.
310         return (500 * 10**uint(decimals)).div(2**rewardEra);
311     }
312 
313     // help debug mining software
314     function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
315         bytes32 digest = keccak256(challenge_number, msg.sender, nonce);
316         return digest;
317     }
318 
319     // help debug mining software
320     function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
321         bytes32 digest = keccak256(challenge_number, msg.sender, nonce);
322         if(uint256(digest) > testTarget) revert();
323         return (digest == challenge_digest);
324     }
325 
326     // ------------------------------------------------------------------------
327     // Total supply
328     // ------------------------------------------------------------------------
329     function totalSupply() public constant returns (uint) {
330         return _totalSupply  - balances[address(0)];
331     }
332 
333     // ------------------------------------------------------------------------
334     // Get the token balance for account `tokenOwner`
335     // ------------------------------------------------------------------------
336     function balanceOf(address tokenOwner) public constant returns (uint balance) {
337         return balances[tokenOwner];
338     }
339 
340     // ------------------------------------------------------------------------
341     // Transfer the balance from token owner's account to `to` account
342     // - Owner's account must have sufficient balance to transfer
343     // - 0 value transfers are allowed
344     // ------------------------------------------------------------------------
345     function transfer(address to, uint tokens) public returns (bool success) {
346         balances[msg.sender] = balances[msg.sender].sub(tokens);
347         balances[to] = balances[to].add(tokens);
348         Transfer(msg.sender, to, tokens);
349         return true;
350     }
351 
352     // ------------------------------------------------------------------------
353     // Token owner can approve for `spender` to transferFrom(...) `tokens`
354     // from the token owner's account
355     //
356     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
357     // recommends that there are no checks for the approval double-spend attack
358     // as this should be implemented in user interfaces
359     // ------------------------------------------------------------------------
360     function approve(address spender, uint tokens) public returns (bool success) {
361         allowed[msg.sender][spender] = tokens;
362         Approval(msg.sender, spender, tokens);
363         return true;
364     }
365 
366     // ------------------------------------------------------------------------
367     // Transfer `tokens` from the `from` account to the `to` account
368     //
369     // The calling account must already have sufficient tokens approve(...)-d
370     // for spending from the `from` account and
371     // - From account must have sufficient balance to transfer
372     // - Spender must have sufficient allowance to transfer
373     // - 0 value transfers are allowed
374     // ------------------------------------------------------------------------
375     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
376         balances[from] = balances[from].sub(tokens);
377         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
378         balances[to] = balances[to].add(tokens);
379         Transfer(from, to, tokens);
380         return true;
381     }
382 
383     // ------------------------------------------------------------------------
384     // Returns the amount of tokens approved by the owner that can be
385     // transferred to the spender's account
386     // ------------------------------------------------------------------------
387     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
388         return allowed[tokenOwner][spender];
389     }
390 
391     // ------------------------------------------------------------------------
392     // Token owner can approve for `spender` to transferFrom(...) `tokens`
393     // from the token owner's account. The `spender` contract function
394     // `receiveApproval(...)` is then executed
395     // ------------------------------------------------------------------------
396     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
397         allowed[msg.sender][spender] = tokens;
398         Approval(msg.sender, spender, tokens);
399         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
400         return true;
401     }
402 
403     // ------------------------------------------------------------------------
404     // Don't accept ETH
405     // ------------------------------------------------------------------------
406     function () public payable {
407         revert();
408     }
409 
410     // ------------------------------------------------------------------------
411     // Owner can transfer out any accidentally sent ERC20 tokens
412     // ------------------------------------------------------------------------
413     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
414         return ERC20Interface(tokenAddress).transfer(owner, tokens);
415     }
416 }