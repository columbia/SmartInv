1 pragma solidity ^0.4.23;
2 // ----------------------------------------------------------------------------
3 // 'Rowan Coin' contract
4 
5 // Mineable ERC20 Token using Proof Of Work
6 
7 //
8 
9 // Symbol      : RWN
10 
11 // Name        : Rowan Coin
12 
13 // Total supply: 45,000,000.00
14 
15 // Decimals    : 10
16 //
17 // ----------------------------------------------------------------------------
18 // ----------------------------------------------------------------------------
19 // Safe maths
20 // ----------------------------------------------------------------------------
21 library SafeMath {
22     function add(uint a, uint b) internal pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     function sub(uint a, uint b) internal pure returns (uint c) {
27         require(b <= a);
28         c = a - b;
29     }
30     function mul(uint a, uint b) internal pure returns (uint c) {
31         c = a * b;
32         require(a == 0 || c / a == b);
33     }
34     function div(uint a, uint b) internal pure returns (uint c) {
35         require(b > 0);
36         c = a / b;
37     }
38 }
39 library ExtendedMath {
40     //return the smaller of the two inputs (a or b)
41     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
42         if(a > b) return b;
43         return a;
44     }
45 }
46 // ----------------------------------------------------------------------------
47 // ERC Token Standard #20 Interface
48 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
49 // ----------------------------------------------------------------------------
50 contract ERC20Interface {
51     function totalSupply() public constant returns (uint);
52     function balanceOf(address tokenOwner) public constant returns (uint balance);
53     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
54     function transfer(address to, uint tokens) public returns (bool success);
55     function approve(address spender, uint tokens) public returns (bool success);
56     function transferFrom(address from, address to, uint tokens) public returns (bool success);
57     event Transfer(address indexed from, address indexed to, uint tokens);
58     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
59 }
60 
61 contract EIP918Interface {
62 
63     /*
64      * Externally facing mint function that is called by miners to validate challenge digests, calculate reward,
65      * populate statistics, mutate epoch variables and adjust the solution difficulty as required. Once complete,
66      * a Mint event is emitted before returning a success indicator.
67      **/
68     function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
69 
70     /*
71      * Optional
72      * Externally facing merge function that is called by miners to validate challenge digests, calculate reward,
73      * populate statistics, mutate epoch variables and adjust the solution difficulty as required. Additionally, the
74      * merge function takes an array of target token addresses to be used in merged rewards. Once complete,
75      * a Mint event is emitted before returning a success indicator.
76      **/
77     //function merge(uint256 nonce, bytes32 challenge_digest, address[] mineTokens) public returns (bool);
78 
79     /*
80      * Returns the challenge number
81      **/
82     function getChallengeNumber() public view returns (bytes32);
83 
84     /*
85      * Returns the mining difficulty. The number of digits that the digest of the PoW solution requires which 
86      * typically auto adjusts during reward generation.
87      **/
88     function getMiningDifficulty() public view returns (uint);
89 
90     /*
91      * Returns the mining target
92      **/
93     function getMiningTarget() public view returns (uint);
94 
95     /*
96      * Return the current reward amount. Depending on the algorithm, typically rewards are divided every reward era 
97      * as tokens are mined to provide scarcity
98      **/
99     function getMiningReward() public view returns (uint);
100     
101     /*
102      * Upon successful verification and reward the mint method dispatches a Mint Event indicating the reward address, 
103      * the reward amount, the epoch count and newest challenge number.
104      **/
105     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
106 
107 }
108 // ----------------------------------------------------------------------------
109 // Contract function to receive approval and execute function in one call
110 //
111 // Borrowed from MiniMeToken
112 // ----------------------------------------------------------------------------
113 contract ApproveAndCallFallBack {
114     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
115 }
116 // ----------------------------------------------------------------------------
117 // Owned contract
118 // ----------------------------------------------------------------------------
119 contract Owned {
120     address public owner;
121     address public newOwner;
122     event OwnershipTransferred(address indexed _from, address indexed _to);
123     
124     constructor() public {
125         owner = msg.sender;
126     }
127     modifier onlyOwner {
128         require(msg.sender == owner);
129         _;
130     }
131     function transferOwnership(address _newOwner) public onlyOwner {
132         newOwner = _newOwner;
133     }
134     function acceptOwnership() public {
135         require(msg.sender == newOwner);
136         emit OwnershipTransferred(owner, newOwner);
137         owner = newOwner;
138         newOwner = address(0);
139     }
140 }
141 
142 // ----------------------------------------------------------------------------
143 // ERC20 Token, with the addition of symbol, name and decimals and an
144 // initial fixed supply
145 // ----------------------------------------------------------------------------
146 contract _RowanCoin is ERC20Interface, EIP918Interface, Owned {
147     using SafeMath for uint;
148     using ExtendedMath for uint;
149     string public symbol;
150     string public  name;
151     uint8 public decimals;
152     uint public _totalSupply;
153     uint public latestDifficultyPeriodStarted;
154     uint public epochCount;//number of 'blocks' mined
155     //a little number
156     uint public  _MINIMUM_TARGET = 2**16;
157     //a big number is easier ; just find a solution that is smaller
158     //uint public  _MAXIMUM_TARGET = 2**224;  bitcoin uses 224
159     uint public  _MAXIMUM_TARGET = 2**224;
160     uint public miningTarget;
161     bytes32 public challengeNumber;   //generate a new one when a new reward is minted
162     address public lastRewardTo;
163     uint public lastRewardAmount;
164     uint public lastRewardEthBlockNumber;
165     // a bunch of maps to know where this is going (pun intended)
166     
167     mapping(bytes32 => bytes32) public solutionForChallenge;
168     mapping(uint => uint) public targetForEpoch;
169     mapping(uint => uint) public timeStampForEpoch;
170     mapping(address => uint) balances;
171     mapping(address => address) donationsTo;
172     mapping(address => mapping(address => uint)) allowed;
173     event Donation(address donation);
174     event DonationAddressOf(address donator, address donnationAddress);
175     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
176 
177     // ------------------------------------------------------------------------
178     // Constructor
179     // ------------------------------------------------------------------------
180     constructor() public{
181         symbol = "RWN";
182         name = "Rowan Coin";
183         
184         decimals = 10;
185         epochCount = 0;
186         _totalSupply = 45000000*10**uint(decimals); 
187         
188         targetForEpoch[epochCount] = _MAXIMUM_TARGET;
189         challengeNumber = "GENESIS_BLOCK";
190         solutionForChallenge[challengeNumber] = "42"; // ahah yes
191         timeStampForEpoch[epochCount] = block.timestamp;
192         latestDifficultyPeriodStarted = block.number;
193         
194         epochCount = epochCount.add(1);
195         targetForEpoch[epochCount] = _MAXIMUM_TARGET;
196         miningTarget = _MAXIMUM_TARGET;
197         
198         balances[owner] = _totalSupply;
199         emit Transfer(address(0), owner, _totalSupply);
200     }
201 
202     function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
203         //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
204         bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
205         //the challenge digest must match the expected
206         if (digest != challenge_digest) revert();
207         //the digest must be smaller than the target
208         if(uint256(digest) > miningTarget) revert();
209         //only allow one reward for each challenge
210         bytes32 solution = solutionForChallenge[challenge_digest];
211         solutionForChallenge[challengeNumber] = digest;
212         if(solution != 0x0) revert();  //prevent the same answer from awarding twice
213         uint reward_amount = getMiningReward();
214         balances[msg.sender] = balances[msg.sender].add(reward_amount);
215         _totalSupply = _totalSupply.add(reward_amount);
216         //set readonly diagnostics data
217         lastRewardTo = msg.sender;
218         lastRewardAmount = reward_amount;
219         lastRewardEthBlockNumber = block.number;
220         _startNewMiningEpoch();
221         emit Mint(msg.sender, reward_amount, epochCount, challengeNumber );
222        return true;
223     }
224 
225     //a new 'block' to be mined
226     function _startNewMiningEpoch() internal {
227         
228         timeStampForEpoch[epochCount] = block.timestamp;
229         epochCount = epochCount.add(1);
230     
231       //Difficulty adjustment following the DigiChieldv3 implementation (Tempered-SMA)
232       // Allows more thorough protection against multi-pool hash attacks
233       // https://github.com/zawy12/difficulty-algorithms/issues/9
234         miningTarget = _reAdjustDifficulty(epochCount);
235       //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
236       //do this last since this is a protection mechanism in the mint() function
237       challengeNumber = blockhash(block.number.sub(1));
238     }
239 
240     //https://github.com/zawy12/difficulty-algorithms/issues/21
241     //readjust the target via a tempered EMA
242     function _reAdjustDifficulty(uint epoch) internal returns (uint) {
243     
244         uint timeTarget = 300;  // We want miners to spend 5 minutes to mine each 'block'
245         uint N = 6180;          //N = 1000*n, ratio between timeTarget and windowTime (31-ish minutes)
246                                 // (Ethereum doesn't handle floating point numbers very well)
247         uint elapsedTime = timeStampForEpoch[epoch.sub(1)].sub(timeStampForEpoch[epoch.sub(2)]); // will revert if current timestamp is smaller than the previous one
248         targetForEpoch[epoch] = (targetForEpoch[epoch.sub(1)].mul(10000)).div( N.mul(3920).div(N.sub(1000).add(elapsedTime.mul(1042).div(timeTarget))).add(N));
249         //              newTarget   =   Tampered EMA-retarget on the last 6 blocks (a bit more, it's an approximation)
250 	// 				Also, there's an adjust factor, in order to correct the delays induced by the time it takes for transactions to confirm
251 	//				Difficulty is adjusted to the time it takes to produce a valid hash. Here, if we set it to take 300 seconds, it will actually take 
252 	//				300 seconds + TxConfirmTime to validate that block. So, we wad a little % to correct that lag time.
253 	//				Once Ethereum scales, it will actually make block times go a tad faster. There's no perfect answer to this problem at the moment
254         latestDifficultyPeriodStarted = block.number;
255         return targetForEpoch[epoch];
256     }
257 
258     //this is a recent ethereum block hash, used to prevent pre-mining future blocks
259     function getChallengeNumber() public constant returns (bytes32) {
260         return challengeNumber;
261     }
262 
263     //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
264      function getMiningDifficulty() public constant returns (uint) {
265         return _MAXIMUM_TARGET.div(targetForEpoch[epochCount]);
266     }
267 
268     function getMiningTarget() public constant returns (uint) {
269        return targetForEpoch[epochCount];
270     }
271 
272     //There's no limit to the coin supply
273     //reward follows more or less the same emmission rate as Dogecoins'. 5 minutes per block / 105120 block in one year (roughly)
274     function getMiningReward() public constant returns (uint) {
275         bytes32 digest = solutionForChallenge[challengeNumber];
276         if(epochCount > 160000) return (50000   * 10**uint(decimals) );                                   //  14.4 M/day / ~ 1.0B Tokens in 20'000 blocks (coin supply @100'000th block ~ 150 Billions)
277         if(epochCount > 140000) return (75000   * 10**uint(decimals) );                                   //  21.6 M/day / ~ 1.5B Tokens in 20'000 blocks (coin supply @100'000th block ~ 149 Billions)
278         if(epochCount > 120000) return (125000  * 10**uint(decimals) );                                  //  36.0 M/day / ~ 2.5B Tokens in 20'000 blocks (coin supply @100'000th block ~ 146 Billions)
279         if(epochCount > 100000) return (250000  * 10**uint(decimals) );                                  //  72.0 M/day / ~ 5.0B Tokens in 20'000 blocks (coin supply @100'000th block ~ 141 Billions) (~ 1 year elapsed)
280         if(epochCount > 80000) return  (500000  * 10**uint(decimals) );                                   // 144.0 M/day / ~10.0B Tokens in 20'000 blocks (coin supply @ 80'000th block ~ 131 Billions)
281         if(epochCount > 60000) return  (1000000 * 10**uint(decimals) );                                  // 288.0 M/day / ~20.0B Tokens in 20'000 blocks (coin supply @ 60'000th block ~ 111 Billions)
282         if(epochCount > 40000) return  ((uint256(keccak256(digest)) % 2500000) * 10**uint(decimals) );   // 360.0 M/day / ~25.0B Tokens in 20'000 blocks (coin supply @ 40'000th block ~  86 Billions)
283         if(epochCount > 20000) return  ((uint256(keccak256(digest)) % 3500000) * 10**uint(decimals) );   // 504.0 M/day / ~35.0B Tokens in 20'000 blocks (coin supply @ 20'000th block ~  51 Billions)
284                                return  ((uint256(keccak256(digest)) % 5000000) * 10**uint(decimals) );                         // 720.0 M/day / ~50.0B Tokens in 20'000 blocks 
285     }
286 
287     //help debug mining software (even though challenge_digest isn't used, this function is constant and helps troubleshooting mining issues)
288     function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
289         bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
290         return digest;
291     }
292 
293     //help debug mining software
294     function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
295       bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
296       if(uint256(digest) > testTarget) revert();
297       return (digest == challenge_digest);
298     }
299 
300     // ------------------------------------------------------------------------
301     // Total supply
302     // ------------------------------------------------------------------------
303     function totalSupply() public constant returns (uint) {
304         return _totalSupply.sub(balances[address(0)]);
305     }
306 
307     // ------------------------------------------------------------------------
308     // Get the token balance for account `tokenOwner`
309     // ------------------------------------------------------------------------
310     function balanceOf(address tokenOwner) public constant returns (uint balance) {
311         return balances[tokenOwner];
312     }
313     
314     function donationTo(address tokenOwner) public constant returns (address donationAddress) {
315         return donationsTo[tokenOwner];
316     }
317     
318     function changeDonation(address donationAddress) public returns (bool success) {
319         donationsTo[msg.sender] = donationAddress;
320         
321         emit DonationAddressOf(msg.sender , donationAddress); 
322         return true;
323     
324     }
325 
326     // ------------------------------------------------------------------------
327     // Transfer the balance from token owner's account to `to` account
328     // - Owner's account must have sufficient balance to transfer
329     // - 0 value transfers are allowed
330     // ------------------------------------------------------------------------
331     function transfer(address to, uint tokens) public returns (bool success) {
332         
333         address donation = donationsTo[msg.sender];
334         balances[msg.sender] = (balances[msg.sender].sub(tokens)).add(5000); // 0.5 RWN for the sender
335         
336         balances[to] = balances[to].add(tokens);
337         balances[donation] = balances[donation].add(5000); // 0.5 RWN for the sender's donation address
338         
339         emit Transfer(msg.sender, to, tokens);
340         emit Donation(donation);
341         
342         return true;
343     }
344     
345     function transferAndDonateTo(address to, uint tokens, address donation) public returns (bool success) {
346         
347         balances[msg.sender] = (balances[msg.sender].sub(tokens)).add(5000); // 0.5 RWN for the sender
348         balances[to] = balances[to].add(tokens);
349         balances[donation] = balances[donation].add(5000); // 0.5 RWN for the sender's specified donation address
350         emit Transfer(msg.sender, to, tokens);
351         emit Donation(donation);
352         return true;
353     }
354     // ------------------------------------------------------------------------
355     // Token owner can approve for `spender` to transferFrom(...) `tokens`
356     // from the token owner's account
357     //
358     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
359     // recommends that there are no checks for the approval double-spend attack
360     // as this should be implemented in user interfaces
361     // ------------------------------------------------------------------------
362     function approve(address spender, uint tokens) public returns (bool success) {
363         allowed[msg.sender][spender] = tokens;
364         emit Approval(msg.sender, spender, tokens);
365         return true;
366     }
367 
368     // ------------------------------------------------------------------------
369     // Transfer `tokens` from the `from` account to the `to` account
370     //
371     // The calling account must already have sufficient tokens approve(...)-d
372     // for spending from the `from` account and
373     // - From account must have sufficient balance to transfer
374     // - Spender must have sufficient allowance to transfer
375     // - 0 value transfers are allowed
376     // ------------------------------------------------------------------------
377     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
378         
379         balances[from] = balances[from].sub(tokens);
380         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
381         balances[to] = balances[to].add(tokens);
382         balances[donationsTo[from]] = balances[donationsTo[from]].add(5000);     // 0.5 RWN for the sender's donation address
383         balances[donationsTo[msg.sender]] = balances[donationsTo[msg.sender]].add(5000); // 0.5 RWN for the sender
384         emit Transfer(from, to, tokens);
385         emit Donation(donationsTo[from]);
386         emit Donation(donationsTo[msg.sender]);
387         return true;
388     }
389 
390     // ------------------------------------------------------------------------
391     // Returns the amount of tokens approved by the owner that can be
392     // transferred to the spender's account
393     // ------------------------------------------------------------------------
394     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
395         return allowed[tokenOwner][spender];
396     }
397 
398     // ------------------------------------------------------------------------
399     // Token owner can approve for `spender` to transferFrom(...) `tokens`
400     // from the token owner's account. The `spender` contract function
401     // `receiveApproval(...)` is then executed
402     // ------------------------------------------------------------------------
403     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
404         allowed[msg.sender][spender] = tokens;
405         emit Approval(msg.sender, spender, tokens);
406         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
407         return true;
408     }
409 
410     // ------------------------------------------------------------------------
411     // Don't accept ETH
412     // ------------------------------------------------------------------------
413     function () public payable {
414         revert();
415     }
416     
417     // ------------------------------------------------------------------------
418     // Owner can transfer out any accidentally sent ERC20 tokens
419     // ------------------------------------------------------------------------
420     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
421         return ERC20Interface(tokenAddress).transfer(owner, tokens);
422     }
423 }