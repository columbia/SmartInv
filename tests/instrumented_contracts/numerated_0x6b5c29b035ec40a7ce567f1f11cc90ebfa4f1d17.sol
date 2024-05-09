1 // SPDX-License-Identifier: -- 🎲 --
2 
3 pragma solidity ^0.7.5;
4 
5 library SafeMath {
6 
7     function add(uint256 a, uint256 b) internal pure returns (uint256) {
8         uint256 c = a + b;
9         require(c >= a, 'SafeMath: addition overflow');
10         return c;
11     }
12 
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14         require(b <= a, 'SafeMath: subtraction overflow');
15         uint256 c = a - b;
16         return c;
17     }
18 
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         if (a == 0) {
21             return 0;
22         }
23 
24         uint256 c = a * b;
25         require(c / a == b, 'SafeMath: multiplication overflow');
26         return c;
27     }
28 
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b > 0, 'SafeMath: division by zero');
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33         return c;
34     }
35 
36     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b != 0, 'SafeMath: modulo by zero');
38         return a % b;
39     }
40 }
41 
42 contract dgKeeper {
43 
44     using SafeMath for uint256;
45 
46     address public gateKeeper;
47     address public gateOverseer;
48     address public distributionToken;
49 
50     uint256 public totalRequired;
51     uint256 immutable MIN_TIME_FRAME;
52 
53     struct KeeperInfo {
54         uint256 keeperRate;
55         uint256 keeperFrom;
56         uint256 keeperTill;
57         uint256 keeperBalance;
58         uint256 keeperPayouts;
59         bool isImmutable;
60     }
61 
62     mapping(address => KeeperInfo) public keeperList;
63 
64     modifier onlyGateKeeper() {
65         require(
66             msg.sender == gateKeeper,
67             'dgKeeper: keeper denied!'
68         );
69         _;
70     }
71 
72     modifier onlyGateOverseer() {
73         require(
74             msg.sender == gateOverseer,
75             'dgKeeper: overseer denied!'
76         );
77         _;
78     }
79 
80     event tokensScraped (
81         address indexed scraper,
82         uint256 scrapedAmount,
83         uint256 timestamp
84     );
85 
86     event recipientCreated (
87         address indexed recipient,
88         uint256 timeLock,
89         uint256 timeReward,
90         uint256 instantReward,
91         uint256 timestamp,
92         bool isImmutable
93     );
94 
95     event recipientDestroyed (
96         address indexed recipient,
97         uint256 timestamp
98     );
99 
100     constructor(
101         address _distributionToken,
102         address _gateOverseer,
103         address _gateKeeper,
104         uint256 _minTimeFrame
105     ) {
106         require(
107             _minTimeFrame > 0,
108             'dgKeeper: increase _timeFrame'
109         );
110         distributionToken = _distributionToken;
111         gateOverseer = _gateOverseer;
112         gateKeeper = _gateKeeper;
113         MIN_TIME_FRAME = _minTimeFrame;
114     }
115 
116     function allocateTokensBulk(
117         address[] memory _recipients,
118         uint256[] memory _tokensOpened,
119         uint256[] memory _tokensLocked,
120         uint256[] memory _timeFrame,
121         bool[] memory _immutable
122     )
123         external
124         onlyGateKeeper
125     {
126         for(uint i = 0; i < _recipients.length; i++) {
127             allocateTokens(
128                 _recipients[i],
129                 _tokensOpened[i],
130                 _tokensLocked[i],
131                 _timeFrame[i],
132                 _immutable[i]
133             );
134         }
135     }
136 
137     function allocateTokens(
138         address _recipient,
139         uint256 _tokensOpened,
140         uint256 _tokensLocked,
141         uint256 _timeFrame,
142         bool _isImmutable
143     )
144         public
145         onlyGateKeeper
146     {
147         require(
148             _timeFrame >= MIN_TIME_FRAME,
149             'dgKeeper: _timeFrame below minimum'
150         );
151 
152         require(
153             keeperList[_recipient].keeperFrom == 0,
154             'dgKeeper: _recipient is active'
155         );
156 
157         totalRequired =
158         totalRequired
159             .add(_tokensOpened)
160             .add(_tokensLocked);
161 
162         safeBalanceOf(
163             distributionToken,
164             address(this),
165             totalRequired
166         );
167 
168         keeperList[_recipient].keeperFrom = getNow();
169         keeperList[_recipient].keeperTill = getNow().add(_timeFrame);
170         keeperList[_recipient].keeperRate = _tokensLocked.div(_timeFrame);
171         keeperList[_recipient].keeperBalance = _tokensLocked.mod(_timeFrame);
172         keeperList[_recipient].isImmutable = _isImmutable;
173 
174         keeperList[_recipient].keeperBalance = 
175         keeperList[_recipient].keeperBalance.add(_tokensOpened);
176 
177         emit recipientCreated (
178             _recipient,
179             _timeFrame,
180             _tokensLocked,
181             _tokensOpened,
182             block.timestamp,
183             _isImmutable
184         );
185     }
186 
187     function scrapeMyTokens()
188         external
189     {
190         _scrapeTokens(msg.sender);
191     }
192 
193     function scrapeTokens(
194         address _recipient
195     ) 
196         external
197         onlyGateOverseer
198     {
199         _scrapeTokens(
200             _recipient
201         );
202     }
203 
204     function _scrapeTokens(
205         address _recipient
206     )
207         internal
208     {
209        uint256 scrapeAmount =
210         availableBalance(_recipient);
211 
212         keeperList[_recipient].keeperPayouts =
213         keeperList[_recipient].keeperPayouts.add(scrapeAmount);
214 
215         safeTransfer(
216             distributionToken,
217             _recipient,
218             scrapeAmount
219         );
220 
221         totalRequired =
222         totalRequired.sub(scrapeAmount);
223 
224         emit tokensScraped (
225             _recipient,
226             scrapeAmount,
227             block.timestamp
228         );
229     }
230 
231     function destroyRecipient(
232         address _recipient
233     )
234         external
235         onlyGateOverseer
236     {
237         require(
238             keeperList[_recipient].isImmutable == false,
239             'dgKeeper: _recipient is immutable'
240         );
241 
242         _scrapeTokens(_recipient);
243 
244         totalRequired =
245         totalRequired.sub(
246             lockedBalance(_recipient)
247         );
248 
249         delete keeperList[_recipient];
250         
251         emit recipientDestroyed (
252             _recipient,
253             block.timestamp
254         );
255     }
256 
257     function availableBalance(
258         address _recipient
259     )
260         public
261         view
262         returns (uint256)
263     {
264         uint256 timePassed =
265             getNow() < keeperList[_recipient].keeperTill
266                 ? getNow()
267                     .sub(keeperList[_recipient].keeperFrom)
268                 : keeperList[_recipient].keeperTill
269                     .sub(keeperList[_recipient].keeperFrom);
270 
271         return keeperList[_recipient].keeperRate
272             .mul(timePassed)
273             .add(keeperList[_recipient].keeperBalance)
274             .sub(keeperList[_recipient].keeperPayouts);
275     }
276 
277     function lockedBalance(address _recipient)
278         public
279         view
280         returns (uint256)
281     {
282         uint256 timeRemaining =
283             keeperList[_recipient].keeperTill > getNow() ?
284             keeperList[_recipient].keeperTill - getNow() : 0;
285 
286         return keeperList[_recipient].keeperRate
287             .mul(timeRemaining);
288     }
289 
290     function getNow()
291         public
292         view
293         returns (uint256)
294     {
295         return block.timestamp;
296     }
297 
298     function changeDistributionToken(
299         address _newDistributionToken
300     )
301         external
302         onlyGateKeeper
303     {
304         distributionToken = _newDistributionToken;
305     }
306 
307     function renounceKeeperOwnership()
308         external
309         onlyGateKeeper
310     {
311         gateKeeper = address(0x0);
312     }
313 
314     function renounceOverseerOwnership()
315         external
316         onlyGateOverseer
317     {
318         gateOverseer = address(0x0);
319     }
320 
321     bytes4 private constant TRANSFER = bytes4(
322         keccak256(
323             bytes(
324                 'transfer(address,uint256)'
325             )
326         )
327     );
328 
329     bytes4 private constant BALANCEOF = bytes4(
330         keccak256(
331             bytes(
332                 'balanceOf(address)'
333             )
334         )
335     );
336 
337     function safeTransfer(
338         address _token,
339         address _to,
340         uint256 _value
341     )
342         private
343     {
344         (bool success, bytes memory data) = _token.call(
345             abi.encodeWithSelector(
346                 TRANSFER,
347                 _to,
348                 _value
349             )
350         );
351 
352         require(
353             success && (
354                 data.length == 0 || abi.decode(
355                     data, (bool)
356                 )
357             ),
358             'dgKeeper: TRANSFER_FAILED'
359         );
360     }
361 
362     function safeBalanceOf(
363         address _token,
364         address _owner,
365         uint256 _required
366     )
367         private
368     {
369         (bool success, bytes memory data) = _token.call(
370             abi.encodeWithSelector(
371                 BALANCEOF,
372                 _owner
373             )
374         );
375 
376         require(
377             success && abi.decode(
378                 data, (uint256)
379             ) >= _required,
380             'dgKeeper: BALANCEOF_FAILED'
381         );
382     }
383 }