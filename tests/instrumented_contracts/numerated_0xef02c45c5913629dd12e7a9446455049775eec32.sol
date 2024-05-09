1 pragma solidity ^0.4.8;
2 
3 contract RuletkaIo {
4     
5     /*** EVENTS ***/
6     
7     /// @dev A russian Roulette has been executed between 6 players
8     /// in room roomId and unfortunately, victim got shot and didn't 
9     /// make it out alive... RIP
10     event partyOver(uint256 roomId, address victim, address[] winners);
11 
12     /// @dev A new player has enter a room
13     event newPlayer(uint256 roomId, address player);
14     
15     /// @dev A room is full, we close the door. Game can start.
16     event fullRoom(uint256 roomId);
17     
18     /// @dev A safety mechanism has been triggered to empty the room and refund entirely the players (Should never happen)
19     event  roomRefunded(uint256 _roomId, address[] refundedPlayers);
20 
21     /*** Founders addresses ***/
22     address CTO;
23     address CEO;
24     
25      Room[] private allRooms;
26 
27     function () public payable {} // Give the ability of receiving ether
28 
29     function RuletkaIo() public {
30         CTO = msg.sender;
31         CEO = msg.sender;
32     }
33     
34     /*** ACCESS MODIFIERS ***/
35     /// @dev Access modifier for CTO-only functionality
36     modifier onlyCTO() {
37         require(msg.sender == CTO);
38         _;
39     }
40     
41     /// @dev Assigns a new address to act as the CTO.
42     /// @param _newCTO The address of the new CTO
43     function setCTO(address _newCTO) public onlyCTO {
44         require(_newCTO != address(0));
45         CTO = _newCTO;
46     }
47     
48     /// @dev Assigns a new address to act as the CEO.
49     /// @param _newCEO The address of the new CEO
50     function setCEO(address _newCEO) public onlyCTO {
51         require(_newCEO != address(0));
52         CEO = _newCEO;
53     }
54     
55     /*** DATATYPES ***/
56       struct Room {
57         string name;
58         uint256 entryPrice; //  The price to enter the room and play Russian Roulette
59         uint256 balance;
60         address[] players;
61       }
62     
63     
64     /// For creating Room
65   function createRoom(string _name, uint256 _entryPrice) public onlyCTO{
66     address[] memory players;
67     Room memory _room = Room({
68       name: _name,
69       players: players,
70       balance: 0,
71       entryPrice: _entryPrice
72     });
73 
74     allRooms.push(_room);
75   }
76     
77     function enter(uint256 _roomId) public payable {
78         Room storage room = allRooms[_roomId-1]; //if _roomId doesn't exist in array, exits.
79         
80         require(room.players.length < 6);
81         require(msg.value >= room.entryPrice);
82         
83         room.players.push(msg.sender);
84         room.balance += room.entryPrice;
85         
86         emit newPlayer(_roomId, msg.sender);
87         
88         if(room.players.length == 6){
89             executeRoom(_roomId);
90         }
91     }
92     
93     function enterWithReferral(uint256 _roomId, address referrer) public payable {
94         
95         Room storage room = allRooms[_roomId-1]; //if _roomId doesn't exist in array, exits.
96         
97         require(room.players.length < 6);
98         require(msg.value >= room.entryPrice);
99         
100         uint256 referrerCut = SafeMath.div(room.entryPrice, 100); // Referrer get one percent of the bet as reward
101         referrer.transfer(referrerCut);
102          
103         room.players.push(msg.sender);
104         room.balance += room.entryPrice - referrerCut;
105         
106         emit newPlayer(_roomId, msg.sender);
107         
108         if(room.players.length == 6){
109             emit fullRoom(_roomId);
110             executeRoom(_roomId);
111         }
112     }
113     
114     function executeRoom(uint256 _roomId) public {
115         
116         Room storage room = allRooms[_roomId-1]; //if _roomId doesn't exist in array, exits.
117         
118         //Check if the room is really full before shooting people...
119         require(room.players.length == 6);
120         
121         uint256 halfFee = SafeMath.div(room.entryPrice, 20);
122         CTO.transfer(halfFee);
123         CEO.transfer(halfFee);
124         room.balance -= halfFee * 2;
125         
126         uint256 deadSeat = random();
127         
128         distributeFunds(_roomId, deadSeat);
129         
130         delete room.players;
131     }
132     
133     function distributeFunds(uint256 _roomId, uint256 _deadSeat) private returns(uint256) {
134         
135         Room storage room = allRooms[_roomId-1]; //if _roomId doesn't exist in array, exits.
136         uint256 balanceToDistribute = SafeMath.div(room.balance,5);
137         
138         address victim = room.players[_deadSeat];
139         address[] memory winners = new address[](5);
140         uint256 j = 0; 
141         for (uint i = 0; i<6; i++) {
142             if(i != _deadSeat){
143                room.players[i].transfer(balanceToDistribute);
144                room.balance -= balanceToDistribute;
145                winners[j] = room.players[i];
146                j++;
147             }
148         }
149         
150         emit partyOver(_roomId, victim, winners);
151        
152         return address(this).balance;
153     }
154     
155      /// @dev Empty the room and refund each player. Safety mechanism which shouldn't be used.
156     /// @param _roomId The Room id to empty and refund
157     function refundPlayersInRoom(uint256 _roomId) public onlyCTO{
158         Room storage room = allRooms[_roomId-1]; //if _roomId doesn't exist in array, exits.
159         uint256 nbrOfPlayers = room.players.length;
160         uint256 balanceToRefund = SafeMath.div(room.balance,nbrOfPlayers);
161         for (uint i = 0; i<nbrOfPlayers; i++) {
162              room.players[i].transfer(balanceToRefund);
163              room.balance -= balanceToRefund;
164         }
165         
166         emit roomRefunded(_roomId, room.players);
167         delete room.players;
168     }
169     
170     
171     /// @dev A clean and efficient way to generate random and make sure that it
172     /// will remain the same accross the executing nodes of random value 
173     /// Ethereum Blockchain. We base our computation on the block.timestamp
174     /// and difficulty which will remain the same accross the nodes to ensure
175     /// same result for the same execution.
176     function random() private view returns (uint256) {
177         return uint256(uint256(keccak256(block.timestamp, block.difficulty))%6);
178     }
179     
180     function getRoom(uint256 _roomId) public view returns (
181     string name,
182     address[] players,
183     uint256 entryPrice,
184     uint256 balance
185   ) {
186     Room storage room = allRooms[_roomId-1];
187     name = room.name;
188     players = room.players;
189     entryPrice = room.entryPrice;
190     balance = room.balance;
191   }
192   
193   function payout(address _to) public onlyCTO {
194     _payout(_to);
195   }
196 
197   /// For paying out balance on contract
198   function _payout(address _to) private {
199     if (_to == address(0)) {
200       CTO.transfer(SafeMath.div(address(this).balance, 2));
201       CEO.transfer(address(this).balance);
202     } else {
203       _to.transfer(address(this).balance);
204     }
205   }
206   
207 }
208 
209 library SafeMath {
210 
211   /**
212   * @dev Multiplies two numbers, throws on overflow.
213   */
214   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
215     if (a == 0) {
216       return 0;
217     }
218     uint256 c = a * b;
219     assert(c / a == b);
220     return c;
221   }
222 
223   /**
224   * @dev Integer division of two numbers, truncating the quotient.
225   */
226   function div(uint256 a, uint256 b) internal pure returns (uint256) {
227     // assert(b > 0); // Solidity automatically throws when dividing by 0
228     uint256 c = a / b;
229     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
230     return c;
231   }
232 
233   /**
234   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
235   */
236   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
237     assert(b <= a);
238     return a - b;
239   }
240 
241   /**
242   * @dev Adds two numbers, throws on overflow.
243   */
244   function add(uint256 a, uint256 b) internal pure returns (uint256) {
245     uint256 c = a + b;
246     assert(c >= a);
247     return c;
248   }
249 }