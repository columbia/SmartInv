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
177     function activate() isAdmin() public {
178         require(address(devAddr_) != address(0x0), "Must setup devAddr_.");
179         require(address(partnerAddr_) != address(0x0), "Must setup partnerAddr_.");
180         require(address(affiAddr_) != address(0x0), "Must setup affiAddr_.");
181 
182         require(activated_ == false, "Only once");
183         activated_ = true ;
184 	}
185 	
186     mapping(address => uint256)     private g_users ;
187     function initUsers() private {
188         g_users[msg.sender] = 9 ;
189         
190         uint256 pId = G_NowUserId;
191         pIDxAddr_[msg.sender] = pId;
192         player_[pId].addr = msg.sender;
193     }
194     modifier isAdmin() {
195         uint256 role = g_users[msg.sender];
196         require((role==9), "Must be admin.");
197         _;
198     }	
199     function addRule(uint256 _interest, uint256 _dayRange,
200         uint256 _min, uint256 _max) isAdmin() public {
201         require(address(devAddr_) != address(0x0), "Must setup devAddr_.");
202         require(address(partnerAddr_) != address(0x0), "Must setup partnerAddr_.");
203         require(address(affiAddr_) != address(0x0), "Must setup affiAddr_.");
204 
205         ruleSum_ = ruleSum_.add(1);
206         
207         plan_[ruleSum_] = SDDatasets.Plan(_interest,_dayRange,_min, _max);
208         
209 	}
210 	
211     uint256 public G_NowUserId = 1000; //first user
212     uint256 public G_AllEth = 0;
213     uint256 G_DayBlocks = 5900;
214     
215     mapping (address => uint256) public pIDxAddr_;  
216     mapping (uint256 => SDDatasets.Player) public player_; 
217     mapping (uint256 => SDDatasets.Plan) private plan_;   
218 	
219 	function GetIdByAddr(address addr) public 
220 	    view returns(uint256)
221 	{
222 	    return pIDxAddr_[addr];
223 	}
224 	
225 
226 	function GetPlayerByUid(uint256 uid) public 
227 	    view returns(uint256,uint256,uint256,uint256,uint256,uint256,uint256)
228 	{
229 	    SDDatasets.Player storage player = player_[uid];
230 
231 	    return
232 	    (
233 	        player.aff,
234 	        player.laff,
235 	        player.aff1sum,
236 	        player.aff2sum,
237 	        player.aff3sum,
238 	        player.aff4sum,
239 	        player.planCount
240 	    );
241 	}
242 	
243     function GetPlanByUid(uint256 uid) public 
244 	    view returns(uint256[],uint256[],uint256[],uint256[],uint256[],bool[])
245 	{
246 	    uint256[] memory planIds = new  uint256[] (player_[uid].planCount);
247 	    uint256[] memory startBlocks = new  uint256[] (player_[uid].planCount);
248 	    uint256[] memory investeds = new  uint256[] (player_[uid].planCount);
249 	    uint256[] memory atBlocks = new  uint256[] (player_[uid].planCount);
250 	    uint256[] memory payEths = new  uint256[] (player_[uid].planCount);
251 	    bool[] memory isCloses = new  bool[] (player_[uid].planCount);
252 	    
253         for(uint i = 0; i < player_[uid].planCount; i++) {
254 	        planIds[i] = player_[uid].plans[i].planId;
255 	        startBlocks[i] = player_[uid].plans[i].startBlock;
256 	        investeds[i] = player_[uid].plans[i].invested;
257 	        atBlocks[i] = player_[uid].plans[i].atBlock;
258 	        payEths[i] = player_[uid].plans[i].payEth;
259 	        isCloses[i] = player_[uid].plans[i].isClose;
260 	    }
261 	    
262 	    return
263 	    (
264 	        planIds,
265 	        startBlocks,
266 	        investeds,
267 	        atBlocks,
268 	        payEths,
269 	        isCloses
270 	    );
271 	}
272 	
273 function GetPlanTimeByUid(uint256 uid) public 
274 	    view returns(uint256[])
275 	{
276 	    uint256[] memory startTimes = new  uint256[] (player_[uid].planCount);
277 
278         for(uint i = 0; i < player_[uid].planCount; i++) {
279 	        startTimes[i] = player_[uid].plans[i].startTime;
280 	    }
281 	    
282 	    return
283 	    (
284 	        startTimes
285 	    );
286 	}	
287 
288     constructor() public {
289         plan_[1] = SDDatasets.Plan(240,60,1e16, 5e20);
290         plan_[2] = SDDatasets.Plan(350,40,1e18, 1e21);
291         plan_[3] = SDDatasets.Plan(470,35,1e19, 1e22);
292         plan_[4] = SDDatasets.Plan(100,0,1e16, 1e22);
293         plan_[5] = SDDatasets.Plan(900,12,1e18, 1e22);
294         
295         initUsers();
296     }
297 	
298 	function register_(uint256 _affCode) private{
299         G_NowUserId = G_NowUserId.add(1);
300         
301         address _addr = msg.sender;
302         
303         pIDxAddr_[_addr] = G_NowUserId;
304 
305         player_[G_NowUserId].addr = _addr;
306         player_[G_NowUserId].laff = _affCode;
307         player_[G_NowUserId].planCount = 0;
308         
309         uint256 _affID1 = _affCode;
310         uint256 _affID2 = player_[_affID1].laff;
311         uint256 _affID3 = player_[_affID2].laff;
312         uint256 _affID4 = player_[_affID3].laff;
313         
314         player_[_affID1].aff1sum = player_[_affID1].aff1sum.add(1);
315         player_[_affID2].aff2sum = player_[_affID2].aff2sum.add(1);
316         player_[_affID3].aff3sum = player_[_affID3].aff3sum.add(1);
317         player_[_affID4].aff4sum = player_[_affID4].aff4sum.add(1);
318 	}
319 	
320     
321     // this function called every time anyone sends a transaction to this contract
322     function () isActivated() external payable {
323         if (msg.value == 0) {
324             withdraw();
325         } else {
326             invest(1000, 1);
327         }
328     } 	
329     
330     function invest(uint256 _affCode, uint256 _planId) isActivated() public payable {
331 	    require(_planId >= 1 && _planId <= ruleSum_, "_planId error");
332         
333 		//get uid
334 		uint256 uid = pIDxAddr_[msg.sender];
335 		
336 		//first
337 		if (uid == 0) {
338 		    if (player_[_affCode].addr != address(0x0)) {
339 		        register_(_affCode);
340 		    } else {
341 			    register_(1000);
342 		    }
343 		    
344 			uid = G_NowUserId;
345 		}
346 		
347 	    require(msg.value >= plan_[_planId].min && msg.value <= plan_[_planId].max, "invest amount error, please set the exact amount");
348 
349         // record block number and invested amount (msg.value) of this transaction
350         uint256 planCount = player_[uid].planCount;
351         player_[uid].plans[planCount].planId = _planId;
352         player_[uid].plans[planCount].startTime = now;
353         player_[uid].plans[planCount].startBlock = block.number;
354         player_[uid].plans[planCount].atBlock = block.number;
355         player_[uid].plans[planCount].invested = msg.value;
356         player_[uid].plans[planCount].payEth = 0;
357         player_[uid].plans[planCount].isClose = false;
358         
359         player_[uid].planCount = player_[uid].planCount.add(1);
360 
361         G_AllEth = G_AllEth.add(msg.value);
362         
363         if (msg.value > 1000000000) {
364             distributeRef(msg.value, player_[uid].laff);
365             
366             uint256 devFee = (msg.value.mul(2)).div(100);
367             devAddr_.transfer(devFee);
368             
369             uint256 partnerFee = (msg.value.mul(2)).div(100);
370             partnerAddr_.transfer(partnerFee);
371         } 
372         
373     }
374    
375 	
376 	function withdraw() isActivated() public payable {
377 	    require(msg.value == 0, "withdraw fee is 0 ether, please set the exact amount");
378 	    
379 	    uint256 uid = pIDxAddr_[msg.sender];
380 	    require(uid != 0, "no invest");
381 
382         for(uint i = 0; i < player_[uid].planCount; i++) {
383 	        if (player_[uid].plans[i].isClose) {
384 	            continue;
385 	        }
386 
387             SDDatasets.Plan plan = plan_[player_[uid].plans[i].planId];
388             
389             uint256 blockNumber = block.number;
390             bool bClose = false;
391             if (plan.dayRange > 0) {
392                 
393                 uint256 endBlockNumber = player_[uid].plans[i].startBlock.add(plan.dayRange*G_DayBlocks);
394                 if (blockNumber > endBlockNumber){
395                     blockNumber = endBlockNumber;
396                     bClose = true;
397                 }
398             }
399             
400             uint256 amount = player_[uid].plans[i].invested * plan.interest / 10000 * (blockNumber - player_[uid].plans[i].atBlock) / G_DayBlocks;
401 
402             // send calculated amount of ether directly to sender (aka YOU)
403             address sender = msg.sender;
404             sender.send(amount);
405 
406             // record block number and invested amount (msg.value) of this transaction
407             player_[uid].plans[i].atBlock = block.number;
408             player_[uid].plans[i].isClose = bClose;
409             player_[uid].plans[i].payEth += amount;
410         }
411 	}
412 
413 	
414     function distributeRef(uint256 _eth, uint256 _affID) private{
415         
416         uint256 _allaff = (_eth.mul(8)).div(100);
417         
418         uint256 _affID1 = _affID;
419         uint256 _affID2 = player_[_affID1].laff;
420         uint256 _affID3 = player_[_affID2].laff;
421         uint256 _aff = 0;
422 
423         if (_affID1 != 0) {   
424             _aff = (_eth.mul(5)).div(100);
425             _allaff = _allaff.sub(_aff);
426             player_[_affID1].aff = _aff.add(player_[_affID1].aff);
427             player_[_affID1].addr.transfer(_aff);
428         }
429 
430         if (_affID2 != 0) {   
431             _aff = (_eth.mul(2)).div(100);
432             _allaff = _allaff.sub(_aff);
433             player_[_affID2].aff = _aff.add(player_[_affID2].aff);
434             player_[_affID2].addr.transfer(_aff);
435         }
436 
437         if (_affID3 != 0) {   
438             _aff = (_eth.mul(1)).div(100);
439             _allaff = _allaff.sub(_aff);
440             player_[_affID3].aff = _aff.add(player_[_affID3].aff);
441             player_[_affID3].addr.transfer(_aff);
442        }
443 
444         if(_allaff > 0 ){
445             affiAddr_.transfer(_allaff);
446         }      
447     }	
448 }