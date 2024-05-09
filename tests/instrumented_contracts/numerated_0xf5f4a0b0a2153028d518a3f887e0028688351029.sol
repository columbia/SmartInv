1 pragma solidity ^0.4.15;
2 
3 contract tickets {
4     
5     mapping(uint256 => uint256) public ticketPrices;
6     mapping(address => uint256[]) public ticketsOwners;
7     mapping(uint256 => address) public ticketsOwned;
8     mapping(address => uint256) public noOfTicketsOwned;
9     mapping(address => bool) public banned;
10     uint256 public noOfSeats;
11     
12     mapping(address => uint256[]) public reservations;
13     mapping(address => uint256) public noOfreservations;
14     mapping(address => uint256) public timeOfreservations;
15     mapping(address => uint256) public priceOfreservations;
16     mapping(uint256 => address) public addressesReserving;
17     uint256 public lowestAddressReserving=0;
18     uint256 public highestAddressReserving=0;
19     
20     mapping(uint256 => uint256[]) public ticketTransfers;
21     mapping(uint256 => uint256) public ticketTransfersPerAmount;
22     uint256 public ticketTransfersAmount = 0;
23     mapping(address => uint256[]) public ticketTransferers;
24     mapping(address => uint256) public ticketTransferersAmount;
25     mapping(address => uint256[]) public ticketTransferees;
26     mapping(address => uint256) public ticketTransfereesAmount;
27     
28     mapping(address => bytes32) public hashes;
29     
30     string public name;
31     
32     uint256 public secondsToHold = 60 * 5 ;
33     
34     address public owner;
35     
36     function tickets(uint256[] ticks, uint256 nOfSeats, string n) {
37         for(uint256 i=0;i<nOfSeats;i++) {
38             ticketPrices[i] = ticks[i];
39         }
40         noOfSeats = nOfSeats;
41         name = n;
42         owner = msg.sender;
43     }
44     
45     function reserveSeats(uint256[] seats, uint256 nOfSeats) {
46         if(noOfreservations[msg.sender] != 0 && !banned[msg.sender]) {
47             revert();
48         }
49         resetReservationsInternal();
50         uint256 price = 0;
51         for(uint256 i=0;i<nOfSeats;i++) {
52             if(ticketsOwned[seats[i]] != 0x0) {
53                 revert();
54             }
55             reservations[msg.sender].push(seats[i]);
56             price += ticketPrices[seats[i]];
57             ticketsOwned[seats[i]] = msg.sender;
58         }
59         noOfreservations[msg.sender] = nOfSeats;
60         timeOfreservations[msg.sender] = now;
61         priceOfreservations[msg.sender] = price;
62         noOfTicketsOwned[msg.sender]++;
63         highestAddressReserving++;
64         Reserved(msg.sender, seats);
65     }
66     
67     function resetReservations(address requester, bool resetOwn) {
68         if(noOfreservations[requester] == 0) {
69             throw;
70         }
71         for(uint256 i=0;i<noOfreservations[requester] && resetOwn;i++) {
72             ticketsOwned[reservations[requester][i]] = 0x0;
73             noOfTicketsOwned[msg.sender]--;
74         }
75         reservations[requester] = new uint256[](0);
76         noOfreservations[requester] = 0;
77         timeOfreservations[requester] = 0;
78         priceOfreservations[requester] = 0;
79     }
80     
81     function resetReservationsInternal() private {
82         bool pastTheLowest = false;
83         bool stop = false;
84         for(uint256 i=lowestAddressReserving;i<highestAddressReserving && !stop;i++) {
85             if(timeOfreservations[addressesReserving[i]] != 0) {
86                 pastTheLowest = true;
87                 if(now - timeOfreservations[addressesReserving[i]] > secondsToHold) {
88                     resetReservations(addressesReserving[i], true);
89                 } else {
90                     stop = true;
91                 }
92             }
93             if(timeOfreservations[addressesReserving[i]] == 0 && !pastTheLowest) {
94                 lowestAddressReserving = i;
95             }
96             
97         }
98     }
99     
100     function revokeTickets(address revokee, bool payback) payable {
101         if(msg.sender == owner) {
102             banned[revokee] = true;
103             uint256 price = 0;
104             for(uint256 i=0;i<noOfTicketsOwned[revokee];i++) {
105                 ticketsOwned[ticketsOwners[revokee][i]] = 0x0;
106                 price+=ticketPrices[ticketsOwners[revokee][i]];
107             }
108             ticketsOwners[revokee] = new uint256[](0);
109             noOfTicketsOwned[revokee] = 0;
110             if(payback) {
111                 revokee.send(price);
112             }
113             Banned(revokee, payback);
114         }
115     }
116     
117     function InvokeTransfer(address transferee, uint256[] ticks, uint256 amount) {
118         if(amount>0 && getTransfer(msg.sender,transferee) != 100000000000000000) {
119             for(uint256 i=0;i<amount;i++) {
120                 ticketTransfers[ticketTransfersAmount].push(ticks[i]);
121             }
122             ticketTransferers[msg.sender][ticketTransferersAmount[msg.sender]++] = ticketTransfersAmount;
123             ticketTransferees[transferee][ticketTransfereesAmount[transferee]++] = ticketTransfersAmount;
124             ticketTransfersPerAmount[ticketTransfersAmount] = amount;
125             TransferStarted(msg.sender, transferee, ticks, ticketTransfersAmount++);
126         } else {
127             revert();
128         }
129     }
130     
131     function removeTransfer(uint256 transferID) {
132         bool transferer = false;
133         for(uint256 i=0;i<ticketTransferersAmount[msg.sender] && !transferer;i++) {
134             if(ticketTransferers[msg.sender][i] == transferID) {
135                 transferer = true;
136             }
137         }
138         if(transferer) {
139             ticketTransfers[transferID] = new uint256[](0);
140         } else {
141             revert();
142         }
143     }
144     
145     function finishTransfer(uint256 transferID) payable {
146         bool transferee = false;
147         for(uint256 j=0;j<ticketTransfereesAmount[msg.sender] && !transferee;j++) {
148             if(ticketTransferees[msg.sender][j] == transferID) {
149                 transferee = true;
150             }
151         }
152         if(!transferee) {
153             revert();
154         }
155         uint256 price = 0;
156         for(uint256 i=0;i<ticketTransfersPerAmount[transferID];i++) {
157             price += ticketPrices[ticketTransfers[transferID][i]];
158         }
159         if(msg.value == price) {
160             for(i=0;i<ticketTransfersPerAmount[transferID];i++) {
161                 ticketsOwned[ticketTransfers[transferID][i]] = msg.sender;
162             }
163             Transferred(transferID);
164         } else {
165             revert();
166         }
167     }
168     
169     function getTransfer(address transferer, address transferee) returns (uint256) {
170         for(uint256 i=0;i<ticketTransferersAmount[transferer];i++) {
171             for(uint256 j=0;j<ticketTransfereesAmount[transferee];j++) {
172                 if(ticketTransferers[transferer][i] == ticketTransferees[transferee][j]) {
173                     return ticketTransferees[transferee][j];
174                 }
175             }
176         }
177         return 100000000000000000;
178     }
179     
180     function returnTickets(uint256 ticketID) {
181         if(ticketsOwned[ticketID] == msg.sender) {
182             for(uint256 i=0;i<noOfTicketsOwned[msg.sender];i++) {
183                 if(ticketsOwners[msg.sender][i] == ticketID) {
184                     ticketsOwners[msg.sender][i] = 100000000000000000;
185                 }
186             }
187             ticketsOwned[ticketID] = 0x0;
188             noOfTicketsOwned[msg.sender]--;
189             msg.sender.send(ticketPrices[ticketID]);
190         } else {
191             revert();
192         }
193     }
194     
195     function changePrice (uint256[] seats, uint256 nOfSeats) {
196         if(nOfSeats == noOfSeats) {
197             for(uint256 i = 0;i<noOfSeats;i++) {
198                 ticketPrices[i] = seats[i];
199             }
200         } else {
201             revert();
202         }
203     }
204     
205     function setHash(bytes32 hash) {
206         hashes[msg.sender] = hash;
207     }
208     
209     function checkHash(address a, string password) constant returns (bool) {
210         return hashes[a]!="" && hashes[a] == sha3(password);
211     }
212     
213     function() payable {
214         if(msg.value == priceOfreservations[msg.sender] && !banned[msg.sender]) {
215             for(uint256 i=0;i<noOfreservations[msg.sender];i++) {
216                 ticketsOwners[msg.sender].push(reservations[msg.sender][i]);
217             }
218             resetReservations(msg.sender, false);
219             owner.send(msg.value);
220             Confirmed(msg.sender);
221         } else {
222             revert();
223         }
224     }
225     
226     event Reserved(address indexed _to, uint256[] _tickets);
227     event Confirmed(address indexed _to);
228     event TransferStarted(address indexed _from, address indexed _to, uint256[] _tickets, uint256 _transferID);
229     event Transferred(uint256 _transferID);
230     event Banned(address indexed _banned, bool payback);
231     
232 }