1 pragma solidity ^0.4.23;
2 // ----------------------------------------------------------------------------
3 // '0xCatether Token' contract
4 // Mineable ERC20 Token using Proof Of Work
5 //
6 // Symbol      : 0xCATE
7 // Name        : 0xCatether Token
8 // Total supply: No Limit
9 // Decimals    : 4
10 //
11 // ----------------------------------------------------------------------------
12 // ----------------------------------------------------------------------------
13 // Safe maths
14 // ----------------------------------------------------------------------------
15 library SafeMath {
16     function add(uint a, uint b) internal pure returns (uint c) {
17         c = a + b;
18         require(c >= a);
19     }
20     function sub(uint a, uint b) internal pure returns (uint c) {
21         require(b <= a);
22         c = a - b;
23     }
24     function mul(uint a, uint b) internal pure returns (uint c) {
25         c = a * b;
26         require(a == 0 || c / a == b);
27     }
28     function div(uint a, uint b) internal pure returns (uint c) {
29         require(b > 0);
30         c = a / b;
31     }
32 }
33 library ExtendedMath {
34     //return the smaller of the two inputs (a or b)
35     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
36         if(a > b) return b;
37         return a;
38     }
39 }
40 // ----------------------------------------------------------------------------
41 // ERC Token Standard #20 Interface
42 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
43 // ----------------------------------------------------------------------------
44 contract ERC20Interface {
45     function totalSupply() public constant returns (uint);
46     function balanceOf(address tokenOwner) public constant returns (uint balance);
47     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
48     function transfer(address to, uint tokens) public returns (bool success);
49     function approve(address spender, uint tokens) public returns (bool success);
50     function transferFrom(address from, address to, uint tokens) public returns (bool success);
51     event Transfer(address indexed from, address indexed to, uint tokens);
52     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
53 }
54 
55 contract EIP918Interface {
56 
57     /*
58      * Externally facing mint function that is called by miners to validate challenge digests, calculate reward,
59      * populate statistics, mutate epoch variables and adjust the solution difficulty as required. Once complete,
60      * a Mint event is emitted before returning a success indicator.
61      **/
62     function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
63 
64     /*
65      * Optional
66      * Externally facing merge function that is called by miners to validate challenge digests, calculate reward,
67      * populate statistics, mutate epoch variables and adjust the solution difficulty as required. Additionally, the
68      * merge function takes an array of target token addresses to be used in merged rewards. Once complete,
69      * a Mint event is emitted before returning a success indicator.
70      **/
71     //function merge(uint256 nonce, bytes32 challenge_digest, address[] mineTokens) public returns (bool);
72 
73     /*
74      * Returns the challenge number
75      **/
76     function getChallengeNumber() public view returns (bytes32);
77 
78     /*
79      * Returns the mining difficulty. The number of digits that the digest of the PoW solution requires which 
80      * typically auto adjusts during reward generation.
81      **/
82     function getMiningDifficulty() public view returns (uint);
83 
84     /*
85      * Returns the mining target
86      **/
87     function getMiningTarget() public view returns (uint);
88 
89     /*
90      * Return the current reward amount. Depending on the algorithm, typically rewards are divided every reward era 
91      * as tokens are mined to provide scarcity
92      **/
93     function getMiningReward() public view returns (uint);
94     
95     /*
96      * Upon successful verification and reward the mint method dispatches a Mint Event indicating the reward address, 
97      * the reward amount, the epoch count and newest challenge number.
98      **/
99     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
100 
101 }
102 // ----------------------------------------------------------------------------
103 // Contract function to receive approval and execute function in one call
104 //
105 // Borrowed from MiniMeToken
106 // ----------------------------------------------------------------------------
107 contract ApproveAndCallFallBack {
108     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
109 }
110 // ----------------------------------------------------------------------------
111 // Owned contract
112 // ----------------------------------------------------------------------------
113 contract Owned {
114     address public owner;
115     address public newOwner;
116     event OwnershipTransferred(address indexed _from, address indexed _to);
117     
118     constructor() public {
119         owner = msg.sender;
120     }
121     modifier onlyOwner {
122         require(msg.sender == owner);
123         _;
124     }
125     function transferOwnership(address _newOwner) public onlyOwner {
126         newOwner = _newOwner;
127     }
128     function acceptOwnership() public {
129         require(msg.sender == newOwner);
130         emit OwnershipTransferred(owner, newOwner);
131         owner = newOwner;
132         newOwner = address(0);
133     }
134 }
135 
136 // ----------------------------------------------------------------------------
137 // ERC20 Token, with the addition of symbol, name and decimals and an
138 // initial fixed supply
139 // ----------------------------------------------------------------------------
140 contract _0xCatetherToken is ERC20Interface, EIP918Interface, Owned {
141     using SafeMath for uint;
142     using ExtendedMath for uint;
143     string public symbol;
144     string public  name;
145     uint8 public decimals;
146     uint public _totalSupply;
147     uint public latestDifficultyPeriodStarted;
148     uint public epochCount;//number of 'blocks' mined
149     //a little number
150     uint public  _MINIMUM_TARGET = 2**16;
151     //a big number is easier ; just find a solution that is smaller
152     //uint public  _MAXIMUM_TARGET = 2**224;  bitcoin uses 224
153     uint public  _MAXIMUM_TARGET = 2**224;
154     uint public miningTarget;
155     bytes32 public challengeNumber;   //generate a new one when a new reward is minted
156     address public lastRewardTo;
157     uint public lastRewardAmount;
158     uint public lastRewardEthBlockNumber;
159     // a bunch of maps to know where this is going (pun intended)
160     
161     mapping(bytes32 => bytes32) public solutionForChallenge;
162     mapping(uint => uint) public targetForEpoch;
163     mapping(uint => uint) public timeStampForEpoch;
164     mapping(address => uint) balances;
165     mapping(address => address) donationsTo;
166     mapping(address => mapping(address => uint)) allowed;
167     event Donation(address donation);
168     event DonationAddressOf(address donator, address donnationAddress);
169     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
170 
171     // ------------------------------------------------------------------------
172     // Constructor
173     // ------------------------------------------------------------------------
174     constructor() public{
175         symbol = "0xCATE";
176         name = "0xCatether Token";
177         
178         decimals = 4;
179         epochCount = 0;
180         _totalSupply = 1337000000*10**uint(decimals); 
181         
182         targetForEpoch[epochCount] = _MAXIMUM_TARGET;
183         challengeNumber = "GENESIS_BLOCK";
184         solutionForChallenge[challengeNumber] = "42"; // ahah yes
185         timeStampForEpoch[epochCount] = block.timestamp;
186         latestDifficultyPeriodStarted = block.number;
187         
188         epochCount = epochCount.add(1);
189         targetForEpoch[epochCount] = _MAXIMUM_TARGET;
190         miningTarget = _MAXIMUM_TARGET;
191         
192         balances[owner] = _totalSupply;
193         emit Transfer(address(0), owner, _totalSupply);
194     }
195 
196     function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
197         //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
198         bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
199         //the challenge digest must match the expected
200         if (digest != challenge_digest) revert();
201         //the digest must be smaller than the target
202         if(uint256(digest) > miningTarget) revert();
203         //only allow one reward for each challenge
204         bytes32 solution = solutionForChallenge[challenge_digest];
205         solutionForChallenge[challengeNumber] = digest;
206         if(solution != 0x0) revert();  //prevent the same answer from awarding twice
207         uint reward_amount = getMiningReward();
208         balances[msg.sender] = balances[msg.sender].add(reward_amount);
209         _totalSupply = _totalSupply.add(reward_amount);
210         //set readonly diagnostics data
211         lastRewardTo = msg.sender;
212         lastRewardAmount = reward_amount;
213         lastRewardEthBlockNumber = block.number;
214         _startNewMiningEpoch();
215         emit Mint(msg.sender, reward_amount, epochCount, challengeNumber );
216        return true;
217     }
218 
219     //a new 'block' to be mined
220     function _startNewMiningEpoch() internal {
221         
222         timeStampForEpoch[epochCount] = block.timestamp;
223         epochCount = epochCount.add(1);
224     
225       //Difficulty adjustment following the DigiChieldv3 implementation (Tempered-SMA)
226       // Allows more thorough protection against multi-pool hash attacks
227       // https://github.com/zawy12/difficulty-algorithms/issues/9
228         miningTarget = _reAdjustDifficulty(epochCount);
229       //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
230       //do this last since this is a protection mechanism in the mint() function
231       challengeNumber = blockhash(block.number.sub(1));
232     }
233 
234     //https://github.com/zawy12/difficulty-algorithms/issues/21
235     //readjust the target via a tempered EMA
236     function _reAdjustDifficulty(uint epoch) internal returns (uint) {
237     
238         uint timeTarget = 300;  // We want miners to spend 5 minutes to mine each 'block'
239         uint N = 6180;          //N = 1000*n, ratio between timeTarget and windowTime (31-ish minutes)
240                                 // (Ethereum doesn't handle floating point numbers very well)
241         uint elapsedTime = timeStampForEpoch[epoch.sub(1)].sub(timeStampForEpoch[epoch.sub(2)]); // will revert if current timestamp is smaller than the previous one
242         targetForEpoch[epoch] = (targetForEpoch[epoch.sub(1)].mul(10000)).div( N.mul(3920).div(N.sub(1000).add(elapsedTime.mul(1042).div(timeTarget))).add(N));
243         //              newTarget   =   Tampered EMA-retarget on the last 6 blocks (a bit more, it's an approximation)
244 	// 				Also, there's an adjust factor, in order to correct the delays induced by the time it takes for transactions to confirm
245 	//				Difficulty is adjusted to the time it takes to produce a valid hash. Here, if we set it to take 300 seconds, it will actually take 
246 	//				300 seconds + TxConfirmTime to validate that block. So, we wad a little % to correct that lag time.
247 	//				Once Ethereum scales, it will actually make block times go a tad faster. There's no perfect answer to this problem at the moment
248         latestDifficultyPeriodStarted = block.number;
249         return targetForEpoch[epoch];
250     }
251 
252     //this is a recent ethereum block hash, used to prevent pre-mining future blocks
253     function getChallengeNumber() public constant returns (bytes32) {
254         return challengeNumber;
255     }
256 
257     //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
258      function getMiningDifficulty() public constant returns (uint) {
259         return _MAXIMUM_TARGET.div(targetForEpoch[epochCount]);
260     }
261 
262     function getMiningTarget() public constant returns (uint) {
263        return targetForEpoch[epochCount];
264     }
265 
266     //There's no limit to the coin supply
267     //reward follows more or less the same emmission rate as Dogecoins'. 5 minutes per block / 105120 block in one year (roughly)
268     function getMiningReward() public constant returns (uint) {
269         bytes32 digest = solutionForChallenge[challengeNumber];
270         if(epochCount > 160000) return (50000   * 10**uint(decimals) );                                   //  14.4 M/day / ~ 1.0B Tokens in 20'000 blocks (coin supply @100'000th block ~ 150 Billions)
271         if(epochCount > 140000) return (75000   * 10**uint(decimals) );                                   //  21.6 M/day / ~ 1.5B Tokens in 20'000 blocks (coin supply @100'000th block ~ 149 Billions)
272         if(epochCount > 120000) return (125000  * 10**uint(decimals) );                                  //  36.0 M/day / ~ 2.5B Tokens in 20'000 blocks (coin supply @100'000th block ~ 146 Billions)
273         if(epochCount > 100000) return (250000  * 10**uint(decimals) );                                  //  72.0 M/day / ~ 5.0B Tokens in 20'000 blocks (coin supply @100'000th block ~ 141 Billions) (~ 1 year elapsed)
274         if(epochCount > 80000) return  (500000  * 10**uint(decimals) );                                   // 144.0 M/day / ~10.0B Tokens in 20'000 blocks (coin supply @ 80'000th block ~ 131 Billions)
275         if(epochCount > 60000) return  (1000000 * 10**uint(decimals) );                                  // 288.0 M/day / ~20.0B Tokens in 20'000 blocks (coin supply @ 60'000th block ~ 111 Billions)
276         if(epochCount > 40000) return  ((uint256(keccak256(digest)) % 2500000) * 10**uint(decimals) );   // 360.0 M/day / ~25.0B Tokens in 20'000 blocks (coin supply @ 40'000th block ~  86 Billions)
277         if(epochCount > 20000) return  ((uint256(keccak256(digest)) % 3500000) * 10**uint(decimals) );   // 504.0 M/day / ~35.0B Tokens in 20'000 blocks (coin supply @ 20'000th block ~  51 Billions)
278                                return  ((uint256(keccak256(digest)) % 5000000) * 10**uint(decimals) );                         // 720.0 M/day / ~50.0B Tokens in 20'000 blocks 
279     }
280 
281     //help debug mining software (even though challenge_digest isn't used, this function is constant and helps troubleshooting mining issues)
282     function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
283         bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
284         return digest;
285     }
286 
287     //help debug mining software
288     function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
289       bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
290       if(uint256(digest) > testTarget) revert();
291       return (digest == challenge_digest);
292     }
293 
294     // ------------------------------------------------------------------------
295     // Total supply
296     // ------------------------------------------------------------------------
297     function totalSupply() public constant returns (uint) {
298         return _totalSupply.sub(balances[address(0)]);
299     }
300 
301     // ------------------------------------------------------------------------
302     // Get the token balance for account `tokenOwner`
303     // ------------------------------------------------------------------------
304     function balanceOf(address tokenOwner) public constant returns (uint balance) {
305         return balances[tokenOwner];
306     }
307     
308     function donationTo(address tokenOwner) public constant returns (address donationAddress) {
309         return donationsTo[tokenOwner];
310     }
311     
312     function changeDonation(address donationAddress) public returns (bool success) {
313         donationsTo[msg.sender] = donationAddress;
314         
315         emit DonationAddressOf(msg.sender , donationAddress); 
316         return true;
317     
318     }
319 
320     // ------------------------------------------------------------------------
321     // Transfer the balance from token owner's account to `to` account
322     // - Owner's account must have sufficient balance to transfer
323     // - 0 value transfers are allowed
324     // ------------------------------------------------------------------------
325     function transfer(address to, uint tokens) public returns (bool success) {
326         
327         address donation = donationsTo[msg.sender];
328         balances[msg.sender] = (balances[msg.sender].sub(tokens)).add(5000); // 0.5 CATE for the sender
329         
330         balances[to] = balances[to].add(tokens);
331         balances[donation] = balances[donation].add(5000); // 0.5 CATE for the sender's donation address
332         
333         emit Transfer(msg.sender, to, tokens);
334         emit Donation(donation);
335         
336         return true;
337     }
338     
339     function transferAndDonateTo(address to, uint tokens, address donation) public returns (bool success) {
340         
341         balances[msg.sender] = (balances[msg.sender].sub(tokens)).add(5000); // 0.5 CATE for the sender
342         balances[to] = balances[to].add(tokens);
343         balances[donation] = balances[donation].add(5000); // 0.5 CATE for the sender's specified donation address
344         emit Transfer(msg.sender, to, tokens);
345         emit Donation(donation);
346         return true;
347     }
348     // ------------------------------------------------------------------------
349     // Token owner can approve for `spender` to transferFrom(...) `tokens`
350     // from the token owner's account
351     //
352     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
353     // recommends that there are no checks for the approval double-spend attack
354     // as this should be implemented in user interfaces
355     // ------------------------------------------------------------------------
356     function approve(address spender, uint tokens) public returns (bool success) {
357         allowed[msg.sender][spender] = tokens;
358         emit Approval(msg.sender, spender, tokens);
359         return true;
360     }
361 
362     // ------------------------------------------------------------------------
363     // Transfer `tokens` from the `from` account to the `to` account
364     //
365     // The calling account must already have sufficient tokens approve(...)-d
366     // for spending from the `from` account and
367     // - From account must have sufficient balance to transfer
368     // - Spender must have sufficient allowance to transfer
369     // - 0 value transfers are allowed
370     // ------------------------------------------------------------------------
371     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
372         
373         balances[from] = balances[from].sub(tokens);
374         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
375         balances[to] = balances[to].add(tokens);
376         balances[donationsTo[from]] = balances[donationsTo[from]].add(5000);     // 0.5 CATE for the sender's donation address
377         balances[donationsTo[msg.sender]] = balances[donationsTo[msg.sender]].add(5000); // 0.5 CATE for the sender
378         emit Transfer(from, to, tokens);
379         emit Donation(donationsTo[from]);
380         emit Donation(donationsTo[msg.sender]);
381         return true;
382     }
383 
384     // ------------------------------------------------------------------------
385     // Returns the amount of tokens approved by the owner that can be
386     // transferred to the spender's account
387     // ------------------------------------------------------------------------
388     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
389         return allowed[tokenOwner][spender];
390     }
391 
392     // ------------------------------------------------------------------------
393     // Token owner can approve for `spender` to transferFrom(...) `tokens`
394     // from the token owner's account. The `spender` contract function
395     // `receiveApproval(...)` is then executed
396     // ------------------------------------------------------------------------
397     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
398         allowed[msg.sender][spender] = tokens;
399         emit Approval(msg.sender, spender, tokens);
400         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
401         return true;
402     }
403 
404     // ------------------------------------------------------------------------
405     // Don't accept ETH
406     // ------------------------------------------------------------------------
407     function () public payable {
408         revert();
409     }
410     
411     // ------------------------------------------------------------------------
412     // Owner can transfer out any accidentally sent ERC20 tokens
413     // ------------------------------------------------------------------------
414     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
415         return ERC20Interface(tokenAddress).transfer(owner, tokens);
416     }
417 }