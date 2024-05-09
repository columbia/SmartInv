1 pragma solidity ^0.4.23;
2 
3 /**
4 A PennyAuction-like game to win a prize.
5 
6 UI: https://www.pennyether.com
7 
8 How it works:
9     - An initial prize is held in the Contract
10     - Anyone may overthrow the Monarch by paying a small fee.
11         - They become the Monarch
12         - The "reign" timer is reset to N.
13         - The prize may be increased or decreased
14     - If nobody overthrows the new Monarch in N blocks, the Monarch wins.
15 
16 For fairness, an "overthrow" is refunded if:
17     - The incorrect amount is sent.
18     - The game is already over.
19     - The overthrower is already the Monarch.
20     - Another overthrow occurred in the same block
21         - Note: Here, default gas is used for refund. On failure, fee is kept.
22 
23 Other notes:
24     - .sendFees(): Sends accrued fees to "collector", at any time.
25     - .sendPrize(): If game is ended, sends prize to the Monarch.
26 */
27 contract MonarchyGame {
28     // We store values as GWei to reduce storage to 64 bits.
29     // int64: 2^63 GWei is ~ 9 billion Ether, so no overflow risk.
30     //
31     // For blocks, we use uint32, which has a max value of 4.3 billion
32     // At a 1 second block time, there's a risk of overflow in 120 years.
33     //
34     // We put these variables together because they are all written to
35     // on each bid. This should save some gas when we write.
36     struct Vars {
37         // [first 256-bit segment]
38         address monarch;        // address of monarch
39         uint64 prizeGwei;       // (Gwei) the current prize
40         uint32 numOverthrows;   // total number of overthrows
41 
42         // [second 256-bit segment]
43         uint32 blockEnded;      // the time at which no further overthrows can occur  
44         uint32 prevBlock;       // block of the most recent overthrow
45         bool isPaid;            // whether or not the winner has been paid
46         bytes23 decree;         // 23 leftover bytes for decree
47     }
48 
49     // These values are set on construction and don't change.
50     // We store in a struct for gas-efficient reading/writing.
51     struct Settings {
52         // [first 256-bit segment]
53         address collector;       // address that fees get sent to
54         uint64 initialPrizeGwei; // (Gwei > 0) amt initially staked
55         // [second 256-bit segment]
56         uint64 feeGwei;          // (Gwei > 0) cost to become the Monarch
57         int64 prizeIncrGwei;     // amount added/removed to prize on overthrow
58         uint32 reignBlocks;      // number of blocks Monarch must reign to win
59     }
60 
61     Vars vars;
62     Settings settings;
63     uint constant version = 1;
64 
65     event SendPrizeError(uint time, string msg);
66     event Started(uint time, uint initialBlocks);
67     event OverthrowOccurred(uint time, address indexed newMonarch, bytes23 decree, address indexed prevMonarch, uint fee);
68     event OverthrowRefundSuccess(uint time, string msg, address indexed recipient, uint amount);
69     event OverthrowRefundFailure(uint time, string msg, address indexed recipient, uint amount);
70     event SendPrizeSuccess(uint time, address indexed redeemer, address indexed recipient, uint amount, uint gasLimit);
71     event SendPrizeFailure(uint time, address indexed redeemer, address indexed recipient, uint amount, uint gasLimit);
72     event FeesSent(uint time, address indexed collector, uint amount);
73 
74     constructor(
75         address _collector,
76         uint _initialPrize,
77         uint _fee,
78         int _prizeIncr,
79         uint _reignBlocks,
80         uint _initialBlocks
81     )
82         public
83         payable
84     {
85         require(_initialPrize >= 1e9);                // min value of 1 GWei
86         require(_initialPrize < 1e6 * 1e18);          // max value of a million ether
87         require(_initialPrize % 1e9 == 0);            // even amount of GWei
88         require(_fee >= 1e6);                         // min value of 1 GWei
89         require(_fee < 1e6 * 1e18);                   // max value of a million ether
90         require(_fee % 1e9 == 0);                     // even amount of GWei
91         require(_prizeIncr <= int(_fee));             // max value of _bidPrice
92         require(_prizeIncr >= -1*int(_initialPrize)); // min value of -1*initialPrize
93         require(_prizeIncr % 1e9 == 0);               // even amount of GWei
94         require(_reignBlocks >= 1);                   // minimum of 1 block
95         require(_initialBlocks >= 1);                 // minimum of 1 block
96         require(msg.value == _initialPrize);          // must've sent the prize amount
97 
98         // Set instance variables. these never change.
99         // These can be safely cast to int64 because they are each < 1e24 (see above),
100         // 1e24 divided by 1e9 is 1e15. Max int64 val is ~1e19, so plenty of room.
101         // For block numbers, uint32 is good up to ~4e12, a long time from now.
102         settings.collector = _collector;
103         settings.initialPrizeGwei = uint64(_initialPrize / 1e9);
104         settings.feeGwei = uint64(_fee / 1e9);
105         settings.prizeIncrGwei = int64(_prizeIncr / 1e9);
106         settings.reignBlocks = uint32(_reignBlocks);
107 
108         // Initialize the game variables.
109         vars.prizeGwei = settings.initialPrizeGwei;
110         vars.monarch = _collector;
111         vars.prevBlock = uint32(block.number);
112         vars.blockEnded = uint32(block.number + _initialBlocks);
113 
114         emit Started(now, _initialBlocks);
115     }
116 
117 
118     /*************************************************************/
119     /********** OVERTHROWING *************************************/
120     /*************************************************************/
121     //
122     // Upon new bid, adds fees and increments time and prize.
123     //  - Refunds if overthrow is too late, user is already monarch, or incorrect value passed.
124     //  - Upon an overthrow-in-same-block, refends previous monarch.
125     //
126     // Gas Cost: 34k - 50k
127     //     Overhead: 25k
128     //       - 23k: tx overhead
129     //       -  2k: SLOADs, execution
130     //     Failure: 34k
131     //       - 25k: overhead
132     //       -  7k: send refund
133     //       -  2k: event: OverthrowRefundSuccess
134     //     Clean: 37k
135     //       - 25k: overhead
136     //       - 10k: update Vars (monarch, numOverthrows, prize, blockEnded, prevBlock, decree)
137     //       -  2k: event: OverthrowOccurred
138     //     Refund Success: 46k
139     //       - 25k: overhead
140     //       -  7k: send
141     //       - 10k: update Vars (monarch, decree)
142     //       -  2k: event: OverthrowRefundSuccess
143     //       -  2k: event: OverthrowOccurred
144     //     Refund Failure: 50k
145     //       - 25k: overhead
146     //       - 11k: send failure
147     //       - 10k: update Vars (monarch, numOverthrows, prize, decree)
148     //       -  2k: event: OverthrowRefundFailure
149     //       -  2k: event: OverthrowOccurred
150     function()
151         public
152         payable
153     {
154         overthrow(0);
155     }
156 
157     function overthrow(bytes23 _decree)
158         public
159         payable
160     {
161         if (isEnded())
162             return errorAndRefund("Game has already ended.");
163         if (msg.sender == vars.monarch)
164             return errorAndRefund("You are already the Monarch.");
165         if (msg.value != fee())
166             return errorAndRefund("Value sent must match fee.");
167 
168         // compute new values. hopefully optimizer reads from vars/settings just once.
169         int _newPrizeGwei = int(vars.prizeGwei) + settings.prizeIncrGwei;
170         uint32 _newBlockEnded = uint32(block.number) + settings.reignBlocks;
171         uint32 _newNumOverthrows = vars.numOverthrows + 1;
172         address _prevMonarch = vars.monarch;
173         bool _isClean = (block.number != vars.prevBlock);
174 
175         // Refund if _newPrize would end up being < 0.
176         if (_newPrizeGwei < 0)
177             return errorAndRefund("Overthrowing would result in a negative prize.");
178 
179         // Attempt refund, if necessary. Use minimum gas.
180         bool _wasRefundSuccess;
181         if (!_isClean) {
182             _wasRefundSuccess = _prevMonarch.send(msg.value);   
183         }
184 
185         // These blocks can be made nicer, but optimizer will
186         //  sometimes do two updates instead of one. Seems it is
187         //  best to keep if/else trees flat.
188         if (_isClean) {
189             vars.monarch = msg.sender;
190             vars.numOverthrows = _newNumOverthrows;
191             vars.prizeGwei = uint64(_newPrizeGwei);
192             vars.blockEnded = _newBlockEnded;
193             vars.prevBlock = uint32(block.number);
194             vars.decree = _decree;
195         }
196         if (!_isClean && _wasRefundSuccess){
197             // when a refund occurs, we just swap winners.
198             // overthrow count and prize do not get reset.
199             vars.monarch = msg.sender;
200             vars.decree = _decree;
201         }
202         if (!_isClean && !_wasRefundSuccess){
203             vars.monarch = msg.sender;   
204             vars.prizeGwei = uint64(_newPrizeGwei);
205             vars.numOverthrows = _newNumOverthrows;
206             vars.decree = _decree;
207         }
208 
209         // Emit the proper events.
210         if (!_isClean){
211             if (_wasRefundSuccess)
212                 emit OverthrowRefundSuccess(now, "Another overthrow occurred on the same block.", _prevMonarch, msg.value);
213             else
214                 emit OverthrowRefundFailure(now, ".send() failed.", _prevMonarch, msg.value);
215         }
216         emit OverthrowOccurred(now, msg.sender, _decree, _prevMonarch, msg.value);
217     }
218         // called from the bidding function above.
219         // refunds sender, or throws to revert entire tx.
220         function errorAndRefund(string _msg)
221             private
222         {
223             require(msg.sender.call.value(msg.value)());
224             emit OverthrowRefundSuccess(now, _msg, msg.sender, msg.value);
225         }
226 
227 
228     /*************************************************************/
229     /********** PUBLIC FUNCTIONS *********************************/
230     /*************************************************************/
231 
232     // Sends prize to the current winner using _gasLimit (0 is unlimited)
233     function sendPrize(uint _gasLimit)
234         public
235         returns (bool _success, uint _prizeSent)
236     {
237         // make sure game has ended, and is not paid
238         if (!isEnded()) {
239             emit SendPrizeError(now, "The game has not ended.");
240             return (false, 0);
241         }
242         if (vars.isPaid) {
243             emit SendPrizeError(now, "The prize has already been paid.");
244             return (false, 0);
245         }
246 
247         address _winner = vars.monarch;
248         uint _prize = prize();
249         bool _paySuccessful = false;
250 
251         // attempt to pay winner (use full gas if _gasLimit is 0)
252         vars.isPaid = true;
253         if (_gasLimit == 0) {
254             _paySuccessful = _winner.call.value(_prize)();
255         } else {
256             _paySuccessful = _winner.call.value(_prize).gas(_gasLimit)();
257         }
258 
259         // emit proper event. rollback .isPaid on failure.
260         if (_paySuccessful) {
261             emit SendPrizeSuccess({
262                 time: now,
263                 redeemer: msg.sender,
264                 recipient: _winner,
265                 amount: _prize,
266                 gasLimit: _gasLimit
267             });
268             return (true, _prize);
269         } else {
270             vars.isPaid = false;
271             emit SendPrizeFailure({
272                 time: now,
273                 redeemer: msg.sender,
274                 recipient: _winner,
275                 amount: _prize,
276                 gasLimit: _gasLimit
277             });
278             return (false, 0);          
279         }
280     }
281     
282     // Sends accrued fees to the collector. Callable by anyone.
283     function sendFees()
284         public
285         returns (uint _feesSent)
286     {
287         _feesSent = fees();
288         if (_feesSent == 0) return;
289         require(settings.collector.call.value(_feesSent)());
290         emit FeesSent(now, settings.collector, _feesSent);
291     }
292 
293 
294 
295     /*************************************************************/
296     /********** PUBLIC VIEWS *************************************/
297     /*************************************************************/
298 
299     // Expose all Vars ////////////////////////////////////////
300     function monarch() public view returns (address) {
301         return vars.monarch;
302     }
303     function prize() public view returns (uint) {
304         return uint(vars.prizeGwei) * 1e9;
305     }
306     function numOverthrows() public view returns (uint) {
307         return vars.numOverthrows;
308     }
309     function blockEnded() public view returns (uint) {
310         return vars.blockEnded;
311     }
312     function prevBlock() public view returns (uint) {
313         return vars.prevBlock;
314     }
315     function isPaid() public view returns (bool) {
316         return vars.isPaid;
317     }
318     function decree() public view returns (bytes23) {
319         return vars.decree;
320     }
321     ///////////////////////////////////////////////////////////
322 
323     // Expose all Settings //////////////////////////////////////
324     function collector() public view returns (address) {
325         return settings.collector;
326     }
327     function initialPrize() public view returns (uint){
328         return uint(settings.initialPrizeGwei) * 1e9;
329     }
330     function fee() public view returns (uint) {
331         return uint(settings.feeGwei) * 1e9;
332     }
333     function prizeIncr() public view returns (int) {
334         return int(settings.prizeIncrGwei) * 1e9;
335     }
336     function reignBlocks() public view returns (uint) {
337         return settings.reignBlocks;
338     }
339     ///////////////////////////////////////////////////////////
340 
341     // The following are computed /////////////////////////////
342     function isEnded() public view returns (bool) {
343         return block.number > vars.blockEnded;
344     }
345     function getBlocksRemaining() public view returns (uint) {
346         if (isEnded()) return 0;
347         return (vars.blockEnded - block.number) + 1;
348     }
349     function fees() public view returns (uint) {
350         uint _balance = address(this).balance;
351         return vars.isPaid ? _balance : _balance - prize();
352     }
353     function totalFees() public view returns (uint) {
354         int _feePerOverthrowGwei = int(settings.feeGwei) - settings.prizeIncrGwei;
355         return uint(_feePerOverthrowGwei * vars.numOverthrows * 1e9);
356     }
357     ///////////////////////////////////////////////////////////
358 }