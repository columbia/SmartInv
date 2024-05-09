1 pragma solidity ^0.4.19;
2 
3 contract Fizzy {
4   /*
5   * Potential statuses for the Insurance struct
6   * 0: ongoing
7   * 1: insurance contract resolved normaly and the flight landed before the limit
8   * 2: insurance contract resolved normaly and the flight landed after the limit
9   * 3: insurance contract resolved because cancelled by the user
10   * 4: insurance contract resolved because flight cancelled by the air company
11   * 5: insurance contract resolved because flight redirected
12   * 6: insurance contract resolved because flight diverted
13   */
14   struct Insurance {          // all the infos related to a single insurance
15     bytes32 productId;           // ID string of the product linked to this insurance
16     uint limitArrivalTime;    // maximum arrival time after which we trigger compensation (timestamp in sec)
17     uint32 premium;           // amount of the premium
18     uint32 indemnity;         // amount of the indemnity
19     uint8 status;             // status of this insurance contract. See comment above for potential values
20   }
21 
22   event InsuranceCreation(    // event sent when a new insurance contract is added to this smart contract
23     bytes32 flightId,         // <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>
24     uint32 premium,           // amount of the premium paid by the user
25     uint32 indemnity,         // amount of the potential indemnity
26     bytes32 productId            // ID string of the product linked to this insurance
27   );
28 
29   /*
30    * Potential statuses for the InsuranceUpdate event
31    * 1: flight landed before the limit
32    * 2: flight landed after the limit
33    * 3: insurance contract cancelled by the user
34    * 4: flight cancelled
35    * 5: flight redirected
36    * 6: flight diverted
37    */
38   event InsuranceUpdate(      // event sent when the situation of a particular insurance contract is resolved
39     bytes32 productId,           // id string of the user linked to this account
40     bytes32 flightId,         // <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>
41     uint32 premium,           // amount of the premium paid by the user
42     uint32 indemnity,         // amount of the potential indemnity
43     uint8 status              // new status of the insurance contract. See above comment for potential values
44   );
45 
46   address creator;            // address of the creator of the contract
47 
48   // All the insurances handled by this smart contract are contained in this mapping
49   // key: a string containing the flight number and the timestamp separated by a dot
50   // value: an array of insurance contracts for this flight
51   mapping (bytes32 => Insurance[]) insuranceList;
52 
53 
54   // ------------------------------------------------------------------------------------------ //
55   // MODIFIERS / CONSTRUCTOR
56   // ------------------------------------------------------------------------------------------ //
57 
58   /**
59    * @dev This modifier checks that only the creator of the contract can call this smart contract
60    */
61   modifier onlyIfCreator {
62     if (msg.sender == creator) _;
63   }
64 
65   /**
66    * @dev Constructor
67    */
68   function Fizzy() public {
69     creator = msg.sender;
70   }
71 
72 
73   // ------------------------------------------------------------------------------------------ //
74   // INTERNAL FUNCTIONS
75   // ------------------------------------------------------------------------------------------ //
76 
77   function areStringsEqual (bytes32 a, bytes32 b) private pure returns (bool) {
78     // generate a hash for each string and compare them
79     return keccak256(a) == keccak256(b);
80   }
81 
82 
83   // ------------------------------------------------------------------------------------------ //
84   // FUNCTIONS TRIGGERING TRANSACTIONS
85   // ------------------------------------------------------------------------------------------ //
86 
87   /**
88    * @dev Add a new insurance for the given flight
89    * @param flightId <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>
90    * @param limitArrivalTime Maximum time after which we trigger the compensation (timestamp in sec)
91    * @param premium Amount of premium paid by the client
92    * @param indemnity Amount (potentialy) perceived by the client
93    * @param productId ID string of product linked to the insurance
94    */
95   function addNewInsurance(
96     bytes32 flightId,
97     uint limitArrivalTime,
98     uint32 premium,
99     uint32 indemnity,
100     bytes32 productId)
101   public
102   onlyIfCreator {
103 
104     Insurance memory insuranceToAdd;
105     insuranceToAdd.limitArrivalTime = limitArrivalTime;
106     insuranceToAdd.premium = premium;
107     insuranceToAdd.indemnity = indemnity;
108     insuranceToAdd.productId = productId;
109     insuranceToAdd.status = 0;
110 
111     insuranceList[flightId].push(insuranceToAdd);
112 
113     // send an event about the creation of this insurance contract
114     InsuranceCreation(flightId, premium, indemnity, productId);
115   }
116 
117   /**
118    * @dev Update the status of a flight
119    * @param flightId <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>
120    * @param actualArrivalTime The actual arrival time of the flight (timestamp in sec)
121    */
122   function updateFlightStatus(
123     bytes32 flightId,
124     uint actualArrivalTime)
125   public
126   onlyIfCreator {
127 
128     uint8 newStatus = 1;
129 
130     // go through the list of all insurances related to the given flight
131     for (uint i = 0; i < insuranceList[flightId].length; i++) {
132 
133       // we check this contract is still ongoing before updating it
134       if (insuranceList[flightId][i].status == 0) {
135 
136         newStatus = 1;
137 
138         // if the actual arrival time is over the limit the user wanted,
139         // we trigger the indemnity, which means status = 2
140         if (actualArrivalTime > insuranceList[flightId][i].limitArrivalTime) {
141           newStatus = 2;
142         }
143 
144         // update the status of the insurance contract
145         insuranceList[flightId][i].status = newStatus;
146 
147         // send an event about this update for each insurance
148         InsuranceUpdate(
149           insuranceList[flightId][i].productId,
150           flightId,
151           insuranceList[flightId][i].premium,
152           insuranceList[flightId][i].indemnity,
153           newStatus
154         );
155       }
156     }
157   }
158 
159   /**
160    * @dev Manually resolve an insurance contract
161    * @param flightId <carrier_code><flight_number>.<timestamp_in_sec_of_departure_date>
162    * @param newStatusId ID of the resolution status for this insurance contract
163    * @param productId ID string of the product linked to the insurance
164    */
165   function manualInsuranceResolution(
166     bytes32 flightId,
167     uint8 newStatusId,
168     bytes32 productId)
169   public
170   onlyIfCreator {
171 
172     // go through the list of all insurances related to the given flight
173     for (uint i = 0; i < insuranceList[flightId].length; i++) {
174 
175       // look for the insurance contract with the correct ID number
176       if (areStringsEqual(insuranceList[flightId][i].productId, productId)) {
177 
178         // we check this contract is still ongoing before updating it
179         if (insuranceList[flightId][i].status == 0) {
180 
181           // change the status of the insurance contract to the specified one
182           insuranceList[flightId][i].status = newStatusId;
183 
184           // send an event about this update
185           InsuranceUpdate(
186             productId,
187             flightId,
188             insuranceList[flightId][i].premium,
189             insuranceList[flightId][i].indemnity,
190             newStatusId
191           );
192 
193           return;
194         }
195       }
196     }
197   }
198 
199   function getInsurancesCount(bytes32 flightId) public view onlyIfCreator returns (uint) {
200     return insuranceList[flightId].length;
201   }
202 
203   function getInsurance(bytes32 flightId, uint index) public view onlyIfCreator returns (bytes32, uint, uint32, uint32, uint8) {
204     Insurance memory ins = insuranceList[flightId][index];
205     return (ins.productId, ins.limitArrivalTime, ins.premium, ins.indemnity, ins.status);
206   }
207 
208 }