1 pragma solidity ^ 0.4 .18;
2 
3 contract Etherumble {
4 
5     struct PlayerBets {
6         address addPlayer;
7         uint amount;
8     }
9 
10     PlayerBets[] users;
11     
12     address[] players = new address[](20);
13     uint[] bets = new uint[](20);
14 
15     uint nbUsers = 0;
16     uint totalBets = 0;
17     uint fees = 0;
18     uint endBlock = 0;
19 
20     address owner;
21     
22     address lastWinner;
23     uint lastWinnerTicket=0;
24     uint totalGames = 0;
25     
26     modifier isOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     modifier hasValue() {
32         require(msg.value >= 10000000000000000 && nbUsers < 19); //0.01 ether min
33         _;
34     }
35 
36     modifier onlyIf(bool _condition) {
37         require(_condition);
38         _;
39     }
40 
41     function Etherumble() public {
42         owner = msg.sender;
43     }
44     
45     function getActivePlayers() public constant returns(uint) {
46         return nbUsers;
47     }
48     
49     function getPlayerAddress(uint index) public constant returns(address) {
50         return players[index];
51     }
52     
53     function getPlayerBet(uint index) public constant returns(uint) {
54         return bets[index];
55     }
56     function getEndBlock() public constant returns(uint) {
57         return endBlock;
58     }
59     function getLastWinner() public constant returns(address) {
60         return lastWinner;
61     }
62     function getLastWinnerTicket() public constant returns(uint) {
63         return lastWinnerTicket;
64     }
65     function getTotalGames() public constant returns(uint) {
66         return totalGames;
67     }
68     
69 
70     function() public payable hasValue {
71         checkinter();//first check if it's a good block for ending a game. this way there is no new user after the winner block hash is calculated
72         players[nbUsers] = msg.sender;
73         bets[nbUsers] = msg.value;
74         
75         users.push(PlayerBets(msg.sender, msg.value));
76         nbUsers++;
77         totalBets += msg.value;
78         if (nbUsers == 2) { //at the 2nd player it start counting blocks...
79             endBlock = block.number + 15;
80         }
81     }
82 
83     function endLottery() internal {
84         uint sum = 0;
85         uint winningNumber = uint(block.blockhash(block.number - 1)) % totalBets;
86 
87         for (uint i = 0; i < nbUsers; i++) {
88             sum += users[i].amount;
89 
90             if (sum >= winningNumber) {
91                 // destroy this contract and send the balance to users[i]
92                 withrawWin(users[i].addPlayer,winningNumber);
93                 return;
94             }
95         }
96     }
97 
98     function withrawWin(address winner,uint winticket) internal {
99         uint tempTot = totalBets;
100         lastWinnerTicket = winticket;
101         totalGames++;
102         
103         //reset all values
104         nbUsers = 0;
105         totalBets = 0;
106         endBlock = 0;
107         delete users;
108         
109         fees += tempTot * 5 / 100;
110         winner.transfer(tempTot * 95 / 100);
111         lastWinner = winner;
112     }
113     
114     function withrawFee() public isOwner {
115         owner.transfer(fees);
116         fees = 0;
117     }
118     function destroykill() public isOwner {
119         selfdestruct(owner);
120     }
121 
122     function checkinter() internal{ //this can be called by anyone if the timmer freez
123         //check block time
124         if (endBlock <= block.number && endBlock != 0) {
125             endLottery();
126         }
127     }
128     
129     function callback() public isOwner{ //this can be called by anyone if the timmer freez
130         //check block time
131         if (endBlock <= block.number && endBlock != 0) {
132             endLottery();
133         }
134     }
135 }