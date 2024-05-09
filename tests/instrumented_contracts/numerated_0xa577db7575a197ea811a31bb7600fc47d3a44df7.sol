1 pragma solidity ^0.4.24;
2 
3 contract SuperBank {
4     using SafeMath for *;
5 
6     struct Investment {
7         uint256 amount;
8         uint256 safeAmount;
9         uint256 atBlock;
10         uint256 withdraw;
11         uint256 canWithdraw;
12         uint256 maxWithdraw;
13     }
14 
15     uint256 public startBlockNo;
16     uint256 public startTotal;
17 
18     uint256 public total;
19     uint256 public people;
20     uint256 public floatFund;
21     uint256 public safeFund;
22 
23     uint256 public bonus;
24     uint256 public bonusEndTime;
25     address public leader;
26     uint256 public lastPrice;
27 
28     mapping (address => Investment) public invested_m;
29 
30     address public owner; 
31 
32     constructor()
33         public
34     {
35         owner = msg.sender;
36         startBlockNo = block.number + (5900 * 14);
37         // 1000 ether
38         startTotal = 1000000000000000000000;
39     }
40 
41     modifier onlyOwner() 
42     {
43         require(owner == msg.sender, "only owner can do it");
44         _;    
45     }
46 
47     /**
48      * @dev invest
49      * 
50      * radical investment
51      */
52     function()
53         public
54         payable
55     {
56         if (msg.value == 0)
57         {
58             withdraw();
59         } else {
60             invest(2, address(0));
61         }
62     }
63 
64     /**
65      * @dev invest
66      */
67     function invest(uint8 _type, address _ref)
68         public
69         payable
70     {
71         uint256 _eth = msg.value;
72         uint256 _now = now;
73         uint256 _safe_p;
74         uint256 _other_p;
75         uint256 _return_p;
76         uint256 _safeAmount;
77         uint256 _otherAmount;
78         uint256 _returnAmount;
79         uint256 _teamAmount;
80         uint256 _promoteAmount;
81 
82         require(msg.value >= 1000000000, "not enough ether");
83 
84         withdraw();
85 
86         if (invested_m[msg.sender].amount == 0)
87         {
88             people = people.add(1);
89         }
90 
91         if (_type == 1)
92         {
93             _safe_p = 80;
94             _other_p = 5;
95             _return_p = 130;
96         } else {
97             _safe_p = 40;
98             _other_p = 25;
99             _return_p = 170;
100         }
101 
102         _safeAmount = (_eth.mul(_safe_p) / 100);
103         _returnAmount = (_eth.mul(_return_p) / 100);
104 
105         invested_m[msg.sender].amount = _eth.add(invested_m[msg.sender].amount);
106         invested_m[msg.sender].safeAmount = _safeAmount.add(invested_m[msg.sender].safeAmount);
107         invested_m[msg.sender].maxWithdraw = _returnAmount.add(invested_m[msg.sender].maxWithdraw);
108 
109         total = total.add(_eth);
110         safeFund = safeFund.add(_safeAmount);
111         
112         //start ?
113         if (block.number < startBlockNo && startTotal <= total) 
114         {
115             startBlockNo = block.number;
116         }
117 
118         if (_ref != address(0) && _ref != msg.sender)
119         {
120             uint256 _refTotal = invested_m[_ref].amount;
121             if (_refTotal < 5000000000000000000)
122             {
123                 _promoteAmount = (_eth.mul(3) / 100);
124                 _teamAmount = (_eth.mul(7) / 100);
125             } else if (_refTotal < 20000000000000000000) {
126                 _promoteAmount = (_eth.mul(5) / 100);
127                 _teamAmount = (_eth.mul(5) / 100);
128             } else {
129                 _promoteAmount = (_eth.mul(7) / 100);
130                 _teamAmount = (_eth.mul(3) / 100);
131             }
132 
133             _ref.transfer(_promoteAmount);
134         } else {
135             _teamAmount = (_eth.mul(10) / 100);
136         }
137 
138         owner.transfer(_teamAmount);
139 
140         _otherAmount = (_eth.mul(_other_p) / 100);
141 
142         floatFund = floatFund.add(_otherAmount);
143 
144         // bonus
145         if (bonusEndTime != 0 && bonusEndTime < _now)
146         {   
147             uint256 bonus_t = bonus;
148             address leader_t = leader;
149             bonus = 0;
150             leader = address(0);
151             lastPrice = 0;
152             bonusEndTime = 0;
153             leader_t.transfer(bonus_t);
154         }
155         bonus = bonus.add(_otherAmount);
156     }
157 
158     /**
159      * @dev withdraws
160      */
161     function withdraw()
162         public
163     {
164         uint256 _blockNo = block.number;
165         uint256 _leaveWithdraw = invested_m[msg.sender].maxWithdraw.sub(invested_m[msg.sender].canWithdraw);
166         uint256 _blockSub;
167 
168         if (_blockNo < startBlockNo)
169         {
170             _blockSub = 0;
171         } else {
172             if (invested_m[msg.sender].atBlock < startBlockNo)
173             {
174                 _blockSub = _blockNo.sub(startBlockNo);
175             } else {
176                 _blockSub = _blockNo.sub(invested_m[msg.sender].atBlock);
177             }
178         }
179 
180         uint256 _canAmount = ((invested_m[msg.sender].amount.mul(5) / 100).mul(_blockSub) / 5900);
181 
182         if (_canAmount > _leaveWithdraw)
183         {
184             _canAmount = _leaveWithdraw;
185         }
186         invested_m[msg.sender].canWithdraw = _canAmount.add(invested_m[msg.sender].canWithdraw);
187 
188         uint256 _realAmount = invested_m[msg.sender].canWithdraw.sub(invested_m[msg.sender].withdraw);
189         
190         if (_realAmount > 0)
191         {
192             if (invested_m[msg.sender].safeAmount >= _realAmount)
193             {
194                 safeFund = safeFund.sub(_realAmount);
195                 invested_m[msg.sender].safeAmount = invested_m[msg.sender].safeAmount.sub(_realAmount);
196             } else {
197                 uint256 _extraAmount = _realAmount.sub(invested_m[msg.sender].safeAmount);
198                 if (floatFund >= _extraAmount)
199                 {
200                     floatFund = floatFund.sub(_extraAmount);
201                 } else {
202                     _realAmount = floatFund.add(invested_m[msg.sender].safeAmount);
203                     floatFund = 0;
204                 }
205                 safeFund = safeFund.sub(invested_m[msg.sender].safeAmount);
206                 invested_m[msg.sender].safeAmount = 0;
207             }
208         }
209 
210         invested_m[msg.sender].withdraw = _realAmount.add(invested_m[msg.sender].withdraw);
211         invested_m[msg.sender].atBlock = _blockNo;
212 
213         if (_realAmount > 0)
214         {
215             msg.sender.transfer(_realAmount);
216         }
217     }
218 
219     /**
220      * @dev bid
221      */
222     function bid(address _ref)
223         public
224         payable
225     {
226         uint256 _eth = msg.value;
227         uint256 _ethUse = msg.value;
228         uint256 _now = now;
229         uint256 _promoteAmount;
230         uint256 _teamAmount;
231         uint256 _otherAmount;
232 
233         require(block.number >= startBlockNo, "Need start");
234 
235         // bonus
236         if (bonusEndTime != 0 && bonusEndTime < _now)
237         {   
238             uint256 bonus_t = bonus;
239             address leader_t = leader;
240             bonus = 0;
241             leader = address(0);
242             lastPrice = 0;
243             bonusEndTime = 0;
244             leader_t.transfer(bonus_t);
245         }
246 
247         uint256 _maxPrice = (1000000000000000000).add(lastPrice);
248         // less than (lastPrice + 0.1Ether) ?
249         require(_eth >= (100000000000000000).add(lastPrice), "Need more Ether");
250         // more than (lastPrice + 1Ether) ?
251         if (_eth > _maxPrice)
252         {
253             _ethUse = _maxPrice;
254             // refund
255             msg.sender.transfer(_eth.sub(_ethUse));
256         }
257 
258         bonusEndTime = _now + 12 hours;
259         leader = msg.sender;
260         lastPrice = _ethUse;
261 
262         if (_ref != address(0) && _ref != msg.sender)
263         {
264             uint256 _refTotal = invested_m[_ref].amount;
265             if (_refTotal < 5000000000000000000)
266             {
267                 _promoteAmount = (_ethUse.mul(3) / 100);
268                 _teamAmount = (_ethUse.mul(7) / 100);
269             } else if (_refTotal < 20000000000000000000) {
270                 _promoteAmount = (_ethUse.mul(5) / 100);
271                 _teamAmount = (_ethUse.mul(5) / 100);
272             } else {
273                 _promoteAmount = (_ethUse.mul(7) / 100);
274                 _teamAmount = (_ethUse.mul(3) / 100);
275             }
276 
277             _ref.transfer(_promoteAmount);
278         } else {
279             _teamAmount = (_ethUse.mul(10) / 100);
280         }
281 
282         owner.transfer(_teamAmount);
283 
284         _otherAmount = (_ethUse.mul(45) / 100);
285 
286         floatFund = floatFund.add(_otherAmount);
287         bonus = bonus.add(_otherAmount);
288     }
289 
290     /**
291      * @dev change owner.
292      */
293     function changeOwner(address newOwner)
294         onlyOwner()
295         public
296     {
297         owner = newOwner;
298     }
299 
300     /**
301      * @dev getInfo
302      */
303     function getInfo()
304         public 
305         view 
306         returns(uint256, uint256, uint256, uint256, uint256, uint256, uint256, uint256, address, uint256)
307     {
308         return (
309             startBlockNo,
310             startTotal,
311             total,
312             people,
313             floatFund,
314             safeFund,
315             bonus,
316             bonusEndTime,
317             leader,
318             lastPrice
319         );
320     }
321 }
322 
323 library SafeMath {
324     
325     /**
326     * @dev Multiplies two numbers, throws on overflow.
327     */
328     function mul(uint256 a, uint256 b) 
329         internal 
330         pure 
331         returns (uint256 c) 
332     {
333         if (a == 0) {
334             return 0;
335         }
336         c = a * b;
337         require(c / a == b, "SafeMath mul failed");
338         return c;
339     }
340 
341     /**
342     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
343     */
344     function sub(uint256 a, uint256 b)
345         internal
346         pure
347         returns (uint256) 
348     {
349         require(b <= a, "SafeMath sub failed");
350         return a - b;
351     }
352 
353     /**
354     * @dev Adds two numbers, throws on overflow.
355     */
356     function add(uint256 a, uint256 b)
357         internal
358         pure
359         returns (uint256 c) 
360     {
361         c = a + b;
362         require(c >= a, "SafeMath add failed");
363         return c;
364     }
365     
366     /**
367      * @dev gives square root of given x.
368      */
369     function sqrt(uint256 x)
370         internal
371         pure
372         returns (uint256 y) 
373     {
374         uint256 z = ((add(x,1)) / 2);
375         y = x;
376         while (z < y) 
377         {
378             y = z;
379             z = ((add((x / z),z)) / 2);
380         }
381     }
382     
383     /**
384      * @dev gives square. multiplies x by x
385      */
386     function sq(uint256 x)
387         internal
388         pure
389         returns (uint256)
390     {
391         return (mul(x,x));
392     }
393     
394     /**
395      * @dev x to the power of y 
396      */
397     function pwr(uint256 x, uint256 y)
398         internal 
399         pure 
400         returns (uint256)
401     {
402         if (x==0)
403             return (0);
404         else if (y==0)
405             return (1);
406         else 
407         {
408             uint256 z = x;
409             for (uint256 i=1; i < y; i++)
410                 z = mul(z,x);
411             return (z);
412         }
413     }
414 }