1 pragma solidity ^0.4.24;
2 /** title -Divies- v0.7.1
3  
4  *         ┌──────────────────────────────────────────────────────────────────────┐
5  *         │ Divies!, is a contract that adds an external dividend system to BTB. │
6  *         │ All eth sent to this contract, can be distributed to BTB holders.    │
7  *         │ Uses msg.sender as masternode for initial buy order.                 │
8  *         └──────────────────────────────────────────────────────────────────────┘
9  *                                ┌────────────────────┐
10  *                                │ Setup Instructions │
11  *                                └────────────────────┘
12  * (Step 1) import this contracts interface into your contract
13  * 
14  *    import "./DiviesInterface.sol";
15  * 
16  * (Step 2) set up the interface and point it to this contract
17  * 
18  *    DiviesInterface private Divies = DiviesInterface(0xEDEaB579e57a7D66297D0a67302647bB109db7A8);
19  *                                ┌────────────────────┐
20  *                                │ Usage Instructions │
21  *                                └────────────────────┘
22  * call as follows anywhere in your code:
23  *   
24  *    Divies.deposit.value(amount)();
25  *          ex:  Divies.deposit.value(232000000000000000000)();
26  */
27 
28 interface HourglassInterface {
29     function() payable external;
30     function buy(address _playerAddress) payable external returns(uint256);
31     function sell(uint256 _amountOfTokens) external;
32     function reinvest() external;
33     function withdraw() external;
34     function exit() external;
35     function dividendsOf(address _playerAddress) external view returns(uint256);
36     function balanceOf(address _playerAddress) external view returns(uint256);
37     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
38     function stakingRequirement() external view returns(uint256);
39 }
40 
41 contract Divies {
42     using SafeMath for uint256;
43     using UintCompressor for uint256;
44 
45     HourglassInterface constant BTBcontract_ = HourglassInterface(0xEDEaB579e57a7D66297D0a67302647bB109db7A8);
46     
47     uint256 public pusherTracker_ = 100;
48     mapping (address => Pusher) public pushers_;
49     struct Pusher
50     {
51         uint256 tracker;
52         uint256 time;
53     }
54     uint256 public rateLimiter_;
55     
56     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
57     // MODIFIERS
58     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
59     modifier isHuman() {
60         require(tx.origin == msg.sender);
61         _;
62     }
63     
64     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
65     // BALANCE
66     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
67     function balances()
68         public
69         view
70         returns(uint256)
71     {
72         return (address(this).balance);
73     }
74     
75     
76     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
77     // DEPOSIT
78     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
79     function deposit()
80         external
81         payable
82     {
83         
84     }
85     
86     // used so the distribute function can call hourglass's withdraw
87     function() external payable {}
88     
89     
90     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
91     // EVENTS
92     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
93     event onDistribute(
94         address pusher,
95         uint256 startingBalance,
96         uint256 masternodePayout,
97         uint256 finalBalance,
98         uint256 compressedData
99     );
100     /* compression key
101     [0-14] - timestamp
102     [15-29] - caller pusher tracker 
103     [30-44] - global pusher tracker 
104     [45-46] - percent
105     [47] - greedy
106     */  
107     
108     
109     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
110     // DISTRIBUTE
111     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
112     function distribute(uint256 _percent)
113         public
114         isHuman()
115     {
116         // make sure _percent is within boundaries
117         require(_percent > 0 && _percent < 100, "please pick a percent between 1 and 99");
118         
119         // data setup
120         address _pusher = msg.sender;
121         uint256 _bal = address(this).balance;
122         uint256 _mnPayout;
123         uint256 _compressedData;
124         
125         // limit pushers greed (use "if" instead of require for level 42 top kek)
126         if (
127             pushers_[_pusher].tracker <= pusherTracker_.sub(100) && // pusher is greedy: wait your turn
128             pushers_[_pusher].time.add(1 hours) < now               // pusher is greedy: its not even been 1 hour
129         )
130         {
131             // update pushers wait que 
132             pushers_[_pusher].tracker = pusherTracker_;
133             pusherTracker_++;
134             
135             // setup mn payout for event
136             if (BTBcontract_.balanceOf(_pusher) >= BTBcontract_.stakingRequirement())
137                 _mnPayout = (_bal / 10) / 3;
138             
139             // setup _stop.  this will be used to tell the loop to stop
140             uint256 _stop = (_bal.mul(100 - _percent)) / 100;
141             
142             // buy & sell    
143             BTBcontract_.buy.value(_bal)(_pusher);
144             BTBcontract_.sell(BTBcontract_.balanceOf(address(this)));
145             
146             // setup tracker.  this will be used to tell the loop to stop
147             uint256 _tracker = BTBcontract_.dividendsOf(address(this));
148     
149             // reinvest/sell loop
150             while (_tracker >= _stop) 
151             {
152                 // lets burn some tokens to distribute dividends to p3d holders
153                 BTBcontract_.reinvest();
154                 BTBcontract_.sell(BTBcontract_.balanceOf(address(this)));
155                 
156                 // update our tracker with estimates (yea. not perfect, but cheaper on gas)
157                 _tracker = (_tracker.mul(81)) / 100;
158             }
159             
160             // withdraw
161             BTBcontract_.withdraw();
162         } else {
163             _compressedData = _compressedData.insert(1, 47, 47);
164         }
165         
166         // update pushers timestamp  (do outside of "if" for super saiyan level top kek)
167         pushers_[_pusher].time = now;
168     
169         // prep event compression data 
170         _compressedData = _compressedData.insert(now, 0, 14);
171         _compressedData = _compressedData.insert(pushers_[_pusher].tracker, 15, 29);
172         _compressedData = _compressedData.insert(pusherTracker_, 30, 44);
173         _compressedData = _compressedData.insert(_percent, 45, 46);
174             
175         // fire event
176         emit onDistribute(_pusher, _bal, _mnPayout, address(this).balance, _compressedData);
177     }
178 }
179 
180 /**
181 * @title -UintCompressor- v0.1.9
182 
183 */
184 
185 library UintCompressor {
186     using SafeMath for *;
187     
188     function insert(uint256 _var, uint256 _include, uint256 _start, uint256 _end)
189         internal
190         pure
191         returns(uint256)
192     {
193         // check conditions 
194         require(_end < 77 && _start < 77, "start/end must be less than 77");
195         require(_end >= _start, "end must be >= start");
196         
197         // format our start/end points
198         _end = exponent(_end).mul(10);
199         _start = exponent(_start);
200         
201         // check that the include data fits into its segment 
202         require(_include < (_end / _start));
203         
204         // build middle
205         if (_include > 0)
206             _include = _include.mul(_start);
207         
208         return((_var.sub((_var / _start).mul(_start))).add(_include).add((_var / _end).mul(_end)));
209     }
210     
211     function extract(uint256 _input, uint256 _start, uint256 _end)
212 	    internal
213 	    pure
214 	    returns(uint256)
215     {
216         // check conditions
217         require(_end < 77 && _start < 77, "start/end must be less than 77");
218         require(_end >= _start, "end must be >= start");
219         
220         // format our start/end points
221         _end = exponent(_end).mul(10);
222         _start = exponent(_start);
223         
224         // return requested section
225         return((((_input / _start).mul(_start)).sub((_input / _end).mul(_end))) / _start);
226     }
227     
228     function exponent(uint256 _position)
229         private
230         pure
231         returns(uint256)
232     {
233         return((10).pwr(_position));
234     }
235 }
236 
237 /**
238  * @title SafeMath v0.1.9
239  * @dev Math operations with safety checks that throw on error
240  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
241  * - added sqrt
242  * - added sq
243  * - added pwr 
244  * - changed asserts to requires with error log outputs
245  * - removed div, its useless
246  */
247 library SafeMath {
248     
249     /**
250     * @dev Multiplies two numbers, throws on overflow.
251     */
252     function mul(uint256 a, uint256 b) 
253         internal 
254         pure 
255         returns (uint256 c) 
256     {
257         if (a == 0) {
258             return 0;
259         }
260         c = a * b;
261         require(c / a == b, "SafeMath mul failed");
262         return c;
263     }
264 
265     /**
266     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
267     */
268     function sub(uint256 a, uint256 b)
269         internal
270         pure
271         returns (uint256) 
272     {
273         require(b <= a, "SafeMath sub failed");
274         return a - b;
275     }
276 
277     /**
278     * @dev Adds two numbers, throws on overflow.
279     */
280     function add(uint256 a, uint256 b)
281         internal
282         pure
283         returns (uint256 c) 
284     {
285         c = a + b;
286         require(c >= a, "SafeMath add failed");
287         return c;
288     }
289     
290     /**
291      * @dev gives square root of given x.
292      */
293     function sqrt(uint256 x)
294         internal
295         pure
296         returns (uint256 y) 
297     {
298         uint256 z = ((add(x,1)) / 2);
299         y = x;
300         while (z < y) 
301         {
302             y = z;
303             z = ((add((x / z),z)) / 2);
304         }
305     }
306     
307     /**
308      * @dev gives square. multiplies x by x
309      */
310     function sq(uint256 x)
311         internal
312         pure
313         returns (uint256)
314     {
315         return (mul(x,x));
316     }
317     
318     /**
319      * @dev x to the power of y 
320      */
321     function pwr(uint256 x, uint256 y)
322         internal 
323         pure 
324         returns (uint256)
325     {
326         if (x==0)
327             return (0);
328         else if (y==0)
329             return (1);
330         else 
331         {
332             uint256 z = x;
333             for (uint256 i=1; i < y; i++)
334                 z = mul(z,x);
335             return (z);
336         }
337     }
338 }