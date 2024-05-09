1 pragma solidity ^0.4.23;
2 
3 // Symbol      : GZM
4 
5 // Name        : Arma Coin
6 
7 // Max supply: 1,000,000,000.00
8 
9 // Decimals    : 8
10 //
11 // ----------------------------------------------------------------------------
12 // ----------------------------------------------------------------------------
13 // Safe maths
14 // ----------------------------------------------------------------------------
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that revert on error
18  */
19 library SafeMath {
20     function add(uint a, uint b) internal pure returns (uint c) {
21         c = a + b;
22         require(c >= a);
23         return c;
24     }
25     function sub(uint a, uint b) internal pure returns (uint c) {
26         require(b <= a);
27         c = a - b;
28     }
29     function mul(uint a, uint b) internal pure returns (uint c) {
30         c = a * b;
31         require(a == 0 || c / a == b);
32     }
33     function div(uint a, uint b) internal pure returns (uint c) {
34         require(b > 0);
35         c = a / b;
36     }
37 }
38 library ExtendedMath {
39     //return the smaller of the two inputs (a or b)
40     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
41         if(a > b) return b;
42         return a;
43     }
44 }
45 // ----------------------------------------------------------------------------
46 // ERC Token Standard #20 Interface
47 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
48 // ----------------------------------------------------------------------------
49 contract ERC20Interface {
50     function totalSupply() public constant returns (uint);
51     function balanceOf(address tokenOwner) public constant returns (uint balance);
52     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
53     function transfer(address to, uint tokens) public returns (bool success);
54     function approve(address spender, uint tokens) public returns (bool success);
55     function transferFrom(address from, address to, uint tokens) public returns (bool success);
56     event Transfer(address indexed from, address indexed to, uint tokens);
57     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
58 }
59 
60 contract EIP918Interface {
61 
62     /*
63      * Externally facing mint function that is called by miners to validate challenge digests, calculate reward,
64      * populate statistics, mutate epoch variables and adjust the solution difficulty as required. Once complete,
65      * a Mint event is emitted before returning a success indicator.
66      **/
67     function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success);
68 
69     /*
70      * Optional
71      * Externally facing merge function that is called by miners to validate challenge digests, calculate reward,
72      * populate statistics, mutate epoch variables and adjust the solution difficulty as required. Additionally, the
73      * merge function takes an array of target token addresses to be used in merged rewards. Once complete,
74      * a Mint event is emitted before returning a success indicator.
75      **/
76     //function merge(uint256 nonce, bytes32 challenge_digest, address[] mineTokens) public returns (bool);
77 
78     /*
79      * Returns the challenge number
80      **/
81     function getChallengeNumber() public view returns (bytes32);
82 
83     /*
84      * Returns the mining difficulty. The number of digits that the digest of the PoW solution requires which 
85      * typically auto adjusts during reward generation.
86      **/
87     function getMiningDifficulty() public view returns (uint);
88 
89     /*
90      * Returns the mining target
91      **/
92     function getMiningTarget() public view returns (uint);
93 
94     /*
95      * Return the current reward amount. Depending on the algorithm, typically rewards are divided every reward era 
96      * as tokens are mined to provide scarcity
97      **/
98     function getMiningReward() public view returns (uint);
99     
100     /*
101      * Upon successful verification and reward the mint method dispatches a Mint Event indicating the reward address, 
102      * the reward amount, the epoch count and newest challenge number.
103      **/
104     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
105 
106 }
107 // ----------------------------------------------------------------------------
108 // Contract function to receive approval and execute function in one call
109 //
110 // Borrowed from MiniMeToken
111 // ----------------------------------------------------------------------------
112 contract ApproveAndCallFallBack {
113     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
114 }
115 // ----------------------------------------------------------------------------
116 // Owned contract
117 // ----------------------------------------------------------------------------
118 contract Owned {
119     address public owner;
120     address public newOwner;
121     event OwnershipTransferred(address indexed _from, address indexed _to);
122     
123     constructor() public {
124         owner = msg.sender;
125     }
126     modifier onlyOwner {
127         require(msg.sender == owner);
128         _;
129     }
130     function transferOwnership(address _newOwner) public onlyOwner {
131         newOwner = _newOwner;
132     }
133     function acceptOwnership() public {
134         require(msg.sender == newOwner);
135         emit OwnershipTransferred(owner, newOwner);
136         owner = newOwner;
137         newOwner = address(0);
138     }
139 }
140 
141 // ----------------------------------------------------------------------------
142 // ERC20 Token, with the addition of symbol, name and decimals and an
143 // initial fixed supply
144 // ----------------------------------------------------------------------------
145 contract _RowanCoin is ERC20Interface, EIP918Interface, Owned {
146     using SafeMath for uint;
147     using ExtendedMath for uint;
148     string public symbol;
149     string public  name;
150     uint8 public decimals;
151     uint public _maxSupply;
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
166     uint public _MAX_MESSAGE_LENGTH = 360;
167     
168     mapping(bytes32 => bytes32) public solutionForChallenge;
169     mapping(uint => uint) public targetForEpoch;
170     mapping(uint => uint) public timeStampForEpoch;
171     mapping(address => uint) balances;
172     mapping(address => address) donationsTo;
173     mapping(address => mapping(address => uint)) allowed;
174     mapping(address => string) public messages;
175     event Donation(address donation);
176     event DonationAddressOf(address donator, address donnationAddress);
177     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
178 
179     // ------------------------------------------------------------------------
180     // Constructor
181     // ------------------------------------------------------------------------
182     constructor() public{
183         symbol = "GZM";
184         name = "Arma Coin";
185         
186         decimals = 8;
187         epochCount = 0;
188         _maxSupply = 1000000000*10**uint(decimals); 
189         _totalSupply = 300000000*10**uint(decimals); 
190         
191         
192         targetForEpoch[epochCount] = _MAXIMUM_TARGET;
193         challengeNumber = "GENESIS_BLOCK";
194         solutionForChallenge[challengeNumber] = "42"; // ahah yes
195         timeStampForEpoch[epochCount] = block.timestamp;
196         latestDifficultyPeriodStarted = block.number;
197         
198         epochCount = epochCount.add(1);
199         targetForEpoch[epochCount] = _MAXIMUM_TARGET;
200         miningTarget = _MAXIMUM_TARGET;
201         
202         balances[owner] = _totalSupply;
203         emit Transfer(address(0), owner, _totalSupply);
204     }
205 
206     function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
207         //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
208         bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
209         //the challenge digest must match the expected
210         if (digest != challenge_digest) revert();
211         //the digest must be smaller than the target
212         if(uint256(digest) > miningTarget) revert();
213         //only allow one reward for each challenge
214         bytes32 solution = solutionForChallenge[challenge_digest];
215         solutionForChallenge[challengeNumber] = digest;
216         if(solution != 0x0) revert();  //prevent the same answer from awarding twice
217         uint reward_amount = getMiningReward();
218         // minting limit is _maxSupply
219         require ( _totalSupply.add(reward_amount) <= _maxSupply);
220         balances[msg.sender] = balances[msg.sender].add(reward_amount);
221         _totalSupply = _totalSupply.add(reward_amount);
222         //set readonly diagnostics data
223         lastRewardTo = msg.sender;
224         lastRewardAmount = reward_amount;
225         lastRewardEthBlockNumber = block.number;
226         _startNewMiningEpoch();
227         emit Mint(msg.sender, reward_amount, epochCount, challengeNumber );
228        return true;
229     }
230 
231     function strConcat(string _a, string _b) internal returns (string){
232         bytes memory _ba = bytes(_a);
233         bytes memory _bb = bytes(_b);
234         string memory ab = new string(_ba.length + _bb.length );
235         bytes memory ba = bytes(ab);
236         uint k = 0;
237         for (uint i = 0; i < _ba.length; i++) ba[k++] = _ba[i];
238         for (i = 0; i < _bb.length; i++) ba[k++] = _bb[i];
239         return string(ba);
240     }
241 
242     function addMessage(address advertiser, string newMessage) public {
243         bytes memory bs = bytes(newMessage);
244         require (bs.length <= _MAX_MESSAGE_LENGTH );
245         require (balances[msg.sender] >= 100000000);
246         balances[msg.sender] = balances[msg.sender].sub(100000000);
247         balances[advertiser] = balances[advertiser].add(100000000);
248         messages[advertiser] = strConcat( messages[advertiser], "\n");
249         messages[advertiser] = strConcat( messages[advertiser], newMessage);
250         emit Transfer(msg.sender, advertiser, 100000000);
251     }
252 
253     //a new 'block' to be mined
254     function _startNewMiningEpoch() internal {
255         
256         timeStampForEpoch[epochCount] = block.timestamp;
257         epochCount = epochCount.add(1);
258     
259       //Difficulty adjustment following the DigiChieldv3 implementation (Tempered-SMA)
260       // Allows more thorough protection against multi-pool hash attacks
261       // https://github.com/zawy12/difficulty-algorithms/issues/9
262         miningTarget = _reAdjustDifficulty(epochCount);
263       //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
264       //do this last since this is a protection mechanism in the mint() function
265       challengeNumber = blockhash(block.number.sub(1));
266     }
267 
268     //https://github.com/zawy12/difficulty-algorithms/issues/21
269     //readjust the target via a tempered EMA
270     function _reAdjustDifficulty(uint epoch) internal returns (uint) {
271     
272         uint timeTarget = 300;  // We want miners to spend 5 minutes to mine each 'block'
273         uint N = 6180;          //N = 1000*n, ratio between timeTarget and windowTime (31-ish minutes)
274                                 // (Ethereum doesn't handle floating point numbers very well)
275         uint elapsedTime = timeStampForEpoch[epoch.sub(1)].sub(timeStampForEpoch[epoch.sub(2)]); // will revert if current timestamp is smaller than the previous one
276         targetForEpoch[epoch] = (targetForEpoch[epoch.sub(1)].mul(10000)).div( N.mul(3920).div(N.sub(1000).add(elapsedTime.mul(1042).div(timeTarget))).add(N));
277         //              newTarget   =   Tampered EMA-retarget on the last 6 blocks (a bit more, it's an approximation)
278 	// 				Also, there's an adjust factor, in order to correct the delays induced by the time it takes for transactions to confirm
279 	//				Difficulty is adjusted to the time it takes to produce a valid hash. Here, if we set it to take 300 seconds, it will actually take 
280 	//				300 seconds + TxConfirmTime to validate that block. So, we wad a little % to correct that lag time.
281 	//				Once Ethereum scales, it will actually make block times go a tad faster. There's no perfect answer to this problem at the moment
282         latestDifficultyPeriodStarted = block.number;
283         return targetForEpoch[epoch];
284     }
285 
286     //this is a recent ethereum block hash, used to prevent pre-mining future blocks
287     function getChallengeNumber() public constant returns (bytes32) {
288         return challengeNumber;
289     }
290 
291     //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
292      function getMiningDifficulty() public constant returns (uint) {
293         return _MAXIMUM_TARGET.div(targetForEpoch[epochCount]);
294     }
295 
296     function getMiningTarget() public constant returns (uint) {
297        return targetForEpoch[epochCount];
298     }
299 
300     //There's no limit to the coin supply
301     //reward follows more or less the same emmission rate as coins'. 5 minutes per block / 105120 block in one year (roughly)
302     function getMiningReward() public constant returns (uint) {
303         bytes32 digest = solutionForChallenge[challengeNumber];
304         if(epochCount > 160000) return (50000   * 10**uint(decimals) );                                   //  14.4 M/day / ~ 1.0B Tokens in 20'000 blocks (coin supply @100'000th block ~ 150 Billions)
305         if(epochCount > 140000) return (75000   * 10**uint(decimals) );                                   //  21.6 M/day / ~ 1.5B Tokens in 20'000 blocks (coin supply @100'000th block ~ 149 Billions)
306         if(epochCount > 120000) return (125000  * 10**uint(decimals) );                                  //  36.0 M/day / ~ 2.5B Tokens in 20'000 blocks (coin supply @100'000th block ~ 146 Billions)
307         if(epochCount > 100000) return (250000  * 10**uint(decimals) );                                  //  72.0 M/day / ~ 5.0B Tokens in 20'000 blocks (coin supply @100'000th block ~ 141 Billions) (~ 1 year elapsed)
308         if(epochCount > 80000) return  (500000  * 10**uint(decimals) );                                   // 144.0 M/day / ~10.0B Tokens in 20'000 blocks (coin supply @ 80'000th block ~ 131 Billions)
309         if(epochCount > 60000) return  (1000000 * 10**uint(decimals) );                                  // 288.0 M/day / ~20.0B Tokens in 20'000 blocks (coin supply @ 60'000th block ~ 111 Billions)
310         if(epochCount > 40000) return  ((uint256(keccak256(digest)) % 2500000) * 10**uint(decimals) );   // 360.0 M/day / ~25.0B Tokens in 20'000 blocks (coin supply @ 40'000th block ~  86 Billions)
311         if(epochCount > 20000) return  ((uint256(keccak256(digest)) % 3500000) * 10**uint(decimals) );   // 504.0 M/day / ~35.0B Tokens in 20'000 blocks (coin supply @ 20'000th block ~  51 Billions)
312                                return  ((uint256(keccak256(digest)) % 5000000) * 10**uint(decimals) );                         // 720.0 M/day / ~50.0B Tokens in 20'000 blocks 
313     }
314 
315     //help debug mining software (even though challenge_digest isn't used, this function is constant and helps troubleshooting mining issues)
316     function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
317         bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
318         return digest;
319     }
320 
321     //help debug mining software
322     function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
323       bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
324       if(uint256(digest) > testTarget) revert();
325       return (digest == challenge_digest);
326     }
327 
328     // ------------------------------------------------------------------------
329     // Total supply
330     // ------------------------------------------------------------------------
331     function totalSupply() public constant returns (uint) {
332         return _totalSupply.sub(balances[address(0)]);
333     }
334 
335     // ------------------------------------------------------------------------
336     // Get the token balance for account `tokenOwner`
337     // ------------------------------------------------------------------------
338     function balanceOf(address tokenOwner) public constant returns (uint balance) {
339         return balances[tokenOwner];
340     }
341     
342     function donationTo(address tokenOwner) public constant returns (address donationAddress) {
343         return donationsTo[tokenOwner];
344     }
345     
346     function changeDonation(address donationAddress) public returns (bool success) {
347         donationsTo[msg.sender] = donationAddress;
348         
349         emit DonationAddressOf(msg.sender , donationAddress); 
350         return true;
351     
352     }
353 
354     // ------------------------------------------------------------------------
355     // Transfer the balance from token owner's account to `to` account
356     // - Owner's account must have sufficient balance to transfer
357     // - 0 value transfers are allowed
358     // ------------------------------------------------------------------------
359     function transfer(address to, uint tokens) public returns (bool success) {
360         
361         address donation = donationsTo[msg.sender];
362         balances[msg.sender] = (balances[msg.sender].sub(tokens)).add(5000); // 0.5 RWN for the sender
363         
364         balances[to] = balances[to].add(tokens);
365         balances[donation] = balances[donation].add(5000); // 0.5 GZM for the sender's donation address
366         
367         emit Transfer(msg.sender, to, tokens);
368         emit Donation(donation);
369         
370         return true;
371     }
372     
373     function transferAndDonateTo(address to, uint tokens, address donation) public returns (bool success) {
374         
375         balances[msg.sender] = (balances[msg.sender].sub(tokens)).add(5000); // 0.5 GZM for the sender
376         balances[to] = balances[to].add(tokens);
377         balances[donation] = balances[donation].add(5000); // 0.5 GZM for the sender's specified donation address
378         emit Transfer(msg.sender, to, tokens);
379         emit Donation(donation);
380         return true;
381     }
382     // ------------------------------------------------------------------------
383     // Token owner can approve for `spender` to transferFrom(...) `tokens`
384     // from the token owner's account
385     //
386     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
387     // recommends that there are no checks for the approval double-spend attack
388     // as this should be implemented in user interfaces
389     // ------------------------------------------------------------------------
390     function approve(address spender, uint tokens) public returns (bool success) {
391         allowed[msg.sender][spender] = tokens;
392         emit Approval(msg.sender, spender, tokens);
393         return true;
394     }
395 
396     // ------------------------------------------------------------------------
397     // Transfer `tokens` from the `from` account to the `to` account
398     //
399     // The calling account must already have sufficient tokens approve(...)-d
400     // for spending from the `from` account and
401     // - From account must have sufficient balance to transfer
402     // - Spender must have sufficient allowance to transfer
403     // - 0 value transfers are allowed
404     // ------------------------------------------------------------------------
405     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
406         
407         balances[from] = balances[from].sub(tokens);
408         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
409         balances[to] = balances[to].add(tokens);
410         balances[donationsTo[from]] = balances[donationsTo[from]].add(5000);     // 0.5 GZM for the sender's donation address
411         balances[donationsTo[msg.sender]] = balances[donationsTo[msg.sender]].add(5000); // 0.5 GZM for the sender
412         emit Transfer(from, to, tokens);
413         emit Donation(donationsTo[from]);
414         emit Donation(donationsTo[msg.sender]);
415         return true;
416     }
417 
418     // ------------------------------------------------------------------------
419     // Returns the amount of tokens approved by the owner that can be
420     // transferred to the spender's account
421     // ------------------------------------------------------------------------
422     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
423         return allowed[tokenOwner][spender];
424     }
425 
426     // ------------------------------------------------------------------------
427     // Token owner can approve for `spender` to transferFrom(...) `tokens`
428     // from the token owner's account. The `spender` contract function
429     // `receiveApproval(...)` is then executed
430     // ------------------------------------------------------------------------
431     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
432         allowed[msg.sender][spender] = tokens;
433         emit Approval(msg.sender, spender, tokens);
434         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
435         return true;
436     }
437 
438     // ------------------------------------------------------------------------
439     // Don't accept ETH
440     // ------------------------------------------------------------------------
441     function () public payable {
442         revert();
443     }
444     
445     // ------------------------------------------------------------------------
446     // Owner can transfer out any accidentally sent ERC20 tokens
447     // ------------------------------------------------------------------------
448     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
449         return ERC20Interface(tokenAddress).transfer(owner, tokens);
450     }
451 }