1 pragma solidity >=0.5.0;
2 
3 contract MakeYourBet {
4 
5     address payable owner;
6     uint256 gameId;
7     uint256 totalBank;
8 
9     bool calculatingResultPhase;
10 
11     struct Bet {
12         uint256 gameId;
13         uint256 totalBet;
14     }
15 
16     mapping(address => Bet) public bets;
17     address payable[] players;
18 
19     modifier onlyOwner() {
20         require(msg.sender == owner);
21         _;
22     }
23 
24     modifier isNotCalculatingResultsPhase() {
25         require(calculatingResultPhase == false);
26         _;
27     }
28 
29     modifier startCalculatingResultsPhase() {
30         require(calculatingResultPhase == false);
31         calculatingResultPhase = true;
32         _;
33         calculatingResultPhase = false;
34     }
35 
36     function appendToList(address payable _addr) private {
37         players.push(_addr);
38     }
39 
40     constructor() public {
41         gameId = 1;
42         totalBank = 0;
43         players.length = 0;
44         owner = msg.sender;
45     }
46 
47     function () external payable {
48         require(msg.value > 0);
49         if (bets[msg.sender].gameId == 0) {
50             bets[msg.sender] = Bet(
51                 {gameId: gameId, totalBet: msg.value}
52             );
53             appendToList(msg.sender);
54         } else {
55             if (bets[msg.sender].gameId == gameId) {
56                 bets[msg.sender].totalBet += msg.value;
57             } else {
58                 bets[msg.sender].gameId = gameId;
59                 bets[msg.sender].totalBet = msg.value;
60                 appendToList(msg.sender);
61             }
62         }
63         totalBank += msg.value;
64     }
65 
66     function getGameId() external view returns (uint256) {
67         return gameId;
68     }
69 
70     function getOwner() external view returns (address) {
71         return owner;
72     }
73 
74     function getPlayersNum() external view returns (uint256) {
75         return players.length;
76     }
77 
78     function getPlayerById(uint256 _id) external view returns (address) {
79         require(_id >= 0 && _id < players.length);
80         return players[_id];
81     }
82 
83     function getPlayerBet(address _addr) external view returns (uint256) {
84         if (bets[_addr].gameId != gameId) {
85             return 0x0;
86         }
87         return bets[_addr].totalBet;
88     }
89 
90     function getTotalBank() external view returns (uint256) {
91         return totalBank;
92     }
93 
94     function getLeader() public view returns (address payable, uint256) {
95         address payable winnerAddress = address(0x0);
96         for (uint256 index = 0; index < players.length; index++) {
97             address payable currentAddress = players[index];
98             uint256 playerGameId = bets[currentAddress].gameId;
99             uint256 currentBet = bets[currentAddress].totalBet;
100             if (playerGameId == gameId && currentBet > bets[winnerAddress].totalBet) {
101                 winnerAddress = currentAddress;
102             }
103         }
104         return (winnerAddress, bets[winnerAddress].totalBet);
105     }
106 
107     function payWinnerAndStartNewGame() external payable onlyOwner startCalculatingResultsPhase returns (bool result) {
108         address payable winnerAddress;
109         uint256 winnerBet;
110         
111         (winnerAddress, winnerBet) = getLeader();
112         
113         if (winnerAddress != address(0x0)) {
114             uint256 totalWin = totalBank - winnerBet;
115             uint256 winningFee = totalWin / 15;
116             totalWin -= winningFee;
117             owner.transfer(winningFee);
118             winnerAddress.transfer(totalWin + winnerBet);
119             result = true;
120         } else {
121             result = false;
122         }
123 
124         gameId += 1;
125         players.length = 0;
126         totalBank = 0;
127     }
128 
129 }