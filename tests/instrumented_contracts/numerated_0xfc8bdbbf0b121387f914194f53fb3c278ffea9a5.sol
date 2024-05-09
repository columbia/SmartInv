1 pragma solidity ^0.4.0;
2 
3 contract SponsoredItemGooRaffle {
4     
5     Goo goo = Goo(0x57b116da40f21f91aec57329ecb763d29c1b2355);
6     
7     address owner;
8     
9     // Raffle tickets
10     mapping(address => TicketPurchases) private ticketsBoughtByPlayer;
11     mapping(uint256 => address[]) private rafflePlayers;
12 
13     // Current Raffle info
14     uint256 private constant RAFFLE_TICKET_BASE_GOO_PRICE = 1000;
15     uint256 private raffleEndTime;
16     uint256 private raffleTicketsBought;
17     uint256 private raffleId;
18     address private raffleWinner;
19     bool private raffleWinningTicketSelected;
20     uint256 private raffleTicketThatWon;
21     
22     
23     // Raffle structures
24     struct TicketPurchases {
25         TicketPurchase[] ticketsBought;
26         uint256 numPurchases; // Allows us to reset without clearing TicketPurchase[] (avoids potential for gas limit)
27         uint256 raffleId;
28     }
29     
30     // Allows us to query winner without looping (avoiding potential for gas limit)
31     struct TicketPurchase {
32         uint256 startId;
33         uint256 endId;
34     }
35     
36     function SponsoredItemGooRaffle() public {
37         owner = msg.sender;
38     }
39     
40     function startTokenRaffle(uint256 endTime, address tokenContract, uint256 id, bool hasItemAlready) external {
41         require(msg.sender == owner);
42         require(block.timestamp < endTime);
43         
44         if (raffleId != 0) { // Sanity to assure raffle has ended before next one starts
45             require(raffleWinner != 0);
46         }
47         
48         // Reset previous raffle info
49         raffleWinningTicketSelected = false;
50         raffleTicketThatWon = 0;
51         raffleWinner = 0;
52         raffleTicketsBought = 0;
53         
54         // Set current raffle info
55         raffleEndTime = endTime;
56         raffleId++;
57     }
58     
59 
60     function buyRaffleTicket(uint256 amount) external {
61         require(raffleEndTime >= block.timestamp);
62         require(amount > 0);
63         
64         uint256 ticketsCost = SafeMath.mul(RAFFLE_TICKET_BASE_GOO_PRICE, amount);
65         goo.transferFrom(msg.sender, this, ticketsCost);
66         // Burn 95% of the Goo (save 5% for contests / marketing fund)
67         goo.transfer(address(0), (ticketsCost * 95) / 100);
68         
69         // Handle new tickets
70         TicketPurchases storage purchases = ticketsBoughtByPlayer[msg.sender];
71         
72         // If we need to reset tickets from a previous raffle
73         if (purchases.raffleId != raffleId) {
74             purchases.numPurchases = 0;
75             purchases.raffleId = raffleId;
76             rafflePlayers[raffleId].push(msg.sender); // Add user to raffle
77         }
78         
79         // Store new ticket purchase
80         if (purchases.numPurchases == purchases.ticketsBought.length) {
81             purchases.ticketsBought.length += 1;
82         }
83         purchases.ticketsBought[purchases.numPurchases++] = TicketPurchase(raffleTicketsBought, raffleTicketsBought + (amount - 1)); // (eg: buy 10, get id's 0-9)
84         
85         // Finally update ticket total
86         raffleTicketsBought += amount;
87     }
88     
89     function awardRafflePrize(address checkWinner, uint256 checkIndex) external {
90         require(raffleEndTime < block.timestamp);
91         require(raffleWinner == 0);
92         
93         if (!raffleWinningTicketSelected) {
94             drawRandomWinner(); // Ideally do it in one call (gas limit cautious)
95         }
96         
97         // Reduce gas by (optionally) offering an address to _check_ for winner
98         if (checkWinner != 0) {
99             TicketPurchases storage tickets = ticketsBoughtByPlayer[checkWinner];
100             if (tickets.numPurchases > 0 && checkIndex < tickets.numPurchases && tickets.raffleId == raffleId) {
101                 TicketPurchase storage checkTicket = tickets.ticketsBought[checkIndex];
102                 if (raffleTicketThatWon >= checkTicket.startId && raffleTicketThatWon <= checkTicket.endId) {
103                     assignRaffleWinner(checkWinner); // WINNER!
104                     return;
105                 }
106             }
107         }
108         
109         // Otherwise just naively try to find the winner (will work until mass amounts of players)
110         for (uint256 i = 0; i < rafflePlayers[raffleId].length; i++) {
111             address player = rafflePlayers[raffleId][i];
112             TicketPurchases storage playersTickets = ticketsBoughtByPlayer[player];
113             
114             uint256 endIndex = playersTickets.numPurchases - 1;
115             // Minor optimization to avoid checking every single player
116             if (raffleTicketThatWon >= playersTickets.ticketsBought[0].startId && raffleTicketThatWon <= playersTickets.ticketsBought[endIndex].endId) {
117                 for (uint256 j = 0; j < playersTickets.numPurchases; j++) {
118                     TicketPurchase storage playerTicket = playersTickets.ticketsBought[j];
119                     if (raffleTicketThatWon >= playerTicket.startId && raffleTicketThatWon <= playerTicket.endId) {
120                         assignRaffleWinner(player); // WINNER!
121                         return;
122                     }
123                 }
124             }
125         }
126     }
127     
128     function assignRaffleWinner(address winner) internal {
129         raffleWinner = winner;
130     }
131     
132     // Random enough for small contests (Owner only to prevent trial & error execution)
133     function drawRandomWinner() public {
134         require(msg.sender == owner);
135         require(raffleEndTime < block.timestamp);
136         require(!raffleWinningTicketSelected);
137         
138         uint256 seed = raffleTicketsBought + block.timestamp;
139         raffleTicketThatWon = addmod(uint256(block.blockhash(block.number-1)), seed, (raffleTicketsBought + 1));
140         raffleWinningTicketSelected = true;
141     }
142     
143     // 5% of Goo gained will be reinvested into the game (contests / marketing / acquiring more raffle assets)
144     function transferGoo(address recipient, uint256 amount) external {
145         require(msg.sender == owner);
146         goo.transfer(recipient, amount);
147     }
148     
149      // To display on website
150     function getLatestRaffleInfo() external constant returns (uint256, uint256, uint256, address, uint256) {
151         return (raffleEndTime, raffleId, raffleTicketsBought, raffleWinner, raffleTicketThatWon);
152     }
153     
154     // To allow clients to verify contestants
155     function getRafflePlayers(uint256 raffle) external constant returns (address[]) {
156         return (rafflePlayers[raffle]);
157     }
158     
159      // To allow clients to verify contestants
160     function getPlayersTickets(address player) external constant returns (uint256[], uint256[]) {
161         TicketPurchases storage playersTickets = ticketsBoughtByPlayer[player];
162         
163         if (playersTickets.raffleId == raffleId) {
164             uint256[] memory startIds = new uint256[](playersTickets.numPurchases);
165             uint256[] memory endIds = new uint256[](playersTickets.numPurchases);
166             
167             for (uint256 i = 0; i < playersTickets.numPurchases; i++) {
168                 startIds[i] = playersTickets.ticketsBought[i].startId;
169                 endIds[i] = playersTickets.ticketsBought[i].endId;
170             }
171         }
172         
173         return (startIds, endIds);
174     }
175 }
176 
177 
178 interface Goo {
179     function transfer(address to, uint tokens) public returns (bool success);
180     function transferFrom(address from, address to, uint tokens) public returns (bool success);
181 }
182 
183 library SafeMath {
184 
185   /**
186   * @dev Multiplies two numbers, throws on overflow.
187   */
188   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
189     if (a == 0) {
190       return 0;
191     }
192     uint256 c = a * b;
193     assert(c / a == b);
194     return c;
195   }
196 
197   /**
198   * @dev Integer division of two numbers, truncating the quotient.
199   */
200   function div(uint256 a, uint256 b) internal pure returns (uint256) {
201     // assert(b > 0); // Solidity automatically throws when dividing by 0
202     uint256 c = a / b;
203     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
204     return c;
205   }
206 
207   /**
208   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
209   */
210   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
211     assert(b <= a);
212     return a - b;
213   }
214 
215   /**
216   * @dev Adds two numbers, throws on overflow.
217   */
218   function add(uint256 a, uint256 b) internal pure returns (uint256) {
219     uint256 c = a + b;
220     assert(c >= a);
221     return c;
222   }
223 }