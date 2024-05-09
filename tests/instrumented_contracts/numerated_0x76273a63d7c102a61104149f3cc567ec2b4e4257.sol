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
70   }
71   struct VisitMeta {
72     address owner;
73     uint index;
74   }
75   
76   address public cardboardUnicornTokenAddress;
77   address public groveAddress;
78   address public owner = msg.sender;
79   mapping (address => Visit[]) bookings;
80   mapping (bytes32 => VisitMeta) public bookingMetadataForKey;
81   mapping (uint8 => uint) public visitLength;
82   mapping (uint8 => uint) public visitCost;
83   uint public visitingUnicorns = 0;
84   uint public repossessionBlocks = 120960;
85   uint8 public repossessionBountyPerTen = 2;
86   uint8 public repossessionBountyPerHundred = 25;
87   uint public birthBlockThreshold = 60480;
88   uint8 public birthPerTen = 1;
89   uint8 public birthPerHundred = 15;
90 
91   event NewBooking(address indexed _who, uint indexed _index, VisitType indexed _type, uint _unicornCount);
92   event BookingUpdate(address indexed _who, uint indexed _index, VisitState indexed _newState, uint _unicornCount);
93   event RepossessionBounty(address indexed _who, uint _unicornCount);
94   event DonationReceived(address indexed _who, uint _unicornCount);
95 
96   modifier onlyOwner {
97     require(msg.sender == owner);
98     _;
99   }
100   
101   function UnicornRanch() {
102     visitLength[uint8(VisitType.Spa)] = 720;
103     visitLength[uint8(VisitType.Afternoon)] = 1440;
104     visitLength[uint8(VisitType.Day)] = 2880;
105     visitLength[uint8(VisitType.Overnight)] = 8640;
106     visitLength[uint8(VisitType.Week)] = 60480;
107     visitLength[uint8(VisitType.Extended)] = 120960;
108     
109     visitCost[uint8(VisitType.Spa)] = 0;
110     visitCost[uint8(VisitType.Afternoon)] = 0;
111     visitCost[uint8(VisitType.Day)] = 1 szabo;
112     visitCost[uint8(VisitType.Overnight)] = 1 szabo;
113     visitCost[uint8(VisitType.Week)] = 1 szabo;
114     visitCost[uint8(VisitType.Extended)] = 1 szabo;
115   }
116 
117 
118   function getBookingCount(address _who) constant returns (uint count) {
119     return bookings[_who].length;
120   }
121   function getBooking(address _who, uint _index) constant returns (uint _unicornCount, VisitType _type, uint _startBlock, uint _expiresBlock, VisitState _state) {
122     Visit storage v = bookings[_who][_index];
123     return (v.unicornCount, v.t, v.startBlock, v.expiresBlock, v.state);
124   }
125 
126   function bookSpaVisit(uint _unicornCount) payable {
127     return addBooking(VisitType.Spa, _unicornCount);
128   }
129   function bookAfternoonVisit(uint _unicornCount) payable {
130     return addBooking(VisitType.Afternoon, _unicornCount);
131   }
132   function bookDayVisit(uint _unicornCount) payable {
133     return addBooking(VisitType.Day, _unicornCount);
134   }
135   function bookOvernightVisit(uint _unicornCount) payable {
136     return addBooking(VisitType.Overnight, _unicornCount);
137   }
138   function bookWeekVisit(uint _unicornCount) payable {
139     return addBooking(VisitType.Week, _unicornCount);
140   }
141   function bookExtendedVisit(uint _unicornCount) payable {
142     return addBooking(VisitType.Extended, _unicornCount);
143   }
144   
145   function addBooking(VisitType _type, uint _unicornCount) payable {
146     if (_type == VisitType.Afternoon) {
147       return donateUnicorns(availableBalance(msg.sender));
148     }
149     require(msg.value >= visitCost[uint8(_type)].mul(_unicornCount)); // Must be paying proper amount
150 
151     ERC20Token cardboardUnicorns = ERC20Token(cardboardUnicornTokenAddress);
152     cardboardUnicorns.transferFrom(msg.sender, address(this), _unicornCount); // Transfer the actual asset
153     visitingUnicorns = visitingUnicorns.add(_unicornCount);
154     uint expiresBlock = block.number.add(visitLength[uint8(_type)]); // Calculate when this booking will be done
155     
156     // Add the booking to the ledger
157     bookings[msg.sender].push(Visit(
158       _unicornCount,
159       _type,
160       block.number,
161       expiresBlock,
162       VisitState.InProgress
163     ));
164     uint newIndex = bookings[msg.sender].length - 1;
165     bytes32 uniqueKey = keccak256(msg.sender, newIndex); // Create a unique key for this booking
166     
167     // Add a reference for that key, to find the metadata about it later
168     bookingMetadataForKey[uniqueKey] = VisitMeta(
169       msg.sender,
170       newIndex
171     );
172     
173     if (groveAddress > 0) {
174       // Insert into Grove index for applications to query
175       GroveAPI g = GroveAPI(groveAddress);
176       g.insert("bookingExpiration", uniqueKey, int(expiresBlock));
177     }
178     
179     // Send event about this new booking
180     NewBooking(msg.sender, newIndex, _type, _unicornCount);
181   }
182   
183   function completeBooking(uint _index) {
184     require(bookings[msg.sender].length > _index); // Sender must have at least this many bookings
185     Visit storage v = bookings[msg.sender][_index];
186     require(block.number >= v.expiresBlock); // Expired time must be past
187     require(v.state == VisitState.InProgress); // Visit must not be complete or repossessed
188     
189     uint unicornsToReturn = v.unicornCount;
190     ERC20Token cardboardUnicorns = ERC20Token(cardboardUnicornTokenAddress);
191 
192     // Determine if any births occurred
193     uint birthCount = 0;
194     if (SafeMath.sub(block.number, v.startBlock) >= birthBlockThreshold) {
195       if (v.unicornCount >= 100) {
196         birthCount = uint(birthPerHundred).mul(v.unicornCount / 100);
197       } else if (v.unicornCount >= 10) {
198         birthCount = uint(birthPerTen).mul(v.unicornCount / 10);
199       }
200     }
201     if (birthCount > 0) {
202       uint availableUnicorns = cardboardUnicorns.balanceOf(address(this)) - visitingUnicorns;
203       if (availableUnicorns < birthCount) {
204         birthCount = availableUnicorns;
205       }
206       unicornsToReturn = unicornsToReturn.add(birthCount);
207     }
208         
209     // Update the status of the Visit
210     v.state = VisitState.Completed;
211     bookings[msg.sender][_index] = v;
212     
213     // Transfer the asset back to the owner
214     visitingUnicorns = visitingUnicorns.sub(unicornsToReturn);
215     cardboardUnicorns.transfer(msg.sender, unicornsToReturn);
216     
217     // Send event about this update
218     BookingUpdate(msg.sender, _index, VisitState.Completed, unicornsToReturn);
219   }
220   
221   function repossessBooking(address _who, uint _index) {
222     require(bookings[_who].length > _index); // Address in question must have at least this many bookings
223     Visit storage v = bookings[_who][_index];
224     require(block.number > v.expiresBlock.add(repossessionBlocks)); // Repossession time must be past
225     require(v.state == VisitState.InProgress); // Visit must not be complete or repossessed
226     
227     // Update the status of the Visit
228     v.state = VisitState.Repossessed;
229     bookings[_who][_index] = v;
230     visitingUnicorns = visitingUnicorns.sub(v.unicornCount);
231     
232     // Send event about this update
233     BookingUpdate(_who, _index, VisitState.Repossessed, v.unicornCount);
234     
235     // Calculate Bounty amount
236     uint bountyCount = 1;
237     if (v.unicornCount >= 100) {
238         bountyCount = uint(repossessionBountyPerHundred).mul(v.unicornCount / 100);
239     } else if (v.unicornCount >= 10) {
240       bountyCount = uint(repossessionBountyPerTen).mul(v.unicornCount / 10);
241     }
242     
243     // Send bounty to bounty hunter
244     ERC20Token cardboardUnicorns = ERC20Token(cardboardUnicornTokenAddress);
245     cardboardUnicorns.transfer(msg.sender, bountyCount);
246     
247     // Send event about the bounty payout
248     RepossessionBounty(msg.sender, bountyCount);
249   }
250   
251   function availableBalance(address _who) internal returns (uint) {
252     ERC20Token cardboardUnicorns = ERC20Token(cardboardUnicornTokenAddress);
253     uint count = cardboardUnicorns.allowance(_who, address(this));
254     if (count == 0) {
255       return 0;
256     }
257     uint balance = cardboardUnicorns.balanceOf(_who);
258     if (balance < count) {
259       return balance;
260     }
261     return count;
262   }
263   
264   function() payable {
265     if (cardboardUnicornTokenAddress == 0) {
266       return;
267     }
268     return donateUnicorns(availableBalance(msg.sender));
269   }
270   
271   function donateUnicorns(uint _unicornCount) payable {
272     if (_unicornCount == 0) {
273       return;
274     }
275     ERC20Token cardboardUnicorns = ERC20Token(cardboardUnicornTokenAddress);
276     cardboardUnicorns.transferFrom(msg.sender, address(this), _unicornCount);
277     DonationReceived(msg.sender, _unicornCount);
278   }
279   
280   /**
281    * Change ownership of the Ranch
282    */
283   function changeOwner(address _newOwner) onlyOwner {
284     owner = _newOwner;
285   }
286 
287   /**
288    * Change the outside contracts used by this contract
289    */
290   function changeCardboardUnicornTokenAddress(address _newTokenAddress) onlyOwner {
291     cardboardUnicornTokenAddress = _newTokenAddress;
292   }
293   function changeGroveAddress(address _newAddress) onlyOwner {
294     groveAddress = _newAddress;
295   }
296   
297   /**
298    * Update block durations for various types of visits
299    */
300   function changeVisitLengths(uint _spa, uint _afternoon, uint _day, uint _overnight, uint _week, uint _extended) onlyOwner {
301     visitLength[uint8(VisitType.Spa)] = _spa;
302     visitLength[uint8(VisitType.Afternoon)] = _afternoon;
303     visitLength[uint8(VisitType.Day)] = _day;
304     visitLength[uint8(VisitType.Overnight)] = _overnight;
305     visitLength[uint8(VisitType.Week)] = _week;
306     visitLength[uint8(VisitType.Extended)] = _extended;
307   }
308   
309   /**
310    * Update ether costs for various types of visits
311    */
312   function changeVisitCosts(uint _spa, uint _afternoon, uint _day, uint _overnight, uint _week, uint _extended) onlyOwner {
313     visitCost[uint8(VisitType.Spa)] = _spa;
314     visitCost[uint8(VisitType.Afternoon)] = _afternoon;
315     visitCost[uint8(VisitType.Day)] = _day;
316     visitCost[uint8(VisitType.Overnight)] = _overnight;
317     visitCost[uint8(VisitType.Week)] = _week;
318     visitCost[uint8(VisitType.Extended)] = _extended;
319   }
320   
321   /**
322    * Update bounty reward settings
323    */
324   function changeRepoSettings(uint _repoBlocks, uint8 _repoPerTen, uint8 _repoPerHundred) onlyOwner {
325     repossessionBlocks = _repoBlocks;
326     repossessionBountyPerTen = _repoPerTen;
327     repossessionBountyPerHundred = _repoPerHundred;
328   }
329   
330   /**
331    * Update birth event settings
332    */
333   function changeBirthSettings(uint _birthBlocks, uint8 _birthPerTen, uint8 _birthPerHundred) onlyOwner {
334     birthBlockThreshold = _birthBlocks;
335     birthPerTen = _birthPerTen;
336     birthPerHundred = _birthPerHundred;
337   }
338 
339   function withdraw() onlyOwner {
340     owner.transfer(this.balance); // Send all ether in this contract to this contract's owner
341   }
342   function withdrawForeignTokens(address _tokenContract) onlyOwner {
343     ERC20Token token = ERC20Token(_tokenContract);
344     token.transfer(owner, token.balanceOf(address(this))); // Send all owned tokens to this contract's owner
345   }
346   
347 }