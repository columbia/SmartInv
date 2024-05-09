1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function add(uint a, uint b) internal pure returns (uint c) {
5     c = a + b;
6     require(c >= a);
7   }
8 
9   function sub(uint a, uint b) internal pure returns (uint c) {
10     require(b <= a);
11     c = a - b;
12   }
13 
14   function mul(uint a, uint b) internal pure returns (uint c) {
15     c = a * b;
16     require(a == 0 || c / a == b);
17   }
18 
19   function div(uint a, uint b) internal pure returns (uint c) {
20     require(b > 0);
21     c = a / b;
22   }
23 }
24 
25 library ExtendedMath {
26 
27   //return the smaller of the two inputs (a or b)
28   function limitLessThan(uint a, uint b) internal pure returns (uint c) {
29     if(a > b) return b;
30     return a;
31   }
32 }
33 
34 contract ERC20Interface {
35   function totalSupply() public constant returns (uint);
36   function balanceOf(address tokenOwner) public constant returns (uint balance);
37   function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
38   function transfer(address to, uint tokens) public returns (bool success);
39   function approve(address spender, uint tokens) public returns (bool success);
40   function transferFrom(address from, address to, uint tokens) public returns (bool success);
41   event Transfer(address indexed from, address indexed to, uint tokens);
42   event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
43 }
44 
45 contract ApproveAndCallFallBack {
46   function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
47 }
48 
49 contract Owned {
50 
51   address public owner;
52   address public newOwner;
53   event OwnershipTransferred(address indexed _from, address indexed _to);
54 
55   function Owned() public {
56     owner = msg.sender;
57   }
58 
59   modifier onlyOwner {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   function transferOwnership(address _newOwner) public onlyOwner {
65     newOwner = _newOwner;
66   }
67 
68   function acceptOwnership() public {
69     require(msg.sender == newOwner);
70     OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72     newOwner = address(0);
73   }
74 }
75 
76 contract Lira is ERC20Interface, Owned {
77 
78   bool locked = false;
79   bytes32 public challengeNumber;
80   address public lastRewardTo;
81   using SafeMath for uint;
82   using ExtendedMath for uint;
83   string public symbol;
84   string public  name;
85   uint8 public decimals;
86   uint public _totalSupply;
87   uint public latestDifficultyPeriodStarted;
88   uint public epochCount; // Blocks mined
89   uint public _BLOCKS_PER_READJUSTMENT = 1024;
90   uint public  _MINIMUM_TARGET = 2**16;
91   uint public  _MAXIMUM_TARGET = 2**234;
92   uint public miningTarget;
93   uint public rewardEra;
94   uint public maxSupplyForEra;
95   uint public lastRewardAmount;
96   uint public lastRewardEthBlockNumber;
97   uint public tokensMinted;
98 
99   mapping(bytes32 => bytes32) solutionForChallenge;
100   mapping(address => uint) balances;
101   mapping(address => mapping(address => uint)) allowed;
102 
103   event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
104 
105   function Lira() public onlyOwner{
106 
107     symbol = "LIRA";
108     name = "Lira Cash";
109     decimals = 8;
110 
111     _totalSupply = 21000000 * 10**uint(decimals);
112 
113     if(locked) revert();
114     locked = true;
115     tokensMinted = 0;
116     rewardEra = 0;
117     maxSupplyForEra = _totalSupply.div(2);
118     miningTarget = _MAXIMUM_TARGET;
119     latestDifficultyPeriodStarted = block.number;
120     _startNewMiningEpoch();
121 
122   }
123 
124   function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
125 
126     bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
127 
128     if (digest != challenge_digest) revert();
129     if(uint256(digest) > miningTarget) revert();
130 
131     bytes32 solution = solutionForChallenge[challengeNumber];
132     solutionForChallenge[challengeNumber] = digest;
133 
134     // Prevent duplicate answers and duplicate rewards
135     if(solution != 0x0) revert();
136 
137     uint reward_amount = getMiningReward();
138     balances[msg.sender] = balances[msg.sender].add(reward_amount);
139     tokensMinted = tokensMinted.add(reward_amount);
140     assert(tokensMinted <= maxSupplyForEra);
141 
142     lastRewardTo = msg.sender;
143     lastRewardAmount = reward_amount;
144     lastRewardEthBlockNumber = block.number;
145     _startNewMiningEpoch();
146 
147     Mint(msg.sender, reward_amount, epochCount, challengeNumber );
148     return true;
149   }
150 
151   function _startNewMiningEpoch() internal {
152 
153     if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 39){
154       rewardEra = rewardEra + 1;
155     }
156 
157     maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
158     epochCount = epochCount.add(1);
159 
160     if(epochCount % _BLOCKS_PER_READJUSTMENT == 0){
161       _reAdjustDifficulty();
162     }
163 
164     challengeNumber = block.blockhash(block.number - 1);
165 
166   }
167 
168   function _reAdjustDifficulty() internal {
169 
170     uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
171     uint epochsMined = _BLOCKS_PER_READJUSTMENT; //256
172     uint targetEthBlocksPerDiffPeriod = epochsMined * 60;
173 
174     if( ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod ){
175       uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div( ethBlocksSinceLastDifficultyPeriod );
176       uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
177       miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));
178     } else {
179       uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div( targetEthBlocksPerDiffPeriod );
180       uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000);
181       miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));
182     }
183 
184     latestDifficultyPeriodStarted = block.number;
185 
186     if(miningTarget < _MINIMUM_TARGET){
187       miningTarget = _MINIMUM_TARGET;
188     }
189 
190     if(miningTarget > _MAXIMUM_TARGET){
191       miningTarget = _MAXIMUM_TARGET;
192     }
193   }
194 
195   function getChallengeNumber() public constant returns (bytes32) {
196     return challengeNumber;
197   }
198 
199   function getMiningDifficulty() public constant returns (uint) {
200     return _MAXIMUM_TARGET.div(miningTarget);
201   }
202 
203   function getMiningTarget() public constant returns (uint) {
204     return miningTarget;
205   }
206 
207   function getMiningReward() public constant returns (uint) {
208     return (50 * 10**uint(decimals) ).div( 2**rewardEra ) ;
209   }
210 
211   function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
212     bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
213     return digest;
214   }
215 
216   function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
217     bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
218     if(uint256(digest) > testTarget) revert();
219     return (digest == challenge_digest);
220   }
221 
222   function totalSupply() public constant returns (uint) {
223     return _totalSupply  - balances[address(0)];
224   }
225 
226   function balanceOf(address tokenOwner) public constant returns (uint balance) {
227     return balances[tokenOwner];
228   }
229 
230   function transfer(address to, uint tokens) public returns (bool success) {
231     balances[msg.sender] = balances[msg.sender].sub(tokens);
232     balances[to] = balances[to].add(tokens);
233     Transfer(msg.sender, to, tokens);
234     return true;
235   }
236 
237   function transferExtra(address to, uint tokens, uint extra) public returns (bool success) {
238     balances[msg.sender] = balances[msg.sender].sub(tokens);
239     balances[to] = balances[to].add(tokens);
240     Transfer(msg.sender, to, tokens);
241     return true;
242   }
243 
244   function approve(address spender, uint tokens) public returns (bool success) {
245     allowed[msg.sender][spender] = tokens;
246     Approval(msg.sender, spender, tokens);
247     return true;
248   }
249 
250   function transferFrom(address from, address to, uint tokens) public returns (bool success) {
251     balances[from] = balances[from].sub(tokens);
252     allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
253     balances[to] = balances[to].add(tokens);
254     Transfer(from, to, tokens);
255     return true;
256   }
257 
258   function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
259     return allowed[tokenOwner][spender];
260   }
261 
262   function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
263     allowed[msg.sender][spender] = tokens;
264     Approval(msg.sender, spender, tokens);
265     ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
266     return true;
267   }
268 
269   function () public payable {
270     revert();
271   }
272 
273   function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
274     return ERC20Interface(tokenAddress).transfer(owner, tokens);
275   }
276 
277 }