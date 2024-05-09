1 pragma solidity ^0.4.18;
2 
3 
4 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNK0kxolc:;,,'''''''''',,;:cloxk0KNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
5 // MMMMMMMMMMMMMMMMMMMMMMMMMMMWN0kdl:,''''',,;;:::::cc:::::;;,,''''';:ldk0NWMMMMMMMMMMMMMMMMMMMMMMMMMMM
6 // MMMMMMMMMMMMMMMMMMMMMMMWN0xo:,''',;:cloodxxkkkkkkkkkkkkkkxxdoolc:;,''',:ox0NWMMMMMMMMMMMMMMMMMMMMMMM
7 // MMMMMMMMMMMMMMMMMMMMWXOdc,''';:lodxkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkxdoc:;''',cdOXWMMMMMMMMMMMMMMMMMMMM
8 // MMMMMMMMMMMMMMMMMMN0d:,'',:loxkkkkkkkkkkkkkkkkkkkkkxodkkkkkkkkkkkkkkkkxol:,'',:d0NMMMMMMMMMMMMMMMMMM
9 // MMMMMMMMMMMMMMMWXxc,'',:ldxkkkkkkkkkkkkkkkkkkkkkxl:;cxkkkkkkkkkkkkkkkkkkkxdl:,'',cxXWMMMMMMMMMMMMMMM
10 // MMMMMMMMMMMMMWKd:''';ldxkkkkkkkkkkkkkkkkkkkkkkxo:'';dkkkkkkkkkkkkkkkkkkkkkkkxdl;''':dKWMMMMMMMMMMMMM
11 // MMMMMMMMMMMWKd;'',:oxxkkxxkkxkkxxxxxxxxxkkxkkxl,'',cxxkkxxxxxxxxxkkkxkkkxkkxkkxxo:,'';dKWMMMMMMMMMMM
12 // MMMMMMMMMMXx:'',:oxxxxxxxxxxxxxxxxxxxxxxxxxxxl,'',:oxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxo:,'':xXMMMMMMMMMM
13 // MMMMMMMMW0c''':oxxxxxxxxxxxxxxxxxxxxxxxxxxxxd;''';coxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxo:'''c0WMMMMMMMM
14 // MMMMMMMXx;'';ldxxxxxxxxxxxxxxxxxxxxxxxxxxxxxc,''';coxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdl;'';xXMMMMMMM
15 // MMMMMMKl,'':oxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxd:'''',:lxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxo:'',lKMMMMMM
16 // MMMMW0c'',cdxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxd:'''',;ldxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdc,''c0WMMMM
17 // MMMW0c'',cdxddddddddddddddddddddddddddddxddo:'''''':dddddddooddxddddddddddddddddddddddddxdl,''c0WMMM
18 // MMW0c'',lddddddddddddddddddddddddddddddddddd:'''''',lddddddoc:lddddddddddddddddddddddddddddl,''c0MMM
19 // MMKl'',cddddddddddddddddddddddddddddddddddddc''''''':oddddddl,,codddddddddddddddddddddddddddc,''lKMM
20 // MNd,''coddddddddddddddddddddddddddddddddddddc,'''''',cddddddo:'';codddddddddddddddddddddddddoc'',dNM
21 // WO;'';odddddddddddddddddddddddddddddddddddddl,''''''';lddddddl,''';loddddddddddddddddddddddddo:'';OW
22 // Xl'',codoodddddddddddddddddddddddoddddoollodl;'''''''';loddodo:'''',:odooddddddddddddddoodddool,''lX
23 // k;'':oooooooooooooooooooooooooooooooooo:,cooo;''''''''',cooooo:'''''';loooooooooooooooooooooooo:'';k
24 // o'',cooooooooooooooooooooooooooooooool;'':ooo:'''''''''',:loooc,'''''',:oooooooooooooooooooooooc,''o
25 // :'';loooooooooooooooooooooooooooooooc;''':ooo:'''''''''''';cll:''''''''';loooooooooooooooooooool;'':
26 // ,'';loooooooooooooooooooooooooooool:,''',coooc'''''''''''''',,''''''''''';looooooooooooooooooool;'';
27 // ''':loooooooooooooooooooooooooool:,''''';loooc,''''''''''''''''''''''''''';coooooooooooooooooool:'''
28 // ''':loolllllllllllllllllloollllc;'''''',cllllc,'''''''''''''''''''''''''''';cllollllllllllllolll:'''
29 // ''':lllllllllllllllllllllllllc;'''''''';lllllc,''''''''''''''''''''''''''''';lllllllllllllllllll:'''
30 // ,'';lllllllllllllllllllllllc;''''''''',clllllc,'''''''''''''''''''''''''''''':llllllllllllllllll;'',
31 // ;'';cllllllllllllllllllllc:,'''''''''':llllll:,'''''',,'''''''''''''''''''''',:llllllllllllllllc;'';
32 // c'',:lllllllllllllllllll:,''''''''''',:lllllc;'''''''cc''''''''''''''''''''''';clllllllllllllll:,''l
33 // x,'';cllllllllllllccllc:,''''''''''''',:cccc;''''''',oo;''''''''''''''''''''''':clllllllcllcllc;'',x
34 // 0:'',ccccccccccccccccc;''''''''''''''''',,,''''''''':dd;''''''''''''''''''''''',ccccccccccccccc,'':0
35 // Nd,'';ccccccccccccccc;''''''''''''''''''''''''''''';oxd;'''''''''''''''''''''''':ccccccccccccc;'',dN
36 // MKc'',:ccccccccccccc;'''''''''''';:,''''''''''''',;ldxo;'''''''''''''''''''''''';cccccccccccc:,''cKM
37 // MWO;'',:ccccccccccc:,''''''''''';odl;''''''''''',lodddl,'''''''''''''''''''''''';:cccccccccc:,'';OWM
38 // MMWx,'',:cccccccccc;''''''''''';ldddo:,''''''',:ldddddc''''''''''''''''''''''''',:ccccccccc:,'',xWMM
39 // MMMNd,'',:::c::c:c:,'''''''''',coooodolc;,,,;:looodddo;''''''''''''''''''''''''',:c::::ccc:,'',dNMMM
40 // MMMMNd,'',:::::::::,'''''''''';loooooooooolloooooooooc,''''''''''''''''''''''''';:::::::::,'',xNMMMM
41 // MMMMMNx;'',;:::::::,'''''''''':looooooooooooooooooooo:''''''''''''''''''''''''',;:::::::;,'';xNMMMMM
42 // MMMMMMWOc''',::::::;''''''''',:llllllllllllllllllllll:''''''''''''''''''''''''',::::::;,'''cOWMMMMMM
43 // MMMMMMMMKo,'',;::::;,'''''''',:llllllllllllllllllllll:'''''';;'''''''''''''''',;:::::;,'',oKMMMMMMMM
44 // MMMMMMMMMNOc''',;;:;,'''''''',:lllllllllllllllllllcll:,'''',:c,''''''''''''''';;:::;,'''ckNMMMMMMMMM
45 // MMMMMMMMMMWXx:''',;;;,'''''''':ccccccccccccccccccccccc:;,,,:cc;'''''''''''''',;;;;,''':xXWMMMMMMMMMM
46 // MMMMMMMMMMMMWKd;''',,;,''''''';ccccccccccccccccccccccccc::cccc;''''''''''''',;;,,''':dKWMMMMMMMMMMMM
47 // MMMMMMMMMMMMMMWXxc,''',''''''',:::::::::::::::::::::::::::::::;'''''''''''',,,''',:xXWMMMMMMMMMMMMMM
48 // MMMMMMMMMMMMMMMMWXOo;'''''''''',::::::::::::::::::::::::::::::,'''''''''''''''';lONWMMMMMMMMMMMMMMMM
49 // MMMMMMMMMMMMMMMMMMMWKkl;'''''''',;:::::::::::::::::::::::::::;,''''''''''''';lkKWMMMMMMMMMMMMMMMMMMM
50 // MMMMMMMMMMMMMMMMMMMMMMWKko:,''''',,;;;;;;;;;;;;;;;;;;;;;;;;;;,'''''''''',:okKWMMMMMMMMMMMMMMMMMMMMMM
51 // MMMMMMMMMMMMMMMMMMMMMMMMMWN0koc;,'''''',,,,,,,,,,,,,,,,,,,,,''''''',;cok0NWMMMMMMMMMMMMMMMMMMMMMMMMM
52 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNX0kdlc;,,'''''''''''''''''''',,:cldk0XNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
53 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNKOxdlc:;,,'''''',,;;cloxOKNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
54 //
55 // ----------------------------------------------------------------------------------------------------
56 //
57 // Website: https://skorch.io 
58 // Reddit: https://reddit.com/r/SkorchToken
59 // Twitter: https://twitter.com/SkorchToken
60 
61 library SafeMath {
62 
63     function add(uint a, uint b) internal pure returns (uint c) {
64         c = a + b;
65         require(c >= a);
66     }
67 
68     function sub(uint a, uint b) internal pure returns (uint c) {
69         require(b <= a);
70         c = a - b;
71     }
72 
73     function mul(uint a, uint b) internal pure returns (uint c) {
74         c = a * b;
75         require(a == 0 || c / a == b);
76     }
77 
78     function div(uint a, uint b) internal pure returns (uint c) {
79         require(b > 0);
80         c = a / b;
81     }
82 }
83 
84 library ExtendedMath {
85     //return the smaller of the two inputs (a or b)
86     function limitLessThan(uint a, uint b) internal pure returns (uint c) {
87         if(a > b) return b;
88         return a;
89     }
90 }
91 
92 contract ERC20Interface {
93     function totalSupply() public constant returns (uint);
94     function balanceOf(address tokenOwner) public constant returns (uint balance);
95     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
96     function transfer(address to, uint tokens) public returns (bool success);
97     function approve(address spender, uint tokens) public returns (bool success);
98     function transferFrom(address from, address to, uint tokens) public returns (bool success);
99     event Transfer(address indexed from, address indexed to, uint tokens);
100     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
101 }
102 
103 contract ApproveAndCallFallBack {
104     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
105 }
106 
107 contract Owned {
108 
109     address public owner;
110 
111     address public newOwner;
112 
113     event OwnershipTransferred(address indexed _from, address indexed _to);
114 
115     constructor() public {
116         owner = msg.sender;
117     }
118 
119 
120     modifier onlyOwner {
121         require(msg.sender == owner);
122         _;
123     }
124 
125 
126     function transferOwnership(address _newOwner) public onlyOwner {
127         newOwner = _newOwner;
128     }
129 
130     function acceptOwnership() public {
131         require(msg.sender == newOwner);
132         emit OwnershipTransferred(owner, newOwner);
133         owner = newOwner;
134         newOwner = address(0);
135     }
136 }
137 
138 contract SkorchToken is ERC20Interface, Owned {
139 
140     using SafeMath for uint;
141     using ExtendedMath for uint;
142 
143     string public symbol;
144 
145     string public  name;
146 
147     uint8 public decimals;
148 
149     uint public _totalSupply;
150     uint public latestDifficultyPeriodStarted;
151     uint public epochCount;
152     uint public _BLOCKS_PER_READJUSTMENT = 1024;
153 
154     uint public  _MINIMUM_TARGET = 2**16;
155 
156     uint public  _MAXIMUM_TARGET = 2**234;
157 
158     uint public miningTarget;
159     
160     uint256 public MinimumPoStokens = 20000 * 10**uint(decimals); // set minimum tokens to stake 
161 
162     bytes32 public challengeNumber;   //generate a new one when a new reward is minted
163 
164     uint public rewardEra;
165     uint public maxSupplyForEra;
166 
167     address public lastRewardTo;
168     uint public lastRewardAmount;
169     uint public lastRewardEthBlockNumber;
170 
171     mapping(bytes32 => bytes32) solutionForChallenge;
172 
173     uint public tokensMinted;
174 
175     mapping(address => uint) balances;
176 
177     mapping(address => mapping(address => uint)) allowed;
178     
179     mapping(address => uint256) timer; // timer to check PoS 
180     
181     // how to calculate doubleUnit: 
182     // specify how much percent increase you want per year 
183     // e.g. 130% -> 2.3 multiplier every year 
184     // now divide (1 years) by LOG(2.3) where LOG is the natural logarithm (not LOG10)
185     // in this case LOG(2.3) is 0.83290912293
186     // hence multiplying by 1/0.83290912293 is the same 
187     // 31536000 = 1 years (to prevent deprecated warning in solc)
188     uint256 doubleUnit = (31536000) * 1.2;
189 
190     event Mint(address indexed from, uint reward_amount, uint epochCount, bytes32 newChallengeNumber);
191 
192     constructor()
193         public 
194         onlyOwner()
195     {
196         symbol = "SKO";
197         name = "Skorch Token";
198         decimals = 18;
199         // uncomment this to test 
200         //balances[msg.sender] = (20000) * (10 ** uint(decimals)); // change 20000 to some lower number than 20000 
201         //to see you will not get PoS tokens if you have less than 20000 tokens 
202         //timer[msg.sender] = now - (1 years);
203         _totalSupply = 21000000 * 10**uint(decimals);
204         tokensMinted = 0;
205         rewardEra = 0;
206         maxSupplyForEra = _totalSupply.div(2);
207         miningTarget = _MAXIMUM_TARGET;
208         latestDifficultyPeriodStarted = block.number;
209         _startNewMiningEpoch();
210         
211         
212     }
213     
214     function setPosTokens(uint256 newTokens)
215         public 
216         onlyOwner
217     {
218         require(newTokens >= 100000);
219         // note: newTokens should be multiplied with 10**uint(decimals) (10^18);
220         // require is in place to prevent fuck up. for 1000 tokens you need to enter 1000* 10^18 
221         MinimumPoStokens = newTokens;
222     }
223 
224         function mint(uint256 nonce, bytes32 challenge_digest) public returns (bool success) {
225             bytes32 digest =  keccak256(challengeNumber, msg.sender, nonce );
226             if (digest != challenge_digest) revert();
227             if(uint256(digest) > miningTarget) revert();
228              bytes32 solution = solutionForChallenge[challengeNumber];
229              solutionForChallenge[challengeNumber] = digest;
230              if(solution != 0x0) revert();  //prevent the same answer from awarding twice
231              _claimTokens(msg.sender);
232             uint reward_amount = getMiningReward();
233             balances[msg.sender] = balances[msg.sender].add(reward_amount);
234             tokensMinted = tokensMinted.add(reward_amount);
235             assert(tokensMinted <= maxSupplyForEra);
236             lastRewardTo = msg.sender;
237             lastRewardAmount = reward_amount;
238             lastRewardEthBlockNumber = block.number;
239              _startNewMiningEpoch();
240               emit Mint(msg.sender, reward_amount, epochCount, challengeNumber );
241            return true;
242         }
243 
244     function _startNewMiningEpoch() internal {
245       if( tokensMinted.add(getMiningReward()) > maxSupplyForEra && rewardEra < 39)
246       {
247         rewardEra = rewardEra + 1;
248       }
249       maxSupplyForEra = _totalSupply - _totalSupply.div( 2**(rewardEra + 1));
250       epochCount = epochCount.add(1);
251       if(epochCount % _BLOCKS_PER_READJUSTMENT == 0)
252       {
253         _reAdjustDifficulty();
254       }
255       challengeNumber = block.blockhash(block.number - 1);
256     }
257 
258     function _reAdjustDifficulty() internal {
259         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
260         uint epochsMined = _BLOCKS_PER_READJUSTMENT; 
261         uint targetEthBlocksPerDiffPeriod = epochsMined * 60; //should be 60 times slower than ethereum
262         if( ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod )
263         {
264           uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(100)).div( ethBlocksSinceLastDifficultyPeriod );
265           uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(1000);
266           miningTarget = miningTarget.sub(miningTarget.div(2000).mul(excess_block_pct_extra));   //by up to 50 %
267         }else{
268           uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(100)).div( targetEthBlocksPerDiffPeriod );
269           uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(1000); //always between 0 and 1000
270           miningTarget = miningTarget.add(miningTarget.div(2000).mul(shortage_block_pct_extra));   //by up to 50 %
271         }
272         latestDifficultyPeriodStarted = block.number;
273         if(miningTarget < _MINIMUM_TARGET) //very difficult
274         {
275           miningTarget = _MINIMUM_TARGET;
276         }
277         if(miningTarget > _MAXIMUM_TARGET) //very easy
278         {
279           miningTarget = _MAXIMUM_TARGET;
280         }
281     }
282 
283     function getChallengeNumber() public constant returns (bytes32) {
284         return challengeNumber;
285     }
286 
287     function getMiningDifficulty() public constant returns (uint) {
288         return _MAXIMUM_TARGET.div(miningTarget);
289     }
290 
291     function getMiningTarget() public constant returns (uint) {
292        return miningTarget;
293    }
294 
295     function getMiningReward() public constant returns (uint) {
296          return (50 * 10**uint(decimals) ).div( 2**rewardEra ) ;
297     }
298 
299     function getMintDigest(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number) public view returns (bytes32 digesttest) {
300         bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
301         return digest;
302       }
303       
304       function checkMintSolution(uint256 nonce, bytes32 challenge_digest, bytes32 challenge_number, uint testTarget) public view returns (bool success) {
305           bytes32 digest = keccak256(challenge_number,msg.sender,nonce);
306           if(uint256(digest) > testTarget) revert();
307           return (digest == challenge_digest);
308         }
309 
310     function totalSupply() public constant returns (uint) {
311         return _totalSupply;
312     }
313 
314     function balanceOf(address tokenOwner) public constant returns (uint balance) {
315         return balances[tokenOwner];// + _getPoS(tokenOwner); // add unclaimed pos tokens 
316     }
317 
318     function transfer(address to, uint tokens) public returns (bool success) {
319         _claimTokens(msg.sender);
320         _claimTokens(to);
321         balances[msg.sender] = balances[msg.sender].sub(tokens);
322         balances[to] = balances[to].add(tokens);
323         emit Transfer(msg.sender, to, tokens);
324         return true;
325     }
326 
327     function approve(address spender, uint tokens) public returns (bool success) {
328         allowed[msg.sender][spender] = tokens;
329         emit Approval(msg.sender, spender, tokens);
330         return true;
331     }
332 
333     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
334         _claimTokens(from);
335         _claimTokens(to);
336         balances[from] = balances[from].sub(tokens);
337         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
338         balances[to] = balances[to].add(tokens);
339         emit Transfer(from, to, tokens);
340         return true;
341     }
342 
343     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
344         allowed[msg.sender][spender] = tokens;
345         emit Approval(msg.sender, spender, tokens);
346         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
347         return true;
348     }
349 
350     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
351         return allowed[tokenOwner][spender];
352     }
353 
354     function () public payable {
355         revert();
356     } 
357     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
358         return ERC20Interface(tokenAddress).transfer(owner, tokens);
359     }
360     
361     function claimTokens() public {
362         _claimTokens(msg.sender);        
363     }
364     
365     function _claimTokens(address target) internal{
366         if (timer[target] == 0){
367             // russian hackers BTFO
368             return;
369         }
370         if (timer[target] == now){
371             // 0 seconds passed, 0 tokens gotten via PoS 
372             // return so no gas waste 
373             return;
374         }
375         
376         uint256 totalTkn = _getPoS(target);
377         balances[target] = balances[target].add(totalTkn);
378         _totalSupply.add(totalTkn);
379         timer[target] = now;
380         emit Transfer(address(0x0), target, totalTkn);
381     }
382     
383     function _getPoS(address target) internal view returns (uint256){
384         if (balances[target] <= MinimumPoStokens){
385             return 0;
386         }
387         int ONE_SECOND = 0x10000000000000000;
388         int PORTION_SCALED = (int(now - timer[target]) * ONE_SECOND) / int(doubleUnit); 
389         uint256 exp = fixedExp(PORTION_SCALED);
390         
391         return ((balances[target].mul(exp)) / uint(one)).sub(balances[target]); 
392     }
393     
394     
395     
396     int256 constant ln2       = 0x0b17217f7d1cf79ac;
397     int256 constant ln2_64dot5= 0x2cb53f09f05cc627c8;
398     int256 constant one       = 0x10000000000000000;
399 	int256 constant c2 =  0x02aaaaaaaaa015db0;
400 	int256 constant c4 = -0x000b60b60808399d1;
401 	int256 constant c6 =  0x0000455956bccdd06;
402 	int256 constant c8 = -0x000001b893ad04b3a;
403 	function fixedExp(int256 a) public pure returns (uint256 exp) {
404 		int256 scale = (a + (ln2_64dot5)) / ln2 - 64;
405 		a -= scale*ln2;
406 		// The polynomial R = 2 + c2*x^2 + c4*x^4 + ...
407 		// approximates the function x*(exp(x)+1)/(exp(x)-1)
408 		// Hence exp(x) = (R(x)+x)/(R(x)-x)
409 		int256 z = (a*a) / one;
410 		int256 R = ((int256)(2) * one) +
411 			(z*(c2 + (z*(c4 + (z*(c6 + (z*c8/one))/one))/one))/one);
412 		exp = (uint256) (((R + a) * one) / (R - a));
413 		if (scale >= 0)
414 			exp <<= scale;
415 		else
416 			exp >>= -scale;
417 		return exp;
418 	}
419 
420 }