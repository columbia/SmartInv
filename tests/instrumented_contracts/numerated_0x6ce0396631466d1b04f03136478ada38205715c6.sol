1 pragma solidity ^0.4.20;
2 library SafeMath {
3   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4     uint256 c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8 
9   function div(uint256 a, uint256 b) internal pure returns (uint256) {
10     // assert(b > 0); // Solidity automatically throws when dividing by 0 uint256 c = a / b;
11     uint256 c = a / b;
12     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
13     return c;
14   }
15 
16   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function add(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 }
27 
28 /**
29  * @title Ownable
30  * @dev The Ownable contract has an owner address, and provides basic authorization control
31  * functions, this simplifies the implementation of "user permissions".
32  */
33 contract Ownable {
34   address public owner;
35 
36 
37   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39 
40   /**
41    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
42    * account.
43    */
44   constructor () public {
45     owner = msg.sender;
46   }
47 
48 
49   /**
50    * @dev Throws if called by any account other than the owner.
51    */
52   modifier onlyOwner() {
53     require(msg.sender == owner);
54     _;
55   }
56 
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) onlyOwner public {
63     require(newOwner != address(0));
64     emit OwnershipTransferred(owner, newOwner);
65     owner = newOwner;
66   }
67 }
68 
69 contract Jackpot is Ownable {
70 
71   string public constant name = "Jackpot";
72 
73   event newWinner(address winner, uint256 ticketNumber);
74   // event newRandomNumber_bytes(bytes);
75   // event newRandomNumber_uint(uint);
76   event newContribution(address contributor, uint value);
77 
78   using SafeMath for uint256;
79   address[] public players = new address[](10);
80   uint256 public lastTicketNumber = 0;
81   uint8 public lastIndex = 0;
82 
83   uint256 public numberOfPlayers = 10;
84 
85   struct tickets {
86     uint256 startTicket;
87     uint256 endTicket;
88   }
89 
90   mapping (address => tickets[]) public ticketsMap;
91   mapping (address => uint256) public contributions;
92 
93   function setNumberOfPlayers(uint256 _noOfPlayers) public onlyOwner {
94     numberOfPlayers = _noOfPlayers;
95   }
96 
97 
98   function executeLottery() public { 
99       
100         if (lastIndex >= numberOfPlayers) {
101           uint randomNumber = address(this).balance.mul(16807) % 2147483647;
102           randomNumber = randomNumber % lastTicketNumber;
103           address winner;
104           bool hasWon;
105           for (uint8 i = 0; i < lastIndex; i++) {
106             address player = players[i];
107             for (uint j = 0; j < ticketsMap[player].length; j++) {
108               uint256 start = ticketsMap[player][j].startTicket;
109               uint256 end = ticketsMap[player][j].endTicket;
110               if (randomNumber >= start && randomNumber < end) {
111                 winner = player;
112                 hasWon = true;
113                 break;
114               }
115             }
116             if(hasWon) break;
117           }
118           require(winner!=address(0) && hasWon);
119 
120           for (uint8 k = 0; k < lastIndex; k++) {
121             delete ticketsMap[players[k]];
122             delete contributions[players[k]];
123           }
124 
125           lastIndex = 0;
126           lastTicketNumber = 0;
127 
128           uint balance = address(this).balance;
129         //   if (!owner.send(balance/10)) throw;
130           owner.transfer(balance/10);
131           //Both SafeMath.div and / throws on error
132         //   if (!winner.send(balance - balance/10)) throw;
133         winner.transfer(balance.sub(balance/10));
134         emit  newWinner(winner, randomNumber);
135           
136         }
137       
138   }
139 
140   function getPlayers() public constant returns (address[], uint256[]) {
141     address[] memory addrs = new address[](lastIndex);
142     uint256[] memory _contributions = new uint256[](lastIndex);
143     for (uint i = 0; i < lastIndex; i++) {
144       addrs[i] = players[i];
145       _contributions[i] = contributions[players[i]];
146     }
147     return (addrs, _contributions);
148   }
149 
150   function getTickets(address _addr) public constant returns (uint256[] _start, uint256[] _end) {
151     tickets[] storage tks = ticketsMap[_addr];
152     uint length = tks.length;
153     uint256[] memory startTickets = new uint256[](length);
154     uint256[] memory endTickets = new uint256[](length);
155     for (uint i = 0; i < length; i++) {
156       startTickets[i] = tks[i].startTicket;
157       endTickets[i] = tks[i].endTicket;
158     }
159     return (startTickets, endTickets);
160   }
161 
162   function () public payable {
163     uint256 weiAmount = msg.value;
164     require(weiAmount >= 1e16);
165 
166     bool isSenderAdded = false;
167     for (uint8 i = 0; i < lastIndex; i++) {
168       if (players[i] == msg.sender) {
169         isSenderAdded = true;
170         break;
171       }
172     }
173     if (!isSenderAdded) {
174       players[lastIndex] = msg.sender;
175       lastIndex++;
176     }
177 
178     tickets memory senderTickets;
179     senderTickets.startTicket = lastTicketNumber;
180     uint256 numberOfTickets = weiAmount/1e15;
181     senderTickets.endTicket = lastTicketNumber.add(numberOfTickets);
182     lastTicketNumber = lastTicketNumber.add(numberOfTickets);
183     ticketsMap[msg.sender].push(senderTickets);
184 
185     contributions[msg.sender] = contributions[msg.sender].add(weiAmount);
186 
187     emit newContribution(msg.sender, weiAmount);
188 
189     if(lastIndex >= numberOfPlayers) {
190       executeLottery();
191     }
192   }
193 }