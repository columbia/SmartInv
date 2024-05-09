1 pragma solidity ^0.4.18;
2 //Project-D presents...
3 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNmddddddddddddmNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
4 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNdhyso/-`````````````````````-/+ossdNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
5 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNdyo/``````````````````````````````````````../shNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
6 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMmyo:-``````````````````````````````````````````````````./shNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
7 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNhs/.```````````````````````````````````````````````````````````.-+hMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
8 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNyo-```````````````````````````````````````````````````````````````````.+ymMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
9 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMms/.`````````````````````````````````````````````````````````````````````````.-ohNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
10 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNy/.````````````````````````````````````````````````````````````````````````````````.+hNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
11 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMh+.``````````````````````````````````````````````````````````````````````````````````````-ymMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
12 //MMMMMMMMMMMMMMMMMMMMMMMMMMms-```````````````````````````````````````````````````````````````````````````````````````````.+dMMMMMMMMMMMMMMMMMMMMMMMMMMM
13 //MMMMMMMMMMMMMMMMMMMMMMMMm+.```````````````````````````````````````````````````````````````````````````````````````````````.:yMMMMMMMMMMMMMMMMMMMMMMMMM
14 //MMMMMMMMMMMMMMMMMMMMMMm+.````````````````````````````````````````````````````````````````````````````````````````````````````:yNMMMMMMMMMMMMMMMMMMMMMM
15 //MMMMMMMMMMMMMMMMMMMMmo.````````````````````````````````````````````````````````````````````````````````````````````````````````:hMMMMMMMMMMMMMMMMMMMMM
16 //MMMMMMMMMMMMMMMMMMmo.````````````````````````````````````````````````````````````````````````````````````````````````````````````:hMMMMMMMMMMMMMMMMMMM
17 //MMMMMMMMMMMMMMMMMy-````````````````````````````````````````````````````````````````````````````````````````````````````````````````+mMMMMMMMMMMMMMMMMM
18 //MMMMMMMMMMMMMMMm+```````````````````````````````````````````````````````````````````````````````````````````````````````````````````-hMMMMMMMMMMMMMMMM
19 //MMMMMMMMMMMMMMh-``````````````````````````````````````````````````````````````````````````````````````````````````````````````````````/mMMMMMMMMMMMMMM
20 //MMMMMMMMMMMMMo`````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````-mMMMMMMMMMMMMM
21 //MMMMMMMMMMMm/```````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````.sMMMMMMMMMMMM
22 //MMMMMMMMMMm-``````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````sMMMMMMMMMMM
23 //MMMMMMMMMd-````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````oNMMMMMMMMM
24 //MMMMMMMMd.``````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````````+MMMMMMMMM
25 //MMMMMMMm-````````````.-+yyyyyyhs+-.``````````````````````````````````````````````````````````````````````````````````````````````````````````sMMMMMMMM
26 //MMMMMMN:```````````./hmds+/::/+sdmh+.`````````````````````````````````````````````````````````````````````````````````````````````````````````yMMMMMMM
27 //MMMMMN/```````````:hms:``````````-ommo.```````````````````````````````````````````````````````````````````````````````````````````````````````.dMMMMMM
28 //MMMMM+```````````:mm:````-+oo+-````-dNd:```````````````````````````````````````````````````````````````````````````````````````````````````````:NMMMMM
29 //MMMMh```````````.mN:```.yNNNNNNy.```-mNm++++++++-``````-+++++++/.```````````````````````````````````````````````````````````````````````````````+MMMMM
30 //MMMM-```````````sNy````yNNNmy/oNd````oNNNNdyyyymms-``.smdyyyymNNh/```````````````````````````````````````````````````````````````````````````````hMMMM
31 //MMMh````````````NN/```.NNNN:.-+Nm:```.NNNNm/```.yNm+:dms````omNNNd```````````````````````````````````````````````````````````````````````````````:MMMM
32 //MMM-````````````NN````+NNNmohmho/`````NNNNhNs.```+mNmd:```-hNNNNy.````````````````````````````````````````````````````````````````````````````````dMMM
33 //MMh`````````````NN````oNNNmy+:+yd+````NNNN`omd:```-ss.```/mNNNm+``````````````````````````````````````````````````````````````````````````````````:MMM
34 //MM/`````````````NN````+ds/:ohNNNNo````NNNN``:dNo```````.sNNNNh-````````````````````````````````````````````````````````````````````````````````````NMM
35 //MN``````````````NN`````/sdNNNNNNNo````NNNN````yNh`````-mNNNNo``````````````````````````````````````````````````````````````````````````````````````yMM
36 //Ms``````````````NN-```.NNNNNdo:dN+````NNNN```:mN+``````sNNN:```````````````````````````````````````````````````````````````````````````````````````+MM
37 //Mo``````````````hNo````dNNm-``/Nm````+NNNm`.sNd-```..```:mNh-````````````...-////////////////:..```````````````````````````````````````````````````.MM
38 //Mo``````````````-Nm.```-dNN/:omm:```.dNNNo-dNs````oNm/```.yNm+`.-:/osyhhdmmddyysssooooooooooyhdmdhys+/-.````````````````````````````````````````````MM
39 //Mo```````````````+Nd.````+yhhy+````.hNNNNoNm:```-hNNNNy.```/mNhhdhyhhhhhhddddyo/-`.-/+ossssso-``+osssyhmdy+.````````````````````````````````````````NM
40 //M/````````````````+Nm+````````````:dNNNNNNy.```+mNNNNmNm/```-hNNNNNNNNNNms+-`.-/ohdNNNNNNNNNNd.`+NNNNmdhhhhNh/``````````````````````````````````````yM
41 //M-`````````````````-yNmy+::--::/sdNNNNNNNdooooyNNNNmddmNNhhhdmNNNNNNmy+-`../shmNNNmNNNNmmmNmNNs``oNmNmNNNmmhhmmo-```````````````````````````````````oM
42 //M:```````````````````-smNNNNNNNNNNNNmhsNNNNNNNNNNNssooooomNNNNNNNNN-`...+ymNNNNNNNNNNNNNNNNNNNN-``yNy``-+hNNmdhdNy/:::.`````````````````````````````sM
43 //M:``````````````````````:oshhhhhhso+dd+/:+oooooo+-``````.-osoooooo/..```.dNNNNNNNNNNNNNNNNNNNNNy``.mN-````:smNmmhddhddmy.```````````````````````````mM
44 //Ms````````````````````````````````.dm-.````````````````..-------:.````````:///+ooossyhhddmNNNNNN.``oNmhhhhhhmNNNNNNNhNyNo.``````````````````````````MM
45 //Mm````````````````````````````````yNo+ossooo+++hddhhhhhhmmmmmmmmo`````````````````````````....-:.--.osossyhhhdmNNNNNNy/sydmhs/-````````````````````-MM
46 //MM-``````````````````````````````.NhdyhhhNNmhddyNNyyso+sysosyNNmo`````````````````````````````````/:so/s/o+:::-./-/o+:````.:oydds/.````````````````oMM
47 //MMo``````````````````````````````sNsddyyNNss.:/:NoNNmyymdmhsdNNm/````````````````./syyyys/.```````:.:..o+/+/-:::y+oo+.```````..:ohmy:``````````````mMM
48 //MMd`````````````````````````````.mdhNNNNhNmh++syNmmhhhhhdmmdNNNNhyyyyyyyso++++++sdNNNNNNNNmo++///+s++/////:::::::://:-.....-ymmh+-/hm+````````````-MMM
49 //MMM-````````````````````````````ddo:+osssooossssssssssssyyyyyyyyhhhhhhhhdddddddddNNNNNNNNNNNNdsssssssssssssyyyyyhhhhhhyhhhhmNNNNNhyyddy```````````hMMM
50 //MMMh```````````````````````````.Ny/::---------..`````````````````..............-yNNNNNNNNNNNNm/---+/::::::::::::::://::://oNNmmmhmyyoyN.`````````:MMMM
51 //MMMM-``````````````````````````.Ndhdmmmmmmmmmmmdddddddddddddddhyyyyysssssssso//hNNNmdhhhyyhNNNmmmmmNmmmmmmmmmmmmmmmmmmmmmmmNNNNNmyyyshm``````````sMMMM
52 //MMMMd```````````````````````````omh+/yNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNmhmNNNNmhoNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNyhsmm+`````````:NMMMM
53 //MMMMMo```````````````````````````:hmyos+/ohNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNmhNNNNNNNNysNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNmsoN/`````````.dMMMMM
54 //MMMMMN:```````````````````````````.+yyhdyyyyhhddmNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNhNNNNNNNNNN/NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNmodm+``````````yMMMMMM
55 //MMMMMMm-`````````````````````````````..--:+oohNyNNNNNNmhdNdNNNNmmmmNNddmmNNNNNNNNyNNNNNNNNNNoNNNNNNNNNNNmmdmdNNmdddNNdNNNNNNmdmmyhN+``````````sMMMMMMM
56 //MMMMMMMm.````````````````````````````````````.dmdNNNNNNyymhNNNmmdNddmdmmhNNNNNNNNyNNNNNNNNNdsdddNNdhhhNmmddddddhyyyyhmdmmdmmmmmddms``````````/MMMMMMMM
57 //MMMMMMMMy.````````````````````````````````````.ymddmNNNNmNNNNmmmd+....:NdmNNNNNNNhhNNNNNNNm+hmdoo/:::::------..`````./sydddddmdhy/``````````:NMMMMMMMM
58 //MMMMMMMMMh-`````````````````````````````````````:shdmdmddmdddmho-``````oNdmNNNNNNNhhmNNNmhohmd-`````````````````````````.------.```````````oNMMMMMMMMM
59 //MMMMMMMMMMm-``````````````````````````````````````.-:/osssso/:.`````````omdmmNNNNNNdhsyyhhdNh.```````````````````````````````````````````.sMMMMMMMMMMM
60 //MMMMMMMMMMMm/````````````````````````````````````````````````````````````-ohdmmdmmmNNNmmmmdo.```````````````````````````````````````````.yMMMMMMMMMMMM
61 //MMMMMMMMMMMMNs.`````````````````````````````````````````````````````````````-/+shyyhhhhyy+-````````````````````````````````````````````-hMMMMMMMMMMMMM
62 //MMMMMMMMMMMMMMy.``````````````````````````````````````````````````````````````````````````````````````````````````````````````````````+mMMMMMMMMMMMMMM
63 //MMMMMMMMMMMMMMMd:```````````````````````````````````````````````````````````````````````````````````````````````````````````````````-yMMMMMMMMMMMMMMMM
64 //MMMMMMMMMMMMMMMMNs.```````````````````````````````````````````````````````````````````````````````````````````````````````````````.omMMMMMMMMMMMMMMMMM
65 //MMMMMMMMMMMMMMMMMMm+.````````````````````````````````````````````````````````````````````````````````````````````````````````````:hMMMMMMMMMMMMMMMMMMM
66 //MMMMMMMMMMMMMMMMMMMMh:.````````````````````````````````````````````````````````````````````````````````````````````````````````:yNMMMMMMMMMMMMMMMMMMMM
67 //MMMMMMMMMMMMMMMMMMMMMMh:.````````````````````````````````````````````````````````````````````````````````````````````````````:yNMMMMMMMMMMMMMMMMMMMMMM
68 //MMMMMMMMMMMMMMMMMMMMMMMMd+.````````````````````````````````````````````````````````````````````````````````````````````````-yNMMMMMMMMMMMMMMMMMMMMMMMM
69 //MMMMMMMMMMMMMMMMMMMMMMMMMMd+.```````````````````````````````````````````````````````````````````````````````````````````.+hNMMMMMMMMMMMMMMMMMMMMMMMMMM
70 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMmy:.``````````````````````````````````````````````````````````````````````````````````````.+dMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
71 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMms:.````````````````````````````````````````````````````````````````````````````````./hmMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
72 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMdo:.``````````````````````````````````````````````````````````````````````````-+ymMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
73 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMms-````````````````````````````````````````````````````````````````````.-ohNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
74 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMmho/.````````````````````````````````````````````````````````````-/ymMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
75 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNdy+-```````````````````````````````````````````````````./ohmMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
76 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMmhs+/-.``````````````````````````````````````.:+oymMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
77 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNdhys+/.``````````````````````.-:+osyhmMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
78 //MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNddddhhyshhhdddmNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
79 
80 // ----------------------------------------------------------------------------
81 
82 // 'HACHIROKU' token contract
83 
84 // Mineable ERC20 Token using Proof Of Work
85 
86 //
87 
88 // Symbol      : 0xAE86
89 
90 // Name        : HACHIROKU
91 
92 // Total supply: 86,000,000
93 
94 // Decimals    : 8
95 
96 // ----------------------------------------------------------------------------
97 
98 
99 
100 // ----------------------------------------------------------------------------
101 
102 // Safe maths
103 
104 // ----------------------------------------------------------------------------
105 
106 library SafeMath {
107 
108     function add(uint a, uint b) internal pure returns (uint c) {
109 
110         c = a + b;
111 
112         require(c >= a);
113 
114     }
115 
116     function sub(uint a, uint b) internal pure returns (uint c) {
117 
118         require(b <= a);
119 
120         c = a - b;
121 
122     }
123 
124     function mul(uint a, uint b) internal pure returns (uint c) {
125 
126         c = a * b;
127 
128         require(a == 0 || c / a == b);
129 
130     }
131 
132     function div(uint a, uint b) internal pure returns (uint c) {
133 
134         require(b > 0);
135 
136         c = a / b;
137 
138     }
139 
140 }
141 
142 
143 
144 library ExtendedMath {
145 
146 
147     //return the smaller of the two inputs (a or b)
148     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
149 
150         if(a > b) return b;
151 
152         return a;
153 
154     }
155 }
156 
157 // ----------------------------------------------------------------------------
158 
159 // ERC Token Standard #20 Interface
160 
161 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
162 
163 // ----------------------------------------------------------------------------
164 
165 contract ERC20Interface {
166 
167     function totalSupply() public constant returns (uint);
168 
169     function balanceOf(address tokenOwner) public constant returns (uint balance);
170 
171     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
172 
173     function transfer(address to, uint tokens) public returns (bool success);
174 
175     function approve(address spender, uint tokens) public returns (bool success);
176 
177     function transferFrom(address from, address to, uint tokens) public returns (bool success);
178 
179 
180     event Transfer(address indexed from, address indexed to, uint tokens);
181 
182     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
183 
184 }
185 
186 
187 
188 // ----------------------------------------------------------------------------
189 
190 // Contract function to receive approval and execute function in one call
191 
192 //
193 
194 // Borrowed from MiniMeToken
195 
196 // ----------------------------------------------------------------------------
197 
198 contract ApproveAndCallFallBack {
199 
200     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
201 
202 }
203 
204 
205 
206 // ----------------------------------------------------------------------------
207 
208 // Owned contract
209 
210 // ----------------------------------------------------------------------------
211 
212 contract Owned {
213 
214     address public owner;
215 
216     address public newOwner;
217 
218 
219     event OwnershipTransferred(address indexed _from, address indexed _to);
220 
221 
222     function Owned() public {
223 
224         owner = msg.sender;
225 
226     }
227 
228 
229     modifier onlyOwner {
230 
231         require(msg.sender == owner);
232 
233         _;
234 
235     }
236 
237 
238     function transferOwnership(address _newOwner) public onlyOwner {
239 
240         newOwner = _newOwner;
241 
242     }
243 
244     function acceptOwnership() public {
245 
246         require(msg.sender == newOwner);
247 
248         OwnershipTransferred(owner, newOwner);
249 
250         owner = newOwner;
251 
252         newOwner = address(0);
253 
254     }
255 
256 }
257 
258 
259 
260 // ----------------------------------------------------------------------------
261 
262 // ERC20 Token, with the addition of symbol, name and decimals and an
263 
264 // initial fixed supply
265 
266 // ----------------------------------------------------------------------------
267 
268 contract _0xAE86Token is ERC20Interface, Owned {
269 
270     using SafeMath for uint;
271     using ExtendedMath for uint;
272 
273 
274     string public symbol;
275 
276     string public  name;
277 
278     uint8 public decimals;
279 
280     uint public _totalSupply;
281 
282 
283 
284      uint public latestDifficultyPeriodStarted;
285 
286 
287 
288     uint public epochCount;//number of 'blocks' mined
289 
290 
291     uint public _BLOCKS_PER_READJUSTMENT = 100;
292 
293 
294     //a little number
295     uint public  _MINIMUM_TARGET = 2**16;
296 
297 
298       //a big number is easier ; just find a solution that is smaller
299     //uint public  _MAXIMUM_TARGET = 2**224;  bitcoin uses 224
300     uint public  _MAXIMUM_TARGET = 2**234;
301 
302 
303     uint public miningTarget;
304 
305     bytes32 public challengeNumber;   //generate a new one when a new reward is minted
306 
307 
308 
309     uint public rewardEra;
310     uint public maxSupplyForEra;
311 
312 
313     address public lastRewardTo;
314     uint public lastRewardAmount;
315     uint public lastRewardEthBlockNumber;
316 
317     bool locked = false;
318 
319     mapping(bytes32 => bytes32) solutionForChallenge;
320 
321     uint public tokensMinted;
322 
323     mapping(address => uint) balances;
324 
325 
326     mapping(address => mapping(address => uint)) allowed;
327 
328 
329     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
330 
331     // ------------------------------------------------------------------------
332 
333     // Constructor
334 
335     // ------------------------------------------------------------------------
336 
337     function _0xAE86Token() public onlyOwner{
338 
339 
340 
341         symbol = "0xAE86";
342 
343         name = "HACHIROKU";
344 
345         decimals = 8;
346 
347         _totalSupply = 86000000 * 10**uint(decimals);
348 
349         if(locked) revert();
350         locked = true;
351 
352         tokensMinted = 860000 * 10**uint(decimals);
353 
354         rewardEra = 0;
355         maxSupplyForEra = _totalSupply.div(2);
356 
357         miningTarget = _MAXIMUM_TARGET;
358 
359         latestDifficultyPeriodStarted = block.number;
360 
361         _startNewMiningEpoch();
362 
363 
364         //1% premine for the swap and future developement
365         balances[owner] = tokensMinted;
366         Transfer(address(0), owner, tokensMinted);
367 
368     }
369 
370 
371 
372 
373         function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
374 
375 
376             //the PoW must contain work that includes a recent ethereum block hash (challenge number) and the msg.sender's address to prevent MITM attacks
377             bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
378 
379             //the challenge digest must match the expected
380             if (digest != challenge_digest) revert();
381 
382             //the digest must be smaller than the target
383             if(uint256(digest) > miningTarget) revert();
384 
385 
386             //only allow one reward for each challenge
387              bytes32 solution = solutionForChallenge[challengeNumber];
388              solutionForChallenge[challengeNumber] = digest;
389              if(solution != 0x0) revert();  //prevent the same answer from awarding twice
390 
391 
392             uint reward_amount = getMiningReward();
393 
394             balances[msg.sender] = balances[msg.sender].add(reward_amount);
395 
396             tokensMinted = tokensMinted.add(reward_amount);
397 
398 
399             //Cannot mint more tokens than there are
400             assert(tokensMinted <= maxSupplyForEra);
401 
402             //set readonly diagnostics data
403             lastRewardTo = msg.sender;
404             lastRewardAmount = reward_amount;
405             lastRewardEthBlockNumber = block.number;
406 
407 
408              _startNewMiningEpoch();
409 
410               Mint(msg.sender, reward_amount, epochCount, challengeNumber );
411 
412            return true;
413 
414         }
415 
416 
417     //a new 'block' to be mined
418     function _startNewMiningEpoch() internal {
419 
420       //if max supply for the era will be exceeded next reward round then enter the new era before that happens
421 
422       //40 is the final reward era, almost all tokens minted
423       //once the final era is reached, more tokens will not be given out because the assert function
424       if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 39)
425       {
426         rewardEra = rewardEra + 1;
427       }
428 
429       //set the next minted supply at which the era will change
430       // total supply is 8600000000000000  because of 8 decimal places
431       maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
432 
433       epochCount = epochCount.add(1);
434 
435       //every so often, readjust difficulty. Dont readjust when deploying
436       if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
437       {
438         _reAdjustDifficulty();
439       }
440 
441 
442       //make the latest ethereum block hash a part of the next challenge for PoW to prevent pre-mining future blocks
443       //do this last since this is a protection mechanism in the mint() function
444       challengeNumber = block.blockhash(block.number - 1);
445 
446 
447 
448 
449 
450 
451     }
452 
453 
454 
455 
456     //https://en.bitcoin.it/wiki/Difficulty#What_is_the_formula_for_difficulty.3F
457     //as of 2017 the bitcoin difficulty was up to 17 zeroes, it was only 8 in the early days
458 
459     //readjust the target by 5 percent
460     function _reAdjustDifficulty() internal {
461 
462 
463         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
464         //assume 360 ethereum blocks per hour
465 
466         //we want miners to spend 1 minutes to mine each 'block', about 6 ethereum blocks = one 0xAE86 epoch
467         uint epochsMined = _BLOCKS_PER_READJUSTMENT; //256
468 
469         uint targetEthBlocksPerDiffPeriod = epochsMined * 6; //should be 6 times slower than ethereum
470 
471         //if there were less eth blocks passed in time than expected
472         if( ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod )
473         {
474           uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div( ethBlocksSinceLastDifficultyPeriod );
475 
476           uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
477           // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.
478 
479           //make it harder
480           miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %
481         }else{
482           uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div( targetEthBlocksPerDiffPeriod );
483 
484           uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
485 
486           //make it easier
487           miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %
488         }
489 
490 
491 
492         latestDifficultyPeriodStarted = block.number;
493 
494         if(miningTarget < _MINIMUM_TARGET) //very difficult
495         {
496           miningTarget = _MINIMUM_TARGET;
497         }
498 
499         if(miningTarget > _MAXIMUM_TARGET) //very easy
500         {
501           miningTarget = _MAXIMUM_TARGET;
502         }
503     }
504 
505 
506     //this is a recent ethereum block hash, used to prevent pre-mining future blocks
507     function getChallengeNumber() public constant returns (bytes32) {
508         return challengeNumber;
509     }
510 
511     //the number of zeroes the digest of the PoW solution requires.  Auto adjusts
512      function getMiningDifficulty() public constant returns (uint) {
513         return _MAXIMUM_TARGET.div(miningTarget);
514     }
515 
516     function getMiningTarget() public constant returns (uint) {
517        return miningTarget;
518    }
519 
520 
521 
522     //86m tokens total
523     //reward begins at 86 and is cut in half every reward era (as tokens are mined)
524     function getMiningReward() public constant returns (uint) {
525         //once we get half way thru the coins, only get 43 per block
526 
527          //every reward era, the reward amount halves.
528 
529          return (86 * 10**uint(decimals) ).div( 2**rewardEra ) ;
530 
531     }
532 
533     //help debug mining software
534     function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
535 
536         bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
537 
538         return digest;
539 
540       }
541 
542         //help debug mining software
543       function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
544 
545           bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
546 
547           if(uint256(digest) > testTarget) revert();
548 
549           return (digest == challenge_digest);
550 
551         }
552 
553 
554 
555     // ------------------------------------------------------------------------
556 
557     // Total supply
558 
559     // ------------------------------------------------------------------------
560 
561     function totalSupply() public constant returns (uint) {
562 
563         return _totalSupply  - balances[address(0)];
564 
565     }
566 
567 
568 
569     // ------------------------------------------------------------------------
570 
571     // Get the token balance for account `tokenOwner`
572 
573     // ------------------------------------------------------------------------
574 
575     function balanceOf(address tokenOwner) public constant returns (uint balance) {
576 
577         return balances[tokenOwner];
578 
579     }
580 
581 
582 
583     // ------------------------------------------------------------------------
584 
585     // Transfer the balance from token owner's account to `to` account
586 
587     // - Owner's account must have sufficient balance to transfer
588 
589     // - 0 value transfers are allowed
590 
591     // ------------------------------------------------------------------------
592 
593     function transfer(address to, uint tokens) public returns (bool success) {
594 
595         balances[msg.sender] = balances[msg.sender].sub(tokens);
596 
597         balances[to] = balances[to].add(tokens);
598 
599         Transfer(msg.sender, to, tokens);
600 
601         return true;
602 
603     }
604 
605 
606 
607     // ------------------------------------------------------------------------
608 
609     // Token owner can approve for `spender` to transferFrom(...) `tokens`
610 
611     // from the token owner's account
612 
613     //
614 
615     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
616 
617     // recommends that there are no checks for the approval double-spend attack
618 
619     // as this should be implemented in user interfaces
620 
621     // ------------------------------------------------------------------------
622 
623     function approve(address spender, uint tokens) public returns (bool success) {
624 
625         allowed[msg.sender][spender] = tokens;
626 
627         Approval(msg.sender, spender, tokens);
628 
629         return true;
630 
631     }
632 
633 
634 
635     // ------------------------------------------------------------------------
636 
637     // Transfer `tokens` from the `from` account to the `to` account
638 
639     //
640 
641     // The calling account must already have sufficient tokens approve(...)-d
642 
643     // for spending from the `from` account and
644 
645     // - From account must have sufficient balance to transfer
646 
647     // - Spender must have sufficient allowance to transfer
648 
649     // - 0 value transfers are allowed
650 
651     // ------------------------------------------------------------------------
652 
653     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
654 
655         balances[from] = balances[from].sub(tokens);
656 
657         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
658 
659         balances[to] = balances[to].add(tokens);
660 
661         Transfer(from, to, tokens);
662 
663         return true;
664 
665     }
666 
667 
668 
669     // ------------------------------------------------------------------------
670 
671     // Returns the amount of tokens approved by the owner that can be
672 
673     // transferred to the spender's account
674 
675     // ------------------------------------------------------------------------
676 
677     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
678 
679         return allowed[tokenOwner][spender];
680 
681     }
682 
683 
684 
685     // ------------------------------------------------------------------------
686 
687     // Token owner can approve for `spender` to transferFrom(...) `tokens`
688 
689     // from the token owner's account. The `spender` contract function
690 
691     // `receiveApproval(...)` is then executed
692 
693     // ------------------------------------------------------------------------
694 
695     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
696 
697         allowed[msg.sender][spender] = tokens;
698 
699         Approval(msg.sender, spender, tokens);
700 
701         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
702 
703         return true;
704 
705     }
706 
707 
708 
709     // ------------------------------------------------------------------------
710 
711     // Don't accept ETH
712 
713     // ------------------------------------------------------------------------
714 
715     function () public payable {
716 
717         revert();
718 
719     }
720 
721 
722 
723     // ------------------------------------------------------------------------
724 
725     // Owner can transfer out any accidentally sent ERC20 tokens
726 
727     // ------------------------------------------------------------------------
728 
729     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
730 
731         return ERC20Interface(tokenAddress).transfer(owner, tokens);
732 
733     }
734 
735 }