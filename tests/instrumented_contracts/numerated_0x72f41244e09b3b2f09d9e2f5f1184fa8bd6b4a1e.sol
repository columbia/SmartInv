1 pragma solidity ^0.4.25;
2 
3 /***********************************************************
4  * Easy Smart Contract
5  *  - GAIN 5.3% PER 24 HOURS (every 5900 blocks) 40 days  
6  *  - GAIN 5.6% PER 24 HOURS (every 5900 blocks) 30 days  
7  *  - GAIN 6.6% PER 24 HOURS (every 5900 blocks) 20 days  
8  *  - GAIN 7.6% PER 24 HOURS (every 5900 blocks) 15 days  
9  *  - GAIN 8.5% PER 24 HOURS (every 5900 blocks) 12 days   
10  *  - GAIN 3% PER 24 HOURS (every 5900 blocks) forever  
11  *  
12   * How to use:
13  *  1. Send any amount of ether to make an investment (The Data input 1~6 investment category, the default is 1.)
14  *  2. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
15  *
16  *  ****** When contract balance less than 0.0001eth, Automatically enter the next round
17  * 
18  * RECOMMENDED GAS LIMIT: 300000
19  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
20  * 
21  * 
22  *  https://www.easysmart.biz
23  *  https://t.me/easy_smart
24  ***********************************************************/
25 
26 contract EasySmart {
27     using SafeMath              for *;
28 
29     address public promoAddr_ = address(0xfCFbaFfD975B107B2Bcd58BF71DC78fBeBB6215D);
30 
31     uint256 ruleSum_ = 6;
32 
33     uint256 G_DayBlocks = 5900;
34     
35     uint256 public rId_ = 1;
36     mapping (uint256 => ESDatasets.Round) public round_; 
37 
38     mapping (uint256 => mapping(address => uint256)) public pIDxAddr_;  
39     mapping (uint256 => mapping(uint256 => ESDatasets.Player)) public player_; 
40     mapping (uint256 => ESDatasets.Plan) private plan_;   
41 	
42 	function GetIdByAddr(address addr) public 
43 	    view returns(uint256)
44 	{
45 	    return pIDxAddr_[rId_][addr];
46 	}
47 	
48 
49 	function GetPlayerByUid(uint256 uid) public 
50 	    view returns(uint256)
51 	{
52 	    ESDatasets.Player storage player = player_[rId_][uid];
53 
54 	    return
55 	    (
56 	        player.planCount
57 	    );
58 	}
59 	
60     function GetPlanByUid(uint256 uid) public 
61 	    view returns(uint256[],uint256[],uint256[],uint256[],uint256[],bool[])
62 	{
63 	    uint256[] memory planIds = new  uint256[] (player_[rId_][uid].planCount);
64 	    uint256[] memory startBlocks = new  uint256[] (player_[rId_][uid].planCount);
65 	    uint256[] memory investeds = new  uint256[] (player_[rId_][uid].planCount);
66 	    uint256[] memory atBlocks = new  uint256[] (player_[rId_][uid].planCount);
67 	    uint256[] memory payEths = new  uint256[] (player_[rId_][uid].planCount);
68 	    bool[] memory isCloses = new  bool[] (player_[rId_][uid].planCount);
69 	    
70         for(uint i = 0; i < player_[rId_][uid].planCount; i++) {
71 	        planIds[i] = player_[rId_][uid].plans[i].planId;
72 	        startBlocks[i] = player_[rId_][uid].plans[i].startBlock;
73 	        investeds[i] = player_[rId_][uid].plans[i].invested;
74 	        atBlocks[i] = player_[rId_][uid].plans[i].atBlock;
75 	        payEths[i] = player_[rId_][uid].plans[i].payEth;
76 	        isCloses[i] = player_[rId_][uid].plans[i].isClose;
77 	    }
78 	    
79 	    return
80 	    (
81 	        planIds,
82 	        startBlocks,
83 	        investeds,
84 	        atBlocks,
85 	        payEths,
86 	        isCloses
87 	    );
88 	}
89 	
90 function GetPlanTimeByUid(uint256 uid) public 
91 	    view returns(uint256[])
92 	{
93 	    uint256[] memory startTimes = new  uint256[] (player_[rId_][uid].planCount);
94 
95         for(uint i = 0; i < player_[rId_][uid].planCount; i++) {
96 	        startTimes[i] = player_[rId_][uid].plans[i].startTime;
97 	    }
98 	    
99 	    return
100 	    (
101 	        startTimes
102 	    );
103 	}	
104 
105     constructor() public {
106         plan_[1] = ESDatasets.Plan(530,40);
107         plan_[2] = ESDatasets.Plan(560,30);
108         plan_[3] = ESDatasets.Plan(660,20);
109         plan_[4] = ESDatasets.Plan(760,15);
110         plan_[5] = ESDatasets.Plan(850,12);
111         plan_[6] = ESDatasets.Plan(300,0);
112         
113         round_[rId_].startTime = now;
114 
115     }
116 	
117 	function register_(address addr) private{
118         round_[rId_].nowUserId = round_[rId_].nowUserId.add(1);
119         
120         address _addr = addr;
121         
122         pIDxAddr_[rId_][_addr] = round_[rId_].nowUserId;
123 
124         player_[rId_][round_[rId_].nowUserId].addr = _addr;
125         player_[rId_][round_[rId_].nowUserId].planCount = 0;
126         
127 	}
128 	
129     
130     // this function called every time anyone sends a transaction to this contract
131     function () external payable {
132         if (msg.value == 0) {
133             withdraw();
134         } else {
135             invest();
136         }
137     } 	
138     
139     function invest() private {
140 	    uint256 _planId = bytesToUint(msg.data);
141 	    
142 	    if (_planId<1 || _planId > ruleSum_) {
143 	        _planId = 1;
144 	    }
145         
146 		//get uid
147 		uint256 uid = pIDxAddr_[rId_][msg.sender];
148 		
149 		//first
150 		if (uid == 0) {
151 		    register_(msg.sender);
152 			uid = round_[rId_].nowUserId;
153 		}
154 		
155         // record block number and invested amount (msg.value) of this transaction
156         uint256 planCount = player_[rId_][uid].planCount;
157         player_[rId_][uid].plans[planCount].planId = _planId;
158         player_[rId_][uid].plans[planCount].startTime = now;
159         player_[rId_][uid].plans[planCount].startBlock = block.number;
160         player_[rId_][uid].plans[planCount].atBlock = block.number;
161         player_[rId_][uid].plans[planCount].invested = msg.value;
162         player_[rId_][uid].plans[planCount].payEth = 0;
163         player_[rId_][uid].plans[planCount].isClose = false;
164         
165         player_[rId_][uid].planCount = player_[rId_][uid].planCount.add(1);
166 
167         round_[rId_].ethSum = round_[rId_].ethSum.add(msg.value);
168         
169         if (msg.value > 1000000000) {
170 
171             uint256 promoFee = (msg.value.mul(5)).div(100);
172             promoAddr_.transfer(promoFee);
173             
174         } 
175         
176     }
177    
178 	
179 	function withdraw() private {
180 	    require(msg.value == 0, "withdraw fee is 0 ether, please set the exact amount");
181 	    
182 	    uint256 uid = pIDxAddr_[rId_][msg.sender];
183 	    require(uid != 0, "no invest");
184 
185         for(uint i = 0; i < player_[rId_][uid].planCount; i++) {
186 	        if (player_[rId_][uid].plans[i].isClose) {
187 	            continue;
188 	        }
189 
190             ESDatasets.Plan plan = plan_[player_[rId_][uid].plans[i].planId];
191             
192             uint256 blockNumber = block.number;
193             bool bClose = false;
194             if (plan.dayRange > 0) {
195                 
196                 uint256 endBlockNumber = player_[rId_][uid].plans[i].startBlock.add(plan.dayRange*G_DayBlocks);
197                 if (blockNumber > endBlockNumber){
198                     blockNumber = endBlockNumber;
199                     bClose = true;
200                 }
201             }
202             
203             uint256 amount = player_[rId_][uid].plans[i].invested * plan.interest / 10000 * (blockNumber - player_[rId_][uid].plans[i].atBlock) / G_DayBlocks;
204 
205             // send calculated amount of ether directly to sender (aka YOU)
206             address sender = msg.sender;
207             sender.send(amount);
208 
209             // record block number and invested amount (msg.value) of this transaction
210             player_[rId_][uid].plans[i].atBlock = block.number;
211             player_[rId_][uid].plans[i].isClose = bClose;
212             player_[rId_][uid].plans[i].payEth += amount;
213         }
214         
215         if (this.balance < 100000000000000) { //0.0001eth
216             rId_ = rId_.add(1);
217             round_[rId_].startTime = now;
218         }
219 	}
220 	
221     function bytesToUint(bytes b) private returns (uint256){
222         uint256 number;
223         for(uint i=0;i<b.length;i++){
224             number = number + uint(b[i])*(2**(8*(b.length-(i+1))));
225         }
226         return number;
227     }	
228 }
229 
230 /***********************************************************
231  * @title SafeMath v0.1.9
232  * @dev Math operations with safety checks that throw on error
233  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
234  * - added sqrt
235  * - added sq
236  * - added pwr 
237  * - changed asserts to requires with error log outputs
238  * - removed div, its useless
239  ***********************************************************/
240  library SafeMath {
241     /**
242     * @dev Multiplies two numbers, throws on overflow.
243     */
244     function mul(uint256 a, uint256 b) 
245         internal 
246         pure 
247         returns (uint256 c) 
248     {
249         if (a == 0) {
250             return 0;
251         }
252         c = a * b;
253         require(c / a == b, "SafeMath mul failed");
254         return c;
255     }
256 
257     /**
258     * @dev Integer division of two numbers, truncating the quotient.
259     */
260     function div(uint256 a, uint256 b) internal pure returns (uint256) {
261         // assert(b > 0); // Solidity automatically throws when dividing by 0
262         uint256 c = a / b;
263         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
264         return c;
265     }
266     
267     /**
268     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
269     */
270     function sub(uint256 a, uint256 b)
271         internal
272         pure
273         returns (uint256) 
274     {
275         require(b <= a, "SafeMath sub failed");
276         return a - b;
277     }
278 
279     /**
280     * @dev Adds two numbers, throws on overflow.
281     */
282     function add(uint256 a, uint256 b)
283         internal
284         pure
285         returns (uint256 c) 
286     {
287         c = a + b;
288         require(c >= a, "SafeMath add failed");
289         return c;
290     }
291     
292     /**
293      * @dev gives square root of given x.
294      */
295     function sqrt(uint256 x)
296         internal
297         pure
298         returns (uint256 y) 
299     {
300         uint256 z = ((add(x,1)) / 2);
301         y = x;
302         while (z < y) 
303         {
304             y = z;
305             z = ((add((x / z),z)) / 2);
306         }
307     }
308     
309     /**
310      * @dev gives square. multiplies x by x
311      */
312     function sq(uint256 x)
313         internal
314         pure
315         returns (uint256)
316     {
317         return (mul(x,x));
318     }
319     
320     /**
321      * @dev x to the power of y 
322      */
323     function pwr(uint256 x, uint256 y)
324         internal 
325         pure 
326         returns (uint256)
327     {
328         if (x==0)
329             return (0);
330         else if (y==0)
331             return (1);
332         else 
333         {
334             uint256 z = x;
335             for (uint256 i=1; i < y; i++)
336                 z = mul(z,x);
337             return (z);
338         }
339     }
340 }
341 
342 /***********************************************************
343  * ESDatasets library
344  ***********************************************************/
345 library ESDatasets {
346     
347     struct Round {
348         uint256 nowUserId;
349         uint256 ethSum;
350         uint256 startTime;
351     }
352     
353     struct Player {
354         address addr;   // player address
355         uint256 planCount;
356         mapping(uint256=>PalyerPlan) plans;
357     }
358     
359     struct PalyerPlan {
360         uint256 planId;
361         uint256 startTime;
362         uint256 startBlock;
363         uint256 invested;    //
364         uint256 atBlock;    // 
365         uint256 payEth;
366         bool isClose;
367     }
368 
369     struct Plan {
370         uint256 interest;    // interest per day %%
371         uint256 dayRange;    // days, 0 means No time limit
372     }    
373 }