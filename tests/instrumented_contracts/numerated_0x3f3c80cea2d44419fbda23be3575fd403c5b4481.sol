1 pragma solidity ^0.4.23;
2 
3 /// @title A contract that remembers its creator (owner). Part of the
4 ///        Lition Smart Contract.
5 ///
6 /// @author Björn Stein, Quantum-Factory GmbH,
7 ///                      https://quantum-factory.de
8 ///
9 /// @dev License: Attribution-NonCommercial-ShareAlike 2.0 Generic (CC
10 ///              BY-NC-SA 2.0), see
11 ///              https://creativecommons.org/licenses/by-nc-sa/2.0/
12 contract owned {
13     constructor() public { owner = msg.sender; }
14     address owner;
15     
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20 }
21 
22 /// @title A contract that allows consumer addresses to be
23 ///        registered. Part of the Lition Smart Contract.
24 ///
25 /// @author Björn Stein, Quantum-Factory GmbH,
26 ///                      https://quantum-factory.de
27 ///
28 /// @dev License: Attribution-NonCommercial-ShareAlike 2.0 Generic (CC
29 ///              BY-NC-SA 2.0), see
30 ///              https://creativecommons.org/licenses/by-nc-sa/2.0/
31 contract consumerRegistry is owned {
32     event consumerRegistered(address indexed consumer);
33     event consumerDeregistered(address indexed consumer);
34 
35     // map address to userID
36     mapping(address => uint32) public consumers;
37 
38     modifier onlyRegisteredConsumers {
39         require(consumers[msg.sender] > 0);
40         _;
41     }
42 
43     /// @notice Allow the owner of the address `aconsumer.address()`
44     ///         to make transactions on behalf of user id `auserID`.
45     ///
46     /// @dev Register address aconsumer to belong to userID
47     ///      auserID. Addresses can be delisted ("unregistered") by
48     ///      setting the userID auserID to zero.
49     function registerConsumer(address aconsumer, uint32 auserID) onlyOwner external {
50         if (auserID != 0) {
51             emit consumerRegistered(aconsumer);
52         } else {
53             emit consumerDeregistered(aconsumer);
54         }
55         consumers[aconsumer] = auserID;
56     }
57 }
58 
59 /// @title A contract that allows producer addresses to be registered.
60 ///
61 /// @author Björn Stein, Quantum-Factory GmbH,
62 ///                      https://quantum-factory.de
63 ///
64 /// @dev License: Attribution-NonCommercial-ShareAlike 2.0 Generic (CC
65 ///              BY-NC-SA 2.0), see
66 ///              https://creativecommons.org/licenses/by-nc-sa/2.0/
67 contract producerRegistry is owned {
68     event producerRegistered(address indexed producer);
69     event producerDeregistered(address indexed producer);
70     
71     // map address to bool "is a registered producer"
72     mapping(address => bool) public producers;
73 
74     modifier onlyRegisteredProducers {
75         require(producers[msg.sender]);
76         _;
77     }
78     
79     /// @notice Allow the owner of address `aproducer.address()` to
80     ///         act as a producer (by offering energy).
81     function registerProducer(address aproducer) onlyOwner external {
82         emit producerRegistered(aproducer);
83         producers[aproducer] = true;
84     }
85 
86     /// @notice Cease allowing the owner of address
87     ///         `aproducer.address()` to act as a producer (by
88     ///         offering energy).
89     function deregisterProducer(address aproducer) onlyOwner external {
90         emit producerDeregistered(aproducer);
91         producers[aproducer] = false;
92     }
93 }
94 
95 /// @title The Lition Smart Contract, initial development version.
96 ///
97 /// @author Björn Stein, Quantum-Factory GmbH,
98 ///                      https://quantum-factory.de
99 ///
100 /// @dev License: Attribution-NonCommercial-ShareAlike 2.0 Generic (CC
101 ///              BY-NC-SA 2.0), see
102 ///              https://creativecommons.org/licenses/by-nc-sa/2.0/
103 contract EnergyStore is owned, consumerRegistry, producerRegistry {
104 
105     event BidMade(address indexed producer, uint32 indexed day, uint32 indexed price, uint64 energy);
106     event BidRevoked(address indexed producer, uint32 indexed day, uint32 indexed price, uint64 energy);
107     event Deal(address indexed producer, uint32 indexed day, uint32 price, uint64 energy, uint32 indexed userID);
108     event DealRevoked(address indexed producer, uint32 indexed day, uint32 price, uint64 energy, uint32 indexed userID);
109     
110     uint64 constant mWh = 1;
111     uint64 constant  Wh = 1000 * mWh;
112     uint64 constant kWh = 1000 * Wh;
113     uint64 constant MWh = 1000 * kWh;
114     uint64 constant GWh = 1000 * MWh;
115     uint64 constant TWh = 1000 * GWh;
116     uint64 constant maxEnergy = 18446 * GWh;
117   
118     struct Bid {
119         // producer's public key
120         address producer;
121         
122         // day for which the offer is valid
123         uint32 day;
124         
125         // price vs market price
126         uint32 price;
127         
128         // energy to sell
129         uint64 energy;
130         
131         // timestamp for when the offer was submitted
132         uint64 timestamp;
133     }
134     
135     struct Ask {
136         address producer;
137         uint32 day;
138         uint32 price;
139         uint64 energy;
140         uint32 userID;
141         uint64 timestamp;
142     }
143 
144     // bids (for energy: offering energy for sale)
145     Bid[] public bids;
146 
147     // asks (for energy: demanding energy to buy)
148     Ask[] public asks;
149     
150     // map (address, day) to index into bids
151     mapping(address => mapping(uint32 => uint)) public bidsIndex;
152     
153     // map (userid) to index into asks [last take written]
154     mapping(uint32 => uint) public asksIndex;
155     
156     /// @notice Offer `(aenergy / 1.0e6).toFixed(6)` kWh of energy for
157     ///         day `aday` at a price `(aprice / 1.0e3).toFixed(3) + '
158     ///         ct/kWh'` above market price for a date given as day
159     ///         `aday` whilst asserting that the current date and time
160     ///         in nanoseconds since 1970 is `atimestamp`.
161     ///
162     /// @param aday Day for which the offer is valid.
163     /// @param aprice Price surcharge in millicent/kWh above market
164     ///        price
165     /// @param aenergy Energy to be offered in mWh
166     /// @param atimestamp UNIX time (seconds since 1970) in
167     ///        nanoseconds
168     function offer_energy(uint32 aday, uint32 aprice, uint64 aenergy, uint64 atimestamp) onlyRegisteredProducers external {
169         // require a minimum offer of 1 kWh
170         require(aenergy >= kWh);
171         
172         uint idx = bidsIndex[msg.sender][aday];
173         
174         // idx is either 0 or such that bids[idx] has the right producer and day (or both 0 and ...)
175         if ((bids.length > idx) && (bids[idx].producer == msg.sender) && (bids[idx].day == aday)) {
176             // we will only let newer timestamps affect the stored data
177             require(atimestamp > bids[idx].timestamp);
178             
179             // NOTE: Should we sanity-check timestamps here (ensure that
180             //       they are either in the past or not in the too-distant
181             //       future compared to the last block's timestamp)?
182 
183             emit BidRevoked(bids[idx].producer, bids[idx].day, bids[idx].price, bids[idx].energy);   
184         }
185         
186         // create entry with new index idx for (msg.sender, aday)
187         idx = bids.length;
188         bidsIndex[msg.sender][aday] = idx; 
189         bids.push(Bid({
190             producer: msg.sender,
191             day: aday,
192             price: aprice,
193             energy: aenergy,
194             timestamp: atimestamp
195         }));
196         emit BidMade(bids[idx].producer, bids[idx].day, bids[idx].price, bids[idx].energy);
197     }
198     
199     function getBidsCount() external view returns(uint count) {
200         return bids.length;
201     }
202 
203     function getBidByProducerAndDay(address producer, uint32 day) external view returns(uint32 price, uint64 energy) {
204         uint idx = bidsIndex[producer][day];
205         require(bids.length > idx);
206         require(bids[idx].producer == producer);
207         require(bids[idx].day == day);
208         return (bids[idx].price, bids[idx].energy);
209     }
210 
211     /// @notice Buy `(aenergy / 1.0e6).toFixed(6)` kWh of energy on
212     ///         behalf of user id `auserID` (possibly de-anonymized by
213     ///         randomization) for day `aday` at a surcharge `(aprice
214     ///         / 1.0e3).toFixed(3)` ct/kWh from the energy producer
215     ///         using the address `aproducer.address()` whilst
216     ///         asserting that the current time in seconds since 1970
217     ///         is `(atimestamp / 1.0e9)` seconds.
218     ///
219     /// @param aproducer Address of the producer offering the energy
220     ///        to be bought.
221     /// @param aday Day for which the offer is valid.
222     /// @param aprice Price surcharge in millicent/kWh above market
223     ///        price
224     /// @param aenergy Energy to be offered in mWh
225     /// @param atimestamp UNIX time (seconds since 1970) in
226     ///        nanoseconds
227     ///
228     /// @dev This function is meant to be called by Lition on behalf
229     ///      of customers.
230     function buy_energy(address aproducer, uint32 aday, uint32 aprice, uint64 aenergy, uint32 auserID, uint64 atimestamp) onlyOwner external {
231         buy_energy_core(aproducer, aday, aprice, aenergy, auserID, atimestamp);
232     }
233     
234     /// @notice Buy `(aenergy / 1.0e6).toFixed(6)` kWh of energy on
235     ///          for day `aday` at a surcharge `(aprice /
236     ///          1.0e3).toFixed(3)` ct/kWh from the energy producer
237     ///          using the address `aproducer.address()`.
238     ///
239     /// @param aproducer Address of the producer offering the energy
240     ///        to be bought.
241     /// @param aday Day for which the offer is valid.
242     /// @param aprice Price surcharge in millicent/kWh above market
243     ///        price
244     /// @param aenergy Energy to be offered in mWh
245     ///
246     /// @dev This function is meant to be called by a Lition customer
247     ///      who has chosen to be registered for this ability and to
248     ///      decline anonymization by randomization of user ID.
249     function buy_energy(address aproducer, uint32 aday, uint32 aprice, uint64 aenergy) onlyRegisteredConsumers external {
250         buy_energy_core(aproducer, aday, aprice, aenergy, consumers[msg.sender], 0);
251     }
252 
253     function buy_energy_core(address aproducer, uint32 aday, uint32 aprice, uint64 aenergy, uint32 auserID, uint64 atimestamp) internal {
254         // find offer by producer (aproducer) for day (aday), or zero
255         uint idx = bidsIndex[aproducer][aday];
256         
257         // if the offer exists...
258         if ((bids.length > idx) && (bids[idx].producer == aproducer) && (bids[idx].day == aday)) {
259             // ...and has the right price...
260             require(bids[idx].price == aprice);
261             
262             // ...and is not overwriting a (by timestamp) later choice...
263             //
264             // NOTE: Only works if a single (same) day is written, not for
265             //       a bunch of writes (with different days)
266             //
267             // NOTE: The timestamp checking logic can be turned off by
268             //       using a timestamp of zero.
269             uint asksIdx = asksIndex[auserID];
270             if ((asks.length > asksIdx) && (asks[asksIdx].day == aday)) {
271                 require((atimestamp == 0) || (asks[asksIdx].timestamp < atimestamp));
272                 emit DealRevoked(asks[asksIdx].producer, asks[asksIdx].day, asks[asksIdx].price, asks[asksIdx].energy, asks[asksIdx].userID);
273             }
274             
275             // ...then record the customer's choice
276             asksIndex[auserID] = asks.length;
277             asks.push(Ask({
278                 producer: aproducer,
279                 day: aday,
280                 price: aprice,
281                 energy: aenergy,
282                 userID: auserID,
283                 timestamp: atimestamp
284             }));
285             emit Deal(aproducer, aday, aprice, aenergy, auserID);
286         } else {
287             // the offer does not exist
288             revert();
289         }
290     }
291 
292     function getAsksCount() external view returns(uint count) {
293         return asks.length;
294     }
295         
296     function getAskByUserID(uint32 userID) external view returns(address producer, uint32 day, uint32 price, uint64 energy) {
297         uint idx = asksIndex[userID];
298         require(asks[idx].userID == userID);
299         return (asks[idx].producer, asks[idx].day, asks[idx].price, asks[idx].energy);
300     }
301 }