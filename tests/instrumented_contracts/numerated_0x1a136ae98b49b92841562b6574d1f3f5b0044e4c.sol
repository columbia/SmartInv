1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'PoWAdv Token' contract
5 // Mineable ERC20 Token using Proof Of Work
6 //
7 // Symbol      : POWA
8 // Name        : PoWAdv Token
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
32 
33     function div(uint a, uint b) internal pure returns (uint c) {
34         require(b > 0);
35         c = a / b;
36     }
37 }
38 
39 library ExtendedMath {
40     //return the smaller of the two inputs (a or b)
41     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
42         if(a > b) return b;
43         return a;
44     }
45 }
46 
47 // ----------------------------------------------------------------------------
48 // ERC Token Standard #20 Interface
49 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
50 // ----------------------------------------------------------------------------
51 contract ERC20Interface {
52     function totalSupply() public constant returns (uint);
53     function balanceOf(address tokenOwner) public constant returns (uint balance);
54     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
55     function transfer(address to, uint tokens) public returns (bool success);
56     function approve(address spender, uint tokens) public returns (bool success);
57     function transferFrom(address from, address to, uint tokens) public returns (bool success);
58 
59     event Transfer(address indexed from, address indexed to, uint tokens);
60     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
61 }
62 
63 // ----------------------------------------------------------------------------
64 // Contract function to receive approval and execute function in one call
65 //
66 // Borrowed from MiniMeToken
67 // ----------------------------------------------------------------------------
68 contract ApproveAndCallFallBack {
69     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
70 }
71 
72 // ----------------------------------------------------------------------------
73 // Owned contract
74 // ----------------------------------------------------------------------------
75 contract Owned {
76     address public owner;
77     address public newOwner;
78 
79     event OwnershipTransferred(address indexed _from, address indexed _to);
80 
81     function Owned() public {
82         owner = msg.sender;
83     }
84 
85     modifier onlyOwner {
86         require(msg.sender == owner);
87         _;
88     }
89 
90     function transferOwnership(address _newOwner) public onlyOwner {
91         newOwner = _newOwner;
92     }
93 
94     function acceptOwnership() public {
95         require(msg.sender == newOwner);
96         emit OwnershipTransferred(owner, newOwner);
97         owner = newOwner;
98         newOwner = address(0);
99     }
100 }
101 
102 // ----------------------------------------------------------------------------
103 // ERC20 Token, with the addition of symbol, name and decimals and an
104 // initial fixed supply
105 // ----------------------------------------------------------------------------
106 contract PoWAdvCoinToken is ERC20Interface, Owned {
107     using SafeMath for uint;
108     using ExtendedMath for uint;
109 
110     string public symbol;
111     string public  name;
112     uint8 public decimals;
113     uint public _totalSupply;
114 
115     uint public latestDifficultyPeriodStarted;
116     uint public firstValidBlockNumber;
117 
118     uint public epochCount; //number of 'blocks' mined
119 
120     uint public _BLOCKS_PER_READJUSTMENT = 16;
121     // avg ETH block period is ~10sec this is 60 roughly block per 10min
122     uint public _TARGET_EPOCH_PER_PEDIOD = _BLOCKS_PER_READJUSTMENT * 60; 
123     uint public _BLOCK_REWARD = (250 * 10**uint(8));
124     //a little number
125     uint public  _MINIMUM_TARGET = 2**16;
126     //a big number is easier ; just find a solution that is smaller
127     uint public  _MAXIMUM_TARGET = 2**234;
128 
129     uint public miningTarget;
130     bytes32 public challengeNumber;   //generate a new one when a new reward is minted
131 
132     bool locked = false;
133 
134     mapping(bytes32 => bytes32) solutionForChallenge;
135 
136     uint public tokensMinted;
137 
138     mapping(address => uint) balances;
139     mapping(address => mapping(address => uint)) allowed;
140 
141     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
142 
143     // ------------------------------------------------------------------------
144     // Constructor
145     // ------------------------------------------------------------------------
146     function PoWAdvCoinToken() public onlyOwner {
147 
148         symbol = "POWA";
149         name = "PoWAdv Token";
150         decimals = 8;
151         _totalSupply = 100000000 * 10**uint(decimals);
152 
153         if(locked) 
154 			revert();
155 			
156         locked = true;
157         tokensMinted = 0;
158         miningTarget = _MAXIMUM_TARGET;
159         latestDifficultyPeriodStarted = block.number;
160         firstValidBlockNumber =  5349511;
161         _startNewMiningEpoch();
162 
163         // Sum of tokens mined before hard fork, will be distributed manually
164         epochCount = 3071;
165         balances[owner] = epochCount * _BLOCK_REWARD;
166         tokensMinted = epochCount * _BLOCK_REWARD;
167     }
168  
169 	function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
170 
171         require(block.number > firstValidBlockNumber);
172             
173 		//the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
174 		bytes32 digest = keccak256(challengeNumber, msg.sender, nonce);
175 
176 		//the challenge digest must match the expected
177 		if (digest != challenge_digest) 
178 			revert();
179 
180 		//the digest must be smaller than the target
181 		if(uint256(digest) > discountedMiningTarget(msg.sender)) 
182 			revert();
183 
184 		//only allow one reward for each challenge
185 		bytes32 solution = solutionForChallenge[challengeNumber];
186 		solutionForChallenge[challengeNumber] = digest;
187 		if(solution != 0x0) 
188 			revert();  //prevent the same answer from awarding twice
189 
190 		uint reward_amount = _BLOCK_REWARD;
191 
192 		balances[msg.sender] = balances[msg.sender].add(reward_amount);
193 
194         tokensMinted = tokensMinted.add(reward_amount);
195         
196 		assert(tokensMinted <= _totalSupply);
197 	
198 		_startNewMiningEpoch();
199 
200 		emit Mint(msg.sender, reward_amount, epochCount, challengeNumber);
201 
202 		return true;
203 	}
204 
205     //a new 'block' to be mined
206     function _startNewMiningEpoch() internal {
207 		epochCount = epochCount.add(1);
208 
209 		//every so often, readjust difficulty. Dont readjust when deploying
210 		if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
211 			_reAdjustDifficulty();
212 		
213 		//make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
214 		//do this last since this is a protection mechanism in the mint() function
215 		challengeNumber = block.blockhash(block.number - 1);
216     }
217 
218     function _reAdjustDifficulty() internal {
219 
220         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
221 
222         //we want miners to spend 10 minutes to mine each 'block', about 60 ethereum blocks = one POWA epoch
223         uint targetEthBlocksPerDiffPeriod = _TARGET_EPOCH_PER_PEDIOD; //should be X times slower than ethereum
224 
225         //if there were less eth blocks passed in time than expected
226         if(ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod)
227         {
228 			uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div(ethBlocksSinceLastDifficultyPeriod);
229 			uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
230 		
231 			//make it harder
232 			miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %
233         }else{
234 			uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div(targetEthBlocksPerDiffPeriod);
235 			uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
236 
237 			//make it easier
238 			miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));  //by up to 50 %
239         }
240 
241         latestDifficultyPeriodStarted = block.number;
242 
243         if(miningTarget < _MINIMUM_TARGET) //very difficult
244         {
245 			miningTarget = _MINIMUM_TARGET;
246         }
247 
248         if(miningTarget > _MAXIMUM_TARGET) //very easy
249         {
250 			miningTarget = _MAXIMUM_TARGET;
251         }
252     }
253 
254     //this is a recent ethereum block hash, used to prevent pre-mining future blocks
255     function getChallengeNumber() public constant returns (bytes32) {
256         return challengeNumber;
257     }
258 
259     //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
260      function getMiningDifficulty() public constant returns (uint) {
261         return _MAXIMUM_TARGET.div(miningTarget);
262     }
263 
264 	function getMiningTarget() public constant returns (uint) {
265 		return miningTarget;
266 	}
267 	
268     function discountedMiningTarget(address solver) public constant returns (uint256 discountedDiff) {
269         // the number of coins owned
270         uint256 minerBalance = uint256(balanceOf(solver));
271          
272         if(minerBalance <= 2 * _BLOCK_REWARD)
273             return getMiningTarget();
274             
275         // the number of full block rewards owned
276         uint256 minerDiscount = uint256(minerBalance.div(_BLOCK_REWARD));
277             
278         discountedDiff = miningTarget.mul(minerDiscount.mul(minerDiscount));
279         
280         if(discountedDiff > _MAXIMUM_TARGET) //very easy
281             discountedDiff = _MAXIMUM_TARGET;
282       
283         return discountedDiff;
284     }
285     
286     function discountedMiningDifficulty(address solver) public constant returns (uint256 discountedDiff) {
287         return _MAXIMUM_TARGET.div(discountedMiningTarget(solver));
288     }
289 
290     // ------------------------------------------------------------------------
291     // Total supply
292     // ------------------------------------------------------------------------
293     function totalSupply() public constant returns (uint) {
294         return _totalSupply - balances[address(0)];
295     }
296 
297     // ------------------------------------------------------------------------
298     // Get the token balance for account `tokenOwner`
299     // ------------------------------------------------------------------------
300     function balanceOf(address tokenOwner) public constant returns (uint balance) {
301         return balances[tokenOwner];
302     }
303 
304     // ------------------------------------------------------------------------
305     // Transfer the balance from token owner's account to `to` account
306     // - Owner's account must have sufficient balance to transfer
307     // - 0 value transfers are not allowed
308     // ------------------------------------------------------------------------
309     function transfer(address to, uint tokens) public returns (bool success) {
310         require(to != 0);
311         balances[msg.sender] = balances[msg.sender].sub(tokens);
312         balances[to] = balances[to].add(tokens);
313         emit Transfer(msg.sender, to, tokens);
314         return true;
315     }
316 
317     // ------------------------------------------------------------------------
318     // Token owner can approve for `spender` to transferFrom(...) `tokens`
319     // from the token owner's account
320     //
321     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
322     // recommends that there are no checks for the approval double-spend attack
323     // as this should be implemented in user interfaces
324     // ------------------------------------------------------------------------
325     function approve(address spender, uint tokens) public returns (bool success) {
326         allowed[msg.sender][spender] = tokens;
327         emit Approval(msg.sender, spender, tokens);
328         return true;
329     }
330 
331 
332     // ------------------------------------------------------------------------
333     // Transfer `tokens` from the `from` account to the `to` account
334     //
335     // The calling account must already have sufficient tokens approve(...)-d
336     // for spending from the `from` account and
337     // - From account must have sufficient balance to transfer
338     // - Spender must have sufficient allowance to transfer
339     // - 0 value transfers are allowed
340     // ------------------------------------------------------------------------
341     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
342         balances[from] = balances[from].sub(tokens);
343         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
344         balances[to] = balances[to].add(tokens);
345         emit Transfer(from, to, tokens);
346         return true;
347     }
348 
349     // ------------------------------------------------------------------------
350     // Returns the amount of tokens approved by the owner that can be
351     // transferred to the spender's account
352     // ------------------------------------------------------------------------
353     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
354         return allowed[tokenOwner][spender];
355     }
356 
357     // ------------------------------------------------------------------------
358     // Token owner can approve for `spender` to transferFrom(...) `tokens`
359     // from the token owner's account. The `spender` contract function
360     // `receiveApproval(...)` is then executed
361     // ------------------------------------------------------------------------
362     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
363         allowed[msg.sender][spender] = tokens;
364         emit Approval(msg.sender, spender, tokens);
365         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
366         return true;
367     }
368 
369     // ------------------------------------------------------------------------
370     // Don't accept ETH
371     // ------------------------------------------------------------------------
372     function () public payable {
373         revert();
374     }
375 
376     // ------------------------------------------------------------------------
377     // Owner can transfer out any accidentally sent ERC20 tokens
378     // ------------------------------------------------------------------------
379     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
380         return ERC20Interface(tokenAddress).transfer(owner, tokens);
381     }
382 }