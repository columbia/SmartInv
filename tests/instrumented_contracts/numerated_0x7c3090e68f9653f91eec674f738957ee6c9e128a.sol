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
36     uint256 eventDate;
37     
38     function tickets(uint256[] ticks, uint256 nOfSeats, string n, uint256 eD) {
39         for(uint256 i=0;i<nOfSeats;i++) {
40             ticketPrices[i] = ticks[i];
41         }
42         noOfSeats = nOfSeats;
43         name = n;
44         owner = msg.sender;
45         eventDate = eD;
46     }
47     
48     function reserveSeats(uint256[] seats, uint256 nOfSeats) {
49         if(noOfreservations[msg.sender] != 0 && !banned[msg.sender]) {
50             revert();
51         }
52         resetReservationsInternal();
53         uint256 price = 0;
54         for(uint256 i=0;i<nOfSeats;i++) {
55             if(ticketsOwned[seats[i]] != 0x0) {
56                 revert();
57             }
58             reservations[msg.sender].push(seats[i]);
59             price += ticketPrices[seats[i]];
60             ticketsOwned[seats[i]] = msg.sender;
61         }
62         noOfreservations[msg.sender] = nOfSeats;
63         timeOfreservations[msg.sender] = now;
64         priceOfreservations[msg.sender] = price;
65         noOfTicketsOwned[msg.sender]++;
66         highestAddressReserving++;
67         Reserved(msg.sender, seats);
68     }
69     
70     function resetReservations(address requester, bool resetOwn) {
71         if(noOfreservations[requester] == 0) {
72             throw;
73         }
74         for(uint256 i=0;i<noOfreservations[requester] && resetOwn;i++) {
75             ticketsOwned[reservations[requester][i]] = 0x0;
76             noOfTicketsOwned[msg.sender]--;
77         }
78         reservations[requester] = new uint256[](0);
79         noOfreservations[requester] = 0;
80         timeOfreservations[requester] = 0;
81         priceOfreservations[requester] = 0;
82     }
83     
84     function resetReservationsInternal() private {
85         bool pastTheLowest = false;
86         bool stop = false;
87         for(uint256 i=lowestAddressReserving;i<highestAddressReserving && !stop;i++) {
88             if(timeOfreservations[addressesReserving[i]] != 0) {
89                 pastTheLowest = true;
90                 if(now - timeOfreservations[addressesReserving[i]] > secondsToHold) {
91                     resetReservations(addressesReserving[i], true);
92                 } else {
93                     stop = true;
94                 }
95             }
96             if(timeOfreservations[addressesReserving[i]] == 0 && !pastTheLowest) {
97                 lowestAddressReserving = i;
98             }
99             
100         }
101     }
102     
103     function revokeTickets(address revokee, bool payback) payable {
104         if(msg.sender == owner) {
105             banned[revokee] = true;
106             uint256 price = 0;
107             for(uint256 i=0;i<noOfTicketsOwned[revokee];i++) {
108                 ticketsOwned[ticketsOwners[revokee][i]] = 0x0;
109                 price+=ticketPrices[ticketsOwners[revokee][i]];
110             }
111             ticketsOwners[revokee] = new uint256[](0);
112             noOfTicketsOwned[revokee] = 0;
113             if(payback) {
114                 revokee.send(price);
115             }
116             Banned(revokee, payback);
117         }
118     }
119     
120     function InvokeTransfer(address transferee, uint256[] ticks, uint256 amount) {
121         if(amount>0 && getTransfer(msg.sender,transferee) != 100000000000000000) {
122             for(uint256 i=0;i<amount;i++) {
123                 ticketTransfers[ticketTransfersAmount].push(ticks[i]);
124             }
125             ticketTransferers[msg.sender][ticketTransferersAmount[msg.sender]++] = ticketTransfersAmount;
126             ticketTransferees[transferee][ticketTransfereesAmount[transferee]++] = ticketTransfersAmount;
127             ticketTransfersPerAmount[ticketTransfersAmount] = amount;
128             TransferStarted(msg.sender, transferee, ticks, ticketTransfersAmount++);
129         } else {
130             revert();
131         }
132     }
133     
134     function removeTransfer(uint256 transferID) {
135         bool transferer = false;
136         for(uint256 i=0;i<ticketTransferersAmount[msg.sender] && !transferer;i++) {
137             if(ticketTransferers[msg.sender][i] == transferID) {
138                 transferer = true;
139             }
140         }
141         if(transferer) {
142             ticketTransfers[transferID] = new uint256[](0);
143         } else {
144             revert();
145         }
146     }
147     
148     function finishTransfer(uint256 transferID) payable {
149         bool transferee = false;
150         for(uint256 j=0;j<ticketTransfereesAmount[msg.sender] && !transferee;j++) {
151             if(ticketTransferees[msg.sender][j] == transferID) {
152                 transferee = true;
153             }
154         }
155         if(!transferee) {
156             revert();
157         }
158         uint256 price = 0;
159         for(uint256 i=0;i<ticketTransfersPerAmount[transferID];i++) {
160             price += ticketPrices[ticketTransfers[transferID][i]];
161         }
162         if(msg.value == price) {
163             for(i=0;i<ticketTransfersPerAmount[transferID];i++) {
164                 ticketsOwned[ticketTransfers[transferID][i]] = msg.sender;
165             }
166             Transferred(transferID);
167         } else {
168             revert();
169         }
170     }
171     
172     function getTransfer(address transferer, address transferee) returns (uint256) {
173         for(uint256 i=0;i<ticketTransferersAmount[transferer];i++) {
174             for(uint256 j=0;j<ticketTransfereesAmount[transferee];j++) {
175                 if(ticketTransferers[transferer][i] == ticketTransferees[transferee][j]) {
176                     return ticketTransferees[transferee][j];
177                 }
178             }
179         }
180         return 100000000000000000;
181     }
182     
183     function returnTickets(uint256 ticketID) {
184         if(now < eventDate) {
185             if(ticketsOwned[ticketID] == msg.sender) {
186                 for(uint256 i=0;i<noOfTicketsOwned[msg.sender];i++) {
187                     if(ticketsOwners[msg.sender][i] == ticketID) {
188                         ticketsOwners[msg.sender][i] = 100000000000000000;
189                     }
190                 }
191                 ticketsOwned[ticketID] = 0x0;
192                 noOfTicketsOwned[msg.sender]--;
193                 msg.sender.send(ticketPrices[ticketID]);
194             } else {
195                 revert();
196             }
197         } else {
198             revert();
199         }
200     }
201     
202     function changePrice (uint256[] seats, uint256 nOfSeats) {
203         if(nOfSeats == noOfSeats) {
204             for(uint256 i = 0;i<noOfSeats;i++) {
205                 ticketPrices[i] = seats[i];
206             }
207         } else {
208             revert();
209         }
210     }
211     
212     function setHash(bytes32 hash) {
213         hashes[msg.sender] = hash;
214     }
215     
216     function checkHash(address a, string password) constant returns (bool) {
217         return hashes[a]!="" && hashes[a] == sha3(password);
218     }
219     
220     function end() {
221         if(msg.sender == owner) {
222             if(now > eventDate) {
223                 owner.send(this.balance);
224             }
225         } else {
226             revert();
227         }
228     }
229     
230     function() payable {
231         if(msg.value == priceOfreservations[msg.sender] && !banned[msg.sender]) {
232             for(uint256 i=0;i<noOfreservations[msg.sender];i++) {
233                 ticketsOwners[msg.sender].push(reservations[msg.sender][i]);
234             }
235             resetReservations(msg.sender, false);
236             Confirmed(msg.sender);
237         } else {
238             revert();
239         }
240     }
241     
242     event Reserved(address indexed _to, uint256[] _tickets);
243     event Confirmed(address indexed _to);
244     event TransferStarted(address indexed _from, address indexed _to, uint256[] _tickets, uint256 _transferID);
245     event Transferred(uint256 _transferID);
246     event Banned(address indexed _banned, bool payback);
247     
248 }