1 pragma solidity ^0.4.15;//MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNKOkOKWMMMMMM //
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
29 // MMMWXOxdoooddxkO0NMMMMMMMWKkfoahheitNX0GlikkxxkXMMMMMMMWX0OkxddooddxOXWMMM //
30 // MMMWXKKNNWMMMMMWWWMMMMMMMMMWNXXXNWMMMMMMWXXXXNWMMMMMMMMMWWWMMMMWWNXKKNWMMM //
31 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM //
32 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM //
33 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM Lucky* MMMM> *~+. drohmah <MMMMMMMMMMMMM //
34 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM Number MMMMMMMMMM> funn <MMMMMMMMMMMMMMM //
35 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM ------ MMMMMMMMM> drohma *~+. <MMMMMMMMM //
36 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM Random MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM //
37 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM Ledger MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM //
38 // MMMMM>***<creator>...<MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM //
39 // ~> 0x0563cAC61Ea13a591A9E41087929f80d3076471d <~+~+~+~> VIII*XII*MMXVII <~ //
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
103 //   Step 3: Call revealNumber to generate the number, and make it publicly accessable in the UI.
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
125     // for Number Config :: uint256 cost, uint256 max, uint8 waitTime
126     event EventLuckyNumberUpdated(uint256, uint256, uint8);
127     // for Number Ledger
128     // :: address requestor, uint256 max, uint256 creationBlockNumber, uint8 waitTime
129     event EventLuckyNumberRequested(address, uint256, uint256, uint8);
130     // :: address requestor, uint256 creationBlockNumber, uint256 renderedNumber
131     event EventLuckyNumberRevealed(address, uint256, uint256);
132     
133     mapping (address => PendingNumber) public pendingNumbers;
134     mapping (address => bool) public whiteList;
135 
136     function requestNumber(address _requestor, uint256 _max, uint8 _waitTime) payable public;
137     function revealNumber(address _requestor) payable public;
138 }
139 
140 // LuckyNumber Implementation
141 contract LuckyNumberImp is LuckyNumber, Mortal, Random {
142     
143     // Initialize state +.+.+.
144     function LuckyNumberImp() {
145         owned();
146         // defaults
147         cost = 20000000000000000; // 0.02 ether // 20 finney
148         max = 15; // generate number between 1 and 15
149         waitTime = 3; // 3 blocks
150     }
151 
152 	// Let owner customize defauts.
153     // Allow the owner to set max.
154     function setMax(uint256 _max)
155     onlyOwner
156     public
157     returns (bool) {
158         max = _max;
159         EventLuckyNumberUpdated(cost, max, waitTime);
160         return true;
161     }
162 
163     // Allow the owner to set waitTime. (in blocks)
164     function setWaitTime(uint8 _waitTime)
165     onlyOwner
166     public
167     returns (bool) {
168         waitTime = _waitTime;
169         EventLuckyNumberUpdated(cost, max, waitTime);
170         return true;
171     }
172 
173     // Allow the owner to set cost.
174     function setCost(uint256 _cost)
175     onlyOwner
176     public
177     returns (bool) {
178         cost = _cost;
179         EventLuckyNumberUpdated(cost, max, waitTime);
180         return true;
181     }
182 
183     // Allow the owner to set proxy contracts,
184     // which can accept tokens on behalf of this contract.
185     function enableProxy(address _proxy)
186     onlyOwner
187     public
188     returns (bool) {
189         // _cost
190         whiteList[_proxy] = true;
191         return whiteList[_proxy];
192     }
193 
194     function removeProxy(address _proxy)
195     onlyOwner
196     public
197     returns (bool) {
198         delete whiteList[_proxy];
199         return true;
200     }
201 
202     // Allow the owner to cash out the holdings of this contract.
203     function withdraw(address _recipient, uint256 _balance)
204     onlyOwner
205     public
206     returns (bool) {
207         _recipient.transfer(_balance);
208         return true;
209     }
210 
211     // Assume that simple transactions are trying to request a number,
212     // unless it is from the owner.
213     function () payable public {
214         if (msg.sender != owner) {
215             requestNumber(msg.sender, max, waitTime);
216         }
217     }
218     
219     // Request a Number ... *~>
220     function requestNumber(address _requestor, uint256 _max, uint8 _waitTime)
221     payable 
222     public {
223         // external requirement: 
224         // value must exceed cost
225         // unless address is whitelisted
226         if (!whiteList[msg.sender]) {
227             require(!(msg.value < cost));
228         }
229 
230         // internal requirement: 
231         // request address must not have pending number
232         assert(!checkNumber(_requestor));
233         // set pending number
234         pendingNumbers[_requestor] = PendingNumber({
235             proxy: tx.origin,
236             renderedNumber: 0,
237             max: max,
238             creationBlockNumber: block.number,
239             waitTime: waitTime
240         });
241         if (_max > 1) {
242             pendingNumbers[_requestor].max = _max;
243         }
244         // max 250 wait to leave a few blocks
245         // for the reveal transction to occur
246         // and write from the pending numbers block
247         // before it expires
248         if (_waitTime > 0 && _waitTime < 250) {
249             pendingNumbers[_requestor].waitTime = _waitTime;
250         }
251         EventLuckyNumberRequested(_requestor, pendingNumbers[_requestor].max, pendingNumbers[_requestor].creationBlockNumber, pendingNumbers[_requestor].waitTime);
252     }
253 
254     // Reveal your number ... *~>
255     // Only requestor or proxy can generate the number
256     function revealNumber(address _requestor)
257     public
258     payable {
259         assert(_canReveal(_requestor, msg.sender));
260         _revealNumber(_requestor);
261     }
262 
263     // Internal implementation of revealNumber().
264     function _revealNumber(address _requestor) 
265     internal {
266         // waitTime has passed, render this requestor's number.
267         uint256 luckyBlock = _revealBlock(_requestor);
268         // 
269         // TIME LIMITATION:
270         // blocks older than (currentBlock - 256) 
271         // "expire" and read the same hash as most recent valid block
272         // 
273         uint256 luckyNumber = getRand(luckyBlock, pendingNumbers[_requestor].max);
274 
275         // set new values
276         pendingNumbers[_requestor].renderedNumber = luckyNumber;
277         // event
278         EventLuckyNumberRevealed(_requestor, pendingNumbers[_requestor].creationBlockNumber, pendingNumbers[_requestor].renderedNumber);
279         // zero out wait blocks since this is now inactive(record keeping)
280         pendingNumbers[_requestor].waitTime = 0;
281     }
282 
283     function canReveal(address _requestor)
284     public
285     constant
286     returns (bool, uint, uint, address, address) {
287         return (_canReveal(_requestor, msg.sender), _remainingBlocks(_requestor), _revealBlock(_requestor), _requestor, msg.sender);
288     }
289 
290     function _canReveal(address _requestor, address _proxy) 
291     internal
292     constant
293     returns (bool) {
294         // check for pending number request
295         if (checkNumber(_requestor)) {
296             // check for no remaining blocks to be mined
297             // must wait for `pendingNumbers[_requestor].waitTime` to be excceeded
298             if (_remainingBlocks(_requestor) == 0) {
299                 // check for ownership
300                 if (pendingNumbers[_requestor].proxy == _requestor || pendingNumbers[_requestor].proxy == _proxy) {
301                     return true;
302                 }
303             }
304         }
305         return false;
306     }
307 
308     function _remainingBlocks(address _requestor)
309     internal
310     constant
311     returns (uint) {
312         uint256 revealBlock = safeAdd(pendingNumbers[_requestor].creationBlockNumber, pendingNumbers[_requestor].waitTime);
313         uint256 remainingBlocks = 0;
314         if (revealBlock > block.number) {
315             remainingBlocks = safeSubtract(revealBlock, block.number);
316         }
317         return remainingBlocks;
318     }
319 
320     function _revealBlock(address _requestor)
321     internal
322     constant
323     returns (uint) {
324         // add wait block time
325         // to creation block time
326         // then subtract 1
327         return safeAdd(pendingNumbers[_requestor].creationBlockNumber, pendingNumbers[_requestor].waitTime);
328     }
329 
330 
331     function getNumber(address _requestor)
332     public
333     constant
334     returns (uint, uint, uint, address) {
335         return (pendingNumbers[_requestor].renderedNumber, pendingNumbers[_requestor].max, pendingNumbers[_requestor].creationBlockNumber, _requestor);
336     }
337 
338     // is a number pending for this requestor?
339     // TRUE: there is a number pending
340     // can not request, can reveal
341     // FALSE: there is not a number yet pending
342     function checkNumber(address _requestor)
343     public
344     constant
345     returns (bool) {
346         if (pendingNumbers[_requestor].renderedNumber == 0 && pendingNumbers[_requestor].waitTime > 0) {
347             return true;
348         }
349         return false;
350     }
351 // 0xMMWKkk0KN/>HBBi/MASSa/DANTi/LANTen.MI.MI.MI.M+.+.+.M->MMMWNKOkOKWJ.J.J.M //
352 }