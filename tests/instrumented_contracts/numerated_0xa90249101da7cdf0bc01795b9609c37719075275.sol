1 pragma solidity ^0.5.2;
2 
3 /*
4 *
5 * WELCOME TO THE SUSTAINABLE UPSWEEP NETWORK
6 *
7 *                  upsweep.net
8 *
9 * Gambling with low gas fees, no edge and no leaks.  
10 *
11 *   
12 *                _19^^^^0^^^^1_
13 *             .18''           ``2.
14 *           .17'      
15 *          .16'   Here's to the   `3.
16 *         .15'      unfolding      `4.
17 *         ::         of hope.       ::
18 *         ::  ...................   ::
19 *         ::                        ::
20 *         `14.       @author       .5'
21 *          `13.  symmetricproof   .6'
22 *           `12.                .7'
23 *             `11..          ..8'
24 *                ^10........9^
25 *                    ''''     
26 *
27 *
28 /* @title The Upsweep Network; a social and sustainable circle of bets.
29 */
30 
31 contract UpsweepV1 {
32 
33     uint public elapsed;
34     uint public timeout;
35     uint public lastId;
36     uint public counter;
37     bool public closed;
38     
39     struct Player {
40         bool revealOnce;
41         bool claimed;
42         bool gotHonour;
43         uint8 i;
44         bytes32 commit;
45     }
46 
47     mapping(uint => mapping (address => Player)) public player;
48     mapping(uint => uint8[20]) public balancesById;   
49     mapping(uint => uint8[20]) public bottleneckById;
50     
51     address payable public owner = msg.sender;
52     uint public ticketPrice = 100000000000000000;
53     
54     mapping(uint => uint) public honour;
55     
56     event FirstBlock(uint);
57     event LastBlock(uint);
58     event Join(uint);
59     event Reveal(uint seat, uint indexed gameId);
60     event NewId(uint);
61     
62     modifier onlyBy(address _account)
63     {
64         require(
65             msg.sender == _account,
66             "Sender not authorized."
67         );
68         _;
69     }
70     
71     modifier circleIsPrivate(bool _closed) {
72         require(
73             _closed == true,
74             "Game is in progress."
75         );
76         _;
77     }
78     
79     modifier circleIsPublic(bool _closed) {
80         require(
81             _closed == false,
82             "Next game has not started."
83         );
84         _;
85     } 
86     
87     modifier onlyAfter(uint _time) {
88         require(
89             block.number > _time,
90             "Function called too early."
91         );
92         _;
93     }
94     
95     modifier onlyBefore(uint _time) {
96         require(
97             block.number <= _time,
98             "Function called too late."
99         );
100         _;
101     }
102     
103     modifier ticketIsAffordable(uint _amount) {
104         require(
105             msg.value >= _amount,
106             "Not enough Ether provided."
107         );
108         _;
109         if (msg.value > _amount)
110             msg.sender.transfer(msg.value - _amount);
111     }
112     
113     /**
114     * @dev pick a number and cast the hash to the network. 
115     * @param _hash is the keccak256 output for the address of the message sender+
116     * the number + a passphrase
117     */
118     function join(bytes32 _hash)
119         public
120         payable
121         circleIsPublic(closed)
122         ticketIsAffordable(ticketPrice)
123         returns (uint gameId)
124     {
125         //the circle is only open to 40 players.
126         require(
127             counter < 40,       
128             "Game is full."
129         );            
130         
131         //timer starts when the first ticket of the game is sold
132         if (counter == 0) {
133             elapsed = block.number;
134             emit FirstBlock(block.number);
135         }
136 
137         player[lastId][msg.sender].commit = _hash;
138         
139         //when the game is full, timer stops and the countdown to reveal begins
140         //NO MORE COMMITS ARE RECEIVED.
141         if (counter == 39) {       
142             closed = true;
143             uint temp = sub(block.number,elapsed);
144             timeout = add(temp,block.number);
145             emit LastBlock(timeout);
146         } 
147         
148         counter++;
149 
150         emit Join(counter);
151         return lastId;
152     }
153    
154      /**
155     * @notice get a refund and exit the game before it begins
156     */
157     function abandon()
158         public
159         circleIsPublic(closed)
160         returns (bool success)
161     {
162         bytes32 commit = player[lastId][msg.sender].commit;
163         require(
164             commit != 0,
165             "Player was not in the game."
166         );
167         
168         player[lastId][msg.sender].commit = 0;
169         counter --;
170         if (counter == 0) {
171             elapsed = 0;
172             emit FirstBlock(0);
173         }    
174         emit Join(counter);
175         msg.sender.transfer(ticketPrice);
176         return true;
177     }     
178     /**
179     * @notice to make your bet legal, you must reveal the corresponding number
180     * @dev a new hash is computed to verify authenticity of the bet
181     * @param i is the number (between 0 and 19)
182     * @param passphrase to prevent brute-force validation
183     */
184     function reveal(
185         uint8 i, 
186         string memory passphrase 
187     )
188         public 
189         circleIsPrivate(closed)
190         onlyBefore(timeout)
191         returns (bool success)
192     {
193         bool status = player[lastId][msg.sender].revealOnce;
194         require(
195             status == false,
196             "Player already revealed."
197         );
198         
199         bytes32 commit = player[lastId][msg.sender].commit;
200  
201         //hash is recalculated to verify authenticity
202         bytes32 hash = keccak256(
203             abi.encodePacked(msg.sender,i,passphrase)
204         );
205             
206         require(
207             hash == commit,
208             "Hashes don't match."
209         );
210         
211         player[lastId][msg.sender].revealOnce = true;
212         player[lastId][msg.sender].i = i;
213         
214         //contribution is credited to the chosen number
215         balancesById[lastId][i] ++;
216         //the list of players inside this numbers grows by one
217         bottleneckById[lastId][i] ++;
218         
219         counter--;
220         //last player to reveal must pay extra gas fees to update the game 
221         if (counter == 0) {
222             timeout = 0;
223             updateBalances();
224         }
225         
226         emit Reveal(i,lastId);
227         return true;
228     }
229   
230     /**
231     * @notice distributes rewards fairly.
232     * @dev the circle has no head or foot, node 19 passes to node 0 only if node 0 is not empty.
233     * To successfully distribute contributions, the function loops through all numbers and 
234     * identifies the first empty number, from there the chain of transfers begins. 
235     * 
236     */
237     function updateBalances()
238         public
239         circleIsPrivate(closed)
240         onlyAfter(timeout)
241         returns (bool success)
242     {
243         // identify the first empty number.
244         for (uint8 i = 0; i < 20; i++) {
245             if (balancesById[lastId][i] == 0) { 
246                 // start chain of transfers from the next number.
247                 uint j = i + 1;
248                 for (uint8 a = 0; a < 19; a++) {   
249                     if (j == 20) j = 0;
250                     if (j == 19) {       
251                         if (balancesById[lastId][0] > 0) {
252                             uint8 temp = balancesById[lastId][19];
253                             balancesById[lastId][19] = 0;
254                             balancesById[lastId][0] += temp;  
255                             j = 0; 
256                         } else {
257                             j = 1;
258                         }
259                     } else {            
260                         if (balancesById[lastId][j + 1] > 0) { 
261                             uint8 temp = balancesById[lastId][j];
262                             balancesById[lastId][j] = 0;
263                             balancesById[lastId][j + 1] += temp; 
264                             j += 1; 
265                         } else { 
266                             j += 2; 
267                         }
268                     }
269                 }
270                 // will break when all balances are updated.
271                 break;
272             }
273         }
274         // reset variables and start a new game.
275         closed = false;
276         if (timeout > 0) timeout = 0;
277         elapsed = 0;
278         // players that reveal are rewarded the ticket value of those
279         // that don't reveal.
280         if (counter > 0) {
281             uint total = mul(counter, ticketPrice);
282             uint among = sub(40,counter);
283             honour[lastId] = div(total,among);
284             counter = 0;
285         } 
286         lastId ++;
287         emit NewId(lastId);
288         return true;
289     }
290     
291     /**
292     * @notice accumulated rewards are already allocated in specific numbers, if players can
293     * prove they picked that "lucky" number, they are allowed to withdraw the accumulated
294     * ether.
295     * 
296     * If there is more than one player in a given number, the reward is split equally. 
297     * 
298     * @param gameId only attempt to withdraw rewards from a valid game, otherwise the transaction
299     * will fail.
300     */
301     function withdraw(uint gameId) 
302         public
303         returns (bool success)
304     {
305         bool status = player[gameId][msg.sender].revealOnce;
306         require(
307             status == true,
308             "Player has not revealed."
309         );
310         
311         bool claim = player[gameId][msg.sender].claimed;
312         require(
313             claim == false,
314             "Player already claimed."
315         );
316         
317         uint8 index = player[gameId][msg.sender].i;
318         require(
319             balancesById[gameId][index] > 0,
320             "Player didn't won."
321         );
322         
323         player[gameId][msg.sender].claimed = true;
324         
325         uint temp = uint(balancesById[gameId][index]);
326         uint among = uint(bottleneckById[gameId][index]);
327         uint total = mul(temp, ticketPrice);
328         uint payout = div(total, among);
329         
330         msg.sender.transfer(payout);   
331         
332         return true;
333     }   
334     
335     function microTip()
336         public
337         payable
338         returns (bool success)
339     {
340         owner.transfer(msg.value);
341         return true;
342     }
343     
344     function changeOwner(address payable _newOwner)
345         public
346         onlyBy(owner)
347         returns (bool success)
348     {
349         owner = _newOwner;
350         return true;
351     }
352     
353     function getHonour(uint _gameId)
354         public
355         returns (bool success)
356     {
357         bool status = player[_gameId][msg.sender].gotHonour;
358         require(
359             status == false,
360             "Player already claimed honour."
361         );
362         bool revealed = player[_gameId][msg.sender].revealOnce;
363         require(
364             revealed == true,
365             "Player has not revealed."
366         );
367         player[_gameId][msg.sender].gotHonour = true;
368         msg.sender.transfer(honour[_gameId]);
369         return true;
370     }
371     
372     /**
373     * @dev Multiplies two numbers, reverts on overflow.
374     */
375     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
376         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
377         // benefit is lost if 'b' is also tested.
378         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
379         if (a == 0) {
380             return 0;
381         }
382 
383         uint256 c = a * b;
384         require(c / a == b);
385 
386         return c;
387     }
388 
389     /**
390     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
391     */
392     function div(uint256 a, uint256 b) internal pure returns (uint256) {
393         // Solidity only automatically asserts when dividing by 0
394         require(b > 0);
395         uint256 c = a / b;
396         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
397 
398         return c;
399     }
400 
401     /**
402     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
403     */
404     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
405         require(b <= a);
406         uint256 c = a - b;
407 
408         return c;
409     }
410 
411     /**
412     * @dev Adds two numbers, reverts on overflow.
413     */
414     function add(uint256 a, uint256 b) internal pure returns (uint256) {
415         uint256 c = a + b;
416         require(c >= a);
417 
418         return c;
419     }
420 
421     /**
422     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
423     * reverts when dividing by zero.
424     */
425     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
426         require(b != 0);
427         return a % b;
428     }
429 
430 
431 }