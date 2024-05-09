1 pragma solidity ^0.4.6;
2 
3 //created by http://about.me/kh.bakhtiari
4 contract Lottery {
5     bool enabled = true;
6     address public owner;
7     
8     uint private ROUND_PER_BLOCK = 20;
9     uint private TICKET_PRICE = 1 finney;
10     uint private MAX_PENDING_PARTICIPANTS = 50;
11     
12     uint public targetBlock;
13     uint public ticketPrice;
14     uint8 public minParticipants;
15     uint8 public maxParticipants;
16     
17     uint public totalRoundsPassed;
18     uint public totalTicketsSold;
19     
20     address[] public participants;
21     address[] public pendingParticipants;
22     
23     event RoundEnded(address winner, uint amount);
24     
25     function Lottery() public payable {
26         increaseBlockTarget();
27         ticketPrice = 1 finney;
28         minParticipants = 2;
29         maxParticipants = 20;
30         owner = msg.sender;
31     }
32     
33     function () payable {
34         if (!enabled)
35             throw;
36             
37         if (msg.value < ticketPrice)
38             throw;
39             
40         for (uint i = 0; i < msg.value / ticketPrice; i++) {
41             if (participants.length == maxParticipants) {
42                 if (pendingParticipants.length >= MAX_PENDING_PARTICIPANTS)
43                     if (msg.sender.send(msg.value - (i * TICKET_PRICE))) 
44                         return;
45                     else
46                         throw;
47 
48                 pendingParticipants.push(msg.sender);
49             } else {
50                 participants.push(msg.sender);
51             }
52             totalTicketsSold++;
53         }
54 
55         if (msg.value % ticketPrice > 0)
56             if (!msg.sender.send(msg.value % ticketPrice))
57                 throw;
58     }
59 
60     function conclude () public returns (bool) {
61         if (block.number < targetBlock)
62             return false;
63 
64         totalRoundsPassed++;
65         
66         increaseBlockTarget();
67         
68         if (!findAndPayTheWinner())
69             return false;
70 
71         delete participants;
72         
73         uint m = pendingParticipants.length > maxParticipants ? maxParticipants : pendingParticipants.length;
74         
75         for (uint i = 0; i < m; i++)
76             participants.push(pendingParticipants[i]);
77         
78         if (m == pendingParticipants.length) {
79             delete pendingParticipants;
80         } else {
81             for (i = m; i < pendingParticipants.length; i++) {
82                 pendingParticipants[i-m] == pendingParticipants[i];
83                 delete pendingParticipants[i];
84             }
85             pendingParticipants.length -= m;
86         }
87 
88         return true;
89     }
90 
91     function findAndPayTheWinner() private returns (bool) {
92         uint winnerIndex = uint(block.blockhash(block.number - 1)) % participants.length;
93         
94         address winner = participants[winnerIndex];
95         
96         uint prize = (ticketPrice * participants.length) * 98 / 100;
97         
98         bool success =  winner.send(prize);
99         
100         if (success)
101             RoundEnded(winner, prize);
102         
103         return success;
104     }
105 
106     function increaseBlockTarget() private {
107         if (block.number < targetBlock)
108             return;
109 
110         targetBlock = block.number + ROUND_PER_BLOCK;
111     }
112     
113     function currentParticipants() public constant returns (uint) {
114         return participants.length;
115     }
116     
117     function currentPendingParticipants() public constant returns (uint) {
118         return pendingParticipants.length;
119     }
120     
121     function maxPendingParticipants() public constant returns (uint) {
122         return MAX_PENDING_PARTICIPANTS;
123     }
124     
125     function kill() public {
126         enabled = false;
127     }
128 }