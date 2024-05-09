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
130  * RandomLedger is the main public interface for a random number ledger.
131  * To make a request:
132  * Step 1: Call requestNumber with the `cost` as the value
133  * Step 2: Wait waitTime in blocks past the block which mines transaction for requestNumber
134  * Step 3: Call revealNumber to generate the number, and make it publicly accessable in the UI.
135  *         this is required to create the Events which generate the Ledger. 
136  */
137 contract RandomLedger is Owned {
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
151         // blocks to wait,
152         // also maintains pending state
153         uint8 waitTime;
154     }
155 
156     // for Number Ledger
157     event EventRandomLedgerRequested(address requestor, uint256 max, uint256 originBlock, uint8 waitTime, address indexed requestProxy);
158     event EventRandomLedgerRevealed(address requestor, uint256 originBlock, uint256 renderedNumber, address indexed requestProxy);
159     
160     mapping (address => PendingNumber) pendingNumbers;
161     mapping (address => bool) public whiteList;
162 
163     function requestNumber(address _requestor, uint256 _max, uint8 _waitTime) payable public;
164     function revealNumber(address _requestor) payable public;
165 }
166 
167 /**
168  * Lucky Number :: Random Ledger Service *~+>
169  * Any contract or address can make a request from this implementation
170  * on behalf of any other address as a requestProxy.
171  */
172 contract RandomLedgerService is RandomLedger, Mortal, Random {
173     
174     // Initialize state +.+.+.
175     function RandomLedgerService() {
176         owned();
177         cost = 20000000000000000; // 0.02 ether // 20 finney
178         max = 21; // generate number between 1 and 21
179         waitTime = 5; // 5 blocks
180     }
181 
182     // Let owner customize defauts.
183     // Allow the owner to set max.
184     function setMax(uint256 _max)
185     onlyOwner
186     public
187     returns (bool) {
188         max = _max;
189         return true;
190     }
191 
192     // Allow the owner to set waitTime. (in blocks)
193     function setWaitTime(uint8 _waitTime)
194     onlyOwner
195     public
196     returns (bool) {
197         waitTime = _waitTime;
198         return true;
199     }
200 
201     // Allow the owner to set cost.
202     function setCost(uint256 _cost)
203     onlyOwner
204     public
205     returns (bool) {
206         cost = _cost;
207         return true;
208     }
209 
210     // Allow the owner to set a transaction proxy
211     // which can perform value exchanges on behalf of this contract.
212     // (unrelated to the requestProxy which is not whiteList)
213     function enableProxy(address _proxy)
214     onlyOwner
215     public
216     returns (bool) {
217         whiteList[_proxy] = true;
218         return whiteList[_proxy];
219     }
220 
221     function removeProxy(address _proxy)
222     onlyOwner
223     public
224     returns (bool) {
225         delete whiteList[_proxy];
226         return true;
227     }
228 
229     // Allow the owner to cash out the holdings of this contract.
230     function withdraw(address _recipient, uint256 _balance)
231     onlyOwner
232     public
233     returns (bool) {
234         _recipient.transfer(_balance);
235         return true;
236     }
237 
238     // Assume that simple transactions are trying to request a number,
239     // unless it is from the owner.
240     function () payable public {
241         assert(msg.sender != owner);
242         requestNumber(msg.sender, max, waitTime);
243     }
244     
245     // Request a Number ... *~>
246     function requestNumber(address _requestor, uint256 _max, uint8 _waitTime)
247     payable 
248     public {
249         // external requirement: 
250         // value must exceed cost
251         // unless address is whitelisted
252         if (!whiteList[msg.sender]) {
253             require(!(msg.value < cost));
254         }
255 
256         // internal requirement: 
257         // request address must not have pending number
258         assert(!isRequestPending(_requestor));
259         // set pending number
260         pendingNumbers[_requestor] = PendingNumber({
261             requestProxy: tx.origin, // requestProxy: original address that kicked off the transaction
262             renderedNumber: 0,
263             max: max,
264             originBlock: block.number,
265             waitTime: waitTime
266         });
267         if (_max > 1) {
268             pendingNumbers[_requestor].max = _max;
269         }
270         // max 250 wait to leave a few blocks
271         // for the reveal transction to occur
272         // and write from the pending numbers block
273         // before it expires
274         if (_waitTime > 0 && _waitTime < 250) {
275             pendingNumbers[_requestor].waitTime = _waitTime;
276         }
277         EventRandomLedgerRequested(_requestor, pendingNumbers[_requestor].max, pendingNumbers[_requestor].originBlock, pendingNumbers[_requestor].waitTime, pendingNumbers[_requestor].requestProxy);
278     }
279 
280     // Reveal your number ... *~>
281     // Only requestor or proxy can generate the number
282     function revealNumber(address _requestor)
283     public
284     payable {
285         assert(_canReveal(_requestor, msg.sender));
286         // waitTime has passed, render this requestor's number.
287         _revealNumber(_requestor);
288     }
289 
290     // Internal implementation of revealNumber().
291     function _revealNumber(address _requestor) 
292     internal {
293         uint256 luckyBlock = _revealBlock(_requestor);
294         // 
295         // TIME LIMITATION ~> should handle in user interface
296         // blocks older than (currentBlock - 256) 
297         // "expire" and read the same hash as most recent valid block
298         // 
299         uint256 luckyNumber = getRandomFromBlockHash(luckyBlock, pendingNumbers[_requestor].max);
300 
301         // set new values
302         pendingNumbers[_requestor].renderedNumber = luckyNumber;
303         // event
304         EventRandomLedgerRevealed(_requestor, pendingNumbers[_requestor].originBlock, pendingNumbers[_requestor].renderedNumber, pendingNumbers[_requestor].requestProxy);
305         // zero out wait blocks since this is now inactive (for state management)
306         pendingNumbers[_requestor].waitTime = 0;
307     }
308 
309     function canReveal(address _requestor)
310     public
311     constant
312     returns (bool, uint, uint, address, address) {
313         return (_canReveal(_requestor, msg.sender), _remainingBlocks(_requestor), _revealBlock(_requestor), _requestor, msg.sender);
314     }
315 
316     function _canReveal(address _requestor, address _proxy) 
317     internal
318     constant
319     returns (bool) {
320         // check for pending number request
321         if (isRequestPending(_requestor)) {
322             // check for no remaining blocks to be mined
323             // must wait for `pendingNumbers[_requestor].waitTime` to be excceeded
324             if (_remainingBlocks(_requestor) == 0) {
325                 // check for ownership
326                 if (pendingNumbers[_requestor].requestProxy == _requestor || pendingNumbers[_requestor].requestProxy == _proxy) {
327                     return true;
328                 }
329             }
330         }
331         return false;
332     }
333 
334     function _remainingBlocks(address _requestor)
335     internal
336     constant
337     returns (uint) {
338         uint256 revealBlock = add(pendingNumbers[_requestor].originBlock, pendingNumbers[_requestor].waitTime);
339         uint256 remainingBlocks = 0;
340         if (revealBlock > block.number) {
341             remainingBlocks = sub(revealBlock, block.number);
342         }
343         return remainingBlocks;
344     }
345 
346     function _revealBlock(address _requestor)
347     internal
348     constant
349     returns (uint) {
350         // add wait block time
351         // to creation block time
352         // then subtract 1
353         return add(pendingNumbers[_requestor].originBlock, pendingNumbers[_requestor].waitTime);
354     }
355 
356 
357     function getNumber(address _requestor)
358     public
359     constant
360     returns (uint, uint, uint, address) {
361         return (pendingNumbers[_requestor].renderedNumber, pendingNumbers[_requestor].max, pendingNumbers[_requestor].originBlock, _requestor);
362     }
363 
364     // is a number request pending for the address
365     function isRequestPending(address _requestor)
366     public
367     constant
368     returns (bool) {
369         if (pendingNumbers[_requestor].renderedNumber == 0 && pendingNumbers[_requestor].waitTime > 0) {
370             return true;
371         }
372         return false;
373     }
374 // 0xMMWKkk0KN/>HBBi/MASSa/DANTi/LANTen.MI.MI.MI.M+.+.+.M->MMWNKOkOKWJ.J.J.M*~+>
375 }