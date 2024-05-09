1 pragma solidity ^0.4.24;
2 
3 /***********************************************************
4  * SafeDif contract
5  *  - GAIN 2.4% PER 24 HOURS (every 5900 blocks) 60 days  0.01~500eth
6  *  - GAIN 3.5% PER 24 HOURS (every 5900 blocks) 40 days  1~1000eth
7  *  - GAIN 4.7% PER 24 HOURS (every 5900 blocks) 35 days  10~10000eth
8  *  - GAIN 1% PER 24 HOURS (every 5900 blocks) forever    0.01~10000eth
9  *  - GAIN 9% PER 24 HOURS (every 5900 blocks) 12 days    1~10000eth
10  *  
11  *  https://www.safedif.com
12  ***********************************************************/
13 
14 /***********************************************************
15  * @title SafeMath v0.1.9
16  * @dev Math operations with safety checks that throw on error
17  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
18  * - added sqrt
19  * - added sq
20  * - added pwr 
21  * - changed asserts to requires with error log outputs
22  * - removed div, its useless
23  ***********************************************************/
24  library SafeMath {
25     /**
26     * @dev Multiplies two numbers, throws on overflow.
27     */
28     function mul(uint256 a, uint256 b) 
29         internal 
30         pure 
31         returns (uint256 c) 
32     {
33         if (a == 0) {
34             return 0;
35         }
36         c = a * b;
37         require(c / a == b, "SafeMath mul failed");
38         return c;
39     }
40 
41     /**
42     * @dev Integer division of two numbers, truncating the quotient.
43     */
44     function div(uint256 a, uint256 b) internal pure returns (uint256) {
45         // assert(b > 0); // Solidity automatically throws when dividing by 0
46         uint256 c = a / b;
47         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48         return c;
49     }
50     
51     /**
52     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53     */
54     function sub(uint256 a, uint256 b)
55         internal
56         pure
57         returns (uint256) 
58     {
59         require(b <= a, "SafeMath sub failed");
60         return a - b;
61     }
62 
63     /**
64     * @dev Adds two numbers, throws on overflow.
65     */
66     function add(uint256 a, uint256 b)
67         internal
68         pure
69         returns (uint256 c) 
70     {
71         c = a + b;
72         require(c >= a, "SafeMath add failed");
73         return c;
74     }
75     
76     /**
77      * @dev gives square root of given x.
78      */
79     function sqrt(uint256 x)
80         internal
81         pure
82         returns (uint256 y) 
83     {
84         uint256 z = ((add(x,1)) / 2);
85         y = x;
86         while (z < y) 
87         {
88             y = z;
89             z = ((add((x / z),z)) / 2);
90         }
91     }
92     
93     /**
94      * @dev gives square. multiplies x by x
95      */
96     function sq(uint256 x)
97         internal
98         pure
99         returns (uint256)
100     {
101         return (mul(x,x));
102     }
103     
104     /**
105      * @dev x to the power of y 
106      */
107     function pwr(uint256 x, uint256 y)
108         internal 
109         pure 
110         returns (uint256)
111     {
112         if (x==0)
113             return (0);
114         else if (y==0)
115             return (1);
116         else 
117         {
118             uint256 z = x;
119             for (uint256 i=1; i < y; i++)
120                 z = mul(z,x);
121             return (z);
122         }
123     }
124 }
125 
126 /***********************************************************
127  * SDDatasets library
128  ***********************************************************/
129 library SDDatasets {
130     struct Player {
131         address addr;   // player address
132         uint256 aff;    // affiliate vault,directly send
133         uint256 laff;   // parent id
134         uint256 planCount;
135         mapping(uint256=>PalyerPlan) plans;
136         uint256 aff1sum; //4 level
137         uint256 aff2sum;
138         uint256 aff3sum;
139         uint256 aff4sum;
140     }
141     
142     struct PalyerPlan {
143         uint256 planId;
144         uint256 startTime;
145         uint256 startBlock;
146         uint256 invested;    //
147         uint256 atBlock;    // 
148         uint256 payEth;
149         bool isClose;
150     }
151 
152     struct Plan {
153         uint256 interest;    // interest per day %%
154         uint256 dayRange;    // days, 0 means No time limit
155         uint256 min;
156         uint256 max;
157     }    
158 }
159 
160 contract SafeDif {
161     using SafeMath              for *;
162 
163     address public devAddr_ = address(0xe6CE2a354a0BF26B5b383015B7E61701F6adb39C);
164     address public affiAddr_ = address(0x08F521636a2B117B554d04dc9E54fa4061161859);
165     
166     //partner address
167     address public partnerAddr_ = address(0xa8502800F27F5c13F0701450fE07550Cf81C62a7);
168 
169     bool public activated_ = false;
170     
171     uint256 ruleSum_ = 5;
172     modifier isActivated() {
173         require(activated_ == true, "its not active yet."); 
174         _;
175     }
176 
177     //Start ---> Version 1 has code holes, and administrators have privileges. Migration of version 1 data is used.
178     function version1Invest(address addr, uint256 eth, uint256 _affCode, uint256 _planId)
179     isAdmin() public payable {
180         require(activated_ == false, "Only not active");
181         
182 	    require(_planId >= 1 && _planId <= ruleSum_, "_planId error");
183         
184 		//get uid
185 		uint256 uid = pIDxAddr_[addr];
186 		
187 		//first
188 		if (uid == 0) {
189 		    if (player_[_affCode].addr != address(0x0)) {
190 		        register_(addr, _affCode);
191 		    } else {
192 			    register_(addr, 1000);
193 		    }
194 		    
195 			uid = G_NowUserId;
196 		}
197 		
198         uint256 planCount = player_[uid].planCount;
199         player_[uid].plans[planCount].planId = _planId;
200         player_[uid].plans[planCount].startTime = now;
201         player_[uid].plans[planCount].startBlock = block.number;
202         player_[uid].plans[planCount].atBlock = block.number;
203         player_[uid].plans[planCount].invested = eth;
204         player_[uid].plans[planCount].payEth = 0;
205         player_[uid].plans[planCount].isClose = false;
206         
207         player_[uid].planCount = player_[uid].planCount.add(1);
208 
209         G_AllEth = G_AllEth.add(eth);
210 
211     }
212     //<--- end
213     
214     function activate() isAdmin() public {
215         require(address(devAddr_) != address(0x0), "Must setup devAddr_.");
216         require(address(partnerAddr_) != address(0x0), "Must setup partnerAddr_.");
217         require(address(affiAddr_) != address(0x0), "Must setup affiAddr_.");
218 
219         require(activated_ == false, "Only once");
220         activated_ = true ;
221 	}
222 	
223     mapping(address => uint256)     private g_users ;
224     function initUsers() private {
225         g_users[msg.sender] = 9 ;
226         
227         uint256 pId = G_NowUserId;
228         pIDxAddr_[msg.sender] = pId;
229         player_[pId].addr = msg.sender;
230     }
231     modifier isAdmin() {
232         uint256 role = g_users[msg.sender];
233         require((role==9), "Must be admin.");
234         _;
235     }	
236 
237     uint256 public G_NowUserId = 1000; //first user
238     uint256 public G_AllEth = 0;
239     uint256 G_DayBlocks = 5900;
240     
241     mapping (address => uint256) public pIDxAddr_;  
242     mapping (uint256 => SDDatasets.Player) public player_; 
243     mapping (uint256 => SDDatasets.Plan) private plan_;   
244 	
245 	function GetIdByAddr(address addr) public 
246 	    view returns(uint256)
247 	{
248 	    return pIDxAddr_[addr];
249 	}
250 	
251 
252 	function GetPlayerByUid(uint256 uid) public 
253 	    view returns(uint256,uint256,uint256,uint256,uint256,uint256,uint256)
254 	{
255 	    SDDatasets.Player storage player = player_[uid];
256 
257 	    return
258 	    (
259 	        player.aff,
260 	        player.laff,
261 	        player.aff1sum,
262 	        player.aff2sum,
263 	        player.aff3sum,
264 	        player.aff4sum,
265 	        player.planCount
266 	    );
267 	}
268 	
269     function GetPlanByUid(uint256 uid) public 
270 	    view returns(uint256[],uint256[],uint256[],uint256[],uint256[],bool[])
271 	{
272 	    uint256[] memory planIds = new  uint256[] (player_[uid].planCount);
273 	    uint256[] memory startBlocks = new  uint256[] (player_[uid].planCount);
274 	    uint256[] memory investeds = new  uint256[] (player_[uid].planCount);
275 	    uint256[] memory atBlocks = new  uint256[] (player_[uid].planCount);
276 	    uint256[] memory payEths = new  uint256[] (player_[uid].planCount);
277 	    bool[] memory isCloses = new  bool[] (player_[uid].planCount);
278 	    
279         for(uint i = 0; i < player_[uid].planCount; i++) {
280 	        planIds[i] = player_[uid].plans[i].planId;
281 	        startBlocks[i] = player_[uid].plans[i].startBlock;
282 	        investeds[i] = player_[uid].plans[i].invested;
283 	        atBlocks[i] = player_[uid].plans[i].atBlock;
284 	        payEths[i] = player_[uid].plans[i].payEth;
285 	        isCloses[i] = player_[uid].plans[i].isClose;
286 	    }
287 	    
288 	    return
289 	    (
290 	        planIds,
291 	        startBlocks,
292 	        investeds,
293 	        atBlocks,
294 	        payEths,
295 	        isCloses
296 	    );
297 	}
298 	
299 function GetPlanTimeByUid(uint256 uid) public 
300 	    view returns(uint256[])
301 	{
302 	    uint256[] memory startTimes = new  uint256[] (player_[uid].planCount);
303 
304         for(uint i = 0; i < player_[uid].planCount; i++) {
305 	        startTimes[i] = player_[uid].plans[i].startTime;
306 	    }
307 	    
308 	    return
309 	    (
310 	        startTimes
311 	    );
312 	}	
313 
314     constructor() public {
315         plan_[1] = SDDatasets.Plan(240,60,1e16, 5e20);
316         plan_[2] = SDDatasets.Plan(350,40,1e18, 1e21);
317         plan_[3] = SDDatasets.Plan(470,35,1e19, 1e22);
318         plan_[4] = SDDatasets.Plan(100,0,1e16, 1e22);
319         plan_[5] = SDDatasets.Plan(900,12,1e18, 1e22);
320         
321         initUsers();
322     }
323 	
324 	function register_(address addr, uint256 _affCode) private{
325         G_NowUserId = G_NowUserId.add(1);
326         
327         address _addr = addr;
328         
329         pIDxAddr_[_addr] = G_NowUserId;
330 
331         player_[G_NowUserId].addr = _addr;
332         player_[G_NowUserId].laff = _affCode;
333         player_[G_NowUserId].planCount = 0;
334         
335         uint256 _affID1 = _affCode;
336         uint256 _affID2 = player_[_affID1].laff;
337         uint256 _affID3 = player_[_affID2].laff;
338         uint256 _affID4 = player_[_affID3].laff;
339         
340         player_[_affID1].aff1sum = player_[_affID1].aff1sum.add(1);
341         player_[_affID2].aff2sum = player_[_affID2].aff2sum.add(1);
342         player_[_affID3].aff3sum = player_[_affID3].aff3sum.add(1);
343         player_[_affID4].aff4sum = player_[_affID4].aff4sum.add(1);
344 	}
345 	
346     
347     // this function called every time anyone sends a transaction to this contract
348     function () isActivated() external payable {
349         if (msg.value == 0) {
350             withdraw();
351         } else {
352             invest(1000, 1);
353         }
354     } 	
355     
356     function invest(uint256 _affCode, uint256 _planId) isActivated() public payable {
357 	    require(_planId >= 1 && _planId <= ruleSum_, "_planId error");
358         
359 		//get uid
360 		uint256 uid = pIDxAddr_[msg.sender];
361 		
362 		//first
363 		if (uid == 0) {
364 		    if (player_[_affCode].addr != address(0x0)) {
365 		        register_(msg.sender, _affCode);
366 		    } else {
367 			    register_(msg.sender, 1000);
368 		    }
369 		    
370 			uid = G_NowUserId;
371 		}
372 		
373 	    require(msg.value >= plan_[_planId].min && msg.value <= plan_[_planId].max, "invest amount error, please set the exact amount");
374 
375         // record block number and invested amount (msg.value) of this transaction
376         uint256 planCount = player_[uid].planCount;
377         player_[uid].plans[planCount].planId = _planId;
378         player_[uid].plans[planCount].startTime = now;
379         player_[uid].plans[planCount].startBlock = block.number;
380         player_[uid].plans[planCount].atBlock = block.number;
381         player_[uid].plans[planCount].invested = msg.value;
382         player_[uid].plans[planCount].payEth = 0;
383         player_[uid].plans[planCount].isClose = false;
384         
385         player_[uid].planCount = player_[uid].planCount.add(1);
386 
387         G_AllEth = G_AllEth.add(msg.value);
388         
389         if (msg.value > 1000000000) {
390             distributeRef(msg.value, player_[uid].laff);
391             
392             uint256 devFee = (msg.value.mul(2)).div(100);
393             devAddr_.transfer(devFee);
394             
395             uint256 partnerFee = (msg.value.mul(2)).div(100);
396             partnerAddr_.transfer(partnerFee);
397         } 
398         
399     }
400    
401 	
402 	function withdraw() isActivated() public payable {
403 	    require(msg.value == 0, "withdraw fee is 0 ether, please set the exact amount");
404 	    
405 	    uint256 uid = pIDxAddr_[msg.sender];
406 	    require(uid != 0, "no invest");
407 
408         for(uint i = 0; i < player_[uid].planCount; i++) {
409 	        if (player_[uid].plans[i].isClose) {
410 	            continue;
411 	        }
412 
413             SDDatasets.Plan plan = plan_[player_[uid].plans[i].planId];
414             
415             uint256 blockNumber = block.number;
416             bool bClose = false;
417             if (plan.dayRange > 0) {
418                 
419                 uint256 endBlockNumber = player_[uid].plans[i].startBlock.add(plan.dayRange*G_DayBlocks);
420                 if (blockNumber > endBlockNumber){
421                     blockNumber = endBlockNumber;
422                     bClose = true;
423                 }
424             }
425             
426             uint256 amount = player_[uid].plans[i].invested * plan.interest / 10000 * (blockNumber - player_[uid].plans[i].atBlock) / G_DayBlocks;
427 
428             // send calculated amount of ether directly to sender (aka YOU)
429             address sender = msg.sender;
430             sender.send(amount);
431 
432             // record block number and invested amount (msg.value) of this transaction
433             player_[uid].plans[i].atBlock = block.number;
434             player_[uid].plans[i].isClose = bClose;
435             player_[uid].plans[i].payEth += amount;
436         }
437 	}
438 
439 	
440     function distributeRef(uint256 _eth, uint256 _affID) private{
441         
442         uint256 _allaff = (_eth.mul(8)).div(100);
443         
444         uint256 _affID1 = _affID;
445         uint256 _affID2 = player_[_affID1].laff;
446         uint256 _affID3 = player_[_affID2].laff;
447         uint256 _aff = 0;
448 
449         if (_affID1 != 0) {   
450             _aff = (_eth.mul(5)).div(100);
451             _allaff = _allaff.sub(_aff);
452             player_[_affID1].aff = _aff.add(player_[_affID1].aff);
453             player_[_affID1].addr.transfer(_aff);
454         }
455 
456         if (_affID2 != 0) {   
457             _aff = (_eth.mul(2)).div(100);
458             _allaff = _allaff.sub(_aff);
459             player_[_affID2].aff = _aff.add(player_[_affID2].aff);
460             player_[_affID2].addr.transfer(_aff);
461         }
462 
463         if (_affID3 != 0) {   
464             _aff = (_eth.mul(1)).div(100);
465             _allaff = _allaff.sub(_aff);
466             player_[_affID3].aff = _aff.add(player_[_affID3].aff);
467             player_[_affID3].addr.transfer(_aff);
468        }
469 
470         if(_allaff > 0 ){
471             affiAddr_.transfer(_allaff);
472         }      
473     }	
474 }