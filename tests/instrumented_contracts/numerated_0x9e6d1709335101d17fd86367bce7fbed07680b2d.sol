1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0 uint256 c = a / b;
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner public {
68     require(newOwner != address(0));
69     OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 }
73 
74 contract Jackpot is Ownable {
75 
76   string public constant name = "Jackpot";
77 
78   event newWinner(address winner, uint256 ticketNumber);
79   // event newRandomNumber_bytes(bytes);
80   // event newRandomNumber_uint(uint);
81   event newContribution(address contributor, uint value);
82 
83   using SafeMath for uint256;
84   address[] public players = new address[](10);
85   uint256 public lastTicketNumber = 0;
86   uint8 public lastIndex = 0;
87 
88   struct tickets {
89     uint256 startTicket;
90     uint256 endTicket;
91   }
92 
93   mapping (address => tickets[]) public ticketsMap;
94   mapping (address => uint256) public contributions;
95 
96 
97   function executeLottery() { 
98       
99         if (lastIndex > 9) {
100           uint randomNumber = this.balance.mul(16807) % 2147483647;
101           randomNumber = randomNumber % lastTicketNumber;
102           address winner;
103           bool hasWon;
104           for (uint8 i = 0; i < lastIndex; i++) {
105             address player = players[i];
106             for (uint j = 0; j < ticketsMap[player].length; j++) {
107               uint256 start = ticketsMap[player][j].startTicket;
108               uint256 end = ticketsMap[player][j].endTicket;
109               if (randomNumber >= start && randomNumber < end) {
110                 winner = player;
111                 hasWon = true;
112                 break;
113               }
114             }
115             if(hasWon) break;
116           }
117           require(winner!=address(0) && hasWon);
118 
119           for (uint8 k = 0; k < lastIndex; k++) {
120             delete ticketsMap[players[k]];
121             delete contributions[players[k]];
122           }
123 
124           lastIndex = 0;
125           lastTicketNumber = 0;
126 
127           uint balance = this.balance;
128           if (!owner.send(balance/10)) throw;
129           //Both SafeMath.div and / throws on error
130           if (!winner.send(balance - balance/10)) throw;
131           newWinner(winner, randomNumber);
132           
133         }
134       
135   }
136 
137   function getPlayers() constant returns (address[], uint256[]) {
138     address[] memory addrs = new address[](lastIndex);
139     uint256[] memory _contributions = new uint256[](lastIndex);
140     for (uint i = 0; i < lastIndex; i++) {
141       addrs[i] = players[i];
142       _contributions[i] = contributions[players[i]];
143     }
144     return (addrs, _contributions);
145   }
146 
147   function getTickets(address _addr) constant returns (uint256[] _start, uint256[] _end) {
148     tickets[] tks = ticketsMap[_addr];
149     uint length = tks.length;
150     uint256[] memory startTickets = new uint256[](length);
151     uint256[] memory endTickets = new uint256[](length);
152     for (uint i = 0; i < length; i++) {
153       startTickets[i] = tks[i].startTicket;
154       endTickets[i] = tks[i].endTicket;
155     }
156     return (startTickets, endTickets);
157   }
158 
159   function() payable {
160     uint256 weiAmount = msg.value;
161     require(weiAmount >= 1e16);
162 
163     bool isSenderAdded = false;
164     for (uint8 i = 0; i < lastIndex; i++) {
165       if (players[i] == msg.sender) {
166         isSenderAdded = true;
167         break;
168       }
169     }
170     if (!isSenderAdded) {
171       players[lastIndex] = msg.sender;
172       lastIndex++;
173     }
174 
175     tickets memory senderTickets;
176     senderTickets.startTicket = lastTicketNumber;
177     uint256 numberOfTickets = weiAmount/1e15;
178     senderTickets.endTicket = lastTicketNumber.add(numberOfTickets);
179     lastTicketNumber = lastTicketNumber.add(numberOfTickets);
180     ticketsMap[msg.sender].push(senderTickets);
181 
182     contributions[msg.sender] = contributions[msg.sender].add(weiAmount);
183 
184     newContribution(msg.sender, weiAmount);
185 
186     if(lastIndex > 9) {
187       executeLottery();
188     }
189   }
190 }