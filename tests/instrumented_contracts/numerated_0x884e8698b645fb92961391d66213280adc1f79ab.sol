1 pragma solidity ^0.4.20;
2 
3 /**''''''
4  *  ====    ;
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     uint256 c = a / b;
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 /**
33  * @title Ownable
34  * @dev The Ownable contract has an owner address, and provides basic authorization control
35  * functions, this simplifies the implementation of "user permissions".
36  */
37 contract Ownable {
38   address public owner;
39 
40 
41   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43 
44 
45   function Ownable() {
46     owner = msg.sender;
47   }
48 
49 
50 
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55 
56 
57  
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 }
64 
65 contract POH is Ownable {
66 
67   string public constant name = "POH Lottery";
68   uint public playersRequired = 125000;
69   uint256 public priceOfTicket = 1e15 wei;
70 
71   event newWinner(address winner, uint256 ticketNumber);
72   // event newRandomNumber_bytes(bytes);
73   // event newRandomNumber_uint(uint);
74   event newContribution(address contributor, uint value);
75 
76   using SafeMath for uint256;
77   address[] public players = new address[](399);
78   uint256 public lastTicketNumber = 0;
79   uint8 public playersSignedUp = 0;
80   uint public blockMinedAt;
81   uint public amountwon;
82   address public TheWinner;
83   uint public amounRefferalWon;
84   address public theWinningReferral;
85   uint public randomNumber;
86   uint public balanceOfPot = this.balance;
87 
88   struct tickets {
89     uint256 startTicket;
90     uint256 endTicket;
91   }
92 
93   mapping (address => tickets[])  ticketsMap;
94   mapping(address => address) public referral;
95   mapping (address => uint256) public contributions;
96   function updateFileds(uint256 _playersRequired, uint256 _priceOfTicket) onlyOwner{
97       playersRequired = _playersRequired;
98       priceOfTicket = _priceOfTicket;
99   }
100 
101   function executeLottery() { 
102       
103         if (playersSignedUp > playersRequired-1) {
104           randomNumber = uint(blockhash(block.number-1))%lastTicketNumber + 1;
105           address  winner;
106           bool hasWon;
107           for (uint8 i = 0; i < playersSignedUp; i++) {
108             address player = players[i];
109             for (uint j = 0; j < ticketsMap[player].length; j++) {
110               uint256 start = ticketsMap[player][j].startTicket;
111               uint256 end = ticketsMap[player][j].endTicket;
112               if (randomNumber >= start && randomNumber < end) {
113                 winner = player;
114                 hasWon = true;
115                 break;
116               }
117             }
118             if(hasWon) break;
119           }
120           require(winner!=address(0) && hasWon);
121 
122           for (uint8 k = 0; k < playersSignedUp; k++) {
123             delete ticketsMap[players[k]];
124             delete contributions[players[k]];
125           }
126 
127           playersSignedUp = 0;
128           lastTicketNumber = 0;
129           blockMinedAt = block.number;
130 
131           uint balance = this.balance;
132           balanceOfPot = balance;
133           amountwon = (balance*80)/100;
134           TheWinner = winner;
135           if (!owner.send(balance/10)) throw;
136           if(referral[winner] != 0x0000000000000000000000000000000000000000){
137               amounRefferalWon = (amountwon*10)/100;
138               referral[winner].send(amounRefferalWon);
139               winner.send(amountwon*90/100);
140               theWinningReferral = referral[winner];
141           }
142           else{
143               if (!winner.send(amountwon)) throw;
144           }
145           newWinner(winner, randomNumber);
146           
147         }
148       
149   }
150 
151   function getPlayers() constant returns (address[], uint256[]) {
152     address[] memory addrs = new address[](playersSignedUp);
153     uint256[] memory _contributions = new uint256[](playersSignedUp);
154     for (uint i = 0; i < playersSignedUp; i++) {
155       addrs[i] = players[i];
156       _contributions[i] = contributions[players[i]];
157     }
158     return (addrs, _contributions);
159   }
160 
161   function getTickets(address _addr) constant returns (uint256[] _start, uint256[] _end) {
162     tickets[] tks = ticketsMap[_addr];
163     uint length = tks.length;
164     uint256[] memory startTickets = new uint256[](length);
165     uint256[] memory endTickets = new uint256[](length);
166     for (uint i = 0; i < length; i++) {
167       startTickets[i] = tks[i].startTicket;
168       endTickets[i] = tks[i].endTicket;
169     }
170     return (startTickets, endTickets);
171   }
172 
173   function join()  payable {
174     uint256 weiAmount = msg.value;
175     require(weiAmount >= 1e16);
176 
177     bool isSenderAdded = false;
178     for (uint8 i = 0; i < playersSignedUp; i++) {
179       if (players[i] == msg.sender) {
180         isSenderAdded = true;
181         break;
182       }
183     }
184     if (!isSenderAdded) {
185       players[playersSignedUp] = msg.sender;
186       playersSignedUp++;
187     }
188 
189     tickets memory senderTickets;
190     senderTickets.startTicket = lastTicketNumber;
191     uint256 numberOfTickets = (weiAmount/priceOfTicket);
192     senderTickets.endTicket = lastTicketNumber.add(numberOfTickets);
193     lastTicketNumber = lastTicketNumber.add(numberOfTickets);
194     ticketsMap[msg.sender].push(senderTickets);
195 
196     contributions[msg.sender] = contributions[msg.sender].add(weiAmount);
197 
198     newContribution(msg.sender, weiAmount);
199 
200     if(playersSignedUp > playersRequired) {
201       executeLottery();
202     }
203   }
204   
205     function joinwithreferral(address refer)  payable {
206     uint256 weiAmount = msg.value;
207     require(weiAmount >= 1e16);
208 
209     bool isSenderAdded = false;
210     for (uint8 i = 0; i < playersSignedUp; i++) {
211       if (players[i] == msg.sender) {
212         isSenderAdded = true;
213         break;
214       }
215     }
216     if (!isSenderAdded) {
217       players[playersSignedUp] = msg.sender;
218       referral[msg.sender] = refer;
219       playersSignedUp++;
220     }
221 
222     tickets memory senderTickets;
223     senderTickets.startTicket = lastTicketNumber;
224     uint256 numberOfTickets = (weiAmount/priceOfTicket);
225     senderTickets.endTicket = lastTicketNumber.add(numberOfTickets);
226     lastTicketNumber = lastTicketNumber.add(numberOfTickets);
227     ticketsMap[msg.sender].push(senderTickets);
228 
229     contributions[msg.sender] = contributions[msg.sender].add(weiAmount);
230 
231     newContribution(msg.sender, weiAmount);
232 
233     if(playersSignedUp > playersRequired) {
234       executeLottery();
235     }
236   }
237 }