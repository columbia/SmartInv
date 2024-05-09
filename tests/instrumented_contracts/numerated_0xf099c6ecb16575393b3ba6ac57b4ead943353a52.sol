1 pragma solidity ^0.4.22;
2 
3 contract BuddhaTower {
4     event onBuy
5     (
6         address indexed buyerAddress,
7         uint256 amount,
8         uint256 currentHeight
9     );
10 
11     event onSplit(
12     	uint round,
13     	uint luckyNumber,
14     	address luckyPlayer
15     );
16 
17     event onTimeup(
18     	uint round,
19     	address lastBuyer
20     );
21 
22     event onQualifySuccess(
23     	address applier
24     );
25 
26 
27 //==============================================================================
28 //   __|_ _    __|_ _  .
29 //  _\ | | |_|(_ | _\  .
30 //==============================================================================
31 
32 	struct RoundData {
33         uint256 maxHeight;
34         uint256 lotteryPool;
35         uint256 peakPool;
36         uint256 tokenPot;
37         uint[][] buyinfo;
38     	address[] buyAddress;
39     	uint256 startTime;
40     	uint256 endTime;
41     	address[] lotteryWinners;
42     	address finalWinner;
43     }
44 
45 	mapping (address => uint256) public balanceOf;
46 	address[] public holders;
47     uint256 public totalToken = 0;
48     // bool public active = false;
49     address private owner;
50     mapping (address => uint256) public ethOf;
51     mapping (address => address) public inviterOf;
52     mapping (address => bool) public qualified;
53     uint public price;
54     bool public emergencySwitch = false;
55     uint public height;
56     uint256 public lotteryPool;
57     uint256 public peakPool;
58     uint[7] public inviteCut = [10,8,6,2,2,1,1];
59     mapping(uint256 => RoundData) public roundData_;
60     mapping(address => uint256) public inviteIncome;
61     mapping(address => uint256) public lotteryIncome;
62     mapping(address => uint256) public finalIncome;
63     mapping(address => uint256) public tokenIncome;
64     uint256 public step = 100000000000;
65     
66     uint public _rId;
67     address private lastBuyer;
68     mapping (address => bool) public banAddress;
69     mapping (address => uint[4]) public leefs;
70     uint public devCut = 0;
71     address public addr1 = 0x0b8E19f4A333f58f824e59eBeD301190939c63B5;//3.5%
72     address public addr2 = 0x289809c3Aa4D52e2cb424719F82014a1Ff7F2266;//2%
73     address public addr3 = 0xf3140b8c2e3dac1253f2041e4f4549ddb1aebd35;//2%
74     address public addr4 = 0x245aDe5562bdA54AE913FF1f74b8329Ab011D7e0;//dev cut
75 
76     // uint public rand = 0;
77 //==============================================================================
78 //     _ _  _  _|. |`. _  _ _  .
79 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
80 //==============================================================================
81     modifier isHuman() {
82         address _addr = msg.sender;
83         uint256 _codeLength;
84         
85         assembly {_codeLength := extcodesize(_addr)}
86         require(_codeLength == 0, "sorry humans only");
87         _;
88     }
89 
90     modifier isEmergency() {
91         require(emergencySwitch);
92         _;
93     }
94 
95     modifier isBaned(address addr) {
96         require(!banAddress[addr]);
97         _;
98     }
99 
100     modifier isActive(){
101     	require(
102             roundData_[_rId].startTime != 0,
103             "not Started"
104         );
105         _;
106     }
107 
108     modifier onlyOwner(){
109     	require(
110             msg.sender == owner,
111             "only owner can do this"
112         );
113         _;
114     }
115 
116     modifier isWithinLimits(uint256 _eth) {
117         require(_eth >= 1000000000, "too low");
118         require(_eth <= 100000000000000000000000, "too much");
119         _;    
120     }    
121 //==============================================================================
122 //     _ _  _  __|_ _    __|_ _  _  .
123 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
124 //==============================================================================
125     constructor () public{
126     	owner = msg.sender;
127     	balanceOf[owner] = 1000000000000000000;//decimal 18
128     	totalToken = 1000000000000000000;
129     	leefs[owner] = [9,9,9,9];
130     	holders.push(owner);
131     	qualified[owner] = true;
132     	_rId = 0;
133     	price = 100000000000000000;
134     	activate();
135     }
136 
137 //==============================================================================
138 //     _    |_ |. _   |`    _  __|_. _  _  _  .
139 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
140 //====|=========================================================================
141     function deposit(address _inviter, uint256 _amount)
142         isActive()
143         isHuman()
144         isWithinLimits(msg.value)
145         isBaned(msg.sender)
146         public
147         payable
148     {
149     	require(_amount > 0 && _amount <= 1000);
150     	require (msg.value >= (height * step + price + (height + _amount-1)*step + price)*_amount/2,"value not enough");
151     	if(inviterOf[msg.sender]==0x0 && qualified[_inviter] && _inviter != msg.sender)
152     	{
153     		inviterOf[msg.sender] = _inviter;
154     	}
155         buy(_amount);
156     }
157 
158 	function withdrawEth(uint _amount) 
159 	isBaned(msg.sender)
160 	isHuman()
161 	public
162     {
163         require(ethOf[msg.sender] >= _amount);
164         msg.sender.transfer(_amount);
165         ethOf[msg.sender] -= _amount;
166     }    
167 
168     function getLotteryWinner(uint _round, uint index) public
169     returns (address)
170     {
171     	require(_round>=0 && index >= 0);
172     	return roundData_[_round].lotteryWinners[index];
173     }
174 
175     function getLotteryWinnerLength(uint _round) public
176     returns (uint)
177     {
178     	return roundData_[_round].lotteryWinners.length;
179     }
180 
181     function getQualified() public{
182     	require(balanceOf[msg.sender] >= 1000000000000000000);
183     	qualified[msg.sender] = true;
184     	emit onQualifySuccess(msg.sender);
185     }
186 
187     function getBuyInfoLength(uint256 rId) public 
188     returns(uint)
189     {
190     	return roundData_[rId].buyinfo.length;
191     }
192 
193     function getBuyInfo(uint256 rId,uint256 index) public 
194     returns(uint, uint)
195     {
196     	require(index >= 0 && index < roundData_[rId].buyinfo.length);
197     	return (roundData_[rId].buyinfo[index][0],roundData_[rId].buyinfo[index][1]);
198     }
199 
200     function getBuyAddress(uint256 rId,uint256 index) public 
201     returns (address)
202     {
203     	require(index >= 0 && index < roundData_[rId].buyAddress.length);
204     	return roundData_[rId].buyAddress[index];
205     }
206 //==============================================================================
207 //     _ _  _ _   | _  _ . _  .
208 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
209 //=====================_|=======================================================
210 	function buy(uint256 amount) private{
211 		if(now >= roundData_[_rId].endTime)
212 		{
213 			endTime();
214 		}
215 		require(amount > 0);
216 		uint256 cost = (price + height*step + price + (height+amount-1)*step)*amount/2;
217 		ethOf[msg.sender] += msg.value - cost;
218 		
219 		roundData_[_rId].peakPool += cost*3/10;
220 		roundData_[_rId].lotteryPool += cost/10;
221 		roundData_[_rId].tokenPot += cost*17/100;
222 		devCut += cost*55/1000;
223 
224         ethOf[addr1] += cost*35/1000;
225         ethOf[addr2] += cost*20/1000;
226         ethOf[addr3] += cost*20/1000;
227 
228 
229 		roundData_[_rId].buyinfo.push([height+1,height+amount]);
230 		roundData_[_rId].buyAddress.push(msg.sender);
231 
232 		roundData_[_rId].endTime += amount * 60;//*60;
233 
234         if (amount >= 10 && balanceOf[msg.sender] == 0)
235         	holders.push(msg.sender);
236         uint256 tokenGet = amount/1000 * 11000000000000000000 + amount / 100 * 1000000000000000000 + amount/10*1000000000000000000;
237         address affect = 0x0;
238         if (balanceOf[msg.sender] < 1000000000000000000 && tokenGet > 1000000000000000000)
239         {
240         	leefs[inviterOf[msg.sender]][0]+=1;
241         	if(leefs[inviterOf[msg.sender]][0] == 3 && balanceOf[inviterOf[msg.sender]] >= 7000000000000000000 )
242         	{
243         		affect = inviterOf[inviterOf[msg.sender]];
244         		leefs[affect][1]+=1;
245         		if(leefs[affect][1] == 3 && balanceOf[affect] >= 20000000000000000000)
246         		{
247         			affect = inviterOf[affect];
248         			leefs[affect][2]+=1;
249         		}
250         	}
251         }
252         if ((balanceOf[msg.sender] < 7000000000000000000 || leefs[msg.sender][0] < 3) && balanceOf[msg.sender] + tokenGet >= 7000000000000000000 && leefs[msg.sender][0] >= 3)
253         {
254         	leefs[inviterOf[msg.sender]][1]+=1;
255         	if(leefs[inviterOf[msg.sender]][1] == 3 && balanceOf[inviterOf[msg.sender]] >= 20000000000000000000 )
256         	{
257         		affect = inviterOf[inviterOf[msg.sender]];
258         		leefs[affect][2]+=1;
259         	}
260         }
261         		
262         if ((balanceOf[msg.sender] < 20000000000000000000 || leefs[msg.sender][1] < 3)&& balanceOf[msg.sender] + tokenGet >= 20000000000000000000 && leefs[msg.sender][1] >= 3)
263         	leefs[inviterOf[msg.sender]][2]+=1;
264         balanceOf[msg.sender] += tokenGet;
265         totalToken+=tokenGet;
266         address inviter = inviterOf[msg.sender];
267         address inviter2 = inviterOf[inviter];
268         address inviter3 = inviterOf[inviter2];
269         address inviter4 = inviterOf[inviter3];
270         address inviter5 = inviterOf[inviter4];
271         address inviter6 = inviterOf[inviter5];
272         address inviter7 = inviterOf[inviter6];
273 
274         if(inviter != 0x0){
275             ethOf[inviter] += cost * inviteCut[0]/100;
276             inviteIncome[inviter] += cost * inviteCut[0]/100;
277         }
278 
279         if(inviter2 != 0x0 && balanceOf[inviter2] >= 7000000000000000000 && leefs[inviter2][0] >= 3){
280             ethOf[inviter2] += cost * inviteCut[1]/100;
281             inviteIncome[inviter2] += cost * inviteCut[1]/100;
282         }else{
283             roundData_[_rId].lotteryPool += cost * inviteCut[1]/100;
284         }
285 
286         if(inviter3 != 0x0 && balanceOf[inviter3] >= 7000000000000000000 && leefs[inviter3][0] >= 3){
287             ethOf[inviter3] += cost * inviteCut[2]/100;
288             inviteIncome[inviter3] += cost * inviteCut[2]/100;
289         }else{
290             roundData_[_rId].lotteryPool += cost * inviteCut[2]/100;
291         }
292 
293         if(inviter4 != 0x0 && balanceOf[inviter4] >= 20000000000000000000 && leefs[inviter4][1] >= 3){
294             ethOf[inviter4] += cost * inviteCut[3]/100;
295             inviteIncome[inviter4] += cost * inviteCut[3]/100;
296         }else{
297             roundData_[_rId].lotteryPool += cost * inviteCut[3]/100;
298         }
299 
300         if(inviter5 != 0x0 && balanceOf[inviter5] >= 20000000000000000000 && leefs[inviter5][1] >= 3){
301             ethOf[inviter5] += cost * inviteCut[4]/100;
302             inviteIncome[inviter5] += cost * inviteCut[4]/100;
303         }else{
304             roundData_[_rId].lotteryPool += cost * inviteCut[4]/100;
305         }
306 
307         if(inviter6 != 0x0 && balanceOf[inviter6] >= 100000000000000000000 && leefs[inviter6][2] >= 3){
308             ethOf[inviter6] += cost * inviteCut[5]/100;
309             inviteIncome[inviter6] += cost * inviteCut[5]/100;
310         }else{
311             roundData_[_rId].lotteryPool += cost * inviteCut[5]/100;
312         }
313 
314         if(inviter7 != 0x0 && balanceOf[inviter7] >= 100000000000000000000 && leefs[inviter7][2] >= 3){
315             ethOf[inviter7] += cost * inviteCut[6]/100;
316             inviteIncome[inviter7] += cost * inviteCut[6]/100;
317         }else{
318             roundData_[_rId].lotteryPool += cost * inviteCut[6]/100;
319         }
320 
321 
322         if(roundData_[_rId].endTime - now > 86400)
323         {
324             roundData_[_rId].endTime = now + 86400;
325         }
326 
327 		if(height+amount >= (height/1000+1)*1000 )
328 		{
329 			lastBuyer = msg.sender;
330 			splitLottery();
331 		}
332 
333 		height += amount;
334 		emit onBuy(msg.sender, amount, height);
335 	}
336 
337 	// function getRand() public{
338 	// 	rand = uint(keccak256(now, msg.sender)) % 1000 + 1 + _rId*1000;
339 	// }
340 
341 	function splitLottery() private{
342         //随机一个赢家
343         uint random = uint(keccak256(now, msg.sender)) % 1000 + 1 + roundData_[_rId].lotteryWinners.length*1000;//瞎比写的
344         // rand = random;
345         //随机完毕
346         // uint startHeight = ((height/1000)-1)*1000;
347         uint i = 0;
348         uint start = 0;
349         uint end = roundData_[_rId].buyinfo.length-1;
350         uint mid = (start+end)/2;
351         while(end >= start)
352         {
353         	if(roundData_[_rId].buyinfo[mid][0] > random)
354         	{
355         		end = mid-1;
356         		mid = start+(end-start)/2;
357         		continue;
358         	}
359         	if(roundData_[_rId].buyinfo[mid][1] < random)
360         	{
361         		start = mid+1;
362         		mid = start+(end-start)/2;
363         		continue;
364         	}
365         	break;
366         }
367         address lotteryWinner = roundData_[_rId].buyAddress[mid];
368         ethOf[lotteryWinner] += roundData_[_rId].lotteryPool*80/100;
369         lotteryIncome[lotteryWinner] += roundData_[_rId].lotteryPool*80/100;
370         roundData_[_rId].lotteryWinners.push(lotteryWinner);
371 
372         for (i = 0; i < holders.length; i++)
373         {
374         	ethOf[holders[i]] += roundData_[_rId].tokenPot* balanceOf[holders[i]]/totalToken;
375         	tokenIncome[holders[i]] += roundData_[_rId].tokenPot* balanceOf[holders[i]]/totalToken;
376         }
377         step += 100000000000;
378         roundData_[_rId].lotteryPool = roundData_[_rId].lotteryPool*2/10;
379         emit onSplit(height/1000+1,random, lotteryWinner);
380 	}
381 
382 	function endTime() private{
383 		address finalWinner = owner;
384 		if(roundData_[_rId].buyAddress.length > 0)
385 			finalWinner = roundData_[_rId].buyAddress[roundData_[_rId].buyAddress.length-1];
386         //防止溢出
387         require(ethOf[finalWinner]+roundData_[_rId].peakPool*8/10 >= ethOf[finalWinner]);
388         ethOf[finalWinner] += roundData_[_rId].peakPool*8/10;
389         finalIncome[finalWinner] += roundData_[_rId].peakPool*8/10;
390         roundData_[_rId].finalWinner = finalWinner;
391         roundData_[_rId].maxHeight = height;
392         height = 0;
393         step = 100000000000;
394         _rId++;
395         roundData_[_rId].peakPool = roundData_[_rId-1].peakPool*2/10;
396         ethOf[owner] += roundData_[_rId-1].lotteryPool;
397         roundData_[_rId].lotteryPool = 0; 
398 
399         roundData_[_rId].startTime = now;
400         roundData_[_rId].endTime = now+86400;
401         emit onTimeup(_rId-1,finalWinner);
402 	}
403 
404 
405 //==============================================================================
406 //    (~ _  _    _._|_    .
407 //    _)(/_(_|_|| | | \/  .
408 //====================/=========================================================
409     function activate() public onlyOwner(){
410     	height = 0;
411     	_rId = 0;
412     	roundData_[_rId].startTime = now;
413     	roundData_[_rId].endTime = now + 86400;
414     }
415 
416     function takeDevCut() public onlyOwner() {
417         addr4.transfer(devCut);
418         devCut = 0;
419     }    
420 
421     function wipeAll() public onlyOwner() {
422         selfdestruct(owner);
423     }
424 
425     function emergencyStart() public onlyOwner() {
426         emergencySwitch = true;
427     }
428 
429     function emergencyClose() public onlyOwner() {
430         emergencySwitch = false;
431     }
432 
433     function addToBanlist(address addr) public onlyOwner() {
434     	banAddress[addr] = true;
435     }
436 
437     function moveFromBanlist(address addr) public onlyOwner() {
438     	banAddress[addr] = false;
439     }
440 
441 //==============================================================================
442 //    _|_ _  _ | _  .
443 //     | (_)(_)|_\  .
444 //==============================================================================
445 
446 }