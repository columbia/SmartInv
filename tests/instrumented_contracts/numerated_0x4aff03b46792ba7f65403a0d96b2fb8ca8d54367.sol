1 pragma solidity ^0.4.18;
2 
3 // To fix the original Skorch token contract a snapshot was taken at block 5772500. Snapshot is applied here 
4 
5 library SafeMath {
6 
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11 
12     function sub(uint a, uint b) internal pure returns (uint c) {
13         require(b <= a);
14         c = a - b;
15     }
16 
17     function mul(uint a, uint b) internal pure returns (uint c) {
18         c = a * b;
19         require(a == 0 || c / a == b);
20     }
21 
22     function div(uint a, uint b) internal pure returns (uint c) {
23         require(b > 0);
24         c = a / b;
25     }
26 }
27 
28 library ExtendedMath {
29     //return the smaller of the two inputs (a or b)
30     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
31         if(a > b) return b;
32         return a;
33     }
34 }
35 
36 contract ERC20Interface {
37     function totalSupply() public constant returns (uint);
38     function balanceOf(address tokenOwner) public constant returns (uint balance);
39     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
40     function transfer(address to, uint tokens) public returns (bool success);
41     function approve(address spender, uint tokens) public returns (bool success);
42     function transferFrom(address from, address to, uint tokens) public returns (bool success);
43     event Transfer(address indexed from, address indexed to, uint tokens);
44     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
45 }
46 
47 contract ApproveAndCallFallBack {
48     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
49 }
50 
51 contract Owned {
52 
53     address public owner;
54 
55     address public newOwner;
56 
57     event OwnershipTransferred(address indexed _from, address indexed _to);
58 
59     constructor() public {
60         owner = msg.sender;
61     }
62 
63 
64     modifier onlyOwner {
65         require(msg.sender == owner);
66         _;
67     }
68 
69 
70     function transferOwnership(address _newOwner) public onlyOwner {
71         newOwner = _newOwner;
72     }
73 
74     function acceptOwnership() public {
75         require(msg.sender == newOwner);
76         emit OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78         newOwner = address(0);
79     }
80 }
81 
82 contract AABitcoinToken is ERC20Interface, Owned {
83 
84     using SafeMath for uint;
85     using ExtendedMath for uint;
86 
87     string public symbol;
88 
89     string public  name;
90 
91     uint8 public decimals;
92 
93     uint public _totalSupply;
94     uint public latestDifficultyPeriodStarted;
95     uint public epochCount;
96     uint public _BLOCKS_PER_READJUSTMENT = 1024;
97 
98     uint public  _MINIMUM_TARGET = 2**16;
99 
100     uint public  _MAXIMUM_TARGET = 2**234;
101 
102     uint public miningTarget;
103 
104     bytes32 public challengeNumber;   //generate a new one when a new reward is minted
105 
106     uint public rewardEra;
107     uint public maxSupplyForEra;
108 
109     address public lastRewardTo;
110     uint public lastRewardAmount;
111     uint public lastRewardEthBlockNumber;
112 
113     bool locked = false;
114 
115     mapping(bytes32 => bytes32) solutionForChallenge;
116 
117     uint public tokensMinted;
118     
119     uint internal GLOBAL_START_TIMER;
120 
121     mapping(address => uint) balances;
122 
123     mapping(address => mapping(address => uint)) allowed;
124     
125     mapping(address => uint256) timer; // timer to check PoS 
126     
127     // how to calculate doubleUnit: 
128     // specify how much percent increase you want per year 
129     // e.g. 130% -> 2.3 multiplier every year 
130     // now divide (1 years) by LOG(2.3) where LOG is the natural logarithm (not LOG10)
131     // in this case LOG(2.3) is 0.83290912293
132     // hence multiplying by 1/0.83290912293 is the same 
133     // 31536000 = 1 years (to prevent deprecated warning in solc)
134     uint256 doubleUnit = (31536000) * 3.811;
135 
136     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
137     event PoS(address indexed from, uint reward_amount);
138 
139     constructor()
140         public 
141         onlyOwner()
142     {
143         symbol = "SKO";
144         name = "Skorch Token";
145         decimals = 8;
146         // uncomment this to test 
147         //balances[msg.sender] = (20000) * (10 ** uint(decimals)); // change 20000 to some lower number than 20000 
148         //to see you will not get PoS tokens if you have less than 20000 tokens 
149         //timer[msg.sender] = now - (1 years);
150         _totalSupply = 21000000 * 10**uint(decimals);
151         if(locked) revert();
152         locked = true;
153         tokensMinted = 0;
154         rewardEra = 0;
155         maxSupplyForEra = _totalSupply.div(2);
156         miningTarget = _MAXIMUM_TARGET;
157         latestDifficultyPeriodStarted = block.number;
158         //_startNewMiningEpoch(); all relevant vars are set below
159         GLOBAL_START_TIMER = now;
160         challengeNumber = 0x85d676fa25011d060e3c7405f6e55de1921372c788bfaaed75c00b63a63c510d;
161         epochCount = 6231;
162         rewardEra = 0;
163         maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
164         miningTarget = 431359146674410236714672241392314090778194310760649159697657763988184;
165         
166         // token balances as of block 5772500
167 balances[0xbf45f4280cfbe7c2d2515a7d984b8c71c15e82b7] = 2000 * 10 ** uint(decimals);
168 emit Transfer(address(0x0), 0xbf45f4280cfbe7c2d2515a7d984b8c71c15e82b7, 2000 * 10 ** uint(decimals));
169 balances[0xb38094d492af4fffff760707f36869713bfb2250] = 20050 * 10 ** uint(decimals);
170 emit Transfer(address(0x0), 0xb38094d492af4fffff760707f36869713bfb2250, 20050 * 10 ** uint(decimals));
171 balances[0x8f3dd21c9334980030ba95c37565ba25df9574cd] = 200 * 10 ** uint(decimals);
172 emit Transfer(address(0x0), 0x8f3dd21c9334980030ba95c37565ba25df9574cd, 200 * 10 ** uint(decimals));
173 balances[0xaa7a7c2decb180f68f11e975e6d92b5dc06083a6] = 1150 * 10 ** uint(decimals);
174 emit Transfer(address(0x0), 0xaa7a7c2decb180f68f11e975e6d92b5dc06083a6, 1150 * 10 ** uint(decimals));
175 balances[0x07a68bd44a526e09b8dbfc7085b265450362b61a] = 1000 * 10 ** uint(decimals);
176 emit Transfer(address(0x0), 0x07a68bd44a526e09b8dbfc7085b265450362b61a, 1000 * 10 ** uint(decimals));
177 balances[0x4e27a678c8dc883035c542c83124e7e3f39842b0] = 350 * 10 ** uint(decimals);
178 emit Transfer(address(0x0), 0x4e27a678c8dc883035c542c83124e7e3f39842b0, 350 * 10 ** uint(decimals));
179 balances[0x0102f6ca7278e7d96a6d649da30bfe07e87155a3] = 2800 * 10 ** uint(decimals);
180 emit Transfer(address(0x0), 0x0102f6ca7278e7d96a6d649da30bfe07e87155a3, 2800 * 10 ** uint(decimals));
181 balances[0xfc313f77c2cbc6cd0dd82b9a0ed1620ba906e46d] = 1900 * 10 ** uint(decimals);
182 emit Transfer(address(0x0), 0xfc313f77c2cbc6cd0dd82b9a0ed1620ba906e46d, 1900 * 10 ** uint(decimals));
183 balances[0xfec55e783595682141c4b5e6ad9ea605f1683844] = 100 * 10 ** uint(decimals);
184 emit Transfer(address(0x0), 0xfec55e783595682141c4b5e6ad9ea605f1683844, 100 * 10 ** uint(decimals));
185 balances[0x167e733de0861f0d61b179d3d1891e6b90587732] = 20200 * 10 ** uint(decimals);
186 emit Transfer(address(0x0), 0x167e733de0861f0d61b179d3d1891e6b90587732, 20200 * 10 ** uint(decimals));
187 balances[0x22dd964193df4de2e6954a2a9d9cbbd6f44f0b28] = 7650 * 10 ** uint(decimals);
188 emit Transfer(address(0x0), 0x22dd964193df4de2e6954a2a9d9cbbd6f44f0b28, 7650 * 10 ** uint(decimals));
189 balances[0xd2b752bec2fe5c7e5cc600eb5ce465a210cb857a] = 3750 * 10 ** uint(decimals);
190 emit Transfer(address(0x0), 0xd2b752bec2fe5c7e5cc600eb5ce465a210cb857a, 3750 * 10 ** uint(decimals));
191 balances[0xe14cffadb6bbad8de69bd5ba214441a9582ec548] = 700 * 10 ** uint(decimals);
192 emit Transfer(address(0x0), 0xe14cffadb6bbad8de69bd5ba214441a9582ec548, 700 * 10 ** uint(decimals));
193 balances[0xfe5a94e5bab010f52ae8fd8589b7d0a7b0b433ae] = 20000 * 10 ** uint(decimals);
194 emit Transfer(address(0x0), 0xfe5a94e5bab010f52ae8fd8589b7d0a7b0b433ae, 20000 * 10 ** uint(decimals));
195 balances[0xae7c95f2192c739edfb16412a6112a54f8965305] = 550 * 10 ** uint(decimals);
196 emit Transfer(address(0x0), 0xae7c95f2192c739edfb16412a6112a54f8965305, 550 * 10 ** uint(decimals));
197 balances[0x30385a99e66469a8c0bf172896758dd4595704a9] = 50 * 10 ** uint(decimals);
198 emit Transfer(address(0x0), 0x30385a99e66469a8c0bf172896758dd4595704a9, 50 * 10 ** uint(decimals));
199 balances[0x219fdb55ea364fcaf29aaa87fb1c45ba7db8128e] = 200 * 10 ** uint(decimals);
200 emit Transfer(address(0x0), 0x219fdb55ea364fcaf29aaa87fb1c45ba7db8128e, 200 * 10 ** uint(decimals));
201 balances[0xab4485ca338b91087a09ae8bc141648bb1c6e967] = 1100 * 10 ** uint(decimals);
202 emit Transfer(address(0x0), 0xab4485ca338b91087a09ae8bc141648bb1c6e967, 1100 * 10 ** uint(decimals));
203 balances[0xafaf9a165408737e11191393fe695c1ebc7a5429] = 35500 * 10 ** uint(decimals);
204 emit Transfer(address(0x0), 0xafaf9a165408737e11191393fe695c1ebc7a5429, 35500 * 10 ** uint(decimals));
205 balances[0xebd76aa221968b8ba9cdd6e6b4dbb889140088a3] = 3050 * 10 ** uint(decimals);
206 emit Transfer(address(0x0), 0xebd76aa221968b8ba9cdd6e6b4dbb889140088a3, 3050 * 10 ** uint(decimals));
207 balances[0x26b8c7606e828a509bbb208a0322cf960c17b225] = 4300 * 10 ** uint(decimals);
208 emit Transfer(address(0x0), 0x26b8c7606e828a509bbb208a0322cf960c17b225, 4300 * 10 ** uint(decimals));
209 balances[0x9b8957d1ac592bd388dcde346933ac1269b7c314] = 1050 * 10 ** uint(decimals);
210 emit Transfer(address(0x0), 0x9b8957d1ac592bd388dcde346933ac1269b7c314, 1050 * 10 ** uint(decimals));
211 balances[0xad9f11d1dd6d202243473a0cdae606308ab243b4] = 1000 * 10 ** uint(decimals);
212 emit Transfer(address(0x0), 0xad9f11d1dd6d202243473a0cdae606308ab243b4, 1000 * 10 ** uint(decimals));
213 balances[0x2f0d5a1d6bb5d7eaa0eaad39518621911a4a1d9f] = 200 * 10 ** uint(decimals);
214 emit Transfer(address(0x0), 0x2f0d5a1d6bb5d7eaa0eaad39518621911a4a1d9f, 200 * 10 ** uint(decimals));
215 balances[0xfbc2b315ac1fba765597a92ff100222425ce66fd] = 6000 * 10 ** uint(decimals);
216 emit Transfer(address(0x0), 0xfbc2b315ac1fba765597a92ff100222425ce66fd, 6000 * 10 ** uint(decimals));
217 balances[0x0a26d9674c2a1581ada4316e3f5960bb70fb0fb2] = 5100 * 10 ** uint(decimals);
218 emit Transfer(address(0x0), 0x0a26d9674c2a1581ada4316e3f5960bb70fb0fb2, 5100 * 10 ** uint(decimals));
219 balances[0xdc680cc11a535e45329f49566850668fef34054f] = 9750 * 10 ** uint(decimals);
220 emit Transfer(address(0x0), 0xdc680cc11a535e45329f49566850668fef34054f, 9750 * 10 ** uint(decimals));
221 balances[0x9fc5b0edc0309745c6974f1a6718029ea41a4d6e] = 400 * 10 ** uint(decimals);
222 emit Transfer(address(0x0), 0x9fc5b0edc0309745c6974f1a6718029ea41a4d6e, 400 * 10 ** uint(decimals));
223 balances[0xe0c059faabce16dd5ddb4817f427f5cf3b40f4c4] = 1800 * 10 ** uint(decimals);
224 emit Transfer(address(0x0), 0xe0c059faabce16dd5ddb4817f427f5cf3b40f4c4, 1800 * 10 ** uint(decimals));
225 balances[0x85d66f3a8da35f47e03d6bb51f51c2d70a61e12e] = 13200 * 10 ** uint(decimals);
226 emit Transfer(address(0x0), 0x85d66f3a8da35f47e03d6bb51f51c2d70a61e12e, 13200 * 10 ** uint(decimals));
227 balances[0xa5b3725e37431dc6a103961749cb9c98954202cd] = 4400 * 10 ** uint(decimals);
228 emit Transfer(address(0x0), 0xa5b3725e37431dc6a103961749cb9c98954202cd, 4400 * 10 ** uint(decimals));
229 balances[0xf3552d4018fad9fcc390f5684a243f7318d8b570] = 2500 * 10 ** uint(decimals);
230 emit Transfer(address(0x0), 0xf3552d4018fad9fcc390f5684a243f7318d8b570, 2500 * 10 ** uint(decimals));
231 balances[0x1fca39ed4f19edd12eb274dc467c099eb5106a13] = 2750 * 10 ** uint(decimals);
232 emit Transfer(address(0x0), 0x1fca39ed4f19edd12eb274dc467c099eb5106a13, 2750 * 10 ** uint(decimals));
233 balances[0xf95f528d7c25904f15d4154e45eab8e5d4b6c160] = 350 * 10 ** uint(decimals);
234 emit Transfer(address(0x0), 0xf95f528d7c25904f15d4154e45eab8e5d4b6c160, 350 * 10 ** uint(decimals));
235 balances[0xa62178f120cccba370d2d2d12ec6fb1ff276d706] = 20250 * 10 ** uint(decimals);
236 emit Transfer(address(0x0), 0xa62178f120cccba370d2d2d12ec6fb1ff276d706, 20250 * 10 ** uint(decimals));
237 balances[0xc446073e0c00a1138812b3a99a19df3cb8ace70d] = 20050 * 10 ** uint(decimals);
238 emit Transfer(address(0x0), 0xc446073e0c00a1138812b3a99a19df3cb8ace70d, 20050 * 10 ** uint(decimals));
239 balances[0xfcc6bf3369077e22a90e05ad567744bf5109e4d4] = 300 * 10 ** uint(decimals);
240 emit Transfer(address(0x0), 0xfcc6bf3369077e22a90e05ad567744bf5109e4d4, 300 * 10 ** uint(decimals));
241 balances[0x25e5c43d5f53ee1a7dd5ad7560348e29baea3048] = 50 * 10 ** uint(decimals);
242 emit Transfer(address(0x0), 0x25e5c43d5f53ee1a7dd5ad7560348e29baea3048, 50 * 10 ** uint(decimals));
243 balances[0x4d01d11697f00097064d7e05114ecd3843e82867] = 6050 * 10 ** uint(decimals);
244 emit Transfer(address(0x0), 0x4d01d11697f00097064d7e05114ecd3843e82867, 6050 * 10 ** uint(decimals));
245 balances[0xe585ba86b84283f0f1118041837b06d03b96885e] = 1350 * 10 ** uint(decimals);
246 emit Transfer(address(0x0), 0xe585ba86b84283f0f1118041837b06d03b96885e, 1350 * 10 ** uint(decimals));
247 balances[0x21a6043877a0ac376b7ca91195521de88d440eba] = 1600 * 10 ** uint(decimals);
248 emit Transfer(address(0x0), 0x21a6043877a0ac376b7ca91195521de88d440eba, 1600 * 10 ** uint(decimals));
249 balances[0xe8a01b61f80130aefda985ee2e9c6899a57a17c8] = 1750 * 10 ** uint(decimals);
250 emit Transfer(address(0x0), 0xe8a01b61f80130aefda985ee2e9c6899a57a17c8, 1750 * 10 ** uint(decimals));
251 balances[0x8d12a197cb00d4747a1fe03395095ce2a5cc6819] = 46800 * 10 ** uint(decimals);
252 emit Transfer(address(0x0), 0x8d12a197cb00d4747a1fe03395095ce2a5cc6819, 46800 * 10 ** uint(decimals));
253 balances[0xa1a3e2fcc1e7c805994ca7309f9a829908a18b4c] = 4100 * 10 ** uint(decimals);
254 emit Transfer(address(0x0), 0xa1a3e2fcc1e7c805994ca7309f9a829908a18b4c, 4100 * 10 ** uint(decimals));
255 balances[0x51138ab5497b2c3d85be94d23905f5ead9e533a7] = 50 * 10 ** uint(decimals);
256 emit Transfer(address(0x0), 0x51138ab5497b2c3d85be94d23905f5ead9e533a7, 50 * 10 ** uint(decimals));
257 balances[0x559a922941f84ebe6b9f0ed58e3b96530614237e] = 650 * 10 ** uint(decimals);
258 emit Transfer(address(0x0), 0x559a922941f84ebe6b9f0ed58e3b96530614237e, 650 * 10 ** uint(decimals));
259 balances[0xe539a7645d2f33103c89b5b03abb422a163b7c73] = 600 * 10 ** uint(decimals);
260 emit Transfer(address(0x0), 0xe539a7645d2f33103c89b5b03abb422a163b7c73, 600 * 10 ** uint(decimals));
261 balances[0x4ffe17a2a72bc7422cb176bc71c04ee6d87ce329] = 4300 * 10 ** uint(decimals);
262 emit Transfer(address(0x0), 0x4ffe17a2a72bc7422cb176bc71c04ee6d87ce329, 4300 * 10 ** uint(decimals));
263 balances[0x88058d4d90cc9d9471509e5be819b2be361b51c6] = 9450 * 10 ** uint(decimals);
264 emit Transfer(address(0x0), 0x88058d4d90cc9d9471509e5be819b2be361b51c6, 9450 * 10 ** uint(decimals));
265 balances[0x0000bb50ee5f5df06be902d1f9cb774949c337ed] = 1150 * 10 ** uint(decimals);
266 emit Transfer(address(0x0), 0x0000bb50ee5f5df06be902d1f9cb774949c337ed, 1150 * 10 ** uint(decimals));
267 balances[0xd7dd80404d3d923c8a40c47c1f61aacbccb4191e] = 6450 * 10 ** uint(decimals);
268 emit Transfer(address(0x0), 0xd7dd80404d3d923c8a40c47c1f61aacbccb4191e, 6450 * 10 ** uint(decimals));
269 balances[0xf2119e50578b3dfa248652c4fbec76b9e415acb2] = 100 * 10 ** uint(decimals);
270 emit Transfer(address(0x0), 0xf2119e50578b3dfa248652c4fbec76b9e415acb2, 100 * 10 ** uint(decimals));
271 balances[0xd2470aacd96242207f06111819111d17ca055dfb] = 9450 * 10 ** uint(decimals); 
272 emit Transfer(address(0x0), 0xd2470aacd96242207f06111819111d17ca055dfb, 9450 * 10 ** uint(decimals));
273 
274 // test lines 
275 //balances[msg.sender] = 1000 * 10 ** uint(decimals);
276 //timer[msg.sender ] = ( now - ( 1 years));
277 
278     }
279 
280 
281         function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
282             bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
283             if (digest != challenge_digest) revert();
284             if(uint256(digest) > miningTarget) revert();
285              bytes32 solution = solutionForChallenge[challengeNumber];
286              solutionForChallenge[challengeNumber] = digest;
287              if(solution != 0x0) revert();  //prevent the same answer from awarding twice
288              _claimTokens(msg.sender);
289              timer[msg.sender]=now;
290             uint reward_amount = getMiningReward();
291             balances[msg.sender] = balances[msg.sender].add(reward_amount);
292             tokensMinted = tokensMinted.add(reward_amount);
293             assert(tokensMinted <= maxSupplyForEra);
294             lastRewardTo = msg.sender;
295             lastRewardAmount = reward_amount;
296             lastRewardEthBlockNumber = block.number;
297              _startNewMiningEpoch();
298               emit Mint(msg.sender, reward_amount, epochCount, challengeNumber );
299               emit Transfer(address(0x0), msg.sender, reward_amount);
300            return true;
301         }
302 
303     function _startNewMiningEpoch() internal {
304       if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 39)
305       {
306         rewardEra = rewardEra + 1;
307       }
308       maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
309       epochCount = epochCount.add(1);
310       if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
311       {
312         _reAdjustDifficulty();
313       }
314       challengeNumber = block.blockhash(block.number - 1);
315     }
316 
317     function _reAdjustDifficulty() internal {
318         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
319         uint epochsMined = _BLOCKS_PER_READJUSTMENT; 
320         uint targetEthBlocksPerDiffPeriod = epochsMined * 60; //should be 60 times slower than ethereum
321         if( ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod )
322         {
323           uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div( ethBlocksSinceLastDifficultyPeriod );
324           uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
325           miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %
326         }else{
327           uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div( targetEthBlocksPerDiffPeriod );
328           uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
329           miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %
330         }
331         latestDifficultyPeriodStarted = block.number;
332         if(miningTarget < _MINIMUM_TARGET) //very difficult
333         {
334           miningTarget = _MINIMUM_TARGET;
335         }
336         if(miningTarget > _MAXIMUM_TARGET) //very easy
337         {
338           miningTarget = _MAXIMUM_TARGET;
339         }
340     }
341 
342     function getChallengeNumber() public constant returns (bytes32) {
343         return challengeNumber;
344     }
345 
346     function getMiningDifficulty() public constant returns (uint) {
347         return _MAXIMUM_TARGET.div(miningTarget);
348     }
349 
350     function getMiningTarget() public constant returns (uint) {
351        return miningTarget;
352    }
353 
354     function getMiningReward() public constant returns (uint) {
355          return (50 * 10**uint(decimals) ).div( 2**rewardEra ) ;
356     }
357 
358     function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
359         bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
360         return digest;
361       }
362       
363       function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
364           bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
365           if(uint256(digest) > testTarget) revert();
366           return (digest == challenge_digest);
367         }
368 
369     function totalSupply() public constant returns (uint) {
370         return _totalSupply;
371     }
372 
373     function balanceOf(address tokenOwner) public constant returns (uint balance) {
374         return balances[tokenOwner] + _getPoS(tokenOwner); // add unclaimed pos tokens 
375     }
376 
377     function transfer(address to, uint tokens) public returns (bool success) {
378         _claimTokens(msg.sender);
379         _claimTokens(to);
380         timer[msg.sender] = now;
381         timer[to] = now;
382         balances[msg.sender] = balances[msg.sender].sub(tokens);
383         balances[to] = balances[to].add(tokens);
384         emit Transfer(msg.sender, to, tokens);
385         return true;
386     }
387 
388     function approve(address spender, uint tokens) public returns (bool success) {
389         allowed[msg.sender][spender] = tokens;
390         emit Approval(msg.sender, spender, tokens);
391         return true;
392     }
393 
394     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
395         _claimTokens(from);
396         _claimTokens(to);
397         timer[from] = now;
398         timer[to] = now;
399         balances[from] = balances[from].sub(tokens);
400         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
401         balances[to] = balances[to].add(tokens);
402         emit Transfer(from, to, tokens);
403         return true;
404     }
405 
406     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
407         allowed[msg.sender][spender] = tokens;
408         emit Approval(msg.sender, spender, tokens);
409         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
410         return true;
411     }
412 
413     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
414         return allowed[tokenOwner][spender];
415     }
416 
417     function () public payable {
418         revert();
419     } 
420     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
421         return ERC20Interface(tokenAddress).transfer(owner, tokens);
422     }
423     
424     function claimTokens() public {
425         _claimTokens(msg.sender);        
426         timer[msg.sender] = now;
427     }
428     
429     function _claimTokens(address target) internal{
430         if (timer[target] == 0){
431             // russian hackers BTFO
432 
433             if (balances[target] > 0){
434                 // timer is handled in _getPoS 
435             }
436             else{
437                 return;
438             }
439         }
440         if (timer[target] == now){
441             // 0 seconds passed, 0 tokens gotten via PoS 
442             // return so no gas waste 
443             return;
444         }
445         
446         uint256 totalTkn = _getPoS(target);
447         if (totalTkn > 0){
448             balances[target] = balances[target].add(totalTkn);
449             _totalSupply.add(totalTkn);
450             emit PoS(target, totalTkn);
451         }
452 
453         //timer[target] = now; every time you claim tokens this timer is set. this is to prevent people claiming 0 tokens and then setting their timer
454         emit Transfer(address(0x0), target, totalTkn);
455     }
456     
457     function _getPoS(address target) internal view returns (uint256){
458         int ONE_SECOND = 0x10000000000000000;
459         uint TIME = timer[target];
460         if (TIME == 0){
461             TIME = GLOBAL_START_TIMER;
462         }
463         int PORTION_SCALED = (int(now - TIME) * ONE_SECOND) / int(doubleUnit); 
464         uint256 exp = fixedExp(PORTION_SCALED);
465         
466         return ((balances[target].mul(exp)) / uint(one)).sub(balances[target]); 
467     }
468     
469     
470     
471     int256 constant ln2       = 0x0b17217f7d1cf79ac;
472     int256 constant ln2_64dot5= 0x2cb53f09f05cc627c8;
473     int256 constant one       = 0x10000000000000000;
474     int256 constant c2 =  0x02aaaaaaaaa015db0;
475     int256 constant c4 = -0x000b60b60808399d1;
476     int256 constant c6 =  0x0000455956bccdd06;
477     int256 constant c8 = -0x000001b893ad04b3a;
478     function fixedExp(int256 a) public pure returns (uint256 exp) {
479         int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
480         a -= scale*ln2;
481         // The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
482         // approximates the function x*(exp(x)+1)/(exp(x)-1)
483         // Hence exp(x) = (R(x)+x)/(R(x)-x)
484         int256 z = (a*a) / one;
485         int256 R = ((int256)(2) * one) +
486             (z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
487         exp = (uint256) (((R + a) * one) / (R - a));
488         if (scale >= 0)
489             exp <<= scale;
490         else
491             exp >>= -scale;
492         return exp;
493     }
494 
495 }