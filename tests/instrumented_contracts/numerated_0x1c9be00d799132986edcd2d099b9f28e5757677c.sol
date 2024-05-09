1 pragma solidity ^0.4.21;
2 
3 // ----------------------------------------------------------------------------
4 // 'PoWEth Token' contract
5 // Mineable ERC20 Token using Proof Of Work
6 //
7 // Symbol      : PoWEth
8 // Name        : PoWEth Token
9 // Total supply: 100,000,000.00
10 // Decimals    : 8
11 //
12 // ----------------------------------------------------------------------------
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 library SafeMath {
18     function add(uint a, uint b) internal pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22 
23     function sub(uint a, uint b) internal pure returns (uint c) {
24         require(b <= a);
25         c = a - b;
26     }
27 
28     function mul(uint a, uint b) internal pure returns (uint c) {
29         c = a * b;
30         require(a == 0 || c / a == b);
31     }
32 }
33 
34 library ExtendedMath {
35     //return the smaller of the two inputs (a or b)
36     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
37         if(a > b) return b;
38         return a;
39     }
40 }
41 
42 contract ERC20Interface {
43 
44     function totalSupply() public constant returns (uint);
45     function balanceOf(address tokenOwner) public constant returns (uint balance);
46     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
47     function transfer(address to, uint tokens) public returns (bool success);
48     function approve(address spender, uint tokens) public returns (bool success);
49     function transferFrom(address from, address to, uint tokens) public returns (bool success);
50 
51     event Transfer(address indexed from, address indexed to, uint tokens);
52     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
53 }
54 
55 contract ApproveAndCallFallBack {
56     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
57 }
58 
59 
60 // ----------------------------------------------------------------------------
61 // ERC20 Token, with the addition of symbol, name and decimals and an
62 // initial fixed supply
63 // ----------------------------------------------------------------------------
64 contract _0xEtherToken is ERC20Interface {
65     using SafeMath for uint;
66     using ExtendedMath for uint;
67 
68     string public symbol = "PoWEth";
69     string public name = "PoWEth Token";
70     uint8 public decimals = 8;
71     uint public _totalSupply = 10000000000000000;
72 	uint public maxSupplyForEra = 5000000000000000;
73 	
74     uint public latestDifficultyPeriodStarted;
75 	uint public tokensMinted;
76 	
77     uint public epochCount; //number of 'blocks' mined
78     uint public _BLOCKS_PER_READJUSTMENT = 1024;
79 
80     uint public  _MINIMUM_TARGET = 2**16;
81     uint public  _MAXIMUM_TARGET = 2**234;
82 
83     uint public miningTarget = _MAXIMUM_TARGET;
84 
85     bytes32 public challengeNumber;   //generate a new one when a new reward is minted
86 
87     uint public rewardEra;
88     
89     address public lastRewardTo;
90     uint public lastRewardAmount;
91     uint public lastRewardEthBlockNumber;
92 
93     mapping(bytes32 => bytes32) solutionForChallenge;
94 
95     mapping(address => uint) balances;
96     mapping(address => mapping(address => uint)) allowed;
97     
98     address private owner;
99 
100     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
101 
102     function _0xEtherToken() public {
103         
104         owner = msg.sender;
105         
106         latestDifficultyPeriodStarted = block.number;
107 
108         _startNewMiningEpoch();
109 
110         //The owner gets nothing! You must mine this ERC20 token
111         //balances[owner] = _totalSupply;
112         //Transfer(address(0), owner, _totalSupply);
113     }
114 
115 	function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
116 
117 		//the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
118 		bytes32 digest = keccak256(challengeNumber, msg.sender, nonce );
119 
120 		//the challenge digest must match the expected
121 		if (digest != challenge_digest) revert();
122 
123 		//the digest must be smaller than the target
124 		if(uint256(digest) > miningTarget) revert();
125 
126 		//only allow one reward for each challenge
127 		bytes32 solution = solutionForChallenge[challengeNumber];
128 		solutionForChallenge[challengeNumber] = digest;
129 		if(solution != 0x0) 
130 			revert();  //prevent the same answer from awarding twice
131 
132 		uint reward_amount = getMiningReward();
133 
134 		balances[msg.sender] = balances[msg.sender].add(reward_amount);
135 
136 		tokensMinted = tokensMinted.add(reward_amount);
137 
138 		//Cannot mint more tokens than there are
139 		assert(tokensMinted <= maxSupplyForEra);
140 
141 		//set readonly diagnostics data
142 		lastRewardTo = msg.sender;
143 		lastRewardAmount = reward_amount;
144 		lastRewardEthBlockNumber = block.number;
145 		
146 		_startNewMiningEpoch();
147     	emit Mint(msg.sender, reward_amount, epochCount, challengeNumber );
148 
149 	   return true;
150 	}
151 
152     //a new 'block' to be mined
153     function _startNewMiningEpoch() internal {
154 		//if max supply for the era will be exceeded next reward round then enter the new era before that happens
155 
156 		//20 is the final reward era, almost all tokens minted
157 		//once the final era is reached, more tokens will not be given out because the assert function
158 		// 1 era is estimated 1,5y, 20 era is roughly 60y of mining time
159 		if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 19)
160 		{
161 			rewardEra = rewardEra + 1;
162 		}
163 
164 		maxSupplyForEra = _totalSupply - _totalSupply / (2**(rewardEra + 1));
165 
166 		epochCount = epochCount.add(1);
167 
168 		//every so often, readjust difficulty. Dont readjust when deploying
169 		if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
170 		{
171 			_reAdjustDifficulty();
172 		}
173 
174 		//make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
175 		//do this last since this is a protection mechanism in the mint() function
176 		challengeNumber = block.blockhash(block.number - 1);
177     }
178 
179     //https://en.bitcoin.it/wiki/Difficulty#What_is_the_formula_for_difficulty.3F
180     //as of 2017 the bitcoin difficulty was up to 17 zeroes, it was only 8 in the early days
181     //readjust the target by 5 percent
182     function _reAdjustDifficulty() internal {
183         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
184         
185         //assume 240 ethereum blocks per hour
186         //we want miners to spend ~7,5 minutes to mine each 'block', about 30 ethereum blocks = 1 PoWEth epoch
187         uint targetEthBlocksPerDiffPeriod = _BLOCKS_PER_READJUSTMENT * 30; //should be 30 times slower than ethereum
188 
189         //if there were less eth blocks passed in time than expected
190         if(ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod)
191         {
192 			uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)) / ethBlocksSinceLastDifficultyPeriod;
193 			uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
194 			
195 			//make it harder
196 			miningTarget = miningTarget.sub((miningTarget/2000).mul(excess_block_pct_extra));
197         }else{
198 			uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)) / targetEthBlocksPerDiffPeriod;
199 			uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000);
200 
201 			//make it easier
202 			miningTarget = miningTarget.add((miningTarget/2000).mul(shortage_block_pct_extra));
203         }
204 
205         latestDifficultyPeriodStarted = block.number;
206 
207         if(miningTarget < _MINIMUM_TARGET) //very difficult
208         {
209 			miningTarget = _MINIMUM_TARGET;
210         }
211 
212         if(miningTarget > _MAXIMUM_TARGET) //very easy
213         {
214 			miningTarget = _MAXIMUM_TARGET;
215         }
216     }
217 
218     //this is a recent ethereum block hash, used to prevent pre-mining future blocks
219     function getChallengeNumber() public constant returns (bytes32) {
220         return challengeNumber;
221     }
222 
223     //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
224      function getMiningDifficulty() public constant returns (uint) {
225         return _MAXIMUM_TARGET / miningTarget;
226     }
227 
228     function getMiningTarget() public constant returns (uint) {
229        return miningTarget;
230 	}
231 
232     //100m coins total
233     //reward begins at 250 and is cut in half every reward era (as tokens are mined)
234     function getMiningReward() public constant returns (uint) {
235 		return 25000000000/(2**rewardEra);
236     }
237 
238     // ------------------------------------------------------------------------
239     // Total supply
240     // ------------------------------------------------------------------------
241     function totalSupply() public constant returns (uint) {
242         return _totalSupply  - balances[address(0)];
243     }
244 
245     // ------------------------------------------------------------------------
246     // Get the token balance for account `tokenOwner`
247     // ------------------------------------------------------------------------
248     function balanceOf(address tokenOwner) public constant returns (uint balance) {
249         return balances[tokenOwner];
250     }
251 
252     // ------------------------------------------------------------------------
253     // Transfer the balance from token owner's account to `to` account
254     // - Owner's account must have sufficient balance to transfer
255     // - 0 value transfers are allowed
256     // ------------------------------------------------------------------------
257     function transfer(address to, uint tokens) public returns (bool success) {
258         balances[msg.sender] = balances[msg.sender].sub(tokens);
259         balances[to] = balances[to].add(tokens);
260         emit Transfer(msg.sender, to, tokens);
261         return true;
262     }
263 
264     // ------------------------------------------------------------------------
265     // Token owner can approve for `spender` to transferFrom(...) `tokens`
266     // from the token owner's account
267     //
268     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
269     // recommends that there are no checks for the approval double-spend attack
270     // as this should be implemented in user interfaces
271     // ------------------------------------------------------------------------
272     function approve(address spender, uint tokens) public returns (bool success) {
273         allowed[msg.sender][spender] = tokens;
274         emit Approval(msg.sender, spender, tokens);
275         return true;
276     }
277 
278     // ------------------------------------------------------------------------
279     // Transfer `tokens` from the `from` account to the `to` account
280     //
281     // The calling account must already have sufficient tokens approve(...)-d
282     // for spending from the `from` account and
283     // - From account must have sufficient balance to transfer
284     // - Spender must have sufficient allowance to transfer
285     // - 0 value transfers are allowed
286     // ------------------------------------------------------------------------
287     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
288         balances[from] = balances[from].sub(tokens);
289         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
290         balances[to] = balances[to].add(tokens);
291         emit Transfer(from, to, tokens);
292         return true;
293     }
294 
295     // ------------------------------------------------------------------------
296     // Returns the amount of tokens approved by the owner that can be
297     // transferred to the spender's account
298     // ------------------------------------------------------------------------
299     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
300         return allowed[tokenOwner][spender];
301     }
302 
303     // ------------------------------------------------------------------------
304     // Token owner can approve for `spender` to transferFrom(...) `tokens`
305     // from the token owner's account. The `spender` contract function
306     // `receiveApproval(...)` is then executed
307     // ------------------------------------------------------------------------
308     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
309         allowed[msg.sender][spender] = tokens;
310         emit Approval(msg.sender, spender, tokens);
311         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
312         return true;
313     }
314 
315     // ------------------------------------------------------------------------
316     // Don't accept ETH
317     // ------------------------------------------------------------------------
318     function () public payable {
319         revert();
320     }
321 
322     // ------------------------------------------------------------------------
323     // Owner can transfer out any accidentally sent ERC20 tokens
324     // ------------------------------------------------------------------------
325     function transferAnyERC20Token(address tokenAddress, uint tokens) public returns (bool success) {
326         require(msg.sender == owner);
327         return ERC20Interface(tokenAddress).transfer(owner, tokens);
328     }
329     
330     //help debug mining software
331     function getMintDigest(uint256 nonce, bytes32 challenge_number) public view returns (bytes32 digesttest) {
332         bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
333         return digest;
334 	}
335 
336 	//help debug mining software
337 	function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
338 		bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
339 		if(uint256(digest) > testTarget) 
340 			revert();
341 		return (digest == challenge_digest);
342 	}
343 }