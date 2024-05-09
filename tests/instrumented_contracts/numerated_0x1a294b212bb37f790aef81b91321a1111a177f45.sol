1 pragma solidity ^0.4.24;
2 /** title -Divies- v0.7.0
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
31  *         │ Uses msg.sender as masternode for initial buy order.                 │
32  *         └──────────────────────────────────────────────────────────────────────┘
33  *                                ┌────────────────────┐
34  *                                │ Setup Instructions │
35  *                                └────────────────────┘
36  * (Step 1) import this contracts interface into your contract
37  * 
38  *    import "./DiviesInterface.sol";
39  * 
40  * (Step 2) set up the interface and point it to this contract
41  * 
42  *    DiviesInterface private Divies = DiviesInterface(0x1a294b212BB37f790AeF81b91321A1111A177f45);
43  *                                ┌────────────────────┐
44  *                                │ Usage Instructions │
45  *                                └────────────────────┘
46  * call as follows anywhere in your code:
47  *   
48  *    Divies.deposit.value(amount)();
49  *          ex:  Divies.deposit.value(232000000000000000000)();
50  */
51 //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
52 // IMPORT LIBRARIES
53 //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
54 /**
55  * @title SafeMath v0.1.9
56  * @dev Math operations with safety checks that throw on error
57  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
58  * - added sqrt
59  * - added sq
60  * - added pwr 
61  * - changed asserts to requires with error log outputs
62  * - removed div, its useless
63  */
64 library SafeMath {
65     
66     /**
67     * @dev Multiplies two numbers, throws on overflow.
68     */
69     function mul(uint256 a, uint256 b) 
70         internal 
71         pure 
72         returns (uint256 c) 
73     {
74         if (a == 0) {
75             return 0;
76         }
77         c = a * b;
78         require(c / a == b, "SafeMath mul failed");
79         return c;
80     }
81 
82     /**
83     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
84     */
85     function sub(uint256 a, uint256 b)
86         internal
87         pure
88         returns (uint256) 
89     {
90         require(b <= a, "SafeMath sub failed");
91         return a - b;
92     }
93 
94     /**
95     * @dev Adds two numbers, throws on overflow.
96     */
97     function add(uint256 a, uint256 b)
98         internal
99         pure
100         returns (uint256 c) 
101     {
102         c = a + b;
103         require(c >= a, "SafeMath add failed");
104         return c;
105     }
106     
107     /**
108      * @dev gives square root of given x.
109      */
110     function sqrt(uint256 x)
111         internal
112         pure
113         returns (uint256 y) 
114     {
115         uint256 z = ((add(x,1)) / 2);
116         y = x;
117         while (z < y) 
118         {
119             y = z;
120             z = ((add((x / z),z)) / 2);
121         }
122     }
123     
124     /**
125      * @dev gives square. multiplies x by x
126      */
127     function sq(uint256 x)
128         internal
129         pure
130         returns (uint256)
131     {
132         return (mul(x,x));
133     }
134     
135     /**
136      * @dev x to the power of y 
137      */
138     function pwr(uint256 x, uint256 y)
139         internal 
140         pure 
141         returns (uint256)
142     {
143         if (x==0)
144             return (0);
145         else if (y==0)
146             return (1);
147         else 
148         {
149             uint256 z = x;
150             for (uint256 i=1; i < y; i++)
151                 z = mul(z,x);
152             return (z);
153         }
154     }
155 }
156 interface HourglassInterface {
157     function() payable external;
158     function buy(address _playerAddress) payable external returns(uint256);
159     function sell(uint256 _amountOfTokens) external;
160     function reinvest() external;
161     function withdraw() external;
162     function exit() external;
163     function dividendsOf(address _playerAddress) external view returns(uint256);
164     function balanceOf(address _playerAddress) external view returns(uint256);
165     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
166     function stakingRequirement() external view returns(uint256);
167 }
168 /**
169 * @title -UintCompressor- v0.1.9
170 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
171 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
172 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
173 *                                  _____                      _____
174 *                                 (, /     /)       /) /)    (, /      /)          /)
175 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
176 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
177 *          ┴ ┴                /   /          .-/ _____   (__ /                               
178 *                            (__ /          (_/ (, /                                      /)™ 
179 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
180 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
181 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
182 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
183 *    _  _   __   __ _  ____     ___   __   _  _  ____  ____  ____  ____  ____   __   ____ 
184 *===/ )( \ (  ) (  ( \(_  _)===/ __) /  \ ( \/ )(  _ \(  _ \(  __)/ ___)/ ___) /  \ (  _ \===*
185 *   ) \/ (  )(  /    /  )(    ( (__ (  O )/ \/ \ ) __/ )   / ) _) \___ \\___ \(  O ) )   /
186 *===\____/ (__) \_)__) (__)====\___) \__/ \_)(_/(__)  (__\_)(____)(____/(____/ \__/ (__\_)===*
187 *
188 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
189 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
190 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
191 */
192 
193 library UintCompressor {
194     using SafeMath for *;
195     
196     function insert(uint256 _var, uint256 _include, uint256 _start, uint256 _end)
197         internal
198         pure
199         returns(uint256)
200     {
201         // check conditions 
202         require(_end < 77 && _start < 77, "start/end must be less than 77");
203         require(_end >= _start, "end must be >= start");
204         
205         // format our start/end points
206         _end = exponent(_end).mul(10);
207         _start = exponent(_start);
208         
209         // check that the include data fits into its segment 
210         require(_include < (_end / _start));
211         
212         // build middle
213         if (_include > 0)
214             _include = _include.mul(_start);
215         
216         return((_var.sub((_var / _start).mul(_start))).add(_include).add((_var / _end).mul(_end)));
217     }
218     
219     function extract(uint256 _input, uint256 _start, uint256 _end)
220 	    internal
221 	    pure
222 	    returns(uint256)
223     {
224         // check conditions
225         require(_end < 77 && _start < 77, "start/end must be less than 77");
226         require(_end >= _start, "end must be >= start");
227         
228         // format our start/end points
229         _end = exponent(_end).mul(10);
230         _start = exponent(_start);
231         
232         // return requested section
233         return((((_input / _start).mul(_start)).sub((_input / _end).mul(_end))) / _start);
234     }
235     
236     function exponent(uint256 _position)
237         private
238         pure
239         returns(uint256)
240     {
241         return((10).pwr(_position));
242     }
243 }
244 
245 contract Divies {
246     using SafeMath for uint256;
247     using UintCompressor for uint256;
248 
249     HourglassInterface constant P3Dcontract_ = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
250     
251     uint256 public pusherTracker_ = 100;
252     mapping (address => Pusher) public pushers_;
253     struct Pusher
254     {
255         uint256 tracker;
256         uint256 time;
257     }
258     uint256 public rateLimiter_;
259     
260     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
261     // MODIFIERS
262     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
263     modifier isHuman() {
264         address _addr = msg.sender;
265         uint256 _codeLength;
266         
267         assembly {_codeLength := extcodesize(_addr)}
268         require(_codeLength == 0, "sorry humans only");
269         _;
270     }
271     
272     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
273     // BALANCE
274     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
275     function balances()
276         public
277         view
278         returns(uint256)
279     {
280         return (address(this).balance);
281     }
282     
283     
284     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
285     // DEPOSIT
286     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
287     function deposit()
288         external
289         payable
290     {
291         
292     }
293     
294     // used so the distribute function can call hourglass's withdraw
295     function() external payable {}
296     
297     
298     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
299     // EVENTS
300     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
301     event onDistribute(
302         address pusher,
303         uint256 startingBalance,
304         uint256 masternodePayout,
305         uint256 finalBalance,
306         uint256 compressedData
307     );
308     /* compression key
309     [0-14] - timestamp
310     [15-29] - caller pusher tracker 
311     [30-44] - global pusher tracker 
312     [45-46] - percent
313     [47] - greedy
314     */  
315     
316     
317     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
318     // DISTRIBUTE
319     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
320     function distribute(uint256 _percent)
321         public
322         isHuman()
323     {
324         // make sure _percent is within boundaries
325         require(_percent > 0 && _percent < 100, "please pick a percent between 1 and 99");
326         
327         // data setup
328         address _pusher = msg.sender;
329         uint256 _bal = address(this).balance;
330         uint256 _mnPayout;
331         uint256 _compressedData;
332         
333         // limit pushers greed (use "if" instead of require for level 42 top kek)
334         if (
335             pushers_[_pusher].tracker <= pusherTracker_.sub(100) && // pusher is greedy: wait your turn
336             pushers_[_pusher].time.add(1 hours) >= now              // pusher is greedy: its not even been 1 hour
337         )
338         {
339             // update pushers wait que 
340             pushers_[_pusher].tracker = pusherTracker_;
341             pusherTracker_++;
342             
343             // setup mn payout for event
344             if (P3Dcontract_.balanceOf(_pusher) >= P3Dcontract_.stakingRequirement())
345                 _mnPayout = (_bal / 10) / 3;
346             
347             // setup _stop.  this will be used to tell the loop to stop
348             uint256 _stop = (_bal.mul(100 - _percent)) / 100;
349             
350             // buy & sell    
351             P3Dcontract_.buy.value(_bal)(_pusher);
352             P3Dcontract_.sell(P3Dcontract_.balanceOf(address(this)));
353             
354             // setup tracker.  this will be used to tell the loop to stop
355             uint256 _tracker = P3Dcontract_.dividendsOf(address(this));
356     
357             // reinvest/sell loop
358             while (_tracker >= _stop) 
359             {
360                 // lets burn some tokens to distribute dividends to p3d holders
361                 P3Dcontract_.reinvest();
362                 P3Dcontract_.sell(P3Dcontract_.balanceOf(address(this)));
363                 
364                 // update our tracker with estimates (yea. not perfect, but cheaper on gas)
365                 _tracker = (_tracker.mul(81)) / 100;
366             }
367             
368             // withdraw
369             P3Dcontract_.withdraw();
370         } else {
371             _compressedData = _compressedData.insert(1, 47, 47);
372         }
373         
374         // update pushers timestamp  (do outside of "if" for super saiyan level top kek)
375         pushers_[_pusher].time = now;
376     
377         // prep event compression data 
378         _compressedData = _compressedData.insert(now, 0, 14);
379         _compressedData = _compressedData.insert(pushers_[_pusher].tracker, 15, 29);
380         _compressedData = _compressedData.insert(pusherTracker_, 30, 44);
381         _compressedData = _compressedData.insert(_percent, 45, 46);
382             
383         // fire event
384         emit onDistribute(_pusher, _bal, _mnPayout, address(this).balance, _compressedData);
385     }
386 }