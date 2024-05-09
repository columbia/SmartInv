1 pragma solidity ^0.4.20;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract Ownable {
33     address public owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37     function Ownable() public {
38         owner = msg.sender;
39     }
40 
41     modifier onlyOwner() {
42         require(msg.sender == owner);
43         _;
44     }
45 
46     function transferOwnership(address newOwner) public onlyOwner {
47         require(newOwner != address(0));
48         emit OwnershipTransferred(owner, newOwner);
49         owner = newOwner;
50     }
51 
52 }
53 
54 contract BGXTokenInterface{
55 
56     function distribute( address _to, uint256 _amount ) public returns( bool );
57     function finally( address _teamAddress ) public returns( bool );
58 
59 }
60 
61 contract BGXCrowdsale is Ownable{
62 
63     using SafeMath for uint256;
64 
65     BGXTokenInterface bgxTokenInterface;
66 
67     address   public bgxWallet;
68     address[] public adviser;
69     address[] public bounty;
70     address[] public team;
71 
72     mapping( address => uint256 ) adviserAmount;
73     mapping( address => uint256 ) bountyAmount;
74     mapping( address => uint256 ) teamAmount;
75 
76     uint256 public presaleDateStart      = 1524571200;
77     uint256 public presaleDateFinish     = 1526385600;
78     uint256 public saleDateStart         = 1526990400;
79     uint256 public saleDateFinish        = 1528200000;
80 
81     uint256 constant public hardcap      = 500000000 ether;
82     uint256 public presaleHardcap        = 30000000  ether;
83     uint256 public softcap               = 40000000  ether;
84     uint256 public totalBGX              = 0;
85     uint256 constant public minimal      = 1000 ether;
86 
87     uint256 reserved                     = 250000000 ether;
88     uint256 constant teamLimit           = 100000000 ether;
89     uint256 constant advisersLimit       = 100000000 ether;
90     uint256 constant bountyLimit         = 50000000 ether;
91     uint256 public distributionDate      = 0;
92 
93     bool paused = false;
94 
95     enum CrowdsaleStates { Pause, Presale, Sale, OverHardcap, Finish }
96 
97     CrowdsaleStates public state = CrowdsaleStates.Pause;
98 
99     uint256 public sendNowLastCount = 0;
100     uint256 public finishLastCount = 0;
101     uint256 public finishCurrentLimit = 0;
102 
103     modifier activeState {
104         require(
105             getState() == CrowdsaleStates.Presale
106             || getState() == CrowdsaleStates.Sale
107         );
108         _;
109     }
110 
111     modifier onPause {
112         require(
113             getState() == CrowdsaleStates.Pause
114         );
115         _;
116     }
117 
118     modifier overSoftcap {
119         require(
120             totalBGX >= softcap
121         );
122         _;
123     }
124 
125     modifier finishOrHardcap {
126         require(
127             getState() == CrowdsaleStates.OverHardcap
128             || getState() == CrowdsaleStates.Finish
129         );
130         _;
131     }
132 
133     // fix for short address attack
134     modifier onlyPayloadSize(uint size) {
135         require(msg.data.length == size + 4);
136         _;
137     }
138 
139     address[]                     public investors;
140     mapping( address => uint256 ) public investorBalance;
141     mapping( address => bool )    public inBlackList;
142 
143 
144 
145     function setBgxWalletAddress( address _a ) public onlyOwner returns( bool )
146     {
147         require( address(0) != _a );
148         bgxWallet = _a;
149         return true;
150     }
151 
152     function setCrowdsaleDate( uint256 _presaleStart, uint256 _presaleFinish, uint256 _saleStart, uint256 _saleFinish ) public onlyOwner onPause returns( bool )
153     {
154         presaleDateStart = _presaleStart;
155         presaleDateFinish = _presaleFinish;
156         saleDateStart = _saleStart;
157         saleDateFinish = _saleFinish;
158 
159         return true;
160     }
161 
162     function setCaps( uint256 _presaleHardcap, uint256 _softcap ) public onlyOwner onPause returns( bool )
163     {
164         presaleHardcap = _presaleHardcap;
165         softcap = _softcap;
166 
167         return true;
168     }
169 
170 
171     function getState() public returns( CrowdsaleStates )
172     {
173 
174         if( state == CrowdsaleStates.Pause || paused ) return CrowdsaleStates.Pause;
175         if( state == CrowdsaleStates.Finish ) return CrowdsaleStates.Finish;
176 
177         if( totalBGX >= hardcap ) return CrowdsaleStates.OverHardcap;
178 
179 
180         if( now >= presaleDateStart && now <= presaleDateFinish ){
181 
182             if( totalBGX >= presaleHardcap ) return CrowdsaleStates.Pause;
183             return CrowdsaleStates.Presale;
184 
185         }
186 
187         if( now >= saleDateStart && now <= saleDateFinish ){
188 
189             if( totalBGX >= hardcap ) {
190                 _startCounter();
191                 return CrowdsaleStates.OverHardcap;
192             }
193             return CrowdsaleStates.Sale;
194 
195         }
196 
197         if( now > saleDateFinish ) {
198             _startCounter();
199             return CrowdsaleStates.Finish;
200         }
201 
202         return CrowdsaleStates.Pause;
203 
204     }
205 
206     function _startCounter() internal
207     {
208         if (distributionDate <= 0) {
209             distributionDate = now + 2 days;
210         }
211     }
212 
213 
214     function pauseStateSwithcer() public onlyOwner returns( bool )
215     {
216         paused = !paused;
217     }
218 
219     function start() public onlyOwner returns( bool )
220     {
221         state = CrowdsaleStates.Presale;
222 
223         return true;
224     }
225 
226 
227     function send(address _addr, uint _amount) public onlyOwner activeState onlyPayloadSize(2 * 32) returns( bool )
228     {
229         require( address(0) != _addr && _amount >= minimal && !inBlackList[_addr] );
230 
231         if( getState() == CrowdsaleStates.Presale ) require( totalBGX.add( _amount ) <= presaleHardcap );
232         if( getState() == CrowdsaleStates.Sale )    require( totalBGX.add( _amount ) <= hardcap );
233 
234 
235         investors.push( _addr );
236 
237 
238         investorBalance[_addr] = investorBalance[_addr].add( _amount );
239         if ( !inBlackList[_addr]) {
240             totalBGX = totalBGX.add( _amount );
241         }
242         return true;
243 
244     }
245 
246     function investorsCount() public constant returns( uint256 )
247     {
248         return investors.length;
249     }
250 
251     function sendNow( uint256 _count ) public onlyOwner overSoftcap  returns( bool )
252     {
253         require( sendNowLastCount.add( _count ) <= investors.length );
254 
255         uint256 to = sendNowLastCount.add( _count );
256 
257         for( uint256 i = sendNowLastCount; i <= to - 1; i++ )
258             if( !inBlackList[investors[i]] ){
259                 investorBalance[investors[i]] = 0;
260                 bgxTokenInterface.distribute( investors[i], investorBalance[investors[i]] );
261             }
262 
263         sendNowLastCount = sendNowLastCount.add( _count );
264     }
265 
266 
267     function blackListSwithcer( address _addr ) public onlyOwner returns( bool )
268     {
269         require( address(0) != _addr );
270 
271         if( !inBlackList[_addr] ){
272             totalBGX = totalBGX.sub( investorBalance[_addr] );
273         } else {
274             totalBGX = totalBGX.add( investorBalance[_addr] );
275         }
276 
277         inBlackList[_addr] = !inBlackList[_addr];
278 
279     }
280 
281 
282     function finish( uint256 _count) public onlyOwner finishOrHardcap overSoftcap returns( bool )
283     {
284         require(_count > 0);
285         require(distributionDate > 0 && distributionDate <= now);
286         if (finishCurrentLimit == 0) {
287             finishCurrentLimit = bountyLimit.add(teamLimit.add(advisersLimit));
288         }
289         // advisers + bounters total cnt
290         uint256 totalCnt = adviser.length.add(bounty.length);
291 
292         if (finishLastCount < adviser.length) {
293             for( uint256 i = finishLastCount; i <= adviser.length - 1; i++  ){
294                 finishCurrentLimit = finishCurrentLimit.sub( adviserAmount[adviser[i]] );
295                 bgxTokenInterface.distribute( adviser[i],adviserAmount[adviser[i]] );
296                 finishLastCount++;
297                 _count--;
298                 if (_count <= 0) {
299                     return true;
300                 }
301             }
302         }
303         if (finishLastCount < totalCnt) {
304             for( i = finishLastCount.sub(adviser.length); i <= bounty.length - 1; i++  ){
305                 finishCurrentLimit = finishCurrentLimit.sub( bountyAmount[bounty[i]] );
306                 bgxTokenInterface.distribute( bounty[i],bountyAmount[bounty[i]] );
307                 finishLastCount ++;
308                 _count--;
309                 if (_count <= 0) {
310                     return true;
311                 }
312             }
313         }
314         if (finishLastCount >= totalCnt && finishLastCount < totalCnt.add(team.length)) {
315             for( i =  finishLastCount.sub(totalCnt); i <= team.length - 1; i++  ){
316 
317                 finishCurrentLimit = finishCurrentLimit.sub( teamAmount[team[i]] );
318                 bgxTokenInterface.distribute( team[i],teamAmount[team[i]] );
319                 finishLastCount ++;
320                 _count--;
321                 if (_count <= 0) {
322                     return true;
323                 }
324             }
325         }
326 
327         reserved = reserved.add( finishCurrentLimit );
328 
329         return true;
330 
331     }
332 
333 
334 
335     function sendToTeam() public onlyOwner finishOrHardcap overSoftcap returns( bool )
336     {
337         bgxTokenInterface.distribute( bgxWallet, reserved );
338         bgxTokenInterface.finally( bgxWallet );
339 
340         return true;
341     }
342 
343 
344 
345 
346     function setAdvisers( address[] _addrs, uint256[] _amounts ) public onlyOwner finishOrHardcap returns( bool )
347     {
348         require( _addrs.length == _amounts.length );
349 
350         adviser = _addrs;
351         uint256 limit = 0;
352 
353         for( uint256 i = 0; i <= adviser.length - 1; i++  ){
354             require( limit.add( _amounts[i] ) <= advisersLimit );
355             adviserAmount[adviser[i]] = _amounts[i];
356             limit.add( _amounts[i] );
357         }
358     }
359 
360     function setBounty( address[] _addrs, uint256[] _amounts ) public onlyOwner finishOrHardcap returns( bool )
361     {
362         require( _addrs.length == _amounts.length );
363 
364         bounty = _addrs;
365         uint256 limit = 0;
366 
367         for( uint256 i = 0; i <= bounty.length - 1; i++  ){
368             require( limit.add( _amounts[i] ) <= bountyLimit );
369             bountyAmount[bounty[i]] = _amounts[i];
370             limit.add( _amounts[i] );
371         }
372     }
373 
374     function setTeams( address[] _addrs, uint256[] _amounts ) public onlyOwner finishOrHardcap returns( bool )
375     {
376         require( _addrs.length == _amounts.length );
377 
378         team = _addrs;
379         uint256 limit = 0;
380 
381         for( uint256 i = 0; i <= team.length - 1; i++  ){
382             require( limit.add( _amounts[i] ) <= teamLimit );
383             teamAmount[team[i]] = _amounts[i];
384             limit.add( _amounts[i] );
385         }
386     }
387 
388 
389     function setBGXTokenInterface( address _BGXTokenAddress ) public onlyOwner returns( bool )
390     {
391         require( _BGXTokenAddress != address(0) );
392         bgxTokenInterface = BGXTokenInterface( _BGXTokenAddress );
393     }
394 
395 
396     function time() public constant returns(uint256 )
397     {
398         return now;
399     }
400 
401 
402 
403 
404 }