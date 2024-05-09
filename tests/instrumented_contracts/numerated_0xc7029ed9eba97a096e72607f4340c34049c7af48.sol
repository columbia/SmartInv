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
42  *    DiviesInterface private Divies = DiviesInterface(0xc7029Ed9EBa97A096e72607f4340c34049C7AF48);
43  *                                ┌────────────────────┐
44  *                                │ Usage Instructions │
45  *                                └────────────────────┘
46  * call as follows anywhere in your code:
47  *   
48  *    Divies.deposit.value(amount)();
49  *          ex:  Divies.deposit.value(232000000000000000000)();
50  */
51 
52 interface HourglassInterface {
53     function() payable external;
54     function buy(address _playerAddress) payable external returns(uint256);
55     function sell(uint256 _amountOfTokens) external;
56     function reinvest() external;
57     function withdraw() external;
58     function exit() external;
59     function dividendsOf(address _playerAddress) external view returns(uint256);
60     function balanceOf(address _playerAddress) external view returns(uint256);
61     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
62     function stakingRequirement() external view returns(uint256);
63 }
64 
65 contract Divies {
66     using SafeMath for uint256;
67     using UintCompressor for uint256;
68 
69     HourglassInterface constant P3Dcontract_ = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
70     
71     uint256 public pusherTracker_ = 100;
72     mapping (address => Pusher) public pushers_;
73     struct Pusher
74     {
75         uint256 tracker;
76         uint256 time;
77     }
78     uint256 public rateLimiter_;
79     
80     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
81     // MODIFIERS
82     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
83     modifier isHuman() {
84         address _addr = msg.sender;
85         uint256 _codeLength;
86         
87         assembly {_codeLength := extcodesize(_addr)}
88         require(_codeLength == 0, "sorry humans only");
89         _;
90     }
91     
92     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
93     // BALANCE
94     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
95     function balances()
96         public
97         view
98         returns(uint256)
99     {
100         return (address(this).balance);
101     }
102     
103     
104     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
105     // DEPOSIT
106     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
107     function deposit()
108         external
109         payable
110     {
111         
112     }
113     
114     // used so the distribute function can call hourglass's withdraw
115     function() external payable {}
116     
117     
118     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
119     // EVENTS
120     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
121     event onDistribute(
122         address pusher,
123         uint256 startingBalance,
124         uint256 masternodePayout,
125         uint256 finalBalance,
126         uint256 compressedData
127     );
128     /* compression key
129     [0-14] - timestamp
130     [15-29] - caller pusher tracker 
131     [30-44] - global pusher tracker 
132     [45-46] - percent
133     [47] - greedy
134     */  
135     
136     
137     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
138     // DISTRIBUTE
139     //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
140     function distribute(uint256 _percent)
141         public
142         isHuman()
143     {
144         // make sure _percent is within boundaries
145         require(_percent > 0 && _percent < 100, "please pick a percent between 1 and 99");
146         
147         // data setup
148         address _pusher = msg.sender;
149         uint256 _bal = address(this).balance;
150         uint256 _mnPayout;
151         uint256 _compressedData;
152         
153         // limit pushers greed (use "if" instead of require for level 42 top kek)
154         if (
155             pushers_[_pusher].tracker <= pusherTracker_.sub(100) && // pusher is greedy: wait your turn
156             pushers_[_pusher].time.add(1 hours) < now               // pusher is greedy: its not even been 1 hour
157         )
158         {
159             // update pushers wait que 
160             pushers_[_pusher].tracker = pusherTracker_;
161             pusherTracker_++;
162             
163             // setup mn payout for event
164             if (P3Dcontract_.balanceOf(_pusher) >= P3Dcontract_.stakingRequirement())
165                 _mnPayout = (_bal / 10) / 3;
166             
167             // setup _stop.  this will be used to tell the loop to stop
168             uint256 _stop = (_bal.mul(100 - _percent)) / 100;
169             
170             // buy & sell    
171             P3Dcontract_.buy.value(_bal)(_pusher);
172             P3Dcontract_.sell(P3Dcontract_.balanceOf(address(this)));
173             
174             // setup tracker.  this will be used to tell the loop to stop
175             uint256 _tracker = P3Dcontract_.dividendsOf(address(this));
176     
177             // reinvest/sell loop
178             while (_tracker >= _stop) 
179             {
180                 // lets burn some tokens to distribute dividends to p3d holders
181                 P3Dcontract_.reinvest();
182                 P3Dcontract_.sell(P3Dcontract_.balanceOf(address(this)));
183                 
184                 // update our tracker with estimates (yea. not perfect, but cheaper on gas)
185                 _tracker = (_tracker.mul(81)) / 100;
186             }
187             
188             // withdraw
189             P3Dcontract_.withdraw();
190         } else {
191             _compressedData = _compressedData.insert(1, 47, 47);
192         }
193         
194         // update pushers timestamp  (do outside of "if" for super saiyan level top kek)
195         pushers_[_pusher].time = now;
196     
197         // prep event compression data 
198         _compressedData = _compressedData.insert(now, 0, 14);
199         _compressedData = _compressedData.insert(pushers_[_pusher].tracker, 15, 29);
200         _compressedData = _compressedData.insert(pusherTracker_, 30, 44);
201         _compressedData = _compressedData.insert(_percent, 45, 46);
202             
203         // fire event
204         emit onDistribute(_pusher, _bal, _mnPayout, address(this).balance, _compressedData);
205     }
206 }
207 
208 /**
209 * @title -UintCompressor- v0.1.9
210 * ┌┬┐┌─┐┌─┐┌┬┐   ╦╦ ╦╔═╗╔╦╗  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐
211 *  │ ├┤ ├─┤│││   ║║ ║╚═╗ ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
212 *  ┴ └─┘┴ ┴┴ ┴  ╚╝╚═╝╚═╝ ╩   ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘
213 *                                  _____                      _____
214 *                                 (, /     /)       /) /)    (, /      /)          /)
215 *          ┌─┐                      /   _ (/_      // //       /  _   // _   __  _(/
216 *          ├─┤                  ___/___(/_/(__(_/_(/_(/_   ___/__/_)_(/_(_(_/ (_(_(_
217 *          ┴ ┴                /   /          .-/ _____   (__ /                               
218 *                            (__ /          (_/ (, /                                      /)™ 
219 *                                                 /  __  __ __ __  _   __ __  _  _/_ _  _(/
220 * ┌─┐┬─┐┌─┐┌┬┐┬ ┬┌─┐┌┬┐                          /__/ (_(__(_)/ (_/_)_(_)/ (_(_(_(__(/_(_(_
221 * ├─┘├┬┘│ │ │││ ││   │                      (__ /              .-/  © Jekyll Island Inc. 2018
222 * ┴  ┴└─└─┘─┴┘└─┘└─┘ ┴                                        (_/
223 *    _  _   __   __ _  ____     ___   __   _  _  ____  ____  ____  ____  ____   __   ____ 
224 *===/ )( \ (  ) (  ( \(_  _)===/ __) /  \ ( \/ )(  _ \(  _ \(  __)/ ___)/ ___) /  \ (  _ \===*
225 *   ) \/ (  )(  /    /  )(    ( (__ (  O )/ \/ \ ) __/ )   / ) _) \___ \\___ \(  O ) )   /
226 *===\____/ (__) \_)__) (__)====\___) \__/ \_)(_/(__)  (__\_)(____)(____/(____/ \__/ (__\_)===*
227 *
228 * ╔═╗┌─┐┌┐┌┌┬┐┬─┐┌─┐┌─┐┌┬┐  ╔═╗┌─┐┌┬┐┌─┐ ┌──────────┐
229 * ║  │ ││││ │ ├┬┘├─┤│   │   ║  │ │ ││├┤  │ Inventor │
230 * ╚═╝└─┘┘└┘ ┴ ┴└─┴ ┴└─┘ ┴   ╚═╝└─┘─┴┘└─┘ └──────────┘
231 */
232 
233 library UintCompressor {
234     using SafeMath for *;
235     
236     function insert(uint256 _var, uint256 _include, uint256 _start, uint256 _end)
237         internal
238         pure
239         returns(uint256)
240     {
241         // check conditions 
242         require(_end < 77 && _start < 77, "start/end must be less than 77");
243         require(_end >= _start, "end must be >= start");
244         
245         // format our start/end points
246         _end = exponent(_end).mul(10);
247         _start = exponent(_start);
248         
249         // check that the include data fits into its segment 
250         require(_include < (_end / _start));
251         
252         // build middle
253         if (_include > 0)
254             _include = _include.mul(_start);
255         
256         return((_var.sub((_var / _start).mul(_start))).add(_include).add((_var / _end).mul(_end)));
257     }
258     
259     function extract(uint256 _input, uint256 _start, uint256 _end)
260 	    internal
261 	    pure
262 	    returns(uint256)
263     {
264         // check conditions
265         require(_end < 77 && _start < 77, "start/end must be less than 77");
266         require(_end >= _start, "end must be >= start");
267         
268         // format our start/end points
269         _end = exponent(_end).mul(10);
270         _start = exponent(_start);
271         
272         // return requested section
273         return((((_input / _start).mul(_start)).sub((_input / _end).mul(_end))) / _start);
274     }
275     
276     function exponent(uint256 _position)
277         private
278         pure
279         returns(uint256)
280     {
281         return((10).pwr(_position));
282     }
283 }
284 
285 /**
286  * @title SafeMath v0.1.9
287  * @dev Math operations with safety checks that throw on error
288  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
289  * - added sqrt
290  * - added sq
291  * - added pwr 
292  * - changed asserts to requires with error log outputs
293  * - removed div, its useless
294  */
295 library SafeMath {
296     
297     /**
298     * @dev Multiplies two numbers, throws on overflow.
299     */
300     function mul(uint256 a, uint256 b) 
301         internal 
302         pure 
303         returns (uint256 c) 
304     {
305         if (a == 0) {
306             return 0;
307         }
308         c = a * b;
309         require(c / a == b, "SafeMath mul failed");
310         return c;
311     }
312 
313     /**
314     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
315     */
316     function sub(uint256 a, uint256 b)
317         internal
318         pure
319         returns (uint256) 
320     {
321         require(b <= a, "SafeMath sub failed");
322         return a - b;
323     }
324 
325     /**
326     * @dev Adds two numbers, throws on overflow.
327     */
328     function add(uint256 a, uint256 b)
329         internal
330         pure
331         returns (uint256 c) 
332     {
333         c = a + b;
334         require(c >= a, "SafeMath add failed");
335         return c;
336     }
337     
338     /**
339      * @dev gives square root of given x.
340      */
341     function sqrt(uint256 x)
342         internal
343         pure
344         returns (uint256 y) 
345     {
346         uint256 z = ((add(x,1)) / 2);
347         y = x;
348         while (z < y) 
349         {
350             y = z;
351             z = ((add((x / z),z)) / 2);
352         }
353     }
354     
355     /**
356      * @dev gives square. multiplies x by x
357      */
358     function sq(uint256 x)
359         internal
360         pure
361         returns (uint256)
362     {
363         return (mul(x,x));
364     }
365     
366     /**
367      * @dev x to the power of y 
368      */
369     function pwr(uint256 x, uint256 y)
370         internal 
371         pure 
372         returns (uint256)
373     {
374         if (x==0)
375             return (0);
376         else if (y==0)
377             return (1);
378         else 
379         {
380             uint256 z = x;
381             for (uint256 i=1; i < y; i++)
382                 z = mul(z,x);
383             return (z);
384         }
385     }
386 }