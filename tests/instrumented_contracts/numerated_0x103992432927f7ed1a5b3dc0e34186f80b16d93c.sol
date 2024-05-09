1 pragma solidity ^0.4.13;
2 
3 contract Tiles {
4 
5     uint public constant NUM_TILES = 256;
6     uint constant SIDE_LENGTH = 16;
7     uint private constant STARTING_GAME_NUMBER = 1;
8     uint public DEFAULT_GAME_COST = 5000000000000000;
9 
10     address private owner;
11 
12     uint public currentGameNumber;
13     uint public currentGameBalance;
14     uint public numTilesClaimed;
15     Tile[16][16] public tiles;
16     bool public gameStopped;
17     uint public gameEarnings;
18     bool public willChangeCost;
19     uint public currentGameCost;
20     uint public nextGameCost;
21 
22     mapping (address => uint) public pendingWithdrawals;
23     mapping (uint => address) public gameToWinner;
24 
25     struct Tile {
26         uint gameClaimed;
27         address claimedBy;
28     }
29 
30     event GameWon(uint indexed gameNumber, address indexed winner);
31     event TileClaimed(uint indexed gameNumber, uint indexed xCoord, uint indexed yCoord, address claimedBy);
32     event WinningsClaimed(address indexed claimedBy, uint indexed amountClaimed);
33     event FailedToClaim(address indexed claimedBy, uint indexed amountToClaim);
34     event PrintWinningInfo(bytes32 hash, uint xCoord, uint yCoord);
35 
36     modifier onlyOwner() {
37         require(msg.sender == owner);
38         _;
39     }
40 
41     modifier gameRunning() {
42         require(!gameStopped);
43         _;
44     }
45 
46     modifier gameNotRunning() {
47         require(gameStopped == true);
48         _;
49     }
50 
51     function Tiles() payable {
52         owner = msg.sender;
53         currentGameNumber = STARTING_GAME_NUMBER;
54         currentGameCost = DEFAULT_GAME_COST;
55         numTilesClaimed = 0;
56         gameStopped = false;
57         gameEarnings = 0;
58         willChangeCost = false;
59         nextGameCost = DEFAULT_GAME_COST;
60     }
61 
62     function cancelContract() onlyOwner returns (bool) {
63         gameStopped = true;
64         refundTiles();
65         refundWinnings();
66     }
67 
68     function getRightCoordinate(byte input) returns(uint) {
69         byte val = input & byte(15);
70         return uint(val);
71     }
72 
73     function getLeftCoordinate(byte input) returns(uint) {
74         byte val = input >> 4;
75         return uint(val);
76     }
77 
78     function determineWinner() private {
79         bytes32 winningHash = block.blockhash(block.number - 1);
80         byte winningPair = winningHash[31];
81         uint256 winningX = getRightCoordinate(winningPair);
82         uint256 winningY = getLeftCoordinate(winningPair);
83         address winner = tiles[winningX][winningY].claimedBy;
84         PrintWinningInfo(winningHash, winningX, winningY);
85         GameWon(currentGameNumber, winner);
86         resetGame(winner);
87     }
88 
89     function claimTile(uint xCoord, uint yCoord, uint gameNumber) gameRunning payable {
90         if (gameNumber != currentGameNumber || tiles[xCoord][yCoord].gameClaimed == currentGameNumber) {
91             revert();
92         }
93         require(msg.value == currentGameCost);
94 
95         currentGameBalance += msg.value;
96         tiles[xCoord][yCoord] = Tile(currentGameNumber, msg.sender);
97         TileClaimed(currentGameNumber, xCoord, yCoord, msg.sender);
98         numTilesClaimed += 1;
99         if (numTilesClaimed == NUM_TILES) {
100             determineWinner();
101         }
102     }
103 
104     function resetGame(address winner) private {
105         uint winningAmount = uint(currentGameBalance) * uint(9) / uint(10);
106         uint remainder = currentGameBalance - winningAmount;
107         currentGameBalance = 0;
108 
109         gameToWinner[currentGameNumber] = winner;
110         currentGameNumber++;
111         numTilesClaimed = 0;
112 
113         pendingWithdrawals[winner] += winningAmount;
114         gameEarnings += remainder;
115 
116         if (willChangeCost) {
117             currentGameCost = nextGameCost;
118             willChangeCost = false;
119         }
120     }
121 
122     function refundTiles() private {
123         Tile memory currTile;
124         for (uint i = 0; i < SIDE_LENGTH; i++) {
125             for (uint j = 0; j < SIDE_LENGTH; j++) {
126                 currTile = tiles[i][j];
127                 if (currTile.gameClaimed == currentGameNumber) {
128                     if (currTile.claimedBy.send(currentGameCost)) {
129                         tiles[i][j] = Tile(0, 0x0);
130                     }
131                 }
132             }
133         }
134     }
135 
136     function refundWinnings() private {
137         address currAddress;
138         uint currAmount;
139         for (uint i = STARTING_GAME_NUMBER; i < currentGameNumber; i++) {
140             currAddress = gameToWinner[i];
141             currAmount = pendingWithdrawals[currAddress];
142             if (currAmount != 0) {
143                 if (currAddress.send(currAmount)) {
144                     pendingWithdrawals[currAddress] = 0;
145                 }
146             }
147         }
148     }
149 
150     function claimWinnings() {
151         if (pendingWithdrawals[msg.sender] != 0) {
152             if (msg.sender.send(pendingWithdrawals[msg.sender])) {
153                 WinningsClaimed(msg.sender, pendingWithdrawals[msg.sender]);
154                 pendingWithdrawals[msg.sender] = 0;
155             } else {
156                 FailedToClaim(msg.sender, pendingWithdrawals[msg.sender]);
157             }
158         }
159     }
160 
161     function updateGameCost(uint newGameCost) onlyOwner returns (bool) {
162         if (newGameCost > 0) {
163             nextGameCost = newGameCost;
164             willChangeCost = true;
165         }
166     }
167 
168     function claimOwnersEarnings() onlyOwner {
169         if (gameEarnings != 0) {
170             if (owner.send(gameEarnings)) {
171                 gameEarnings = 0;
172             }
173         }
174     }
175 }