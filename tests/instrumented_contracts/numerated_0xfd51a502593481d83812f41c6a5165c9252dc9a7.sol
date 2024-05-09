1 pragma solidity ^0.5.7;
2 
3 /*
4 ................&..,&&&&&&.......%&&&%..........&....................
5 ................#&&&&&...&&&&&&&&&&&&&&&&&&&&&.......................
6 ..............&&&&&..&&&&&&&&&&&&&&&&&&&&&&&&&&&&&...................
7 ..........%.&&&&&.&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&................
8 ..........&&&&&.&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&..............
9 .........&&&&.&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&............
10 ........&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&..........
11 .......&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&.........
12 ......&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&........
13 .....&&&&&&&&&&&&&&&&&&&&(&&&&&&&&&&&&&&&&&/&&&&&&&&&&&&&&&&&&.......
14 ....#&&&&&&&&&&&&&&,&&&&&&&.&&&&&&&&&&&&&.&&&&&&&(.&&&&&&&&&&&&......
15 ....&&&&&&&&&&&&&&&&&.&&&&&&&..&&&&&&&..&&&&&&&*...&&&&&&&&&&&&&.....
16 ....&&&&&&&&&&&&&&&&&&&/#&&&&&&&..&..&&&&&&&&......&&&&&&&&&&&&&.....
17 ....&&&&&&&&&&&&&&.&&&&&&&.&&&&&&&.&&&&&&&%.......&&&&&&&&&&&&&&&....
18 ...*&&&&&&&&&&&&&&&&.%&&&&&&.(&&&&&&&&&&........&&&&&&&&&&&&&&&&&....
19 ....&&&&&&&&&&&&&&&&&&.*&&&&&&&.&&&&&%.......,&&&&&&&&&&&&&&&&&&&....
20 ....&&&&&&&&&&&&&&&&&&&&..&&&&&&&.(........#&&&&&&&&&&&&&&&&&&&&&....
21 ....&&&&&&&&&&&&&&&&&&&&&&../&&&&&/......&&&&&&&&&&&&&&&&&&&&&&&&....
22 ....&&&&&&&&&&&&&&&&&&&&&&&&(.,&&&/....&&&&&&&&&&&&&&&&&&&&&&&&&&....
23 .....&&&&&&&&&&&&&&&&&&&&&&&&,,&&&/....&&&&&&&&&&&&&&&&&&&&&&&&&%....
24 ......&&&&&&&&&&&&&&&&&&&&&&&*,&&&/....&&&&&&&&&&&&&&&&&&&&&&&&&.....
25 .......&&&&&&&&&&&&&&&&&&&&&&%,&&&*....&&&&&&&&&&&&&&&&&&&&&&&&*.....
26 ....,...&&&&&&&&&&&&&&&&&&&&&&,&&&*....&&&&&&&&&&&&&&&&&&&&&&&&......
27 .........&&&&&&&&&&&&&&&&&&&&&,&&&*...,&&&&&&&&&&&&&&&&&&&&&&&.......
28 ..........&&&&&&&&&&&&&&&&&&&&,&&&*.../&&&&&&&&&&&&&&&&&,&&&&........
29 ............&&&&&&&&&&&&&&&&&&,&&&*...&&&&&&&&&&&&&&&&(&&&&%.........
30 ..............&&&&&&&&&&&&&&&&&&&&*...&&&&&&&&&&&&&&(&&&&&...........
31 ...........&....&&&&&&&&&&&&&&&&&&*...&&&&&&&&&&&&.&&&&&.............
32 ...................%&&&&&&&&&&&&&&*..%&&&&&&&&&..&&&&&...............
33 ................&(......&&&&&&&&&&/&&&&&&&(...&&&&.................
34 */
35 
36 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
37 
38 contract Cyle {
39 
40     string name;
41     string symbol;
42     uint8 decimals = 18;
43     uint256 totalSupply;
44 
45     uint256 cyleGenesisBlock;
46     uint256 lastBlock;
47 
48     uint256 miningReward;
49     uint256 publicMineSupply;
50     uint256 masternodeSupply;
51     uint256 smallReward = 0;
52     uint256 bigReward = 0;
53     uint256 masternodeRateNumerator;
54     uint256 masternodeRateDenominator;
55 
56     uint256 staticFinney = 1 finney;
57     uint256 requiredAmountForMasternode = 100* 10 ** uint256(decimals);
58     uint256 public maxAmountForMasternode = 10000* 10 ** uint256(decimals);
59 
60     uint256 blocksBetweenReward;
61 
62     address owner;
63 
64     address cyle = 0x0bAFb154b0E48BC9C483B92A0Cf00Cfb3d132EC7;
65 
66     uint256 blacklistedAmountOfBlocks = 5760;
67     
68     mapping (address => uint256) public balanceOf;
69     mapping (address => mapping (address => uint256)) public allowance;
70     mapping (uint256 => bool) public blockHasBeenMined;
71 
72     mapping (address => bool) public masternodeCheck;
73 
74     mapping (address => uint256) public registeredAtBlock;
75     mapping (address => uint256) public lastTimeRewarded;
76 
77     mapping (address => bool) public addressHasParkedToken;
78     mapping (address => uint256) public lockedAmount;
79 
80     mapping (address => uint256) public blacklistedTillBlock;
81 
82     event Transfer(address indexed from, address indexed to, uint256 value);
83     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
84     event Burn(address indexed from, uint256 value);
85     event ValueCheck(uint256 value);
86 
87     modifier onlyOwner {
88         require(msg.sender == owner);
89         _;
90     }
91 
92     modifier onlyMasterNode {
93         require(masternodeCheck[msg.sender]);
94         _;
95     }
96 
97     modifier remainingNodeSupplyChecky{
98         require(masternodeSupply > 0);
99         _;
100     }
101 
102     modifier remainingMineSupplyCheck{
103         require(publicMineSupply > miningReward);
104         _;
105     }
106 
107     modifier nodePotentialCheck{
108         require(!masternodeCheck[msg.sender]);
109         require(balanceOf[msg.sender] > requiredAmountForMasternode);
110         _;
111     }
112 
113     modifier checkForMiningBlacklisting{
114         require(getCurrentCyleBlock() > blacklistedTillBlock[msg.sender]);
115         _;
116     }
117 
118     constructor() public {
119         totalSupply = 450000000 * 10 ** uint256(decimals);  
120         balanceOf[address(this)] = totalSupply;             
121         name = "Cyle";                                   
122         symbol = "CYLE";                               
123         cyleGenesisBlock = block.number;
124         lastBlock = block.number;
125         publicMineSupply = SafeMath.div(totalSupply,2);
126         masternodeSupply = SafeMath.sub(totalSupply, publicMineSupply);
127         owner = msg.sender;
128         masternodeRateNumerator = 6081;
129         masternodeRateDenominator = 500000;
130         miningReward = 50 * 10 ** uint256(decimals);
131         blocksBetweenReward = 40320;
132     }
133 
134     function getStaticFinney() public view returns (uint){
135         return staticFinney;
136     }
137 
138     function calcSmallReward(uint256 _miningReward) private pure returns(uint256 _reward){
139         _reward=SafeMath.div(SafeMath.mul(_miningReward, 20),100);
140         return _reward;
141     }
142 
143      function calcBigReward(uint256 _miningReward) private pure returns(uint256 _reward){
144         _reward=SafeMath.div(SafeMath.mul(_miningReward, 80),100);
145         return _reward;
146     }
147 
148     function publicMine() public payable remainingMineSupplyCheck checkForMiningBlacklisting{
149         require(!blockHasBeenMined[getCurrentCyleBlock()]);
150         miningReward = getCurrentMiningReward();
151         smallReward = calcSmallReward(miningReward);
152         bigReward = calcBigReward(miningReward);
153         this.transfer(msg.sender, bigReward);
154         this.transfer(cyle, smallReward);
155         publicMineSupply = SafeMath.sub(publicMineSupply,miningReward);
156         blockHasBeenMined[getCurrentCyleBlock()] = true;
157         blacklistedTillBlock[msg.sender] = SafeMath.add(getCurrentCyleBlock(), blacklistedAmountOfBlocks);
158     }
159     
160     function getRemainingPublicMineSupply() public view returns (uint256 _amount){
161         return publicMineSupply;
162     }
163 
164     function getRemainingMasternodeSupply() public view returns (uint256 _amount){
165         return masternodeSupply;
166     }
167 
168     function getBlacklistblockForUser() public view returns(uint256){
169         return blacklistedTillBlock[msg.sender];
170     }
171 
172     function registerMasternode() public nodePotentialCheck{
173         require(!masternodeCheck[msg.sender]);
174         uint256 currentCyleBlock = getCurrentCyleBlock();
175         masternodeCheck[msg.sender] = true;
176         registeredAtBlock[msg.sender] = currentCyleBlock;
177         lastTimeRewarded[msg.sender] = currentCyleBlock;
178     }
179 
180     function lockAmountForMasternode(uint256 _amount) public onlyMasterNode{
181 
182         require(SafeMath.sub(balanceOf[msg.sender], lockedAmount[msg.sender]) >= _amount);
183         require(_amount <= maxAmountForMasternode && SafeMath.add(lockedAmount[msg.sender],_amount)<= maxAmountForMasternode);
184         addressHasParkedToken[msg.sender] = true;
185         if(lockedAmount[msg.sender] == 0){
186             lastTimeRewarded[msg.sender] = getCurrentCyleBlock();
187         }
188         lockedAmount[msg.sender] = SafeMath.add(lockedAmount[msg.sender],_amount);
189 
190     }
191 
192     function unlockAmountFromMasterNode() public onlyMasterNode returns(bool){
193 
194         addressHasParkedToken[msg.sender] = false;
195         lockedAmount[msg.sender] = 0;
196         return true;
197 
198     }
199 
200     function claimMasternodeReward() public onlyMasterNode remainingNodeSupplyChecky{
201 
202         require(addressHasParkedToken[msg.sender]);
203         uint256 interest = interestToClaim(msg.sender);
204         this.transfer(msg.sender, calcBigReward(interest));
205         this.transfer(cyle, calcSmallReward(interest));
206         lastTimeRewarded[msg.sender] = getCurrentCyleBlock();
207         masternodeSupply = SafeMath.sub(masternodeSupply, interest);
208 
209     }
210 
211     function interestToClaim(address _owner) public view returns(uint256 _amountToClaim){
212 
213         uint256 blockstopay = SafeMath.div(SafeMath.sub(getCurrentCyleBlock(),lastTimeRewarded[_owner]), blocksBetweenReward);
214         _amountToClaim = SafeMath.mul((SafeMath.div(SafeMath.mul(getCurrentMasternodeNumerator(), lockedAmount[_owner]), getCurrentMasternodeDenominator())), blockstopay);
215         return _amountToClaim;
216     }
217 
218     function getCurrentPossibleAmountOfAddress(address _owner) public view returns(uint256 _amount){
219 
220          if(!addressHasParkedToken[_owner]){
221             _amount = 0;
222         } else {
223            _amount = SafeMath.add(lockedAmount[_owner], interestToClaim(_owner));
224            return _amount;
225         }
226     }
227 
228     function getLastTimeRewarded(address _owner) public view returns (uint256 _block){
229         return lastTimeRewarded[_owner];
230 
231     }
232 
233     function checkForMasterNode(address _owner) public view returns (bool _state){
234        _state = masternodeCheck[_owner];
235        return _state;
236     }
237 
238     function adjustBlocksBetweenReward(uint256 _newBlocksBetweenReward) public onlyOwner {
239         blocksBetweenReward = _newBlocksBetweenReward;
240     }
241 
242     function _transfer(address _from, address _to, uint _value) internal {
243         require(_to != address(0x0));
244         require(balanceOf[_from] >= _value);
245         require(balanceOf[_to] + _value >= balanceOf[_to]);
246         uint previousBalances = balanceOf[_from] + balanceOf[_to];
247         balanceOf[_from] -= _value;
248         balanceOf[_to] += _value;
249         emit Transfer(_from, _to, _value);
250         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
251     }
252 
253     function transfer(address _to, uint256 _value) public returns (bool success) {
254         _transfer(msg.sender, _to, _value);
255         return true;
256     }
257 
258     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
259         require(_value <= allowance[_from][msg.sender]);     // Check allowance
260         allowance[_from][msg.sender] -= _value;
261         _transfer(_from, _to, _value);
262         return true;
263     }
264 
265     function approve(address _spender, uint256 _value) public
266         returns (bool success) {
267         allowance[msg.sender][_spender] = _value;
268         emit Approval(msg.sender, _spender, _value);
269         return true;
270     }
271 
272     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
273         public
274         returns (bool success) {
275         tokenRecipient spender = tokenRecipient(_spender);
276         if (approve(_spender, _value)) {
277             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
278             return true;
279         }
280     }
281 
282     function burn(uint256 _value) public returns (bool success) {
283         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
284         balanceOf[msg.sender] -= _value;            // Subtract from the sender
285         totalSupply -= _value;                      // Updates totalSupply
286         emit Burn(msg.sender, _value);
287         return true;
288     }
289 
290     function burnFrom(address _from, uint256 _value) public returns (bool success) {
291         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
292         require(_value <= allowance[_from][msg.sender]);    // Check allowance
293         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
294         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
295         totalSupply -= _value;                              // Update totalSupply
296         emit Burn(_from, _value);
297         return true;
298 }
299 
300     function getCurrentEthBlock() private view returns (uint256 blockAmount){
301         return block.number;
302     }
303 
304     function getCurrentCyleBlock() public view returns (uint256){
305         uint256 eth = getCurrentEthBlock();
306         uint256 cyleBlock = SafeMath.sub(eth, cyleGenesisBlock);
307         return cyleBlock;
308     }
309 
310     function getCurrentMiningReward() public view returns(uint256 _miningReward){
311         return miningReward;
312     }
313 
314      function getCurrentMasterNodeReward() public view returns(uint256 _miningReward){
315         return SafeMath.mul(SafeMath.div(masternodeRateNumerator,masternodeRateDenominator),100);
316     }
317 
318     function getCurrentMasternodeNumerator() public view returns(uint256 _numerator){
319         return masternodeRateNumerator;    
320     }
321  
322     function getCurrentMasternodeDenominator() public view returns(uint256 _denominator){
323         return masternodeRateDenominator;    
324     }
325 
326     function getTotalSupply() public view returns (uint256 _totalSupply){
327         return totalSupply;
328     }
329 
330     function getCurrentLockedAmount() public view returns (uint256 _amount){
331         return lockedAmount[msg.sender];
332     }
333 
334     function getCurrentUnlockedAmount() public view returns (uint256 _unlockedAmount){
335         return SafeMath.sub(balanceOf[msg.sender], lockedAmount[msg.sender]);
336     }
337 
338     function getMasternodeRequiredAmount() public view returns(uint256 _reqAmount){
339         return requiredAmountForMasternode;
340     }
341 
342     function adjustMiningRewards() public{
343 
344         uint256 _remainingMiningSupply = getRemainingPublicMineSupply();
345 
346         if(_remainingMiningSupply < 175000000000000000000000000 && _remainingMiningSupply > 131250000000000000000000000){
347             miningReward = 25000000000000000000;
348         }
349 
350         if(_remainingMiningSupply < 131250000000000000000000000 && _remainingMiningSupply > 93750000000000000000000000){
351             miningReward = 12500000000000000000;
352         }
353 
354         if(_remainingMiningSupply < 93750000000000000000000000 && _remainingMiningSupply > 62500000000000000000000000){
355             miningReward = 6250000000000000000;
356         }
357 
358         if(_remainingMiningSupply < 62500000000000000000000000 && _remainingMiningSupply > 37500000000000000000000000){
359             miningReward = 3125000000000000000;
360         }
361 
362         if(_remainingMiningSupply < 37500000000000000000000000 && _remainingMiningSupply > 18750000000000000000000000){
363             miningReward = 1562500000000000000;
364         }
365 
366         if(_remainingMiningSupply < 18750000000000000000000000 && _remainingMiningSupply > 12500000000000000000000000){
367             miningReward = 800000000000000000;
368         }
369 
370         if(_remainingMiningSupply < 12500000000000000000000000 && _remainingMiningSupply > 6250000000000000000000000){
371             miningReward = 400000000000000000;
372         }
373 
374         if(_remainingMiningSupply < 6250000000000000000000000){
375             miningReward = 200000000000000000;
376         }
377 
378     }
379 
380     function adjustMasternodeRewards() public{
381 
382         uint256 _remainingStakeSupply = getRemainingMasternodeSupply();
383 
384         if(_remainingStakeSupply < 218750000000000000000000000 && _remainingStakeSupply > 206250000000000000000000000){
385            masternodeRateNumerator=5410;
386            masternodeRateDenominator=500000;
387         }
388 
389         if(_remainingStakeSupply < 206250000000000000000000000 && _remainingStakeSupply > 187500000000000000000000000){
390            masternodeRateNumerator=469;
391            masternodeRateDenominator=50000;
392         }
393 
394         if(_remainingStakeSupply < 187500000000000000000000000 && _remainingStakeSupply > 162500000000000000000000000){
395            masternodeRateNumerator=783;
396            masternodeRateDenominator=100000;
397         }
398 
399         if(_remainingStakeSupply < 162500000000000000000000000 && _remainingStakeSupply > 131250000000000000000000000){
400            masternodeRateNumerator=307;
401            masternodeRateDenominator=50000;
402         }
403 
404         if(_remainingStakeSupply < 131250000000000000000000000 && _remainingStakeSupply > 93750000000000000000000000){
405            masternodeRateNumerator=43;
406            masternodeRateDenominator=10000;
407         }
408 
409         if(_remainingStakeSupply < 93750000000000000000000000 && _remainingStakeSupply > 50000000000000000000000000){
410            masternodeRateNumerator=269;
411            masternodeRateDenominator=100000;
412         }
413 
414         if(_remainingStakeSupply < 50000000000000000000000000){
415            masternodeRateNumerator=183;
416            masternodeRateDenominator=100000;
417         }
418     }
419     
420 }
421 
422 library SafeMath {
423 
424   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
425     if (a == 0) {
426       return 0;
427     }
428     uint256 c = a * b;
429     assert(c / a == b);
430     return c;
431   }
432 
433   function div(uint256 a, uint256 b) internal pure returns (uint256) {
434     uint256 c = a / b;
435     return c;
436   }
437 
438   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
439     assert(b <= a);
440     return a - b;
441   }
442 
443   function add(uint256 a, uint256 b) internal pure returns (uint256) {
444     uint256 c = a + b;
445     assert(c >= a);
446     return c;
447   }
448 }