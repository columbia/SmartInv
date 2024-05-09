1 pragma solidity 0.4.19;
2 
3 /**
4  * Owned Contract
5  * 
6  * This is a contract trait to inherit from. Contracts that inherit from Owned 
7  * are able to modify functions to be only callable by the owner of the
8  * contract.
9  * 
10  * By default it is impossible to change the owner of the contract.
11  */
12 contract Owned {
13     /**
14      * Contract owner.
15      * 
16      * This value is set at contract creation time.
17      */
18     address owner;
19 
20     /**
21      * Contract constructor.
22      * 
23      * This sets the owner of the Owned contract at the time of contract
24      * creation.
25      */
26     function Owned() public {
27         owner = msg.sender;
28     }
29 
30     /**
31      * Modify method to only allow the owner to call it.
32      */
33     modifier onlyOwner {
34         require(msg.sender == owner);
35         _;
36     }
37 }
38 
39 /**
40  * Aethia Omega Egg Sale Contract.
41  * 
42  * Every day, for a period of five (5) days, starting February 12th 12:00:00 
43  * UTC, this contract is allowed to sell a maximum of one-hundred-and-twenty
44  * (120) omega Ethergotchi eggs, for a total of six-hundred (600) eggs.
45  *
46  * These one-hundred-and-twenty eggs are divided over the twelve (12) time slots
47  * of two (2) hours that make up each day. Every two hours, ten (10) omega
48  * Ethergotchi eggs are available for 0.09 ether (excluding the gas cost of a 
49  * transaction).
50  *
51  * Any omega eggs that remain at the end of a time slot are not transferred to
52  * the next time slot.
53  */
54 contract OmegaEggSale is Owned {
55 
56     /**
57      * The start date of the omega egg sale in seconds since the UNIX epoch.
58      * 
59      * This value is equivalent to February 12th, 12:00:00 UTC, on a 24 hour
60      * clock.
61      */
62     uint256 constant START_DATE = 1518436800;
63 
64     /**
65      * The end date of the omega egg sale in seconds since the UNIX epoch.
66      * 
67      * This value is equivalent to February 17th, 12:00:00 UTC, on a 24 hour
68      * clock.
69      */
70     uint256 constant END_DATE = 1518868800;
71 
72     /**
73      * The amount of seconds within a single time slot.
74      *
75      * This is set to a total of two hours:
76      *      2 x 60 x 60 = 7200 seconds
77      */
78     uint16 constant SLOT_DURATION_IN_SECONDS = 7200;
79 
80     /**
81      * The number of remaining eggs in each time slot.
82      * 
83      * This is initially set to ten for each time slot.
84      */
85     mapping (uint8 => uint8) remainingEggs;
86     
87     /**
88      * Omega egg owners.
89      *
90      * This is a mapping containing all owners of omega eggs. While this does
91      * not prevent people from using multiple addresses to buy multiple omega
92      * eggs, it does increase the difficulty slightly.
93      */
94     mapping (address => bool) eggOwners;
95 
96     /**
97      * Omega egg sale event.
98      * 
99      * For audit and logging purposes, all omega egg sales are logged by 
100      * acquirer and acquisition date.
101      */
102     event LogOmegaEggSale(address indexed _acquirer, uint256 indexed _date);
103 
104     /**
105      * Contract constructor
106      * 
107      * This generates all omega egg time slots and the amount of available
108      * omega eggs within each time slot. The generation is done by calculating
109      * the total amount of seconds within the sale period together with the 
110      * amount of seconds within each time slot, and dividing the former by the
111      * latter for the number of time slots.
112      * 
113      * Each time slot is then assigned ten omega eggs.
114      */
115     function OmegaEggSale() Owned() public {
116         uint256 secondsInSalePeriod = END_DATE - START_DATE;
117         uint8 timeSlotCount = uint8(
118             secondsInSalePeriod / SLOT_DURATION_IN_SECONDS
119         );
120 
121         for (uint8 i = 0; i < timeSlotCount; i++) {
122             remainingEggs[i] = 10;
123         }
124     }
125 
126     /**
127      * Buy omega egg from the OmegaEggSale contract.
128      * 
129      * The cost of an omega egg is 0.09 ether. This contract accepts any amount
130      * equal or above 0.09 ether to buy an omega egg. In the case of higher
131      * amounts being sent, the contract will refund the difference.
132      * 
133      * To successully buy an omega egg, five conditions have to be met:
134      *  1. The `buyOmegaEgg` method must be called.
135      *  2. A value of 0.09 or more ether must accompany the transaction.
136      *  3. The transaction occurs in between February 12th 12:00:00 UTC and
137      *     February 17th 12:00:00 UTC.
138      *  4. The time slot in which the transaction occurs has omega eggs
139      *     available.
140      *  5. The sender must not already have bought an omega egg.
141      */
142     function buyOmegaEgg() payable external {
143         require(msg.value >= 0.09 ether);
144         require(START_DATE <= now && now < END_DATE);
145         require(eggOwners[msg.sender] == false);
146 
147         uint8 currentTimeSlot = getTimeSlot(now);
148 
149         require(remainingEggs[currentTimeSlot] > 0);
150 
151         remainingEggs[currentTimeSlot] -= 1;
152         eggOwners[msg.sender] = true;
153 
154         LogOmegaEggSale(msg.sender, now);
155         
156         // Send back any remaining value
157         if (msg.value > 0.09 ether) {
158             msg.sender.transfer(msg.value - 0.09 ether);
159         }
160     }
161 
162     /**
163      * Fallback payable method.
164      *
165      * This is in the case someone calls the contract without specifying the
166      * correct method to call. This method will ensure the failure of a
167      * transaction that was wrongfully executed.
168      */
169     function () payable external {
170         revert();
171     }
172     
173     /**
174      * Return number of eggs remaining in given time slot.
175      * 
176      * If the time slot is not valid (e.g. the time slot does not exist
177      * according to the this contract), the number of remaining eggs will
178      * default to zero (0).
179      * 
180      * This method is intended for external viewing purposes.
181      * 
182      * Parameters
183      * ----------
184      * _timeSlot : uint8
185      *     The time slot to return the number of remaining eggs for.
186      * 
187      * Returns
188      * -------
189      * uint8
190      *     The number of eggs still available within the contract for given
191      *     time slot.
192      */
193     function eggsInTimeSlot(uint8 _timeSlot) view external returns (uint8) {
194         return remainingEggs[_timeSlot];
195     }
196     
197     /**
198      * Return true if `_buyer` has bought an omega egg, otherwise false.
199      * 
200      * This method is intended for external viewing purposes.
201      * 
202      * Parameters
203      * ----------
204      * _buyer : address
205      *     The Ethereum wallet address of the buyer.
206      * 
207      * Returns
208      * -------
209      * bool
210      *     True if `_buyer` has bought an egg, otherwise false.
211      */
212     function hasBoughtEgg(address _buyer) view external returns (bool) {
213         return eggOwners[_buyer] == true;
214     }
215     
216     /**
217      * Withdraw all funds from contract.
218      * 
219      * This method can only be called after the OmegaEggSale contract has run
220      * its course.
221      */
222     function withdraw() onlyOwner external {
223         require(now >= END_DATE);
224 
225         owner.transfer(this.balance);
226     }
227 
228     /**
229      * Calculate the time slot corresponding to the given UNIX timestamp.
230      *
231      * The time slot is calculated by subtracting the current date and time in
232      * seconds from the contract's starting date and time in seconds. The result
233      * is then divided by the number of seconds within a time slot, and rounded
234      * down to get the correct time slot.
235      *
236      * Parameters
237      * ----------
238      * _timestamp : uint256
239      *     The timestamp to calculate a timeslot for. This is the amount of
240      *     seconds elapsed since the UNIX epoch.
241      *
242      * Returns
243      * -------
244      * uint8
245      *     The OmegaEggSale time slot corresponding to the given timestamp.
246      *     This can be a non-existent time slot, if the timestamp is further
247      *     in the future than `END_DATE`.
248      */
249     function getTimeSlot(uint256 _timestamp) private pure returns (uint8) {
250         uint256 secondsSinceSaleStart = _timestamp - START_DATE;
251         
252         return uint8(secondsSinceSaleStart / SLOT_DURATION_IN_SECONDS);
253     }
254 }