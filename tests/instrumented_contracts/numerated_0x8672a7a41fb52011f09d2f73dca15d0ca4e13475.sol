1 //visit our site at:
2 //https://xandar.herokuapp.com/
3 pragma solidity ^0.4.21;
4 
5 contract Zandar {
6     uint8 public constant MAINTENANCE_FEE_PERCENT = 5;
7     uint8 public constant REFUND_PERCENT = 80;
8     
9     address admin;
10     uint public admin_profit = 0;
11     uint public currentActiveGameID = 0;
12 
13     struct Game {
14         uint ticketPrice;
15         
16         uint bettingPhaseStart; //unix time
17         uint bettingPhaseEnd;   //unix time
18         uint claimingPhaseStart;//unix time
19         uint claimingPhaseEnd;  //unix time
20     
21         mapping(address => uint8) tickets;
22         uint8 numTickets;
23         uint8 numPrizeClaimed;
24         uint8 winningMultiplier;
25     
26         uint balance; //balance of each game
27     }
28     
29     Game[] public games;
30     
31     modifier adminOnly() {
32         require(msg.sender == admin);
33         _;
34     }
35     
36     function Zandar() public{
37         admin = msg.sender;
38     }
39     
40     //fallback function for handling unexpected payment
41     //if any ether is sent to the address, credit the admin balance
42     function() external payable{
43         admin_profit += msg.value;
44     }
45     
46     function createGame(uint _ticketPrice, uint _bettingStartUnixTime,
47         uint _bettingPhaseDays, uint _waitingPhaseDays,
48         uint _claimingPhaseDays, uint8 _winningMultiplier) adminOnly external{
49         
50         uint bettingPhaseEnd = _bettingStartUnixTime + _bettingPhaseDays * 1 days;
51         uint claimingPhaseStart = bettingPhaseEnd + _waitingPhaseDays * 1 days;
52         uint claimingPhaseEnd = claimingPhaseStart + _claimingPhaseDays * 1 days;
53 
54         Game memory g = Game({
55             ticketPrice: _ticketPrice,
56             bettingPhaseStart: _bettingStartUnixTime,
57             bettingPhaseEnd: bettingPhaseEnd,
58             claimingPhaseStart: claimingPhaseStart,
59             claimingPhaseEnd: claimingPhaseEnd,
60             numTickets:0,
61             numPrizeClaimed:0,
62             balance:0,
63             winningMultiplier: _winningMultiplier
64         });
65 
66         games.push(g);
67     }
68 
69     function setCurrentActiveGameID(uint _id) adminOnly external{
70         currentActiveGameID = _id;
71     }
72     
73     function getNumGames() external view returns (uint){
74         return games.length;
75     }
76 
77     function getNumTicketsPurchased(uint _gameID, address _address) external view returns (uint8){
78         return games[_gameID].tickets[_address];
79     } 
80     
81     function getContractBalance() external view returns (uint){
82         return address(this).balance;
83     }
84 
85     function purchaseTicket(uint _gameID) external payable {
86         require(msg.value >= games[_gameID].ticketPrice);
87         require(now >= games[_gameID].bettingPhaseStart &&
88             now < games[_gameID].bettingPhaseEnd);
89         games[_gameID].tickets[msg.sender] += 1;
90         games[_gameID].numTickets += 1;
91         uint admin_fee = games[_gameID].ticketPrice * MAINTENANCE_FEE_PERCENT/100;
92         admin_profit += admin_fee;
93         games[_gameID].balance += msg.value - admin_fee;
94     }        
95 
96     function claimProfit(uint _gameID) external {
97         require(now >= games[_gameID].claimingPhaseStart &&
98             now < games[_gameID].claimingPhaseEnd);
99         require(games[_gameID].tickets[msg.sender]>0);
100         require(games[_gameID].numPrizeClaimed <
101             games[_gameID].numTickets/games[_gameID].winningMultiplier);
102         
103         games[_gameID].numPrizeClaimed += 1;
104         games[_gameID].tickets[msg.sender] -= 1;
105         uint reward = games[_gameID].ticketPrice *
106             games[_gameID].winningMultiplier * (100-MAINTENANCE_FEE_PERCENT) / 100;
107         msg.sender.transfer(reward);
108         games[_gameID].balance -= reward;
109     }
110     
111     // get back the BET before claimingPhase
112     function getRefund(uint _gameID) external {
113         require(now < games[_gameID].claimingPhaseStart - 1 days);
114         require(games[_gameID].tickets[msg.sender]>0);
115         games[_gameID].tickets[msg.sender] -= 1;
116         games[_gameID].numTickets -= 1;
117         uint refund = games[_gameID].ticketPrice * REFUND_PERCENT / 100;
118         uint admin_fee = games[_gameID].ticketPrice *
119             (100 - REFUND_PERCENT - MAINTENANCE_FEE_PERCENT) / 100;
120         admin_profit += admin_fee;
121         games[_gameID].balance -= games[_gameID].ticketPrice *
122             (100 - MAINTENANCE_FEE_PERCENT) / 100;
123         msg.sender.transfer(refund);
124     }
125 
126     // call by admin to get maintenance fee
127     function getAdminFee() adminOnly external {
128         require(admin_profit > 0);
129         msg.sender.transfer(admin_profit);
130         admin_profit = 0;
131     }
132     
133     // admin can claim unclaimed fund after the claiming phase, if any
134     function getUnclaimedEtherIfAny(uint _gameID) adminOnly external {
135         require(now >= games[_gameID].claimingPhaseEnd);
136         require(games[_gameID].balance > 0);
137         msg.sender.transfer(games[_gameID].balance);
138         games[_gameID].balance = 0;
139     }
140 
141      //transfer ownership of the contract
142  	function transferOwnership(address _newAdmin) adminOnly external {
143     	admin = _newAdmin;
144  	}
145 }