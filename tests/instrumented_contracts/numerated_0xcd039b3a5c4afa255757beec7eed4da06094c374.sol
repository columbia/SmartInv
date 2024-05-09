1 pragma solidity ^0.4.24;
2 
3 /***********************************************************
4  * Easy Investment UP Contract
5  *  - GAIN 4.5% PER 24 HOURS (every 5900 blocks) 60 days  
6  *  - GAIN 5% PER 24 HOURS (every 5900 blocks) 40 days  
7  *  - GAIN 5.3% PER 24 HOURS (every 5900 blocks) 30 days  
8  *  - GAIN 6.5% PER 24 HOURS (every 5900 blocks) 20 days     
9  *  - GAIN 9.3% PER 24 HOURS (every 5900 blocks) 12 days    
10  *  
11   * How to use:
12  *  1. Send any amount of ether to make an investment (The Data input 1~5 investment category, the default is 1.)
13  *  2. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
14  *
15  * RECOMMENDED GAS LIMIT: 500000
16  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
17  * 
18  * 
19  *  https://www.easyinvestup.com
20  *  https://t.me/easyinvestup
21  ***********************************************************/
22 
23 contract EasyInvestUP {
24     using SafeMath              for *;
25 
26     address public promoAddr_ = address(0xfCFbaFfD975B107B2Bcd58BF71DC78fBeBB6215D);
27 
28     uint256 ruleSum_ = 5;
29 
30     uint256 public G_NowUserId = 1000; //first user
31     uint256 public G_AllEth = 0;
32     uint256 G_DayBlocks = 5900;
33     
34     mapping (address => uint256) public pIDxAddr_;  
35     mapping (uint256 => EUDatasets.Player) public player_; 
36     mapping (uint256 => EUDatasets.Plan) private plan_;   
37 	
38 	function GetIdByAddr(address addr) public 
39 	    view returns(uint256)
40 	{
41 	    return pIDxAddr_[addr];
42 	}
43 	
44 
45 	function GetPlayerByUid(uint256 uid) public 
46 	    view returns(uint256)
47 	{
48 	    EUDatasets.Player storage player = player_[uid];
49 
50 	    return
51 	    (
52 	        player.planCount
53 	    );
54 	}
55 	
56     function GetPlanByUid(uint256 uid) public 
57 	    view returns(uint256[],uint256[],uint256[],uint256[],uint256[],bool[])
58 	{
59 	    uint256[] memory planIds = new  uint256[] (player_[uid].planCount);
60 	    uint256[] memory startBlocks = new  uint256[] (player_[uid].planCount);
61 	    uint256[] memory investeds = new  uint256[] (player_[uid].planCount);
62 	    uint256[] memory atBlocks = new  uint256[] (player_[uid].planCount);
63 	    uint256[] memory payEths = new  uint256[] (player_[uid].planCount);
64 	    bool[] memory isCloses = new  bool[] (player_[uid].planCount);
65 	    
66         for(uint i = 0; i < player_[uid].planCount; i++) {
67 	        planIds[i] = player_[uid].plans[i].planId;
68 	        startBlocks[i] = player_[uid].plans[i].startBlock;
69 	        investeds[i] = player_[uid].plans[i].invested;
70 	        atBlocks[i] = player_[uid].plans[i].atBlock;
71 	        payEths[i] = player_[uid].plans[i].payEth;
72 	        isCloses[i] = player_[uid].plans[i].isClose;
73 	    }
74 	    
75 	    return
76 	    (
77 	        planIds,
78 	        startBlocks,
79 	        investeds,
80 	        atBlocks,
81 	        payEths,
82 	        isCloses
83 	    );
84 	}
85 	
86 function GetPlanTimeByUid(uint256 uid) public 
87 	    view returns(uint256[])
88 	{
89 	    uint256[] memory startTimes = new  uint256[] (player_[uid].planCount);
90 
91         for(uint i = 0; i < player_[uid].planCount; i++) {
92 	        startTimes[i] = player_[uid].plans[i].startTime;
93 	    }
94 	    
95 	    return
96 	    (
97 	        startTimes
98 	    );
99 	}	
100 
101     constructor() public {
102         plan_[1] = EUDatasets.Plan(450,60);
103         plan_[2] = EUDatasets.Plan(500,40);
104         plan_[3] = EUDatasets.Plan(530,30);
105         plan_[4] = EUDatasets.Plan(650,20);
106         plan_[5] = EUDatasets.Plan(930,12);
107 
108     }
109 	
110 	function register_(address addr) private{
111         G_NowUserId = G_NowUserId.add(1);
112         
113         address _addr = addr;
114         
115         pIDxAddr_[_addr] = G_NowUserId;
116 
117         player_[G_NowUserId].addr = _addr;
118         player_[G_NowUserId].planCount = 0;
119         
120 	}
121 	
122     
123     // this function called every time anyone sends a transaction to this contract
124     function () external payable {
125         if (msg.value == 0) {
126             withdraw();
127         } else {
128             invest();
129         }
130     } 	
131     
132     function invest() private {
133 	    uint256 _planId = bytesToUint(msg.data);
134 	    
135 	    if (_planId<1 || _planId > ruleSum_) {
136 	        _planId = 1;
137 	    }
138         
139 		//get uid
140 		uint256 uid = pIDxAddr_[msg.sender];
141 		
142 		//first
143 		if (uid == 0) {
144 		    register_(msg.sender);
145 			uid = G_NowUserId;
146 		}
147 		
148         // record block number and invested amount (msg.value) of this transaction
149         uint256 planCount = player_[uid].planCount;
150         player_[uid].plans[planCount].planId = _planId;
151         player_[uid].plans[planCount].startTime = now;
152         player_[uid].plans[planCount].startBlock = block.number;
153         player_[uid].plans[planCount].atBlock = block.number;
154         player_[uid].plans[planCount].invested = msg.value;
155         player_[uid].plans[planCount].payEth = 0;
156         player_[uid].plans[planCount].isClose = false;
157         
158         player_[uid].planCount = player_[uid].planCount.add(1);
159 
160         G_AllEth = G_AllEth.add(msg.value);
161         
162         if (msg.value > 1000000000) {
163 
164             uint256 promoFee = (msg.value.mul(5)).div(100);
165             promoAddr_.transfer(promoFee);
166             
167         } 
168         
169     }
170    
171 	
172 	function withdraw() private {
173 	    require(msg.value == 0, "withdraw fee is 0 ether, please set the exact amount");
174 	    
175 	    uint256 uid = pIDxAddr_[msg.sender];
176 	    require(uid != 0, "no invest");
177 
178         for(uint i = 0; i < player_[uid].planCount; i++) {
179 	        if (player_[uid].plans[i].isClose) {
180 	            continue;
181 	        }
182 
183             EUDatasets.Plan plan = plan_[player_[uid].plans[i].planId];
184             
185             uint256 blockNumber = block.number;
186             bool bClose = false;
187             if (plan.dayRange > 0) {
188                 
189                 uint256 endBlockNumber = player_[uid].plans[i].startBlock.add(plan.dayRange*G_DayBlocks);
190                 if (blockNumber > endBlockNumber){
191                     blockNumber = endBlockNumber;
192                     bClose = true;
193                 }
194             }
195             
196             uint256 amount = player_[uid].plans[i].invested * plan.interest / 10000 * (blockNumber - player_[uid].plans[i].atBlock) / G_DayBlocks;
197 
198             // send calculated amount of ether directly to sender (aka YOU)
199             address sender = msg.sender;
200             sender.transfer(amount);
201 
202             // record block number and invested amount (msg.value) of this transaction
203             player_[uid].plans[i].atBlock = block.number;
204             player_[uid].plans[i].isClose = bClose;
205             player_[uid].plans[i].payEth += amount;
206         }
207 	}
208 	
209     function bytesToUint(bytes b) private returns (uint256){
210         uint256 number;
211         for(uint i=0;i<b.length;i++){
212             number = number + uint(b[i])*(2**(8*(b.length-(i+1))));
213         }
214         return number;
215     }	
216 }
217 
218 /***********************************************************
219  * @title SafeMath v0.1.9
220  * @dev Math operations with safety checks that throw on error
221  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
222  * - added sqrt
223  * - added sq
224  * - added pwr 
225  * - changed asserts to requires with error log outputs
226  * - removed div, its useless
227  ***********************************************************/
228  library SafeMath {
229     /**
230     * @dev Multiplies two numbers, throws on overflow.
231     */
232     function mul(uint256 a, uint256 b) 
233         internal 
234         pure 
235         returns (uint256 c) 
236     {
237         if (a == 0) {
238             return 0;
239         }
240         c = a * b;
241         require(c / a == b, "SafeMath mul failed");
242         return c;
243     }
244 
245     /**
246     * @dev Integer division of two numbers, truncating the quotient.
247     */
248     function div(uint256 a, uint256 b) internal pure returns (uint256) {
249         // assert(b > 0); // Solidity automatically throws when dividing by 0
250         uint256 c = a / b;
251         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
252         return c;
253     }
254     
255     /**
256     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
257     */
258     function sub(uint256 a, uint256 b)
259         internal
260         pure
261         returns (uint256) 
262     {
263         require(b <= a, "SafeMath sub failed");
264         return a - b;
265     }
266 
267     /**
268     * @dev Adds two numbers, throws on overflow.
269     */
270     function add(uint256 a, uint256 b)
271         internal
272         pure
273         returns (uint256 c) 
274     {
275         c = a + b;
276         require(c >= a, "SafeMath add failed");
277         return c;
278     }
279     
280     /**
281      * @dev gives square root of given x.
282      */
283     function sqrt(uint256 x)
284         internal
285         pure
286         returns (uint256 y) 
287     {
288         uint256 z = ((add(x,1)) / 2);
289         y = x;
290         while (z < y) 
291         {
292             y = z;
293             z = ((add((x / z),z)) / 2);
294         }
295     }
296     
297     /**
298      * @dev gives square. multiplies x by x
299      */
300     function sq(uint256 x)
301         internal
302         pure
303         returns (uint256)
304     {
305         return (mul(x,x));
306     }
307     
308     /**
309      * @dev x to the power of y 
310      */
311     function pwr(uint256 x, uint256 y)
312         internal 
313         pure 
314         returns (uint256)
315     {
316         if (x==0)
317             return (0);
318         else if (y==0)
319             return (1);
320         else 
321         {
322             uint256 z = x;
323             for (uint256 i=1; i < y; i++)
324                 z = mul(z,x);
325             return (z);
326         }
327     }
328 }
329 
330 /***********************************************************
331  * EUDatasets library
332  ***********************************************************/
333 library EUDatasets {
334     struct Player {
335         address addr;   // player address
336         uint256 planCount;
337         mapping(uint256=>PalyerPlan) plans;
338     }
339     
340     struct PalyerPlan {
341         uint256 planId;
342         uint256 startTime;
343         uint256 startBlock;
344         uint256 invested;    //
345         uint256 atBlock;    // 
346         uint256 payEth;
347         bool isClose;
348     }
349 
350     struct Plan {
351         uint256 interest;    // interest per day %%
352         uint256 dayRange;    // days, 0 means No time limit
353     }    
354 }