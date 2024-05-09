1 pragma solidity ^0.4.24;
2 
3 // File: contracts/interface/DiviesInterface.sol
4 
5 interface DiviesInterface {
6     function deposit() external payable;
7 }
8 
9 // File: contracts/library/SafeMath.sol
10 
11 /**
12  * @title SafeMath v0.1.9
13  * @dev Math operations with safety checks that throw on error
14  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
15  * - added sqrt
16  * - added sq
17  * - added pwr 
18  * - changed asserts to requires with error log outputs
19  * - removed div, its useless
20  */
21 library SafeMath {
22     
23     /**
24     * @dev Multiplies two numbers, throws on overflow.
25     */
26     function mul(uint256 a, uint256 b) 
27         internal 
28         pure 
29         returns (uint256 c) 
30     {
31         if (a == 0) {
32             return 0;
33         }
34         c = a * b;
35         require(c / a == b, "SafeMath mul failed");
36         return c;
37     }
38 
39     /**
40     * @dev Integer division of two numbers, truncating the quotient.
41     */
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         // assert(b > 0); // Solidity automatically throws when dividing by 0
44         uint256 c = a / b;
45         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46         return c;
47     }
48     
49     /**
50     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51     */
52     function sub(uint256 a, uint256 b)
53         internal
54         pure
55         returns (uint256) 
56     {
57         require(b <= a, "SafeMath sub failed");
58         return a - b;
59     }
60 
61     /**
62     * @dev Adds two numbers, throws on overflow.
63     */
64     function add(uint256 a, uint256 b)
65         internal
66         pure
67         returns (uint256 c) 
68     {
69         c = a + b;
70         require(c >= a, "SafeMath add failed");
71         return c;
72     }
73     
74     /**
75      * @dev gives square root of given x.
76      */
77     function sqrt(uint256 x)
78         internal
79         pure
80         returns (uint256 y) 
81     {
82         uint256 z = ((add(x,1)) / 2);
83         y = x;
84         while (z < y) 
85         {
86             y = z;
87             z = ((add((x / z),z)) / 2);
88         }
89     }
90     
91     /**
92      * @dev gives square. multiplies x by x
93      */
94     function sq(uint256 x)
95         internal
96         pure
97         returns (uint256)
98     {
99         return (mul(x,x));
100     }
101     
102     /**
103      * @dev x to the power of y 
104      */
105     function pwr(uint256 x, uint256 y)
106         internal 
107         pure 
108         returns (uint256)
109     {
110         if (x==0)
111             return (0);
112         else if (y==0)
113             return (1);
114         else 
115         {
116             uint256 z = x;
117             for (uint256 i=1; i < y; i++)
118                 z = mul(z,x);
119             return (z);
120         }
121     }
122 }
123 
124 // File: contracts/library/UintCompressor.sol
125 
126 library UintCompressor {
127     using SafeMath for *;
128     
129     function insert(uint256 _var, uint256 _include, uint256 _start, uint256 _end)
130         internal
131         pure
132         returns(uint256)
133     {
134         // check conditions 
135         require(_end < 77 && _start < 77, "start/end must be less than 77");
136         require(_end >= _start, "end must be >= start");
137         
138         // format our start/end points
139         _end = exponent(_end).mul(10);
140         _start = exponent(_start);
141         
142         // check that the include data fits into its segment 
143         require(_include < (_end / _start));
144         
145         // build middle
146         if (_include > 0)
147             _include = _include.mul(_start);
148         
149         return((_var.sub((_var / _start).mul(_start))).add(_include).add((_var / _end).mul(_end)));
150     }
151     
152     function extract(uint256 _input, uint256 _start, uint256 _end)
153 	    internal
154 	    pure
155 	    returns(uint256)
156     {
157         // check conditions
158         require(_end < 77 && _start < 77, "start/end must be less than 77");
159         require(_end >= _start, "end must be >= start");
160         
161         // format our start/end points
162         _end = exponent(_end).mul(10);
163         _start = exponent(_start);
164         
165         // return requested section
166         return((((_input / _start).mul(_start)).sub((_input / _end).mul(_end))) / _start);
167     }
168     
169     function exponent(uint256 _position)
170         private
171         pure
172         returns(uint256)
173     {
174         return((10).pwr(_position));
175     }
176 }
177 
178 // File: contracts/interface/HourglassInterface.sol
179 
180 interface HourglassInterface {
181     function() payable external;
182     function buy(address _playerAddress) payable external returns(uint256);
183     function sell(uint256 _amountOfTokens) external;
184     function reinvest() external;
185     function withdraw() external;
186     function exit() external;
187     function dividendsOf(address _playerAddress) external view returns(uint256);
188     function balanceOf(address _playerAddress) external view returns(uint256);
189     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
190     function stakingRequirement() external view returns(uint256);
191 }
192 
193 // File: contracts/DiviesLong.sol
194 
195 /**
196  *         ┌──────────────────────────────────────────────────────────────────────┐
197  *         │ Divies!, is a contract that adds an external dividend system to P3D. │
198  *         │ All eth sent to this contract, can be distributed to P3D holders.    │
199  *         │ Uses msg.sender as masternode for initial buy order.                 │
200  *         └──────────────────────────────────────────────────────────────────────┘
201  *                                ┌────────────────────┐
202  *                                │ Setup Instructions │
203  *                                └────────────────────┘
204  * (Step 1) import this contracts interface into your contract
205  * 
206  *    import "./DiviesInterface.sol";
207  * 
208  * (Step 2) set up the interface and point it to this contract
209  * 
210  *    DiviesInterface private Divies = DiviesInterface(0xc7029Ed9EBa97A096e72607f4340c34049C7AF48);
211  *                                ┌────────────────────┐
212  *                                │ Usage Instructions │
213  *                                └────────────────────┘
214  * call as follows anywhere in your code:
215  *   
216  *    Divies.deposit.value(amount)();
217  *          ex:  Divies.deposit.value(232000000000000000000)();
218  */
219 
220 
221 
222 
223 
224 contract DiviesLong {
225     using SafeMath for uint256;
226     using UintCompressor for uint256;
227 
228     //TODO:
229     HourglassInterface constant P3Dcontract_ = HourglassInterface(0x97550CE17666bB49349EF0E50f9fDb88353EDb64);
230     
231     uint256 public pusherTracker_ = 100;
232     mapping (address => Pusher) public pushers_;
233     struct Pusher
234     {
235         uint256 tracker;
236         uint256 time;
237     }
238     uint256 public rateLimiter_;
239     
240     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
241     // MODIFIERS
242     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
243     modifier isHuman() {
244         address _addr = msg.sender;
245         require (_addr == tx.origin);
246         uint256 _codeLength;
247         
248         assembly {_codeLength := extcodesize(_addr)}
249         require(_codeLength == 0, "sorry humans only");
250         _;
251     }
252     
253     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
254     // BALANCE
255     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
256     function balances()
257         public
258         view
259         returns(uint256)
260     {
261         return (address(this).balance);
262     }
263     
264     
265     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
266     // DEPOSIT
267     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
268     function deposit()
269         external
270         payable
271     {
272         
273     }
274     
275     // used so the distribute function can call hourglass's withdraw
276     function() external payable {
277         // don't send it
278         revert();
279     }
280     
281     
282     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
283     // EVENTS
284     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
285     event onDistribute(
286         address pusher,
287         uint256 startingBalance,
288         uint256 masternodePayout,
289         uint256 finalBalance,
290         uint256 compressedData
291     );
292     /* compression key
293     [0-14] - timestamp
294     [15-29] - caller pusher tracker 
295     [30-44] - global pusher tracker 
296     [45-46] - percent
297     [47] - greedy
298     */  
299     
300     
301     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
302     // DISTRIBUTE
303     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
304     function distribute(uint256 _percent)
305         public
306         isHuman()
307     {
308         // make sure _percent is within boundaries
309         require(_percent > 0 && _percent < 100, "please pick a percent between 1 and 99");
310         
311         // data setup
312         address _pusher = msg.sender;
313         uint256 _bal = address(this).balance;
314         uint256 _mnPayout;
315         uint256 _compressedData;
316         
317         // limit pushers greed (use "if" instead of require for level 42 top kek)
318         if (
319             pushers_[_pusher].tracker <= pusherTracker_.sub(100) && // pusher is greedy: wait your turn
320             pushers_[_pusher].time.add(1 hours) < now               // pusher is greedy: its not even been 1 hour
321         )
322         {
323             // update pushers wait que 
324             pushers_[_pusher].tracker = pusherTracker_;
325             pusherTracker_++;
326             
327             // setup mn payout for event
328             if (P3Dcontract_.balanceOf(_pusher) >= P3Dcontract_.stakingRequirement())
329                 _mnPayout = (_bal / 10) / 3;
330             
331             // setup _stop.  this will be used to tell the loop to stop
332             uint256 _stop = (_bal.mul(100 - _percent)) / 100;
333             
334             // buy & sell    
335             P3Dcontract_.buy.value(_bal)(_pusher);
336             P3Dcontract_.sell(P3Dcontract_.balanceOf(address(this)));
337             
338             // setup tracker.  this will be used to tell the loop to stop
339             uint256 _tracker = P3Dcontract_.dividendsOf(address(this));
340     
341             // reinvest/sell loop
342             while (_tracker >= _stop) 
343             {
344                 // lets burn some tokens to distribute dividends to p3d holders
345                 P3Dcontract_.reinvest();
346                 P3Dcontract_.sell(P3Dcontract_.balanceOf(address(this)));
347                 
348                 // update our tracker with estimates (yea. not perfect, but cheaper on gas)
349                 _tracker = (_tracker.mul(81)) / 100;
350             }
351             
352             // withdraw
353             P3Dcontract_.withdraw();
354         } else {
355             _compressedData = _compressedData.insert(1, 47, 47);
356         }
357         
358         // update pushers timestamp  (do outside of "if" for super saiyan level top kek)
359         pushers_[_pusher].time = now;
360     
361         // prep event compression data 
362         _compressedData = _compressedData.insert(now, 0, 14);
363         _compressedData = _compressedData.insert(pushers_[_pusher].tracker, 15, 29);
364         _compressedData = _compressedData.insert(pusherTracker_, 30, 44);
365         _compressedData = _compressedData.insert(_percent, 45, 46);
366             
367         // fire event
368         emit onDistribute(_pusher, _bal, _mnPayout, address(this).balance, _compressedData);
369     }
370 }