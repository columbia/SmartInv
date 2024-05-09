1 pragma solidity 0.5.9;
2                                                                                                                  
3 // 'BitcoinSoV' contract
4 // Mineable & Deflationary ERC20 Token using Proof Of Work
5 // Website: https://btcsov.com
6 //
7 // Symbol      : BSOV
8 // Name        : BitcoinSoV 
9 // Total supply: 21,000,000.00
10 // Decimals    : 8
11 //
12 // ----------------------------------------------------------------------------
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 
18 library SafeMath {
19 
20     function add(uint a, uint b) internal pure returns(uint c) {
21         c = a + b;
22         require(c >= a);
23     }
24 
25     function sub(uint a, uint b) internal pure returns(uint c) {
26         require(b <= a);
27         c = a - b;
28     }
29 
30     function mul(uint a, uint b) internal pure returns(uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34 
35     function div(uint a, uint b) internal pure returns(uint c) {
36         require(b > 0);
37         c = a / b;
38     }
39 
40 }
41 
42 library ExtendedMath {
43 
44     //return the smaller of the two inputs (a or b)
45     function limitLessThan(uint a, uint b) internal pure returns(uint c) {
46         if (a > b) return b;
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
57 
58     function totalSupply() public view returns(uint);
59     function balanceOf(address tokenOwner) public view returns(uint balance);
60     function allowance(address tokenOwner, address spender) public view returns(uint remaining);
61     function transfer(address to, uint tokens) public returns(bool success);
62     function approve(address spender, uint tokens) public returns(bool success);
63     function transferFrom(address from, address to, uint tokens) public returns(bool success);
64     event Transfer(address indexed from, address indexed to, uint tokens);
65     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
66 
67 }
68 
69 // ----------------------------------------------------------------------------
70 // Contract function to receive approval and execute function in one call
71 //
72 // Borrowed from MiniMeToken
73 // ----------------------------------------------------------------------------
74 
75 contract ApproveAndCallFallBack {
76 
77     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
78 
79 }
80 
81 // ----------------------------------------------------------------------------
82 // Owned contract
83 // ----------------------------------------------------------------------------
84 
85 contract Owned {
86 
87     address public owner;
88     address public newOwner;
89 
90     event OwnershipTransferred(address indexed _from, address indexed _to);
91 
92     constructor() public {
93         owner = msg.sender;
94     }
95 
96     modifier onlyOwner {
97         require(msg.sender == owner);
98         _;
99     }
100 
101     function transferOwnership(address _newOwner) public onlyOwner {
102         newOwner = _newOwner;
103     }
104 
105     function acceptOwnership() public {
106         require(msg.sender == newOwner);
107         emit OwnershipTransferred(owner, newOwner);
108         owner = newOwner;
109         newOwner = address(0);
110     }
111 
112 }
113 
114 // ----------------------------------------------------------------------------
115 // ERC20 Token, with the addition of symbol, name and decimals and an
116 // initial fixed supply
117 // ----------------------------------------------------------------------------
118 
119 contract _BitcoinSoV is ERC20Interface, Owned {
120 
121     using SafeMath for uint;
122     using ExtendedMath for uint;
123 
124     string public symbol;
125     string public name;
126     uint8 public decimals;
127     uint public _totalSupply;
128     uint public latestDifficultyPeriodStarted;
129     uint public epochCount; //number of 'blocks' mined
130     uint public _BLOCKS_PER_READJUSTMENT = 1024;
131 
132     //a little number
133     uint public _MINIMUM_TARGET = 2 ** 16;
134 
135     //a big number is easier ; just find a solution that is smaller
136     //uint public  _MAXIMUM_TARGET = 2**224;  bitcoin uses 224
137     uint public _MAXIMUM_TARGET = 2 ** 234;
138     uint public miningTarget;
139     bytes32 public challengeNumber; //generate a new one when a new reward is minted
140     uint public rewardEra;
141     uint public maxSupplyForEra;
142     address public lastRewardTo;
143     uint public lastRewardAmount;
144     uint public lastRewardEthBlockNumber;
145     bool locked = false;
146     mapping(bytes32 => bytes32) solutionForChallenge;
147     uint public tokensMinted;
148     mapping(address => uint) balances;
149     mapping(address => mapping(address => uint)) allowed;
150     uint public burnPercent;
151 
152     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
153 
154     // ------------------------------------------------------------------------
155     // Constructor
156     // ------------------------------------------------------------------------
157 
158     constructor() public onlyOwner {
159 
160         symbol = "BSOV";
161         name = "BitcoinSoV";
162         decimals = 8;
163         _totalSupply = 21000000 * 10 ** uint(decimals);
164         if (locked) revert();
165         locked = true;
166         tokensMinted = 0;
167         rewardEra = 0;
168         maxSupplyForEra = _totalSupply.div(2);
169         miningTarget = _MAXIMUM_TARGET;
170         latestDifficultyPeriodStarted = block.number;
171         burnPercent = 10; //it's divided by 1000, then 10/1000 = 0.01 = 1%
172         _startNewMiningEpoch();
173 
174         //The owner gets nothing! You must mine this ERC20 token
175         //balances[owner] = _totalSupply;
176         //Transfer(address(0), owner, _totalSupply);
177 
178     }
179 
180     function mint(uint256 nonce, bytes32 challenge_digest) public returns(bool success) {
181         //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
182         bytes32 digest = keccak256(abi.encodePacked(challengeNumber, msg.sender, nonce));
183         //the challenge digest must match the expected
184         if (digest != challenge_digest) revert();
185         //the digest must be smaller than the target
186         if (uint256(digest) > miningTarget) revert();
187         //only allow one reward for each challenge
188         bytes32 solution = solutionForChallenge[challengeNumber];
189         solutionForChallenge[challengeNumber] = digest;
190         if (solution != 0x0) revert(); //prevent the same answer from awarding twice
191         uint reward_amount = getMiningReward();
192         balances[msg.sender] = balances[msg.sender].add(reward_amount);
193         tokensMinted = tokensMinted.add(reward_amount);
194         //Cannot mint more tokens than there are
195         assert(tokensMinted <= maxSupplyForEra);
196         //set readonly diagnostics data
197         lastRewardTo = msg.sender;
198         lastRewardAmount = reward_amount;
199         lastRewardEthBlockNumber = block.number;
200         _startNewMiningEpoch();
201         emit Mint(msg.sender, reward_amount, epochCount, challengeNumber);
202         return true;
203     }
204 
205     //a new 'block' to be mined
206     function _startNewMiningEpoch() internal {
207         //if max supply for the era will be exceeded next reward round then enter the new era before that happens
208         //40 is the final reward era, almost all tokens minted
209         //once the final era is reached, more tokens will not be given out because the assert function
210         if (tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 39) {
211             rewardEra = rewardEra + 1;
212         }
213         //set the next minted supply at which the era will change
214         // total supply is 2100000000000000  because of 8 decimal places
215         maxSupplyForEra = _totalSupply - _totalSupply.div(2 ** (rewardEra + 1));
216         epochCount = epochCount.add(1);
217         //every so often, readjust difficulty. Dont readjust when deploying
218         if (epochCount % _BLOCKS_PER_READJUSTMENT == 0) {
219             _reAdjustDifficulty();
220         }
221         //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
222         //do this last since this is a protection mechanism in the mint() function
223         challengeNumber = blockhash(block.number - 1);
224     }
225     //https://en.bitcoin.it/wiki/Difficulty#What_is_the_formula_for_difficulty.3F
226     //as of 2017 the bitcoin difficulty was up to 17 zeroes, it was only 8 in the early days
227     //readjust the target by 5 percent
228     function _reAdjustDifficulty() internal {
229         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
230         //assume 360 ethereum blocks per hour
231         //we want miners to spend 10 minutes to mine each 'block', about 60 ethereum blocks = one BitcoinSoV epoch
232         uint epochsMined = _BLOCKS_PER_READJUSTMENT; //256
233         uint targetEthBlocksPerDiffPeriod = epochsMined * 60; //should be 60 times slower than ethereum
234         //if there were less eth blocks passed in time than expected
235         if (ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod) {
236             uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div(ethBlocksSinceLastDifficultyPeriod);
237             uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
238             // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.
239             //make it harder
240             miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra)); //by up to 50 %
241         } else {
242             uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div(targetEthBlocksPerDiffPeriod);
243             uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
244             //make it easier
245             miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra)); //by up to 50 %
246         }
247         latestDifficultyPeriodStarted = block.number;
248         if (miningTarget < _MINIMUM_TARGET) //very difficult
249         {
250             miningTarget = _MINIMUM_TARGET;
251         }
252         if (miningTarget > _MAXIMUM_TARGET) //very easy
253         {
254             miningTarget = _MAXIMUM_TARGET;
255         }
256     }
257 
258     //this is a recent ethereum block hash, used to prevent pre-mining future blocks
259     function getChallengeNumber() public view returns(bytes32) {
260         return challengeNumber;
261     }
262 
263     //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
264     function getMiningDifficulty() public view returns(uint) {
265         return _MAXIMUM_TARGET.div(miningTarget);
266     }
267 
268     function getMiningTarget() public view returns(uint) {
269         return miningTarget;
270     }
271 
272     //21m coins total
273     //reward begins at 50 and is cut in half every reward era (as tokens are mined)
274     function getMiningReward() public view returns(uint) {
275         //once we get half way thru the coins, only get 25 per block
276         //every reward era, the reward amount halves.
277         return (50 * 10 ** uint(decimals)).div(2 ** rewardEra);
278     }
279 
280     //help debug mining software
281     function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns(bytes32 digesttest) {
282         bytes32 digest = keccak256(abi.encodePacked(challenge_number, msg.sender, nonce));
283         return digest;
284     }
285 
286     //help debug mining software
287     function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns(bool success) {
288         bytes32 digest = keccak256(abi.encodePacked(challenge_number, msg.sender, nonce));
289         if (uint256(digest) > testTarget) revert();
290         return (digest == challenge_digest);
291     }
292 
293     // ------------------------------------------------------------------------
294     // Total supply
295     // ------------------------------------------------------------------------
296 
297     function totalSupply() public view returns(uint) {
298         return _totalSupply - balances[address(0)];
299     }
300 
301     // ------------------------------------------------------------------------
302     // Get the token balance for account `tokenOwner`
303     // ------------------------------------------------------------------------
304 
305     function balanceOf(address tokenOwner) public view returns(uint balance) {
306         return balances[tokenOwner];
307     }
308 
309     // ------------------------------------------------------------------------
310     // Transfer the balance from token owner's account to `to` account
311     // - Owner's account must have sufficient balance to transfer
312     // - 0 value transfers are allowed
313     // ------------------------------------------------------------------------
314 
315     function transfer(address to, uint tokens) public returns(bool success) {
316 
317         uint toBurn = tokens.mul(burnPercent).div(1000);
318         uint toSend = tokens.sub(toBurn);
319 
320         balances[msg.sender] = balances[msg.sender].sub(tokens);
321 
322         balances[to] = balances[to].add(toSend);
323         emit Transfer(msg.sender, to, toSend);
324 
325         balances[address(0)] = balances[address(0)].add(toBurn);
326         emit Transfer(msg.sender, address(0), toBurn);
327 
328         return true;
329 
330     }
331 
332     // ------------------------------------------------------------------------
333     // Token owner can approve for `spender` to transferFrom(...) `tokens`
334     // from the token owner's account
335     //
336     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
337     // recommends that there are no checks for the approval double-spend attack
338     // as this should be implemented in user interfaces
339     // ------------------------------------------------------------------------
340 
341     function approve(address spender, uint tokens) public returns(bool success) {
342         allowed[msg.sender][spender] = tokens;
343         emit Approval(msg.sender, spender, tokens);
344         return true;
345     }
346 
347     // ------------------------------------------------------------------------
348     // Transfer `tokens` from the `from` account to the `to` account
349     //
350     // The calling account must already have sufficient tokens approve(...)-d
351     // for spending from the `from` account and
352     // - From account must have sufficient balance to transfer
353     // - Spender must have sufficient allowance to transfer
354     // - 0 value transfers are allowed
355     // ------------------------------------------------------------------------
356 
357     function transferFrom(address from, address to, uint tokens) public returns(bool success) {
358         uint toBurn = tokens.mul(burnPercent).div(1000);
359         uint toSend = tokens.sub(toBurn);
360         balances[from] = balances[from].sub(tokens);
361         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
362         balances[to] = balances[to].add(toSend);
363         emit Transfer(from, to, toSend);
364         balances[address(0)] = balances[address(0)].add(toBurn);
365         emit Transfer(from, address(0), toBurn);
366         return true;
367     }
368 
369     // ------------------------------------------------------------------------
370     // Returns the amount of tokens approved by the owner that can be
371     // transferred to the spender's account
372     // ------------------------------------------------------------------------
373 
374     function allowance(address tokenOwner, address spender) public view returns(uint remaining) {
375         return allowed[tokenOwner][spender];
376     }
377 
378     // ------------------------------------------------------------------------
379     // Token owner can approve for `spender` to transferFrom(...) `tokens`
380     // from the token owner's account. The `spender` contract function
381     // `receiveApproval(...)` is then executed
382     // ------------------------------------------------------------------------
383 
384     function approveAndCall(address spender, uint tokens, bytes memory data) public returns(bool success) {
385         allowed[msg.sender][spender] = tokens;
386         emit Approval(msg.sender, spender, tokens);
387         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
388         return true;
389     }
390 
391     // ------------------------------------------------------------------------
392     // Don't accept ETH
393     // ------------------------------------------------------------------------
394 
395     function () external payable {
396         revert();
397     }
398 
399     // ------------------------------------------------------------------------
400     // Owner can transfer out any accidentally sent ERC20 tokens
401     // ------------------------------------------------------------------------
402 
403     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns(bool success) {
404         return ERC20Interface(tokenAddress).transfer(owner, tokens);
405     }
406 
407 }