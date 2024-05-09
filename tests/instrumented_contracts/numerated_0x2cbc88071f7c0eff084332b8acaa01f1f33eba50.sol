1 pragma solidity ^0.4.11;//MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNKOkOKWMMMMMM //
2 // MMMMWKkk0KNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNKOkOKWMMMMMM //
3 // MMMMXl.....,cdOXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXOo:,.....dNMMMM //
4 // MMMWd.        .'cxKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0d:'.        .xMMMM //
5 // MMMK,   ......   ..:xXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKd;.    .....    :XMMM //
6 // MMWd.   .;;;,,'..   .'lkXNWWNNNWMMMMMMMMMMWNNWWWNKkc..  ...',;;;,.   .kMMM //
7 // MMNc   .,::::::;,'..   ..,;;,,dNMMMMMMMMMMXl,;;;,..   ..';;::::::'.  .lWMM //
8 // MM0'   .;:::::::;;'..        ;0MMMMMMMMMMMWO'        ..,;;:::::::;.   ;KMM //
9 // MMx.  .';::::;,'...        .:0MMMMMMMMMMMMMWO;.        ...';;::::;..  .OMM //
10 // MWd.  .,:::;'..          .,xNMMMMMMMMMMMMMMMMXd'.          ..,;:::'.  .xMM //
11 // MNl.  .,:;'..         .,ckNMMMMMMMMMMMMMMMMMMMMXxc'.         ..';:,.  .dWM //
12 // MNc   .,,..    .;:clox0NWXXWMMMMMMMMMMMMMMMMMMWXXWXOxolc:;.    ..,'.  .oWM //
13 // MNc   ...     .oWMMMNXNMW0odXMMMMMMMMMMMMMMMMKooKWMNXNMMMNc.     ...  .oWM //
14 // MNc.          ;KMMMMNkokNMXlcKMMMMMMMMMMMMMM0coNMNxoOWMMMM0,          .oWM //
15 // MNc         .;0MMMMMMWO:dNMNoxWMMMMMMMMMMMMNddNMNocKMMMMMMWO,         .oWM //
16 // MX:        .lXMMMMMMMMM0lOMMNXWMMMMMMMMMMMMWXNMMklKMMMMMMMMM0:.       .lNM //
17 // MX;      .;kWMMMMMMMMMMMXNMMMMMMMMMMMMMMMMMMMMMMNNMMMMMMMMMMMNx,.      cNM //
18 // MO.    .:kNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNx:.  . ,0M //
19 // Wl..':dKWMMMMMMMWNK000KNMMMMMMMMMMMMMMMMMMMMMMMMMWNK000KNMMMMMMMMW0o;...dW //
20 // NxdOXWMMMMMMMW0olcc::;,,cxXWMMMMMMMMMMMMMMMMMMWKd:,,;::ccld0WMMMMMMMWKkokW //
21 // MMMMMMMMMMMWOlcd0XWWWN0x:.,OMMMMMMMMMMMMMMMMMWk,'cxKNWWWXOdcl0MMMMMMMMMMMM //
22 // MMMMMMMMMMMWKKWMMMMMMMMMWK0XMMMMMMMMMMMMMMMMMMXOXWMMMMMMMMMN0XMMMMMMMMMMMM //
23 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWK0OOOO0KWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM //
24 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNo.......'xWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM //
25 // MMMNKOkkkk0XNMMMMMMMMMMMMMMMMMMWO;.    .:0WMMMMMMMMMMMMMMMMMWNKOkkkkOKNMMM //
26 // MMWXOkxddoddxxkKWMMMMMMMMMMMMMMMMXo...'dNMMMMMMMMMMMMMMMMN0kxxdodddxk0XMMM //
27 // MMMMMMMMMMMMWNKKNMMMMMMMMMMMMMMMMWOc,,c0WMMMMMMMMMMMMMMMMXKKNWMMMMMMMMMMMM //
28 // MMMMMMMMWXKKXXNWMMMMMMMMMMWWWWWX0xcclc:cxKNWWWWWMMMMMMMMMMWNXXKKXWMMMMMMMM //
29 // MMMWXOxdoooddxkO0NMMMMMMMWKkfoahheitNX0GlikkdakXMMMMMMMWX0OkxddooddxOXWMMM //
30 // MMMWXKKNNWMMMMMWWWMMMMMMMMMWNXXXNWMMMMMMWXXXXNWMMMMMMMMMWWWMMMMWWNXKKNWMMM //
31 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM //
32 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM //
33 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM Lucky* MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM //
34 // MMM> *~+> we are the MMMMMMMMMMMM Number MMMMMMM> we are the <+~* <MMMMMMM //
35 // MMMMMMMMMM> music <MMMMMMMMMMMMMM ------ MMMMMMMMMM> dreamer <MMMMMMMMMMMM //
36 // MMMMMMMM> *~+> makers <MMMMM<MMMM Random MMMMMMMMMMMMM> of <MMMMMMMMMMMMMM //
37 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM Ledger MMMMMMMMMMMMMM> dreams. <+~* <MMM //
38 // M> palimpsest by <MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM //
39 // ~> arkimedes.eth <~+~+~+~~+~+~+~~+~+~+~~+~+~+~~+~+~+~~> VIII*XII*MMXVII <~ //
40 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM //
41 
42 /**
43  * Manages contract ownership.
44  */
45 contract Owned {
46     address public owner;
47     function owned() {
48         owner = msg.sender;
49     }
50     modifier onlyOwner {
51         require(msg.sender == owner);
52         _;
53     }
54     function transferOwnership(address _newOwner) onlyOwner {
55         owner = _newOwner;
56     }
57 }
58 
59 /**
60  * Function to recover the funds on the contract
61  */
62 contract Mortal is Owned {
63     function kill() onlyOwner {
64         selfdestruct(owner);
65     }
66 }
67 
68 /**
69  * SafeMath
70  * Math operations with safety checks that throw on error.
71  * Taking ideas from FirstBlood token. Enhanced by OpenZeppelin.
72  */
73 contract SafeMath {
74   function mul(uint256 a, uint256 b)
75   internal
76   constant
77   returns (uint256) {
78     uint256 c = a * b;
79     assert(a == 0 || c / a == b);
80     return c;
81   }
82 
83   function div(uint256 a, uint256 b)
84   internal
85   constant
86   returns (uint256) {
87     // assert(b > 0); // Solidity automatically throws when dividing by 0
88     uint256 c = a / b;
89     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
90     return c;
91   }
92 
93   function sub(uint256 a, uint256 b)
94   internal
95   constant
96   returns (uint256) {
97     assert(b <= a);
98     return a - b;
99   }
100 
101   function add(uint256 a, uint256 b)
102   internal
103   constant
104   returns (uint256) {
105     uint256 c = a + b;
106     assert(c >= a);
107     return c;
108   }
109 }
110 
111 /**
112  * Random number generator from mined block hash.
113  */
114 contract Random is SafeMath {
115     // Generates a random number from 1 to max based on the last block hash.
116     function getRandomFromBlockHash(uint blockNumber, uint max)
117     public
118     constant 
119     returns(uint) {
120         // block.blockhash(uint blockNumber)
121         //    returns
122         //    (bytes32):
123         //        hash of the given block
124         // !! only works for 256 most recent blocks excluding current !!
125         return(add(uint(sha3(block.blockhash(blockNumber))) % max, 1));
126     }
127 }
128 
129 /**
130  * LuckyNumber is the main public interface for a random number ledger.
131  * To make a request:
132  * Step 1: Call requestNumber with the `cost` as the value
133  * Step 2: Wait waitTime in blocks past the block which mines transaction for requestNumber
134  * Step 3: Call revealNumber to generate the number, and make it publicly accessable in the UI.
135  *         this is required to create the Events which generate the Ledger. 
136  */
137 contract LuckyNumber is Owned {
138     // ~> cost to generate a random number in Wei.
139     uint256 public cost;
140     // ~> waitTime is the number of blocks before random is generated.
141     uint8 public waitTime;
142     // ~> set default max
143     uint256 public max;
144 
145     // PendingNumber represents one number.
146     struct PendingNumber {
147         address requestProxy;
148         uint256 renderedNumber;
149         uint256 originBlock;
150         uint256 max;
151         // block to wait
152         // this will also be used as
153         // an active bool to save some storage
154         uint8 waitTime;
155     }
156 
157     // for Number Ledger
158     event EventLuckyNumberRequested(address indexed requestor, uint256 max, uint256 originBlock, uint8 waitTime, address indexed requestProxy);
159     event EventLuckyNumberRevealed(address indexed requestor, uint256 originBlock, uint256 renderedNumber, address indexed requestProxy);
160     
161     mapping (address => PendingNumber) public pendingNumbers;
162     mapping (address => bool) public whiteList;
163 
164     function requestNumber(address _requestor, uint256 _max, uint8 _waitTime) payable public;
165     function revealNumber(address _requestor) payable public;
166 }
167 
168 /**
169  * Lucky Number Service *~+>
170  * Any contract or address can make a request from this implementation
171  * on behalf of any other address as a requestProxy.
172  */
173 contract LuckyNumberService is LuckyNumber, Mortal, Random {
174     
175     // Initialize state +.+.+.
176     function LuckyNumberService() {
177         owned();
178         // defaults
179         cost = 20000000000000000; // 0.02 ether // 20 finney
180         max = 15; // generate number between 1 and 15
181         waitTime = 3; // 3 blocks
182     }
183 
184     // Let owner customize defauts.
185     // Allow the owner to set max.
186     function setMax(uint256 _max)
187     onlyOwner
188     public
189     returns (bool) {
190         max = _max;
191         return true;
192     }
193 
194     // Allow the owner to set waitTime. (in blocks)
195     function setWaitTime(uint8 _waitTime)
196     onlyOwner
197     public
198     returns (bool) {
199         waitTime = _waitTime;
200         return true;
201     }
202 
203     // Allow the owner to set cost.
204     function setCost(uint256 _cost)
205     onlyOwner
206     public
207     returns (bool) {
208         cost = _cost;
209         return true;
210     }
211 
212     // Allow the owner to set a transaction proxy
213     // which can perform value exchanges on behalf of this contract.
214     // (unrelated to the requestProxy which is not whiteList)
215     function enableProxy(address _proxy)
216     onlyOwner
217     public
218     returns (bool) {
219         whiteList[_proxy] = true;
220         return whiteList[_proxy];
221     }
222 
223     function removeProxy(address _proxy)
224     onlyOwner
225     public
226     returns (bool) {
227         delete whiteList[_proxy];
228         return true;
229     }
230 
231     // Allow the owner to cash out the holdings of this contract.
232     function withdraw(address _recipient, uint256 _balance)
233     onlyOwner
234     public
235     returns (bool) {
236         _recipient.transfer(_balance);
237         return true;
238     }
239 
240     // Assume that simple transactions are trying to request a number,
241     // unless it is from the owner.
242     function () payable public {
243         assert(msg.sender != owner);
244         requestNumber(msg.sender, max, waitTime);
245     }
246     
247     // Request a Number ... *~>
248     function requestNumber(address _requestor, uint256 _max, uint8 _waitTime)
249     payable 
250     public {
251         // external requirement: 
252         // value must exceed cost
253         // unless address is whitelisted
254         if (!whiteList[msg.sender]) {
255             require(!(msg.value < cost));
256         }
257 
258         // internal requirement: 
259         // request address must not have pending number
260         assert(!checkNumber(_requestor));
261         // set pending number
262         pendingNumbers[_requestor] = PendingNumber({
263             requestProxy: tx.origin, // requestProxy: original address that kicked off the transaction
264             renderedNumber: 0,
265             max: max,
266             originBlock: block.number,
267             waitTime: waitTime
268         });
269         if (_max > 1) {
270             pendingNumbers[_requestor].max = _max;
271         }
272         // max 250 wait to leave a few blocks
273         // for the reveal transction to occur
274         // and write from the pending numbers block
275         // before it expires
276         if (_waitTime > 0 && _waitTime < 250) {
277             pendingNumbers[_requestor].waitTime = _waitTime;
278         }
279         EventLuckyNumberRequested(_requestor, pendingNumbers[_requestor].max, pendingNumbers[_requestor].originBlock, pendingNumbers[_requestor].waitTime, pendingNumbers[_requestor].requestProxy);
280     }
281 
282     // Reveal your number ... *~>
283     // Only requestor or proxy can generate the number
284     function revealNumber(address _requestor)
285     public
286     payable {
287         assert(_canReveal(_requestor, msg.sender));
288         // waitTime has passed, render this requestor's number.
289         _revealNumber(_requestor);
290     }
291 
292     // Internal implementation of revealNumber().
293     function _revealNumber(address _requestor) 
294     internal {
295         uint256 luckyBlock = _revealBlock(_requestor);
296         // 
297         // TIME LIMITATION ~> should handle in user interface
298         // blocks older than (currentBlock - 256) 
299         // "expire" and read the same hash as most recent valid block
300         // 
301         uint256 luckyNumber = getRandomFromBlockHash(luckyBlock, pendingNumbers[_requestor].max);
302 
303         // set new values
304         pendingNumbers[_requestor].renderedNumber = luckyNumber;
305         // event
306         EventLuckyNumberRevealed(_requestor, pendingNumbers[_requestor].originBlock, pendingNumbers[_requestor].renderedNumber, pendingNumbers[_requestor].requestProxy);
307         // zero out wait blocks since this is now inactive (for state management)
308         pendingNumbers[_requestor].waitTime = 0;
309     }
310 
311     function canReveal(address _requestor)
312     public
313     constant
314     returns (bool, uint, uint, address, address) {
315         return (_canReveal(_requestor, msg.sender), _remainingBlocks(_requestor), _revealBlock(_requestor), _requestor, msg.sender);
316     }
317 
318     function _canReveal(address _requestor, address _proxy) 
319     internal
320     constant
321     returns (bool) {
322         // check for pending number request
323         if (checkNumber(_requestor)) {
324             // check for no remaining blocks to be mined
325             // must wait for `pendingNumbers[_requestor].waitTime` to be excceeded
326             if (_remainingBlocks(_requestor) == 0) {
327                 // check for ownership
328                 if (pendingNumbers[_requestor].requestProxy == _requestor || pendingNumbers[_requestor].requestProxy == _proxy) {
329                     return true;
330                 }
331             }
332         }
333         return false;
334     }
335 
336     function _remainingBlocks(address _requestor)
337     internal
338     constant
339     returns (uint) {
340         uint256 revealBlock = add(pendingNumbers[_requestor].originBlock, pendingNumbers[_requestor].waitTime);
341         uint256 remainingBlocks = 0;
342         if (revealBlock > block.number) {
343             remainingBlocks = sub(revealBlock, block.number);
344         }
345         return remainingBlocks;
346     }
347 
348     function _revealBlock(address _requestor)
349     internal
350     constant
351     returns (uint) {
352         // add wait block time
353         // to creation block time
354         // then subtract 1
355         return add(pendingNumbers[_requestor].originBlock, pendingNumbers[_requestor].waitTime);
356     }
357 
358 
359     function getNumber(address _requestor)
360     public
361     constant
362     returns (uint, uint, uint, address) {
363         return (pendingNumbers[_requestor].renderedNumber, pendingNumbers[_requestor].max, pendingNumbers[_requestor].originBlock, _requestor);
364     }
365 
366     // is a number request pending for the address
367     function checkNumber(address _requestor)
368     public
369     constant
370     returns (bool) {
371         if (pendingNumbers[_requestor].renderedNumber == 0 && pendingNumbers[_requestor].waitTime > 0) {
372             return true;
373         }
374         return false;
375     }
376 // 0xMMWKkk0KN/>HBBi/MASSa/DANTi/LANTen.MI.MI.MI.M+.+.+.M->MMWNKOkOKWJ.J.J.M*~+>
377 }