1 pragma solidity ^0.4.11;
2 
3 contract ERC20Token {
4   function balanceOf(address _who) constant returns (uint balance);
5   function allowance(address _owner, address _spender) constant returns (uint remaining);
6   function transferFrom(address _from, address _to, uint _value);
7   function transfer(address _to, uint _value);
8 }
9 contract GroveAPI {
10   function insert(bytes32 indexName, bytes32 id, int value) public;
11 }
12 
13 /**
14  * Math operations with safety checks
15  */
16 library SafeMath {
17   function mul(uint a, uint b) internal returns (uint) {
18     uint c = a * b;
19     assert(a == 0 || c / a == b);
20     return c;
21   }
22 
23   function div(uint a, uint b) internal returns (uint) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   function sub(uint a, uint b) internal returns (uint) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint a, uint b) internal returns (uint) {
36     uint c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 
41   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
42     return a >= b ? a : b;
43   }
44 
45   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
46     return a < b ? a : b;
47   }
48 
49   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
50     return a >= b ? a : b;
51   }
52 
53   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
54     return a < b ? a : b;
55   }
56 }
57 
58 contract UnicornRanch {
59   using SafeMath for uint;
60 
61   enum VisitType { Spa, Afternoon, Day, Overnight, Week, Extended }
62   enum VisitState { InProgress, Completed, Repossessed }
63   
64   struct Visit {
65     uint unicornCount;
66     VisitType t;
67     uint startBlock;
68     uint expiresBlock;
69     VisitState state;
70     uint completedBlock;
71     uint completedCount;
72   }
73   struct VisitMeta {
74     address owner;
75     uint index;
76   }
77   
78   address public cardboardUnicornTokenAddress;
79   address public groveAddress;
80   address public owner = msg.sender;
81   mapping (address => Visit[]) bookings;
82   mapping (bytes32 => VisitMeta) public bookingMetadataForKey;
83   mapping (uint8 => uint) public visitLength;
84   mapping (uint8 => uint) public visitCost;
85   uint public visitingUnicorns = 0;
86   uint public repossessionBlocks = 43200;
87   uint8 public repossessionBountyPerTen = 2;
88   uint8 public repossessionBountyPerHundred = 25;
89   uint public birthBlockThreshold = 43860;
90   uint8 public birthPerTen = 1;
91   uint8 public birthPerHundred = 15;
92 
93   event NewBooking(address indexed _who, uint indexed _index, VisitType indexed _type, uint _unicornCount);
94   event BookingUpdate(address indexed _who, uint indexed _index, VisitState indexed _newState, uint _unicornCount);
95   event RepossessionBounty(address indexed _who, uint _unicornCount);
96   event DonationReceived(address indexed _who, uint _unicornCount);
97 
98   modifier onlyOwner {
99     require(msg.sender == owner);
100     _;
101   }
102   
103   function UnicornRanch() {
104     visitLength[uint8(VisitType.Spa)] = 720;
105     visitLength[uint8(VisitType.Afternoon)] = 1440;
106     visitLength[uint8(VisitType.Day)] = 2880;
107     visitLength[uint8(VisitType.Overnight)] = 8640;
108     visitLength[uint8(VisitType.Week)] = 60480;
109     visitLength[uint8(VisitType.Extended)] = 120960;
110     
111     visitCost[uint8(VisitType.Spa)] = 0;
112     visitCost[uint8(VisitType.Afternoon)] = 0;
113     visitCost[uint8(VisitType.Day)] = 10 szabo;
114     visitCost[uint8(VisitType.Overnight)] = 30 szabo;
115     visitCost[uint8(VisitType.Week)] = 50 szabo;
116     visitCost[uint8(VisitType.Extended)] = 70 szabo;
117   }
118 
119 
120   function getBookingCount(address _who) constant returns (uint count) {
121     return bookings[_who].length;
122   }
123   function getBooking(address _who, uint _index) constant returns (uint _unicornCount, VisitType _type, uint _startBlock, uint _expiresBlock, VisitState _state, uint _completedBlock, uint _completedCount) {
124     Visit storage v = bookings[_who][_index];
125     return (v.unicornCount, v.t, v.startBlock, v.expiresBlock, v.state, v.completedBlock, v.completedCount);
126   }
127 
128   function bookSpaVisit(uint _unicornCount) payable {
129     return addBooking(VisitType.Spa, _unicornCount);
130   }
131   function bookAfternoonVisit(uint _unicornCount) payable {
132     return addBooking(VisitType.Afternoon, _unicornCount);
133   }
134   function bookDayVisit(uint _unicornCount) payable {
135     return addBooking(VisitType.Day, _unicornCount);
136   }
137   function bookOvernightVisit(uint _unicornCount) payable {
138     return addBooking(VisitType.Overnight, _unicornCount);
139   }
140   function bookWeekVisit(uint _unicornCount) payable {
141     return addBooking(VisitType.Week, _unicornCount);
142   }
143   function bookExtendedVisit(uint _unicornCount) payable {
144     return addBooking(VisitType.Extended, _unicornCount);
145   }
146   
147   function addBooking(VisitType _type, uint _unicornCount) payable {
148     if (_type == VisitType.Afternoon) {
149       return donateUnicorns(availableBalance(msg.sender));
150     }
151     require(msg.value >= visitCost[uint8(_type)].mul(_unicornCount)); // Must be paying proper amount
152 
153     ERC20Token cardboardUnicorns = ERC20Token(cardboardUnicornTokenAddress);
154     cardboardUnicorns.transferFrom(msg.sender, address(this), _unicornCount); // Transfer the actual asset
155     visitingUnicorns = visitingUnicorns.add(_unicornCount);
156     uint expiresBlock = block.number.add(visitLength[uint8(_type)]); // Calculate when this booking will be done
157     
158     // Add the booking to the ledger
159     bookings[msg.sender].push(Visit(
160       _unicornCount,
161       _type,
162       block.number,
163       expiresBlock,
164       VisitState.InProgress,
165       0,
166       0
167     ));
168     uint newIndex = bookings[msg.sender].length - 1;
169     bytes32 uniqueKey = keccak256(msg.sender, newIndex); // Create a unique key for this booking
170     
171     // Add a reference for that key, to find the metadata about it later
172     bookingMetadataForKey[uniqueKey] = VisitMeta(
173       msg.sender,
174       newIndex
175     );
176     
177     if (groveAddress > 0) {
178       // Insert into Grove index for applications to query
179       GroveAPI g = GroveAPI(groveAddress);
180       g.insert("bookingExpiration", uniqueKey, int(expiresBlock));
181     }
182     
183     // Send event about this new booking
184     NewBooking(msg.sender, newIndex, _type, _unicornCount);
185   }
186   
187   function completeBooking(uint _index) {
188     require(bookings[msg.sender].length > _index); // Sender must have at least this many bookings
189     Visit storage v = bookings[msg.sender][_index];
190     require(block.number >= v.expiresBlock); // Expired time must be past
191     require(v.state == VisitState.InProgress); // Visit must not be complete or repossessed
192     
193     uint unicornsToReturn = v.unicornCount;
194     ERC20Token cardboardUnicorns = ERC20Token(cardboardUnicornTokenAddress);
195 
196     // Determine if any births occurred
197     uint birthCount = 0;
198     if (SafeMath.sub(block.number, v.startBlock) >= birthBlockThreshold) {
199       if (v.unicornCount >= 100) {
200         birthCount = uint(birthPerHundred).mul(v.unicornCount / 100);
201       } else if (v.unicornCount >= 10) {
202         birthCount = uint(birthPerTen).mul(v.unicornCount / 10);
203       }
204     }
205     if (birthCount > 0) {
206       uint availableUnicorns = cardboardUnicorns.balanceOf(address(this)) - visitingUnicorns;
207       if (availableUnicorns < birthCount) {
208         birthCount = availableUnicorns;
209       }
210       unicornsToReturn = unicornsToReturn.add(birthCount);
211     }
212         
213     // Update the status of the Visit
214     v.state = VisitState.Completed;
215     v.completedBlock = block.number;
216     v.completedCount = unicornsToReturn;
217     bookings[msg.sender][_index] = v;
218     
219     // Transfer the asset back to the owner
220     visitingUnicorns = visitingUnicorns.sub(unicornsToReturn);
221     cardboardUnicorns.transfer(msg.sender, unicornsToReturn);
222     
223     // Send event about this update
224     BookingUpdate(msg.sender, _index, VisitState.Completed, unicornsToReturn);
225   }
226   
227   function repossessBooking(address _who, uint _index) {
228     require(bookings[_who].length > _index); // Address in question must have at least this many bookings
229     Visit storage v = bookings[_who][_index];
230     require(block.number > v.expiresBlock.add(repossessionBlocks)); // Repossession time must be past
231     require(v.state == VisitState.InProgress); // Visit must not be complete or repossessed
232     
233     visitingUnicorns = visitingUnicorns.sub(v.unicornCount);
234     
235     // Send event about this update
236     BookingUpdate(_who, _index, VisitState.Repossessed, v.unicornCount);
237     
238     // Calculate Bounty amount
239     uint bountyCount = 1;
240     if (v.unicornCount >= 100) {
241         bountyCount = uint(repossessionBountyPerHundred).mul(v.unicornCount / 100);
242     } else if (v.unicornCount >= 10) {
243       bountyCount = uint(repossessionBountyPerTen).mul(v.unicornCount / 10);
244     }
245     
246     // Send bounty to bounty hunter
247     ERC20Token cardboardUnicorns = ERC20Token(cardboardUnicornTokenAddress);
248     cardboardUnicorns.transfer(msg.sender, bountyCount);
249     
250     // Send event about the bounty payout
251     RepossessionBounty(msg.sender, bountyCount);
252 
253     // Update the status of the Visit
254     v.state = VisitState.Repossessed;
255     v.completedBlock = block.number;
256     v.completedCount = v.unicornCount - bountyCount;
257     bookings[_who][_index] = v;
258   }
259   
260   function availableBalance(address _who) internal returns (uint) {
261     ERC20Token cardboardUnicorns = ERC20Token(cardboardUnicornTokenAddress);
262     uint count = cardboardUnicorns.allowance(_who, address(this));
263     if (count == 0) {
264       return 0;
265     }
266     uint balance = cardboardUnicorns.balanceOf(_who);
267     if (balance < count) {
268       return balance;
269     }
270     return count;
271   }
272   
273   function() payable {
274     if (cardboardUnicornTokenAddress == 0) {
275       return;
276     }
277     return donateUnicorns(availableBalance(msg.sender));
278   }
279   
280   function donateUnicorns(uint _unicornCount) payable {
281     if (_unicornCount == 0) {
282       return;
283     }
284     ERC20Token cardboardUnicorns = ERC20Token(cardboardUnicornTokenAddress);
285     cardboardUnicorns.transferFrom(msg.sender, address(this), _unicornCount);
286     DonationReceived(msg.sender, _unicornCount);
287   }
288   
289   /**
290    * Change ownership of the Ranch
291    */
292   function changeOwner(address _newOwner) onlyOwner {
293     owner = _newOwner;
294   }
295 
296   /**
297    * Change the outside contracts used by this contract
298    */
299   function changeCardboardUnicornTokenAddress(address _newTokenAddress) onlyOwner {
300     cardboardUnicornTokenAddress = _newTokenAddress;
301   }
302   function changeGroveAddress(address _newAddress) onlyOwner {
303     groveAddress = _newAddress;
304   }
305   
306   /**
307    * Update block durations for various types of visits
308    */
309   function changeVisitLengths(uint _spa, uint _afternoon, uint _day, uint _overnight, uint _week, uint _extended) onlyOwner {
310     visitLength[uint8(VisitType.Spa)] = _spa;
311     visitLength[uint8(VisitType.Afternoon)] = _afternoon;
312     visitLength[uint8(VisitType.Day)] = _day;
313     visitLength[uint8(VisitType.Overnight)] = _overnight;
314     visitLength[uint8(VisitType.Week)] = _week;
315     visitLength[uint8(VisitType.Extended)] = _extended;
316   }
317   
318   /**
319    * Update ether costs for various types of visits
320    */
321   function changeVisitCosts(uint _spa, uint _afternoon, uint _day, uint _overnight, uint _week, uint _extended) onlyOwner {
322     visitCost[uint8(VisitType.Spa)] = _spa;
323     visitCost[uint8(VisitType.Afternoon)] = _afternoon;
324     visitCost[uint8(VisitType.Day)] = _day;
325     visitCost[uint8(VisitType.Overnight)] = _overnight;
326     visitCost[uint8(VisitType.Week)] = _week;
327     visitCost[uint8(VisitType.Extended)] = _extended;
328   }
329   
330   /**
331    * Update bounty reward settings
332    */
333   function changeRepoSettings(uint _repoBlocks, uint8 _repoPerTen, uint8 _repoPerHundred) onlyOwner {
334     repossessionBlocks = _repoBlocks;
335     repossessionBountyPerTen = _repoPerTen;
336     repossessionBountyPerHundred = _repoPerHundred;
337   }
338   
339   /**
340    * Update birth event settings
341    */
342   function changeBirthSettings(uint _birthBlocks, uint8 _birthPerTen, uint8 _birthPerHundred) onlyOwner {
343     birthBlockThreshold = _birthBlocks;
344     birthPerTen = _birthPerTen;
345     birthPerHundred = _birthPerHundred;
346   }
347 
348   function withdraw() onlyOwner {
349     owner.transfer(this.balance); // Send all ether in this contract to this contract's owner
350   }
351   function withdrawForeignTokens(address _tokenContract) onlyOwner {
352     ERC20Token token = ERC20Token(_tokenContract);
353     token.transfer(owner, token.balanceOf(address(this))); // Send all owned tokens to this contract's owner
354   }
355   
356 }