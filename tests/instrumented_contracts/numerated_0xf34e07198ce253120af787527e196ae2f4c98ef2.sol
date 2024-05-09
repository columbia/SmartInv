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
135         test();
136     }
137 
138 //==============================================================================
139 //     _    |_ |. _   |`    _  __|_. _  _  _  .
140 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
141 //====|=========================================================================
142     function deposit(address _inviter, uint256 _amount)
143         isActive()
144         isHuman()
145         isWithinLimits(msg.value)
146         isBaned(msg.sender)
147         public
148         payable
149     {
150     	require(_amount > 0 && _amount <= 1000);
151     	require (msg.value >= (height * step + price + (height + _amount-1)*step + price)*_amount/2,"value not enough");
152     	if(inviterOf[msg.sender]==0x0 && qualified[_inviter] && _inviter != msg.sender)
153     	{
154     		inviterOf[msg.sender] = _inviter;
155     	}
156         buy(_amount);
157     }
158 
159 	function withdrawEth(uint _amount) 
160 	isBaned(msg.sender)
161 	isHuman()
162 	public
163     {
164         require(ethOf[msg.sender] >= _amount);
165         msg.sender.transfer(_amount);
166         ethOf[msg.sender] -= _amount;
167     }    
168 
169     function getLotteryWinner(uint _round, uint index) public
170     returns (address)
171     {
172     	require(_round>=0 && index >= 0);
173     	return roundData_[_round].lotteryWinners[index];
174     }
175 
176     function getLotteryWinnerLength(uint _round) public
177     returns (uint)
178     {
179     	return roundData_[_round].lotteryWinners.length;
180     }
181 
182     function getQualified() public{
183     	require(balanceOf[msg.sender] >= 1000000000000000000);
184     	qualified[msg.sender] = true;
185     	emit onQualifySuccess(msg.sender);
186     }
187 
188     function getBuyInfoLength(uint256 rId) public 
189     returns(uint)
190     {
191     	return roundData_[rId].buyinfo.length;
192     }
193 
194     function getBuyInfo(uint256 rId,uint256 index) public 
195     returns(uint, uint)
196     {
197     	require(index >= 0 && index < roundData_[rId].buyinfo.length);
198     	return (roundData_[rId].buyinfo[index][0],roundData_[rId].buyinfo[index][1]);
199     }
200 
201     function getBuyAddress(uint256 rId,uint256 index) public 
202     returns (address)
203     {
204     	require(index >= 0 && index < roundData_[rId].buyAddress.length);
205     	return roundData_[rId].buyAddress[index];
206     }
207 //==============================================================================
208 //     _ _  _ _   | _  _ . _  .
209 //    (_(_)| (/_  |(_)(_||(_  . (this + tools + calcs + modules = our softwares engine)
210 //=====================_|=======================================================
211 	function buy(uint256 amount) private{
212 		if(now >= roundData_[_rId].endTime)
213 		{
214 			endTime();
215 		}
216 		require(amount > 0);
217 		uint256 cost = (price + height*step + price + (height+amount-1)*step)*amount/2;
218 		ethOf[msg.sender] += msg.value - cost;
219 		
220 		roundData_[_rId].peakPool += cost*3/10;
221 		roundData_[_rId].lotteryPool += cost/10;
222 		roundData_[_rId].tokenPot += cost*17/100;
223 		devCut += cost*55/1000;
224 
225         ethOf[addr1] += cost*35/1000;
226         ethOf[addr2] += cost*20/1000;
227         ethOf[addr3] += cost*20/1000;
228 
229 
230 		roundData_[_rId].buyinfo.push([height+1,height+amount]);
231 		roundData_[_rId].buyAddress.push(msg.sender);
232 
233 		roundData_[_rId].endTime += amount * 60;//*60;
234 
235         if (amount >= 10 && balanceOf[msg.sender] == 0)
236         	holders.push(msg.sender);
237         uint256 tokenGet = amount/1000 * 11000000000000000000 + amount / 100 * 1000000000000000000 + amount/10*1000000000000000000;
238         address affect = 0x0;
239         if (balanceOf[msg.sender] < 1000000000000000000 && tokenGet > 1000000000000000000)
240         {
241         	leefs[inviterOf[msg.sender]][0]+=1;
242         	if(leefs[inviterOf[msg.sender]][0] == 3 && balanceOf[inviterOf[msg.sender]] >= 7000000000000000000 )
243         	{
244         		affect = inviterOf[inviterOf[msg.sender]];
245         		leefs[affect][1]+=1;
246         		if(leefs[affect][1] == 3 && balanceOf[affect] >= 20000000000000000000)
247         		{
248         			affect = inviterOf[affect];
249         			leefs[affect][2]+=1;
250         		}
251         	}
252         }
253         if ((balanceOf[msg.sender] < 7000000000000000000 || leefs[msg.sender][0] < 3) && balanceOf[msg.sender] + tokenGet >= 7000000000000000000 && leefs[msg.sender][0] >= 3)
254         {
255         	leefs[inviterOf[msg.sender]][1]+=1;
256         	if(leefs[inviterOf[msg.sender]][1] == 3 && balanceOf[inviterOf[msg.sender]] >= 20000000000000000000 )
257         	{
258         		affect = inviterOf[inviterOf[msg.sender]];
259         		leefs[affect][2]+=1;
260         	}
261         }
262         		
263         if ((balanceOf[msg.sender] < 20000000000000000000 || leefs[msg.sender][1] < 3)&& balanceOf[msg.sender] + tokenGet >= 20000000000000000000 && leefs[msg.sender][1] >= 3)
264         	leefs[inviterOf[msg.sender]][2]+=1;
265         balanceOf[msg.sender] += tokenGet;
266         totalToken+=tokenGet;
267         address inviter = inviterOf[msg.sender];
268         address inviter2 = inviterOf[inviter];
269         address inviter3 = inviterOf[inviter2];
270         address inviter4 = inviterOf[inviter3];
271         address inviter5 = inviterOf[inviter4];
272         address inviter6 = inviterOf[inviter5];
273         address inviter7 = inviterOf[inviter6];
274 
275         if(inviter != 0x0){
276             ethOf[inviter] += cost * inviteCut[0]/100;
277             inviteIncome[inviter] += cost * inviteCut[0]/100;
278         }
279 
280         if(inviter2 != 0x0 && balanceOf[inviter2] >= 7000000000000000000 && leefs[inviter2][0] >= 3){
281             ethOf[inviter2] += cost * inviteCut[1]/100;
282             inviteIncome[inviter2] += cost * inviteCut[1]/100;
283         }else{
284             roundData_[_rId].lotteryPool += cost * inviteCut[1]/100;
285         }
286 
287         if(inviter3 != 0x0 && balanceOf[inviter3] >= 7000000000000000000 && leefs[inviter3][0] >= 3){
288             ethOf[inviter3] += cost * inviteCut[2]/100;
289             inviteIncome[inviter3] += cost * inviteCut[2]/100;
290         }else{
291             roundData_[_rId].lotteryPool += cost * inviteCut[2]/100;
292         }
293 
294         if(inviter4 != 0x0 && balanceOf[inviter4] >= 20000000000000000000 && leefs[inviter4][1] >= 3){
295             ethOf[inviter4] += cost * inviteCut[3]/100;
296             inviteIncome[inviter4] += cost * inviteCut[3]/100;
297         }else{
298             roundData_[_rId].lotteryPool += cost * inviteCut[3]/100;
299         }
300 
301         if(inviter5 != 0x0 && balanceOf[inviter5] >= 20000000000000000000 && leefs[inviter5][1] >= 3){
302             ethOf[inviter5] += cost * inviteCut[4]/100;
303             inviteIncome[inviter5] += cost * inviteCut[4]/100;
304         }else{
305             roundData_[_rId].lotteryPool += cost * inviteCut[4]/100;
306         }
307 
308         if(inviter6 != 0x0 && balanceOf[inviter6] >= 100000000000000000000 && leefs[inviter6][2] >= 3){
309             ethOf[inviter6] += cost * inviteCut[5]/100;
310             inviteIncome[inviter6] += cost * inviteCut[5]/100;
311         }else{
312             roundData_[_rId].lotteryPool += cost * inviteCut[5]/100;
313         }
314 
315         if(inviter7 != 0x0 && balanceOf[inviter7] >= 100000000000000000000 && leefs[inviter7][2] >= 3){
316             ethOf[inviter7] += cost * inviteCut[6]/100;
317             inviteIncome[inviter7] += cost * inviteCut[6]/100;
318         }else{
319             roundData_[_rId].lotteryPool += cost * inviteCut[6]/100;
320         }
321 
322 
323         if(roundData_[_rId].endTime - now > 86400)
324         {
325             roundData_[_rId].endTime = now + 86400;
326         }
327 
328 		if(height+amount >= (height/1000+1)*1000 )
329 		{
330 			lastBuyer = msg.sender;
331 			splitLottery();
332 		}
333 
334 		height += amount;
335 		emit onBuy(msg.sender, amount, height);
336 	}
337 
338 	// function getRand() public{
339 	// 	rand = uint(keccak256(now, msg.sender)) % 1000 + 1 + _rId*1000;
340 	// }
341 
342 	function splitLottery() private{
343         //随机一个赢家
344         uint random = uint(keccak256(now, msg.sender)) % 1000 + 1 + roundData_[_rId].lotteryWinners.length*1000;//瞎比写的
345         // rand = random;
346         //随机完毕
347         // uint startHeight = ((height/1000)-1)*1000;
348         uint i = 0;
349         uint start = 0;
350         uint end = roundData_[_rId].buyinfo.length-1;
351         uint mid = (start+end)/2;
352         while(end >= start)
353         {
354         	if(roundData_[_rId].buyinfo[mid][0] > random)
355         	{
356         		end = mid-1;
357         		mid = start+(end-start)/2;
358         		continue;
359         	}
360         	if(roundData_[_rId].buyinfo[mid][1] < random)
361         	{
362         		start = mid+1;
363         		mid = start+(end-start)/2;
364         		continue;
365         	}
366         	break;
367         }
368         address lotteryWinner = roundData_[_rId].buyAddress[mid];
369         ethOf[lotteryWinner] += roundData_[_rId].lotteryPool*80/100;
370         lotteryIncome[lotteryWinner] += roundData_[_rId].lotteryPool*80/100;
371         roundData_[_rId].lotteryWinners.push(lotteryWinner);
372 
373         for (i = 0; i < holders.length; i++)
374         {
375         	ethOf[holders[i]] += roundData_[_rId].tokenPot* balanceOf[holders[i]]/totalToken;
376         	tokenIncome[holders[i]] += roundData_[_rId].tokenPot* balanceOf[holders[i]]/totalToken;
377         }
378         step += 100000000000;
379         roundData_[_rId].lotteryPool = roundData_[_rId].lotteryPool*2/10;
380         emit onSplit(height/1000+1,random, lotteryWinner);
381 	}
382 
383 	function endTime() private{
384 		address finalWinner = owner;
385 		if(roundData_[_rId].buyAddress.length > 0)
386 			finalWinner = roundData_[_rId].buyAddress[roundData_[_rId].buyAddress.length-1];
387         //防止溢出
388         require(ethOf[finalWinner]+roundData_[_rId].peakPool*8/10 >= ethOf[finalWinner]);
389         ethOf[finalWinner] += roundData_[_rId].peakPool*8/10;
390         finalIncome[finalWinner] += roundData_[_rId].peakPool*8/10;
391         roundData_[_rId].finalWinner = finalWinner;
392         roundData_[_rId].maxHeight = height;
393         height = 0;
394         step = 100000000000;
395         _rId++;
396         roundData_[_rId].peakPool = roundData_[_rId-1].peakPool*2/10;
397         ethOf[owner] += roundData_[_rId-1].lotteryPool;
398         roundData_[_rId].lotteryPool = 0; 
399 
400         roundData_[_rId].startTime = now;
401         roundData_[_rId].endTime = now+86400;
402         emit onTimeup(_rId-1,finalWinner);
403 	}
404 
405 
406 //==============================================================================
407 //    (~ _  _    _._|_    .
408 //    _)(/_(_|_|| | | \/  .
409 //====================/=========================================================
410     function activate() public onlyOwner(){
411     	height = 0;
412     	_rId = 0;
413     	roundData_[_rId].startTime = now;
414     	roundData_[_rId].endTime = now + 86400;
415     	// active = true;
416     }
417 
418     function takeDevCut() public onlyOwner() {
419         // msg.sender.transfer(devCut);
420         addr4.transfer(devCut);
421         devCut = 0;
422     }    
423 
424     function wipeAll() public onlyOwner() {
425         selfdestruct(owner);
426     }
427 
428     function emergencyStart() public onlyOwner() {
429         emergencySwitch = true;
430     }
431 
432     function emergencyClose() public onlyOwner() {
433         emergencySwitch = false;
434     }
435 
436     function addToBanlist(address addr) public onlyOwner() {
437     	banAddress[addr] = true;
438     }
439 
440     function moveFromBanlist(address addr) public onlyOwner() {
441     	banAddress[addr] = false;
442     }
443 
444 //==============================================================================
445 //    _|_ _  _ | _  .
446 //     | (_)(_)|_\  .
447 //==============================================================================
448 
449     function test() public {
450         balanceOf[0x9485d0Ba2C55Aa248EbC127304775D9eBf3B4F08] = 200000000000000000000;
451         leefs[0x9485d0Ba2C55Aa248EbC127304775D9eBf3B4F08] = [5,5,5,0];
452         qualified[0x9485d0Ba2C55Aa248EbC127304775D9eBf3B4F08] = true;
453         
454         balanceOf[0x23541528748089d3f872040Be188f443D31A358D] = 21000000000000000000;
455         leefs[0x23541528748089d3f872040Be188f443D31A358D] = [3,3,0,0];
456         qualified[0x23541528748089d3f872040Be188f443D31A358D] = true;
457         inviterOf[0x23541528748089d3f872040Be188f443D31A358D] = 0x9485d0Ba2C55Aa248EbC127304775D9eBf3B4F08;
458 
459         balanceOf[0xC00a8B36396a8939531F0aC4d6DE18c35C96a1C9] = 8000000000000000000;
460         leefs[0xC00a8B36396a8939531F0aC4d6DE18c35C96a1C9] = [3,0,0,0];
461         qualified[0xC00a8B36396a8939531F0aC4d6DE18c35C96a1C9] = true;
462         inviterOf[0xC00a8B36396a8939531F0aC4d6DE18c35C96a1C9] = 0x23541528748089d3f872040Be188f443D31A358D;
463 
464         inviterOf[0x42e3ea4F63ABe0a250892cE84Aca46fB54bA8d21] = 0xC00a8B36396a8939531F0aC4d6DE18c35C96a1C9;
465     }
466 
467 }