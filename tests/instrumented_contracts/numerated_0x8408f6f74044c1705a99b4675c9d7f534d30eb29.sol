1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4     address public owner;
5 
6     function Ownable() public {
7         owner = msg.sender;
8     }
9     
10     modifier onlyOwner() {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function changeOwner(address newOwner) onlyOwner public {
16         require(newOwner != address(0));
17         owner = newOwner;
18     }
19 }
20 
21 contract Withdrawable {
22 
23     mapping (address => uint) public pendingWithdrawals;
24 
25     function withdraw() public {
26         uint amount = pendingWithdrawals[msg.sender];
27         
28         require(amount > 0);
29         require(this.balance >= amount);
30 
31         pendingWithdrawals[msg.sender] = 0;
32         msg.sender.transfer(amount);
33     }
34 }
35 
36 /**
37  * @title EthLottery
38  */
39 contract EthLottery is Withdrawable, Ownable {
40 
41     event onTicketPurchase(uint32 lotteryId, address buyer, uint16[] tickets);
42     event onLotteryCompleted(uint32 lotteryId);
43     event onLotteryFinalized(uint32 lotteryId);
44     event onLotteryInsurance(address claimer);
45 
46     uint32 public lotteryId;
47     
48     struct Lottery {        
49         uint8 ownerCut;
50 
51         uint ticketPrice;
52         uint16 numTickets;
53         uint16 winningTicket;
54         
55         mapping (uint16 => address) tickets;
56         mapping (address => uint16) ticketsPerAddress;
57         
58         address winner;
59         
60         uint16[] ticketsSold;
61         address[] ticketOwners;
62 
63         bytes32 serverHash;
64         bytes32 serverSalt;
65         uint serverRoll; 
66 
67         uint lastSaleTimestamp;
68     }
69 
70     mapping (uint32 => Lottery) lotteries;
71     
72     // Init Lottery. 
73     function initLottery(uint16 numTickets, uint ticketPrice, uint8 ownerCut, bytes32 serverHash) onlyOwner public {
74         require(ownerCut < 100);
75                 
76         lotteryId += 1;
77 
78         lotteries[lotteryId].ownerCut = ownerCut;
79         lotteries[lotteryId].ticketPrice = ticketPrice;
80         lotteries[lotteryId].numTickets = numTickets;
81         lotteries[lotteryId].serverHash = serverHash;
82     }
83 
84     function getLotteryDetails(uint16 lottId) public constant returns (
85         uint8 ownerCut,
86         uint ticketPrice,
87         //
88         uint16 numTickets, 
89         uint16 winningTicket,
90         //
91         bytes32 serverHash,
92         bytes32 serverSalt,
93         uint serverRoll,
94         //
95         uint lastSaleTimestamp,
96         //
97         address winner,
98         uint16[] ticketsSold, 
99         address[] ticketOwners
100     ) {
101         ownerCut = lotteries[lottId].ownerCut;
102         ticketPrice = lotteries[lottId].ticketPrice;
103         //
104         numTickets = lotteries[lottId].numTickets;
105         winningTicket = lotteries[lottId].winningTicket;
106         //
107         serverHash = lotteries[lottId].serverHash;
108         serverSalt = lotteries[lottId].serverSalt;
109         serverRoll = lotteries[lottId].serverRoll; 
110         //
111         lastSaleTimestamp = lotteries[lottId].lastSaleTimestamp;
112         //
113         winner = lotteries[lottId].winner;
114         ticketsSold = lotteries[lottId].ticketsSold;
115         ticketOwners = lotteries[lottId].ticketOwners;
116     }
117 
118     function purchaseTicket(uint16 lottId, uint16[] tickets) public payable {
119 
120         // Checks on Lottery
121         require(lotteries[lottId].winner == address(0));
122         require(lotteries[lottId].ticketsSold.length < lotteries[lottId].numTickets);
123 
124         // Checks on tickets
125         require(tickets.length > 0);
126         require(tickets.length <= lotteries[lottId].numTickets);
127         require(tickets.length * lotteries[lottId].ticketPrice == msg.value);
128 
129         for (uint16 i = 0; i < tickets.length; i++) {
130             
131             uint16 ticket = tickets[i];
132 
133             // Check number is OK and not Sold
134             require(lotteries[lottId].numTickets > ticket);
135             require(lotteries[lottId].tickets[ticket] == 0);
136             
137             // Ticket checks passed OK
138             lotteries[lottId].ticketsSold.push(ticket);
139             lotteries[lottId].ticketOwners.push(msg.sender);
140 
141             // Save who's buying this ticket
142             lotteries[lottId].tickets[ticket] = msg.sender;
143         }
144 
145         // Add amount of tickets bought to this address
146         lotteries[lottId].ticketsPerAddress[msg.sender] += uint16(tickets.length);
147 
148         // Save last timestamp of sale
149         lotteries[lottId].lastSaleTimestamp = now;
150 
151         onTicketPurchase(lottId, msg.sender, tickets);
152 
153         // Send event on all tickets sold. 
154         if (lotteries[lottId].ticketsSold.length == lotteries[lottId].numTickets) {
155             onLotteryCompleted(lottId);
156         }
157     }
158 
159     function finalizeLottery(uint16 lottId, bytes32 serverSalt, uint serverRoll) onlyOwner public {
160         
161         // Check lottery not Closed and completed
162         require(lotteries[lottId].winner == address(0));
163         require(lotteries[lottId].ticketsSold.length == lotteries[lottId].numTickets);
164 
165         // If it's been less than two hours from the sale of the last ticket.
166         require((lotteries[lottId].lastSaleTimestamp + 2 hours) >= now);
167 
168         // Check fairness of server roll here
169         require(keccak256(serverSalt, serverRoll) == lotteries[lottId].serverHash);
170         
171         // Final Number is based on server roll and lastSaleTimestamp. 
172         uint16 winningTicket = uint16(
173             addmod(serverRoll, lotteries[lottId].lastSaleTimestamp, lotteries[lottId].numTickets)
174         );
175         address winner = lotteries[lottId].tickets[winningTicket];
176         
177         lotteries[lottId].winner = winner;
178         lotteries[lottId].winningTicket = winningTicket;
179 
180         // Send funds to owner and winner
181         uint vol = lotteries[lottId].numTickets * lotteries[lottId].ticketPrice;
182 
183         pendingWithdrawals[owner] += (vol * lotteries[lottId].ownerCut) / 100;
184         pendingWithdrawals[winner] += (vol * (100 - lotteries[lottId].ownerCut)) / 100;
185 
186         onLotteryFinalized(lottId);
187     }
188 
189     function lotteryCloseInsurance(uint16 lottId) public {
190         
191         // Check lottery is still open and all tickets were sold. 
192         require(lotteries[lottId].winner == address(0));
193         require(lotteries[lottId].ticketsSold.length == lotteries[lottId].numTickets);
194         
195         // If it's been more than two hours from the sale of the last ticket.
196         require((lotteries[lottId].lastSaleTimestamp + 2 hours) < now);
197             
198         // Check caller hash bought tickets for this lottery
199         require(lotteries[lottId].ticketsPerAddress[msg.sender] > 0);
200 
201         uint16 numTickets = lotteries[lottId].ticketsPerAddress[msg.sender];
202 
203         // Send ticket refund to caller
204         lotteries[lottId].ticketsPerAddress[msg.sender] = 0;
205         pendingWithdrawals[msg.sender] += (lotteries[lottId].ticketPrice * numTickets);
206 
207         onLotteryInsurance(msg.sender);
208     }
209 }