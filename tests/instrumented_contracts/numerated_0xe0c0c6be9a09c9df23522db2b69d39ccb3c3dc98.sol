1 pragma solidity >=0.5.0;
2 
3 contract CrazyBet {
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
16     struct HistoryItem {
17         address winnerAddress;
18         uint256 winnerBet;
19         uint256 winnerAmount;
20     }
21 
22     mapping(address => Bet) public bets;
23     address payable[] players;
24     HistoryItem[] public history;
25 
26     modifier onlyOwner() {
27         require(msg.sender == owner);
28         _;
29     }
30 
31     modifier isNotCalculatingResultsPhase() {
32         require(calculatingResultPhase == false);
33         _;
34     }
35 
36     modifier startCalculatingResultsPhase() {
37         require(calculatingResultPhase == false);
38         calculatingResultPhase = true;
39         _;
40         calculatingResultPhase = false;
41     }
42 
43     function appendToList(address payable _addr) private {
44         players.push(_addr);
45     }
46 
47     constructor() public {
48         gameId = 1;
49         totalBank = 0;
50         players.length = 0;
51         owner = msg.sender;
52     }
53 
54     function () external payable {
55         require(msg.value > 0);
56         if (bets[msg.sender].gameId == 0) {
57             bets[msg.sender] = Bet(
58                 {gameId: gameId, totalBet: msg.value}
59             );
60             appendToList(msg.sender);
61         } else {
62             if (bets[msg.sender].gameId == gameId) {
63                 bets[msg.sender].totalBet += msg.value;
64             } else {
65                 bets[msg.sender].gameId = gameId;
66                 bets[msg.sender].totalBet = msg.value;
67                 appendToList(msg.sender);
68             }
69         }
70         totalBank += msg.value;
71         if (random() == 0 && players.length > 2) {
72             payWinnerAndStartNewGame();
73         }
74     }
75 
76     function getGameId() external view returns (uint256) {
77         return gameId;
78     }
79 
80     function getOwner() external view returns (address) {
81         return owner;
82     }
83 
84     function getPlayersNum() external view returns (uint256) {
85         return players.length;
86     }
87 
88     function getPlayerById(uint256 _id) external view returns (address) {
89         require(_id >= 0 && _id < players.length);
90         return players[_id];
91     }
92 
93     function getPlayerBet(address _addr) external view returns (uint256) {
94         if (bets[_addr].gameId != gameId) {
95             return 0x0;
96         }
97         return bets[_addr].totalBet;
98     }
99 
100     function getTotalBank() external view returns (uint256) {
101         return totalBank;
102     }
103 
104     function getLeader() public view returns (address payable, uint256) {
105         address payable winnerAddress = address(0x0);
106         for (uint256 index = 0; index < players.length; index++) {
107             address payable currentAddress = players[index];
108             uint256 playerGameId = bets[currentAddress].gameId;
109             uint256 currentBet = bets[currentAddress].totalBet;
110             if (playerGameId == gameId && currentBet > bets[winnerAddress].totalBet) {
111                 winnerAddress = currentAddress;
112             }
113         }
114         return (winnerAddress, bets[winnerAddress].totalBet);
115     }
116 
117     function random() private view returns (uint8) {
118         return uint8(uint256(keccak256(abi.encodePacked(msg.sender, block.coinbase, block.timestamp, block.difficulty, totalBank))) % 10);
119     }
120 
121     function payWinnerAndStartNewGame() private startCalculatingResultsPhase returns (bool result) {
122         address payable winnerAddress;
123         uint256 winnerBet;
124         
125         (winnerAddress, winnerBet) = getLeader();
126         
127         if (winnerAddress != address(0x0)) {
128             uint256 totalWin = totalBank - winnerBet;
129             uint256 winningFee = totalWin / 21;
130             totalWin -= winningFee;
131             owner.transfer(winningFee);
132             winnerAddress.transfer(totalWin + winnerBet);
133             history.push(HistoryItem({
134                 winnerAddress: winnerAddress,
135                 winnerAmount: totalWin + winnerBet,
136                 winnerBet: winnerBet}));
137             result = true;
138         } else {
139             result = false;
140         }
141 
142         gameId += 1;
143         players.length = 0;
144         totalBank = 0;
145     }
146 
147 }