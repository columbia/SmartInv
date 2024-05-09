1 pragma solidity ^0.4.24;
2 /** title -LuckyETH- v0.1.0
3 * ┌┬┐┌─┐┌─┐┌┬┐  ╦    ╦  ┌─┐┬─┐┌─┐┌─┐┌─┐┌┐┌┌┬┐┌─┐ 
4 *  │ ├┤ ├─┤│││   ║  ║   ├─┘├┬┘├┤ └─┐├┤ │││ │ └─┐
5 *  ┴ └─┘┴ ┴┴ ┴    ╚╝    ┴  ┴└─└─┘└─┘└─┘┘└┘ ┴ └─┘  
6 */
7 
8 //==============================================================================
9 //     _    _  _ _|_ _  .
10 //    (/_\/(/_| | | _\  .
11 //==============================================================================
12 contract LuckyEvents {
13     // fired at end of buy
14     event onEndTx
15     (
16         address player,
17         uint256 playerID,
18         uint256 ethIn,
19         address wonAddress,
20         uint256 wonAmount,          // amount won
21         uint256 genAmount,          // amount distributed to gen
22         uint256 airAmount          // amount added to airdrop
23     );
24     
25 	// fired whenever theres a withdraw
26     event onWithdraw
27     (
28         uint256 indexed playerID,
29         address playerAddress,
30         uint256 ethOut,
31         uint256 timeStamp
32     );
33 }
34 
35 //==============================================================================
36 //   __|_ _    __|_ _  .
37 //  _\ | | |_|(_ | _\  .
38 //==============================================================================
39 library LuckyDatasets {
40     struct EventReturns {
41         address player;
42         uint256 playerID;
43         uint256 ethIn;
44         address wonAddress;         // address won
45         uint256 wonAmount;          // amount won
46         uint256 genAmount;          // amount distributed to gen
47         uint256 airAmount;          // amount added to airdrop
48     }
49 }
50 
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58   address public owner;
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 }
76 
77 contract LuckyETH is LuckyEvents, Ownable  {
78     using SafeMath for *;
79     
80 //==============================================================================
81 //     _ _  _  |`. _     _ _ |_ | _  _  .
82 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
83 //=================_|===========================================================
84     string constant public name = "Lucky ETH";
85     string constant public symbol = "L";
86 //****************
87 // Pot DATA 
88 //****************
89     uint256 public pIndex; // the index for next player
90 //==============================================================================
91 //     _| _ _|_ _    _ _ _|_    _   .
92 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store distributed info that changes)
93 //=============================|================================================
94 	uint256 public genPot_;             // distributed pot for all players
95 //==============================================================================
96 //     _| _ _|_ _    _ _ _|_    _   .
97 //    (_|(_| | (_|  _\(/_ | |_||_)  .  (data used to store airdrop info that changes)
98 //=============================|================================================
99 	uint256 public airDropPot_;             // person who gets the airdrop wins part of this pot
100     uint256 public airDropTracker_ = 0;     // incremented each time a "qualified" tx occurs.  used to determine winning air drop
101 //****************
102 // PLAYER DATA 
103 //****************
104     mapping (address => uint256) public pIDxAddr_;          // (addr => pID) returns player id by address
105     mapping (address => address) public pAff_;              // (addr => affAddr)
106 //****************
107 // TEAM FEE DATA 
108 //****************
109     // TeamV act as player
110     address public teamV;
111 //==============================================================================
112 //     _ _  _  __|_ _    __|_ _  _  .
113 //    (_(_)| |_\ | | |_|(_ | (_)|   .  (initial data setup upon contract deploy)
114 //==============================================================================
115     constructor()
116         public
117     {
118         // player id start from 1
119         pIndex = 1;
120 	}
121 
122 //==============================================================================
123 //     _ _  _  _|. |`. _  _ _  .
124 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
125 //==============================================================================
126     /**
127      * @dev prevents contracts from interacting with fomo3d 
128      */
129     modifier isHuman() {
130         address _addr = msg.sender;
131         require (_addr == tx.origin);
132         
133         uint256 _codeLength;
134         
135         assembly {_codeLength := extcodesize(_addr)}
136         require(_codeLength == 0, "sorry humans only");
137         _;
138     }
139 
140     /**
141      * @dev sets boundaries for incoming tx 
142      */
143     modifier isWithinLimits(uint256 _eth) {
144         require(_eth >= 1000000000, "pocket lint: not a valid currency"); /** 1Gwei **/
145         require(_eth <= 100000000000000000000000, "no vitalik, no");    /** 1 KEth **/
146 		_;    
147 	}
148 	
149 //==============================================================================
150 //     _    |_ |. _   |`    _  __|_. _  _  _  .
151 //    |_)|_||_)||(_  ~|~|_|| |(_ | |(_)| |_\  .  (use these to interact with contract)
152 //====|=========================================================================
153 
154     function ()
155         isHuman()
156         isWithinLimits(msg.value)
157         public
158         payable
159     {
160         address _affAddr = address(0);
161         if (pAff_[msg.sender] != address(0)) {
162             _affAddr = pAff_[msg.sender];
163         }
164         core(msg.sender, msg.value, _affAddr);
165     }
166     
167     /**
168      * @dev converts all incoming ethereum to keys.
169      * -functionhash- 0x98a0871d (using address for affiliate)
170      * @param _affAddr the address of the player who gets the affiliate fee
171      */
172     function buy(address _affAddr)
173         isHuman()
174         isWithinLimits(msg.value)
175         public
176         payable
177     {
178         if (_affAddr == address(0)) {
179             _affAddr = pAff_[msg.sender];
180         } else {
181             pAff_[msg.sender] = _affAddr;
182         }
183         core(msg.sender, msg.value, _affAddr);
184     }
185     
186     /**
187      * @dev withdraws all of your earnings.
188      * -functionhash- 0x3ccfd60b
189      */
190     function withdraw()
191         isHuman()
192         public
193     {
194        playerWithdraw(msg.sender);
195     }
196     
197     /**
198      * @dev updateTeamV withdraw and buy
199      */
200     function updateTeamV(address _team)
201         onlyOwner()
202         public
203     {
204         if (teamV != address(0)) {
205            playerWithdraw(teamV);
206         }
207         core(_team, 0, address(0));
208         teamV = _team;
209     }
210     
211     /**
212      * @dev this is the core logic for any buy
213      * is live.
214      */
215     function core(address _pAddr, uint256 _eth, address _affAddr)
216         private
217     {
218         // set up our tx event data
219         LuckyDatasets.EventReturns memory _eventData_;
220         _eventData_.player = _pAddr;
221         
222         uint256 _pID =  pIDxAddr_[_pAddr];
223         if (_pID == 0) {
224             _pID = pIndex;
225             pIndex = pIndex.add(1);
226             pIDxAddr_[_pAddr] = _pID;
227         }
228          _eventData_.playerID = _pID;
229          _eventData_.ethIn = _eth;
230         
231         // manage airdrops
232         if (_eth >= 100000000000000000)
233         {
234             airDropTracker_++;
235             if (airdrop() == true)
236             {
237                 // gib muni
238                 uint256 _prize = 0;
239                 if (_eth >= 10000000000000000000)
240                 {
241                     // calculate prize
242                     _prize = ((airDropPot_).mul(75)) / 100;
243                 } else if (_eth >= 1000000000000000000 && _eth < 10000000000000000000) {
244                     // calculate prize
245                     _prize = ((airDropPot_).mul(50)) / 100;
246                 } else if (_eth >= 100000000000000000 && _eth < 1000000000000000000) {
247                     // calculate prize
248                     _prize = ((airDropPot_).mul(25)) / 100;
249                 }
250                 
251                 // adjust airDropPot 
252                 airDropPot_ = (airDropPot_).sub(_prize);
253                     
254                 // give prize to winner
255                 _pAddr.transfer(_prize);
256                     
257                 // set airdrop happened bool to true
258                 _eventData_.wonAddress = _pAddr;
259                 // let event know how much was won 
260                 _eventData_.wonAmount = _prize;
261                 
262                 
263                 // reset air drop tracker
264                 airDropTracker_ = 0;
265             }
266         }
267         
268         // 20% for affiliate share fee
269         uint256 _aff = _eth / 5;
270         // 30% for _distributed rewards
271         uint256 _gen = _eth.mul(30) / 100;
272         // 50% for pot
273         uint256 _airDrop = _eth.sub(_aff.add(_gen));
274        
275         // distributeExternal
276         uint256 _affID = pIDxAddr_[_affAddr];
277         if (_affID != 0 && _affID != _pID) {
278             _affAddr.transfer(_aff);
279         } else {
280             _airDrop = _airDrop.add(_aff);
281         }
282 
283         airDropPot_ = airDropPot_.add(_airDrop);
284         genPot_ = genPot_.add(_gen);
285 
286         // set up event data
287         _eventData_.genAmount = _gen;
288         _eventData_.airAmount = _airDrop;
289 
290         // call end tx function to fire end tx event.
291         endTx(_eventData_);
292     }
293     
294     function airdrop()
295         private 
296         view 
297         returns(bool)
298     {
299         uint256 seed = uint256(keccak256(abi.encodePacked(
300             
301             (block.timestamp).add
302             (block.difficulty).add
303             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
304             (block.gaslimit).add
305             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
306             (block.number)
307             
308         )));
309         if((seed - ((seed / 1000) * 1000)) <= airDropTracker_)
310             return(true);
311         else
312             return(false);
313     }
314     
315     /**
316      * @dev prepares compression data and fires event for buy or reload tx's
317      */
318     function endTx(LuckyDatasets.EventReturns memory _eventData_)
319         private
320     {
321         emit LuckyEvents.onEndTx
322         (
323             _eventData_.player,
324             _eventData_.playerID,
325             _eventData_.ethIn,
326             _eventData_.wonAddress,
327             _eventData_.wonAmount,
328             _eventData_.genAmount,
329             _eventData_.airAmount
330         );
331     }
332     
333       /**
334      * @dev withdraws all of your earnings.
335      * -functionhash- 0x3ccfd60b
336      */
337     function playerWithdraw(address _pAddr)
338         private
339     {
340         // grab time
341         uint256 _now = now;
342         
343         // player 
344         uint256 _pID =  pIDxAddr_[_pAddr];
345         require(_pID != 0, "no, no, no...");
346         delete(pIDxAddr_[_pAddr]);
347         delete(pAff_[_pAddr]);
348         pIDxAddr_[_pAddr] = 0; // oh~~
349         
350          // set up our tx event data
351         LuckyDatasets.EventReturns memory _eventData_;
352         _eventData_.player = _pAddr;
353         
354         // setup local rID
355         uint256 _pIndex = pIndex;
356         uint256 _gen = genPot_;
357         uint256 _sum = _pIndex.mul(_pIndex.sub(1)) / 2;
358         uint256 _percent = _pIndex.sub(1).sub(_pID);
359         assert(_percent < _pIndex);
360         _percent = _gen.mul(_percent) / _sum;
361         
362         genPot_ = genPot_.sub(_percent);
363         _pAddr.transfer(_percent);
364         
365         
366         // fire withdraw event
367         emit LuckyEvents.onWithdraw(_pID, _pAddr, _percent, _now);
368         
369     }
370 }
371 
372 /**
373  * @title SafeMath v0.1.9
374  * @dev Math operations with safety checks that throw on error
375  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
376  * - added sqrt
377  * - added sq
378  * - added pwr 
379  * - changed asserts to requires with error log outputs
380  * - removed div, its useless
381  */
382 library SafeMath {
383     
384     /**
385     * @dev Multiplies two numbers, throws on overflow.
386     */
387     function mul(uint256 a, uint256 b) 
388         internal 
389         pure 
390         returns (uint256 c) 
391     {
392         if (a == 0) {
393             return 0;
394         }
395         c = a * b;
396         require(c / a == b, "SafeMath mul failed");
397         return c;
398     }
399 
400     /**
401     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
402     */
403     function sub(uint256 a, uint256 b)
404         internal
405         pure
406         returns (uint256) 
407     {
408         require(b <= a, "SafeMath sub failed");
409         return a - b;
410     }
411 
412     /**
413     * @dev Adds two numbers, throws on overflow.
414     */
415     function add(uint256 a, uint256 b)
416         internal
417         pure
418         returns (uint256 c) 
419     {
420         c = a + b;
421         require(c >= a, "SafeMath add failed");
422         return c;
423     }
424     
425     /**
426      * @dev gives square root of given x.
427      */
428     function sqrt(uint256 x)
429         internal
430         pure
431         returns (uint256 y) 
432     {
433         uint256 z = ((add(x,1)) / 2);
434         y = x;
435         while (z < y) 
436         {
437             y = z;
438             z = ((add((x / z),z)) / 2);
439         }
440     }
441     
442     /**
443      * @dev gives square. multiplies x by x
444      */
445     function sq(uint256 x)
446         internal
447         pure
448         returns (uint256)
449     {
450         return (mul(x,x));
451     }
452     
453     /**
454      * @dev x to the power of y 
455      */
456     function pwr(uint256 x, uint256 y)
457         internal 
458         pure 
459         returns (uint256)
460     {
461         if (x==0)
462             return (0);
463         else if (y==0)
464             return (1);
465         else 
466         {
467             uint256 z = x;
468             for (uint256 i=1; i < y; i++)
469                 z = mul(z,x);
470             return (z);
471         }
472     }
473 }