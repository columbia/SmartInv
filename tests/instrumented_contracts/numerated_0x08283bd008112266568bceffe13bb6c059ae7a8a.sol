1 pragma solidity ^0.4.24;
2 /** title -Divies- v0.7.1
3  *         ┌──────────────────────────────────────────────────────────────────────┐
4  *         │ Divies!, is a contract that adds an external dividend system to H4D. │
5  *         │ All eth sent to this contract, can be distributed to H4D holders.    │
6  *         │ Uses msg.sender as masternode for initial buy order.                 │
7  *         └──────────────────────────────────────────────────────────────────────┘
8  *                                ┌────────────────────┐
9  *                                │ Setup Instructions │
10  *                                └────────────────────┘
11  * (Step 1) import this contracts interface into your contract
12  * 
13  *    import "./DiviesInterface.sol";
14  * 
15  * (Step 2) set up the interface and point it to this contract
16  * 
17  *    DiviesInterface private Divies = DiviesInterface(0x63456554CC52038bE211FdC3DcF03F617BCfC80D);
18  *                                ┌────────────────────┐
19  *                                │ Usage Instructions │
20  *                                └────────────────────┘
21  * call as follows anywhere in your code:
22  *   
23  *    Divies.deposit.value(amount)();
24  *          ex:  Divies.deposit.value(232000000000000000000)();
25  */
26 
27 interface HourglassInterface {
28     function() payable external;
29     function buy(address _playerAddress) payable external returns(uint256);
30     function sell(uint256 _amountOfTokens) external;
31     function reinvest() external;
32     function withdraw() external;
33     function exit() external;
34     function dividendsOf(address _playerAddress) external view returns(uint256);
35     function balanceOf(address _playerAddress) external view returns(uint256);
36     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
37     function stakingRequirement() external view returns(uint256);
38 }
39 
40 contract Divies {
41     using SafeMath for uint256;
42     using UintCompressor for uint256;
43 
44     HourglassInterface constant H4Dcontract_ = HourglassInterface(0xd2371B1C095Fc57503bdce1F2d2673D81961c83a);
45     
46     uint256 public pusherTracker_ = 100;
47     mapping (address => Pusher) public pushers_;
48     struct Pusher
49     {
50         uint256 tracker;
51         uint256 time;
52     }
53     uint256 public rateLimiter_;
54     
55     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
56     // MODIFIERS
57     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
58     modifier isHuman() {
59         require(tx.origin == msg.sender);
60         _;
61     }
62     
63     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
64     // BALANCE
65     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
66     function balances()
67         public
68         view
69         returns(uint256)
70     {
71         return (address(this).balance);
72     }
73     
74     
75     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
76     // DEPOSIT
77     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
78     function deposit()
79         external
80         payable
81     {
82         
83     }
84     
85     // used so the distribute function can call hourglass's withdraw
86     function() external payable {}
87     
88     
89     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
90     // EVENTS
91     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
92     event onDistribute(
93         address pusher,
94         uint256 startingBalance,
95         uint256 masternodePayout,
96         uint256 finalBalance,
97         uint256 compressedData
98     );
99     /* compression key
100     [0-14] - timestamp
101     [15-29] - caller pusher tracker 
102     [30-44] - global pusher tracker 
103     [45-46] - percent
104     [47] - greedy
105     */  
106     
107     
108     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
109     // DISTRIBUTE
110     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
111     function distribute(uint256 _percent)
112         public
113         isHuman()
114     {
115         // make sure _percent is within boundaries
116         require(_percent > 0 && _percent < 100, "please pick a percent between 1 and 99");
117         
118         // data setup
119         address _pusher = msg.sender;
120         uint256 _bal = address(this).balance;
121         uint256 _mnPayout;
122         uint256 _compressedData;
123         
124         // limit pushers greed (use "if" instead of require for level 42 top kek)
125         if (
126             pushers_[_pusher].tracker <= pusherTracker_.sub(100) && // pusher is greedy: wait your turn
127             pushers_[_pusher].time.add(1 hours) < now               // pusher is greedy: its not even been 1 hour
128         )
129         {
130             // update pushers wait que 
131             pushers_[_pusher].tracker = pusherTracker_;
132             pusherTracker_++;
133             
134             // setup mn payout for event
135             if (H4Dcontract_.balanceOf(_pusher) >= H4Dcontract_.stakingRequirement())
136                 _mnPayout = (_bal / 10) / 3;
137             
138             // setup _stop.  this will be used to tell the loop to stop
139             uint256 _stop = (_bal.mul(100 - _percent)) / 100;
140             
141             // buy & sell    
142             H4Dcontract_.buy.value(_bal)(_pusher);
143             H4Dcontract_.sell(H4Dcontract_.balanceOf(address(this)));
144             
145             // setup tracker.  this will be used to tell the loop to stop
146             uint256 _tracker = H4Dcontract_.dividendsOf(address(this));
147     
148             // reinvest/sell loop
149             while (_tracker >= _stop) 
150             {
151                 // lets burn some tokens to distribute dividends to H4D holders
152                 H4Dcontract_.reinvest();
153                 H4Dcontract_.sell(H4Dcontract_.balanceOf(address(this)));
154                 
155                 // update our tracker with estimates (yea. not perfect, but cheaper on gas)
156                 _tracker = (_tracker.mul(81)) / 100;
157             }
158             
159             // withdraw
160             H4Dcontract_.withdraw();
161         } else {
162             _compressedData = _compressedData.insert(1, 47, 47);
163         }
164         
165         // update pushers timestamp  (do outside of "if" for super saiyan level top kek)
166         pushers_[_pusher].time = now;
167     
168         // prep event compression data 
169         _compressedData = _compressedData.insert(now, 0, 14);
170         _compressedData = _compressedData.insert(pushers_[_pusher].tracker, 15, 29);
171         _compressedData = _compressedData.insert(pusherTracker_, 30, 44);
172         _compressedData = _compressedData.insert(_percent, 45, 46);
173             
174         // fire event
175         emit onDistribute(_pusher, _bal, _mnPayout, address(this).balance, _compressedData);
176     }
177 }
178 
179 /**
180 * @title -UintCompressor- v0.1.9
181 
182 */
183 
184 library UintCompressor {
185     using SafeMath for *;
186     
187     function insert(uint256 _var, uint256 _include, uint256 _start, uint256 _end)
188         internal
189         pure
190         returns(uint256)
191     {
192         // check conditions 
193         require(_end < 77 && _start < 77, "start/end must be less than 77");
194         require(_end >= _start, "end must be >= start");
195         
196         // format our start/end points
197         _end = exponent(_end).mul(10);
198         _start = exponent(_start);
199         
200         // check that the include data fits into its segment 
201         require(_include < (_end / _start));
202         
203         // build middle
204         if (_include > 0)
205             _include = _include.mul(_start);
206         
207         return((_var.sub((_var / _start).mul(_start))).add(_include).add((_var / _end).mul(_end)));
208     }
209     
210     function extract(uint256 _input, uint256 _start, uint256 _end)
211 	    internal
212 	    pure
213 	    returns(uint256)
214     {
215         // check conditions
216         require(_end < 77 && _start < 77, "start/end must be less than 77");
217         require(_end >= _start, "end must be >= start");
218         
219         // format our start/end points
220         _end = exponent(_end).mul(10);
221         _start = exponent(_start);
222         
223         // return requested section
224         return((((_input / _start).mul(_start)).sub((_input / _end).mul(_end))) / _start);
225     }
226     
227     function exponent(uint256 _position)
228         private
229         pure
230         returns(uint256)
231     {
232         return((10).pwr(_position));
233     }
234 }
235 
236 /**
237  * @title SafeMath v0.1.9
238  * @dev Math operations with safety checks that throw on error
239  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
240  * - added sqrt
241  * - added sq
242  * - added pwr 
243  * - changed asserts to requires with error log outputs
244  * - removed div, its useless
245  */
246 library SafeMath {
247     
248     /**
249     * @dev Multiplies two numbers, throws on overflow.
250     */
251     function mul(uint256 a, uint256 b) 
252         internal 
253         pure 
254         returns (uint256 c) 
255     {
256         if (a == 0) {
257             return 0;
258         }
259         c = a * b;
260         require(c / a == b, "SafeMath mul failed");
261         return c;
262     }
263 
264     /**
265     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
266     */
267     function sub(uint256 a, uint256 b)
268         internal
269         pure
270         returns (uint256) 
271     {
272         require(b <= a, "SafeMath sub failed");
273         return a - b;
274     }
275 
276     /**
277     * @dev Adds two numbers, throws on overflow.
278     */
279     function add(uint256 a, uint256 b)
280         internal
281         pure
282         returns (uint256 c) 
283     {
284         c = a + b;
285         require(c >= a, "SafeMath add failed");
286         return c;
287     }
288     
289     /**
290      * @dev gives square root of given x.
291      */
292     function sqrt(uint256 x)
293         internal
294         pure
295         returns (uint256 y) 
296     {
297         uint256 z = ((add(x,1)) / 2);
298         y = x;
299         while (z < y) 
300         {
301             y = z;
302             z = ((add((x / z),z)) / 2);
303         }
304     }
305     
306     /**
307      * @dev gives square. multiplies x by x
308      */
309     function sq(uint256 x)
310         internal
311         pure
312         returns (uint256)
313     {
314         return (mul(x,x));
315     }
316     
317     /**
318      * @dev x to the power of y 
319      */
320     function pwr(uint256 x, uint256 y)
321         internal 
322         pure 
323         returns (uint256)
324     {
325         if (x==0)
326             return (0);
327         else if (y==0)
328             return (1);
329         else 
330         {
331             uint256 z = x;
332             for (uint256 i=1; i < y; i++)
333                 z = mul(z,x);
334             return (z);
335         }
336     }
337 }