1 pragma solidity ^0.4.25;
2 
3 /***********************************************************
4  * MultiInvest contract
5  *  - GAIN 5.3% PER 24 HOURS (every 5900 blocks) 40 days  0.01~500eth
6  *  - GAIN 5.6% PER 24 HOURS (every 5900 blocks) 30 days  1~1000eth
7  *  - GAIN 6.6% PER 24 HOURS (every 5900 blocks) 20 days  2~10000eth
8  *  - GAIN 7.6% PER 24 HOURS (every 5900 blocks) 15 days  5~10000eth
9  *  - GAIN 8.5% PER 24 HOURS (every 5900 blocks) 12 days    10~10000eth
10  *  - GAIN 3% PER 24 HOURS (every 5900 blocks) forever    0.01~10000eth
11  *  
12  *  website:  https://www.MultiInvest.biz
13  *  telegram: https://t.me/MultiInvest
14  ***********************************************************/
15 
16 /***********************************************************
17  * @title SafeMath v0.1.9
18  * @dev Math operations with safety checks that throw on error
19  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
20  * - added sqrt
21  * - added sq
22  * - added pwr 
23  * - changed asserts to requires with error log outputs
24  * - removed div, its useless
25  ***********************************************************/
26  library SafeMath {
27     /**
28     * @dev Multiplies two numbers, throws on overflow.
29     */
30     function mul(uint256 a, uint256 b) 
31         internal 
32         pure 
33         returns (uint256 c) 
34     {
35         if (a == 0) {
36             return 0;
37         }
38         c = a * b;
39         require(c / a == b, "SafeMath mul failed");
40         return c;
41     }
42 
43     /**
44     * @dev Integer division of two numbers, truncating the quotient.
45     */
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         // assert(b > 0); // Solidity automatically throws when dividing by 0
48         uint256 c = a / b;
49         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
50         return c;
51     }
52     
53     /**
54     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
55     */
56     function sub(uint256 a, uint256 b)
57         internal
58         pure
59         returns (uint256) 
60     {
61         require(b <= a, "SafeMath sub failed");
62         return a - b;
63     }
64 
65     /**
66     * @dev Adds two numbers, throws on overflow.
67     */
68     function add(uint256 a, uint256 b)
69         internal
70         pure
71         returns (uint256 c) 
72     {
73         c = a + b;
74         require(c >= a, "SafeMath add failed");
75         return c;
76     }
77     
78     /**
79      * @dev gives square root of given x.
80      */
81     function sqrt(uint256 x)
82         internal
83         pure
84         returns (uint256 y) 
85     {
86         uint256 z = ((add(x,1)) / 2);
87         y = x;
88         while (z < y) 
89         {
90             y = z;
91             z = ((add((x / z),z)) / 2);
92         }
93     }
94     
95     /**
96      * @dev gives square. multiplies x by x
97      */
98     function sq(uint256 x)
99         internal
100         pure
101         returns (uint256)
102     {
103         return (mul(x,x));
104     }
105     
106     /**
107      * @dev x to the power of y 
108      */
109     function pwr(uint256 x, uint256 y)
110         internal 
111         pure 
112         returns (uint256)
113     {
114         if (x==0)
115             return (0);
116         else if (y==0)
117             return (1);
118         else 
119         {
120             uint256 z = x;
121             for (uint256 i=1; i < y; i++)
122                 z = mul(z,x);
123             return (z);
124         }
125     }
126 }
127 
128 /***********************************************************
129  * SDDatasets library
130  ***********************************************************/
131 library SDDatasets {
132     struct Player {
133         address addr;   // player address
134         uint256 aff;    // affiliate vault,directly send
135         uint256 laff;   // parent id
136         uint256 planCount;
137         mapping(uint256=>PalyerPlan) plans;
138         uint256 aff1sum; //4 level
139         uint256 aff2sum;
140         uint256 aff3sum;
141         uint256 aff4sum;
142     }
143     
144     struct PalyerPlan {
145         uint256 planId;
146         uint256 startTime;
147         uint256 startBlock;
148         uint256 invested;    //
149         uint256 atBlock;    // 
150         uint256 payEth;
151         bool isClose;
152     }
153 
154     struct Plan {
155         uint256 interest;    // interest per day %%
156         uint256 dayRange;    // days, 0 means No time limit
157         uint256 min;
158         uint256 max;
159     }    
160 }
161 
162 contract MultiInvest {
163     using SafeMath              for *;
164 
165     address public devAddr_ = address(0xe6CE2a354a0BF26B5b383015B7E61701F6adb39C);
166     address public commuAddr_ = address(0x08F521636a2B117B554d04dc9E54fa4061161859);
167     
168     //partner address
169     address public partnerAddr_ = address(0xEc31176d4df0509115abC8065A8a3F8275aafF2b);
170 
171     bool public activated_ = false;
172     
173     uint256 ruleSum_ = 6;
174     modifier isActivated() {
175         require(activated_ == true, "its not active yet."); 
176         _;
177     }
178 
179     function activate() isAdmin() public {
180         require(address(devAddr_) != address(0x0), "Must setup devAddr_.");
181         require(address(partnerAddr_) != address(0x0), "Must setup partnerAddr_.");
182         require(address(commuAddr_) != address(0x0), "Must setup affiAddr_.");
183 
184         require(activated_ == false, "Only once");
185         activated_ = true ;
186 	}
187 	
188     mapping(address => uint256)     private g_users ;
189     function initUsers() private {
190         g_users[msg.sender] = 9 ;
191         
192         uint256 pId = G_NowUserId;
193         pIDxAddr_[msg.sender] = pId;
194         player_[pId].addr = msg.sender;
195     }
196     modifier isAdmin() {
197         uint256 role = g_users[msg.sender];
198         require((role==9), "Must be admin.");
199         _;
200     }	
201 
202     uint256 public G_NowUserId = 1000; //first user
203     uint256 public G_AllEth = 0;
204     uint256 G_DayBlocks = 5900;
205     
206     mapping (address => uint256) public pIDxAddr_;  
207     mapping (uint256 => SDDatasets.Player) public player_; 
208     mapping (uint256 => SDDatasets.Plan) private plan_;   
209 	
210 	function GetIdByAddr(address addr) public 
211 	    view returns(uint256)
212 	{
213 	    return pIDxAddr_[addr];
214 	}
215 	
216 
217 	function GetPlayerByUid(uint256 uid) public 
218 	    view returns(uint256,uint256,uint256,uint256,uint256,uint256,uint256)
219 	{
220 	    SDDatasets.Player storage player = player_[uid];
221 
222 	    return
223 	    (
224 	        player.aff,
225 	        player.laff,
226 	        player.aff1sum,
227 	        player.aff2sum,
228 	        player.aff3sum,
229 	        player.aff4sum,
230 	        player.planCount
231 	    );
232 	}
233 	
234     function GetPlanByUid(uint256 uid) public 
235 	    view returns(uint256[],uint256[],uint256[],uint256[],uint256[],bool[])
236 	{
237 	    uint256[] memory planIds = new  uint256[] (player_[uid].planCount);
238 	    uint256[] memory startBlocks = new  uint256[] (player_[uid].planCount);
239 	    uint256[] memory investeds = new  uint256[] (player_[uid].planCount);
240 	    uint256[] memory atBlocks = new  uint256[] (player_[uid].planCount);
241 	    uint256[] memory payEths = new  uint256[] (player_[uid].planCount);
242 	    bool[] memory isCloses = new  bool[] (player_[uid].planCount);
243 	    
244         for(uint i = 0; i < player_[uid].planCount; i++) {
245 	        planIds[i] = player_[uid].plans[i].planId;
246 	        startBlocks[i] = player_[uid].plans[i].startBlock;
247 	        investeds[i] = player_[uid].plans[i].invested;
248 	        atBlocks[i] = player_[uid].plans[i].atBlock;
249 	        payEths[i] = player_[uid].plans[i].payEth;
250 	        isCloses[i] = player_[uid].plans[i].isClose;
251 	    }
252 	    
253 	    return
254 	    (
255 	        planIds,
256 	        startBlocks,
257 	        investeds,
258 	        atBlocks,
259 	        payEths,
260 	        isCloses
261 	    );
262 	}
263 	
264 function GetPlanTimeByUid(uint256 uid) public 
265 	    view returns(uint256[])
266 	{
267 	    uint256[] memory startTimes = new  uint256[] (player_[uid].planCount);
268 
269         for(uint i = 0; i < player_[uid].planCount; i++) {
270 	        startTimes[i] = player_[uid].plans[i].startTime;
271 	    }
272 	    
273 	    return
274 	    (
275 	        startTimes
276 	    );
277 	}	
278 
279     constructor() public {
280         plan_[1] = SDDatasets.Plan(530,40,1e16, 5e20);
281         plan_[2] = SDDatasets.Plan(560,30,1e18, 1e21);
282         plan_[3] = SDDatasets.Plan(660,20,2e18, 1e22);
283         plan_[4] = SDDatasets.Plan(760,15,5e18, 1e22);
284         plan_[5] = SDDatasets.Plan(850,12,1e19, 1e22);
285         plan_[6] = SDDatasets.Plan(300,0,1e16, 1e22);
286         
287         initUsers();
288     }
289 	
290 	function register_(address addr, uint256 _affCode) private{
291         G_NowUserId = G_NowUserId.add(1);
292         
293         address _addr = addr;
294         
295         pIDxAddr_[_addr] = G_NowUserId;
296 
297         player_[G_NowUserId].addr = _addr;
298         player_[G_NowUserId].laff = _affCode;
299         player_[G_NowUserId].planCount = 0;
300         
301         uint256 _affID1 = _affCode;
302         uint256 _affID2 = player_[_affID1].laff;
303         uint256 _affID3 = player_[_affID2].laff;
304         uint256 _affID4 = player_[_affID3].laff;
305         
306         player_[_affID1].aff1sum = player_[_affID1].aff1sum.add(1);
307         player_[_affID2].aff2sum = player_[_affID2].aff2sum.add(1);
308         player_[_affID3].aff3sum = player_[_affID3].aff3sum.add(1);
309         player_[_affID4].aff4sum = player_[_affID4].aff4sum.add(1);
310 	}
311 	
312     
313     // this function called every time anyone sends a transaction to this contract
314     function () isActivated() external payable {
315         if (msg.value == 0) {
316             withdraw();
317         } else {
318             invest(1000, 1);
319         }
320     } 	
321     
322     function invest(uint256 _affCode, uint256 _planId) isActivated() public payable {
323 	    require(_planId >= 1 && _planId <= ruleSum_, "_planId error");
324         
325 		//get uid
326 		uint256 uid = pIDxAddr_[msg.sender];
327 		
328 		//first
329 		if (uid == 0) {
330 		    if (player_[_affCode].addr != address(0x0)) {
331 		        register_(msg.sender, _affCode);
332 		    } else {
333 			    register_(msg.sender, 1000);
334 		    }
335 		    
336 			uid = G_NowUserId;
337 		}
338 		
339 	    require(msg.value >= plan_[_planId].min && msg.value <= plan_[_planId].max, "invest amount error, please set the exact amount");
340 
341         // record block number and invested amount (msg.value) of this transaction
342         uint256 planCount = player_[uid].planCount;
343         player_[uid].plans[planCount].planId = _planId;
344         player_[uid].plans[planCount].startTime = now;
345         player_[uid].plans[planCount].startBlock = block.number;
346         player_[uid].plans[planCount].atBlock = block.number;
347         player_[uid].plans[planCount].invested = msg.value;
348         player_[uid].plans[planCount].payEth = 0;
349         player_[uid].plans[planCount].isClose = false;
350         
351         player_[uid].planCount = player_[uid].planCount.add(1);
352 
353         G_AllEth = G_AllEth.add(msg.value);
354         
355         if (msg.value > 1000000000) {
356             distributeRef(msg.value, player_[uid].laff);
357             
358             uint256 devFee = (msg.value.mul(2)).div(100);
359             devAddr_.transfer(devFee);
360             
361             uint256 partnerFee = (msg.value.mul(2)).div(100);
362             partnerAddr_.transfer(partnerFee);
363         } 
364         
365     }
366    
367 	
368 	function withdraw() isActivated() public payable {
369 	    require(msg.value == 0, "withdraw fee is 0 ether, please set the exact amount");
370 	    
371 	    uint256 uid = pIDxAddr_[msg.sender];
372 	    require(uid != 0, "no invest");
373 
374         for(uint i = 0; i < player_[uid].planCount; i++) {
375 	        if (player_[uid].plans[i].isClose) {
376 	            continue;
377 	        }
378 
379             SDDatasets.Plan plan = plan_[player_[uid].plans[i].planId];
380             
381             uint256 blockNumber = block.number;
382             bool bClose = false;
383             if (plan.dayRange > 0) {
384                 
385                 uint256 endBlockNumber = player_[uid].plans[i].startBlock.add(plan.dayRange*G_DayBlocks);
386                 if (blockNumber > endBlockNumber){
387                     blockNumber = endBlockNumber;
388                     bClose = true;
389                 }
390             }
391             
392             uint256 amount = player_[uid].plans[i].invested * plan.interest / 10000 * (blockNumber - player_[uid].plans[i].atBlock) / G_DayBlocks;
393 
394             // send calculated amount of ether directly to sender (aka YOU)
395             address sender = msg.sender;
396             sender.send(amount);
397 
398             // record block number and invested amount (msg.value) of this transaction
399             player_[uid].plans[i].atBlock = block.number;
400             player_[uid].plans[i].isClose = bClose;
401             player_[uid].plans[i].payEth += amount;
402         }
403 	}
404 
405 	
406     function distributeRef(uint256 _eth, uint256 _affID) private{
407         
408         uint256 _allaff = (_eth.mul(8)).div(100);
409         
410         uint256 _affID1 = _affID;
411         uint256 _affID2 = player_[_affID1].laff;
412         uint256 _affID3 = player_[_affID2].laff;
413         uint256 _aff = 0;
414 
415         if (_affID1 != 0) {   
416             _aff = (_eth.mul(5)).div(100);
417             _allaff = _allaff.sub(_aff);
418             player_[_affID1].aff = _aff.add(player_[_affID1].aff);
419             player_[_affID1].addr.transfer(_aff);
420         }
421 
422         if (_affID2 != 0) {   
423             _aff = (_eth.mul(2)).div(100);
424             _allaff = _allaff.sub(_aff);
425             player_[_affID2].aff = _aff.add(player_[_affID2].aff);
426             player_[_affID2].addr.transfer(_aff);
427         }
428 
429         if (_affID3 != 0) {   
430             _aff = (_eth.mul(1)).div(100);
431             _allaff = _allaff.sub(_aff);
432             player_[_affID3].aff = _aff.add(player_[_affID3].aff);
433             player_[_affID3].addr.transfer(_aff);
434        }
435 
436         if(_allaff > 0 ){
437             commuAddr_.transfer(_allaff);
438         }      
439     }	
440 }