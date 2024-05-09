1 pragma solidity ^0.4.20;
2 
3 /**
4  * @author FadyAro
5  *
6  * 22.07.2018
7  *
8  *
9  */
10 contract Ownable {
11 
12     address public owner;
13 
14     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16     constructor() public {
17         owner = msg.sender;
18     }
19 
20     modifier onlyOwner() {
21         require(msg.sender == owner);
22         _;
23     }
24 
25     function transferOwnership(address newOwner) public onlyOwner {
26         require(newOwner != address(0));
27         emit OwnershipTransferred(owner, newOwner);
28         owner = newOwner;
29     }
30 }
31 
32 contract Pausable is Ownable {
33 
34     event Pause();
35     event Unpause();
36 
37     bool public paused = false;
38 
39     modifier whenNotPaused() {
40         require(!paused, 'Contract Paused!');
41         _;
42     }
43 
44     modifier whenPaused() {
45         require(paused, 'Contract Active!');
46         _;
47     }
48 
49     function pause() onlyOwner whenNotPaused public {
50         paused = true;
51         emit Pause();
52     }
53 
54     function unpause() onlyOwner whenPaused public {
55         paused = false;
56         emit Unpause();
57     }
58 }
59 
60 contract EtherDrop is Pausable {
61 
62     uint constant PRICE_WEI = 2e16;
63 
64     /*
65      * blacklist flag
66      */
67     uint constant FLAG_BLACKLIST = 1;
68 
69     /*
70      * subscription queue size: should be power of 10
71      */
72     uint constant QMAX = 1000;
73 
74     /*
75      * randomness order construction conform to QMAX
76      * e.g. random [0 to 999] is of order 3 => rand = 100*x + 10*y + z
77      */
78     uint constant DMAX = 3;
79 
80     /*
81      * this event is when we have a new subscription
82      * note that it may be fired sequentially just before => NewWinner
83      */
84     event NewDropIn(address addr, uint round, uint place, uint value);
85 
86     /*
87      * this event is when we have a new winner
88      * it is as well a new round start => (round + 1)
89      */
90     event NewWinner(address addr, uint round, uint place, uint value, uint price);
91 
92     struct history {
93 
94         /*
95          * user black listed comment
96          */
97         uint blacklist;
98 
99         /*
100          * user rounds subscriptions number
101          */
102         uint size;
103 
104         /*
105          * array of subscribed rounds indexes
106          */
107         uint[] rounds;
108 
109         /*
110          * array of rounds subscription's inqueue indexes
111          */
112         uint[] places;
113 
114         /*
115          * array of rounds's ether value subscription >= PRICE
116          */
117         uint[] values;
118 
119         /*
120          * array of 0's initially, update to REWARD PRICE in win situations
121          */
122         uint[] prices;
123     }
124 
125     /*
126      * active subscription queue
127      */
128     address[] private _queue;
129 
130     /*
131      * winners history
132      */
133     address[] private _winners;
134 
135     /*
136      * winner comment 32 left
137      */
138     bytes32[] private _wincomma;
139 
140     /*
141      * winner comment 32 right
142      */
143     bytes32[] private _wincommb;
144 
145     /*
146      * winners positions
147      */
148     uint[] private _positions;
149 
150     /*
151      * on which block we got a winner
152      */
153     uint[] private _blocks;
154 
155     /*
156      * active round index
157      */
158     uint public _round;
159 
160     /*
161      * active round queue pointer
162      */
163     uint public _counter;
164 
165     /*
166      * allowed collectibles
167      */
168     uint private _collectibles = 0;
169 
170     /*
171      * users history mapping
172      */
173     mapping(address => history) private _history;
174 
175     /**
176      * get current round details
177      */
178     function currentRound() public view returns (uint round, uint counter, uint round_users, uint price) {
179         return (_round, _counter, QMAX, PRICE_WEI);
180     }
181 
182     /**
183      * get round stats by index
184      */
185     function roundStats(uint index) public view returns (uint round, address winner, uint position, uint block_no) {
186         return (index, _winners[index], _positions[index], _blocks[index]);
187     }
188 
189     /**
190      *
191      * @dev get the total number of user subscriptions
192      *
193      * @param user the specific user
194      *
195      * @return user rounds size
196      */
197     function userRounds(address user) public view returns (uint) {
198         return _history[user].size;
199     }
200 
201     /**
202      *
203      * @dev get user subscription round number details
204      *
205      * @param user the specific user
206      *
207      * @param index the round number
208      *
209      * @return round no, user placing, user drop, user reward
210      */
211     function userRound(address user, uint index) public view returns (uint round, uint place, uint value, uint price) {
212         history memory h = _history[user];
213         return (h.rounds[index], h.places[index], h.values[index], h.prices[index]);
214     }
215 
216     /**
217      * round user subscription
218      */
219     function() public payable whenNotPaused {
220         /*
221          * check subscription price
222          */
223         require(msg.value >= PRICE_WEI, 'Insufficient Ether');
224 
225         /*
226          * start round ahead: on QUEUE_MAX + 1
227          * draw result
228          */
229         if (_counter == QMAX) {
230 
231             uint r = DMAX;
232 
233             uint winpos = 0;
234 
235             _blocks.push(block.number);
236 
237             bytes32 _a = blockhash(block.number - 1);
238 
239             for (uint i = 31; i >= 1; i--) {
240                 if (uint8(_a[i]) >= 48 && uint8(_a[i]) <= 57) {
241                     winpos = 10 * winpos + (uint8(_a[i]) - 48);
242                     if (--r == 0) break;
243                 }
244             }
245 
246             _positions.push(winpos);
247 
248             /*
249              * post out winner rewards
250              */
251             uint _reward = (QMAX * PRICE_WEI * 90) / 100;
252             address _winner = _queue[winpos];
253 
254             _winners.push(_winner);
255             _winner.transfer(_reward);
256 
257             /*
258              * update round history
259              */
260             history storage h = _history[_winner];
261             h.prices[h.size - 1] = _reward;
262 
263             /*
264              * default winner blank comments
265              */
266             _wincomma.push(0x0);
267             _wincommb.push(0x0);
268 
269             /*
270              * log the win event: winpos is the proof, history trackable
271              */
272             emit NewWinner(_winner, _round, winpos, h.values[h.size - 1], _reward);
273 
274             /*
275              * update collectibles
276              */
277             _collectibles += address(this).balance - _reward;
278 
279             /*
280              * reset counter
281              */
282             _counter = 0;
283 
284             /*
285              * increment round
286              */
287             _round++;
288         }
289 
290         h = _history[msg.sender];
291 
292         /*
293          * user is not allowed to subscribe twice
294          */
295         require(h.size == 0 || h.rounds[h.size - 1] != _round, 'Already In Round');
296 
297         /*
298          * create user subscription: N.B. places[_round] is the result proof
299          */
300         h.size++;
301         h.rounds.push(_round);
302         h.places.push(_counter);
303         h.values.push(msg.value);
304         h.prices.push(0);
305 
306         /*
307          * initial round is a push, others are 'on set' index
308          */
309         if (_round == 0) {
310             _queue.push(msg.sender);
311         } else {
312             _queue[_counter] = msg.sender;
313         }
314 
315         /*
316          * log subscription
317          */
318         emit NewDropIn(msg.sender, _round, _counter, msg.value);
319 
320         /*
321          * increment counter
322          */
323         _counter++;
324     }
325 
326     /**
327      *
328      * @dev let the user comment 64 letters for a winning round
329      *
330      * @param round the winning round
331      *
332      * @param a the first 32 letters comment
333      *
334      * @param b the second 32 letters comment
335      *
336      * @return user comment
337      */
338     function comment(uint round, bytes32 a, bytes32 b) whenNotPaused public {
339 
340         address winner = _winners[round];
341 
342         require(winner == msg.sender, 'not a winner');
343         require(_history[winner].blacklist != FLAG_BLACKLIST, 'blacklisted');
344 
345         _wincomma[round] = a;
346         _wincommb[round] = b;
347     }
348 
349 
350     /**
351      *
352      * @dev blacklist a user for its comments behavior
353      *
354      * @param user address
355      *
356      */
357     function blackList(address user) public onlyOwner {
358         history storage h = _history[user];
359         if (h.size > 0) {
360             h.blacklist = FLAG_BLACKLIST;
361         }
362     }
363 
364     /**
365     *
366     * @dev get the user win round comment
367     *
368     * @param round the winning round number
369     *
370     * @return user comment
371     */
372     function userComment(uint round) whenNotPaused public view returns (address winner, bytes32 comma, bytes32 commb) {
373         if (_history[_winners[round]].blacklist != FLAG_BLACKLIST) {
374             return (_winners[round], _wincomma[round], _wincommb[round]);
375         } else {
376             return (0x0, 0x0, 0x0);
377         }
378     }
379 
380     /*
381      * etherdrop team R&D support collectibles
382      */
383     function collect() public onlyOwner {
384         owner.transfer(_collectibles);
385     }
386 }