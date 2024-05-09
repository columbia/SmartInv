1 pragma solidity ^0.4.24;
2 /** title -Divies- v0.7.1
3  * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
4  *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
5  *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
6  *                                  _____                      _____
7  *                                 (, /     /)       /) /)    (, /      /)          /)
8  *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
9  *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
10  *          ┴ ┴                /   /          .-/ _____   (__ /                               
11  *                            (__ /          (_/ (, /                                      /)™ 
12  *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
13  * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
14  * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
15  * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
16  *          ______      .-./`)  ,---.  ,---. .-./`)      .-''-.      .-'''-.   .---.  
17  *=========|    _ `''.  \ .-.') |   /  |   | \ .-.')   .'_ _   \    / _     \  \   /=========*
18  *         | _ | ) _  \ / `-' \ |  |   |  .' / `-' \  / ( ` )   '  (`' )/`--'  |   |  
19  *         |( ''_'  ) |  `-'`"` |  | _ |  |   `-'`"` . (_ o _)  | (_ o _).      \ /   
20  *         | . (_) `. |  .---.  |  _( )_  |   .---.  |  (_,_)___|  (_,_). '.     v    
21  *         |(_    ._) '  |   |  \ (_ o._) /   |   |  '  \   .---. .---.  \  :   _ _   
22  *         |  (_.\.' /   |   |   \ (_,_) /    |   |   \  `-'    / \    `-'  |  (_I_)  
23  *=========|       .'    |   |    \     /     |   |    \       /   \       /  (_(=)_)========* 
24  *         '-----'`      '---'     `---`      '---'     `'-..-'     `-...-'    (_I_)  
25  * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
26  * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
27  * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
28  *         ┌──────────────────────────────────────────────────────────────────────┐
29  *         │ Divies!, is a contract that adds an external dividend system to P3D. │
30  *         │ All eth sent to this contract, can be distributed to P3D holders.    │
31  *         └──────────────────────────────────────────────────────────────────────┘
32  *                                ┌────────────────────┐
33  *                                │ Setup Instructions │
34  *                                └────────────────────┘
35  * (Step 1) import this contracts interface into your contract
36  * 
37  *    import "./DiviesInterface.sol";
38  * 
39  * (Step 2) set up the interface and point it to this contract
40  * 
41  *    DiviesInterface private Divies = DiviesInterface(0xC0c001140319C5f114F8467295b1F22F86929Ad0);
42  *                                ┌────────────────────┐
43  *                                │ Usage Instructions │
44  *                                └────────────────────┘
45  * call as follows anywhere in your code:
46  *   
47  *    Divies.deposit.value(amount)();
48  *          ex:  Divies.deposit.value(232000000000000000000)();
49  */
50 interface HourglassInterface {
51     function() payable external;
52     function buy(address _playerAddress) payable external returns(uint256);
53     function sell(uint256 _amountOfTokens) external;
54     function reinvest() external;
55     function withdraw() external;
56     function exit() external;
57     function dividendsOf(address _playerAddress) external view returns(uint256);
58     function balanceOf(address _playerAddress) external view returns(uint256);
59     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
60     function stakingRequirement() external view returns(uint256);
61 }
62 
63 contract Divies {
64     using SafeMath for uint256;
65     using UintCompressor for uint256;
66 
67     HourglassInterface constant P3Dcontract_ = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
68     
69     uint256 public pusherTracker_ = 100;
70     mapping (address => Pusher) public pushers_;
71     struct Pusher
72     {
73         uint256 tracker;
74         uint256 time;
75     }
76     uint256 public rateLimiter_;
77     
78     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
79     // MODIFIERS
80     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
81     modifier isHuman() {
82         address _addr = msg.sender;
83         require(_addr == tx.origin);
84         uint256 _codeLength;
85         
86         assembly {_codeLength := extcodesize(_addr)}
87         require(_codeLength == 0, "sorry humans only");
88         _;
89     }
90     
91     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
92     // BALANCE
93     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
94     function balances()
95         public
96         view
97         returns(uint256)
98     {
99         return (address(this).balance);
100     }
101     
102     
103     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
104     // DEPOSIT
105     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
106     function deposit()
107         external
108         payable
109     {
110         
111     }
112     
113     // used so the distribute function can call hourglass's withdraw
114     function() external payable {}
115     
116     
117     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
118     // EVENTS
119     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
120     event onDistribute(
121         address pusher,
122         uint256 startingBalance,
123         uint256 finalBalance,
124         uint256 compressedData
125     );
126     /* compression key
127     [0-14] - timestamp
128     [15-29] - caller pusher tracker 
129     [30-44] - global pusher tracker 
130     [45-46] - percent
131     [47] - greedy
132     */  
133     
134     
135     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
136     // DISTRIBUTE
137     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
138     function distribute(uint256 _percent)
139         public
140         isHuman()
141     {
142         // make sure _percent is within boundaries
143         require(_percent > 0 && _percent < 100, "please pick a percent between 1 and 99");
144         
145         // data setup
146         address _pusher = msg.sender;
147         uint256 _bal = address(this).balance;
148         uint256 _compressedData;
149         
150         // limit pushers greed (use "if" instead of require for level 42 top kek)
151         if (
152             pushers_[_pusher].tracker <= pusherTracker_.sub(100) && // pusher is greedy: wait your turn
153             pushers_[_pusher].time.add(1 hours) < now               // pusher is greedy: its not even been 1 hour
154         )
155         {
156             // update pushers wait que 
157             pushers_[_pusher].tracker = pusherTracker_;
158             pusherTracker_++;
159             
160             // setup _stop.  this will be used to tell the loop to stop
161             uint256 _stop = (_bal.mul(100 - _percent)) / 100;
162             
163             // buy & sell    
164             P3Dcontract_.buy.value(_bal)(address(0));
165             P3Dcontract_.sell(P3Dcontract_.balanceOf(address(this)));
166             
167             // setup tracker.  this will be used to tell the loop to stop
168             uint256 _tracker = P3Dcontract_.dividendsOf(address(this));
169     
170             // reinvest/sell loop
171             while (_tracker >= _stop) 
172             {
173                 // lets burn some tokens to distribute dividends to p3d holders
174                 P3Dcontract_.reinvest();
175                 P3Dcontract_.sell(P3Dcontract_.balanceOf(address(this)));
176                 
177                 // update our tracker with estimates (yea. not perfect, but cheaper on gas)
178                 _tracker = (_tracker.mul(81)) / 100;
179             }
180             
181             // withdraw
182             P3Dcontract_.withdraw();
183         } else {
184             _compressedData = _compressedData.insert(1, 47, 47);
185         }
186         
187         // update pushers timestamp  (do outside of "if" for super saiyan level top kek)
188         pushers_[_pusher].time = now;
189     
190         // prep event compression data 
191         _compressedData = _compressedData.insert(now, 0, 14);
192         _compressedData = _compressedData.insert(pushers_[_pusher].tracker, 15, 29);
193         _compressedData = _compressedData.insert(pusherTracker_, 30, 44);
194         _compressedData = _compressedData.insert(_percent, 45, 46);
195             
196         // fire event
197         emit onDistribute(_pusher, _bal, address(this).balance, _compressedData);
198     }
199 }
200 
201 
202 /**
203 * @title -UintCompressor- v0.1.9
204 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
205 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
206 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
207 *                                  _____                      _____
208 *                                 (, /     /)       /) /)    (, /      /)          /)
209 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
210 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
211 *          ┴ ┴                /   /          .-/ _____   (__ /                               
212 *                            (__ /          (_/ (, /                                      /)™ 
213 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
214 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
215 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
216 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
217 *    _  _   __   __ _  ____     ___   __   _  _  ____  ____  ____  ____  ____   __   ____ 
218 *===/ )( \ (  ) (  ( \(_  _)===/ __) /  \ ( \/ )(  _ \(  _ \(  __)/ ___)/ ___) /  \ (  _ \===*
219 *   ) \/ (  )(  /    /  )(    ( (__ (  O )/ \/ \ ) __/ )   / ) _) \___ \\___ \(  O ) )   /
220 *===\____/ (__) \_)__) (__)====\___) \__/ \_)(_/(__)  (__\_)(____)(____/(____/ \__/ (__\_)===*
221 *
222 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
223 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
224 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
225 */
226 
227 library UintCompressor {
228     using SafeMath for *;
229     
230     function insert(uint256 _var, uint256 _include, uint256 _start, uint256 _end)
231         internal
232         pure
233         returns(uint256)
234     {
235         // check conditions 
236         require(_end < 77 && _start < 77, "start/end must be less than 77");
237         require(_end >= _start, "end must be >= start");
238         
239         // format our start/end points
240         _end = exponent(_end).mul(10);
241         _start = exponent(_start);
242         
243         // check that the include data fits into its segment 
244         require(_include < (_end / _start));
245         
246         // build middle
247         if (_include > 0)
248             _include = _include.mul(_start);
249         
250         return((_var.sub((_var / _start).mul(_start))).add(_include).add((_var / _end).mul(_end)));
251     }
252     
253     function extract(uint256 _input, uint256 _start, uint256 _end)
254 	    internal
255 	    pure
256 	    returns(uint256)
257     {
258         // check conditions
259         require(_end < 77 && _start < 77, "start/end must be less than 77");
260         require(_end >= _start, "end must be >= start");
261         
262         // format our start/end points
263         _end = exponent(_end).mul(10);
264         _start = exponent(_start);
265         
266         // return requested section
267         return((((_input / _start).mul(_start)).sub((_input / _end).mul(_end))) / _start);
268     }
269     
270     function exponent(uint256 _position)
271         private
272         pure
273         returns(uint256)
274     {
275         return((10).pwr(_position));
276     }
277 }
278 
279 /**
280  * @title SafeMath v0.1.9
281  * @dev Math operations with safety checks that throw on error
282  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
283  * - added sqrt
284  * - added sq
285  * - added pwr 
286  * - changed asserts to requires with error log outputs
287  * - removed div, its useless
288  */
289 library SafeMath {
290     
291     /**
292     * @dev Multiplies two numbers, throws on overflow.
293     */
294     function mul(uint256 a, uint256 b) 
295         internal 
296         pure 
297         returns (uint256 c) 
298     {
299         if (a == 0) {
300             return 0;
301         }
302         c = a * b;
303         require(c / a == b, "SafeMath mul failed");
304         return c;
305     }
306 
307     /**
308     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
309     */
310     function sub(uint256 a, uint256 b)
311         internal
312         pure
313         returns (uint256) 
314     {
315         require(b <= a, "SafeMath sub failed");
316         return a - b;
317     }
318 
319     /**
320     * @dev Adds two numbers, throws on overflow.
321     */
322     function add(uint256 a, uint256 b)
323         internal
324         pure
325         returns (uint256 c) 
326     {
327         c = a + b;
328         require(c >= a, "SafeMath add failed");
329         return c;
330     }
331     
332     /**
333      * @dev gives square root of given x.
334      */
335     function sqrt(uint256 x)
336         internal
337         pure
338         returns (uint256 y) 
339     {
340         uint256 z = ((add(x,1)) / 2);
341         y = x;
342         while (z < y) 
343         {
344             y = z;
345             z = ((add((x / z),z)) / 2);
346         }
347     }
348     
349     /**
350      * @dev gives square. multiplies x by x
351      */
352     function sq(uint256 x)
353         internal
354         pure
355         returns (uint256)
356     {
357         return (mul(x,x));
358     }
359     
360     /**
361      * @dev x to the power of y 
362      */
363     function pwr(uint256 x, uint256 y)
364         internal 
365         pure 
366         returns (uint256)
367     {
368         if (x==0)
369             return (0);
370         else if (y==0)
371             return (1);
372         else 
373         {
374             uint256 z = x;
375             for (uint256 i=1; i < y; i++)
376                 z = mul(z,x);
377             return (z);
378         }
379     }
380 }