1 pragma solidity ^0.4.18;
2 
3  
4 
5 //-------------------------------
6 // (        )   )  (            )  
7 // )\ )  ( /(( /(  )\ )  (   ( /(  
8 //(()/(  )\())\())(()/(  )\  )\()) 
9 // /(_))((_)((_)\  /(_)|((_)((_)\  
10 //(_)) |_ ((_)((_)(_)) )\___ _((_) 
11 /// __|| |/ // _ \| _ ((/ __| || | 
12 //\__ \  ' <| (_) |   /| (__| __ | 
13 //|___/ _|\_\\___/|_|_\ \___|_||_| 
14 //--------------------------------
15 
16 //------------------------------------------
17 // Official Website: https://skorch.io
18 // Github: https://github.com/skorchtoken
19 // Twitter: https://twitter.com/SkorchToken
20 // Reddit: https://reddit.com/r/SkorchToken
21 // Medium: https://medium.com/@skorchtoken
22 // Discord: https://discord.gg/yxZAnfe
23 // Telegram: https://t.me/skorchtoken
24 
25 // ALWAYS refer to our official social media channels and website for project announcements.
26 //------------------------------------------
27 
28 // Skorch is the first PoW+PoS mineable ERC20 token using Keccak256 (Sha3) algorithm
29 // 210 Million Total Supply 
30 // 21 Million available for Proof of Work mining based on Bitcoin's SHA256 Algorithm
31 // 21k (21,000) SKO Required to be held in your wallet to gain Proof of Stake Rewards
32 // 189 Million of 210 Million total supply will be minted by the smart contract for PoS rewards 
33 // 30% PoS rewards for the first year but decreases each year after until 0 
34 // PoS requirement decreases after first year and each year after until 0
35 
36 // Difficulty target auto-adjusts with PoW hashrate
37 // Mining rewards decrease as more tokens are minted
38 
39 // To fix and improve the original Skorch token contract a snapshot was taken at block 5882054.
40 
41 
42 library SafeMath {
43 
44     function add(uint a, uint b) internal pure returns (uint c) {
45         c = a + b;
46         require(c >= a);
47     }
48 
49     function sub(uint a, uint b) internal pure returns (uint c) {
50         require(b <= a);
51         c = a - b;
52     }
53 
54     function mul(uint a, uint b) internal pure returns (uint c) {
55         c = a * b;
56         require(a == 0 || c / a == b);
57     }
58 
59     function div(uint a, uint b) internal pure returns (uint c) {
60         require(b > 0);
61         c = a / b;
62     }
63 }
64 
65 //209899900000000
66 
67 library ExtendedMath {
68     //return the smaller of the two inputs (a or b)
69     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
70         if(a > b) return b;
71         return a;
72     }
73 }
74 
75 contract ERC20Interface {
76     function totalSupply() public constant returns (uint);
77     function balanceOf(address tokenOwner) public constant returns (uint balance);
78     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
79     function transfer(address to, uint tokens) public returns (bool success);
80     function approve(address spender, uint tokens) public returns (bool success);
81     function transferFrom(address from, address to, uint tokens) public returns (bool success);
82     event Transfer(address indexed from, address indexed to, uint tokens);
83     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
84 }
85 
86 contract ApproveAndCallFallBack {
87     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
88 }
89 
90 contract Owned {
91 
92     address public owner;
93 
94     address public newOwner;
95 
96     event OwnershipTransferred(address indexed _from, address indexed _to);
97 
98     constructor() public {
99         owner = msg.sender;
100     }
101 
102 
103     modifier onlyOwner {
104         require(msg.sender == owner);
105         _;
106     }
107 
108 
109     function transferOwnership(address _newOwner) public onlyOwner {
110         newOwner = _newOwner;
111     }
112 
113     function acceptOwnership() public {
114         require(msg.sender == newOwner);
115         emit OwnershipTransferred(owner, newOwner);
116         owner = newOwner;
117         newOwner = address(0);
118     }
119 }
120 
121 contract Skorch is ERC20Interface, Owned {
122 
123     using SafeMath for uint;
124     using ExtendedMath for uint;
125 
126     string public symbol;
127 
128     string public  name;
129 
130     uint8 public decimals = 8;
131 
132     uint public _totalSupply;
133     uint public latestDifficultyPeriodStarted;
134     uint public epochCount;
135     uint public _BLOCKS_PER_READJUSTMENT = 1024;
136 
137     uint public  _MINIMUM_TARGET = 2**16;
138 
139     uint public  _MAXIMUM_TARGET = 2**234;
140 
141     uint public miningTarget;
142 
143     bytes32 public challengeNumber;   //generate a new one when a new reward is minted
144 
145     uint public rewardEra;
146     uint public maxSupplyForEra;
147 
148     address public lastRewardTo;
149     uint public lastRewardAmount;
150     uint public lastRewardEthBlockNumber;
151 
152     bool locked = false;
153 
154     mapping(bytes32 => bytes32) solutionForChallenge;
155 
156     uint public tokensMinted;
157     
158     uint internal GLOBAL_START_TIMER;
159 
160     mapping(address => uint) balances;
161 
162     mapping(address => mapping(address => uint)) allowed;
163     
164     mapping(address => uint256) timer; // timer to check PoS 
165     
166     // how to calculate doubleUnit: 
167     // specify how much percent increase you want per year 
168     // e.g. 130% -> 2.3 multiplier every year 
169     // now divide (1 years) by LOG(2.3) where LOG is the natural logarithm (not LOG10)
170     // in this case LOG(2.3) is 0.83290912293
171     // hence multiplying by 1/0.83290912293 is the same 
172     // 31536000 = 1 years (to prevent deprecated warning in solc)
173    
174     
175   //  uint256 timerUnit = 2.2075199 * (10**8);
176     uint256 timerUnit = 88416639; // unit for staking req
177     uint256 stakingRequirement = (21000 * (10**uint(decimals)));
178     
179     
180     uint stakeUnit = 930222908; // unit  for staking 
181     
182     //uint256 stakingCap = (210000000 * (10**uint(decimals)));
183 
184     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
185     event PoS(address indexed from, uint reward_amount);
186 
187     constructor()
188         public 
189         onlyOwner()
190     {
191         symbol = "SKO";
192         name = "Skorch";
193         decimals = 8;
194         // uncomment this to test 
195         //balances[msg.sender] = (21000) * (10 ** uint(decimals)); // change 21000 to some lower number than 21000 
196         //to see you will not get PoS tokens if you have less than 21000 tokens 
197         //timer[msg.sender] = now - (1 years);
198         _totalSupply = 210000000 * 10**uint(decimals);
199         if(locked) revert();
200         locked = true;
201         tokensMinted = 69750000000000;
202         rewardEra = 0;
203         maxSupplyForEra = 1050000000000000;
204         //miningTarget = _MAXIMUM_TARGET;
205         latestDifficultyPeriodStarted = block.number;
206         //_startNewMiningEpoch(); all relevant vars are set below
207         GLOBAL_START_TIMER = now;
208         challengeNumber = 0x48f499eca7dc41858c2a53fded09096d138b8b88a9da8f488dccd5118bb1bbe2;
209         epochCount = 20181;
210         rewardEra = 0;
211         maxSupplyForEra = (_totalSupply/10) - _totalSupply.div( 20**(rewardEra + 1)); // multiplied by 10 since totalsupply is 210 million here 
212         miningTarget = 462884030900683306229868328231836786922375156766639975465481078398;
213         
214         
215         
216         // SNAPSHOT DATA 
217 // NEW FILE
218 balances[0xab4485ca338b91087a09ae8bc141648bb1c6e967]=111501588282;
219 emit Transfer(address(0x0), 0xab4485ca338b91087a09ae8bc141648bb1c6e967, 111501588282);
220 balances[0xf2119e50578b3dfa248652c4fbec76b9e415acb2]=10136508025;
221 emit Transfer(address(0x0), 0xf2119e50578b3dfa248652c4fbec76b9e415acb2, 10136508025);
222 balances[0xb12b538cb67fceb50bbc1a31d2011eb92e6f7188]=1583682;
223 emit Transfer(address(0x0), 0xb12b538cb67fceb50bbc1a31d2011eb92e6f7188, 1583682);
224 balances[0x21b7e18dacde5c004a0a56e74f071ac3fb2e98ff]=10790714329;
225 emit Transfer(address(0x0), 0x21b7e18dacde5c004a0a56e74f071ac3fb2e98ff, 10790714329);
226 balances[0xe539a7645d2f33103c89b5b03abb422a163b7c73]=60819048154;
227 emit Transfer(address(0x0), 0xe539a7645d2f33103c89b5b03abb422a163b7c73, 60819048154);
228 balances[0x4ffe17a2a72bc7422cb176bc71c04ee6d87ce329]=451048209723;
229 emit Transfer(address(0x0), 0x4ffe17a2a72bc7422cb176bc71c04ee6d87ce329, 451048209723);
230 balances[0xc0a2002e74b3b22e77098cb87232f446d813ce31]=33885;
231 emit Transfer(address(0x0), 0xc0a2002e74b3b22e77098cb87232f446d813ce31, 33885);
232 balances[0xfc313f77c2cbc6cd0dd82b9a0ed1620ba906e46d]=192593652488;
233 emit Transfer(address(0x0), 0xfc313f77c2cbc6cd0dd82b9a0ed1620ba906e46d, 192593652488);
234 balances[0x219fdb55ea364fcaf29aaa87fb1c45ba7db8128e]=20273016051;
235 emit Transfer(address(0x0), 0x219fdb55ea364fcaf29aaa87fb1c45ba7db8128e, 20273016051);
236 balances[0xfbc2b315ac1fba765597a92ff100222425ce66fd]=608190481542;
237 emit Transfer(address(0x0), 0xfbc2b315ac1fba765597a92ff100222425ce66fd, 608190481542);
238 balances[0x852563d88480decbc9bfb4428bb689af48dd92a9]=1008618359915;
239 emit Transfer(address(0x0), 0x852563d88480decbc9bfb4428bb689af48dd92a9, 1008618359915);
240 balances[0x4d01d11697f00097064d7e05114ecd3843e82867]=789840293838;
241 emit Transfer(address(0x0), 0x4d01d11697f00097064d7e05114ecd3843e82867, 789840293838);
242 balances[0xe75ea07e4b90e46e13c37644138aa99ec69020ae]=526108154879;
243 emit Transfer(address(0x0), 0xe75ea07e4b90e46e13c37644138aa99ec69020ae, 526108154879);
244 balances[0x51138ab5497b2c3d85be94d23905f5ead9e533a7]=5068254012;
245 emit Transfer(address(0x0), 0x51138ab5497b2c3d85be94d23905f5ead9e533a7, 5068254012);
246 balances[0xae7c95f2192c739edfb16412a6112a54f8965305]=55750794141;
247 emit Transfer(address(0x0), 0xae7c95f2192c739edfb16412a6112a54f8965305, 55750794141);
248 balances[0xe0261acfdd10508c75b6a60b1534c8386c4daa52]=5047016671743;
249 emit Transfer(address(0x0), 0xe0261acfdd10508c75b6a60b1534c8386c4daa52, 5047016671743);
250 balances[0x0a26d9674c2a1581ada4316e3f5960bb70fb0fb2]=516961909310;
251 emit Transfer(address(0x0), 0x0a26d9674c2a1581ada4316e3f5960bb70fb0fb2, 516961909310);
252 balances[0xa62178f120cccba370d2d2d12ec6fb1ff276d706]=2052642875205;
253 emit Transfer(address(0x0), 0xa62178f120cccba370d2d2d12ec6fb1ff276d706, 2052642875205);
254 balances[0xe57a18783640c9fa3c5e8e4d4b4443e2024a7ff9]=2494738345632;
255 emit Transfer(address(0x0), 0xe57a18783640c9fa3c5e8e4d4b4443e2024a7ff9, 2494738345632);
256 balances[0x9b8957d1ac592bd388dcde346933ac1269b7c314]=106433334269;
257 emit Transfer(address(0x0), 0x9b8957d1ac592bd388dcde346933ac1269b7c314, 106433334269);
258 balances[0xf27bb893a4d9574378c4b1d089bdb6b9fce5099e]=380845;
259 emit Transfer(address(0x0), 0xf27bb893a4d9574378c4b1d089bdb6b9fce5099e, 380845);
260 balances[0x54a8f792298af9489de7a1245169a943fb69f5a6]=707886981662;
261 emit Transfer(address(0x0), 0x54a8f792298af9489de7a1245169a943fb69f5a6, 707886981662);
262 balances[0x004ba728a652bded4d4b79fb04b5a92ad8ce15e7]=21250198;
263 emit Transfer(address(0x0), 0x004ba728a652bded4d4b79fb04b5a92ad8ce15e7, 21250198);
264 balances[0xd05803aee240195460f8589a6d6487fcea0097c1]=85731;
265 emit Transfer(address(0x0), 0xd05803aee240195460f8589a6d6487fcea0097c1, 85731);
266 balances[0xad9f11d1dd6d202243473a0cdae606308ab243b4]=101365080257;
267 emit Transfer(address(0x0), 0xad9f11d1dd6d202243473a0cdae606308ab243b4, 101365080257);
268 balances[0xfec55e783595682141c4b5e6ad9ea605f1683844]=60657099080;
269 emit Transfer(address(0x0), 0xfec55e783595682141c4b5e6ad9ea605f1683844, 60657099080);
270 balances[0x99a7e5777b711ff23e2b6961232a4009f7cec1b0]=456860909542;
271 emit Transfer(address(0x0), 0x99a7e5777b711ff23e2b6961232a4009f7cec1b0, 456860909542);
272 balances[0xbf45f4280cfbe7c2d2515a7d984b8c71c15e82b7]=1366848029003;
273 emit Transfer(address(0x0), 0xbf45f4280cfbe7c2d2515a7d984b8c71c15e82b7, 1366848029003);
274 balances[0xb38094d492af4fffff760707f36869713bfb2250]=2032369859152;
275 emit Transfer(address(0x0), 0xb38094d492af4fffff760707f36869713bfb2250, 2032369859152);
276 balances[0x900953b10460908ec636b46307dca13a759275cb]=1856435;
277 emit Transfer(address(0x0), 0x900953b10460908ec636b46307dca13a759275cb, 1856435);
278 balances[0x167e733de0861f0d61b179d3d1891e6b90587732]=2047574621189;
279 emit Transfer(address(0x0), 0x167e733de0861f0d61b179d3d1891e6b90587732, 2047574621189);
280 balances[0xdb3cbb8aa4dec854e6e60982dd9d4e85a8b422bc]=2;
281 emit Transfer(address(0x0), 0xdb3cbb8aa4dec854e6e60982dd9d4e85a8b422bc, 2);
282 balances[0x072e8711704654019c3d9bc242b3f9a4ee1963ce]=10136236279;
283 emit Transfer(address(0x0), 0x072e8711704654019c3d9bc242b3f9a4ee1963ce, 10136236279);
284 balances[0x04f72aa695b65a54d79db635005077293d111635]=167020515303;
285 emit Transfer(address(0x0), 0x04f72aa695b65a54d79db635005077293d111635, 167020515303);
286 balances[0x30385a99e66469a8c0bf172896758dd4595704a9]=614699515479;
287 emit Transfer(address(0x0), 0x30385a99e66469a8c0bf172896758dd4595704a9, 614699515479);
288 balances[0xfe5a94e5bab010f52ae8fd8589b7d0a7b0b433ae]=2067847571118;
289 emit Transfer(address(0x0), 0xfe5a94e5bab010f52ae8fd8589b7d0a7b0b433ae, 2067847571118);
290 balances[0x88058d4d90cc9d9471509e5be819b2be361b51c6]=957900008429;
291 emit Transfer(address(0x0), 0x88058d4d90cc9d9471509e5be819b2be361b51c6, 957900008429);
292 balances[0xfcc6bf3369077e22a90e05ad567744bf5109e4d4]=1635580659302;
293 emit Transfer(address(0x0), 0xfcc6bf3369077e22a90e05ad567744bf5109e4d4, 1635580659302);
294 balances[0x21a6043877a0ac376b7ca91195521de88d440eba]=162184128411;
295 emit Transfer(address(0x0), 0x21a6043877a0ac376b7ca91195521de88d440eba, 162184128411);
296 balances[0xd7dd80404d3d923c8a40c47c1f61aacbccb4191e]=3569292763171;
297 emit Transfer(address(0x0), 0xd7dd80404d3d923c8a40c47c1f61aacbccb4191e, 3569292763171);
298 balances[0xa1a3e2fcc1e7c805994ca7309f9a829908a18b4c]=633301706054;
299 emit Transfer(address(0x0), 0xa1a3e2fcc1e7c805994ca7309f9a829908a18b4c, 633301706054);
300 balances[0xc5556ce5c51d2f6a8d7a54bec2a9961dfada84db]=2471775966918;
301 emit Transfer(address(0x0), 0xc5556ce5c51d2f6a8d7a54bec2a9961dfada84db, 2471775966918);
302 balances[0xb4894098be4dbfdc0024dfb9d2e9f6654e0e3786]=10053178133;
303 emit Transfer(address(0x0), 0xb4894098be4dbfdc0024dfb9d2e9f6654e0e3786, 10053178133);
304 balances[0xe8a01b61f80130aefda985ee2e9c6899a57a17c8]=177388890449;
305 emit Transfer(address(0x0), 0xe8a01b61f80130aefda985ee2e9c6899a57a17c8, 177388890449);
306 balances[0x559a922941f84ebe6b9f0ed58e3b96530614237e]=65887302167;
307 emit Transfer(address(0x0), 0x559a922941f84ebe6b9f0ed58e3b96530614237e, 65887302167);
308 balances[0xf95f528d7c25904f15d4154e45eab8e5d4b6c160]=425572373267;
309 emit Transfer(address(0x0), 0xf95f528d7c25904f15d4154e45eab8e5d4b6c160, 425572373267);
310 balances[0x0045b9707913eae3889283ed4d72077a904b9848]=1507541146428;
311 emit Transfer(address(0x0), 0x0045b9707913eae3889283ed4d72077a904b9848, 1507541146428);
312 balances[0x586389feed58c2c6a0ce6258cb1c58833abdb093]=2603426;
313 emit Transfer(address(0x0), 0x586389feed58c2c6a0ce6258cb1c58833abdb093, 2603426);
314 balances[0xd2b752bec2fe5c7e5cc600eb5ce465a210cb857a]=380119050963;
315 emit Transfer(address(0x0), 0xd2b752bec2fe5c7e5cc600eb5ce465a210cb857a, 380119050963);
316 balances[0x518bbb5e4a1e8f8f21a09436c35b9cb5c20c7b43]=5037433249;
317 emit Transfer(address(0x0), 0x518bbb5e4a1e8f8f21a09436c35b9cb5c20c7b43, 5037433249);
318 balances[0x25e5c43d5f53ee1a7dd5ad7560348e29baea3048]=5068254012;
319 emit Transfer(address(0x0), 0x25e5c43d5f53ee1a7dd5ad7560348e29baea3048, 5068254012);
320 balances[0x22dd964193df4de2e6954a2a9d9cbbd6f44f0b28]=2754253183453;
321 emit Transfer(address(0x0), 0x22dd964193df4de2e6954a2a9d9cbbd6f44f0b28, 2754253183453);
322 balances[0xaa7a7c2decb180f68f11e975e6d92b5dc06083a6]=116569842295;
323 emit Transfer(address(0x0), 0xaa7a7c2decb180f68f11e975e6d92b5dc06083a6, 116569842295);
324 balances[0x4e27a678c8dc883035c542c83124e7e3f39842b0]=35477778089;
325 emit Transfer(address(0x0), 0x4e27a678c8dc883035c542c83124e7e3f39842b0, 35477778089);
326 balances[0x3bd56f97876d3af248b1fe92e361c05038c74c27]=15181683975;
327 emit Transfer(address(0x0), 0x3bd56f97876d3af248b1fe92e361c05038c74c27, 15181683975);
328 balances[0x674194d05bfc9a176a5b84711c8687609ff3d17b]=4287056630970;
329 emit Transfer(address(0x0), 0x674194d05bfc9a176a5b84711c8687609ff3d17b, 4287056630970);
330 balances[0x0102f6ca7278e7d96a6d649da30bfe07e87155a3]=1233053375653;
331 emit Transfer(address(0x0), 0x0102f6ca7278e7d96a6d649da30bfe07e87155a3, 1233053375653);
332 balances[0x3750ecf5e0536d04dd3858173ab571a0dcbdf7e0]=50270330036;
333 emit Transfer(address(0x0), 0x3750ecf5e0536d04dd3858173ab571a0dcbdf7e0, 50270330036);
334 balances[0x07a68bd44a526e09b8dbfc7085b265450362b61a]=101365080257;
335 emit Transfer(address(0x0), 0x07a68bd44a526e09b8dbfc7085b265450362b61a, 101365080257);
336 balances[0xebd76aa221968b8ba9cdd6e6b4dbb889140088a3]=309163494783;
337 emit Transfer(address(0x0), 0xebd76aa221968b8ba9cdd6e6b4dbb889140088a3, 309163494783);
338 balances[0xc7ee330d69cdddc1b9955618ff0df27bb8de3143]=10098567209;
339 emit Transfer(address(0x0), 0xc7ee330d69cdddc1b9955618ff0df27bb8de3143, 10098567209);
340 balances[0xe0c059faabce16dd5ddb4817f427f5cf3b40f4c4]=656449480989;
341 emit Transfer(address(0x0), 0xe0c059faabce16dd5ddb4817f427f5cf3b40f4c4, 656449480989);
342 balances[0xdc680cc11a535e45329f49566850668fef34054f]=1629652247199;
343 emit Transfer(address(0x0), 0xdc680cc11a535e45329f49566850668fef34054f, 1629652247199);
344 balances[0x22ef324a534ba9aa0d060c92294fdd0fc4aca065]=105388398778;
345 emit Transfer(address(0x0), 0x22ef324a534ba9aa0d060c92294fdd0fc4aca065, 105388398778);
346 balances[0xe14cffadb6bbad8de69bd5ba214441a9582ec548]=70955556179;
347 emit Transfer(address(0x0), 0xe14cffadb6bbad8de69bd5ba214441a9582ec548, 70955556179);
348 balances[0xdfb895c870c4956261f4839dd12786ef612d7314]=307632851383;
349 emit Transfer(address(0x0), 0xdfb895c870c4956261f4839dd12786ef612d7314, 307632851383);
350 balances[0x620103bb2b263ab0a50a47f73140d218401541c0]=10780637244561;
351 emit Transfer(address(0x0), 0x620103bb2b263ab0a50a47f73140d218401541c0, 10780637244561);
352 balances[0x9fc5b0edc0309745c6974f1a6718029ea41a4d6e]=65859631176;
353 emit Transfer(address(0x0), 0x9fc5b0edc0309745c6974f1a6718029ea41a4d6e, 65859631176);
354 balances[0xd6ceae2756f2af0a2f825b6e3ca8a9cfb4d082e2]=1122517124649;
355 emit Transfer(address(0x0), 0xd6ceae2756f2af0a2f825b6e3ca8a9cfb4d082e2, 1122517124649);
356 balances[0x25437b6a20021ea94d549ddd50403994e532e9d7]=1711954946632;
357 emit Transfer(address(0x0), 0x25437b6a20021ea94d549ddd50403994e532e9d7, 1711954946632);
358 balances[0xeb4f4c886b402c65ff6f619716efe9319ce40fcf]=526035186557;
359 emit Transfer(address(0x0), 0xeb4f4c886b402c65ff6f619716efe9319ce40fcf, 526035186557);
360 balances[0xf3552d4018fad9fcc390f5684a243f7318d8b570]=253412700642;
361 emit Transfer(address(0x0), 0xf3552d4018fad9fcc390f5684a243f7318d8b570, 253412700642);
362 balances[0x85abe8e3bed0d4891ba201af1e212fe50bb65a26]=1060373239943;
363 emit Transfer(address(0x0), 0x85abe8e3bed0d4891ba201af1e212fe50bb65a26, 1060373239943);
364 balances[0xc446073e0c00a1138812b3a99a19df3cb8ace70d]=2032369859153;
365 emit Transfer(address(0x0), 0xc446073e0c00a1138812b3a99a19df3cb8ace70d, 2032369859153);
366 balances[0x195d65187a4aeb24b563dd2d52709a6b67064ad3]=235803680643;
367 emit Transfer(address(0x0), 0x195d65187a4aeb24b563dd2d52709a6b67064ad3, 235803680643);
368 balances[0x588611841bd8b134f3d6ca3ff2796b483dfca4c6]=27875;
369 emit Transfer(address(0x0), 0x588611841bd8b134f3d6ca3ff2796b483dfca4c6, 27875);
370 balances[0x43237ce180fc47cb4e3d32eb23e420f5ecf7a95e]=5087020825285;
371 emit Transfer(address(0x0), 0x43237ce180fc47cb4e3d32eb23e420f5ecf7a95e, 5087020825285);
372 balances[0x394299ef1650ac563a9adbec4061b25e50570f49]=65523270720;
373 emit Transfer(address(0x0), 0x394299ef1650ac563a9adbec4061b25e50570f49, 65523270720);
374 balances[0x0000bb50ee5f5df06be902d1f9cb774949c337ed]=728415;
375 emit Transfer(address(0x0), 0x0000bb50ee5f5df06be902d1f9cb774949c337ed, 728415);
376 balances[0x4927fb34fff626adb7b07305c447ac89ded8bea2]=15181318646;
377 emit Transfer(address(0x0), 0x4927fb34fff626adb7b07305c447ac89ded8bea2, 15181318646);
378 balances[0x93da7b2830e3932d906749e67a7ce1fbf3a5366d]=2768553093810;
379 emit Transfer(address(0x0), 0x93da7b2830e3932d906749e67a7ce1fbf3a5366d, 2768553093810);
380 balances[0x7f4924f55e215e1fe44e3b5bb7fdfced2154b30f]=506445600761;
381 emit Transfer(address(0x0), 0x7f4924f55e215e1fe44e3b5bb7fdfced2154b30f, 506445600761);
382 balances[0x9834977aa420b078b8fd47c73a9520f968d66a3a]=1035039327674;
383 emit Transfer(address(0x0), 0x9834977aa420b078b8fd47c73a9520f968d66a3a, 1035039327674);
384 balances[0x26b8c7606e828a509bbb208a0322cf960c17b225]=1314664139193;
385 emit Transfer(address(0x0), 0x26b8c7606e828a509bbb208a0322cf960c17b225, 1314664139193);
386 balances[0x8f3dd21c9334980030ba95c37565ba25df9574cd]=20273016051;
387 emit Transfer(address(0x0), 0x8f3dd21c9334980030ba95c37565ba25df9574cd, 20273016051);
388 balances[0x85d66f3a8da35f47e03d6bb51f51c2d70a61e12e]=10419370357974;
389 emit Transfer(address(0x0), 0x85d66f3a8da35f47e03d6bb51f51c2d70a61e12e, 10419370357974);
390 balances[0xbafc492638a2ec4f89aff258c8f18f806a844d72]=396663813367;
391 emit Transfer(address(0x0), 0xbafc492638a2ec4f89aff258c8f18f806a844d72, 396663813367);
392 balances[0x2f0d5a1d6bb5d7eaa0eaad39518621911a4a1d9f]=45613275677;
393 emit Transfer(address(0x0), 0x2f0d5a1d6bb5d7eaa0eaad39518621911a4a1d9f, 45613275677);
394 balances[0xae5910c6f3cd709bf497bae2b8eae8cf983aca1b]=561729123519;
395 emit Transfer(address(0x0), 0xae5910c6f3cd709bf497bae2b8eae8cf983aca1b, 561729123519);
396 balances[0xb963db36d28468ce64bce65e560e5f27e75f2f50]=50497795029;
397 emit Transfer(address(0x0), 0xb963db36d28468ce64bce65e560e5f27e75f2f50, 50497795029);
398 balances[0x7134161b9e6fa84d62f156037870ee77fa50f607]=806825;
399 emit Transfer(address(0x0), 0x7134161b9e6fa84d62f156037870ee77fa50f607, 806825);
400 balances[0x111fd8a12981d1174cfa8eef3b0141b3d5d4e5b3]=5023380788;
401 emit Transfer(address(0x0), 0x111fd8a12981d1174cfa8eef3b0141b3d5d4e5b3, 5023380788);
402 balances[0xafaf9a165408737e11191393fe695c1ebc7a5429]=3750469994332;
403 emit Transfer(address(0x0), 0xafaf9a165408737e11191393fe695c1ebc7a5429, 3750469994332);
404 balances[0x5329fcc196c445009aac138b22d25543ed195888]=126671028590;
405 emit Transfer(address(0x0), 0x5329fcc196c445009aac138b22d25543ed195888, 126671028590);
406 balances[0xa5b3725e37431dc6a103961749cb9c98954202cd]=446006353130;
407 emit Transfer(address(0x0), 0xa5b3725e37431dc6a103961749cb9c98954202cd, 446006353130);
408 balances[0xb8ab7387076f022c28481fafb28911ce4377e0ea]=3045242779146;
409 emit Transfer(address(0x0), 0xb8ab7387076f022c28481fafb28911ce4377e0ea, 3045242779146);
410 balances[0xd2470aacd96242207f06111819111d17ca055dfb]=957900008429;
411 emit Transfer(address(0x0), 0xd2470aacd96242207f06111819111d17ca055dfb, 957900008429);
412 balances[0x1fca39ed4f19edd12eb274dc467c099eb5106a13]=278753970706;
413 emit Transfer(address(0x0), 0x1fca39ed4f19edd12eb274dc467c099eb5106a13, 278753970706);
414 balances[0x8d12a197cb00d4747a1fe03395095ce2a5cc6819]=4743885756029;
415 emit Transfer(address(0x0), 0x8d12a197cb00d4747a1fe03395095ce2a5cc6819, 4743885756029);
416 balances[0x2a23527a6dbafae390514686d50f47747d01e44d]=652376852116;
417 emit Transfer(address(0x0), 0x2a23527a6dbafae390514686d50f47747d01e44d, 652376852116);
418 balances[0x371e31169df00563eafab334c738e66dd0476a8f]=226377928506;
419 emit Transfer(address(0x0), 0x371e31169df00563eafab334c738e66dd0476a8f, 226377928506);
420 balances[0x40ea0a2abc9479e51e411870cafd759cb110c258]=30282012248;
421 emit Transfer(address(0x0), 0x40ea0a2abc9479e51e411870cafd759cb110c258, 30282012248);
422 balances[0xe585ba86b84283f0f1118041837b06d03b96885e]=170791;
423 emit Transfer(address(0x0), 0xe585ba86b84283f0f1118041837b06d03b96885e, 170791);
424 balances[0xbede88c495132efb90b5039bc2942042e07814df]=40513641855;
425 emit Transfer(address(0x0), 0xbede88c495132efb90b5039bc2942042e07814df, 40513641855);
426         
427 
428 
429 // test lines 
430 //balances[msg.sender] = 21000 * (10 ** uint(decimals));
431 //timer[msg.sender ] = ( now - ( 1 years));
432 
433     }
434 
435 
436         function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
437             bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
438             if (digest != challenge_digest) revert();
439             if(uint256(digest) > miningTarget) revert();
440              bytes32 solution = solutionForChallenge[challengeNumber];
441              solutionForChallenge[challengeNumber] = digest;
442              if(solution != 0x0) revert();  //prevent the same answer from awarding twice
443              _claimTokens(msg.sender);
444              timer[msg.sender]=now;
445             uint reward_amount = getMiningReward();
446             balances[msg.sender] = balances[msg.sender].add(reward_amount);
447             tokensMinted = tokensMinted.add(reward_amount);
448             assert(tokensMinted <= maxSupplyForEra);
449             lastRewardTo = msg.sender;
450             lastRewardAmount = reward_amount;
451             lastRewardEthBlockNumber = block.number;
452              _startNewMiningEpoch();
453               emit Mint(msg.sender, reward_amount, epochCount, challengeNumber );
454               emit Transfer(address(0x0), msg.sender, reward_amount);
455            return true;
456         }
457 
458     function _startNewMiningEpoch() internal {
459       if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 39)
460       {
461         rewardEra = rewardEra + 1;
462       }
463       maxSupplyForEra = _totalSupply/10 - _totalSupply.div( 20**(rewardEra + 1));
464       epochCount = epochCount.add(1);
465       if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
466       {
467         _reAdjustDifficulty();
468       }
469       challengeNumber = block.blockhash(block.number - 1);
470     }
471 
472     function _reAdjustDifficulty() internal {
473         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
474         uint epochsMined = _BLOCKS_PER_READJUSTMENT; 
475         uint targetEthBlocksPerDiffPeriod = epochsMined * 60; //should be 60 times slower than ethereum
476         if( ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod )
477         {
478           uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div( ethBlocksSinceLastDifficultyPeriod );
479           uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
480           miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %
481         }else{
482           uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div( targetEthBlocksPerDiffPeriod );
483           uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
484           miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %
485         }
486         latestDifficultyPeriodStarted = block.number;
487         if(miningTarget < _MINIMUM_TARGET) //very difficult
488         {
489           miningTarget = _MINIMUM_TARGET;
490         }
491         if(miningTarget > _MAXIMUM_TARGET) //very easy
492         {
493           miningTarget = _MAXIMUM_TARGET;
494         }
495     }
496 
497     function getChallengeNumber() public constant returns (bytes32) {
498         return challengeNumber;
499     }
500 
501     function getMiningDifficulty() public constant returns (uint) {
502         return _MAXIMUM_TARGET.div(miningTarget);
503     }
504 
505     function getMiningTarget() public constant returns (uint) {
506        return miningTarget;
507    }
508 
509     function getMiningReward() public constant returns (uint) {
510          return (50 * 10**uint(decimals) ).div( 2**rewardEra ) ;
511     }
512 
513     function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
514         bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
515         return digest;
516       }
517       
518       function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
519           bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
520           if(uint256(digest) > testTarget) revert();
521           return (digest == challenge_digest);
522         }
523 
524     function totalSupply() public constant returns (uint) {
525         return _totalSupply;
526     }
527 
528     function balanceOf(address tokenOwner) public constant returns (uint balance) {
529         return balances[tokenOwner] + _getPoS(tokenOwner); // add unclaimed pos tokens 
530     }
531 
532     function transfer(address to, uint tokens) public returns (bool success) {
533         _claimTokens(msg.sender);
534         _claimTokens(to);
535         timer[msg.sender] = now;
536         timer[to] = now;
537         balances[msg.sender] = balances[msg.sender].sub(tokens);
538         balances[to] = balances[to].add(tokens);
539         emit Transfer(msg.sender, to, tokens);
540         return true;
541     }
542 
543     function approve(address spender, uint tokens) public returns (bool success) {
544         allowed[msg.sender][spender] = tokens;
545         emit Approval(msg.sender, spender, tokens);
546         return true;
547     }
548 
549     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
550         _claimTokens(from);
551         _claimTokens(to);
552         timer[from] = now;
553         timer[to] = now;
554         balances[from] = balances[from].sub(tokens);
555         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
556         balances[to] = balances[to].add(tokens);
557         emit Transfer(from, to, tokens);
558         return true;
559     }
560 
561     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
562         allowed[msg.sender][spender] = tokens;
563         emit Approval(msg.sender, spender, tokens);
564         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
565         return true;
566     }
567 
568     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
569         return allowed[tokenOwner][spender];
570     }
571 
572     function () public payable {
573         revert();
574     } 
575     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
576         return ERC20Interface(tokenAddress).transfer(owner, tokens);
577     }
578     
579     function claimTokens() public {
580         _claimTokens(msg.sender);        
581         timer[msg.sender] = now;
582     }
583     
584     function _claimTokens(address target) internal{
585         if (timer[target] == 0){
586             // russian hackers BTFO
587 
588             if (balances[target] > 0){
589                 // timer is handled in _getPoS 
590             }
591             else{
592                 return;
593             }
594         }
595         if (timer[target] == now){
596             // 0 seconds passed, 0 tokens gotten via PoS 
597             // return so no gas waste 
598             return;
599         }
600         
601         uint256 totalTkn = _getPoS(target);
602         if (totalTkn > 0){
603             balances[target] = balances[target].add(totalTkn);
604             //_totalSupply.add(totalTkn); total supply is fixed 
605             emit PoS(target, totalTkn);
606         }
607 
608         //timer[target] = now; every time you claim tokens this timer is set. this is to prevent people claiming 0 tokens and then setting their timer
609         emit Transfer(address(0x0), target, totalTkn);
610     }
611     
612     function getStakingRequirementTime(address target, uint256 TIME) view returns (uint256){
613 
614 
615 
616             return (stakingRequirement * fixedExp(((int(GLOBAL_START_TIMER) - int(TIME)) * one) / int(timerUnit)))/uint(one) ; 
617 
618     }
619     
620     function getRequirementTime(address target) view returns (uint256) {
621         uint256 balance = balances[target];
622         int ONE = 0x10000000000000000;
623         if (balance == 0){
624             return (uint256(0) - 1); // inf 
625         }
626         uint TIME = timer[target];
627         if (TIME == 0){
628             TIME = GLOBAL_START_TIMER;
629         }
630         
631         int ln = fixedLog((balance * uint(one)) / stakingRequirement);
632         int mul = (int(timerUnit) * ln) / (int(one));
633         uint pos = uint( -mul);
634         
635         
636         return (pos + GLOBAL_START_TIMER);
637     }
638     
639     function GetStakingNow() view returns (uint256){
640         return (stakingRequirement * fixedExp(((int(GLOBAL_START_TIMER) - int(now)) * one) / int(timerUnit)))/uint(one) ; 
641     }
642     
643 
644     
645     
646     function _getPoS(address target) internal view returns (uint256){
647         if (balances[target] == 0){
648             return 0;
649         }
650         int ONE_SECOND = 0x10000000000000000;
651         uint TIME = timer[target];
652         if (TIME == 0){
653             TIME = GLOBAL_START_TIMER;
654         }
655         if (balances[target] < getStakingRequirementTime(target, TIME)){
656             // staking requirement was too low at update 
657             // maybe it has since surpassed the requirement? 
658             uint flipTime = getRequirementTime(target);
659             if ( now > flipTime ){
660                 TIME = flipTime;
661             }
662             else{
663                 return 0;
664             }
665         }
666         int PORTION_SCALED = ( (int(GLOBAL_START_TIMER) - int(TIME)) * ONE_SECOND) / int(stakeUnit); 
667         uint256 exp = fixedExp(PORTION_SCALED);
668         
669         PORTION_SCALED = ( (int(GLOBAL_START_TIMER) - int(now)) * ONE_SECOND) / int(stakeUnit); 
670         uint256 exp2 = fixedExp(PORTION_SCALED);
671         
672         uint256 MULT = (9 * (exp.sub(exp2)) * (balances[target])) / (uint(one)); 
673         
674 
675         
676         return (MULT);
677     }
678     
679     
680     
681     int256 constant ln2       = 0x0b17217f7d1cf79ac;
682     int256 constant ln2_64dot5= 0x2cb53f09f05cc627c8;
683     int256 constant one       = 0x10000000000000000;
684     int256 constant c2 =  0x02aaaaaaaaa015db0;
685     int256 constant c4 = -0x000b60b60808399d1;
686     int256 constant c6 =  0x0000455956bccdd06;
687     int256 constant c8 = -0x000001b893ad04b3a;
688     uint256 constant sqrt2    = 0x16a09e667f3bcc908;
689     uint256 constant sqrtdot5 = 0x0b504f333f9de6484;
690     int256 constant c1        = 0x1ffffffffff9dac9b;
691     int256 constant c3        = 0x0aaaaaaac16877908;
692     int256 constant c5        = 0x0666664e5e9fa0c99;
693     int256 constant c7        = 0x049254026a7630acf;
694     int256 constant c9        = 0x038bd75ed37753d68;
695     int256 constant c11       = 0x03284a0c14610924f;
696     function fixedExp(int256 a) public pure returns (uint256 exp) {
697         int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
698         a -= scale*ln2;
699         // The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
700         // approximates the function x*(exp(x)+1)/(exp(x)-1)
701         // Hence exp(x) = (R(x)+x)/(R(x)-x)
702         int256 z = (a*a) / one;
703         int256 R = ((int256)(2) * one) +
704             (z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
705         exp = (uint256) (((R + a) * one) / (R - a));
706         if (scale >= 0)
707             exp <<= scale;
708         else
709             exp >>= -scale;
710         return exp;
711     }
712 
713     function fixedLog(uint256 a) internal pure returns (int256 log) {
714         int32 scale = 0;
715         while (a > sqrt2) {
716             a /= 2;
717             scale++;
718         }
719         while (a <= sqrtdot5) {
720             a *= 2;
721             scale--;
722         }
723         int256 s = (((int256)(a) - one) * one) / ((int256)(a) + one);
724         // The polynomial R = c1*x + c3*x^3 + ... + c11 * x^11
725         // approximates the function log(1+x)-log(1-x)
726         // Hence R(s) = log((1+s)/(1-s)) = log(a)
727         var z = (s*s) / one;
728         return scale * ln2 +
729             (s*(c1 + (z*(c3 + (z*(c5 + (z*(c7 + (z*(c9 + (z*c11/one))
730                 /one))/one))/one))/one))/one);
731     }
732 
733 }