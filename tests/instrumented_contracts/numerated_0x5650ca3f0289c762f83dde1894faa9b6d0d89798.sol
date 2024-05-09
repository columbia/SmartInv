1 pragma solidity ^0.4.18;
2 
3 
4 
5 
6 library SafeMath 
7    {
8    function add(uint a, uint b) internal pure returns (uint c) 
9       {
10       c = a + b;
11       require(c >= a);
12       }
13 
14    function sub(uint a, uint b) internal pure returns (uint c) 
15       {
16       require(b <= a);
17       c = a - b;
18       }
19 
20    function mul(uint a, uint b) internal pure returns (uint c) 
21       {
22       c = a * b;
23       require(a == 0 || c / a == b);
24       }
25 
26    function div(uint a, uint b) internal pure returns (uint c) 
27       {
28       require(b > 0);
29       c = a / b;
30       }
31    }
32 
33 
34 
35 library ExtendedMath 
36    {
37    //return the smaller of the two inputs (a or b)
38    function limitLessThan(uint a, uint b) internal pure returns (uint c) 
39       {
40       if(a > b) return b;
41       return a;
42       }
43    }
44 
45 
46 
47 
48 contract ERC20Interface 
49    {
50    function totalSupply() public constant returns (uint);
51    function balanceOf(address tokenOwner) public constant returns (uint balance);
52    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
53    function transfer(address to, uint tokens) public returns (bool success);
54    function approve(address spender, uint tokens) public returns (bool success);
55    function transferFrom(address from, address to, uint tokens) public returns (bool success);
56    event Transfer(address indexed from, address indexed to, uint tokens);
57    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
58    }
59 
60 
61 
62 
63 
64 contract ApproveAndCallFallBack 
65    {
66    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
67    }
68 
69 
70 
71 // ----------------------------------------------------------------------------
72 // Owned contract
73 // ----------------------------------------------------------------------------
74 
75 contract Owned 
76    {
77    address public owner;
78    address public newOwner;
79 
80    event OwnershipTransferred(address indexed _from, address indexed _to);
81 
82    function Owned() public 
83       {
84       owner = msg.sender;
85       }
86 
87 
88    modifier onlyOwner 
89       {
90       require(msg.sender == owner);
91       _;
92       }
93 
94 
95    function transferOwnership(address _newOwner) public onlyOwner 
96       {
97       newOwner = _newOwner;
98       }
99 
100    function acceptOwnership() public 
101       {
102       require(msg.sender == newOwner);
103       OwnershipTransferred(owner, newOwner);
104       owner = newOwner;
105       newOwner = address(0);
106       }
107    }
108 
109 
110 
111 // ----------------------------------------------------------------------------
112 // ERC20 Token, with the addition of symbol, name and decimals and an
113 // initial fixed supply
114 // ----------------------------------------------------------------------------
115 
116 contract _BlockXToken is ERC20Interface, Owned 
117    {
118    using SafeMath for uint;
119    using ExtendedMath for uint;
120    string public symbol;
121    string public  name;
122    uint8 public decimals;
123    uint public _totalSupply;
124    uint public latestDifficultyPeriodStarted;
125    uint public epochCount; //number of 'blocks' mined
126    uint public _BLOCKS_PER_READJUSTMENT = 4;
127 
128    //a little number
129    uint public  _MINIMUM_TARGET = 2**16;
130    //a big number is easier, just find a solution that is smaller
131    //uint public  _MAXIMUM_TARGET = 2**224;  bitcoin uses 224
132    uint public  _MAXIMUM_TARGET = 2**234;
133 
134    uint public miningTarget;
135    bytes32 public challengeNumber;   //generate a new one when a new reward is minted
136    uint public rewardEra;
137    uint public maxSupplyForEra;
138    address public lastRewardTo;
139    uint public lastRewardAmount;
140    uint public lastRewardEthBlockNumber;
141    bool locked = false;
142    mapping(bytes32 => bytes32) solutionForChallenge;
143    uint public tokensMinted;
144    mapping(address => uint) balances;
145    mapping(address => mapping(address => uint)) allowed;
146    mapping(address => bool) public frozenAccount;   // Array of frozen accounts
147    mapping(address => bool) public whitelistedAccount;   //   Array of whitelisted accounts
148    event FrozenFunds(address target, bool frozen);
149    event whitelistedFunds(address target, bool whitelisted);
150 
151 
152    event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
153    // ------------------------------------------------------------------------
154    // Constructor
155    // ------------------------------------------------------------------------
156    function _BlockXToken() public onlyOwner 
157       {
158       symbol = "BLKX";
159       name = "Block X Token";
160       decimals = 8;
161       _totalSupply = 10000000000 * 10**uint(decimals);
162       if(locked) revert();
163       locked = true;
164       tokensMinted = 0;
165       rewardEra = 0;
166       maxSupplyForEra = _totalSupply.div(2);
167       miningTarget = _MAXIMUM_TARGET;
168       latestDifficultyPeriodStarted = block.number;
169       _startNewMiningEpoch();
170       }
171 
172 
173 
174 
175    function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) 
176       {
177       if (whitelistedAccount[msg.sender]) 
178          {
179          //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
180          bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
181          //the challenge digest must match the expected
182 
183          if (digest != challenge_digest) revert();
184 
185          //the digest must be smaller than the target
186          if(uint256(digest) > miningTarget) revert();
187 
188          //only allow one reward for each challenge
189          bytes32 solution = solutionForChallenge[challengeNumber];
190          solutionForChallenge[challengeNumber] = digest;
191          if(solution != 0x0) revert();  //prevent the same answer from awarding twice
192 
193          uint reward_amount = getMiningReward();
194          balances[msg.sender] = balances[msg.sender].add(reward_amount);
195          tokensMinted = tokensMinted.add(reward_amount);
196 
197          //Cannot mint more tokens than there are
198          assert(tokensMinted <= maxSupplyForEra);
199          assert(tokensMinted <= _totalSupply);
200 
201          //set readonly diagnostics data
202          lastRewardTo = msg.sender;
203          lastRewardAmount = reward_amount;
204          lastRewardEthBlockNumber = block.number;
205 
206          _startNewMiningEpoch();
207 
208          Mint(msg.sender, reward_amount, epochCount, challengeNumber );
209 
210          return true;
211          }
212 
213       else 
214          {
215          return false;
216          }
217 
218       }
219 
220 
221    //a new 'block' to be mined
222    function _startNewMiningEpoch() internal 
223       {
224       //if max supply for the era will be exceeded next reward round then enter the new era before that happens
225       //4 is the final reward era, almost all tokens minted
226       //once the final era is reached, more tokens will not be given out because the assert function
227 
228       if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 4)
229          {
230          rewardEra = rewardEra + 1;
231          }
232 
233       //set the next minted supply at which the era will change
234       // total supply is 1000000000000000000  because of 8 decimal places
235       maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
236 
237       epochCount = epochCount.add(1);
238 
239       //every so often, readjust difficulty. Dont readjust when deploying
240       if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
241          {
242          _reAdjustDifficulty();
243          }
244 
245       //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
246       //do this last since this is a protection mechanism in the mint() function
247       challengeNumber = block.blockhash(block.number - 1);
248       }
249 
250 
251 
252    function _reAdjustDifficulty() internal 
253       {
254       uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
255       //assume 270 ethereum blocks per hour
256 
257       //we want miners to spend 10 minutes to mine each 'block', about 45 ethereum blocks = one Block X Token epoch
258       uint epochsMined = _BLOCKS_PER_READJUSTMENT; //256
259 
260       uint targetEthBlocksPerDiffPeriod = epochsMined * 45; //should be 45 times slower than ethereum
261 
262       //if there were less eth blocks passed in time than expected
263       if( ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod )
264          {
265          uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div( ethBlocksSinceLastDifficultyPeriod );
266 
267          uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
268          // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.
269 
270          //make it harder
271          miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %
272          }
273 
274       else
275          {
276          uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div( targetEthBlocksPerDiffPeriod );
277 
278          uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
279 
280          //make it easier
281          miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %
282          }
283 
284 
285 
286       latestDifficultyPeriodStarted = block.number;
287 
288       if(miningTarget < _MINIMUM_TARGET) //very difficult
289          {
290          miningTarget = _MINIMUM_TARGET;
291          }
292 
293       if(miningTarget > _MAXIMUM_TARGET) //very easy
294          {
295          miningTarget = _MAXIMUM_TARGET;
296          }
297       }
298 
299 
300    //this is a recent ethereum block hash, used to prevent pre-mining future blocks
301    function getChallengeNumber() public constant returns (bytes32) 
302       {
303       return challengeNumber;
304       }
305 
306    //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
307    function getMiningDifficulty() public constant returns (uint) 
308       {
309       return _MAXIMUM_TARGET.div(miningTarget);
310       }
311 
312    function getMiningTarget() public constant returns (uint) 
313       {
314       return miningTarget;
315       }
316 
317 
318 
319    //10,000,000,000 coins total
320    //reward begins at 100,000 and is cut in half every reward era (as tokens are mined)
321    function getMiningReward() public constant returns (uint) 
322       {
323       //once we get half way thru the coins, only get 50,000 per block
324       //every reward era, the reward amount halves.
325       return (100000 * 10**uint(decimals) ).div( 2**rewardEra ) ;
326       }
327 
328    //help debug mining software
329    function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) 
330       {
331       bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
332 
333       if (challenge_digest == 9643712) 
334          {
335          //suppress the warning
336          }
337 
338       return digest;
339       }
340 
341    //help debug mining software
342    function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) 
343       {
344       bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
345       if(uint256(digest) > testTarget) revert();
346       return (digest == challenge_digest);
347       }
348 
349 
350 
351    // ------------------------------------------------------------------------
352    // Total supply
353    // ------------------------------------------------------------------------
354 
355    function totalSupply() public constant returns (uint) 
356       {
357       return _totalSupply  - balances[address(0)];
358       }
359 
360 
361 
362    // ------------------------------------------------------------------------
363    // Get the token balance for account `tokenOwner`
364    // ------------------------------------------------------------------------
365 
366    function balanceOf(address tokenOwner) public constant returns (uint balance) 
367       {
368       return balances[tokenOwner];
369       }
370 
371 
372 
373    // ------------------------------------------------------------------------
374    // Transfer the balance from token owner's account to `to` account
375    // - Owner's account must have sufficient balance to transfer
376    // - 0 value transfers are allowed
377    // ------------------------------------------------------------------------
378 
379    function transfer(address to, uint tokens) public returns (bool success) 
380       {
381       // Checks if sender has enough balance, checks for overflows, and checks if the sender or to accounts are frozen
382       if ((balances[msg.sender] < tokens) || (balances[to] + tokens < balances[to]) || (frozenAccount[msg.sender]) || (frozenAccount[to])) 
383          {
384          return false;
385          }
386 
387       else 
388          {
389          balances[msg.sender] = balances[msg.sender].sub(tokens);
390          balances[to] = balances[to].add(tokens);
391          Transfer(msg.sender, to, tokens);
392          return true;
393         }
394     }
395 
396 
397 
398    // ------------------------------------------------------------------------
399    // Token owner can approve for `spender` to transferFrom(...) `tokens`
400    // from the token owner's account
401    //
402    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
403    // recommends that there are no checks for the approval double-spend attack
404    // as this should be implemented in user interfaces
405    // ------------------------------------------------------------------------
406    function approve(address spender, uint tokens) public returns (bool success) 
407       {
408       if ((frozenAccount[msg.sender]) || (frozenAccount[spender])) 
409          {
410          return false;
411          }
412 
413       else 
414          {
415          allowed[msg.sender][spender] = tokens;
416          Approval(msg.sender, spender, tokens);
417          return true;
418          }
419       }
420 
421 
422 
423    // ------------------------------------------------------------------------
424    // Transfer `tokens` from the `from` account to the `to` account
425    //
426    // The calling account must already have sufficient tokens approve(...)-d
427    // for spending from the `from` account and
428    // - From account must have sufficient balance to transfer
429    // - Spender must have sufficient allowance to transfer
430    // - 0 value transfers are allowed
431    // ------------------------------------------------------------------------
432 
433    function transferFrom(address from, address to, uint tokens) public returns (bool success) 
434       {
435       if ((frozenAccount[msg.sender]) || (frozenAccount[from]) || (frozenAccount[to])) 
436          {
437          return false;
438          }
439 
440       else 
441          {
442          balances[from] = balances[from].sub(tokens);
443          allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
444          balances[to] = balances[to].add(tokens);
445          Transfer(from, to, tokens);
446          return true;
447          }
448       }
449 
450 
451 
452    // ------------------------------------------------------------------------
453    // Returns the amount of tokens approved by the owner that can be
454    // transferred to the spender's account
455    // ------------------------------------------------------------------------
456 
457    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) 
458       {
459       return allowed[tokenOwner][spender];
460       }
461 
462 
463 
464    // ------------------------------------------------------------------------
465    // Token owner can approve for `spender` to transferFrom(...) `tokens`
466    // from the token owner's account. The `spender` contract function
467    // `receiveApproval(...)` is then executed
468    // ------------------------------------------------------------------------
469 
470    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) 
471       {
472       if ((frozenAccount[msg.sender]) || (frozenAccount[spender])) 
473          {
474          return false;
475          }
476 
477       else 
478          {
479          allowed[msg.sender][spender] = tokens;
480          Approval(msg.sender, spender, tokens);
481          ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
482          return true;
483          }
484       }
485 
486 
487 
488 
489    function freezeAccount(address target, bool freeze) public onlyOwner 
490       {
491       frozenAccount[target] = freeze;
492       FrozenFunds(target, freeze);
493       }
494 
495 
496    function whitelistAccount(address target, bool whitelist) public onlyOwner 
497       {
498       whitelistedAccount[target] = whitelist;
499       whitelistedFunds(target, whitelist);
500       }
501 
502 
503 
504 
505 
506 
507    // ------------------------------------------------------------------------
508    // Don't accept ETH
509    // ------------------------------------------------------------------------
510 
511    function () public payable 
512       {
513       revert();
514       }
515 
516 
517 
518    // ------------------------------------------------------------------------
519    // Owner can transfer out any accidentally sent ERC20 tokens
520    // ------------------------------------------------------------------------
521 
522    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) 
523       {
524       return ERC20Interface(tokenAddress).transfer(owner, tokens);
525       }
526 
527 
528    }