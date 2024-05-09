1 pragma solidity ^0.4.0;
2 
3 // GOO
4 // ~~ https://ethergoo.io ~~
5 
6 // Allows players to purchase tickets for rare ERC721 items using Goo! (ERC20)
7 // Get in touch if you are a game with ERC721 items and wish to sponsor us (in return for raffle-placement on our main game page)
8 
9 contract SponsoredItemGooRaffle {
10     
11     Goo goo = Goo(0x57b116da40f21f91aec57329ecb763d29c1b2355);
12     
13     ERC721 erc;
14     uint256 tokenId;
15     address owner;
16     
17     // Raffle tickets
18     mapping(address => TicketPurchases) private ticketsBoughtByPlayer;
19     mapping(uint256 => address[]) private rafflePlayers;
20 
21     // Current Raffle info
22     uint256 private constant RAFFLE_TICKET_BASE_GOO_PRICE = 1000;
23     uint256 private raffleEndTime;
24     uint256 private raffleTicketsBought;
25     uint256 private raffleId;
26     address private raffleWinner;
27     bool private raffleWinningTicketSelected;
28     uint256 private raffleTicketThatWon;
29     
30     
31     // Raffle structures
32     struct TicketPurchases {
33         TicketPurchase[] ticketsBought;
34         uint256 numPurchases; // Allows us to reset without clearing TicketPurchase[] (avoids potential for gas limit)
35         uint256 raffleId;
36     }
37     
38     // Allows us to query winner without looping (avoiding potential for gas limit)
39     struct TicketPurchase {
40         uint256 startId;
41         uint256 endId;
42     }
43     
44     function SponsoredItemGooRaffle() public {
45         owner = msg.sender;
46     }
47     
48     function startTokenRaffle(uint256 endTime, address tokenContract, uint256 id) external {
49         require(msg.sender == owner);
50         require(block.timestamp < endTime);
51         
52         // Grab ownership of token
53         erc = ERC721(tokenContract);
54         tokenId = id;
55         erc.transferFrom(msg.sender, this, id);
56         
57         if (raffleId != 0) { // Sanity to assure raffle has ended before next one starts
58             require(raffleWinner != 0);
59         }
60         
61         // Reset previous raffle info
62         raffleWinningTicketSelected = false;
63         raffleTicketThatWon = 0;
64         raffleWinner = 0;
65         raffleTicketsBought = 0;
66         
67         // Set current raffle info
68         raffleEndTime = endTime;
69         raffleId++;
70     }
71     
72 
73     function buyRaffleTicket(uint256 amount) external {
74         require(raffleEndTime >= block.timestamp);
75         require(amount > 0);
76         
77         uint256 ticketsCost = SafeMath.mul(RAFFLE_TICKET_BASE_GOO_PRICE, amount);
78         goo.transferFrom(msg.sender, this, ticketsCost);
79         // Burn 95% of the Goo (save 5% for contests / marketing fund)
80         goo.transfer(address(0), (ticketsCost * 95) / 100);
81         
82         // Handle new tickets
83         TicketPurchases storage purchases = ticketsBoughtByPlayer[msg.sender];
84         
85         // If we need to reset tickets from a previous raffle
86         if (purchases.raffleId != raffleId) {
87             purchases.numPurchases = 0;
88             purchases.raffleId = raffleId;
89             rafflePlayers[raffleId].push(msg.sender); // Add user to raffle
90         }
91         
92         // Store new ticket purchase
93         if (purchases.numPurchases == purchases.ticketsBought.length) {
94             purchases.ticketsBought.length += 1;
95         }
96         purchases.ticketsBought[purchases.numPurchases++] = TicketPurchase(raffleTicketsBought, raffleTicketsBought + (amount - 1)); // (eg: buy 10, get id's 0-9)
97         
98         // Finally update ticket total
99         raffleTicketsBought += amount;
100     }
101     
102     function awardRafflePrize(address checkWinner, uint256 checkIndex) external {
103         require(raffleEndTime < block.timestamp);
104         require(raffleWinner == 0);
105         require(erc.ownerOf(tokenId) == address(this));
106         
107         if (!raffleWinningTicketSelected) {
108             drawRandomWinner(); // Ideally do it in one call (gas limit cautious)
109         }
110         
111         // Reduce gas by (optionally) offering an address to _check_ for winner
112         if (checkWinner != 0) {
113             TicketPurchases storage tickets = ticketsBoughtByPlayer[checkWinner];
114             if (tickets.numPurchases > 0 && checkIndex < tickets.numPurchases && tickets.raffleId == raffleId) {
115                 TicketPurchase storage checkTicket = tickets.ticketsBought[checkIndex];
116                 if (raffleTicketThatWon >= checkTicket.startId && raffleTicketThatWon <= checkTicket.endId) {
117                     assignRafflePrize(checkWinner); // WINNER!
118                     return;
119                 }
120             }
121         }
122         
123         // Otherwise just naively try to find the winner (will work until mass amounts of players)
124         for (uint256 i = 0; i < rafflePlayers[raffleId].length; i++) {
125             address player = rafflePlayers[raffleId][i];
126             TicketPurchases storage playersTickets = ticketsBoughtByPlayer[player];
127             
128             uint256 endIndex = playersTickets.numPurchases - 1;
129             // Minor optimization to avoid checking every single player
130             if (raffleTicketThatWon >= playersTickets.ticketsBought[0].startId && raffleTicketThatWon <= playersTickets.ticketsBought[endIndex].endId) {
131                 for (uint256 j = 0; j < playersTickets.numPurchases; j++) {
132                     TicketPurchase storage playerTicket = playersTickets.ticketsBought[j];
133                     if (raffleTicketThatWon >= playerTicket.startId && raffleTicketThatWon <= playerTicket.endId) {
134                         assignRafflePrize(player); // WINNER!
135                         return;
136                     }
137                 }
138             }
139         }
140     }
141     
142     function assignRafflePrize(address winner) internal {
143         raffleWinner = winner;
144         erc.transfer(winner, tokenId);
145     }
146     
147     // Random enough for small contests (Owner only to prevent trial & error execution)
148     function drawRandomWinner() public {
149         require(msg.sender == owner);
150         require(raffleEndTime < block.timestamp);
151         require(!raffleWinningTicketSelected);
152         
153         uint256 seed = raffleTicketsBought + block.timestamp;
154         raffleTicketThatWon = addmod(uint256(block.blockhash(block.number-1)), seed, (raffleTicketsBought + 1));
155         raffleWinningTicketSelected = true;
156     }
157     
158     // 5% of Goo gained will be reinvested into the game (contests / marketing / acquiring more raffle assets)
159     function transferGoo(address recipient, uint256 amount) external {
160         require(msg.sender == owner);
161         goo.transfer(recipient, amount);
162     }
163     
164      // To display on website
165     function getLatestRaffleInfo() external constant returns (uint256, uint256, uint256, address, uint256) {
166         return (raffleEndTime, raffleId, raffleTicketsBought, raffleWinner, raffleTicketThatWon);
167     }
168     
169     // To allow clients to verify contestants
170     function getRafflePlayers(uint256 raffle) external constant returns (address[]) {
171         return (rafflePlayers[raffle]);
172     }
173     
174      // To allow clients to verify contestants
175     function getPlayersTickets(address player) external constant returns (uint256[], uint256[]) {
176         TicketPurchases storage playersTickets = ticketsBoughtByPlayer[player];
177         
178         if (playersTickets.raffleId == raffleId) {
179             uint256[] memory startIds = new uint256[](playersTickets.numPurchases);
180             uint256[] memory endIds = new uint256[](playersTickets.numPurchases);
181             
182             for (uint256 i = 0; i < playersTickets.numPurchases; i++) {
183                 startIds[i] = playersTickets.ticketsBought[i].startId;
184                 endIds[i] = playersTickets.ticketsBought[i].endId;
185             }
186         }
187         
188         return (startIds, endIds);
189     }
190 }
191 
192 
193 interface Goo {
194     function transfer(address to, uint tokens) public returns (bool success);
195     function transferFrom(address from, address to, uint tokens) public returns (bool success);
196 }
197 
198 
199 interface ERC721 {
200     function transfer(address to, uint tokenId) public payable;
201     function transferFrom(address from, address to, uint tokenId) public;
202     function ownerOf(uint tokenId) public view returns (address owner);
203 }
204 
205 
206 library SafeMath {
207 
208   /**
209   * @dev Multiplies two numbers, throws on overflow.
210   */
211   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
212     if (a == 0) {
213       return 0;
214     }
215     uint256 c = a * b;
216     assert(c / a == b);
217     return c;
218   }
219 
220   /**
221   * @dev Integer division of two numbers, truncating the quotient.
222   */
223   function div(uint256 a, uint256 b) internal pure returns (uint256) {
224     // assert(b > 0); // Solidity automatically throws when dividing by 0
225     uint256 c = a / b;
226     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
227     return c;
228   }
229 
230   /**
231   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
232   */
233   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
234     assert(b <= a);
235     return a - b;
236   }
237 
238   /**
239   * @dev Adds two numbers, throws on overflow.
240   */
241   function add(uint256 a, uint256 b) internal pure returns (uint256) {
242     uint256 c = a + b;
243     assert(c >= a);
244     return c;
245   }
246 }