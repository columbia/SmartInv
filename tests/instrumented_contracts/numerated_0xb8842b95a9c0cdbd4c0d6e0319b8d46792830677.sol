1 pragma solidity ^0.4.15;
2 
3 // MMMMWKkk0KNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNKOkOKWMMMMMM //
4 // MMMMXl.....,cdOXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXOo:,.....dNMMMM //
5 // MMMWd.        .'cxKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMW0d:'.        .xMMMM //
6 // MMMK,   ......   ..:xXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKd;.    .....    :XMMM //
7 // MMWd.   .;;;,,'..   .'lkXNWWNNNWMMMMMMMMMMWNNWWWNKkc..  ...',;;;,.   .kMMM //
8 // MMNc   .,::::::;,'..   ..,;;,,dNMMMMMMMMMMXl,;;;,..   ..';;::::::'.  .lWMM //
9 // MM0'   .;:::::::;;'..        ;0MMMMMMMMMMMWO'        ..,;;:::::::;.   ;KMM //
10 // MMx.  .';::::;,'...        .:0MMMMMMMMMMMMMWO;.        ...';;::::;..  .OMM //
11 // MWd.  .,:::;'..          .,xNMMMMMMMMMMMMMMMMXd'.          ..,;:::'.  .xMM //
12 // MNl.  .,:;'..         .,ckNMMMMMMMMMMMMMMMMMMMMXxc'.         ..';:,.  .dWM //
13 // MNc   .,,..    .;:clox0NWXXWMMMMMMMMMMMMMMMMMMWXXWXOxolc:;.    ..,'.  .oWM //
14 // MNc   ...     .oWMMMNXNMW0odXMMMMMMMMMMMMMMMMKooKWMNXNMMMNc.     ...  .oWM //
15 // MNc.          ;KMMMMNkokNMXlcKMMMMMMMMMMMMMM0coNMNxoOWMMMM0,          .oWM //
16 // MNc         .;0MMMMMMWO:dNMNoxWMMMMMMMMMMMMNddNMNocKMMMMMMWO,         .oWM //
17 // MX:        .lXMMMMMMMMM0lOMMNXWMMMMMMMMMMMMWXNMMklKMMMMMMMMM0:.       .lNM //
18 // MX;      .;kWMMMMMMMMMMMXNMMMMMMMMMMMMMMMMMMMMMMNNMMMMMMMMMMMNx,.      cNM //
19 // MO.    .:kNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNx:.  . ,0M //
20 // Wl..':dKWMMMMMMMWNK000KNMMMMMMMMMMMMMMMMMMMMMMMMMWNK000KNMMMMMMMMW0o;...dW //
21 // NxdOXWMMMMMMMW0olcc::;,,cxXWMMMMMMMMMMMMMMMMMMWKd:,,;::ccld0WMMMMMMMWKkokW //
22 // MMMMMMMMMMMWOlcd0XWWWN0x:.,OMMMMMMMMMMMMMMMMMWk,'cxKNWWWXOdcl0MMMMMMMMMMMM //
23 // MMMMMMMMMMMWKKWMMMMMMMMMWK0XMMMMMMMMMMMMMMMMMMXOXWMMMMMMMMMN0XMMMMMMMMMMMM //
24 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWK0OOOO0KWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM //
25 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNo.......'xWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM //
26 // MMMNKOkkkk0XNMMMMMMMMMMMMMMMMMMWO;.    .:0WMMMMMMMMMMMMMMMMMWNKOkkkkOKNMMM //
27 // MMWXOkxddoddxxkKWMMMMMMMMMMMMMMMMXo...'dNMMMMMMMMMMMMMMMMN0kxxdodddxk0XMMM //
28 // MMMMMMMMMMMMWNKKNMMMMMMMMMMMMMMMMWOc,,c0WMMMMMMMMMMMMMMMMXKKNWMMMMMMMMMMMM //
29 // MMMMMMMMWXKKXXNWMMMMMMMMMMWWWWWX0xcclc:cxKNWWWWWMMMMMMMMMMWNXXKKXWMMMMMMMM //
30 // MMMWXOxdoooddxkO0NMMMMMMMWKkxxdlloxKNX0dolodxxkXMMMMMMMWX0OkxddooddxOXWMMM //
31 // MMMWXKKNNWMMMMMWWWMMMMMMMMMWNXXXNWMMMMMMWXXXXNWMMMMMMMMMWWWMMMMWWNXKKNWMMM //
32 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM //
33 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM //
34 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM Lucky  MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM //
35 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM Number MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM //
36 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM ------ MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM //
37 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM Random MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM //
38 // MM Contract design by MMMMMMMMMMM Ledger MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM //
39 // => 0x7C601D5DCd97B680dd623ff816D233898e6AD8dC <=MMMMMMM +.+.+. -> MMXVII M //
40 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM //
41 
42 
43 // Manages contract ownership.
44 contract Owned {
45     address public owner;
46     function owned() {
47         owner = msg.sender;
48     }
49     modifier onlyOwner {
50         require(msg.sender == owner);
51         _;
52     }
53     function transferOwnership(address _newOwner) onlyOwner {
54         owner = _newOwner;
55     }
56 }
57 
58 contract Mortal is Owned {
59     /* Function to recover the funds on the contract */
60     function kill() onlyOwner {
61         selfdestruct(owner);
62     }
63 }
64 
65 /* taking ideas from FirstBlood token */
66 contract SafeMath {
67     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
68         uint256 z = x + y;
69         assert((z >= x) && (z >= y));
70         return z;
71     }
72     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
73         assert(x >= y);
74         uint256 z = x - y;
75         return z;
76     }
77     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
78         uint256 z = x * y;
79         assert((x == 0)||(z/x == y));
80         return z;
81     }
82 }
83 
84 // Random is a block hash based random number generator.
85 // this is public so requestors can validate thier numbers
86 // independent of the native user interface
87 contract Random is SafeMath {
88     // Generates a random number from 1 to max based on the last block hash.
89     function getRand(uint blockNumber, uint max)
90     public
91     constant 
92     returns(uint) {
93         // block.blockhash(uint blockNumber) returns (bytes32): hash of the given block
94         // only works for 256 most recent blocks excluding current
95         return(safeAdd(uint(sha3(block.blockhash(blockNumber))) % max, 1));
96     }
97 }
98 
99 // LuckyNumber is the main public interface for a random number ledger.
100 // To make a request:
101 //   Step 1: Call requestNumber with the `cost` as the value
102 //   Step 2: Wait waitTime in blocks past the block which mines transaction for requestNumber
103 //   Step 3: Call revealNumber() to generate the number, and make it publicly accessable in the UI.
104 //           this is required to create the Events which generate the Ledger. 
105 contract LuckyNumber is Owned {
106     // cost to generate a random number in Wei.
107     uint256 public cost;
108     // waitTime is the number of blocks before random is generated.
109     uint8 public waitTime;
110     // set default max
111     uint256 public max;
112 
113     // PendingNumber represents one number.
114     struct PendingNumber {
115         address proxy;
116         uint256 renderedNumber;
117         uint256 creationBlockNumber;
118         uint256 max;
119         // block to wait
120         // this will also be used as
121         // an active bool to save some storage
122         uint8 waitTime;
123     }
124 
125     // for Number Config
126     event EventLuckyNumberUpdated(uint256 cost, uint256 max, uint8 waitTime);
127     // for Number Ledger
128     event EventLuckyNumberRequested(address requestor, uint256 max, uint256 creationBlockNumber, uint8 waitTime);
129     event EventLuckyNumberRevealed(address requestor, uint256 max, uint256 renderedNumber);
130     
131     mapping (address => PendingNumber) public pendingNumbers;
132     mapping (address => bool) public whiteList;
133 
134     function requestNumber(address _requestor, uint256 _max, uint8 _waitTime) payable public;
135     function revealNumber(address _requestor) payable public;
136 }
137 
138 // LuckyNumber Implementation
139 contract LuckyNumberImp is LuckyNumber, Mortal, Random {
140     
141     // Initialize state +.+.+.
142     function LuckyNumberImp() {
143         owned();
144         // defaults
145         cost = 20000000000000000; // 0.02 ether // 20 finney
146         max = 15; // generate number between 1 and 15
147         waitTime = 3; // 3 blocks
148     }
149 
150     // Allow the owner to set proxy contracts
151     // which can accept tokens
152     // on behalf of this contract
153     function enableProxy(address _proxy)
154     onlyOwner
155     public
156     returns (bool) {
157         // _cost
158         whiteList[_proxy] = true;
159         return whiteList[_proxy];
160     }
161 
162     function removeProxy(address _proxy)
163     onlyOwner
164     public
165     returns (bool) {
166         delete whiteList[_proxy];
167         return true;
168     }
169 
170     // Allow the owner to set max.
171     function setMax(uint256 _max)
172     onlyOwner
173     public
174     returns (bool) {
175         max = _max;
176         EventLuckyNumberUpdated(cost, max, waitTime);
177         return true;
178     }
179 
180     // Allow the owner to set waitTime. (in blocks)
181     function setWaitTime(uint8 _waitTime)
182     onlyOwner
183     public
184     returns (bool) {
185         waitTime = _waitTime;
186         EventLuckyNumberUpdated(cost, max, waitTime);
187         return true;
188     }
189 
190     // Allow the owner to set cost.
191     function setCost(uint256 _cost)
192     onlyOwner
193     public
194     returns (bool) {
195         cost = _cost;
196         EventLuckyNumberUpdated(cost, max, waitTime);
197         return true;
198     }
199     
200     // Allow the owner to cash out the holdings of this contract.
201     function withdraw(address _recipient, uint256 _balance)
202     onlyOwner
203     public
204     returns (bool) {
205         _recipient.transfer(_balance);
206         return true;
207     }
208 
209     // Assume that simple transactions are trying to request a number, unless it is
210     // from the owner.
211     function () payable public {
212         if (msg.sender != owner) {
213             requestNumber(msg.sender, max, waitTime);
214         }
215     }
216     
217     // Request a Number.
218     function requestNumber(address _requestor, uint256 _max, uint8 _waitTime)
219     payable 
220     public {
221         // external requirement: 
222         // value must exceed cost
223         // unless address is whitelisted
224         if (!whiteList[msg.sender]) {
225             require(!(msg.value < cost));
226         }
227 
228         // internal requirement: 
229         // request address must not have pending number
230         assert(!checkNumber(_requestor));
231         // set pending number
232         pendingNumbers[_requestor] = PendingNumber({
233             proxy: tx.origin,
234             renderedNumber: 0,
235             max: max,
236             creationBlockNumber: block.number,
237             waitTime: waitTime
238         });
239         if (_max > 1) {
240             pendingNumbers[_requestor].max = _max;
241         }
242         // max 250 wait to leave a few blocks
243         // for the reveal transction to occur
244         // and write from the pending numbers block
245         // before it expires
246         if (_waitTime > 0 && _waitTime < 250) {
247             pendingNumbers[_requestor].waitTime = _waitTime;
248         }
249         EventLuckyNumberRequested(_requestor, pendingNumbers[_requestor].max, pendingNumbers[_requestor].creationBlockNumber, pendingNumbers[_requestor].waitTime);
250     }
251 
252     // Only requestor or proxy can generate the number
253     function revealNumber(address _requestor)
254     public
255     payable {
256         assert(_canReveal(_requestor, msg.sender));
257         _revealNumber(_requestor);
258     }
259 
260     // Internal implementation of revealNumber().
261     function _revealNumber(address _requestor) 
262     internal {
263         // waitTime has passed, render this requestor's number.
264         uint256 luckyBlock = _revealBlock(_requestor);
265         // 
266         // TIME LIMITATION:
267         // blocks older than (currentBlock - 256) 
268         // "expire" and read the same hash as most recent valid block
269         // 
270         uint256 luckyNumber = getRand(luckyBlock, pendingNumbers[_requestor].max);
271 
272         // set new values
273         pendingNumbers[_requestor].renderedNumber = luckyNumber;
274         // event
275         EventLuckyNumberRevealed(_requestor, pendingNumbers[_requestor].creationBlockNumber, pendingNumbers[_requestor].renderedNumber);
276         // zero out wait blocks since this is now inactive
277         pendingNumbers[_requestor].waitTime = 0;
278         // update creation block as one use for number (record keeping)
279         pendingNumbers[_requestor].creationBlockNumber = 0;
280     }
281 
282     function canReveal(address _requestor)
283     public
284     constant
285     returns (bool, uint, uint, address, address) {
286         return (_canReveal(_requestor, msg.sender), _remainingBlocks(_requestor), _revealBlock(_requestor), _requestor, msg.sender);
287     }
288 
289     function _canReveal(address _requestor, address _proxy) 
290     internal
291     constant
292     returns (bool) {
293         // check for pending number request
294         if (checkNumber(_requestor)) {
295             // check for no remaining blocks to be mined
296             // must wait for `pendingNumbers[_requestor].waitTime` to be excceeded
297             if (_remainingBlocks(_requestor) == 0) {
298                 // check for ownership
299                 if (pendingNumbers[_requestor].proxy == _requestor || pendingNumbers[_requestor].proxy == _proxy) {
300                     return true;
301                 }
302             }
303         }
304         return false;
305     }
306 
307     function _remainingBlocks(address _requestor)
308     internal
309     constant
310     returns (uint) {
311         uint256 revealBlock = safeAdd(pendingNumbers[_requestor].creationBlockNumber, pendingNumbers[_requestor].waitTime);
312         uint256 remainingBlocks = 0;
313         if (revealBlock > block.number) {
314             remainingBlocks = safeSubtract(revealBlock, block.number);
315         }
316         return remainingBlocks;
317     }
318 
319     function _revealBlock(address _requestor)
320     internal
321     constant
322     returns (uint) {
323         // add wait block time
324         // to creation block time
325         // then subtract 1
326         return safeAdd(pendingNumbers[_requestor].creationBlockNumber, pendingNumbers[_requestor].waitTime);
327     }
328 
329 
330     function getNumber(address _requestor)
331     public
332     constant
333     returns (uint, uint, uint, address) {
334         return (pendingNumbers[_requestor].renderedNumber, pendingNumbers[_requestor].max, pendingNumbers[_requestor].creationBlockNumber, _requestor);
335     }
336 
337     // is a number pending for this requestor?
338     // TRUE: there is a number pending
339     // can not request, can reveal
340     // FALSE: there is not a number yet pending
341     function checkNumber(address _requestor)
342     public
343     constant
344     returns (bool) {
345         if (pendingNumbers[_requestor].renderedNumber == 0 && pendingNumbers[_requestor].waitTime > 0) {
346             return true;
347         }
348         return false;
349     }
350 // 0xMMWKkk0KNM>HBBi\MASSa\DANTi\LANTen.MI.MI.MI.M+.+.+.M->MMMWNKOkOKWJ.J.J.M //
351 }